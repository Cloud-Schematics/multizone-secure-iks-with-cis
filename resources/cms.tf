##############################################################################
# CMS Instance
##############################################################################

data ibm_resource_instance kube_default_cms {
    name              = "kube-${var.cluster_id}"
    resource_group_id = var.resource_group_id
    service           = "cloudcerts"
}

##############################################################################


##############################################################################
# Create Authorization Policy to allow CMS to access CIS
##############################################################################

resource ibm_iam_authorization_policy policy {
    roles                       = [
        "Reader",
        "Writer",
        "Manager",
    ]
    source_resource_instance_id = data.ibm_resource_instance.kube_default_cms.guid
    source_service_account      = var.account_id
    source_service_name         = "cloudcerts"
    target_service_name         = "internet-svcs"
}

##############################################################################
