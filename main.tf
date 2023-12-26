provider "aws" {
  region = "us-west-2" # Set your desired AWS region
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  count = 2
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = element(["10.0.1.0/24", "10.0.2.0/24"], count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count = 2
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = element(["10.0.3.0/24", "10.0.4.0/24"], count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

resource "aws_eks_cluster" "Eks" {
  name     = "eks_cluster"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = concat(aws_subnet.public_subnet[*].id, aws_subnet.private_subnet[*].id)
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster]
}

resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

# Data source to get availability zones in the region
data "aws_availability_zones" "available" {}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.Eks.endpoint
}

output "eks_cluster_name" {
  value = aws_eks_cluster.Eks.name
}
