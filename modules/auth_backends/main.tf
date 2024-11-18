resource "vault_auth_backend" "userpass" {
  path = "userpass"
  type = "userpass"
}


### TODO
# go through this: https://developer.hashicorp.com/vault/docs/auth/jwt/oidc-providers/azuread

resource "vault_jwt_auth_backend" "azure" {
  count                 = var.oidc.enabled ? 1 : 0
  path                  = "oidc"
  type                  = "oidc"
  oidc_client_id        = var.oidc.client.id
  oidc_client_secret    = var.oidc.client.secret
  oidc_discovery_ca_pem = file(var.oidc.discovery.ca_file_path)
  oidc_discovery_url    = var.oidc.discovery.url
  # default_role          = "admins"
  default_role = "chumps"
  provider_config = {
    provider = "azure"
  }
}

# Missing auth_url. Please check that allowed_redirect_uris for the role include this mount path.
resource "vault_jwt_auth_backend_role" "vault-oidc-role" {
  for_each     = var.oidc.roles
  backend      = vault_jwt_auth_backend.azure[0].path
  role_type    = "oidc"
  role_name    = each.key
  groups_claim = "roles"

  user_claim = "email"
  # set the entity-alias to the group/role name
  # does not work because we could have many groups associated with our accounts
  # user_claim      = "roles"
  # user_claim      = "/roles/0"
  # user_claim_json_pointer = true
  # oidc_scopes        = ["https://graph.microsoft.com/.default","profile","email", "openid"]
  oidc_scopes = [
    "https://graph.microsoft.com/.default",
  ]
  allowed_redirect_uris = var.oidc.allowed_redirect_uris

  # ensure that the user is a member of the group
  bound_claims         = { "roles" : each.value.idp_group }
  verbose_oidc_logging = true
}
