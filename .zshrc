# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="sorin"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git osx ruby)

# Load that oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Fuck that autocorrect b.s.! (from oh-my-zsh)
unsetopt correct_all
# Fuck that automenu b.s.! (from oh-my-zsh)
setopt noautomenu

# History FOREVER
HISTFILE=~/.zshis
HISTSIZE=1000000
SAVEHIST=1000000

# This loads RVM into a shell session.
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  
 
# Pathypath
export PATH="$HOME/bin:/usr/local/bin:/usr/local/Cellar/vim/7.3.333/bin:/Users/lkosak/pear/bin:$PATH"

# Set Apple Terminal.app resume directory
if [[ $TERM_PROGRAM == "Apple_Terminal" ]] && [[ -z "$INSIDE_EMACS" ]] {
 function chpwd {
   local SEARCH=' '
   local REPLACE='%20'
   local PWD_URL="file://$HOSTNAME${PWD//$SEARCH/$REPLACE}"
   printf '\e]7;%s\a' $PWD_URL
 }

 chpwd
}

# Node the node
export NODE_PATH="/usr/local/lib/node_modules:$NODE_PATH" 

# Postgres has silly start and stop commands
alias pg_start="pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start"
alias pg_stop="pg_ctl -D /usr/local/var/postgres stop -s -m fast"

# Fix forward delete
bindkey "^[[3~" delete-char 

# disable flow control to allow <C-s> in vim
stty -ixon -ixoff

# DB syncage
alias ppdb_capture="echo -n \"Creating dump on production server...\" && ssh pinchit.com '/home/lou/dump.sh' && echo \"done.\""
alias ppdb_download="echo \"Downloading dump...\" && rsync -avzL --progress --safe-links -e 'ssh -p 9922' lou@pinchit.com:/home/lou/.dumps/pinchit-production-latest ~/.dumps/ && echo \"...done.\""
alias ppdb_load="~/.dumps/load.sh"
alias ppdb_sync="ppdb_capture && ppdb_download & ppdb_load"
