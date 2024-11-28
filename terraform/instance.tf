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

# Variables
variable "instance_count" {
  description = "Nombre d'instances à créer"
  type        = number
  default     = 2
}

# Instance Configuration
resource "aws_instance" "zookeeper_kafka" {
  count = var.instance_count
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
      Name = "zookeeper-kafka-root-volume-${count.index + 1}"
    }
  }

  tags = {
    Name = "zookeeper-kafka-instance-${count.index + 1}"
  }
}

# Elastic IP
resource "aws_eip" "zookeeper_kafka_ip" {
  count = var.instance_count
  instance = aws_instance.zookeeper_kafka[count.index].id

  tags = {
    Name = "zookeeper-kafka-eip-${count.index + 1}"
  }
}

output "elastic_ip" {
  value = {
    for idx in range(var.instance_count):
      "instance_${idx + 1}" => aws_eip.zookeeper_kafka_ip[idx].public_dns
  }
}
output "instance_private_ips" {
  value = {
    for idx in range(var.instance_count):
      "instance_${idx + 1}" => aws_eip.zookeeper_kafka_ip[idx].private_ip
  }
}
