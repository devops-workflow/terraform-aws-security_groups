/**
 * AWS Security Groups Terraform Module
 * =====================
 *
 * Creates basic security groups to be used by instances and ELBs.
 *
 * Usage:
 * ------
 *
 *     module "security_group" {
 *       source      = "../tf_security_groups"
 *
 *       add variables
 *     }
**/

# ecs cluster sg <- ecs lb & bastion
# ecs lb <- bastion & internet port
resource "aws_security_group" "internal_elb" {
  #name        = "${format("%s-%s-internal-elb", var.name, var.environment)}"
  name = "${var.namespaced ? format("%s-%s-internal-elb", var.environment, var.name) : format("%s-internal-elb", var.name)}"
  vpc_id      = "${var.vpc_id}"
  description = "Allows internal ELB traffic"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr}"]
    security_groups = ["${split(",", var.security_groups)}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = ["${split(",", var.security_groups)}"]
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = "${ merge(
    var.tags,
    map("Name", var.namespaced ?
     format("%s-%s-internal-elb", var.environment, var.name) :
     format("%s-internal-elb", var.name) ),
    map("Environment", var.environment),
    map("Terraform", "true") )}"
}

resource "aws_security_group" "external_elb" {
  #name        = "${format("%s-%s-external-elb", var.name, var.environment)}"
  name = "${var.namespaced ? format("%s-%s-external-elb", var.environment, var.name) : format("%s-external-elb", var.name)}"
  vpc_id      = "${var.vpc_id}"
  description = "Allows external ELB traffic"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = ["${split(",", var.security_groups)}"]
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = "${ merge(
    var.tags,
    map("Name", var.namespaced ?
     format("%s-%s-external-elb", var.environment, var.name) :
     format("%s-external-elb", var.name) ),
    map("Environment", var.environment),
    map("Terraform", "true") )}"
}
/*
# FIX: REMOVE change to only allow bastion
resource "aws_security_group" "external_ssh" {
  #name        = "${format("%s-%s-external-ssh", var.name, var.environment)}"
  name = "${var.namespaced ? format("%s-%s-external-ssh", var.environment, var.name) : format("%s-external-ssh", var.name)}"
  description = "Allows ssh from the world"
  vpc_id      = "${var.vpc_id}"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = "${ merge(
    var.tags,
    map("Name", var.namespaced ?
     format("%s-%s-external-ssh", var.environment, var.name) :
     format("%s-external-ssh", var.name) ),
    map("Environment", var.environment) )}"
}
*/
/*
# FIX: allow all internal networks & bastion
resource "aws_security_group" "internal_ssh" {
  #name        = "${format("%s-%s-internal-ssh", var.name, var.environment)}"
  name = "${var.namespaced ? format("%s-%s-internal-ssh", var.environment, var.name) : format("%s-internal-ssh", var.name)}"
  description = "Allows ssh from bastion"
  vpc_id      = "${var.vpc_id}"
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["192.168.0.0/16"]
    #security_groups = []
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr}"]
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = "${ merge(
    var.tags,
    map("Name", var.namespaced ?
     format("%s-%s-internal-ssh", var.environment, var.name) :
     format("%s-internal-ssh", var.name) ),
    map("Environment", var.environment) )}"
}
*/
