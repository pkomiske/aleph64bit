      SUBROUTINE PTPCOJ(LIST,IER)
C
C----------------------------------------------------------------------
C! Unpack the PTCO or PTNC bank into TPCO. Needs banks FRTL and FRFT.
C
C    Author:  R. Johnson   16-06-88
C             modified by D.Schlatter
C     Input :    LIST      BOS event list
C                          if LIST(2:2).eq.'-' drop POT banks
C     Output:    IER       = 0  successful
C                          = 1  input bank does not exist or is empty
C                          = 2  not enough space
C                          =-1  OK but garbage collection
C
C    Called by TPTOJ
C    Calls     TUN1CO or TUN1NC
C
C    Warning:  this routine does not sort the coordinates in TPCO
C              by row and sector number, so the resulting bank cannot
C              be used as input into the pattern recognition routines.
C              Call TSRTCO to sort the coordinates appropriately.
C
C    Note: if PTNC (the new POT coordinate bank) is found, then it
C          is unpacked.  Otherwise the routine looks for the old
C          version, named PTCO.
C
C----------------------------------------------------------------------
      SAVE
C
      INTEGER LMHLEN, LMHCOL, LMHROW
      PARAMETER (LMHLEN=2, LMHCOL=1, LMHROW=2)
C
      COMMON /BCS/   IW(1000)
      INTEGER IW
      REAL RW(1000)
      EQUIVALENCE (RW(1),IW(1))
C
      PARAMETER(JFRTIV=1,JFRTNV=2,JFRTII=3,JFRTNI=4,JFRTNE=5,JFRTIT=6,
     +          JFRTNT=7,JFRTNR=8,LFRTLA=8)
      PARAMETER(JTPCIN=1,JTPCRV=2,JTPCPH=3,JTPCZV=4,JTPCSR=5,JTPCSZ=6,
     +          JTPCOF=7,JTPCTN=8,JTPCCN=9,JTPCIT=10,JTPCRR=11,
     +          JTPCRZ=12,LTPCOA=12)
C
      CHARACTER LIST*(*),PLIST*4,JLIST*4
      LOGICAL FIRST,FNEW
      DATA FIRST/.TRUE./
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
C
      IF (FIRST) THEN
        FIRST=.FALSE.
        NFRTL=NAMIND('FRTL')
        NTPCO=NAMIND('TPCO')
        CALL BKFMT('TPCO','2I,(I,5F,4I,2F)')
        NPTCO=NAMIND('PTCO')
        NPTNC=NAMIND('PTNC')
      ENDIF
C
      KPTCO=IW(NPTCO)
      KPTNC=IW(NPTNC)
      IER = 1
      IF (KPTCO.EQ.0 .AND. KPTNC.EQ.0) GOTO 999
C
      IF (KPTNC.NE.0) THEN
        IF (LROWS(KPTNC) .EQ. 0) GOTO 999
        NCORD=LROWS(KPTNC)
        FNEW=.TRUE.
      ELSE
        IF (LROWS(KPTCO) .EQ. 0) GOTO 999
        NCORD=LROWS(KPTCO)
        FNEW=.FALSE.
      ENDIF
      LEN=NCORD*LTPCOA+LMHLEN
      IW(1)=1
      CALL AUBOS('TPCO',0,LEN,KTPCO,IER)
      IF (IER.EQ.2) GOTO 999
      IER1 = IER
      JLIST = 'TPCO'
      IW(KTPCO+LMHCOL)=LTPCOA
      IW(KTPCO+LMHROW)=NCORD
C
      KFRTL=IW(NFRTL)
      IF (KFRTL.EQ.0)  GO TO 600
C
C++   Loop over coordinates by track number, so we can fill the
C++   track reference in TPCO
C
      IC=0
      DO 500 ITK=1,LROWS(KFRTL)
        IF (ITABL(KFRTL,ITK,JFRTNT).EQ.0) GO TO 500
        DO 100 II=1,ITABL(KFRTL,ITK,JFRTNT)
          IC=IC+1
          IF (FNEW) THEN
            CALL TUN1NC(IC,ITK,IW(KROW(KTPCO,IC)+JTPCIN),
     &                        RW(KROW(KTPCO,IC)+JTPCIN),IERR)
          ELSE
            CALL TUN1CO(IC,IW(KROW(KTPCO,IC)+JTPCIN),
     &                        RW(KROW(KTPCO,IC)+JTPCIN),IERR)
          ENDIF
          IF (IERR.NE.0) THEN
            IER=IERR*10+4
            GO TO 998
          ENDIF
          IW(KROW(KTPCO,IC)+JTPCTN)=ITK
  100   CONTINUE
        DO 200 II=1,ITABL(KFRTL,ITK,JFRTNR)
          IC=IC+1
          IF (FNEW) THEN
            CALL TUN1NC(IC,ITK,IW(KROW(KTPCO,IC)+JTPCIN),
     &                        RW(KROW(KTPCO,IC)+JTPCIN),IERR)
          ELSE
            CALL TUN1CO(IC,IW(KROW(KTPCO,IC)+JTPCIN),
     &                        RW(KROW(KTPCO,IC)+JTPCIN),IERR)
          ENDIF
          IF (IERR.NE.0) THEN
            IER=IERR*10+4
            GO TO 998
          ENDIF
          IW(KROW(KTPCO,IC)+JTPCTN)=-ITK
  200   CONTINUE
  500 CONTINUE
C
C++   Fill in the remaining unassociated coordinates
C
      DO 700 II=IC+1,NCORD
        IF (FNEW) THEN
          CALL TUN1NC(II,0,IW(KROW(KTPCO,II)+JTPCIN),
     &                      RW(KROW(KTPCO,II)+JTPCIN),IERR)
        ELSE
          CALL TUN1CO(II,IW(KROW(KTPCO,II)+JTPCIN),
     &                      RW(KROW(KTPCO,II)+JTPCIN),IERR)
        ENDIF
        IF (IERR.NE.0) THEN
          IER=IERR*10+4
          GO TO 998
        ENDIF
  700 CONTINUE
      GOTO 998
C
C++   Only coordinates but no tracks
C
  600 CONTINUE
      DO 610 II=1,NCORD
        IF (FNEW) THEN
          CALL TUN1NC(II,0,IW(KROW(KTPCO,II)+JTPCIN),
     &                      RW(KROW(KTPCO,II)+JTPCIN),IERR)
        ELSE
          CALL TUN1CO(II,IW(KROW(KTPCO,II)+JTPCIN),
     &                      RW(KROW(KTPCO,II)+JTPCIN),IERR)
        ENDIF
        IF (IERR.NE.0) THEN
          IER=IERR*10+1
          GO TO 998
        ENDIF
  610 CONTINUE
C
  998 CONTINUE
C
C - get the drop flag if any, then drop POT banks if required,
C   add JUL banks to S-list
C   POT banks are on PLIST, JUL banks on JLIST
      PLIST = 'PTCOPTNC'
C! add JLIST to S-list, drop PLIST if required
      IF (LNBLNK(LIST).EQ.2) THEN
         IF (LIST(2:2).EQ.'-' .AND. LNBLNK(PLIST).GE.4) THEN
            CALL BDROP (IW,PLIST)
            CALL BLIST (IW,LIST,PLIST(1:LNBLNK(PLIST)))
         ENDIF
      ENDIF
      CALL BLIST (IW,'S+',JLIST(1:LNBLNK(JLIST)))
C
C
      IF (IER1 .EQ. 1) IER = -1
C
  999 CONTINUE
      RETURN
      END
