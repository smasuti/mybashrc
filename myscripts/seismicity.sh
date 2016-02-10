#!/usr/bin/env bash

eval "$(docopts -V - -h - : "$@" <<EOF
Usage: seismicity [options]

      -r, --region=<REG>          The region of the seismicity. 
                                  <REG>=west/east/south/north [default: 90/120/-10/10]
      -m, --mag=<MAG>             The minmum magnitude. <MAG> should be from 0 to 8 [default: 4]
      -s, --start=<DATE>          The start date. date format = yyyy-mm-dd
      -e, --end=<DATE>            The end date. date format = yyyy-mm-dd
      -c, --cpt=<file>            Uses the specified cpt palette [default: seis]
      -d, --debug                 If enabled it will print some debug values.
      -f, --file=<file>           If specified plot from the file.
      -i, --mms=<min/max/step>    Uses the min/max/step to generate the cpt.
      -o, --output=<outfile>      Uses the outfile to output [default: seismicity.ps]
      -t, --type=<database>       Option of choosing the USGS/CMT. [default: USGS]		
      -l,                         Adds the magnitude and date to the earthquake.
      -n, --nodisplay             If specified dont display only download and plot. [default: false]
      --help                      Show help options.
      --version                   Print program version.

Description:
     This script plots the seismicity of the specified region(-r option) from the 
     start date(-s option) to the end date(-e option) above the specified magnitude
     (-m option).  
     date format = yyyy-mm-dd
     If the region and the magnitude are not specified default values are used.

Examples:
     seismicity.sh -r 119/123/21/26 -s 1960-01-01 -e 2016-02-06
----
seismicity 1.0
Copyright (C) 2015 Sagar Masuti
Author: Sagar Masuti & Shweta Kalghatgi
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
EOF
)"

# --------------------------------------------------------------------------------------------------
# To Do :
# 1. Check if its possible to incorporate the moment released by this seismicity check ader et al 2012
# 2. Need to add option to overlay other plots. 
# 3. Check for start and end if file is not given and throw error.
# --------------------------------------------------------------------------------------------------

checkDownload ()
{       
    prereg=`cat $1 | sed -n "1p" | cut -d"=" -f 2 | cut -d" " -f 1`  
    prestart=`cat $1 | sed -n "1p" | cut -d"=" -f 3 | cut -d" " -f 1`  
    preend=`cat $1 | sed -n "1p" | cut -d"=" -f 4 | cut -d" " -f 1`  
    premag=`cat $1 | sed -n "1p" | cut -d"=" -f 5 | cut -d" " -f 1`  
    if [ $debug == "true" ]; then
        echo "Previous -> reg : $prereg start=$prestart end=$preend mag=$premag" 
    fi

    if [[ ( ${region} == ${prereg} ) && ( ${start} == ${prestart} ) && \
        ( ${end} == ${preend} ) && ( $premag == $mag ) ]] ; then
        download="false"
    fi 
}
# --------------------------------------------------------------------------------------------------
# Variables.
t=2
res=i
amp="&"
download="true"
psFile="$output"
pdfFile="seismicity.pdf"
# --------------------------------------------------------------------------------------------------

# ------------- defaults ----------------
# Check for region.
if [ "$region" == "" ]; then 
	if [ "$file" == "" ]; then 
		echo "Default region is chosen"
		region="90/120/-10/10"
	else
		lon1=`grep -v "#" $file | awk 'BEGIN{m=100.0}{m=($1>m)?m:$1;}END{print m-1}'`
		lon2=`grep -v "#" $file | awk 'function max(x,y){return (x>y)?x:y};BEGIN{m=0}{m=max(m,$1)}END{print m+1}'`
		lat1=`grep -v "#" $file | awk 'BEGIN{m=100.0}{m=($2>m)?m:$2;}END{print m-1}'`
		lat2=`grep -v "#" $file | awk 'function max(x,y){return (x>y)?x:y};BEGIN{m=0}{m=max(m,$2)}END{print m+1}'`
		region=`echo "$lon1/$lon2/$lat1/$lat2"`
	fi	
fi

# Magnitude of seismicity
if [ "$mag" == "" ]; then
	mag=4
fi 

# cpt file option
if [ "$cpt" == "" ]; then
	cpt="seis"
fi 

if [ "$output" == "" ]; then 
	output="seismicity.ps"
fi

if [ "$type" == "" ]; then 
	type="USGS"
fi
# ---------------------------------------

w=`echo "$region" | cut -d"/" -f 1`
e=`echo "$region" | cut -d"/" -f 2`
s=`echo "$region" | cut -d"/" -f 3`
n=`echo "$region" | cut -d"/" -f 4`

echo "The region is : $w/$e/$s/$n"
if [ $debug == "true" ]; then 
	echo "The magnitude is : $mag"
fi

# --------------------------------------------------------------------------------------------------
# If file is empty download the data.
if [ "$file" == "" ]; then
    # check if the data is already downloaded.
    if [[ ( -e usgs_ll.dat )  && ( "$type" == "USGS" ) ]] ; then
        # This all should go in a seperate function.
        file=usgs_ll.dat
        checkDownload "usgs_ll.dat" 
    elif [[ ( -e cmt_ll.dat )  && ( "$type" == "CMT" ) ]] ; then 
        file=cmt_ll.dat
        checkDownload "cmt_ll.dat" 
    fi

    if [ $download == "true" ]; then 
        if [ "$type" == "USGS" ]; then
            if [ $debug == "true" ]; then
                echo "Going to request for USGS data"
            fi

            file=usgs_ll.dat
            min="minmagnitude="
            minlat="minlatitude="
            maxlat="maxlatitude="
            minlong="minlongitude="
            maxlong="maxlongitude="
            st="starttime="
            et="endtime="
            str="http://earthquake.usgs.gov/fdsnws/event/1/query?format=csv"

            url=`echo $str$amp$st$start$amp$et$end$amp$min$mag$amp$minlat$s$amp$maxlat$n$amp$minlong$w$amp$maxlong$e`

            if [ $debug == "true" ]; then 
                echo "url is : $url"
            fi
            
            echo "Downloading the seismicity ..."
            echo "It may take a while depending on the start and end date"
            curl -s $url > data.csv
            echo "Downloading completed ..."

            if [ ! -e data.csv ]; then 
                echo "Error: couldnt download the data. try again"
                exit 
            fi
            echo "# region=$region start=$start end=$end mag=$mag" > $file

            cat data.csv | awk -F"," 'BEGIN{print "# lon,lat,depth,mag,year,month,day"}{if (1<NR){print $3,$2,$4,$5,substr($0,0,4),substr($0,6,2),substr($0,9,2)}}' >> $file

            rm data.csv
        else
            if [ $debug == "true" ]; then
                echo "Going to request for CMT data"
            fi

            file=cmt_ll.dat
            str="http://www.globalcmt.org/cgi-bin/globalcmt-cgi-bin/CMT4/form?itype=ymd"
            yr="yr="
            mo="mo="
            day="day="
            format="otype=ymd"
            j="jyr=1976&jday=1&ojyr=1976&ojday=1&nday=1"
            mmin="lmw="
            mmax="umw=10"
            lmin="lms=0&ums=10&lmb=0&umb=10"
            llat="llat="
            ulat="ulat="
            llon="llon="
            ulon="ulon="
            ex="lhd=0&uhd=1000&lts=-9999&uts=9999&lpe1=0&upe1=90&lpe2=0&upe2=90&list=6"
            ochr="o"
            syr=`echo $start | cut -d"-" -f 1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'`
            smo=`echo $start | cut -d"-" -f 2 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'`
            sday=`echo $start | cut -d"-" -f 3 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'`
            eyr=`echo $end | cut -d"-" -f 1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'`
            emo=`echo $end | cut -d"-" -f 2 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'`
            eday=`echo $end | cut -d"-" -f 3 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'`

            echo "# region=$region start=$start end=$end mag=$mag" > $file

            url=`echo $str$amp$yr$syr$amp$mo$smo$amp$day$sday$amp$format$amp$ochr$yr$eyr$amp$ochr$mo$emo$amp$ochr$day$eday$amp$j$amp$mmin$mag$amp$mmax$amp$lmin$amp$llat$s$amp$ulat$n$amp$llon$w$amp$ulon$e$amp$ex`
            
            if [ $debug == "true" ]; then
                echo "url is: $url"
            fi
            curl -s $url | grep "X Y" >> $file 
        fi
    fi
else
    if [ "$start" == "" ]; then
        syr=`minmax usgs_ll.dat | awk '{print $9}' | cut -d"/" -f 1 | cut -d"<" -f 2` 
        smo=`minmax usgs_ll.dat | awk '{print $10}' | cut -d"/" -f 1 | cut -d"<" -f 2`
        sday=`minmax usgs_ll.dat | awk '{print $11}' | cut -d"/" -f 1 | cut -d"<" -f 2`
        start=`echo $sday-$smo-$syr` 
    fi
    if [ "$end" == "" ]; then
        eyr=`minmax usgs_ll.dat | awk '{print $9}' | cut -d"/" -f 2 | cut -d">" -f 1`
        emo=`minmax usgs_ll.dat | awk '{print $10}' | cut -d"/" -f 2 | cut -d">" -f 1`
        eday=`minmax usgs_ll.dat | awk '{print $11}' | cut -d"/" -f 2 | cut -d">" -f 1`
        end=`echo $eday-$emo-$eyr` 
    fi
    echo "$start-$end"
fi


echo "plotting the boundary/coast ..."
title="Seismicity (From $start to $end)"
pscoast -R$region -Bf${t}a${t}:"":/f${t}a${t}:""::."$title":WSne -W1 -JM7i -P -K -D$res -N1 > $psFile

if [ "$mms" == "" ]; then

	m1=`grep -v "#" $file | awk 'BEGIN{m=100.0}{m=($3>m)?m:$3;}END{print m}'`
	m2=`grep -v "#" $file | awk 'function max(x,y){return (x>y)?x:y};BEGIN{m=0}{m=max(m,$3)}END{print m}'`

	if [ $debug == "true" ]; then 
		echo "min and max are : $m1 $m2"
	fi

	if [ "$m1" == "" ]; then 
		m1=0
	fi

	if [ "$m2" == "" ]; then 
		m2=10
	fi

	if [ "$m1" == "$m2" ]; then 
		m1=0
	fi
	step=$(echo "scale=2; ($m2-$m1)/100" | bc -q) 
else
	m1=`echo $mms | cut -d"/" -f 1`
	m2=`echo $mms | cut -d"/" -f 2`
	step=`echo $mms | cut -d"/" -f 3`
fi 

scale=$(echo "scale=1; ($m2-$m1)/6.0" | bc -q) 

if [ $debug == "true" ]; then 
	echo "scale is: $scale"
	echo "step is: $step"
fi

# checking for end members and inserting triangles in psscale. 
a1=`grep -v "#" $file | awk 'BEGIN{m=100.0}{m=($3>m)?m:$3;}END{print m}'`
a2=`grep -v "#" $file | awk 'function max(x,y){return (x>y)?x:y};BEGIN{m=0}{m=max(m,$3)}END{print m}'`

res1=$(echo "$a1 != $m1" | bc -q)
res2=$(echo "$a2 != $m2" | bc -q)

if [ \( "$res1" -eq 1 -a "$res2" -eq 1 \) ]; then
	eflag="-E"
fi

makecpt -T$m1/$m2/$step -D -C$cpt > depth.cpt
psscale -O -K $eflag -B$scale/:"Depth (km)": -D3.5i/-0.4i/3.0i/0.2ih -C./depth.cpt >> $psFile

#offset=1
#psxy -O -K -JM7i -R$region  -P -N -M -Sc -Cdepth.cpt -W0.22p <<EOF >> $psFile
#$(bc <<< $w+$offset) $(bc <<< $s-0.7 ) 0 0.64 
#$(bc <<< $w+$offset+0.5) $(bc <<< $s-0.7 ) 0 0.49
#$(bc <<< $w+$offset+1.0) $(bc <<< $s-0.7 ) 0 0.36
#$(bc <<< $w+$offset+1.5) $(bc <<< $s-0.7 ) 0 0.25
#$(bc <<< $w+$offset+2.0) $(bc <<< $s-0.7 ) 0 0.16
#EOF

#pstext -O -K -JM7i -R$region  -P -N <<EOF >> $psFile
#$(bc <<< $w+$offset-0.5) $(bc <<< $s-0.7) 15 0 0 LM 8 
#EOF
count=`grep -v "#" $file | wc -l`

echo "Number of earthquakes : $count"
echo "plotting the seismicity ..."
if [ $type == "USGS" ]; then
	grep -v "#" $file | awk '{print $1,$2,$3,$4*$4/100}' | psxy -O -K -JM7i -R$region -P -M -Cdepth.cpt -Sc -W0.22p/0/0/0 >> $psFile
    if [ $l == "true" ]; then 
        grep -v "#" $file | awk '{printf("%.3f %.3f 08 0 29 LM Mw%.1f %d/%d/%d\n",$1,$2,$4,$5,$6,$7);}' | \
        pstext -O -K  -R$region -JM7i -P -G50/50/225 -D0.2c/0 >> $psFile 
    fi
else
	grep -v "#" $file | psmeca -V -O -K -JM7i -R$region -Zdepth.cpt -P -M -D0/110 -G0/204/0 \
		   -W1p/0/0/0 -Sd0.5/-1/0 >> $psFile
	#grep -v "#" $file |	\
	#awk 'function log10(x){return log(x)/log(10)}; \
		 #function Mw(x){return 2/3*(log10(x)-16.1)}; \
		 #function Mo(mrr,mtt,mpp,mrt,mrp,mtp){return sqrt((mrr^2+mtt^2+mpp^2+2*mrt^2+2*mrp^2+2*mtp^2)/2)}; \
		 #function MoSS(mrr,mtt,mpp,mrt,mrp,mtp){return sqrt((mtt^2+mpp^2+2*mtp^2)/2)}; \
		 #{if (7==length($13)){$3=substr($13,5,2);if (20<$3){$3=$3+1900}else{$3=$3+2000}} \
		 #else{$3=substr($13,1,4)}; { \
		 #printf "%f %f %s %02d/%3.1f\n",$1,$2,"08 0 29 LM ",substr($3,3,2),Mw(10^$10*Mo($4,$5,$6,$7,$8,$9)) \
		 #}}' | pstext -O -K -JM7i -R$region -P -G0/0/99 -D0.2c/0 >> $psFile	
fi

# convert to pdf and display
ps2pdf -sPAPERSIZE="archA" -dPDFSETTINGS=/prepress $psFile $pdfFile
if [ "$nodisplay" != "true" ]; then
    xpdf -geometry +0+0 -paper "archA" $pdfFile -z 100 -g 565x655 >& /dev/null &
fi

rm depth.cpt
