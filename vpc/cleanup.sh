#!/bin/bash

#Delete SSH Keys from EC2 and local machine
KEYNAME="deploy-aws"
aws ec2 delete-key-pair --key-name $KEYNAME --region eu-west-1
aws ec2 delete-key-pair --key-name $KEYNAME --region us-west-1

rm -f $HOME/.ssh/$KEYNAME.pem $HOME/.ssh/$KEYNAME.pub

# apply changes required (using db variables file)
echo 'Destroying changes with terraform destroy'
cd ./env/prod
terraform destroy -var-file="eu-west-1.tfvars" -var-file="us-west-1.tfvars"