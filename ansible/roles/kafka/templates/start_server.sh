#!/bin/sh
{{setup_path}}/zookeeper/apache-zookeeper-3.9.3-bin/bin/zkServer.sh start 

{{setup_path}}/kafka/kafka_2.13-3.9.0/bin/kafka-server-start.sh {{setup_path}}/kafka/kafka_2.13-3.9.0/config/server.properties

