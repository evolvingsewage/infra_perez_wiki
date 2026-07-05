# bootstrap/azure

Creates the Azure resources needed to hold Terraform state for
`azure/monitoring`:

- Resource group for state storage
- Storage Account — `LRS` (locally redundant, cheapest replication tier),
  TLS 1.2 minimum, versioning enabled (recovery path if a bad `apply`
  corrupts state), private container (no anonymous blob access)
- Blob container within it for the actual state files

Deterministic naming (storage account name derived from your Azure
subscription ID) so `azure/monitoring`'s backend config can reference the
same name without needing to read this config's outputs first.

## Applied manually, once — not automated

Same chicken-and-egg reason as `bootstrap/aws` (can't store state for the
thing that creates your state storage), but **unlike `bootstrap/aws`, this
one doesn't attempt the belt-and-suspenders auto-bootstrap dance at all** —
that pattern was designed for the AWS side but never actually got wired into
the real GitHub Actions workflow there either (see `bootstrap/aws/README.md`).
This one is upfront from the start: apply it once by hand, and any workflow
that needs this storage account just assumes it exists.

```
cd bootstrap/azure
terraform init
terraform apply
```

Requires `az login` already done (`az account show` to verify). Creates
real Azure resources.
