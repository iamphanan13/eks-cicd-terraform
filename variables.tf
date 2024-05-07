variable "vpc_name" {
    type = string
    default = "EKS_VPC"
}

variable "vpc_cidr" {
    type = string
    description = "CIDR Block for VPC"
    default = "10.10.0.0/16"
  
}

variable "public_subnets" {
    type        = list(string)
    description = "List of public subnet IDs"
    default = [ "10.10.10.0/24", "10.10.20.0/24", "10.10.30.0/24" ]
}

variable "private_subnets" {
    type        = list(string)
    description = "List of public subnet IDs"
    default = [ "10.10.40.0/24", "10.10.50.0/24", "10.10.60.0/24" ]
  
}

variable "jenkins_sg" {
    type = string 
    default = "SG ID for Jenkins Server"

}

variable "ec2_jenkins_instance" {
    type = string
    default = "Jenkins EC2 Instance"
    
}

variable "instance_type" {
  type = string 
  description = "EC2 Type"
  default = "t2.micro"
}