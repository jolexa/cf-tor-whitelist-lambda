#!/bin/bash

DIR=$(mktemp -d)
cd $DIR

# Install awscli python lib + deps in buildroot
pip install requests -t .
# Fetch aws cli wrapper from github
wget https://raw.githubusercontent.com/jolexa/cloudflare-tor-whitelister/master/cfwhitelist/whitelist.py
# Fetch the main script from this repo
wget https://raw.githubusercontent.com/jolexa/cf-tor-whitelist-lambda/master/main.py

# Have to hardcode the bucket name for secrets. TODO, this is not ideal but it
# works for now
sed -i -e "s/BUCKETNAME/$1/" main.py

# create zip
zip -r9 /tmp/cf-tor-whitelist-lambda.zip *
cd ..
# cleanup
rm -rf $DIR
