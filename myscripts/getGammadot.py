#!/usr/bin/env python3
from __future__ import print_function
import math
import sys

def getInputs():
    fileId = sys.stdin
    line = ''
    for line in fileId:
    # Need to trim here. For removing any spaces at the beginning.
        if ('#' == line[0]):
            continue
        else:
            break
    return line

def main():
    iIndex = 0
    for line in sys.stdin:    
        Coh,z,a,x1,x2,length,width,thick,strike,dip,zs= map(float, line.split()) 
        n = 3.5   
        A = 90  
        #Coh = 2000 
        r = 1.2
        Ea = 480e3 
        p = 3300 * 9.8 * z * 1000 
        Va = 11e-6 
        R = 8.3144 
        G = 30e3 
      
        Tm = 1350          # in K ( K = c + 273)
        Rm = 3300              # mantle density        (kg/m^3)
        Cp = 1171              # specific heat         (J/kg/K) 
        k = 3.138 
        corr=3.14e7/((1e3)**(n-1))

        kappa = k / (Rm * Cp)
        T = (Tm * math.erf ((z-zs) / math.sqrt ( 4 * kappa * a * 3.15e7)))+273 

        gamma0=corr*((G**n)*A*(Coh**r)* math.exp (-(Ea + p*Va)/(R*T)))
        if (not math.isnan(gamma0)): 
            iIndex+=1
            print(iIndex,gamma0,x1,x2,z,length,width,thick,strike,dip)
            #print(x2,z,gamma0)

if __name__ == "__main__":
    main()

