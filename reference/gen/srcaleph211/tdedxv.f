      SUBROUTINE TDEDXV(GGNR,SSNR,IER)
C----------------------------------------------------------------------
C!  Get Tpc De/Dx global normalisation constant
CKEY  DEDX TPC  / INTERNAL
C   Author   :- W. Wiedenmann         31-Aug-1993
C   modified by : F.Ranjard - 931217
C   modified by : J.Nachtman, F.Ranjard - 950803
C   modified by : J.Nachtman - 951106
C   Outputs:
C        - GGNR        / R     Global Normalisation Constant
C        - SSNR        / R     Sector to sector Normalisation Constants
C        - IER         / I     Error Code
C                               0 : OK
C                               1 : no calibration available
C                                   or other inconsistency
C
C   Description
C   ===========
C   the run# is got from ABRUEV
C   IF run# >= 40000 THEN  (140Gev runs and above)
C      The global De/Dx normalisation factor is calculated
C      using a parametrization given in TCPX bank.
C      The sector De/Dx normalisation factor is taken from
C      the TCSX bank and maybe modified by the TPHV bank.
C   ELSEIF run# >= 20000 THEN
C      The global/sector De/Dx normalisation is taken from
C      the TCGX/TCSX bank for the present run IRUN.
C   ELSE
C      the TC2X bank is used.
C   ENDIF
C   If no calibration is available or an error occures
C   IER=1, GGNR=0., SSNR=0. are returned.
C
C    ENTRY points
C    ============
C    ENTRY TDEDXR (JRUN,GGNR,SSNR,IER)
C    to input the run number.
C    Input:
C       - JRUN   /I   run number for which dedx calibration is
C                        required.
C
C======================================================================
      SAVE
      INTEGER LMHLEN, LMHCOL, LMHROW
      PARAMETER (LMHLEN=2, LMHCOL=1, LMHROW=2)
C
      COMMON /BCS/   IW(1000)
      INTEGER IW
      REAL RW(1000)
      EQUIVALENCE (RW(1),IW(1))
C
      INTEGER JTCPFR,JTCPLR,JTCPP1,JTCPP2,LTCPXA
      PARAMETER(JTCPFR=1,JTCPLR=2,JTCPP1=3,JTCPP2=4,LTCPXA=4)
      INTEGER JTPHFR,JTPHLR,JTPHP1,JTPHP2,LTPHVA
      PARAMETER(JTPHFR=1,JTPHLR=2,JTPHP1=3,JTPHP2=4,LTPHVA=4)
      PARAMETER(JTCGFR=1,JTCGLR=2,JTCGNR=3,LTCGXA=3)
      PARAMETER(JTCSSN=1,LTCSXA=36)
      PARAMETER(JTC2ID=1,JTC2VR=2,JTC2NR=4,JTC2SN=5,JTC2AP=41,JTC2RP=42,
     +          JTC2SL=46,LTC2XA=46)
      PARAMETER (LTPDRO=21,LTTROW=19,LTSROW=12,LTWIRE=200,LTSTYP=3,
     +           LTSLOT=12,LTCORN=6,LTSECT=LTSLOT*LTSTYP,LTTPAD=4,
     +           LMXPDR=150,LTTSRW=11)
      INTEGER ALGTDB,GTSTUP,NAMERU
      CHARACTER  DET*2
      PARAMETER (DET='TP')
      DIMENSION SNR(LTSECT), SSNR(LTSECT)
      LOGICAL FIRST
      DATA FIRST /.TRUE./
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
C======================================================================
C
C+++ Get current run number
C
      CALL ABRUEV (KRUN,KEVT)
      IRUN = KRUN
C
C - 1st entry
   10 CONTINUE
      IF (FIRST) THEN
        NATCSX = NAMIND('TCSX')
        NATC2X = NAMIND('TC2X')
        NATSSR = NAMIND('TSSR')
        FIRST = .FALSE.
        ILAST = 0
        ISTATUS = 1
      ENDIF
C
C+++ new run
C
      IF (IRUN.NE.ILAST) THEN
        ILAST = IRUN
C
C----------------------------------------------------------------------
C  If run>=40000 Look for TCPX/TPHV/TCSX on Daf and TSSR on run record
C  If run>=20000 Look for TCGX/TCSX on Daf
C  If run< 20000 Look for TC2X  on Daf
C
C----------------------------------------------------------------------
C
        ISTATUS = 0
        GNR = 0.
        DO IS=1,LTSECT
          SNR(IS) = 0.
        ENDDO
C
        IF (IRUN .GE. 40000) THEN
C
C+++ For high energy (>140Gev) runs get presure and HV from TSSR
C    SOR record
          JTSSR = IW(NATSSR)
          K4HV  = 0
          K7PR  = 0
          IF (JTSSR.NE.0) THEN
             KTSSR = JTSSR+LMHLEN
 20          IF (KTSSR.LT.KNEXT(JTSSR)) THEN
C             Get HV from hardware4 after current
C             Get gas pressure from hardware7
                IHW = IW(KTSSR+1)
                NHW = IW(KTSSR+2)
                IF (IHW.EQ.4) THEN
                   K4HV = KTSSR+2+LTSECT
                ELSEIF (IHW.EQ.7) THEN
                   K7PR = KTSSR+2
                ENDIF
                IF (K4HV.EQ.0 .OR.K7PR.EQ.0) THEN
                   KTSSR = KTSSR+2+NHW
                   GOTO 20
                ENDIF
             ENDIF
          ENDIF
C
          IF (K4HV.EQ.0 .OR. K7PR.EQ.0) THEN
             ISTATUS = 1
             GOTO 999
          ELSE
C          Check the gas pressure, take the 1st one (in reverse order)
C          with a reasonable value.
             DO I=3,1,-1
                IPRESS = IW(K7PR+I)
                IF (IPRESS.GT.9350 .AND. IPRESS.LT.10000) GOTO 30
             ENDDO
             ISTATUS =1
             GOTO 999
          ENDIF
 30       CONTINUE
C
C+++ For high energy (>140Gev) runs get TCPX, TCSX and TPHV row #
C    for this run from daf
C
          IRET = ALGTDB(JUNIDB(0),'TCSX',-IRUN)
          JTCSX = IW(NATCSX)
          JTCPX = NAMERU ('TCPX',IRUN,JTCPFR,IROW)
          JTCPX = ABS(JTCPX)
          JTPHV = NAMERU ('TPHV',IRUN,JTPHFR,JROW)
          JTPHV = ABS(JTPHV)

          IF ((JTCPX.GT.0).AND.(IROW.GT.0) .AND.
     &        (JTCSX.GT.0).AND.
     &        (JTPHV.GT.0).AND.(JROW.GT.0) ) THEN
C
C+++        run exists in TCPX/TCSX/TPHV,
C
C+++        take global pressure corrections and sector high voltage
C           corrections from TCPX and TPHV
C
            GNR1 = RTABL(JTCPX,IROW,JTCPP1)
            GNR2 = RTABL(JTCPX,IROW,JTCPP2)

            SNR1 = RTABL(JTPHV,IROW,JTPHP1)
            SNR2 = RTABL(JTPHV,IROW,JTPHP2)
C
C+++        apply corrections for pressure dependence
C
            TPPRES = ALOG(REAL(IPRESS))
            GNR = GNR1 - GNR2*TPPRES
            GNR = 1./EXP(GNR)
C
C+++        apply corrections for high voltage dependence
C           The nominal tpc HV is 1250 volts, so 1000 is chosen
C           as an extreme lower limit for a reasonable value, and
C           1300 as an upper limit, to check that the TSSR bank contains
C           reasonable values for sector voltages. The normal fluctuatio
C           in sector voltages and measurements are <5 volts, so if the
C           voltage is within 10 volts of 1250, normal voltages are assu
C           no additional correction is applied to the TCSX sector corre
C
            DO IS=1,LTSECT
               SNR(IS) = RTABL(JTCSX,1,JTCSSN-1+IS)
               TPVOLT = REAL(IW(K4HV+IS))
               IF ((TPVOLT.GT.1000.) .AND. (TPVOLT.LT.1300.)) THEN
                 IF ((TPVOLT.LT.1240.).OR.(TPVOLT.GT.1260.)) THEN
                   HVCORR = SNR1 + SNR2*REAL(TPVOLT)
                   SNR(IS) = SNR(IS)/EXP(HVCORR)
                 ENDIF
               ELSE
                 ISTATUS = 1
                 GOTO 999
               ENDIF
            ENDDO
          ELSE
C           this run does not exist in TCPX
            ISTATUS = 1
            GOTO 999
          ENDIF
C
        ELSEIF (IRUN .GE. 20000) THEN
C
C+++ For 1993 onwards Get TCSX and TCGX row # for this run from daf
C
          IRET = ALGTDB(JUNIDB(0),'TCSX',-IRUN)
          JTCSX = IW(NATCSX)
          JTCGX = NAMERU ('TCGX',IRUN,JTCGFR,IROW)
          JTCGX = ABS(JTCGX)
          IF ((JTCGX.GT.0).AND.(IROW.GT.0).AND.(JTCSX.GT.0)) THEN
C
C+++        run exists in TCGX/TCSX, take global calibration from
C           row# IROW, and sector calibration from TCSX
C
            GNR = RTABL(JTCGX,IROW,JTCGNR)
            DO IS=1,LTSECT
               SNR(IS) = RTABL(JTCSX,1,JTCSSN-1+IS)
            ENDDO
          ELSE
C           this run does not exist in TCGX
            ISTATUS = 1
            GOTO 999
          ENDIF
C
        ELSE
C
C+++        Before 1993 and for MC get TC2X from Daf
C
          IF (IRUN.LE.2000) THEN
            ITP = GTSTUP (DET,IRUN)
          ELSE
            ITP = IRUN
          ENDIF
          IRET = ALGTDB(JUNIDB(0),'TC2X',-ITP)
          JTC2X = IW(NATC2X)
          IF ( JTC2X.GT.0 ) THEN
            IF (IRUN.LT.ITABL(JTC2X,1,JTC2VR). OR.
     &          IRUN.GT.ITABL(JTC2X,1,JTC2VR+1)) THEN
C              this run is not in the range of runs of this bank
              ISTATUS = 1
              GOTO 999
            ELSE
              GNR = RTABL(JTC2X,1,JTC2NR)
              DO IS=1,LTSECT
                SNR(IS)=RTABL(JTC2X,1,JTC2SN+IS-1)
              ENDDO
            ENDIF
          ELSE
C              this run does not exist in TC2X
            ISTATUS = 1
            GOTO 999
          ENDIF
C
        ENDIF
C
      ENDIF
C ---------------- end of new run ----------------------------------
C
C+++  same run as before or sector normalisation has been found or
C     set to 0.
C     fill output arguments
C
  999 CONTINUE
      GGNR = GNR
      DO I=1,LTSECT
        SSNR(I) = SNR(I)
      ENDDO
      IER = ISTATUS
      RETURN
C
C ------------- ENTRY point to give specific run number
C
      ENTRY TDEDXR (JRUN,GGNR,SSNR,IER)
      IRUN = JRUN
      GOTO 10
C
      END