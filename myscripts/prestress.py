#!/usr/bin/env python3
from __future__ import print_function
import math
import numpy
import sys

def main():
    iIndex = 0
    for line in sys.stdin:    
        index,z,ncoh,vstar= map(float, line.split()) 
        a = 59
        n = 3.5
        A = 10**0.56 
        r = 1.2
        Ea = 418.5e3 
        p = 3330 * 9.8 * z * 1000 
        R = 8.3144 
        G = 30e3 
      
        Tm = 1380              # in K ( K = c + 273)
        Rm = 3330              # mantle density        (kg/m^3)
        Cp = 1171              # specific heat         (J/kg/K) 
        k = 3.138 
        DEG2RAD = 0.01745329251994329547437168059786927
        theta=(-27*DEG2RAD)
        thetasub=(10*DEG2RAD)
        p11=math.cos(theta)**2-math.sin(theta)**2
        p22=math.sin(theta)**2-math.cos(theta)**2
        p12=math.sin(2*theta) 
        p13=math.cos(thetasub)
        p23=math.sin(thetasub)
        t=numpy.zeros(6);
        Rtsub=numpy.zeros(6);
        t[0]=p11;t[1]=p12;t[3]=p22
        Rtsub[2]=p13;Rtsub[4]=p23
        Rt=(1/math.sqrt(2.0))*t 
        
        kappa = k / (Rm * Cp)
        T = (Tm * math.erf ((z) / math.sqrt ( 4 * kappa * a * 3.15e7)))+273 

        epsilondot = 1e-17
        epsilondotsub = 1e-17

        tau = ((epsilondot/(A*(ncoh**r)))*math.exp((Ea+p*vstar*1e-6)/(R*T)))**(1.0/n)
        tausub = ((epsilondotsub/(A*(ncoh**r)))*math.exp((Ea+p*vstar*1e-6)/(R*T)))**(1.0/n)
        ntau = min(tau, (0.6*p)/1e6)
        sigma = ntau * Rt
        ntau = min(tausub, (0.6*p)/1e6)
        sigmasub= ntau * Rtsub 

        pre=sigma + sigmasub
        print ("%d %f %.2e %.2e %.2e %.2e %.2e %.2e" % (index,z,pre[0],pre[1],pre[2],pre[3],pre[4],pre[5]))

if __name__ == "__main__":
    main()
