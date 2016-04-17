#!/bin/bash

#
# VARIABLES
#

# Server IP
SS_SERVER_IP_AD=""

# New Server User Name
SS_NEW_SRVR_USR=""

# Set packages that are prerequisite here
SS_PACK_PREREQS=""

# Set whether or not to install Ruby
SS_INSTALL_RUBY=

# Set version of Ruby to install
SS_RUBY_VERSION=""

# Power down droplet after App Install
SS_PWR_DWN_DROP=

#
# DEPLOY SCRIPT
#

sed -i '' "s/\(SS_PACK_PREREQS *=\" *\).*/\1$SS_PACK_PREREQS\"/" srvr_AppInstall.sh
sed -i '' "s/\(SS_INSTALL_RUBY *= *\).*/\1$SS_INSTALL_RUBY/" srvr_AppInstall.sh
sed -i '' "s/\(SS_RUBY_VERSION *=\" *\).*/\1$SS_RUBY_VERSION\"/" srvr_AppInstall.sh
sed -i '' "s/\(SS_PWR_DWN_DROP *= *\).*/\1$SS_PWR_DWN_DROP/" srvr_AppInstall.sh

# Copy AppInstall script to server
scp srvr_AppInstall.sh $SS_NEW_SRVR_USR@$SS_SERVER_IP_AD:~

# Reset the variables in the AppInstall script
sed -i '' "s/\(SS_PACK_PREREQS *=\" *\).*/\1\"/" srvr_AppInstall.sh
sed -i '' "s/\(SS_INSTALL_RUBY *= *\).*/\1/" srvr_AppInstall.sh
sed -i '' "s/\(SS_RUBY_VERSION *=\" *\).*/\1\"/" srvr_AppInstall.sh
sed -i '' "s/\(SS_PWR_DWN_DROP *= *\).*/\1/" srvr_AppInstall.sh

echo ""
echo "Starting AppInstall server script!"
echo ""

# Connect to Server and Deploy AppInstall script then remove it
ssh $SS_NEW_SRVR_USR@$SS_SERVER_IP_AD ". ~/srvr_AppInstall.sh && rm ~/srvr_AppInstall.sh"

echo ""
echo "#######################################"
echo ""
echo "Finished with AppInstall!"
echo ""
echo "#######################################"
echo ""