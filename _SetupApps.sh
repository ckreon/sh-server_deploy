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

# Set whether to generate Server SSH key
SSH_KEYGEN_SRVR=

# Description for server-generated SSH key
SSH_KEY_DESCRIP=""

# Power down droplet after App Install
SS_PWR_DWN_DROP=

#
# DEPLOY SCRIPT
#

sed -i '' "s/\(SS_PACK_PREREQS *=\" *\).*/\1$SS_PACK_PREREQS\"/" srvr_AppInstall_1.sh
sed -i '' "s/\(SS_INSTALL_RUBY *= *\).*/\1$SS_INSTALL_RUBY/" srvr_AppInstall_1.sh srvr_AppInstall_2.sh
sed -i '' "s/\(SS_RUBY_VERSION *=\" *\).*/\1$SS_RUBY_VERSION\"/" srvr_AppInstall_1.sh srvr_AppInstall_2.sh
sed -i '' "s/\(SSH_KEYGEN_SRVR *= *\).*/\1$SSH_KEYGEN_SRVR/" srvr_AppInstall_2.sh
sed -i '' "s/\(SSH_KEY_DESCRIP *=\" *\).*/\1$SSH_KEY_DESCRIP\"/" srvr_AppInstall_2.sh

sed -i '' "s/\(SS_PWR_DWN_DROP *= *\).*/\1$SS_PWR_DWN_DROP/" srvr_AppInstall_2.sh

# Copy AppInstall script to server
scp srvr_AppInstall_1.sh srvr_AppInstall_2.sh $SS_NEW_SRVR_USR@$SS_SERVER_IP_AD:~

# Reset the variables in the AppInstall script
sed -i '' "s/\(SS_PACK_PREREQS *=\" *\).*/\1\"/" srvr_AppInstall_1.sh
sed -i '' "s/\(SS_INSTALL_RUBY *= *\).*/\1/" srvr_AppInstall_1.sh srvr_AppInstall_2.sh
sed -i '' "s/\(SS_RUBY_VERSION *=\" *\).*/\1\"/" srvr_AppInstall_1.sh srvr_AppInstall_2.sh
sed -i '' "s/\(SSH_KEYGEN_SRVR *= *\).*/\1/" srvr_AppInstall_2.sh
sed -i '' "s/\(SSH_KEY_DESCRIP *=\" *\).*/\1\"/" srvr_AppInstall_2.sh
sed -i '' "s/\(SS_PWR_DWN_DROP *= *\).*/\1/" srvr_AppInstall_2.sh

echo ""
echo "Starting AppInstall server script!"
echo ""

# Connect to Server and Deploy AppInstall_1 script then remove it
ssh $SS_NEW_SRVR_USR@$SS_SERVER_IP_AD ". ~/srvr_AppInstall_1.sh && rm ~/srvr_AppInstall_1.sh"

# Connect to Server and Deploy AppInstall_2 script then remove it
ssh $SS_NEW_SRVR_USR@$SS_SERVER_IP_AD ". ~/srvr_AppInstall_2.sh && rm ~/srvr_AppInstall_2.sh"

echo ""
echo "#######################################"
echo ""
echo "Finished with AppInstall!"
echo ""
echo "#######################################"
echo ""

echo ""
echo "Remember to have fun."
echo ""
