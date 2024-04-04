# Output data from Terraform

## 自分用メモ

### modulesのoutputについて
- modulesを自作した際に、呼び出し側のoutputで参照したいものをoutputs.tfでoutputブロックで宣言する
```terraform
output "instance_ids" {
  description = "IDs of EC2 instances"
  value       = aws_instance.app.*.id
}
```
- こうすることでmoduleの呼び出し側で以下のようにoutputできる
```terraform
output "web_server_count" {
  description = "Number of web servers provisioned"
  value       = length(module.ec2_instances.instance_ids)
}
```
- module.{moduleを呼び出す際に定義した名前}.{moduleの中のoutputs.tfで宣言されている名前}

### outputコマンド
- ターミナルから`terraform output`でoutputの内容すべて表示
- `terraform output 名前`でそれだけ表示可能
  - `terraform output lb_url`など
- `terraform output -raw lb_url`とするとstring型の際に出力される""を出力させなくできる
```
$ terraform output lb_url
"http://lb-uFE-project-alpha-dev-219190705.us-east-1.elb.amazonaws.com/"
$ terraform output -raw lb_url
http://lb-uFE-project-alpha-dev-219190705.us-east-1.elb.amazonaws.com/
```
- rawの使用例としてはcurlでたたくときなど
```
$ curl $(terraform output -raw lb_url)
<html><body><div>Hello, world!</div></body></html>
```

### sensitive
- outputにsensitive=trueをつけるとapply時にsensitiveと出力されて隠される
- コマンドでterraform outputとたたいた時も同様
- terraform output db_passwordのように名前を指定すると出力されてしまう

### outputのjson
- `terraform output -json`とたたくとjson形式で出力される
```
{
  "db_password": {
    "sensitive": true,
    "type": "string",
    "value": "notasecurepassword"
  },
  "db_username": {
    "sensitive": true,
    "type": "string",
    "value": "admin"
  },
  "lb_url": {
    "sensitive": false,
    "type": "string",
    "value": "http://lb-uFE-project-alpha-dev-219190705.us-east-1.elb.amazonaws.com/"
  },
  "vpc_id": {
    "sensitive": false,
    "type": "string",
    "value": "vpc-02e8b1e59a3279282"
  },
  "web_server_count": {
    "sensitive": false,
    "type": "number",
    "value": 4
  }
}
```
- ここでもsensitive=trueにしたdb_usernameやdb_passwordが出力されてしまう