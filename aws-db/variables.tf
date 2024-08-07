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
