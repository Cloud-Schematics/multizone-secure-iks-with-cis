# Module Variables

Variable          | Type   | Description                                                                 | Default
----------------- | ------ | --------------------------------------------------------------------------- |--------
resource_group_id | string | ID for IBM Cloud Resource Group where resources will be deployed            | 
account_id        | string | ID of the account where your resources will be provisioned                  | 
cluster_id        | string | Cluster ID to get CMS instance                                              | 
unique_id         | string | A unique identifier need to provision resources. Must begin with a letter   | `"asset-multizone"`
cis_plan          | string | Plan for CIS instance                                                       | `"enterprise-usage"`
domain            | string | The domain to add to CIS                                                    | `"gcat-asset-test.com"`