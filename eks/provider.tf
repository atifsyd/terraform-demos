provider "aws" {
  version                 = "~>2.57.0"
  profile                 = "default"
#  shared_credentials_file = "/home/syeda/.aws/credentials"
  region                  = "us-west-1"
}

provider "random" {
  version = "~> 2.2.1"
}

data "aws_caller_identity" "current" {}