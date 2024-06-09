# Build and use a local module
## 自分用メモ
### module作り方
- `README.md`と`LICENSE`ファイルは作らなくても動くが、作ることがベストプラクティスとされている
- `main.tf`, `variables.tf`, `outputs.tf`を作成する必要がある
- `main.tf`にProviderブロックを書く必要はない
- `variables.tf`で宣言されるvariableはdefault値を設定しておく必要はないため、呼び出し側が必ず値を設定しないといけない
  - このvariableが呼び出し側から見ると入力のようにふるまう
- `outputs.tf`のoutputは呼び出し側が取得できる唯一の情報となる
  - 利用方法は`module.<MODULE NAME>.<OUTPUT NAME>`となる
  - read-onlyである

### module変更後
- moduleのソースコードを変更したあとは、`terraform init`または`terraform get`をたたいてからapplyを実行
### AWS CLIでs3のファイル操作
- s3にファイルをアップロードするときは以下のコマンド
- `aws s3 cp modules/aws-s3-static-website-bucket/www/ s3://$(terraform output -raw website_bucket_name)/ --recursive --profile msd_user`
- 削除するときは以下のコマンド
- `aws s3 rm s3://$(terraform output -raw website_bucket_name)/ --recursive --profile msd_user`
### エラー対処
- S3の仕様変更によりソースコードそのまま使っても動かない
- 以下を参考に修正した
- https://github.com/hashicorp/learn-terraform-modules-create/pull/12/commits/ae0b04690d04127427c30dfe52432b33316e00c3