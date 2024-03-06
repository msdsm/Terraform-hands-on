# Terraform Cloud

## 概要
- Terraform Cloudにtfstateファイルを置くという話

## EC2構築
- いつも通りmain.tf
## Terraform Cloudアカウント作成
- GUIで作成
- organization作成

## Terraform Cloudのset up
- main.tfに以下追記
```terraform
terraform {
  cloud {
    organization = "organization-name" # 自分で作った名前
    workspaces {
      name = "learn-tfc-aws"
    }
  }
}
```

## WorkSpace variablesの設定
- workspaceのvariableにいってAWSのアクセスキーとシークレットアクセスキー設定
  - 必ずsensitiveにチェックを入れる
- `terraform apply`実行
- そうすると以下のエラーが出て詰まった
```
$ terraform apply
Running apply in Terraform Cloud. Output will stream here. Pressing Ctrl-C
will cancel the remote apply if it's still pending. If the apply started it
will stop streaming the logs, but will not stop the apply running remotely.

Preparing the remote apply...

To view this run in a browser, visit:
https://app.terraform.io/app/msd_organization/learn-tfc-aws/runs/run-9S2x6XhTVghgDcMf

Waiting for the plan to start...

Terraform v1.7.4
on linux_amd64
Initializing plugins and modules...
╷
│ Warning: Value for undeclared variable
│
│ The root module does not declare a variable named "AWS_ACCESS_KEY_ID" but a
│ value was found in file
│ "/home/tfc-agent/.tfc-agent/component/terraform/runs/run-9S2x6XhTVghgDcMf/terraform.tfvars".
│ If you meant to use this value, add a "variable" block to the
│ configuration.
│
│ To silence these warnings, use TF_VAR_... environment variables to provide
│ certain "global" settings to all configurations in your organization. To
│ reduce the verbosity of these warnings, use the -compact-warnings option.
╵
╷
│ Warning: Value for undeclared variable
│
│ The root module does not declare a variable named "AWS_SECRET_ACCESS_KEY"
│ but a value was found in file
│ "/home/tfc-agent/.tfc-agent/component/terraform/runs/run-9S2x6XhTVghgDcMf/terraform.tfvars".
│ If you meant to use this value, add a "variable" block to the
│ configuration.
│
│ To silence these warnings, use TF_VAR_... environment variables to provide
│ certain "global" settings to all configurations in your organization. To
│ reduce the verbosity of these warnings, use the -compact-warnings option.
╵
╷
│ Error: configuring Terraform AWS Provider: failed to get shared config profile, msd_user
│
│   with provider["registry.terraform.io/hashicorp/aws"],
│   on main.tf line 18, in provider "aws":
│   18: provider "aws" {
│
╵
Operation failed: failed running terraform plan (exit 1)

```

## Login
- `terraform login`でログイン
- `terraform init`で設定更新
- tfstateファイルがterraform cloud上で管理されるようになった
- `rm terraform.tfstate`で削除

## Terraform Cloudについて
- `terraform apply`をローカルマシンで実行すると、ローカルマシン上のtfファイルを参照
- それをもとにterraform cloud上のtfstateファイルが変更される
- その結果インフラ変わる