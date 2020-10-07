*DK DPARAM
CH..............+++
CH
CH
CH
CH
CH
CH
CH --------------------------------------------------------------------  DPARAM
CH
      SUBROUTINE DPARAM(NGRUP,N1,N2,N3,N4,N5,N6,N7,N8,N9,N0)
CH
C     Output: N1,N2,... # of PDF,PDT,.. in DALI_##.PAR_D0
C
CH --------------------------------------------------------------------
CH
C
C      .................................. entry list of DPARAM
C      ENTRY DPAROP(NGRUP,TNAM)
C      ENTRY DPARP0
C      ENTRY DPARCH(NGRUP,T1,T2)
C      ENTRY DPARGG(NGRUP,NG1,NG2)
C      ENTRY DPAR_GET_IND(NGRUP,T1,LIND,NARR)
C      ENTRY DPARGV(NGRUP,T1,N1234,P1234)
C      ENTRY DPARGI(NGRUP,T1,IP2)
C      ENTRY DPARSV(NGRUP,T1,N1234,P1234)
C      ENTRY DPAR_TOGGLE(NGRUP,T1,N1234)
C      ENTRY DPAR_SET_CO(NGRUP,T1)
C      ENTRY DPAR_SET_WIDTH(NGRP1,T1,NGRP2,T2)
C      ENTRY DPAR_SET_TR_WIDTH
C      ENTRY DPAR_SET_SY(NGRUP,FOVER)
C      ENTRY DPACGT(NGRUP,PTO)
C      ENTRY DPACGF(NGRUP,PFR)
C      ENTRY DPACNT(NC1,NC2,PTO)
C      ENTRY DPACNF(NC1,NC2,PFR)
C      ENTRY DPARST(TFIN)
C      ENTRY DPAR_GET_HEADER(TOP1,TOPIN,THEAD,THELP,FOUND)
C      ENTRY DPAR_DSP_STR_GROUP
C      ENTRY DPAR_CHG_BY_NAME(TANSW,FOUND)
C      ENTRY DPAR_DEBUG
C      ENTRY DPAR_CHECK_DEF(TCHEK,IPAR)
C      ENTRY DPAR_CHECK_USE(TCHEK)
C
      INCLUDE 'DALI_CF.INC'
      CHARACTER *(*) TNAM,TFIN,T1,T2,THELP,THEAD,TANSW,TCHEK
C     .............................................. MGR should stop with 9
      DIMENSION PTO(2,*),PFR(2,*),NARR(*),RARR(*)
      DIMENSION PARDM(4)
      PARAMETER (MGR=129)
      DIMENSION NGR1(0:MGR),NGR2(0:MGR),NSTRT(MGR),NLIST(MGR)
      DATA NGR1(0),NGR2(0)/2*0/
      DIMENSION NDIG(MPARDA)
      LOGICAL FCHEK,FCHK1(MPARDA),FCHK2(MPARDA)
      DATA FCHK1/MPARDA*.FALSE./
      DATA FCHK2/MPARDA*.FALSE./
      CHARACTER *1 TSL
      CHARACTER *2 TPAR2(0:MPARDA),TOP1,TOP2,TOPIN
      CHARACTER *3 TPAR3(0:MPARDA),TW,THLP(MGR),TPR3M
      DATA TPAR2/'**',MPARDA*' '/,TPAR3/'***',MPARDA*' '/
      CHARACTER *4 TGRP
      CHARACTER *4 TGRUP(0:MGR)
      DATA TGRUP/'----',MGR*'....'/
      PARAMETER (MNSET=66)
      CHARACTER *2 TSET(MNSET)
      CHARACTER *40 TCOM(MGR)
      CHARACTER *80 T80
      PARAMETER (MSET=20)
      DIMENSION ISET1(0:MSET),ISET2(0:MSET)
      DATA ISET1(0)/0/,ISET2(0)/0/
CBSN  DATA NUNIDU/10/      ! In P_DALBX.FOR !!
      DATA LOLD/0/,LMAX/50/
      LOGICAL FOUND
      I2=(LENOCC(TPARDA)+1)/6
      K=NGR1(NGRUP)-1
      K2=NGR2(NGRUP)
      L=-3
      DO I=1,I2
        L=L+6
   20   K=K+1
        IF(K.GT.K2) THEN
          K=0
          IF(L.NE.LOLD) THEN
            LOLD=L
C           IF(USLVDU.GE.6.) THEN
  333         CALL DWRT(
     &          TSUBDJ//TPARDA(L:L+2)//' wrong sequence#')
C           END IF
            GO TO 20
          ELSE
C            ...............................................  TYPE ERROR
C           IF(USLVDU.GE.6.) THEN
  444         CALL DWRT(TSUBDJ//TPARDA(L:L+2)//' not found')
C           END IF
            GO TO 21
          END IF
        END IF
        IF(TPARDA(L:L+2).NE.TPAR3(K)) GO TO 20
        FCHK1(K)=.TRUE.
        GO TO(1,2,3,4,5,6,7,8,9,10),I
    1   N1=K
        GO TO 21
    2   N2=K
        GO TO 21
    3   N3=K
        GO TO 21
    4   N4=K
        GO TO 21
    5   N5=K
        GO TO 21
    6   N6=K
        GO TO 21
    7   N7=K
        GO TO 21
    8   N8=K
        GO TO 21
    9   N9=K
        GO TO 21
   10   N0=K
   21 END DO
      RETURN
CH..............---
CH
CH
CH
CH
CH
CH
CH --------------------------------------------------------------------  DPAROP
CH
      ENTRY DPAROP(NGRUP,TNAM)
CH
C
C     input: group, tnam=textstring : "DF_123 CT$1234 ...."
C     In the text array TPOPDA DF and DT are set at the position of DF and
C     DT in TPAR2.
C     COMMON: N_1_DA = position of first word, N_2_DA = position of last word.
C
C     Call before DPAROP0.
C
CH --------------------------------------------------------------------
CH
      LNUM=LENOCC(TNAM)
      IF(NGRUP.NE.0) THEN
        K=NGR1(NGRUP)-1
        K2=NGR2(NGRUP)
      END IF
      DO L=1,LNUM-2,4
        TW=TNAM(L:L+2)
  200   K=K+1
        IF(K.GT.K2) THEN
          K=0
          IF(L.NE.LOLD) THEN
            LOLD=L
            GO TO 200
          ELSE
            CALL DWRT('ERROR IN DPAROP: '//TW)
            GO TO 201
          END IF
        END IF
        IF(TW.NE.TPAR3(K)) GO TO 200
        TPOPDA(K)=TPAR2(K)
        N_1_DA=MIN(N_1_DA,K)
        N_2_DA=MAX(N_2_DA,K)
  201 END DO
      RETURN
CH..............---
CH
CH
CH
CH
CH
CH
CH ------------------------------------------------------------------  DPARP0
CH
      ENTRY DPARP0
CH
C
C  Clear TPOPDA and set N_1_DA to 999 and N_2_DA to 0. Called before DPAROP
C
CH --------------------------------------------------------------------
CH
C
      N_1_DA=999
      N_2_DA=0
      DO I=1,MPARDA
        TPOPDA(I)=' '
      END DO
      RETURN
CH..............---
CH
CH
CH
CH
CH
CH
CH ------------------------------------------------------------------  DPARCH
CH
      ENTRY DPARCH(NGRUP,T1,T2)
CH
C
C   Set word T2 ino TPOPDA at the position of T1 in TPARDA
C
CH --------------------------------------------------------------------
CH
C
      DO K=NGR1(NGRUP),NGR2(NGRUP)
        IF(TPAR3(K).EQ.T1) THEN
          TPOPDA(K)=T2
          N_1_DA=MIN(N_1_DA,K)
          N_2_DA=MAX(N_2_DA,K)
          RETURN
        END IF
      END DO
      RETURN
CH..............---
CH
CH
CH
CH
CH
CH
CH ------------------------------------------------------------------  DPARGG
CH
      ENTRY DPARGG(NGRUP,NG1,NG2)
CH
C
C    get position of group=ngrup between ng1 and ng2
C
CH --------------------------------------------------------------------
CH
      NG1=NGR1(NGRUP)
      NG2=NGR2(NGRUP)
      RETURN
CH..............---
CH
CH
CH
CH
CH
CH
CH ------------------------------------------------------------------  
CH
      ENTRY DPAR_GET_ARRAY(NGRUP,T1,LARR,NARR)
CH
C
C         Store LARR integer values into NARR
C
CH --------------------------------------------------------------------
CH
      DO K=NGR1(NGRUP),NGR2(NGRUP)
        IF(TPAR3(K).EQ.T1) THEN
          K1=K-1
          DO I=1,LARR
            NARR(I)=PARADA(2,K1+I)
          END DO
          IF(FCHEK) FCHK2(K)=.TRUE.
          RETURN
        END IF
      END DO
      WRITE(TXTADW,4000) TSUBDJ,'DPAR_GET_ARRAY',NGRUP,T1 
      CALL DWRC
      TSUBDJ=' '
      RETURN
CH..............---
CH
CH
CH
CH
CH
CH
CH ------------------------------------------------------------------  
CH
      ENTRY DPAR_GET_REAL(NGRUP,T1,LARR,RARR)
CH
C
C         Store LARR  values into RARR
C
CH --------------------------------------------------------------------
CH
      DO K=NGR1(NGRUP),NGR2(NGRUP)
        IF(TPAR3(K).EQ.T1) THEN
          K1=K-1
          DO I=1,LARR
            RARR(I)=PARADA(2,K1+I)
          END DO
          IF(FCHEK) FCHK2(K)=.TRUE.
          RETURN
        END IF
      END DO
      WRITE(TXTADW,4000) TSUBDJ,'DPAR_GET_REAL',NGRUP,T1 
      CALL DWRC
      TSUBDJ=' '
      RETURN
CH..............---
CH
CH
CH
CH
CH
CH
CH ------------------------------------------------------------------  
CH
      ENTRY DPARGV(NGRUP,T1,N1234,P1234)
CH
C
C                Get value of parameter T1
C
CH --------------------------------------------------------------------
CH
      DO K=NGR1(NGRUP),NGR2(NGRUP)
        IF(TPAR3(K).EQ.T1) THEN
          IF(N1234.GT.0.) THEN
            P1234=PARADA(N1234,K)
          ELSE IF(PARADA(4,K).GE.0.) THEN
            P1234=PARADA(  2  ,K)
          END IF
          IF(FCHEK) FCHK2(K)=.TRUE.
          RETURN
        END IF
      END DO
      WRITE(TXTADW,4000) TSUBDJ,'DPARGV',NGRUP,T1 
 4000 FORMAT(2A,I4,1X,A,' ??"')
      CALL DWRC
      TSUBDJ=' '
      RETURN
CH..............---
CH
CH
CH
CH
CH
CH
CH ------------------------------------------------------------------  
CH
      ENTRY DPARGI(NGRUP,T1,IP2)
CH
C
C                Get integer value of parameter T1
C
CH --------------------------------------------------------------------
CH
      DO K=NGR1(NGRUP),NGR2(NGRUP)
        IF(TPAR3(K).EQ.T1) THEN
          IP2=PARADA(2,K)
          IF(FCHEK) FCHK2(K)=.TRUE.
          RETURN
        END IF
      END DO
      WRITE(TXTADW,4000) TSUBDJ,'DPARGI',NGRUP,T1 
      CALL DWRC
      TSUBDJ=' '
      RETURN
CH..............---
CH
CH
CH
CH
CH
CH
CH ------------------------------------------------------------------  DPARSV
CH
      ENTRY DPARSV(NGRUP,T1,N1234,P1234)
CH
C
C                Set value of parameter T1 in position N1234 = 1 TO 4
C
CH --------------------------------------------------------------------
CH
      DO K=NGR1(NGRUP),NGR2(NGRUP)
        IF(TPAR3(K).EQ.T1) THEN
          IF(FCHEK) THEN
            FCHK2(K)=.TRUE.
          ELSE
            PARADA(N1234,K)=P1234
          END IF
          RETURN
        END IF
      END DO
      WRITE(TXTADW,4000) TSUBDJ,'DPARSV',NGRUP,T1 
      CALL DWRC
      TSUBDJ=' '
      RETURN
CH..............---
CH
CH
CH
CH
CH
CH
CH ------------------------------------------------------------------  DPARSV
CH
      ENTRY DPAR_TOGGLE(NGRUP,T1,N1234)
CH
C
C       value of parameter T1 in position N1234 = - value
C
CH --------------------------------------------------------------------
CH
      DO K=NGR1(NGRUP),NGR2(NGRUP)
        IF(TPAR3(K).EQ.T1) THEN
          IF(FCHEK) THEN
            FCHK2(K)=.TRUE.
          ELSE
            PARADA(N1234,K)=-PARADA(N1234,K)
          END IF
          RETURN
        END IF
      END DO
      WRITE(TXTADW,4000) TSUBDJ,'DPAR_TOGGLE',NGRUP,T1 
      CALL DWRC
      TSUBDJ=' '
      RETURN
CH..............---
CH
CH
CH
CH
CH
CH
CH ------------------------------------------------------------------  DPARSV
CH
      ENTRY DPAR_SET_CO(NGRUP,T1)
CH
C
C                Set color ngrup/t1 
C
CH --------------------------------------------------------------------
CH
      DO K=NGR1(NGRUP),NGR2(NGRUP)
        IF(TPAR3(K).EQ.T1) THEN
          ICOLDP=PARADA(2,K)
          IF(FCHEK) FCHK2(K)=.TRUE.
          IF(PARADA(4,K).GE.0.) THEN
            CALL DGLEVL(ICOLDP)
          ELSE
            ICOLDP=-ICOLDP-1
          END IF
          RETURN
        END IF
      END DO
      ICOLDP=8
      WRITE(TXTADW,4000) TSUBDJ,'DPAR_SET_CO',NGRUP,T1 
      CALL DWRC
      TSUBDJ=' '
      RETURN
CH..............---
CH
CH
CH
CH
CH
CH
CH ------------------------------------------------------------------  DPARSV
CH
      ENTRY DPAR_SET_WIDTH(NGRP1,T1,NGRP2,T2)
CH
C     Input: NRRP1,T1 : individual width  = W1( )   
C     Input: NRRP1,T1 :  general   width  = W2( )  
C
C     IF( W1(4)= 0 )  W=W1(2)  else     |    W1(4) =      -1    0   +1    
C     IF( W1(4)=-1 )  W=W2(2)  else     |    W2(4) = -1   W2   W1   W1(2)
C     IF( W2(4)= 1 )  W=W2(2)  else     |      "   =  0   W2   W1   W1(2)
C                     W=W1(2)  then     |      "   =  1   W2   W1   W2
C          set lin width to W
C
CH --------------------------------------------------------------------
CH
      DO K=NGR1(NGRP1),NGR2(NGRP1)
        IF(TPAR3(K).EQ.T1) THEN
          DLINDD=PARADA(2,K)
          IF(FCHEK) FCHK2(K)=.TRUE.
          IF(PARADA(4,K).EQ.0.) RETURN
          W14=PARADA(4,K)
          GO TO 300
        END IF
      END DO
      WRITE(TXTADW,4000) TSUBDJ,'DPAR_SET_WIDTH',NGRP1,T1 
      CALL DWRC
      TSUBDJ=' '
      RETURN
  300 DO K=NGR1(NGRP2),NGR2(NGRP2)
        IF(TPAR3(K).EQ.T2) THEN
          IF(W14.EQ.-1..OR.PARADA(4,K).GT.0.) DLINDD=PARADA(2,K)
          IF(FCHEK) FCHK2(K)=.TRUE.
          RETURN
        END IF
      END DO
      WRITE(TXTADW,4000) TSUBDJ,'DPAR_SET_WIDTH',NGRP2,T2 
      CALL DWRC
      TSUBDJ=' '
      RETURN
CH..............---
CH
CH
CH
CH
CH
CH
CH --------------------------------------------------------- DPAR_SET_TR_WIDTH
CH
      ENTRY DPAR_SET_TR_WIDTH
CH
C
C                reset track width
C
CH --------------------------------------------------------------------
CH
      DO K=NGR1(87),NGR2(87)
        IF(TPAR3(K).EQ.'SDW') THEN
          DLINDD=PARADA(2,K)
          IF(FCHEK) FCHK2(K)=.TRUE.
          RETURN
        END IF
      END DO
      WRITE(TXTADW,4000) TSUBDJ,'DPAR_SET_TR_WIDTH',87,'SDW' 
      CALL DWRC
      TSUBDJ=' '
      RETURN
CH..............---
CH
CH
CH
CH
CH
CH
CH -------------------------------------------------------------  DPAR_SET_SY
CH
      ENTRY DPAR_SET_SY(NGRUP,FOVER)

CH
C                set symbol and size
C
CH --------------------------------------------------------------------
CH
      DO K1=NGR1(NGRUP),NGR2(NGRUP)
        IF(TPAR3(K1).EQ.'SSY') THEN
          DO K2=K1+1,NGR2(NGRUP)
            IF(TPAR3(K2).EQ.'SSZ') THEN
              CALL DQPD0(IDPAR(K1),PARADA(2,K2),FOVER)
              IF(FCHEK) THEN
                FCHK2(K1)=.TRUE.
                FCHK2(K2)=.TRUE.
              END IF
              RETURN
            END IF
          END DO
          WRITE(TXTADW,4000) TSUBDJ,'DPAR_SET_SY',NGRUP,'SSZ' 
          CALL DWRC
          TSUBDJ=' '
          RETURN
        END IF
      END DO
      WRITE(TXTADW,4000) TSUBDJ,'DPAR_SET_SY',NGRUP,'SSY'
      CALL DWRC
      TSUBDJ=' '
      RETURN
CH..............---
CH
CH
CH
CH
CH
CH
CH ------------------------------------------------------------------  DPACGT
CH
      ENTRY DPACGT(NGRUP,PTO)
CH
C
C                Copy group NGRUP from PARADA to PTO
C
CH --------------------------------------------------------------------
CH
C
      DO K=NGR1(NGRUP),NGR2(NGRUP)
        PTO(1,K)=PARADA(2,K)
        PTO(2,K)=PARADA(4,K)
      END DO
      RETURN
CH..............---
CH
CH
CH
CH
CH
CH
CH ------------------------------------------------------------------  DPACGF
CH
      ENTRY DPACGF(NGRUP,PFR)
CH
C
C                  Copy group NGRUP from PFR TO PARADA
C
CH --------------------------------------------------------------------
CH
C
      DO K=NGR1(NGRUP),NGR2(NGRUP)
        PARADA(2,K)=PFR(1,K)
        PARADA(4,K)=PFR(2,K)
      END DO
      RETURN
CH..............---
CH
CH
CH
CH
CH
CH
CH ------------------------------------------------------------------  DPACNT
CH
      ENTRY DPACNT(NC1,NC2,PTO)
CH
C
C         Copy PARADA to PTO from NC1 to NC2.
C
CH --------------------------------------------------------------------
CH
C
      DO K=NC1,NC2
        PTO(1,K)=PARADA(2,K)
        PTO(2,K)=PARADA(4,K)
      END DO
      RETURN
CH..............---
CH
CH
CH
CH
CH
CH
CH ------------------------------------------------------------------  DPACGT
CH
      ENTRY DPACFT(NGRUP,PFR,PTO)
CH
C
C                Copy group NGRUP from PFR to PTO
C
CH --------------------------------------------------------------------
CH
C
      DO K=NGR1(NGRUP),NGR2(NGRUP)
        PTO(1,K)=PFR(1,K)
        PTO(2,K)=PFR(2,K)
      END DO
      RETURN
CH..............---
CH
CH
CH
CH
CH
CH
CH ------------------------------------------------------------------  DPACNF
CH
      ENTRY DPACNF(NC1,NC2,PFR)
CH
C
C         Copy PFR to PARADA from NC1 to NC2.
C
CH --------------------------------------------------------------------
CH
C
      DO K=NC1,NC2
        PARADA(2,K)=PFR(1,K)
        PARADA(4,K)=PFR(2,K)
      END DO
      RETURN
CH..............---
CH
CH
CH
CH
CH
CH
CH ------------------------------------------------------------------  DPARST
CH
      ENTRY DPARST(TFIN)
CH
CH --------------------------------------------------------------------
CH
C   STORE DALI_D#.PAR_D0
C ---------------------------------------------------------------------
C
C     Created by H.Drevermann                              06-MAY-1994
      CALL DGOPEN(NUNIDU,TFIN,2,*109,ISTAT)
      CALL VZERO(NGR1,MGR+1)
      CALL VZERO(NGR2,MGR+1)
      ILIST=0
      LSET=0
  102 N=1
  103 READ(NUNIDU,1000,END=108) T80
 1000 FORMAT(1X,A)
      L80=LENOCC(T80)
      IF(T80(1:3).EQ.'   ') GO TO 103
      IF     (T80(1:3).EQ.'S__') THEN
        READ(T80,2001) IG,NSTRT(IG),THLP(IG),TGRUP(IG),TCOM(IG)
        IF(IG.GT.MGR) CALL DWRT('Group # too high !#')
 2001   FORMAT(4X,2I3,3(1X,A))
        IF(NGR1(IG).NE.0) THEN
          WRITE(TXTADW,2002) IG
 2002     FORMAT('Group ',I3,' double defined in parameter file#')
          CALL DWRC
        END IF
        NGR1(IG)=N
        ILIST=ILIST+1
        NLIST(IG)=ILIST
        GO TO 103
      ELSE IF(T80(1:3).EQ.'__E') THEN
        READ(T80,2001) IG
        NGR2(IG)=N-1
        GO TO 103
      ELSE IF(T80(1:3).EQ.'__N') THEN
        READ(T80(4:10),1002) ISET
 1002   FORMAT(I7)
        IF(ISET.GT.MSET) THEN
          CALL DWRT('Too many name sets in the parameter file.#')
          GO TO 103
        END IF
        ISET1(ISET)=LSET+1
        DO L=12,L80-1,3
          LSET=LSET+1
          IF(LSET.GE.MNSET) THEN
            CALL DWRT('Too many name in the parameter file.#')
            GO TO 103
          END IF
          TSET(LSET)=T80(L:L+1)
        END DO
        ISET2(ISET)=LSET
        GO TO 103
      END IF
      PARA2=PARADA(2,N)
      READ(T80,1103,END=108) TPAR3(N),NDIG(N),(PARADA(I,N),I=1,4),
     &  TPAR2(N),TGRP
 1103 FORMAT(A,I6,F8.2,F10.3,F9.0,F4.0,1X,2A)
C     ................................ default width = track width is stored
      IF(IG.EQ.68.AND.TPAR3(N).EQ.'STR') WDTR=PARADA(2,N)
      IF(PARADA(4,N).GT.90) THEN
        IF(     PARADA(4,N).EQ.99) THEN
          PARADA(2,N)=MAX(PARA2,PARADA(2,N))
        ELSE IF(PARADA(4,N).EQ.98) THEN
          PARADA(2,N)=MIN(PARA2,PARADA(2,N))
        ELSE IF(PARADA(4,N).EQ.97) THEN
          PARADA(2,N)=PARA2
        END IF
      END IF
      N=N+1
      IF(N.LE.MPARDA) GO TO 103
      CALL DWRT('Too many parameters ! Last parameter = #')
      CALL DWRT(T80)
  108 NPAR=N-1
      CLOSE(UNIT=NUNIDU)
      IMAXDO=NGR2(1)
      DO K=1,MGR
        IF(NGR1(K).NE.0.OR.NGR2(K).NE.0) THEN
          IF(NGR1(K).EQ.0.OR.NGR2(K).EQ.0) THEN
            WRITE(TXTADW,1104) K
 1104       FORMAT('Group ',I3,' not fully defined in parameter file#')
            CALL DWRC
          END IF
        END IF
      END DO
      RETURN
  109 TXTADW=TFIN//' not found'
      CALL DWRC
      RETURN

CH..............---
CH
CH
CH
CH
CH
CH
CH ------------------------------------------------------- DPARST_MODIF
CH
      ENTRY DPARST_MODIF(TFIN)
CH
CH --------------------------------------------------------------------
CH
C     MODIFY **.PAR_D0
C ---------------------------------------------------------------------
C
C     Created by H.Drevermann                              06-MAY-1994
      CALL DGOPEN(NUNIDU,TFIN,2,*709,ISTAT)
      READ(NUNIDU,1000) TXTADW
      NPMOD=0
  703 READ(NUNIDU,1000,END=708) T80
      L80=LENOCC(T80)
      IF(T80(1:3).EQ.'   ') GO TO 703
      IF     (T80(1:3).EQ.'S__') THEN
        READ(T80,7001) IG
        IF(IG.GT.MGR) CALL DWRT('Group # too high !#')
 7001   FORMAT(4X,I3)
      ELSE
        READ(T80,1103,END=108) TPR3M,NDIGM,(PARDM(I),I=1,4)
        DO K=NGR1(IG),NGR2(IG)
          IF(TPAR3(K).EQ.TPR3M) THEN
            DO I=1,4
              PARADA(I,K)=PARDM(I)
            END DO
            NPMOD=NPMOD+1
            GO TO 703
          END IF
        END DO
        WRITE(TXTADW,7000) IG,TPR3M
 7000   FORMAT(I6,1X,A,' not found.#')
      END IF
      GO TO 703
  708 CLOSE(UNIT=NUNIDU)
      WRITE(TXTADW(1:3),7002) NPMOD
 7002 FORMAT(I3)
      CALL DWRC
      RETURN
CBSN  709 CALL DWRT(TFIN//' not found.#')
  709 TXTADW=TFIN//' not found.#'
      CALL DWRC
CBSN for Linux
      RETURN
CH..............---
CH
CH
CH
CH
CH
CH
CH ------------------------------------------------  DPAR_GET_HEADER
CH
      ENTRY DPAR_GET_HEADER(TOP1,TOPIN,THEAD,THELP,FOUND)
CH
CH --------------------------------------------------------------------
      TOP2=TOPIN
      FOUND=.FALSE.
      IF(TOP2.EQ.'? ') THEN
C       ................................ return possible goup names in THEAD
        CALL VZERO(NWRKDW,ILIST)
        DO K=1,MGR
          IF(TGRUP(K)(1:2).EQ.TOP1) THEN
            FOUND=.TRUE.
            IF(TGRUP(K)(3:4).EQ.'1G') THEN
              THEAD=TCOM(K)
              THELP=THLP(K)
              N_1_DA=NGR1(K)
              N_2_DA=NGR2(K)
              KGR=K
              TOP2='1G'
              TOPIN='1G'
              RETURN
            END IF
            NWRKDW(NLIST(K))=K
          END IF
        END DO
        L=1
        THEAD=' '
        DO I=1,ILIST
          IF(NWRKDW(I).NE.0) THEN
            THEAD(L:L+1)=TGRUP(NWRKDW(I))(3:4)
            L=L+3
C           .......................................... CHARACTER *42 THEAD
            IF(L.GE.39) THEN
C             ...... Not more than 12 group names are displayed. 
              THEAD(40:42)='...'
              RETURN
            END IF
          END IF
        END DO
        RETURN
      END IF
C     ......................................... Search group by name
      DO K=1,MGR
        IF(TGRUP(K).EQ.TOP1//TOP2) THEN
          FOUND=.TRUE.
          THEAD=TCOM(K)
          THELP=THLP(K)
          N_1_DA=NGR1(K)
          N_2_DA=NGR2(K)
          KGR=K
          RETURN
        END IF
      END DO
      RETURN
CH..............---
CH
CH
CH
CH
CH
CH
CH ------------------------------------------------------  DPAR_DSP_STR_GROUP
CH
      ENTRY DPAR_DSP_STR_GROUP
CH
CH --------------------------------------------------------------------
C     DPAR_DSP_STR_GROUP must be called before to setup N_1_da and N_1_DA
C     ............................................ clear TPOPDA
      DO I=1,N_1_DA-1
        TPOPDA(I)=' '
      END DO
      DO I=N_2_DA+1,MPARDA
        TPOPDA(I)=' '
      END DO
      TXTADW=TOP2//' | '
      L1=NSTRT(KGR)
C     .......................... store parameter names into TPOPDA
C     ............................. and write them to the terminal.
      DO I=N_1_DA,N_2_DA
        IF(TPAR2(I).NE.' ') THEN
          TPOPDA(I)=TPAR2(I)
C         ............................... L1234567
C         ............................... FI=12345
  100     NUMDI=NDIG(I)
          NDI=MOD(NUMDI,10)
          NUMDI=NUMDI/10
          JST=MOD(NUMDI,100)
          IF(NUMDI.GE.100) THEN
            LPS=NUMDI/100
            IF(LPS.LT.50) THEN
              IF(LPS.GE.L1) THEN
                L1=LPS
              ELSE
                CALL DWRC
                L1=LPS
                TXTADW='   | '
              END IF
            ELSE
              CALL DWRC
              L1=LPS-50
              TXTADW='   | '
            END IF
          END IF
C         .............................. L1 = next blank position
C         .............................. L2 = last non bank position
          L2=L1+1
          IF(JST.GT.0) L2=L2+5
          IF(NDI.GT.0) L2=L2+1+NDI
          IF(L2.GT.LMAX) THEN
            CALL DWRC
            TXTADW='   | '
            L1=NSTRT(KGR)
          END IF
          TXTADW(L1:L1+1)=TPAR2(I)
          L1=L1+2
          IF(     PARADA(4,I).EQ.0.) THEN
            TSL='='
          ELSE IF(PARADA(4,I).LT.0.) THEN
            TSL='/'
          ELSE
            TSL=':'
          END IF
          IF(JST.GT.0) THEN
            NP2=PARADA(2,I)
            TXTADW(L1:L1+4)=TSL//''''//TSET(ISET1(JST)+NP2)//''''
            L1=L1+5
          END IF
          IF(NDI.GT.0) THEN
            TXTADW(L1:L1)=TSL
            L1=L1+1
            CALL DTN(PARADA(2,I) ,NDI , TXTADW(L1:L1+NDI-1))
            L1=L1+NDI
          END IF
          TXTADW(L1:L1)=' '
          L1=L1+1
        END IF
      END DO
      IF(L1.GT.NSTRT(KGR)) CALL DWRC
      RETURN
CH --------------------------------------------------  DPAR_CHG_BY_NAME
CH
      ENTRY DPAR_CHG_BY_NAME(TANSW,FOUND)
CH
CH --------------------------------------------------------------------
      CALL DOPERG(NSP,NPAR)
      NUMDI=NDIG(NPAR)
      NDI=MOD(NUMDI,10)
      NUMDI=NUMDI/10
      JST=MOD(NUMDI,100)
      NST1=ISET1(JST)
      NST2=ISET2(JST)
      IF(NSP.EQ.1.AND.NST2.GT.0.AND.JST.GT.0) THEN
        CALL DO_STR_LIST(NST2-NST1+1,TSET(NST1),'variable name')
        M=0
        DO N=NST1,NST2
          IF(TANSW.EQ.TSET(N)) THEN
            PARADA(2,NPAR)=M
            PARADA(4,NPAR)=ABS(PARADA(4,NPAR))
            FOUND=.TRUE.
            RETURN
          END IF
          M=M+1
        END DO
      END IF
      FOUND=.FALSE.
      RETURN
CH --------------------------------------------------  DPAR_DEBUG
CH
      ENTRY DPAR_DEBUG
CH
CH --------------------------------------------------------------------
      CALL DTYANS('For Debugging: List group, get Position, <CR>',
     &  'LP',NANSW)
      IF(NANSW.LE.0) RETURN
C     ........................................................... List
      IF(NANSW.EQ.1) THEN
        DO K=0,MGR,10
          WRITE(TXTADW,1201) K,(TGRUP(K+I)(1:4),I=0,9)
 1201     FORMAT(I3,10(1X,A4))
          CALL DWRC
        END DO
        WRITE(TXTADW,1200) (I,I=0,9)
 1200   FORMAT(1X,10I5)
        CALL DWRC
      ELSE 
C     ........................................................... Get Position
        CALL DWRT('# of group = ')
        CALL DGETLN(TW,NNAM,3)
        IF(NNAM.LT.1) RETURN
        READ(TW(1:NNAM),1202,ERR=209) JGR
 1202   FORMAT(I3)
        IF(JGR.LE.0.OR.JGR.GT.MGR) RETURN
        CALL DWRT('3 letter name = ')
        CALL DGETLN(TW,NNAM,3)
        IF(NNAM.LT.1) RETURN
        DO K=NGR1(JGR),NGR2(JGR)
          IF(TPAR3(K).EQ.TW) THEN
            WRITE(TXTADW,1203) JGR,TW,K
 1203       FORMAT(I3,1X,A,' = ',I3)
            CALL DWRC
            RETURN
          END IF
        END DO
  209   CALL DWRT('Parameter not found.#')
      END IF
      RETURN
CH ---------------------------------------------------------- DPAR_CHECK_DEF
CH
      ENTRY DPAR_CHECK_DEF(TCHEK,IPAR)
CH
C     called by the J_?? checking routine produced via "R J_CHECK_PAR" + US5
C
CH --------------------------------------------------------------------
CH
      IF(IPAR.EQ.0) THEN
        TXTADW=TCHEK//' not defined'
        CALL DWRC
      ELSE
        FCHK2(IPAR)=.TRUE.
        FCHK1(IPAR)=.FALSE.
        IPAR=0
      END IF
      RETURN
C
C
C     CHECK OF J_PAR_CHECK
CJ_E. TPARDA=
CJ_E.&  'J_TS1'
CJ_E. CALL DPARAM(62
CJ_E.&  ,J_TS1)
CJ_E. CALL DPARSV(62,'TS2',2,PP)
CJ_E. CALL DQPD1(53,0.) 
CJ_E. ENTRY J_PAR_CHECK
CJ_E. P=PARADA(2,J_TS3)
CJ_       ................... 1 following lines not checked by J_DPAR_CHECK
CJ_E. P=PARADA(2,J_TS4) ! test of J_PAR_CHECK ignore!
C
C     This gives the following output:
C
C=C_DALBP   DPAR_CHECK_J       TS1 wrong sequence   |
C                              TS1 not found        |
C                              DPARSV  62 TS2 ??    |
C                              DPARGV  53 SSY ??    |
C                              DPARGV  53 SSZ ??    |
C=C_DALBP   +J_PAR_CHECK       J_TS3 not defined    |
C
C
C
C
C
CH ---------------------------------------------------------- DPAR_CHECK_USE
CH
      ENTRY DPAR_CHECK_USE(TCHEK)
CH
C     called by the J_DALI.FOR produced via "@J_CHECK_PAR" 
C
CH --------------------------------------------------------------------
CH
      IF(    TCHEK.EQ.'CLEAR') THEN
        DO K=1,MPARDA
          FCHK1(K)=.FALSE.
          FCHK2(K)=.FALSE.
        END DO
        FCHEK=.TRUE.
      ELSE IF(TCHEK.EQ.'STOP') THEN
        FCHEK=.FALSE.
        TXTADW='unused gr. '
        L=13
        DO N=1,MGR
          IF(NGR1(N).EQ.0) THEN
            WRITE(TXTADW(L:L+2),3000) N
 3000       FORMAT(I3)
            IF(L.GT.73) THEN
              CALL DWRC
              TXTADW=' '
              L=1
            ELSE
              L=L+4
            END IF
          END IF
        END DO
        IF(L.GT.1) CALL DWRC
        TXTADW='unused paramet.'
        L=17
        DO N=1,MPARDA
          IF(TPAR3(N).NE.'   '.AND.
     &       TPAR3(N).NE.'***'.AND.(.NOT.FCHK2(N))) THEN
            CALL D_PAR_SEARCH_GROUP(N,NGR1,NGR2,MGR,NGK)
            WRITE(TXTADW(L:L+6),3001) NGK,TPAR3(N)
 3001       FORMAT(I3,1X,A)
            IF(L.GT.65) THEN
              CALL DWRC
              TXTADW=' '
              L=1
            ELSE
              L=L+8
            END IF
          END IF
        END DO
        IF(L.GT.1) CALL DWRC
C  
        TXTADW='unused op para.'
        L=17
        DO N=N_1_DA,N_2_DA
          IF(TPOPDA(N).NE.' '.AND.(.NOT.FCHK2(N))) THEN
            CALL D_PAR_SEARCH_GROUP(N,NGR1,NGR2,MGR,NGK)
            WRITE(TXTADW(L:L+6),3001) NGK,TPAR3(N)
            IF(L.GT.65) THEN
              CALL DWRC
              TXTADW=' '
              L=1
            ELSE
              L=L+8
            END IF
          END IF
        END DO
        IF(L.GT.1) CALL DWRC
C       .....................................................
      ELSE
        DO K=1,MPARDA
          IF(FCHK1(K)) THEN
            TXTADW=TCHEK//TPAR3(K)//' not used'
            CALL DWRC
            FCHK1(K)=.FALSE.
          END IF
        END DO
      END IF
      END
*DK IDPAR
CH..............+++
CH
CH
CH
CH
CH
CH
CH ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ IDPAR
CH
      FUNCTION IDPAR(N)
CH
CH ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      INCLUDE 'DALI_CF.INC'
      IDPAR=PARADA(2,N)
      END
*DK D_PAR_SEARCH_GROUP
CH..............+++
CH
CH
CH
CH
CH
CH
CH ++++++++++++++++++++++++++++++++++++++++++++++++++++++ D_PAR_SEARCH_GROUP
CH
      SUBROUTINE D_PAR_SEARCH_GROUP(N,NGR1,NGR2,MGR,NGK)
CH
CH ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
CH
      DIMENSION NGR1(*),NGR2(*)
C     ............ Search for smallest group containing parameter N
      NGD=999
      NGK=0
      DO K=1,MGR
        IF(N.GE.NGR1(K).AND.N.LE.NGR2(K)) THEN
          NGDN=NGR2(K)-NGR1(K)
          IF(NGDN.LT.NGD) THEN
            NGK=K
            NGD=NGDN
          END IF
        END IF
      END DO
      END
*DK DPCEAR
CH..............+++
CH
CH
CH
CH
CH
CH
CH ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  DPCEAR
CH
      SUBROUTINE DPCEAR(NARE)
CH
CH ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
CH
C ---------------------------------------------------------------------
C
C    Created by H.Drevermann                   28-JUL-1988
C
C!:Parameter Copy: Execute all pictures on ARea "nar"
C    Inputs    :
C    Outputs   :
C
C    Called by :
C ---------------------------------------------------------------------
*CA DALLCO
      INCLUDE 'DALI_CF.INC'
      LOGICAL F0,FOUT
      IF(NTVIDT.EQ.0) RETURN
      NAR=NARE
      IPOLD=IPICDO
      IAR=IAREDO
      NOCL=NOCLDT
      FOUT=.TRUE.
      DO   700  M=MPNWDW,0,-1
        IF(NWINDW(M,NAR).EQ.-2.OR.NWINDW(M,NAR).EQ.1) THEN
          CALL DPCGVA(M,F0)
          IF(.NOT.F0) THEN
            NOCLDT=NOCL
            CALL DBR2
            CALL DGCHKX
            FOUT=.FALSE.
          END IF
        END IF
  700 CONTINUE
      IF(FOUT) THEN
        CALL DWRT('The selected window '//TAREDO(IAREDO)//
     &    ' contains no full picture.')
        CALL DWRT('Select other window.')
      END IF
      IAREDO=IAR
      IPICDO=IPOLD
      TPICDO=TPICDP(IPICDO)
      PICNDO=IPICDO
      END
*DK DPCGAR
CH..............+++
CH
CH
CH
CH
CH
CH
CH ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  DPCGAR
CH
      SUBROUTINE DPCGAR(IARE,F0)
CH
CH ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
CH
C ---------------------------------------------------------------------
C
C    Created by H.Drevermann                   28-JUL-1988
C
C!:Parameter-Copy: Get parameters of ARea, if stored
C    Inputs    :
C    Outputs   :
C
C    Called by :
C ---------------------------------------------------------------------
*CA DALLCO
      INCLUDE 'DALI_CF.INC'
      LOGICAL F0
      IWUS=0
      IF(ISTODS(4,IARE,IWUS).EQ.0) THEN
         F0=.TRUE.
         RETURN
      END IF
      GO TO 1
CH..............---
CH
CH
CH
CH
CH
CH
CH --------------------------------------------------------------------  DPCGVA
CH
      ENTRY DPCGVA(IARE,F0)
CH
CH --------------------------------------------------------------------
CH
C ---------------------------------------------------------------------
C
C    Created by H.Drevermann                   28-JUL-1988
C
C!:Parameter-Copy: Get paramters of Visible area
C    Inputs    :
C    Outputs   :
C
C    Called by :
C ---------------------------------------------------------------------
      IWUS=0
      IF(ISTODS(4,IARE,IWUS).LT.1) THEN
         F0=.TRUE.
         RETURN
      END IF
    1 MAR=IARE
      JAR=IARE
      GO TO 2
CH..............---
CH
CH
CH
CH
CH
CH
CH --------------------------------------------------------------------  DPCGVI
CH
      ENTRY DPCGAR_NEW(NWUS,IARE,F0)
CH
CH --------------------------------------------------------------------
CH
C ---------------------------------------------------------------------
C
C    Created by H.Drevermann                   28-JUL-1988
C
C!:Parameter-Copy: Get paramters dependent on user window
      IWUS=NWUS
      IF(ISTODS(4,IARE,IWUS).EQ.0) THEN
         F0=.TRUE.
         RETURN
      END IF
      GO TO 1
CH..............---
CH
CH
CH
CH
CH
CH
CH --------------------------------------------------------------------  DPCGVI
CH
      ENTRY DPCGVI(IARE,F0)
CH
CH --------------------------------------------------------------------
CH
C ---------------------------------------------------------------------
C
C    Created by H.Drevermann                   28-JUL-1988
C
C!:Parameter-Copy: Get paramters of Virtual area
C    Inputs    :
C    Outputs   :
C
C    Called by :
C ---------------------------------------------------------------------
      IWUS=0
      MAR=IARE
      JAR=IAREDO
      IF(ISTODS(1,MAR,0).EQ.0) THEN
        F0=.TRUE.
        RETURN
      END IF
    2 CALL UCOPY(ISTODS(1,MAR,IWUS),IMAXDO,8)
      TPICDO=TPICDP(IPICDO)
      IAREDO=JAR
      CALL DPACGF(1,PSTODS(1,1,MAR,IWUS))
      F0=.FALSE.
      END
*DK DPCSAR
CH..............+++
CH
CH
CH
CH
CH
CH
CH ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  DPCSAR
CH
      SUBROUTINE DPCSAR
CH
CH ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
CH
C ---------------------------------------------------------------------
C
C    Created by H.Drevermann                   28-JUL-1988
C
C!:Parameter-Copy: Store for ARea
C!:store parameters for projection npic and used window.
C    Inputs    :
C    Outputs   :
C
C    Called by :
C ---------------------------------------------------------------------
*CA DALLCO
      INCLUDE 'DALI_CF.INC'
      IWUS=0
      DO   700  M=0,MPNWDW
        IF(NWINDW(M,IAREDO).LT.0.AND.ISTODS(4,M,0).NE.0)
     &     ISTODS(4,M,0)=-1
  700 CONTINUE
      IARE=IAREDO
      GO TO 1
CH..............---
CH
CH
CH
CH
CH
CH --------------------------------------------------------------------  DPCSAV
CH
      ENTRY DPCSAV(NWUS,JARE)
CH
CH --------------------------------------------------------------------
CH
C ---------------------------------------------------------------------
C
C    Created by H.Drevermann                   28-JUL-1988
C
C!:Parameter-Copy: Get paramters of Visible area
C    Inputs    :
C    Outputs   :
C
C    Called by :
C ---------------------------------------------------------------------
      IARE=JARE
      IWUS=NWUS
C     ............. copy last window set to area -4 = virtual window 0. 
C     ............. Get back with "G0").
    1 CALL UCOPY(ISTODS(1,IARE,IWUS),ISTODS(1,-4,IWUS),8)
      ISTODS(4,-4,IWUS)=1
      CALL UCOPY(TVRUDS(1,IARE,IWUS),TVRUDS(1,-4,IWUS),4)
      CALL UCOPY(TVRUDS(5,IARE,IWUS),TVRUDS(5,-4,IWUS),2)
      CALL DPACFT(1,PSTODS(1,1,IARE,IWUS),PSTODS(1,1,-4,IWUS))
C     ....................... copy current to window
      CALL UCOPY(IMAXDO,ISTODS(1,IARE,IWUS),8)
      ISTODS(4,IARE,IWUS)=1
      CALL UCOPY(HUMIDT,TVRUDS(1,IARE,IWUS),4)
      CALL UCOPY(AROTDT,TVRUDS(5,IARE,IWUS),2)
      CALL DPACGT(1,PSTODS(1,1,IARE,IWUS))
      RETURN
CH..............---
CH
CH
CH
CH
CH
CH
CH --------------------------------------------------------------------  DPCSAV
CH
      ENTRY DPCPAR(IPIC,IPAR,NPAR)
CH
CH --------------------------------------------------------------------
CH
      IF(ISTODS(5,IPAR,0).EQ.IPIC.AND.
     &  ISTODS(4,IPAR,0).EQ.1) THEN
        NPAR=IPAR
      ELSE
        DO NPAR=MPNWDW,0,-1
          IF(ISTODS(5,NPAR,0).EQ.IPIC.AND.
     &       ISTODS(4,NPAR,0).EQ.1) RETURN
        END DO
        NPAR=-9
      END IF
      END