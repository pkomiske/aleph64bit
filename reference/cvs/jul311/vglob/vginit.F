      SUBROUTINE VGINIT
C-------------------------------------------------------------
C! Initialize variables for VDET global pattern recognition
CKEY VGLOB 
C
C  Author      : Paul Rensing 6-2-95
C
C  Modified    : Dave Casper 17-4-97  Initialize VGLB from database
C
C
C  INPUTS:  
C    Bank VGLB from dbase or cards
C              
C  OUTPUTS: 
C    Common block VGLBCM is initialized.
C
C-------------------------------------------------------------
#ifndef DOC
      IMPLICIT NONE
C
#include "bcs.h"
#include "vglbcm.h"
#include "vglbst.h"
C
#include "vglbjj.h"
C
      integer NAMIND, ALGTDB, GTSTUP, JUNIDB
      external NAMIND, ALGTDB, GTSTUP, JUNIDB
C
      INTEGER NamVGLB, IndVGLB, I
      INTEGER IRUN, IROLD, IEVT, ITP, IRET
      CHARACTER*2 DET
      CHARACTER*4 LIST
C
      SAVE NamVGLB
C
#include "bmacrod.h"
C
      DATA NamVGLB/0/
      DATA IROLD/0/
      DATA DET/'VD'/
      DATA LIST/'VGLB'/
C
#include "bmacro.h"
C
      IF (NamVGLB .eq. 0) THEN
        NamVGLB = NAMIND('VGLB')
C
C initialize the statistics common
C
        NEvtVD = 0
        TimTot = 0.0
        TimHit = 0.0
        TimKal = 0.0
        TimSol = 0.0
        Do I = 1, NVIEW
         NHitVD(I) = 0
         NHitAs(I) = 0
         NHitDb(I) = 0
        End Do
      ENDIF
C
C Get VGLB from database (or cards) if possible
C
#include "gtdbbk.h"
C
      if (iret.lt.0) then
C
C Bank was (re-)loaded
C
         IndVGLB = IW(NamVGLB)
         NSIGRD = RTABL(indVGLB,1,JVGLNS)
         MINERR = RTABL(indVGLB,1,JVGLME)
         PHNOMI = RTABL(indVGLB,1,JVGLPN)
         PHTHRN = RTABL(indVGLB,1,JVGLPT)
         PHDIFF2V = RTABL(indVGLB,1,JVGLP2)
         CHINUL = RTABL(indVGLB,1,JVGLNP)
         ONEDPEN = RTABL(indVGLB,1,JVGLOP)
         MAXCHIK = RTABL(indVGLB,1,JVGLMK)
         MAXBRTSZ = ITABL(indVGLB,1,JVGLBS)
         FINALPRB = RTABL(indVGLB,1,JVGLMF)
         if (ITABL(indVGLB,1,JVGLUI) .eq. 1) then
            USEITC = .true.
         else
            USEITC = .false.
         end if
         MOMCUT = RTABL(indVGLB,1,JVGLFC)
         if (ITABL(indVGLB,1,JVGLPS) .eq. 1) then
            PckSln = .TRUE.
         else
            PckSln = .FALSE.
         end if
         if (ITABL(indVGLB,1,JVGLPK) .eq. 1) then
            PckTrk = .TRUE.
         else
            PckTrk = .FALSE.
         end if
         write(iw(6),*) 'VGLOB - Initialization from bank VGLB'
      else if (iret.eq.0) then
C
C  No bank found - use defaults
C
         NSIGRD = 5.0
         MINERR = 0.0012
         if (IW(NAMIND('KINE')) .eq. 0) then
            PHNOMI = 460.0
         else
C taken from analysis of    VDXY,VDZT PH
            PHNOMI = 540.0
         end if
         PHTHRN = 1.8
         PHDIFF2V = 0.7
         CHINUL = 11.0
         ONEDPEN = 4.0
         MAXCHIK = 30.0
         MAXBRTSZ = 100000
         FINALPRB = 5.0
         USEITC = .TRUE.
         MOMCUT = 3.0
         PCKSLN = .TRUE.
         PCKTRK = .TRUE.
         write(iw(6),*) 'VGLOB - WARNING: default initialization'
      ELSE
C
C Existing bank still valid - bail out
C
         RETURN
      ENDIF
C
      write(iw(6),*) 'NSigmaRoad = ', NSIGRD
      write(iw(6),*) 'MinError = ',MINERR,' PhNominal = ',PHNOMI
      write(iw(6),*) 'PhThreshold = ',PHTHRN,
     $                      ' Phdiff2View = ',PHDIFF2V
      write(iw(6),*) 'NullPen = ',CHINUL,' OnedPen = ',ONEDPEN
      write(iw(6),*) 'MaxchiK = ',MAXCHIK,' maxBrutSz =',MAXBRTSZ
      write(iw(6),*) 'MaxchiF = ',FINALPRB,' UseItc = ',USEITC
      write(iw(6),*) 'FootCut = ',MOMCUT
      write(iw(6),*) 'PcktrK = ',PCKTRK, ' PckSln = ',PCKSLN 
C
      RETURN
      END
#endif
