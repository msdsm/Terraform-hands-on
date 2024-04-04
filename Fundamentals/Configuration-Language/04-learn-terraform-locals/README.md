# Simplify Terraform configuration with locals

## ファイル説明
- `terraform.tf`
- `main.tf`
  - VPC, セキュリティグループ, ロードバランサー, EC2作成
  - tagsで使用するvariableを使ってlocalsでname作成
- `variables.tf`
  - tagsで使用する変数宣言
- `outputs.tf`
  - ロードバランサーのドメイン名出力
  - tagsの値出力

## 自分用メモ

### localとvariableの違い
- https://qiita.com/hajimeni/items/4afcac38e4f275edb852
- https://www.guri2o1667.work/entry/2022/04/26/%E3%80%90Terraform%E3%80%91%EF%BC%88%E5%88%9D%E5%BF%83%E8%80%85%E5%90%91%E3%81%91%EF%BC%89locals%E3%81%A8variable%E3%81%AE%E4%BD%BF%E3%81%84%E5%88%86%E3%81%91%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6
- variableで変数を定義して、それらの変数を参照してまた別の変数の値を作り出すのがlocalというイメージ
  - variables.tfで変数envinronmentを定義してlocalsブロックで文字列を作成している
  - `terraform apply -var "environment=prod"`と実行すると変わる