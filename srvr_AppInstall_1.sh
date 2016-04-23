#!/bin/bash
set -x

SS_PACK_PREREQS=""
SS_INSTALL_RUBY=
SS_RUBY_VERSION=""

#
# APP INSTALLATION
#

# Install prerequisite packages
echo "Installing Pre-req's..."
sudo apt-get update
sudo apt-get -y install $SS_PACK_PREREQS

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
	echo "Installing ruby version $SS_RUBY_VERSION..."

	# Install ruby version
	~/.rbenv/bin/rbenv install $SS_RUBY_VERSION

	# Set installed version as global
	~/.rbenv/bin/rbenv global $SS_RUBY_VERSION
fi
