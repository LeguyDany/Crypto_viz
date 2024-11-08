provider "aws" {
  region = "eu-west-3"
}

# VPC Configuration
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "zookeeper-kafka-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-3a"

  tags = {
    Name = "zookeeper-kafka-public-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "zookeeper-kafka-igw"
  }
}

# Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "zookeeper-kafka-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.main.id
}

# Security group
resource "aws_security_group" "zookeeper_kafka_sg" {
  name        = "zookeeper-kafka-sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id  

  ingress {
    from_port   = 22
    to_port     = 22
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
    Name = "zookeeper-kafka-sg"
  }
}

# AMI Configuration
data "aws_ami" "debian" {
    most_recent = true
    owners = ["136693071363"]

    filter {
        name = "name"
        values = ["debian-12-amd64-*"]
    }

    filter {
        name = "state"
        values = ["available"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

output "ami_id" {
    value = data.aws_ami.debian.id
}

# Key Pair Configuration
resource "aws_key_pair" "deployer" {
  key_name   = "zookeeper-kafka-key"
  public_key = file("~/.ssh/crypto_viz.pub")
}

# Instance Configuration
resource "aws_instance" "zookeeper_kafka" {
  ami           = data.aws_ami.debian.id
  instance_type = "t3.small"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.zookeeper_kafka_sg.id]
  key_name               = aws_key_pair.deployer.key_name 


  root_block_device {
    volume_size           = 10
    volume_type           = "gp3"
    delete_on_termination = true
    
    tags = {
      Name = "zookeeper-kafka-root-volume-1"
    }
  }

  tags = {
    Name = "zookeeper-kafka-instance-1"
  }
}

output "instance_public_dns" {
  value = aws_instance.zookeeper_kafka.public_dns
}