# Perform dynamic operations with functions
- ソースコードのままだと動かない
- 以下のissue参考にmain.tfでAMIのフィルタリングを変更すると動く
- https://github.com/hashicorp/learn-terraform-functions/issues/12

## templatefile function
- EC2に与えるユーザーデータファイルをshファイルではなくtftplファイルにする
- tftplファイルで"${department}"のように変数を使える
```shell
sudo groupadd -r ${department}
sudo useradd -m -s /bin/bash ${name}
sudo usermod -a -G ${department} ${name}
sudo cp /etc/sudoers /etc/sudoers.orig
echo "${name} ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/${name}
```
- variables.tfで以下のように変数宣言
```terraform
variable "user_name" {
  description = "The user creating this infrastructure"
  default     = "terraform"
}

variable "user_department" {
  description = "The organization the user belongs to: dev, prod, qa"
  default     = "learn"
}
```
- main.tfで以下のようにtemplatefileファンクションを呼び出す
```terraform
user_data = templatefile("user_data.tftpl", { department = var.user_department, name = var.user_name })
```
- 第一引数にユーザーデータファイル、第二引数にユーザーデータファイルに渡す変数のオブジェクト
- この変数を渡すときにvariableを参照できるから便利

## lookup function
- 指定されたキーに対応するマップの値を返す
  - lookup(map, key, [default])
- キーがマップに存在しない場合オプションで指定されたデフォルト値を返す
- デフォルト値が指定されておらず、キーが存在しない場合にエラーが発生する
```terraform
variable "example_map" {
  default = {
    "a" = "apple"
    "b" = "banana"
    "c" = "cherry"
  }
}

output "example_lookup" {
  value = lookup(var.example_map, "b", "default_value")
}
```
- 今回のリソースでは以下のようにAMIで使用
```terraform
variable "aws_amis" {
  type = map
  default = {
    "us-east-1" = "ami-0739f8cdb239fe9ae"
    "us-west-2" = "ami-008b09448b998a562"
    "us-east-2" = "ami-0ebc8f6f580a04647"
  }
}

resource "aws_instance" "web" {
  // ami                         = data.aws_ami.ubuntu.id
  ami                         = lookup(var.aws_amis, var.aws_region)
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnet_public.id
  vpc_security_group_ids      = [aws_security_group.sg_8080.id]
  associate_public_ip_address = true
}
```

## file function
- ファイル読み込み

## EC2接続でkeypair指定方法
- security groupで22あける
- ssh-keygenコマンドでsshキー作成
- aws_key_pairリソースで公開鍵ファイル読み込み
```terraform
resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = file("ssh_key.pub")
}
```
- aws_instanceリソースでkey_nameという引数にaws_key_pairリソースで指定した名前渡す
```terraform
resource "aws_instance" "web" {
  // ami                         = data.aws_ami.ubuntu.id
  ami                         = lookup(var.aws_amis, var.aws_region)
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnet_public.id
  vpc_security_group_ids      = [aws_security_group.sg_8080.id, aws_security_group.sg_22.id]
  associate_public_ip_address = true
  user_data                   = templatefile("user_data.tftpl", { department = var.user_department, name = var.user_name })
  key_name                    = aws_key_pair.ssh_key.key_name # これ
}
```
- ssh接続時に秘密鍵ファイルへのパス指定
- `ssh ubuntu@$(terraform output -raw web_public_ip) -i ssh_key`