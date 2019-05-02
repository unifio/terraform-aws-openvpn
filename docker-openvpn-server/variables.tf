# Input Variables

## Resource tags
variable "stack_item_label" {
  type        = string
  description = "Short form identifier for this stack. This value is used to create the 'Name' resource tag for resources created by this stack item, and also serves as a unique key for re-use."
}

variable "stack_item_fullname" {
  type        = string
  description = "Long form descriptive name for this stack item. This value is used to create the 'application' resource tag for resources created by this stack item."
}

## VPC parameters
variable "vpc_id" {
  type        = string
  description = "ID of the target VPC."
}

variable "region" {
  type        = string
  description = "AWS region to be utilized."
}

variable "subnets" {
  type        = string
  description = "List of VPC subnets to associate with the cluster."
}

## OpenVPN parameters
variable "additional_routes" {
  type        = string
  description = "Additional routes to add to Openvpn Config"
  default     = ""
}

variable "ami_custom" {
  type        = string
  description = "Custom AMI to utilize"
  default     = ""
}

variable "ami_custom_user_data" {
  type        = string
  description = "Custom AMI user data to use"
  default     = ""
}

variable "instance_based_naming_enabled" {
  type        = string
  description = "Flag to enable instance-id based name tagging."
  default     = ""
}

variable "assign_eip" {
  type        = string
  description = "Boolean to determine if Elastic IP should be assigned to host"
  default     = "false"
}

variable "eip_tag" {
  type        = string
  description = "Tag used to lookup Elastic IP to assign"
  default     = ""
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type to associate with the launch configuration."
  default     = "t2.small"
}

variable "key_name" {
  type        = string
  description = "SSH key pair to associate with the launch configuration."
}

### TODO: expects 4 subnets to map as internal network routes.
### Fix the magic # problem
variable "route_cidrs" {
  type        = string
  description = "Routes for the VPN server to expose, comma delimited"
  default     = ""
}

variable "s3_bucket" {
  type        = string
  description = "The S3 bucket where certificate and configuration are stored."
}

### Do not include the trailing slash
variable "s3_bucket_prefix" {
  type        = string
  description = "The S3 bucket prefix. Certificates and configuration will be sourced from the root if not configured."
  default     = ""
}

variable "ssh_whitelist" {
  type        = string
  description = "Limit SSH access to the designated list of CIDRs"
  default     = "0.0.0.0/0"
}

variable "vpc_dns_ip" {
  type        = string
  description = "Optional: DNS IP address for the VPC."
  default     = ""
}

variable "vpn_whitelist" {
  type        = string
  description = "Limit VPN access to the designated list of CIDRs"
  default     = "0.0.0.0/0"
}

# New variables
variable "enable_lb" {
  type        = string
  description = "String boolean of whether or not to expect a load balancer to be attached to this ASG cluster"
  default     = "false"
}

variable "enabled_metrics" {
  type = list(string)

  default = [
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupMaxSize",
    "GroupMinSize",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]
}

variable "instance_tags" {
  type = map(string)

  default = {
    Name       = "openvpn_server"
    managed_by = "terraform"
  }
}

variable "s3_bucket_prefix_for_service" {
  type        = string
  description = "Actual s3 path (without the bucket prefix) that the openvpn service will use, if different from IAM path permissions"
  default     = ""
}

variable "openvpn_docker_image" {
  type        = string
  description = "Docker image for the openvpn container instance"
  default     = "unifio/openvpn"
}

variable "openvpn_docker_tag" {
  type        = string
  description = "Docker image for the openvpn container instance"
  default     = "latest"
}

variable "associate_public_ip_address" {
  type        = string
  description = "Flag for associating public IP addresses with instances managed by the auto scaling group."
  default     = ""
}

variable "lb_subnets" {
  type        = string
  description = "List of VPC subnets to associate with the lb. Defaults to the same one as the cluster if not set"
  default     = ""
}

variable "lb_logs_enabled" {
  type        = string
  description = "String boolean of whether or not to enable access logs for the lb"
  default     = "false"
}

variable "lb_logs_bucket" {
  type        = string
  description = "S3 bucket for the lb access logs"
  default     = ""
}

variable "lb_logs_bucket_prefix" {
  type        = string
  description = "S3 bucket prefix for the lb access logs"
  default     = ""
}

