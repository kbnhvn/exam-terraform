terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = var.provider_region
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
}

module "ec2" {
    source = "./ec2"
    az_a   = var.az_a
    az_b   = var.az_b
    app_subnet_a = module.networking.app_subnet_a
    app_subnet_b = module.networking.app_subnet_b
    sg_exam-terraform = module.security.sg_exam-terraform
    key_name = module.security.key_name

}

module "networking" {
    source = "./networking"
    az_a   = var.az_a
    az_b   = var.az_b
}

module "security" {
    source = "./security"
    az_a   = var.az_a
    az_b   = var.az_b
    cidr_vpc = module.networking.cidr_vpc
    public_subnet_a = module.networking.public_subnet_a
    public_subnet_b = module.networking.public_subnet_b
}

module "loadbalancer" {
    source = "./loadbalancer"
    az_a   = var.az_a
    az_b   = var.az_b
    vpc_id = module.networking.vpc_id
    app_subnet_a = module.networking.app_subnet_a
    app_subnet_b = module.networking.app_subnet_b
    exam-terraform_a = module.ec2.exam-terraform_a
    exam-terraform_b = module.ec2.exam-terraform_b
}

module "db" {
    source = "./db"
    db_password = var.db_password
    db_username = var.db_username
    exam-terraform_db_subnet_group = module.networking.exam-terraform_db_subnet_group
    az_a   = var.az_a
    az_b   = var.az_b
}