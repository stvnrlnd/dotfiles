#!/bin/sh

echo "Setting up your Mac..."

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle

# Install PHP extensions with PECL
pecl install memcached imagick

# Install global Composer packages
/usr/local/bin/composer global require laravel/installer laravel/valet

# Install Laravel Valet
$HOME/.composer/vendor/bin/valet install

# Create a Projects directory
# This is a default directory for macOS user accounts but doesn't comes pre-installed
mkdir -p $HOME/Projects/_sites

# Park Laravel Valet
cd $HOME/Projects/_sites && $HOME/.composer/vendor/bin/valet park && cd $HOME

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the Projects/_resources/dotfiles directory
rm -rf $HOME/.zshrc
ln -s $HOME/Projects/_resources/dotfiles/.zshrc $HOME/.zshrc

# Removes .gitconfig from $HOME (if it exists) and symlinks the .gitconfig file from the Projects/_resources/dotfiles directory
rm -rf $HOME/.gitconfig
ln -s $HOME/Projects/_resources/dotfiles/.gitconfig $HOME/.gitconfig

# Symlink the Mackup config file to the home directory
ln -s $HOME/Projects/_resources/dotfiles/.mackup.cfg $HOME/.mackup.cfg

# Set macOS preferences
# We will run this last because this will reload the shell
source .macos