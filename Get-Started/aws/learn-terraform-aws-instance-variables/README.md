# 変数を使う


## 変数定義
- `variables.tf`作成して変数定義
```terraform
variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "ExamplAppServerInstance"
}
```
- 上の変数はstring型でEC2のタグの名前に使うようにしている

## EC2構築
- `main.tf`で変数を以下のように使う
```
resource "aws_instance" "app_server" {
  ami           = "ami-08d70e59c07c61a3a"
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
}
```
- `terraform plan`で1 to addを確認
- `terraform apply`で作成

## EC2の変更
- `terraform apply -var "instance_name=AnotherName"`実行
- 0 to add, 1 to change, 0 to destroyと表示される
- 既存のEC2の名前タグを変更するという内容が表示される
- yesを入力して実行すると実際に変更される