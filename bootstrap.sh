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
if [ ! -d ".dotfiles" ]; then
	printf "Cloning dotfiles repo... "
	git clone $GIT_REPO $DOTFILES_DIR || \
		{ echo >&2 " failed, aborting."; exit 1; }
	printf "done!\n"
	cd $DOTFILES_DIR
	printf "Updating submodules in repo... "
	git submodule update --init vim/vim/bundle/Vundle.vim/ || \
		{ echo >&2 " failed, aborting."; exit 1; }
	cd $HOME
	printf "done!\n"
fi

# Make symlinks to the dotfiles using stow
printf "Installing dotfiles..."
cd $DOTFILES_DIR
stow bash || { echo >&2 " bash failed, aborting."; exit 1; }
stow vim || { echo >&2 " vim failed, aborting."; exit 1; }
# need to create the screenshots dir for mpv, also makes sure that mpv config
# dir exists
mkdir -p ~/.config/mpv/screenshots || \
	{ echo >&2 " mpv screenshots dir failed, aborting."; exit 1; }
stow -t ~/.config/mpv/ mpv || { echo >&2 " mpv failed, aborting."; exit 1; }
stow git || { echo >&2 " git failed, aborting."; exit 1; }
echo " success!"

exit

printf "Telling Vundle to setup all the vim plugins... "
vim +PluginInstall +qall || { echo >&2 "Failed, aborting."; exit 1; }
printf "done!\n"



# For reference installing a cron job, need to remove dotsync part
#printf "Installing cron job for automatic dotfile updates:\n"
# will update dotfiles everyday at 9am
#(crontab -l | grep -v dotsync; echo "0 9 * * 7 $DOTSYNC -u") | crontab - || \
#	{ echo >&2 "Failed, aborting."; exit 1;}

printf "Done!\n"
