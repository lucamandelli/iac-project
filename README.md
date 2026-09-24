# iac-project

Terraform project that provisions static website hosting on AWS with an S3 bucket behind a CloudFront distribution. Built to practice structuring Terraform the way it's done in real projects: reusable modules, remote state and per-environment workspaces.

## Architecture

```
            ┌──────────────┐        ┌──────────────┐
 users ───▶ │  CloudFront  │ ─────▶ │  S3 bucket   │
            │  HTTPS, CDN  │        │  website     │
            └──────────────┘        └──────────────┘

 Terraform state ─▶ S3 bucket with versioning and encryption
```

## What's inside

- **Modules.** `modules/s3` (bucket + website configuration) and `modules/cloudfront` (distribution) with their own variables and outputs, wired together in `main.tf`.
- **Remote state.** State stored in a versioned, encrypted S3 bucket protected by `prevent_destroy`.
- **Workspaces.** The website bucket name is suffixed with the workspace (`luca-iac-dev`, `luca-iac-prod`), so each environment gets its own isolated resources from the same code.
- **HTTPS by default.** CloudFront redirects all HTTP traffic to HTTPS.

## Project structure

```
main.tf          wires the s3 and cloudfront modules
providers.tf     AWS provider, S3 backend and the state bucket
variables.tf
outputs.tf       S3 domain and CloudFront domain
modules/
├── s3/
└── cloudfront/
```

## Usage

Requirements: Terraform and AWS credentials. `providers.tf` uses the AWS profile `lucamandelli`, so change it to your own profile.

```bash
terraform init
terraform workspace new dev
terraform plan
terraform apply
```

Outputs:

| Output           | Description                       |
| ---------------- | --------------------------------- |
| `s3_bucket_name` | S3 bucket domain name             |
| `cdn_domain`     | CloudFront distribution domain    |

To tear everything down: `terraform destroy`.

## Next steps

- Serve the bucket privately through CloudFront Origin Access Control instead of a public origin
- Turn on caching (TTLs are currently set to 0)
- Run `plan` on pull requests and `apply` on merge through GitHub Actions, like in [ci.iac](https://github.com/lucamandelli/ci.iac)

## Related

- [ci.api](https://github.com/lucamandelli/ci.api) and [ci.iac](https://github.com/lucamandelli/ci.iac): a NestJS API deployed to AWS App Runner by a GitHub Actions pipeline, with its infrastructure managed in Terraform
