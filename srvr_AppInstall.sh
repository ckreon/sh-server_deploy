#!/bin/bash

SS_PACK_PREREQS=""
SS_INSTALL_RUBY=
SS_RUBY_VERSION=""
SS_PWR_DWN_DROP=

#
# SERVER INSTALLATION
#

# Install prerequisite packages
echo "Installing Pre-req's..."
sudo apt-get update
sudo apt-get -y install $SS_INSTL_PREREQS

# Install rbenv
if [ "$SS_INSTALL_RUBY" = true ] ; then
	echo "Installing rbenv..."
	git clone https://github.com/rbenv/rbenv.git ~/.rbenv
	# Compile dynamic bash extension
	cd ~/.rbenv && src/configure && make -C src
	# Add rbenv to PATH and rbenv init to .bashrc
	echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
	echo 'eval "$(rbenv init -)"' >> ~/.bashrc

	# Run rbenv init
	~/.rbenv/bin/rbenv init

	# Install ruby-build
	echo "Installing ruby-build..."
	git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

	# Launch new shell to get updated PATH
	bash

	# Install ruby version
	echo "Installing ruby version $SS_RUBY_VERSION..."
	rbenv install $SS_RUBY_VERSION

	# Set installed version as global
	rbenv global $SS_RUBY_VERSION

fi

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
	gem update --system
	gem install bundler
	gem update
	gem cleanup

	# Uninstall the rubygems-update package
	expect <<- DONE
	  set timeout -1

	  spawn gem uninstall rubygems-update
	  # Look for prompt
	  expect "*?[Yn]*"
	  # Send response
	  send -- "y\r"

	  expect eof
	DONE
fi

#
# Install additional apps
#



#
# /additional apps
#

if [ "$SS_INSTALL_RUBY" = true ] ; then
	# Close new shell launched by Ruby install
	exit
fi

# Generate and add an SSH key with no pass-phrase
echo "Generating SSH key and adding it to client..."
ssh-keygen -t rsa -b 4096 -C $SSH_KEY_DESC -f ~/.ssh/id_rsa -q -P ""
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

# Open SSH public key in ST3 to use as needed
echo "Opening SSH public key for use"
subl ~/.ssh/id_rsa.pub

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