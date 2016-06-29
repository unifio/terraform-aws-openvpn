# Input Variables

## Resource tags
variable "stack_item_label" {
  type        = "string"
  description = "Short form identifier for this stack. This value is used to create the 'Name' resource tag for resources created by this stack item, and also serves as a unique key for re-use."
}

variable "stack_item_fullname" {
  type        = "string"
  description = "Long form descriptive name for this stack item. This value is used to create the 'application' resource tag for resources created by this stack item."
}

## VPC parameters
variable "vpc_id" {
  type        = "string"
  description = "ID of the target VPC."
}

variable "region" {
  type        = "string"
  description = "AWS region to be utilized."
}

variable "subnets" {
  type        = "string"
  description = "List of VPC subnets to associate with the cluster."
}

## OpenVPN parameters
variable "ami_custom" {
  type        = "string"
  description = "Custom AMI to utilize"
  default     = ""
}

variable "ami_region_lookup" {
  # Not meant to be overwritten
  type = "map"

  default = {
    us-east-1      = "ami-d66995bb"
    ap-northeast-1 = "ami-4803ec29"
    custom         = ""
  }
}

variable "instance_type" {
  type        = "string"
  description = "EC2 instance type to associate with the launch configuration."
  default     = "t2.small"
}

variable "key_name" {
  type        = "string"
  description = "SSH key pair to associate with the launch configuration."
}

### TODO: expects 4 subnets to map as internal network routes.
### Fix the magic # problem
variable "route_cidrs" {
  type        = "string"
  description = "Routes for the VPN server to expose"
}

variable "s3_bucket" {
  type        = "string"
  description = "The S3 bucket where certificate and configuration are stored."
}

### Do not include the trailing slash
variable "s3_bucket_prefix" {
  type        = "string"
  description = "The S3 bucket prefix. Certificates and configuration will be sourced from the root if not configured."
  default     = ""
}

variable "vpn_whitelist" {
  type        = "string"
  description = "Limit VPN access to the designated list of CIDRs"
  default     = "0.0.0.0/0"
}

variable "ssh_whitelist" {
  type        = "string"
  description = "Limit SSH access to the designated list of CIDRs"
  default     = "0.0.0.0/0"
}
