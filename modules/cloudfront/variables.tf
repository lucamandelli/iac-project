variable "origin_id" {
  type        = string
  description = "The origin ID for the CloudFront distribution"
}

variable "bucket_domain_name" {
  type        = string
  description = "The S3 bucket domain name"
}

variable "cdn_price_class" {
  type        = string
  default     = "PriceClass_200"
  description = "The price class for the CloudFront distribution"
}

variable "cdn_tags" {
  type        = map(string)
  default     = {}
  description = "The tags for the CloudFront distribution"
}
