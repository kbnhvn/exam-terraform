output "cidr_vpc" {
    value = aws_vpc.exam-terraform_vpc.id
}

output "app_subnet_a" {
    value = aws_subnet.app_subnet_a.id
}

output "app_subnet_b" {
    value = aws_subnet.app_subnet_b.id
}

output "public_subnet_a" {
    value = aws_subnet.public_subnet_a.id
}

output "public_subnet_b" {
    value = aws_subnet.public_subnet_b.id
}

output "vpc_id" {
  value = aws_vpc.exam-terraform_vpc.id
}


output "exam-terraform_db_subnet_group" {
    value = aws_db_subnet_group.exam-terraform_db_subnet_group.name
}