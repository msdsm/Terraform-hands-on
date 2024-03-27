# Define infrastructure with Terraform resources
- 以下のgithubをcloneするとテトリスできるというもの
  - https://github.com/hashicorp/learn-terraform-resources/tree/main?tab=MPL-2.0-1-ov-file
- 動画に従ってcloneしてからsegrity_groupのingress,egress書いたらできた
## ファイル説明
- `terraform.tf`
  - terraformブロックを持つ
  - ここで必要なプロバイダーを定義
    - aws
    - random
- `main.tf`
  - EC2作成
  - インスタンスユーザーデータとしてshファイル与える
- `init-script.sh`
  - インスタンスユーザーデータ
  - EC2初回起動時に実行されるスクリプト
  
## 自分用メモ
### random_pet
- 公式document
  - https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet
- ユニークなidをランダムに生成するぽい


### aws_instanceのuser_data
- インスタンスユーザーデータ
  - EC2インスタンスが初回に実行するスクリプトのことを指す
  - 初回起動時だけ実行される
  - https://qiita.com/miyuki_samitani/items/d1078feda3c4748b4756
- terraform aws_instance公式ドキュメント
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
  - 下の方にuser_dataの説明あり
  - user_data - (Optional) User data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user_data_base64 instead. Updates to this field will trigger a stop/start of the EC2 instance by default. If the user_data_replace_on_change is set then updates to this field will trigger a destroy and recreate.
### aws_instance.(命名したid名).public_dns
- aws_instance公式ドキュメント
- public_dns - Public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC.

### aws_security_group
- 公式ドキュメント
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
- ingress,egressは普通に存在する英単語
