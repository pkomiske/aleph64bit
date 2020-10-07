C-----------------------------------------------------------------------
C
      SUBROUTINE MIN100(BANK,NCOLS, KOLD,KNEW,NROWS)
C
C++   Utility routine for MINUPD.
C++   Copy BANK/n to BANK/100. If any problems, NROWS set to zero.
C
      INTEGER LMHLEN, LMHCOL, LMHROW
      PARAMETER (LMHLEN=2, LMHCOL=1, LMHROW=2)
C
      COMMON /BCS/   IW(1000)
      INTEGER IW
      REAL RW(1000)
      EQUIVALENCE (RW(1),IW(1))
C
      CHARACTER*4 BANK
C!    set of intrinsic functions to handle BOS banks
C - # of words/row in bank with index ID
      LCOLS(ID) = IW(ID+1)
C - # of rows in bank with index ID
      LROWS(ID) = IW(ID+2)
C - index of next row in the bank with index ID
      KNEXT(ID) = ID + LMHLEN + IW(ID+1)*IW(ID+2)
C - index of row # NRBOS in the bank with index ID
      KROW(ID,NRBOS) = ID + LMHLEN + IW(ID+1)*(NRBOS-1)
C - # of free words in the bank with index ID
      LFRWRD(ID) = ID + IW(ID) - KNEXT(ID)
C - # of free rows in the bank with index ID
      LFRROW(ID) = LFRWRD(ID) / LCOLS(ID)
C - Lth integer element of the NRBOSth row of the bank with index ID
      ITABL(ID,NRBOS,L) = IW(ID+LMHLEN+(NRBOS-1)*IW(ID+1)+L)
C - Lth real element of the NRBOSth row of the bank with index ID
      RTABL(ID,NRBOS,L) = RW(ID+LMHLEN+(NRBOS-1)*IW(ID+1)+L)
C
C
      NROWS = 0
      KNEW = 0
      KOLD = IW(NAMIND(BANK))
      IF (KOLD.LE.0) RETURN
      NROWS = LROWS(KOLD)
      LEN = LMHLEN + NCOLS * NROWS
      CALL AUBOS(BANK,100,LEN, KNEW,IGARB)
      IF (IGARB.GE.2) THEN
         NROWS = 0
         RETURN
      ELSE
         KOLD = IW(NAMIND(BANK))
      ENDIF
      IW(KNEW+LMHCOL) = NCOLS
      IW(KNEW+LMHROW) = NROWS
C
      RETURN
      END