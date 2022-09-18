#--------------------------------------------------------------#
#                                                              #
#      CloudFront Web Distribution with Elastic Beanstalk      #
#                                                              #
#--------------------------------------------------------------#

#--------------------------------------------------------------#
#                   Elastic Load Balancing                     #
#--------------------------------------------------------------#
data "aws_lb" "default" {
  tags  = var.load_balancer_tags
}

#--------------------------------------------------------------#
#                 CloudFront Web Distribution                  #
#--------------------------------------------------------------#
resource "aws_cloudfront_distribution" "default" {
  comment = "Cloudfront web proxy"
  enabled = true

  origin {
    origin_id   = data.aws_lb.default.id
    domain_name = data.aws_lb.default.dns_name

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = data.aws_lb.default.id
    viewer_protocol_policy = "allow-all"

    forwarded_values {
      query_string = true
      headers      = ["Host"]

      cookies {
        forward = "all"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}