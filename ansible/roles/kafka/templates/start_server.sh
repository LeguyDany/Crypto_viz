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
