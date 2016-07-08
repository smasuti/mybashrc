#!/usr/bin/env bash

module load gnuplot/4.6.5/gnu 
module load relax/gnu

echo $PWD
PLOT_SCRIPT_PATH=~/bin/timeseries.plt
MODEL_PATH=$1
DATA_PATH="~//workspace/wharton12/miracle/miracle_16_1/gps/"
OUT_DIR=$PWD/plots
mkdir -p $OUT_DIR

sed -i "23i DATA_DIR_PATH=\"${DATA_PATH}\/\"" ${PLOT_SCRIPT_PATH} 
sed -i "24i model=\"${MODEL_PATH}\/\"" ${PLOT_SCRIPT_PATH} 

if [ ! -f $MODEL_PATH/ABGS-relax.ned ]; then
	obsrelax.sh ${MODEL_PATH}/????.ned
fi
#obsrelax.sh ${DATA_PATH}/????.ned

gnuplot ${PLOT_SCRIPT_PATH}

f1=`echo $MODEL_PATH | rev | cut -d"/" -f 2 | rev` 
filename="${f1}.pdf"
mv fit.pdf $filename
mv $filename $OUT_DIR 
rm fit.eps

sed -i 24d ${PLOT_SCRIPT_PATH} 
sed -i 23d ${PLOT_SCRIPT_PATH} 
