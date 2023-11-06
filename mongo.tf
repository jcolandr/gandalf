resource "aws_instance" "mongo" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name      = "jdc-aws" 
  subnet_id     = "subnet-0bba23212dab3d1c4" 
  iam_instance_profile = aws_iam_instance_profile.hp.name

  tags = {
    Name = "MongoDB-Instance"
  }
}

# Example security group to allow SSH and MongoDB access
resource "aws_security_group" "mongo-vm-sg" {
  name        = "mongo-vm-security-group"
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
    Name = "mongo-vm-security-group"
  }
}

# Associate the security group with the EC2 instance
resource "aws_network_interface_sg_attachment" "mongo-vm-sg" {
  security_group_id    = aws_security_group.mongo-vm-sg.id
  network_interface_id = aws_instance.mongo.primary_network_interface_id
}



