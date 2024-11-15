# Security group
resource "aws_security_group" "zookeeper_kafka_sg" {
  name        = "zookeeper-kafka-sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # === SSH ===
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  # === Zookeeper ===
  # Client port
  ingress { 
    from_port   = 2181
    to_port     = 2181
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
  # Leader election port
  ingress {
    from_port   = 3888
    to_port     = 3888
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
  # Quorum port
  ingress {
    from_port   = 2888
    to_port     = 2888
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  tags = {
    Name = "zookeeper-kafka-sg"
  }
}