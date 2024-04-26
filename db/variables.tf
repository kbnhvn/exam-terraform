variable "db_username" {
    type        = string
    sensitive   = true
}

variable "db_password" {
    type        = string
    sensitive   = true
}

variable "az_a" {
    type        = string
}

variable "az_b" {
    type        = string
}

variable "exam-terraform_db_subnet_group" {
    type = string
}