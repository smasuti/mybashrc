#!/usr/bin/env python3
from __future__ import print_function
import math
import sys

def main():
    iIndex = 0
    for line in sys.stdin:
        Coh,z,a,x1,x2,length,width,thick,strike,dip,zs= map(float, line.split())
        n = 1.0
        A = 1e6
        #Coh = 2000 
        r = 1.0
        Ea = 335e3
        p = 3330 * 9.8 * z * 1000
        Va = 4e-6
        R = 8.3144
        G = 30e3
        pp = 3
        d = 10000

        Tm = 1350          # in K ( K = c + 273)
        Rm = 3330              # mantle density        (kg/m^3)
        Cp = 1171              # specific heat         (J/kg/K) 
        k = 3.138

        kappa = k / (Rm * Cp)
        T = (Tm * math.erf ((z-zs) / math.sqrt ( 4 * kappa * a * 3.15e7)))+273

        gamma0=((G**n)*A*(Coh**r)*(d**(-pp))* math.exp (-(Ea + p*Va)/(R*T)))
        if (not math.isnan(gamma0)):
            iIndex+=1
            print("%d %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f" % (iIndex,gamma0,x1,x2,z,length,width,thick,strike,dip))
            #print(x2,z,gamma0)

if __name__ == "__main__":
    main()

