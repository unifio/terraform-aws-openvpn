provider "aws" {
  region = var.region
}

module "cluster" {
  source = "./cluster"

  stack_item_label              = var.stack_item_label
  stack_item_fullname           = var.stack_item_fullname
  ami_custom                    = var.ami_custom
  ami_custom_user_data          = var.ami_custom_user_data
  key_name                      = var.key_name
  vpc_id                        = var.vpc_id
  instance_type                 = var.instance_type
  subnets                       = var.subnets
  instance_based_naming_enabled = var.instance_based_naming_enabled
  instance_tags                 = var.instance_tags
  enabled_metrics               = var.enabled_metrics
  ssh_whitelist                 = var.ssh_whitelist
  enable_lb                     = var.enable_lb
  vpn_whitelist                 = var.vpn_whitelist
  region                        = var.region
  s3_bucket                     = var.s3_bucket
  s3_bucket_prefix              = var.s3_bucket_prefix
  s3_bucket_prefix_for_service  = var.s3_bucket_prefix_for_service
  additional_routes             = var.additional_routes
  assign_eip                    = var.assign_eip
  route_cidrs                   = var.route_cidrs
  additional_routes             = var.additional_routes
  vpc_dns_ip                    = var.vpc_dns_ip
  openvpn_docker_image          = var.openvpn_docker_image
  openvpn_docker_tag            = var.openvpn_docker_tag
  associate_public_ip_address   = var.associate_public_ip_address
  lb_target_group_arns          = [module.endpoint.lb_target_group_arns]
}

module "endpoint" {
  source = "./endpoint"

  stack_item_label      = var.stack_item_label
  stack_item_fullname   = var.stack_item_fullname
  subnets               = var.subnets
  lb_subnets            = var.lb_subnets
  lb_logs_enabled       = var.lb_logs_enabled
  lb_logs_bucket        = var.lb_logs_bucket
  lb_logs_bucket_prefix = var.lb_logs_bucket_prefix
  vpc_id                = var.vpc_id
}

