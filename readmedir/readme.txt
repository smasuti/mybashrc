1) Renaming all the files in a directory
	for f in * ; do a=`echo $f | cut -d"_" -f 1`;mv $f $a; done
	for f in *.ned; do mv $(basename $f) $(basename $f .ned).txt; done;

2) Adding numbers for rebtel account
	cat temp | awk '{print $7}' | awk -F":" 'BEGIN{s=0}{s=s+$2;print $2}END{print "sum is ",s}'

3) Adding numbers from ocbc account 
	cat t | awk 'BEGIN{c=0.0;}{c=c+$1}END{print c}'

4) Counting the number of words in a tex file 
	detex document.tex | wc -w

5) Convert the latlon to km(relax) format
	 grep -v "#" sugar_ll.dat | awk '{print $4,$3,$2}' | proj +proj=utm +zone=47 | awk '{$1=($1+56748.29)/1e3;$2=($2-221910.44)/1e3;print $0}' | awk '{print NR,$3,$1,$2,0}' > sugar_km.dat

6) Plate age at x,y 
	echo ""| awk '{for(x=-200;x<=200;x=x+10){for(y=-200;y<=200;y=y+10){print x,y;}}}' | grdtrack  -G/Users/smasuti/wharton12/gmt/age.3.2_km.grd

7) x,y,z, to ductile zones.
	cat temp | awk '{for(z=80;z<=200;z=z+10){if($3>0){print z,$3,$1,$2,10,10,10,0,0}}}' | getGammadot.py > ductile.flt

8) Converting from km to ll of grd file 
	grd2xyz ../../stress_recMega_src12_100_new/000-log10-tau.grd | awk '{print $1*1e3-56748.29,$2*1e3+221910.44,$3}' | invproj +proj=utm +zone=47 -f "%f" | surface -R/Users/SMasuti/wharton12/gmt/etopo2_ll.grd -G../../stress_recMega_src12_100_new/000-log10-tau-ll.grd

9) Plotting the diviatoric stress 
grdmap.sh -g -b 84/106/-12/12 -t 2 -p -3/0/0.001 -c ./seis_inv.cpt -e ./erpatch.sh -e ./ewharton.sh -e ./efaults.sh -e ./emoment.sh -e ./ecoasts.sh -e ./eninety.sh -e ./elabel_ll.sh -C 1 ../../stress_recMega_src12_80_new/000-log10-tau-ll.grd

10) Get the number of lines in a variable 
	num=$(grep -v "#" ductile.dat | wc -l | tr -d ' ')

11) Ductile zones along slab
	echo ""| awk '{for(x=-1400;x<=1400;x=x+40){for(y=-1400;y<=1400;y=y+40){print x,y;}}}' | grdtrack  -G/Users/smasuti/wharton12/gmt/age.3.2_km_neighbor.grd | grdtrack -G/Users/smasuti/wharton12/gmt/sum_slab1.0_clip_km.grd | awk '{for(z=80;z<=200;z=z+10){if($3>0){print z+($4+0),$3,$2,$1,40,40,10,0,0}}}' | getGammadot.py > ductile.dat 

12) Extrapolating the age in the slab area
	grd2xyz age.3.2_km.grd | nearneighbor -R-1500/1250/-1300/1500 -I10/10 -S220 -G../gmt/age.3.2_km_neighbor.grd -N6/1

13) Check the storage and search max directory size in GB
	du -h | awk '{if($1 ~ /G/){print $0}}'

14) Processing for postseismic data: 79p is the line number.  
	echo "# Name  u1      u2        u3" > postseismic.dat; for i in *-relax.txt; do  echo -n `echo $i | awk '{print substr($0,0,4)," "}'`; sed -n 79p $i | awk '{print " ",$2,$3,$4}'; done >> postseismic.dat

15) Joining 2 files with the first column matching 
	join <(sort sugar_temp.dat) <(sort postseismic.dat)  | awk '{print $1,$2,$3,$4,$5,$6}' | column -t > post.dat

16) Getting the line number of particular time in all the data files.
	cat sugar_km.dat | awk '{print substr($2,0,4)".dat"}' | getData.py

17) Combining the postseismic of data and model
	join <(sort post_data.dat) <(sort post_model.dat) | awk 'BEGIN{print "#name lat lon u1(d), u2(d), u3(d), u1(m), u2(m), u3(m)"}{print $1,$5,$6,$2,$3,$4,$7,$8,$9}' | column -t > postseismic.dat
	
18) Getting  all the needed libraries of a binary
	readelf -d ./miracle | grep NEEDED

19) renew the DHCP
	sudo ipconfig set en0 DHCP

20) search and replace in files 
	grep -rl "komodo" . | xargs sed -i s/komodo/nya2/g 

21) Remove blank spaces and lines from the file 
	sed -i '/^[[:space:]]*$/d;s/[[:space:]]*$//' na.asc

22) To plot the vectors on the map view using relax with latitude and longitude. We need to convert each of the component into ll format and then using the following command. 
	grdmap.sh -g -b 84/106/-12/12 -t 2 -p -0.3/0.3/0.001 -v 0.5 -s 1 -e erpatch.sh -e ./ecoasts.sh ../exp200f6g300ductile5000/042

23) Getting the best model in miracle before the miracle has finished executing.
	komodo :
		grep -n "res= " 12444.komodo.des.OU | awk 'BEGIN{min=5.1498E+03}{if (min > $13){min=$13;m1=$7;m2=$9;m3=$11}}END{print  "m1 : " m1 "m2 : " m2 "m3 : " m3 min}' 
	
	nya2 : 
	grep -n "res= " p2_37644.out | awk 'BEGIN{min=5.1891E+03}{if (min > $11){min=$11;m1=(3981*$7)**(1/1.2);m2=$9;}}END{print m1, m2}' > best_37644.txt

24) Getting the coulomb stress at certain point in relax 
	for i in {10..29}; do grdcoulomb.sh -s 289 -d 89 -r 176 -f 0.4 0$i; echo "-131.697 39.3635" | grdtrack -G0$i-tc.grd >> stress.txt ; done

25) Getting the models from the log file. 
	* grep -n "res= " p2_37644.out | awk 'BEGIN{print "    m(1)     m(2)"}{print (3981*$7)**(1/1.2),$9}' > models_37644.txt
    * converting : cat temp | awk 'BEGIN{print "#n modelno coh vstar vo misfit"}{m1=(3981*(10**$3))**(1/1.2);print NR,$1,m1,$4,10**$5,$2}' | column -t > model.txt
    * sorting : cat model.txt | sort -g -k6 | head

26) Cumulative stress. 
This is wrong I guess:	cat stress.txt | awk 'BEGIN{sum=$3}{for(i=0;i<NR;i++){sum=sum+$3};print $2, sum;sum=0;}' > cumulative.txt

28) Sample usage of grdview command.
	grdview.sh -b -800/800/-800/800/-500/0 -t 200  -E 200/40 -e ./ez_geology.sh ../exp200f6g300ductile1100ad5/exp200f6g300ductile1100ad5/001

29) From km to ll using invproj
	cat rfaults-001.xy | awk '{if (substr($0,0,1)==">"){print $0}else{print $1*1e3-56748.29,$2*1e3+221910.44}}' | invproj +proj=utm +zone=47 -t">" -f %f  > rfaults-001_ll.xy

30) Exploring the end members
 obsres.py -b 0/1 --relax --range=-1/1/0.1 --ddir data/gps/ps2 --network=../data/gps/ps2/opts12.dat ./coupled_swei_hscm_1 ./exp200f6g300ductile1000ad15 ./exp300f6g0ductile50ad15 ./exp300f6g1500ductile4000ad15 ./exp300f6g300ductile50ad15 ./exp300f6g500ductile1000ad15

31) Best model out of log
	cat models.txt | awk 'BEGIN{m1=0;m2=0;m3=0;min=10}{if($4<min){min=$4;m1=$1;m2=$2;m3=$3;}}END{print m1,m2,m3,min}' > best.txt

32) logarithm to base 10 in awk.
	grep -n "res= " stdout | awk 'function log10(n){return log(n)/log(10)}{print log10($7),$9,log10($11),$13}' > models.txt

33) Multiple events relax
	obsrelax.sh -t 0.24/2.7/5.82/7.28 5eventscorrected/????.txt

34) git related commands 
	git config --global user.name "sagar masuti"
	git config --global user.email "sagar.masuti@gmail.com"
	# generate the ssh public key
	ssh-keygen -t rsa
	# get the locally deleted file
	git checkout HEAD <path>

35) convert NEIC catalogue to GMT
cat ~/Downloads/query.csv | awk -F"," 'BEGIN{print "# lon,lat,depth,mag,year,month,day"}{if (1<NR){print $3,$2,$4,$5,substr($0,0,4),substr($0,6,2),substr($0,9,2)}}' > ../gmt/neic_Mw4_ll.dat

36) To format the output using double awk
	grep -v "#" models.txt | awk '{printf ("%.4f %.4f %.4f %.4f\n",$1,$2,$3,$4)}' | awk '{printf("%10s %10s %10s %12s\n",$1,$2,$3,$4)}' 

37) Command to replace new line inserted by excel in vi. To type ^M use ctrl+v and then ctrl+m
	vi temp.csv
	%s/^M/^M/gc

38) replacing the character and new line with just a newline 
	%s/+\n/\r/gc # here the character is + 

39) Plotting the function name as the x-axis in gnuplot
	plot 'multi.txt' using 1:3:xtic(2) w l title "mkl1", "" using 1:4:xtic(2) w l title "mkl16"

40) To create the ifg list file. 
	ls -la data | awk '{if(length($10)>3){print substr($10,10,8), substr($10,1,8), 0, "ALOS"}}'

41) Step function in creating the long term motion.
	grdmath -R000-east.grd X 60 COSD MUL Y 60 SIND MUL SUB STEP 0.025 MUL = test1.grd 
	grdmath -R000-east.grd X 120 COSD MUL Y 120 SIND MUL ADD STEP 0 GT -0.025 MUL = test2.grd
	grdmath test1.grd test2.grd ADD = test.grd

42) Getting the basename
	out=${f[i]%.tif}.grd

43) In vi to match any character use dot -> '.'

44) Showing all the hidden/invisible files in finder 
	defaults write com.apple.finder AppleShowAllFiles -boolean true ; killall Finder
	# hiding back
	defaults write com.apple.finder AppleShowAllFiles -boolean false; killall Finder

45) get geographic bounds of Relax models
grd2xyz ./coseismic/000-east.grd | awk '{printf "%f %f\n", $1*1e3-56748.29,$2*1e3+221910.44}' | invproj +proj=utm +zone=47 -f '%f' | minmax

46) compiling the relax for miracle on komodo. 
    CFLAGS=-fPIC FCFLAGS=-fPIC ./waf configure --gmt-dir=/usr/local/GMT4.5.8/gnu --use-fftw --fftw-dir=/usr/local/fftw-3.3.2/gnu
    LDFLAGS=-L/usr/local/netcdf-3.6.3/gnu/lib CPPFLAGS=-L/usr/local/netcdf-3.6.3/gnu/include CFLAGS=-fPIC FCFLAGS=-fPIC ./waf configure --gmt-dir=/usr/local/GMT4.5.8/gnu --use-fftw --fftw-dir=/usr/local/fftw-3.3.2/gnu

    CFLAGS=-fPIC FCFLAGS=-fPIC ./waf lite
    compiling the relax on komodo. 
    ./waf configure --gmt-dir=/usr/local/GMT4.5.8/gnu --use-fftw --fftw-dir=/usr/local/fftw-3.3.2/gnu
    if we dont use the fftw-dir bydefault its refering to some other and gives the memory allocation error.

47) Pattern matching in the vi.
    %s/\([0-9]\)-/\1 -/gc
    # here we replace any 0-0 with 0 -0 also notice that \([0-9]\) is held in 1
    The same can be done to all the files using the below command
    sed -i 's/\([0-9]\)-/\1 -/g' *.ned
    sed -i 's/\([0-9]\)-/\1 -/g' in.param.000?
    # replacing the . with relax_000? in input file
    for i in in.param.000?; do t=relax_`echo $i | cut -d"." -f 3 `; sed -i "s/^\./$t/g" $i;done

48) renaming the file from the relax.
    for i in *-relax.ned; do mv $(basename $i) $(basename $i .ned).dat; done

49) Searching for a string with grep exact match add ^ ie., cat some.txt | grep "^abc" will give only
    line with abc

50) grep -n "^abc" gives the line number of search. 

51) command sed to print from certain line to certain line: sed -n '84,217p' src/miracle.f90

52) making directories for miracle. 
    for i in {1..30}; do mkdir -p "relax_"`echo $i | awk '{printf "%03.3d", $1}'`;done

53) Miracle models 
    cat in.param | grep in.param | sort | awk 'BEGIN{print "# residual         m1         m2"}{print $2,$3,$4}' > models.txt

54) Printing the last line of relax output or status of miracle.
    for i in relax_*; do printf $i; tail $i/ABGS.ned | sed -n 10p; done
    for i in relax_*; do tail $i/ABGS.ned | sed -n 10p| awk -v n=$i '{if(1.0>$1){print n, $1}}'; done

55) Counting number characters in latex document.
    texcount -char abstract.tex
    For word count:
    texcount abstract.tex

56) Getting best fit before miracle finishes. 
    cat ~/26322.komodo.des.OU | grep in.param | awk '{print $2,$3,$4,$1}' | sort

57) Checking how many nodes are free on komodo.
    qnodes | grep "state = free" | wc

58) Sending message to the other user logged in.
    write username tty

59) Split in awk example.
    for i in *.txt; do echo $i | awk '{split($0,a,"_");print "mv " $0 " "a[1]"-relax.dat"}'; done

60) Opening multiple files each on different process.
    for i in relax_000?; do gv $i/fit.pdf >& /dev/null & done

61) cut with more than one field.
    echo "benchmark_128_1000_1000_1year_prestress" | cut -d"_" --fields=3,4,6

62) login to specific node in komodo.
    qsub -q q24 -l nodes=1:ppn=24,walltime=10:00:00:00 -I

63) getting the data from the -relax.ned file
    for i in *-relax.ned; do tail $i | sed -n 10p | awk '{printf("%12.4e %12.4e %12.4e %12.4e\n",$2,$3,$4,$5);}'; done

64) getting the age for plotting the profile.
    echo ""| awk '{for(x=-1400;x<=1400;x=x+1){print x,0;}}' | grdtrack  -Gage.3.2_km.grd  | grdtrack -Gsum_slab1.0_clip_km.grd | awk '{for(z=0;z<=200;z=z+1){if(substr($4,0,3)!="NaN"){printf("%f %f %f\n",$1,z+$4,$3)}else{printf("%f %f %f\n",$1,z,$3)}}}' > temp.xyz
    xyz2grd temp.xyz -Gprofile.grd -I1/1 -R-1400/1400/0/380
    grdmap.sh -b -1400/1400/0/200 -p 45/100/1 -c seis profile.grd

65) git on komodo if it gives error about the requester URL returned error
    then in .git/config replace url https with following
    ssh://git

66) Opening 10 best models of relax using gv in komodo.
    cat stdout | grep in.param | awk '{print $2,$1}' | sort -g | head | awk '{print "gv relax_"substr($2,10,4)".pdf"}' | sh

67) Cleaning the -relax.ned files on komodo.
    for i in miracle_1*; do for j in $i/relax_*; do rm $j/*-relax.ned;done;done

68) Checking for number of files in a directory.
    find .//. ! -name . -print | grep -c //

69) Display 2 files side by side 
    pr -m -t temp1 temp2

70) Dike input processing 
    cat kc1dz8_drhoNegCG_0086002.dat | awk -v offset=28.2707 '{$1=-$1-offset;print $1,$2}' > input_depth_opening.dat

71) Converting from subflt to flt format of relax.
    grep -v "#" slipmodel.m8.2 | awk '{print $2,$1,$3,$4,$5,$6,$7,$8,$9}' | proj +proj=utm +zone=47 | awk 'BEGIN{print "# nb  slip      x1      x2      x3   length  width strike dip  rake"}{print NR,$3/100,($1+56748.29)/1e3, ($2-221910.44)/1e3,$3,23,5,$7,$8,$6}' > swei+13_aftershock.flt

72) Getting the names from the kml file 
    cat doc.kml | grep name | cut -d'[' -f 3 | cut -d']' -f 1 > names.xy
    
73) Compiling relax on NSCC
    #Configuring with cuda
    ./waf configure --use-fftw  --proj-dir=/home/users/ntu/sagarshr/mysoft/newhome/sagarshr/src/proj/ 
    --gmt-dir=/home/users/ntu/sagarshr/mysoft/newhome/sagarshr/src/gmt/ --use-cuda --cuda-dir=/app/cuda/6.5

    #Normal configuration
    ./waf configure --use-fftw  --proj-dir=/home/ntu/sagarshr/src/proj/
    --gmt-dir=/home/ntu/sagarshr/src/gmt/
    #compiling the library
    CFLAGS=-fPIC FCFLAGS=-fPIC ./waf configure --use-fftw
    --proj-dir=/home/ntu/sagarshr/src/proj/ --gmt-dir=/home/ntu/sagarshr/src/gmt/
    CFLAGS=-fPIC FCFLAGS=-fPIC ./waf lite

######     After the alpha test finished    ################# 
    module load cuda/7.0
    module load fftw/3.3.4/xe_2016/parallel
    CFLAGS=-fPIC FCFLAGS=-fPIC ./waf configure --use-fftw --use-cuda --proj-dir=/home/users/ntu/sagarshr/mysoft/ --relax-lite
    CFLAGS=-fPIC FCFLAGS=-fPIC ./waf lite
# compiling relax-miracle
    module load intelmpi
    make
# interactive job
    qsub -I -q gpu  -l select=1:ncpus=1:ngpus=1

74) For ps_font problem on komodo, do the following:
    export GMT_SHAREDIR=/usr/local/software/GMT4.5.8/share/

75) Converting from pdf to tiff
    gs -o s5_gs.tiff -sDEVICE=tiff24nc -r600x600 -sPAPERSIZE=a4 Figure-S5.pdf
    convert  -density 300x300 Figure-S5.pdf s5.tiff 
    
    reduce the size:
    tiffutil -lzw s5_gs.tiff -out s5_reduced.tiff

76) rename all the files from miracle. ????-relax.ned to ????.ned 
    for i in relax_*; do for j in $i/*.ned; do a=`echo $j | cut -d"-" -f 1`;ext=`echo .ned`; mv $j $a$ext; done;done
    for i in ????-relax.dat; do a=`echo $i | cut -d"-" -f 1`; b=`echo ".dat"`; mv $i $a$b; done

77) Processing the models for copula.
    # copy the model and its output.
    scp -r sagarshr001@komodo.ase.ntu.edu.sg:~/workspace/wharton12/miracle/miracle_16_61 .    
    # remove the coseismic offset
    for i in relax_*; do pushd $i; obsrelax.sh ????.ned; popd; done
    # delete the old files
    for i in relax_*; do pushd $i; rm ????.ned; popd; done 
    # rename ????-relax.ned to ????.ned 
    for i in relax_*; do for j in $i/*.ned; do a=`echo $j | cut -d"-" -f 1`;ext=`echo .ned`; mv $j $a$ext; done;done
    # process the stdout to output the models.
    cat stdout | grep in.param | awk '{print $4,$5,$2}' > models.dat
    
78) Check weather.
    curl http://wttr.in/singapore

79) Mercurial reverting (equivalent to checkout of git) is 
    hg revert filename

80) Converting video to image (tif format)
    ffmpeg -i DSCN8992.MOV -pix_fmt rgb24 -r 1 out%05d.tif

81) Plotting mapview of relax best fit model
    grdmap.sh -g -p -0.03/0.03/0.001 -b 88.2/101/-2/7 -s 1 -v 0.05 -t 5 -c anatolia.cpt -e ./gmt/eslab.sh -e ./gmt/ecoasts.sh -e ./gmt/ewharton.sh -e ./gmt/efaults.sh -e ./gmt/emoment.sh -e ./gmt/egpsdata.sh -i ./gmt/etopo2_ll_3_hs.grd best_2240_4260_miracle_52_122/392-relax_ll-up.grd
