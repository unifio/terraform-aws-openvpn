# OpenVPN Server

## Creates IAM role & policies
resource "aws_iam_role" "role" {
  name = "${var.stack_item_label}-${var.region}"
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

resource "aws_iam_role_policy" "s3_certs_ro" {
  name = "s3_certs_ro"
  role = "${aws_iam_role.role.id}"

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
        "arn:aws:s3:::${replace(var.s3_bucket,"/(/)+$/","")}/${replace(var.s3_bucket_prefix,"/^(/)+|(/)+$/","")}",
        "arn:aws:s3:::${replace(var.s3_bucket,"/(/)+$/","")}/${replace(var.s3_bucket_prefix,"/^(/)+|(/)+$/","")}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:List*"
      ],
      "Resource": [
        "arn:aws:s3:::${replace(var.s3_bucket,"/(/)+$/","")}"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "tags" {
  name = "tags"
  role = "${aws_iam_role.role.id}"

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

## Creates IAM instance profile
resource "aws_iam_instance_profile" "profile" {
  name  = "${var.stack_item_label}-${var.region}"
  roles = ["${aws_iam_role.role.name}"]
}

## Create elastic load balancer security group and rules
resource "aws_security_group" "sg_elb" {
  name_prefix = "${var.stack_item_label}-elb-"
  description = "${var.stack_item_fullname} load balancer security group"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name        = "${var.stack_item_label}-elb"
    application = "${var.stack_item_fullname}"
    managed_by  = "terraform"
  }
}

resource "aws_security_group_rule" "elb_allow_all_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.sg_elb.id}"
}

resource "aws_security_group_rule" "elb_allow_openvpn_tcp_in" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "tcp"
  cidr_blocks       = ["${split(",",var.vpn_whitelist)}"]
  security_group_id = "${aws_security_group.sg_elb.id}"
}

## Creates an elastic load balancer
resource "aws_elb" "elb" {
  name            = "${var.stack_item_label}"
  subnets         = ["${split(",",var.subnets)}"]
  internal        = false
  security_groups = ["${aws_security_group.sg_elb.id}"]

  listener {
    instance_port     = 1194
    instance_protocol = "tcp"
    lb_port           = 1194
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 4
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:1194"
    interval            = 30
  }

  tags {
    Name        = "${var.stack_item_label}"
    application = "${var.stack_item_fullname}"
    managed_by  = "terraform"
  }

  lifecycle {
    create_before_destroy = true
  }
}

## Creates security group rules
resource "aws_security_group_rule" "cluster_allow_all_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${module.cluster.sg_id}"
}

resource "aws_security_group_rule" "cluster_allow_openvpn_tcp_in" {
  type                     = "ingress"
  from_port                = 1194
  to_port                  = 1194
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.sg_elb.id}"
  security_group_id        = "${module.cluster.sg_id}"
}

resource "aws_security_group_rule" "cluster_allow_ssh_in" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${split(",",var.ssh_whitelist)}"]
  security_group_id = "${module.cluster.sg_id}"
}

resource "aws_security_group_rule" "cluster_allow_icmp_in" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = ["${split(",",var.ssh_whitelist)}"]
  security_group_id = "${module.cluster.sg_id}"
}

## Creates instance user data
data "template_file" "user_data" {
  template = "${file("${path.module}/templates/user_data.tpl")}"

  vars {
    hostname         = "${var.stack_item_label}"
    s3_bucket        = "${var.s3_bucket}"
    s3_bucket_prefix = "${var.s3_bucket_prefix}"
    route_cidrs      = "${var.route_cidrs}"
  }
}

## Creates auto scaling cluster
module "cluster" {
  source = "github.com/WhistleLabs/terraform-aws-asg?ref=v0.2.1//group"

  # Resource tags
  stack_item_label    = "${var.stack_item_label}"
  stack_item_fullname = "${var.stack_item_fullname}"

  # VPC parameters
  vpc_id  = "${var.vpc_id}"
  subnets = "${var.subnets}"
  region  = "${var.region}"

  # LC parameters
  ami              = "${coalesce(var.ami_custom, lookup(var.ami_region_lookup, var.region))}"
  instance_type    = "${var.instance_type}"
  instance_profile = "${aws_iam_instance_profile.profile.id}"
  user_data        = "${data.template_file.user_data.rendered}"
  key_name         = "${var.key_name}"
  ebs_optimized    = false

  # ASG parameters
  max_size         = 2
  min_size         = 1
  hc_grace_period  = 300
  min_elb_capacity = 1
  load_balancers   = "${aws_elb.elb.id}"
}
