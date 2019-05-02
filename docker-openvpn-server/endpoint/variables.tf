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

variable "subnets" {
  type        = string
  description = "List of VPC subnets to associate with the cluster."
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

variable "vpc_id" {
  type        = string
  description = "ID of the target VPC."
}

