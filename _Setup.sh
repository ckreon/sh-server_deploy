#!/bin/bash

#
# VARIABLES
#

# Server IP
SS_SERVER_IP_AD="123.123.123.123"

# New Server User Name
SS_NEW_SRVR_USR="MY_USER"

# Set $SS_PASSWORD from the command line: ( SS_PASSWORD=MyPassword123 )
# !!! DON'T USE SPECIAL CHARACTERS !!!
SS_SRVR_USR_PWD=$SS_PASSWORD

# SSH Key Path for User
SS_USR_KEY_PATH="$HOME/.ssh/id_rsa.pub"

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
SS_SRV_APPINSTL=false

#
# DEPLOY SCRIPT
#

# Let the deploy script know it was launched from Setup
sed -i '' "s/\(SS_FROM_SETUP *= *\).*/\1true/" lcl_ServerDeploy.sh

. lcl_ServerDeploy.sh

# Change FROM_SETUP variable back to false
sed -i '' "s/\(SS_FROM_SETUP *= *\).*/\1false/" lcl_ServerDeploy.sh
