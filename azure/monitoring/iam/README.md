# azure/monitoring/iam

The prerequisite for automation — Azure's equivalent of `aws/jenkins/iam`.
Applied once, manually. Don't destroy it or you'll need to run it again.
Requires `bootstrap/azure` applied first.

Creates:

- Resource group (`infra-perez-wiki-monitoring-rg`) that will hold the AKS
  cluster, built in `azure/monitoring/aks`
- Azure AD app registration + service principal — the identity GitHub
  Actions authenticates as
- **Two** federated identity credentials, not one — Azure requires an exact
  subject match per credential (unlike AWS's IAM trust policy, which could
  use a single `StringLike` condition to match a pattern). One for
  `perez_wiki`'s main branch, one for `infra_perez_wiki`'s main branch.
- RBAC role assignments: `Contributor` scoped to just the monitoring
  resource group (starting point — AKS creation touches several resource
  types, may need adjustment once tested for real, same as how the AWS IAM
  policy grew from real `AccessDeniedException` errors), and
  `Storage Blob Data Contributor` scoped to just the state storage account
  from `bootstrap/azure`

No client secret anywhere — authentication is purely OIDC federation, same
"no long-lived credentials" approach as the AWS side.

## Applying (manual, one-time)

Bash (Git Bash/Mac/Linux):
```
bash azure/scripts/tf-init.sh azure/monitoring/iam azure-monitoring-iam.tfstate
```

PowerShell:
```
.\azure\scripts\tf-init.ps1 azure\monitoring\iam azure-monitoring-iam.tfstate
```

Then:
```
cd azure/monitoring/iam
terraform plan
terraform apply
```

Either init script recomputes the same deterministic backend-config values
`bootstrap/azure` used, rather than needing you to run `terraform output`
there and copy-paste them in by hand. Requires `az login` already done.


Outputs (`github_actions_client_id`, `tenant_id`, `subscription_id`) are not
secrets — they're plain identifiers used by `azure/login@v2` in GitHub
Actions workflows, safe to reference directly or store as repo Variables
rather than Secrets.
