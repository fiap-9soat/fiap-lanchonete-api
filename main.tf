data "aws_eks_cluster" "eks_cluster" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = var.eks_cluster_name
}

module "deployment" {
  source = "./modules/deploy"

  aws_region            = var.aws_region
  aws_access_key        = var.aws_access_key
  aws_secret_key        = var.aws_secret_key
  aws_token_key         = var.aws_token_key
  db_url                = var.db_url
  db_username           = var.db_username
  db_password           = var.db_password
  mercado_pago_api_key  = var.mercado_pago_api_key
  mercado_pago_id_loja  = var.mercado_pago_id_loja
  mercado_pago_id_conta = var.mercado_pago_id_conta
  eks_cluster_name      = var.eks_cluster_name
}
