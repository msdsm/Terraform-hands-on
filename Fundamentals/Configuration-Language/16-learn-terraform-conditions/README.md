# Validate modules with custom conditions


## メモ
### precondition
- preconditionが含まれるブロックのリソースがapplyされる前に評価される
### postcondition
- postconditionが含まれるブロックのリソースがapplyされた直後、次のリソースがapplyされる前に評価される
### lifecycle
- 以下のように条件式とエラー時の文字列を与える(両方必須)
```terraform
resource "aws_instance" "app" {
  count = var.aws_instance_count

  instance_type = var.aws_instance_type
  ami           = var.aws_ami_id

  subnet_id              = var.aws_private_subnet_ids[count.index % length(var.aws_private_subnet_ids)]
  vpc_security_group_ids = [module.app_security_group.security_group_id]

  # 追加
  lifecycle {
    precondition {
      condition     = var.aws_instance_count % length(var.aws_private_subnet_ids) == 0
      error_message = "The number of instances (${var.aws_instance_count}) must be evenly divisible by the number of private subnets (${length(var.aws_private_subnet_ids)})."
    }
    precondition {
      condition     = data.aws_ec2_instance_type.app.ebs_optimized_support != "unsupported"
      error_message = "The EC2 instance type (${var.aws_instance_type}) must support EBS optimization."
    }
  }
}
```
- lifecycleの中で複数のpreconditionが使える
- preconditionの場合は、aws_instance.appがapplyされる前に実行される
- 条件式(condition)がTrueの場合は次に進んでapplyされて、Falseの場合はerror_messageが出力されて実行は終了する
  - ここでいう実行はapplyとplan両方のこと
- 以下、terraform planでconditionを満たさないときの出力例
```
#...
╷
│ Error: Resource precondition failed
│
│   on modules/example-app-deployment/main.tf line 93, in resource "aws_instance" "app":
│   93:       condition     = var.aws_instance_count % length(var.aws_private_subnet_ids) == 0
│     ├────────────────
│     │ var.aws_instance_count is 3
│     │ var.aws_private_subnet_ids is list of string with 2 elements
│
│ The number of instances (3) must be evenly divisible by the number of private
│ subnets (2).
╵

#...

╷
│ Error: Resource precondition failed
│
│   on modules/example-app-deployment/main.tf line 98, in resource "aws_instance" "app":
│   98:       condition     = data.aws_ec2_instance_type.app.ebs_optimized_support != "unsupported"
│     ├────────────────
│     │ data.aws_ec2_instance_type.app.ebs_optimized_support is "unsupported"
│
│ The EC2 instance type (t2.micro) must support EBS optimization.
╵
```
- postconditionについても同じようにかける
- ただし以下の場合は、planではerrorキャッチできずapply時にキャッチする
```terraform
data "aws_vpc" "app" {
  id = var.aws_vpc_id

  lifecycle {
    postcondition {
      condition     = self.enable_dns_support == true
      error_message = "The selected VPC must have DNS support enabled."
    }
  }
}
```

### 雑メモ
- assertやtry catchに似ている
- 例外処理みたいなことができてうれしいという気持ち
- dataが見つかっていないまま進むとどこかでバグりそうだから、見つかっていない場合に次に進まずに実行終了できるから安全という話かも