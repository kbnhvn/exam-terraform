# ------ Import modules ------ #

module "networking" {
    source = "../networking"
    az_a = var.az_a
    az_b = var.az_b
}

module "security" {
    source = "../security"
    az_a = var.az_a
    az_b = var.az_b
}

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
    subnet_id              = "${module.networking.app_subnet_a.id}"
    vpc_security_group_ids = ["${aws_security_group.sg_exam-terraform.id}"]
    key_name               = "${module.security_rules.key_name}"
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
    subnet_id              = "${module.networking.app_subnet_b.id}"
    vpc_security_group_ids = ["${aws_security_group.sg_exam-terraform.id}"]
    key_name               = "${module.security_rules.key_name}"
    user_data              = "${file("install_wordpress.sh")}"
    availability_zone      = var.az_b
    tags = {
        Name = "exam-terraform-b"
    }
}

# ------ EC2 Security groups ------ #

resource "aws_security_group" "sg_exam-terraform" {
    name   = "sg_exam-terraform"
    vpc_id = "${module.networking.cidr_vpc.id}"

    tags = {
        Name = "sg-exam-terraform"
    }
}

resource "aws_security_group_rule" "allow_all" {
    type              = "ingress"
    cidr_blocks       = ["10.0.128.0/20", "10.0.144.0/20"]
    to_port           = 0
    from_port         = 0
    protocol          = "-1"
    security_group_id = "${aws_security_group.sg_exam-terraform.id}"
}

resource "aws_security_group_rule" "outbound_allow_all" {
    type = "egress"
    cidr_blocks       = ["0.0.0.0/0"]
    to_port           = 0
    from_port         = 0
    protocol          = "-1"
    security_group_id = "${aws_security_group.sg_exam-terraform.id}"
}