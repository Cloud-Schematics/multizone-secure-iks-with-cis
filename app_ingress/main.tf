
##############################################################################
# Resource Group where VPC will be created
##############################################################################

data ibm_resource_group resource_group {
  name = var.resource_group
}

##############################################################################


##############################################################################
# Cluster Data
##############################################################################

data ibm_container_vpc_cluster cluster {
  name              = var.cluster_name
  resource_group_id = data.ibm_resource_group.resource_group.id
}

##############################################################################


##############################################################################
# Cluster Config Data
##############################################################################

data ibm_container_cluster_config cluster {
  cluster_name_id   = var.cluster_name
  resource_group_id = data.ibm_resource_group.resource_group.id
  admin             = true
}

##############################################################################