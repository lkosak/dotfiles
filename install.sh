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
exclusions=($MY_FNAME .git .gitignore .gitmodules README.md vs_code com.googlecode.iterm2.plist tampermonkey .claude)

VS_CODE_ROOT="$HOME/Library/Application Support/Code/User"
mkdir -p "$VS_CODE_ROOT"
ln -sf "$DIR/vs_code/settings.json" "$VS_CODE_ROOT/settings.json"

CLAUDE_ROOT="$HOME/.claude"
mkdir -p "$CLAUDE_ROOT"
if [ -e "$CLAUDE_ROOT/settings.json" ] && [ ! -h "$CLAUDE_ROOT/settings.json" ]; then
  echo "WARNING: $CLAUDE_ROOT/settings.json exists as a regular file, not a symlink; skipping"
else
  ln -sf "$DIR/.claude/settings.json" "$CLAUDE_ROOT/settings.json"
fi

# Install oh-my-zsh
CHSH=no RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Link everything else to home dir
for f in $FILES
do
 # Ignore this script
 FNAME=$(basename $f)

 if [[ ! ${exclusions[@]} =~ "$FNAME" ]]; then
   if [ -h $HOME/$FNAME ]; then
     echo "$HOME/$FNAME already linked; skipping"
   elif [ -d $HOME/$FNAME ]; then
     echo "$HOME/$FNAME already exists; skipping"
   elif [ -e $HOME/$FNAME ]; then
     diff $HOME/$FNAME $f > /dev/null

     if [ $? -eq 0 ]; then
       echo "$HOME/$FNAME exists but identical; replacing with link"
       ln -sf $f $HOME/$FNAME
     else
       echo "WARNING: $HOME/$FNAME is a regular file (not a symlink) with different contents; skipping"
     fi
   else
     echo "Linking $f to $HOME/$FNAME"
     ln -s $f $HOME/$FNAME
   fi
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
