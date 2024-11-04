resource "vault_auth_backend" "userpass" {
  path = "userpass"
  type = "userpass"
}

resource "vault_jwt_auth_backend" "azure" {
    count = var.config.oidc.auth.enabled ? 1 : 0
    path = "oidc"
    type = "oidc"
    oidc_discovery_url = var.oidc.discovery_url
    oidc_client_secret = var.oidc.client_secret
    oidc_client_id = var.oidc.client_id
    oidc_discovery_ca_pem = file(var.oidc.discovery_ca_file_path)
    provider_config = {
        provider = "azure"
        fetch_groups = true
        fetch_user_info = true
        groups_recurse_max_depth = 1
    }
}

