#!/usr/bin/env bash

lb=`echo $1 | cut -d"-" -f 1`
ub=`echo $1 | cut -d"-" -f 2`

for j in $(seq "$lb" "$ub"); do
	i=relax_`echo ${j} | awk '{printf "%04.4d",$1}'`
	pushd $i
	rm -f *.xy
	rm -f *.vtp
	rm -f *.vtk
	rm -f *.creep.dat
	rm -f *.grd
	rm -f *.dat
 	rm -f report.txt	
	popd 
done


