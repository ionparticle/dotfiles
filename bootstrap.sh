#!/bin/sh

HOST="$(hostname)"
GIT_REPO=https://github.com/ionparticle/dotfiles.git
DOTFILES_DIR=.dotfiles
DOTSYNC=$HOME/$DOTFILES_DIR/dotsync/bin/dotsync
DOTSYNCRC=$HOME/$DOTFILES_DIR/.dotsyncrc

printf "Check if we can use git... "
command -v git >/dev/null 2>&1 || { echo >&2 " failed, aborting."; exit 1; }
printf "success!\n"

cd $HOME
if [ ! -d ".dotfiles" ]; then
	printf "Cloning dotfiles repo... "
	cd .dotfiles;
	git clone --recursive $GIT_REPO $DOTFILES_DIR;
	printf "done!\n"
fi

# Add this computer to the list of known hosts so dotsync will actually sync
grep $HOST $DOTSYNCRC >/dev/null
if [ ! $? -eq 0 ]; then
	printf "Unknown host detected, adding to list... "
	sed -i "s/\[endhosts\]/$HOST\t\tgit=NONE\n\[endhosts\]/g" $DOTSYNCRC || \
		{ echo >&2 "Failed, aborting."; exit 1; }
	printf "done!\n"
	printf "Push new host to git repo... "
	$DOTSYNC -P || { echo >&2 "Failed, aborting."; exit 1; }
	printf "done!\n"
fi

printf "Running dotsync: \n"
$DOTSYNC -L || { echo >&2 "Failed, aborting."; exit 1; }
printf "Dotsync done!\n"

printf "Installing cron job for automatic dotfile updates:\n"
# will update dotfiles everyday at 9am
(crontab -l | grep -v dotsync; echo "0 9 * * 7 $DOTSYNC -u") | crontab - || \
	{ echo >&2 "Failed, aborting."; exit 1;}

printf "Done!\n"
