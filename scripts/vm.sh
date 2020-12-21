#!/bin/bash

if [ $# -eq 0 ] ; then
  echo "No arguments supplied" >&2
  exit 1
fi

bash prepare.sh

if [ "$1" == "create" ] ; then
  cd ../aws-instance
  terraform init
  terraform plan -var "ssh_public_key=$(cat ~/.ssh/id_rsa.pub)"
  terraform apply -var "ssh_public_key=$(cat ~/.ssh/id_rsa.pub)" -auto-approve
elif [ "$1" == "destroy" ] ; then
  cd ../aws-instance
  terraform destroy -var "ssh_public_key=$(cat ~/.ssh/id_rsa.pub)" -auto-approve
fi
