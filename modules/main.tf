provider "aws" {
  region = "eu-west-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "webserver-vpc"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

module "my_webserver" {
  source         = "../modules/webserver"
  vpc_id         = aws_vpc.main.id
  cidr_block     = "10.0.0.0/16"
  webserver_name = "mywebserver"
  ami            = data.aws_ami.ubuntu.id
  instance_type  = "t2.micro"
}

