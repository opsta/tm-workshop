#!/bin/bash

set -e

install_amzn () {
  if ! command -v terraform &> /dev/null ; then
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
    sudo yum install -y terraform
  fi
  if ! command -v ansible &> /dev/null ; then
    sudo amazon-linux-extras install -y epel
    sudo yum install -y ansible
  fi
}

install_debian () {
  if ! command -v terraform &> /dev/null ; then
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    sudo apt-get update
    sudo apt-get install terraform
  fi
}

install_rhel () {
  if ! command -v terraform &> /dev/null ; then
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
    sudo yum -y install terraform
  fi
}

install_common () {
  [[ ! -f ~/.ansible/roles/opsta.ansible_trendmicro_ds/README.md ]] && ansible-galaxy install opsta.ansible_trendmicro_ds
}

# Generate SSH
[[ ! -f ~/.ssh/id_rsa ]] && ssh-keygen -f ~/.ssh/id_rsa -N ""

# Check Linux Distribution
if type lsb_release >/dev/null 2>&1 ; then
  distro=$(lsb_release -i -s)
elif [ -e /etc/os-release ] ; then
  distro=$(awk -F= '$1 == "ID" {print $2}' /etc/os-release)
fi

# convert to lowercase
distro=$(printf '%s\n' "$distro" | LC_ALL=C tr '[:upper:]' '[:lower:]')

# Install required packages
case "$distro" in
  *amzn*)   install_amzn ;;
  *debian*) install_debian ;;
  *centos*) install_rhel ;;
  *ubuntu*) install_debian ;;
  *)        echo "unknown distro: '$distro'" ; exit 1 ;;
esac

install_common
