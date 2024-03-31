# Protect sensitive input variables

## ファイル説明

## 自分用メモ
### sensitive
- variableで値をCLI上で出力させたくないときに使う
  - passwordとか
- 以下のように使う
```terraform
variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true // これ追記
}
```
- こうするとterraform applyやterraform outputするときに表示されない
- 値の設定方法としては、.tfvarsファイルを作成してそこで以下のように記述
```terraform
db_username = "admin"
db_password = "insecurepassword"
```
- .gitignoreで.tfvarsを無視するようにすればよい(今回は勉強のためやらずに、tfvarsもpushしてるけど)
- `terraform apply -var-file="secret.tfvars"`

### sensitiveに対するoutput
- outputで以下のようにsensitiveなvariableを参照するとエラーになる
```terraform
// sensitiveなvariableに参照するとエラーになることを確認
output "db_connect_string" {
  description = "MySQL database connection string"
  value       = "Server=${aws_db_instance.database.address}; Database=ExampleDB; Uid=${var.db_username}; Pwd=${var.db_password}"
}
```
```
│ Error: Output refers to sensitive values
│
│   on outputs.tf line 3:
│    3: output "db_connect_string" {
│
│ To reduce the risk of accidentally exporting sensitive data that was
│ intended to be only internal, Terraform requires that any root module
│ output containing sensitive data be explicitly marked as sensitive, to
│ confirm your intent.
│
│ If you do intend to export this data, annotate the output value as
│ sensitive by adding the following argument:
│     sensitive = true
```
- outputを以下のように変更するとエラーにならずに以下のように出力される
```terraform
output "db_connect_string" {
  description = "MySQL database connection string"
  value       = "Server=${aws_db_instance.database.address}; Database=ExampleDB; Uid=${var.db_username}; Pwd=${var.db_password}"
  sensitive   = true // 追加
}
```
```
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

db_connect_string = <sensitive>
```