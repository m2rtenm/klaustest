resource "aws_vpc" "app_vpc" {
  cidr_block = var.cidr_block

  enable_dns_hostnames = "true"
  enable_dns_support = "true"

  tags = {
    "Name" = "${var.prefix}-vpc"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id = aws_vpc.app_vpc.id
  cidr_block = var.public_subnet_1_cidr
  map_public_ip_on_launch = true
  availability_zone = var.az_list[0]

  tags = {
    "Name" = "${var.prefix}-public_subnet_1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id = aws_vpc.app_vpc.id
  cidr_block = var.public_subnet_2_cidr
  map_public_ip_on_launch = true
  availability_zone = var.az_list[1]

  tags = {
    "Name" = "${var.prefix}-public_subnet_2"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id = aws_vpc.app_vpc.id
  cidr_block = var.private_subnet_1_cidr
  map_public_ip_on_launch = false
  availability_zone = var.az_list[0]

  tags = {
    "Name" = "${var.prefix}-private_subnet_1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id = aws_vpc.app_vpc.id
  cidr_block = var.private_subnet_2_cidr
  map_public_ip_on_launch = false
  availability_zone = var.az_list[1]

  tags = {
    "Name" = "${var.prefix}-private_subnet_2"
  }
}

resource "aws_subnet" "db_subnet_1" {
  vpc_id = aws_vpc.app_vpc.id
  cidr_block = var.db_subnet_1_cidr
  availability_zone = var.az_list[0]

  tags = {
    "Name" = "${var.prefix}-db_subnet_1"
  }
}

resource "aws_subnet" "db_subnet_2" {
  vpc_id = aws_vpc.app_vpc.id
  cidr_block = var.db_subnet_2_cidr
  availability_zone = var.az_list[1]

  tags = {
    "Name" = "${var.prefix}-db_subnet_2"
  }
}

resource "aws_subnet" "bastion_subnet" {
  vpc_id = aws_vpc.app_vpc.id
  cidr_block = var.bastion_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone = var.az_list[0]

  tags = {
    "Name" = "${var.prefix}-bastion_subnet"
  }
}