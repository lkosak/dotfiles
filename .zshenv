# Support for a .zlocal file that is outside of version control
LOCALCONF="$HOME/.zlocal"
[ -f $LOCALCONF ] && source $LOCALCONF

# Pathypath
export PATH="$HOME/.rbenv/bin:$HOME/bin:/usr/local/bin:/usr/local/share/npm/bin:$PATH:/usr/local/sbin"

# Load rbenv
eval "$(rbenv init -)"

# Node the node
export NODE_PATH="/usr/local/lib/node_modules:$NODE_PATH"

