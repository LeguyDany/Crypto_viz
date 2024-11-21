#!/bin/sh

cd ../../terraform

elastic_ip_1=($(terraform output | grep instance_1 | awk '{print $3}'))
elastic_ip_2=($(terraform output | grep instance_2 | awk '{print $3}'))

cd ../ansible

sed -i '' "s/vm1_public_ip:.*/vm1_public_ip: ${elastic_ip_1[0]}/" ./playbooks/setup.yaml
sed -i '' "s/vm1_private_ip:.*/vm1_private_ip: ${elastic_ip_1[1]}/" ./playbooks/setup.yaml

sed -i '' "s/vm2_public_ip:.*/vm2_public_ip: ${elastic_ip_2[0]}/" ./playbooks/setup.yaml
sed -i '' "s/vm2_private_ip:.*/vm2_private_ip: ${elastic_ip_2[1]}/" ./playbooks/setup.yaml

sed -i '' "2s/[^ ]*/${elastic_ip_1[0]}/" ./inventory
sed -i '' "5s/[^ ]*/${elastic_ip_2[0]}/" ./inventory
