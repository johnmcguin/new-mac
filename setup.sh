if [[ -f ~/.ssh/id_rsa.pub || -f ~/.ssh/id_ecdsa.pub || -f ~/.ssh/id_ed25519.pub ]]; then
	echo "It looks like you already have a public key to use. Follow the instruction to upload it to GitHub."
else
	echo "Creating an SSH key for you..."
	ssh-keygen -t ed25519 -C "johnmcguin88@gmail.com"

	echo "Starting ssh agent"
	eval "$(ssh-agent -s)"

	SSH_CONFIG=~/.ssh/config
	if [ ! -f "$SSH_CONFIG" ]; then
	    echo "Add the following to your config:"
	    echo "Host github.com
		  AddKeysToAgent yes
		  UseKeychain yes
		  IdentityFile ~/.ssh/id_ed25519"
	    touch ~/.ssh/config
	    echo "Your ssh config has been created"
	    echo "Please edit it now"
	    read -p "Press [Enter] when done."
	    ssh-add --apple-use-keychain ~/.ssh/id_ed25519
	fi
fi

echo "Please add this public key to Github \n"
echo "https://github.com/account/ssh \n"
read -p "Press [Enter] key after this..."

echo "Installing xcode-stuff"
xcode-select --install

echo "Checking for homebrew"
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Updating homebrew..."
brew update

# Deps
deps=(
  neovim
  docker
  docker-compose
  nvm
)

echo "Installing homebrew deps..."
brew install ${deps[@]}

echo "Checking for git"
if test ! $(which git); then
	echo "Installing git"
	brew install git
fi

echo "Git config"
git config --global user.name "John McGuin"
git config --global user.email johnmcguin88@gmail.com

echo "Cleaning up homebrew"
brew cleanup

# Install Zsh & Oh My Zsh
echo "Installing Oh My ZSH..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Set up your theme ZSH_THEME [recommend agnoster]"
read -p "Press [Enter] key after this..."

# Install powerline fonts 
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
# clean-up a bit
cd ..
rm -rf fonts

echo "Please update iTerm2 Preferences > Profiles > Font to a powerline selection"
read -p "Press [Enter] after this..."

# Apps
apps=(
  alfred
  iterm2
  spotify
  rectangle
  caffeine
  app-cleaner
  obsidian
)

echo "Installing apps with Cask..."
brew install --cask ${apps[@]}

echo "Cleaning up homebrew"
brew cleanup

echo "Setting some Mac settings..."

#"Saving to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

#"Disable smart quotes and smart dashes as they are annoying when typing code"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

#"Setting trackpad & mouse speed to a reasonable number"
defaults write -g com.apple.trackpad.scaling 2
defaults write -g com.apple.mouse.scaling 2.5

#"Enabling subpixel font rendering on non-Apple LCDs"
defaults write NSGlobalDomain AppleFontSmoothing -int 2

#"Showing icons for hard drives, servers, and removable media on the desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true

#"Showing all filename extensions in Finder by default"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

#"Avoiding the creation of .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

#"Setting the icon size of Dock items to 36 pixels for optimal size/screen-realestate"
defaults write com.apple.dock tilesize -int 36

#"Speeding up Mission Control animations and grouping windows by application"
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock "expose-group-by-app" -bool true

#"Setting Dock to auto-hide and removing the auto-hiding delay"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0

#"Preventing Time Machine from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

#"Setting screenshots location to ~/Desktop/Screengrabs"
defaults write com.apple.screencapture location -string "$HOME/Desktop/Screengrabs"

killall Finder

echo "Done!"

