#!/usr/bin/env bash
# ----------------------------------------------------------------------
# This is to install aliases in the environment.
# Author : Sagar Masuti.
# Date   : 28-07-2015
# ----------------------------------------------------------------------

mkdir -p ~/mybashrc_backup

mv ~/.aliases.sh ~/mybashrc_backup/
check=`cat ~/.bashrc | grep aliases.sh | wc -l` 
if [ $check != 0 ] ; then
    echo "aliases.sh is present"
else 
    cat << EOF >> ~/.bashrc
if [ -f ~/.aliases.sh ] ; then
    source ~/.aliases.sh
fi
EOF
fi
cp ~/aliases.sh ~/.aliases.sh

echo "----------------------------- aliases --------------------------- "
echo "aliases is installed."
echo "previous aliases are moved to ~/mybashrc_backup/.aliases.sh"
echo "you need to use -> source ~/.bashrc for the aliases to take effect"
echo "use pral command to see all the available aliases"
echo "------------------------------------------------------------------"
