# --------- Import modules --------- #

module "networking" {
    source = "../networking"
    az_a = var.az_a
    az_b = var.az_b
}

# --------- Bastion Host --------- #

resource "aws_key_pair" "exam-terraform_key" {
	key_name   = "exam-terraform-key"
	public_key = file(var.public_key_path)
}

data "aws_ami" "exam-terraform-ami" {
    most_recent = true
    owners      = ["amazon"]

    filter {
        name    = "name"
        values  = ["amzn2-ami-hvm-*"]
    }
}

resource "aws_instance" "exam-terraform_bastion" {
    ami                    = data.aws_ami.exam-terraform-ami.id
    instance_type          = "t2.micro"
    subnet_id              = "${module.network.public_subnet_a.id}"
    vpc_security_group_ids = ["${aws_security_group.sg_22.id}"]
    key_name               = "${aws_key_pair.exam-terraform_key.key_name}"

    tags = {
        Name = "exam-terraform-bastion"
    }
}

# --------- Security Group Bastion Host --------- #

resource "aws_security_group" "sg_22" {

    name   = "sg_22"
    vpc_id = "${module.network.cidr_vpc.id}"

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["10.0.128.0/20", "10.0.144.0/20"]
    }

    egress {
        from_port   = "0"
        to_port     = "0"
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name        = "sg-22"
    }
}

# --------- Network ACL --------- #

resource "aws_network_acl" "exam-terraform_public_a" {
    vpc_id = "${module.network.cidr_vpc.id}"

    subnet_ids = ["${module.network.public_subnet_a.id}"]

    tags = {
        Name = "acl-exam-terraform-public-a"
    }
}

resource "aws_network_acl_rule" "nat_inbound_a" {
    network_acl_id = "${aws_network_acl.exam-terraform_public_a.id}"
    rule_number    = 200
    egress         = false
    protocol       = "-1"
    rule_action    = "allow"
    cidr_block = "10.0.128.0/20"
    from_port  = 0
    to_port    = 0
}

resource "aws_network_acl" "exam-terraform_public_b" {
    vpc_id = "${module.network.cidr_vpc.id}"

    subnet_ids = ["${module.network.public_subnet_b.id}"]

    tags = {
        Name = "acl-exam-terraform-public-b"
    }
}

resource "aws_network_acl_rule" "nat_inbound_b" {
    network_acl_id = "${aws_network_acl.exam-terraform_public_b.id}"
    rule_number    = 200
    egress         = true
    protocol       = "-1"
    rule_action    = "allow"
    cidr_block = "10.0.144.0/20"
    from_port  = 0
    to_port    = 0
}