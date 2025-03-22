data "aws_db_instance" "fiap_lanchonete_db" {
  db_instance_identifier = "fiap-lanchonete-db"
}

resource "kubernetes_deployment" "fiap_lanchonete_deployment" {
  metadata {
    name = "fiap-lanchonete"
  }
  wait_for_rollout = true

  depends_on = [kubernetes_config_map.mercado_pago_config, kubernetes_secret.mysql_secret, kubernetes_secret.mercado_pago_secret]

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "fiap-lanchonete"
      }
    }
    template {
      metadata {
        labels = {
          app = "fiap-lanchonete"
        }
      }
      spec {
        container {
          name  = "fiap-lanchonete"
          image = "lamarcke/fiap-lanchonete:latest"
          port {
            container_port = 8080
          }
          env_from {
            config_map_ref {
              name = kubernetes_config_map.mercado_pago_config.metadata[0].name
            }
          }
          env_from {
            secret_ref {
              name = kubernetes_secret.mysql_secret.metadata[0].name
            }
          }
          env_from {
            secret_ref {
              name = kubernetes_secret.mercado_pago_secret.metadata[0].name
            }
          }

          env_from {
            secret_ref {
              name = kubernetes_secret.aws_secret.metadata[0].name
            }
          }
          env {
            name  = "DB_URL"
            value = data.aws_db_instance.fiap_lanchonete_db.endpoint
          }
        }
      }
    }
  }
}
