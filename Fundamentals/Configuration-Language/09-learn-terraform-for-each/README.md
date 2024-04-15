# Manage similar resources with for each

## for_each
- varとして宣言したmapを参照する形で、for_eachを使うことでリソースを複数作成できる
```terraform
module "ec2_instances" {
  source     = "./modules/aws-instance"
  depends_on = [module.vpc]

  for_each = var.project

  instance_count     = each.value.instances_per_subnet * length(module.vpc[each.key].private_subnets)
  instance_type      = each.value.instance_type
  subnet_ids         = module.vpc[each.key].private_subnets[*]
  security_group_ids = [module.app_security_group[each.key].security_group_id]

  project_name = each.key
  environment  = each.value.environment
}

variable "project" {
  description = "Map of project names to configuration."
  type        = map(any)

  default = {
    client-webapp = {
      public_subnets_per_vpc  = 2,
      private_subnets_per_vpc = 2,
      instances_per_subnet    = 2,
      instance_type           = "t2.micro",
      environment             = "dev"
    },
    internal-webapp = {
      public_subnets_per_vpc  = 1,
      private_subnets_per_vpc = 1,
      instances_per_subnet    = 2,
      instance_type           = "t2.nano",
      environment             = "test"
    }
  }
}
```
- indexはeach.keyで取得
- mapのそれぞれの変数の値は、each.value."変数名"で取得

## for
- for inを使うことで以下のようにかける 
```terraform
output "public_dns_names" {
  description = "Public DNS names of the load balancers for each project."
  value       = { for p in sort(keys(var.project)) : p => module.elb_http[p].elb_dns_name }
}

output "vpc_arns" {
  description = "ARNs of the vpcs for each project."
  value       = { for p in sort(keys(var.project)) : p => module.vpc[p].vpc_arn }
}

output "instance_ids" {
  description = "IDs of EC2 instances."
  value       = { for p in sort(keys(var.project)) : p => module.ec2_instances[p].instance_ids }
}

```