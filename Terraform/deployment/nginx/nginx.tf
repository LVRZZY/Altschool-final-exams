resource "time_sleep" "time" {

    depends_on = [
        data.aws_eks_cluster.demo
    ]

    create_duration = "20s"
}

resource "kubernetes_namespace" "nginx-namespace" {

  depends_on = [time_sleep.time]
  metadata {
    name = "nginx-ingress"
  }
}

resource "helm_release" "ingress-nginx" {
  depends_on = [kubernetes_namespace.nginx-namespace, time_sleep.time]
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.5.2"

  namespace        = kubernetes_namespace.nginx-namespace.id
  create_namespace = true

  values = [
    file("nginx.yaml")
  ]

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

 set {
    name  = "podSecurityPolicy.enabled"
    value = true
  }

  set {
    name  = "server.persistentVolume.enabled"
    value = false
  }


  set {
    name = "server\\.resources"
    value = yamlencode({
      limits = {
        cpu    = "200m"
        memory = "50Mi"
      }
      requests = {
        cpu    = "100m"
        memory = "30Mi"
      }
    })
  }

}



# load-balancer host name
/* output "load_balancer_hostname" {
  value = kubernetes_ingress.sock-shop.status.0.load_balancer.0.ingress.0.hostname
} */






