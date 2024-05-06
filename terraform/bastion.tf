resource "aws_security_group" "bastion_sg" {
  name = "${var.prefix}-bastion_sg"
  description = "Bastion instance security group"
  vpc_id = aws_vpc.app_vpc.id

    # Allow SSH access
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ] # this should be restricted to specific IP-s or ranges
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_instance" "bastion_ec2" {
  ami = var.bastion_ami
  instance_type = "t3.micro"
  subnet_id = aws_subnet.bastion_subnet.id
  vpc_security_group_ids = [ aws_security_group.bastion_sg.id ]

  user_data = <<-EOF
            #!/bin/bash
            sudo apt update
            sudo apt  install awscli -y
            curl -LO "https://dl.k8s.io/release/v1.23.6/bin/linux/amd64/kubectl"
            sudo chmod +x kubectl
            sudo mv kubectl /usr/local/bin/
            EOF

    tags = {
      "Name" = "${var.prefix}-bastion_ec2_host"
    }
}