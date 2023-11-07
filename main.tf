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