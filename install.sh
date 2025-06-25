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
exclusions=($MY_FNAME .git .gitignore .gitmodules README.md vs_code com.googlecode.iterm2.plist tampermonkey)

VS_CODE_ROOT="$HOME/Library/Application Support/Code/User"
mkdir -p "$VS_CODE_ROOT"
ln -sf "$DIR/vs_code/settings.json" "$VS_CODE_ROOT/settings.json"

# Set up ZSH path and link files
ZDOTDIR="$HOME/.zsh"
mkdir -p "$ZDOTDIR"

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
       echo "$HOME/$FNAME already exists; skipping"
     fi
   else
     echo "Linking $f to $HOME/$FNAME"
     ln -s $f $HOME/$FNAME
   fi
 fi
done

defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "~/Sites/dotfiles"
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
