resource "kubernetes_config_map" "mercado_pago_config" {
  metadata {
    name = "mercado-pago-config"
  }
  data = {
    MERCADO_PAGO_URL             = "https://api.mercadopago.com/"
    MERCADO_PAGO_URL_NOTIFICACAO = var.mercado_pago_url_notificacao
  }
}
