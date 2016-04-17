#!/bin/bash

SS_SWAPFIL_SIZE=""
SS_PWR_DWN_DROP=

# Allocate swap space
fallocate -l $SS_SWAPFIL_SIZE /swapfile

# Restrict access to swap space
chmod 600 /swapfile

# Format the file for swap
mkswap /swapfile

# Turn on swap file for the system
swapon /swapfile

# Make swap start automatically at boot
sh -c 'echo "/swapfile none swap sw 0 0" >> /etc/fstab'

echo ""
echo "#######################################"
echo ""
echo "Swap is now configured!"
echo ""

if [ "$SS_PWR_DWN_DROP" = true ] ; then
	echo ""
	echo "Ok, shutting down..."
	echo "Take a snapshot for backup!"
	echo ""
	echo "#######################################"
	echo ""

	poweroff

else
	echo ""
  echo "Ok, done with SwapConfig!"
  echo ""
  echo "#######################################"
	echo ""
fi
