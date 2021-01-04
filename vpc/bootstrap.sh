#!/bin/bash

function setup_SSH_Accesses {
  # Create key pair
  KEYPATH=".sekrets"
  KEYNAME="deploy-aws"
  REGION1="eu-west-1"
  REGION2="us-west-1"

  mkdir -p ./$KEYPATH
  openssl genrsa -out "$KEYPATH/aws.pem" 4096
  openssl rsa -in "$KEYPATH/aws.pem" -pubout > "$KEYPATH/aws.pub"
  chmod 400 "$KEYPATH/aws.pem"

  aws ec2 import-key-pair --region $REGION1 --key-name $KEYNAME \
  --public-key-material "$(grep -v PUBLIC $KEYPATH/aws.pub | tr -d '\n')"
  aws ec2 import-key-pair --region $REGION2 --key-name $KEYNAME \
  --public-key-material "$(grep -v PUBLIC $KEYPATH/aws.pub | tr -d '\n')"
  
  mv $KEYPATH/aws.pem $HOME/.ssh/$KEYNAME.pem
  mv $KEYPATH/aws.pub $HOME/.ssh/$KEYNAME.pub
  
  rm -rf ./$KEYPATH
}

function create_S3_bucket {
  BUCKETNAME="atif-terraform-state"
  REGION="eu-west-1"
  aws s3 mb --region $REGION s3://$BUCKETNAME
}

# Only setup ssh access and s3 bucket if not already
setup_SSH_Accesses
create_S3_bucket

terraform workspace list
terraform workspace new prod
terraform workspace select prod
