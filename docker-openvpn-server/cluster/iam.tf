# inputs
locals {
  in_iam_stack_item_label = var.stack_item_label
  in_iam_region           = var.region
  in_iam_s3_bucket        = var.s3_bucket
  in_iam_s3_bucket_prefix = var.s3_bucket_prefix
}

# local vars for the file
locals {
  local_iam_name           = "${local.in_iam_stack_item_label}-${local.in_iam_region}"
  local_iam_s3_full_path   = "${replace(local.in_iam_s3_bucket, "/(/)+$/", "")}/${replace(local.in_iam_s3_bucket_prefix, "/^(/)+|(/)+$/", "")}"
  local_iam_s3_bucket_path = replace(local.in_iam_s3_bucket, "/(/)+$/", "")
}

## Creates IAM role & policies
resource "aws_iam_role" "role" {
  name = local.local_iam_name
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
  role = aws_iam_role.role.id

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
        "arn:aws:s3:::${local.local_iam_s3_full_path}",
        "arn:aws:s3:::${local.local_iam_s3_full_path}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:List*"
      ],
      "Resource": [
        "arn:aws:s3:::${local.local_iam_s3_bucket_path}"
      ]
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "tags" {
name = "tags"
role = aws_iam_role.role.id

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
  name = local.local_iam_name
  role = aws_iam_role.role.name
}

## outputs
locals {
  out_iam_instance_profile_id = aws_iam_instance_profile.profile.id
}

