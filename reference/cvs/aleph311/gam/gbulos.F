      SUBROUTINE GBULOS(T,P,E,N,IERROR)
C---------------------------------------------------------------------
CKEY PHOTONS
C!  Calculate Eigenvariances cluster.
C!  Find a two photon decomposition of cluster based on
C!  Eigenvariaces and 3rd moments in direction of major axis.
C
C  Author    :       Nigel Keemer
C  Modified  :       C.Goy             18/12/90
C
C    Input: T      - 1st coordinate of elements (storeys)
C           P      - 2nd coordinate of elements (storeys)
C           E      - Energy of elements (storeys)
C           N      - Number of storeys in cluster
C  Outputs: IERROR - Error
C                    = 1 - cluster energy < 0.
C    Calls: None
C Bank ref: None
C Comm ref: None
C Bank mod: None
C Comm mod: GULIMP - Decomposition of cluster into two impacts
C           GUINFO - Values of second and third moments in Eigenframe
C---------------------------------------------------------------------
#ifndef DOC
C Input arguements (see above)
      SAVE
      REAL              T(*),   P(*),   E(*)
      INTEGER           N
C Output aguement (see above)
      INTEGER           IERROR
C Positions and energies in local coordinate system of two photons
      REAL              E1,     T1,     P1,     E2,     T2,     P2
      COMMON / GULIMP / E1,     T1,     P1,     E2,     T2,     P2
C Sigma and 3rd moments of cluster in Eigenframe
      REAL              RALAMS, RALAML, sVM3,    sUM3
      COMMON / GUINFO / RALAMS, RALAML, sVM3,    sUM3
      DOUBLE PRECISION VM3,UM3
C Storey index
      INTEGER           I
C Sums
      DOUBLE PRECISION   TPSUM,  TSUM,   TTSUM,  PSUM,   PPSUM,  ESUM
C Moments in T,P coordinates
      DOUBLE PRECISION   TPBAR,  TBAR,   TTBAR,  PBAR,   PPBAR
C Elements of moments matrix to be diagonalized
      DOUBLE PRECISION   A,      B,      C,      AMB
C Angle between T,P frame & Eigenframe
      DOUBLE PRECISION   PHI,    SPH,    CPH
C Eigenvalues
      DOUBLE PRECISION   ALAMS,  ALAML
      DOUBLE PRECISION   ALAM1,  ALAM2
C Coordinate directions in eigenframe
      DOUBLE PRECISION   U,      V
C Difference between second moments, asymmetry in energies (E2-E1/ET)
      DOUBLE PRECISION   DELTAL, DEL
C Positions of two impacts in Eigenframe
      DOUBLE PRECISION   U1,     V1,     U2,     V2
C Protestion against underflows
      DOUBLE PRECISION   SMALL
      DATA SMALL / 0.00000001 /
C---------------------------------------------------------------------
      IERROR = 0
      TSUM   = 0.
      PSUM   = 0.
      TPSUM  = 0.
      TTSUM  = 0.
      PPSUM  = 0.
      ESUM   = 0.
C Find 0th 1st and 2nd moments
      DO 10 I = 1,N
        ESUM   = ESUM  + E(I)
        TSUM   = TSUM  + E(I) * T(I)
        PSUM   = PSUM  + E(I) * P(I)
        TTSUM  = TTSUM + E(I) * T(I)*T(I)
        PPSUM  = PPSUM + E(I) * P(I)*P(I)
        TPSUM  = TPSUM + E(I) * T(I)*P(I)
   10 CONTINUE
      IF (ESUM.LE.0.) THEN
        IERROR = 1
        GO TO 999
      ENDIF
C
      TBAR   = TSUM  / ESUM
      PBAR   = PSUM  / ESUM
      TPBAR  = TPSUM / ESUM
      TTBAR  = TTSUM / ESUM
      PPBAR  = PPSUM / ESUM
      A      = TTBAR - TBAR*TBAR
      B      = PPBAR - PBAR*PBAR
      C      = TPBAR - TBAR*PBAR
      AMB    = A-B
C protect overflow
      IF (ABS(AMB).LT.SMALL) AMB = SMALL
C Angle to rotate to Eigenframe
      PHI    = ATAN2(2.*C,AMB)*0.5
      CPH    = COS(PHI)
      SPH    = SIN(PHI)
C ALAMS and ALAML are the Eigenvariances, RALAMS & RALAML are sigmas
      ALAM1  = DMAX1( A*CPH*CPH + 2.*C*SPH*CPH + B*SPH*SPH, SMALL)
      ALAM2  = DMAX1( A*SPH*SPH - 2.*C*SPH*CPH + B*CPH*CPH, SMALL)
      ALAML  = ALAM1
      ALAMS  = ALAM2
      RALAMS = sngl(dSQRT(ALAMS))
      RALAML = sngl(dSQRT(ALAML))
C Rotate to Eigenframe and compute the third moment
C U-axis corresponds to ALAMS, V-axis corresponds to ALAML
      UM3    = 0.
      VM3    = 0.
      DO 20 I = 1,N
        U      = (P(I)-PBAR)*SPH + (T(I)-TBAR)*CPH
        V      = (P(I)-PBAR)*CPH - (T(I)-TBAR)*SPH
        UM3    = UM3 + E(I)*U*U*U
        VM3    = VM3 + E(I)*V*V*V
   20 CONTINUE
      UM3    = UM3 / ESUM
      VM3    = VM3 / ESUM
C Split the cluster and rotate back to internal frame
      DEL    = 1. + 4.*(ALAM1-ALAM2)**3/(UM3*UM3)
      DEL    = 1.0/SQRT(DEL)
      DELTAL = DMAX1(ABS(ALAM1-ALAM2),SMALL)
      U1     = UM3 * (1.0 - 1.0/DEL) / (2.0*DELTAL)
      U2     = UM3 * (1.0 + 1.0/DEL) / (2.0*DELTAL)
      V1     = 0.
      V2     = 0.
C
      T1     = sngl(TBAR + U1*CPH - V1*SPH )
      P1     = sngl(PBAR + U1*SPH + V1*CPH )
      E1     = sngl(ESUM * (1.0+DEL) * 0.5 )
      T2     = sngl(TBAR + U2*CPH - V2*SPH )
      P2     = sngl(PBAR + U2*SPH + V2*CPH )
      E2     = sngl(ESUM * (1.0-DEL) * 0.5 )
C
      svm3 = sngl(vm3)
      sum3 = sngl(um3)
C
  999 CONTINUE
C
      RETURN
      END
#endif
