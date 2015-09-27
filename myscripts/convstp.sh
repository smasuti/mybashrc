#!/usr/bin/env bash

rm final_data.dat
echo "Earthquake-1" > final_data.dat
echo "CHN     33.9988 -117.6804" >> final_data.dat
cat $1 | awk '{print $6,$5,$2}' | proj +proj=utm +zone=11 | awk '{$1=($1-437202.03)/1e3;$2=($2-3762231.31)/1e3; print NR,$3,$2,$1}' > temp1.dat
cat $1 | awk '{print NR,$2,$5,$6,$7,$13}' > temp2.dat
join temp2.dat temp1.dat | column -t | awk '{{printf("%5s%10.4f%10.4f%10.4f%10.3f%10.3f%10.3f\n",$2,$3,$4,$5,$8,$9,$6)}}' >> final_data.dat
#join temp2.dat temp1.dat | column -t | awk '{if(length($2)<4){printf("%5s%10.4f%10.4f%10.4f%10.3f%10.3f%10.3f\n",$2,$3,$4,$5,$8,$9,$6)}}' >> final_data.dat
awk '!a[$1]++' final_data.dat > temp
mv temp final_data.dat
rm temp1.dat
rm temp2.dat
