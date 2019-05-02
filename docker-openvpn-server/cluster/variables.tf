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

variable "ami_custom" {
  type        = string
  description = "Custom AMI to utilize"
  default     = ""
}

variable "ami_custom_user_data" {
  type        = string
  description = "Custom AMI instance user data to start the instance with"
  default     = ""
}

variable "key_name" {
  type        = string
  description = "SSH key pair to associate with the launch configuration."
}

variable "root_vol_size" {
  type        = string
  description = "Size of the AMI root volume in GB"
}

variable "vpc_id" {
  type        = string
  description = "ID of the target VPC."
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type to associate with the launch configuration."
  default     = "t2.small"
}

variable "subnets" {
  type        = string
  description = "List of VPC subnets to associate with the cluster."
}

variable "instance_based_naming_enabled" {
  type        = string
  description = "Flag to enable instance-id based name tagging."
  default     = ""
}

variable "instance_tags" {
  type = map(string)

  default = {
    Name        = "openvpn_server"
    application = "OpenVPN Server"
    managed_by  = "terraform"
  }
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

variable "ssh_whitelist" {
  type        = string
  description = "Limit SSH access to the designated list of CIDRs"
  default     = "0.0.0.0/0"
}

variable "enable_lb" {
  type        = string
  description = "String boolean of whether or not to expect a load balancer to be attached to this ASG cluster"
  default     = "false"
}

variable "vpn_whitelist" {
  type        = string
  description = "Limit VPN access to the designated list of CIDRs"
  default     = "0.0.0.0/0"
}

### Do not include the trailing slash
variable "s3_bucket_prefix" {
  type        = string
  description = "The S3 bucket prefix. Certificates and configuration will be sourced from the root if not configured."
  default     = ""
}

variable "s3_bucket" {
  type        = string
  description = "The S3 bucket where certificate and configuration are stored."
}

variable "region" {
  type        = string
  description = "AWS region to be utilized."
}

variable "assign_eip" {
  type        = string
  description = "Boolean to determine if Elastic IP should be assigned to host"
  default     = "false"
}

### TODO: expects 4 subnets to map as internal network routes.
### Fix the magic # problem
variable "route_cidrs" {
  type        = string
  description = "Routes for the VPN server to expose"
  default     = "10.8.0.0/24"
}

variable "s3_bucket_prefix_for_service" {
  type        = string
  description = "Actual s3 path (without the bucket prefix) that the openvpn service will use, if different from IAM path permissions"
  default     = ""
}

variable "additional_routes" {
  type        = string
  description = "Additional routes to add to Openvpn Config"
  default     = ""
}

variable "vpc_dns_ip" {
  type        = string
  description = "Optional: DNS IP address for the VPC."
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

variable "lb_target_group_arns" {
  type        = list(string)
  description = "target group arns to associate with the NLB, if enable_lb == true"
  default     = []
}

variable "hc_grace_period" {
  type        = string
  description = "Health check grace period for ASG"
  default     = "300"
}

