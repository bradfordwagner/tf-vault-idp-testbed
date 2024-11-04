variable "oidc" {
  type = object({
    client_id              = string
    client_secret          = string
    discovery_url          = string
    discovery_ca_file_path = string
  })
  default = {
    client_id              = "this should be set"
    client_secret          = "this should be set"
    discovery_url          = "https://login.microsoftonline.com/.../v2.0"
    discovery_ca_file_path = "this should be set"
  }
}
