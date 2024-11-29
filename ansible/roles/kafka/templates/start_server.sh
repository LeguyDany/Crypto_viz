#!/bin/bash
# start_servers.sh

# Variables
ZOOKEEPER_PATH="/home/{{user}}/zookeeper/apache-zookeeper-3.9.3-bin"
KAFKA_PATH="/home/{{user}}/kafka/kafka_2.13-3.9.0"

# Zookeeper
echo "Starting Zookeeper..."
$ZOOKEEPER_PATH/bin/zkServer.sh start

# Wait for Zookeeper to start
sleep 10

# Check Zookeeper status
echo "Checking Zookeper's status..."
$ZOOKEEPER_PATH/bin/zkServer.sh status

# Start Kafka
echo "Starting Kafka..."
$KAFKA_PATH/bin/kafka-server-start.sh -daemon $KAFKA_PATH/config/server.properties

# Check Kafka status
echo "Checking kafka's status..."
sleep 10
$KAFKA_PATH/bin/kafka-topics.sh --list --bootstrap-server localhost:9092

private_ip=$(hostname -I | awk '{print $1}')
if [ "$private_ip" = "{{vm1_private_ip}}" ]; then 
    echo "Creating a new kafka topic named {{ kafka_topic_name }}"
    $KAFKA_PATH/bin/kafka-topics.sh --bootstrap-server localhost:9092 --topic {{ kafka_topic_name }} --create --partitions 3 --replication-factor 2
fi
