# ------ Databases ------ #

resource "aws_db_instance" "aws_exam-terraform_db_a" {
    allocated_storage    = 10
    db_name              = "examTerraformDbA"
    engine               = "mysql"
    engine_version       = "5.7"
    instance_class       = "db.t3.micro"
    db_subnet_group_name = var.exam-terraform_db_subnet_group
    port                 = 3306
    skip_final_snapshot  = true
    password = var.db_password
    username = var.db_username
}

resource "aws_db_instance" "aws_exam-terraform_db_b" {
    allocated_storage    = 10
    db_name              = "examTerraformDbB"
    engine               = "mysql"
    engine_version       = "5.7"
    instance_class       = "db.t3.micro"
    db_subnet_group_name = var.exam-terraform_db_subnet_group
    port                 = 3306
    skip_final_snapshot  = true
    password = var.db_password
    username = var.db_username
}