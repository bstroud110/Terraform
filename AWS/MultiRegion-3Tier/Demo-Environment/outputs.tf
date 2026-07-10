output "vpc_id" {
  description = "ID of the Demo VPC"
  value       = aws_vpc.demovpc.id
}

output "public_subnet_id" {
  description = "Details of the public subnet"
  value       = aws_subnet.demopublicsubnet.id
}

output "aws_instance_public_dns" {
  description = "Public DNS hostname of the NGINX EC2 Instance"
  value       = aws_instance.demonginx.public_dns
}

