# Terraform IAC Learning Project

A comprehensive Infrastructure as Code (IaC) project built with Terraform to demonstrate AWS infrastructure provisioning. This project showcases the creation of a static website hosting solution using S3 and CloudFront CDN.

## 🏗️ Architecture

This project implements a modern static website hosting architecture on AWS:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   CloudFront    │    │   S3 Bucket     │    │   Static Files  │
│   (CDN)         │◄───│   (Origin)      │◄───│   (index.html)  │
│                 │    │                 │    │                 │
│ • Global CDN    │    │ • Website Host  │    │ • HTML/CSS/JS   │
│ • SSL/TLS       │    │ • Static Files  │    │ • Images        │
│ • Caching       │    │ • Versioning    │    │ • Assets        │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### Components

- **S3 Bucket**: Static website hosting with website configuration
- **CloudFront Distribution**: Global CDN for improved performance and security
- **Terraform State**: Remote state management using S3 backend
- **Modular Design**: Reusable modules for S3 and CloudFront

## 📋 Prerequisites

Before running this project, ensure you have the following installed:

- [Terraform](https://www.terraform.io/downloads.html) (>= 1.0.0)
- [AWS CLI](https://aws.amazon.com/cli/) (>= 2.0.0)
- AWS Account with appropriate permissions
- AWS credentials configured (`aws configure` or AWS profile)

### Required AWS Permissions

The following AWS permissions are required:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:CreateBucket",
        "s3:DeleteBucket",
        "s3:GetBucketLocation",
        "s3:ListBucket",
        "s3:PutBucketWebsite",
        "s3:PutBucketVersioning",
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "cloudfront:CreateDistribution",
        "cloudfront:GetDistribution",
        "cloudfront:UpdateDistribution",
        "cloudfront:DeleteDistribution",
        "cloudfront:ListDistributions"
      ],
      "Resource": "*"
    }
  ]
}
```

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone <repository-url>
cd iac-project
```

### 2. Configure AWS Credentials

```bash
# Option 1: Using AWS CLI
aws configure

# Option 2: Using AWS Profile (as configured in providers.tf)
aws configure --profile <your_profile_name>
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Plan the Deployment

```bash
terraform plan
```

### 5. Apply the Infrastructure

```bash
terraform apply
```

### 6. Verify the Deployment

After successful deployment, you'll see outputs similar to:

```
Outputs:

s3_bucket_name = "luca-iac-<workspace>.s3.amazonaws.com"
cdn_domain = "d1234567890abc.cloudfront.net"
```

## 📁 Project Structure

```
iac-project/
├── main.tf                 # Main Terraform configuration
├── variables.tf            # Root variables
├── outputs.tf             # Root outputs
├── providers.tf           # Provider configuration and state backend
├── modules/
│   ├── s3/               # S3 bucket module
│   │   ├── main.tf       # S3 bucket resources
│   │   ├── variables.tf  # S3 module variables
│   │   ├── outputs.tf    # S3 module outputs
│   │   └── datasources.tf # S3 data sources
│   └── cloudfront/       # CloudFront module
│       ├── main.tf       # CloudFront distribution resources
│       ├── variables.tf  # CloudFront module variables
│       ├── outputs.tf    # CloudFront module outputs
│       └── datasources.tf # CloudFront data sources
└── README.md             # This file
```

## 🔧 Configuration

### Variables

The project uses the following variables:

| Variable            | Description                        | Default                | Required |
| ------------------- | ---------------------------------- | ---------------------- | -------- |
| `state_bucket_name` | S3 bucket name for Terraform state | `luca-state-bucket-tf` | No       |
| `s3_bucket_name`    | S3 bucket name for website hosting | -                      | Yes      |
| `s3_tags`           | Tags for S3 bucket                 | `{}`                   | No       |
| `cdn_tags`          | Tags for CloudFront distribution   | `{}`                   | No       |

### Workspace Support

The project supports Terraform workspaces. The S3 bucket name is automatically suffixed with the workspace name:

```hcl
bucket = "${var.s3_bucket_name}-${terraform.workspace}"
```

### State Management

Terraform state is stored remotely in S3 with the following configuration:

- **Bucket**: `luca-state-bucket-tf`
- **Region**: `us-east-2`
- **Key**: `terraform.tfstate`
- **Encryption**: Enabled

## 🛠️ Usage

### Creating a New Workspace

```bash
# Create a new workspace
terraform workspace new production

# Switch to existing workspace
terraform workspace select production

# List all workspaces
terraform workspace list
```

### Deploying to Different Environments

```bash
# Development environment
terraform workspace select dev
terraform apply

# Staging environment
terraform workspace select staging
terraform apply

# Production environment
terraform workspace select production
terraform apply
```

### Updating Infrastructure

```bash
# Plan changes
terraform plan

# Apply changes
terraform apply

# Destroy infrastructure (use with caution)
terraform destroy
```

## 📊 Outputs

After successful deployment, the following outputs are available:

| Output           | Description                    | Example                         |
| ---------------- | ------------------------------ | ------------------------------- |
| `s3_bucket_name` | S3 bucket domain name          | `luca-iac-dev.s3.amazonaws.com` |
| `cdn_domain`     | CloudFront distribution domain | `d1234567890abc.cloudfront.net` |

## 🔍 Monitoring and Troubleshooting

### Check S3 Bucket Status

```bash
# List S3 buckets
aws s3 ls

# Check bucket website configuration
aws s3api get-bucket-website --bucket <bucket-name>
```

### Check CloudFront Distribution

```bash
# List CloudFront distributions
aws cloudfront list-distributions

# Get distribution details
aws cloudfront get-distribution --id <distribution-id>
```

### Common Issues

1. **Permission Denied**: Ensure AWS credentials are properly configured
2. **Bucket Already Exists**: Use a unique bucket name or different workspace
3. **CloudFront Distribution Failed**: Check S3 bucket configuration and permissions

## 🧹 Cleanup

To destroy all created resources:

```bash
# Destroy infrastructure
terraform destroy

# Remove workspace (optional)
terraform workspace select default
terraform workspace delete <workspace-name>
```

⚠️ **Warning**: This will permanently delete all created AWS resources.

## 📚 Learning Objectives

This project demonstrates the following Terraform and AWS concepts:

### Terraform Concepts
- **Modules**: Reusable infrastructure components
- **Variables**: Parameterized configurations
- **Outputs**: Exposing resource information
- **Workspaces**: Environment isolation
- **Remote State**: Team collaboration and state management
- **Dependencies**: Resource ordering and relationships

### AWS Concepts
- **S3**: Static website hosting and object storage
- **CloudFront**: Global content delivery network
- **IAM**: Permissions and access control
- **Tags**: Resource organization and cost tracking

### Best Practices
- **Modular Design**: Reusable and maintainable code
- **State Management**: Remote state for team collaboration
- **Environment Isolation**: Workspace-based deployments
- **Security**: Proper IAM permissions and encryption
- **Documentation**: Comprehensive README and inline comments

## 🤝 Contributing

This is a learning project. Feel free to:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is for educational purposes. Feel free to use and modify as needed.

## 🙏 Acknowledgments

- HashiCorp for Terraform
- AWS for cloud infrastructure
- The Terraform community for best practices and examples

---

**Note**: This project is designed for learning purposes. Always review and understand the infrastructure before deploying to production environments. 