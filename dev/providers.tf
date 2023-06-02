terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.20.0"
    }
  }

  backend "local" {
    path = ".state/terraform.tfstate"
  }
}

provider "kubernetes" {
    config_path    = "~/.kube/config"
    config_context = "minikube"
}