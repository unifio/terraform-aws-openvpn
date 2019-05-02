# OpenVPN Server Example

## Configures provider
provider "aws" {
  region = var.region
}

## Creates OpenVPN deployment
module "openvpn_server" {
  source = "../../certs"

  ## Resource tags
  stack_item_label    = var.stack_item_label
  stack_item_fullname = var.stack_item_fullname

  ## VPC parameters
  vpc_id  = var.vpc_id
  region  = var.region
  subnets = var.subnets

  ## OpenVPN parameters
  instance_type    = var.instance_type
  key_name         = var.key_name
  route_cidrs      = var.route_cidrs
  s3_bucket        = var.s3_bucket
  s3_bucket_prefix = var.s3_bucket_prefix

  assign_eip = "true"
  eip_tag    = "openvpn-instance"
  vpc_dns_ip = "1.1.1.1"
}

