# Public Subnet
resource "aws_subnet" "kafka" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-3a"

  tags = {
    Name = "kafka-subnet"
  }
}

# Route Table Associations
resource "aws_route_table_association" "kafka" {
  subnet_id      = aws_subnet.kafka.id
  route_table_id = var.route_table_id
}
