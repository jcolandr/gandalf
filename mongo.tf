variable "mongodb_version" {
  description = "MongoDB version to install"
  default     = "4.4" # You can change this to the desired MongoDB version
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI ID (you can choose an appropriate AMI for your region)
}

provider "aws" {
  region = "us-east-1" # Change this to your desired AWS region
}

resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name      = "your-key-pair" # Replace with your SSH key pair
  subnet_id     = "your-subnet-id" # Replace with your VPC subnet ID

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install epel -y
              sudo yum install -y mongodb-org-${var.mongodb_version}

              # Start MongoDB and enable it on system startup
              sudo systemctl start mongod
              sudo systemctl enable mongod
              EOF

  tags = {
    Name = "MongoDB-Instance"
  }
}

# Example security group to allow SSH and MongoDB access
resource "aws_security_group" "example" {
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
resource "aws_network_interface_sg_attachment" "example" {
  security_group_id    = aws_security_group.example.id
  network_interface_id = aws_instance.example.network_interface_ids[0]
}

output "instance_public_ip" {
  value = aws_instance.example.public_ip
}
