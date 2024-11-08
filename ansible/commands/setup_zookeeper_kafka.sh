#!/bin/sh
ansible-playbook -i ../inventory ../playbooks/setup.yaml --vault-password-file ../vault_pass.txt