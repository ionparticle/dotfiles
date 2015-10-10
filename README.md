# dotfiles

Trying to make my home configs as easy to maintain as possible. On new machines, as long as it has git already installed, I should be able just download bootstrap.sh and run it to establish an auto updating dot file environment.

The only thing that doesn't auto-update is the dotsync dependency itself. When I try to do submodule update, it goes and update my Vundle installed vim plugins too. Not sure if I want it to do that.

Using [dotsync](https://github.com/dotphiles/dotsync) for dotfile syncing. Not using the remote syncing part, I'm just using cron jobs to have each machine update themselves.
