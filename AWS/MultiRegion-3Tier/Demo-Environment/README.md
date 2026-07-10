GOAL:  Define a simple AWS 3 Tier environment using Terraform.

ARCHITECTURE DIAGRAM:  Multi-Region-3-Tier-Architecture.jpg

STRUCTURE:  
    3-Tier Architecture
    Required Provider:  AWS
    Region:  us-east1
    Availability Zones:  us-east-1a, us-east-1c
    VPC
        CIDR:  10.0.0.0/16
        Enable DNS = true
    Subnets
        Public 10.0.0.0/24
        Private1 10.0.1.0/24
        Private2 10.0.2.0/24
    EC2 Instance for NGINX 
    EC2 Instance for Application server
    RDS Database for backend storage
    
    

#The below command will use the AWS CLI to allow us to configure access to the AWS environment via local environment 
#We then pass the credentials AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY as environment variables

aws configure


TO DO:
Terraform:
    Implement variables
    Consider modules

S3 Bucket:
    Best practices of Terraform involve storing state file in an S3 bucket.  As of 6/20/2026, current form stores state file locally.

Security Group work:
    Create security group for connectivity between App server and database

EC2 Work
    Validate configuration of EC2 instances
        -Need to access servers to ensure User Data configuration is being pushed successfully
    Validate connectivity between front and back ends, as well as backend with database

RDS Database


