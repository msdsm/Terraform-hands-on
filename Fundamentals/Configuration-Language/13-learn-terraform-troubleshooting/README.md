# Troubleshoot Terraform

## メモ

### terraformの仕組みについて
- 4段階の処理からなる
  - HashiCorp Conriguration Language -> State -> Core Application -> Provider
- それぞれでLanguage errors, State errors, Core errors, Provider errorsがあり得る
#### Language errors
- syntax errorなどがこれに該当
- ファイルの行数がエラーメッセージとして出力される
- terraform fmtで検出できる
- vscode拡張機能が入っていれば、editor上で赤線がある
#### State erros
- stateが同期されていないなどの時におこる
#### Core errors
- バグ
- Githubでissue切るべき
#### Provider errors
- バグ
- Githubでissue切るべき

### Cycle error
- リソースが互いに依存しあっているときに起こる
  - つまり、リソースの依存グラフでループがあるとき
- terraform validateで検出できる