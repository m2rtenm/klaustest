# Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    "Name" = "${var.prefix}-internet_gateway"
  }
}

# Elastic IP-s
resource "aws_eip" "nat_eip_1" {
  domain = "vpc"
  depends_on = [ aws_internet_gateway.igw ]

  tags = {
    "Name" = "${var.prefix}-nat_eip_1"
  }
}

resource "aws_eip" "nat_eip_2" {
  domain = "vpc"
  depends_on = [ aws_internet_gateway.igw ]

  tags = {
    "Name" = "${var.prefix}-nat_eip_2"
  }
}

# NAT gateways
resource "aws_nat_gateway" "ngw_1" {
  allocation_id = aws_eip.nat_eip_1.id
  subnet_id = aws_subnet.public_subnet_1.id
  depends_on = [ aws_internet_gateway.igw ]

  tags = {
    "Name" = "${var.prefix}-nat_gateway_1"
  }
}

resource "aws_nat_gateway" "ngw_2" {
  allocation_id = aws_eip.nat_eip_2.id
  subnet_id = aws_subnet.public_subnet_2.id
  depends_on = [ aws_internet_gateway.igw ]

  tags = {
    "Name" = "${var.prefix}-nat_gateway_2"
  }
}

# Route tables and associations
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    "Name" = "${var.prefix}-public_route_to_internet"
  }
}

resource "aws_route_table" "private_route_table_1" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    "Name" = "${var.prefix}-private_route_1"
  }
}

resource "aws_route_table" "private_route_table_2" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    "Name" = "${var.prefix}-private_route_2"
  }
}

resource "aws_route" "public_route" {
  route_table_id = aws_route_table.public_route_table.id
  gateway_id = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "private_route_1" {
  route_table_id = aws_route_table.private_route_table_1.id
  gateway_id = aws_nat_gateway.ngw_1.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "private_route_2" {
  route_table_id = aws_route_table.private_route_table_2.id
  gateway_id = aws_nat_gateway.ngw_2.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_route_assoc_1" {
  subnet_id = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_route_assoc_2" {
  subnet_id = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_route_assoc_1" {
  subnet_id = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table_1.id
}

resource "aws_route_table_association" "private_route_assoc_2" {
  subnet_id = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table_2.id
}

resource "aws_route_table_association" "bastion_assoc" {
  subnet_id = aws_subnet.bastion_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}