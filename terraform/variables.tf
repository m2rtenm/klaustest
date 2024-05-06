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

variable "az_list" {
  type = list(string)
  default = [ "eu-north-1a", "eu-north-1b", "eu-north-1c" ]
}

variable "public_subnet_1_cidr" {
  type = string
  default = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  type = string
  default = "10.0.2.0/24"
}

variable "private_subnet_1_cidr" {
  type = string
  default = "10.0.3.0/24"
}

variable "private_subnet_2_cidr" {
  type = string
  default = "10.0.4.0/24"
}

variable "db_subnet_1_cidr" {
  type = string
  default = "10.0.5.0/24"
}

variable "db_subnet_2_cidr" {
  type = string
  default = "10.0.6.0/24"
}

variable "bastion_subnet_cidr" {
  type = string
  default = "10.0.7.0/24"
}

variable "eks_cluster_name" {
  type = string
  default = "EKS-Klaus"
}

variable "bastion_ami" {
  type = string
  default = "ami-011e54f70c1c91e17"
  description = "Ubuntu 22.04 LTS AMI"
}

variable "db_username" {
  type = string
  default = "awsklaus"
}

variable "db_password" {}