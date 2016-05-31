# openvpn_server - Variables

variable "ami" {
  description = "Artifact AMI"
}

variable "stack_item_fullname" {}

variable "stack_item_label" {}

#
# 0 - if instance is a standalone instance outside a VPC
# 1 - if instance is in a vpc
#
variable "in_vpc" {
  default = 0
}

variable "vpc_id" {
  default = ""
}

variable "security_groups" {
  default = ""
}

# Which subnet the vpn servers will run in.
variable "subnets" {
  default = ""
}

# TODO: expects 4 subnets to map as internal network routes.
# Fix the magic # problem
variable "route_cidrs" {
  default = ""
}

variable "key_name" {}

#
# m3.medium - if instance is a standalone instance outside a VPC
# t2.small - if instance is in a vpc
#
variable "instance_type" {}

variable "region" {}

variable "release" {
  default = "0.0.2"
}

variable "role" {
  default = "vpn_server"
}

# Do not include the trailing slash
variable "s3_path" {}

variable "s3_bucket" {}

variable "sns_topic_arn" {}

# From AWS limits, max rules for an SG is ~50
variable "cidr_whitelist" {
  default = "0.0.0.0/0"
}
