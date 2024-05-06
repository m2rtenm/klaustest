# IAM role and attaching to policies
resource "aws_iam_role" "eks_cluster_nodes_role" {
  name = "IAM_Role_eks_cluster_nodes"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
            "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
    }
  ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "eks_cluster_node_policy_attachment" {
  role = aws_iam_role.eks_cluster_nodes_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cluster_cni_policy_attachment" {
  role = aws_iam_role.eks_cluster_nodes_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_cluster_ecr_policy_attachment" {
  role = aws_iam_role.eks_cluster_nodes_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}