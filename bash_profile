export PATH=$PATH:~/src/mybashrc/myscripts

MODULESHOME=/usr/local/modules/tcl; export MODULESHOME

if [ -z $TCLSH ]; then
   if [ -f /usr/bin/tclsh ]; then
      TCLSH="/usr/bin/tclsh"
   elif [ -f /bin/tclsh ]; then
      TCLSH="/bin/tclsh"
   else 
      TCLSH=""
   fi
fi

module () { eval `$TCLSH /usr/local/modules/tcl/modulecmd.tcl bash $*`; }
. /usr/local/modules/tcl/init/modulerc

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

if [ -f /etc/bash_completion ]; then
         . /etc/bash_completion 
fi
