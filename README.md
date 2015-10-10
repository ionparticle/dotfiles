# dotfiles

Trying to make my home configs as easy to maintain as possible. On new machines, provided git and vim are already installed, I should be able just download bootstrap.sh and run it to establish an auto updating dot file environment.

```shell
wget https://raw.githubusercontent.com/ionparticle/dotfiles/master/bootstrap.sh; \
chmod +x bootstrap.sh; \
./bootstrap.sh
```

Auto-update doesn't include Vundle managed vim plugins or dotsync. Not sure how to handle those yet.

Using [dotsync](https://github.com/dotphiles/dotsync) for dotfile syncing. Not using the remote syncing part, I'm just using cron jobs to have each machine update themselves.
