variable "mongodb_version" {
  description = "MongoDB version to install"
  default     = "4.4" # You can change this to the desired MongoDB version
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI ID (you can choose an appropriate AMI for your region)
}

provider "aws" {
  region = "us-east-2" 
}

resource "aws_instance" "mongo" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name      = "jdc-aws" 
  subnet_id     = "subnet-0d22cfd6dfa91dd5e" 
  iam_instance_profile = aws_iam_instance_profile.highly_privileged_instance_profile.name

  tags = {
    Name = "MongoDB-Instance"
  }
}

# Example security group to allow SSH and MongoDB access
resource "aws_security_group" "mongo-sg" {
  name        = "example-security-group"
  description = "Allow SSH and MongoDB access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 27017 # MongoDB default port
    to_port     = 27017
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
    Name = "example-security-group"
  }
}

# Associate the security group with the EC2 instance
resource "aws_network_interface_sg_attachment" "mongo-sg" {
  security_group_id    = aws_security_group.mongo-sg.id
  network_interface_id = aws_instance.mongo.primary_network_interface_id
}

resource "aws_iam_instance_profile" "highly_privileged_instance_profile" {
  name = "highly-privileged-instance-profile"
}

resource "aws_iam_role" "highly_privileged_role" {
  name = "highly-privileged-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "highly_privileged_policy_attachment" {
  name       = "highly-privileged-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess" # Replace with the desired policy or permissions
  roles      = [aws_iam_role.highly_privileged_role.name]
}

resource "aws_iam_instance_profile" "highly_privileged_instance_profile" {
  name = "highly-privileged-instance-profile"
  role = aws_iam_role.highly_privileged_role.name
}

output "instance_public_ip" {
  value = aws_instance.mongo.public_ip
}

