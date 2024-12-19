# Security group
resource "aws_security_group" "spark_consumer_sg" {
  name        = "spark-consumer-sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # IMCP pings
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.1.0/24"]
  }


  # === SSH ===
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  # === Spark ===
  # Master port
  ingress { 
    from_port   = 7077 
    to_port     = 7077
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
  # Worker port
  ingress {
    from_port   = 7080
    to_port     = 7080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 
  # Web UI master port
  ingress {
    from_port   = 7080
    to_port     = 7080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Web UI worker port
  ingress {
    from_port   = 7081
    to_port     = 7081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "spark-consumer-sg"
  }
}