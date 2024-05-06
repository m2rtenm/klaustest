resource "aws_security_group" "db_sg" {
  name = "${var.prefix}-db_sg"
  description = "Security group for DB"
  vpc_id = aws_vpc.app_vpc.id

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = [ aws_subnet.db_subnet_1.cidr_block, aws_subnet.db_subnet_2.cidr_block ]
    security_groups = [ aws_security_group.bastion_sg.id ]
  }

  tags = {
    "Name" = "${var.prefix}-db_sg"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name = "${var.prefix}-db_subnet_group"
  subnet_ids = [ aws_subnet.db_subnet_1.id, aws_subnet.db_subnet_2.id, aws_subnet.bastion_subnet.id ]

  tags = {
    "Name" = "${var.prefix}-db_subnet_group"
  }
}

resource "aws_db_instance" "app_db" {
  allocated_storage = 20
  db_name = "KlausDB"
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t3.micro"
  username = var.db_username
  password = var.db_password
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [ aws_security_group.db_sg.id ]
  multi_az = false
  availability_zone = var.az_list[0]

  tags = {
    "Name" = "${var.prefix}-db"
  }
}