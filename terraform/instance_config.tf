# AMI Configuration
data "aws_ami" "debian" {
    most_recent = true
    owners = ["136693071363"]

    filter {
        name = "name"
        values = ["debian-12-amd64-*"]
    }

    filter {
        name = "state"
        values = ["available"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

# Variables
variable "instance_count_kafka" {
  description = "Nombre d'instances à créer"
  type        = number
  default     = 2
}
variable "instance_count_spark" {
  description = "Nombre d'instances à créer"
  type        = number
  default     = 3
}

