terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.0"
    }

    kubernetes = {
        version = ">= 2.0.0"
        source = "hashicorp/kubernetes"
    }

    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}


data "aws_eks_cluster" "demo" {
  name = "demo"
}
data "aws_eks_cluster_auth" "demo_auth" {
  name = "demo_auth"
}


provider "aws" {
  region     = "us-east-1"
}

provider "helm" {
    kubernetes {
       config_path = "~/.kube/config"
    }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "kubectl" {
   load_config_file = false
   alias = "aws"
   host                   = data.aws_eks_cluster.demo.endpoint
   cluster_ca_certificate = base64decode(data.aws_eks_cluster.demo.certificate_authority[0].data)
   token                  = data.aws_eks_cluster_auth.demo_auth.token
   config_path = "~/.kube/config"
}
