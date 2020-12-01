# For first run, run the following commands to set aws creds

aws configure --profile development

cat <<-EOF > ~/.aws/credentials
[development]
aws_access_key_id = <Your access key>
aws_secret_access_key = <Your secret access key>
EOF

cat <<-EOF > ~/.aws/config
[profile development]
region = us-east-2
output = json
EOF

export AWS_DEFAULT_PROFILE=development
export AWS_PROFILE=development

aws sts get-caller-identity
aws ec2 describe-instances
