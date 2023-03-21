terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"  
      version = ">= 2.0.0"
    }
  }
}

data "aws_eks_cluster" "my-ekscluster" {
  name = "my-ekscluster"
}
data "aws_eks_cluster_auth" "my-ekscluster_auth" {
  name = "my-ekscluster_auth"
}
provider "kubernetes" {
  host                   = data.aws_eks_cluster.my-ekscluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.my-ekscluster.certificate_authority[
0].data)
  version          = "2.16.1"
  config_path = "~/.kube/config"
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", "my-ekscluster"]
    command     = "aws"
  }
}

resource "kubernetes_namespace" "kube-namespace" {
  metadata {
    name = "voting-app"
  }
}
