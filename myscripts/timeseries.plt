#----------------------------------------------------------------
# To plot all the vertical and horizontal component of the GPS
# Author : Sagar Masuti
# Date   : 27-Nov-2015
#----------------------------------------------------------------

set terminal postscript eps enhanced color
outputname="fit.eps"
set output outputname

station="ABGS BITI BTET HNKO LHW2 PBKR PBLI PSMK PTLO RNDG SDKL BTHL BNON BSIM LEWK UMLH"
#station="RNDG SDKL BTHL BNON BSIM LEWK UMLH"
set multiplot
set size 0.40,0.9
set xrange [0:1]
set xlabel "Time (Yr)"
set ylabel "Displacement (cm)"
set format y "%g"
set style line 10 lc rgb '#0060ad' lt 1 lw 0.5 pt 5 ps 0.3
set style line 11 lc rgb '#a9a9a9' lt 1 lw 0.5 pt 5 ps 0.3
set style line 2 lc rgb "red" lt 1 lw 1.2




EXT_TXT="-relax.ned"
EXT_DAT="-relax.dat"

offset=5
set nokey

set ylabel "Vertical displacement(cm)"
veroff=5
ymax=words(station)*veroff
ymin=-2
set yrange[ymin:ymax+veroff]

set origin 0.5,0.05

do for[j=1:words(station)] {
    plot DATA_DIR_PATH.word(station,j).EXT_DAT using 1:(-$4*100 + (j-1)*offset):($7*100) with yerrorbars ls 11, "" using 1:(-$4*100 + (j-1)*offset) ls 10, word(model,1).word(station,j).EXT_TXT using 1:(-$4*100 + (j-1)*offset) with line ls 2


   set label word(station,j) at 1.02, (j-1)*offset
}

set origin 0.05,0.05
horoff=5
set ylabel "Horizontal displacement(cm)"
ymax=words(station)*horoff
ymin=-2
set yrange[ymin:ymax+horoff]

do for[j=1:words(station)] {
    plot DATA_DIR_PATH.word(station,j).EXT_DAT using 1:(sqrt(($2*$2)+($3*$3))*100 + (j-1)*offset):(sqrt($5*$5+$6*$6)*300) with yerrorbars ls 11, "" using 1:(sqrt(($2*$2)+($3*$3))*100 + (j-1)*offset) ls 10, word(model,1).word(station,j).EXT_TXT using 1:(sqrt(($2*$2)+($3*$3))*100 + (j-1)*offset) with line ls 2

 set label word(station,j) at 1.02, (j-1)*offset
}

unset multiplot

system(sprintf("epstopdf %s",outputname));
