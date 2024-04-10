# Create resource dependencies

## 概要
- terraformは依存関係を推論してくれるから正しい順序でapplyやdestroyができる
- けど依存関係を正しく推論できないときがあり、そのようなときは自分で明示的に依存関係を示す必要がある
- 実際に今回のソースコードのように依存関係を明示せずにec2を2つとelasticIPの紐づけをapplyすると、2つのec2は同時に作成されて、それが終わり次第eipが実行されるようになっている。これはterraformが依存関係を推論してくれているからである

## 自分用メモ

### `depends_on`
- resource内でdepends_onに指定したリソースがcompleteになるまで実行をまつ
- 以下の例だと、s3,ec2の実行が終わるまでsqsは実行されない
```terraform
module "example_sqs_queue" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "3.3.0"

  depends_on = [aws_s3_bucket.example, aws_instance.example_c]
}
```