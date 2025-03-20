data "aws_eks_cluster" "eks_cluster" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = var.eks_cluster_name
}

module "configmap" {
  source = "0-configmap.tf"
}

module "secret" {
  source     = "1-secret.tf"
  depends_on = [module.configmap]
}

module "deployment" {
  source     = "2-deployment.tf"
  depends_on = [module.secret]
  vars = {
    db_url = var.db_url
  }
}
