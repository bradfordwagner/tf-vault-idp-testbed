resource "vault_auth_backend" "userpass" {
  path = "userpass"
  type = "userpass"
}

resource "vault_jwt_auth_backend" "azure" {
    count = var.oidc.enabled ? 1 : 0
    path = "oidc"
    type = "oidc"
    oidc_client_id = var.oidc.client.id
    oidc_client_secret = var.oidc.client.secret
    oidc_discovery_ca_pem = file(var.oidc.discovery.ca_file_path)
    oidc_discovery_url = var.oidc.discovery.url
    provider_config = {
        provider = "azure"
        fetch_groups = true
        fetch_user_info = true
        groups_recurse_max_depth = 1
    }
}

# Missing auth_url. Please check that allowed_redirect_uris for the role include this mount path.
resource "vault_jwt_auth_backend_role" "vault-oidc-role" {
  for_each  = var.oidc.roles
  backend         = vault_jwt_auth_backend.azure[0].path
  role_name       = each.key
  # groups_claim    = var.groups_claim
  user_claim      = "upn"
  role_type       = "oidc"
  # oidc_scopes        = var.oidc_scopes
  allowed_redirect_uris = [
    "https://vault-ui.vault.svc/ui/vault/auth/oidc/oidc/callback",
  ]
  # token_ttl               = var.ldap_token_ttl
  # token_max_ttl           = var.ldap_token_max_ttl
  # token_explicit_max_ttl  = var.ldap_token_max_ttl
  # token_policies    = lookup(local.oidc_role_to_policy, each.key, tolist([]))
  # token_bound_cidrs = lookup(local.oidc_role_to_cidr_restriction, each.key, tolist([]))
  bound_claims = {"roles": each.value.idp_group}
}
