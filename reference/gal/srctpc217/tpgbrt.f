      SUBROUTINE TPGBRT(ITYPE,NBRTE,PSIN,PSOUT)
C-----------------------------------------------------------------------
C!  Find the number of broken track elements and the initial and final
C!  points of each
C
C  Called from:  TPBRTK
C  Calls:        AUCIRL, SORTZV, TPFIDS
C
C  Inputs:   PASSED:      --ITYPE, the sector type
C            /TRAKEL/     --secondary track parameters for the track
C                           element to be broken
C            /SCTBND/     --x-limits, slopes, and intercepts of the
C                           line segments forming the boundaries of
C                           the extended sectors
C
C  Outputs:  PASSED:      --NBRTE,  the number of broken track elements
C                         --PSIN,   the angle (measured counter-
C                                   clockwise) between the X-axis and
C                                   the radius to the first point of
C                                   each broken track element (all in
C                                   X-Y projection)
C                         --PSOUT,  same for last point of each broken
C                                   track element
C  D. DeMille
C-----------------------------------------------------------------------
C
C  TRAKEL:  track parameters for dE/dX and carrying around broken
C  tracks
C
      COMMON/TRAKEL/NTRK,X(3),VECT(3),ABSMOM,SEGLEN,TOF,AMASS,CHARGE,
     *              RAD,CENT(2),DELPSI,PSI1,ALPH01,ALPH02
C - MXBRK = 2* MAX(NLINES(1..3)) + 2 , NLINES= 8,10,10 in /SCTBND/
      PARAMETER (MXBRK=22, MXBRTE=MXBRK/2)
      COMMON/BRKNTK/XB(3,6),VECTB(3,6),SEGLNB(6)
      COMMON /SCTBND/ NLINES(3),SLOPES(10,3),YCEPTS(10,3),
     1                XUPLIM(10,3),XLWLIM(10,3),PHIMAX(3)
      REAL PI, TWOPI, PIBY2, PIBY3, PIBY4, PIBY6, PIBY8, PIBY12
      REAL RADEG, DEGRA
      REAL CLGHT
      INTEGER NBITW, NBYTW, LCHAR
      PARAMETER (PI=3.141592653589)
      PARAMETER (RADEG=180./PI, DEGRA=PI/180.)
      PARAMETER (TWOPI = 2.*PI , PIBY2 = PI/2., PIBY4 = PI/4.)
      PARAMETER (PIBY6 = PI/6. , PIBY8 = PI/8.)
      PARAMETER (PIBY12= PI/12., PIBY3 = PI/3.)
      PARAMETER(CLGHT = 29.9792458, ALDEDX = 0.000307)
      PARAMETER (NBITW = 32 , NBYTW = NBITW/8 , LCHAR = 4)
C
C  Additional constants for TPCSIM
C  Units -- Mev,Joules,deg Kelvin,Coulombs
C
      REAL ELMASS,CROOT2,CKBOLT,CROOMT,ECHARG
      PARAMETER (ELMASS = 0.511)
      PARAMETER (CROOT2 = 1.41421356)
      PARAMETER (CKBOLT = 1.380662E-23)
      PARAMETER (CROOMT = 300.)
      PARAMETER (ECHARG = 1.602189E-19)
C
      DIMENSION PSINT(MXBRK),PSBRK(MXBRK),INDPS(MXBRK)
      DIMENSION PSIN(MXBRTE),PSOUT(MXBRTE)
C
      LOGICAL LIN
C
      NINT = 0
C
C  Find the points of intersection of the circle defined by the track
C  element's x-y projection and the line segments forming the sector
C
      DO 1 I = 1, NLINES(ITYPE)
C
         CALL AUCIRL(CENT(1),CENT(2),RAD,SLOPES(I,ITYPE),
     *               YCEPTS(I,ITYPE),XLWLIM(I,ITYPE),XUPLIM(I,ITYPE),
     *               PSINT(NINT+1),MINT)
         NINT = NINT + MINT
C
 1    CONTINUE
C
C  Change angular variables to the interval [ psi2, psi2 + 2pi ]
C
      PSI2 = PSI1 + ABS(DELPSI)
      IF ( PSI2 .GT. TWOPI ) THEN
C
         PSTMP = PSI2 - TWOPI
         DO 2 J = 1, NINT
            IF ( PSINT(J) .LT. PSTMP ) PSINT(J) = PSINT(J) + TWOPI
    2    CONTINUE
C
      ENDIF
C
C  Find those intersections which actually lie on the part
C  of the circle which the track traverses; psi1 and psi2 also count
C  as relevant breakpoints
C
      NBRK = 1
      PSBRK(NBRK) = PSI1
C
      DO 3 J = 1, NINT
C
         IF ( PSINT(J) .GT. PSI1 .AND. PSINT(J) .LT. PSI2 ) THEN
            NBRK = NBRK + 1
            PSBRK(NBRK) = PSINT(J)
         ENDIF
C
 3    CONTINUE
C
      NBRK = NBRK + 1
      PSBRK(NBRK) = PSI2
C
C  Order psbrk from smallest to largest if rotation is clockwise, or
C  vice-versa
C
      NWAY = INT( SIGN(1.,DELPSI) ) - 1
      CALL SORTZV(PSBRK,INDPS,NBRK,1,NWAY,0)
C
C  See whether the first point of the track segment lies in the sector
C
      CALL TPFIDS(X,ITYPE,LIN)
C
C  Determine the number of broken track elements
C
      IF ( MOD(NBRK,2) .EQ. 1 ) THEN
C
         NBRTE = ( NBRK - 1 )/2
C
      ELSE
C
         IF ( LIN ) THEN
            NBRTE = ( NBRK / 2 )
         ELSE
            NBRTE = ( NBRK / 2 ) - 1
         ENDIF
C
      ENDIF
C
C  Determine the initial and final points of each broken track element
C
      IF ( LIN ) THEN
C
         DO 4 J = 1, NBRTE
            PSIN(J) = PSBRK( INDPS(2*J-1) )
            PSOUT(J) = PSBRK( INDPS(2*J) )
 4       CONTINUE
C
      ELSE
C
         DO 5 J = 1, NBRTE
            PSIN(J) = PSBRK( INDPS(2*J) )
            PSOUT(J) = PSBRK( INDPS(2*J+1) )
 5       CONTINUE
C
      ENDIF
C
      RETURN
      END
