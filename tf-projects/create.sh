mkdir -p ./{infra/{net,sec},webapp/{app,db}}
touch ./{infra,webapp}/aws.tf

cat <<-'AWSPROFILE' > ./infra/aws.tf
variable "region" {}
provider "aws" {
  region     = "${var.region}"
}
AWSPROFILE

cp ./infra/aws.tf ./webapp/aws.tf

export TF_VAR_region=$(
  awk -F'= ' '/region/{print $2}' <(
    grep -A1 "\[.*$AWS_PROFILE\]" ~/.aws/config)
)

echo $TF_VAR_region

pushd ./infra/ && terraform init && popd
pushd ./webapp/ && terraform init && popd

# Create key pair
mkdir -p ./.sekrets
KEYPATH=".sekrets"
KEYNAME="deploy-aws"
openssl genrsa -out "$KEYPATH/aws.pem" 4096
openssl rsa -in "$KEYPATH/aws.pem" -pubout > "$KEYPATH/aws.pub"
chmod 400 "$KEYPATH/aws.pem"
aws ec2 import-key-pair \
  --key-name $KEYNAME \
  --public-key-material \
        "$(grep -v PUBLIC $KEYPATH/aws.pub | 
           tr -d '\n')"
cp $KEYPATH/aws.pem $HOME/.ssh/$KEYNAME.pem
cp $KEYPATH/aws.pub $HOME/.ssh/$KEYNAME.pub

#Verify
KEYNAME="deploy-aws"
aws ec2 describe-key-pairs \
  --query 'KeyPairs[*].[KeyName]' \
  --output text | grep $KEYNAME

# Later, use the command to login
KEYNAME="deploy-aws"
ssh -i ~/.ssh/$KEYNAME.pem $AWS_HOST_IP
