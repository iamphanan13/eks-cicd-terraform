variable "subnet_count" {
  type = map(number)
  description = "Counting the subnets"
  default = {
    "public" = 1,
    "subnet" = 2
  }
}


variable "vpc_name" {
    type = string
    default = "Jenkins_VPC"
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
variable "settings" {
    description = "Configure the VM"
    type = map(any)

    default = {
        "app" = {
        instance_type = "t3.micro"
        count = 1 
        }
    }
}

variable "ec2_jenkins_instance" {
    type = string
    default = "Jenkins EC2 Instance"
    
}

variable "instance_type" {
  type = string 
  description = "EC2 Type"
  default = "t3.micro"
}