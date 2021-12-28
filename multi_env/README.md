State File

Use different state file / variable file for each env

terraform plan -state = "./dev/dev.state" -var-file = "common.tfvars" -var-file="./dev/dev.tfvars" \
terraform apply -state = "./dev/dev.state" -var-file = "common.tfvars" -var-file="./dev/dev.tfvars"



|                 | DEV         |UAT          |                  PROD|
| -----------     | ----------- |-------------|----------------------|
| CIDR Block      | 10.0.0.0/16 |10.1.0.0/16  |10.2.0.0/16       |
| Subnet          | 2           | 2           | 3                |
| instance        | 2           | 4           | 6                |


Workspace
terraform workspace  new dev
terraform workspace list
terraform workspace select default
terraform workspace select dev
terraform workspace select uat


terraform apply -var-file=terraform.tfvar


