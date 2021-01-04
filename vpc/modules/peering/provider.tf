provider "aws" {
  alias = "src"
  region = var.requestor_region
}
provider "aws" {
  alias = "dst"
  region = var.acceptor_region
}