# openvpn_server

provider "aws" {
  region = "${var.region}"
}

/* ---------------------------- */
/* IAM Role & Instance Profile  */
/* ---------------------------- */

resource "aws_iam_role" "vpn_role" {
  name = "${var.region}-${var.stack_item_label}-vpn"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
         "Service": "ec2.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "s3_vpn" {
  name = "s3_vpn"
  role = "${aws_iam_role.vpn_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:Get*"
      ],
      "Resource": [
        "arn:aws:s3:::${var.s3_path}",
        "arn:aws:s3:::${var.s3_path}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:List*"
      ],
      "Resource": [
        "arn:aws:s3:::${var.s3_bucket}"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "tags" {
  name = "tags"
  role = "${aws_iam_role.vpn_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "ec2:CreateTags",
          "ec2:AssociateAddress",
          "ec2:DescribeAddresses",
          "ec2:DescribeInstances"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "vpn_profile" {
  name  = "${var.region}-${var.stack_item_label}-vpn"
  roles = ["${aws_iam_role.vpn_role.name}"]
}

/* ---------------------------- */
/* Security Group               */
/* ---------------------------- */
resource "aws_security_group_rule" "allow_all_out" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${module.asg.sg_id}"
}

resource "aws_security_group_rule" "allow_ssh_in_tcp" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["${split(",",var.cidr_whitelist)}"]

  security_group_id = "${module.asg.sg_id}"
}

resource "aws_security_group_rule" "allow_openvpn_in_tdp" {
  type        = "ingress"
  from_port   = 1194
  to_port     = 1194
  protocol    = "tcp"
  cidr_blocks = ["${split(",",var.cidr_whitelist)}"]

  security_group_id = "${module.asg.sg_id}"
}

resource "aws_security_group_rule" "allow_ping_request_icmp" {
  type        = "ingress"
  from_port   = 8
  to_port     = 0
  protocol    = "icmp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${module.asg.sg_id}"
}

resource "aws_security_group_rule" "allow_ping_reply_icmp" {
  type        = "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "icmp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${module.asg.sg_id}"
}

/* ---------------------------- */
/* User Data                    */
/* ---------------------------- */
resource "template_file" "user_data" {
  template = "${file("${path.module}/templates/user_data.tpl")}"

  vars {
    instance_number  = "${count.index}"
    hostname         = "${var.role}-${count.index}"
    region           = "${var.region}"
    stack_item_label = "${var.stack_item_label}"
    role             = "${var.role}"
    s3_path          = "${var.s3_path}"
    route_cidrs      = "${var.route_cidrs}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

module "asg" {
  source = "github.com/unifio/terraform-aws-asg?ref=v0.2.0//group"

  # Resource tags
  stack_item_label    = "${var.stack_item_label}-vpn-asg"
  stack_item_fullname = "${var.stack_item_fullname}-vpn"

  # VPC parameters
  vpc_id  = "${var.vpc_id}"
  subnets = "${var.subnets}"
  region  = "${var.region}"

  # LC parameters
  ami              = "${var.ami}"
  instance_type    = "${var.instance_type}"
  instance_profile = "${aws_iam_instance_profile.vpn_profile.id}"
  user_data        = "${template_file.user_data.rendered}"
  key_name         = "${var.key_name}"
  ebs_optimized    = false

  # ASG parameters
  max_size         = 2
  min_size         = 1
  hc_grace_period  = 300
  hc_check_type    = "EC2"
  min_elb_capacity = 1
  load_balancers   = "${aws_elb.elb.id}"
}

# Create a new load balancer
resource "aws_elb" "elb" {
  name            = "${var.stack_item_label}-vpn-elb"
  subnets         = ["${split(",",var.subnets)}"]
  internal        = false
  security_groups = ["${module.asg.sg_id}"]

  listener {
    instance_port     = 1194
    instance_protocol = "tcp"
    lb_port           = 1194
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:1194"
    interval            = 30
  }

  tags {
    Name        = "${var.stack_item_label}-vpn-elb"
    application = "${var.stack_item_fullname}-vpn"
    managed_by  = "terraform"
  }
}

# Create a Route53 record

