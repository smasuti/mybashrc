
from __future__ import print_function 
# For checking the python version info.
import sys
# Degree to radian and radian to degree.
import math
# For accessing the date class
from datetime import date
from numpy import *
import pylab as plt
from matplotlib import rc, rcParams
import re
def plotstation(sn,Dir,Dird,vis,ls):
    ''' read data '''
    nums = len(sn)
    cm = 100.

    for i in range(nums):
        print ('...... Working on station :  %s ......'%sn[i])
        plt.clf()
        rc('lines',lw=2)
        rcParams['font.size']=12
        
        fig = plt.figure(1,figsize=[18,18],facecolor='w')
        
        ax1 = fig.add_subplot(311)
        plt.ylabel('North(cm)')
        plt.title('Station  ' + sn[i] )
        
        ax2 = fig.add_subplot(312)
        plt.ylabel('East(cm)')
        
        ax3 = fig.add_subplot(313)
        plt.ylabel('Up(cm)')
        plt.xlabel('Year')
        
        visco = [1e18,1e19,1e20,1.5e20]
        refe  = 10./3.*10**19
        scale = array(visco)/refe
        scale = [1.]

        nc = len(vis)
        count = 0
        
        ''' load GIPSY GPS solution '''
        fnd = Dird + sn[i]+'_fillGap2002.txt'
        tempd = loadtxt(fnd) 
     
        deci=doy("2004/12/26")
    
#        for iIndex in range (0,len(tempd[:,0])):
#            tempd[iIndex,0]-=remove
 
        for v,lc in zip(vis,ls):
            
            ''' load relax model prediction '''
            fn = Dir + v+'/'+ sn[i]+'-relax.txt'
            temp = loadtxt(fn)
 
            ''' north '''
            ax1.plot(temp[:,0]+deci,cm*temp[:,1],lc,label='model')
            ax1.plot(tempd[:,0],tempd[:,2],'r.')
            
            ''' east '''
            
            ax2.plot(temp[:,0]+deci,cm*temp[:,2],lc,label='model')
            ax2.plot(tempd[:,0],tempd[:,1],'r.')
            
            ''' up '''
            ax3.plot(temp[:,0]+deci,-cm*temp[:,3],lc,label='model')
            ax3.plot(tempd[:,0], tempd[:,3],'r.')
            
            count +=1
            
        plt.legend(bbox_to_anchor=(1.05, 1), loc=0,borderaxespad=0.)    
        
        
        plt.savefig(Dir +'plots/'+ sn[i]+'.pdf',dpi=100)

def doy(cDate):
# The following can be done manually also. But using the built-in modules 
    try:
        (cyy,cmm,cdd) = re.split ('\D+', cDate, maxsplit=2)
        yy = int (cyy)
        mm = int (cmm)
        dd = int (cdd)
        day = date(yy,mm,dd).timetuple().tm_yday
        print ('Day of the year is: ', day)
        fDay = float (day)
        if ((((yy/4) == 0) and ((yy/100) != 0)) or ((yy/400) == 0)):
            fDec = float (yy) + float(fDay/366)
        else:
            fDec = float(yy) + float(fDay/365)    
    except ValueError:
        print ('\nInvalid input. Please enter a proper date')
        print ('Correct example would be something like 2014 02 02 or 2014-02-01\n')
    
    print ("decimal year : ", fDec) 
    return fDec


if __name__ == '__main__':
    #sta = ['UMLH','BITI','BNON','BSIM','BTHL','HNKO','LEWK','LHW2','PBLI']
    sta=['UMLH']
    #Dir = '/Users/qiangqiu/Desktop/relax/relaxApril2012/offsumatra12/'
    Dir = '/Users/smasuti/relaxation/'
    Dird = '/Users/smasuti/relaxation/gps/PCAIM_formatFilledgap/'
    visco = ['viscoelastic85_0_2']
#    visco = ['viscoelastic40_2', 'viscoelastic40_3']
    lico  = ['b-','k-','g-','m-','r','y']
    plotstation(sta,Dir,Dird,visco,lico)
