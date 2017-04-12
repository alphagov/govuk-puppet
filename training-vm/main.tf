variable "training_ssh_key_path" {}
variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}

provider "aws" {
  region     = "eu-west-1"
  access_key = "${var.aws_access_key_id}"
  secret_key = "${var.aws_secret_access_key}"
}

resource "aws_instance" "govuk-training" {
  ami                    = "ami-a192bad2"
  instance_type          = "t2.xlarge"
  key_name               = "govuk-training-integration"
  vpc_security_group_ids = ["sg-805389f9"]
  subnet_id              = "subnet-74dbee10"
  iam_instance_profile   = "govuk-training"
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 100
    delete_on_termination = true
  }
  user_data              = "${file("training_user_data.txt")}"
  tags {
    Name = "govuk-training"
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
