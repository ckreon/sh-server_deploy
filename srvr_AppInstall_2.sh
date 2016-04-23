#!/bin/bash
set -x

SS_INSTALL_RUBY=
SS_RUBY_VERSION=""
SSH_KEYGEN_SRVR=
SSH_KEY_DESCRIP=""
SS_PWR_DWN_DROP=

# 
# SCRIPTS
#

# Setup server to use ST3 on local machine with RMATE+RSUB
echo "Setting up remote ST editing..."
sudo wget -O /usr/local/bin/subl https://raw.github.com/aurora/rmate/master/rmate
sudo chmod a+x /usr/local/bin/subl

# Clone server_files repo into home directory
git clone https://github.com/ckreon/server_files.git ~/server_files

# SymLink .bashrc
echo "SymLinking .bashrc..."
if [ -f ~/.bashrc ] ; then
	rm ~/.bashrc
fi
ln -s ~/server_files/.bashrc ~/

# If Ruby installed, SymLink .gemrc
if [ "$SS_INSTALL_RUBY" = true ] ; then
	echo "SymLinking .gemrc..."
	if [ -f ~/.gemrc ] ; then
		rm ~/.gemrc
	fi
	ln -s ~/server_files/.gemrc ~/
fi

# SymLink .gitconfig
echo "SymLinking .gitconfig..."
if [ -f ~/.gitconfig ] ; then
	rm ~/.gitconfig
fi
ln -s ~/server_files/.gitconfig ~/

# If Ruby installed, update ruby-gems and install bundler
if [ "$SS_INSTALL_RUBY" = true ] ; then
	$HOME/.rbenv/versions/$SS_RUBY_VERSION/bin/ruby -v
	$HOME/.rbenv/versions/$SS_RUBY_VERSION/bin/gem update --system
	$HOME/.rbenv/versions/$SS_RUBY_VERSION/bin/gem install bundler
	$HOME/.rbenv/versions/$SS_RUBY_VERSION/bin/gem update
	$HOME/.rbenv/versions/$SS_RUBY_VERSION/bin/gem cleanup
	# Uninstall the rubygems-update package
	$HOME/.rbenv/versions/$SS_RUBY_VERSION/bin/gem uninstall -x rubygems-update
fi

#
# Install additional apps
#



#
# /additional apps
#

if [ "$SSH_KEYGEN_SRVR" = true ] ; then
	# Generate and add an SSH key with no pass-phrase
	echo "Generating SSH key and adding it to client..."
	ssh-keygen -t rsa -b 4096 -C $SSH_KEY_DESCRIP -f ~/.ssh/id_rsa -q -P ""
	eval "$(ssh-agent -s)"
	ssh-add ~/.ssh/id_rsa

	# Open SSH public key in ST3 to use as needed
	echo "Opening SSH public key for use"
	subl ~/.ssh/id_rsa.pub
fi

echo ""
echo "#######################################"
echo ""
echo "Apps are installed!"
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
  echo "Ok, done with AppInstall!"
  echo ""
  echo "#######################################"
	echo ""
fi
