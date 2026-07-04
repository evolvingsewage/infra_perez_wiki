# bootstrap/aws

Creates the AWS resources needed to hold Terraform state for `aws/jenkins`:

- S3 bucket for Jenkins. It's versioned, SSE-S3 (AES256) encrypted, all
  public access blocked, bucket policy denies any non-TLS request.

## Idempotent Bootstrap 

This config has no persistent backend, I store any relevant historical data
on my personal machine. The goal is a single button press, here's what happens 
on the AWS end:

1. Runs `terraform apply -var="bucket_already_exists=false"`. If the bucket
   doesn't exist yet, this creates it and everything else normally.
2. If that fails with S3's own `BucketAlreadyOwnedByYou` error — meaning an
   earlier run already created it — the workflow retries with
   `terraform apply -var="bucket_already_exists=true"`. The `import` block
   in `main.tf` then adopts the real bucket into this run's state first,
   and the rest of `apply` reconciles the versioning, encryption, 
   public-access-block, and policy resources.
3. The calling workflows (`deploy-everything.yml`, `deploy-jenkins-only.yml`,
   `destroy-everything.yml`) also set a `concurrency` group, so two runs can
   never actually execute this sequence at the same time. That's what
   actually prevents the race in practice; the try/retry above is defense
   in depth for correctness even if that were somehow bypassed. One could
   probably clog the queue.

No manual `terraform apply` is ever required; this runs automatically
as part of the on-demand deploy lifecycle (see the repo root README).
`aws/jenkins`'s own state, once this bucket exists, persists normally in it.

## Local dry run (optional for silly geese)

```
cd bootstrap/aws
terraform init
terraform plan -var="bucket_already_exists=false"   # set to true if it already exists
```

Requires AWS CLI credentials already configured (`aws sts get-caller-identity`
to verify). This isn't a part of the normal workflow, and creates real resources.
Ya might break something.
