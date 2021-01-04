provider "aws" {
  region = var.region1
  alias  = "eu-west-1"
}

provider "aws" {
  region = var.region2
  alias  = "us-west-1"
}