# Terraformインストール、nginx構築

## Terraformインストール
- mac
  - tfenvでインストールするとバージョン管理が楽
- windows
  - 公式サイトからバッチファイルダウンロードする、C:/Windowsとかに置く
## nginx構築
- Docker起動
  - コマンド or Docker Desktop起動
- main.tf作成
- プロジェクト初期化
  - `terraform ini`
- NGINXサーバーコンテナをprovision
  - `terraform apply`
- 起動したか確認
  - `docker ps`またはlocalhost:8000にアクセス
- コンテナ停止
  - `terraform destroy`