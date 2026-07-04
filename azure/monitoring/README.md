# azure/monitoring — not yet built

AKS cluster, Free tier (control plane genuinely $0), 3 worker nodes
(B2ats_v2) — one node each for Grafana, Prometheus, and Loki. On-demand and
fully ephemeral; dashboards/datasources provisioned as code so nothing is
lost on teardown, but metric/log history does not survive a teardown (that
trade-off was accepted deliberately — worth noting as a limitation, not
hiding it).

Will contain:

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
