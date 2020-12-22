#!/bin/bash

set -e

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
source ~/.nvm/nvm.sh
nvm install node
npm install

if [ -f /lib/systemd/system/bookinfo_ratings.service ] ; then
  cp ~/bookinfo-ratings/bookinfo_ratings.service /lib/systemd/system/
  sudo systemctl daemon-reload
  sudo systemctl restart bookinfo_ratings
else
  cp ~/bookinfo-ratings/bookinfo_ratings.service /lib/systemd/system/
  sudo systemctl daemon-reload
  sudo systemctl start bookinfo_ratings
  sudo systemctl enable bookinfo_ratings
fi
