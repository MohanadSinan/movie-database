#---------------------------------------------------------------------#
#                                                                     #
#                     Simple Ubuntu EC2 Instance                      #
#                                                                     #
#---------------------------------------------------------------------#

#---------------------------------------------------------------------#
#                          Security Group                             #
#---------------------------------------------------------------------#
resource "aws_security_group" "default" {
  name        = "${var.instance_name}-SG"
  description = "Allow port 8080 for Jenkins connections & SSH access"

  ingress {
    description = "Allow port 8080 for Jenkins connections"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow incoming SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.instance_name} SG"
  }
}

#---------------------------------------------------------------------#
#                   The Last Version of Ubuntu AMI                    #
#---------------------------------------------------------------------#
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

#---------------------------------------------------------------------#
#                         Ubuntu EC2 Instance                         #
#---------------------------------------------------------------------#
# Define an Ubuntu instance
resource "aws_instance" "Jenkins" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  tags = {
    Name = var.instance_name
  }
}
