#!/usr/bin/env python3

import numpy as libnp
import scipy
import scipy.interpolate
from scipy.interpolate import griddata
import matplotlib.pyplot as plt
import math
from scipy.interpolate import Rbf

def func(a):
    return libnp.exp(-(a**2)/2)

def main():
    m = libnp.loadtxt ("/Users/smasuti/research/sumatra/wharton12/models/exp512_11.dat")

    x = libnp.arange(min(m[:,2]),max(m[:,2]),0.01)
    y = libnp.arange(min(m[:,3]),max(m[:,3]),0.01)
    
    [xq, yq] = libnp.meshgrid(x, y)
    values = func(m[:,1])
    Vq = (scipy.interpolate.griddata((m[:,2],m[:,3]),values,(xq,yq),method='cubic'))
    print (Vq)
    plt.pcolor(10.**xq, 10.**yq, Vq) 
    #rbf = Rbf(m[:,2], m[:,3], values,function='cubic')
    #Vq=rbf(xq,yq)
    #plt.imshow(Vq,extent=(min(m[:,2]),max(m[:,2]),min(m[:,3]),max(m[:,3]))) 
    #plt.savefig("pythonexp.eps", orientation = 'portrait', format = 'eps') 
    plt.show()

if __name__ == "__main__":
    main()
