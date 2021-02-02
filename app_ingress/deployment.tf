
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
        name      = "${var.application_name}-deployment-svc"
        namespace = var.namespace

        labels = {
            app = "${var.application_name}-deployment-svc"
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
# Get IAM Auth Token
##############################################################################

data ibm_iam_auth_token token {}

##############################################################################

##############################################################################
# Add Certificate to cluster via IKS API
##############################################################################

data ibm_iam_auth_token token {}

resource null_resource create_cert_secret_via_api {

    provisioner local-exec {
        command = <<BASH

curl -X POST https://containers.cloud.ibm.com/global/ingress/v2/secret/createSecret \
    -H "Authorization: ${data.ibm_iam_auth_token.token.iam_access_token}" \
    -d '{
        "cluster" : "${data.ibm_container_vpc_cluster.cluster.id}",
        "crn" : "${ibm_certificate_manager_order.cert.id}",
        "name" : "${var.cert_name}",
        "namespace" : "${var.namespace}",
        "persistence" : true
    }'
        BASH 
    }
    
}


##############################################################################


##############################################################################
# Kubernetes Ingress
##############################################################################

resource kubernetes_ingress ingress {
    metadata {
        name      = "${var.application_name}-ingress"
        namespace = var.namespace

        annotations = {
            // Needed to run ingress on IKS 
            "kubernetes.io/ingress.class" = "public-iks-k8s-nginx"
        }
    }

    spec {
        tls {
            hosts       = [
                var.domain
            ]
            secret_name = var.cert_name
        }

        rule {
            host = var.domain

            http {
                path {
                    path = var.path

                    backend {
                        service_name = "${var.application_name}-deployment-svc"
                        service_port = var.port
                    }
                }
            }
        }
    }

    // Wait for secret to be created
    depends_on = [ 
        kubernetes_service.service,
        null_resource.create_cert_secret_via_api
    ]
}

##############################################################################
