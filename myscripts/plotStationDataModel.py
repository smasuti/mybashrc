#!/usr/bin/env python

"""
Usage:
    plotdisp.py [options]

Options:
    --lat=<val>     The latitude.
    --lon=<val>     The longitude.

Author : 
   Original : Qiang Qiu 
   Date : 16 Jan 2014

   Modified : Sagar Masuti.
   Date : 15 Jul 2014
 
"""

#from docopt import docopt
from numpy import * 
import pylab as plt
import matplotlib.ticker as tker
import matplotlib.gridspec as grdspc
import os

#dataDir = ''
#plots = dataDir+'datamodelPlots/'
def main ():
#    arguments = docopt(__doc__, version='1.0')
    dataDir = '/Users/smasuti/relaxation/viscoelastic40_1/'
    plots = dataDir+'plots/'
    if os.path.isdir(plots): 
        print '%s exists'%plots
    else:
        os.mkdir(plots)


    gpslist0 = ['LEWK','BSIM','PBLI','LHWA','BTHL','BITI','PSMK','PTLO','ABGS','PBJO',\
            'SMGY','BSAT','MKMK','PRKB','PPNJ','PSKI','SLBU',\
            'JMBI','LAIS','LNNG','MLKN','MNNA','MSAI','NGNG','TIKU','BTET',\
            'UMLH']
#gpslist=['LEWK']
    gpslist = ['LEWK','BSIM','PBLI','LHWA','BTHL','BITI','PSMK','PTLO',\
           'BSAT','MKMK','PSKI',\
           'LNNG','NGNG','TIKU',\
           'UMLH']

    index = []

    for n in range(len(gpslist)):
        m = 0
        while gpslist0[m]!=gpslist[n]:
            m +=1
        index.append(m)





    model  = loadtxt(dataDir+'modelStation_time.txt')
    data = loadtxt(dataDir+'dataStation_time.txt')


    ts = 2005.110959
    te = ts+365*7.79*0.00274
    tstep = 0.00274
    timsample = arange(ts,te,tstep)
    cm=100.


    formatter = tker.FormatStrFormatter('%04d')
    mkers = 6
    lwd   = 2.5
    offset=0

    fig=plt.figure(1,figsize=[12,8],facecolor='w',dpi=120)
    gs = grdspc.GridSpec(1,3)
    ax1=plt.subplot(gs[0,0])
    ax2=plt.subplot(gs[0,1])
    ax3=plt.subplot(gs[0,2])


    nn = 0
    for st in index:
        #plt.clf()
        #plt.close('all')
        
        """
        
        fig=plt.figure(i,figsize=[6,4.5],facecolor='w',dpi=120)
        gs = grdspc.GridSpec(3,1)
        gs.update(hspace=0.25)
        
        ''' east '''
        ax1=plt.subplot(gs[0,0])
        ax1.plot(timsample[:-1],cm*data[:,st*3],'go',ms=mkers,label='Data')
        ax1.plot(timsample[:-1],cm*model[:,st*3],'r-',lw=lwd,label='Model')
        ax1.xaxis.set_major_formatter(formatter)
        for tick in ax1.xaxis.get_major_ticks():
            tick.label1On = False
        ax1.legend(loc=0)
        plt.title(gpslist[st])


        
        ''' north '''
        ax2=plt.subplot(gs[1,0])
        ax2.plot(timsample[:-1],cm*data[:,st*3+1],'go',ms=mkers)
        ax2.plot(timsample[:-1],cm*model[:,st*3+1],'r-',lw=lwd)
        ax2.xaxis.set_major_formatter(formatter)
        for tick in ax2.xaxis.get_major_ticks():
            tick.label1On = False
        ax2.set_ylabel('Elevation (cm)')
        ''' up '''
        ax3=plt.subplot(gs[2,0])
        ax3.plot(timsample[:-1],cm*data[:,st*3+2],'go',ms=mkers)
        ax3.plot(timsample[:-1],cm*model[:,st*3+2],'r-',lw=lwd)
        ax3.xaxis.set_major_formatter(formatter)
        ax3.set_xlabel('Year')
        savefig(plots+gpslist[st]+'_MD.pdf',dpi=120)
        plt.show()

        """

        #gs.update(vspace=0.25)
        
        ''' east '''
        if st==index[-1]:
            ax1.plot(timsample[:-1],cm*data[:,st*3]+offset,'go',ms=mkers,label='Data')
            ax1.plot(timsample[:-1],cm*model[:,st*3]+offset,'r-',lw=lwd,label='Model')
        else:
            ax1.plot(timsample[:-1],cm*data[:,st*3]+offset,'go',ms=mkers)
            ax1.plot(timsample[:-1],cm*model[:,st*3]+offset,'r-',lw=lwd)
        ax1.text(2003+0.25,cm*data[0,st*3]+offset,gpslist[nn])
        
        
        ''' north '''
        
        ax2.plot(timsample[:-1],cm*data[:,st*3+1]+offset,'go',ms=mkers)
        ax2.plot(timsample[:-1],cm*model[:,st*3+1]+offset,'r-',lw=lwd)
        ax2.text(2003+0.25,cm*data[0,st*3+1]+offset,gpslist[nn])

        ''' up '''
        
        ax3.plot(timsample[:-1],cm*data[:,st*3+2]+offset,'go',ms=mkers)
        ax3.plot(timsample[:-1],cm*model[:,st*3+2]+offset,'r-',lw=lwd)
        ax3.text(2003+0.25,cm*data[0,st*3+2]+offset,gpslist[nn])

        offset +=20
        nn +=1



    ax1.xaxis.set_major_formatter(formatter)
    ax1.set_ylabel('Elevation (cm)')
    ax1.set_xlim(2003,2013)
    ax1.set_title('East')

    ax2.xaxis.set_major_formatter(formatter)
    ax2.set_xlabel('Year')
    ax2.set_xlim(2003,2013)
    ax2.set_title('North')
    ax3.xaxis.set_major_formatter(formatter)
    ax3.set_title('Up')
    ax3.set_xlim(2003,2013)
    ax1.legend(loc=0)
    plt.savefig(plots+gpslist[0]+'_MD.eps',dpi=120)
    plt.show()



    print 'Work is done!'
    
if __name__ == "__main__":
    main() 
