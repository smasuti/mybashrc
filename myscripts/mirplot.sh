#!/usr/bin/env bash

export PATH=$PATH:~/src/relax/util

PLOT_SCRIPT_PATH=~/src/mybashrc/myscripts/timeseries.plt
CUR_PATH=$1
DATA_PATH="$1/gps/"
OUT_DIR="$1/plots"
mkdir -p $OUT_DIR
gsed -i "23i DATA_DIR_PATH=\"${DATA_PATH}\"" ${PLOT_SCRIPT_PATH} 
i=${CUR_PATH}/relax_0001
#for i in ${CUR_PATH}/relax_*;
#do 
	if [ -e $i/ABGS.ned ]; then
		echo "Processing $i"
		gsed -i "24i model=\"$i/\"" ${PLOT_SCRIPT_PATH} 
		if [ ! -f $i/ABGS-relax.ned ]; then
			obsrelax.sh -s $i/????.ned
		fi
		gnuplot ${PLOT_SCRIPT_PATH}
		f=`echo $i | rev | cut -d"/" -f 1 | rev` 
		filename="${f}.pdf"
		mv fit.pdf $filename
		mv $filename $OUT_DIR 
		rm fit.eps
		gsed -i 24d ${PLOT_SCRIPT_PATH} 
	fi
#done
gsed -i 23d ${PLOT_SCRIPT_PATH} 
