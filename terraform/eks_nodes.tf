resource "aws_security_group" "eks_cluster_nodes_sg" {
  name = "${var.prefix}-eks_cluster_nodes_sg"
  description = "Cluster worker nodes security group"
  vpc_id = aws_vpc.app_vpc.id

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    "Name" = "${var.prefix}-eks_cluster_nodes_sg"
  }
}

resource "aws_security_group_rule" "node_ingress_self" {
  description = "Allow nodes to communicate with others"
  from_port = 0
  to_port = 65535
  protocol = "-1"
  security_group_id = aws_security_group.eks_cluster_nodes_sg.id
  source_security_group_id = aws_security_group.eks_cluster_nodes_sg.id
  type = "ingress"
}

resource "aws_security_group_rule" "node_ingress_cluster" {
  description = "Allow communication from control plane"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  security_group_id = aws_security_group.eks_cluster_nodes_sg.id
  source_security_group_id = aws_security_group.eks_cluster_sg.id
  type = "ingress"
}

resource "aws_eks_node_group" "eks_cluster_nodes" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.prefix}-eks_cluster_node_group"
  node_role_arn = aws_iam_role.eks_cluster_nodes_role.arn

  subnet_ids = [ aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id ]
  
  capacity_type = "ON_DEMAND"
  instance_types = [ "t3.micro" ]

  scaling_config {
    desired_size = 2
    max_size = 6
    min_size = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [ 
    aws_iam_role_policy_attachment.eks_cluster_node_policy_attachment, 
    aws_iam_role_policy_attachment.eks_cluster_cni_policy_attachment, 
    aws_iam_role_policy_attachment.eks_cluster_ecr_policy_attachment 
    ]
  
  lifecycle {
    ignore_changes = [ scaling_config[0].desired_size ]
  }
  
  tags = {
    "Name" = "${var.prefix}-eks_cluster_node_group"
  }
}