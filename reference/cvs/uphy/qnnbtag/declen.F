***************************************************************
      SUBROUTINE DECLEN(ICH,DCM,PCM)
***************************************************************
#include "qcde.h"
      REAL DCM,PCM(4),DIST(3)
#include "qmacro.h"
C
C  Initializes arrays
C
       do i=1,4
        pcm(i) = 0.
       enddo
       do i=1,3
        dist(i) = 0.
       enddo
C
C  Attrape le 4-vecteur
C
       CALL QVGET4(PCM,ICH)
C
C  Longueur de desintegration
C
          IVXBEG  = KORIV(ICH)
          IVXEND  = KENDV(ICH)
          DIST(1) = QVX(IVXBEG) -QVX(IVXEND)
          DIST(2) = QVY(IVXBEG) -QVY(IVXEND)
          DIST(3) = QVZ(IVXBEG) -QVZ(IVXEND)
          DCM     = SQRT(DIST(1)**2+DIST(2)**2+DIST(3)**2)
      RETURN
      END
***************************************************************
      REAL FUNCTION CHARM_WT(ICM,CNCHT,DCM,PCM,KTQUA)
***************************************************************
*  Weight for correcting Monte Carlo charm physics.Greene/Brown
*  Modified for new 92 MC. -S.M-
*  inputs = ICM     alpha particle code.
*           CNCHT   Multiplicity of the D decay.
*           DCM     Decay length
*           PCM     4-momentum(E,p)
***************************************************************
      IMPLICIT NONE
C
C  Calling arguments
C
      REAL PCM(4),DCM
      INTEGER ICM,CNCHT,KTQUA
C
C  Local
C
      REAL CC
      PARAMETER (CC=2.997925E10)
      INTEGER I,J,IMES
      REAL PMASS,PMOM,DTM
C
C  Functions
C
      INTEGER MNUM
      INTEGER IFANNEE
      REAL VMOD
C
C  Physics data
C
      REAL WBR(2,3,0:6)
      REAL CHAD(2,0:4)
      REAL TMC(7),TMS(7)
      EXTERNAL IFANNEE
C
C     S.M  06.02.95 / new 92 MC  and 93 MC corrections.
C
******Lifetimes
******
      DATA TMC,TMS /
     >10.70E-13,4.28E-13,4.36E-13,1.76E-13,15.0E-13,15.0E-13,15.0E-13,
     >10.57E-13,4.15E-13,4.67E-13,2.00E-13,16.3E-13,15.7E-13,15.8E-13/
******
******Topologicals BR 92
******
      DATA ((WBR(1,I,J),J=0,6),I=1,3)
     &  / 1.000, 1.2940, 1.000, 0.869 , 1.000, 0.926, 1.000,
     &    1.853, 1.000, 0.929, 1.000, 1.032, 1.000, 4.339,
     &    1.000, 1.516, 1.000, 0.675, 1.000, 1.568, 1.000  /
      DATA ((WBR(2,I,J),J=0,6),I=1,3)
     &  / 1.000, 1.300, 1.000, 0.866 , 1.000, 0.941, 1.000,
     &    1.839, 1.000, 0.930, 1.000, 1.031, 1.000, 4.217,
     &    1.000, 1.500, 1.000, 0.678, 1.000, 1.569, 1.000  /
******
******Prod rates   n id     D+      D0      Ds      /\c
******
      DATA (CHAD(1,J),J=0,4) / 1.000 , 1.333 , 0.899 , 1.031 , 0.859 /
      DATA (CHAD(2,J),J=0,4) / 1.000 , 0.955 , 0.947 , 1.559 , 1.081 /
******
********************************************************
      CHARM_WT = 1.
      IMES = MNUM(ICM)
C
C  Lifetime
C
      IF (IMES.NE.0) THEN
      PMOM  = VMOD(PCM,3)
      IF ((PCM(4)**2).GT.(PMOM**2).AND.PMOM.GT.0.) THEN
      PMASS = SQRT(PCM(4)**2 - PMOM**2)
      DTM   = (PMASS/PMOM)*(DCM/CC)
      CHARM_WT = CHARM_WT * (TMC(IMES)/TMS(IMES))*
     $           EXP(DTM*( 1./TMC(IMES) - 1./TMS(IMES)))
      ENDIF
      ENDIF
C
C  Topological branching ratios
C
      IF (IMES.NE.0) THEN
        IF (CNCHT.LE.6.AND.IMES.LE.3) THEN
          IF (IFANNEE().EQ.92) CHARM_WT = CHARM_WT*WBR(1,IMES,CNCHT)
          IF (IFANNEE().EQ.93) CHARM_WT = CHARM_WT*WBR(2,IMES,CNCHT)
        ENDIF
      ENDIF
C
C  Hadron production rates; also weight the 'unidentified' decays
C  (seulement pour les events Z-->ccbar)
      IF (KTQUA.EQ.2) THEN
      IF (IFANNEE().EQ.92) CHARM_WT = CHARM_WT*CHAD(1,IMES)
      IF (IFANNEE().EQ.93) CHARM_WT = CHARM_WT*CHAD(2,IMES)
      ENDIF
C
      RETURN
      END
**************************************
      INTEGER FUNCTION MNUM(I)
**************************************
      IMPLICIT NONE
      INTEGER I
C
      IF (I.EQ.35.OR.I.EQ.36)THEN        !  charged D
        MNUM=1
      ELSE IF (I.EQ.37.OR.I.EQ.38)THEN   ! neutral D
        MNUM=2
      ELSE IF (I.EQ.39.OR.I.EQ.40)THEN   ! strange D
        MNUM=3
      ELSE IF (I.EQ.41.OR.I.EQ.53)THEN   ! /\c
        MNUM=4
      ELSE IF (I.EQ.115.OR.I.EQ.116)THEN   ! B+
        MNUM=5
      ELSE IF (I.EQ.117.OR.I.EQ.118)THEN   ! B0
        MNUM=6
      ELSE IF (I.EQ.119.OR.I.EQ.120)THEN   ! Bs
        MNUM=7
      ELSE
        MNUM = 0
      END IF
      RETURN
      END
