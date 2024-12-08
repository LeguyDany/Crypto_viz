#!/bin/sh
ansible-playbook -i ../inventory ../playbooks/setup_spark.yaml --vault-password-file ../vault_pass.txt