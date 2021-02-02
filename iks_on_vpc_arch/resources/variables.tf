##############################################################################
# Account Variables
##############################################################################

variable resource_group_id {
    description = "ID for IBM Cloud Resource Group where resources will be deployed"
    type        = string
}

variable account_id {
  description = "ID of the account where your resources will be provisioned"
  type        = string
}

##############################################################################


##############################################################################
# Cluster Variables
##############################################################################

variable cluster_id {
    description = "Cluster ID to get CMS instance"
    type        = string
}

##############################################################################


##############################################################################
# CIS Variables
##############################################################################

variable unique_id {
    description = "A unique identifier need to provision resources. Must begin with a letter"
    type        = string
    default     = "asset-multizone"
}

variable cis_plan {
    description = "Plan for CIS instance"
    type        = string
    default     = "enterprise-usage"
}

variable domain {
    description = "The domain to add to CIS"
    type        = string
    default     = "gcat-asset-test.com"
}

##############################################################################