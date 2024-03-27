provider "aws" {
  profile = "msd_user"
  region  = "us-west-2"
}

provider "random" {}

resource "random_pet" "myname" {}

resource "aws_instance" "myweb" {
  ami                    = "ami-a0cfeed8"
  instance_type          = "t2.micro"
  user_data              = file("init-script.sh")
  vpc_security_group_ids = [aws_security_group.myweb-sg.id]

  tags = {
    Name = "myweb"
  }
}
resource "aws_security_group" "myweb-sg" {
  name = "myweb-sg"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

