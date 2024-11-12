resource "vault_auth_backend" "userpass" {
  path = "userpass"
  type = "userpass"
}


### TODO
# go through this: https://developer.hashicorp.com/vault/docs/auth/jwt/oidc-providers/azuread

resource "vault_jwt_auth_backend" "azure" {
    count = var.oidc.enabled ? 1 : 0
    path = "oidc"
    type = "oidc"
    oidc_client_id = var.oidc.client.id
    oidc_client_secret = var.oidc.client.secret
    oidc_discovery_ca_pem = file(var.oidc.discovery.ca_file_path)
    oidc_discovery_url = var.oidc.discovery.url
    default_role = "admins"
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
  # groups_claim    = "roles"
  groups_claim    = "groups"
  user_claim      = "upn"
  # oidc_scopes        = ["https://graph.microsoft.com/.default profile"]
  oidc_scopes        = ["profile"]
  allowed_redirect_uris = [
    "https://vault-ui.vault.svc/ui/vault/auth/oidc/oidc/callback",
    "http://localhost:8250/oidc/callback",
    "https://localhost:8250/oidc/callback",
    "https://vault.multitenant.hal.adpe-vault.extdns.dev.blackrock.com/ui/vault/auth/oidc/oidc/callback",
  ]
  # token_ttl               = var.ldap_token_ttl
  # token_max_ttl           = var.ldap_token_max_ttl
  # token_explicit_max_ttl  = var.ldap_token_max_ttl
  token_policies    = each.value.token_policies
  # token_bound_cidrs = lookup(local.oidc_role_to_cidr_restriction, each.key, tolist([]))
  
  
  # but how do i see the claims this is how we ensure that a user is a member of a group
  # bound_claims = {"roles": each.value.idp_group}
  verbose_oidc_logging = true
}


# resource "vault_identity_group" "external_groups_azure" {
#    for_each  = var.oidc.roles
#    name     = "${each.key}_azure"
#    type     = "external"
# }

