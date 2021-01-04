##############################################################################
# Kubernetes Deployment
##############################################################################

resource kubernetes_deployment deployment {
    metadata {
        name      = "${var.application_name}-deployment"
        namespace = var.namespace

        labels = {
            app = "${var.application_name}-deployment"
        }
    }

    spec {
        replicas = 3

        selector {
            match_labels = {
                app = "${var.application_name}-deployment"
            }
        }

        template {
            metadata {
                labels = {
                    app = "${var.application_name}-deployment"
                }
            }

            spec {
                container {
                    name  = var.application_name
                    image = var.image
                }
            }
        }
    }
}

##############################################################################


##############################################################################
# Kubernetes Service
##############################################################################

resource kubernetes_service service {
    metadata {
        name      = "${var.application_name}-svc"
        namespace = var.namespace

        labels = {
            app = "${var.application_name}-deployment"
        }
    }

    spec {
        port {
            protocol    = "TCP"
            port        = var.port
            target_port = var.target_port
        }

        selector = {
            app = "${var.application_name}-deployment"
        }
    }

    depends_on = [ kubernetes_deployment.deployment ]

}

##############################################################################


##############################################################################
# Kubernetes Ingress
##############################################################################

resource kubernetes_ingress ingress {
    metadata {
        name = "${var.application_name}-ingress"

        annotations = {
            "kubernetes.io/ingress.class" = "public-iks-k8s-nginx"
        }
    }

    spec {
        tls {
            hosts       = [
                "${var.subdomain}.${data.ibm_container_vpc_cluster.cluster.ingress_hostname}"
            ]
            secret_name = var.cert_name
        }

        rule {
            host = "${var.subdomain}.${data.ibm_container_vpc_cluster.cluster.ingress_hostname}"

            http {
                path {
                    path = var.path

                    backend {
                        service_name = "${var.application_name}-svc"
                        service_port = var.port
                    }
                }
            }
        }
    }

    depends_on = [ 
        kubernetes_service.service,
        ibm_certificate_manager_order.cert 
    ]
}

##############################################################################
