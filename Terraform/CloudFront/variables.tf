#--------------------------------------------------------------#
#                                                              #
#               CloudFront Environment Variables               #
#                                                              #
#--------------------------------------------------------------#

#--------------------------------------------------------------#
#                        AWS Provider                          #
#--------------------------------------------------------------#
variable "aws_region" {
  description = "AWS region to create resources in"
  type        = string
  default     = "us-east-1"
}

#--------------------------------------------------------------#
#                  Elastic Load Balancer Tags                  #
#--------------------------------------------------------------#
variable "load_balancer_tags" {
  default = {
    Environment = "Development"
    Project     = "Movie Database"
    Version     = "1.0"
  }
  type          = map(string)
}