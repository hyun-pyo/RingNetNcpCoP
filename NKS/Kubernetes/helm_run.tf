provider "helm" {
  kubernetes {
    config_path = var.kube_config
  }
}

# kube-state-metrics & Prometheus & Grafana 
resource "helm_release" "prometheus-grafana" {
  chart     = "stable/prometheus-operator"
  name      = "prometheus"
  namespace = "monitor"

  #Service type LoadBalancer 변경하여 외부로 노출 default 값은 ClusterIP
  set {
    name  = "grafana.service.type"
    value = "LoadBalancer"
  }

  #Grafana admin Password를 cisco 변경
  set {
    name  = "grafana.adminPassword"
    value = "cisco"
  }
}

# mainpage helm chart
resource "helm_release" "mainpage" {
  name       = "mainpage"
  repository = "https://hyun-pyo.github.io/helm-chart/stable/main-0.1.0/"
  chart      = "mainpage"
  version    = "0.1.0"
}