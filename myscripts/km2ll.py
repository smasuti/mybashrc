#!/usr/bin/env python

"""
Usage:
    km2ll.py [options]

Options:
    --y=<val>     The y.
    --x=<val>     The x.

"""

from docopt import docopt
import os
import subprocess

def main():
    arguments = docopt(__doc__, version='1.0')
    y = arguments['--y']
    x = arguments['--x']
    y = (float (y) * 1e3) - 56748.29
    x = (float (x) * 1e3) + 221910.44
    comString = "echo " + str(y) + " " + str(x) + "| invproj +proj=utm +zone=47 -f \"%f\" "
    print (comString)  
    f = os.popen(comString)
    lon,lat = f.read().split("\t")
    print("Final: ", lon, lat)

if __name__ == "__main__":
    main()
