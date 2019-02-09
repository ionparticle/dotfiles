#!/bin/bash

GIT_REPO=https://github.com/ionparticle/dotfiles.git
DOTFILES_DIR=.dotfiles

echo "Checking for dependencies:"
# curl needed for grabbing vim-plugin
REQUIRED_PROGRAMS=('git' 'vim' 'stow' 'curl')
for i in ${REQUIRED_PROGRAMS[@]}; do
	printf "\t$i - "
	command -v $i >/dev/null 2>&1 || { echo >&2 " failed, aborting."; exit 1; }
	printf "success!\n"
done

cd $HOME
if [ ! -d $DOTFILES_DIR ]; then
	printf "Cloning dotfiles repo... "
	git clone $GIT_REPO $DOTFILES_DIR || \
		{ echo >&2 " failed, aborting."; exit 1; }
	printf "done!\n"
fi

# Make symlinks to the dotfiles using stow
cd $DOTFILES_DIR
./stow.sh

# Setup vim plugins
printf "Setting up all the vim plugins... "
vim +'PlugInstall --sync' +qall || { echo >&2 "Failed, aborting."; exit 1; }
printf "done!\n"

printf "Installing cron job for automatic dotfile updates..."
# will update dotfiles everyday at 9am
(crontab -l | grep -v $DOTFILES_DIR; echo \
	"0 9 * * * cd $HOME/$DOTFILES_DIR;git pull;./stow.sh") | crontab - || \
	{ echo >&2 " failed, aborting."; exit 1;}
echo " success!"
