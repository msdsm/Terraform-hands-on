# Query data with outputs

## EC2作成
- 以前と同じように`variables.tf`, `main.tf`でEC2作成

## 値出力
- `outputs.tf`作成
```terraform
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.app_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}

```
- EC2のIDとpublicIPアドレスを出力しているようにしている
- `terraform applay`するとターミナルに以下のように出力される
```

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

instance_id = "i-0772257a24fe484d5"
instance_public_ip = "34.222.140.205"

```
## 削除
- `terraform destroy`実行すると以下のように出力される
```
Changes to Outputs:
  - instance_id        = "i-0772257a24fe484d5" -> null
  - instance_public_ip = "34.222.140.205" -> null
```