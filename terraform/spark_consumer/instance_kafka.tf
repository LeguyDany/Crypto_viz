# Instance Configuration
resource "aws_instance" "spark_consumer" {
  count = var.instance_count
  ami           = var.aws_ami_debian_id
  instance_type = "t3.small"
  subnet_id              = aws_subnet.spark_consumer.id
  vpc_security_group_ids = [aws_security_group.spark_consumer_sg.id]
  key_name               = var.aws_key_pair_name

  root_block_device {
    volume_size           = 10
    volume_type           = "gp3"
    delete_on_termination = true
    
    tags = {
      Name = "spark-consumer-root-volume-${count.index + 1}"
    }
  }

  tags = {
    Name = "spark-consumer-instance-${count.index + 1}"
  }
}

# Elastic IP
resource "aws_eip" "spark_consumer_ip" {
  count = var.instance_count
  instance = aws_instance.spark_consumer[count.index].id

  tags = {
    Name = "spark-consumer-eip-${count.index + 1}"
  }
}

# Outputs
output "elastic_ip_spark_consumer" {
  value = {
    for idx in range(var.instance_count):
      "instance_${idx + 1}" => aws_eip.spark_consumer_ip[idx].public_dns
  }
}
output "instance_private_ips_spark_consumer" {
  value = {
    for idx in range(var.instance_count):
      "instance_${idx + 1}" => aws_eip.spark_consumer_ip[idx].private_ip
  }
}
