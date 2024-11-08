# Key Pair Configuration
resource "aws_key_pair" "deployer" {
  key_name   = "zookeeper-kafka-key"
  public_key = file("~/.ssh/crypto_viz.pub")
}
