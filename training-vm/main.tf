variable "training_ssh_key_path" {}
variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}
variable "instance_govuk-training_name" {
  default = "govuk-training"
}

provider "aws" {
  region     = "eu-west-1"
  access_key = "${var.aws_access_key_id}"
  secret_key = "${var.aws_secret_access_key}"
}

data "terraform_remote_state" "govuk-training_vpc" {
  backend = "s3"
  config {
    bucket = "govuk-terraform-state-integration"
    key    = "terraform-training-environment.tfstate"
    region = "eu-west-1"
  }
}

resource "aws_instance" "govuk-training" {
  ami                    = "ami-a192bad2"
  instance_type          = "t2.xlarge"
  key_name               = "govuk-training-integration"
  vpc_security_group_ids = ["${data.terraform_remote_state.govuk-training_vpc.public_security_group_ids}"]
  subnet_id              = "${data.terraform_remote_state.govuk-training_vpc.public_subnet_ids}"
  iam_instance_profile   = "${data.terraform_remote_state.govuk-training_vpc.govuk-training_instance_profile}"
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 100
    delete_on_termination = true
  }
  user_data              = "${file("training_user_data.txt")}"
  tags {
    Name = "${var.instance_govuk-training_name}"
  }
  provisioner "file" {
    source      = "provisioner"
    destination = "/home/ubuntu"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.training_ssh_key_path)}"
    }
  }
}

output "ip" {
  value = "${aws_instance.govuk-training.public_dns}"
}
