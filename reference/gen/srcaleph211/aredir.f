      SUBROUTINE AREDIR (IEVT,IRUN,NREC,IRET)
C -------------------------------------------------------------
C- F.Ranjard - 911031              from ABRREC
CKEY ALPHARD READ EDIR
C! reads EDIR file
C returns NEVT NRUN in /SYSBOS/ and record pointer in IW(1)
C
C - Output:  IEVT   / I  = next event # to be read
C            IRUN   / I  = next run # to be read
C            NREC   / I  = record pointer
C            IRET   / I  = return code
C
C -------------------------------------------------------------
      SAVE NASEVT, NASRUN, IV, IVMAX
*MACRO BOSCOM
C
      COMMON /BCS/IW(1000)
      COMMON /SYSBOS/NSYST,NAMES,NPRIM,IDNAM,IDPTR,
     1               IDFMT,NDUMM,NRESR,NLPLM, NARR,
     2               IARR(10),
     3               IEFMT,TLEFT,
     4               LEPIO,NAMI,INDI,INDJ,IBC,DUMMI(73),
     5               INTA(200), NPTR,NRUN,NEVT,
     6               LUNDAT,LUNSEL,LUNSE2,LUTDAT,MASKR,LMASK,
     7               NRE,NAMERE(3),NUMMRE(3),IRUNRE(3),IEVTRE(3)
C
      COMMON /ABRCOM/ BATCH,INIT,CLOSE1,CLOSE2,FWFILM
     &               ,IUNDAT(2),IUTDAT(5),IUNSEL,IUNSE2,IUTSEL
     &               ,MASKA,MASKW
     &               ,WLIST,TLIST
      LOGICAL BATCH, INIT, CLOSE1, CLOSE2, FWFILM
      CHARACTER*1   TLIST, WLIST
C
      LOGICAL OK, BSELEC
      DATA NAPTS /0/
C --------------------------------------------------------------
      IF (NAPTS.EQ.0) THEN
         NAPTS = NAMIND('$PTS')
         NASEVT= NAMIND('SEVT')
         NASRUN= NAMIND('SRUN')
      ENDIF
C
C       get event directory bank
C
      JPTS = 0
      IPT = NAPTS+1
  110 IPT = IW(IPT-1)
      IF (IPT .NE. 0)  THEN
         IF (IW(IPT-2) .NE. IUNSEL)  GOTO 110
         JPTS = IPT
      ENDIF
C
C
  205   IF (JPTS .EQ. 0) THEN
C       read new event directory bank
           CALL ABREAD (IW, IUNSEL, 'Z', *812, *813)
           JPTS = NLINK ('$PTS', 0)
           IF (JPTS .EQ. 0)  GO TO 812
           JPTS = NSWAP ('$PTS', IUNSEL, '$PTS', 0)
           IF (JPTS .EQ. 0)  GO TO 812
           IVMAX = IW(JPTS)/4 * 4
           IV = 0
           GOTO 215
        ENDIF
C
C       current event directory
 210    CONTINUE
        IF (IV .GE. IVMAX)  THEN
           LPTS = IW(JPTS)
           JPTS = NDROP ('$PTS', IUNSEL)
C         if there are extra words after the last entry it means
C         that there is another $PTS bank: reads it
           IF (MOD(LPTS,4).NE.0) GOTO 205
C         end of the event directory for the current input file
           GOTO 813
        ENDIF
C
C      get next entry in event directory
 215    IV = IV + 4
        IEVT = IW(JPTS+IV)
        IRUN = IW(JPTS+IV-1)
C
C      test MASK
        LMASK = IW(JPTS+IV-2)
        IF (.NOT. BSELEC (LMASK, MASKR))  GO TO 210
        MASKW = LMASK
C
C       BATCH mode .........................
        IF (BATCH) THEN
C
C     is this entry selected (IEVT, SEVT, SRUN, or IRUN) ?
        CALL ABSEVT (IRUN, IEVT, IFLG)
        IF (IFLG .EQ. 0)  THEN
           GO TO 210
        ELSEIF (IFLG .LT. 0) THEN
C        look for next run on the same EDIR
           DO 220 M = IV+3,IVMAX,4
              IF (IW(JPTS+M).EQ.0 .OR. IW(JPTS+M).EQ.IRUN) GOTO 220
              IV = M-3
              GOTO 215
  220      CONTINUE
           IVMAX = 0
           GOTO 210
        ELSEIF (IFLG .EQ. 5)  THEN
           IVMAX = 0
           GOTO 210
        ELSEIF (IFLG .GE. 4) THEN
           IRET = IFLG
           GO TO 900
        ENDIF
C
C     INTERACTIVE mode   .........................
      ELSE
C
        JSEVT = IW(NASEVT)
        JSRUN = IW(NASRUN)
C
        IF (JSEVT.EQ.0 .AND. JSRUN.EQ.0) THEN
C        get next event defined by IV,IEVT,IRUN with IEVT not 0
           IF (IEVT.EQ.0) THEN
              IF (IRUN.NE.NRUN) GOTO 290
              DO 250 M=IV+4,IVMAX,4
                 IF ((IW(JPTS+M-1).EQ.0.OR.IW(JPTS+M-1).EQ.NRUN)
     &           .AND. (IW(JPTS+M).EQ.0)) GOTO 250
                 IV = M
                 IEVT = IW(JPTS+IV)
                 IRUN = IW(JPTS+IV-1)
                 GOTO 290
 250          CONTINUE
              IF (IEVT.EQ.0) THEN
C              no more event on this $PTS , read next $PTS
                 IVMAX = 0
                 GOTO 210
              ENDIF
           ENDIF
        ELSE
C
C        get event set by SEVT or SRUN card
          IF (JSRUN.NE.0) THEN
             MRUN = IW(JSRUN+1)
             MEVT = 0
          ENDIF
          IF (JSEVT.NE.0) THEN
             MRUN = IW(JSEVT+1)
             MEVT = IW(JSEVT+2)
          ENDIF
          IF (IRUN .NE. MRUN) THEN
C        get run # MRUN
             DO 251 M=IV+3,IVMAX,4
                IF (IW(JPTS+M).NE.MRUN) GOTO 251
                IV=M+1
                IEVT = IW(JPTS+IV)
                IRUN = IW(JPTS+IV-1)
                GOTO 260
 251         CONTINUE
             IF (IRUN.NE.MRUN) THEN
C             run not found on this $PTS , try next $PTS
                IVMAX = 0
                GOTO 210
             ENDIF
          ENDIF
C
 260      CONTINUE
C        get next event or event # MEVT
          IF (
     &        (MEVT.NE.0 .AND. IEVT.NE.MEVT)) THEN
             OK = .FALSE.
             IRET = 0
             DO 261 M=IV+4,IVMAX,4
                IF (IW(JPTS+M).EQ.0) GOTO 261
                IF (MEVT.NE.0 .AND.MEVT.NE.IW(JPTS+M)) THEN
                  IF (IW(JPTS+M-1).NE.MRUN) THEN
                     IRET=8
                  ELSEIF (IW(JPTS+M).GT.MEVT) THEN
                     IRET=8
                  ENDIF
                  IF (IRET.NE.0) GOTO 900
                ELSE
                  IV = M
                  IEVT = IW(JPTS+IV)
                  IRUN = IW(JPTS+IV-1)
                  OK = .TRUE.
                  GOTO 290
                ENDIF
 261         CONTINUE
             IF (.NOT.OK) THEN
C             no more event on this $PTS , read next $PTS
                IVMAX = 0
                GOTO 210
             ENDIF
          ENDIF
        ENDIF
C
C      end of BATCH or INTE mode in EDIR ..........
       ENDIF
C
 290    CONTINUE
C         event record, run record, other record :
        IF (IEVT .NE. 0)  THEN
C          event record
           IRET = 1
        ELSE
           IF (IRUN .NE. 0)  THEN
C         run record
              IRET = 2
           ELSE
C         other record : goto test MASK
              IRET = 3
           ENDIF
        ENDIF
C
        NREC = IABS(IW(JPTS+IV-3))
      GOTO 900
C ------------------------------------------------------------
C       Read error on event directory :
  812 IRET = 12
      GOTO 900
C       EOF on event directory
  813 IRET = 4
 900  CONTINUE
      END