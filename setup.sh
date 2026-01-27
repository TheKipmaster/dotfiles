
################################################################################
############ Kitty #############################################################
################################################################################

curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

# Create symbolic links to add kitty and kitten to PATH (assuming ~/.local/bin is in
# your system-wide PATH)
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
# Place the kitty.desktop file somewhere it can be found by the OS
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
# If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
# Update the paths to the kitty and its icon in the kitty desktop file(s)
sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
# Make xdg-terminal-exec (and hence desktop environments that support it use kitty)
echo 'kitty.desktop' > ~/.config/xdg-terminals.list

################################################################################
############ NeoVim ############################################################
################################################################################

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

npm install -g neovim

################################################################################
############ LazyVim Utils #####################################################
################################################################################

# FZF
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# ImageMagick
sudo apt install imagemagick

# Ripgrep
sudo apt install ripgrep

# fd-find
sudo apt install fd-find
ln -s $(which fdfind) ~/.local/bin/fd

# Lua
sudo apt install lua5.1

# luarocks
sudo apt install liblua5.1-0-dev

# tree-sitter
npm install --global tree-sitter-cli

# ast-grep
npm install --global @ast-grep/cli

################################################################################
############ Lazygit ###########################################################
################################################################################

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/

################################################################################
############ Symlinks ##########################################################
################################################################################

# [ -d $HOME/.bin ] || ln -s $HOME/Documents/dotfiles/.bin $HOME/

# Create i3, nvim, kitty config dirs if they don't exist already
mkdir -p $HOME/.config/i3
mkdir -p $HOME/.config/kitty
mkdir -p $HOME/.config/nvim

ln -sf $HOME/Documents/dotfiles/i3/config $HOME/.config/i3
ln -sf $HOME/Documents/dotfiles/kitty.conf $HOME/.config/kitty
ln -sf $HOME/Documents/dotfiles/nvim $HOME/.config/nvim

# ln -sf $HOME/Documents/dotfiles/.profile $HOME

ln -sf $HOME/Documents/dotfiles/.fonts $HOME

ln -sf $HOME/Documents/dotfiles/dunst $HOME/.config

ln -sf $HOME/Documents/dotfiles/polybar $HOME/.config

ln -sf $HOME/Documents/dotfiles/rofi $HOME/.config

ln -sf $HOME/Documents/dotfiles/nitrogen $HOME/.config

ln -sf $HOME/Documents/dotfiles/picom $HOME/.config

ln -sf $HOME/Documents/dotfiles/.zshrc $HOME

ln -sf $HOME/Documents/dotfiles/.bashrc $HOME
