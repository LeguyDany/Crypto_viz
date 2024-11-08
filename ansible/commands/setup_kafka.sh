#!/bin/sh
ansible-playbook -i ../inventory ../playbooks/setup_kafka.yaml --vault-password-file ../vault_pass.txt