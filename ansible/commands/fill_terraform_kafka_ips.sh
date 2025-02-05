#!/bin/sh

cd ../../terraform

elastic_ip_1=($(terraform output | grep instance_1_kafka | awk '{print $3}'))
elastic_ip_2=($(terraform output | grep instance_2_kafka | awk '{print $3}'))

cd ../ansible

sed -i '' "s/vm1_public_ip:.*/vm1_public_ip: ${elastic_ip_1[0]}/" ./playbooks/setup_kafka.yaml
sed -i '' "s/vm1_private_ip:.*/vm1_private_ip: ${elastic_ip_1[1]}/" ./playbooks/setup_kafka.yaml

sed -i '' "s/vm2_public_ip:.*/vm2_public_ip: ${elastic_ip_2[0]}/" ./playbooks/setup_kafka.yaml
sed -i '' "s/vm2_private_ip:.*/vm2_private_ip: ${elastic_ip_2[1]}/" ./playbooks/setup_kafka.yaml

sed -i '' "2s/[^ ]*/${elastic_ip_1[0]}/" ./inventory
sed -i '' "5s/[^ ]*/${elastic_ip_2[0]}/" ./inventory

# Cleanup known_hosts
ssh-keygen -R ${elastic_ip_1[0]}
ssh-keygen -R ${elastic_ip_2[0]}

# Add new keys
ssh-keyscan -H ${elastic_ip_1[0]} >> ~/.ssh/known_hosts
ssh-keyscan -H ${elastic_ip_2[0]} >> ~/.ssh/known_hosts