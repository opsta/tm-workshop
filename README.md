# Terraform for Trend Micro Cloud One Workshop

## First initial

```bash
git clone https://github.com/opsta/tm-workshop.git
cd tm-workshop/
```

## Inside folder ./scripts/

```bash
cd ./scripts/
```

### Create VM

```bash
./vm.sh create
```

### Install Trend Micro Deep Security Agent

```bash
./vm.sh install [TenentNumber] [TenentID] [Token]
```

### Brute Force SSH

```bash
./vm.sh attack-ssh
```

### Install Nginx on VM

```bash
./vm.sh install-nginx
```

## Delete VM

```bash
./vm.sh delete
```

## Cloud Conformity Auto Remediate

```bash
git clone https://github.com/cloudconformity/auto-remediate.git
cd auto-remediate
sudo npm install -g serverless
npm install
serverless deploy --region ap-southeast-1
```
