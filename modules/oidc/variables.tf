variable "config" {
  type = any
}

variable "group_name_to_id" {
  type = map(string)
}

variable "vault_addr" {
  type = string
}
