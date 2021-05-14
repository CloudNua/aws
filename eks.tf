module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = "1.17"
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.private_subnets

  tags = {
    Terraform   = "true"
    Environment = "dev"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.xlarge"
      asg_desired_capacity          = 2
      asg_max_size                  = 4
      asg_min_size                  = 1
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
      workers_additional_policies   = [aws_iam_policy.worker_policy.arn]
    }
  ]
}

resource "aws_iam_policy" "worker_policy" {
  name        = "worker-policy"
  description = "Worker policy for the ALB Ingress"

  policy = file("${path.module}/iam-policy/iam-policy.json")
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

output "env-dynamic-url" {
  value = module.eks.cluster_endpoint
}