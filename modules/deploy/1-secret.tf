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