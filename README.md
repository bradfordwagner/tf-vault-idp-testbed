# vault.idp

## Setup
```bash
vault_group=argo_admins # if you want access to the vault UI
aad_group_name='' # group in aad
allowed_redirect_uri=${vault_addr}/ui/vault/auth/oidc/oidc/callback
azure_tenant_id='' # tenant id of your azure active directory
cat <<EOF > oidc.auth.yaml
enabled: true
client:
  id: ...
  secret: ...
discovery:
  url: https://login.microsoftonline.com/${azure_tenant_id}/v2.0
  ca_file_path: ...

allowed_redirect_uris:
  - ${allowed_redirect_uri}

default_role: my_oidc_role
roles:
  my_oidc_role:
    group: ${vault_group}
    idp_group: ${aad_group_name}
EOF
```
- `task tf_apply` - sets up vault policy against VAULT_ADDR, using the currently configured token. Tested with a naughty ROOT_TOKEN.
- `task auth_apply` - configures kubernetes auth against VAULT_ADDR, using the CLIENT_KUBECONFIG  into the ${TF_VAR_client_test_kubernetes_namespace}
- `task tests_apply` - deploys the tests mentioned below into the ${TF_VAR_client_test_kubernetes_namespace}

