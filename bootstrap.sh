#!/bin/bash

HOST="$(hostname)"
GIT_REPO=https://github.com/ionparticle/dotfiles.git
DOTFILES_DIR=.dotfiles

echo "Checking for dependencies:"
REQUIRED_PROGRAMS=('git' 'vim' 'stow')
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
	cd $DOTFILES_DIR
	printf "Updating submodules in repo... "
	git submodule update --init vim/.vim/bundle/Vundle.vim/ || \
		{ echo >&2 " failed, aborting."; exit 1; }
	cd $HOME
	printf "done!\n"
fi

# Make symlinks to the dotfiles using stow
cd $DOTFILES_DIR
./stow.sh

# Setup vim plugins
printf "Telling Vundle to setup all the vim plugins... "
vim +PluginInstall +qall || { echo >&2 "Failed, aborting."; exit 1; }
printf "done!\n"

# For reference installing a cron job, need to remove dotsync part
printf "Installing cron job for automatic dotfile updates..."
# will update dotfiles everyday at 9am
(crontab -l | grep -v $DOTFILES_DIR; echo \
	"0 9 * * * cd $HOME/$DOTFILES_DIR;git pull;./stow.sh") | crontab - || \
	{ echo >&2 " failed, aborting."; exit 1;}
echo " success!"
