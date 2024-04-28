# Use Configuration to move resources

## moved
- コードをリファクタしてmodule化したときなどのようにリソースの位置が移動するとterraformはその移動を認識できず移動前のものを削除して移動後のものを作成する
- そのため、rootにあるmain.tfでec2を作成していたものをmodules/ec2/main.tfに移動させてmodule化けした後にterraform applyすると以下のようになる
```
Plan: 1 to add, 0 to change, 1 to destroy.
```
- そこで移動をterraformに認識させるためにmovedを以下のようにrootのmain.tfで使う
```terraform
moved {
  from = aws_instance.example
  to   = module.ec2_instance.aws_instance.example
}
```
- こうすることでterraform planすると以下のようになる
```
Plan: 0 to add, 1 to change, 0 to destroy.
```
- またリソース名を変更するときにも使える
- "vpc"というリソース名を"learn_vpc"に変更したときに以下のように書ける
```terraform
moved {
  from = module.vpc
  to   = module.learn_vpc
}
```
- このように書いてrenameのためにterraform initしてterrqaform planすると以下
```
Plan: 0 to add, 0 to change, 0 to destroy.
```