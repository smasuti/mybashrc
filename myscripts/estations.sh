#!/bin/bash

#
#   seismicity.sh -a estations.sh 
#
eval "$(docopts -V - -h - : "$@" <<EOF
Usage: estations.sh [options]

      -r, --region=<REG>          The region of the seismicity. 
      -J,                         The projection.
      -o, --output=<file>         The output filename.
      --help                      Show help options.
      --version                   Print program version.

Description:
     This script adds seismic stations to the seismicity plot. 

Examples:
    seismicity.sh -r 118/123/21/27 -s 2017-02-16 -e 2017-02-17 -a estations.sh
----
estations 1.0
opyright (C) 2015 Sagar Masuti
Author: Sagar Masuti 
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
EOF
)"

grep -v "#" ./broadband_stations.dat | awk '{print $4,$3}' | psxy -O -K -J -R$region -P -m \
      -W0.5p/10/10/10 -St0.25c -G204/0/0  >> $output
