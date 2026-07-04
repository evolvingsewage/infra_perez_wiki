# bootstrap/aws — not yet built

Creates the AWS resources needed to hold Terraform state for `aws/jenkins`:

- S3 bucket for remote state, versioning + SSE-KMS enabled
- KMS key for that bucket's encryption
- DynamoDB table (or S3-native locking, depending on current Terraform/AWS
  provider support at build time) for state locking

Applied once, manually, with **local** state (there's no bucket to store this
config's own state in yet — that's the chicken-and-egg reason this lives
separately from `aws/jenkins`). After this runs once, its outputs (bucket name,
KMS key ARN) get wired into `aws/jenkins`'s backend config.
