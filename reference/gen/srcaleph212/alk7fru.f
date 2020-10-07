      INTEGER FUNCTION ALK7FRU (LURUK7,IRUN,TYPE,TAPE)
C --------------------------------------------------------
C - F.Ranjard - 900627
C! get cartridge number for a given type of a given run
CKEY ALEF TAPE  RUN / USER
C
C - Input     : LURUK7  / INTE  = open RUK7FILE.UPDATE on unit LURUK7
C               IRUN    / INTE  = run number
C               TYPE    / A     = data type
C                                 'RAW'/'POT'/'DST'/'MINI/NANO'
C
C - Output    : TAPE     / A      = tape number i.e. AS1234_98
C               ALK7FRU   / INTE  = error code
C                                 = 0  OK
C                                 = 1  cannot open RUK7FILE
C                                 = 2  file is empty
C                                 = 3  too many runs, increase K7COM
C                                 = 13 wrong data type
C                                 = 14 run does not exist
C - open RUNCARTSLIST which contains for each run the number
C   of the CERN cartridges in the order : RAW/POT/DST/MINI/NANO
C   on unit LURUK7
C   IF IRUN is in the list THEN
C      return in TAPE the cartridge number corresponding to
C      the data type wanted
C   ENDIF
C ---------------------------------------------------------
      CHARACTER*(*) TYPE,TAPE
      CHARACTER CHAINT*4
      CHARACTER*80 RUK7NAM
      INTEGER ALK7OP
C! keep content of RUNCARTS.LIST file
C! keep content of RUNCARTS.LIST file
      PARAMETER(MXLRUN=2500,MXSEG=4,MXTYP=5,LK7=9)
      INTEGER K7LRUN
C - 22500=MXLRUN*LK7 (9 characters per K7 for MXLRUN runs)
      CHARACTER*22500 K7CART
C - 5=MXTYP the number of various data types ('RPDMN')
      CHARACTER*5 K7TYPE
      COMMON/ALK7COM/ K7SEG,K7LINE(MXSEG),K7LRUN(MXLRUN,MXSEG),
     &                K7CART(MXTYP,MXSEG),K7TYPE
      DATA IFIR / 0/
C
C ------------------------------------------------------------------
C
C - at 1st entry :
C
       IF (IFIR.EQ.0) THEN
          IFIR = 1
          IER = ALK7OP(LURUK7)
          IF (IER.NE.0) GOTO 999
       ENDIF
C
C - next entry:
C
 10    CONTINUE
C    check data type
       ITYP = INDEX (K7TYPE,TYPE(1:1))
       IF (ITYP.EQ.0) THEN
          IER = 13
          GOTO 999
       ENDIF
C
C    get row # which contains run# IRUN
       DO 1 ISEG=1,K7SEG
          MSEG = ISEG
          JPOS = LOCATI (K7LRUN(1,ISEG),K7LINE(ISEG),IRUN)
          IF (JPOS.GT.0) THEN
             GOTO 20
          ELSEIF (JPOS.EQ.0) THEN
             GOTO 2
          ENDIF
 1     CONTINUE
C      The run is not there
 2     IER = 14
       GOTO 999
C
C    get tape #
 20    CONTINUE
       IC = (JPOS-1)*LK7+1
       TAPE = K7CART(ITYP,MSEG)(IC:IC+LK7-1)
       IER = 0
C
 999   CONTINUE
       ALK7FRU = IER
C
       END