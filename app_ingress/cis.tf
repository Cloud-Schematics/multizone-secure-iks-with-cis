##############################################################################
# Data Blocks
##############################################################################

data ibm_cis cis {
    name              = var.cis_name
    resource_group_id = data.ibm_resource_group.resource_group.id
}

data ibm_cis_domain domain {
    domain = var.domain
    cis_id = data.ibm_cis.cis.id
}

data ibm_resource_instance kube_default_cms {
    name              = "kube-${data.ibm_container_vpc_cluster.cluster.id}"
    resource_group_id = data.ibm_resource_group.resource_group.id
    service           = "cloudcerts"
}

##############################################################################


#############################################################################
# 
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
    name      = "${var.dns_subdomain}.${var.domain}"
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


##############################################################################
# Create a rule to overwrite host headers to allow CIS to access the ingress
# subdomain URL
##############################################################################

data ibm_iam_auth_token token {}

resource null_resource cis_page_rule_via_api {

    triggers = {
        crn                   = data.ibm_cis.cis.id
        domain_id             = data.ibm_cis_domain.domain.domain_id
        domain                = var.domain
        token                 = data.ibm_iam_auth_token.token.iam_access_token
        ingress_subdomain_url = "${var.subdomain}.${data.ibm_container_vpc_cluster.cluster.ingress_hostname}"
    }

    provisioner local-exec {
        command = <<BASH
CRN=${self.triggers.crn}
DOMAIN_ID=${self.triggers.domain_id}
URL=www.${self.triggers.domain}/*
INGRESS_SUBDOMAIN_URL=${self.triggers.ingress_subdomain_url}

curl -s -X POST \
    https://api.cis.cloud.ibm.com/v1/$CRN/zones/$DOMAIN_ID/pagerules \
    -H 'content-type: application/json' \
    -H 'accept: application/json' \
    -H "x-auth-user-token: ${self.triggers.token}" \
    -d '{
        "targets" : [
            {
                "target" : "url",
                "constraint" : {
                    "operator" : "matches",
                    "value"    : "'$URL'"
                }
            }
        ],
        "actions" : [
            {
                "id"    : "host_header_override",
                "value" : "'$INGRESS_SUBDOMAIN_URL'"
            }
        ],
        "status" : "active"
    }'

        BASH
    }

    provisioner local-exec {
        when    = destroy
        command = <<BASH

CRN=${self.triggers.crn}
DOMAIN_ID=${self.triggers.domain_id}
INGRESS_SUBDOMAIN_URL=${self.triggers.ingress_subdomain_url}

# Get all page rules
RESULTS=$(curl -s -X GET \
    https://api.cis.cloud.ibm.com/v1/$CRN/zones/$DOMAIN_ID/pagerules \
    -H 'content-type: application/json' \
    -H 'accept: application/json' \
    -H "x-auth-user-token: ${self.triggers.token}" | jq ".result")

# Get length of arrays
RULES_COUNT=$(echo $RESULTS | jq ". | length")
# Get count to go through
RESULTS_LENGTH=$(($RULES_COUNT - 1))


# For each rule
for i in $(seq 0 $RESULTS_LENGTH)
do
    # Get result action
    RESULT_ACTION_ID=$(echo $RESULTS | jq -r ".[$i].actions[0].id")
    # Get value
    RESULT_ACTION_VALUE=$(echo $RESULTS | jq  -r ".[$i].actions[0].value")
    # If ID and value are equal, save as PAGE_RULE_ID
    if [ "$RESULT_ACTION_ID" == "host_header_override" ] && [ "$RESULT_ACTION_VALUE" == "$INGRESS_SUBDOMAIN_URL" ] ; then
        PAGE_RULE_ID=$(echo $RESULTS | jq -r ".[$i].id")
    fi
done

# Delete rule

curl -s -X DELETE \
    https://api.cis.cloud.ibm.com/v1/$CRN/zones/$DOMAIN_ID/pagerules/$PAGE_RULE_ID \
    -H 'content-type: application/json' \
    -H 'accept: application/json' \
    -H "x-auth-user-token: ${self.triggers.token}"

        BASH
    }

    depends_on = [ ibm_cis_dns_record.dns_record ]
}

##############################################################################