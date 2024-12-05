# Public Subnet
resource "aws_subnet" "spark_consumer" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-3a"

  tags = {
    Name = "spark-consumer-subnet"
  }
}

# Route Table Associations
resource "aws_route_table_association" "spark_consumer" {
  subnet_id      = aws_subnet.spark_consumer.id
  route_table_id = var.route_table_id
}
