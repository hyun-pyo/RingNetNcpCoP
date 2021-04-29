#####################################################################
# Variables
#####################################################################

variable "kube_config"{
  description = "kubeconfig path"
  default = "~/.kube/config"
  type = string
}

variable "monitor_namespace"{
  description = "monitor_namespace"
  default = "monitor"
  type = string
}


