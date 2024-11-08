# Security group
resource "aws_security_group" "zookeeper_kafka_sg" {
  name        = "zookeeper-kafka-sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id  

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "zookeeper-kafka-sg"
  }
}