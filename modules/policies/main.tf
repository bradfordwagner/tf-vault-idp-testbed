resource "vault_policy" "ui" {
  name   = "ui"
  policy = <<EOT
path "*" {
  capabilities = ["read", "list"]
}
EOT
}

# read any oidc client
resource "vault_policy" "argo_workflows_oidc_client" {
  name   = "argo_workflows_oidc_client"
  policy = <<EOT
path "identity/oidc/client/argo-workflows" {
  capabilities = ["read"]
}
EOT
}
