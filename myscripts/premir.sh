#!/usr/bin/env bash
# This script will prepare the gps data from relax to run miracle.
# Author : Sagar Masuti.
# Date : 23-05-2015
# --------------------------------------------------------------------

DIR=$1
declare -a f=($DIR/*.ned)

for (( i = 0; i < ${#f[*]} ; ++ i ))
do
    grep -v "#" ${f[$i]} | awk 'BEGIN{print "#        t        u1        u2        u3   s1   s2   s3"}{print $1,$2,$3,$4,"0.00000001 0.00000001 0.00000001"}' > temp && mv temp ${f[$i]}
done

