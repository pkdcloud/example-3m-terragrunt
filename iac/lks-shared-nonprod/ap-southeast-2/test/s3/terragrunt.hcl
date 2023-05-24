# iac/nonprod/ap-southeast-2/app/terragrunt.hcl

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "tfr:///terraform-aws-modules/s3-bucket/aws//.?version=3.8.2"
}

inputs = {
  bucket = "lks-apse2-test-terragrunt-s3-bucket"
}
