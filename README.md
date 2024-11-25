# Dotfiles #
A collection of mojo-preserving configuration files. Makes a handsome environment.

### Some neat thing(s): ###

**install.sh** -- clones the structure of this directory into your home directory using symbolic links.

**git submodules** -- all kinds of external dependencies are referenced as git submodules. Just run `git submodule init` before running the installer.

## Random hacks

## Preventing the "Slack links open in Safari website added to dock" issue

* `brew install duti`
* `duti -s com.google.Chrome com.apple.web-internet-location all`

([Source](https://www.reddit.com/r/MacOS/comments/10fj13w/comment/j51wt66/))
