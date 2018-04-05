# OpenVPN Certificate Generator

provider "template" {
  version = "~> 0.1"
}

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

resource "aws_iam_role_policy" "s3_certs_rw" {
  name = "s3_certs_rw"
  role = "${aws_iam_role.role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:Get*",
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::${replace(var.s3_bucket,"/(/)+$/","")}",
        "arn:aws:s3:::${replace(var.s3_bucket,"/(/)+$/","")}/*"
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
          "ec2:DescribeTags",
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
  name = "${var.stack_item_label}-${var.region}"
  role = "${aws_iam_role.role.name}"
}

## Creates security group rules
resource "aws_security_group" "sg_cert_gen" {
  name_prefix = "${var.stack_item_label}-${var.region}-"
  description = "${var.stack_item_fullname} security group"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name        = "${var.stack_item_label}"
    application = "${var.stack_item_fullname}"
    managed_by  = "terraform"
  }
}

resource "aws_security_group_rule" "allow_all_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.sg_cert_gen.id}"
}

resource "aws_security_group_rule" "allow_ssh_in" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${split(",",var.cidr_whitelist)}"]
  security_group_id = "${aws_security_group.sg_cert_gen.id}"
}

## Creates user instance data
data "template_file" "user_data" {
  template = "${file("${path.module}/templates/user_data.tpl")}"

  vars {
    active_clients   = "${var.active_clients}"
    cert_key_name    = "${var.cert_key_name}"
    cert_key_size    = "${var.cert_key_size}"
    force_cert_regen = "${var.force_cert_regen}"
    hostname         = "${var.stack_item_label}"
    key_city         = "${var.key_city}"
    key_country      = "${var.key_country}"
    key_email        = "${var.key_email}"
    key_org          = "${var.key_org}"
    key_ou           = "${var.key_ou}"
    key_province     = "${var.key_province}"
    openvpn_host     = "${var.openvpn_host}"
    region           = "${var.region}"
    revoked_clients  = "${var.revoked_clients}"
    s3_bucket        = "${var.s3_bucket}"
    s3_dir_override  = "${var.s3_bucket_prefix}"
    s3_push_dryrun   = "${var.s3_push_dryrun}"
  }
}

## Creates instance
resource "aws_instance" "generate_certs" {
  ami                         = "${coalesce(lookup(var.ami_region_lookup, var.region), var.ami_custom)}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.sg_cert_gen.id}"]
  subnet_id                   = "${var.subnet}"
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.profile.id}"

  tags {
    Name        = "${var.stack_item_label}"
    application = "${var.stack_item_fullname}"
    managed_by  = "terraform"
  }

  user_data = "${data.template_file.user_data.rendered}"
}
