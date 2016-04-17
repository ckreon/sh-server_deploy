#!/bin/bash

SS_ENABLE_FWHTP=
SS_ENABLE_FWSSL=
SS_ENABLE_FWMAL=

# Allow SSH traffic through firewall
ufw allow ssh

# Allow HTTP traffic if set
if [ "$SS_ENABLE_FWHTP" = true ] ; then
	ufw allow 80/tcp
fi

# Allow SSL traffic if set
if [ "$SS_ENABLE_FWSSL" = true ] ; then
	ufw allow 443/tcp
fi

# Allow Mail traffic if set
if [ "$SS_ENABLE_FWMAL" = true ] ; then
	ufw allow 25/tcp
fi

echo ""
echo "#######################################"
echo ""
echo "Here are the rules you added to the Firewall:"
echo ""

ufw show added

echo ""
echo "#######################################"
echo ""
echo "Enabling Firewall!"
echo ""

# Enable firewall
expect <<- DONE
  set timeout -1

  spawn ufw enable

  # Look for prompt
  expect "*?(y|n)\?*"
  # Send response
  send -- "y\r"

  expect eof
DONE
