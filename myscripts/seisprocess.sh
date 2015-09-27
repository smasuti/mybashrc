#!/usr/bin/env bash

eval "$(docopts -V - -h - : "$@" <<EOF
Usage: seisprocess --time=<time> [options]

      -p, --debug                 If enabled it will print some debug values.
      -d, --data=<path>           The location of the data.         
      -o, --output=<outfolder>    Puts all the processed data into this folder.
                                  [default: ground_vel]
      --help                      Show help options.
      -v, --version               Print program version.

Description:
    time format is hh mm ss mil. For example, 21 41 20 000
----
seisprocess 1.0
Copyright (C) 2015 Sagar Masuti
Author: Sagar Masuti 
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
EOF
)"

if [ "$data" == "" ]; then
    data=$PWD
fi

rdseed -df $data/*.seed > /dev/null
rdseed -pf $data/*.seed > /dev/null

if [ "$output" == "" ]; then
    output="$data/ground_vel"
fi

mkdir -p $output

# rename the files. 
ls -1 SAC_* | awk '{split($1,a,"_");print "mv "$1,a[1]"_"a[2]"_"a[3]"_"a[4]"_"a[5]"_"a[6]}' > /dev/null

macro="$data/origin.sm"
first=`ls *.SAC | head -1`
year=`echo "$first" | awk '{split($1,a,"."); print a[1]" "a[2]" "}'`
origin=`echo $year $time`
evla=`saclst evla f $first | awk '{print $2}'`
evlo=`saclst evlo f $first | awk '{print $2}'`
evdp=`saclst evdp f $first | awk '{print $2}'`

if [ $debug == "true" ]; then
    echo "year jday = $origin evla = $evla evlo = $evlo evdp = $evdp"
fi

rm $macro

cat > $macro << EOF 
r \$1 
chnhdr o gmt $origin
evaluate to tt1 &1,o * -1
chnhdr allt %tt1
ch evla $evla 
ch evlo $evlo 
ch evdp $evdp 
writehdr
EOF

ls -1 *.[zrt] *.sac *.SAC *.HN? *.BH? | awk -v macro=$macro '{print "r "$1,"\nm ",\
                                        macro,$1}END{print "q"}' | sac

echo "removing the instrument response .."
transfer_iris.pl > /dev/null
echo "completed removing instrument response" 
echo ""

echo "rotating .."
pushd $output > /dev/null 
for i in *.SAC; do mv $i ${i%.M.SAC}; done

rot_all.pl . > /dev/null

echo "completed rotating .."

# Need to do the plotting from here. 
# Lets write in a script file seperately.

popd > /dev/null
popd > /dev/null
