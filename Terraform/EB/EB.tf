#--------------------------------------------------------------#
#                                                              #
#       Elastic Beanstalk with Application Load Balancer       #
#                                                              #
#--------------------------------------------------------------#

#--------------------------------------------------------------#
#                           EC2 IAM                            #
#--------------------------------------------------------------#
data "aws_iam_policy_document" "ec2_iam" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"
      identifiers = [
      "ec2.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "ec2_iam" {
  name               = "${var.name}-ec2"
  assume_role_policy = data.aws_iam_policy_document.ec2_iam.json
}

resource "aws_iam_instance_profile" "ec2_iam" {
  name = "${var.name}-ec2"
  role = aws_iam_role.ec2_iam.name
}

resource "aws_iam_role_policy_attachment" "ec2_iam" {
  count = length(var.ec2_policies)

  role       = aws_iam_role.ec2_iam.name
  policy_arn = var.ec2_policies[count.index]
}

#--------------------------------------------------------------#
#                          S3 Bucket                           #
#--------------------------------------------------------------#
resource "aws_s3_bucket" "default" {
  bucket = "${var.name}-s3"
}

resource "aws_s3_object" "default" {
  bucket = aws_s3_bucket.default.id
  key    = var.s3_object_name
  source = "../../${var.s3_object_name}"
}

#--------------------------------------------------------------#
#               Elastic Beanstalk Application                  #
#--------------------------------------------------------------#
resource "aws_elastic_beanstalk_application" "default" {
  name        = var.name
  description = "The name of Elastic Beanstalk application"
}

resource "aws_elastic_beanstalk_application_version" "default" {
  name        = var.elastic_beanstalk_application_version_name
  application = var.name
  description = "Application version created by Terraform"
  bucket      = aws_s3_bucket.default.id
  key         = aws_s3_object.default.id
}

resource "time_sleep" "delay" {
  depends_on = [
    aws_elastic_beanstalk_application_version.default,
    aws_elastic_beanstalk_application.default
    ]

  create_duration = "10s"
}

#--------------------------------------------------------------#
#               Elastic Beanstalk Environment                  #
#--------------------------------------------------------------#
data "aws_elastic_beanstalk_solution_stack" "default" {
  most_recent = true

  name_regex = "^64bit Amazon Linux (.*) ${var.solution_stack}(.*)$"
}

resource "aws_elastic_beanstalk_environment" "default" {
  name        = "${var.name}-env"
  application = var.name

  solution_stack_name = data.aws_elastic_beanstalk_solution_stack.default.name

  depends_on = [time_sleep.delay]

  version_label = var.elastic_beanstalk_application_version_name

  #========================= Capacity =========================#
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = var.environment_type
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = var.autoscale_min
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = var.autoscale_max
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "Availability Zones"
    value     = var.availability_zones
  }

  #====================== Load balancer =======================#
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = var.load_balancer_type
  }

  #========================= Security =========================#
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = var.eb2_iam_name == "" ? aws_iam_instance_profile.ec2_iam.name : var.eb2_iam_name
  }

  #========================= Software =========================#
  dynamic "setting" {
    for_each = var.environment_variables

    content {
      namespace = "aws:elasticbeanstalk:application:environment"
      name      = setting.key
      value     = setting.value
    }
  }
}
