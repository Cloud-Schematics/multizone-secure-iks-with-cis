##############################################################################
# Account Variables
##############################################################################

variable unique_id {
    description = "A unique identifier need to provision resources. Must begin with a letter"
    type        = string
    default     = "asset-multizone"
}

variable ibm_region {
    description = "IBM Cloud region where all resources will be deployed"
    type        = string
}

variable resource_group_id {
    description = "ID of resource group to create VPC"
    type        = string
}

##############################################################################


##############################################################################
# Network variables
##############################################################################

variable classic_access {
  description = "Enable VPC Classic Access. Note: only one VPC per region can have classic access"
  type        = bool
  default     = false
}

variable enable_public_gateway {
  description = "Enable public gateways for subnets, true or false"
  type        = bool
  default     = true
}

variable cidr_blocks {
  description = "A list of tier subnet CIDR blocks"
  type        = list //(string)
  default     = [
    "10.10.10.0/24",
    "10.10.20.0/24",
    "10.10.30.0/24"
  ] 
}

variable acl_rules {
  description = "Access control list rule set"
  default = [
    {
      name        = "iks-create-worker-nodes-inbound"
      action      = "allow"
      source      = "161.26.0.0/16"
      destination = "0.0.0.0/0"
      direction   = "inbound"
    },
    {
      name        = "iks-nodes-to-master-inbound"
      action      = "allow"
      source      = "166.8.0.0/14"
      destination = "0.0.0.0/0"
      direction   = "inbound"
    },
    {
      name        = "deny-all-inbound"
      action      = "deny"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction   = "inbound"      
    },
    {
      name        = "cf-ip-1"
      source      = "103.21.244.0/22"
      action      = "allow"
      destination = "0.0.0.0/0"
      direction   = "inbound"
      tcp         = {
        source_port_min = 1
        source_port_max = 65535
        port_min        = 443
        port_max        = 443
      }
    },
    {
      name        = "cf-ip-2"
      source      = "173.245.48.0/20"
      action      = "allow"
      destination = "0.0.0.0/0"
      direction   = "inbound"
      tcp         = {
        source_port_min = 1
        source_port_max = 65535
        port_min        = 443
        port_max        = 443
      }
    },
    {
      name        = "cf-ip-3"
      source      = "103.22.200.0/22"
      action      = "allow"
      destination = "0.0.0.0/0"
      direction   = "inbound"
      tcp         = {
        source_port_min = 1
        source_port_max = 65535
        port_min        = 443
        port_max        = 443
      }
    },
    {
      name        = "cf-ip-4"
      source      = "103.31.4.0/22"
      action      = "allow"
      destination = "0.0.0.0/0"
      direction   = "inbound"
      tcp         = {
        source_port_min = 1
        source_port_max = 65535
        port_min        = 443
        port_max        = 443
      }
    },
    {
      name        = "cf-ip-5"
      source      = "141.101.64.0/18"
      action      = "allow"
      destination = "0.0.0.0/0"
      direction   = "inbound"
      tcp         = {
        source_port_min = 1
        source_port_max = 65535
        port_min        = 443
        port_max        = 443
      }
    },
    {
      name        = "cf-ip-6"
      source      = "108.162.192.0/18"
      action      = "allow"
      destination = "0.0.0.0/0"
      direction   = "inbound"
      tcp         = {
        source_port_min = 1
        source_port_max = 65535
        port_min        = 443
        port_max        = 443
      }
    },
    {
      name        = "cf-ip-7"
      source      = "190.93.240.0/20"
      action      = "allow"
      destination = "0.0.0.0/0"
      direction   = "inbound"
      tcp         = {
        source_port_min = 1
        source_port_max = 65535
        port_min        = 443
        port_max        = 443
      }
    },
    {
      name        = "cf-ip-8"
      source      = "188.114.96.0/20"
      action      = "allow"
      destination = "0.0.0.0/0"
      direction   = "inbound"
      tcp         = {
        source_port_min = 1
        source_port_max = 65535
        port_min        = 443
        port_max        = 443
      }
    },
    {
      name        = "cf-ip-9"
      source      = "197.234.240.0/22"
      action      = "allow"
      destination = "0.0.0.0/0"
      direction   = "inbound"
      tcp         = {
        source_port_min = 1
        source_port_max = 65535
        port_min        = 443
        port_max        = 443
      }
    },
    {
      name        = "cf-ip-10"
      source      = "198.41.128.0/17"
      action      = "allow"
      destination = "0.0.0.0/0"
      direction   = "inbound"
      tcp         = {
        source_port_min = 1
        source_port_max = 65535
        port_min        = 443
        port_max        = 443
      }
    },
    {
      name        = "cf-ip-11"
      source      = "162.158.0.0/15"
      action      = "allow"
      destination = "0.0.0.0/0"
      direction   = "inbound"
      tcp         = {
        source_port_min = 1
        source_port_max = 65535
        port_min        = 443
        port_max        = 443
      }
    },
    {
      name        = "cf-ip-12"
      source      = "104.16.0.0/12"
      action      = "allow"
      destination = "0.0.0.0/0"
      direction   = "inbound"
      tcp         = {
        source_port_min = 1
        source_port_max = 65535
        port_min        = 443
        port_max        = 443
      }
    },
    {
      name        = "cf-ip-13"
      source      = "172.64.0.0/13"
      action      = "allow"
      destination = "0.0.0.0/0"
      direction   = "inbound"
      tcp         = {
        source_port_min = 1
        source_port_max = 65535
        port_min        = 443
        port_max        = 443
      }
    },
    {
      name        = "cf-ip-14"
      source      = "131.0.72.0/22"
      action      = "allow"
      destination = "0.0.0.0/0"
      direction   = "inbound"
      tcp         = {
        source_port_min = 1
        source_port_max = 65535
        port_min        = 443
        port_max        = 443
      }
    },
    {
      name        = "allow-all-https-inbound"
      source      = "0.0.0.0/0"
      action      = "allow"
      destination = "0.0.0.0/0"
      direction   = "inbound"
      tcp         = {
        source_port_min = 1
        source_port_max = 65535
        port_min        = 443
        port_max        = 443
      }
    },   
    {
      name        = "allow-all-outbound"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction   = "outbound"
    }
  ]
  
}

variable security_group_rules {
  description = "List of security group rules to be added to default security group"
  default     = {
    allow_all_inbound = {
      source    = "0.0.0.0/0"
      direction = "inbound"
    }
  }
}

##############################################################################