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
- EC2の部分は以下
  - IDは`aws_instance.app_server`となる
  - `resource サービス名 変数名`
  - tagsでNameを指定するとAWSコンソール画面でec2を一覧表示したときに一番左にあるカラム(Name)に入る
```terraform
resource "aws_instance" "app_server" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}
```
- `terraform fmt`でコード自動整形
  - VSCodeの拡張機能でも整形してくれる
- `terraform validate`で構文チェック
- `terraform plan`で設定ファイルとクラウド上のリソースを比較してどのリソースを追加・変更・削除するのか確認
- `terraform apply`実行してyesを入力してEnterで実行
- `terraform show`で適用済みの全リソースの情報を確認できる
- `terraform state list`でリソース名のみ確認できる
- 実際にAWSコンソール画面でec2が作成されていることを確認

## EC2変更
- `main.tf`で以下のようにamiを変更
```terraform
 resource "aws_instance" "app_server" {
-  ami           = "ami-830c94e3"
+  ami           = "ami-08d70e59c07c61a3a"
   instance_type = "t2.micro"
 }
```
- `terraform plan`で確認
  - 1 to add, 1 to destoryと表示される
  - 既存のaws_instance.app_serverを削除して新しく作るという意味
- `terraform apply`で実行
## リソース削除
- `terraform destroy`で管理しているリソースすべて削除する
- 1 to destroyと表示されてec2のaws_instance.app_serverが削除される
- コンソールを見ると、インスタンスの状態が終了済みになっていた