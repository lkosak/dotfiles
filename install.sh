#!/bin/bash

LSOF=$(lsof -p $$ | grep -E "/"$(basename $0)"$")
MY_PATH=$(echo $LSOF | sed -r s/'^([^\/]+)\/'/'\/'/1 2>/dev/null)
if [ $? -ne 0 ]; then
## OSX
MY_PATH=$(echo $LSOF | sed -E s/'^([^\/]+)\/'/'\/'/1 2>/dev/null)
fi

DIR=$(dirname $MY_PATH)
MY_FNAME=$(basename $0)

# include hidden files
shopt -s dotglob

FILES="$DIR/*"

for f in $FILES 
do
 # Ignore this script
 FNAME=$(basename $f)
 if [ $FNAME != $MY_FNAME -a $FNAME != ".git" ]; then
  echo "Linking $f to $HOME/$FNAME"
  ln -s $f $HOME/$FNAME
 fi
done
