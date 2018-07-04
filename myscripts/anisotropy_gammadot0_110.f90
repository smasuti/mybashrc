! --------------------------------------------------------------------------
!> function builddgammadot0
!! This function implements the below equation given the new COH and Vstar 
!! values.
!!                                 _          _
!!                                | - (E + pV) | 
!! gammadot0 = A G^n (fH20^r) exp |------------|
!!                                |_    RT    _|
!
! --------------------------------------------------------------------------
PROGRAM main

    IMPLICIT NONE

    REAL*8, PARAMETER :: Ra = 8.3144
    REAL*8, PARAMETER :: G = 30e3
    REAL*8, PARAMETER :: Tm = 1380.0
    REAL*8, PARAMETER :: rho = 3.3e3
    REAL*8, PARAMETER :: Rm = 3.33e3
    REAL*8, PARAMETER :: Cp = 1.171e3
    REAL*8, PARAMETER :: k = 3.138

      ! Integer variables.
    INTEGER :: iIndex,ndz
    INTEGER :: iunit

      ! Floating variables.
    REAL*8 :: p,kappa,T,gamma0 
    REAL*8 :: ma,r,n,A,ae,vstar
    REAL*8 :: z,corr,d,pp
    REAL*4 :: coh,x1,x2,length,width,thick,strike,dip

    CHARACTER(256) :: dataline
    ! read from the standard input
    iunit=5

    A=10**3.45
    ae=470e3
    vstar=12
    d=2000
    pp=0
    n=3.0
    r=0.4
    corr=3.15e7/((1e3)**(n-1))

    kappa = k / (Rm * Cp)
    
    PRINT '("# number of ductile zones")'
    CALL getdata(iunit,dataline)
    READ  (dataline,*) ndz

    PRINT '("#n gammadot0 depth")'
    DO iIndex=1,ndz
         CALL getdata(iunit,dataline)
         READ  (dataline,*), coh,z,ma,x1,x2,length,width,thick,strike,dip

         p = rho * 9.8 * z * 1000
        
         ! Calculate the temperature.
         T = (Tm * ERF (z / SQRT ( 4 * kappa * ma * 3.15e7)))+273

         ! Calculate gammadot0
         gamma0=corr*(G**n)*A*(d**(-pp))*(coh**r)*EXP(-(ae+(p*vstar*1e-6))/(Ra*T))
         IF (.NOT. ISNAN(gamma0)) THEN
             PRINT '(I5.5,9ES10.2E1)',iIndex,gamma0,x1,x2,z,length,width,thick, &
                                      strike,dip
         END IF
    END DO
END PROGRAM 

subroutine getdata(unit,line)
    implicit none
    integer unit
    character line*256,char*1
    integer i
    char='#'
100 continue
    if(char.eq.'#')then
        read(unit,'(a)')line
        i=1
        char=line(1:1)
200     continue
        if(char.eq.' ')then
            i=i+1
            char=line(i:i)
            goto 200
        endif
        goto 100
    endif
return
end
