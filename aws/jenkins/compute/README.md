# aws/jenkins/compute

The ephemeral half: security group, EC2 instance, and the SSM parameters
Jenkins needs at boottime.

What the instance runs:

- **Jenkins controller** (`jenkins/jenkins:lts-jdk17`) — configured entirely
  via JCasC (`jcasc/jenkins.yaml`): one `admin` user, one pipeline job
  (`deploy-perez-wiki`) that SSHes into the Linode box and runs the same
  steps my self-hosted-runner workflow did. Docker socket is mounted so
  the Docker plugin can spin up build agents as containers on demand,
  instead of running separate long-lived agent containers.
- **node_exporter**, basic-auth protected, for the Azure-side Prometheus to
  scrape (scrape config itself comes later, in `azure/monitoring`).

Secrets (Linode SSH key, node_exporter auth hash, Jenkins admin password)
are written to SSM as `SecureString` parameters by Terraform, then read back
by the instance at boot (via its own scoped IAM role) into files under
`/opt/jenkins/secrets`

Shell access, if ever needed, goes through AWS systems Manager Session Manager 
via IAM. Don't bother with typical SSH.

## Instructions

```
cd aws/jenkins/compute
terraform init \
  -backend-config="bucket=<bootstrap output>" \
  -backend-config="region=<bootstrap output>" \
  -backend-config="key=aws-jenkins-compute/terraform.tfstate" \
  -backend-config="use_lockfile=true"
terraform apply \
  -var="admin_cidr=<your IP>/32" \
  -var="linode_ssh_private_key=..." \
  -var="exporter_basic_auth_hash=..." \
  -var="jenkins_admin_password=..."
```

Requires manual run of `aws/jenkins/iam` during first deployment.
