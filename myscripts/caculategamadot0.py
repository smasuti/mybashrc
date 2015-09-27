# calcualte gamadot0
# QiuQiang 28/01/2014

from numpy import *
import sys


usage= ''' 
        Two paramters are needed for this
        program. 
        
        V1 : viscosity units in pa.s
        V2 : shear module rigidity G in pa
        
        For example: python caculategamadot0.py 1e19 3e4 
        
        Relaxation time tm -->  10.610330
        gamadot0 = 1./tm   -->  0.094248
        
        '''
try:
    yita = float(sys.argv[1])
    G    = float(sys.argv[2])
except:
    print 'Usage:',sys.argv[0]
    print usage 
    sys.exit(1)


''' do calculation '''
yita = yita/10**6  # change pa.s to Mpa.s
yita = yita/(pi*10**7)  # change to mpa.yr

''' calcualt relaxatim tao '''
#G = 3e4   # Mpa 
tao = yita/G

print 'Relaxation time tm -->  %f' %tao
print 'gamadot0 = 1./tm   -->  %f' %(1./tao)
