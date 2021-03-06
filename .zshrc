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
DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(gitfast)

# Load that oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Fuck that autocorrect b.s.! (from oh-my-zsh)
unsetopt correct_all
# Fuck that automenu b.s.! (from oh-my-zsh)
setopt noautomenu

# History FOREVER
HISTFILE=~/.zshistory
HISTSIZE=1000000
SAVEHIST=1000000
setopt append_history
unsetopt share_history

# Pathypath
export PATH="$HOME/.rbenv/bin:/usr/local/share/npm/bin:$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"

# Load rbenv
eval "$(rbenv init -)"

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

# only use local git files for autocompletion (speed tweak)
__git_files () {
  _wanted files expl 'local files' _files
}

# Fix forward delete
bindkey "^[[3~" delete-char

# disable flow control to allow <C-s> in vim
stty -ixon -ixoff

# color switching
alias dark="perl -p -i -e 's/bg=light/bg=dark/g' ~/.vimrc"
alias light="perl -p -i -e 's/bg=dark/bg=light/g' ~/.vimrc"

# sometimes tmux starts sending these focus/blur control sequences to the
# terminal, which causes vim to go haywire when you focus/blur the pane.
# sending this sequence to the terminal seems to fix it, so let's do this
# instead of spending eighteen hours figuring out why it's happening.
alias nofocus="echo -e \"\033[?1004lfixed\!\""

# Some things like editors. Some Lous like vim
export EDITOR=vim

# Support for a .zlocal file that is outside of version control
LOCALCONF="$HOME/.zlocal"
[ -f $LOCALCONF ] && source $LOCALCONF

# Performance hack for slow repos
function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
}
