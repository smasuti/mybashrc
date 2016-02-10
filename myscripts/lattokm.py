#!/usr/bin/env python

"""
Usage:
    lattokm.py [options]

Options:
    --lat=<val>     The latitude.
    --lon=<val>     The longitude.

"""

from docopt import docopt
import os
import subprocess

def main():
    arguments = docopt(__doc__, version='1.0')
    lat = arguments['--lat']
    lon = arguments['--lon']
    comString = "echo " + lon + " " + lat + "| proj +proj=utm +zone=47"
    print (comString)
    f = os.popen(comString)
    east,north = f.read().split("\t")
    ceast=float(east)
    cnorth=float(north)
    print (ceast, cnorth)
    ceast=(ceast+56748.29)/1000
    cnorth=(cnorth-221910.44)/1000
    print("Final: ", ceast, cnorth)

if __name__ == "__main__":
    main()
