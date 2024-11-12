resource "vault_policy" "ui" {
  name = "ui"
  policy = <<EOT
path "*" {
  capabilities = ["read", "list"]
}
EOT
}
