*DK tpzspr
      SUBROUTINE TPZSPR(IARR,NTOT, LTHRSH,NPRESP,NPOSTS,MINLEN,
     &                  IOFF1,NLEN,NISOL,MXISOL)
C--------------------------------------------------------------------
C!  Take the signal in IARR and find isolated pulses using the
C!  same zero suppression algorithm as the TPDs implement online.
C
C  Called from:  TSRESP
C  Calls:        None
C
C  Inputs:   PASSED:  --IARR,   array containing the full signal
C                     --NTOT,   length of the full signal
C                     --LTHRSH  threshold for zero suppression
C                     --NPRESP  No of presamples to be kept
C                     --NPOSTS  No of postsamples to be kept
C                     --MINLEN  Min no of samples above LTHRSH
C                     --MXISOL, max number of isolated pulses allowed
C
C  Outputs:  PASSED:  --NISOL,  number of isolated pulses
C                     --IOFF1,  offset from IARR(1) of 1st bin of
C                               each isolated pulse
C                     --NLEN,   length of each isolated pulse
C  R. Johnson  28-11-86
C  M. Mermikides 8-11-87 Allow different constants for wires and pads
C--------------------------------------------------------------------
C
      DIMENSION IARR(NTOT)
      DIMENSION IOFF1(MXISOL),NLEN(MXISOL)
      LOGICAL LOUT
C
C?    Loop over all samples in the digitized signal.  When the signal
C?    rises above LTHRSH we open a new pulse starting at that point
C?    minus the number of presamples (NPRESP).  When it falls again
C?    below LTHRSH, then we close off the pulse by calculating the
C?    total number of samples up to that point plus the number of
C?    post samples, or if the number of samples over threshold was
C?    less than MINLEN, then we just drop that pulse and go to the next.
C
      LOUT=.TRUE.
      NISOL=0
      DO 80 IS=1,NTOT
        IF (LOUT) THEN
          IF (IARR(IS).GE.LTHRSH) THEN
            LOUT=.FALSE.
            NISOL=NISOL+1
            IOFF1(NISOL)=MAX(0,IS-NPRESP-1)
            NLEN(NISOL)=IS-IOFF1(NISOL)
            MXLEN=NTOT-IOFF1(NISOL)
            NOVER=1
          END IF
        ELSE
          IF (IARR(IS).LT.LTHRSH .OR. IS.EQ.NTOT) THEN
            LOUT=.TRUE.
            IF (NOVER.LT.MINLEN) THEN
              NISOL=NISOL-1
            ELSE
              NLEN(NISOL)=MIN(MXLEN,NLEN(NISOL)+NPOSTS)
              IF (NISOL.EQ.MXISOL) GO TO 90
            END IF
          ELSE
            NLEN(NISOL)=NLEN(NISOL)+1
            NOVER=NOVER+1
          END IF
        END IF
   80 CONTINUE
   90 CONTINUE
      RETURN
      END
