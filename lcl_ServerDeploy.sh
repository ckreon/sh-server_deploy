#!/bin/bash

SS_FROM_SETUP=false

echo ""
echo "#######################################"
echo ""
echo "Welcome to the Server Deploy script!"
echo ""
echo "#######################################"
echo ""

# Make sure we came from _Setup.sh so variables are initialized
if [ "$SS_FROM_SETUP" = true ] ; then
	echo "Great - looks like we came from the setup script!"
	echo ""
	echo "Variables are properly set!"
	echo ""
	echo "#######################################"
else
	echo "This script should be launched from _Setup.sh."
  echo "Variables will not be initialized otherwise."
  echo ""
	echo "#######################################"

  exit 1
fi

#
# INITIAL SETUP
#

# Connect to Server as root and run apt-get update/upgrade & install expect
expect <<- DONE
  set timeout -1

  spawn ssh root@$SS_SERVER_IP_AD "apt-get update && apt-get -y upgrade && apt-get -y install expect"
  # Look for prompt
  expect "*?(yes/no)\?*"
  # Send response
  send -- "yes\r"

  expect eof
DONE

# Put user and password variable into the AddUser script
sed -i '' "s/\(SS_NEW_SRVR_USR *=\" *\).*/\1$SS_NEW_SRVR_USR\"/" srvr_AddUser.sh
sed -i '' "s/\(SS_SRVR_USR_PWD *=\" *\).*/\1$SS_SRVR_USR_PWD\"/" srvr_AddUser.sh

# Copy AddUser script to server
scp srvr_AddUser.sh root@$SS_SERVER_IP_AD:~

echo ""
echo "Starting AddUser server script!"
echo ""

# Connect to Server and Deploy AddUser script then remove it
ssh root@$SS_SERVER_IP_AD ". ~/srvr_AddUser.sh && rm ~/srvr_AddUser.sh"

# Remove user and password variables from the AddUser script
sed -i '' "s/\(SS_NEW_SRVR_USR *=\" *\).*/\1\"/" srvr_AddUser.sh
sed -i '' "s/\(SS_SRVR_USR_PWD *=\" *\).*/\1\"/" srvr_AddUser.sh

echo ""
echo "Copying SSH key for new user!"
echo ""

# Run ssh-copy-id to copy User Key to Server
expect <<- DONE
  set timeout -1

  # Use '-i $SS_USR_KEY_PATH' for custom keys
  spawn ssh-copy-id -i $SS_USR_KEY_PATH $SS_NEW_SRVR_USR@$SS_SERVER_IP_AD 
  # Look for prompt
  expect "*?assword:*"
  # Send response
  send -- "$SS_SRVR_USR_PWD\r"

  expect eof
DONE

echo ""
echo "Testing new user..."
echo ""

# Test SSH into server as new user
ssh $SS_NEW_SRVR_USR@$SS_SERVER_IP_AD "echo 'It worked!'"

echo ""
echo "#######################################"
echo ""
echo "Finished with AddUser!"
echo ""
echo "#######################################"
echo ""

# Put SSL variable into the ServerConfig script
sed -i '' "s/\(SS_ENABLE_FWHTP *= *\).*/\1$SS_ENABLE_FWHTP/" srvr_FirewallConfig.sh
sed -i '' "s/\(SS_ENABLE_FWSSL *= *\).*/\1$SS_ENABLE_FWSSL/" srvr_FirewallConfig.sh
sed -i '' "s/\(SS_ENABLE_FWMAL *= *\).*/\1$SS_ENABLE_FWMAL/" srvr_FirewallConfig.sh

# Copy FirewallConfig script to server
scp srvr_FirewallConfig.sh $SS_NEW_SRVR_USR@$SS_SERVER_IP_AD:~

echo ""
echo "Starting FirewallConfig server script!"
echo ""

# Connect to Server and Deploy FirewallConfig script then remove it
ssh $SS_NEW_SRVR_USR@$SS_SERVER_IP_AD "sudo bash srvr_FirewallConfig.sh && rm ~/srvr_FirewallConfig.sh"

# Remove variables from FireWall Config
sed -i '' "s/\(SS_ENABLE_FWHTP *= *\).*/\1/" srvr_FirewallConfig.sh
sed -i '' "s/\(SS_ENABLE_FWSSL *= *\).*/\1/" srvr_FirewallConfig.sh
sed -i '' "s/\(SS_ENABLE_FWMAL *= *\).*/\1/" srvr_FirewallConfig.sh

echo ""
echo "#######################################"
echo ""
echo "Finished with FirewallConfig!"
echo ""
echo "#######################################"
echo ""

# Copy NTPConfig script to server
scp srvr_NTPConfig.sh $SS_NEW_SRVR_USR@$SS_SERVER_IP_AD:~

echo ""
echo "Starting NTPConfig server script!"
echo ""

# Connect to Server and Deploy NTPConfig script then remove it
ssh $SS_NEW_SRVR_USR@$SS_SERVER_IP_AD "sudo bash srvr_NTPConfig.sh && rm ~/srvr_NTPConfig.sh"

echo ""
echo "#######################################"
echo ""
echo "Finished with NTPConfig!"
echo ""
echo "#######################################"
echo ""

if [ "$SS_ENABLE_SWAPF" = true ] ; then
	# Put Swapsize and Powerdown variable into the SwapConfig script
	sed -i '' "s/\(SS_SWAPFIL_SIZE *=\" *\).*/\1$SS_SWAPFIL_SIZE\"/" srvr_SwapConfig.sh
	sed -i '' "s/\(SS_PWR_DWN_DROP *= *\).*/\1$SS_PWR_DWN_DROP/" srvr_SwapConfig.sh

	# Copy SwapConfig script to server
	scp srvr_SwapConfig.sh $SS_NEW_SRVR_USR@$SS_SERVER_IP_AD:~

	echo ""
	echo "Starting SwapConfig server script!"
	echo ""

	# Connect to Server and Deploy SwapConfig script then remove it
	ssh $SS_NEW_SRVR_USR@$SS_SERVER_IP_AD "sudo bash srvr_SwapConfig.sh && rm ~/srvr_SwapConfig.sh"

	# Remove Swapsize and Powerdown variable from SwapConfig
	sed -i '' "s/\(SS_SWAPFIL_SIZE *=\" *\).*/\1\"/" srvr_SwapConfig.sh
	sed -i '' "s/\(SS_PWR_DWN_DROP *= *\).*/\1/" srvr_SwapConfig.sh

	echo ""
	echo "#######################################"
	echo ""
	echo "Finished with SwapConfig!"
	echo ""
	echo "#######################################"
	echo ""
fi

echo ""
echo "#######################################"
echo ""
echo "Finished with General Server Config!"
echo ""
echo "#######################################"
echo ""

if [ "$SS_SRV_APPINSTL" = true ] ; then
	echo ""
	echo "Great! Let's install the server Apps."
	echo ""

	# Copy variables to _SetupApps script
	sed -i '' "s/\(SS_SERVER_IP_AD *=\" *\).*/\1$SS_SERVER_IP_AD\"/" _SetupApps.sh
	sed -i '' "s/\(SS_NEW_SRVR_USR *=\" *\).*/\1$SS_NEW_SRVR_USR\"/" _SetupApps.sh
	sed -i '' "s/\(SS_PACK_PREREQS *=\" *\).*/\1$SS_PACK_PREREQS\"/" _SetupApps.sh
	sed -i '' "s/\(SS_INSTALL_RUBY *= *\).*/\1$SS_INSTALL_RUBY/" _SetupApps.sh
	sed -i '' "s/\(SS_RUBY_VERSION *=\" *\).*/\1$SS_RUBY_VERSION\"/" _SetupApps.sh
	sed -i '' "s/\(SS_PWR_DWN_DROP *= *\).*/\1$SS_PWR_DWN_DROP/" _SetupApps.sh

	# Launch the SetupApps script
	. _SetupApps.sh

	# Reset the variables in the _SetupApps script
	sed -i '' "s/\(SS_SERVER_IP_AD *=\" *\).*/\1\"/" _SetupApps.sh
	sed -i '' "s/\(SS_NEW_SRVR_USR *=\" *\).*/\1\"/" _SetupApps.sh
	sed -i '' "s/\(SS_PACK_PREREQS *=\" *\).*/\1\"/" _SetupApps.sh
	sed -i '' "s/\(SS_INSTALL_RUBY *= *\).*/\1/" _SetupApps.sh
	sed -i '' "s/\(SS_RUBY_VERSION *=\" *\).*/\1\"/" _SetupApps.sh
	sed -i '' "s/\(SS_PWR_DWN_DROP *= *\).*/\1/" _SetupApps.sh
else
	echo ""
  echo "All done, enjoy!"
  echo ""
fi
