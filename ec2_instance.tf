provider "aws" {   #credentials to get into aws
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.aws_region}"
  }

  resource "aws_security_group" "allow_10" {
    name        = "allow_10"
    description = "security group"

    ingress {
      from_port   = 22   #opening port 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
    }

    ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
    }

    ingress {
      from_port   = 443  #port 443 for redirection
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
    }

    tags {
        Name = "sec_group1"
      }

  }

resource "aws_instance" "sre_challenge" {
  count = 1
  ami = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  iam_instance_profile = "${var.iam_instance_profile}"
  key_name = "${var.aws_key_name}"
  availability_zone = "${var.availability_zone}"
  subnet_id = "${var.subnet_id}"
  security_groups = ["allow_10"]

  lifecycle {
   create_before_destroy = false
       }
       root_block_device {
       volume_type = "io1"
       volume_size = "${var.root_volume_size}"
       delete_on_termination = "true"
       iops = "${var.root_iops}"
         }
tags {
  "Name" = "${var.app_name}"
  "OwnerContact" = "${var.owner_contact}"
  "CMDBEnvironment" = "${var.CMDBEnvironment}"
  "OwnerID" = "${var.owner_id}"
  "Nodetype" = "${var.node_type}"
  "Application" = "${var.application}"
  "ASV" = "${var.application_asv}"
  "maid_downtime" = "${var.maid_downtime}"
  "downtime" = "${var.downtime}"
  "start_stop" = "{var.start_stop}"
  "firstRun" = "{var.firstRun}"
 }

}
