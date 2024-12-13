# Instance Configuration
resource "aws_instance" "spark_producer" {
  count = var.instance_count
  ami           = var.aws_ami_debian_id
  instance_type = "t3.small"
  subnet_id              = aws_subnet.spark_producer.id
  vpc_security_group_ids = [aws_security_group.spark_producer_sg.id]
  key_name               = var.aws_key_pair_name

  root_block_device {
    volume_size           = 10
    volume_type           = "gp3"
    delete_on_termination = true
    
    tags = {
      Name = "spark-producer-root-volume-${count.index + 1}"
    }
  }

  tags = {
    Name = "spark-producer-instance-${count.index + 1}"
  }
}

# # Elastic IP
# resource "aws_eip" "spark_producer_ip" {
#   count = var.instance_count
#   instance = aws_instance.spark_producer[count.index].id

#   tags = {
#     Name = "spark-producer-eip-${count.index + 1}"
#   }
# }

# Outputs
output "public_ip_spark_producer" {
  value = {
    for idx in range(var.instance_count):
      "instance_${idx + 1}_spark_producer" => aws_instance.spark_producer[idx].public_dns
  }
}
output "instance_private_ips_spark_producer" {
  value = {
    for idx in range(var.instance_count):
      "instance_${idx + 1}_spark_producer" => aws_instance.spark_producer[idx].private_ip
  }
}
