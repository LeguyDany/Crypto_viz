# module "kafka" {
#   source            = "./kafka"
#   vpc_id            = aws_vpc.main.id
#   instance_count    = var.instance_count_kafka
#   route_table_id    = aws_route_table.main.id
#   aws_ami_debian_id = data.aws_ami.debian.id
#   aws_key_pair_name = aws_key_pair.deployer.key_name
# }
# output "kafka_elastic_public_ips" {
#   value = module.kafka.public_elastic_ips_kafka
# }
# output "kafka_elastic_private_ips" {
#   value = module.kafka.private_elastic_ips_kafka
# }

module "spark_consumer" {
  source         = "./spark_consumer"
  vpc_id            = aws_vpc.main.id
  instance_count    = var.instance_count_spark
  route_table_id    = aws_route_table.main.id
  aws_ami_debian_id = data.aws_ami.debian.id
  aws_key_pair_name = aws_key_pair.deployer.key_name
}

module "spark_producer" {
  source         = "./spark_producer"
  vpc_id            = aws_vpc.main.id
  instance_count    = var.instance_count_spark
  route_table_id    = aws_route_table.main.id
  aws_ami_debian_id = data.aws_ami.debian.id
  aws_key_pair_name = aws_key_pair.deployer.key_name
}


# Outputs

output "spark_consumer_public_ips" {
  value = module.spark_consumer.public_ip_spark_consumer
}
output "spark_consumer_private_ips" {
  value = module.spark_consumer.instance_private_ips_spark_consumer
}

output "spark_producer_public_ips" {
  value = module.spark_producer.public_ip_spark_producer
}
output "spark_producer_ips" {
  value = module.spark_producer.instance_private_ips_spark_producer
}
