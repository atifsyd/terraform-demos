terraform {
  backend "s3" {
    bucket  = "atif-terraform-state"
    encrypt = true
    // path pattern: s3://<bucket>/<workspace_key_prefix>/<workspace-name>/<key>
    key                  = "terraform.tfstate"
    region               = "eu-west-1"
    workspace_key_prefix = "my-infra"
  }
}