#!/bin/bash

cd ../../terraform

# IPs 
declare elastic_ip_con_public
declare elastic_ip_con_private
declare elastic_ip_prod_public
declare elastic_ip_prod_private

for i in 1 2 3; do
  elastic_ip_con=($(terraform output | grep instance_${i}_spark_consumer | awk '{print $3}'))
  elastic_ip_con_public[$i]=${elastic_ip_con[0]}
  elastic_ip_con_private[$i]=${elastic_ip_con[1]}

  elastic_ip_prod=($(terraform output | grep instance_${i}_spark_producer | awk '{print $3}'))
  elastic_ip_prod_public[$i]=${elastic_ip_prod[0]}
  elastic_ip_prod_private[$i]=${elastic_ip_prod[1]}
done

cd ../ansible

# Fill the IPs
for i in 1 2 3; do
  # Consumer
  sed -i '' "s/vm${i}_consumer_public_ip:.*/vm${i}_consumer_public_ip: ${elastic_ip_con_public[${i}]}/" ./playbooks/setup_spark.yaml
  sed -i '' "s/vm${i}_consumer_private_ip:.*/vm${i}_consumer_private_ip: ${elastic_ip_con_private[$i][1]}/" ./playbooks/setup_spark.yaml

  # Producer
  sed -i '' "s/vm${i}_producer_public_ip:.*/vm${i}_producer_public_ip: ${elastic_ip_prod_public[$i]}/" ./playbooks/setup_spark.yaml
  sed -i '' "s/vm${i}_producer_private_ip:.*/vm${i}_producer_private_ip: ${elastic_ip_prod_private[$i]}/" ./playbooks/setup_spark.yaml
done

# Fill the inventory
for i in 1 2 3; do
  sed -i '' "$((8 + (i - 1) * 3))s/[^ ]*/${elastic_ip_con_public[$i]}/" ./inventory
  sed -i '' "$((17 + (i - 1) * 3))s/[^ ]*/${elastic_ip_prod_public[$i]}/" ./inventory
done

# Cleanup known_hosts and add new keys
# for i in 1 2 3; do
  # ssh-keygen -R ${elastic_ip_con_public[$i]}
  # ssh-keygen -R ${elastic_ip_prod_public[$i]}

  # ssh-keyscan -H ${elastic_ip_con_public[$i]} >> ~/.ssh/known_hosts
  # ssh-keyscan -H ${elastic_ip_prod_public[$i]} >> ~/.ssh/known_hosts
# done