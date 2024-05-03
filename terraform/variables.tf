variable "region" {
    type = string
    description = "Default AWS region"
    default = "eu-north-1"
}

variable "prefix" {
  type = string
  description = "Prefix for all resources"
  default = "aws-klaus"
}

variable "cidr_block" {
  type = string
  default = "10.0.0.0/16"
}