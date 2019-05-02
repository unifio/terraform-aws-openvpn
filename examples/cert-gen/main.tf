# OpenVPN Certificate Generator

## Configures AWS provider
provider "aws" {
  region = var.region
}

## Creates generator
module "cert_generator" {
  source = "../../generate-certs"

  # Resource labels
  stack_item_label    = var.stack_item_label
  stack_item_fullname = var.stack_item_fullname

  # Instance parameters
  ami_custom    = var.ami_custom
  instance_type = var.instance_type
  key_name      = var.key_name
  region        = var.region
  subnet        = element(split(",", var.subnets), 0)
  vpc_id        = var.vpc_id

  # Generator parameters
  active_clients   = var.active_clients
  cert_key_name    = var.cert_key_name
  cert_key_size    = var.cert_key_size
  force_cert_regen = var.force_cert_regen
  key_city         = var.key_city
  key_country      = var.key_country
  key_email        = var.key_email
  key_org          = var.key_org
  key_ou           = var.key_ou
  key_province     = var.key_province
  openvpn_host     = var.openvpn_host
  revoked_clients  = var.revoked_clients
  s3_bucket        = var.s3_bucket
  s3_bucket_prefix = var.s3_bucket_prefix
  s3_push_dryrun   = var.s3_push_dryrun
}

