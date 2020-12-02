# About
This project has infrastructure and web application setup using bash scripts and Terraform
Post setup, get the public ip of ec2 instance from terraform show command.
Also, get the RDS endpoint. Navigate to EC2 Public IP address in any browser and enter the RDS details. The application then shows sample usernames, phone, email and isAdmin.
To run this project, run the command

```bash
./setup.sh
# to remove
./cleanup.sh
```

# References
https://joachim8675309.medium.com/building-aws-infra-with-terraform-96387481b9d7