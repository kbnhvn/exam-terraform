variable public_key_path {
    description = "Public key path"
    default     = "~/.ssh/id_rsa.pub"
}

variable "az_a" {
    type        = string
}

variable "az_b" {
    type        = string
}

variable "cidr_vpc" {
    type        = string
}

variable "public_subnet_a" {
    type        = string
}

variable "public_subnet_b" {
    type        = string
}