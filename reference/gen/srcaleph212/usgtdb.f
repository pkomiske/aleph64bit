      INTEGER FUNCTION USGTDB(LBASE,LIST,IRUN)
C -------------------------------------------------------------
C! USER routine to get a list of data base banks
C - F.Ranjard - 890802
C - modified by F.Ranjard - 891001
CKEY DAF DBASE / USER
C
C  Input  :   LBASE = data base logical unit
C             LIST  = list of banks names to be accessed from data base
C                     single name or list of names
C             IRUN  = current run number
C
C  Ouput : USGTDB = > 0  if existing bank(s) are still valid
C                   = 0  if error occurs ( no valid bank found)
C                   < 0  if one or more existing banks were reloaded
C
C  Called by : ALGTDB, AGETDB when a UDAF data card is encountered
C
C ============= FALCON I version of USGTDB =======================
C
C  reads the DAF in the following way:
C  This routine assumes that ONLY 1 RUN is executed at a time
C  that means that if a bank NAME exists when entering the routine
C  it must be used, otherwise get it from data base.
C
C     IF a bank exists (read from data cards or from tape) THEN
C        it is taken in priority.
C     ELSE
C        valid bank is read from the data base
C     ENDIF
C
C - ENTRY point USGTD1 (INEW)
C   input argument : INEW   / INTE = data card bank number
C   output         : USGTD1 / INTE = previous data card bank number
C   data base bank  given on data cards have the bank number INEW
C--------------------------------------------------------------
      CHARACTER*(*)  LIST,NAME*4
      INTEGER LMHLEN, LMHCOL, LMHROW
      PARAMETER (LMHLEN=2, LMHCOL=1, LMHROW=2)
C
      COMMON /BCS/   IW(1000)
      INTEGER IW
      REAL RW(1000)
      EQUIVALENCE (RW(1),IW(1))
C
      INTEGER USGTD1
      DATA NRDC /-1/
C ----------------------------------------------------------------------
C
      ISTAT=1
      IOLD=1
C                     Analyse list of Banks
      IMAX = (LNBLNK(LIST)+3)/4
      I=0
  2   I=I+1
      IF (I.LE.IMAX) THEN
         NAME=LIST((I-1)*4+1:I*4)
C
C     take the bank if already there
         IND = IW(NAMIND(NAME))
         IF (IND .NE. 0) THEN
            IOLD = -1
         ELSE
C     otherwise get it from the data base
C     get the bank# valid for run# IRUN
            NEW = NDANR (LBASE,NAME,'LE',IRUN)
C     if there is a valid bank then load it
            IF (NEW .NE. 0) THEN
               IND = MDARD (IW,LBASE,NAME,NEW)
               IOLD=-1
            ELSE
               ISTAT = 0
            ENDIF
         ENDIF
C
C     get next bank name in the list
         GO TO 2
      ENDIF
C
      USGTDB=ISTAT*IOLD
      RETURN
C
C - entry point to reset the data card bank number NRDC
C   which is not used in the present version
C   this FUNCTION is called by ADBSWP after reading data cards
C
      ENTRY USGTD1 (INEW)
      USGTD1 = NRDC
      NRDC = INEW
      RETURN
C
      END