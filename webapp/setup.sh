#!/bin/bash

function create_AWS_Provider {
	cat <<-'AWSPROFILE' > ./infra/aws.tf
	variable "region" {}
	provider "aws" {
	  region     = var.region
	}
	AWSPROFILE
	export TF_VAR_region=$(
	awk -F'= ' '/region/{print $2}' <(
	  grep -A1 "\[.*$AWS_PROFILE\]" ~/.aws/config)
	)
	echo $TF_VAR_region
}

function setup_SSH_Accesses {
	# Create key pair
	KEYPATH=".sekrets"
	KEYNAME="deploy-aws"
	mkdir -p ./$KEYPATH
	openssl genrsa -out "$KEYPATH/aws.pem" 4096
	openssl rsa -in "$KEYPATH/aws.pem" -pubout > "$KEYPATH/aws.pub"
	chmod 400 "$KEYPATH/aws.pem"
	aws ec2 import-key-pair \
	--key-name $KEYNAME \
	--public-key-material \
	      "$(grep -v PUBLIC $KEYPATH/aws.pub | 
	        tr -d '\n')"
	mv $KEYPATH/aws.pem $HOME/.ssh/$KEYNAME.pem
	mv $KEYPATH/aws.pub $HOME/.ssh/$KEYNAME.pub
	rm -rf ./$KEYPATH
}

function addEC2_Key_Pair {
	#Verify
	KEYNAME="deploy-aws"
	aws ec2 describe-key-pairs \
	  --query 'KeyPairs[*].[KeyName]' \
	  --output text | grep $KEYNAME

	# Later, use the command to login
	# KEYNAME="deploy-aws"
	# ssh -i ~/.ssh/$KEYNAME.pem $AWS_HOST_IP
}

# Create Infra on AWS - Subnets, VPC, Internet gateway, Route table, Route table association and NAT
function main {
	create_AWS_Provider
	setup_SSH_Accesses
	addEC2_Key_Pair

	terraform init
	
	terraform validate && terraform plan -var-file="db.tfvars"
	
	terraform apply -var-file="db.tfvars"
}

main