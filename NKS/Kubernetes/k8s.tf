provider "kubernetes" {
  config_path = var.kube_config
}

resource "kubernetes_namespace" "monitor" {
  metadata {
    name = "monitor"
  }
}
