#!/usr/bin/bash


faultname=mine.dat
fout=mine_relax.dat
fpara=mine_relax.vtp

echo $faultname

cat $faultname | awk '{print NR,$2,$3,$4,-$5/2,$6/2,0,$7,$8}' | extrude.sh | grep -v "#" | paste $faultname - | awk '{$2=$10;$3=$11;$4=$12;$10="";$11="";$12="";print NR,$0}' > temp

echo 'Done'
