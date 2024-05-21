resource "aws_vpc" "jenkins_vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_hostnames = true


  tags = {
    Name = var.vpc_name
  }
}

#Create Internet Gateway 
resource "aws_internet_gateway" "jenkins_igw" {
  vpc_id = aws_vpc.jenkins_vpc.id //Specify the VPC ID

  // Tagging the Internet Gateway
  tags = {
    Name = "vpc_jenkins_igw"
  }
}

# Create a group of public subnet 
resource "aws_subnet" "public_subnets" {
  vpc_id                  = aws_vpc.jenkins_vpc.id          // Atach the public subnet to this VPC
  count                   = var.subnet_count.public // Count the number of public subnets want to create
  map_public_ip_on_launch = true
  // Grabbing the subnet from block, will start from 1
  // It'll be 10.10.10.0/24
  cidr_block = var.public_subnets[count.index]

  // Grabbing the azs from data object which created before,
  // Default region is ap-southeast-1, azs will be ap-southeast-1a
  availability_zone = data.aws_availability_zones.azs.names[count.index]

  tags = {
    Name = "public_subnet_${count.index}"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.jenkins_vpc.id
}

resource "aws_route_table_association" "public_rta" {
  route_table_id = aws_route_table.public_rt.id
  count = var.subnet_count.public

  subnet_id = aws_subnet.public_subnets[count.index].id // Grabbing the subnet ID from count
  
}
resource "aws_security_group" "jenkins_sg" {
  name = var.jenkins_sg
  description = "Security Group for Jenkins Server"
  vpc_id = aws_vpc.jenkins_vpc.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    description = "JenkinsPort"
    cidr_blocks = ["0.0.0.0/0"]
    }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "HTTPS"
    cidr_blocks = ["0.0.0.0/0"]
    }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
    }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "SSH"
    cidr_blocks = ["0.0.0.0/0"]
    }
  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    description = "SonarQubePort"
    cidr_blocks = ["0.0.0.0/0"]
    }
    
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
  tags = {
    Name = "jenkins-sg"
  }
}

resource "aws_instance" "jenkins_vm" {
  ami = data.aws_ami.ubuntu.id
  count = var.settings.app.count
  monitoring = true
  instance_type = var.settings.app.instance_type
  subnet_id = aws_subnet.public_subnets[count.index].id
  key_name = aws_key_pair.keypair.key_name
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true
  availability_zone = data.aws_availability_zones.azs.names[0]
  # user_data = 
  tags = {
    Name = "Jenkins-vm"
  }
}

