# Lock and upgrade provider versions

## メモ
### providerのバージョンについて
- version指定で`>=`を使うとterraform initした際にその制約を満たす最新のバージョンになる
- 以下の場合4.5.0以上の最新バージョンになる(5.46.0になった)
```terraform
 aws = {
      source  = "hashicorp/aws"
      version = ">= 4.5.0"
    }
```
### .terraform.lock.hclファイルについて
- providerのバージョンを固定するファイル
- .terraform.lock.hclファイルがある状態でterraform initするとlockファイルに書かれているバージョンになる
  - 上述のように>=4.5.0という制約をつけていて、.terraform.lock.hclに4.5.1と書かれているなら4.5.1になる
  - 最新版にならない
- バージョンを制約を満たす中での最新版にしたい場合は、`terraform init -upgrade`を実行する