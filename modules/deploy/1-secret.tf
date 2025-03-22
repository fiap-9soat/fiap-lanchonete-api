resource "kubernetes_secret" "mysql_secret" {
  metadata {
    name      = "mysql-secret"
    namespace = "default"
  }
  data = {
    MYSQL_USER          = var.db_username
    MYSQL_PASSWORD      = var.db_password
    MYSQL_ROOT_PASSWORD = var.db_password
  }
  type = "Opaque"
}

resource "kubernetes_secret" "mercado_pago_secret" {
  metadata {
    name      = "mercado-pago-secret"
    namespace = "default"
  }
  data = {
    MERCADO_PAGO_API_KEY  = var.mercado_pago_api_key
    MERCADO_PAGO_ID_LOJA  = var.mercado_pago_id_loja
    MERCADO_PAGO_ID_CONTA = var.mercado_pago_id_conta
  }
  type = "Opaque"
}

resource "kubernetes_secret" "aws_secret" {
  metadata {
    name      = "aws-secret"
    namespace = "default"
  }
  data = {
    AWS_ACCESS_KEY = var.aws_access_key
    AWS_SECRET_KEY = var.aws_secret_key
    AWS_TOKEN_KEY  = var.aws_token_key
  }
}
