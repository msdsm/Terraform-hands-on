# Use checks to validate infrastructure


## メモ
### check
- 以下のように使える
```terraform
check "certificate" {
  assert {
    condition     = aws_acm_certificate.cert.status == "ERRORED"
    error_message = "Certificate status is ${aws_acm_certificate.cert.status}"
  }
}
```
- checkブロックは1つ以上のassertから構成されて、assertはpreconditoinやpostconditionと同じくconditonとerror_messageから構成される
  - conditionの条件式がtrueならそのまま進み、falseならerror_messageに与えた文字列が出力される
- 実際の出力例が以下
```
Plan: 1 to add, 1 to change, 1 to destroy.
╷
│ Warning: Check block assertion failed
│
│   on main.tf line 169, in check "certificate":
│  169:     condition     = aws_acm_certificate.cert.status == "ERRORED"
│     ├────────────────
│     │ aws_acm_certificate.cert.status is "ISSUED"
│
│ Certificate status is ISSUED
╵

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: 
```
- variableのvalidationやlifecycleのconditionと違う点は、上記のように実行が止まらないという点
- checkブロックのconditionがfalseだとしても、warningとしてメッセージを出力して実行はとまらない
  - preconditionとかは実行が強制終了する
- そのため、プログラマーがwarningをみてyesかnoか判断することができる
- また、checkブロックの中でdataブロックも使うことができる
```terraform
check "response" {
  data "http" "terramino" {
    url      = "https://${aws_lb.terramino.dns_name}"
    insecure = true
  }

  assert {
    condition     = data.http.terramino.status_code == 200
    error_message = "Terramino response is ${data.http.terramino.status_code}"
  }
}
```