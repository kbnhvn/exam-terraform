output "key_name" {
    value = aws_key_pair.exam-terraform_key.key_name
}

output "sg_exam-terraform" {
    value = aws_security_group.sg_exam-terraform.id
}