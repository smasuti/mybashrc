#!/usr/bin/env bash

which docopts > /dev/null
out=$?
if [ $out != 0 ]; then
	echo "installing docopts ..."
	git clone https://github.com/docopt/docopts.git	
	cd docopts
	python setup.py install
	cd -
	rm -rf docopts
	echo "docopts installed"
else
	echo "docopts is already present"
fi
