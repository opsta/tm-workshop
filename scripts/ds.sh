#!/bin/bash

set -e

cd ../tf-aws-instance/
export DS_IP=$(terraform output -raw public_ip)
cd ../ansible-playbooks/
ansible-playbook -i $DS_IP, ds.yml \
  -e tmds_download_tenant_id=$1 \
  -e tmds_activation_tenant_id=$2 \
  -e tmds_activation_token=$3 \
  -e tmds_activation_policy_id=4
