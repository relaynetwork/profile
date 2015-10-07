if [ -d "$HOME/local/homebrew/bin" ]; then
  export PATH="$HOME/local/homebrew/bin:$PATH:$HOME/local/homebrew/sbin"
fi
. ~/.profile.d/init

export PATH
alias s='cd ..'
alias sl='ls'

. $HOME/.profile.d/users/kburton/kyle.burton.conf

#export JAVA_HOME="/usr/lib/jvm/java-1.7.0-openjdk-amd64"
#if [ -d "/usr/lib/jvm/java-7-oracle/" ]; then
#  export JAVA_HOME="/usr/lib/jvm/java-7-oracle/"
#fi

export PATH="$JAVA_HOME/bin:$PATH"

export RUBYLIB=".:$RUBYLIB:$HOME/projects/rn-rubylibs/relay-gems/lib"

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
PATH=$PATH:/home/ubuntu/.rvm/gems/ruby-1.9.3-p484/bin


# Aliases for running Transition tests with Phantom.js
alias phantomwire='/home/relay/projects/transition.js/software/phantomjs-1.8.1-linux-x86_64/bin/phantomjs /home/relay/projects/rn-web-specs/rn-wall/wire-phantom-runner.js'
alias phantomclient='/home/relay/projects/transition.js/software/phantomjs-1.8.1-linux-x86_64/bin/phantomjs /home/relay/projects/rn-web-specs/client-portal/client-portal-phantom-runner.js'
alias phantomfull='phantomclient && phantomwire'

alias phantomjs='/home/relay/projects/transition.js/software/phantomjs-1.8.1-linux-x86_64/bin/phantomjs'



if [ -d "$HOME/local/node/bin" ]; then
  export PATH="$PATH:$HOME/local/node/bin"
elif [ -d "$HOME/node_modules/.bin" ]; then
  export PATH="$PATH:$HOME/node_modules/.bin"
elif [ -d "/opt/node/bin" ]; then
  export PATH="$PATH:/opt/node/bin"
fi

alias emacs="TERM='xterm-256color' emacs -nw"

alias awsd="aws --profile=dev $@"

test -e /home/relay/projects/dev-utils/instago/go.env && source /home/relay/projects/dev-utils/instago/go.env

test -f $HOME/bin/bake-completion.sh && . $HOME/bin/bake-completion.sh
