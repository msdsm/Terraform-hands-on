# EC2を立ててユーザーデータでapacheをインストールしてwebサイト構築
- ec2を立てたときにshファイルをユーザーデータに渡してapacheをインストール

## ファイル説明
- `terraform.tf`
  - terraformブロックを持つ
  - ここで必要なプロバイダーを定義
    - aws
- `main.tf`
  - EC2作成
  - インスタンスユーザーデータとしてshファイル与える
- `outputs.tf`
  - ページのURL出力
- `init-script.sh`
  - インスタンスユーザーデータ
  - EC2初回起動時に実行されるスクリプト
  - apacheのインストールとwebページの構築

## 実行方法
- main.tfでprofileにユーザー名設定
- `terraform init`
- `terraform apply`
- URLにアクセス
  - コンソール画面でステータスチェックがokになるまで待つ必要がある
  - 数分かかる
