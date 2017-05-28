#!/usr/bin/env python3
from __future__ import print_function
import math
import sys

def main():
    iIndex = 0
    for line in sys.stdin:
        Coh,vstar,Tm,z,a,x1,x2,length,width,thick,strike,dip,zs= map(float, line.split())
        n = 3.5
        A = 10**0.56
        r = 1.2
        Ea = 418.5e3
        p = 3330 * 9.8 * z * 1000
        R = 8.3144
        G = 30e3

        Rm = 3330              # mantle density        (kg/m^3)
        Cp = 1171              # specific heat         (J/kg/K) 
        k = 3.138
        corr=3.15e7/((1e3)**(n-1))

        kappa = k / (Rm * Cp)

        gamma0=corr*((G**n)*A*(Coh**r)* math.exp (-(Ea + p*vstar*1e-6)/(R*T)))* \
               (math.exp(3330*9.8*132e3*(vstar*1e-6-11e-6)/(R*T)))
        if (not math.isnan(gamma0)):
            iIndex+=1
            print(iIndex,gamma0,x1,x2,z,length,width,thick,strike,dip)
            #print(x2,z,gamma0)

if __name__ == "__main__":
    main()

