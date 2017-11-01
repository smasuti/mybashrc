#!/usr/bin/env bash

#scp sagarshr001@komodo.ase.ntu.edu.sg:/mnt/isilon/userdata/home/sagarshr001/workspace/wharton12/miracle/$1/stdout .
scp sagarshr@ntu.nscc.sg:/home/users/ntu/sagarshr/workspace/wharton12/miracle/$1/stdout .
#relax="relax_"`echo $2 | awk '{printf "%04.4d",$1}'`
#echo $relax
#scp mechanics@komodo.ase.ntu.edu.sg:~//wharton12/$1/stdout .
#scp mechanics@komodo.ase.ntu.edu.sg:~/wharton12/$1/$relax/*.ned .
mv stdout $1.dat
# if 3 model parameter add $6 to the below awk.
expnum=`echo $1 | cut -d"_" -f 3`
size=`echo $1 | cut -d"_" -f 2`
cat $1.dat | grep "in.param" | awk 'BEGIN{print "\%n    misfit    m1(coh)    m2(V_0)"}{print NR,$2,$4,$5,$6}' > temp_$1.dat
newfilename=`echo $1.dat | sed s/miracle/wharton/g`
mv temp_$1.dat $newfilename
echo "created $newfilename file"
