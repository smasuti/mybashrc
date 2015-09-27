#!/usr/bin/env bash

eval "$(docopts -V - -h - : "$@" <<EOF
Usage: seisplot [options]

      -e, --debug                 If enabled it will print some debug values.
      -d, --ddir=<path>           The location of the data to be plotted. 
                                  [default: .]         
      -o, --outfile=name          The name of the output file. [default: out]  
      -s, --stname=<sta>          The name of the station to be plotted.
      -r, --range=<min-max>       The range within which the station to be 
                                  plotted. [default: 0/1000/1000/2000]
      -f, --filter=<f1-f2-f3-f4>  The type of the filtering to be applied.[future]
      -p, --phase=<phase>          Marks the phase using the theoretical arrival
                                  time. Could be the list of phase seperated by
                                  - dashes. ex: P-PP-S
      -m, --model=<prem>          Model to be used to calculate the thereotical 
                                  arrival time. [default: prem]
      -c, --scaling=<m>           This applies the vertical scaling to the 
                                  waveform. The -M option of pssac2. [default: 0.02]
      --help                      Show this message, but you already know that!
      -v, --version               Print program version.

Description:
      This is the simple script to plot seismogram data.

Author: Sagar Masuti 
        Earth Observatory of Singapore, NTU.
-------------------------------------------------------------------------------
seisplot 1.0
Copyright (C) 2015 Sagar Masuti
Date : 25-08-2015
This is free software: you are free to change and redistribute it.
There is NO WARRANTY. 
---------------------------------------------------------------------------
EOF
)"

pushd $ddir > /dev/null

colors[1]="255/0/255"           # magenta
colors[2]="0/0/0"               # black
colors[3]="255/0/0"             # red
colors[4]="255/100/50"          # orange
colors[5]="255/255/0"           # yellow
colors[6]="255/100/100"         # grapefruit red
colors[7]="255/200/200"         # light pink
colors[8]="175/125/125"         # pink/brown
colors[9]="0/255/255"           # cyan
colors[10]="255/100/0"          # orange
colors[11]="255/50/100"         # red/pink
colors[12]="0/0/255"            # blue
colors[13]="100/100/255"        # light blue
colors[14]="0/255/0"            # green
colors[15]="0/100/0"            # forest green
colors[16]="100/200/200"        # blue green

rm -rf plotdir
first=`ls *.z | head -1`
evla=`saclst evla f $first | awk '{print $2}'`
evlo=`saclst evlo f $first | awk '{print $2}'`
evdp=`saclst evdp f $first | awk '{print $2}'`

station=sta.ps
minx=`echo $range | cut -d"/" -f 1`
maxx=`echo $range | cut -d"/" -f 2`
miny=`echo $range | cut -d"/" -f 3`
maxy=`echo $range | cut -d"/" -f 4`

if [ "$filter" == "" ]; then
    filmin1=0.02
    filmax1=1.0
    filmin2=0.02
    filmax2=0.8
else
    filmin1=`echo $filter | cut -d"-" -f 1`
    filmax1=`echo $filter | cut -d"-" -f 2`
    filmin2=`echo $filter | cut -d"-" -f 3`
    filmax2=`echo $filter | cut -d"-" -f 4`
fi

thdist=200
plotdir="plotdir"
mkdir -p $plotdir

if [ "$stname" != "" ] ; then
    saclst stla stlo dist az f $stname > sta.lst
    # plot for the station alone and ta ta bye bye
else
    j=0
    predist=$miny
    declare -a f=(*.10.t)
    if [ "$debug" == "true" ]; then 
        echo "Number of files to process: ${#f[*]}"
    fi
    predist=$(echo "$miny-$thdist-100" | bc -q) 
    for (( i = 0; i < ${#f[*]}-1; ++ i ))
    do
        dist=`saclst dist f ${f[i]} | awk '{printf("%d",$2)}'` 
        az=`saclst az f ${f[i]} | awk '{printf("%d",$2)}'` 
        lastdist=$(echo "$predist+$thdist" | bc -q)
        if [ "$debug" == "true" ]; then
            echo "$predist < $dist < $lastdist"
        fi
        if [[ $dist -ge $miny  &&  $dist -lt $maxy && $predist -lt $dist && $lastdist -lt $dist ]]; then 
            if [[ $predist -lt $dist && $lastdist -lt $dist ]] ; then
                sta=`echo ${f[i]} | cut -d"." -f 8`
                echo "Processing station.. $sta"
                cp ${f[i]} $plotdir/ 
                cp ${f[i]%.t}.z $plotdir/
                if [[ ( "$j" == "0" ) || ( "${name[j-1]}" != "$sta" ) ]] ; then
                    name[j]=$sta
                    distance[j]=$dist
                    stalat=`saclst stla f ${f[i]} | awk '{print $2}'`
                    stalon=`saclst stlo f ${f[i]} | awk '{print $2}'`
                    x=$(echo "$maxx+20" | bc -q)
                    echo "$stalon $stalat 10 0 0 5 $sta" >> $plotdir/sta.lst
                    #if [ "$j" == "0" ]; then
                        #newminx=$(echo "$minx+($dist/10)" | bc -q)
                    #fi
                    let "j+=1"
                fi
            fi
            predist=$dist
        fi
       
    done

    sac << EOF
    r plotdir/*.z
    rtr
    rmean
    int
    bp c ${filmin1} ${filmax1} n 4 p 2
    rtr
    rmean
    w over
    r plotdir/*.[rt]
    rtr
    rmean
    int
    bp c ${filmin2} ${filmax2} n 4 p 2
    rtr
    rmean
    w over
    q
EOF
fi

# Plotting the stations 
pscoast -Rg -JE${evlo}/${evla}/90/6i -B0 -Dc -Ggray -A5000 -Wthinnest -K  > $station
echo $evlo $evla | psxy -J -R -Sa0.5 -Gred -K -O >> ${station}
gmtset ELLIPSOID Sphere
awk '{print $1,$2}' $plotdir/sta.lst | psxy -R -J -St0.3 -G${colors[3]} -W0p -K -O >> ${station}
awk '{print $0}' $plotdir/sta.lst | pstext -O -K  -R -J -P -G50/50/225 -D0.2c/0 >> ${station}

if [ "$phase" != "" ] ; then
    n=`echo $phase | awk '{n=split($1,a,"-");print n}'`
    for (( j=1; j <= n; j++ ))
    do
        ph=`echo $phase | cut -d"-" -f $j` 
        echo "Processing phase $ph"
        for (( i = $miny; i <= $maxy; i=i+100 ))
        do
           taup_time -mod $model -h $evdp -km $i -ph $ph -time | sed '/^$/d' | \
           awk -v dist=$i -v p=$ph '{print $1,dist,p}' >> $plotdir/taup.txt  
        done    
        echo "> 10" >> $plotdir/taup.txt
    done
fi

j=0
right=3
psbasemap -JX4i/7i -R$minx/$maxx/$miny/$maxy -Ba500f100:"Time (s)"::."Vertical \
component":/a500f100:"Distance (km)":nSWe -K -X$right \
> ${outfile}.ps 
pssac2 -JX -R -Ekt-1 -M$scaling/0 plotdir/*.z -W0.5p/blue -K -O \
>> ${outfile}.ps
cat $plotdir/sta.lst | pstext -JX -R -O -K -N >> ${outfile}.ps 
if [ "$phase" != "" ] ; then
    n=`echo $phase | awk '{n=split($1,a,"-");print n}'`
    for (( j=1; j <= n; j++ ))
    do
        ph=`echo $phase | cut -d"-" -f $j` 
        cat $plotdir/taup.txt | grep $ph | psxy -JX -R -M -W0.8p/${colors[$j]} \
        -K -O >> ${outfile}.ps
        x=`cat plotdir/taup.txt | grep "^$ph" | awk 'BEGIN{max=0}{if($1>max)\
           {max=$1}}END{print max}'`
        y=$(echo $maxy-50 | bc -q)
        echo "$x $y 20 0 0 LM $ph" | pstext -JX -R -G${colors[$j]} -K -O \
        -N >> ${outfile}.ps 
    done
fi

right=13
psbasemap -JX4i/7i -R$minx/$maxx/$miny/$maxy -Ba500f100:"Time (s)"::."Tangential \
component":/a500f100:"Distance (km)":nSwe -K -O -X$right \
>> ${outfile}.ps 
pssac2 -JX -R -Ekt-1 -M$scaling/0 plotdir/*.t -W0.5p/blue -K -O \
>> ${outfile}.ps
cat $plotdir/sta.lst | pstext -JX -R -O -K -N >> ${outfile}.ps 
if [ "$phase" != "" ] ; then
    n=`echo $phase | awk '{n=split($1,a,"-");print n}'`
    for (( j=1; j <= n; j++ ))
    do
        ph=`echo $phase | cut -d"-" -f $j` 
        cat $plotdir/taup.txt | grep $ph | psxy -JX -R -M -W0.8p/${colors[$j]} \
        -K -O >> ${outfile}.ps
        x=`cat plotdir/taup.txt | grep "^$ph" | awk 'BEGIN{max=0}{if($1>max)\
           {max=$1}}END{print max}'`
        y=$(echo $maxy-50 | bc -q)
        echo "$x $y 20 0 0 LM $ph" | pstext -JX -R -G${colors[$j]} -K -O \
        -N >> ${outfile}.ps 
    done
fi

#rm $plotdir/sta.lst
rm $plotdir/taup.txt 
popd > /dev/null

echo ""
echo "# -------------------------------------------------------"
echo "# The script produced two files : $station and $outfile.ps"
echo "# -------------------------------------------------------"
echo ""
