# Secure Multizone IKS on VPC With CIS

This [architecture](./iks_on_vpc_arch) creates a Multizone VPC, an IKS cluster on that VPC, a CIS instance, and a domain. Included is an example module for deploying an ingress application onto your cluster and accessing it through your domain using CIS.

![Multizone IKS Secure](./.docs/mz-cis.png)

---

## Table of Contents

1. [VPC](##VPC)
2. [VPC Cluster](##vpc-cluster)
3. [CIS](##cis)
4. [Infrastructure Variables](##infrastructure-variables)

---

## VPC

This architecture creates a Multizone VPC using the [multizone_vpc module](./iks_on_vpc_arch/multizone_vpc). For this example, public gateways are enabled.

![Multizone VPC](./iks_on_vpc_arch/multizone_vpc/.docs/multizone.png)

For more information about VPC see the documentation [here](https://cloud.ibm.com/docs/vpc/vpc-getting-started-with-ibm-cloud-virtual-private-cloud-infrastructure).

### VPC ACLs

The ACL that's created for this VPC uses the following rules to secure inbound traffic for the VPC:

---

#### Automatically Generated Rules

The [multizone_vpc module acl code](./iks_on_vpc_arch/multizone_vpc/acl.tf) creates the following three rules automatically:

Description                           | Source CIDR             | Destination CIDR | Action | Direction
--------------------------------------|-------------------------|------------------|--------|-----------
Allow all traffic from peer subnet 1  | 10.10.10.0/24 (default) | Any              | Allow  | Inbound
Allow all traffic from peer subnet 2  | 10.10.20.0/24 (default) | Any              | Allow  | Inbound
Allow all traffic from peer subnet 3  | 10.10.30.0/24 (default) | Any              | Allow  | Inbound

---

#### Kubernetes Required ACL Rules

In order for IKS to work on the VPC, the following ACL rules need to be in place. These rules can be found in [variables.tf](./iks_on_vpc_arch/variables.tf)

Description                           | Source CIDR             | Destination CIDR | Action | Direction
--------------------------------------|-------------------------|------------------|--------|-----------
IKS Create Worker Nodes               | 161.26.0.0/16           | Any              | Allow  | Inbound
IKS Create Worker Nodes               | 161.26.0.0/16           | Any              | Allow  | Inbound

---

#### Cloudflare Required ACL Rules

To allow inbound HTTPS traffic through CIS, the following rules are required to allow Cloudflare servers to reach the VPC. These rules can be found in [variables.tf](./iks_on_vpc_arch/variables.tf)

Description                           | Source CIDR             | Destination CIDR | Port | Action | Direction
--------------------------------------|-------------------------|------------------|------|--------|-----------
Cloudflare IP 1                       | 103.21.244.0/22         | Any              | 443  | Allow  | Inbound
Cloudflare IP 2                       | 173.245.48.0/20         | Any              | 443  | Allow  | Inbound
Cloudflare IP 3                       | 103.22.200.0/22         | Any              | 443  | Allow  | Inbound
Cloudflare IP 4                       | 103.31.4.0/22           | Any              | 443  | Allow  | Inbound
Cloudflare IP 5                       | 141.101.64.0/18         | Any              | 443  | Allow  | Inbound
Cloudflare IP 6                       | 108.162.192.0/18        | Any              | 443  | Allow  | Inbound
Cloudflare IP 7                       | 190.93.240.0/20         | Any              | 443  | Allow  | Inbound
Cloudflare IP 8                       | 188.114.96.0/20         | Any              | 443  | Allow  | Inbound
Cloudflare IP 9                       | 197.234.240.0/22        | Any              | 443  | Allow  | Inbound
Cloudflare IP 10                      | 162.158.0.0/15          | Any              | 443  | Allow  | Inbound
Cloudflare IP 11                      | 104.16.0.0/12           | Any              | 443  | Allow  | Inbound
Cloudflare IP 12                      | 172.64.0.0/13           | Any              | 443  | Allow  | Inbound
Cloudflare IP 13                      | 131.0.72.0/22           | Any              | 443  | Allow  | Inbound
Cloudflare IP 14                      | 198.41.128.0/17         | Any              | 443  | Allow  | Inbound

---

#### Other ACL Rules

Description                           | Source CIDR             | Destination CIDR | Action | Direction
--------------------------------------|-------------------------|------------------|--------|-----------
Allow all outbound traffic            | Any                     | Any              | Allow  | Outbound
Deny all inbound traffic              | Any                     | Any              | Allow  | Inbound

For more information about ACLs see the [documentation](https://cloud.ibm.com/docs/containers?topic=containers-vpc-network-policy#acls).

---

### VPC Security Group Rules

IKS on VPC Clusters are provisioned the VPC Default Security Group. In order to allow the workers to connect, a rule to allow all traffic is added to the default security group.

For more information about security groups see the documentation [here](https://cloud.ibm.com/docs/vpc?topic=vpc-using-security-groups).

---

## VPC Cluster

This architecture uses the [vpc_cluster module](./iks_on_vpc_arch/vpc_cluster) to create a cluster across all three zones of the VPC. Optionally, this module can create additional worker pools in the existing cluster. **Note: In order to make sure you cluster load balancers work properly, make sure each pool has at least 2 worker nodes.**

![VPC Cluster](./iks_on_vpc_arch/vpc_cluster/.docs/cluster.png).

For more information about IKS see the documentation [here](https://cloud.ibm.com/docs/containers?topic=containers-vpc_ks_tutorial).

---

## CIS

This architecture creates a Cloud Internet Services instance and CIS domain. We'll use this domain to deploy the [example ingress application](./app_ingress). This module also creates an IAM authorization policy to allow the CIS instance to access the IKS default Certificate Manager instance.

For more information about CIS see the documentation [here](https://cloud.ibm.com/docs/cis/getting-started.html).

### Domain

This creates a domain in your CIS instance. In order for this domain to be connected, you will need to change the NS records for your domain to the ones listed in CIS. This can be done from the GUI at cloud.ibm.com.

![CIS NS Records](./.docs/cisgui.png)

### Authorization Policy

All IBM Cloud Kubernetes clusters are created with a [Certificate Manager instance](https://www.ibm.com/cloud/blog/ibm-cloud-kubernetes-service-integration-with-ibm-cloud-certificate-manager). In order for our CIS to communicate with this Certificate Manager instance, an authorization policy is created to allow CIS to create and access certificates stored in the Certificate Manager instnace. See the authorization policy in [/resources/cms.tf](./resources/cms.tf)

---

## Infrastructure Variables

Variable                        | Type         | Description                                                                                                                                                       | Default
--------------------------------|--------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------
ibmcloud_api_key                | string       | The IBM Cloud platform API key needed to deploy IAM enabled resources                                                                                             |
unique_id                       | string       | A unique identifier need to provision resources. Must begin with a letter                                                                                         | `asset-multizone`
ibm_region                      | string       | IBM Cloud region where all resources will be deployed                                                                                                             |
resource_group                  | string       | Name of resource group where all infrastructure will be provisioned                                                                                               | `asset-development`
generation                      | number       | Generation for VPC. Can be 1 or 2                                                                                                                                 | 2
account_id                      | string       | ID of the account where your resources will be provisioned                                                                                                        |
classic_access                  | bool         | Enable VPC Classic Access. Note: only one VPC per region can have classic access                                                                                  | `false`
enable_public_gateway           | bool         | Enable public gateways for subnets, true or false                                                                                                                 | `true`
cidr_blocks                     | list(string) | A list of tier subnet CIDR blocks                                                                                                                                 | `["10.10.10.0/24","10.10.20.0/24","10.10.30.0/24"]`
acl_rules                       | list(map)    | List of Access Control List rules                                                                                                                                 | See [variables.tf](variables.tf) For full list of default rules
security_group_rules            | map          | List of security group rules to be added to default security group                                                                                                | `{ allow_all_inbound = { source = "0.0.0.0/0" direction = "inbound" } } }`
machine_type                    | string       | The flavor of IKS worker nodes to use for your cluster                                                                                                            | `bx2.4x16`
workers_per_zone                | number       | Number of workers to provision in each subnet. For load balancing to work, worker pool size must be 2 or greater.                                                 | `2`
disable_public_service_endpoint | bool         | Disable public service endpoint for cluster                                                                                                                       | `false`
kube_version                    | string       | Specify the Kubernetes version, including the major andminor version. To see available versions, run ibmcloud ks versions. To use the default, leave string empty | `""`
wait_till                       | string       | To avoid long wait times when you run your Terraform code, you can specify the stage when you want Terraform to mark the cluster resource creation as completed. Depending on what stage you choose, the cluster creation might not be fully completed and continues to run in the background. However, your Terraform code can continue to run without waiting for the cluster to be fully created. Supported args are `MasterNodeReady`, `OneWorkerNodeReady`, and `IngressReady` | `IngressReady`
worker_pools                    | list(map)    | (Optional) List of maps describing additional worker pools. See [variables.tf](./variables.tf) for examples                                                       |
cis_plan                        | string       | Plan for CIS instance                                                                                                                                             | `enterprise-usage`
domain                          | string       | The domain to add to CIS                                                                                                                                          | `gcat-asset-test.com`
