packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  ami_name = "amazon-linux-2023-pre-baked-10"
  vpc_id = "" # MAIN VPC
  subnet_id = "" # Private Subnet in Main VPC
  source_ami_id = "ami-0b53285ea6c7a08a7" # Base AMI
  ami_owner = "amazon"
  ssh_username = "ec2-user"
  tags = {
    created_by = "packer"
    created_at = formatdate("YYYYMMDDhhmmss", timestamp())
  }
}

source "amazon-ebs" "amazon-linux" {
  ami_name      = local.ami_name
  instance_type = "t2.xlarge"
  region        = "eu-west-2"
  vpc_id = local.vpc_id
  subnet_id = local.subnet_id
  associate_public_ip_address = true
  source_ami = local.source_ami_id
  ssh_username = local.ssh_username
  tags = local.tags
}

build {
  name    = local.ami_name
  sources = [
    "source.amazon-ebs.amazon-linux"
  ]
  provisioner "shell" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y unzip",
      "sudo yum install -y ecs-init"
    ]
  }
  provisioner "shell" {
    inline = [
      "curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip'",
      "unzip awscliv2.zip",
      "sudo ./aws/install",
      "aws --version"
    ]
  }
}
