module "kafka" {
  source            = "./kafka"
  vpc_id            = aws_vpc.main.id
  instance_count    = var.instance_count
  route_table_id    = aws_route_table.main.id
  aws_ami_debian_id = data.aws_ami.debian.id
  aws_key_pair_name = aws_key_pair.deployer.key_name
}

module "spark_consumer" {
  source         = "./spark_consumer"
  vpc_id            = aws_vpc.main.id
  instance_count    = var.instance_count
  route_table_id    = aws_route_table.main.id
  aws_ami_debian_id = data.aws_ami.debian.id
  aws_key_pair_name = aws_key_pair.deployer.key_name
}

module "spark_producer" {
  source         = "./spark_producer"
  vpc_id            = aws_vpc.main.id
  instance_count    = var.instance_count
  route_table_id    = aws_route_table.main.id
  aws_ami_debian_id = data.aws_ami.debian.id
  aws_key_pair_name = aws_key_pair.deployer.key_name
}
