#!/bin/bash

set -e

if [ $# -eq 0 ] ; then
  echo "No arguments supplied" >&2
  exit 1
fi

bash prepare.sh

if [ "$1" == "create" ] ; then
  cd ../tf-aws-instance
  terraform init
  terraform plan -var "ssh_public_key=$(cat ~/.ssh/id_rsa.pub)"
  terraform apply -var "ssh_public_key=$(cat ~/.ssh/id_rsa.pub)" -auto-approve
elif [ "$1" == "destroy" ] ; then
  cd ../tf-aws-instance
  terraform destroy -var "ssh_public_key=$(cat ~/.ssh/id_rsa.pub)" -auto-approve
elif [ "$1" == "attack-ssh" ] ; then
  cd ../tf-aws-instance
  watch -n1 ssh $(terraform output -raw public_ip)
elif [ "$1" == "install-nginx" ] ; then
  cd ../tf-aws-instance
  ssh ec2-user@$(terraform output -raw public_ip) sudo amazon-linux-extras install nginx1
elif [ "$1" == "install-agent" ] ; then
  cd ../tf-aws-instance/
  ansible-playbook -i $(terraform output -raw public_ip), ../ansible-playbooks/ds.yml \
    -e ansible_user=ec2-user \
    -e tmds_download_tenant_id=$2 \
    -e tmds_activation_tenant_id=$3 \
    -e tmds_activation_token=$4 \
    -e tmds_activation_policy_id=4
fi
