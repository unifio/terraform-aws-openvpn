# Inputs

## Resource tags
variable "stack_item_label" {
  type = string
}

variable "stack_item_fullname" {
  type = string
}

## VPC parameters
variable "vpc_id" {
  type = string
}

variable "region" {
  type = string
}

variable "subnets" {
  type = string
}

## OpenVPN parameters
variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "route_cidrs" {
  type = string
}

variable "s3_bucket" {
  type = string
}

variable "s3_bucket_prefix" {
  type = string
}

