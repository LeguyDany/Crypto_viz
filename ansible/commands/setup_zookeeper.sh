#!/bin/sh
ansible-playbook -i ../inventory ../playbooks/setup_zookeeper.yaml --vault-password-file ../vault_pass.txt