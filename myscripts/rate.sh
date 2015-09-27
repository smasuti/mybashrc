#!/usr/bin/env bash
# This is a script to plot the seismicity iteratively.
# Author : Sagar Masuti.
# Date : 22-05-2015
# -------------------------------------------------------------------


yys=2000
for i in {0..11}; do
    yy=$(echo "$yys + $i" | bc -q) 
    st=`echo "$yy-01-01"`
    en=`echo "$yy-12-31"`
    out=`echo "out_usgs_$yy"`
    seismicity.sh -s $st -e $en -r 90/95/-2/5 -n -o $out 
    out=`echo "out_cmt_$yy"`
    seismicity.sh -s $st -e $en -r 90/95/-2/5 -n -t CMT -o $out 
done
    seismicity.sh -s 2012-01-01 -e 2012-04-12 -r 90/95/-2/5 -n -o out_usgs_2012
    seismicity.sh -s 2012-01-01 -e 2012-04-12 -r 90/95/-2/5 -n -t CMT -o out_cmt_2012
