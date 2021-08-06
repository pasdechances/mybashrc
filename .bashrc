# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

HISTCONTROL=ignoreboth

shopt -s histappend

HISTSIZE=1000
HISTFILESIZE=2000
HISTTIMEFORMAT="%d/%m/%Y %T "

shopt -s checkwinsize

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='\[\e[40;1;36m\]\[\033[01;32m\][\D{%d-%m-%Y %H:%M:%S}] ${debian_chroot:+($debian_chroot)}\u@\h:\[\033[01;34m\]\w \[\033[31m\] $(parse_git_branch) \[\e[40;1;36m\]  >\[\033[00m\]\n'
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alrtF'
alias la='ls -A'
alias l='ls -CF'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias rm=remove
alias rem=delete

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


function parse_git_branch() {
    git=$(git branch --show-current 2>/dev/null)
    if [[ ! -z $git ]]; then
        echo "[${git}]"
    fi
}

function remove(){
    for el in ${@}; do
        if [[ ! -d ~/trash ]];then
            mkdir -p ~/trash
        fi
        mv  $el ~/trash
    done
}

function delete(){
    for el in ${@}; do
        if [ -d $el ];then
            echo "Le dossier $el sera definitivement supprimé est vous sur de vouloir continuer ? (Yes/No)"
        else
            echo "Le fichier $el sera definitivement supprimé est vous sur de vouloir continuer ? (Yes/No)"
        fi
        read reponse
        if [[ "$reponse" == "Yes" ]];then 
            /bin/rm -rf $el
        else
            echo "La suppression a été annulée"
        fi
    done
}
