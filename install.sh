#!/bin/bash

LSOF=$(lsof -p $$ | grep -E "/"$(basename $0)"$")
MY_PATH=$(echo $LSOF | sed -r s/'^([^\/]+)\/'/'\/'/1 2>/dev/null)

# special path determiner for OSX
if [ $? -ne 0 ]; then
  MY_PATH=$(echo $LSOF | sed -E s/'^([^\/]+)\/'/'\/'/1 2>/dev/null)
fi

DIR=$(dirname $MY_PATH)
MY_FNAME=$(basename $0)

# include hidden files
shopt -s dotglob

FILES="$DIR/*"
exclusions=($MY_FNAME .git .gitignore .gitmodules README.md vs_code com.googlecode.iterm2.plist tampermonkey .claude .config)

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
RESET='\033[0m'

link_file() {
  local src="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -h "$dest" ]; then
    echo -e "${YELLOW}$dest already linked; skipping${RESET}"
  elif [ -d "$dest" ]; then
    echo -e "${RED}$dest already exists as directory; skipping${RESET}"
  elif [ -e "$dest" ]; then
    diff "$dest" "$src" > /dev/null
    if [ $? -eq 0 ]; then
      echo -e "${YELLOW}$dest exists but identical; replacing with link${RESET}"
      ln -sf "$src" "$dest"
    else
      echo -e "${RED}$dest already exists with different content; skipping${RESET}"
    fi
  else
    echo -e "${GREEN}Linking $src to $dest${RESET}"
    ln -sf "$src" "$dest"
  fi
}

link_file "$DIR/vs_code/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
link_file "$DIR/.claude/settings.json" "$HOME/.claude/settings.json"
link_file "$DIR/.config/ghostty/config.ghostty" "$HOME/.config/ghostty/config.ghostty"

# Install oh-my-zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo -e "${YELLOW}$HOME/.oh-my-zsh already exists; skipping oh-my-zsh install${RESET}"
else
  CHSH=no RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Link everything else to home dir
for f in $FILES
do
  FNAME=$(basename $f)
  if [[ ! ${exclusions[@]} =~ "$FNAME" ]]; then
    link_file "$f" "$HOME/$FNAME"
  fi
done

defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/Sites/dotfiles"
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
defaults write com.googlecode.iterm2.plist NoSyncNeverRemindPrefsChangesLostForFile -bool true
defaults write com.googlecode.iterm2.plist NoSyncNeverRemindPrefsChangesLostForFile_selection -int 0

###############################################################################
# macOS Preferences                                                           #
###############################################################################

echo "Applying macOS preferences..."

# Keyboard: Remap Caps Lock to Control for all keyboards
# Src 30064771129 = Caps Lock, Dst 30064771300 = Control
MODIFIER_MAPPING='
{
    HIDKeyboardModifierMappingDst = 30064771300;
    HIDKeyboardModifierMappingSrc = 30064771129;
}
'
for key in \
  "com.apple.keyboard.modifiermapping.1452-834-0" \
  "com.apple.keyboard.modifiermapping.alt_handler_id-49" \
  "com.apple.keyboard.modifiermapping.alt_handler_id-106"; do
  defaults -currentHost write -g "$key" -array "$MODIFIER_MAPPING"
done

# Keyboard: Fast key repeat rate (lower = faster, default is 6)
defaults write -g KeyRepeat -int 2

# Keyboard: Short delay until key repeat (lower = shorter, default is 25)
defaults write -g InitialKeyRepeat -int 15

# Trackpad: Set tracking speed (0.0 to 3.0, default is ~1.0)
defaults write -g com.apple.trackpad.scaling -float 0.875

# Trackpad: Enable tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# Trackpad: Enable two-finger right click
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true

# Trackpad: Enable pinch to zoom
defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch -bool true

# Trackpad: Enable rotate gesture
defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate -bool true

# Trackpad: Enable momentum scrolling
defaults write com.apple.AppleMultitouchTrackpad TrackpadMomentumScroll -bool true

# Trackpad: Enable four-finger swipe gestures
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerPinchGesture -int 2

# Trackpad: Suppress Force Touch
defaults write com.apple.AppleMultitouchTrackpad ForceSuppressed -bool true
defaults write com.apple.AppleMultitouchTrackpad ActuateDetents -int 0

echo "macOS preferences applied. Some changes may require a logout/restart to take effect."
