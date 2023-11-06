resource "aws_instance" "mongo" {
  ami           = var.ami_id
  instance_type = "t2.small"
  key_name      = "jdc-aws" 
  subnet_id     = aws_subnet.public_subnet[0].id 
  iam_instance_profile = aws_iam_instance_profile.hp.name

  tags = {
    Name = "MongoDB-VM"
  }
}
resource "aws_subnet" "public_subnet" {
  count             = 1
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true
}

# Example security group to allow SSH and MongoDB access
resource "aws_security_group" "mongo" {
  name        = "mongo-vm-sg"
  description = "Allow SSH and MongoDB access"
  vpc_id = "vpc-0b0b78b62d9ef61c7"

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
resource "aws_network_interface_sg_attachment" "mongo" {
  security_group_id    = aws_security_group.mongo.id
  network_interface_id = aws_instance.mongo.primary_network_interface_id
}



