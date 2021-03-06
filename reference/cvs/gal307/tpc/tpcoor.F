*DK tpcoor
      SUBROUTINE TPCOOR
C -------------------------------------------------------------------
C! - M.Mermikides -  860202                     F.Ranjard - 861002
C! - Simulate TPC pad hit coordinates from intersections
C!   using simple error parametrisation.
C.   The purpose of this routine is to provide input for the track
C    reconstruction in the absence of pad digitisations.
C
C    input : NATHT  name-index of the hit bank TPHT
C    output: Banks TPCO, TPCH, TCRL
C
C ----------------------------------------------------------------------
#ifndef DOC
      SAVE
C
#include "bcs.h"
#include "tpgpar.h"
#include "tpgeom.h"
#include "tpgeop.h"
#include "tpnamc.h"
#include "tjjpar.h"
C
C  Resolution parametrisation
C
C  SIGMA(r-phi)**2 = S0P**2 + SMU**2*(TAN(BETA))**2
C  SIGMA(z)**2     = S0Z**2 + SDZ**2*(DriftLength) + SDA**2*COS(THETA)**2
C
      COMMON /TPCERR/S0P,S0P2,SMU,SMU2,S0Z,S0Z2,SDZ,SDZ2,SDA,SDA2
C
      LOGICAL FIRST
      DATA FIRST/.TRUE./
C  Two-track resolution
      PARAMETER (WSEP = 1.8, ZSEP = 2.0)
C
      PARAMETER (LTEMPW=7)
      PARAMETER (LTPCHW=1)
#include "bmacro.h"
C
C ----------------------------------------------------------------------
C
C  Check that we have a hit bank
C
      JTPHT = IW(NATPHT)
      IF (JTPHT.EQ.0) GO TO 999
C
      NHITS = LROWS (JTPHT)
      IF (NHITS.EQ.0) GO TO 999
C
C Fill in the error parameters once
C
      IF (FIRST) THEN
         FIRST = .FALSE.
         KFATE = NLINK('FATE',0)
         IF (KFATE.GT.0) THEN
            TPCERP = RW(KFATE+1)
            TPCERM = RW(KFATE+2)
            TPCERZ = RW(KFATE+3)
            TPCERL = RW(KFATE+4)
            TPCERA = RW(KFATE+5)
         ELSEIF (KFATE.LE.0) THEN
            TPCERP = 1.
            TPCERM = 1.
            TPCERZ = 1.
            TPCERL = 1.
            TPCERA = 1.
         ENDIF
         S0P = TPCERP*0.016
         SMU = TPCERM*0.21
         S0Z = TPCERZ*0.10
         SDZ = TPCERL*0.0025
         SDA = TPCERA*0.25
         S0P2 = S0P*S0P
         SMU2 = SMU*SMU
         S0Z2 = S0Z*S0Z
         SDZ2 = SDZ*SDZ
         SDA2 = SDA*SDA
      ENDIF
C
C  Create work bank to store coordinates initially.
C  These will finally be transferred to the TPCO bank after
C  deletion of the overlapping hits.
C
      JDTWRK = 0
      IW(1)=1
      NDATA = NHITS*LTEMPW + LMHLEN
      CALL WBANK(IW,JDTWRK,NDATA,*860)
      IW(JDTWRK + LMHCOL) = LTEMPW
      IW(JDTWRK + LMHROW) = 0
      IW(JDTWRK-3) = INTCHA ('TPCO')
C
      NC = 0
      DO 170 IH = 1,NHITS
         KTPHT = KROW (JTPHT,IH)
         IROW = IW(KTPHT + 2)/100000
         RAD = TPPROW(IROW)
         ISLOT = MOD(IW(KTPHT + 2)/1000,100)
         ITYP = ITPTYP(ISLOT)
         ISEC = ITPSEC(ISLOT)
         IRS = IROW
         IF(ITYP.GT.1) IRS = IROW - NTPDRW(1)
C  Get error in phi and z
         TANB = RAD*RW(KTPHT + 5)
         COST = RW(KTPHT + 6)
         SIGW2 = S0P2 + SMU2*TANB**2
         SIGZ2 = S0Z2+(ZTPCMX-ABS(RW(KTPHT+4)))*SDZ2+COST**2*SDA2
         CALL RANNOR(RN1,RN2)
         PHI = RW(KTPHT + 3) + SQRT(SIGW2)*RN1/RAD
         Z   = RW(KTPHT + 4) + SQRT(SIGZ2)*RN2
C  Check acceptance after we smear the hit
         PHIS = TPHDIF(PHI,TPPHI0(ISLOT))
         IF(ABS(PHIS).GT.TPDPHW(IRS,ITYP)) GO TO 170
         IF(ABS(Z).GT.ZTPCMX)  GO TO 170
         IPAD = (TPDPHW(IRS,ITYP)-PHIS)/TPDPHS(IRS,ITYP) + 1
         NC = NC + 1
         KWRK = KROW (JDTWRK,NC)
         IW(KWRK + JTPCIN) = IROW*100000 + ISLOT*1000 + IPAD
         RW(KWRK + JTPCRV) = RAD
         RW(KWRK + JTPCPH) = PHI
         RW(KWRK + JTPCZV) = Z
         RW(KWRK + JTPCSR) = SIGW2
         RW(KWRK + JTPCSZ) = SIGZ2
         IW(KWRK + 7) = IH
C
  170 CONTINUE
      IW(JDTWRK + LMHROW) = NC
C
C++   Look for neighbouring coordinates
C
      I=0
  200 I=I+1
      IF(I.GE.NC) GO TO 500
      IC1 = IW(KROW(JDTWRK,I)+JTPCIN)
      IRS1 = IC1/1000
C
      II = I
  205 II = II + 1
      IC2 = IW(KROW(JDTWRK,II)+JTPCIN)
      IRS2 = IC2/1000
C
      IF(IRS2.NE.IRS1) THEN
         IF(II.EQ.I+1)  I = II - 1
         GO TO 200
      ENDIF
C
C++   We now have hits on same row and sector.
C++   Compare r-phi positions
C
      RAD = RW(KROW(JDTWRK,I) + JTPCRV)
      PHI1= RW(KROW(JDTWRK,I) + JTPCPH)
      PHI2= RW(KROW(JDTWRK,II) + JTPCPH)
      IF (RAD*ABS(PHI2-PHI1).GT.WSEP) GO TO 205
C
C++   Compare z-coordinates
C
      Z1 = RW(KROW(JDTWRK,I)+JTPCZV)
      Z2 = RW(KROW(JDTWRK,II)+JTPCZV)
      IF (ABS(Z2-Z1).GT.ZSEP) GO TO 205
C
C 50% of time kill both hits, 50% make one averaged hit
C
      IF (RNDM(IDUM).GT..5) THEN
         IW(KROW(JDTWRK,I)+7) = 0
         IW(KROW(JDTWRK,II)+7) = 0
      ELSE
         RW(KROW(JDTWRK,I) + JTPCPH) = (PHI1+PHI2)/2.
         RW(KROW(JDTWRK,I)+JTPCZV)  = (Z1+Z2)/2.
         IW(KROW(JDTWRK,II)+7) = 0
      ENDIF
      GO TO 205
C
C++   Create TPCO, TPCH, TCRL banks
C
  500 NDATA = NC*LTPCOA + LMHLEN
      IW(1)=1
      CALL ALBOS('TPCO', 0,NDATA,JTPCO,IGACO)
      CALL BLIST(IW,'E+','TPCO')
      IW(JTPCO + LMHCOL) = LTPCOA
      IW(JTPCO + LMHROW) = 0
C
      NDATA = NC*LTPCHW + LMHLEN
      CALL ALBOS('TPCH',0,NDATA,JTPCH,IGACH)
      CALL BLIST(IW,'E+','TPCH')
      IW(JTPCH + LMHCOL) = LTPCHW
      IW(JTPCH + LMHROW) = 0
C
      NDATA = LTPDRO*LTCRLA + LMHLEN
      CALL ALBOS('TCRL',0,NDATA,JTCRL,IGARL)
      CALL BLIST(IW,'E+','TCRL')
      IF (IGACO+IGACH+IGARL.NE.0) THEN
         JTPCO = IW(NATPCO)
         JTPCH = IW(NATPCH)
      ENDIF
      IW(JTCRL+LMHCOL)=LTCRLA
      IW(JTCRL+LMHROW)=LTPDRO
C
C++   Transfer coordinates to TPCO bank and fill row list and hit
C++   reference banks
C
      IROLD=-1
      IC = 0
      DO 600 I=1,NC
         KWRK = KROW (JDTWRK,I)
C  Skip deleted hits
         IF(IW(KWRK+7).EQ.0) GO TO 600
C
         IRS  = IW(KWRK+JTPCIN)/1000
         IROW = IRS/100
         ISLOT = MOD(IRS,100)
         IC = IC + 1
         KTPCO = KROW (JTPCO,IC)
         IW(KTPCO+JTPCIN) = IW(KWRK+JTPCIN)
         RW(KTPCO+JTPCRV) = RW(KWRK+JTPCRV)
         RW(KTPCO+JTPCPH) = RW(KWRK+JTPCPH)
         RW(KTPCO+JTPCZV) = RW(KWRK+JTPCZV)
         RW(KTPCO+JTPCSR) = RW(KWRK+JTPCSR)
         RW(KTPCO+JTPCSZ) = RW(KWRK+JTPCSZ)
         IW(KTPCO+JTPCOF) = 5
         IW(KTPCO+JTPCTN) = 0
         IW(KTPCO+JTPCCN) = 0
         IW(KTPCO+JTPCIT) = 0
         RW(KTPCO+JTPCRR) = 0.
         RW(KTPCO+JTPCRZ) = 0.
C
         KTCRL = KROW (JTCRL,IROW)
         IF (IROW.NE.IROLD) THEN
            IROLD=IROW
            IW(KTCRL+JTCROC)=IC-1
         ENDIF
         IW(KTCRL+JTCRNC)=IW(KTCRL+JTCRNC)+1
         IF (IENDTP(ISLOT).EQ.2) THEN
            IW(KTCRL+JTCRN1) = IW (KTCRL+JTCRN1) + 1
         ENDIF
C
C++     Update reference bank
C
         IW(KROW(JTPCH,IC) + 1) = IW(KWRK+7)
         IW(JTPCH + LMHROW) = IW(JTPCH + LMHROW) + 1
         IW(JTPCO + LMHROW) = IW(JTPCO + LMHROW) + 1
C
  600 CONTINUE
C
C    Now drop work bank
C
      CALL WDROP(IW,JDTWRK)
C
      GO TO 999
C
  860 CALL ALTELL(' ++TPCOOR Error lifting work bank',
     &               0,'NEXT')
  999 CONTINUE
      RETURN
      END
#endif
