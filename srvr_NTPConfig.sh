#!/bin/bash

# Configure Timezone info
timedatectl set-timezone America/Los_Angeles

# Install NTP synchronization
apt-get update
apt-get -y install ntp