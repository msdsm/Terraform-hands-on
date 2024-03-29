# Customize Terraform configuration with variables

## ファイル説明

## 自分用メモ
### terraform console
- `terraform console`でインタラクティブモードに入れる
- 以下その例
```
$ terraform console
> var.private_subnet_cidr_blocks
tolist([
  "10.0.101.0/24",
  "10.0.102.0/24",
  "10.0.103.0/24",
  "10.0.104.0/24",
  "10.0.105.0/24",
  "10.0.106.0/24",
  "10.0.107.0/24",
  "10.0.108.0/24",
])
> var.private_subnet_cidr_blocks[1]
"10.0.102.0/24"
> slice(var.private_subnet_cidr_blocks, 0, 3)
tolist([
  "10.0.101.0/24",
  "10.0.102.0/24",
  "10.0.103.0/24",
])
> exit
```

### variable
- typeとして、string, number, bool, list, map, setなどがある

### slice
- slice(list変数, l, r)でlistの半開区間[l, r)を取得できる
- 上のterraform consoleの出力例にある
- variables.tfで以下のように使用
```terraform
private_subnets = slice(var.private_subnet_cidr_blocks, 0, var.private_subnet_count)
public_subnets  = slice(var.public_subnet_cidr_blocks, 0, var.public_subnet_count)
```

### map
- variables.tfで以下のように使用
```terraform
variable "resource_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
  default = {
    project     = "project-alpha"
    environment = "dev"
  }
}
```
- 呼び出し方法は以下
```
$ terraform console
> var.resource_tags["environment"]
"dev"
> var.resource_tags["project"]
"project-alpha"
> exit
```

### 変数代入法
- variableでdefault valueを指定していない場合は、-varコマンドで指定するかtfvarsファイルで指定する
#### コマンド方法
- `terraform apply -var ec2_instance_type=t2.micro`

#### ファイルの方法
- terraform.tfvarsを以下のように作成
```
resource_tags = {
  project    = "project-alpha"
  environent = "dev"
}

ec2_instance_type = "t3.micro"

instance_count = 3
```
- `terraform apply`する

### 文字列に変数を入れる
- "文字列${変数名}文字列"
- 以下例
```terraform
name = "lb-${random_string.lb_id.result}-${var.resource_tags["project"]}-${var.resource_tags["environment"]}"
```

### validateion
- variableの中にvalidationを定義できる
- 以下、例
```terraform
```
- regexall()は正規表現を使って対象文字列から正規表現と一致する部分列を持ってくる
- 今回は英数字とハイフン以外の文字が対象文字列にあるかどうかチェックしている
- 以下のように実行すると正しくvalidationにはじかれる
`terraform apply -var='resource_tags={project="my-project",environment="development"}'`
Planning failed. Terraform encountered an error while generating this plan
╷
│ Error: Invalid value for variable
│
│   on variables.tf line 75:
│   75: variable "resource_tags" {
│     ├────────────────
│     │ var.resource_tags["environment"] is "development"
│
│ The environment tag must be no more than 8 characters, and only contain letters, numbers, and hyphens.
│
│ This was checked by the validation rule at variables.tf:88,3-1