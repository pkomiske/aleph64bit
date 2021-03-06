      SUBROUTINE UINDXS(KBNK2,ICOLR,IWREL,IFLAG)
C ---------------------------------------------------------------------
C.
C! - Establish n-->1 relationships for static tables
C.
C. - Author   : A. Putzer  - 86/09/09
C. - Modified : A. Putzer  - 87/06/04
C.              F.Ranjard  - 94/03/23  call SORTI instead of SORTX
C.
C.
C.   Arguments: -  KBNK2    (input)  Index of input bank
C.              -  ICOLR    (input)  Column containing the attribute
C.                                   used for the relation
C.              -  IWREL(2) (output) Adresses of the banks containing
C.                                   the relation information
C.              -  IFLAG    (output) Error flag  = 0 ok
C.                                                -1 Bank not existing
C.                                                -2 Bank not filled
C.                                                -3 ICOLR not valid
C.                                                -4 no working space
C.                                                -5 no relation at all
C.
C ---------------------------------------------------------------------
C - Column number containing the information used for the sorting
      PARAMETER (KCOLR = 1)
C - Number of colums for intermediate bank, relation bank, pointer bank
      PARAMETER (NCOLI = 2, NCOLR = 3, NCOLP = 1)
C - Column numbers in the relation bank for
C           Relation attribute, NofRelations, Pointer to pointer bank
      PARAMETER (LCOLR = 1, LCOLN = 2, LCOLP =3)
C
      DIMENSION IWREL(*)
      COMMON /JDULOC/   INDWO
      INTEGER LMHLEN, LMHCOL, LMHROW
      PARAMETER (LMHLEN=2, LMHCOL=1, LMHROW=2)
C
      COMMON /BCS/   IW(1000)
      INTEGER IW
      REAL RW(1000)
      EQUIVALENCE (RW(1),IW(1))
C
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
C ---------------------------------------------------------------------
      IFLAG = 0
      IF (KBNK2.EQ.0) THEN
        IFLAG = -1
        GO TO 999
      ENDIF
C
C -   Get parameters of the inputbank
C
      NROWB = LROWS(KBNK2)
      IF (NROWB.LT.1) THEN
        IFLAG = -2
        GO TO 999
      ENDIF
      NCOLB = LCOLS(KBNK2)
C
      IF (ICOLR.LT.0.OR.ICOLR.GT.NCOLB) THEN
        IFLAG = -3
        GO TO 999
      ENDIF
C
C -     Lift working bank used as working space
C
      NLNWK = NROWB*NCOLI
      INDWO = 0
      CALL WBANK(IW,INDWO,2*NLNWK,*998)
C
      IST = KBNK2 + LMHLEN
      KST = INDWO
C
C -   Fill working bank
C
      NROWF = 0
      DO 100 I = 1,NROWB
C -  Skip rows with the rel. attr. = 0
      IF (IW(IST+ICOLR).EQ.0) GO TO 101
      NROWF = NROWF + 1
C - Relation attribute
        IW(KST+1)  =  IW(IST+ICOLR)
C - Row number
        IW(KST+2)  =  I
        KST = KST + NCOLI
  101   IST = IST + NCOLB
  100 CONTINUE
C - If there is no relation at all set flag and quit
C
      IF (NROWF.EQ.0) THEN
          IFLAG = -5
          GO TO 999
      ENDIF
C
C
C - Sort relation bank
C
      CALL SORTI(IW(INDWO+1),NCOLI,NROWF,KCOLR)
C
C - Get number of different values for the relation attribute
C
      NDIFF = 1
      NST = INDWO+1
      NREMB = IW(NST)
      DO 200 I = 2,NROWF
        NST = NST+NCOLI
        IF (IW(NST).NE.NREMB) THEN
          NDIFF = NDIFF+1
          NREMB = IW(NST)
        ENDIF
  200 CONTINUE
C
C - Lift now the relation banks
C
      CALL WBANK(IW,IWREL(1),NDIFF*NCOLR+LMHLEN,*998)
      CALL WBANK(IW,IWREL(2),NROWF*NCOLP+LMHLEN,*998)
C
C - Fill number of colums and rows
C
      IW(IWREL(1) + LMHCOL) = NCOLR
      IW(IWREL(2) + LMHCOL) = NCOLP
      IW(IWREL(1) + LMHROW) = NDIFF
      IW(IWREL(2) + LMHROW) = NROWB
C
C - Fill the relation banks
C      Column 1 : Value of relation relation attribute
C      Column 2 : Number of entities in input bank corresponding to it
C      Column 3 : Relative pointer to the address in the pointer bank
C - And the pointer bank
C      Column 1 : Relative addresses to the entities in the input bank
C                 (sorted)
C
      NDIFF = 1
      NENTI = 1
      NST = INDWO+1
      NREMB = IW(NST)
      IST1 = IWREL(1) + LMHLEN
      IST2 = IWREL(2) + LMHLEN + NCOLP
      IW(IST1+LCOLR) = NREMB
      IW(IST1+LCOLP) = 0
      IW(IST2) = IW(NST+1)
      DO 300 I = 2,NROWF
        NST = NST+NCOLI
        IST2 = IST2 + NCOLP
        IW(IST2) = IW(NST+1)
        IF (IW(NST).NE.NREMB) THEN
          IW(IST1+LCOLN) = NENTI
          IST1 = IST1 + NCOLR
          NDIFF = NDIFF+1
          NREMB = IW(NST)
          NENTI = 1
          IW(IST1+LCOLR) = IW(NST)
          IW(IST1+LCOLP) = I - 1
        ELSE
          NENTI = NENTI + 1
        ENDIF
  300 CONTINUE
      IW(IST1+LCOLN) = NENTI
C
C - Drop unneeded working bank
C
      CALL WDROP(IW,INDWO)
C
      GO TO 999
C
  998 CONTINUE
      IFLAG = -4
  999 RETURN
      END
