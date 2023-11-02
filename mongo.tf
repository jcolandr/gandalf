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

  user_data = <<-EOC
              #!/bin/bash
              cat <<EOF > /etc/yum.repos.d/mongodb-org-7.0.repo 
                [mongodb-org-7.0]
                name=MongoDB Repository
                baseurl=https://repo.mongodb.org/yum/amazon/2023/mongodb-org/7.0/x86_64/
                gpgcheck=1
                enabled=1
                gpgkey=https://www.mongodb.org/static/pgp/server-7.0.asc
                EOF
              sudo yum update -y
              sudo yum install -y mongodb-org-${var.mongodb_version} mongodb-org-database-${var.mongodb_version} mongodb-org-server-${var.mongodb_version}
              # Start MongoDB and enable it on system startup
              sudo systemctl start mongod
              sudo systemctl enable mongod
              EOC

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

output "instance_public_ip" {
  value = aws_instance.mongo.public_ip
}

