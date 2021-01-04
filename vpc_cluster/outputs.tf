##############################################################################
# Cluster ID
##############################################################################

output cluster_id {
    description = "ID of cluster created"
    value       = ibm_container_vpc_cluster.cluster.id
}

output cluster_ingress_hostname {
    description = "Hostname for cluster ingress"
    value       = ibm_container_vpc_cluster.cluster.ingress_hostname
}

##############################################################################