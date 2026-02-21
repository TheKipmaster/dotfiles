
sudo apt install -y curl
sudo apt install -y npm

## zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

sudo apt install -y pavucontrol

## i3 stuff
sudo apt install -y i3
sudo apt install -y libxcursor-dev # polybar dependency
sudo apt install -y polybar
sudo apt install -y nitrogen
sudo apt install -y picom
sudo apt install -y rofi

# snaps
sudo snap install code --classic
sudo snap install obsidian --classic
sudo snap install todoist
sudo snap install spotify

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

# sudo chown -R $(whoami) /usr/local/bin # for in case permissions are an issue
npm install -g neovim

################################################################################
############ LazyVim Utils #####################################################
################################################################################

# FZF
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# ImageMagick
sudo apt install -y imagemagick

# Ripgrep
sudo apt install -y ripgrep

# fd-find
sudo apt install -y fd-find
ln -s $(which fdfind) ~/.local/bin/fd

# Lua
sudo apt install -y lua5.1

# luarocks
sudo apt install -y liblua5.1-0-dev

# tree-sitter
npm install -g -y tree-sitter-cli

# ast-grep
npm install -g -y @ast-grep/cli

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

ln -sf $HOME/Documents/dotfiles/i3/config $HOME/.config/i3
ln -sf $HOME/Documents/dotfiles/kitty.conf $HOME/.config/kitty
ln -sf $HOME/Documents/dotfiles/nvim $HOME/.config

# ln -sf $HOME/Documents/dotfiles/.profile $HOME

ln -sf $HOME/Documents/dotfiles/.fonts $HOME

ln -sf $HOME/Documents/dotfiles/dunst $HOME/.config

ln -sf $HOME/Documents/dotfiles/polybar $HOME/.config

ln -sf $HOME/Documents/dotfiles/rofi $HOME/.config

ln -sf $HOME/Documents/dotfiles/nitrogen $HOME/.config

ln -sf $HOME/Documents/dotfiles/picom $HOME/.config

ln -sf $HOME/Documents/dotfiles/.zshrc $HOME

ln -sf $HOME/Documents/dotfiles/.bashrc $HOME

sudo chmod +x ~/.config/dunst/dunstrc

sudo chmod +x ~/.config/picom/start_picom.sh

sudo chmod +x ~/.config/polybar/launch.sh
sudo chmod +x ~/.config/polybar/scripts/weather/weather.sh
sudo find ~/.config/polybar/scripts -type f -exec chmod +x {} \;

sudo chmod +x ~/.config/rofi/scripts/askpass-rofi.sh
sudo chmod +x ~/.config/rofi/scripts/power_menu.sh