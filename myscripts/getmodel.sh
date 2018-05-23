#!/usr/bin/env bash

eval "$(docopts -V - -h - : "$@" <<EOF
Usage: getmodel.sh [options]

      -s, --source=<SOURCE>       The server name.
      -m, --model=<MODEL>         The name of the folder/model.
      --help                      Show help options.
      --version                   Print program version.

Description:
     This script downloads the stdout of the model and changes to the format 
     required for plotting.

Examples:

----
getmodel.sh 1.0
opyright (C) 2017 Sagar Masuti
Author: Sagar Masuti 
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
EOF
)"

case $source in 
[1])
scp sagarshr001@komodo.ase.ntu.edu.sg:/mnt/isilon/userdata/home/sagarshr001/workspace/wharton12/slip_system_dependent_rheology/$model/stdout .
;;
[2])
#scp sagarshr@ntu.nscc.sg:/home/users/ntu/sagarshr/workspace/wharton12/miracle/benchmark_3_param/$model/stdout .
scp sagarshr@ntu.nscc.sg:/home/users/ntu/sagarshr/workspace/wharton12/miracle/$model/stdout .
;;
[3])
scp sagarshr001@nya2.hpc.ntu.edu.sg:/home/sagarshr001/workspace/wharton12/miracle/$model/stdout .
;;
*)
echo "No matching cluster found"
;;
esac

mv stdout $model.dat
# if 3 model parameter add $6 to the below awk.
expnum=`echo $model | cut -d"_" -f 3`
size=`echo $model | cut -d"_" -f 2`
cat $model.dat | grep "in.param" | awk 'BEGIN{print "\%n    misfit    m1(coh)    m2(V_0)"}{print NR,$2,$4,$5,$6}' > temp_$model.dat
newfilename=`echo $model.dat | sed s/miracle/wharton/g`
mv temp_$model.dat $newfilename
echo "created $newfilename file"
