# --------- Load Balancer --------- #

resource "aws_lb" "lb_exam-terraform" {
	name               = "exam-terraform-alb"
	internal           = false
	load_balancer_type = "application"
	subnets            = [var.app_subnet_a, var.app_subnet_b]
	security_groups    = ["${aws_security_group.sg_application_lb.id}"]

	enable_deletion_protection = false
}

resource "aws_lb_listener" "front_end" {
	load_balancer_arn = "${aws_lb.lb_exam-terraform.arn}"
	port              = "80"
	protocol          = "HTTP"

	default_action {
		type             = "forward"
		target_group_arn = "${aws_lb_target_group.exam-terraform_vms.arn}"
	}
}

resource "aws_lb_target_group" "exam-terraform_vms" {
	name     = "tf-exam-terraform-lb-tg"
	port     = 80
	protocol = "HTTP"
	vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "exam-terraforma_tg_attachment" {
	target_group_arn = "${aws_lb_target_group.exam-terraform_vms.arn}"
	target_id = var.exam-terraform_a
	port = 80
}

resource "aws_lb_target_group_attachment" "exam-terraformb_tg_attachment" {
	target_group_arn = "${aws_lb_target_group.exam-terraform_vms.arn}"
	target_id = var.exam-terraform_b
	port = 80
}

# --------- Load Balancer Security Group --------- #

resource "aws_security_group" "sg_application_lb" {

    name   = "sg_application_lb"
    vpc_id = var.vpc_id

    ingress {
        from_port = 80
        to_port   = 80
        protocol  = "tcp"
        cidr_blocks = ["10.0.128.0/20", "10.0.144.0/20"]
    }

    egress {
        from_port   = "0"
        to_port     = "0"
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "exam-terraform-alb"
    }
}