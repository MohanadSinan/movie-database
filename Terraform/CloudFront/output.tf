output "domain_name" {
  description = "The CloudFront domain name."
  value       = aws_cloudfront_distribution.default.domain_name
}