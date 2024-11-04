variable "config" {
  type = any
}

variable "oidc" {
  type = object({
    client_id     = string
    client_secret = string
    discovery_url = string
    discovery_ca_file_path = string
  })
}
