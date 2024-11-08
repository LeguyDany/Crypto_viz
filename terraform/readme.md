# How to setup

## Credentials

Follow these commands:

```sh
    mkdir ~/.aws
    touch ~/.aws/credentials
```

Copy this and insert your AWS credentials in that file:

```txt
[default]
aws_access_key_id = "your_access_key"
aws_secret_access_key = "your_secret_key"
```

Generate a .pub file:

```sh
    ssh-keygen -y -f ./zookeeper-kafka-1.pem > ~/.ssh/crypto_viz.pub
```