# ------ Data sources ------ #

data "aws_ami" "exam-terraform-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

###########################
# --------- EC2 --------- #
###########################

# ------ ZONE A ------ #

resource "aws_instance" "exam-terraform_a" {
    ami                    = data.aws_ami.exam-terraform-ami.id
    instance_type          = "t2.micro"
    subnet_id              = var.app_subnet_a
    vpc_security_group_ids = [var.sg_exam-terraform]
    key_name               = var.key_name
    user_data              = "${file("install_wordpress.sh")}"
    availability_zone      = var.az_a
    tags = {
        Name = "exam-terraform-a"
    }
}

# ------ ZONE B ------ #

resource "aws_instance" "exam-terraform_b" {
    ami                    = data.aws_ami.exam-terraform-ami.id
    instance_type          = "t2.micro"
    subnet_id              = var.app_subnet_b
    vpc_security_group_ids = [var.sg_exam-terraform]
    key_name               = var.key_name
    user_data              = "${file("install_wordpress.sh")}"
    availability_zone      = var.az_b
    tags = {
        Name = "exam-terraform-b"
    }
}
