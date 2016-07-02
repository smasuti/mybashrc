#!/usr/bin/env bash
# ----------------------------------------------------------------------
# This is to get back to the user environment.
# Author : Sagar Masuti.
# Date   : 21-04-2015
# ----------------------------------------------------------------------

# The setup.sh creates the backup.
echo "restoring the previous configuration files ..."
cp ~/mybashrc_backup/back_bashrc ~/.bashrc
cp ~/mybashrc_backup/back_bash_profile ~/.bash_profile
cp ~/mybashrc_backup/back_vimrc ~/.vimrc
cp ~/mybashrc_backup/back_aliases.sh ~/.aliases.sh

echo "removing the installed modules ..."
rm -rf ~/.modules
echo "restoring the previous module files ..."
cp -r ~/mybashrc_backup/.modules ~/

echo "removing the undodir ..."
rm -rf ~/.vim/undodir
echo "removing the gruvbox colorscheme ..."
rm -rf ~/.vim/bundle/autoload/gruvbox
echo "removing the mpi.vim ..."
rm ~/.vim/bundle/mpi.vim
echo "removing the taglist ..."
rm -rf ~/.vim/plugin
rm -rf ~/.vim/doc
echo "removing the nerdtree ..."
rm -rf ~/.vim/bundle/nerdtree
echo "removing the nerdtree-tabs ..."
rm -rf ~/.vim/bundle/vim-nerdtree-tabs
echo "removing the pydiction ..."
rm -rf ~/.vim/bundle/pydiction
echo "removing the matrix ..."
rm ~/.vim/pluging/matrix.vim
echo "removing comments ..."
rm ~/.vim/plugin/comments.vim
echo "removing SearchComplete ..."
rm ~/.vim/plugin/SearchComplete.vim
echo "removing mru ..."
rm ~/.vim/plugin/mru.vim
echo "removing doxygen..."
rm ~/.vim/plugin/DoxygenToolkit.vim
echo "removing the dirdiff ..."
rm -rf ~/.vim/bundle/vim-dirdiff
echo "removing the ctrlp..."
rm -rf ~/.vim/bundle/ctrlp.vim
echo "removing the python-syntax..."

source ~/.bash_profile

echo "----------------------------------------------------------------"
echo "revert.sh has successfully reverted the changes made by setup.sh"
echo "If your changes are not reflected then," 
echo "Please restart your terminal"
echo "----------------------------------------------------------------"
