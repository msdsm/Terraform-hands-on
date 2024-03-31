/*
// sensitiveなvariableに参照するとエラーになることを確認
output "db_connect_string" {
  description = "MySQL database connection string"
  value       = "Server=${aws_db_instance.database.address}; Database=ExampleDB; Uid=${var.db_username}; Pwd=${var.db_password}"
}
*/

output "db_connect_string" {
  description = "MySQL database connection string"
  value       = "Server=${aws_db_instance.database.address}; Database=ExampleDB; Uid=${var.db_username}; Pwd=${var.db_password}"
  sensitive   = true
}
