provider "aws" {
  version                 = "~>2.57.0"
  profile                 = "default"
  region                  = "us-west-1"
}

provider "random" {
  version = "~> 2.2.1"
}

data "aws_caller_identity" "current" {}