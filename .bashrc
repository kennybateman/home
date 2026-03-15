# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
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

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


### THIS IS WHERE MY CUSTOM CONFIG STARTS ###################################################

## Environment configuration...

# Direnv loads and closes environments as you navigate directories.
eval "$(direnv hook bash)"  # enables direnv
export DIRENV_LOG_FORMAT='' # disable output


## Environment variables...

# Establish the environment variables I need to jump between Windows and WSL...
# 2>/dev/null to suppress output, and tr -d '\r' prevents a weird issue
WINHOME_DIR=$(cmd.exe /C echo %USERPROFILE% 2>/dev/null | tr -d '\r') # 2>/dev/null suppresses output, tr -d '\r' prevents an issue
WINHOME_DIR=$(wslpath "$WINHOME_DIR")          # convert windows path to unix path               
export WINHOME_DIR="$WINHOME_DIR/Desktop/home" # add any custom path mofidications


## Aliases...

alias allow='direnv allow' # turn on direnv for directory
alias deny='direnv deny'   # turn it off

alias home='cd ~'               # quick access to home directory
alias winhome='cd $WINHOME_DIR' # quick access to windows home directory

alias setupremote='bash ~/projects/.setup_remote.sh'      # quick access to remote setup script
alias pushandupdate='bash ~/projects/.push_and_update.sh' # quick access to push and update script


## Startup scripts...

# Create apt package version tracking file apt.txt
echo "Manually installed apt packages:" > ~/apt.txt # Let's start the file at the top
grep -Po '(apt|apt-get) install \K.*' '/var/log/apt/history.log' > ~/apt.tmp # command history
sed -i 's/$/ /' ~/apt.tmp # add a space for better grepping
dpkg-query -W -f='${binary:Package} ${Version}\n' | grep -F -f ~/apt.tmp >> ~/apt.txt # use tmp for grepping
echo "" >> ~/apt.txt # add a newline for better formatting
echo "All installed packages:" >> ~/apt.txt
dpkg-query -W -f='${binary:Package} ${Version}\n' >> ~/apt.txt
echo "" >> ~/apt.txt # add a newline for better formatting
echo "App History:" >> ~/apt.txt
grep -Po '(Install|Upgrade|Remove): .*' /var/log/apt/history.log | perl -pe 's/, (?![^\(]*\))/\n\t/g' >> ~/apt.txt # perl replacement of commas not enclosed in parenthesis
rm ~/apt.tmp # remove the temporary file

# Create non-package managed programs tracking file programs.txt
echo "Non-apt installed programs:" > ~/programs.txt
code --version >> ~/programs.txt
cat ~/.vscode-server/bin/*/package.json >> ~/programs.txt
echo "" >> ~/programs.txt # add a newline for better formatting
nix-env --version >> ~/programs.txt


## Custom UI stuff...

# Just make the PS1 thing really brief. Just the username, ex: ken:~
PS1='\[\e[1;32m\]\u\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\] '
