# openvpn-generate-certs - Variables

variable "ami_region" {
  type = "string"
}

variable "ami_region_lookup" {
  # Not meant to be overwritten
  type = "map"

  default = {
    us-east-1      = "ami-6934c804"
    ap-northeast-1 = "ami-b036d9d1"
    custom         = ""
  }
}

variable "ami_custom" {
  type        = "string"
  description = "Artifact AMI"
  default     = ""
}

variable "stack_item_fullname" {
  type = "string"
}

variable "stack_item_label" {}

variable "instance_type" {
  type    = "string"
  default = "m3.medium"
}

variable "region" {}

variable "key_name" {}

# Do not include the s3:// prefix
# Format should be something like <bucket name>/<folder path>
variable "s3_root_path" {
  type = "string"
}

# From AWS limits, max rules for an SG is ~50
variable "cidr_whitelist" {
  default = "0.0.0.0/0"
}

variable "cert_key_size" {
  default = 4096
}

variable "s3_dir_override" {
  type    = "string"
  default = ""
}

variable "key_city" {
  type    = "string"
  default = "San Francisco"
}

variable "key_org" {
  type    = "string"
  default = "Fort-Funston"
}

# This should probably stick around to help with notifications
variable "key_email" {
  type    = "string"
  default = "cert-admin@example.com"
}

variable "key_ou" {
  type    = "string"
  default = "MyOrgUnit"
}

variable "cert_key_name" {
  type    = "string"
  default = "EasyRSA"
}

variable "key_country" {
  type    = "string"
  default = "US"
}

variable "key_province" {
  type    = "string"
  default = "CA"
}

# Comma delimited list
variable "active_clients" {
  type    = "string"
  default = "client"
}

# Comma delimited list
variable "revoked_clients" {
  type    = "string"
  default = ""
}

variable "openvpn_host" {
  description = "Publicly accessible hostname to openvpn server(s)"
  type        = "string"
  default     = "localhost"
}

variable "force_cert_regen" {
  description = "Force all certificates to be regenerated"
  type        = "string"
  default     = "false"
}

variable "s3_push_dryrun" {
  description = "Dry-run push of certificates into s3 location"
  type        = "string"
  default     = "false"
}
