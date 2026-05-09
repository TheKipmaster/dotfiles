#########################################################################################
############ Core #######################################################################
#########################################################################################
sudo add-apt-repository ppa:fish-shell/release-4
sudo apt update

sudo apt install -y curl npm fish

############ Fisher #####################################################################
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish \
    | source && fisher install jorgebucaran/fisher
fisher install patrickf1/fzf.fish
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fisher install jorgebucaran/nvm.fish
fisher install ilancosman/tide@v6

############ Tide Config ################################################################
tide configure --auto --style=Rainbow --prompt_colors='16 colors' \
    --show_time='24-hour format' --rainbow_prompt_separators=Angled \
    --powerline_prompt_heads=Sharp --powerline_prompt_tails=Flat \
    --powerline_prompt_style='Two lines, character and frame' \
    --prompt_connection=Solid --powerline_right_prompt_frame=No \
    --prompt_spacing=Compact --icons='Many icons' --transient=Yes

############ Utils ######################################################################
sudo apt install -y fd-find batcat pavucontrol
ln -s "$(which batcat)" ~/.local/bin/bat

############ i3 #########################################################################
sudo apt install -y i3 \
    libxcursor-dev polybar \
    nitrogen picom rofi

############ Snap #######################################################################
snaps=(
    "code --classic"
    "obsidian --classic"
    "todoist"
    "discord"
    "steam"
    "ncspot"
)
for snap in "${snaps[@]}"; do                                                                
    sudo snap install $snap                                                                
done

############ Drivers ####################################################################
sudo ubuntu-drivers autoinstall

#########################################################################################
############ Kitty ######################################################################
#########################################################################################

curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

# Create symbolic links to add kitty and kitten to PATH
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
# Place the kitty.desktop file somewhere it can be found by the OS
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
# If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
# Update the paths to the kitty and its icon in the kitty desktop file(s)
sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
# Make xdg-terminal-exec (and hence desktop environments that support it use kitty)
echo 'kitty.desktop' >~/.config/xdg-terminals.list

#########################################################################################
############ NeoVim #####################################################################
#########################################################################################

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

# sudo chown -R $(whoami) /usr/local/bin # for in case permissions are an issue
npm install -g neovim

#########################################################################################
############ LazyVim Utils ##############################################################
#########################################################################################

# FZF
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

lazyvim_utils=(
    imagemagick
    ripgrep
    fd-find
    lua5.1
    liblua5.1-0-dev
)
sudo apt install -y "${lazyvim_utils[@]}"

ln -s "$(which fdfind)" ~/.local/bin/fd

npm install -g -y tree-sitter-cli @ast-grep/cli

#########################################################################################
############ Lazygit ####################################################################
#########################################################################################

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/

#########################################################################################
############ Symlinks ###################################################################
#########################################################################################

DOTFILES="$HOME/Documents/dotfiles"
CONFIG="$HOME/.config"

# [ -d $HOME/.bin ] || ln -s $DOTFILES/.bin $HOME/

# Create i3, nvim, kitty config dirs if they don't exist already
mkdir -p "$CONFIG/i3" "$CONFIG/kitty"

tools=(
    "$DOTFILES/nvim"
    "$DOTFILES/dunst"
    "$DOTFILES/polybar"
    "$DOTFILES/rofi"
    "$DOTFILES/nitrogen"
    "$DOTFILES/picom"
)
ln -sf "${tools[@]}" "$CONFIG"

fish_functions=("$DOTFILES/fish/functions"/*)

ln -sf "${fish_functions[@]}" "$CONFIG/fish/functions"

ln -sf "$DOTFILES/i3/config" "$DOTFILES/i3/scripts" "$CONFIG/i3"
ln -sf "$DOTFILES/kitty.conf" "$CONFIG/kitty"
ln -sf "$DOTFILES/fish/config.fish" "$CONFIG/fish"

home_dotfiles=(
    "$DOTFILES/.fonts"
    "$DOTFILES/.zshrc"
    "$DOTFILES/.XCompose"
    "$DOTFILES/.bashrc"
)
ln -sf "${home_dotfiles[@]}" "$HOME"

claudio_files=("$DOTFILES/claudio"/*)
ln -sf "${claudio_files[@]}" "$HOME/.claude"

sudo chmod +x "$CONFIG/dunst/dunstrc"

sudo chmod +x "$CONFIG/picom/start_picom.sh"

sudo chmod +x "$CONFIG/i3/scripts/"*.sh

sudo chmod +x "$CONFIG/polybar/launch.sh"
sudo chmod +x "$CONFIG/polybar/scripts/weather/weather.sh"
sudo find "$CONFIG/polybar/scripts" -type f -exec chmod +x {} \;

sudo chmod +x "$CONFIG/rofi/scripts/askpass-rofi.sh"
sudo chmod +x "$CONFIG/rofi/scripts/power_menu.sh"
