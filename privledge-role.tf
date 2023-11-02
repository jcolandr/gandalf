# resource "aws_iam_instance_profile" "highly_privileged_instance_profile" {
#   name = "highly-privileged-instance-profile"
# }

# resource "aws_iam_role" "highly_privileged_role" {
#   name = "highly-privileged-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = "sts:AssumeRole",
#         Effect = "Allow",
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# resource "aws_iam_policy_attachment" "highly_privileged_policy_attachment" {
#   name       = "highly-privileged-policy-attachment"
#   policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess" # Replace with the desired policy or permissions
#   roles      = [aws_iam_role.highly_privileged_role.name]
# }

# resource "aws_iam_instance_profile" "highly_privileged_instance_profile" {
#   name = "highly-privileged-instance-profile"
#   role = aws_iam_role.highly_privileged_role.name
# }

# resource "aws_instance" "example" {
#   ami           = var.ami_id
#   instance_type = "t2.micro"
#   key_name      = "your-key-pair" # Replace with your SSH key pair
#   subnet_id     = "your-subnet-id" # Replace with your VPC subnet ID

#   iam_instance_profile = aws_iam_instance_profile.highly_privileged_instance_profile.name

#   user_data = <<-EOF
#               #!/bin/bash
#               # Your user data script here
#               EOF

#   tags = {
#     Name = "Highly-Privileged-Instance"
#   }
# }
