module "eks" {
  source           = "terraform-aws-modules/eks/aws"
  version          = "14.0"
  cluster_name     = "gitops-streamlit-eks"
  cluster_version  = "1.17"
  subnets          = module.vpc.public_subnets
  write_kubeconfig = "false"
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
  vpc_id = module.vpc.vpc_id

  worker_groups = [
    {
      instance_type        = "t2.xlarge"
      asg_desired_capacity = 2
      asg_max_size         = 3
      asg_min_size         = 2
      root_volume_type     = "gp2" # Bug in default "gp3" https://github.com/terraform-aws-modules/terraform-aws-eks/issues/1205
      tags = [{
        key                 = "Terraform"
        value               = "true"
        propagate_at_launch = true
      }]
    }
  ]
}

output "env-dynamic-url" {
  value = module.eks.cluster_endpoint
}
