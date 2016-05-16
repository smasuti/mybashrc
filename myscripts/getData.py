#!/usr/bin/env python

from __future__ import print_function
import math
import sys
import numpy as np
from os.path import exists
'''
This script gets the data from particular station at time epoch
given in item.

Usage :
1) cat sugar_km.dat | awk '{print substr($2,0,4)".dat"}' | getData.py
or
2) echo "BSIM.dat" | getData.py
'''
def main():
    item=1.0+(2/365)
    print ("#gps       u1        u2        u3        s1       s2      s3")
    for f in sys.stdin:
    #f = sys.stdin.readline()
        if exists(f.rstrip('\n')):
            data = np.loadtxt(f.rstrip('\n'))
            for i in range(0,len(data[:,0])):
                if (data[i,0] > item):
                    print (f.rstrip('\n').split('.')[0], data[i,1],data[i,2],data[i,3],data[i,4],data[i,5],data[i,6])
                    break

if __name__ == "__main__":
    main()
