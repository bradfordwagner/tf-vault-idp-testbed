resource "vault_policy" "ui" {
  name   = "ui"
  policy = <<EOT
path "*" {
  capabilities = ["read", "list"]
}
EOT
}

# read any oidc client
resource "vault_policy" "oidc_client" {
  name   = "oidc_client"
  policy = <<EOT
path "identity/oidc/provider/*" {
  capabilities = ["read"]
}
EOT
}
