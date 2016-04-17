#!/bin/bash

#
# SERVER INSTALLATION
#


# 
# SCRIPTS
#

# Setup server to use ST3 on local machine with RMATE+RSUB
wget -O /usr/local/bin/subl https://raw.github.com/aurora/rmate/master/rmate

chmod a+x /usr/local/bin/subl

# Clone server_files repo into home directory
git clone https://github.com/ckreon/server_files.git ~/

# SymLink .bashrc
if [ -f ~/.bashrc ]; then
	rm ~/.bashrc
fi

ln -s ~/server_files/.bashrc ~/

# SymLink .gemrc
if [ -f ~/.gemrc ]; then
	rm ~/.gemrc
fi

ln -s ~/server_files/.gemrc ~/

# SymLink .gitconfig
if [ -f ~/.gitconfig ]; then
	rm ~/.gitconfig
fi

ln -s ~/server_files/.gitconfig ~/



# Generate and add an SSH key with no passphrase
ssh-keygen -t rsa -b 4096 -C $SSH_KEY_DESC -f ~/.ssh/id_rsa -q -P ""

eval "$(ssh-agent -s)"

ssh-add ~/.ssh/id_rsa

# Open SSH public key in ST3 to use as needed
subl ~/.ssh/id_rsa.pub