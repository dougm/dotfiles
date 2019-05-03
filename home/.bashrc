test -r /etc/bashrc &&
      . /etc/bashrc

git_branch() {
    branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
    test -n "$branch" && echo "($branch)"
}

tmux_cmd="tmux -2"
tmux_cfg="$HOME/.tmux.$(uname).conf"

if [ -f $tmux_cfg ]; then
    tmux_cmd="${tmux_cmd} -f ${tmux_cfg}"
fi

alias tmux="${tmux_cmd}"

HISTCONTROL=ignoredups:ignorespace
HISTSIZE=5000
HISTFILESIZE=5000

export GOPATH=$HOME
PATH=$HOME/bin:$PATH
PATH=/usr/local/bin:/usr/local/sbin:/usr/local/share/python:$PATH

# Terminal colours (after installing GNU coreutils)
NM="\[\033[0;38m\]" #means no background and white lines
HI="\[\033[0;37m\]" #change this for letter colors
HII="\[\033[0;31m\]" #change this for letter colors
SI="\[\033[0;33m\]" #this is for the current directory
IN="\[\033[0m\]"

PS1="$NM\h:$SI\w$HII\$(git_branch)$IN% "

dircolors="$(type -P gdircolors dircolors | head -1)"
test -n "$dircolors" && {
    eval `$dircolors ~/.dircolors`
}
unset dircolors

LS_OPTIONS='--color=auto'
ls="$(type -P gls ls | head -1)"
alias ls="$ls \$LS_OPTIONS -hF"
alias ll="$ls \$LS_OPTIONS -lhF"
alias l="$ls \$LS_OPTIONS -lAhF"
alias grep='grep --color'
alias ec='emacsclient -n'

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

if which rbenv >& /dev/null; then
    eval "$(rbenv init -)"
fi

brew=/usr/local/bin/brew
if [ -x $brew ]
then
  # coreutils (homebrew on OSX)
  gnubin=$($brew --prefix coreutils)/libexec/gnubin
  if [ -d $gnubin ]
  then
    export PATH=$gnubin:$PATH
  fi
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.bash.inc" ]; then source "$HOME/google-cloud-sdk/path.bash.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.bash.inc" ]; then source "$HOME/google-cloud-sdk/completion.bash.inc"; fi
