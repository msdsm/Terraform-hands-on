# Write Terraform Tests
## メモ
### test方法
- `terraform test`で実行
- `.tftest.hcl`をrootディレクトリか`tests`ディレクトリの中で探してくれる
- または`-test-directory`で終わるディレクトリでもよい
- testしたいことは`.tftest.hcl`にかく
- testの過程で必要になる新しいリソールなどを`tests/setup/main.tf`などに記述できる
  - これをhelper moduleと呼んでいる
- `.tftest.hcl`に以下のように書くことでhelper moduleを利用可能
```terraform
run "setup_tests" {
  module {
    source = "./tests/setup"
  }
}
```
### `.tftest.hcl`
- 以下のように`run`ブロックの中で複数の`assert`を定義できる
- `assert`の中は`check`や`precondition`などと同じく`condition`, `error_message`から成る
```terraform
# Apply run block to create the bucket
run "create_bucket" {
  variables {
    bucket_name = "${run.setup_tests.bucket_prefix}-aws-s3-website-test"
  }

  # Check that the bucket name is correct
  assert {
    condition     = aws_s3_bucket.s3_bucket.bucket == "${run.setup_tests.bucket_prefix}-aws-s3-website-test"
    error_message = "Invalid bucket name"
  }

  # Check index.html hash matches
  assert {
    condition     = aws_s3_object.index.etag == filemd5("./www/index.html")
    error_message = "Invalid eTag for index.html"
  }

  # Check error.html hash matches
  assert {
    condition     = aws_s3_object.error.etag == filemd5("./www/error.html")
    error_message = "Invalid eTag for error.html"
  }
}
```
- `terraform init`, `terraform test`の実行結果例
```
tests\website.tftest.hcl... in progress
  run "setup_tests"... pass
  run "create_bucket"... pass
tests\website.tftest.hcl... tearing down
tests\website.tftest.hcl... pass

Success! 2 passed, 0 failed.
```

### testの仕組み
- 以下の4つの処理から成る
  - テストファイルの検出
  - テストファイルに記載されているテスト用リソースの作成
  - 作成されたリソースに対して、テストファイルで指定した結果になっているかチェック
  - テスト用リソースの削除