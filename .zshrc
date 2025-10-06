# Place this early in your .zshrc
ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"

# Make sure the directory exists
mkdir -p "$(dirname $ZSH_COMPDUMP)"

# Then initialize completion
#autoload -Uz compinit
#compinit

# Remove stale compdump files if they exist
[[ -f ${ZSH_COMPDUMP}.zwc.old ]] && rm -f ${ZSH_COMPDUMP}.zwc.old

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
HISTFILE=$HOME/.zshistory
HISTSIZE=1000000
SAVEHIST=1000000
setopt APPEND_HISTORY       # don’t overwrite, append instead
setopt INC_APPEND_HISTORY   # write commands as soon as they’re run
setopt SHARE_HISTORY        # share across all sessions

# Pathypath
export PATH="/opt/homebrew/bin:$HOME/.rbenv/bin:$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"

# Load rbenv
if command -v rbenv > /dev/null 2>&1; then
  eval "$(rbenv init -)"
fi

# only use local git files for autocompletion (speed tweak)
__git_files () {
  _wanted files expl 'local files' _files
}

# Fix forward delete
bindkey "^[[3~" delete-char

# disable flow control to allow <C-s> in vim
stty -ixon -ixoff

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

# Force rbenv to use homebrew's OpenSSL
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
