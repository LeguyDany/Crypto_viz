# Instance Configuration
resource "aws_instance" "zookeeper_kafka" {
  count = var.instance_count
  ami           = var.aws_ami_debian_id
  instance_type = "t3.small"
  subnet_id              = aws_subnet.kafka.id
  vpc_security_group_ids = [aws_security_group.zookeeper_kafka_sg.id]
  key_name               = var.aws_key_pair_name

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

# Outputs
output "public_elastic_ips_kafka" {
  value = {
    for idx in range(var.instance_count):
      "instance_${idx + 1}_kafka" => aws_eip.zookeeper_kafka_ip[idx].public_dns
  }
}
output "private_elastic_ips_kafka" {
  value = {
    for idx in range(var.instance_count):
      "instance_${idx + 1}_kafka" => aws_eip.zookeeper_kafka_ip[idx].private_ip
  }
}
