#!/bin/bash

SS_NEW_SRVR_USR=""
SS_SRVR_USR_PWD=""

echo ""
echo "#######################################"
echo ""
echo "Starting AddUser script!"
echo ""
echo "#######################################"
echo ""

echo ""
echo "Adding user $SS_NEW_SRVR_USR..."
echo ""

# Add non-root user
expect <<- DONE
  set timeout -1

  # Add the user specified in ServerSetup
	spawn adduser --gecos "" $SS_NEW_SRVR_USR
  # Look for prompt
  expect "*?assword:*"
  # Send response
  send -- "$SS_SRVR_USR_PWD\r"
  # Look for prompt
  expect "*?assword:*"
  # Send response
  send -- "$SS_SRVR_USR_PWD\r"

  expect eof
DONE

# Add user to sudo group
echo ""
echo "Adding $SS_NEW_SRVR_USR to sudo group..."
echo ""
gpasswd -a $SS_NEW_SRVR_USR sudo

# Disable sudo requiring password for this user
echo 'ckreon ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Modify sshd_config to disallow root login
echo ""
echo "Disallowing root login..."
echo ""
sed -i "s/\(PermitRootLogin *\).*/\1no/" /etc/ssh/sshd_config

# Restart SSH service
echo ""
echo "Restarting SSH service..."
echo ""
service ssh restart

echo ""
echo "#######################################"
echo ""
echo "All done with the AddUser script!"
echo ""
echo "#######################################"
echo ""
