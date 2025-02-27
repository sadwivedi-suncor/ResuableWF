#!/bin/bash
set -e

echo 'Get cf Client'
wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo apt-key add -
echo "deb https://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list
sudo apt-get update
sudo apt-get install cf8-cli

echo 'Check Installation'
cf -v

echo 'Install Plugins'
cf add-plugin-repo CF-Community https://plugins.cloudfoundry.org
cf install-plugin multiapps -f
cf install-plugin html5-plugin -f

echo 'Build the project'
npx mbt build --mtar app.mtar

echo 'Login BTP'
echo cf api $cf_api_url
cf login -a $cf_api_url -u $cf_user -p $cf_password
#cf auth $cf_user "$cf_password"
#cf login -a https://api.cf.us20.hana.ondemand.com -u sadwivedi@suncor.com -p 'asdsdsf' -o Suncor_Energy_Services_Inc_Attn:_Accounts_Payable_clfdev01 -s DEV 
#cf login -a https://api.cf.us20.hana.ondemand.com -o Suncor_Energy_Services_Inc_Attn:_Accounts_Payable_clfdev01 -s DEV --sso-passcode s5t0gXTA54S2_uL7j2dPVNAX7OMAZ8XC

echo 'Deploy the app'
#cf target -o $cf_org -s $cf_space
cf deploy mta_archives/app.mtar -f