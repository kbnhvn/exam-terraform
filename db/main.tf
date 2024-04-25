# ------ Import modules ------ #

module "networking" {
    source = "../networking"
    az_a = var.az_a
    az_b = var.az_b
}

# ------ Databases ------ #

resource "aws_db_instance" "aws_exam-terraform_db_a" {
    allocated_storage    = 10
    db_name              = "exam-terraform_db_a"
    engine               = "mysql"
    engine_version       = "5.7"
    instance_class       = "db.t3.micro"
    db_subnet_group_name = "${module.network.public_subnet_a.name}"
    port                 = 3306
    skip_final_snapshot  = true
    password = var.db_password
    username = var.db_username
}

resource "aws_db_instance" "aws_exam-terraform_db_b" {
    allocated_storage    = 10
    db_name              = "exam-terraform_db_b"
    engine               = "mysql"
    engine_version       = "5.7"
    instance_class       = "db.t3.micro"
    db_subnet_group_name = "${module.network.public_subnet_b.name}"
    port                 = 3306
    skip_final_snapshot  = true
    password = var.db_password
    username = var.db_username
}