#Delete SSH Keys from EC2 and local machine
KEYNAME="deploy-aws"
aws ec2 delete-key-pair --key-name $KEYNAME
rm -f $HOME/.ssh/$KEYNAME.pem $HOME/.ssh/$KEYNAME.pub

# apply changes required (using db variables file)
echo 'Destroying changes with terraform destroy'
terraform destroy -var-file="db.tfvars"
