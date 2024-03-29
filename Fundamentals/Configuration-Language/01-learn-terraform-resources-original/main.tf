provider "aws" {
  profile = "msd_user"
  region  = "us-west-2"
}

resource "aws_instance" "myweb" {
  ami                    = "ami-0a70b9d193ae8a799"          # AMI ID
  instance_type          = "t2.micro"                       # インスタンスタイプ
  user_data              = file("init-script.sh")           # 最初に走らせるスクリプト
  vpc_security_group_ids = [aws_security_group.myweb-sg.id] # セキュリティグループ

  tags = {
    Name = "MyWebServerByTerraform"
  }
}
resource "aws_security_group" "myweb-sg" {
  name = "MyWebSgByTerraform"

  // インバウンドルール : HTTP許可
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //　インバウンドルール : SSH許可
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // アウトバウンドルール : 全部
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
