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

## Instance parameters
variable "ami_custom" {
  type        = string
  description = "Custom AMI to utilize"
  default     = ""
}

variable "ami_region_lookup" {
  # Not meant to be overwritten
  type = map(string)

  default = {
    us-east-1      = "ami-6934c804"
    ap-northeast-1 = "ami-b036d9d1"
    us-west-2      = "ami-530fa433"
    custom         = ""
  }
}

variable "cidr_whitelist" {
  default = "0.0.0.0/0"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type to associate with the launch configuration."
  default     = "m3.medium"
}

variable "key_name" {
  type        = string
  description = "SSH key pair to associate with the launch configuration."
}

variable "region" {
  type        = string
  description = "AWS region to be utilized."
}

variable "subnet" {
  type        = string
  description = "VPC subnet to associate with the instance"
}

variable "vpc_id" {
  type        = string
  description = "ID of the target VPC."
}

## Generator parameters

### Order matters. Do not remove clients here, use the 'revoked_clients' list instead.
variable "active_clients" {
  type        = string
  description = "Comma delimited list of active clients"
  default     = "client"
}

variable "cert_key_name" {
  type    = string
  default = "EasyRSA"
}

variable "cert_key_size" {
  type    = string
  default = 4096
}

variable "force_cert_regen" {
  type        = string
  description = "Force all certificates to be regenerated."
  default     = false
}

variable "key_city" {
  type        = string
  description = "City to be associated with the certificate."
  default     = "San Francisco"
}

variable "key_country" {
  type        = string
  description = "Country to be associated with the certificate."
  default     = "US"
}

variable "key_email" {
  type        = string
  description = "Email address to be associated with the certificate."
  default     = "cert-admin@example.com"
}

variable "key_org" {
  type        = string
  description = "Organization to be associated with the certificate."
  default     = "Fort-Funston"
}

variable "key_ou" {
  type        = string
  description = "Organizational unit to be associated with the certificate."
  default     = "MyOrgUnit"
}

variable "key_province" {
  type        = string
  description = "Province to be associated with the certificate."
  default     = "CA"
}

variable "openvpn_host" {
  type        = string
  description = "Publicly accessible hostname of the OpenVPN server(s)."
  default     = "localhost"
}

# Comma delimited list
variable "revoked_clients" {
  type        = string
  description = "Comma delimited list of existing clients who are to have their privileges revoked."
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

variable "s3_dir_override" {
  type    = string
  default = ""
}

variable "s3_push_dryrun" {
  type        = string
  description = "Dry-run push of certificates into s3 location"
  default     = false
}

