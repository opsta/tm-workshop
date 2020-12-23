#!/bin/bash

set -e

if [ $# -eq 0 ] ; then
  echo "No arguments supplied" >&2
  exit 1
fi

bash prepare.sh

if [ "$1" == "create" ] ; then
  cd ../tf-aws-lambda
  terraform init
  terraform plan
  terraform apply -auto-approve
elif [ "$1" == "destroy" ] ; then
  cd ../tf-aws-lambda
  terraform destroy -auto-approve
else
  echo "No action"
fi
