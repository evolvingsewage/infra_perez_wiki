# azure/monitoring

Split the same way as `aws/jenkins` — two Terraform configs with separate
state, so an automated destroy can never touch the trust relationship that
makes the automation possible in the first place:

- **`iam/`** — Azure AD app registration, federated credentials, RBAC role
  assignments. Applied once, manually. Never destroyed by the on-demand
  lifecycle.
- **`aks/`** — IN PROGRESS. Bare AKS cluster written and applying; Helm
  releases for Grafana/Prometheus/Loki, Kubernetes Secrets wiring, RBAC
  (in-cluster, separate from the Azure RBAC in `iam/`) still to come.
  Created/destroyed on demand, same as `aws/jenkins/compute`.

AKS cluster, Free tier (control plane genuinely $0), 3 worker nodes
(`Standard_D2s_v7` — B-series burstable VMs, originally planned, aren't
available at all on this Free Trial subscription in any region tried) —
one node each for Grafana, Prometheus, and Loki. On-demand and
fully ephemeral; dashboards/datasources provisioned as code so nothing is
lost on teardown, but metric/log history does not survive a teardown (that
trade-off was accepted deliberately — worth noting as a limitation, not
hiding it).

`aks/` will contain:

- AKS cluster + node pool
- Helm releases for Grafana, Prometheus, Loki
- Prometheus scrape config targeting the AWS Jenkins EC2 instance and the
  Linode website box (cross-cloud, over the public internet with auth —
  design TBD)
- Kubernetes Secrets populated directly from GitHub Actions secrets at
  deploy time (no Key Vault — see root README's Secrets section)
- RBAC: each service account scoped to `get` on the one named Secret it
  needs, never namespace-wide `list`

Backend: remote state in the Azure Storage Account created by
`bootstrap/azure`.
