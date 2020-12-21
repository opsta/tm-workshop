#!/bin/bash

install_terraform_amzn () {
  sudo yum install -y yum-utils
  sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
  sudo yum -y install terraform
}

install_terraform_debian () {
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
  sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
  sudo apt-get update && sudo apt-get install terraform
}

install_terraform_rhel () {
  sudo yum install -y yum-utils
  sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
  sudo yum -y install terraform
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

# now do different things depending on distro
case "$distro" in
  *amzn*)    install_terraform_amzn ;;
  *debian*)  install_terraform_debian ;;
  *centos*)  install_terraform_rhel ;;
  *ubuntu*)  install_terraform_debian ;;
  *)        echo "unknown distro: '$distro'" ; exit 1 ;;
esac
