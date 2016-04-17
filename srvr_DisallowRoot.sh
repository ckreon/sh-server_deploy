#!/bin/bash

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