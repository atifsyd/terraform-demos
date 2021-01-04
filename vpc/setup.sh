#!/bin/bash

cd ./env/prod

terraform plan -var-file=eu-west-1.tfvars -var-file=us-west-1.tfvars
terraform apply -var-file=eu-west-1.tfvars -var-file=us-west-1.tfvars