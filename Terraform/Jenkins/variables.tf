#----------------------------------------#
#                                        #
#   EC2 Instance Environment Variables   #
#                                        #
#----------------------------------------#

#----------------------------------------#
#              AWS Provider              #
#----------------------------------------#
variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

#----------------------------------------#
#              EC2 Instance              #
#----------------------------------------#
variable "instance_name" {
  description = "instance name"
  default     = "Jenkins"
}

variable "instance_type" {
  description = "instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "SSH Public Key name"
  default     = "movie"
}