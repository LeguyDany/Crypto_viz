# Public Subnet
resource "aws_subnet" "spark_producer" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-3a"

  tags = {
    Name = "spark-producer-subnet"
  }
}

# Route Table Associations
resource "aws_route_table_association" "spark_producer" {
  subnet_id      = aws_subnet.spark_producer.id
  route_table_id = var.route_table_id
}
