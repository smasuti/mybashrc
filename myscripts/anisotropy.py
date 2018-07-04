#!/usr/bin/env python3
from __future__ import print_function
import math
import sys

def main():
    iIndex = 0
    for line in sys.stdin:
        Coh,z,a,x1,x2,length,width,thick,strike,dip,zs,sc= map(float, line.split())
        n = 3.0
        A = 10**3.45
        r = 0.4
        Ea = 470e3
        Va = 12e-6
        pp = 0
        corr=3.15e7/((1e3)**(n-1))

        d = 6000
        p = 3300 * 9.8 * z * 1000
        R = 8.3144
        G = 30e3
        Tm = 1380 # in K ( K = c + 273)
        Rm = 3300              # mantle density        (kg/m^3)
        Cp = 1171              # specific heat         (J/kg/K) 
        k = 3.138

        kappa = k / (Rm * Cp)
        T = (Tm * math.erf ((z-zs) / math.sqrt ( 4 * kappa * a * 3.15e7)))+273

        gamma0=sc*corr*((G**n)*A*(Coh**r)*(d**pp)*math.exp (-(Ea + p*Va)/(R*T)))
        if (not math.isnan(gamma0)):
            iIndex+=1
            print(iIndex,gamma0,x1,x2,z,length,width,thick,strike,dip)
            #print(x2,z,gamma0)

if __name__ == "__main__":
    main()

