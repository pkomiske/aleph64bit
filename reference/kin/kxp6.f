      SUBROUTINE KXP6CO(LUPAR)
C -----------------------------------------------------------------
C - Modified for Pythia 6.1
C                           B.Bloch   - 980112
C - Modified November 2000 to allow usage of NREF cards : ie give
C   the proper offset to MDM1 cards concerned and proper KF code when
C   modified from verion 7.3x to 6.1y
C
C! Set LUND parameters by data cards
CKEY KINE KINGAL LUND7 DECAY  /  USER INTERNAL
C  Every PYTHIA parameter is a BOS data card keyword,the index of
C  the parameter is the bank number.
C
C  the list of keywords with their format is given below:
C
C 'MSTU'(I),'PARU'(F),'MSTJ'(I),'PARJ'(F),
C 'KCH1'(I),'KCH2'(I),'KCH3'(I),'KCH4'(I),
C 'PMA1'(F),'PMA2'(F),'PMA3'(F),'PMA4'(F),
C 'PARF'(F),'CHA1'(I),'CHA2'(I),
C 'MDC1'(I),'MDC2'(I),'MDC3'(I),'MDM1'(I),'MDM2'(I),'BRAT'(F),
C 'KFD1'(I),'KFD2'(I),'KFD3'(I),'KFD4'(I),'KFD5'(I),
C 'MSEL'(I),'MSUB'(I),'CKIN'(F),'MSTP'(I),'PARP'(F),
C 'MSTI'(I),'PARI'(F),'IMSS'(I),'RMSS'(F)
C
C
C    KEY  i  /  ival     ====>  KEY(i)=ival
C    RKEY i  /  value    ====>  RKEY(i)=value
C
C - structure: SUBROUTINE subprogram
C              User Entry Name: KXP6CO
C              External References: NAMIND/BKFMT/BLIST(BOS77)
C                                   KXP6BR (this Lib)
C              Comdecks referenced: BCS,LUNDCOM
C
C - usage    : CALL KXP6CO(LUPAR)
C - input    : LUPAR=No. of read data cards
C
C  Note that, if a particle mass(PMA1), width(PMA2) or life-time(PMA4)
C  is modified, the PART bank entry is changed accordingly.
C
C#ifndef DOC
C#include "pyt6com.h"
C...Double precision and integer declarations.
      IMPLICIT DOUBLE PRECISION(A-H, O-Z)
      INTEGER PYK,PYCHGE,PYCOMP
C...Commonblocks.
      PARAMETER (L1MST=200, L1PAR=200)
      PARAMETER (L2PAR=500, L2PARF=2000 )
      PARAMETER (LJNPAR=4000)

      COMMON/PYJETS/N7LU,NPAD,K7LU(LJNPAR,5),P7LU(LJNPAR,5),
     $              V7LU(LJNPAR,5)
      COMMON/PYDAT1/MSTU(L1MST),PARU(L1PAR),MSTJ(L1MST),PARJ(L1PAR)
      COMMON/PYDAT2/KCHG(L2PAR,4),PMAS(L2PAR,4),PARF(L2PARF),VCKM(4,4)
      COMMON /PYDAT3/MDCY(L2PAR,3),MDME(LJNPAR,2),BRAT(LJNPAR),
     &               KFDP(LJNPAR,5)
      COMMON/PYDAT4/CHAF(L2PAR,2)
      CHARACTER CHAF*16
C
      COMMON/PYSUBS/MSEL,MSELPD,MSUB(500),KFIN(2,-40:40),CKIN(200)
      COMMON/PYPARS/MSTP(200),PARP(200),MSTI(200),PARI(200)
      COMMON/PYINT1/MINT(400),VINT(400)
      COMMON/PYINT2/ISET(500),KFPR(500,2),COEF(500,20),ICOL(40,4,2)
      COMMON/PYINT3/XSFX(2,-40:40),ISIG(1000,3),SIGH(1000)
      COMMON/PYINT4/MWID(500),WIDS(500,5)
      COMMON/PYINT5/NGENPD,NGEN(0:500,3),XSEC(0:500,3)
      COMMON/PYINT6/PROC(0:500)
      CHARACTER PROC*28
      COMMON/PYMSSM/IMSS(0:99),RMSS(0:99)

      SAVE /PYJETS/
      SAVE /PYDAT1/,/PYDAT2/,/PYDAT3/,/PYDAT4/,/PYSUBS/,
     &/PYPARS/,/PYINT1/,/PYINT2/,/PYINT3/,/PYINT4/,/PYINT5/,
     &/PYINT6/,/PYMSSM/
C
C#include "bcs.h"
*CD bcs
      INTEGER LMHLEN, LMHCOL, LMHROW
      PARAMETER (LMHLEN=2, LMHCOL=1, LMHROW=2)
C
      COMMON /BCS/   IW(1000)
      INTEGER IW
      REAL RW(1000)
      EQUIVALENCE (RW(1),IW(1))
C
      LOGICAL LREF
      PARAMETER (JMIN=144,JMAX=191)    ! This is MDM(j,1) gamma,Z0,W+-
      LOGICAL OLDKF
      PARAMETER (KFOPSIP=30443 ,KFOUPSP=30553) ! new codes offset by 70000
C
      PARAMETER (LKEYS=35)
      CHARACTER*4 KEY(LKEYS),CHAINT
      CHARACTER*1 FMT(LKEYS)
      DATA KEY / 'MSTU','PARU','MSTJ','PARJ',
     &           'KCH1','KCH2','KCH3','KCH4',
     &           'PMA1','PMA2','PMA3','PMA4',
     &           'PARF',       'CHA1','CHA2',
     &           'MDC1','MDC2','MDC3','MDM1',
     &           'MDM2','BRAT','KFD1','KFD2',
     +           'KFD3','KFD4','KFD5','MSEL',
     $           'MSUB','CKIN','MSTP','PARP',
     &           'MSTI','PARI','IMSS','RMSS'/
      DATA FMT /'I','F','I','F',
     &          'I','I','I','I',
     &          'F','F','F','F',
     &          'I',    'I','I',
     &          'I','F','I','I',
     &          'I','I','I','I',
     &          'I','I','I','I',
     &          'I','F','I','I',
     &          'I','F','I','F'/
      DATA NAPAR/0/
      OLDKF(k) = (k.eq.KFOPSIP).or.(k.eq.KFOUPSP)
C --------------------------------------------------
      IF (NAPAR .EQ. 0) NAPAR = NAMIND ('PART')
      LUPAR=0
      iut = iw(6)
C look if NREF card was there
      LREF = IW(NAMIND('KREF')).GT.0
      WRITE(iut,1)
 1    FORMAT(//
     .20X,' YOU ARE RUNNING PYTHIA 6.1 INSIDE THE                 '//
     .20X,'     K I N G A L  - PACKAGE                            '//
     .20X,'      for commentS  SEND MAIL TO :                     '/
     .20X,'         Brigitte.BLOCH@cern.ch                        '//
     .20X,'                                                       '/
     .15X,'-------------------------------------------------------'///
     .20X,' You set up the following PYTHIA parameters            '//)
 2    FORMAT(20X,' KEY : ',A4,'  =  ',I8)
 3    FORMAT(20X,' KEY : ',A4,'  =  ',F8.4)
 4    FORMAT(20X,' KEY : ',A4,'(',I3,')  =  ',I8)
 5    FORMAT(20X,' KEY : ',A4,'(',I8,')  =  ',E10.4)
 6    FORMAT(20X,' KEY : ',A4,'(',I3,')  =  ',A4)
      DO 150 I=1,LKEYS
         NAMI=NAMIND(KEY(I))
         IF (IW(NAMI).EQ.0) GOTO 150
         KIND=NAMI+1
   15    KIND=IW(KIND-1)
         IF (KIND.EQ.0) GOTO 149
         LUPAR = LUPAR+1
         J = IW(KIND-2)
C Look for old psi' and Upsilon' codes
         ioff =0
         If (oldkf(j)) ioff = 70000
C NREF was there , offset if neccessary
         joff = 0
         IF (LREF.and.(j.ge.JMIN).and.(j.le.jmax)) joff =18
         GOTO (21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,
     +37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55) I
   21    MSTU(J) = IW(KIND+1)
         WRITE(iut,4)KEY(I),J,MSTU(J)
       GOTO 15
   22    PARU(J) = RW(KIND+1)
         WRITE(iut,5)KEY(I),J,PARU(J)
       GOTO 15
   23    MSTJ(J) = IW(KIND+1)
         WRITE(iut,4)KEY(I),J,MSTJ(J)
       GOTO 15
   24    PARJ(J) = RW(KIND+1)
         WRITE(iut,5)KEY(I),J,PARJ(J)
       GOTO 15
   25    KC = PYCOMP(J)
         KCHG(KC,1) = IW(KIND+1)
         WRITE(iut,4)KEY(I),J,KCHG(KC,1)
       GOTO 15
   26    KC = PYCOMP(J)
         KCHG(KC,2) = IW(KIND+1)
         WRITE(iut,4)KEY(I),J,KCHG(KC,2)
       GOTO 15
   27    KC = PYCOMP(J)
         KCHG(KC,3) = IW(KIND+1)
         WRITE(iut,4)KEY(I),J,KCHG(KC,3)
       GOTO  15
   28    KC = PYCOMP(J)
         KCHG(KC,4) = IW(KIND+1)
         WRITE(iut,4)KEY(I),J,KCHG(KC,4)
       GOTO  15
   29    KC = PYCOMP(J+ioff)
         PMAS(KC,1) = RW(KIND+1)
         IOF = 6
         WRITE(iut,5)KEY(I),J+ioff,PMAS(KC,1)
       GOTO 115
   30    KC = PYCOMP(J+ioff)
         PMAS(KC,2) = RW(KIND+1)
         IOF = 9
         WRITE(iut,5)KEY(I),J+ioff,PMAS(KC,2)
       GOTO 115
   31    KC = PYCOMP(J+ioff)
         PMAS(KC,3) = RW(KIND+1)
         WRITE(iut,5)KEY(I),J+ioff,PMAS(KC,3)
       GOTO 15
   32    KC = PYCOMP(J+ioff)
         PMAS(KC,4) = RW(KIND+1)/3.33E-12
         IOF = 8
         WRITE(iut,5)KEY(I),J+ioff,PMAS(KC,4)
       GOTO 115
   33    PARF(J) = RW(KIND+1)
         WRITE(iut,5)KEY(I),J,PARF(j)
       GOTO 15
   34    KC = PYCOMP(J)
         CHAF(KC,1) = CHAINT(IW(KIND+1))
         WRITE(iut,6)KEY(I),J,CHAF(KC,1)
       GOTO 15
   35    KC = PYCOMP(J)
         CHAF(KC,2) = CHAINT(IW(KIND+1))
         WRITE(iut,6)KEY(I),J,CHAF(KC,2)
       GOTO 15
   36    KC = PYCOMP(J)
         MDCY(KC,1) = IW(KIND+1)
         WRITE(iut,4)KEY(I),J,MDCY(KC,1)
       GOTO 15
   37    KC = PYCOMP(J)
         MDCY(KC,2) = IW(KIND+1)
         WRITE(iut,4)KEY(I),J,MDCY(KC,2)
       GOTO 15
   38    KC = PYCOMP(J)
         MDCY(KC,3) = IW(KIND+1)
         WRITE(iut,4)KEY(I),J,MDCY(KC,3)
       GOTO 15
   39    MDME(J+joff,1) = IW(KIND+1)
         WRITE(iut,4)KEY(I),J+joff,MDME(J+joff,1)
       GOTO 15
   40    MDME(J+joff,2) = IW(KIND+1)
         WRITE(iut,4)KEY(I),J+joff,MDME(J+off,2)
       GOTO 15
   41    BRAT(J) = RW(KIND+1)
         WRITE(iut,5)KEY(I),J,BRAT(j)
       GOTO 15
   42    KFDP(J,1) = IW(KIND+1)
         WRITE(iut,4)KEY(I),J,KFDP(j,1)
       GOTO 15
   43    KFDP(J,2) = IW(KIND+1)
         WRITE(iut,4)KEY(I),J,KFDP(j,2)
       GOTO 15
   44    KFDP(J,3) = IW(KIND+1)
         WRITE(iut,4)KEY(I),J,KFDP(j,3)
       GOTO 15
   45    KFDP(J,4) = IW(KIND+1)
         WRITE(iut,4)KEY(I),J,KFDP(j,4)
       GOTO 15
   46    KFDP(J,5) = IW(KIND+1)
         WRITE(iut,4)KEY(I),J,KFDP(j,5)
       GOTO 15
   47    MSEL = IW(KIND+1)
         WRITE(iut,2)KEY(I),MSEL
       GOTO 15
   48    MSUB(J) = IW(KIND+1)
         WRITE(iut,4)KEY(I),J,MSUB(J)
       GOTO 15
   49    CKIN(J) = RW(KIND+1)
         WRITE(iut,5)KEY(I),J,CKIN(J)
       GOTO 15
   50    MSTP(J) = IW(KIND+1)
         WRITE(iut,4)KEY(I),J,MSTP(J)
       GOTO 15
   51    PARP(J) = RW(KIND+1)
         WRITE(iut,5)KEY(I),J,PARP(J)
       GOTO 15
   52    MSTI(J) = IW(KIND+1)
         WRITE(iut,4)KEY(I),J,MSTI(J)
       GOTO 15
   53    PARI(J) = RW(KIND+1)
         WRITE(iut,5)KEY(I),J,PARI(J)
       GOTO 15
   54    IMSS(J) = IW(KIND+1)
         WRITE(iut,4)KEY(I),J,IMSS(J)
       GOTO 15
   55    RMSS(J) = RW(KIND+1)
         WRITE(iut,5)KEY(I),J,RMSS(J)
       GOTO 15
 149  CONTINUE
         CALL BKFMT (KEY(I),FMT(I))
         CALL BLIST (IW,'C+',KEY(I))
       GOTO 150
 115  CONTINUE
      IPART = KGPART(J)
      JPART = IW(NAPAR)
      IF (IPART.GT.0) THEN
        RW(JPART+LMHLEN+(IPART-1)*IW(JPART+1)+IOF)= RW(KIND+1)
        IANTI = IW(JPART+LMHLEN+(IPART-1)*IW(JPART+1)+10)
        IF (IANTI.NE.IPART) RW(JPART+LMHLEN+(IANTI-1)*IW(JPART+1)+IOF)=
     $                      RW(KIND+1)
      ENDIF
      GOTO 15
 150  CONTINUE
      WRITE(iut,7)
 7    FORMAT(/,/,15X,
     .'--------------------------------------------------------'//)

C
C      Look for more modifications of decay parameters
C
      CALL KXP6BR
      RETURN
      END
C#endif
      SUBROUTINE KXP6BR
C------------------------------------------------------------------
C          B.Bloch-Devaux -980112
C! Modify decay scheme inside PYTHIA 6.1 for requested particles
CKEY KINE KINGAL LUND7 DECAY  /  INTERNAL
C  Bos data cards are used with the following convention:
C  GADM : define new decay channel for given particle in LUND
C  GRPL : replace a final state by another one
C  GMOB : defines the branching ratios of a LUND particle
C
C  GADM KF MXEL KDP1 KDP2 KDP3 KDP4  KDP5
C       KF Refers to the Lund7 particle code
C       MXEL is the matrix element to be used for that decay
C       KDP1-KDP5 Refer to the lund7 code of the 5 particles final state
C        to be added at the end of the list of decay modes.
C       (if less than 5 particles needed, fill others with 0  )
C        include matrix element code in MXEL, if MXEL=101  5 more
C        positions can be filled for the same decay chain
C  GRPL KF  II  MSWI  MXEL KDP1 KDP2 KDP3 KDP4  KDP5
C       KF Refers to the Lund particle code
C       II Refers to the decay mode number in the list for particle KF
C       MSWI is the switch to be used for that decay ( 0,-1,1,....5)
C       MXEL is the matrix element to be used for that decay
C       KDP1-KDP5 Refer to the lund code of the 5 particles final state
C       (if less than 5 particles needed, fill others with 0  )
C  GMOB KF  BR(1)..................BR(n)
C       KF Refers to the Lund particle code
C       BR(1)...BR(n) are the non-cumulated branching fractions
C       of the n decay modes defined for particle KF
C
C  you may have as many GADM as you want as long as you do not overfill
C  the PYDAT3 array (dimension 2000)otherwise an error message is issued
C  and the process is stopped.
C  NOTE: all GADM cards with the same KF must follow each other !!
C ------
C  GRPL cards are treated in sequence as they appear.
C  GMOB cards should define as many Branching fractions as decay modes
C  including those added through GADM cards.If not, a message is issued
C  and no modification is done.When modified a printout of the resulting
C  decay modes and branching ratios for the particle is issued.
C
C - Modified B.Bloch November 2000 : to allow usage of NREF cards ...
C   one must check the KF codes which have changed (Psi' and Upsilon')
C   from 30443/30553 to 100443/100553)
C
C - structure : SUBROUTINE
C               User entry name :KXP6BR
C               External references:NAMIND/BKFMT/BLIST(BOS77)
C                                   KXP6ST( this library)
C                                   PYCOMP(Pythia 6.1)
C               Comdecks refenced :BCS,LUN7COM
C
C - usage : CALL KXP6BR
C------------------------------------------------------------------
C#ifndef DOC
C#include "pyt6com.h"
C...Double precision and integer declarations.
      IMPLICIT DOUBLE PRECISION(A-H, O-Z)
      INTEGER PYK,PYCHGE,PYCOMP
C...Commonblocks.
      PARAMETER (L1MST=200, L1PAR=200)
      PARAMETER (L2PAR=500, L2PARF=2000 )
      PARAMETER (LJNPAR=4000)

      COMMON/PYJETS/N7LU,NPAD,K7LU(LJNPAR,5),P7LU(LJNPAR,5),
     $              V7LU(LJNPAR,5)
      COMMON/PYDAT1/MSTU(L1MST),PARU(L1PAR),MSTJ(L1MST),PARJ(L1PAR)
      COMMON/PYDAT2/KCHG(L2PAR,4),PMAS(L2PAR,4),PARF(L2PARF),VCKM(4,4)
      COMMON /PYDAT3/MDCY(L2PAR,3),MDME(LJNPAR,2),BRAT(LJNPAR),
     &               KFDP(LJNPAR,5)
      COMMON/PYDAT4/CHAF(L2PAR,2)
      CHARACTER CHAF*16
C
      COMMON/PYSUBS/MSEL,MSELPD,MSUB(500),KFIN(2,-40:40),CKIN(200)
      COMMON/PYPARS/MSTP(200),PARP(200),MSTI(200),PARI(200)
      COMMON/PYINT1/MINT(400),VINT(400)
      COMMON/PYINT2/ISET(500),KFPR(500,2),COEF(500,20),ICOL(40,4,2)
      COMMON/PYINT3/XSFX(2,-40:40),ISIG(1000,3),SIGH(1000)
      COMMON/PYINT4/MWID(500),WIDS(500,5)
      COMMON/PYINT5/NGENPD,NGEN(0:500,3),XSEC(0:500,3)
      COMMON/PYINT6/PROC(0:500)
      CHARACTER PROC*28
      COMMON/PYMSSM/IMSS(0:99),RMSS(0:99)

      SAVE /PYJETS/
      SAVE /PYDAT1/,/PYDAT2/,/PYDAT3/,/PYDAT4/,/PYSUBS/,
     &/PYPARS/,/PYINT1/,/PYINT2/,/PYINT3/,/PYINT4/,/PYINT5/,
     &/PYINT6/,/PYMSSM/
C
C#include "bcs.h"
*CD bcs
      INTEGER LMHLEN, LMHCOL, LMHROW
      PARAMETER (LMHLEN=2, LMHCOL=1, LMHROW=2)
C
      COMMON /BCS/   IW(1000)
      INTEGER IW
      REAL RW(1000)
      EQUIVALENCE (RW(1),IW(1))
C
      LOGICAL OLDKF
      PARAMETER (KFOPSIP=30443 ,KFOUPSP=30553) ! new codes offset by 70000
      OLDKF(k) = (k.eq.KFOPSIP).or.(k.eq.KFOUPSP)
C ----------------------------------------------------------------
      DATA NKF0/-1/
      NAMI =NAMIND('GADM')
      IF (IW(NAMI ).EQ.0) GO TO 96
      JGADM=NAMI +1
 100  JGADM=IW(JGADM-1)
      IF(JGADM.EQ.0) GOTO 97
C
C Create a new line in the original LUND particle data table
C for the particule NKF1 after copying the existing ones at the end of
C the array
C
      NKF1=IW(JGADM+1)
C look for changes
      INKF = NKF1
      ioff =0
      If (oldkf(inkf)) ioff = 70000
      nkf1 = nkf1+ioff
C  get compressed code  for particle
      KC = PYCOMP(NKF1)
      IF ( KC.GT.0) THEN
         NOLD = MDCY(KC,3)
C  Find a new free location to translate the decay tables
         IF (NKF1.NE.NKF0) THEN
            NKF0 = NKF1
            DO 200 K=LJNPAR,1,-1
            DO 300 J = 1,5
               IF(KFDP(K,J).NE.0 )GO TO 400
  300       CONTINUE
  200       CONTINUE
            GO TO 1000
  400       IFREE = K+1
C   copy old modes to the new location
            IOLD = MDCY(KC,2)
            IF(NOLD.GT.0 .AND. IOLD.GT.0) THEN
               DO 401 J=1,NOLD
                  BRAT(IFREE+J-1)=BRAT(IOLD+J-1)
                  MDME(IFREE+J-1,1)=MDME(IOLD+J-1,1)
                  MDME(IFREE+J-1,2)=MDME(IOLD+J-1,2)
                  DO 402 K=1,5
                     KFDP(IFREE+J-1,K)=KFDP(IOLD+J-1,K)
  402             CONTINUE
  401          CONTINUE
            ENDIF
C   Update with new mode
            MDCY(KC,1) = 1
            MDCY(KC,2) = IFREE
         ENDIF
         MDCY(KC,3) = NOLD+1
C
C define the final state of the new entry
C
         MDME(IFREE+NOLD,1)= 1
         MDME(IFREE+NOLD,2)= IW(JGADM+2)
         DO J = 1,5
C look for changes
            INKF = IW(JGADM+2+J)
            ioff =0
            If (oldkf(inkf)) ioff = 70000
            IW(JGADM+2+J) = IW(JGADM+2+J) +ioff
C
            KFDP(IFREE+NOLD,J)= IW(JGADM+2+J)
         ENDDO
         MSTU(20) = 0
      ENDIF
      GOTO 100
 97   CONTINUE
C store the card on the C list
      CALL BKFMT('GADM','I')
      CALL BLIST(IW,'C+','GADM')
  96  CONTINUE
      NAMI =NAMIND('GRPL')
      IF (IW(NAMI ).EQ.0) GO TO 94
      JGRPL=NAMI +1
C
C Replace decay mode by a new definition
C
 102  JGRPL=IW(JGRPL-1)
      IF(JGRPL.EQ.0)GOTO 99
      NKF3=IW(JGRPL+1)
C look for changes
      INKF = NKF3
      ioff =0
      If (oldkf(inkf)) ioff = 70000
      nkf3 = nkf3 + ioff
C  get compressed code  for particle
      KC = PYCOMP(NKF3)
      IF ( KC.GT.0) THEN
        NBR = MDCY(KC,3)
        IK = IW(JGRPL+2)
        IF ( IK .GT. NBR) THEN
          IF (IW(6).GT.0) WRITE(IW(6),1001) IK,NBR
 1001       FORMAT('===KXP6BR ====you try to modify a non existant',
     $       ' line',I8,' maximum is ',I10)
          GO TO 102
        ENDIF
        IENTRY = MDCY(KC,2)+IK-1
C
C replace final state IK by another one for the particle NKF3
C
        MDME(IENTRY,1) = IW(JGRPL+3)
        MDME(IENTRY,2) = IW(JGRPL+4)
        DO 110 J= 1,5
C look for changes
          INKF = IW(JGRPL+4+J)
          ioff =0
          If (oldkf(inkf)) ioff = 70000
          IW(JGRPL+4+J) = IW(JGRPL+4+J) + ioff
          KFDP(IENTRY,J)=IW(JGRPL+4+J)
 110    CONTINUE
      ENDIF
      GOTO 102
   99 CONTINUE
C store the card on the C list
      CALL BKFMT('GRPL','I')
      CALL BLIST(IW,'C+','GRPL')
  94  CONTINUE
C
C  Update the individual branching ratios
C
      NAMI =NAMIND('GMOB')
      IF (IW(NAMI ).EQ.0) GO TO 95
      JGMOB=NAMI +1
 101  JGMOB=IW(JGMOB-1)
      IF(JGMOB.EQ.0)GOTO 98
C define the branching ratios of the particle NKF2
      NKF2=IW(JGMOB+1)
C look for changes
      INKF = NKF2
      ioff =0
      If (oldkf(inkf)) ioff = 70000
      nkf2 = nkf2+ioff
C  get compressed code  for particle
      KC = PYCOMP(NKF2)
      IF ( KC.GT.0) THEN
        NBR = MDCY(KC,3)
        IF ( NBR .NE. IW(JGMOB)-1) THEN
          IF (IW(6).GT.0) WRITE(IW(6),1002) NFK2,NBR
 1002        FORMAT('===KXP6BR ==== BR numbers do not agree for',
     $           ' part ',I8,' should be ',I10)
          GO TO 101
        ENDIF
        IENTRY = MDCY(KC,2)
        DO 500 JJ=1,NBR
            BRAT(IENTRY+JJ-1)=RW(JGMOB+1+JJ)
 500    CONTINUE
        CALL KXP6ST(NKF2)
      ENDIF
      GOTO 101
 98   CONTINUE
C store the card on the C list
      CALL BKFMT('GMOB','I,(F)')
      CALL BLIST(IW,'C+','GMOB')
  95  CONTINUE
      RETURN
 1000 IF (IW(6).GT.0) WRITE (IW(6),550) NKF1,K
  550 FORMAT(1X,'++++++KXP6BR+++++++ cannot extend decay list for',
     $ ' particle',I10,'Pointer MDCE was',I10)
      END
C#endif
      SUBROUTINE PYTAUD(ITAU,IORIG,KFORIG,NDECAY)
C dummy routine for now ... will be updated later, just use
C standard Tau decays from Pythia without polarization options
C...Double precision and integer declarations.
      IMPLICIT DOUBLE PRECISION(A-H, O-Z)
      PARAMETER (L1MST=200, L1PAR=200)
      COMMON/PYDAT1/MSTU(L1MST),PARU(L1PAR),MSTJ(L1MST),PARJ(L1PAR)
      MSTJ(28) = 0
      RETURN
      END