##############################################################################
# Account Variables
##############################################################################

variable ibmcloud_api_key {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
  type        = string
}


variable ibm_region {
    description = "IBM Cloud region where all resources will be deployed"
    type        = string
}

variable resource_group {
    description = "Name of resource group to create VPC"
    type        = string
    default     = "asset-development"
}

variable generation {
  description = "generation for VPC. Can be 1 or 2"
  type        = number
  default     = 2
}

##############################################################################


##############################################################################
# Cluster Variables
##############################################################################

variable cluster_name {
    description = "Name of the cluster where resources will be provisioned"
    type        = string
}
##############################################################################


##############################################################################
# CMS Variables
##############################################################################

variable cert_name {
    description = "Name of certificate to create"
    type        = string
    default     = "demo-cert"
}

variable cert_description {
    description = "The description for the certificate being created"
    type        = string
    default     = "A demo certificate"
}

##############################################################################


##############################################################################
# CIS Variables
##############################################################################

variable cis_name {
    description = "Name of the CIS instance where resources will be provisioned"
    type        = string
}
variable cis_plan {
    description = "Plan for CIS instance"
    type        = string
    default     = "enterprise-usage"
}

variable subdomain {
    description = "Name of the subdmain to use"
    type        = string
    default     = "test"
}

variable domain {
    description = "The domain to add to CIS"
    type        = string
    default     = "gcat-asset-test.com"
}

variable always_use_https {
    description = "Always use HTTPS for domain"
    type        = bool
    default     = true
}

variable automatic_https_rewrites {
    description = "Automatically rewrite HTTP requests"
    type        = bool
    default     = true 
}

variable ssl {
    description = "SSL"
    type        = string
    default     = "full"
}

##############################################################################


##############################################################################
# Deployment Variables
##############################################################################

variable application_name {
    description = "Name for the application that will be deployed"
    type        = string
    default     = "hello-world"
}

variable replicas {
    description = "Number of replicas for the deployment"
    type        = number
    default     = 3
}

variable namespace {
    description = "Namespace where the application will be deployed"
    type        = string
    default     = "default"
}

variable image {
    description = "Image to deploy on the cluster"
    type        = string
    default     = "us.icr.io/asset-development/hello-world:1"
}

variable path {
    description = "Application path"
    type        = string
    default     = "/"
}

variable port {
    description = "Port for application"
    type        = number
    default     = 8080
}

variable target_port {
    description = "Target port for application"
    type        = string
    default     = 8080
}

##############################################################################