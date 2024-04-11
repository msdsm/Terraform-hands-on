# Manage similar resources with count

## count
- リソース内でcountを使うと複数個のリソースが作成できる
```terraform
count = var.instances_per_subnet * length(module.vpc.private_subnets)
```
- それぞれのリソースには0から始まるindexが与えられていて以下のようにアクセス可能
```terraform
  subnet_id              = module.vpc.private_subnets[count.index % length(module.vpc.private_subnets)]
```
- このとき、aws_instance.appなどは配列のようになっていてすべてのIDを取得したいときなどは以下のようにかける
```terraform
aws_instance.app.*.id
```
- 個数は以下
```terraform
length(aws_instance.app)
```