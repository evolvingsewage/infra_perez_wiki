# aws/jenkins — not yet built

Single EC2 instance (t4g.medium, ARM/Graviton), on-demand and fully ephemeral.
Runs the Jenkins controller and agents as containers via Docker Compose —
not 3 separate nodes, not EKS (control-plane fee doesn't make sense for
occasional use).

Will contain:

- EC2 instance + security group (public IP + SG locked down, no load balancer)
- IAM role + OIDC trust policy so GitHub Actions can start/stop this instance
  without long-lived AWS keys
- SSM Parameter Store entries (SecureString, AWS-managed KMS key) for the
  Linode SSH key and any other secrets Jenkins needs at runtime
- User-data / Docker Compose file for the Jenkins controller + agent containers
- Node/container exporter setup so Azure-side Prometheus can scrape this host

Backend: remote state in the S3 bucket created by `bootstrap/aws`.
