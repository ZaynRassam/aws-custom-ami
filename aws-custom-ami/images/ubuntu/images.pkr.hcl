packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "ubuntu-pre-baked-2"
  instance_type = "t2.micro"
  region        = "eu-west-2"
  vpc_id = "vpc-02a56dfbdb96df968"
  subnet_id = "subnet-058e570f02fea911a"
  associate_public_ip_address = true
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name    = "ubuntu-pre-baked-2"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y unzip",
      "sudo apt-get install cloud-guest-utils"
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
