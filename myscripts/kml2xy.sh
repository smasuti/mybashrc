#!/usr/bin/env bash

set -e
self=$(basename $0)


usage(){
	echo ""
	echo "This script converts kml to xy format"
	echo ""
	echo "usage : $self file.kml"
	echo ""
	exit
}
if [ "$1" == "" ] ; then 
	usage
elif [ ! -e $1 ]; then 
	echo ""
	echo "$self: could not find file $1"
	exit
fi 

declare -a f=(`cat $1 | grep -n "<coordinate" | cut -d":" -f 1 | awk '{print $1+1}'`)

out=$(basename $1 .kml).xy

for (( i = 0; i < ${#f[*]}; ++ i ))
do
	sed -n "${f[$i]}p" $1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | sed 's/0 //g' | awk '{split($0,a,","); for(i=1;i<=length(a);i=i+2) if(a[i] == 0){print ">";}else{printf("%f %f\n", a[i], a[i+1]);}}' >> $out 
done

echo "converted from $1 to $out"
