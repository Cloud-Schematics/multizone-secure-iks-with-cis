##############################################################################
# CIS Instance
##############################################################################

data ibm_cis cis {
    name              = var.cis_name
    resource_group_id = data.ibm_resource_group.resource_group.id
}

##############################################################################


##############################################################################
# CIS Domain
##############################################################################

data ibm_cis_domain domain {
    domain = var.domain
    cis_id = data.ibm_cis.cis.id
}

##############################################################################


##############################################################################
# Default Kubernetes CMS instance
##############################################################################

data ibm_resource_instance kube_default_cms {
    name              = "kube-${data.ibm_container_vpc_cluster.cluster.id}"
    resource_group_id = data.ibm_resource_group.resource_group.id
    service           = "cloudcerts"
}

##############################################################################


#############################################################################
# Create Domain Settings
##############################################################################

resource ibm_cis_domain_settings domain_settings {
    cis_id                   = data.ibm_cis.cis.id
    domain_id                = data.ibm_cis_domain.domain.id
    always_use_https         = var.always_use_https ? "on" : "off"
    automatic_https_rewrites = var.automatic_https_rewrites ? "on" : "off"
    ssl                      = var.ssl
}

##############################################################################


##############################################################################
# Create DNS Record to forward the domain URL to the ingress subdomain
##############################################################################

resource ibm_cis_dns_record dns_record {
    cis_id    = data.ibm_cis.cis.id
    domain_id = data.ibm_cis_domain.domain.id
    name      = var.domain
    type      = "CNAME"
    content   = "${var.subdomain}.${data.ibm_container_vpc_cluster.cluster.ingress_hostname}"
    proxied   = true
}

##############################################################################


##############################################################################
# Order CMS Cert into CIS
##############################################################################

resource ibm_certificate_manager_order cert {
    certificate_manager_instance_id = data.ibm_resource_instance.kube_default_cms.id
    name                            = var.cert_name
    description                     = var.cert_description
    domains                         = [ var.domain ]
    rotate_keys                     = false
    domain_validation_method        = "dns-01"
    dns_provider_instance_crn       = data.ibm_cis.cis.id
}

##############################################################################