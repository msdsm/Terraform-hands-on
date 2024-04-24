# Create dynamic expressions

## メモ
### 3項演算子
- 普通のプログラミング言語のようにつかえる
```terraform
locals {
  name  = (var.name != "" ? var.name : random_id.id.hex)
}
```