      SUBROUTINE YVSLF2(NBU,UL,UH,U,EU,NBV,VL,VH,V,EV,SGMX,VLF)
CKEY  QVSRCH / INTERNAL
C ------------------------------------------------------------------------------
C! Adds track (point) to 2-dimension log-likelihood distribution vlf.
C     SPECIALIZED FOR PRIMARY VERTEX IN A PLANE
C  Author : T. MATTISON  U.A.BARCELONA/SLAC  1 DECEMBER 1992
C
C  Input Arguments :
C  *  NBU,UL,UH ARE NUMBER OF BINS, LOW AND HIGH LIMITS
C       FOR FIRST VARIABLE
C  *  NBV,VL,VH ARE SAME FOR SECOND VARIABLE
C  *  U,EU ARE VALUE AND SIGMA OF BEAM IMPACT POINT
C  *  V,EV ARE SAME IN SECOND VARIABLE
C  *  SGMX IS HOW MANY SIGMAS THE DISTRIBUTION REMAINS GAUSSIAN
C  *  VLF(NBU*NBV+NBU+NBV) IS ARRAY CONTAINING LOG-LIKELIHOOD FUNCTION
C        AND SOME SCRATCH SPACE AT THE END
C  Output Arguments :
C  *  ALTERS VLF()
C
C ------------------------------------------------------------------------------
#ifndef DOC
      DIMENSION VLF(*)
C ------------------------------------------------------------------------------
C FIND BIN WIDTHS
      BWU=(UH-UL)/NBU
      BWV=(VH-VL)/NBV
C OFFSETS FOR SCRATCH ARRAYS
      IOFU=NBU*NBV
      IOFV=IOFU+NBU
C
C FILL SCRATCH ARRAY WITH U LIKELIHOOD
C INVERSE ERROR**2
      REU=1./EU
C LOOP OVER U BINS
      BCU=UL-.5*BWU
      DO 150 IBU=1,NBU
        BCU=BCU+BWU
C GAUSSIAN LOG-LIKELIHOOD
        GSN=-.5*((U-BCU)*REU)**2
        VLF(IOFU+IBU)=GSN
  150 CONTINUE
C FILL SCRATCH ARRAY WITH V LIKELIHOOD
C INVERSE ERROR**2
      REV=1./EV
C LOOP OVER V BINS
      BCV=VL-.5*BWV
      DO 250 IBV=1,NBV
        BCV=BCV+BWV
C GAUSSIAN LOG-LIKELIHOOD
        GSN=-.5*((V-BCV)*REV)**2
        VLF(IOFV+IBV)=GSN
  250 CONTINUE
C
C FIND LIMITING LOG-LIKELIHOOD VALUE
      GMN=-.5*SGMX**2
C CLEAR BIN COUNTER
      IB=0
C LOOP OVER V BINS
      DO 450 IBV=1,NBV
C LOOP OVER U BINS
        DO 350 IBU=1,NBU
C INCREMENT BIN COUNTER
          IB=IB+1
C INCREMENT WITH LARGER OF SCRATCH SUM AND LIMITING VALUE
          VLF(IB)=VLF(IB)+MAX(GMN,VLF(IOFU+IBU)+VLF(IOFV+IBV))
  350   CONTINUE
  450 CONTINUE
      RETURN
      END
#endif
