# vpc/outputs.tf

output "vpc_id" {
  description = "ID of the VPC"
  value       = try(aws_vpc.this[0].id, null)
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = try(aws_vpc.this[0].cidr_block, null)
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = try(aws_internet_gateway.this[0].id, null)
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway (if enabled)"
  value       = try(aws_nat_gateway.this[0].id, null)
}
