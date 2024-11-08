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

# Elastic IP
resource "aws_eip" "zookeeper_kafka_ip" {
  instance = aws_instance.zookeeper_kafka.id

  tags = {
    Name = "zookeeper-kafka-eip"
  }
}

output "elastic_ip" {
  value = aws_eip.zookeeper_kafka_ip.public_dns
}