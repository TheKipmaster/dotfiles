# 

# Symlink binaries
# [ -d $HOME/.bin ] || ln -s $HOME/dotfiles/.bin $HOME/

# Create i3 config dir if it doesn't exist already
mkdir -p $HOME/.config/i3

# Symlink i3 config files from git repo to configs
# ln -sf $HOME/dotfiles/i3/config $HOME/.config/i3

# Symlink .profile
# ln -sf $HOME/dotfiles/.profile $HOME

# Symlink fonts
# ln -sf $HOME/dotfiles/.fonts $HOME

# Symlink dunst settings
# ln -sf $HOME/dotfiles/dunst $HOME/.config