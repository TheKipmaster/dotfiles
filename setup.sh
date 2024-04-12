# 

# Symlink binaries
# [ -d $HOME/.bin ] || ln -s $HOME/Documents/dotfiles/.bin $HOME/

# Create i3 config dir if it doesn't exist already
mkdir -p $HOME/.config/i3

# Symlink i3 config files from git repo to configs
# ln -sf $HOME/Documents/dotfiles/i3/config $HOME/.config/i3

# Symlink .profile
# ln -sf $HOME/Documents/dotfiles/.profile $HOME

# Symlink fonts
ln -sf $HOME/Documents/dotfiles/.fonts $HOME

# Symlink dunst settings
# ln -sf $HOME/Documents/dotfiles/dunst $HOME/.config