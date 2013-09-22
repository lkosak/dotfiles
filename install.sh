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
exclusions=($MY_FNAME .git .gitignore .gitmodules README.md)

for f in $FILES
do
 # Ignore this script
 FNAME=$(basename $f)

 if [[ ! ${exclusions[@]} =~ "$FNAME" ]]; then
   if [ -a $HOME/$FNAME ]; then
     echo "$HOME/$FNAME already exists; skipping"
   else
     echo "Linking $f to $HOME/$FNAME"
     ln -s $f $HOME/$FNAME
   fi
   echo "Linking $f to $HOME/$FNAME"
   ln -s $f $HOME/$FNAME
 fi
done
