# iac/nonprod/ap-southeast-2/app/terragrunt.hcl

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "tfr:///terraform-aws-modules/vpc/aws//.?version=3.19.0"
}

inputs = {
  cidr = "10.0.0.0/20"
  name = "lks-use1-prod-terragrunt-vpc"
}
