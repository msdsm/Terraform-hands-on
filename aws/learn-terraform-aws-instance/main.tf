terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  profile = "msd_user"
  region  = "us-west-2"
}

resource "aws_instance" "app_server" {
  # ami           = "ami-830c94e3"
  ami           = "ami-08d70e59c07c61a3a" # amiの変更
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance2"
  }
}
