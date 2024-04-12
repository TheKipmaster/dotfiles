
################################################################################
########### Symlinks ###########################################################
################################################################################

# [ -d $HOME/.bin ] || ln -s $HOME/Documents/dotfiles/.bin $HOME/

# Create i3 config dir if it doesn't exist already
mkdir -p $HOME/.config/i3

ln -sf $HOME/Documents/dotfiles/i3/config $HOME/.config/i3

# ln -sf $HOME/Documents/dotfiles/.profile $HOME

ln -sf $HOME/Documents/dotfiles/.fonts $HOME

ln -sf $HOME/Documents/dotfiles/dunst $HOME/.config

ln -sf $HOME/Documents/dotfiles/polybar $HOME/.config

ln -sf $HOME/Documents/dotfiles/rofi $HOME/.config

ln -sf $HOME/Documents/dotfiles/nitrogen $HOME/.config

ln -sf $HOME/Documents/dotfiles/picom $HOME/.config

ln -sf $HOME/Documents/dotfiles/.zshrc $HOME
