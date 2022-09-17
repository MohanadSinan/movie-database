output "all_settings" {
  description = "List of all option settings configured in the Environment. These are a combination of default settings and their overrides from setting in the configuration."
  value       = aws_elastic_beanstalk_environment.default.all_settings
}

output "application" {
  description = "The Elastic Beanstalk Application specified for this environment."
  value       = aws_elastic_beanstalk_environment.default.application
}

output "cname" {
  description = "Fully qualified DNS name for the Environment."
  value       = aws_elastic_beanstalk_environment.default.cname
}

output "id" {
  description = "ID of the Elastic Beanstalk environment."
  value       = aws_elastic_beanstalk_environment.default.id
}

output "name" {
  description = "Name of the Elastic Beanstalk Environment."
  value       = aws_elastic_beanstalk_environment.default.name
}

output "load_balancers" {
  description = "Elastic load balancers in use by this environment."
  value       = aws_elastic_beanstalk_environment.default.load_balancers
} 