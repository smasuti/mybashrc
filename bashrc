
# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [ -f ~/.aliases.sh ] ; then
	source ~/.aliases.sh
fi

export PS1="\u@\w$ "

module load ports
toilet -f smmono9 -w 100 "You know what to do :)"
module unload ports
