# Use registry modules in configuration

## ファイル説明
- `terraform.tf`
- `main.tf`
  - VPC, EC2のmoduleを使用
- `variables.tf`
  - VPC, EC2モジュールで使う引数の値を変数化
- `outputs.tf`
  - EC2のpublic IPアドレスとsubnetの情報

## 自分用メモ
### moduleのdocument
- VPC
  - https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/3.14.0?tab=inputs&product_intent=terraform
  - 下のinputsに引数の情報がある
- EC2
  - https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/3.5.0?tab=inputs&product_intent=terraform