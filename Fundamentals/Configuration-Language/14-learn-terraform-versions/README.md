# Manage Terraform versions

## メモ

### セマンティックバージョニング
- major.minor.patch
```terraform
required_version = "~> 0.12.29"
```
- ~>はmajor versionとminor versionを固定してパッチバージョン以上のものを指定
  - この例の場合は、0.12が固定でパッチバージョン29以上
    - 0.12.30, 0.12.31などがok
    - 0.13.1, 1.12.1などng
### 現在使用しているterraformのバージョン確認
- `terraform version`で可能

### 現在のプロジェクトのバージョン確認
- initの後に作成される`terraform.tfstate`にversionある
```terraform
"terraform_version": "1.7.4",
```

