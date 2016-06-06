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

###
### 0 - if instance is a standalone instance outside a VPC
### 1 - if instance is in a vpc
###
variable "in_vpc" {
  type        = "string"
  description = "Flag for associating the cluster with a VPC."
  default     = 1
}

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
variable "ami" {
  type        = "string"
  description = "Amazon Machine Image (AMI) to associate with the launch configuration."
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

variable "cidr_whitelist" {
  type        = "string"
  description = "Limit access to the designated list of CIDRs"
  default     = "0.0.0.0/0"
}
