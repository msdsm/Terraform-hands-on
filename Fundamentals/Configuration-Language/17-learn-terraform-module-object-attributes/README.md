# Customize modules with object attributes
- outputのendpointにアクセスするとテトリスできる
- ちなみにTスピンできる

## メモ
### object
- 以下のようにobject定義できる
```terraform
variable "files" {
  description = "Configuration for website files."
  type = object({
    terraform_managed     = bool
    error_document_key    = optional(string, "error,html")
    index_document_suffix = optional(string, "index.html")
    www_path              = optional(string)
  })
}
```
- `key名 = 型`という形でobjectの中身を定義できる
- 右辺に型のみ記述されているものは必須のもので、optionalは任意
- optional(型、デフォルト値)のように使える
- optional(型)と記述した場合はデフォルト値はnullになる
- 呼び出し方法は以下
```terraform
module "website_s3_bucket" {
  source = "./modules/aws-s3-static-website"

  bucket_prefix = "module-object-attributes-"

  files = {
    terraform_managed = true # これは必須
    www_path          = "${path.root}/www" # これ任意
  }
}
```
