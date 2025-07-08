variable "state_bucket_name" {
  type        = string
  default     = "luca-state-bucket-tf"
  description = "The name of the S3 bucket for the Terraform state"
}
