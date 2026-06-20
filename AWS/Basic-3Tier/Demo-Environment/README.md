GOAL:  Define a simple AWS 3 Tier environment using Terraform.

ARCHITECTURE DIAGRAM:  Basic-3-Tier-Architecture.drawio

STRUCTURE:  
    3-Tier Architecture
    Required Provider:  AWS
    Region:  us-east1
    VPC
        CIDR:  10.0.0.0/16
        Enable DNS = true
    Subnets
        Public 10.0.0.0/24
        Private 10.0.1.0/24
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
Address the following:
    Error indicates us-east-1f should be the target for 
│ Error: creating RDS DB Subnet Group (demo-database-subnet-groups): operation error RDS: CreateDBSubnetGroup, https response error StatusCode: 400, RequestID: 099814d7-9c06-48a5-a357-8d0c5c04c8e1, DBSubnetGroupDoesNotCoverEnoughAZs: The DB subnet group doesn't meet Availability Zone (AZ) coverage requirement. Current AZ coverage: us-east-1f. Add subnets to cover at least 2 AZs.
│ 
│   with aws_db_subnet_group.demodbsubnets,
│   on main.tf line 158, in resource "aws_db_subnet_group" "demodbsubnets":
│  158: resource "aws_db_subnet_group" "demodbsubnets" {

