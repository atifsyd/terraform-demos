terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
}

data "aws_ami" "openshot_ami" {
  most_recent = true
  owners      = ["aws-marketplace"]
  filter {
    name   = "name"
    values = ["*OpenShot*"]
  }
}

resource "aws_security_group" "allow_http_ssh_openshot" {
  name        = "allow_http_ssh_openshot"
  description = "Allow HTTP and SSH inbound traffic"

  ingress {
    description = "HTTP OPEN"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    description = "SSH OPEN"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http_ssh_openshot"
  }
}

resource "aws_instance" "web" {
  ami             = data.aws_ami.openshot_ami.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.allow_http_ssh_openshot.name]
  key_name        = "admin"
  user_data       = file("./openshot.sh")
  tags = {
    Name = "production"
  }
}

output "IP" {
  value = aws_instance.web.public_ip
}
