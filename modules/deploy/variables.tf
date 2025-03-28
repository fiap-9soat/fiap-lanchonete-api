variable "db_username" {
  type        = string
  description = "Usuario do DB, deve ser o mesmo especificado na configuraçao do RDS"
  default     = "fiap"
}

variable "db_password" {
  type        = string
  description = "Senha do DB, deve ser o mesmo especificado na configuraçao do RDS"
  default     = "fiap-lanchonete"
}

variable "mercado_pago_api_key" {
  type        = string
  description = "API Key do MercadoPago"
  default     = "TEST-8402790990254628-112619-4290252fdac6fd07a3b8bb555578ff39-662144664"
}
variable "mercado_pago_id_loja" {
  sensitive   = true
  type        = string
  description = "ID da Loja associada a conta do MP"
  default     = "1B2D92F23"
}

variable "mercado_pago_id_conta" {
  sensitive   = true
  type        = number
  description = "ID da Conta do MP"
  default     = 662144664
}

variable "mercado_pago_url_notificacao" {
  type        = string
  description = "URL de notificação do Mercado Pago"
  default     = "https://www.yourserver.com/notifications"
}
