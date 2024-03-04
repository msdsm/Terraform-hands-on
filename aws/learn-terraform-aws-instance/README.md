# AWS認証情報の設定およびEC2の構築

## 認証情報の設定
- AWS CLIをインストール
- `aws configure --profile [任意の名前]`
  - msd_userとした
  - access key, secret access key設定
- `cat ~/.aws/credentials`で確認
  - msd_userが作られていることを確認
## EC2構築
- `main.tf`作成
- AWS認証情報はproviderブロックの中に作成
```terraform
provider "aws" {
  profile = "msd_user" # 作成した名前
}
```
- `terraform fmt`でコード自動整形
  - VSCodeの拡張機能でも整形してくれる
- `terraform validate`で構文チェック
- `terraform plan`で設定ファイルとクラウド上のリソースを比較してどのリソースを追加・変更・削除するのか確認
- `terraform apply`実行してyesを入力してEnterで実行
- `terraform show`で適用済みの全リソースの情報を確認できる
- `terraform state list`でリソース名のみ確認できる