data "gitlab_group" "gitops-demo-apps" {
  full_path = "cloudnua-public/gitops/apps"
}

data "gitlab_projects" "cluster-management-search" {
  # Returns a list of matching projects. limit to 1 result matching "cluster-management"
  group_id            = data.gitlab_group.gitops-demo-apps.id
  simple              = true
  search              = "cluster-management"
  per_page            = 1
  max_queryable_pages = 1
}

data "gitlab_project" "gitops-demo-apps" {
  id = "cloudnua-public/gitops/apps/ml-forecast"
}

resource "gitlab_project_cluster" "aws_cluster" {
  project               = data.gitlab_project.gitops-demo-apps.id
  name                  = module.eks.cluster_id
  domain                = "eks-gitops.cloudnua.com"
  environment_scope     = "eks/*"
  kubernetes_api_url    = module.eks.cluster_endpoint
  kubernetes_token      = data.kubernetes_secret.gitlab-admin-token.data.token
  kubernetes_ca_cert    = trimspace(base64decode(module.eks.cluster_certificate_authority_data))
  management_project_id = data.gitlab_projects.cluster-management-search.projects.0.id
}