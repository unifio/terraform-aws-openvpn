# OpenVPN Generate Certs

## Creates IAM Role & Instance Profile
# TODO: figure out how to de-dup
resource "aws_iam_role" "gen_certs_role" {
  name = "${var.stack_item_label}-${var.region}-gen-certs"
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

resource "aws_iam_role_policy" "s3_gen_certs" {
  name = "s3_gen_certs"
  role = "${aws_iam_role.gen_certs_role.id}"

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
        "arn:aws:s3:::${replace(var.s3_root_path,"/(\/)+$/","")}",
        "arn:aws:s3:::${replace(var.s3_root_path,"/(\/)+$/","")}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:List*"
      ],
      "Resource": [
        "arn:aws:s3:::${element(split("/", var.s3_root_path), 0)}"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "gen_certs_tags" {
  name = "gen-certs-tags"
  role = "${aws_iam_role.gen_certs_role.id}"

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
resource "aws_iam_instance_profile" "gen_certs_profile" {
  name  = "${var.stack_item_label}-${var.region}-gen-certs"
  roles = ["${aws_iam_role.gen_certs_role.name}"]
}

## Creates security group rules
resource "aws_security_group" "generate_certs_sg" {
  name        = "${var.stack_item_label}-${var.region}-gen-certs-sg"
  description = "${stack_item_fullname} security group"
}

resource "aws_security_group_rule" "allow_ssh_in_tcp" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${split(",",var.cidr_whitelist)}"]
  security_group_id = "${aws_security_group.generate_certs_sg.id}"
}

## Creates user instance data
resource "template_file" "user_data" {
  template = "${file("${path.module}/templates/user_data.tpl")}"

  vars {
    s3_region         = "${var.region}"
    s3_cert_root_path = "s3://${var.s3_root_path}"
    key_size          = "${var.cert_key_size}"
    s3_dir_override   = "${var.s3_dir_override}"
    key_city          = "${var.key_city}"
    key_org           = "${var.key_org}"
    key_email         = "${var.key_email}"
    key_ou            = "${var.key_ou}"
    cert_key_name     = "${var.cert_key_name}"
    key_country       = "${var.key_country}"
    key_province      = "${var.key_province}"
    active_clients    = "${var.active_clients}"
    revoked_clients   = "${var.revoked_clients}"
    openvpn_host      = "${var.openvpn_host}"
    force_cert_regen  = "${var.force_cert_regen}"
    s3_push_dryrun    = "${var.s3_push_dryrun}"
  }
}

## Creates instance
resource "aws_instance" "generate_certs" {
  count                       = 1
  ami                         = "${coalesce(lookup(var.ami_region_lookup, var.ami_region), var.ami_custom)}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  security_groups             = ["${aws_security_group.generate_certs_sg.name}"]
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.gen_certs_profile.id}"

  tags {
    Name        = "${var.stack_item_label}-generate-certs"
    application = "${var.stack_item_label}-generate-certs"
    managed_by  = "terraform"
  }

  user_data = "${template_file.user_data.rendered}"
}
