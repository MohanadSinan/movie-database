#--------------------------------------------------------------#
#                                                              #
#           Elastic Beanstalk Environment Variables            #
#                                                              #
#--------------------------------------------------------------#

#--------------------------------------------------------------#
#                        AWS Provider                          #
#--------------------------------------------------------------#
variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

#--------------------------------------------------------------#
#                           EC2 IAM                            #
#--------------------------------------------------------------#
variable "eb2_iam_name" {
  description = "Name of an instance profile. Leave empty for one to be created."
  default     = ""
}

variable "ec2_policies" {
  default = [
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
}

#--------------------------------------------------------------#
#                      Elastic Beanstalk                       #
#--------------------------------------------------------------#
variable "name" {
  description = "The name of project"
  default     = "movie-database"
}

variable "s3_object_name" {
  description = "The name of s3 object"
  default     = "Dockerrun.aws.json"
}

variable "elastic_beanstalk_application_version_name" {
  description = "The Elastic Beanstalk version name"
  default     = "initial-version"
}

variable "solution_stack" {
  description = "Elastic Beanstalk stack, e.g. Docker, Go, Node, Java, IIS"
  default     = "running Docker"
}

variable "environment_type" {
  description = "Environment type, e.g. 'LoadBalanced' or 'SingleInstance'"
  default     = "LoadBalanced"
}

variable "autoscale_min" {
  description = "The minimum instance count to apply when the action runs."
  default     = "1"
}

variable "autoscale_max" {
  description = "The maximum instance count to apply when the action runs."
  default     = "4"
}

variable "availability_zones" {
  description = "Choose the number of AZs for your instances."
  default     = "Any"
}

variable "load_balancer_type" {
  description = "The type of load balancer for your environment. [classic, application, network]"
  default     = "application"
}

variable "environment_variables" {
  description = "Map of custom environment variables to be provided to the application running on Elastic Beanstalk"
  type        = map(string)
  default = {
    DB_URL      = "devops22.cehxjqytwbqs.us-east-1.rds.amazonaws.com"
    DB_NAME     = "goldendb"
    DB_USERNAME = "admin"
    DB_PASSWORD = "DevOps2022"
    DB_POR      = "3306"
  }
}
