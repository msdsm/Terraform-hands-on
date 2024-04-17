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