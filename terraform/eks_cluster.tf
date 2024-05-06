# EKS cluster security
resource "aws_security_group" "eks_cluster_sg" {
  name = "${var.prefix}-eks_cluster_sg"
  description = "EKS cluster communication with worker nodes"
  vpc_id = aws_vpc.app_vpc.id

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${var.prefix}-eks_cluster_sg"
  }
}

resource "aws_security_group_rule" "eks_cluster_ingress_node" {
  description = "Allow pods communicate with the cluster API"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  security_group_id = aws_security_group.eks_cluster_sg.id
  source_security_group_id = aws_security_group.eks_cluster_nodes_sg.id
  type = "ingress"
}

resource "aws_security_group_rule" "eks_cluster_ingress_bastion" {
  description = "Allow bastion communicate with the cluster API"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  security_group_id = aws_security_group.eks_cluster_sg.id
  source_security_group_id = aws_security_group.bastion_sg.id
  type = "ingress"
}

resource "aws_eks_cluster" "eks_cluster" {
  name = var.eks_cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [ 
        aws_subnet.public_subnet_1.id, 
        aws_subnet.public_subnet_2.id, 
        aws_subnet.private_subnet_1.id, 
        aws_subnet.private_subnet_2.id 
        ]
  }

  depends_on = [ 
    aws_iam_role_policy_attachment.eks_cluster_policy_attachment, 
    aws_iam_role_policy_attachment.eks_cluster_service_policy_attachment 
    ]

    tags = {
      "Name" = "${var.prefix}-eks_cluster"
    }
}