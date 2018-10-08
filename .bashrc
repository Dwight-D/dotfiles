#
# ~/.bashrc
#

source ~/dotfiles/aliases

[[ $- != *i* ]] && return

 # List of color variables that bash can use
     COL0="\[\033[0;30m\]"
     COL1="\[\033[1;30m\]"
     COL2="\[\033[0;31m\]"
     COL3="\[\033[1;31m\]"
     COL4="\[\033[0;32m\]"
     COL5="\[\033[1;32m\]"
     COL6="\[\033[0;33m\]"
     COL7="\[\033[1;33m\]"
     COL8="\[\033[0;34m\]"
     COL9="\[\033[1;34m\]"
     COL10="\[\033[0;35m\]"
     COL11="\[\033[1;35m\]" 
     COL12="\[\033[0;36m\]"
     COL13="\[\033[1;36m\]" 
     COL14="\[\033[0;37m\]"  
     COL15="\[\033[1;37m\]"   

     COL_RESET="\[\033[0m\]"      # Color reset

#Use smart completion (not currently installed)
[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
	#Default prompt with color
	else
		#Clean prompt
		#PS1='\[\033[01;32m\]\u \[\033[01;30m\]- \[\033[01;37m\] \W\n\[\033[01;32m\]>\[\033[00m\] '
		
		#SVN info prompt
		source ~/scripts/vcsprompt.sh
	fi

	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi

unset use_color safe_term match_lhs sh

xhost +local:root > /dev/null 2>&1

complete -cf sudo

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)


#========================================================#
#                                                        #
#                   BASH OPTIONS                         #
#                                                        #
#========================================================#


shopt -s checkwinsize

shopt -s expand_aliases

# export QT_SELECT=4

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

#Ignore case for autocomplete
bind "set completion-ignore-case on"

#Show suggestions on first tab
bind "set show-all-if-ambiguous on"

#Add trailing slash to symlink expansion
bind "set mark-symlinked-directories on"

#Enable arrow navigation in cmd history
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'

# Avoid duplicate entries
HISTCONTROL="erasedups:ignoreboth"

# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:cd:history"

# Huge history. Doesn't appear to slow things down, so why not?
HISTSIZE=500000
HISTFILESIZE=100000



## BETTER DIRECTORY NAVIGATION ##

# Prepend cd to directory names automatically
shopt -s autocd 2> /dev/null
# Correct spelling errors during tab-completion
shopt -s dirspell 2> /dev/null
# Correct spelling errors in arguments supplied to cd
shopt -s cdspell 2> /dev/null

#treats variable names as directory for cd
shopt -s cdable_vars 2> /dev/null
source /home/max/dotfiles/shortcuts

# This defines where cd looks for targets
# Add the directories you want to have fast access to, separated by colon
#Look for targets in the current working directory, in home and in the ~/projects folder
#NB: Adds annoying path echo on cd, use with cd function to suppress
CDPATH=".:~:~/projects" 

#=======================FUNCTIONS=========================


# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xvjf $1   ;;
      *.tar.gz)    tar xvzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xvf $1    ;;
      *.tbz2)      tar xvjf $1   ;;
      *.tgz)       tar xvzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

#Override cd (suppress path echo)
function cd() {
    if [ -z "$*" ]; then 
        destination=~
    else
        destination=$*
    fi
    builtin cd "${destination}" >/dev/null && ls
}

# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
(cat ~/.cache/wal/sequences &)

