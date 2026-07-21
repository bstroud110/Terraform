terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

data "aws_ssm_parameter" "amzn2_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

locals {
  azs = [
    "us-east-1a",
    "us-east-1c"
  ]
}

# Create a VPC
resource "aws_vpc" "demovpc" {
  #name                 = "demovpc"
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "demovpc"
  }
}

resource "aws_internet_gateway" "demoig" {
  vpc_id = aws_vpc.demovpc.id
}

resource "aws_subnet" "demopublicsubnet" {
  for_each = toset (local.azs)

  vpc_id     = aws_vpc.demovpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = each.key
  #gateway_id = aws_internet_gateway.demoig.id
  map_public_ip_on_launch = true

  tags = {
    Name = "public-${each.key}"
  }
}

resource "aws_subnet" "demoprivatesubnet1" {
  for_each = toset(local.azs)

  vpc_id     = aws_vpc.demovpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = each.key

  tags = {
    Name = "private-${each.key}"
  }
}

resource "aws_subnet" "demoprivatesubnet2" {
  for_each = toset(local.azs)

  vpc_id     = aws_vpc.demovpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = each.key

  tags = {
    Name = "private-${each.key}"
  }
}

resource "aws_route_table" "demoroutetable" {
  vpc_id = aws_vpc.demovpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demoig.id
  }
}

#Tie the AWS route table and AWS Subnet together
resource "aws_route_table_association" "demoroutetableassociation" {
  for_each = toset(local.azs)

  subnet_id      = aws_subnet.demopublicsubnet[each.key]
  route_table_id = aws_route_table.demoroutetable.id
}

resource "aws_lb" "demopubliclb" {
  name = "demopublic-lb"
  load_balancer_type = "application"
  subnets = values(aws_subnet.demopublicsubnet)[*].id
}


# Security groups
resource "aws_security_group" "nginxsecuritygroup" {
  name   = "nginxsg"
  vpc_id = aws_vpc.demovpc.id

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "appsecuritygroup" {
  name   = "appsg"
  vpc_id = aws_vpc.demovpc.id

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24", "10.0.0.0/24"]
  }

  egress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24", "10.0.0.0/24"]
  }
}

#EC2 Instances

resource "aws_instance" "demonginx" {
  for_each = toset(local.azs)

  ami                         = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.demopublicsubnet[each.key]
  vpc_security_group_ids      = [aws_security_group.nginxsecuritygroup.id]
  user_data_replace_on_change = true

  user_data = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y demonginx
sudo service nginx start
sudo rm /usr/share/nginx/html/index.html
sudo cat > /usr/share/nginx/html/index.html << 'WEBSITE'
<html>
<head>
    <title>Taco Team Server</title>
</head>
<body style="background-color:#1F778D">
    <p style="text-align: center;">
        <span style="color:#FFFFFF;">
            <span style="font-size:100px;">Demonstration Website!</span>
        </span>
    </p>
</body>
</html>
WEBSITE
EOF

  tags = {
    Name = "demo-nginx"
  }

}

resource "aws_instance" "demoappserver" {
  for_each = toset(local.azs)

  ami                         = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.demoprivatesubnet1[each.key]
  vpc_security_group_ids      = [aws_security_group.nginxsecuritygroup.id]
  user_data_replace_on_change = true

  user_data = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y apache tomcat
sudo service apache start
sudo service tomcat start
EOF

  tags = {
    Name = "demo-appserver"
  }
}

#Group subnets the databse will connect to
#Currently needs work
resource "aws_db_subnet_group" "demodbsubnets" {
  for_each = toset(local.azs)

  name        = "demo-database-subnet-groups"
  description = "Subnet groups the demo RDS database should be able to connect to."

  subnet_ids = [
    aws_subnet.demoprivatesubnet1[each.key], #configure a private subnet and replace this later
    aws_subnet.demoprivatesubnet2[each.key]
  ]

  tags = {
    Name = "DB_Subnets"
  }
}

resource "aws_db_instance" "demordsdb" {
  for_each = toset(local.azs)
  
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql8.0"
  publicly_accessible  = false
  skip_final_snapshot  = true

  #Connects the rds instance to demodbsubnets grouping
  db_subnet_group_name = aws_db_subnet_group.demodbsubnets[each.key]
}