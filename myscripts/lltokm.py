#!/usr/bin/env python

import numpy as np


data = np.loadtxt("/Users/smasuti/src/geodynamics/relax/examples/sumatra/wharton12/faults/Megathrust_Aprilcurve_HSuShortM30W170kmDepLonger.flt")
data1=np.loadtxt("/Users/smasuti/src/geodynamics/relax/examples/sumatra/wharton12/faults/utm.txt")

print ("# n   x1       x2     x3 length width   strike dip rake")
for iIndex in range(0,len(data[:,0])):
    print (str(int(data[iIndex,0])).zfill(3), "%.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f" % ((data1[iIndex, 0]+56748.29)/1000, (data1[iIndex,1]-221910.44)/1000,data[iIndex, 4], data[iIndex, 5], data[iIndex,6], data[iIndex,7], data[iIndex,8], data[iIndex, 9]))
