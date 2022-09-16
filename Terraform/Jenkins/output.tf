#-------------------------------------------------------#
#                                                       #
#                 EC2 Instance Outputs                  #
#                                                       #
#-------------------------------------------------------#

output "instance_id" {
  description = "Instance ID"
  value       = aws_instance.Jenkins.id
}

output "instance_public_dns" {
  description = "Instance public dns for class main"
  value       = aws_instance.Jenkins.public_dns
}

output "instance_public_ip" {
  description = "Instance Public IP"
  value       = aws_instance.Jenkins.public_ip
}

output "instance_AZ_name" {
  description = "availability zone"
  value       = aws_instance.Jenkins.availability_zone
}