provider "template" {
  version = ">= 2.1"
}

locals {
  user_data_vars = {
    additional_routes    = var.additional_routes
    assign_eip           = var.assign_eip
    hostname             = var.stack_item_label
    s3_bucket            = var.s3_bucket
    s3_bucket_prefix     = coalesce(var.s3_bucket_prefix_for_service, var.s3_bucket_prefix)
    stack_item_label     = var.stack_item_label
    region               = var.region
    route_cidrs          = var.route_cidrs
    vpc_dns_ip           = var.vpc_dns_ip
    openvpn_docker_image = var.openvpn_docker_image
    openvpn_docker_tag   = var.openvpn_docker_tag
  }
}

## Creates instance user data
data "template_file" "user_data" {
  template = file("${path.module}/templates/user_data.tpl")
  vars     = local.user_data_vars
}

## Creates auto scaling cluster
module "cluster" {
  source = "github.com/whistlelabs/terraform-aws-asg?ref=upgrade-0.12//group"

  # Resource tags
  stack_item_label    = var.stack_item_label
  stack_item_fullname = var.stack_item_fullname

  # VPC parameters
  vpc_id  = var.vpc_id
  subnets = split(",", var.subnets)

  # LC parameters
  ami                           = coalesce(var.ami_custom, data.aws_ami.cluster_ami.id)
  associate_public_ip_address   = var.associate_public_ip_address
  ebs_optimized                 = "false"
  enable_monitoring             = "true"
  instance_based_naming_enabled = var.instance_based_naming_enabled
  instance_profile              = aws_iam_instance_profile.profile.id
  instance_type                 = var.instance_type
  key_name                      = var.key_name
  root_vol_size                 = var.root_vol_size
  user_data = coalesce(
    var.ami_custom_user_data,
    data.template_file.user_data.rendered,
  )

  # ASG parameters
  enabled_metrics   = var.enabled_metrics
  hc_check_type     = var.enable_lb == "true" ? "ELB" : "EC2"
  instance_tags     = var.instance_tags
  max_size          = 2
  min_size          = 1
  hc_grace_period   = var.hc_grace_period
  target_group_arns = var.lb_target_group_arns
}

