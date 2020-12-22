#!/bin/bash

set -e

sudo yum groupinstall "Development Tools" -y

if ! command -v node &> /dev/null ; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
  source ~/.nvm/nvm.sh
  nvm install node
fi

if [ "$1" == "sec" ] ; then
  cp ~/bookinfo-ratings/tm-appsec/* ~/bookinfo-ratings/
  sed -i "s@Environment=TREND_AP_KEY=@Environment=TREND_AP_KEY=$2@" ~/bookinfo-ratings/bookinfo_ratings.service
  sed -i "s@Environment=TREND_AP_SECRET=@Environment=TREND_AP_SECRET=$3@" ~/bookinfo-ratings/bookinfo_ratings.service
fi

cd ~/bookinfo-ratings/
npm install
sed -i "s@CHANGEME_NODE_PATH@$(realpath $(which node))@" ~/bookinfo-ratings/bookinfo_ratings.service
sudo cp ~/bookinfo-ratings/bookinfo_ratings.service /lib/systemd/system/
if [ -f /lib/systemd/system/bookinfo_ratings.service ] ; then
  sudo systemctl daemon-reload
  sudo systemctl restart bookinfo_ratings
else
  sudo cp ~/bookinfo-ratings/bookinfo_ratings.service /lib/systemd/system/
  sudo systemctl daemon-reload
  sudo systemctl start bookinfo_ratings
  sudo systemctl enable bookinfo_ratings
fi
