#!/usr/bin/env bash
# ----------------------------------------------------------------------
# This is to setting the environment.
# Author : Sagar Masuti.
# Date   : 10-04-2015
# ----------------------------------------------------------------------

# create a backup first.
mkdir -p ~/mybashrc_backup

if [ ! -f ~/.bashrc ]; then 
	touch ~/.bashrc
fi

if [ ! -f ~/.bash_profile ]; then 
	touch ~/.bash_profile
fi

if [ ! -f ~/.vimrc ]; then 
	touch ~/.vimrc
fi

if [ ! -f ~/.aliases.sh ]; then 
	touch ~/.aliases.sh
fi

cp ~/.bashrc ~/mybashrc_backup/back_bashrc
cp ~/.bash_profile ~/mybashrc_backup/back_bash_profile
cp ~/.vimrc ~/mybashrc_backup/back_vimrc
cp ~/.aliases.sh ~/mybashrc_backup/back_aliases.sh
cp -r ~/.modules ~/mybashrc_backup/

# setting up the bash related things.
echo "Setting up the bash related stuffs."
cp bashrc ~/.bashrc
cp bash_profile ~/.bash_profile 
cp aliases.sh ~/.aliases.sh

echo "Setting up the vimrc."
cp vimrc ~/.vimrc

echo "Setting up the modules."
mkdir -p ~/.modules
cp -r modules/* ~/.modules/

mkdir -p ~/.vim/undodir

##installing docopts
#which docopts > /dev/null
#out=$?
#if [ $out != 0 ]; then
	#echo "docopts found: no"
	#echo "installing docopts ..."
	#git clone https://github.com/docopt/docopts.git	
	#cd docopts
	#python setup.py install
	#cd -
	#rm -rf docopts
	#echo "docopts installed"
#else
	#echo "docopts found: yes"
#fi
	

# needs to check if the pathogen is installed if not need to install it.
if [ ! -e ~/.vim/autoload/pathogen.vim ] ; then 
	echo "Pathogen found: no"
	echo "installing Pathogen ..."
	mkdir -p ~/.vim/autoload ~/.vim/bundle
	curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
	echo "Pathogen installed"
else
	echo "Pathogen found: yes"
fi 

# needs to check if the gruvbox is installed if not need to install it.
if [ ! -e ~/.vim/bundle/gruvbox/autoload/gruvbox.vim ] ; then
	echo "gruvbox found: no" 
	echo "installing gruvbox ..."
	git clone https://github.com/morhetz/gruvbox.git ~/.vim/bundle/gruvbox
	echo "gruvbox installed"
else 
	echo "gruvbox found: yes" 
fi

# need to check if mpi is installed. 
if [ ! -e ~/.vim/bundle/mpi.vim ]; then
	echo "mpi.vim found: no"
	echo "installing mpi.vim"
    pushd ~/.vim/bundle > /dev/null
	git clone https://github.com/jiangxincode/mpi.vim.git 
    popd > /dev/null
	echo "mpi.vim installed"
else
	echo "mpi.vim found: yes"
fi

# installing taglist
if [ ! -e ~/.vim/plugin/taglist.vim ]; then 
	echo "taglist found: no"
	echo "installing taglist ..."
	pushd ~/.vim > /dev/null
	curl http://liquidtelecom.dl.sourceforge.net/project/vim-taglist/vim-taglist/4.6/taglist_46.zip > tag.zip
	unzip tag.zip
    popd > /dev/null
	echo "taglist installed"
else
	echo "taglist found: yes"
fi

# installing nerdtree
if [ ! -d ~/.vim/bundle/nerdtree ]; then 
   	echo "nerdtree found: no"
	echo "installing nerdtree ..."
    pushd ~/.vim/bundle > /dev/null
 	git clone https://github.com/scrooloose/nerdtree.git 
    popd > /dev/null
	echo "nerdtree installed"
else
	echo "nerdtree found: yes"
fi

# installing the nerdtree-tab
if [ ! -d ~/.vim/bundle/vim-nerdtree-tabs ]; then 
	echo "nerdtree-tabs found: no"
	echo "installing nerdtree-tabs ..."
    pushd ~/.vim/bundle > /dev/null
	git clone https://github.com/jistr/vim-nerdtree-tabs.git
    popd > /dev/null
	echo "nerdtree-tabs installed"
else
	echo "nerdtree-tabs found: yes"
fi

# installing the pydict
if [ -d ~/.vim/bundle/pydiction ]; then 
	echo "pydiction found: no"
	echo "installing pydiction ..."
    pushd ~/.vim/bundle > /dev/null
	git clone https://github.com/rkulla/pydiction.git 
    popd > /dev/null
	echo "pydiction installed"
else
	echo "pydiction found: yes"
fi

# installing Matrix screensaver.
if [ ! -e ~/.vim/plugin/matrix.vim ]; then
	echo "matrix found: no"
	echo "installing matrix ..."
	git clone https://github.com/uguu-org/vim-matrix-screensaver.git
	cp vim-matrix-screensaver/plugin/matrix.vim ~/.vim/plugin/
	rm -rf vim-matrix-screensaver
	echo "matrix installed"
else
	echo "matrix found: yes"
fi

# installing the comments.vim
if [ ! -e ~/.vim/plugin/comments.vim ]; then 
	echo "comments.vim found: no"
	echo "installing comments.vim ..."
	curl http://www.vim.org/scripts/download_script.php?src_id=9801 > comments.vim
	mv comments.vim ~/.vim/plugin/
	echo "comments.vim installed"
else
	echo "comments.vim found: yes"
fi

# installing the searchtab 
if [ ! -e ~/.vim/plugin/SearchComplete.vim ]; then 
	echo "SearchComplete.vim found: no"
	echo "installing SearchComplete.vim ..."
	curl http://www.vim.org/scripts/download_script.php?src_id=1388 > SearchComplete.vim
	mv SearchComplete.vim ~/.vim/plugin/
	echo "SearchComplete.vim installed"
else
	echo "SearchComplete.vim found: yes"
fi

#installing the mru plugin
if [ ! -e ~/.vim/plugin/mru.vim ]; then 
	echo "mru.vim found: no"
	echo "installing mru.vim ..."
	git clone https://github.com/yegappan/mru.git 
	cp mru/plugin/mru.vim ~/.vim/plugin/
    rm -rf mru
	echo "mru.vim installed"
else
	echo "mru.vim found: yes"
fi

if [ ! -e ~/.vim/bundle/vim-dirdiff/plugin/dirdiff.vim ]; then 
	echo "dirdiff.vim found: no"
	echo "installing dirdiff.vim ..."
    pushd ~/.vim/bundle > /dev/null
    git clone git://github.com/will133/vim-dirdiff
    popd > /dev/null
    echo "dirdiff installed"
else
    echo "dirdiff found: yes"
fi

if [ ! -e ~/.vim/bundle/ctrlp.vim ]; then 
	echo "ctrlp.vim found: no"
	echo "installing ctrlp.vim ..."
    pushd ~/.vim/bundle > /dev/null
    git clone https://github.com/kien/ctrlp.vim.git
    popd > /dev/null
    echo "ctrlp installed"
else
    echo "ctrlp found: yes"
fi

if [ ! -d ~/.vim/bundle/python-syntax ]; then 
	echo "python syntax highlighting found: no"
	echo "installing python-syntax..."
    pushd ~/.vim/bundle > /dev/null
    git clone https://github.com/hdima/python-syntax.git 
    popd > /dev/null
    echo "python-syntax installed"
else
    echo "python-syntax found: yes"
fi

if [ ! -d ~/.vim/bundle/SrcExpl ]; then 
	echo "SrcExpl found: no"
	echo "installing SrcExpl..."
    pushd ~/.vim/bundle > /dev/null
    git clone https://github.com/wesleyche/SrcExpl.git 
    popd > /dev/null
    echo "SrcExpl installed"
else
    echo "SrcExpl found: yes"
fi

if [ ! -d ~/.vim/bundle/Trinity ]; then 
	echo "Trinity found: no"
	echo "installing Trinity..."
    pushd ~/.vim/bundle > /dev/null
    git clone https://github.com/wesleyche/Trinity.git 
    rm Trinity/plugin/NERD_tree.vim
    popd > /dev/null
    echo "Trinity installed"
else
    echo "Trinity found: yes"
fi

if [ ! -d ~/.vim/plugin/DoxygenToolkit.vim ]; then 
	echo "Doxygen found: no"
	echo "installing Doxygen..."
    git clone https://github.com/mrtazz/DoxygenToolkit.vim.git 
    cp DoxygenToolkit.vim/plugin/DoxygenToolkit.vim ~/.vim/plugin/ 
    rm -rf DoxygenToolkit.vim
    echo "Doxygen installed"
else
    echo "Doxygen found: yes"
fi

if [ ! -d ~/.vim/bundle/supertab ]; then 
	echo "supertab found: no"
	echo "installing supertab..."
    pushd ~/.vim/bundle > /dev/null
    git clone https://github.com/ervandew/supertab.git 
    popd > /dev/null
    echo "supertab installed"
else
    echo "supertab found: yes"
fi
