# vault.idp

## Setup
```bash
cat <<EOF > oidc.auth.yaml
enabled: true
client:
  id: ...
  secret: ...
discovery:
  url: https://login.microsoftonline.com/.../v2.0
  ca_file_path: ...
roles:
  admins:
    idp_group: MY_GROUP
    token_policies:
      - default
EOF
```
- `task tf_apply` - sets up vault policy against VAULT_ADDR, using the currently configured token. Tested with a naughty ROOT_TOKEN.
- `task auth_apply` - configures kubernetes auth against VAULT_ADDR, using the CLIENT_KUBECONFIG  into the ${TF_VAR_client_test_kubernetes_namespace}
- `task tests_apply` - deploys the tests mentioned below into the ${TF_VAR_client_test_kubernetes_namespace}

