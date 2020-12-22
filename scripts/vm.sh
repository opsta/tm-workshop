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
elif [ "$1" == "ip" ] ; then
  cd ../tf-aws-instance
  echo $(terraform output -raw public_ip)
elif [ "$1" == "attack-ssh" ] ; then
  cd ../tf-aws-instance
  watch -n1 ssh $(terraform output -raw public_ip)
elif [ "$1" == "attack-eicar" ] ; then
  cd ../tf-aws-instance
  ssh ec2-user@$(terraform output -raw public_ip) \
    "curl -O http://files.trendmicro.com/products/eicar-file/eicar.com"
elif [ "$1" == "install-nginx" ] ; then
  cd ../tf-aws-instance
  ssh ec2-user@$(terraform output -raw public_ip) sudo amazon-linux-extras install nginx1
elif [ "$1" == "install-app" ] ; then
  cd ../tf-aws-instance
  export IP=$(terraform output -raw public_ip)
  scp -r ../bookinfo-ratings ec2-user@$IP:~
  ssh ec2-user@$IP "bash ~/bookinfo-ratings/deploy.sh $2 $3 $4"
elif [ "$1" == "app-log" ] ; then
  cd ../tf-aws-instance
  ssh ec2-user@$$(terraform output -raw public_ip) "journalctl -u bookinfo_ratings.service -f"
elif [ "$1" == "install-agent" ] ; then
  cd ../tf-aws-instance/
  ansible-playbook -i $(terraform output -raw public_ip), ../ansible-playbooks/ds.yml \
    -e ansible_user=ec2-user \
    -e tmds_download_tenant_id=$2 \
    -e tmds_activation_tenant_id=$3 \
    -e tmds_activation_token=$4 \
    -e tmds_activation_policy_id=4
elif [ "$1" == "install-docker" ] ; then
  cd ../tf-aws-instance
  export IP=$(terraform output -raw public_ip)
  ssh ec2-user@$IP \
    "sudo bash -c 'amazon-linux-extras install docker; usermod -a -G docker ec2-user; systemctl start docker; systemctl enable docker'"
  ssh ec2-user@$IP \
    "bash -c '[ ! '"'$(docker ps -q -f name=nginx)'"' ] && docker run -d --name nginx -p 8080:80 nginx'"
fi
