# Make symlinks to the dotfiles using stow
printf "Installing dotfiles..."
stow bash || { echo >&2 " bash failed, aborting."; exit 1; }
stow vim || { echo >&2 " vim failed, aborting."; exit 1; }
stow tmux || { echo >&2 " tmux failed, aborting."; exit 1; }
# need to create the screenshots dir for mpv, also makes sure that mpv config
# dir exists
mkdir -p ~/.config/mpv/screenshots || \
	{ echo >&2 " mpv screenshots dir failed, aborting."; exit 1; }
stow -t ~/.config/mpv/ mpv || { echo >&2 " mpv failed, aborting."; exit 1; }
stow git || { echo >&2 " git failed, aborting."; exit 1; }
echo " success!"
