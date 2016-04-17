#!/bin/bash

#
# VARIABLES
#

# Server IP
SS_SERVER_IP_AD="198.199.106.223"

# New Server User Name
SS_NEW_SRVR_USR="ckreon"

# Set $SS_PASSWORD from the command line: ( SS_PASSWORD=MyPassword123 )
# !!! DON'T USE SPECIAL CHARACTERS !!!
SS_SRVR_USR_PWD=$SS_PASSWORD

# SSH Key Path for User
SS_USR_KEY_PATH="$HOME/Dropbox/Backups/Keys/id_rsa.pub"

# Enable HTTP on Server Firewall
SS_ENABLE_FWHTP=false

# Enable SSL on Server Firewall
SS_ENABLE_FWSSL=false

# Enable Mail on Server Firewall
SS_ENABLE_FWMAL=false

# Enable Swapfile on Server
SS_ENABLE_SWAPF=true

# Size of Swapfile to create
SS_SWAPFIL_SIZE="1G"

# Power down droplet after basic config
SS_PWR_DWN_DROP=false

# Launch App Install script when server config is done
SS_SRV_APPINSTL=true

# Set packages that are prerequisite here
SS_PACK_PREREQS="build-essential git"

# Set whether or not to install Ruby
SS_INSTALL_RUBY=true

# Set version of Ruby to install
SS_RUBY_VERSION="2.3.0"

#
# DEPLOY SCRIPT
#

# Let the deploy script know it was launched from Setup
sed -i '' "s/\(SS_FROM_SETUP *= *\).*/\1true/" lcl_ServerDeploy.sh

. lcl_ServerDeploy.sh

# Change FROM_SETUP variable back to false
sed -i '' "s/\(SS_FROM_SETUP *= *\).*/\1/" lcl_ServerDeploy.sh

echo ""
echo "####  ####  ####  ####"
echo "####  ####  ####  ####"
echo ""
echo "Server Configured!"
echo ""
echo "####  ####  ####  ####"
echo "####  ####  ####  ####"
echo ""