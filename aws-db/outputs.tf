Hes, [8/6/2024 11:53 PM]
variable "db_username" {
  description = "the username for the DB"
  type = string
  sensitive = true
}

variable "db_password" {
  description = "the password for the DB"
  type = string
  sensitive = true
}

Hes, [8/6/2024 11:54 PM]
output "address" {
  value       = aws_db_instance.mydb.address
  description = "Connect to the DB at this endpoint"
}

output "port" {
  value       = aws_db_instance.mydb.port
  description = "the port the DB is listening on"
}
