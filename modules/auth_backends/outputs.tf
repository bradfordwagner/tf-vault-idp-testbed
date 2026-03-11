output "user_pass_accessor" {
  value = vault_auth_backend.userpass.accessor
}

output "oidc_backend_accessor" {
  value = vault_jwt_auth_backend.azure[0].accessor
}
