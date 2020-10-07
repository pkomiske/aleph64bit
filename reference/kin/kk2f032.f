      SUBROUTINE ASKUSE (IDPR,ISTA,NTRK,NVRT,ECMS,WEIT)
C ------------------------------------------------------------
C -  B.Bloch January 2001
C! GET AN EVENT FROM KK2F version 4.14
C! then transfer the information into kine and vert banks.
C
C  
C
C     structure : subroutine
C     output arguments :
C          IDPR   : process identification,each digit corresponds to
C          the flavor of the evnt ( several flavors /event is possible)
C          ISTA   : status flag ( 0 means ok), use it to reject
C                   unwanted events
C          NTRK   : number of tracks generated and kept
C                  (i.e. # KINE banks  written)
C          NVRT   : number of vertices generated
C                   (i.e. # VERT banks written)
C          ECMS   : center of mass energy for the event (may be
C                   different from nominal cms energy)
C          WEIT   : event weight ( not 1 if a weighting method is used)
C -----------------------------------------------------------------
C*CA pyt6com
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
      COMMON /PYDAT3/ MDCY(L2PAR,3),MDME(LJNPAR,2),BRAT(LJNPAR),
     &                KFDP(LJNPAR,5)


      COMMON/PYDAT4/CHAF(L2PAR,2)
      CHARACTER CHAF*16
C
      COMMON/PYSUBS/MSEL,MSELPD,MSUB(L2PAR),KFIN(2,-40:40),CKIN(L1MST)
      COMMON/PYPARS/MSTP(L1MST),PARP(L1MST),MSTI(L1MST),PARI(L1MST)
      COMMON/PYINT1/MINT(400),VINT(400)
      COMMON/PYINT2/ISET(500),KFPR(500,2),COEF(500,20),ICOL(40,4,2)
      COMMON/PYINT3/XSFX(2,-40:40),ISIG(1000,3),SIGH(1000)
      COMMON/PYINT4/MWID(500),WIDS(500,5)
      COMMON/PYINT5/NGENPD,NGEN(0:500,3),XSEC(0:500,3)
      COMMON/PYINT6/PROC(0:500)
      CHARACTER PROC*28
      COMMON/PYINT7/SIGT(0:6,0:6,0:5)
C
      REAL*4 VRTX(4),PTRAK(4,2)
      INTEGER KFL(8)
C
C*CA bcs
      INTEGER LMHLEN, LMHCOL, LMHROW  ,LBCS
      PARAMETER (LMHLEN=2, LMHCOL=1, LMHROW=2, LBCS=1000)
C
      COMMON /BCS/   IW(LBCS )
      INTEGER IW
      REAL RW(LBCS)
      EQUIVALENCE (RW(1),IW(1))
C
      COMMON / GLUPAR / SVERT(3),XVRT(3),SXVRT(3),ECM,IFL,IFVRT
      REAL*4 ecm,svert,xvrt,sxvrt
      integer ifl,ifvrt
      COMMON / genflav/ igflav(40)
      COMMON / GLUSTA / ICOULU(10)
      REAL*4 PP,XX(2),et,ect,ent,thr
      REAL*8 TMIN,TMAX,YY,TT,DX
      LOGICAL KEEP
C
C VVVVVVVVVVVVVVVVVVVVV JB 010320 VVVVVVVVVVVVVVVVVVVVVVV
C BBL : ECM renamed to ECMJB !!!!
      REAL*8 ECMJB , Q(4,7)
      REAL*4 EPHMIN,EPHMAX,XTFMIN,XTFMAX,COSTHM
      COMMON / PHCUTS / EPHMIN,EPHMAX,XTFMIN,XTFMAX,COSTHM
      common / phacc / nphacc
      real*8 wtkal
      common / kalinout / wtkal(6)
C ^^^^^^^^^^^^^^^^^^^^^ JB 010320 ^^^^^^^^^^^^^^^^^^^^^^^^^
C
      REAL PI, TWOPI, PIBY2, PIBY3, PIBY4, PIBY6, PIBY8, PIBY12
      REAL RADEG, DEGRA
      REAL CLGHT
      INTEGER NBITW, NBYTW, LCHAR
      PARAMETER (PI=3.141592653589)
      PARAMETER (RADEG=180./PI, DEGRA=PI/180.)
      PARAMETER (TWOPI = 2.*PI , PIBY2 = PI/2., PIBY4 = PI/4.)
      PARAMETER (PIBY6 = PI/6. , PIBY8 = PI/8.)
      PARAMETER (PIBY12= PI/12., PIBY3 = PI/3.)
      PARAMETER (CLGHT = 29.9792458)
      PARAMETER (NBITW = 32 , NBYTW = NBITW/8 , LCHAR = 4)
C
      REAL*4 ECMS,WEIT,EBEAM,RX,RXX,RY,RYY,RZ,RZZ,DUM,PT
      INTEGER    IMAX
      PARAMETER (IMAX = 10000)               ! length ox xpar
      REAL*8 XPAR(IMAX)

      DATA IFI / 0/
C ------------------------------------------------------------------
C
 10   continue
      ISTA = 0
      IFI  =  IFI + 1
      NTRK = 0
      NVRT = 0
C - SET THE CMS ENERGY FOR THIS EVENT ECMS = ECM
      ECMS = ECM
      EBEAM = ECM*0.5
      WEIT = 1.
      IDPR = 0
      IFL1 = 0
C reset entries and fragmentation info
      N7LU = 0
      MSTU(90) = 0
C
C - GET THE PRIMARY VERTEX
C
      CALL RANNOR (RX,RY)
      CALL RANNOR (RZ,DUM)
      VRTX(1) = RX*SVERT(1)
      VRTX(2) = RY*SVERT(2)
      VRTX(3) = RZ*SVERT(3)
      VRTX(4) = 0.
      IF ( IFVRT.ge.2) then
         CALL RANNOR(RXX,RYY)
         CALL RANNOR(RZZ,DUM)
         VRTX(1) = VRTX(1) + RXX*SXVRT(1)
         VRTX(2) = VRTX(2) + RYY*SXVRT(2)
         VRTX(3) = VRTX(3) + RZZ*SXVRT(3)
      ENDIF
      IF ( IFVRT.ge.1) then
         VRTX(1) = VRTX(1) + XVRT(1)
         VRTX(2) = VRTX(2) + XVRT(2)
         VRTX(3) = VRTX(3) + XVRT(3)
      ENDIF
C
C - GET AN EVENT FROM KK2F
C
      CALL KK2f_Make 
C
C     DEBUGGING FIRST FIVE EVENTS:
C
      IF (IFI.LE.5) CALL PYLIST(1)
C
C Look for flavor generated
      call HepEvt_GetKFfin(KFfin)
      idpr = kffin
C
C VVVVVVVVVVVVVVVVVVVVV JB 010320 VVVVVVVVVVVVVVVVVVVVVVV
C NOW take values initialized from data cards !
       IGAMMA=22 
       IGOK=0
       EGMIN=EPHMIN
       EGMAX=EPHMAX
       COSMAX=COSTHM
       CMENE=ECMS
       XTMIN=XTFMIN
       XTMAX=XTFMAX
C       write (iw(6),1234) egmin,cosmax,cmene,xtmin
 1234  format(' -- askuse egmin,cosmax,cmene,xtmin =',4e12.4)
C Loop on all LUND particles ; check photons :
      DO 271 IN=1,N7LU
C         PX=P7LU(IN,1)
C         PY=P7LU(IN,2)
C         PZ=P7LU(IN,3)
C         EN=P7LU(IN,4)
         IPA=IABS(K7LU(IN,2))
C Find photons :
         IF (IPA.EQ.IGAMMA) THEN
           ECMJB=DBLE(CMENE)
           DO IQQ=1,4
              DO IJJ=1,7
                 Q(IQQ,IJJ)=0.D0
              ENDDO
           ENDDO
           Q(1,5) = P7LU(IN,1) 
           Q(2,5) = P7LU(IN,2) 
           Q(3,5) = P7LU(IN,3) 
           Q(4,5) = P7LU(IN,4) 
           CALL CHECK_CUTA(ECMJB,Q,NCUT)
           IF (NCUT.EQ.0) IGOK=IGOK+1
         ENDIF
 271   CONTINUE
C Write only events with at least a gamma inside cuts :
       ISTA=1
      IF (IGOK.GE.nphacc) then
         ISTA=0
c        costhg = Q(3,5)/Q(4,5)
c        print *,'fkalin ',wtkal(1),wtkal(2),Q(4,5),costhg
      endif
C Compute the weights for anomalous couplings, then
C Create the bank 'KWTK' for the event weights if they exist;
C put this bank on the output event bank list:
      IF (ISTA.EQ.0) then
          call qugacoup(0)
          WTDUM=WTANOM(DUMM)
          CALL CREKWTK
          CALL CREKWTKn
      ENDIF
      if (ista.ne.0) go to 998
C ^^^^^^^^^^^^^^^^^^^^^ JB 010320 ^^^^^^^^^^^^^^^^^^^^^^^^^
C      Call the specific routine KXP6AL to fill BOS banks
C      the secondary vertices are propagated
      CALL KXP6AL (VRTX,ISTA,NVRT,NTRK)
      if ( ista.ne.0) then
        WRITE(iw(6),
     & '('' -ERROR booking KINE/VERT AT EVENT #  '',I10)') IFI,ista
          call pylist(1)
      ENDIF
C -   book fragmentation info
      CALL KP6ZFR (IST)
      IF ( IST.ne.0) then
         ista = ista+ist
        WRITE(iw(6),
     & '('' -ERROR booking KZFR AT EVENT #  '',I10)') IFI,ist
      ENDIF
C Get interesting weights and store some in KWGT
      call KKWGT(ist)
      if ( IST.eq.0) then
         ista = ista + 1000
        WRITE(iw(6),
     &  '('' -ERROR booking KWGT AT EVENT #  '',I10)') IFI,ist
      ENDIF
      IF (MSTU(24).NE.0) THEN
        WRITE(iw(6),'(''  ---ERROR PYEXEC AT EVENT #  '',I10)') IFI
        CALL PYLIST(1)
        ISTA = -8
      ENDIF
      if (ista.ne.0) go to 998
 998  IF (ISTA.EQ.0 ) THEN
         ICOULU(10) = ICOULU(10)+1
      ELSEIF (ISTA.GT.0) THEN
         ICOULU(1) = ICOULU(1) +1
         ICOULU(9) = ICOULU(9) +1
      ELSEIF ( ISTA.LT.0) THEN
         ICOULU(-ISTA) = ICOULU(-ISTA) +1
         ICOULU(9) = ICOULU(9) +1
      ENDIF
      if ( kffin.lt.20) igflav(kffin+20) = igflav(kffin+20)+1
      if ( ista.ne.0) go to 10
      if ( kffin.lt.20) igflav(kffin) = igflav(kffin)+1
C
C  -  FILLING HISTOGRAMS
C
C      CALL MAKHISTO
       call fillhis
      call pytabu(11)
      call pytabu(21)
C
C -  ANALYSE TREE INFORMATION:
C
      CALL PYEDIT(2)
      if(ifl.eq.14) n7lu=n7lu-2
      NT=0
      NTC=0
      NNT=0
      ET=0.
      ECT=0.
      ENT=0.
      DO 30 I=1,N7LU
       if ( ifl.eq.14 .and. i.lt.3) go to 30
       NT=NT+1
       ET=ET+P7LU(I,4)
       IF(ABS(PYP(I,6)).GT.0.1)THEN
        NTC=NTC+1
        ECT=ECT+P7LU(I,4)
       ELSE
        NNT=NNT+1
        ENT=ENT+P7LU(I,4)
        pt = sqrt(P7LU(I,1)**2+P7LU(I,2)**2)
        IF(pt.LT.0.0001)THEN
C          CALL HFILL(10016,real(P7LU(I,4)),0.,1.)
          ENT=ENT-P7LU(I,4)
        ENDIF
       ENDIF
 30   CONTINUE

      RETURN
      END
*****************************************************************************
*                                                                           *
*                                                                           *
*****************************************************************************
      SUBROUTINE ASKUSI(IGCOD)
C ------------------------------------------------------------------
C - B.Bloch   January 2001
C! Initialization routine of KK2F generator
C ------------------------------------------------------------------
C
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
      COMMON /PYDAT3/ MDCY(L2PAR,3),MDME(LJNPAR,2),BRAT(LJNPAR),
     &                KFDP(LJNPAR,5)
      COMMON/PYDAT4/CHAF(L2PAR,2)
      CHARACTER CHAF*16
C
      COMMON/PYSUBS/MSEL,MSELPD,MSUB(L2PAR),KFIN(2,-40:40),CKIN(L1MST)
      COMMON/PYPARS/MSTP(L1MST),PARP(L1MST),MSTI(L1MST),PARI(L1MST)
      COMMON/PYINT1/MINT(400),VINT(400)
      COMMON/PYINT2/ISET(500),KFPR(500,2),COEF(500,20),ICOL(40,4,2)
      COMMON/PYINT3/XSFX(2,-40:40),ISIG(1000,3),SIGH(1000)
      COMMON/PYINT4/MWID(500),WIDS(500,5)
      COMMON/PYINT5/NGENPD,NGEN(0:500,3),XSEC(0:500,3)
      COMMON/PYINT6/PROC(0:500)
      CHARACTER PROC*28
C
C*CA BCS
      INTEGER LMHLEN, LMHCOL, LMHROW  ,LBCS
      PARAMETER (LMHLEN=2, LMHCOL=1, LMHROW=2, LBCS=1000)
C
      COMMON /BCS/   IW(LBCS )
      INTEGER IW
      REAL RW(LBCS)
      EQUIVALENCE (RW(1),IW(1))
C
      COMMON / GLUSTA / ICOULU(10)
      COMMON /genflav/ igflav(40)
      COMMON / GLUPAR / SVERT(3),XVRT(3),SXVRT(3),ECM,IFL,IFVRT
      REAL*4 ecm,svert,xvrt,sxvrt
 
C     SVERT    : vertex smearing, set to 1998's values by default.
C     XVRT     : vertex offset, default = 0.,0.,0.
C     SXVRT    : additionnal vertex smearing, default = 0.,0.,0.
C     ECM      : nominal cms energy
C     IFL      : KK2F flavour
C     IFVRT    : IFVRT = 0 normal smearing SVRT applied
C                        1 + offset          XVRT applied
C                        2 + extra smearing  SXVRT applied
      REAL*4 TABL(50),dum
C
      PARAMETER (LPDEC=48)
      INTEGER NODEC(LPDEC)
      INTEGER ALTABL,ALRLEP
      EXTERNAL ALTABL,ALRLEP

      REAL DIZETVER,PHOVERS,TAUOLAVER
      EXTERNAL DIZETVER,PHOVERS,TAUOLAVER
      INTEGER    IMAX
      PARAMETER (IMAX = 10000)               ! length ox xpar
      REAL*8 XPAR(IMAX)
C
C VVVVVVVVVVVVVVVVVVVVVV  JB 010320 VVVVVVVVVVVVVVVVVVVVVVVV
C
      COMMON / KALINO / IFKALIN
      COMMON / SPECX  / IFLEPTOK,INTER,XMX,DELTA
      real*8 xmx,delta
      COMMON / JUKBOX / IBOXU
      REAL*4 EPHMIN,EPHMAX,XTFMIN,XTFMAX,COSTHM
      COMMON / PHCUTS / EPHMIN,EPHMAX,XTFMIN,XTFMAX,COSTHM
      common / phacc / nphacc
      REAL*4 xpr(40)
      integer npr(40)
      COMMON /NEWMOD/  AMNEUT,NNEUT
      REAL*8           AMNEUT
C ^^^^^^^^^^^^^^^^^^^^^ JB 010320 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
C
C ---------------
C  maximum code value for IFL parameter
      PARAMETER ( IFLMX = 10 )
C    IGCOD  for KK2F
      PARAMETER ( IGCO  =  5048)
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
C -----------------------------------------------------------------
C
      IUT = IW(6)
      DO I=1,10
       ICOULU(I) = 0
      ENDDO
      do i=1,40
       igflav(i) = 0
      enddo
      call kk2f_getversion(versio)
C
C   Return generator code IGCOD
C
      IGCOD = IGCO
      WRITE(IUT,101) versio,IGCOD
 101  FORMAT(/,10X,
     &       'KK2F Version',f10.3,' CODE NUMBER =',I4,
     $       ' LAST MODIFICATION ',
     $  ' July,19 2002 '
     & ,/,10X,'***********************************************',//)

C
C  Set up some default values for masses and initial conditions
C
      CALL KK2F_DEFAULT(XPAR)

         NLUND = NAMIND ('GKK4')
         JLUND = IW(NLUND)
         I1 = 23
         i2 = 22
         IF (JLUND .NE. 0) THEN
            IFL  = IW(JLUND+1)
*   5 FLAVOUR HADRON PRODUCTION
            IF(IFL.EQ.10)THEN
             DO 9 IL=1,5
              XPAR(400+IL) = 1.D0
 9           CONTINUE
C   E+E- PRODUCTION
            ELSEIF(IFL.EQ.11)THEN
             XPAR(411) = 1.D0
C   Mu+Mu- PRODUCTION
            ELSEIF(IFL.EQ.13)THEN
             XPAR(413) = 1.D0
C   Tau+ Tau- PRODUCTION
            ELSEIF(IFL.EQ.15)THEN
             XPAR(415) = 1.D0
C   Nu Nu~ PRODUCTION
            ELSEIF(IFL.EQ.12)THEN
             XPAR(412) = 1.D0
             XPAR(414) = 1.D0
             XPAR(416) = 1.D0
             XPAR(628) = 1.D0   ! forces CEEX from v_e
             XPAR(648) = 1.D0   ! forces CEEX from v_mu
             XPAR(668) = 1.D0   ! forces CEEX from v_tau
             XPAR(28)  = 1.D0   ! Key GPS 
C  u u~ PRODUCTION
            ELSEIF(IFL.EQ.2)THEN
             XPAR(402) = 1.D0
C  d d~ PRODUCTION
            ELSEIF(IFL.EQ.1)THEN
             XPAR(401) = 1.D0
C c c~ PRODUCTION
            ELSEIF(IFL.EQ.4)THEN
             XPAR(404) = 1.D0
C s s~ PRODUCTION
            ELSEIF(IFL.EQ.3)THEN
             XPAR(403) = 1.D0
C b b~ PRODUCTION
            ELSEIF(IFL.EQ.5)THEN
             XPAR(405) = 1.D0
C user defined final state
            ELSEIF(IFL.EQ.99)THEN
             WRITE(IUT,*) 'YOU HAVE REQUESTED a user/XPAR setup '
            ENDIF
C VVVVVVVVVVVVVVVVVVVVVV  JB 010320 VVVVVVVVVVVVVVVVVVVVVVVV
C Default parameters for anomalous couplings, see kzphynew for comments
      IBOXU    = 0
      IFKALIN  = 0
      IFLEPTOK = 0
      INTER    = -1
      XMX      = 1000.
      DELTA    = -0.2
C Default values for photon cuts
      EPHMIN=1.
      EPHMAX=1000.
      XTFMIN=0.
      XTFMAX=1.
      COSTHM=1.
      nphacc = 1
C ^^^^^^^^^^^^^^^^^^^^^ JB 010320 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
C*******
            ECM  = RW(JLUND+2)
            IPRT = IW(JLUND+3)
            AMZ =  RW(JLUND+4)
            AMH =  RW(JLUND+5)
            AMT =  RW(JLUND+6)
         ELSE
            IFL = 0
            ECM = 91.2
            IPRT = 0
            AMZ = 91.187
            AMH = 100.0
            AMT = 175.
         ENDIF
C         do il=1,16
C          print *,'flav type',il,xpar(400+il)
C         enddo 

         XPAR(1) = ECM       !CENTER OF MASS ENERGY
         XPAR(5) = dble(IPRT)!PRINTOUT LEVEL
         XPAR(502) = AMZ     ! Z MASS
         XPAR(505) = AMH     ! HIGGS MASS
         XPAR(506) = AMT     ! TOP MASS
C -  INPUT relative to ISR and FSR
         NRAD = NAMIND ('GKKR')
         JRAD = IW(NRAD)
         IF (JRAD .NE. 0) THEN
          XPAR(20) = RW(JRAD+1)  !ISR ON/OFF (=1/0)
          XPAR(21) = RW(JRAD+2)  !FSR ON/OFF (=1/0) 
          XPAR(27) = RW(JRAD+3)  !ISR FSR Interference ON/OFF (=2/0)
          XPAR(29) = RW(JRAD+4)  !PHOTON FROM FINAL QUARK ON/OFF (0/1)
         ENDIF
C - input for tau decays   GTAU card
         jtau = iw(namind('GTAU'))
         if ( jtau.gt.0) then
           xpar(2001) = dble(iw(jtau+1))
           xpar(2002) = dble(iw(jtau+2))
           xpar(2004) = dble(iw(jtau+4))
           xpar(2005) = dble(rw(jtau+5))
           xpar(2008) = dble(rw(jtau+6))
           xpar(2009) = dble(rw(jtau+7))   
         endif
C - input for Tau branching ratios GKBR card
         jkbr = iw(namind('GKBR'))
         if ( jkbr.gt.0) then
           xpar(2010) = dble(rw(jkbr+1))
           xpar(2011) = dble(rw(jkbr+4))
           xpar(2012) = dble(rw(jkbr+2))
           xpar(2013) = dble(rw(jkbr+3))
           sum = 0.
           do i = 1,22
                sum = sum + rw(jkbr+4+i)
           enddo
           do i = 1,22
              xpar(2100+i) = dble(rw(jkbr+4+i)/sum)
           enddo
         endif
C VVVVVVVVVVVVVVVVVVVVV JB 010320 VVVVVVVVVVVVVVVVVVVVVVV
C
C  Input for anomalous coupling parameters from CARD GKR9
C
      NAKOR9 = NAMIND('GKR9')
      JKOR9 = IW(NAKOR9)
      IF(JKOR9.NE.0) THEN
        IBOXU   = IW(JKOR9+1)
        IFKALIN = IW(JKOR9+2)
        IFLEPTOK= IW(JKOR9+3)
        INTER   = IW(JKOR9+4)
        XMX     = RW(JKOR9+5)
        DELTA   = RW(JKOR9+6)
      ENDIF
C
C  Input for special cuts from CARD GCUT
C
      NAPHCU = NAMIND('GCUT')
      JPHCU = IW(NAPHCU)
      IF(JPHCU.NE.0) THEN
        EPHMIN  = RW(JPHCU+1)
        EPHMAX  = RW(JPHCU+2)
        XTFMIN  = RW(JPHCU+3)
        XTFMAX  = RW(JPHCU+4)
        COSTHM  = RW(JPHCU+5)
        if (iw(JPHCU).ge.6) nphacc = nint(RW(JPHCU+6))
      ENDIF
C ^^^^^^^^^^^^^^^^^^^^^ JB 010320 ^^^^^^^^^^^^^^^^^^^^^^^^^
C - input of any input parameter in case it's not foreseen in a card
         NAMI=NAMIND('XPAR')
         IF (IW(NAMI).EQ.0) GOTO 50
         KIND=NAMI+1
   15    KIND=IW(KIND-1)
         IF (KIND.EQ.0) GOTO 49
         LUPAR = LUPAR+1
         J = IW(KIND-2)
         xpar(j) = dble(rw(kind+1))
         go to 15
   49    CONTINUE
         CALL BKFMT ('XPAR','F')
         CALL BLIST (IW,'C+','XPAR')
   50    CONTINUE
         IF ((XPAR(20).EQ.0.D0 .OR. XPAR(21).EQ.0.D0) .AND. 
     &       (XPAR(27).NE.0.D0)) THEN
C no Interference from quarks if No FSR requested
          if (xpar(401)+xpar(402)+xpar(403)+xpar(404)+xpar(405)
     &                 .gt.0) then
          WRITE(IUT,*) '******** WARNING, ********'
          WRITE(IUT,*) 'YOU HAVE REQUESTED ISR/FSR INTERFERENCE'
          WRITE(IUT,*) 'WITH ISR OFF ? ',XPAR(20)
          WRITE(IUT,*) 'OR FSR OFF ?   ',XPAR(21)
          call exit
          endif
         ENDIF
         IF (XPAR(20).EQ.0.D0 .AND. XPAR(21).EQ.0.D0) THEN
          WRITE(IUT,*) '******** WARNING, ********'
          WRITE(IUT,*) 'YOU HAVE REQUESTED NO ISR AND NO FSR'
          WRITE(IUT,*) 'THIS IS NOT ALLOWED IN gps_partitionstart'
         ENDIF
         IF ( XPAR(412).gt.0.d0 .and.XPAR(628).lt.1.d0) go to  51
         IF ( XPAR(414).gt.0.d0 .and.XPAR(648).lt.1.d0) go to  51
         IF ( XPAR(416).gt.0.d0 .and.XPAR(668).lt.1.d0) go to  51
         go to 52
 51      WRITE(IUT,*) '******** WARNING, ********'
         WRITE(IUT,*) 'YOU HAVE REQUESTED Neutrino final State and EEX'
         WRITE(IUT,*) 'should be CEEX : xpar(628,648,668)=1. '
         call exit
 52      continue
C - 
         CALL KK2f_Initialize(xpar)                  ! initialize generator
C - make use of a smearing of the vertex  if it is given
         NSVER = NAMIND ('SVRT')
         JSVER = IW(NSVER)
         IF (JSVER .NE. 0) THEN
            SVERT(1) = RW(JSVER+1)
            SVERT(2) = RW(JSVER+2)
            SVERT(3) = RW(JSVER+3)
         ELSE
            SVERT(1) = 0.0113
            SVERT(2) = 0.0005
            SVERT(3) = 0.79
         ENDIF
C   get an offset for position of interaction point
C   if needed get a smearing on this position
C   XVRT    x      y      z    ( sz    sy    sz)
C
        call vzero(XVRT,3)
        CALL VZERO(SXVRT,3)
        IFVRT = 0
        NAXVRT=NAMIND('XVRT')
        JXVRT=IW(NAXVRT)
        IF (JXVRT.NE.0) THEN
           IFVRT = 1
           XVRT(1)=RW(JXVRT+1)
           XVRT(2)=RW(JXVRT+2)
           XVRT(3)=RW(JXVRT+3)
           IF ( IW(JXVRT).gt.3) then
              IFVRT = 2
              SXVRT(1)=RW(JXVRT+4)
              SXVRT(2)=RW(JXVRT+5)
              SXVRT(3)=RW(JXVRT+6)
           ENDIF
        ENDIF
C
C   Issue the relevant parameters
C
      WRITE (IUT,1000)
      WRITE (IUT,1007)
 1000 FORMAT(1X,78('*'),/,/,10X,'WELCOME TO KK2F & PYTHIA 6.1'/
     $                      10X,'                                   '/)
 1007 FORMAT (1X,78('*') )
C
C -- complete PART bank with LUND  particles
C    use the library routine KXP6IN
      CALL KXP6IN (IPART,IKLIN)
      IF (IPART.LE.0 .OR. IKLIN.LE.0) THEN
         WRITE (IW(6),'(1X,''error in PART or KLIN bank - STOP - ''
     +                 ,2I3)') IPART,IKLIN
         CALL EXIT
      ENDIF
C  do not ask for FSR in JETSET if already here in KK2f
      sum = xpar(401)+xpar(402)+xpar(403)+xpar(404)+xpar(405)
      IF (XPAR(21).gt.0.D0 .AND. sum.gt. 0.) THEN
        WRITE(IUT,*) 'YOU HAVE REQUESTED FSR AND quark final state '
        WRITE(IUT,*) 'FSR in Parton shower is disabled '
        MSTJ(41) = 1             ! only gluon emission
      ENDIF
C   Make sure that masses in PART bank are consistent
C   in case they have been modified by data cards
      NAPAR = NAMIND('PART')
C This is the aleph number of the Z0(lund code=23),top (6) and Higgs(25)
C function KGPART returns the ALEPH code corresponding to the LUND code
C required.
      JPART = IW(NAPAR)
      IZPART = KGPART(23)
      IF (IZPART.GT.0)  THEN
        PMAS(PYCOMP(23),1) = amz
        ZMAS = PMAS(PYCOMP(23),1)
        KPART = KROW(JPART,IZPART)
        RW(KPART+6)=ZMAS
        IANTI = ITABL(JPART,IZPART,10)
        IF (IANTI.NE.IZPART) THEN
          KAPAR = KROW(JPART,IANTI)
          RW(KAPAR+6)=ZMAS
        ENDIF
      ENDIF
      ITPART = KGPART(6)
      IF (ITPART.GT.0)  THEN
        PMAS(PYCOMP( 6),1) = amt
        ZMAS = PMAS(PYCOMP( 6),1)
        KPART = KROW(JPART,ITPART)
        RW(KPART+6)=ZMAS
        IANTI = ITABL(JPART,ITPART,10)
        IF (IANTI.NE.ITPART) THEN
          KAPAR = KROW(JPART,IANTI)
          RW(KAPAR+6)=ZMAS
        ENDIF
      ENDIF
      IHPART = KGPART(25)
      IF (IHPART.GT.0)  THEN
        PMAS(PYCOMP(25),1) = amh
        ZMAS = PMAS(PYCOMP(25),1)
        KPART = KROW(JPART,IHPART)
        RW(KPART+6)=ZMAS
        IANTI = ITABL(JPART,IHPART,10)
        IF (IANTI.NE.IHPART) THEN
          KAPAR = KROW(JPART,IANTI)
          RW(KAPAR+6)=ZMAS
        ENDIF
      ENDIF
C
C - Print PART and KLIN banks
      IF (IPRT.GT.0) CALL PRPART
      IF (IPRT.GT.1) CALL PYLIST(12)
      IF (IPRT.LE.1) then
        if ( i1.gt.0) call kxp6st(i1)
        if ( i2.gt.0) call kxp6st(i2)
      endif
C
C -- get list of  particle# which should not be decayed
C    in LUND  because they are decayed in GALEPH.
C    the routines uses the KLIN bank and fills the user array
C    NODEC in the range [1-LPDEC]
      MXDEC = KNODEC (NODEC,LPDEC)
      MXDEC = MIN (MXDEC,LPDEC)
C
C -- inhibit decays in LUND
C    If the user has set some decay channels by data cards they will
C    will not be overwritten
      IF (MXDEC .GT. 0) THEN
         DO 40 I=1,MXDEC
            IF (NODEC(I).GT.0) THEN
               JIDB = NLINK('MDC1',NODEC(I))
               IF (JIDB .EQ. 0) MDCY(PYCOMP(NODEC(I)),1) = 0
            ENDIF
   40    CONTINUE
      ENDIF
C
C   dump the generator parameters for this run in a bank
C assume all parameters are real and stored as a single row
C      print *,versio
C      phver = phovers(dum)
C      print *,phver
      TABL(1) = versio
      TABL(2) = phovers(dum)
      TABL(3) = 0.01*dizetver(dum)
      TABL(4) = tauolaver(dum)
      TABL(5) = FLOAT(IFL)
      TABL(6) = ECM
      TABL(7) = amz
      TABL(8) = amh
      TABL(9) = amt
      TABL(10) = xpar(20)   ! keyisr
      TABL(11) = xpar(21)   ! keyfsr
      TABL(12) = xpar(27)   ! keyint
      TABL(13) = xpar(29)   ! keyQSR
      DO 11 I=1,3
      TABL(16+I) = XVRT(I)
      TABL(19+I) = sXVRT(I)
 11   TABL(13+I) = SVERT(I)
      NWB =  22
      IND = ALTABL('KPAR',NWB,1,TABL,'2I,(F)','C')
C create KORL bank from Tauola initialization
      NCHAN = 22
      NCOL = NCHAN+5
      NROW = 1
      tabl(1) = tauolaver(dum)
      tabl(2) = xpar(2010)
      tabl(3) = xpar(2012)
      tabl(4) = xpar(2013)
      tabl(5) = xpar(2011)
      sum = 0.
      DO 57 IBR = 1,22
          sum = sum + xpar(2100+ibr)
          tabl(5+IBR) = xpar(2100+ibr)
 57   CONTINUE
      write(iut,*) ' Tau branching fractions used add up to',sum
      JKORL = ALTABL('KORL',NCOL,NROW,tabl,'2I,(F)','C')

C  Fill RLEP bank
      IEBEAM = NINT(ECM* 500. )
      JRLEP = ALRLEP(IEBEAM,'    ',0,0,0)
      CALL PRTABL('RLEP',0)
      CALL PRTABL('KPAR',0)
      CALL PRTABL('KORL',0)
C
C -   keep fragmentation info
      MSTU(17) = 1
      call pytabu(10)
      call pytabu(20)
C VVVVVVVVVVVVVVVVVVVVVVVVVV  JBO 010320 VVVVVVVVVVVVVVVVVVVVVVV
C Initialize the anomalous coupling code:
      amneut=0.0d0 
      nneut=3
      npr(15)=ifkalin
      call kzphynew(xpr,npr)
      call qugacoup(-1)
C
C ^^^^^^^^^^^^^^^^^^^^^^^^^^  JBO 010320 ^^^^^^^^^^^^^^^^^^^^^^
C
C  -  BOOKING HISTOGRAMS
C
        call bookhis

 99   CONTINUE
      RETURN
      END
      SUBROUTINE USCJOB
C-------------------------------------------------------------------
C! End of job routine    KK2F
C
C   To be filled by user to print any relevant info
C
C------------------------------------------------------------------
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
      COMMON /PYDAT3/ MDCY(L2PAR,3),MDME(LJNPAR,2),BRAT(LJNPAR),
     &                KFDP(LJNPAR,5)
      COMMON/PYDAT4/CHAF(L2PAR,2)
      CHARACTER CHAF*16
C
      COMMON/PYSUBS/MSEL,MSELPD,MSUB(L2PAR),KFIN(2,-40:40),CKIN(L1MST)
      COMMON/PYPARS/MSTP(L1MST),PARP(L1MST),MSTI(L1MST),PARI(L1MST)
      COMMON/PYINT1/MINT(400),VINT(400)
      COMMON/PYINT2/ISET(500),KFPR(500,2),COEF(500,20),ICOL(40,4,2)
      COMMON/PYINT3/XSFX(2,-40:40),ISIG(1000,3),SIGH(1000)
      COMMON/PYINT4/MWID(500),WIDS(500,5)
      COMMON/PYINT5/NGENPD,NGEN(0:500,3),XSEC(0:500,3)
      COMMON/PYINT6/PROC(0:500)
      CHARACTER PROC*28
      COMMON/PYINT7/SIGT(0:6,0:6,0:5)
C
C
      COMMON / GLUPAR / SVERT(3),XVRT(3),SXVRT(3),ECM,IFL,IFVRT
      REAL*4 ecm,svert,xvrt,sxvrt
      COMMON /genflav/ igflav(40)
      COMMON / GLUSTA / ICOULU(10)
      INTEGER LMHLEN, LMHCOL, LMHROW  ,LBCS
      PARAMETER (LMHLEN=2, LMHCOL=1, LMHROW=2, LBCS=1000)
C
      COMMON /BCS/   IW(LBCS )
      INTEGER IW
      REAL RW(LBCS)
      EQUIVALENCE (RW(1),IW(1))
C
C.......................................................................
C
C
      CALL KK2f_Finalize                  ! final bookkeping, printouts etc.
      CALL UGTSEC


       IUT=IW(6)
       WRITE(IUT,101)
  101  FORMAT(//20X,'EVENTS STATISTICS',
     &         /20X,'*****************')
       WRITE(IUT,102) ICOULU(9)+ICOULU(10),ICOULU(10),ICOULU(9)
  102  FORMAT(/5X,'# OF GENERATED EVENTS                = ',I10,
     &        /5X,'# OF ACCEPTED  EVENTS                = ',I10,
     &        /5X,'# OF REJECTED  EVENTS                = ',I10)
       do i=1,16
       if (igflav(i).gt.0) WRITE(IUT,103) i,igflav(i+20)
       if (igflav(i).gt.0) WRITE(IUT,104) i,igflav(i)
       enddo
  103  FORMAT(/5X,' flavor code',i5,'# OF GENERATED EVENTS = ',I10)
 104   FORMAT(/5X,' flavor code',i5,'# OF  ACCEPTED EVENTS = ',I10)
      call pytabu(12)
      call pytabu(22)
      RETURN
      END
      SUBROUTINE KKWGT(ist)
C-------B.Bloch march 2k ------------------- 
C    stored some interesting weights for each event
C    in bank KWGT. If all ok ist = 1, if one or more booking pb, ist=0
C-------------------------------------------------------------------------
      INTEGER     len      ! maximum number of auxiliary weights in WtSet
      PARAMETER ( len = 1000)
      Double precision wtmain,wtset(len)
      INTEGER  kwgtbk
      EXTERNAL kwgtbk 
      ist = 1
      call kk2f_getwtlist(wtmain,wtset)
      weik = wtset(71)    ! Born
      ind = kwgtbk(1,1,weik)
      if (ind.le.0) ist = 0
      weik = wtset(72)    ! 1st order
      ind = kwgtbk(2,2,weik)
      if (ind.le.0) ist = 0
      weik = wtset(73)    ! 2nd order
      ind = kwgtbk(3,3,weik)
      if (ind.le.0) ist = 0
      weik = wtset(74)    ! 3rd order
      ind = kwgtbk(4,4,weik)
      if (ind.le.0) ist = 0
      weik = wtset(201)    ! FSR order 0
      ind = kwgtbk(5,11,weik)
      if (ind.le.0) ist = 0
      weik = wtset(202)    ! FSR 1st order
      ind = kwgtbk(6,12,weik)
      if (ind.le.0) ist = 0
      weik = wtset(203)    ! FSR 2nd order
      ind = kwgtbk(7,13,weik)
      if (ind.le.0) ist = 0
      weik = wtset(251)    ! FSR order 0 no interf
      ind = kwgtbk(8,21,weik)
      if (ind.le.0) ist = 0
      weik = wtset(252)    ! FSR 1st order no interf
      ind = kwgtbk(9,22,weik)
      if (ind.le.0) ist = 0
      weik = wtset(253)    ! FSR 2nd order no interf
      ind = kwgtbk(10,23,weik)
      if (ind.le.0) ist = 0
      weik = wtset(213)    ! Virtual pairs and IFI ON 
      ind = kwgtbk(11,31,weik)
      if (ind.le.0) ist = 0
      weik = wtset(263)    ! Virtual pairs and IFI Off
      ind = kwgtbk(12,32,weik)
      if (ind.le.0) ist = 0
      RETURN
      END
      SUBROUTINE UGTSEC
*-------B.Bloch dec 99 -------------------
C     get the cross section at any time in the program ...
*//////////////////////this is kk2f.h/////////////////////////////////////////
      DOUBLE PRECISION    m_version
      CHARACTER*14        m_Date
      PARAMETER ( m_Version     =          4.141d0 ) 
      PARAMETER ( m_Date        =  ' 30 Jan. 2001') 
*////////////////////////////////////////////////////////////////////////////
      INTEGER     m_phmax             ! maximum photon multiplicity ISR+FSR
      PARAMETER ( m_phmax = 100)
      INTEGER     m_jlim
      PARAMETER(  m_jlim  = 10000)
      INTEGER     m_lenwt       ! maximum number of auxiliary weights in WtSet
      PARAMETER ( m_lenwt = 1000)
*/////////////////////////////////////////////////////////////////////////////
      DOUBLE PRECISION       m_xpar,   m_ypar
      INTEGER     m_out,    m_Idyfs,  m_nevgen, m_idgen,  m_KeyWgt
      INTEGER            m_npmax,  m_idbra,  m_nphot
      INTEGER     m_KeyHad, m_KeyISR, m_KeyFSR, m_KeyINT,  m_KeyGPS
      INTEGER            m_Phel,   m_isr,    m_KFini,  m_IsBeamPolarized
      DOUBLE PRECISION m_CMSene, m_DelEne, m_Xcrunb, m_WTmax,m_HadMin,
     &                    m_MasPhot,  m_Emin
      DOUBLE PRECISION       m_BornCru,m_WtCrud, m_WtMain, m_sphot
      DOUBLE PRECISION       m_WtSet,m_WtList,m_alfinv,m_vcut,m_Xenph
      DOUBLE PRECISION       m_p1,     m_p2,     m_q1,     m_q2
      DOUBLE PRECISION       m_PolBeam1,         m_PolBeam2
      DOUBLE PRECISION       m_xSecPb, m_xErrPb
*
      COMMON /c_KK2f/
     $    m_CMSene,           ! CMS energy average
     $    m_PolBeam1(4),      ! Spin Polarization vector first beam
     $    m_PolBeam2(4),      ! Spin Polarization vector second beam
     $    m_DelEne,           ! Beam energy spread [GeV]
     $    m_HadMin,           ! minimum hadronization energy [GeV]
     $    m_xpar(m_jlim),  ! input parameters, READ ONLY, never touch them!!!! 
                              ! them!!!!
     $    m_ypar(m_jlim),     ! debug facility
     $    m_WTmax,            ! maximum weight
     $    m_alfinv,           ! inverse alfaQED
     $    m_Emin,             ! minimum real photon energy, IR regulator
     $    m_MasPhot,          ! ficticious photon mass,     IR regulator
     $    m_Xenph,            ! Enhancement factor for Crude photon multiplicity
     $    m_vcut(3),   ! technical cut on E/Ebeam for non-IR real contributions
     $    m_xSecPb,           ! output cross-section available through getter
     $    m_xErrPb,           ! output crossxsection available through getter
*----------- EVENT-----------------
     $    m_p1(4),            ! e- beam
     $    m_p2(4),            ! e+ beam
     $    m_q1(4),            ! final fermion
     $    m_q2(4),            ! final anti-fermion
     $    m_sphot(m_phmax,4), ! photon momenta
     $    m_WtMain,           ! MAIN weight of KK2f
     $    m_WtCrud,           ! crude distr from ISR and FSR
     $    m_WtSet(m_lenwt),   ! complete list of weights
     $    m_WtList(m_lenwt),  ! complete list of weights
     $    m_Xcrunb,           ! crude in nanobarns
     $    m_BornCru,          ! Crude Born
     $    m_isr( m_phmax),    ! =1 for isr, 0 for fsr
     $    m_Phel(m_phmax),    ! photon helicity =1,0 for +,-
     $    m_nphot,            ! Total Photon multiplicity
*----------------------------------
     $    m_IsBeamPolarized,  ! status of beam polarization
     $    m_KFini,            ! KF of beam fermion
     $    m_KeyWgt,           ! weight=1 on/off switch
     $    m_KeyHad,           ! hadronization switch
     $    m_nevgen,           ! serial number of the event
     $    m_npmax,            ! maximum photon multiplicity
     $    m_KeyISR,           ! ISR switch
     $    m_KeyFSR,           ! FSR switch
     $    m_KeyINT,           ! ISR/FSR INTereference switch
     $    m_KeyGPS,           ! New exponentiation switch
     $    m_out,              ! output unit number
     $    m_Idyfs,            ! pointer for histograming
     $    m_idbra,            ! pointer for brancher
     $    m_idgen             ! special histogram for this generator
      DOUBLE PRECISION       xkarl,error,erkarl,erabs
      DOUBLE PRECISION       errela,averwt
      DOUBLE PRECISION       xsmc,erel
      DOUBLE PRECISION       WTsup
      DOUBLE PRECISION              BornV_Sig0nb,BornV_Integrated 
      DOUBLE PRECISION       AvUnd, AvOve
      DOUBLE PRECISION XSECPB, XERRPB
      INTEGER LMHLEN, LMHCOL, LMHROW  ,LBCS
      PARAMETER (LMHLEN=2, LMHCOL=1, LMHROW=2, LBCS=1000)
      COMMON /BCS/   IW(LBCS )
      INTEGER IW
      REAL RW(LBCS)
      EQUIVALENCE (RW(1),IW(1))
      integer icoulu,igflav
      COMMON / GLUSTA / ICOULU(10)
      COMMON /genflav/ igflav(40)
      integer ito,LevelPrint,idc,iver,ntot,nacc,iut,is,isec,i
      integer Nneg, Nove, Nzer,KSECBK
      real*8 sig0pb,xBorPb
      real*4 XTOT,RTOT,XACC,RACC,big,XPART,eps
      DATA ITO/0/
      data big/ 1000./             !   nb to pb
      SAVE ITO
      ITO = ITO + 1      
      IF (ITO.EQ.1) THEN
      sig0pb =  BornV_Sig0nb(m_CMSene)*1000d0
      xBorPb =  BornV_Integrated(0d0,m_CMSene**2) * sig0pb
* Crude from karLud + printout
      LevelPrint = 0
      CALL KarLud_Finalize(LevelPrint,xkarl,error)
      erkarl = 0d0

* Printout from Karfin
      CALL KarFin_Finalize(LevelPrint)

* Average of the main weight
      CALL GLK_MgetAve(m_idbra, AverWt, ErRela, WtSup)

* main X-section = crude * <WtMain>
      xsmc   =  xkarl*averwt
      erel   =  SQRT(erkarl**2+errela**2)
      erabs  =  xsmc*erel
* The final cross section exported to user
* through getter KK2f_GetXsecMC(xSecPb, xErrPb)
      xSecPb =  xsmc*sig0pb     ! MC xsection in picobarns
      xErrPb =  xSecPb*erel     ! Its error   in picobarns
      print *,' x-section (pb)',xSecPb,' +-',xErrPb
      XTOT = xSecPb/big
      RTOT = xErrPb/big
      ELSEIF (ITO.GT.1) then 
       CALL KK2f_GetXsecMC(xSecPb, xErrPb) ! get MC x-section    
      print *,' x-section (pb)',xSecPb,' +-',xErrPb
         XTOT = xSecPb/big
         RTOT = xErrPb/big
      endif
      IDC = 5047
      IVER = 100*m_Version
      NTOT = ICOULU(10)+icoulu(9)
      NACC = ICOULU(10)             ! 
      XACC = XTOT*float(nacc)/float(ntot)                   !
      RACC = RTOT*xtot/xacc
      racc = racc*sqrt(1./float(nacc)-1./float(ntot))                   !
      is =1
C

      IUT=IW(6)
      WRITE (IUT,*) '******* KK2F CROSS-SECTION ************'
      WRITE (IUT,*) '** CROSS-SECTION BANK CREATED WITH *******'
      WRITE (IUT,*) 'XS =',XTOT,' +- ',RTOT,' nb'
      WRITE (IUT,*) 'NUMBER OF EVENTS :', NTOT

      ISEC =  KSECBK(IS,IDC,IVER,NTOT,NACC,XTOT,RTOT,XACC,RACC)
C      ENDIF
      do i=1,16
          if (igflav(i).gt.0) is = is+1
      enddo
      if (is.eq.2 )  go to 100
      is =1
      do i=1,16
        if (igflav(i).gt.0) then
          is = is+1
          CALL GLK_MgetAve(m_idbra+1, AverWt, ErRela, WtSup)
          NTOT = igflav(i+20)
          NACC = igflav(i)
          eps = float(igflav(i+20))/float(icoulu(10)+icoulu(9))
C          deps = 1./float(igflav(i)) - 1./float(icoulu(10))
          XPART = XTOT*eps
          XACP = XACC*float(igflav(i))/float(icoulu(10))
          RTOT = XPART*errela
C          RTOT = xparT*sqrt(deps + erel*erel )
          RACC = RTOT
      ISEC =  KSECBK(IS,IDC,I,NTOT,NACC,XPART,RTOT,XACP,RACC)
        endif
      enddo
 100  continue
      CALL PRTABL('KSEC',0)
      return
      END

      SUBROUTINE fillhis
      real*8  pf1(4),pf2(4),phot(100,4)
      
      call HepEvt_GetFfins(pf1,pf2)
      e1 = pf1(4)
      e2 = pf2(4)
      call hfill (10001,e1,dum,1.)
      call hfill (10002,e2,dum,1.)
      call HepEvt_GetKFfin(KFfin)
      call hfill (10003,float(kffin),dum,1.)
      call HepEvt_GetPhotIni(nphot,phot)
      call hfill (10004,float(nphot),dum,1.)
      if ( nphot.gt.0) then
        do i=1,nphot
           eg = phot(i,4)
           call hfill(10005,eg,dum,1.)
        enddo
      endif
C      call HepEvt_GetPhotBst(nphot,phot)
C      call hfill (10006,float(nphot),dum,1.)
C      if ( nphot.gt.0) then
C        do i=1,nphot
C           eg = phot(i,4)
C           call hfill(10007,eg, dum,1.)
C        enddo
C      endif
      call HepEvt_GetPhotFin(nphot,phot)
      call hfill (10008,float(nphot),dum,1.)
      if ( nphot.gt.0) then
        do i=1,nphot
           eg = phot(i,4)
           call hfill(10009,eg,dum,1.)
        enddo
      endif
      return
      entry bookhis
      call hbook1 (10001,'Energy fermion 1 ',50,0.,150.,0.)
      call hbook1 (10002,'Energy fermion 2 ',50,0.,150.,0.)
      call hbook1 (10003,'fermion codes  ',20,0.,20.,0.)
      call hbook1 (10004,'Nbr ISR photons per event ',50,0.,50.,0.)
      call hbook1 (10005,'Energy ISR photons',50,0.,100.,0.)
      call hbook1 (10006,'Nbr Beam photons ',50,0.,50.,0.)
      call hbook1 (10007,'Energy Beam photons ',50,0.,100.,0.)
      call hbook1 (10008,'Nbr FSR photons',50,0.,50.,0.) 
      call hbook1 (10009,'Energy FSR photons',50,0.,100.,0.)
      return
      end
      SUBROUTINE MAKHISTO
      IMPLICIT DOUBLE PRECISION(A-H, O-Z)

      REAL*8    p1(4),p2(4),p3(4),p4(4)
      INTEGER   nbv, idv, it, KFfin
      REAL*8    ss2, vv, ss, vmin,  vmax

      REAL*8 PX,PY,PZ,ETOT,SPH,APL,THR,OBL
      REAL*8 PXG,PYG,PZG,EG
      REAL*8 PXKK,PYKK,PZKK,ETOTKK
      INTEGER NT,NTKK,MCONV,NPI,NPIKK,NG
      INTEGER LREC,ISTAT,IDVF,NWPAWC,ICYCLE,NVAR,NVARP

      INTEGER nmxhep         ! maximum number of particles
      PARAMETER (nmxhep=2000)
      REAL*8  phep, vhep
      INTEGER nevhep, nhep, isthep, idhep, jmohep, jdahep
      COMMON /d_hepevt/
     $     nevhep,           ! serial number
     $     nhep,             ! number of particles
     $     isthep(nmxhep),   ! status code
     $     idhep(nmxhep),    ! particle ident KF
     $     jmohep(2,nmxhep), ! parent particles
     $     jdahep(2,nmxhep), ! childreen particles
     $     phep(5,nmxhep),   ! four-momentum, mass [GeV]
     $     vhep(4,nmxhep)    ! vertex [mm]

      PARAMETER (LJNPAR=4000)
      COMMON/PYJETS/N7LU,NPAD,K7LU(LJNPAR,5),P7LU(LJNPAR,5),
     $              V7LU(LJNPAR,5)

      PARAMETER (NVAR = 20)
      REAL VAR(NVAR)
      PARAMETER (NVARP = 4)
      REAL PHOT(NVARP)

         DO it=1,4
            p1(it) =phep(it,1)    ! first  beam
            p2(it) =phep(it,2)    ! second beam
            p3(it) =phep(it,3)    ! first fermion
            p4(it) =phep(it,4)    ! second fermion
         ENDDO
         KFfin = idhep(3)     ! Pythia manual, page 53 !

         ss  =  (p1(4)+p2(4))**2 -(p1(3)+p2(3))**2 
     &          -(p1(2)+p2(2))**2 -(p1(1)+p2(1))**2
         ss2 =  (p3(4)+p4(4))**2 -(p3(3)+p4(3))**2 
     &          -(p3(2)+p4(2))**2 -(p3(1)+p4(1))**2

         vv  = 1d0 -ss2/ss

* loop on not decayed particle - lujets
         call vzero(var, nvar)
         px     = 0.0
         py     = 0.0
         pz     = 0.0
         etot   = 0.0 
         nt     = 0
         npi    = 0
         pxg    = 0.0
         pyg    = 0.0
         pzg    = 0.0
         eg     = 0.0
         ng     = 0
   
         DO it = 3,n7LU
          IF (K7LU(it,1).ge.1 .and. K7LU(it,1).le.10) THEN
* calculate cos theta 
           ct = p7LU(it,3) / sqrt (p7LU(it,4)**2 - p7LU(it,5)**2)
           IF (abs(ct).lt.0.95) THEN 
            px = p7LU(it,1) + px
            py = p7LU(it,2) + py
            pz = p7LU(it,3) + pz
            etot = p7LU(it,4) + etot
            nt = nt  + 1 
            IF (abs(K7LU(it,2)).eq.211) npi = npi + 1
           ENDIF
          ENDIF
         ENDDO

* Take JETSET to HEPEVT routine, and do JETSET to D_HEPEVT

         MCONV  = 1
         call pyhepc(mconv)
C         CALL HEPEVT_LUHEPC(MCONV)
* Check with previous result         
         pxkk = 0.0
         pykk = 0.0
         pzkk = 0.0
         etotkk = 0.0 
         ntkk = 0
         npikk = 0

         DO it = 3,nhep
          IF (isthep(it).eq.1) THEN
* calculate cos theta 
           ct = phep(3,it) / sqrt (phep(4,it)**2 - phep(5,it)**2)
           IF (abs(ct).lt.0.95) THEN 
            pxkk = phep(1,it) + pxkk
            pykk = phep(2,it) + pykk
            pzkk = phep(3,it) + pzkk
            etotkk = phep(4,it) + etotkk
            ntkk = ntkk  + 1 
            IF (abs(IDHEP(it)).eq.211) npikk = npikk + 1
           ENDIF
* photons
           IF(idhep(it).eq.22 .and. jmohep(1,it).eq.1) THEN
            PHOT(1) = phep(1,it)
            PHOT(2) = phep(2,it)
            PHOT(3) = phep(3,it)
            PHOT(4) = phep(4,it)
            PXG = PXG + PHOT(1)
            PYG = PYG + PHOT(2)
            PZG = PZG + PHOT(3)
            EG  = EG  + PHOT(4)
            NG = NG + 1
            CALL HFN(501,PHOT)
           ENDIF
          ENDIF
         ENDDO
***********************************************************************
* Event analysis routine from PYTHIA                                  *
* all particles with K(it,1).ge.1 .and. K(it,1).le.10 considered      *
***********************************************************************     
         CALL PYSPHE(SPH, APL)
         CALL PYTHRU(THR, OBL)
*******************
* Histo filling...*
*******************
         VAR(1) = vv
         VAR(2) = float(nt)
         VAR(3) = px
         VAR(4) = py
         VAR(5) = pz
         VAR(6) = etot
         VAR(7) = float(ntkk)
         VAR(8) = etotkk
         VAR(9) = float(KFfin)
         VAR(10) = float(npi)
         VAR(11) = float(npikk)
         VAR(12) = sph
         VAR(13) = apl
         VAR(14) = thr
         VAR(15) = obl
         VAR(16) = pxg
         VAR(17) = pyg
         VAR(18) = pzg
         VAR(19) = eg
         VAR(20) = float(ng)

C         CALL HFN(500,VAR)

      RETURN
      END
      SUBROUTINE CREKWTK
C --------------------------------------------------------------------
C Create the bank of event weights 'KWTK'
C and put it on the event list bank
C                                J. Boucrot 02 April 1997
C--------------------------------------------------------------------
C     input     : none
C
C     output    : bank 'KWTK' with 1 row containing the
C                 6 event weights
C--------------------------------------------------------------------
      INTEGER LMHLEN, LMHCOL, LMHROW  ,LBCS
      PARAMETER (LMHLEN=2, LMHCOL=1, LMHROW=2, LBCS=1000)
C
      COMMON /BCS/   IW(LBCS )
      INTEGER IW
      REAL RW(LBCS)
      EQUIVALENCE (RW(1),IW(1))
C
      DATA EPSIL / 0.01 /
      COMMON / KALINOUT /  WTKAL(6)
      real*8 wtkal
      real weigh(6)
C--------------------------------------------------------------------
      NWEIG=6
      DO 10 I=1,NWEIG
         WEIGH(I)=SNGL(WTKAL(I))
         IF (I.GT.1.AND.WEIGH(1).GT.0.) WEIGH(I)=WEIGH(I)/WEIGH(1)
 10   CONTINUE
      IF (WEIGH(1).LT.EPSIL) GO TO 999
      ind = KWTKBK(1,weigh)
C
 999  RETURN
      END

       SUBROUTINE CHECK_CUTS(ecm,Q,NCUT)
C-----------------------------------------------------------------------
C Input parameters:
C     Q(4,7) : 4-MOMENTA: 1,2-TRANSVERSE, 3 ALONG ELECTRON, 4 ENERGY
C     FOR    THE FOLLOWING PARTICLES
C            1- INCOMING POSITRON, 2-INCOMING ELECTRON
C            3- NEUTRINO L, 4-ANTINEUTRINO L
C            5- PHOTON
C  ECM = Center-of-mass energy (in GeV)
C Output parameter:
C  NCUT = 0 if particles satisfies the cuts; = 1 if not
C-----------------------------------------------------------------------
      IMPLICIT NONE
      REAL*8 Q(4,7),Ephot,ANGLE,MVV,M34,CT5,MZ,P34(4),ECM
      REAL*8 EGMIN,EGMAX,CTMAX,CTUP
      REAL  PTG,XTG,XTMIN,XTMAX
      COMMON/CUTS/Ephot,ANGLE,MVV
      INTEGER NCUT,N
C VVVVVVVVVVVVVVVVVVVVVV  JB 990518 VVVVVVVVVVVVVVVVVVVVVVVV
C
C*CA PHCUTS
      REAL*4 EPHMIN,EPHMAX,XTFMIN,XTFMAX,COSTHM
      COMMON / PHCUTS / EPHMIN,EPHMAX,XTFMIN,XTFMAX,COSTHM
C*CC PHCUTS
      DATA CTUP  /  0.98D0 /
C ^^^^^^^^^^^^^^^^^^^^^ JB 990518 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
       MZ=91.18D0
c  set ncut=1 if cuts not passeD
       ncut=1
c--
      PTG = DSQRT(Q(1,5)**2+Q(2,5)**2)
      XTG = 2.0*PTG/ecm
C vvvvvvvvvvvvv begin mods JB 990518 vvvvvvvvvvvvvvvvvvvv
      EGMIN=DBLE(EPHMIN)*0.5D0
      EGMAX=DBLE(EPHMAX)*1.5D0
      CTMAX=DBLE(COSTHM)+0.02D0
      IF (CTMAX.GT.CTUP) CTMAX=CTUP
      XTMIN=XTFMIN-0.05
      IF (XTMIN.LT.0.) XTMIN=0.
      XTMAX=XTFMAX+0.05
      IF (XTMAX.GT.1.) XTMAX=1.
C
C      if (Q(4,5).LT.EGMIN) RETURN
C      if (Q(4,5).GT.EGMAX) return
C ^^^^^^^^^^^^^^^^^^^^^ JB 990518 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      CT5=DABS(Q(3,5)/Q(4,5))
C      IF (CT5.GT.CTMAX) RETURN
      DO N=1,4
         P34(N)=Q(N,3)+Q(N,4)
      ENDDO
      M34=DSQRT(P34(4)**2-P34(1)**2-P34(2)**2-P34(3)**2)
C      IF(DABS(M34-MZ).LT.MVV) RETURN
C
C      print *,' check photon E cost X m34 ',Q(4,5), CT5,XTG,M34
      IF(DABS(M34-MZ).LT.MVV) RETURN
      IF (CT5.GT.CTMAX) RETURN
      if (Q(4,5).LT.EGMIN) RETURN
      if (Q(4,5).GT.EGMAX) return
      IF (XTG.LT.XTMIN) RETURN
      IF (XTG.GT.XTMAX) RETURN
C
      NCUT=0
      RETURN
      END
       SUBROUTINE CHECK_CUTA(ecm,Q,NCUT)
C-----------------------------------------------------------------------
C Input parameters:
C     Q(4,7) : 4-MOMENTA: 1,2-TRANSVERSE, 3 ALONG ELECTRON, 4 ENERGY
C     FOR    THE FOLLOWING PARTICLES
C            1- INCOMING POSITRON, 2-INCOMING ELECTRON
C            3- NEUTRINO L, 4-ANTINEUTRINO L
C            5- PHOTON
C  ECM = Center-of-mass energy (in GeV)
C Output parameter:
C  NCUT = 0 if particles satisfies the cuts; = 1 if not
C  modified by B Bloch March 2002 to be used in accepted gammas selection
C            same as check_cuts but with original cuts ( not loosen)
C-----------------------------------------------------------------------
      IMPLICIT NONE
      REAL*8 Q(4,7),Ephot,ANGLE,MVV,M34,CT5,MZ,P34(4),ECM
      REAL*8 EGMIN,EGMAX,CTMAX,CTUP
      REAL  PTG,XTG,XTMIN,XTMAX
      COMMON/CUTS/Ephot,ANGLE,MVV
      INTEGER NCUT,N
C VVVVVVVVVVVVVVVVVVVVVV  JB 990518 VVVVVVVVVVVVVVVVVVVVVVVV
C
C*CA PHCUTS
      REAL*4 EPHMIN,EPHMAX,XTFMIN,XTFMAX,COSTHM
      COMMON / PHCUTS / EPHMIN,EPHMAX,XTFMIN,XTFMAX,COSTHM
C*CC PHCUTS
      DATA CTUP  /  0.98D0 /
C ^^^^^^^^^^^^^^^^^^^^^ JB 990518 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
       MZ=91.18D0
c  set ncut=1 if cuts not passeD
       ncut=1
c--
      PTG = DSQRT(Q(1,5)**2+Q(2,5)**2)
      XTG = 2.0*PTG/ecm
C vvvvvvvvvvvvv begin mods JB 990518 vvvvvvvvvvvvvvvvvvvv
Cbb      EGMIN=DBLE(EPHMIN)*0.5D0
Cbb      EGMAX=DBLE(EPHMAX)*1.5D0
Cbb      CTMAX=DBLE(COSTHM)+0.02D0
Cbb      XTMIN=XTFMIN-0.05
Cbb      XTMAX=XTFMAX+0.05
      EGMIN=DBLE(EPHMIN)
      EGMAX=DBLE(EPHMAX)
      CTMAX=DBLE(COSTHM)
      IF (CTMAX.GT.CTUP) CTMAX=CTUP
      XTMIN=XTFMIN
      IF (XTMIN.LT.0.) XTMIN=0.
      XTMAX=XTFMAX
      IF (XTMAX.GT.1.) XTMAX=1.
C
C      if (Q(4,5).LT.EGMIN) RETURN
C      if (Q(4,5).GT.EGMAX) return
C ^^^^^^^^^^^^^^^^^^^^^ JB 990518 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      CT5=DABS(Q(3,5)/Q(4,5))
C      IF (CT5.GT.CTMAX) RETURN
      DO N=1,4
         P34(N)=Q(N,3)+Q(N,4)
      ENDDO
      M34=DSQRT(P34(4)**2-P34(1)**2-P34(2)**2-P34(3)**2)
C      IF(DABS(M34-MZ).LT.MVV) RETURN
C
C      print *,' check photon E cost X m34 ',Q(4,5), CT5,XTG,M34
      IF(DABS(M34-MZ).LT.MVV) RETURN
      IF (CT5.GT.CTMAX) RETURN
      if (Q(4,5).LT.EGMIN) RETURN
      if (Q(4,5).GT.EGMAX) return
      IF (XTG.LT.XTMIN) RETURN
      IF (XTG.GT.XTMAX) RETURN
C
      NCUT=0
      RETURN
      END

      subroutine anomini(sw2i,mzi,gzi,mwi,gwi)
      IMPLICIT NONE
      real tabl
      COMMON /NEWMOD/  AMNEUT,NNEUT
      REAL*8           AMNEUT
      Integer nneut
      COMMON / gengto / TABL(40)
C*CA PHCUTS
      REAL*4 EPHMIN,EPHMAX,XTFMIN,XTFMAX,COSTHM
      COMMON / PHCUTS / EPHMIN,EPHMAX,XTFMIN,XTFMAX,COSTHM
      double precision mz,gz,mw,gw,sw2,mzi,gzi,mwi,gwi,sw2i
      integer k
CCA GLUPAR
      COMMON / GLUPAR / SVERT(3),XVRT(3),SXVRT(3),ECM,IFL,IFVRT
      REAL*4 ecm,svert,xvrt,sxvrt
      Integer ifl,ifvrt
C
!! nwwg    = 1
!  nnwg ok inside, see also routine initialize for more input to
! geng.
       tabl(12)= float( nneut)
       mz=mzi
       gz=gzi
       mw=mwi
       gw=gwi
       sw2=sw2i
! old internal default. Reasonable for tests
!       mz=91.18d0 
!       gz=2.484
!       mw=80.046485
!       gw=2.2
!       sw2=.2293
       tabl(13)=mz  ! Z mass  for geng
       tabl(14)=gz  ! Z width for geng
       tabl(15)=mw
       tabl(16)=gw
       tabl(17)=sw2
!! k       = 10.d0
!! l       = 10.d0
!! kmax    = 10.d0
!! lmax    = 10.d0



C Default values for photon cuts irrelevant for KORALZ
C important for geng run standalone.
!! N_EV    = 4000
!! LUM     = 22.d0
!! nb1     = 1
!! nb2     = 1
!! MVV     = 0.0d0
!! angle   = 0.317d0
CCC       COSTHM=0.317d0
!! Ephot   = 17.0d0
CCC       EPHMIN= 17.0D0 
!! ENERGY  = 172.D0 
CCC       tabl(16)=172./2.  !ecm/2
CCC
CCC      EPHMIN=1.
CCC      EPHMAX=1000.
CCC      XTFMIN=0.
CCC      XTFMAX=1.
CCC      COSTHM=1.
C Energy
         tabl(16)=ecm/2.

      call gen_g
      end

      FUNCTION FKALIN(mode,QF1,QF2,PH)
      implicit real*8 (a-h,o-z)
      common /kalinout/ wtkal(6)
      common /kalinint/ sig(6)
      real*8 sig1(6)
      REAL*8 QF1(4),QF2(4)
      REAL*8 PH(4)
      common /flags/ nwwg,nneutr
      nnwgstor=nwwg
      nwwg=0

      a=FKALINA(mode,QF1,QF2,PH)
        xn1=sig(1)
      b=FKALINA(mode,QF2,QF1,PH)
        xn2=sig(1)

      nwwg=nnwgstor
      a=FKALINA(mode,QF1,QF2,PH)
      do i=1,6
        sig1(i)=sig(i)
      enddo
      b=FKALINA(mode,QF2,QF1,PH)

      svar=(qf1(4)+qf2(4))**2-(qf1(3)+qf2(3))**2
     $    -(qf1(2)+qf2(2))**2-(qf1(1)+qf2(1))**2
      if (mode.eq.1) then
       do i=1,6
         wtkal(i)=(sig(i)+sig1(i))/(xn1+xn2)
         wtkal(i)=wtkal(i)/photmore(svar)
       enddo
      endif
      fkalin=1d0

      end
      FUNCTION FKALINA(mode,QF1,QF2,PH)
      implicit real*8 (a-h,o-z)
      common /kalino/ ifkalin
      COMMON / BEAMPM / ENE ,AMIN,AMFIN,IDE,IDF
      REAL*8            ENE ,AMIN,AMFIN
      real*8 delkappa(6),lambda(6)
      real*8 ydelkappa(6),ylambda(6)
      common/anom/delkappa,lambda
      common /kalinint/ wtkal(6)
!      common /kalinint/ sig(6)
      real*8 qq(4)
      REAL*8 QF1(4),QF2(4)
      REAL*8 PH(4),PB1(4),PB2(4),PHN(4)
      real*8 sig(6),Q(4,7)
      FKALINA=1D0
      if (ifkalin.eq.0) return
       do k=1,4
        rotek=1d0
!        if (k.eq.1) rotek= 1d0
        if (k.eq.2) rotek= 1d0
        if (k.eq.3) rotek= 1d0
        q(k,1)=0d0                  !e+
        q(k,2)=0d0                  !e-
        if (ide.lt.0) then
         q(k,3)=qf2(k)*rotek               ! nu     !*rotek
         q(k,4)=qf1(k)*rotek               ! nu~    !*rotek
        else
         q(k,3)=qf1(k)*rotek               ! nu     !*rotek
         q(k,4)=qf2(k)*rotek               ! nu~    !*rotek
        endif
        q(k,5)=ph(k)*rotek                ! gamma  !*rotek
        qq(k)=qf1(k)+qf2(k)+ph(k)
       enddo
        E=sqrt(qq(4)**2-qq(3)**2-qq(2)**2-qq(1)**2)/2
        p=sqrt(E**2-amin**2)
        q(4,1)= E
        q(4,2)= E
        if (ide.lt.0) then
         q(3,1)=-P
         q(3,2)= P
        else
         q(3,1)= P
         q(3,2)=-P
        endif
!!
      if (mode.ne.0) then
      ecm=2*e
      ncut=0
! next line may need commenting out
!      CALL CHECK_CUTS(ecm,Q,NCUT)

      call XSECTION(SIG,Q)

      fkalinup=0d0
      do i=1,6
        fkalinup=fkalinup+sig(i)
        fcut=1d0
        if (ncut.eq.1) fcut=0d0
        wtkal(i)=sig(i)  
      enddo 
         fkalina=1d0
      else

      fkalind=1d0
      fkalina=fkalind

      endif
      END
      subroutine kzphynew(XPAR,NPAR)
      implicit double precision (a-h,o-z)
      COMMON / INOUT / INUT,IOUT
      common /specx/ ifleptok,inter,xmx,delta
      real*8 xmx,delta
      common /kalino/ ifkalin

      REAL*4   XPAR(40)
      INTEGER  NPAR(40)
      REAL*8            ENE ,AMIN,AMFIN,p1(4),p2(4)
      INTEGER           IDE,IDF
      COMMON / BEAMPM / ENE ,AMIN,AMFIN,IDE,IDF
      REAL*8           SWSQ,AMW,AMZ,AMH,AMTOP,GAMMZ
      COMMON / GSWPRM /SWSQ,AMW,AMZ,AMH,AMTOP,GAMMZ
      COMMON / QEDPRM /ALFINV,ALFPI,XK0
      REAL*8           ALFINV,ALFPI,XK0
      common /anomopti/ EMINACT,EMAXACT,PTACT,IRECSOFT,IENRICH
 !leptoquars switched off now ...
      ifleptok=0     ! switch on and off ( 1/0) lepttoquarks
      inter=-1     ! inter=-2,-1,1,2
      xmx=200    ! mass of leptoquark
      delta=-.2d0  ! additional parameter (size of coupling
!
      xmx=xpar(19)
      delta=xpar(20)
      ifleptok=npar(13)
      inter=npar(14)
      ifkalin=npar(15)
CBB      CALL KK2f_GetBeams(    p1,p2)    ! bug 
      CALL KK2f_GetCMSene(CMSene)   ! correct
      CALL BornV_GetMZ(    AMZ)
      CALL BornV_GetGammZ( GammZ)
      CALL BornV_GetSwsq(  swsq )
      AMIN   =  BornV_GetMass(   11)
      AMFIN  =  BornV_GetMass(   16)
      IDE=2
      IDF=1
CBB      Ene=p1(4)                 ! bug 
      Ene=0.5d0*CMSene       ! correct
      print *,' =====KZPHYNEW init E beam  ',ene
      if (ifleptok.eq.1) then
        write(iout,*) 'leptoquarks are on !!!!'
        write(iout,*) 'interaction type:',inter
        write(iout,*) 'mass of leptoquark:',xmx
        write(iout,*) 'couplinng parameter delta=',delta
         iktor=abs(inter)
        if(iktor.lt.1.or.iktor.gt.2) then
         write (*,*) 'stop; wrong inter',inter
         stop
        endif
      elseif(ifleptok.eq.0) then
        write(iout,*) 'leptoquarks are off !!!!'
      else
        write(iout,*) 'wrong ifleptok=',ifleptok
        stop
      endif

! anomalka requires initialization
      if (ifkalin.eq.1) then
        write(iout,*) 'anomalous w-w-gamma coup. are on !!!!'
        gamw=2.2
        amw =amz*sqrt(1d0-swsq)
        call anomini(swsq,amz,gammz,amw,gamw)
      elseif (ifkalin.eq.2) then
        write(iout,*) 'anomalous tau-tau-gamma coup. are on !!!!'

 ! copy koralz constants to a common used by anomini_l3
       isfl = 1                   ! Simple flag for TTG (1 = Riemann approx.)
       if2  = 1                   ! Compute weights for MDM (f_2) (1=on,0=off)
       if3  = 0                   ! Compute weights for EDM (f_3) (1=on,0=off)
       call kz_storeparms(ene,swsq,alfinv,amz,gammz,amfin,isfl,if2,if3)
       call anomini_l3
      elseif (ifkalin.eq.0) then
        write(iout,*) 'anomalous z-z-gamma coup. are off !!!'
      else
        write(iout,*) 'wrong ifkalin=',ifkalin
        stop
      endif

c 
        IENRICH=0
        IRECSOFT=0

      if(ifkalin.eq.1.or.ifkalin.eq.2) then
C if you want to change do it here
        IENRICH= 0!  1
        IRECSOFT=  1
        EMINACT=5   ! min. sum of all photon energies for anom to be calc
        EMAXACT=1000! max. sum of all photon energies for anom to be calc
        PTACT  =.2   ! min. pT (beam) of all phot sum for anom to be calc
         if (ifkalin.ne.1.and.ienrich.eq.1) then
           write(iout,*) 'ienrich set to zero, ifkalin ne 1'
           ienrich=0
         endif

        write(iout,7000) IENRICH,IRECSOFT,EMINACT,EMAXACT,PTACT
       endif
 7000 FORMAT(///1X,15(5HKKKKK)
     $ /,' K',     25X,'additional initialization of generator:',9X,1HK
     $ /,' K',     25X,'       10.12.2000                      ',9X,1HK
     $ /,' K',I20  ,5X,'hard phot. configurations enriched? y/n',9X,1HK
     $ /,' K',I20  ,5X,'soft photon configurations removed? y/n',9X,1HK
     $ /,' K',F20.9,5X,'EMINACT: min energy that anom is calc. ',9X,1HK
     $ /,' K',F20.9,5X,'EMAXACT: max energy that anom is calc. ',9X,1HK
     $ /,' K',F20.9,5X,'PTACT  : min pT that anom is calc.     ',9X,1HK
     $ /,' K',F20.9,5X,'WARNING: THIS IS LIBRARY FOR KORALZ    ',9X,1HK
     $ /,' K',F20.9,5X,'WARNING: FOR KKMC nunu mode WTKAL(i)   ',9X,1HK
     $ /,' K',F20.9,5X,'WARNING: must be divided by WTKAL(1)   ',9X,1HK
     $ /,' K',F20.9,5X,'WARNING: tau-tau-gamma never tested    ',9X,1HK
     $ /,' K',F20.9,5X,'WARNING: but it may work if lib loaded ',9X,1HK
     $ /,1X,15(5HKKKKK)/)
      
      end

!      subroutine anomini(swsq,amz,gammz,amw,gamw)
!      implicit double precision (a-h,o,z)
!      end
!      subroutine anomini_l3
!      implicit double precision (a-h,o,z)
!      end

!      FUNCTION WTANOM(Dumm)
!      IMPLICIT DOUBLE PRECISION (A-H,O-Z) 
!      wtanom=1d0
!      end

!!      FUNCTION FKALIN(mode,QF1,QF2,PH)
 !     REAL*8 QF1(4),QF2(4)
 !     REAL*8 PH(4),PB1(4),PB2(4),PHN(4)
 !     FKALIN=1D0
 !     END
!      SUBROUTINE KZ_STOREPARMS(ene,swsq,alfinv,amz,gammz,amfin,il,i2,i3)
!      double precision ene,swsq,alfinv,amz,gammz,amfin
!      end
!      function photmore(svar)
!      IMPLICIT REAL*8 (A-H,O-Z)
C
!      photmore=1d0
!      end
      FUNCTION WTANOM(Dumm)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z) 
      COMMON / MOMSET / QF1(4),QF2(4),SPHUM(4),SPHOT(100,4),NPHOT
      COMMON / MOMINI / XF1(4),XF2(4),XPHUM(4),XPHOT(100,4),NPHOX      
      COMMON / MOMFIN / YF1(4),YF2(4),YPHUM(4),YPHOT(100,4),NPHOY      
      COMMON / BEAMPM / ENE ,AMIN,AMFIN,IDE,IDF
      REAL*8            ENE ,AMIN,AMFIN
      common /kalinout/ wtkal(6) 
      common /anomopti/ EMINACT,EMAXACT,PTACT,IRECSOFT,IENRICH
      REAL*8 PP(4),PM(4),PP1(4),PM1(4),QP1(4),QM1(4),P(4),Q(4)
      REAL*8 PP2(4),PM2(4),QP2(4),QM2(4)
      REAL*8 QP(4),QM(4),phtru(4),test(4)
      REAL*8 WTL3,XANO
      COMPLEX*16 CPRZ0M
      COMPLEX*16 CPRAM
      LOGICAL IFINI,BETTER
      REAL*8 PH(4),PB1(4),PB2(4),PHN(4),ps(4),qf1p(4),qf2p(4)
      common /kalino/ ifkalin
      DATA  BETTER /.FALSE./
      data init/0/
      WTANOM=1.D0
      WTANOM1=1.D0
!!
!      IF(NPHOT.EQ.0) WTANOM=0.D0
!!
      IF(ifkalin.EQ.0) RETURN
      CALL KK2f_GetFermions( qf1,qf2)
      CALL KK2f_GetFermions( xf1,xf2)
      CALL KK2f_GetFermions( yf1,yf2)
      CALL KK2f_GetPhotAll(Nphot,sPhot)
      do k=1,4
        sphum(k)=0D0
        do l=1,nphot
          sphum(k)=sphum(k)+sPhot(l,k)
        enddo
      enddo

         svar=(qf1(4)+qf2(4))**2-(qf1(3)+qf2(3))**2
     $       -(qf1(2)+qf2(2))**2-(qf1(1)+qf2(1))**2
         wtkal(1)=1d0/photmore(svar)
      if (ifkalin.eq.1) then
        do k=2,6
           wtkal(k)=wtkal(1)
         enddo
      elseif (ifkalin.eq.2) then
        do k=3,6
           wtkal(k)=0d0
         enddo
         wtkal(2)=wtkal(1)
      endif
      IF (IRECSOFT.EQ.1) WTANOM=0.D0
      IF(NPHOT.EQ.0) RETURN
      if(sphum(4).lt.EMINACT) return
      if(sphum(4).gt.EMAXACT) return
      pthis=0d0
      do k=1,nphot   
       pthis=max(pthis,sphot(k,1)**2+sphot(k,2)**2)
      enddo
       if (pthis.lt.PTACT**2) return
C!      if(sphum(1)**2+sphum(1)**2.lt.PTACT) return
C-initialization and cleaning after previous use

      if (ifkalin.eq.1) then         
!     ######################
        BETTER=.true.
        IFINI=.true.
      elseif (ifkalin.eq.2) then
!     ##########################
        BETTER=.false.
        IFINI=.false.
      else
!     ####
        write(*,*) 'stop in wtanom, wrong IFKALIN=',IFKALIN
        stop
       endif
!     #####

C 4-MOMENTA OF BEAMS
        DO 7 K=1,4
        PP(K)=0D0
    7   PM(K)=0D0
C
        PP(4)= ENE
        PM(4)= ENE
        PP(3)= ENE
        PM(3)=-ENE
C 4-MOMENTA OF 'DRESSED' FERMIONS
        DO 9 K=1,4
        QP(K) =QF1(K)
        QM(K) =QF2(K)
        PP1(K)=PP(K)
        PM1(K)=PM(K)
        QP1(K)=QP(K)
    9   QM1(K)=QM(K)
        xmmax=-500d0
C
        DO 77 KPHOT=1,NPHOT
C       == == =============
C ADDITION OF THE PHOTON PH TO FERMION OF MINIMAL MASS OF
C FERMION PHOTON STATE
        DO 8 K=1,4
          PH (K)=SPHOT(KPHOT,K)
          PP2(K)=PP(K)-PH(K)
          PM2(K)=PM(K)-PH(K)
          QP2(K)=QP(K)+PH(K)
    8     QM2(K)=QM(K)+PH(K)
C
        CALL MULSK(PP2,PP2,XM1)
        CALL MULSK(PM2,PM2,XM2)
        CALL MULSK(QP2,QP2,XM3)
        CALL MULSK(QM2,QM2,XM4)
        XXKM=1D0-PH(4)/ENE
C possible modifications see same below
        FACINI=CDABS(CPRZ0M(1,4D00*ENE**2*XXKM))**2
C    $        +CDABS(CPRAM (1,4D00*ENE**2*XXKM))**2
        FACFIN=CDABS(CPRZ0M(1,4D00*ENE**2))**2
C    $        +CDABS(CPRAM (1,4D00*ENE**2))**2
        XM1=XM1/FACINI
        XM2=XM2/FACINI
        XM3=XM3/FACFIN
        XM4=XM4/FACFIN
        IF (IFINI) XM1=-(ph(1)**2+ph(2)**2)*(2-ph(3)/abs(ph(3)))
        IF (IFINI) XM2=-(ph(1)**2+ph(2)**2)*(2+ph(3)/abs(ph(3)))
        IF (BETTER) THEN
          IF (IFINI) THEN 
           XM=MIN(-XM1,-XM2,-XM1,-XM2)
          ELSE
           XM=MIN( XM4, XM3, XM3, XM4)
          ENDIF
        ELSE
           XM=MIN(-XM1,-XM2, XM3, XM4)
        ENDIF
        xmmax=max(xmmax,xm)
 77     continue
C
        DO 78 KPHOT=1,NPHOT
C       == == =============
C ADDITION OF THE PHOTON PH TO FERMION OF MINIMAL MASS OF
C FERMION PHOTON STATE
        DO  K=1,4
          PH (K)=SPHOT(KPHOT,K)
          PP2(K)=PP(K)-PH(K)
          PM2(K)=PM(K)-PH(K)
          QP2(K)=QP(K)+PH(K)
          QM2(K)=QM(K)+PH(K)
        enddo
C
        CALL MULSK(PP2,PP2,XM1)
        CALL MULSK(PM2,PM2,XM2)
        CALL MULSK(QP2,QP2,XM3)
        CALL MULSK(QM2,QM2,XM4)
        XXKM=1D0-PH(4)/ENE
C possible modifications see same above
        FACINI=CDABS(CPRZ0M(1,4D00*ENE**2*XXKM))**2
C    $        +CDABS(CPRAM (1,4D00*ENE**2*XXKM))**2
        FACFIN=CDABS(CPRZ0M(1,4D00*ENE**2))**2
C    $        +CDABS(CPRAM (1,4D00*ENE**2))**2
        if ( init.eq.0) then
            print *,' === WTANOM first pass ENE is ',ENE
            print *,' === WTANOM first pass XXKM is ',XXKM
            print *,' === WTANOM first pass FACINI,FACFIN ',FACINI,FACFIN
            init =1
        endif
        IF (IFINI) FACINI=1
        XM1=XM1/FACINI
        XM2=XM2/FACINI
        XM3=XM3/FACFIN
        XM4=XM4/FACFIN
        IF (IFINI) XM1=-(ph(1)**2+ph(2)**2)*(2-ph(3)/abs(ph(3)))
        IF (IFINI) XM2=-(ph(1)**2+ph(2)**2)*(2+ph(3)/abs(ph(3)))
        IF (BETTER) THEN
          IF (IFINI) THEN 
           XM=MIN(-XM1,-XM2,-XM1,-XM2)
          ELSE
           XM=MIN( XM4, XM3, XM3, XM4)
          ENDIF
        ELSE
           XM=MIN(-XM1,-XM2, XM3, XM4)
        ENDIF
        if (xm.lt.xmmax) then
!       ==
        DO 11 K=1,4
        IF     (XM1.EQ.-XM) THEN
          PP1(K)=PP1(K)-PH(K)
        ELSEIF (XM2.EQ.-XM) THEN
          PM1(K)=PM1(K)-PH(K)
        ELSEIF (XM3.EQ. XM) THEN
          QP1(K)=QP1(K)+PH(K)
        ELSEIF (XM4.EQ. XM) THEN
          QM1(K)=QM1(K)+PH(K)
        ELSE
          PRINT *,
     &    'SOMETHING IS STRANGE IN COMPILER MODIFY LOGIC OF SANGLE'
        ENDIF
 11     CONTINUE
        else
         do k=1,4
          phtru(k)=ph(k)
         enddo
        endif
 78     CONTINUE
      phtru(4)=sqrt(abs(phtru(1)**2+phtru(2)**2+phtru(3)**2))
c  boost to effective lab
      do k=1,4
       PS(k)= qp1(k)+qm1(k)+phtru(k)
      enddo

       call bostdq( 1,ps,pp1,pp1)
       call bostdq( 1,ps,pm1,pm1)
       call bostdq( 1,ps,phtru,phtru)
       call bostdq( 1,ps,qp1,qp1)
       call bostdq( 1,ps,qm1,qm1)
       call bostdq( 1,ps,ps,ps)
c lets correct masses of beams ...
       ebstar=ps(4)/2
       pbstar=sqrt(ebstar**2-amin**2)
       pp1s=sqrt(pp1(1)**2+pp1(2)**2+pp1(3)**2)
       pm1s=sqrt(pm1(1)**2+pm1(2)**2+pm1(3)**2)
       do k=1,3
        pp1(k)=pp1(k)*pbstar/pp1s
        pm1(k)=pm1(k)*pbstar/pm1s
       enddo
        pp1(4)=ps(4)/2
        pm1(4)=ps(4)/2
      do k=1,4
       PS(k)= qp1(k)+qm1(k)
      enddo
       call bostdq( 1,ps,qp1,qp1)
       call bostdq( 1,ps,qm1,qm1)
c lets correct masses of taus ...
       ebstar=(qp1(4)+qm1(4))/2
       pbstar=sqrt(ebstar**2-AMFIN**2)
       qp1s=sqrt(qp1(1)**2+qp1(2)**2+qp1(3)**2)
       qm1s=sqrt(qm1(1)**2+qm1(2)**2+qm1(3)**2)
       do k=1,3
        qp1(k)=qp1(k)*pbstar/qp1s
        qm1(k)=qm1(k)*pbstar/qm1s
       enddo
        qp1(4)=ebstar
        qm1(4)=ebstar

       call bostdq(-1,ps,qp1,qp1)
       call bostdq(-1,ps,qm1,qm1)

         aa=0d0
         do k=1,4
           test(k)=pp1(k)+pm1(k)-phtru(k)-qp1(k)-qm1(k)
           aa=aa+abs(test(k))
         enddo
       if (nphot.lt.-2) then
       write(*,*) '======  ',nphot
       do k=1,nphot
        write(*,*) SPHOT(K,4),SPHOT(K,3),SPHOT(K,2),SPHOT(K,1)
       enddo
       write(*,*) '----------------------------'
       write(*,*) ps(4),ps(3),ps(2),ps(1)
       write(*,*) pp1(4),pp1(3),pp1(2),pp1(1)
       write(*,*) pm1(4),pm1(3),pm1(2),pm1(1)
       write(*,*) '----------------------------'
       write(*,*) qp1(4),qp1(3),qp1(2),qp1(1)
       write(*,*) qm1(4),qm1(3),qm1(2),qm1(1)
       write(*,*) phtru(4),phtru(3),phtru(2),phtru(1)
       write(*,*) '----------------------------'
       write(*,*) test(4),test(3),test(2),test(1)
       write(*,*) '>>>>>>>>>>>>>>>>>>>>>>'
       sign=-1
        xmp=0
        xmm=0
        xqp=0
        xqm=0
        xphtr=0
        do k=1,4
         if (k.eq.4) sign=1
         xmp=xmp+sign*pp1(k)**2
         xmm=xmm+sign*pm1(k)**2
         xqp=xqp+sign*qp1(k)**2
         xqm=xqm+sign*qm1(k)**2
         xph=xph+sign*phtru(k)**2
        enddo
       write(*,*) xmp,xmm,xqp,xqm,xph
       endif

      if (ifkalin.eq.1) then
!     ##########################
        WTANOM=FKALIN(1,qp1,qm1,PHTRU)/FKALIN(0,qp1,qm1,PHTRU)
      elseif (ifkalin.eq.2) then
!     ##########################
        
***        print *,''
***        print *,'pp1 ',pp1
***        print *,'pm1 ',pm1
***        print *,'qp1 ',qp1
***        print *,'qm1 ',qm1
***        print *,'phtru ',phtru

        CALL FU_L3(IDE,IDF,pp1,pm1,qp1,qm1,phtru)

        WTANOM=1.0D0
        if (wtl3.gt.2.d0) then
          print *,' Warning !!'
          print *,'----> BIG WEIGHT!!! ',wtanom
        endif
      else
!     ####
        write(*,*) 'stop in wtanom, wrong IFKALIN=',IFKALIN
        stop
      endif
!     #####
      END
      function photmore(svar)
      IMPLICIT REAL*8 (A-H,O-Z)
C
      common /anomopti/ EMINACT,EMAXACT,PTACT,IRECSOFT,IENRICH
      COMMON / BEAMPM / ENE ,AMIN,AMFIN,IDE,IDF
      REAL*8            ENE ,AMIN,AMFIN
      photmore=1d0
      if (ienrich.ne.1) return
      amz=91.177
      gamz=2.5
      u=(sqrt(svar)-amz)/gamz
      fac=1+amz/gamz/(1+u**2)**2
      ff=1/fac

      am1=53
      gam1=15
      u=(sqrt(svar)-am1)/gam1
      if (u.lt.0d0) u=u/2
      w1=6
      fac1=1+w1/(1+u**2)**2

      am2=110
      gam2=15
      u=(sqrt(svar)-am2)/gam2
      w2=2
      fac2=1+w2/(1+u**2)**2

      x=svar/4/ene**2
      photmore1=min(30d0,abs(1d0/x))

      photmore1=photmore1*fac1*fac2
      photmore2=min(30d0,abs(1d0/x**2))
      photmore=1d0+ff*(photmore1-1)

      end
 


      SUBROUTINE bostdq(mode,qq,pp,r)
*     *******************************
* Boost along arbitrary axis (as implemented by Ronald Kleiss).
* The method is described in book of Bjorken and Drell
* p boosted into r  from actual frame to rest frame of q
* forth (mode = 1) or back (mode = -1).
* q must be a timelike, p may be arbitrary.
      IMPLICIT DOUBLE PRECISION (a-h,o-z)
      DIMENSION qq(*),pp(*),r(*)
      DIMENSION q(4),p(4)

      DO k=1,4
         p(k)=pp(k)
         q(k)=qq(k)
      ENDDO
      amq =dsqrt(q(4)**2-q(1)**2-q(2)**2-q(3)**2)
      IF    (mode .EQ. -1) THEN
         r(4) = (p(1)*q(1)+p(2)*q(2)+p(3)*q(3)+p(4)*q(4))/amq
         fac  = (r(4)+p(4))/(q(4)+amq)
      ELSEIF(mode .EQ.  1) THEN
         r(4) =(-p(1)*q(1)-p(2)*q(2)-p(3)*q(3)+p(4)*q(4))/amq
         fac  =-(r(4)+p(4))/(q(4)+amq)
      ELSE
         WRITE(*,*) ' ++++++++ wrong mode in boost3 '
         STOP
      ENDIF
      r(1)=p(1)+fac*q(1)
      r(2)=p(2)+fac*q(2)
      r(3)=p(3)+fac*q(3)
      END

      SUBROUTINE MULSK(X,Y,R)
C ----------------------------------------------------------------------
C USED IN PEDYPR
C IT CALCULATES SCALAR PRODUCT OF FOUR VECTORS
C
C     called by : PEDYVV,PEDYPR,SANGLE,BDRESS,SKONTY
C ----------------------------------------------------------------------
      IMPLICIT REAL*8 (A-H,O-Z)
      DIMENSION X(4),Y(4)
      R=X(4)*Y(4)-X(3)*Y(3)-X(2)*Y(2)-X(1)*Y(1)
      END


      FUNCTION CPRZ0M(MODE,S)
C ----------------------------------------------------------------------
C THIS FUNCTION SUPPLIES TO THE PROGRAM Z0 PROPAGATOR
C IT USES Z0 VACUUM POLARIZATION MEMORIZED IN THE FUNCTION CINTZZ.
C INPUT : S (GEV**2)   PHOTON ENERGY TRANSFER.
C         MODE -INTERNAL KEY IN THE ALGORITHM,
C
C     called by : FUNTIH, FUNTIS, FANTIH,FANTIS, BORNS, SANGLE, BDRESS,
C                 SKONTY, AMPGSW
C ----------------------------------------------------------------------
      IMPLICIT REAL*8(A-H,O-Z)
C     SWSQ        = sin2 (theta Weinberg)
C     AMW,AMZ     = W & Z boson masses respectively
C     AMH         = the Higgs mass
C     AMTOP       = the top mass
C     GAMMZ       = Z0 width
      COMMON / KEYSET / KEYGSW,KEYRAD,KEYTAB
      COMPLEX*16 CPRZ0,SIGMA,CPRZ0M
      data init/0/
C
      KEYGSW = 4   ! BBL   correct
      CALL BornV_GetMZ(    AMZ)
      CALL BornV_GetGammZ( GammZ)

          SIGMA=DCMPLX(0D0,S/AMZ*GAMMZ)
          CPRZ0=DCMPLX((S-AMZ**2),0D0)
          CPRZ0M=1/(CPRZ0+SIGMA)
      IF (KEYGSW.EQ.0) THEN
        CPRZ0M=DCMPLX(0.D0,0.D0)
      ENDIF
      if (init.eq.0) then
         init = 1
         print *,' ====first pass in CPRZ0M, KEYGSW is ',KEYGSW
         print *,' ====first pass in CPRZ0M, CPRZ0M is ',CPRZ0M
      endif
      END

      SUBROUTINE  anomini_l3
       write(*,*) 'WARNING: dummy routine anomini_l3 called'
       write(*,*) '         to calculate anomalous tau-tau-gamma'//
     +            ' couplings'
       write(*,*) '         it must be removed from anomface.f and'//
     +            ' ttglib from KORALZ loaded'
      END

      SUBROUTINE  kz_storeparms(ene,swsq,alfinv,amz,gammz,amfin,
     +            isfl,if2,if3)
      IMPLICIT REAL*8(A-H,O-Z)
       write(*,*) 'WARNING: dummy routine anomini_l3 called'
       write(*,*) '         to calculate anomalous tau-tau-gamma'//
     +            ' couplings'
       write(*,*) '         it must be removed from anomface.f and'//
     +            ' ttglib from KORALZ loaded'
      END

      SUBROUTINE  FU_L3(IDE,IDF,pp1,pm1,qp1,qm1,phtru)
      IMPLICIT REAL*8(A-H,O-Z)
      REAL*8 PP1(4),PM1(4),QP1(4),QM1(4),phtru(4)
       write(*,*) 'WARNING: dummy routine anomini_l3 called'
       write(*,*) '         to calculate anomalous tau-tau-gamma'//
     +            ' couplings'
       write(*,*) '         it must be removed from anomface.f and'//
     +            ' ttglib from KORALZ loaded'
      END
      SUBROUTINE MOMENTA(ECM,Q,WT,DD)
C-----------------------------------------------------------------------
      IMPLICIT NONE
      REAL*8 Q,WT,DD,MZ,GZ,XM,PP,ECM,ML
      INTEGER NIK,N4
      DIMENSION q(4,7),xm(100),pp(4,100)
      COMMON /MZGZ/ MZ,GZ
      COMMON /LIMITS/ ML
C-----------------------------------------------------------------------
      XM(1)=ML
      XM(2)=ML
      XM(3)=0.d0
      CALL RAMBO(3,ECM,XM,PP,WT,DD)
      DO 78 NIK=1,3
       DO 78 N4=1,4
 78   Q(N4,NIK+2)=PP(N4,NIK)
      RETURN
      END 

      SUBROUTINE XSECTION(SIG,Q)
C----------------------------------------------------------------------
C CALCULATES CONTRIBUTION TO XSECTION FOR LL+PHOTON FOR GIVEN MOMENTA
C INPUT: Q(4,7) - 4-MOMENTA: 1,2-TRANSVERSE, 3 ALONG ELECTRON, 4 ENERGY
C     FOR    THE FOLLOWING PARTICLES
C            1- INCOMING POSITRON, 2-INCOMING ELECTRON
C            3- NEUTRINO L, 4-ANTINEUTRINO L
C            5- PHOTON
C OUTPUT: SIG: CONTRIBUTION TO XSEC (TO BE MULTIPLIED BY PROPER WEIGHT)
c              FOR COMBINATIONS OF ANOMALOUS COUPLINGS
C----------------------------------------------------------------------
      IMPLICIT NONE
      REAL*8 Q,P1,P2,P3,P4,P5,SIG(6),S1(6),S2,sepem_vmvma ,MZ,GZ
      external sepem_vmvma
      INTEGER N
      DIMENSION Q(4,7),P1(0:3),P2(0:3),P3(0:3),P4(0:3),P5(0:3)
      integer nwwg,nneutr
      common /flags/ nwwg,nneutr
      COMMON /MZGZ/  MZ,GZ
C----------------------------------------------------------------------
      S2=0.D0
      DO N=1,6
         S1(N)=0.D0
      ENDDO
      DO N=1,3
         P1(N)=Q(N,1)
         P2(N)=Q(N,2)
         P3(N)=Q(N,3)
         P4(N)=Q(N,4)
         P5(N)=Q(N,5)
      ENDDO
      P1(0)=Q(4,1)
      P2(0)=Q(4,2)
      P3(0)=Q(4,3)
      P4(0)=Q(4,4)
      P5(0)=Q(4,5)
C ELECTRON NEUTRINOS
      CALL SEPEM_VEVEA(P1,P2,P3,P4,P5,S1)
      S2=0.d0
C MUON + TAU NEUTRINOS
      if(nneutr.eq.3)   S2= SEPEM_VMVMA(P1,P2,P3,P4,P5)
      DO N=1,6
         SIG(N)=S1(N)+2.D0*S2
      ENDDO
      RETURN
      END
      REAL*8 FUNCTION G(Q,P)
C-------------------------------------------------------------------------
C DOT PRODUCT OF VECTORS Q P
C-------------------------------------------------------------------------
      IMPLICIT REAL*8(A-M,O-Z)
      DIMENSION Q(4),P(4)
C-------------------------------------------------------------------------
      G=Q(4)*P(4)-Q(1)*P(1)-Q(2)*P(2)-Q(3)*P(3)
      RETURN
      END
      SUBROUTINE RAMBO(N,ET,XM,P,WT,DD)
C------------------------------------------------------
C
C                       RAMBO
C
C    RA(NDOM)  M(OMENTA)  B(EAUTIFULLY)  O(RGANIZED)
C
C    A DEMOCRATIC MULTI-PARTICLE PHASE SPACE GENERATOR
C    AUTHORS:  S.D. ELLIS,  R. KLEISS,  W.J. STIRLING
C    THIS IS VERSION 1.0 -  WRITTEN BY R. KLEISS
C
C    N  = NUMBER OF PARTICLES (>1, IN THIS VERSION <101)
C    ET = TOTAL CENTRE-OF-MASS ENERGY
C    XM = PARTICLE MASSES ( DIM=100 )
C    P  = PARTICLE MOMENTA ( DIM=(4,100) )
C    WT = WEIGHT OF THE EVENT
C
C------------------------------------------------------
      IMPLICIT REAL*8(A-H,O-Z)
      DIMENSION XM(10),P(4,100),Q(4,100),Z(100),R(4),
     .   B(3),P2(100),XM2(100),E(100),V(100),IWARN(5)
      integer inut,iout
      COMMON / INOUT / INUT,IOUT
      DATA ACC/1.D-14/,ITMAX/6/,IBEGIN/0/,IWARN/5*0/
C
C INITIALIZATION STEP: FACTORIALS FOR THE PHASE SPACE WEIGHT
      IF(IBEGIN.NE.0) GOTO 103
      IBEGIN=1
      TWOPI=8.*DATAN(1.D0)
      PO2LOG=DLOG(TWOPI/4.)
      Z(2)=PO2LOG
      DO 101 K=3,100
  101 Z(K)=Z(K-1)+PO2LOG-2.*DLOG(DBLE(K-2))
      DO 102 K=3,100
  102 Z(K)=(Z(K)-DLOG(DBLE(K-1)))
C
C CHECK ON THE NUMBER OF PARTICLES
  103 IF(N.GT.1.AND.N.LT.101) GOTO 104
      write(iout,1001) N
      STOP
C
C CHECK WHETHER TOTAL ENERGY IS SUFFICIENT; COUNT NONZERO MASSES
  104 XMT=0.
      NM=0
      DO 105 I=1,N
      IF(XM(I).NE.0.D0) NM=NM+1
  105 XMT=XMT+DABS(XM(I))
      IF(XMT.LE.ET) GOTO 201
      write(iout,1002) XMT,ET
      STOP
C
C THE PARAMETER VALUES ARE NOW ACCEPTED
C
C GENERATE N MASSLESS MOMENTA IN INFINITE PHASE SPACE
  201 DO 202 I=1,N
      C=2.*RANDY(DD)-1.
      S=DSQRT(1.-C*C)
      F=TWOPI*RANDY(DD)
      Q(4,I)=-DLOG(RANDY(DD)*RANDY(DD))
      Q(3,I)=Q(4,I)*C
      Q(2,I)=Q(4,I)*S*DCOS(F)
  202 Q(1,I)=Q(4,I)*S*DSIN(F)
C
C CALCULATE THE PARAMETERS OF THE CONFORMAL TRANSFORMATION
      DO 203 I=1,4
  203 R(I)=0.
      DO 204 I=1,N
      DO 204 K=1,4
  204 R(K)=R(K)+Q(K,I)
      RMAS=DSQRT(R(4)**2-R(3)**2-R(2)**2-R(1)**2)
      DO 205 K=1,3
  205 B(K)=-R(K)/RMAS
      G=R(4)/RMAS
      A=1./(1.+G)
      X=ET/RMAS
C
C TRANSFORM THE Q'S CONFORMALLY INTO THE P'S
      DO 207 I=1,N
      BQ=B(1)*Q(1,I)+B(2)*Q(2,I)+B(3)*Q(3,I)
      DO 206 K=1,3
  206 P(K,I)=X*(Q(K,I)+B(K)*(Q(4,I)+A*BQ))
  207 P(4,I)=X*(G*Q(4,I)+BQ)
C
C CALCULATE WEIGHT AND POSSIBLE WARNINGS
      WT=PO2LOG
      IF(N.NE.2) WT=(2.*N-4.)*DLOG(ET)+Z(N)
      IF(WT.GE.-180.D0) GOTO 208
      IF(IWARN(1).LE.5) write(iout,1004) WT
      IWARN(1)=IWARN(1)+1
  208 IF(WT.LE. 174.D0) GOTO 209
      IF(IWARN(2).LE.5) write(iout,1005) WT
      IWARN(2)=IWARN(2)+1
C
C RETURN FOR WEIGHTED MASSLESS MOMENTA
  209 IF(NM.NE.0) GOTO 210
      WT=DEXP(WT)
      RETURN
C
C MASSIVE PARTICLES: RESCALE THE MOMENTA BY A FACTOR X
  210 XMAX=DSQRT(1.-(XMT/ET)**2)
      DO 301 I=1,N
      XM2(I)=XM(I)**2
  301 P2(I)=P(4,I)**2
      ITER=0
      X=XMAX
      ACCU=ET*ACC
  302 F0=-ET
      G0=0.
      X2=X*X
      DO 303 I=1,N
      E(I)=DSQRT(XM2(I)+X2*P2(I))
      F0=F0+E(I)
  303 G0=G0+P2(I)/E(I)
      IF(DABS(F0).LE.ACCU) GOTO 305
      ITER=ITER+1
      IF(ITER.LE.ITMAX) GOTO 304
      write(iout,1006) ITMAX
      GOTO 305
  304 X=X-F0/(X*G0)
      GOTO 302
  305 DO 307 I=1,N
      V(I)=X*P(4,I)
      DO 306 K=1,3
  306 P(K,I)=X*P(K,I)
  307 P(4,I)=E(I)
C
C CALCULATE THE MASS-EFFECT WEIGHT FACTOR
      WT2=1.
      WT3=0.
      DO 308 I=1,N
      WT2=WT2*V(I)/E(I)
  308 WT3=WT3+V(I)**2/E(I)
      WTM=(2.*N-3.)*DLOG(X)+DLOG(WT2/WT3*ET)
C
C RETURN FOR  WEIGHTED MASSIVE MOMENTA
      WT=WT+WTM
      IF(WT.GE.-180.D0) GOTO 309
      IF(IWARN(3).LE.5) write(iout,1004) WT
      IWARN(3)=IWARN(3)+1
  309 IF(WT.LE. 174.D0) GOTO 310
      IF(IWARN(4).LE.5) write(iout,1005) WT
      IWARN(4)=IWARN(4)+1
  310 WT=DEXP(WT)
      RETURN
C
 1001 FORMAT(' RAMBO FAILS: # OF PARTICLES =',I5,' IS NOT ALLOWED')
 1002 FORMAT(' RAMBO FAILS: TOTAL MASS =',D15.6,' IS NOT',
     . ' SMALLER THAN TOTAL ENERGY =',D15.6)
 1004 FORMAT(' RAMBO WARNS: WEIGHT = EXP(',F20.9,') MAY UNDERFLOW')
 1005 FORMAT(' RAMBO WARNS: WEIGHT = EXP(',F20.9,') MAY  OVERFLOW')
 1006 FORMAT(' RAMBO WARNS:',I3,' ITERATIONS DID NOT GIVE THE',
     . ' DESIRED ACCURACY =',D15.6)
      END
       double precision function ran(dseed)
C ------------------------------------------------------------------------
c
      double precision dseed
      double precision d2m,d2
      data   d2m/2147483647.d0/,d2/2147483648.d0/
C ------------------------------------------------------------------------
      dseed=dmod(16807.d0*dseed,d2m)
      ran=dseed / d2
      return
      end
      SUBROUTINE BOOST(PBOO,PIN,POUT)
C ------------------------------------------------------------------------
C COMPONENT 4 IS ENERGY
C Q IS THE INVARIANT MASS OF PBOO, PIN THE INPUT VECTOR, POUT
C THE OUTPUT VECTOR AND THE BOOST CAN BE EITHER FROM Q REST
C FRAME TO THE PBOO VECTOR GIVEN, OR FROM A GIVEN PBOO TO
C THE Q REST FRAME BY CALLING AS A FUNCTION OF PBOOT INSTEAD
C OF THE ABOVE WHERE PBOOT HAS REVERSED SPACE COMPONENTS FROM PBOO
C ------------------------------------------------------------------------
      IMPLICIT REAL*8(A-M,P-Z)
      DIMENSION PBOO(4),PIN(4),POUT(4)
C ------------------------------------------------------------------------
      Q=DSQRT(PBOO(4)**2-PBOO(3)**2-PBOO(2)**2-PBOO(1)**2)
      POUT(4)=(PBOO(4)*PIN(4)+PBOO(3)*PIN(3)+PBOO(2)*PIN(2)+
     +         PBOO(1)*PIN(1))/Q
      FACT =(PIN(4)+POUT(4))/(Q+PBOO(4))
      DO 10 N=1,3
   10 POUT(N)=PIN(N)+FACT*PBOO(N)
      RETURN
      END
      REAL*8 FUNCTION RANDY(IDUM)
C ------------------------------------------------------------------------
C returns a uniform deviate between 0. and 1. using a routine
C RAN(ISEED). Set IDUM to any negative value to initialize.
C ------------------------------------------------------------------------
      IMPLICIT REAL*8(A-I,K-Z)
      EXTERNAL RAN
      DIMENSION V(97)
      DATA IFF /0.D0/
C ------------------------------------------------------------------------
      IF (IDUM.LT.0.D0.OR.IFF.EQ.0.D0) THEN
        IFF=1.D0
        ISEED=DABS(IDUM)
        IDUM=1.D0
        DO 11 J=1,97
          DUM=RAN(ISEED)
11      CONTINUE
        DO 12 J=1,97
          V(J)=RAN(ISEED)
12      CONTINUE
        Y=RAN(ISEED)
      ENDIF
      J=1+IDINT(97.D0*Y)
      IF(J.GT.97.OR.J.LT.1)GOTO 10
      Y=V(J)
      RANDY=Y
      IF(RANDY.EQ.0.D0.OR.RANDY.EQ.1.D0) GOTO 9
      V(J)=RAN(ISEED)
      RETURN
 10   WRITE(*,*)'RANDY FAILS, J OUT OF RANGE'
      STOP
  9   WRITE(*,*)' ZERO OR ONE GENERATED',RANDY
      RETURN
      END
      subroutine initialize
C ------------------------------------------------------------------------
C     sets up masses and coupling constants for Helas
C ------------------------------------------------------------------------
      implicit none
      real tabl
      COMMON / gengto / TABL(40)

C Constants
C
      double precision  sw2
!      parameter        (sw2 = .2293d0)
C   masses and widths of fermions
      double precision tmass,      bmass,     cmass
      parameter       (tmass=175d0,bmass=5d0, cmass=0d0)
      double precision smass,      umass,     dmass
      parameter       (smass=0d0,  umass=0d0, dmass=0d0)
      double precision twidth,     bwidth,    cwidth
      parameter       (twidth=0d0, bwidth=0d0,cwidth=0d0)
      double precision swidth,     uwidth,    dwidth
      parameter       (swidth=0d0, uwidth=0d0,dwidth=0d0)
      double precision emass,      mumass,    taumass
      parameter       (emass=0d0,  mumass=0d0,taumass=0d0)
      double precision ewidth,     muwidth,    tauwidth
      parameter       (ewidth=0d0, muwidth=0d0,tauwidth=0d0)
C   masses and widths of bosons
      double precision wmass,         zmass
!      parameter       (wmass=80.046485d0,    zmass=91.18d0)
      double precision wwidth,        zwidth
!      parameter       (wwidth=2.2d0, zwidth=2.484d0)
      double precision amass,         awidth
      parameter       (amass=0d0,     awidth=0d0)
      double precision hmass,         hwidth
      parameter       (hmass=150d0,   hwidth=1d0)
C
C Local Variables
C
      integer i
C
C Global Variables
C
      double precision  gw, gwwa, gwwz
      common /coup1/    gw, gwwa, gwwz
      double precision  gal(2),gau(2),gad(2),gwf(2)
      common /coup2a/   gal,   gau,   gad,   gwf
      double precision  gzn(2),gzl(2),gzu(2),gzd(2),g1(2)
      common /coup2b/   gzn,   gzl,   gzu,   gzd,   g1
      double precision  gwwh,gzzh,ghhh,gwwhh,gzzhh,ghhhh
      common /coup3/    gwwh,gzzh,ghhh,gwwhh,gzzhh,ghhhh
      complex*16        gchf(2,12)
      common /coup4/    gchf
      double precision  wmass1,wwidth1,zmass1,zwidth1
      common /vmass1/   wmass1,wwidth1,zmass1,zwidth1
      double precision  amass1,awidth1,hmass1,hwidth1
      common /vmass2/   amass1,awidth1,hmass1,hwidth1
      double precision  fmass(12), fwidth(12)
      common /fermions/ fmass,     fwidth
      double precision  gg(2), g
      common /coupqcd/  gg,    g
C ------------------------------------------------------------------------
!-----------
! Begin Code
!-----------

      zmass= tabl(13)
      zwidth=tabl(14)
      wmass= tabl(15)
      wwidth=tabl(16)
      sw2=   tabl(17)
      fmass(1) = emass
      fmass(2) = 0d0
      fmass(3) = umass
      fmass(4) = dmass
      fmass(5) = mumass
      fmass(6) = 0d0
      fmass(7) = cmass
      fmass(8) = smass
      fmass(9) = taumass
      fmass(10)= 0d0
      fmass(11)= tmass
      fmass(12)= bmass
C
      fwidth(1) = ewidth
      fwidth(2) = 0d0
      fwidth(3) = uwidth
      fwidth(4) = dwidth
      fwidth(5) = muwidth
      fwidth(6) = 0d0
      fwidth(7) = cwidth
      fwidth(8) = swidth
      fwidth(9) = tauwidth
      fwidth(10)= 0d0
      fwidth(11)= twidth
      fwidth(12)= bwidth
C
      wmass1=wmass
      zmass1=zmass
      amass1=amass
      hmass1=hmass
      wwidth1=wwidth
      zwidth1=zwidth
      awidth1=awidth
      hwidth1=hwidth
C
C  Calls to Helas routines to set couplings
C
      call coup1x(sw2,gw,gwwa,gwwz)
      call coup2x(sw2,gal,gau,gad,gwf,gzn,gzl,gzu,gzd,g1)
      call coup3x(sw2,zmass,hmass,gwwh,gzzh,ghhh,gwwhh,gzzhh,ghhhh)
      do i=1,12
         call coup4x(sw2,zmass,fmass(i),gchf(1,i))
      enddo
C
C  QCD couplings
C
      g = 1d0
      gg(1)=-g
      gg(2)=-g
C
      return
      end
      subroutine coup1x(sw2 , gw,gwwa,gwwz)
C ------------------------------------------------------------------------
c
c this subroutine sets up the coupling constants of the gauge bosons in
c the standard model.
c
c input:
c       real    sw2            : square of sine of the weak angle
c
c output:
c       real    gw             : weak coupling constant
c       real    gwwa           : dimensionless coupling of w-,w+,a
c       real    gwwz           : dimensionless coupling of w-,w+,z
C ------------------------------------------------------------------------
      real*8    sw2,gw,gwwa,gwwz,alpha,fourpi,ee,sw,cw
c
      real*8 r_one, r_four, r_ote, r_pi, r_ialph
      parameter( r_one=1.0d0, r_four=4.0d0, r_ote=128.0d0 )
      parameter( r_pi=3.14159265358979323846d0, r_ialph=137.03604d0 )
C ------------------------------------------------------------------------
c
      alpha = r_one / r_ote
ccAJ 25/11/96
      alpha = r_one / r_ialph
      fourpi = r_four * r_pi
      ee=sqrt( alpha * fourpi )
      sw=sqrt( sw2 )
      cw=sqrt( r_one - sw2 )
c
      gw    =  ee/sw
      gwwa  =  ee
      gwwz  =  ee*cw/sw
c
      return
      end
      subroutine coup2x(sw2 , gal,gau,gad,gwf,gzn,gzl,gzu,gzd,g1)
C ----------------------------------------------------------------------
c
c this subroutine sets up the coupling constants for the fermion-
c fermion-vector vertices in the standard model.  the array of the
c couplings specifies the chirality of the flowing-in fermion.  g??(1)
c denotes a left-handed coupling, and g??(2) a right-handed coupling.
c
c input:
c       real    sw2            : square of sine of the weak angle
c
c output:
c       real    gal(2)         : coupling with a of charged leptons
c       real    gau(2)         : coupling with a of up-type quarks
c       real    gad(2)         : coupling with a of down-type quarks
c       real    gwf(2)         : coupling with w-,w+ of fermions
c       real    gzn(2)         : coupling with z of neutrinos
c       real    gzl(2)         : coupling with z of charged leptons
c       real    gzu(2)         : coupling with z of up-type quarks
c       real    gzd(2)         : coupling with z of down-type quarks
c       real    g1(2)          : unit coupling of fermions
C ----------------------------------------------------------------------
c
      real*8 gal(2),gau(2),gad(2),gwf(2),gzn(2),gzl(2),gzu(2),gzd(2),
     &     g1(2),sw2,alpha,fourpi,ee,sw,cw,ez,ey
c
      real*8 r_zero, r_half, r_one, r_two, r_three, r_four, r_ote
      real*8 r_pi, r_ialph
      parameter( r_zero=0.0d0, r_half=0.5d0, r_one=1.0d0, r_two=2.0d0,
     $     r_three=3.0d0 )
      parameter( r_four=4.0d0, r_ote=128.0d0 )
      parameter( r_pi=3.14159265358979323846d0, r_ialph=137.03604d0 )
C ----------------------------------------------------------------------
c
      alpha = r_one / r_ote
ccAJ 25/11/96
      alpha = r_one / r_ialph
      fourpi = r_four * r_pi
      ee=sqrt( alpha * fourpi )
      sw=sqrt( sw2 )
      cw=sqrt( r_one - sw2 )
      ez=ee/(sw*cw)
      ey=ee*(sw/cw)
c
      gal(1) =  ee
      gal(2) =  ee
      gau(1) = -ee*r_two/r_three
      gau(2) = -ee*r_two/r_three
      gad(1) =  ee   /r_three
      gad(2) =  ee   /r_three
      gwf(1) = -ee/sqrt(r_two*sw2)
      gwf(2) =  r_zero
      gzn(1) = -ez*  r_half
      gzn(2) =  r_zero
      gzl(1) = -ez*(-r_half+sw2)
      gzl(2) = -ey
      gzu(1) = -ez*( r_half-sw2*r_two/r_three)
      gzu(2) =  ey*          r_two/r_three
      gzd(1) = -ez*(-r_half+sw2   /r_three)
      gzd(2) = -ey             /r_three
      g1(1)  =  r_one
      g1(2)  =  r_one
c
      return
      end
      subroutine coup3x(sw2,zmass,hmass ,
     &                  gwwh,gzzh,ghhh,gwwhh,gzzhh,ghhhh)
C ----------------------------------------------------------------------
c
c this subroutine sets up the coupling constants of the gauge bosons and
c higgs boson in the standard model.
c
c input:
c       real    sw2            : square of sine of the weak angle
c       real    zmass          : mass of z
c       real    hmass          : mass of higgs
c
c output:
c       real    gwwh           : dimensionful  coupling of w-,w+,h
c       real    gzzh           : dimensionful  coupling of z, z, h
c       real    ghhh           : dimensionful  coupling of h, h, h
c       real    gwwhh          : dimensionful  coupling of w-,w+,h, h
c       real    gzzhh          : dimensionful  coupling of z, z, h, h
c       real    ghhhh          : dimensionless coupling of h, h, h, h
C ----------------------------------------------------------------------
c
      real*8    sw2,zmass,hmass,gwwh,gzzh,ghhh,gwwhh,gzzhh,ghhhh,
     &        alpha,fourpi,ee2,sc2,v
c
      real*8 r_half, r_one, r_two, r_three, r_four, r_ote
      real*8 r_pi, r_ialph
      parameter( r_half=0.5d0, r_one=1.0d0, r_two=2.0d0, r_three=3.0d0 )
      parameter( r_four=4.0d0, r_ote=128.0d0 )
      parameter( r_pi=3.14159265358979323846d0, r_ialph=137.03604d0 )
C ----------------------------------------------------------------------
c
ccAJ 25/11/96
      alpha = r_one / r_ote
      alpha = r_one / r_ialph
      fourpi = r_four * r_pi
      ee2=alpha*fourpi
      sc2=sw2*( r_one - sw2 )
      v = r_two * zmass*sqrt(sc2)/sqrt(ee2)
c
      gwwh  =   ee2/sw2*r_half*v
      gzzh  =   ee2/sc2*r_half*v
      ghhh  =  -hmass**2/v*r_three
      gwwhh =   ee2/sw2*r_half
      gzzhh =   ee2/sc2*r_half
      ghhhh = -(hmass/v)**2*r_three
c
      return
      end
         SUBROUTINE COUP4X(SW2,ZMASS,FMASS , GCHF)
C ----------------------------------------------------------------------
C
C This subroutine sets up the coupling constant for the fermion-fermion-
C Higgs vertex in the STANDARD MODEL.  The coupling is COMPLEX and the
C array of the coupling specifies the chirality of the flowing-IN
C fermion.  GCHF(1) denotes a left-handed coupling, and GCHF(2) a right-
C handed coupling.
C
C INPUT:
C       real    SW2            : square of sine of the weak angle
C       real    ZMASS          : Z       mass
C       real    FMASS          : fermion mass
C
C OUTPUT:
C       complex GCHF(2)        : coupling of fermion and Higgs
C ----------------------------------------------------------------------
C
      implicit none
      COMPLEX*16 GCHF(2)
      REAL*8    SW2,ZMASS,FMASS,ALPHA,FOURPI,EZ,G
C ----------------------------------------------------------------------
C
ccAJ 25/11/96
      ALPHA=1.d0/128.d0
      ALPHA=1./REAL(137.03604)
      FOURPI=4.D0*3.14159265358979323846D0
      EZ=SQRT(ALPHA*FOURPI)/SQRT(SW2*(1.d0-SW2))
      G=EZ*FMASS*0.5d0/ZMASS
C
      GCHF(1) = DCMPLX( -G )
      GCHF(2) = DCMPLX( -G )
C
      RETURN
      END
      subroutine fvixxx(fi,vc,g,fmass,fwidth , fvi)
C ----------------------------------------------------------------------
c
c this subroutine computes an off-shell fermion wavefunction from a
c flowing-in external fermion and a vector boson.
c
c input:
c       complex fi(6)          : flow-in  fermion                   |fi>
c       complex vc(6)          : input    vector                      v
c       real    g(2)           : coupling constants                  gvf
c       real    fmass          : mass  of output fermion f'
c       real    fwidth         : width of output fermion f'
c
c output:
c       complex fvi(6)         : off-shell fermion             |f',v,fi>
C ----------------------------------------------------------------------
c
      complex*16 fi(6),vc(6),fvi(6),sl1,sl2,sr1,sr2,d
      real*8    g(2),pf(0:3),fmass,fwidth,pf2
c
      real*8 r_zero, r_one
      parameter( r_zero=0.0d0, r_one=1.0d0 )
      complex*16 c_imag
C ----------------------------------------------------------------------
      c_imag=dcmplx( 0.d0, 1.d0 )
c
      fvi(5) = fi(5)-vc(5)
      fvi(6) = fi(6)-vc(6)
c
      pf(0)=dble( fvi(5))
      pf(1)=dble( fvi(6))
      pf(2)=dimag(fvi(6))
      pf(3)=dimag(fvi(5))
      pf2=pf(0)**2-(pf(1)**2+pf(2)**2+pf(3)**2)
c
CAJ 26/03/1997
      if (dcmplx( pf2-fmass**2,max(sign(fmass*fwidth,pf2),r_zero))
     &   .ne.r_zero) then
CAJ 26/03/1997
      d=-r_one/dcmplx( pf2-fmass**2,max(sign(fmass*fwidth,pf2),r_zero))
      sl1= (vc(1)+       vc(4))*fi(1)
     &    +(vc(2)-c_imag*vc(3))*fi(2)
      sl2= (vc(2)+c_imag*vc(3))*fi(1)
     &    +(vc(1)-       vc(4))*fi(2)
c
      if ( g(2) .ne. r_zero ) then
         sr1= (vc(1)-       vc(4))*fi(3)
     &       -(vc(2)-c_imag*vc(3))*fi(4)
         sr2=-(vc(2)+c_imag*vc(3))*fi(3)
     &       +(vc(1)+       vc(4))*fi(4)
c
         fvi(1) = ( g(1)*((pf(0)-pf(3))*sl1 -dconjg(fvi(6))*sl2)
     &             +g(2)*fmass*sr1)*d
         fvi(2) = ( g(1)*(      -fvi(6)*sl1 +(pf(0)+pf(3))*sl2)
     &             +g(2)*fmass*sr2)*d
         fvi(3) = ( g(2)*((pf(0)+pf(3))*sr1 +dconjg(fvi(6))*sr2)
     &             +g(1)*fmass*sl1)*d
         fvi(4) = ( g(2)*(       fvi(6)*sr1 +(pf(0)-pf(3))*sr2)
     &             +g(1)*fmass*sl2)*d
c
      else
         fvi(1) = g(1)*((pf(0)-pf(3))*sl1 -dconjg(fvi(6))*sl2)*d
         fvi(2) = g(1)*(      -fvi(6)*sl1 +(pf(0)+pf(3))*sl2)*d
         fvi(3) = g(1)*fmass*sl1*d
         fvi(4) = g(1)*fmass*sl2*d
      end if
c
CAJ 26/03/1997
      else
         fvi(1) = r_zero
         fvi(2) = r_zero
         fvi(3) = r_zero
         fvi(4) = r_zero
      endif
CAJ 26/03/1997
      return
      end
c
      subroutine fvoxxx(fo,vc,g,fmass,fwidth , fvo)
C ----------------------------------------------------------------------
c
c this subroutine computes an off-shell fermion wavefunction from a
c flowing-out external fermion and a vector boson.
c
c input:
c       complex fo(6)          : flow-out fermion                   <fo|
c       complex vc(6)          : input    vector                      v
c       real    g(2)           : coupling constants                  gvf
c       real    fmass          : mass  of output fermion f'
c       real    fwidth         : width of output fermion f'
c
c output:
c       complex fvo(6)         : off-shell fermion             <fo,v,f'|
C ----------------------------------------------------------------------
c
c
      complex*16 fo(6),vc(6),fvo(6),sl1,sl2,sr1,sr2,d
      real*8    g(2),pf(0:3),fmass,fwidth,pf2
c
      real*8 r_zero, r_one
      parameter( r_zero=0.0d0, r_one=1.0d0 )
      complex*16 c_imag
C ----------------------------------------------------------------------
      c_imag=dcmplx( 0.d0, 1.d0 )
c
      fvo(5) = fo(5)+vc(5)
      fvo(6) = fo(6)+vc(6)
c
      pf(0)=dble( fvo(5))
      pf(1)=dble( fvo(6))
      pf(2)=dimag(fvo(6))
      pf(3)=dimag(fvo(5))
      pf2=pf(0)**2-(pf(1)**2+pf(2)**2+pf(3)**2)
c
      d=-r_one/dcmplx( pf2-fmass**2,max(sign(fmass*fwidth,pf2),r_zero))
      sl1= (vc(1)+       vc(4))*fo(3)
     &    +(vc(2)+c_imag*vc(3))*fo(4)
      sl2= (vc(2)-c_imag*vc(3))*fo(3)
     &    +(vc(1)-       vc(4))*fo(4)
c
      if ( g(2) .ne. r_zero ) then
         sr1= (vc(1)-       vc(4))*fo(1)
     &       -(vc(2)+c_imag*vc(3))*fo(2)
         sr2=-(vc(2)-c_imag*vc(3))*fo(1)
     &       +(vc(1)+       vc(4))*fo(2)
c
         fvo(1) = ( g(2)*( (pf(0)+pf(3))*sr1        +fvo(6)*sr2)
     &             +g(1)*fmass*sl1)*d
         fvo(2) = ( g(2)*( dconjg(fvo(6))*sr1 +(pf(0)-pf(3))*sr2)
     &             +g(1)*fmass*sl2)*d
         fvo(3) = ( g(1)*( (pf(0)-pf(3))*sl1        -fvo(6)*sl2)
     &             +g(2)*fmass*sr1)*d
         fvo(4) = ( g(1)*(-dconjg(fvo(6))*sl1 +(pf(0)+pf(3))*sl2)
     &             +g(2)*fmass*sr2)*d
c
      else
         fvo(1) = g(1)*fmass*sl1*d
         fvo(2) = g(1)*fmass*sl2*d
         fvo(3) = g(1)*( (pf(0)-pf(3))*sl1        -fvo(6)*sl2)*d
         fvo(4) = g(1)*(-dconjg(fvo(6))*sl1 +(pf(0)+pf(3))*sl2)*d
      end if
c
      return
      end
      subroutine iovxxx(fi,fo,vc,g , vertex)
C ----------------------------------------------------------------------
c
c this subroutine computes an amplitude of the fermion-fermion-vector
c coupling.
c
c input:
c       complex fi(6)          : flow-in  fermion                   |fi>
c       complex fo(6)          : flow-out fermion                   <fo|
c       complex vc(6)          : input    vector                      v
c       real    g(2)           : coupling constants                  gvf
c
c output:
c       complex vertex         : amplitude                     <fo|v|fi>
C ----------------------------------------------------------------------
c
      complex*16 fi(6),fo(6),vc(6),vertex
      real*8    g(2)
c
      real*8 r_zero, r_one
      parameter( r_zero=0.0d0, r_one=1.0d0 )
      complex*16 c_imag
C ----------------------------------------------------------------------
      c_imag=dcmplx( 0.d0, 1.d0 )
c
 
      vertex =  g(1)*( (fo(3)*fi(1)+fo(4)*fi(2))*vc(1)
     &                +(fo(3)*fi(2)+fo(4)*fi(1))*vc(2)
     &                -(fo(3)*fi(2)-fo(4)*fi(1))*vc(3)*c_imag
     &                +(fo(3)*fi(1)-fo(4)*fi(2))*vc(4)        )
c
      if ( g(2) .ne. r_zero ) then
         vertex = vertex
     &          + g(2)*( (fo(1)*fi(3)+fo(2)*fi(4))*vc(1)
     &                  -(fo(1)*fi(4)+fo(2)*fi(3))*vc(2)
     &                  +(fo(1)*fi(4)-fo(2)*fi(3))*vc(3)*c_imag
     &                  -(fo(1)*fi(3)-fo(2)*fi(4))*vc(4)        )
      end if
c
      return
      end
      subroutine ixxxxx(
     &              p,          !in: four vector momentum
     &              fmass,      !in: fermion mass
     &              nhel,       !in: spinor helicity, -1 or 1
     &              nsf,        !in: -1=antifermion, 1=fermion
     &              fi          !out: fermion wavefunction
     &                 )
C ----------------------------------------------------------------------
c
c       Subroutine returns the desired fermion or
c       anti-fermion spinor. ie., |f>
c       A replacement for the HELAS routine IXXXXX
c
c       Adam Duff,  1992 August 31
c       <duff@phenom.physics.wisc.edu>
C ----------------------------------------------------------------------
c
      implicit none
c
c declare input/output variables
c
      complex*16 fi(6)
      integer*4 nhel, nsf
      real*8 p(0:3), fmass
c
c declare local variables
c
      real*8 r_zero, r_one, r_two
      complex*16 c_zero
c
      real*8 plat, pabs, omegap, omegam, rs2pa, spaz
      parameter( r_zero=0.0d0, r_one=1.0d0, r_two=2.0d0 )
C ----------------------------------------------------------------------
      c_zero=dcmplx( 0.d0, 0.d0 )
c
c define kinematic parameters
c
      fi(5) = dcmplx( p(0), p(3) ) * nsf
      fi(6) = dcmplx( p(1), p(2) ) * nsf
      plat = sqrt( p(1)**2 + p(2)**2 )
      pabs = sqrt( p(1)**2 + p(2)**2 + p(3)**2 )
      omegap = sqrt( p(0) + pabs )
c
c do massive fermion case
c
      if ( fmass .ne. r_zero ) then
         omegam = fmass / omegap
         if ( nsf .eq. 1 ) then
            if ( nhel .eq. 1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fi(1) = dcmplx( omegam, r_zero )
                     fi(2) = c_zero
                     fi(3) = dcmplx( omegap, r_zero )
                     fi(4) = c_zero
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs + p(3) )
                     fi(1) = omegam * rs2pa
     &                     * dcmplx( spaz, r_zero )
                     fi(2) = omegam * rs2pa / spaz
     &                     * dcmplx( p(1), p(2) )
                     fi(3) = omegap * rs2pa
     &                     * dcmplx( spaz, r_zero )
                     fi(4) = omegap * rs2pa / spaz
     &                     * dcmplx( p(1), p(2) )
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fi(1) = c_zero
                     fi(2) = dcmplx( omegam, r_zero )
                     fi(3) = c_zero
                     fi(4) = dcmplx( omegap, r_zero )
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs - p(3) )
                     fi(1) = omegam * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                     fi(2) = omegam * rs2pa * spaz / plat
     &                     * dcmplx( p(1), p(2) )
                     fi(3) = omegap * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                     fi(4) = omegap * rs2pa * spaz / plat
     &                     * dcmplx( p(1), p(2) )
                  end if
               end if
            else if ( nhel .eq. -1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fi(1) = c_zero
                     fi(2) = dcmplx( omegap, r_zero )
                     fi(3) = c_zero
                     fi(4) = dcmplx( omegam, r_zero )
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs + p(3) )
                     fi(1) = omegap * rs2pa / spaz
     &                     * dcmplx( -p(1), p(2) )
                     fi(2) = omegap * rs2pa
     &                     * dcmplx( spaz, r_zero )
                     fi(3) = omegam * rs2pa / spaz
     &                     * dcmplx( -p(1), p(2) )
                     fi(4) = omegam * rs2pa
     &                     * dcmplx( spaz, r_zero )
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fi(1) = dcmplx( -omegap, r_zero )
                     fi(2) = c_zero
                     fi(3) = dcmplx( -omegam, r_zero )
                     fi(4) = c_zero
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs - p(3) )
                     fi(1) = omegap * rs2pa * spaz / plat
     &                     * dcmplx( -p(1), p(2) )
                     fi(2) = omegap * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                     fi(3) = omegam * rs2pa * spaz / plat
     &                     * dcmplx( -p(1), p(2) )
                     fi(4) = omegam * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                  end if
               end if
            else
               stop 'ixxxxx:  fermion helicity must be +1,-1'
            end if
         else if ( nsf .eq. -1 ) then
            if ( nhel .eq. 1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fi(1) = c_zero
                     fi(2) = dcmplx( -omegap, r_zero )
                     fi(3) = c_zero
                     fi(4) = dcmplx( omegam, r_zero )
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs + p(3) )
                     fi(1) = -omegap * rs2pa / spaz
     &                     * dcmplx( -p(1), p(2) )
                     fi(2) = -omegap * rs2pa
     &                     * dcmplx( spaz, r_zero )
                     fi(3) = omegam * rs2pa / spaz
     &                     * dcmplx( -p(1), p(2) )
                     fi(4) = omegam * rs2pa
     &                     * dcmplx( spaz, r_zero )
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fi(1) = dcmplx( omegap, r_zero )
                     fi(2) = c_zero
                     fi(3) = dcmplx( -omegam, r_zero )
                     fi(4) = c_zero
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs - p(3) )
                     fi(1) = -omegap * rs2pa * spaz / plat
     &                     * dcmplx( -p(1), p(2) )
                     fi(2) = -omegap * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                     fi(3) = omegam * rs2pa * spaz / plat
     &                     * dcmplx( -p(1), p(2) )
                     fi(4) = omegam * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                  end if
               end if
            else if ( nhel .eq. -1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fi(1) = dcmplx( omegam, r_zero )
                     fi(2) = c_zero
                     fi(3) = dcmplx( -omegap, r_zero )
                     fi(4) = c_zero
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs + p(3) )
                     fi(1) = omegam * rs2pa
     &                     * dcmplx( spaz, r_zero )
                     fi(2) = omegam * rs2pa / spaz
     &                     * dcmplx( p(1), p(2) )
                     fi(3) = -omegap * rs2pa
     &                     * dcmplx( spaz, r_zero )
                     fi(4) = -omegap * rs2pa / spaz
     &                     * dcmplx( p(1), p(2) )
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fi(1) = c_zero
                     fi(2) = dcmplx( omegam, r_zero )
                     fi(3) = c_zero
                     fi(4) = dcmplx( -omegap, r_zero )
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs - p(3) )
                     fi(1) = omegam * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                     fi(2) = omegam * rs2pa * spaz / plat
     &                     * dcmplx( p(1), p(2) )
                     fi(3) = -omegap * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                     fi(4) = -omegap * rs2pa * spaz / plat
     &                     * dcmplx( p(1), p(2) )
                  end if
               end if
            else
               stop 'ixxxxx:  fermion helicity must be +1,-1'
            end if
         else
            stop 'ixxxxx:  fermion type must be +1,-1'
         end if
c
c do massless fermion case
c
      else
         if ( nsf .eq. 1 ) then
            if ( nhel .eq. 1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fi(1) = c_zero
                     fi(2) = c_zero
                     fi(3) = dcmplx( omegap, r_zero )
                     fi(4) = c_zero
                  else
                     spaz = sqrt( pabs + p(3) )
                     fi(1) = c_zero
                     fi(2) = c_zero
                     fi(3) = dcmplx( spaz, r_zero )
                     fi(4) = r_one / spaz
     &                     * dcmplx( p(1), p(2) )
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fi(1) = c_zero
                     fi(2) = c_zero
                     fi(3) = c_zero
                     fi(4) = dcmplx( omegap, r_zero )
                  else
                     spaz = sqrt( pabs - p(3) )
                     fi(1) = c_zero
                     fi(2) = c_zero
                     fi(3) = r_one / spaz
     &                     * dcmplx( plat, r_zero )
                     fi(4) = spaz / plat
     &                     * dcmplx( p(1), p(2) )
                  end if
               end if
            else if ( nhel .eq. -1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fi(1) = c_zero
                     fi(2) = dcmplx( omegap, r_zero )
                     fi(3) = c_zero
                     fi(4) = c_zero
                  else
                     spaz = sqrt( pabs + p(3) )
                     fi(1) = r_one / spaz
     &                     * dcmplx( -p(1), p(2) )
                     fi(2) = dcmplx( spaz, r_zero )
                     fi(3) = c_zero
                     fi(4) = c_zero
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fi(1) = dcmplx( -omegap, r_zero )
                     fi(2) = c_zero
                     fi(3) = c_zero
                     fi(4) = c_zero
                  else
                     spaz = sqrt( pabs - p(3) )
                     fi(1) = spaz / plat
     &                     * dcmplx( -p(1), p(2) )
                     fi(2) = r_one / spaz
     &                     * dcmplx( plat, r_zero )
                     fi(3) = c_zero
                     fi(4) = c_zero
                  end if
               end if
            else
               stop 'ixxxxx:  fermion helicity must be +1,-1'
            end if
         else if ( nsf .eq. -1 ) then
            if ( nhel .eq. 1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fi(1) = c_zero
                     fi(2) = dcmplx( -omegap, r_zero )
                     fi(3) = c_zero
                     fi(4) = c_zero
                  else
                     spaz = sqrt( pabs + p(3) )
                     fi(1) = -r_one / spaz
     &                     * dcmplx( -p(1), p(2) )
                     fi(2) = dcmplx( -spaz, r_zero )
                     fi(3) = c_zero
                     fi(4) = c_zero
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fi(1) = dcmplx( omegap, r_zero )
                     fi(2) = c_zero
                     fi(3) = c_zero
                     fi(4) = c_zero
                  else
                     spaz = sqrt( pabs - p(3) )
                     fi(1) = -spaz / plat
     &                     * dcmplx( -p(1), p(2) )
                     fi(2) = -r_one / spaz
     &                     * dcmplx( plat, r_zero )
                     fi(3) = c_zero
                     fi(4) = c_zero
                  end if
               end if
            else if ( nhel .eq. -1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fi(1) = c_zero
                     fi(2) = c_zero
                     fi(3) = dcmplx( -omegap, r_zero )
                     fi(4) = c_zero
                  else
                     spaz = sqrt( pabs + p(3) )
                     fi(1) = c_zero
                     fi(2) = c_zero
                     fi(3) = dcmplx( -spaz, r_zero )
                     fi(4) = -r_one / spaz
     &                     * dcmplx( p(1), p(2) )
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fi(1) = c_zero
                     fi(2) = c_zero
                     fi(3) = c_zero
                     fi(4) = dcmplx( -omegap, r_zero )
                  else
                     spaz = sqrt( pabs - p(3) )
                     fi(1) = c_zero
                     fi(2) = c_zero
                     fi(3) = -r_one / spaz
     &                     * dcmplx( plat, r_zero )
                     fi(4) = -spaz / plat
     &                     * dcmplx( p(1), p(2) )
                  end if
               end if
            else
               stop 'ixxxxx:  fermion helicity must be +1,-1'
            end if
         else
            stop 'ixxxxx:  fermion type must be +1,-1'
         end if
      end if
c
c done
c
      return
      end
      subroutine jioxxx(fi,fo,g,vmass,vwidth , jio)
C ----------------------------------------------------------------------
c
c this subroutine computes an off-shell vector current from an external
c fermion pair.  the vector boson propagator is given in feynman gauge
c for a massless vector and in unitary gauge for a massive vector.
c
c input:
c       complex fi(6)          : flow-in  fermion                   |fi>
c       complex fo(6)          : flow-out fermion                   <fo|
c       real    g(2)           : coupling constants                  gvf
c       real    vmass          : mass  of output vector v
c       real    vwidth         : width of output vector v
c
c output:
c       complex jio(6)         : vector current          j^mu(<fo|v|fi>)
C ----------------------------------------------------------------------
c
      complex*16 fi(6),fo(6),jio(6),c0,c1,c2,c3,cs,d
      real*8    g(2),q(0:3),vmass,vwidth,q2,vm2,dd
c
      real*8 r_zero, r_one
      parameter( r_zero=0.0d0, r_one=1.0d0 )
      complex*16 c_imag
C ----------------------------------------------------------------------
      c_imag=dcmplx( 0.d0, 1.d0 )
c
      jio(5) = fo(5)-fi(5)
      jio(6) = fo(6)-fi(6)
c
      q(0)=dble( jio(5))
      q(1)=dble( jio(6))
      q(2)=dimag(jio(6))
      q(3)=dimag(jio(5))
      q2=q(0)**2-(q(1)**2+q(2)**2+q(3)**2)
      vm2=vmass**2
c
      if (vmass.ne.r_zero) then
c
         d=r_one/dcmplx( q2-vm2 , max(sign( vmass*vwidth ,q2),r_zero) )
c  for the running width, use below instead of the above d.
c      d=r_one/dcmplx( q2-vm2 , max( vwidth*q2/vmass ,r_zero) )
c
         if (g(2).ne.r_zero) then
c
            c0=  g(1)*( fo(3)*fi(1)+fo(4)*fi(2))
     &          +g(2)*( fo(1)*fi(3)+fo(2)*fi(4))
            c1= -g(1)*( fo(3)*fi(2)+fo(4)*fi(1))
     &          +g(2)*( fo(1)*fi(4)+fo(2)*fi(3))
            c2=( g(1)*( fo(3)*fi(2)-fo(4)*fi(1))
     &          +g(2)*(-fo(1)*fi(4)+fo(2)*fi(3)))*c_imag
            c3=  g(1)*(-fo(3)*fi(1)+fo(4)*fi(2))
     &          +g(2)*( fo(1)*fi(3)-fo(2)*fi(4))
         else
c
            d=d*g(1)
            c0=  fo(3)*fi(1)+fo(4)*fi(2)
            c1= -fo(3)*fi(2)-fo(4)*fi(1)
            c2=( fo(3)*fi(2)-fo(4)*fi(1))*c_imag
            c3= -fo(3)*fi(1)+fo(4)*fi(2)
         end if
c
         cs=(q(0)*c0-q(1)*c1-q(2)*c2-q(3)*c3)/vm2
c
         jio(1) = (c0-cs*q(0))*d
         jio(2) = (c1-cs*q(1))*d
         jio(3) = (c2-cs*q(2))*d
         jio(4) = (c3-cs*q(3))*d
c
      else
         dd=r_one/q2
c
         if (g(2).ne.r_zero) then
            jio(1) = ( g(1)*( fo(3)*fi(1)+fo(4)*fi(2))
     &                +g(2)*( fo(1)*fi(3)+fo(2)*fi(4)) )*dd
            jio(2) = (-g(1)*( fo(3)*fi(2)+fo(4)*fi(1))
     &                +g(2)*( fo(1)*fi(4)+fo(2)*fi(3)) )*dd
            jio(3) = ( g(1)*( fo(3)*fi(2)-fo(4)*fi(1))
     &                +g(2)*(-fo(1)*fi(4)+fo(2)*fi(3)))
     $           *dcmplx(r_zero,dd)
            jio(4) = ( g(1)*(-fo(3)*fi(1)+fo(4)*fi(2))
     &                +g(2)*( fo(1)*fi(3)-fo(2)*fi(4)) )*dd
c
         else
            dd=dd*g(1)
c
            jio(1) =  ( fo(3)*fi(1)+fo(4)*fi(2))*dd
            jio(2) = -( fo(3)*fi(2)+fo(4)*fi(1))*dd
            jio(3) =  ( fo(3)*fi(2)-fo(4)*fi(1))*dcmplx(r_zero,dd)
            jio(4) =  (-fo(3)*fi(1)+fo(4)*fi(2))*dd
         end if
      end if
c
      return
      end
      subroutine oxxxxx(
     &              p,          !in: four vector momentum
     &              fmass,      !in: fermion mass
     &              nhel,       !in: anti-spinor helicity, -1 or 1
     &              nsf,        !in: -1=antifermion, 1=fermion
     &              fo          !out: fermion wavefunction
     &                 )
C ----------------------------------------------------------------------
c
c       Subroutine returns the desired fermion or
c       anti-fermion anti-spinor. ie., <f|
c       A replacement for the HELAS routine OXXXXX
c
c       Adam Duff,  1992 August 31
c       <duff@phenom.physics.wisc.edu>
c
C ----------------------------------------------------------------------
      implicit none
c
c declare input/output variables
c
      complex*16 fo(6)
      integer*4 nhel, nsf
      real*8 p(0:3), fmass
c
c declare local variables
c
      real*8 r_zero, r_one, r_two
      complex*16 c_zero
      parameter( r_zero=0.0d0, r_one=1.0d0, r_two=2.0d0 )
c
      real*8 plat, pabs, omegap, omegam, rs2pa, spaz
C ----------------------------------------------------------------------
      c_zero=dcmplx( 0.d0, 0.d0 )
c
c define kinematic parameters
c
      fo(5) = dcmplx( p(0), p(3) ) * nsf
      fo(6) = dcmplx( p(1), p(2) ) * nsf
      plat = sqrt( p(1)**2 + p(2)**2 )
      pabs = sqrt( p(1)**2 + p(2)**2 + p(3)**2 )
      omegap = sqrt( p(0) + pabs )
c
c do massive fermion case
c
      if ( fmass .ne. r_zero ) then
         omegam = fmass / omegap
         if ( nsf .eq. 1 ) then
            if ( nhel .eq. 1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fo(1) = dcmplx( omegap, r_zero )
                     fo(2) = c_zero
                     fo(3) = dcmplx( omegam, r_zero )
                     fo(4) = c_zero
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs + p(3) )
                     fo(1) = omegap * rs2pa
     &                     * dcmplx( spaz, r_zero )
                     fo(2) = omegap * rs2pa / spaz
     &                     * dcmplx( p(1), -p(2) )
                     fo(3) = omegam * rs2pa
     &                     * dcmplx( spaz, r_zero )
                     fo(4) = omegam * rs2pa / spaz
     &                     * dcmplx( p(1), -p(2) )
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fo(1) = c_zero
                     fo(2) = dcmplx( omegap, r_zero )
                     fo(3) = c_zero
                     fo(4) = dcmplx( omegam, r_zero )
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs - p(3) )
                     fo(1) = omegap * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                     fo(2) = omegap * rs2pa * spaz / plat
     &                     * dcmplx( p(1), -p(2) )
                     fo(3) = omegam * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                     fo(4) = omegam * rs2pa * spaz / plat
     &                     * dcmplx( p(1), -p(2) )
                  end if
               end if
            else if ( nhel .eq. -1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fo(1) = c_zero
                     fo(2) = dcmplx( omegam, r_zero )
                     fo(3) = c_zero
                     fo(4) = dcmplx( omegap, r_zero )
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs + p(3) )
                     fo(1) = omegam * rs2pa / spaz
     &                     * dcmplx( -p(1), -p(2) )
                     fo(2) = omegam * rs2pa
     &                     * dcmplx( spaz, r_zero )
                     fo(3) = omegap * rs2pa / spaz
     &                     * dcmplx( -p(1), -p(2) )
                     fo(4) = omegap * rs2pa
     &                     * dcmplx( spaz, r_zero )
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fo(1) = dcmplx( -omegam, r_zero )
                     fo(2) = c_zero
                     fo(3) = dcmplx( -omegap, r_zero )
                     fo(4) = c_zero
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs - p(3) )
                     fo(1) = omegam * rs2pa * spaz / plat
     &                     * dcmplx( -p(1), -p(2) )
                     fo(2) = omegam * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                     fo(3) = omegap * rs2pa * spaz / plat
     &                     * dcmplx( -p(1), -p(2) )
                     fo(4) = omegap * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                  end if
               end if
            else
               stop 'oxxxxx:  fermion helicity must be +1,-1'
            end if
         else if ( nsf .eq. -1 ) then
            if ( nhel .eq. 1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fo(1) = c_zero
                     fo(2) = dcmplx( omegam, r_zero )
                     fo(3) = c_zero
                     fo(4) = dcmplx( -omegap, r_zero )
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs + p(3) )
                     fo(1) = omegam * rs2pa / spaz
     &                     * dcmplx( -p(1), -p(2) )
                     fo(2) = omegam * rs2pa
     &                     * dcmplx( spaz, r_zero )
                     fo(3) = -omegap * rs2pa / spaz
     &                     * dcmplx( -p(1), -p(2) )
                     fo(4) = -omegap * rs2pa
     &                     * dcmplx( spaz, r_zero )
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fo(1) = dcmplx( -omegam, r_zero )
                     fo(2) = c_zero
                     fo(3) = dcmplx( omegap, r_zero )
                     fo(4) = c_zero
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs - p(3) )
                     fo(1) = omegam * rs2pa * spaz / plat
     &                     * dcmplx( -p(1), -p(2) )
                     fo(2) = omegam * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                     fo(3) = -omegap * rs2pa * spaz / plat
     &                     * dcmplx( -p(1), -p(2) )
                     fo(4) = -omegap * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                  end if
               end if
            else if ( nhel .eq. -1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fo(1) = dcmplx( -omegap, r_zero )
                     fo(2) = c_zero
                     fo(3) = dcmplx( omegam, r_zero )
                     fo(4) = c_zero
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs + p(3) )
                     fo(1) = -omegap * rs2pa
     &                     * dcmplx( spaz, r_zero )
                     fo(2) = -omegap * rs2pa / spaz
     &                     * dcmplx( p(1), -p(2) )
                     fo(3) = omegam * rs2pa
     &                     * dcmplx( spaz, r_zero )
                     fo(4) = omegam * rs2pa / spaz
     &                     * dcmplx( p(1), -p(2) )
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fo(1) = c_zero
                     fo(2) = dcmplx( -omegap, r_zero )
                     fo(3) = c_zero
                     fo(4) = dcmplx( omegam, r_zero )
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs - p(3) )
                     fo(1) = -omegap * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                     fo(2) = -omegap * rs2pa * spaz / plat
     &                     * dcmplx( p(1), -p(2) )
                     fo(3) = omegam * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                     fo(4) = omegam * rs2pa * spaz / plat
     &                     * dcmplx( p(1), -p(2) )
                  end if
               end if
            else
               stop 'oxxxxx:  fermion helicity must be +1,-1'
            end if
         else
            stop 'oxxxxx:  fermion type must be +1,-1'
         end if
c
c do massless case
c
      else
         if ( nsf .eq. 1 ) then
            if ( nhel .eq. 1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fo(1) = dcmplx( omegap, r_zero )
                     fo(2) = c_zero
                     fo(3) = c_zero
                     fo(4) = c_zero
                  else
                     spaz = sqrt( pabs + p(3) )
                     fo(1) = dcmplx( spaz, r_zero )
                     fo(2) = r_one / spaz
     &                     * dcmplx( p(1), -p(2) )
                     fo(3) = c_zero
                     fo(4) = c_zero
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fo(1) = c_zero
                     fo(2) = dcmplx( omegap, r_zero )
                     fo(3) = c_zero
                     fo(4) = c_zero
                  else
                     spaz = sqrt( pabs - p(3) )
                     fo(1) = r_one / spaz
     &                     * dcmplx( plat, r_zero )
                     fo(2) = spaz / plat
     &                     * dcmplx( p(1), -p(2) )
                     fo(3) = c_zero
                     fo(4) = c_zero
                  end if
               end if
            else if ( nhel .eq. -1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fo(1) = c_zero
                     fo(2) = c_zero
                     fo(3) = c_zero
                     fo(4) = dcmplx( omegap, r_zero )
                  else
                     spaz = sqrt( pabs + p(3) )
                     fo(1) = c_zero
                     fo(2) = c_zero
                     fo(3) = r_one / spaz
     &                     * dcmplx( -p(1), -p(2) )
                     fo(4) = dcmplx( spaz, r_zero )
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fo(1) = c_zero
                     fo(2) = c_zero
                     fo(3) = dcmplx( -omegap, r_zero )
                     fo(4) = c_zero
                  else
                     spaz = sqrt( pabs - p(3) )
                     fo(1) = c_zero
                     fo(2) = c_zero
                     fo(3) = spaz / plat
     &                     * dcmplx( -p(1), -p(2) )
                     fo(4) = r_one / spaz
     &                     * dcmplx( plat, r_zero )
                  end if
               end if
            else
               stop 'oxxxxx:  fermion helicity must be +1,-1'
            end if
         else if ( nsf .eq. -1 ) then
            if ( nhel .eq. 1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fo(1) = c_zero
                     fo(2) = c_zero
                     fo(3) = c_zero
                     fo(4) = dcmplx( -omegap, r_zero )
                  else
                     spaz = sqrt( pabs + p(3) )
                     fo(1) = c_zero
                     fo(2) = c_zero
                     fo(3) = -r_one / spaz
     &                     * dcmplx( -p(1), -p(2) )
                     fo(4) = dcmplx( -spaz, r_zero )
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fo(1) = c_zero
                     fo(2) = c_zero
                     fo(3) = dcmplx( omegap, r_zero )
                     fo(4) = c_zero
                  else
                     spaz = sqrt( pabs - p(3) )
                     fo(1) = c_zero
                     fo(2) = c_zero
                     fo(3) = -spaz / plat
     &                     * dcmplx( -p(1), -p(2) )
                     fo(4) = -r_one / spaz
     &                     * dcmplx( plat, r_zero )
                  end if
               end if
            else if ( nhel .eq. -1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fo(1) = dcmplx( -omegap, r_zero )
                     fo(2) = c_zero
                     fo(3) = c_zero
                     fo(4) = c_zero
                  else
                     spaz = sqrt( pabs + p(3) )
                     fo(1) = dcmplx( -spaz, r_zero )
                     fo(2) = -r_one / spaz
     &                     * dcmplx( p(1), -p(2) )
                     fo(3) = c_zero
                     fo(4) = c_zero
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fo(1) = c_zero
                     fo(2) = dcmplx( -omegap, r_zero )
                     fo(3) = c_zero
                     fo(4) = c_zero
                  else
                     spaz = sqrt( pabs - p(3) )
                     fo(1) = -r_one / spaz
     &                     * dcmplx( plat, r_zero )
                     fo(2) = -spaz / plat
     &                     * dcmplx( p(1), -p(2) )
                     fo(3) = c_zero
                     fo(4) = c_zero
                  end if
               end if
            else
               stop 'oxxxxx:  fermion helicity must be +1,-1'
            end if
         else
            stop 'oxxxxx:  fermion type must be +1,-1'
         end if
      end if
c
c done
c
      return
      end
      SUBROUTINE SEPEM_VEVEA(P1, P2, P3, P4, P5, S1)
C ----------------------------------------------------------------------
C MODIFIED 22.06.96 TO CALCULATE S1 FOR A SET OF ANOMALOUS
C      COUPLINGS
C
C FUNCTION GENERATED BY MADGRAPH
C RETURNS AMPLITUDE SQUARED SUMMED/AVG OVER COLORS
C AND HELICITIES
C FOR THE POINT IN PHASE SPACE P1,P2,P3,P4,...
C
C FOR PROCESS : e+ e-  -> ve ve~ a
C ----------------------------------------------------------------------
C
      IMPLICIT NONE
C
C CONSTANTS
C
      INTEGER    NEXTERNAL,   NCOMB
      PARAMETER (NEXTERNAL=5, NCOMB= 32)
C
C ARGUMENTS
C
      REAL*8 P1(0:3),P2(0:3),P3(0:3),P4(0:3),P5(0:3)
 
 
C DODALEM --------------------->
C OUTPUT S1(6)
      REAL*8 S1(6) ,T(6)
      INTEGER ICASE
C------------------------------<
C
C LOCAL VARIABLES
C
      INTEGER NHEL(NEXTERNAL,NCOMB),NTRY
      INTEGER IHEL
      LOGICAL GOODHEL(NCOMB)
      DATA GOODHEL/NCOMB*.FALSE./
      DATA NTRY/0/
      DATA (NHEL(IHEL,  1),IHEL=1,5) / -1, -1, -1, -1, -1/
      DATA (NHEL(IHEL,  2),IHEL=1,5) / -1, -1, -1, -1,  1/
      DATA (NHEL(IHEL,  3),IHEL=1,5) / -1, -1, -1,  1, -1/
      DATA (NHEL(IHEL,  4),IHEL=1,5) / -1, -1, -1,  1,  1/
      DATA (NHEL(IHEL,  5),IHEL=1,5) / -1, -1,  1, -1, -1/
      DATA (NHEL(IHEL,  6),IHEL=1,5) / -1, -1,  1, -1,  1/
      DATA (NHEL(IHEL,  7),IHEL=1,5) / -1, -1,  1,  1, -1/
      DATA (NHEL(IHEL,  8),IHEL=1,5) / -1, -1,  1,  1,  1/
      DATA (NHEL(IHEL,  9),IHEL=1,5) / -1,  1, -1, -1, -1/
      DATA (NHEL(IHEL, 10),IHEL=1,5) / -1,  1, -1, -1,  1/
      DATA (NHEL(IHEL, 11),IHEL=1,5) / -1,  1, -1,  1, -1/
      DATA (NHEL(IHEL, 12),IHEL=1,5) / -1,  1, -1,  1,  1/
      DATA (NHEL(IHEL, 13),IHEL=1,5) / -1,  1,  1, -1, -1/
      DATA (NHEL(IHEL, 14),IHEL=1,5) / -1,  1,  1, -1,  1/
      DATA (NHEL(IHEL, 15),IHEL=1,5) / -1,  1,  1,  1, -1/
      DATA (NHEL(IHEL, 16),IHEL=1,5) / -1,  1,  1,  1,  1/
      DATA (NHEL(IHEL, 17),IHEL=1,5) /  1, -1, -1, -1, -1/
      DATA (NHEL(IHEL, 18),IHEL=1,5) /  1, -1, -1, -1,  1/
      DATA (NHEL(IHEL, 19),IHEL=1,5) /  1, -1, -1,  1, -1/
      DATA (NHEL(IHEL, 20),IHEL=1,5) /  1, -1, -1,  1,  1/
      DATA (NHEL(IHEL, 21),IHEL=1,5) /  1, -1,  1, -1, -1/
      DATA (NHEL(IHEL, 22),IHEL=1,5) /  1, -1,  1, -1,  1/
      DATA (NHEL(IHEL, 23),IHEL=1,5) /  1, -1,  1,  1, -1/
      DATA (NHEL(IHEL, 24),IHEL=1,5) /  1, -1,  1,  1,  1/
      DATA (NHEL(IHEL, 25),IHEL=1,5) /  1,  1, -1, -1, -1/
      DATA (NHEL(IHEL, 26),IHEL=1,5) /  1,  1, -1, -1,  1/
      DATA (NHEL(IHEL, 27),IHEL=1,5) /  1,  1, -1,  1, -1/
      DATA (NHEL(IHEL, 28),IHEL=1,5) /  1,  1, -1,  1,  1/
      DATA (NHEL(IHEL, 29),IHEL=1,5) /  1,  1,  1, -1, -1/
      DATA (NHEL(IHEL, 30),IHEL=1,5) /  1,  1,  1, -1,  1/
      DATA (NHEL(IHEL, 31),IHEL=1,5) /  1,  1,  1,  1, -1/
      DATA (NHEL(IHEL, 32),IHEL=1,5) /  1,  1,  1,  1,  1/
C ----------------------------------------------------------------------
C ----------
C BEGIN CODE
C ----------
c      write(*,*)'wszedl do sepem'
        DO ICASE=1,6
           S1(ICASE) = 0d0
        ENDDO
      NTRY=NTRY+1
      DO IHEL=1,NCOMB
          IF (GOODHEL(IHEL) .OR. NTRY .LT. 10) THEN
             CALL EPEM_VEVEA(P1, P2, P3, P4, P5,T,NHEL(1,IHEL))
             DO ICASE=1,6
                   S1(ICASE) = S1(ICASE) + T(ICASE)
             ENDDO
                IF (T(1) .GT. 0D0 .AND. .NOT. GOODHEL(IHEL)) THEN
                  GOODHEL(IHEL)=.TRUE.
C                  WRITE(*,*) IHEL,T(1)
                ENDIF
          ENDIF
        ENDDO
        DO ICASE=1,6
           S1(ICASE) = S1(ICASE) /  4D0
        ENDDO
      END
      SUBROUTINE EPEM_VEVEA(P1, P2, P3, P4, P5,T,NHEL)
C ----------------------------------------------------------------------
C
C FUNCTION GENERATED BY MADGRAPH
C RETURNS AMPLITUDE SQUARED SUMMED/AVG OVER COLORS
C FOR THE POINT IN PHASE SPACE P1,P2,P3,P4,...
C AND HELICITY NHEL(1),NHEL(2),....
C
C FOR PROCESS : e+ e-  -> ve ve~ a
C ----------------------------------------------------------------------
C
      IMPLICIT NONE
C
C CONSTANTS
C
      INTEGER    NGRAPHS,    NEIGEN,    NEXTERNAL
      PARAMETER (NGRAPHS=  5,NEIGEN=  1,NEXTERNAL=5)
      REAL*8     ZERO
      PARAMETER (ZERO=0D0)
C DODALEM   22.06.96 ------->
      REAL*8 T(6),EPEM
      INTEGER ICASE
      COMPLEX*16 ANOM(6)
C ONLY VVVXXX HAS ANOMALOUS COUPLINGS
C --------------------------<
C
C ARGUMENTS
C
      REAL*8 P1(0:3),P2(0:3),P3(0:3),P4(0:3),P5(0:3)
      INTEGER NHEL(NEXTERNAL)
C
C LOCAL VARIABLES
C
      INTEGER I,J
      REAL*8 EIGEN_VAL(NEIGEN), EIGEN_VEC(NGRAPHS,NEIGEN)
      COMPLEX*16 ZTEMP
      COMPLEX*16 AMP(NGRAPHS)
      COMPLEX*16 W1(6)  , W2(6)  , W3(6)  , W4(6)  , W5(6)
      COMPLEX*16 W6(6)  , W7(6)  , W8(6)  , W9(6)  , W10(6)
      COMPLEX*16 W11(6)
C
C GLOBAL VARIABLES
C
      REAL*8         GW, GWWA, GWWZ
      COMMON /COUP1/ GW, GWWA, GWWZ
      REAL*8         GAL(2),GAU(2),GAD(2),GWF(2)
      COMMON /COUP2A/GAL,   GAU,   GAD,   GWF
      REAL*8         GZN(2),GZL(2),GZU(2),GZD(2),G1(2)
      COMMON /COUP2B/GZN,   GZL,   GZU,   GZD,   G1
      REAL*8         GWWH,GZZH,GHHH,GWWHH,GZZHH,GHHHH
      COMMON /COUP3/ GWWH,GZZH,GHHH,GWWHH,GZZHH,GHHHH
      COMPLEX*16     GH(2,12)
      COMMON /COUP4/ GH
      REAL*8         WMASS,WWIDTH,ZMASS,ZWIDTH
      COMMON /VMASS1/WMASS,WWIDTH,ZMASS,ZWIDTH
      REAL*8         AMASS,AWIDTH,HMASS,HWIDTH
      COMMON /VMASS2/AMASS,AWIDTH,HMASS,HWIDTH
      REAL*8            FMASS(12), FWIDTH(12)
      COMMON /FERMIONS/ FMASS,     FWIDTH
c ------- flags for turning off wwg diagram, 28.10.96
      integer nwwg,nneutr
      common/flags/nwwg,nneutr
C
C COLOR DATA
C
      DATA EIGEN_VAL(1  )/       5.0000000000000009D+00 /
      DATA EIGEN_VEC(1  ,1  )/  -4.4721359549995793D-01 /
      DATA EIGEN_VEC(2  ,1  )/  -4.4721359549995793D-01 /
      DATA EIGEN_VEC(3  ,1  )/  -4.4721359549995793D-01 /
      DATA EIGEN_VEC(4  ,1  )/   4.4721359549995793D-01 /
      DATA EIGEN_VEC(5  ,1  )/   4.4721359549995793D-01 /
C ----------------------------------------------------------------------
C ----------
C BEGIN CODE
C ----------
      do icase=1,6
      anom(icase)=0.d0
      enddo
      CALL OXXXXX(P1  ,FMASS(1  ),NHEL(1  ),-1,W1  )
      CALL IXXXXX(P2  ,FMASS(1  ),NHEL(2  ), 1,W2  )
      CALL OXXXXX(P3  ,FMASS(2  ),NHEL(3  ), 1,W3  )
      CALL IXXXXX(P4  ,FMASS(2  ),NHEL(4  ),-1,W4  )
      CALL VXXXXX(P5  , ZERO,NHEL(5  ), 1,W5  )
      CALL JIOXXX(W2  ,W3  ,GWF,WMASS,WWIDTH,W6  )
      CALL FVIXXX(W4  ,W6  ,GWF,FMASS(1  ),FWIDTH(1  ),W7  )
      CALL IOVXXX(W7  ,W1  ,W5  ,GAL,AMP(1  ))
      CALL JIOXXX(W4  ,W1  ,GWF,WMASS,WWIDTH,W8  )
      CALL FVIXXX(W2  ,W5  ,GAL,FMASS(1  ),FWIDTH(1  ),W9  )
      CALL IOVXXX(W9  ,W3  ,W8  ,GWF,AMP(2  ))
      if(nwwg.eq.1) CALL VVVXXX(W8  ,W6  ,W5  ,GWWA,ANOM)
      CALL JIOXXX(W4  ,W3  ,GZN,ZMASS,ZWIDTH,W10 )
      CALL FVOXXX(W1  ,W5  ,GAL,FMASS(1  ),FWIDTH(1  ),W11 )
      CALL IOVXXX(W2  ,W11 ,W10 ,GZL,AMP(4  ))
      CALL IOVXXX(W9  ,W1  ,W10 ,GZL,AMP(5  ))
C
      DO ICASE=1,6
        AMP(3)=ANOM(ICASE)
        EPEM = 0.D0
        DO I = 1, NEIGEN
          ZTEMP = (0.D0,0.D0)
          DO J = 1, NGRAPHS
              ZTEMP = ZTEMP + EIGEN_VEC(J,I)*AMP(J)
          ENDDO
          EPEM =EPEM+ZTEMP*EIGEN_VAL(I)*CONJG(ZTEMP)
        ENDDO
        T(ICASE)=EPEM
      ENDDO
C      CALL GAUGECHECK(AMP,ZTEMP,EIGEN_VEC,EIGEN_VAL,NGRAPHS,NEIGEN)
      RETURN
      END
      REAL*8 FUNCTION SEPEM_VMVMA(P1, P2, P3, P4, P5)
C ----------------------------------------------------------------------
C
C FUNCTION GENERATED BY MADGRAPH
C RETURNS AMPLITUDE SQUARED SUMMED/AVG OVER COLORS
C AND HELICITIES
C FOR THE POINT IN PHASE SPACE P1,P2,P3,P4,...
C
C FOR PROCESS : e+ e-  -> vm vm~ a
C ----------------------------------------------------------------------
C
      IMPLICIT NONE
C
C CONSTANTS
C
      INTEGER    NEXTERNAL,   NCOMB
      PARAMETER (NEXTERNAL=5, NCOMB= 32)
C
C ARGUMENTS
C
      REAL*8 P1(0:3),P2(0:3),P3(0:3),P4(0:3),P5(0:3)
C
C LOCAL VARIABLES
C
      INTEGER NHEL(NEXTERNAL,NCOMB),NTRY
      REAL*8 T
      REAL*8 EPEM_VMVMA
      INTEGER IHEL
      LOGICAL GOODHEL(NCOMB)
      DATA GOODHEL/NCOMB*.FALSE./
      DATA NTRY/0/
      DATA (NHEL(IHEL,  1),IHEL=1,5) / -1, -1, -1, -1, -1/
      DATA (NHEL(IHEL,  2),IHEL=1,5) / -1, -1, -1, -1,  1/
      DATA (NHEL(IHEL,  3),IHEL=1,5) / -1, -1, -1,  1, -1/
      DATA (NHEL(IHEL,  4),IHEL=1,5) / -1, -1, -1,  1,  1/
      DATA (NHEL(IHEL,  5),IHEL=1,5) / -1, -1,  1, -1, -1/
      DATA (NHEL(IHEL,  6),IHEL=1,5) / -1, -1,  1, -1,  1/
      DATA (NHEL(IHEL,  7),IHEL=1,5) / -1, -1,  1,  1, -1/
      DATA (NHEL(IHEL,  8),IHEL=1,5) / -1, -1,  1,  1,  1/
      DATA (NHEL(IHEL,  9),IHEL=1,5) / -1,  1, -1, -1, -1/
      DATA (NHEL(IHEL, 10),IHEL=1,5) / -1,  1, -1, -1,  1/
      DATA (NHEL(IHEL, 11),IHEL=1,5) / -1,  1, -1,  1, -1/
      DATA (NHEL(IHEL, 12),IHEL=1,5) / -1,  1, -1,  1,  1/
      DATA (NHEL(IHEL, 13),IHEL=1,5) / -1,  1,  1, -1, -1/
      DATA (NHEL(IHEL, 14),IHEL=1,5) / -1,  1,  1, -1,  1/
      DATA (NHEL(IHEL, 15),IHEL=1,5) / -1,  1,  1,  1, -1/
      DATA (NHEL(IHEL, 16),IHEL=1,5) / -1,  1,  1,  1,  1/
      DATA (NHEL(IHEL, 17),IHEL=1,5) /  1, -1, -1, -1, -1/
      DATA (NHEL(IHEL, 18),IHEL=1,5) /  1, -1, -1, -1,  1/
      DATA (NHEL(IHEL, 19),IHEL=1,5) /  1, -1, -1,  1, -1/
      DATA (NHEL(IHEL, 20),IHEL=1,5) /  1, -1, -1,  1,  1/
      DATA (NHEL(IHEL, 21),IHEL=1,5) /  1, -1,  1, -1, -1/
      DATA (NHEL(IHEL, 22),IHEL=1,5) /  1, -1,  1, -1,  1/
      DATA (NHEL(IHEL, 23),IHEL=1,5) /  1, -1,  1,  1, -1/
      DATA (NHEL(IHEL, 24),IHEL=1,5) /  1, -1,  1,  1,  1/
      DATA (NHEL(IHEL, 25),IHEL=1,5) /  1,  1, -1, -1, -1/
      DATA (NHEL(IHEL, 26),IHEL=1,5) /  1,  1, -1, -1,  1/
      DATA (NHEL(IHEL, 27),IHEL=1,5) /  1,  1, -1,  1, -1/
      DATA (NHEL(IHEL, 28),IHEL=1,5) /  1,  1, -1,  1,  1/
      DATA (NHEL(IHEL, 29),IHEL=1,5) /  1,  1,  1, -1, -1/
      DATA (NHEL(IHEL, 30),IHEL=1,5) /  1,  1,  1, -1,  1/
      DATA (NHEL(IHEL, 31),IHEL=1,5) /  1,  1,  1,  1, -1/
      DATA (NHEL(IHEL, 32),IHEL=1,5) /  1,  1,  1,  1,  1/
C ----------------------------------------------------------------------
C ----------
C BEGIN CODE
C ----------
      SEPEM_VMVMA = 0d0
      NTRY=NTRY+1
      DO IHEL=1,NCOMB
          IF (GOODHEL(IHEL) .OR. NTRY .LT. 10) THEN
             T=EPEM_VMVMA(P1, P2, P3, P4, P5,NHEL(1,IHEL))
             SEPEM_VMVMA = SEPEM_VMVMA + T
              IF (T .GT. 0D0 .AND. .NOT. GOODHEL(IHEL)) THEN
                  GOODHEL(IHEL)=.TRUE.
C                  WRITE(*,*) IHEL,T
              ENDIF
          ENDIF
      ENDDO
      SEPEM_VMVMA = SEPEM_VMVMA /  4D0
      END
      REAL*8 FUNCTION EPEM_VMVMA(P1, P2, P3, P4, P5,NHEL)
C ----------------------------------------------------------------------
C
C FUNCTION GENERATED BY MADGRAPH
C RETURNS AMPLITUDE SQUARED SUMMED/AVG OVER COLORS
C FOR THE POINT IN PHASE SPACE P1,P2,P3,P4,...
C AND HELICITY NHEL(1),NHEL(2),....
C
C FOR PROCESS : e+ e-  -> vm vm~ a
C ----------------------------------------------------------------------
C
      IMPLICIT NONE
C
C CONSTANTS
C
      INTEGER    NGRAPHS,    NEIGEN,    NEXTERNAL
      PARAMETER (NGRAPHS=  2,NEIGEN=  1,NEXTERNAL=5)
      REAL*8     ZERO
      PARAMETER (ZERO=0D0)
C
C ARGUMENTS
C
      REAL*8 P1(0:3),P2(0:3),P3(0:3),P4(0:3),P5(0:3)
      INTEGER NHEL(NEXTERNAL)
C
C LOCAL VARIABLES
C
      INTEGER I,J
      REAL*8 EIGEN_VAL(NEIGEN), EIGEN_VEC(NGRAPHS,NEIGEN)
      COMPLEX*16 ZTEMP
      COMPLEX*16 AMP(NGRAPHS)
      COMPLEX*16 W1(6)  , W2(6)  , W3(6)  , W4(6)  , W5(6)
      COMPLEX*16 W6(6)  , W7(6)  , W8(6)
C
C GLOBAL VARIABLES
C
      REAL*8         GW, GWWA, GWWZ
      COMMON /COUP1/ GW, GWWA, GWWZ
      REAL*8         GAL(2),GAU(2),GAD(2),GWF(2)
      COMMON /COUP2A/GAL,   GAU,   GAD,   GWF
      REAL*8         GZN(2),GZL(2),GZU(2),GZD(2),G1(2)
      COMMON /COUP2B/GZN,   GZL,   GZU,   GZD,   G1
      REAL*8         GWWH,GZZH,GHHH,GWWHH,GZZHH,GHHHH
      COMMON /COUP3/ GWWH,GZZH,GHHH,GWWHH,GZZHH,GHHHH
      COMPLEX*16     GH(2,12)
      COMMON /COUP4/ GH
      REAL*8         WMASS,WWIDTH,ZMASS,ZWIDTH
      COMMON /VMASS1/WMASS,WWIDTH,ZMASS,ZWIDTH
      REAL*8         AMASS,AWIDTH,HMASS,HWIDTH
      COMMON /VMASS2/AMASS,AWIDTH,HMASS,HWIDTH
      REAL*8            FMASS(12), FWIDTH(12)
      COMMON /FERMIONS/ FMASS,     FWIDTH
C
C COLOR DATA
C
      DATA EIGEN_VAL(1  )/       2.0000000000000004D+00 /
      DATA EIGEN_VEC(1  ,1  )/   7.0710678118654746D-01 /
      DATA EIGEN_VEC(2  ,1  )/   7.0710678118654746D-01 /
C ----------------------------------------------------------------------
C ----------
C BEGIN CODE
C ----------
      CALL OXXXXX(P1  ,FMASS(1  ),NHEL(1  ),-1,W1  )
      CALL IXXXXX(P2  ,FMASS(1  ),NHEL(2  ), 1,W2  )
      CALL OXXXXX(P3  ,FMASS(6  ),NHEL(3  ), 1,W3  )
      CALL IXXXXX(P4  ,FMASS(6  ),NHEL(4  ),-1,W4  )
      CALL VXXXXX(P5  , ZERO,NHEL(5  ), 1,W5  )
      CALL JIOXXX(W4  ,W3  ,GZN,ZMASS,ZWIDTH,W6  )
      CALL FVOXXX(W1  ,W5  ,GAL,FMASS(1  ),FWIDTH(1  ),W7  )
      CALL IOVXXX(W2  ,W7  ,W6  ,GZL,AMP(1  ))
      CALL FVIXXX(W2  ,W5  ,GAL,FMASS(1  ),FWIDTH(1  ),W8  )
      CALL IOVXXX(W8  ,W1  ,W6  ,GZL,AMP(2  ))
      EPEM_VMVMA = 0.D0
      DO I = 1, NEIGEN
          ZTEMP = (0.D0,0.D0)
          DO J = 1, NGRAPHS
              ZTEMP = ZTEMP + EIGEN_VEC(J,I)*AMP(J)
          ENDDO
          EPEM_VMVMA =EPEM_VMVMA+ZTEMP*EIGEN_VAL(I)*CONJG(ZTEMP)
      ENDDO
C      CALL GAUGECHECK(AMP,ZTEMP,EIGEN_VEC,EIGEN_VAL,NGRAPHS,NEIGEN)
      END
      subroutine vxxxxx(
     &              p,          !in: boson four momentum
     &              vmass,      !in: boson mass
     &              nhel,       !in: boson helicity
     &              nsv,        !in: incoming (-1) or outgoing (+1)
     &              vc          !out: boson wavefunction
     &                 )
C ----------------------------------------------------------------------
c
c       Subroutine returns the value of evaluated
c       helicity basis boson polarisation wavefunction.
c       Replaces the HELAS routine VXXXXX
c
c       Adam Duff,  1992 September 3
c       <duff@phenom.physics.wisc.edu>
c
C ----------------------------------------------------------------------
      implicit none
c
c declare input/output variables
c
      complex*16 vc(6)
      integer*4 nhel, nsv
      real*8 p(0:3), vmass
c
c declare local variables
c
      real*8 r_zero, r_one, r_two
      parameter( r_zero=0.0d0, r_one=1.0d0, r_two=2.0d0 )
      complex*16 c_zero
 
c
      real*8 plat, pabs, rs2, rplat, rpabs, rden
C ----------------------------------------------------------------------
      c_zero=dcmplx( r_zero, r_zero )
c define internal/external momenta
c
      if ( nsv**2 .ne. 1 ) then
         stop 'vxxxxx:  nsv is not one of -1, +1'
      end if
c
      rs2 = sqrt( r_one / r_two )
      vc(5) = dcmplx( p(0), p(3) ) * nsv
      vc(6) = dcmplx( p(1), p(2) ) * nsv
      plat = sqrt( p(1)**2 + p(2)**2 )
      pabs = sqrt( p(1)**2 + p(2)**2 + p(3)**2 )
c
c calculate polarisation four vectors
c
      if ( nhel**2 .eq. 1 ) then
         if ( (pabs .eq. r_zero) .or. (plat .eq. r_zero) ) then
            vc(1) = c_zero
            vc(2) = dcmplx( -nhel * rs2 * dsign( r_one, p(3) ), r_zero )
            vc(3) = dcmplx( r_zero, nsv * rs2 )
            vc(4) = c_zero
         else
            rplat = r_one / plat
            rpabs = r_one / pabs
            vc(1) = c_zero
            vc(2) = dcmplx( -nhel * rs2 * rpabs * rplat * p(1) * p(3),
     &                     -nsv * rs2 * rplat * p(2) )
            vc(3) = dcmplx( -nhel * rs2 * rpabs * rplat * p(2) * p(3),
     &                     nsv * rs2 * rplat * p(1) )
            vc(4) = dcmplx( nhel * rs2 * rpabs * plat,
     &                     r_zero )
         end if
      else if ( nhel .eq. 0 ) then
         if ( vmass .gt. r_zero ) then
            if ( pabs .eq. r_zero ) then
               vc(1) = c_zero
               vc(2) = c_zero
               vc(3) = c_zero
               vc(4) = dcmplx( r_one, r_zero )
            else
               rden = p(0) / ( vmass * pabs )
               vc(1) = dcmplx( pabs / vmass, r_zero )
               vc(2) = dcmplx( rden * p(1), r_zero )
               vc(3) = dcmplx( rden * p(2), r_zero )
               vc(4) = dcmplx( rden * p(3), r_zero )
            end if
         else
            stop  'vxxxxx: nhel = 0 is only for massive bosons'
         end if
      else if ( nhel .eq. 4 ) then
         if ( vmass .gt. r_zero ) then
            rden = r_one / vmass
            vc(1) = dcmplx( rden * p(0), r_zero )
            vc(2) = dcmplx( rden * p(1), r_zero )
            vc(3) = dcmplx( rden * p(2), r_zero )
            vc(4) = dcmplx( rden * p(3), r_zero )
         elseif (vmass .eq. r_zero) then
            rden = r_one / p(0)
            vc(1) = dcmplx( rden * p(0), r_zero )
            vc(2) = dcmplx( rden * p(1), r_zero )
            vc(3) = dcmplx( rden * p(2), r_zero )
            vc(4) = dcmplx( rden * p(3), r_zero )
         else
            stop 'vxxxxx: nhel = 4 is only for m>=0'
         end if
      else
         stop 'vxxxxx:  nhel is not one of -1, 0, 1 or 4'
      end if
c
c done
c
      return
      end
c
      subroutine vvvxxx(wm,wp,w3,g , vertex)
C ----------------------------------------------------------------------
c
c this subroutine computes an amplitude of the three-point coupling of
c the gauge bosons.
c
c input:
c       complex wm(6)          : vector               flow-out w-
c       complex wp(6)          : vector               flow-out w+
c       complex w3(6)          : vector               j3 or a    or z
c       real    g              : coupling constant    gw or gwwa or gwwz
c
c output:
c       complex vertex(6)      : amplitude               gamma(wm,wp,w3)
c
C ----------------------------------------------------------------------
      implicit none
      complex*16 wm(6),wp(6),w3(6),vertex(6),
     &        xv1,xv2,xv3,v12,v23,v31,p12,p13,p21,p23,p31,p32
      real*8    pwm(0:3),pwp(0:3),pw3(0:3),g
c
      real*8 r_zero, r_tenth
      real*8 delkappa, lambda, delg1, p_pmin, p_ppls, pmn_ppl, wmass
      real*8 delkappa0(6),lambda0(6)
      integer ic
      common/anom/delkappa0,lambda0
      parameter( r_zero=0.0d0, r_tenth=0.1d0 )
C ----------------------------------------------------------------------
      delg1=0.d0
      wmass=80.2d0
c
      pwm(0)=dble( wm(5))
      pwm(1)=dble( wm(6))
      pwm(2)=dimag(wm(6))
      pwm(3)=dimag(wm(5))
      pwp(0)=dble( wp(5))
      pwp(1)=dble( wp(6))
      pwp(2)=dimag(wp(6))
      pwp(3)=dimag(wp(5))
      pw3(0)=dble( w3(5))
      pw3(1)=dble( w3(6))
      pw3(2)=dimag(w3(6))
      pw3(3)=dimag(w3(5))
c
      v12=wm(1)*wp(1)-wm(2)*wp(2)-wm(3)*wp(3)-wm(4)*wp(4)
      v23=wp(1)*w3(1)-wp(2)*w3(2)-wp(3)*w3(3)-wp(4)*w3(4)
      v31=w3(1)*wm(1)-w3(2)*wm(2)-w3(3)*wm(3)-w3(4)*wm(4)
      xv1=r_zero
      xv2=r_zero
      xv3=r_zero
      if ( abs(wm(1)) .ne. r_zero ) then
         if (abs(wm(1)).ge.max(abs(wm(2)),abs(wm(3)),abs(wm(4)))
     $        *r_tenth)
     &      xv1=pwm(0)/wm(1)
      endif
      if ( abs(wp(1)) .ne. r_zero) then
         if (abs(wp(1)).ge.max(abs(wp(2)),abs(wp(3)),abs(wp(4)))
     $        *r_tenth)
     &      xv2=pwp(0)/wp(1)
      endif
      if ( abs(w3(1)) .ne. r_zero) then
         if ( abs(w3(1)).ge.max(abs(w3(2)),abs(w3(3)),abs(w3(4)))
     $        *r_tenth)
     &      xv3=pw3(0)/w3(1)
      endif
      p12= (pwm(0)-xv1*wm(1))*wp(1)-(pwm(1)-xv1*wm(2))*wp(2)
     &    -(pwm(2)-xv1*wm(3))*wp(3)-(pwm(3)-xv1*wm(4))*wp(4)
      p13= (pwm(0)-xv1*wm(1))*w3(1)-(pwm(1)-xv1*wm(2))*w3(2)
     &    -(pwm(2)-xv1*wm(3))*w3(3)-(pwm(3)-xv1*wm(4))*w3(4)
      p21= (pwp(0)-xv2*wp(1))*wm(1)-(pwp(1)-xv2*wp(2))*wm(2)
     &    -(pwp(2)-xv2*wp(3))*wm(3)-(pwp(3)-xv2*wp(4))*wm(4)
      p23= (pwp(0)-xv2*wp(1))*w3(1)-(pwp(1)-xv2*wp(2))*w3(2)
     &    -(pwp(2)-xv2*wp(3))*w3(3)-(pwp(3)-xv2*wp(4))*w3(4)
      p31= (pw3(0)-xv3*w3(1))*wm(1)-(pw3(1)-xv3*w3(2))*wm(2)
     &    -(pw3(2)-xv3*w3(3))*wm(3)-(pw3(3)-xv3*w3(4))*wm(4)
      p32= (pw3(0)-xv3*w3(1))*wp(1)-(pw3(1)-xv3*w3(2))*wp(2)
     &    -(pw3(2)-xv3*w3(3))*wp(3)-(pw3(3)-xv3*w3(4))*wp(4)
c
        p12=p12+xv1*v12
        p13=p13+xv1*v31
        p21=p21+xv2*v12
        p23=p23+xv2*v23
        p31=p31+xv3*v31
        p32=p32+xv3*v23
        p_pmin=pw3(0)*pwm(0)-pw3(1)*pwm(1)-pw3(2)*pwm(2)-pw3(3)*pwm(3)
        p_ppls=pw3(0)*pwp(0)-pw3(1)*pwp(1)-pw3(2)*pwp(2)-pw3(3)*pwp(3)
        pmn_ppl=pwp(0)*pwm(0)-pwp(1)*pwm(1)-pwp(2)*pwm(2)-pwp(3)*pwm(3)
        do ic=1,6
        delkappa=delkappa0(ic)
        lambda=lambda0(ic)
        vertex(ic) = -(v12*(p13-p23)+v23*(p21-p31)+v31*(p32-p12))*g
c
c anomalous contributions
c-----------------------------------------------------------
        if ((delkappa.ne.0.d0).or.(delg1.ne.0.d0).or.(lambda.ne.0.d0))
     +    then
          if (delkappa.ne.0d0) then
            vertex(ic)=vertex(ic)+g*delkappa*(v23*p31-v31*p32)
          endif
          if (delg1.ne.0.d0) then
           vertex(ic)=vertex(ic)+g*delg1*(v12*(p23-p13)-v23*p21+v31*p12)
          endif
          if (lambda.ne.0.d0) then
            vertex(ic)=vertex(ic) -g*lambda/wmass**2*
     1      (p31*p23*p12 - p32*p13*p21 + p_pmin*(p21*v23-p23*v12)
     2                                 + p_ppls*(p13*v12-p12*v31)
     3                                 + pmn_ppl*(p32*v31-p31*v23))
          endif
        endif
        enddo
      return
      end
      subroutine gen_g
C--------------------------------------------------------------------
      implicit NONE
      REAL*8 Q(4,7),DD,SIG(20),ECM,Q2,JACOB,
     .       COEFF,TWOPI,SIG1(6),WT, sigev(20),x(2),
     .       delkappa(6),lambda(6)
      INTEGER NMAX,NTEMP,NCUT,NGOOD,I,icode,ij,ik,k
      REAL  EGAMG,ECOSG,WTG(6),GSIG,PTG,XTG,WTGK(21),
     &      xexp(441),xexp1(21),xexp2(21)
      common /anom/ delkappa,lambda
      common /anom1/ xexp,xexp1,xexp2
      COMMON / INOUT / INUT,IOUT
      integer inut,iout
C--------------------------------------------------------------------
C
      CALL INPUT(ECM,NMAX,Q,JACOB,DD)
      q2=ecm**2
      TWOPI=6.2831853D0
      COEFF=2*Q2*TWOPI**5
c--
c      CALL INITH
c--
      CALL INITIALIZE
      do i=1,20
        sig(i)=0.d0
        sigev(i)=0.d0
      enddo
      x(1)=0.d0
      x(2)=0.d0
C   START GENERATING EVENTS
      ntemp=0
      NGOOD=0
      icode=1
      call bin2g(sig,x,ntemp,icode)
      write(iout,7880) ecm, nmax
 7880 format('# gen_g : Ecm=',f7.1,'   nmax=',i12)
      icode=2
C loop on events:
 99   ntemp=ntemp+1
      CALL MOMENTA(ECM,Q,WT,DD)
      NCUT=1
      CALL CHECK_CUTS(ecm,Q,NCUT)
      IF(NCUT.EQ.1) GOTO 99
      NGOOD=NGOOD+1
      call xsection(sig1,q)
      do i=1,6
c in pb
        sigev(i)=sig1(i)*wt*jacob/COEFF*0.3894D+9
        sig(i)=sig(i)+sigev(i)
      enddo
c--
      EGAMG = Q(4,5)
      PTG = DSQRT(Q(1,5)**2+Q(2,5)**2)
      ECOSG = DABS(Q(3,5)/Q(4,5))
      XTG = (2.*PTG)/ECM
      do ij=1,6
        wtg(ij) = sigev(ij)
      enddo
      do ik=1,21
        wtgk(ik) = xexp1(ik)*wt*jacob/COEFF*0.3894D+9
      enddo
c--
      x(1)=q(4,5)
      x(2)=q(3,5)/q(4,5)
      call bin2g(sigev,x,ntemp,icode)
      if(NGOOD.lt.nmax) goto 99
C end of loop on events ^^^^^^^
C
      do i=1,6
        sig(i)=sig(i)/NTEMP
        write (iout,1000) delkappa(i),lambda(i),sig(i)
      enddo
c--
      icode=3
      call bin2g(sig,x,ntemp,icode)
      write (iout,1001) NGOOD,ntemp
      return
C--------------------------------------------------------------------
 1000 format(2x,'delkappa,lambda,sig :',2x,f5.1,2x,f5.1,5x,e12.5)
 1001 format(2x,'gen_g : ngood=',i10,2x,'ntemp=',i10 )
      end
      subroutine bin2g(y,x,nev,icode)
C--------------------------------------------------------------------
c  binning, calculating chi^2 and printing
c  for ny quantities y(ny), their names cy(ny), ny<=20
c  as functions of nx<=2 variables x(nx), called cx(nx)
c               in nb1 and nb2 bins from xmin(nx) to xmax(nx), nb<=40
C ICODE=1:INITIALIZATION, =2:BINNING, =3:PRINTING
c nev - number of events
c for chi^2, the ny=1 corresponds to standard couplings
C--------------------------------------------------------------------
      implicit none
      real*8 y(20),x(2),xmin(2),xmax(2),lum,t(20,40,40),a(20,20)
     & , s(20,40,40),delk(21),lam(21),sigma,evmin,error,chilow,chihi
     & , b(20),de(2),xsec(20),bk(20),bl(20),xseck,xsecl,par
     & ,xsection
     & ,effi,xlumi,xsscale,xdata,xsdif
      real xexp(441),xexp1(21),xexp2(21)
 
      integer nx,ny,nev,icode,nb(2),ix1,ix2,ibin1,ibin2
     &   ,idum,ik,il,ix,iy,nb1,nb2,ine,i,ine1,ine2
      character*20 cy(20),cx(2)
C     MINIMUM OF EVENTS IN THE BIN FOR A BIN TO BE ACCEPTED
c and error
      parameter ( EVMIN=1.D0, ERROR=0.02D0 )
      integer inut,iout
      COMMON / INOUT / INUT,IOUT
c in common luminosity, matrix a   and anom. couplings
      common /lumino/ lum,a,delk,lam
      common /binning/ xmin,xmax,cx,cy,nb1,nb2,nx,ny
      common /anom1/ xexp,xexp1,xexp2
C--------------------------------------------------------------------
C
      GO TO (10,20,30) ICODE
 10   nb(1)=nb1
      nb(2)=nb2
      do ix=1,nx
         de(ix)=(xmax(ix)-xmin(ix))/nb(ix)
      enddo
      do iy=1,ny
        do ix1=1,nb1
          do ix2=1,nb2
            t(iy,ix1,ix2)=0.D0
          ENDDO
        ENDDO
      enddo
      return
C
 20   ibin1=idint((x(1)-xmin(1))/de(1))+1
      ibin2=idint((x(2)-xmin(2))/de(2))+1
      DO iy=1,ny
         t(iy,ibin1,ibin2)=t(iy,ibin1,ibin2)+y(iy)
      ENDDO
      RETURN
 
 30   continue
c invert t->s
c first total cross section
      do iy=1,ny
c         write(40,*) iy,y(iy)
         xsec(iy)=0.d0
         do idum=1,ny
            xsec(iy)=xsec(iy)+a(iy,idum)*y(idum)
         enddo
      enddo
      do iy=1,20
          bk(iy)=0.d0
          bl(iy)=0.d0
      enddo
      bk(1)=1.d0
      bl(1)=1.d0
      do iy=1,31
         par=0.2d0*(iy-16)
         bk(2)=par**2
         bk(4)=par
         bl(3)=par**2
         bl(5)=par
         xseck=0.d0
         xsecl=0.d0
         do idum=1,ny
            xseck=xseck+bk(idum)*xsec(idum)
            xsecl=xsecl+bl(idum)*xsec(idum)
         enddo
      enddo
c now t-> for binned xsection
      do ibin1=1,nb1
         do ibin2=1,nb2
             do iy=1,ny
                s(iy,ibin1,ibin2)=0.d0
                do idum=1,ny
                  s(iy,ibin1,ibin2)=s(iy,ibin1,ibin2)
     .                   + a(iy,idum)*t(idum,ibin1,ibin2)/nev
                enddo
             enddo
         ENDDO
      ENDDO
 
c  NOW CALCULATE CHI^2. THIS IS ASSUMING THAT SM CORRESPONDS TO
C                       iy=1
c for WWgamma
      ine = 0
      ine1 = 0
      ine2 = 0
      DO ik=1,21
         do il=1,21
            b(1)=1.d0
            b(2)=delk(ik)**2
            b(3)=lam(il)**2
            b(4)=delk(ik)
            b(5)=lam(il)
            b(6)=delk(ik)*lam(il)
            chilow=0.D0
            chihi=0.d0
            xsection=0.d0
            DO  ibin1=1,nb1
               do ibin2=1,nb2
c get sigma as functions of anomalous couplings
                  sigma=0.d0
                  do iy=1,ny
                     sigma=sigma+b(iy)*s(iy,ibin1,ibin2)
                  enddo
c low luminosity
                    IF(LUM*sigma.GT.EVMIN)
     .               chilow=chilow+LUM*(sigma-s(1,ibin1,ibin2))**2/
     .              s(1,ibin1,ibin2)/
     .                (1.D0+ERROR**2*LUM*s(1,ibin1,ibin2))
c high luminosity 10 times bigger
                    IF(LUM*sigma*10.d0.GT.EVMIN)
     .          chihi=chihi+10.d0*LUM*(sigma-s(1,ibin1,ibin2))**2/
     .              s(1,ibin1,ibin2)/
     .                (1.D0+ERROR**2*10.d0*LUM*s(1,ibin1,ibin2))
                 xsection=xsection+sigma
               enddo
            ENDDO
         enddo
      enddo
C
      RETURN
      END
      SUBROUTINE INPUT(ECM,NMAX,Q,JACOB,DD)
C--------------------------------------------------------------------
      IMPLICIT NONE
      character*20 cy(20),cx(2),outname
      REAL*8 ECM,Q(4,7),JACOB,DD,MZ,GZ
      REAL*8 ML,lum,one,half,k,l,k2,l2
     .  ,delkappa(6),lambda(6),kmax,lmax
      REAL*8  delk(21),lam(21),a(20,20),xmin(2),xmax(2)
      REAL*8 EPHOT,ANGLE,MVV,EPHOT0,ANGLE0,MVV0
      INTEGER N3,NMAX,n1,n2,ny,nx,ianom,nb1,nb2,nwwgi,nneutri
      integer nwwg,nneutr,nm0
      integer jtrig,namind
      real tabl
      COMMON / gengto / TABL(40)
C*CA PHCUTS
      REAL*4 EPHMIN,EPHMAX,XTFMIN,XTFMAX,COSTHM
      COMMON / PHCUTS / EPHMIN,EPHMAX,XTFMIN,XTFMAX,COSTHM
      integer inut,iout
C*CC PHCUTS
      COMMON / INOUT / INUT,IOUT
      integer ifkalin
      common /kalino/ ifkalin
C
C Commons specific to this package:
      common/flags/nwwg,nneutr
      COMMON/MZGZ/MZ,GZ
      common/lumino/lum,a,delk,lam
      common/binning/xmin,xmax,cx,cy,nb1,nb2,nx,ny
      COMMON/LIMITS/ML
      COMMON/CUTS/EPHOT,ANGLE,MVV
      common/anom/delkappa,lambda
C vvvvvvvvvvvvv begin mods JB 970403 vvvvvvvvvvvvvvvvvvvv
C--------------------------------------------------------------------
C ---- Initialisation of internal constants:
c luminosity
      lum = 22.0D0
c parameters to calculate the 'a' matrix
      k = 10.0D0
      l = 10.0D0
c number of bins in two variables
      nb1 = 1
      nb2 = 1
c range of del(kappa) and lambda
      kmax = 10.0D0
      lmax = 10.0D0
c cut to eliminate Z+gamma background
      MVV = 0.0D0
c to turn on wwg coupling nwwg=1, to turn off nwwg=0
      nwwg = 0
      if (ifkalin.gt.0) nwwg = 1
C -----  Data from other commons in the program:
C Center-of-mass energy:
      ecm = DBLE(2.*TABL(16))
C Number of events accepted :
      nm0  = 100
      nmax = 0
      namind=1
      write(*,*) 'wild namind=',namind
      if (nmax.lt.nm0) nmax = nm0
c number of neutrino types,
c nneutr=1 only electron neutrinos
c nneutr=3 all neutrinos
      nneutr = TABL(12)
      if (nneutr.lt.1.or.nneutr.gt.3) write(iout,333)  nneutr
 333  format (/' ++ INPUT : wrong nneutr =',I5)
c Minimum photon energy:
      ephot = DBLE(EPHMIN)
C Minimum beam-photon angle:
      angle = DACOS(DBLE(COSTHM))
C ^^^^^^^^^^^^^^ end of mods JB 970403 ^^^^^^^^^^^^^^^^^^
c data for precomputing cross sections for a fixed set of couplings.
        ml=0.d0
        mz=tabl(13)
        gz=tabl(14)
        one=1.d0
        half=0.5d0
        do ianom=1,6
         delkappa(ianom)=0.d0
         lambda(ianom)=0.d0
      enddo
      delkappa(2)=-k
      delkappa(3)=k
      lambda(4)=-l
      lambda(5)=l
      delkappa(6)=k
      lambda(6)=l
c initialize matrix a for bin2g
      do n1=1,20
          do n2=1,20
            a(n1,n2)=0.d0
          enddo
      enddo
      k2=k**2
      l2=l**2
       a(1,1)=one
         a(2,1)=-1.d0/k2
         a(2,2)=half/k2
         a(2,3)=half/k2
            a(3,1)=-1.d0/l2
            a(3,4)=half/l2
            a(3,5)=half/l2
               a(4,2)=-half/k
               a(4,3)=half/k
                   a(5,4)=-half/l
                   a(5,5)=half/l
                       a(6,1)=1.d0/k/l
                       a(6,3)=-1.d0/k/l
                       a(6,5)=-1.d0/k/l
                       a(6,6)=1.d0/k/l
 
 20   FORMAT(10X,G20.10)
 21   FORMAT(10X,I10)
 22   format(10x,a20)
      write(IOUT,*)' --------------------------------------------'
      write(IOUT,*)' - INPUT : ----------------------------------'
      write(IOUT,*)' - for GENG generator -----------------------'
      write(IOUT,*)' - by J. Kalinowski -------------------------'
      write(IOUT,*)' - GENG is run in  initialization -----------'
      write(IOUT,*)' - GENG output is for technical checks ------'
      write(IOUT,*)' - PRINTED: variables: ecm, nmax and CUTS ---'
      write(IOUT,*)' - are used locally only, thus are dummy ----'
      write(IOUT,*)' - for the KORALZ run -----------------------'
      WRITE(IOUT,23) ECM,NMAX,nneutr
 23   format(2x,'ecm=',f8.2,'  nmax=',i8,' nneutr=',i8)
      write(IOUT,229) (delkappa(n1),n1=1,6)
 229  format(2x,'delkappa',6(2x,f5.1))
      write(IOUT,228) (lambda(n1),n1=1,6)
 228  format(2x,'lambda',6(2x,f6.1))
      write(IOUT,*)'matrix A'
      write(IOUT,227) (a(1,n1),n1=1,6)
      write(IOUT,227) (a(2,n1),n1=1,6)
      write(IOUT,227) (a(3,n1),n1=1,6)
      write(IOUT,227) (a(4,n1),n1=1,6)
      write(IOUT,227) (a(5,n1),n1=1,6)
      write(IOUT,227) (a(6,n1),n1=1,6)
 227  format(6(f5.1))
c ml=neutrino mass
      dd=-15.d0
c initialise incoming momenta, + Z axis along electron
      do n3=1,2
         q(1,n3)=0.d0
         q(2,n3)=0.d0
         q(4,n3)=ECM/2.d0
      enddo
      q(3,1)=-ECM/2.d0
      q(3,2)=ECM/2.d0
      JACOB=1.D0
c   for binning
      ny=6
      cy(1)='sm'
      cy(2)='delk=-1'
      cy(3)='delk=1'
      cy(4)='lamb=-1'
      cy(5)='lamb=1'
      cy(6)='delk=lamb=1'
      nx=2
      cx(1)='energy'
      xmin(1)=ephot
      xmax(1)=ecm/2.d0
      cx(2)='cos(angle)'
      xmin(2)=-dcos(angle)
      xmax(2)= dcos(angle)
c  delk and lam for bin2g
      do n1=1,21
          delk(n1)=kmax*(n1-11)/10.d0
          lam(n1)=lmax*(n1-11)/10.d0
      enddo
      WRITE(IOUT,2179) EPHOT,ANGLE,MVV
 2179 FORMAT(1X,'CUTS',/,' MINIMUM PHOTON ENERGY=',F8.3,/,
     .  ' JET-BEAM ANGLE=',F8.3,/,' NEUTRINOS OUTSIDE Z=',F8.3)
      RETURN
      END
      SUBROUTINE QUGACOUP(MODE)
      IMPLICIT NONE
      INTEGER MODE
      IF (MODE.EQ.-1) THEN
       call  QGCINIT
      ELSE
cc       call QGCCAL(1D-2)  !pt must be xxx GeV to calculate anomalous
         call QGCCAL(1D-1)
      ENDIF
      END

      SUBROUTINE QGCCAL(PT0)
      IMPLICIT NONE
      DOUBLE PRECISION   xphot(100,4),p1(4),p2(4),p3(4),p4(4),ph1(4),
     +                   ph2(4)
      DOUBLE PRECISION   mph,m1,m2,m3,m4,p1v(4),p2v(4),p3v(4),p4v(4),
     +                   ph1v(4),ph2v(4)
      DOUBLE PRECISION WT(6),PT,PT1,PT2,PT0
      Integer KFf,nphox,K,L
      common /wtqgc/ wt
C-----------------------------------------------------------------------
      real*8 aaa0(6),aaac(6),aa0,aac
      data aaa0 / 0.0D0, -300.0D0, 300.0D0, 2*0.0D0, 300.0D0 /
      data aaac / 3*0.0D0, -300.0D0, 2*300.0D0 /
C-----------------------------------------------------------------------
      DO K=1,6
        WT(K)=1D0
      ENDDO
      CALL KarLud_GetKFfin( KFf)
      IF (KFf.EQ.12.OR.KFf.EQ.14.OR.KFf.EQ.16) THEN
      ELSE
       RETURN
      ENDIF

      CALL KarLud_GetPhotons(nphox,xphot)
      if (nphox.lt.2) return

      CALL KarLud_GetBeams(    p1, p2)
C      CALL KarFin_GetFermions( p3, p4)
C  try swapping ... ZW 19 july 2002
      CALL KarFin_GetFermions( p4, p3)
      m1=dsqrt(abs(p1(4)**2-p1(3)**2-p1(2)**2-p1(1)**2))
      m2=dsqrt(abs(p2(4)**2-p2(3)**2-p2(2)**2-p2(1)**2))
      m3=dsqrt(abs(p3(4)**2-p3(3)**2-p3(2)**2-p3(1)**2))
      m4=dsqrt(abs(p4(4)**2-p4(3)**2-p4(2)**2-p4(1)**2))
      mph=dsqrt(abs(ph1(4)**2-ph1(3)**2-ph1(2)**2-ph1(1)**2))

!      Now let us get dominant photons.
      PT1=0D0
      PT2=0D0
      DO K=1,nphox
       PT=xphot(k,1)**2+xphot(k,2)**2
       IF (PT.GT.PT1) THEN
         PT1=PT
         DO L=1,4
          ph1(L)=xphot(K,L)
         ENDDO
       ELSEIF(PT.GT.PT2) THEN
         PT2=PT
         DO L=1,4
          ph2(L)=xphot(K,L)
         ENDDO
       ENDIF
      ENDDO
      IF (PT2.LT.PT0) RETURN
      call QGC_KinExt2(p1,m1,p2,m2,p3,m3,p4,m4,ph1,ph2,mph,ph1v,
     +                ph2v,p1v,p2v,p3v,p4v)
C we have now kinematical configuration ready to fill the common of weights.

      DO K=1,6
         aa0=aaa0(k)
         aac=aaac(k)
         call qgccalu(aa0,aac,ph1v,ph2v,p1v,p2v,p3v,p4v,WT(k))
      ENDDO


      DO K=1,5
        WT(k)=Wt(k)/wt(6)
      ENDDO
        wt(6)=1D0
      END
      SUBROUTINE  qgccalu(aa0,aac,ph1v,ph2v,p1v,p2v,p3v,p4v,sig)
      IMPLICIT NONE
      INTEGER I
      DOUBLE PRECISION   SEENUNUGG
      DOUBLE PRECISION   aa0,aac,p1v(4), p2v(4), p3v(4), p4v(4),
     +                    ph1v(4), ph2v(4),sig
      DOUBLE PRECISION  A0,AC,LAMBDA
      COMMON/ANOMALOUS/A0,AC,LAMBDA
      REAL*8 PMG1(0:3),PMG2(0:3),PMG3(0:3),PMG4(0:3),PMG5(0:3),
     +       PMG6(0:3)
      a0=aa0
      ac=aac
C -- SCALE AT WHICH NEW PHYSICS COMES IN
      LAMBDA=80.40D0

! we have only 25 % chances that afiliations e+e- and nu bar_nu is OK
         DO I=1,3
       PMG1(I)=P1v(I)
       PMG2(I)=P2v(I)
       PMG3(I)=ph1v(I)
       PMG4(I)=ph2v(I)
       PMG5(I)=p3v(I)
       PMG6(I)=p4v(I)
        ENDDO
       PMG1(0)=P1v(4)
       PMG2(0)=P2v(4)
       PMG3(0)=ph1v(4)
       PMG4(0)=ph2v(4)
       PMG5(0)=p3v(4)
       PMG6(0)=p4v(4)


C -- EVENT PASSES, SO CALCULATE THE MATRIX ELEMENT
C -- FIRST WORK OUT THE SPINOR PRODUCTS...
      CALL STD(8)
C -- ...THEN THE MATRIX ELEMENT...


      sig=SEENUNUGG(PMG1,PMG2,PMG3,PMG4,PMG5,PMG6)

      end
      SUBROUTINE  QGC_KinExt2(p1,m1,p2,m2,p3,m3,p4,m4,ph1,ph2,
     +            mph,ph1v,ph2v,p1v,p2v,p3v,p4v)
*/////////////////////////////////////////////////////////////////////////////////////
*//                                                                                 //
*//   kinematical extrapolation of complete to momenum conservation                 //
*//   pv3,pv4 are to replace p3 and p4 fulfilling that                              //
*//  used in reduction procedure for electron neutrino channel                      //
*//   p1,m1,p2,m2,p3,m3,p4,m4,ph,mph INPUT                                          //
*//   pv3,pv4                        OUTPUT                                         //
*//                                                                                 //
*/////////////////////////////////////////////////////////////////////////////////////
      IMPLICIT NONE
      DOUBLE PRECISION      PX(4),p1(4),p2(4),p3(4),p4(4),ph1(4),
     +                      PFAT(4),PSUM(4),PTEST(4)
      DOUBLE PRECISION      p1v(4),p2v(4),p3v(4),p4v(4),ph1v(4),
     +                      ph2v(4),ph2(4)
      DOUBLE PRECISION      m1,m2,m3,m4,mph,F0,F1
      INTEGER k
       DO K=1,4
        PFAT(K)=p3(k)+p4(k)+ph1(k)+ph2(k)
        PTEST(K)=p1(k)+p2(k)-ph1(k)-ph2(k)
        psum(k)=p3(k)+p4(k)+ph1(k)+ph2(k)
        p1v(k)=p1(k)
        p2v(k)=p2(k)
        ph1v(k)=ph1(k)
        ph2v(k)=ph2(k)
       ENDDO
       CALL KinLib_BostQ(1,Psum,ph1,ph1v)
       CALL KinLib_BostQ(1,Psum,ph2,ph2v)
       CALL KinLib_BostQ(1,Psum,p3,p3v)
       CALL KinLib_BostQ(1,Psum,p4,p4v)
       CALL KinLib_BostQ(1,PFAT,ptest,ptest)
       CALL KinLib_BostQ(1,PFAT,psum,psum)
       F0=psum(4)/2
       F1=sqrt((F0**2-m3**2))
       p1v(4)=F0
       p2v(4)=F0
       p1v(3)=F1*p1(3)/abs(p1(3))
       p2v(3)=-p1v(3)
       DO K=1,2
         p1v(k)=0
         p2v(k)=0
       ENDDO


       CALL KinLib_BostQ(-1,PFAT,p1v,p1v)
       CALL KinLib_BostQ(-1,PFAT,p2v,p2v)
       CALL KinLib_BostQ(-1,PFAT,p3v,p3v)
       CALL KinLib_BostQ(-1,PFAT,p4v,p4v)
       CALL KinLib_BostQ(-1,PFAT,ph1v,ph1v)
       CALL KinLib_BostQ(-1,PFAT,ph2v,ph2v)

       RETURN
C --   tests are below
       write(*,*) '3 body kinematics missing momentum visible',
     +            ' in last line'
       write(*,*) '--------------'
       write(*,*) p3
       write(*,*) p4
       do k=1,4
         write(*,*) p1(k)+p2(k),ph1(k)+ph2(k)+p3(k)+p4(k)
       enddo
       write(*,*) ' '
       write(*,*) ' after reparation (dirt moved under beams) '
       write(*,*) ph1v
       write(*,*) ph2v
       write(*,*) p1v
       write(*,*) p2v
       write(*,*) p3v
       write(*,*) p4v
       do k=1,4
         write(*,*) p1v(k)+p2v(k),ph1v(k)+ph2v(k)+p3v(k)+p4v(k)
       enddo
       stop
      END
       SUBROUTINE QGCINIT
C-----------------------------------------------------------------------
      common / GLUPAR / svert(3),xvrt(3),sxvrt(3),ecm,ipl,ifvrt
      real*4 ecm,svert,xvrt,sxvrt
c
      real*8 aaa0(6),aaac(6),aa0,aac,eecm
      DATA AAA0 / 0.0D0, -300.0D0, 300.0D0, 2*0.0D0, 300.0D0 /
      DATA AAAC / 3*0.0D0, -300.0D0, 2*300.0D0 /
C-----------------------------------------------------------------------
c      eecm=189.D0 !!200.0D0
      eecm=dble(ecm)
      lou=6! iw(6)
      do 100 k=1,6
         aa0=aaa0(k)
         aac=aaac(k)
         call nunugg(eecm,aa0,aac,lou)
 100  continue
      return
      END
      subroutine nunugg(ecm,aa0,aac,lou)
      IMPLICIT REAL*8(A-H,O-Z)
      REAL*8 P(4,100),XM(100),Q(4,20)
      REAL*8 P1(4),P2(4),NU1(4),NU2(4),K2(4),P02(4),K1(4),P01(4)
      COMMON/MOM/Q
      COMMON/CUTVALS/EPMIN,ETAMAX,EPMAX
      DOUBLE PRECISION  A0,AC,LAMBDA
      COMMON/ANOMALOUS/A0,AC,LAMBDA
      REAL*8 PMG1(0:3),PMG2(0:3),PMG3(0:3),PMG4(0:3),
     +       PMG5(0:3),PMG6(0:3)
      DATA PI,TWOPI,GEVPB/3.1415927D0,6.2831853D0,389379.66D3/
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                                                        C
C                                                        C
C  E-(P2) E+(P1) -->  NU(5) NUBAR(6) GAMMA(3) GAMMA(4)   C
C                                                        C
C                                                        C
C                                                        C
C                                                        C
C                                                        C
C                                                        C
C  FERMIONS ARE ALL MASSLESS                             C
C                                                        C
C     1,2 = TRANSVERSE CMPTS.                            C
C       3 = BEAM CMPT.                                   C
C       4 = ENERGY                                       C
C                                                        C
C  THIS VERSION (29.06.99)                               C
C                                                        C
C   BY ANJA WERTHENBACH  (BASED ON MADGRAPH)             C
C                                                        C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

C -- COLLIDER ENERGY...(IN GEV)
c      RTS=200D0
      rts=ecm
C -- CUTS (EP=ENERGY PHOTON, ETA=SEPARATION TO BEAM)
      EPMIN=20D0
      EPMAX=RTS
      ETAMAX=2D0
c      etamax=0.1D0
C -- ANOMALOUS PARAMETERS ( ZERO IN SM)
c      A0=0.0D0
c      AC=0.0D0
      a0=aa0
      ac=aac
C -- SCALE AT WHICH NEW PHYSICS COMES IN
      LAMBDA=80.40D0
C -- INITIALISE COUNTERS ETC...
C -- NUMBER OF EVENTS GENERATED
      NEVMX=10000
C -- CHANGES BELOW THIS LINE MAY BE FATAL
C -- (EXEPT IN SUBROUTINE BINIT)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
            NIN=0
            NOUT=0
            NHIST=1
            DO 3 I=1,NHIST
  3         CALL HISTO3(I)
      SIG=0.D0
      SIGSQ=0.D0
      DO 5 J=1,100
      XM(J)=0.D0
      DO 5 I=1,4
  5   P(I,J)=0.D0

C -- OVERALL FACTORS: FLUX, PI, NO SPIN AVERAGE HERE, GEV->PB
      CPL=GEVPB/TWOPI**(8)
      EBEAM=RTS/2D0
C -- SET UP INCOMING MOMENTA
          P1(1)=0.D0
          P1(2)=0.D0
          P1(3)=-EBEAM
          P1(4)=EBEAM
          P2(1)=0.D0
          P2(2)=0.D0
          P2(3)=EBEAM
          P2(4)=EBEAM
          P01(1)=0.D0
          P01(2)=0.D0
          P01(3)=1D0
          P01(4)=1D0
          P02(1)=0.D0
          P02(2)=0.D0
          P02(3)=1D0
          P02(4)=1D0

      call initializeq

C -- GENERATE EVENTS
      DO 500 IEV=1,NEVMX
          NEVT=IEV
          ICUT=0
          WEIGHT=0.D0


C -- FIRST, 4-BODY PHASE SPACE FOR ZGAMMAGAMMA
          XM(1)=0.D0
          XM(2)=0.D0
          XM(3)=0.D0
          XM(4)=0.D0
          CALL RAMBOI(4,RTS,XM,P,WTPS)
        DO I=1,4
        NU1(I)=P(I,1)
        NU2(I)=P(I,2)
        K1(I)=P(I,3)
        K2(I)=P(I,4)
        ENDDO


C -- CONVERT MOMENTA TO STD REQUIRED FORMAT
        DO I=1,4
        Q(I,1)=P1(I)
        Q(I,2)=P2(I)
        Q(I,3)=K1(I)
        Q(I,4)=K2(I)
        Q(I,5)=NU2(I)
        Q(I,6)=NU1(I)
        Q(I,7)=P01(I)
        Q(I,8)=P02(I)
        ENDDO
        DO I=1,3
       PMG1(I)=P1(I)
       PMG2(I)=P2(I)
       PMG3(I)=K1(I)
       PMG4(I)=K2(I)
       PMG5(I)=NU2(I)
       PMG6(I)=NU1(I)
        ENDDO
       PMG1(0)=P1(4)
       PMG2(0)=P2(4)
       PMG3(0)=K1(4)
       PMG4(0)=K2(4)
       PMG5(0)=NU2(4)
       PMG6(0)=NU1(4)
C
C -- APPLY EVENT CUTS...
          CALL CUT(ICUT)
          IF(ICUT.EQ.0) GOTO 400

C -- EVENT PASSES, SO CALCULATE THE MATRIX ELEMENT
C -- FIRST WORK OUT THE SPINOR PRODUCTS...
      CALL STD(8)
C -- ...THEN THE MATRIX ELEMENT...


      AMP=SEENUNUGG(PMG1,PMG2,PMG3,PMG4,PMG5,PMG6)
      FLUX=1D0/2D0/RTS**2
      WEIGHT=FLUX*WTPS*CPL*AMP
      WTHIST=WEIGHT/DFLOAT(NEVMX)
      CALL BINIT(WTHIST)

  400 NIN=NIN+ICUT
      SIG=SIG+WEIGHT
      SIGSQ=SIGSQ+WEIGHT*WEIGHT
  500 CONTINUE

      NEV=NEVT
C -- CALCULATE CROSS SECTION AND ERROR
       SIG=SIG/DFLOAT(NEV)
       DSIG=DSQRT(SIGSQ-SIG*SIG*DFLOAT(NEV))/DFLOAT(NEV)

C -- PRINT OUT THE RESULTS
      WRITE (lou,603) A0,AC
 603  FORMAT (/'  --> nunugg called with A0, AC =',2G16.7)
      SIGF=1D3*SIG
      DSIGF=1D3*DSIG
      WRITE(lou,660)RTS
      WRITE(lou,610)SIGF,DSIGF
      WRITE(lou,*)
      WRITE(lou,620)NEV,NIN,NEV-NIN
C      WRITE(6,640)SIG0
C      WRITE(6,670)SIG/SIG0,DSIG/SIG0
C      WRITE(6,680)RTS,SIG,DSIG,SIG0
  610 FORMAT(/,' Cross-section =',G16.7,'  +-  ',G16.7,'   FB',/)
  660 FORMAT(1X,' LEP energy :' ,5F9.4,/)
  620 FORMAT(1X,'Generated events: in.out : ',3I8,/)
  640 FORMAT(1X,'[TOTAL LOWEST-ORDER CROSS SECTION] :  '
     .  ,G12.5,' PB',/)
  670 FORMAT(1X,'[SIGMA/SIGMA0] :  ',F10.7,' +- ',F10.7,/)
  680 FORMAT(1X,F10.4,3X,2F10.4,3X,F10.4)

C-- PRINT OUT HISTOGRAMS
C          CALL HISTO2(1,0)


      return
      END
C
      SUBROUTINE BINIT(WT)
      IMPLICIT REAL*8(A-H,O-Z)
      REAL*8 Q(4,20)
      REAL*8  MASS
      COMMON/MOM/Q
C            CALL HISTO1(1,100,0D0,200D0,Q(4,3),WT)
C -- INVARIANT MASS OF NEUTRINOS
      MASS=DSQRT((Q(4,5)+Q(4,6))**2-(Q(1,5)+Q(1,6))**2
     .           -(Q(2,5)+Q(2,6))**2-(Q(3,5)+Q(3,6))**2)
            CALL HISTO1(1,100,0D0,200D0,MASS,WT)


      RETURN
      END
C
      SUBROUTINE CUT(ICUT)
C ---------------------------------------------------------
      IMPLICIT REAL*8(A-H,O-Z)
      REAL*8 Q(4,20)
      COMMON/MOM/Q
      COMMON/CUTVALS/EPMIN,ETAMAX,EPMAX
      REAL*4 EPHMIN,EPHMAX,XTFMIN,XTFMAX,COSTHM
      COMMON / PHCUTS / EPHMIN,EPHMAX,XTFMIN,XTFMAX,COSTHM
C ---------------------------------------------------------
      ICUT=0
      IF(Q(4,3).LT.EPHMIN) RETURN
      ETAK1=DLOG((Q(4,3)+Q(3,3))/(Q(4,3)-Q(3,3)))/2D0
      IF(DABS(ETAK1).GT.ETAMAX) RETURN
      IF(Q(4,4).LT.EPHMIN) RETURN
      ETAK2=DLOG((Q(4,4)+Q(3,4))/(Q(4,4)-Q(3,4)))/2D0
      IF(DABS(ETAK2).GT.ETAMAX) RETURN
      IF(Q(4,3).GT.EPHMAX) RETURN
      IF(Q(4,4).GT.EPHMAX) RETURN
      ICUT=1
      RETURN
      END
C
      SUBROUTINE HISTO1(IH,IB,X0,X1,X,W)
      IMPLICIT REAL*8(A-H,O-Z)
      CHARACTER*1 REGEL(30),BLANK,STAR
      DIMENSION H(20,100),HX(20),IO(20),IU(20),II(20)
      DIMENSION Y0(20),Y1(20),IC(20)
      DATA REGEL / 30*' ' /,BLANK /' ' /,STAR /'*'/
      Y0(IH)=X0
      Y1(IH)=X1
      IC(IH)=IB
      IF(X.LT.X0) GOTO 11
      IF(X.GT.X1) GOTO 12
      IX=IDINT((X-X0)/(X1-X0)*DFLOAT(IB))+1
      H(IH,IX)=H(IH,IX)+W
      IF(H(IH,IX).GT.HX(IH)) HX(IH)=H(IH,IX)
      II(IH)=II(IH)+1
      RETURN
   11 IU(IH)=IU(IH)+1
      RETURN
   12 IO(IH)=IO(IH)+1
      RETURN
      ENTRY HISTO2(IH,IL)
      IB1=IC(IH)
      X01=Y0(IH)
      X11=Y1(IH)
      BSIZE=(X11-X01)/DFLOAT(IB1)
      HX(IH)=HX(IH)*(1.D0+1.D-06)
C      IF(IL.EQ.0) WRITE(6,21) IH,II(IH),IU(IH),IO(IH)
C      IF(IL.EQ.1) WRITE(6,22) IH,II(IH),IU(IH),IO(IH)
   21 FORMAT(' NO.',I3,' LIN : INSIDE,UNDER,OVER ',3I6)
   22 FORMAT(' NO.',I3,' LOG : INSIDE,UNDER,OVER ',3I6)
      IF(II(IH).EQ.0) GOTO 28
C      WRITE(6,23)
   23 FORMAT(35(1H ),3(10H----+----I))
      DO 27 IV=1,IB1
      Z=(DFLOAT(IV)-0.5D0)/DFLOAT(IB1)*(X11-X01)+X01
      IF(IL.EQ.1) GOTO 24
      IZ=IDINT(H(IH,IV)/HX(IH)*30.)+1
      GOTO 25
   24 IZ=-1
      IF(H(IH,IV).GT.0.D0)
     .IZ=IDINT(DLOG(H(IH,IV))/DLOG(HX(IH))*30.)+1
   25 IF(IZ.GT.0.AND.IZ.LE.30) REGEL(IZ)=STAR
C      WRITE(6,26) Z,H(IH,IV)/BSIZE,(REGEL(I),I=1,30)
      WRITE(6,36) Z,H(IH,IV)/BSIZE
      WRITE(8,36) Z,H(IH,IV)/BSIZE
   26 FORMAT(1H ,2G15.6,4H   I,30A1,1HI)
   36 FORMAT(1H ,2G15.6)
      IF(IZ.GT.0.AND.IZ.LE.30) REGEL(IZ)=BLANK
   27 CONTINUE
C      WRITE(6,23)
      RETURN
   28 WRITE(6,29)
   29 FORMAT('  ')
      RETURN
      ENTRY HISTO3(IH)
      DO 31 I=1,100
   31 H(IH,I)=0.
      HX(IH)=0.
      IO(IH)=0
      IU(IH)=0
      II(IH)=0
      RETURN
      END
C
      SUBROUTINE BOOSTQ(Q,PBOO,PCM,PLB)
      REAL*8 PBOO(4),PCM(4),PLB(4),Q,FACT
         PLB(4)=(PBOO(4)*PCM(4)+PBOO(3)*PCM(3)
     &             +PBOO(2)*PCM(2)+PBOO(1)*PCM(1))/Q
         FACT=(PLB(4)+PCM(4))/(Q+PBOO(4))
         DO 10 J=1,3
  10     PLB(J)=PCM(J)+FACT*PBOO(J)
      RETURN
      END
C
      FUNCTION RN(IDUM)
*
* SUBTRACTIVE MITCHELL-MOORE GENERATOR
* RONALD KLEISS - OCTOBER 2, 1987
*
* THE ALGORITHM IS N(I)=[ N(I-24) - N(I-55) ]MOD M,
* IMPLEMENTED IN A CIRUCULAR ARRAY WITH IDENTIFCATION
* OF NR(I+55) AND NR(I), SUCH THAT EFFECTIVELY:
*        N(1)   <---   N(32) - N(1)
*        N(2)   <---   N(33) - N(2)  ....
*   .... N(24)  <---   N(55) - N(24)
*        N(25)  <---   N(1)  - N(25) ....
*   .... N(54)  <---   N(30) - N(54)
*        N(55)  <---   N(31) - N(55)
*
* IN THIS VERSION  M =2**30  AND  RM=1/M=2.D0**(-30.D0)
*
* THE ARRAY NR HAS BEEN INITIALIZED BY PUTTING NR(I)=I
* AND SUBSEQUENTLY RUNNING THE ALGORITHM 100,000 TIMES.
*
      IMPLICIT REAL*8(A-H,O-Z)
      DIMENSION N(55)
      DATA N/
     . 980629335, 889272121, 422278310,1042669295, 531256381,
     . 335028099,  47160432, 788808135, 660624592, 793263632,
     . 998900570, 470796980, 327436767, 287473989, 119515078,
     . 575143087, 922274831,  21914605, 923291707, 753782759,
     . 254480986, 816423843, 931542684, 993691006, 343157264,
     . 272972469, 733687879, 468941742, 444207473, 896089285,
     . 629371118, 892845902, 163581912, 861580190,  85601059,
     . 899226806, 438711780, 921057966, 794646776, 417139730,
     . 343610085, 737162282,1024718389,  65196680, 954338580,
     . 642649958, 240238978, 722544540, 281483031,1024570269,
     . 602730138, 915220349, 651571385, 405259519, 145115737/
      DATA M/1073741824/
      DATA RM/0.9313225746154785D-09/
      DATA K/55/,L/31/
      IF(K.EQ.55) THEN
         K=1
         ELSE
         K=K+1
         ENDIF
      IF(L.EQ.55) THEN
         L=1
         ELSE
         L=L+1
         ENDIF
      J=N(L)-N(K)
      IF(J.LT.0) J=J+M
      N(K)=J
      RN=J*RM
      RETURN
      END
C


      SUBROUTINE STD(NTOT)
      IMPLICIT REAL*8(A-H,O-Z)
      COMPLEX*16 S(20,20),T(20,20),C23(20)
      REAL*8 Q(4,20),D(20,20),ROOT(20)
      COMMON/CSTD/S,T,D
      COMMON/MOM/Q
      DO  K=1,20
      S(K,K)=DCMPLX(0.D0,0.D0)
      T(K,K)=S(K,K)
      D(K,K)=0.D0
      ENDDO
      DO K=1,NTOT
      ROOT(K)=DSQRT(Q(4,K)-Q(1,K))
      C23(K)=DCMPLX(Q(2,K),Q(3,K))
      ENDDO
      DO 10 I=2,NTOT
      DO 10 J=1,I-1
      S(I,J)=C23(I)*ROOT(J)/ROOT(I) - C23(J)*ROOT(I)/ROOT(J)
      S(J,I)=-S(I,J)
      T(I,J)=-DCONJG(S(I,J))
      T(J,I)=-T(I,J)
      D(I,J)=S(I,J)*T(J,I)
      D(J,I)=D(I,J)
  10  CONTINUE
      RETURN

      END



      REAL*8 FUNCTION SEENUNUGG(P1, P2, P3, P4, P5, P6)
C
C FUNCTION GENERATED BY MADGRAPH
C RETURNS AMPLITUDE SQUARED SUMMED/AVG OVER COLORS
C AND HELICITIES
C FOR THE POINT IN PHASE SPACE P1,P2,P3,P4,...
C
C FOR PROCESS : e+ e-  -> a a ve ve~
C
      IMPLICIT NONE
C
C CONSTANTS
C
      INTEGER    NEXTERNAL,   NCOMB
      PARAMETER (NEXTERNAL=6, NCOMB= 64)
C
C ARGUMENTS
C
      REAL*8 P1(0:3),P2(0:3),P3(0:3),P4(0:3),P5(0:3),P6(0:3)
C
C LOCAL VARIABLES
C
      INTEGER NHEL(NEXTERNAL,NCOMB),NTRY
C      REAL*8 T
      REAL*8 T34, T38, T42, T46, T
      REAL*8 EENUNUGG
      INTEGER IHEL
      LOGICAL GOODHEL(NCOMB)
      DATA GOODHEL/NCOMB*.FALSE./
      DATA NTRY/0/
      DATA (NHEL(IHEL,  1),IHEL=1,6) / -1, -1, -1, -1, -1, -1/
      DATA (NHEL(IHEL,  2),IHEL=1,6) / -1, -1, -1, -1, -1,  1/
      DATA (NHEL(IHEL,  3),IHEL=1,6) / -1, -1, -1, -1,  1, -1/
      DATA (NHEL(IHEL,  4),IHEL=1,6) / -1, -1, -1, -1,  1,  1/
      DATA (NHEL(IHEL,  5),IHEL=1,6) / -1, -1, -1,  1, -1, -1/
      DATA (NHEL(IHEL,  6),IHEL=1,6) / -1, -1, -1,  1, -1,  1/
      DATA (NHEL(IHEL,  7),IHEL=1,6) / -1, -1, -1,  1,  1, -1/
      DATA (NHEL(IHEL,  8),IHEL=1,6) / -1, -1, -1,  1,  1,  1/
      DATA (NHEL(IHEL,  9),IHEL=1,6) / -1, -1,  1, -1, -1, -1/
      DATA (NHEL(IHEL, 10),IHEL=1,6) / -1, -1,  1, -1, -1,  1/
      DATA (NHEL(IHEL, 11),IHEL=1,6) / -1, -1,  1, -1,  1, -1/
      DATA (NHEL(IHEL, 12),IHEL=1,6) / -1, -1,  1, -1,  1,  1/
      DATA (NHEL(IHEL, 13),IHEL=1,6) / -1, -1,  1,  1, -1, -1/
      DATA (NHEL(IHEL, 14),IHEL=1,6) / -1, -1,  1,  1, -1,  1/
      DATA (NHEL(IHEL, 15),IHEL=1,6) / -1, -1,  1,  1,  1, -1/
      DATA (NHEL(IHEL, 16),IHEL=1,6) / -1, -1,  1,  1,  1,  1/
      DATA (NHEL(IHEL, 17),IHEL=1,6) / -1,  1, -1, -1, -1, -1/
      DATA (NHEL(IHEL, 18),IHEL=1,6) / -1,  1, -1, -1, -1,  1/
      DATA (NHEL(IHEL, 19),IHEL=1,6) / -1,  1, -1, -1,  1, -1/
      DATA (NHEL(IHEL, 20),IHEL=1,6) / -1,  1, -1, -1,  1,  1/
      DATA (NHEL(IHEL, 21),IHEL=1,6) / -1,  1, -1,  1, -1, -1/
      DATA (NHEL(IHEL, 22),IHEL=1,6) / -1,  1, -1,  1, -1,  1/
      DATA (NHEL(IHEL, 23),IHEL=1,6) / -1,  1, -1,  1,  1, -1/
      DATA (NHEL(IHEL, 24),IHEL=1,6) / -1,  1, -1,  1,  1,  1/
      DATA (NHEL(IHEL, 25),IHEL=1,6) / -1,  1,  1, -1, -1, -1/
      DATA (NHEL(IHEL, 26),IHEL=1,6) / -1,  1,  1, -1, -1,  1/
      DATA (NHEL(IHEL, 27),IHEL=1,6) / -1,  1,  1, -1,  1, -1/
      DATA (NHEL(IHEL, 28),IHEL=1,6) / -1,  1,  1, -1,  1,  1/
      DATA (NHEL(IHEL, 29),IHEL=1,6) / -1,  1,  1,  1, -1, -1/
      DATA (NHEL(IHEL, 30),IHEL=1,6) / -1,  1,  1,  1, -1,  1/
      DATA (NHEL(IHEL, 31),IHEL=1,6) / -1,  1,  1,  1,  1, -1/
      DATA (NHEL(IHEL, 32),IHEL=1,6) / -1,  1,  1,  1,  1,  1/
      DATA (NHEL(IHEL, 33),IHEL=1,6) /  1, -1, -1, -1, -1, -1/
      DATA (NHEL(IHEL, 34),IHEL=1,6) /  1, -1, -1, -1, -1,  1/
      DATA (NHEL(IHEL, 35),IHEL=1,6) /  1, -1, -1, -1,  1, -1/
      DATA (NHEL(IHEL, 36),IHEL=1,6) /  1, -1, -1, -1,  1,  1/
      DATA (NHEL(IHEL, 37),IHEL=1,6) /  1, -1, -1,  1, -1, -1/
      DATA (NHEL(IHEL, 38),IHEL=1,6) /  1, -1, -1,  1, -1,  1/
      DATA (NHEL(IHEL, 39),IHEL=1,6) /  1, -1, -1,  1,  1, -1/
      DATA (NHEL(IHEL, 40),IHEL=1,6) /  1, -1, -1,  1,  1,  1/
      DATA (NHEL(IHEL, 41),IHEL=1,6) /  1, -1,  1, -1, -1, -1/
      DATA (NHEL(IHEL, 42),IHEL=1,6) /  1, -1,  1, -1, -1,  1/
      DATA (NHEL(IHEL, 43),IHEL=1,6) /  1, -1,  1, -1,  1, -1/
      DATA (NHEL(IHEL, 44),IHEL=1,6) /  1, -1,  1, -1,  1,  1/
      DATA (NHEL(IHEL, 45),IHEL=1,6) /  1, -1,  1,  1, -1, -1/
      DATA (NHEL(IHEL, 46),IHEL=1,6) /  1, -1,  1,  1, -1,  1/
      DATA (NHEL(IHEL, 47),IHEL=1,6) /  1, -1,  1,  1,  1, -1/
      DATA (NHEL(IHEL, 48),IHEL=1,6) /  1, -1,  1,  1,  1,  1/
      DATA (NHEL(IHEL, 49),IHEL=1,6) /  1,  1, -1, -1, -1, -1/
      DATA (NHEL(IHEL, 50),IHEL=1,6) /  1,  1, -1, -1, -1,  1/
      DATA (NHEL(IHEL, 51),IHEL=1,6) /  1,  1, -1, -1,  1, -1/
      DATA (NHEL(IHEL, 52),IHEL=1,6) /  1,  1, -1, -1,  1,  1/
      DATA (NHEL(IHEL, 53),IHEL=1,6) /  1,  1, -1,  1, -1, -1/
      DATA (NHEL(IHEL, 54),IHEL=1,6) /  1,  1, -1,  1, -1,  1/
      DATA (NHEL(IHEL, 55),IHEL=1,6) /  1,  1, -1,  1,  1, -1/
      DATA (NHEL(IHEL, 56),IHEL=1,6) /  1,  1, -1,  1,  1,  1/
      DATA (NHEL(IHEL, 57),IHEL=1,6) /  1,  1,  1, -1, -1, -1/
      DATA (NHEL(IHEL, 58),IHEL=1,6) /  1,  1,  1, -1, -1,  1/
      DATA (NHEL(IHEL, 59),IHEL=1,6) /  1,  1,  1, -1,  1, -1/
      DATA (NHEL(IHEL, 60),IHEL=1,6) /  1,  1,  1, -1,  1,  1/
      DATA (NHEL(IHEL, 61),IHEL=1,6) /  1,  1,  1,  1, -1, -1/
      DATA (NHEL(IHEL, 62),IHEL=1,6) /  1,  1,  1,  1, -1,  1/
      DATA (NHEL(IHEL, 63),IHEL=1,6) /  1,  1,  1,  1,  1, -1/
      DATA (NHEL(IHEL, 64),IHEL=1,6) /  1,  1,  1,  1,  1,  1/
C ----------
C BEGIN CODE
C ----------


C      SEENUNUGG = 0d0
C      NTRY=NTRY+1
C      DO IHEL=1,NCOMB
C          IF (GOODHEL(IHEL) .OR. NTRY .LT. 10) THEN
C             T=EENUNUGG(P1, P2, P3, P4, P5, P6,NHEL(1,IHEL))
C             SEENUNUGG = SEENUNUGG + T
C              IF (T .GT. 0D0 .AND. .NOT. GOODHEL(IHEL)) THEN
C                  GOODHEL(IHEL)=.TRUE.
C                  WRITE(*,*) IHEL,T
C              ENDIF
C          ENDIF
C      ENDDO
C      SEENUNUGG = SEENUNUGG /  4D0
C      END


      SEENUNUGG = 0d0
      T34=EENUNUGG(P1, P2, P3, P4, P5, P6,NHEL(1,34))
      T38=EENUNUGG(P1, P2, P3, P4, P5, P6,NHEL(1,38))
      T42=EENUNUGG(P1, P2, P3, P4, P5, P6,NHEL(1,42))
      T46=EENUNUGG(P1, P2, P3, P4, P5, P6,NHEL(1,46))
      SEENUNUGG = T34+T38+T42+T46
      SEENUNUGG = SEENUNUGG /  4D0
      END

      REAL*8 FUNCTION EENUNUGG(P1, P2, P3, P4, P5, P6,NHEL)
C
C FUNCTION GENERATED BY MADGRAPH
C RETURNS AMPLITUDE SQUARED SUMMED/AVG OVER COLORS
C FOR THE POINT IN PHASE SPACE P1,P2,P3,P4,...
C AND HELICITY NHEL(1),NHEL(2),....
C
C FOR PROCESS : e+ e-  -> a a ve ve~
C
      IMPLICIT NONE
C
C CONSTANTS
C
      INTEGER    NGRAPHS,    NEIGEN,    NEXTERNAL
      PARAMETER (NGRAPHS= 19,NEIGEN=  1,NEXTERNAL=6)
      REAL*8     ZERO
      PARAMETER (ZERO=0D0)
C
C ARGUMENTS
C
      REAL*8 P1(0:3),P2(0:3),P3(0:3),P4(0:3),P5(0:3),P6(0:3)
      INTEGER NHEL(NEXTERNAL)
C
C LOCAL VARIABLES
C
      INTEGER I,J
      REAL*8 EIGEN_VAL(NEIGEN), EIGEN_VEC(NGRAPHS,NEIGEN)
      COMPLEX*16 ZTEMP
      COMPLEX*16 AMP(NGRAPHS)
      COMPLEX*16 W1(6)  , W2(6)  , W3(6)  , W4(6)  , W5(6)
      COMPLEX*16 W6(6)  , W7(6)  , W8(6)  , W9(6)  , W10(6)
      COMPLEX*16 W11(6) , W12(6) , W13(6) , W14(6) , W15(6)
      COMPLEX*16 W16(6) , W17(6) , W18(6) , W19(6) , W20(6)
      COMPLEX*16 W21(6) , W22(6) , W23(6) , W24(6) , W25(6)
      COMPLEX*16 W26(6) , W27(6) , W28(6) , W29(6)
C
C GLOBAL VARIABLES
C
      REAL*8         GW, GWWA, GWWZ
      COMMON /COUP1/ GW, GWWA, GWWZ
      REAL*8         GAL(2),GAU(2),GAD(2),GWF(2)
      COMMON /COUP2A/GAL,   GAU,   GAD,   GWF
      REAL*8         GZN(2),GZL(2),GZU(2),GZD(2),G1(2)
      COMMON /COUP2B/GZN,   GZL,   GZU,   GZD,   G1
      REAL*8         GWWH,GZZH,GHHH,GWWHH,GZZHH,GHHHH
      COMMON /COUP3/ GWWH,GZZH,GHHH,GWWHH,GZZHH,GHHHH
      COMPLEX*16     GH(2,12)
      COMMON /COUP4/ GH
      REAL*8         WMASS,WWIDTH,ZMASS,ZWIDTH
      COMMON /VMASS1/WMASS,WWIDTH,ZMASS,ZWIDTH
      REAL*8         AMASS,AWIDTH,HMASS,HWIDTH
      COMMON /VMASS2/AMASS,AWIDTH,HMASS,HWIDTH
      REAL*8            FMASS(12), FWIDTH(12)
      COMMON /FERMIONS/ FMASS,     FWIDTH
      REAL*8          A0,AC,LAMBDA
      COMMON/ANOMALOUS/A0,AC,LAMBDA

C
C COLOR DATA
C
      DATA EIGEN_VAL(1  )/       9.5000000000000018D+00 /
      DATA EIGEN_VEC(1  ,1  )/  -2.2941573387056174D-01 /
      DATA EIGEN_VEC(2  ,1  )/  -2.2941573387056174D-01 /
      DATA EIGEN_VEC(3  ,1  )/  -2.2941573387056174D-01 /
      DATA EIGEN_VEC(4  ,1  )/  -2.2941573387056174D-01 /
      DATA EIGEN_VEC(5  ,1  )/  -2.2941573387056174D-01 /
      DATA EIGEN_VEC(6  ,1  )/  -2.2941573387056174D-01 /
      DATA EIGEN_VEC(7  ,1  )/  -2.2941573387056174D-01 /
      DATA EIGEN_VEC(8  ,1  )/  -2.2941573387056174D-01 /
      DATA EIGEN_VEC(9  ,1  )/  -2.2941573387056174D-01 /
      DATA EIGEN_VEC(10 ,1  )/  -2.2941573387056174D-01 /
      DATA EIGEN_VEC(11 ,1  )/  -2.2941573387056174D-01 /
      DATA EIGEN_VEC(12 ,1  )/  -2.2941573387056174D-01 /
      DATA EIGEN_VEC(13 ,1  )/  -2.2941573387056174D-01 /
      DATA EIGEN_VEC(14 ,1  )/  -2.2941573387056174D-01 /

C ----------
C BEGIN CODE
C ----------
      CALL OQXXXXX(P1  ,FMASS(1  ),NHEL(1  ),-1,W1  )
      CALL IQXXXXX(P2  ,FMASS(1  ),NHEL(2  ), 1,W2  )
      CALL VQXXXXX(P3  , ZERO,NHEL(3  ), 1,W3  )
      CALL VQXXXXX(P4  , ZERO,NHEL(4  ), 1,W4  )
      CALL OQXXXXX(P5  ,FMASS(2  ),NHEL(5  ), 1,W5  )
      CALL IQXXXXX(P6  ,FMASS(2  ),NHEL(6  ),-1,W6  )
      CALL FVIXXX(W2  ,W3  ,GAL,FMASS(1  ),FWIDTH(1  ),W7  )
      CALL FVIXXX(W7  ,W4  ,GAL,FMASS(1  ),FWIDTH(1  ),W8  )
      CALL JIOXXX(W8  ,W5  ,GWF,WMASS,WWIDTH,W9  )
      CALL IOVXXX(W6  ,W1  ,W9  ,GWF,AMP(1  ))
C      CALL JIOXXX(W8  ,W1  ,GZL,ZMASS,ZWIDTH,W10 )
C      CALL IOVXXX(W6  ,W5  ,W10 ,GZN,AMP(2  ))
      CALL JIOXXX(W2  ,W5  ,GWF,WMASS,WWIDTH,W11 )
      CALL JIOXXX(W6  ,W1  ,GWF,WMASS,WWIDTH,W12 )
      CALL JVVXXX(W11 ,W3  ,GWWA,WMASS,WWIDTH,W13 )
      CALL VVVXXX(W12 ,W13 ,W4  ,GWWA,AMP(2  ))
      CALL FVOXXX(W1  ,W4  ,GAL,FMASS(1  ),FWIDTH(1  ),W14 )
C      CALL JIOXXX(W6  ,W5  ,GZN,ZMASS,ZWIDTH,W15 )
      CALL FVOXXX(W14 ,W3  ,GAL,FMASS(1  ),FWIDTH(1  ),W16 )
C      CALL IOVXXX(W2  ,W16 ,W15 ,GZL,AMP(4  ))
      CALL JIOXXX(W6  ,W14 ,GWF,WMASS,WWIDTH,W17 )
      CALL VVVXXX(W17 ,W11 ,W3  ,GWWA,AMP(3  ))
      CALL FVIXXX(W6  ,W11 ,GWF,FMASS(1  ),FWIDTH(1  ),W18 )
      CALL IOVXXX(W18 ,W14 ,W3  ,GAL,AMP(4  ))
      CALL JIOXXX(W7  ,W5  ,GWF,WMASS,WWIDTH,W19 )
      CALL VVVXXX(W12 ,W19 ,W4  ,GWWA,AMP(5  ))
C      CALL JIOXXX(W7  ,W14 ,GZL,ZMASS,ZWIDTH,W20 )
C      CALL IOVXXX(W6  ,W5  ,W20 ,GZN,AMP(8  ))
      CALL IOVXXX(W6  ,W14 ,W19 ,GWF,AMP(6  ))
      CALL FVIXXX(W2  ,W4  ,GAL,FMASS(1  ),FWIDTH(1  ),W21 )
      CALL FVIXXX(W21 ,W3  ,GAL,FMASS(1  ),FWIDTH(1  ),W22 )
      CALL IOVXXX(W22 ,W5  ,W12 ,GWF,AMP(7 ))
C      CALL IOVXXX(W22 ,W1  ,W15 ,GZL,AMP(11 ))
      CALL JVVXXX(W3  ,W12 ,GWWA,WMASS,WWIDTH,W23 )
      CALL VVVXXX(W23 ,W11 ,W4  ,GWWA,AMP(8 ))
      CALL FVOXXX(W1  ,W3  ,GAL,FMASS(1  ),FWIDTH(1  ),W24 )
      CALL FVOXXX(W24 ,W4  ,GAL,FMASS(1  ),FWIDTH(1  ),W25 )
C      CALL JIOXXX(W2  ,W25 ,GZL,ZMASS,ZWIDTH,W26 )
C      CALL IOVXXX(W6  ,W5  ,W26 ,GZN,AMP(13 ))
      CALL JIOXXX(W6  ,W24 ,GWF,WMASS,WWIDTH,W27 )
      CALL VVVXXX(W27 ,W11 ,W4  ,GWWA,AMP(9 ))
      CALL IOVXXX(W6  ,W25 ,W11 ,GWF,AMP(10 ))
      CALL JIOXXX(W21 ,W5  ,GWF,WMASS,WWIDTH,W28 )
      CALL VVVXXX(W12 ,W28 ,W3  ,GWWA,AMP(11 ))
C      CALL JIOXXX(W21 ,W24 ,GZL,ZMASS,ZWIDTH,W29 )
C      CALL IOVXXX(W6  ,W5  ,W29 ,GZN,AMP(17 ))
      CALL IOVXXX(W6  ,W24 ,W28 ,GWF,AMP(12 ))
      CALL W3W3XX(W12,W3,W11,W4,GWWA,GWWA,WMASS,WWIDTH,AMP(13))
      CALL ANOXXX(W12 ,W3  ,W11 ,W4  ,P3,P4,GWWA,GWWA,WMASS,
     .                    WWIDTH,A0,AC,LAMBDA,AMP(14 ))




      EENUNUGG = 0.D0
      DO I = 1, NEIGEN
          ZTEMP = (0.D0,0.D0)
          DO J = 1, 14
              ZTEMP = ZTEMP + EIGEN_VEC(J,I)*AMP(J)
          ENDDO

          EENUNUGG =EENUNUGG+ZTEMP*EIGEN_VAL(I)*CONJG(ZTEMP)

      ENDDO
C      CALL GAUGECHECK(AMP,ZTEMP,EIGEN_VEC,EIGEN_VAL,NGRAPHS,NEIGEN)
      END
      subroutine jvvxxx(v1,v2,g,vmass,vwidth , jvv)
c
c this subroutine computes an off-shell vector current from the three-
c point gauge boson coupling.  the vector propagator is given in feynman
c gauge for a massless vector and in unitary gauge for a massive vector.
c
c input:
c       complex v1(6)          : first  vector                        v1
c       complex v2(6)          : second vector                        v2
c       real    g              : coupling constant (see the table below)
c       real    vmass          : mass  of output vector v
c       real    vwidth         : width of output vector v
c
c the possible sets of the inputs are as follows:
c    ------------------------------------------------------------------
c    |   v1   |   v2   |  jvv   |      g       |   vmass  |  vwidth   |
c    ------------------------------------------------------------------
c    |   w-   |   w+   |  a/z   |  gwwa/gwwz   | 0./zmass | 0./zwidth |
c    | w3/a/z |   w-   |  w+    | gw/gwwa/gwwz |   wmass  |  wwidth   |
c    |   w+   | w3/a/z |  w-    | gw/gwwa/gwwz |   wmass  |  wwidth   |
c    ------------------------------------------------------------------
c where all the bosons are defined by the flowing-out quantum number.
c
c output:
c       complex jvv(6)         : vector current            j^mu(v:v1,v2)
c
      complex*16 v1(6),v2(6),jvv(6),j12(0:3),js,dg,
     &        sv1,sv2,s11,s12,s21,s22,v12
      real*8 p1(0:3),p2(0:3),q(0:3),g,vmass,vwidth,gs,s,vm2,m1,m2
c
      real*8 r_zero
      parameter( r_zero=0.0d0 )
c
      jvv(5) = v1(5)+v2(5)
      jvv(6) = v1(6)+v2(6)
c
      p1(0)=dble( v1(5))
      p1(1)=dble( v1(6))
      p1(2)=dimag(v1(6))
      p1(3)=dimag(v1(5))
      p2(0)=dble( v2(5))
      p2(1)=dble( v2(6))
      p2(2)=dimag(v2(6))
      p2(3)=dimag(v2(5))
      q(0)=-dble( jvv(5))
      q(1)=-dble( jvv(6))
      q(2)=-dimag(jvv(6))
      q(3)=-dimag(jvv(5))
      s=q(0)**2-(q(1)**2+q(2)**2+q(3)**2)
c
      v12=v1(1)*v2(1)-v1(2)*v2(2)-v1(3)*v2(3)-v1(4)*v2(4)
      sv1= (p2(0)-q(0))*v1(1) -(p2(1)-q(1))*v1(2)
     &    -(p2(2)-q(2))*v1(3) -(p2(3)-q(3))*v1(4)
      sv2=-(p1(0)-q(0))*v2(1) +(p1(1)-q(1))*v2(2)
     &    +(p1(2)-q(2))*v2(3) +(p1(3)-q(3))*v2(4)
      j12(0)=(p1(0)-p2(0))*v12 +sv1*v2(1) +sv2*v1(1)
      j12(1)=(p1(1)-p2(1))*v12 +sv1*v2(2) +sv2*v1(2)
      j12(2)=(p1(2)-p2(2))*v12 +sv1*v2(3) +sv2*v1(3)
      j12(3)=(p1(3)-p2(3))*v12 +sv1*v2(4) +sv2*v1(4)
c
      if ( vmass .ne. r_zero ) then
         vm2=vmass**2
         m1=p1(0)**2-(p1(1)**2+p1(2)**2+p1(3)**2)
         m2=p2(0)**2-(p2(1)**2+p2(2)**2+p2(3)**2)
         s11=p1(0)*v1(1)-p1(1)*v1(2)-p1(2)*v1(3)-p1(3)*v1(4)
         s12=p1(0)*v2(1)-p1(1)*v2(2)-p1(2)*v2(3)-p1(3)*v2(4)
         s21=p2(0)*v1(1)-p2(1)*v1(2)-p2(2)*v1(3)-p2(3)*v1(4)
         s22=p2(0)*v2(1)-p2(1)*v2(2)-p2(2)*v2(3)-p2(3)*v2(4)
         js=(v12*(-m1+m2) +s11*s12 -s21*s22)/vm2
c
         dg=-g/dcmplx( s-vm2 , max(sign( vmass*vwidth ,s),r_zero) )
c
c  for the running width, use below instead of the above dg.
c         dg=-g/dcmplx( s-vm2 , max( vwidth*s/vmass ,r_zero) )
c
         jvv(1) = dg*(j12(0)-q(0)*js)
         jvv(2) = dg*(j12(1)-q(1)*js)
         jvv(3) = dg*(j12(2)-q(2)*js)
         jvv(4) = dg*(j12(3)-q(3)*js)
c
      else
         gs=-g/s
c
         jvv(1) = gs*j12(0)
         jvv(2) = gs*j12(1)
         jvv(3) = gs*j12(2)
         jvv(4) = gs*j12(3)
      end if
c
      return
      end
c
c ======================================================================
c
      subroutine w3w3xx(wm,w31,wp,w32,g31,g32,wmass,wwidth,vertex)
c
c this subroutine computes an amplitude of the four-point coupling of
c the w-, w+ and two w3/z/a.  the amplitude includes the contributions
c of w exchange diagrams.  the internal w propagator is given in unitary
c gauge.  if one sets wmass=0.0, then the gggg vertex is given (see sect
c 2.9.1 of the manual).
c
c input:
c       complex wm(0:3)        : flow-out w-                         wm
c       complex w31(0:3)       : first    w3/z/a                     w31
c       complex wp(0:3)        : flow-out w+                         wp
c       complex w32(0:3)       : second   w3/z/a                     w32
c       real    g31            : coupling of w31 with w-/w+
c       real    g32            : coupling of w32 with w-/w+
c                                                  (see the table below)
c       real    wmass          : mass  of w
c       real    wwidth         : width of w
c
c the possible sets of the inputs are as follows:
c   -------------------------------------------
c   |  wm  |  w31 |  wp  |  w32 |  g31 |  g32 |
c   -------------------------------------------
c   |  w-  |  w3  |  w+  |  w3  |  gw  |  gw  |
c   |  w-  |  w3  |  w+  |  z   |  gw  | gwwz |
c   |  w-  |  w3  |  w+  |  a   |  gw  | gwwa |
c   |  w-  |  z   |  w+  |  z   | gwwz | gwwz |
c   |  w-  |  z   |  w+  |  a   | gwwz | gwwa |
c   |  w-  |  a   |  w+  |  a   | gwwa | gwwa |
c   -------------------------------------------
c where all the bosons are defined by the flowing-out quantum number.
c
c output:
c       complex vertex         : amplitude          gamma(wm,w31,wp,w32)
c
      complex*16    wm(6),w31(6),wp(6),w32(6),vertex
      complex*16 dv1(0:3),dv2(0:3),dv3(0:3),dv4(0:3),dvertx,
     &           v12,v13,v14,v23,v24,v34
      real*8     g31,g32,wmass,wwidth
c
      real*8 r_zero, r_one
      parameter( r_zero=0.0d0, r_one=1.0d0 )

      dv1(0)=dcmplx(wm(1))
      dv1(1)=dcmplx(wm(2))
      dv1(2)=dcmplx(wm(3))
      dv1(3)=dcmplx(wm(4))
      dv2(0)=dcmplx(w31(1))
      dv2(1)=dcmplx(w31(2))
      dv2(2)=dcmplx(w31(3))
      dv2(3)=dcmplx(w31(4))
      dv3(0)=dcmplx(wp(1))
      dv3(1)=dcmplx(wp(2))
      dv3(2)=dcmplx(wp(3))
      dv3(3)=dcmplx(wp(4))
      dv4(0)=dcmplx(w32(1))
      dv4(1)=dcmplx(w32(2))
      dv4(2)=dcmplx(w32(3))
      dv4(3)=dcmplx(w32(4))
c
      if ( dble(wmass) .ne. r_zero ) then
c         dm2inv = r_one / dmw2
c
         v12= dv1(0)*dv2(0)-dv1(1)*dv2(1)-dv1(2)*dv2(2)-dv1(3)*dv2(3)
         v13= dv1(0)*dv3(0)-dv1(1)*dv3(1)-dv1(2)*dv3(2)-dv1(3)*dv3(3)
         v14= dv1(0)*dv4(0)-dv1(1)*dv4(1)-dv1(2)*dv4(2)-dv1(3)*dv4(3)
         v23= dv2(0)*dv3(0)-dv2(1)*dv3(1)-dv2(2)*dv3(2)-dv2(3)*dv3(3)
         v24= dv2(0)*dv4(0)-dv2(1)*dv4(1)-dv2(2)*dv4(2)-dv2(3)*dv4(3)
         v34= dv3(0)*dv4(0)-dv3(1)*dv4(1)-dv3(2)*dv4(2)-dv3(3)*dv4(3)
c
         dvertx = v12*v34 +v14*v23 -2.d0*v13*v24
c
         vertex = dcmplx( dvertx ) * (g31*g32)
c
      else
         v12= dv1(0)*dv2(0)-dv1(1)*dv2(1)-dv1(2)*dv2(2)-dv1(3)*dv2(3)
         v13= dv1(0)*dv3(0)-dv1(1)*dv3(1)-dv1(2)*dv3(2)-dv1(3)*dv3(3)
         v14= dv1(0)*dv4(0)-dv1(1)*dv4(1)-dv1(2)*dv4(2)-dv1(3)*dv4(3)
         v23= dv2(0)*dv3(0)-dv2(1)*dv3(1)-dv2(2)*dv3(2)-dv2(3)*dv3(3)
         v24= dv2(0)*dv4(0)-dv2(1)*dv4(1)-dv2(2)*dv4(2)-dv2(3)*dv4(3)
         v34= dv3(0)*dv4(0)-dv3(1)*dv4(1)-dv3(2)*dv4(2)-dv3(3)*dv4(3)
c

         dvertx = v14*v23 -v13*v24
c
         vertex = dcmplx( dvertx ) * (g31*g32)
      end if
c
      return
      end
c
c ----------------------------------------------------------------------
c
      subroutine anoxxx(wm,w31,wp,w32,PR31,PR32,g31,g32,
     .                  wmass,wwidth,ano0,anoc,scale,vertex)
c

      complex*16    wm(6),w31(6),wp(6),w32(6),vertex
      complex*16 dv1(0:3),dv2(0:3),dv3(0:3),dv4(0:3),dv5(0:3),dv6(0:3),
     .   dvertx,v12,v13,v14,v15,v16,v23,v24,v25,v26,v34,v35,v36,
     .           v45,v46,v56
      real*8     g31,g32,wmass,wwidth,ano0,anoc,scale,pr31(4),pr32(4)
c

      DATA PI/3.14159265358979323846D0/


      dv1(0)=dcmplx(wm(1))
      dv1(1)=dcmplx(wm(2))
      dv1(2)=dcmplx(wm(3))
      dv1(3)=dcmplx(wm(4))
      dv2(0)=dcmplx(w31(1))
      dv2(1)=dcmplx(w31(2))
      dv2(2)=dcmplx(w31(3))
      dv2(3)=dcmplx(w31(4))
      dv3(0)=dcmplx(wp(1))
      dv3(1)=dcmplx(wp(2))
      dv3(2)=dcmplx(wp(3))
      dv3(3)=dcmplx(wp(4))
      dv4(0)=dcmplx(w32(1))
      dv4(1)=dcmplx(w32(2))
      dv4(2)=dcmplx(w32(3))
      dv4(3)=dcmplx(w32(4))
      dv5(0)=dcmplx(PR31(1),0D0)
      dv5(1)=dcmplx(PR31(2),0D0)
      dv5(2)=dcmplx(PR31(3),0D0)
      dv5(3)=dcmplx(PR31(4),0D0)
      dv6(0)=dcmplx(PR32(1),0D0)
      dv6(1)=dcmplx(PR32(2),0D0)
      dv6(2)=dcmplx(PR32(3),0D0)
      dv6(3)=dcmplx(PR32(4),0D0)


c

c
      v12= dv1(0)*dv2(0)-dv1(1)*dv2(1)-dv1(2)*dv2(2)-dv1(3)*dv2(3)
      v13= dv1(0)*dv3(0)-dv1(1)*dv3(1)-dv1(2)*dv3(2)-dv1(3)*dv3(3)
      v14= dv1(0)*dv4(0)-dv1(1)*dv4(1)-dv1(2)*dv4(2)-dv1(3)*dv4(3)
      v15= dv1(0)*dv5(0)-dv1(1)*dv5(1)-dv1(2)*dv5(2)-dv1(3)*dv5(3)
      v16= dv1(0)*dv6(0)-dv1(1)*dv6(1)-dv1(2)*dv6(2)-dv1(3)*dv6(3)
      v23= dv2(0)*dv3(0)-dv2(1)*dv3(1)-dv2(2)*dv3(2)-dv2(3)*dv3(3)
      v24= dv2(0)*dv4(0)-dv2(1)*dv4(1)-dv2(2)*dv4(2)-dv2(3)*dv4(3)
      v25= dv2(0)*dv5(0)-dv2(1)*dv5(1)-dv2(2)*dv5(2)-dv2(3)*dv5(3)
      v26= dv2(0)*dv6(0)-dv2(1)*dv6(1)-dv2(2)*dv6(2)-dv2(3)*dv6(3)
      v34= dv3(0)*dv4(0)-dv3(1)*dv4(1)-dv3(2)*dv4(2)-dv3(3)*dv4(3)
      v35= dv3(0)*dv5(0)-dv3(1)*dv5(1)-dv3(2)*dv5(2)-dv3(3)*dv5(3)
      v36= dv3(0)*dv6(0)-dv3(1)*dv6(1)-dv3(2)*dv6(2)-dv3(3)*dv6(3)
      v45= dv4(0)*dv5(0)-dv4(1)*dv5(1)-dv4(2)*dv5(2)-dv4(3)*dv5(3)
      v46= dv4(0)*dv6(0)-dv4(1)*dv6(1)-dv4(2)*dv6(2)-dv4(3)*dv6(3)
      v56= dv5(0)*dv6(0)-dv5(1)*dv6(1)-dv5(2)*dv6(2)-dv5(3)*dv6(3)
c
      dvertx = 1/(2D0*scale**2)*(ano0*(v13*(v56*v24-v45*v26))
     .      +anoc/4*(v56*(v23*v14+v12*v34)-v45*(v16*v23+v36*v12)
     .              -v26*(v35*v14+v15*v34)+v24*(v35*v16+v15*v36)))

c
      vertex = dcmplx( dvertx ) * (g31*g32)
c


c
      return
      end
      SUBROUTINE RAMBOI(N,ET,XM,P,WT)
C------------------------------------------------------
C
C                       RAMBO
C
C    RA(NDOM)  M(OMENTA)  B(EAUTIFULLY)  O(RGANIZED)
C
C    A DEMOCRATIC MULTI-PARTICLE PHASE SPACE GENERATOR
C    AUTHORS:  S.D. ELLIS,  R. KLEISS,  W.J. STIRLING
C    THIS IS VERSION 1.0 -  WRITTEN BY R. KLEISS
C
C    N  = NUMBER OF PARTICLES (>1, IN THIS VERSION <101)
C    ET = TOTAL CENTRE-OF-MASS ENERGY
C    XM = PARTICLE MASSES ( DIM=100 )
C    P  = PARTICLE MOMENTA ( DIM=(4,100) )
C    WT = WEIGHT OF THE EVENT
C
C------------------------------------------------------
      IMPLICIT REAL*8(A-H,O-Z)
      DIMENSION XM(100),P(4,100),Q(4,100),Z(100),R(4),
     .   B(3),P2(100),XM2(100),E(100),V(100),IWARN(5)
      DATA ACC/1.D-14/,ITMAX/8/,IBEGIN/0/,IWARN/5*0/
      SAVE
C
C INITIALIZATION STEP: FACTORIALS FOR THE PHASE SPACE WEIGHT
      IF(IBEGIN.NE.0) GOTO 103
      IBEGIN=1
      TWOPI=8.*DATAN(1.D0)
      PO2LOG=DLOG(TWOPI/4.)
      Z(2)=PO2LOG
      DO 101 K=3,100
  101 Z(K)=Z(K-1)+PO2LOG-2.*DLOG(DFLOAT(K-2))
      DO 102 K=3,100
  102 Z(K)=(Z(K)-DLOG(DFLOAT(K-1)))
C
C CHECK ON THE NUMBER OF PARTICLES
  103 IF(N.GT.1.AND.N.LT.101) GOTO 104
      PRINT 1001,N
      STOP
C
C CHECK WHETHER TOTAL ENERGY IS SUFFICIENT; COUNT NONZERO MASSES
  104 XMT=0.
      NM=0
      DO 105 I=1,N
      IF(XM(I).NE.0.D0) NM=NM+1
  105 XMT=XMT+DABS(XM(I))
      IF(XMT.LE.ET) GOTO 201
      PRINT 1002,XMT,ET
      STOP
C
C THE PARAMETER VALUES ARE NOW ACCEPTED
C
C GENERATE N MASSLESS MOMENTA IN INFINITE PHASE SPACE
  201 DO 202 I=1,N
      C=2.*RN(1)-1.
      S=DSQRT(1.-C*C)
      F=TWOPI*RN(2)
      Q(4,I)=-DLOG(RN(3)*RN(4))
      Q(3,I)=Q(4,I)*C
      Q(2,I)=Q(4,I)*S*DCOS(F)
  202 Q(1,I)=Q(4,I)*S*DSIN(F)
C
C CALCULATE THE PARAMETERS OF THE CONFORMAL TRANSFORMATION
      DO 203 I=1,4
  203 R(I)=0.
      DO 204 I=1,N
      DO 204 K=1,4
  204 R(K)=R(K)+Q(K,I)
      RMAS=DSQRT(R(4)**2-R(3)**2-R(2)**2-R(1)**2)
      DO 205 K=1,3
  205 B(K)=-R(K)/RMAS
      G=R(4)/RMAS
      A=1./(1.+G)
      X=ET/RMAS
C
C TRANSFORM THE Q'S CONFORMALLY INTO THE P'S
      DO 207 I=1,N
      BQ=B(1)*Q(1,I)+B(2)*Q(2,I)+B(3)*Q(3,I)
      DO 206 K=1,3
  206 P(K,I)=X*(Q(K,I)+B(K)*(Q(4,I)+A*BQ))
  207 P(4,I)=X*(G*Q(4,I)+BQ)
C
C CALCULATE WEIGHT AND POSSIBLE WARNINGS
      WT=PO2LOG
      IF(N.NE.2) WT=(2.*N-4.)*DLOG(ET)+Z(N)
      IF(WT.GE.-180.D0) GOTO 208
      IF(IWARN(1).LE.5) PRINT 1004,WT
      IWARN(1)=IWARN(1)+1
  208 IF(WT.LE. 174.D0) GOTO 209
      IF(IWARN(2).LE.5) PRINT 1005,WT
      IWARN(2)=IWARN(2)+1
C
C RETURN FOR WEIGHTED MASSLESS MOMENTA
  209 IF(NM.NE.0) GOTO 210
      WT=DEXP(WT)
      RETURN
C
C MASSIVE PARTICLES: RESCALE THE MOMENTA BY A FACTOR X
  210 XMAX=DSQRT(1.-(XMT/ET)**2)
      DO 301 I=1,N
      XM2(I)=XM(I)**2
  301 P2(I)=P(4,I)**2
      ITER=0
      X=XMAX
      ACCU=ET*ACC
  302 F0=-ET
      G0=0.
      X2=X*X
      DO 303 I=1,N
      E(I)=DSQRT(XM2(I)+X2*P2(I))
      F0=F0+E(I)
  303 G0=G0+P2(I)/E(I)
      IF(DABS(F0).LE.ACCU) GOTO 305
      ITER=ITER+1
      IF(ITER.LE.ITMAX) GOTO 304
      PRINT 1006,ITMAX
      GOTO 305
  304 X=X-F0/(X*G0)
      GOTO 302
  305 DO 307 I=1,N
      V(I)=X*P(4,I)
      DO 306 K=1,3
  306 P(K,I)=X*P(K,I)
  307 P(4,I)=E(I)
C
C CALCULATE THE MASS-EFFECT WEIGHT FACTOR
      WT2=1.
      WT3=0.
      DO 308 I=1,N
      WT2=WT2*V(I)/E(I)
  308 WT3=WT3+V(I)**2/E(I)
      WTM=(2.*N-3.)*DLOG(X)+DLOG(WT2/WT3*ET)
C
C RETURN FOR  WEIGHTED MASSIVE MOMENTA
      WT=WT+WTM
      IF(WT.GE.-180.D0) GOTO 309
      IF(IWARN(3).LE.5) PRINT 1004,WT
      IWARN(3)=IWARN(3)+1
  309 IF(WT.LE. 174.D0) GOTO 310
      IF(IWARN(4).LE.5) PRINT 1005,WT
      IWARN(4)=IWARN(4)+1
  310 WT=DEXP(WT)
      RETURN
C
 1001 FORMAT(' RAMBO FAILS: # OF PARTICLES =',I5,' IS NOT ALLOWED')
 1002 FORMAT(' RAMBO FAILS: TOTAL MASS =',D15.6,' IS NOT',
     . ' SMALLER THAN TOTAL ENERGY =',D15.6)
 1004 FORMAT(' RAMBO WARNS: WEIGHT = EXP(',F20.9,') MAY UNDERFLOW')
 1005 FORMAT(' RAMBO WARNS: WEIGHT = EXP(',F20.9,') MAY  OVERFLOW')
 1006 FORMAT(' RAMBO WARNS:',I3,' ITERATIONS DID NOT GIVE THE',
     . ' DESIRED ACCURACY =',D15.6)
      END
      SUBROUTINE CREKWTKN
C --------------------------------------------------------------------
C Create the bank of event weights 'KWTQ'
C and put it on the event list bank
C                                J. Boucrot 02 April 1997
C--------------------------------------------------------------------
C     input     : none
C
C     output    : bank 'KWTQ' with 1 row containing the
C                 6 event weights for QGCs
C--------------------------------------------------------------------
      INTEGER LMHLEN, LMHCOL, LMHROW  ,LBCS
      PARAMETER (LMHLEN=2, LMHCOL=1, LMHROW=2, LBCS=1000)
C
      COMMON /BCS/   IW(LBCS )
      INTEGER IW
      REAL RW(LBCS)
      EQUIVALENCE (RW(1),IW(1))
C
      DATA EPSIL / 0.01 /
      common / wtqgc / wt
      real*8 wt(6)
      real weigh(6)
C--------------------------------------------------------------------
      NWEIG=6
      DO 10 I=1,NWEIG
         WEIGH(I)=SNGL(WT(I))
 10   CONTINUE
      IF (WEIGH(1).LT.EPSIL) GO TO 999
       ind = KWTKBK(2,weigh)
 999  RETURN
      END
c       Subroutine returns the desired fermion or
c       anti-fermion anti-spinor. ie., <f|
c       A replacement for the HELAS routine OQXXXXX
c
c       Adam Duff,  1992 August 31
c       <duff@phenom.physics.wisc.edu>
c
      subroutine oqxxxxx(
     &              p,          !in: four vector momentum
     &              fmass,      !in: fermion mass
     &              nhel,       !in: anti-spinor helicity, -1 or 1
     &              nsf,        !in: -1=antifermion, 1=fermion
     &              fo          !out: fermion wavefunction
     &                 )
      implicit none
c
c declare input/output variables
c
      complex*16 fo(6)
      integer*4 nhel, nsf
      real*8 p(0:3), fmass
c
c declare local variables
c
      real*8 r_zero, r_one, r_two
      parameter( r_zero=0.0d0, r_one=1.0d0, r_two=2.0d0 )
      complex*16 c_zero
cccccc      parameter( c_zero=dcmplx( r_zero, r_zero ) )
c
      real*8 plat, pabs, omegap, omegam, rs2pa, spaz
c
c define kinematic parameters
c
      c_zero=dcmplx( r_zero, r_zero ) 
      fo(5) = dcmplx( p(0), p(3) ) * nsf
      fo(6) = dcmplx( p(1), p(2) ) * nsf
      plat = sqrt( p(1)**2 + p(2)**2 )
      pabs = sqrt( p(1)**2 + p(2)**2 + p(3)**2 )
      omegap = sqrt( p(0) + pabs )
c
c do massive fermion case
c
      if ( fmass .ne. r_zero ) then
         omegam = fmass / omegap
         if ( nsf .eq. 1 ) then
            if ( nhel .eq. 1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fo(1) = dcmplx( omegap, r_zero )
                     fo(2) = c_zero
                     fo(3) = dcmplx( omegam, r_zero )
                     fo(4) = c_zero
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs + p(3) )
                     fo(1) = omegap * rs2pa
     &                     * dcmplx( spaz, r_zero )
                     fo(2) = omegap * rs2pa / spaz
     &                     * dcmplx( p(1), -p(2) )
                     fo(3) = omegam * rs2pa
     &                     * dcmplx( spaz, r_zero )
                     fo(4) = omegam * rs2pa / spaz
     &                     * dcmplx( p(1), -p(2) )
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fo(1) = c_zero
                     fo(2) = dcmplx( omegap, r_zero )
                     fo(3) = c_zero
                     fo(4) = dcmplx( omegam, r_zero )
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs - p(3) )
                     fo(1) = omegap * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                     fo(2) = omegap * rs2pa * spaz / plat
     &                     * dcmplx( p(1), -p(2) )
                     fo(3) = omegam * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                     fo(4) = omegam * rs2pa * spaz / plat
     &                     * dcmplx( p(1), -p(2) )
                  end if
               end if
            else if ( nhel .eq. -1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fo(1) = c_zero
                     fo(2) = dcmplx( omegam, r_zero )
                     fo(3) = c_zero
                     fo(4) = dcmplx( omegap, r_zero )
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs + p(3) )
                     fo(1) = omegam * rs2pa / spaz
     &                     * dcmplx( -p(1), -p(2) )
                     fo(2) = omegam * rs2pa
     &                     * dcmplx( spaz, r_zero )
                     fo(3) = omegap * rs2pa / spaz
     &                     * dcmplx( -p(1), -p(2) )
                     fo(4) = omegap * rs2pa
     &                     * dcmplx( spaz, r_zero )
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fo(1) = dcmplx( -omegam, r_zero )
                     fo(2) = c_zero
                     fo(3) = dcmplx( -omegap, r_zero )
                     fo(4) = c_zero
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs - p(3) )
                     fo(1) = omegam * rs2pa * spaz / plat
     &                     * dcmplx( -p(1), -p(2) )
                     fo(2) = omegam * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                     fo(3) = omegap * rs2pa * spaz / plat
     &                     * dcmplx( -p(1), -p(2) )
                     fo(4) = omegap * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                  end if
               end if
            else
               stop 'oqxxxxx:  fermion helicity must be +1,-1'
            end if
         else if ( nsf .eq. -1 ) then
            if ( nhel .eq. 1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fo(1) = c_zero
                     fo(2) = dcmplx( omegam, r_zero )
                     fo(3) = c_zero
                     fo(4) = dcmplx( -omegap, r_zero )
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs + p(3) )
                     fo(1) = omegam * rs2pa / spaz
     &                     * dcmplx( -p(1), -p(2) )
                     fo(2) = omegam * rs2pa
     &                     * dcmplx( spaz, r_zero )
                     fo(3) = -omegap * rs2pa / spaz
     &                     * dcmplx( -p(1), -p(2) )
                     fo(4) = -omegap * rs2pa
     &                     * dcmplx( spaz, r_zero )
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fo(1) = dcmplx( -omegam, r_zero )
                     fo(2) = c_zero
                     fo(3) = dcmplx( omegap, r_zero )
                     fo(4) = c_zero
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs - p(3) )
                     fo(1) = omegam * rs2pa * spaz / plat
     &                     * dcmplx( -p(1), -p(2) )
                     fo(2) = omegam * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                     fo(3) = -omegap * rs2pa * spaz / plat
     &                     * dcmplx( -p(1), -p(2) )
                     fo(4) = -omegap * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                  end if
               end if
            else if ( nhel .eq. -1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fo(1) = dcmplx( -omegap, r_zero )
                     fo(2) = c_zero
                     fo(3) = dcmplx( omegam, r_zero )
                     fo(4) = c_zero
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs + p(3) )
                     fo(1) = -omegap * rs2pa
     &                     * dcmplx( spaz, r_zero )
                     fo(2) = -omegap * rs2pa / spaz
     &                     * dcmplx( p(1), -p(2) )
                     fo(3) = omegam * rs2pa
     &                     * dcmplx( spaz, r_zero )
                     fo(4) = omegam * rs2pa / spaz
     &                     * dcmplx( p(1), -p(2) )
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fo(1) = c_zero
                     fo(2) = dcmplx( -omegap, r_zero )
                     fo(3) = c_zero
                     fo(4) = dcmplx( omegam, r_zero )
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs - p(3) )
                     fo(1) = -omegap * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                     fo(2) = -omegap * rs2pa * spaz / plat
     &                     * dcmplx( p(1), -p(2) )
                     fo(3) = omegam * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                     fo(4) = omegam * rs2pa * spaz / plat
     &                     * dcmplx( p(1), -p(2) )
                  end if
               end if
            else
               stop 'oqxxxxx:  fermion helicity must be +1,-1'
            end if
         else
            stop 'oqxxxxx:  fermion type must be +1,-1'
         end if
c
c do massless case
c
      else
         if ( nsf .eq. 1 ) then
            if ( nhel .eq. 1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fo(1) = dcmplx( omegap, r_zero )
                     fo(2) = c_zero
                     fo(3) = c_zero
                     fo(4) = c_zero
                  else
                     spaz = sqrt( pabs + p(3) )
                     fo(1) = dcmplx( spaz, r_zero )
                     fo(2) = r_one / spaz
     &                     * dcmplx( p(1), -p(2) )
                     fo(3) = c_zero
                     fo(4) = c_zero
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fo(1) = c_zero
                     fo(2) = dcmplx( omegap, r_zero )
                     fo(3) = c_zero
                     fo(4) = c_zero
                  else
                     spaz = sqrt( pabs - p(3) )
                     fo(1) = r_one / spaz
     &                     * dcmplx( plat, r_zero )
                     fo(2) = spaz / plat
     &                     * dcmplx( p(1), -p(2) )
                     fo(3) = c_zero
                     fo(4) = c_zero
                  end if
               end if
            else if ( nhel .eq. -1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fo(1) = c_zero
                     fo(2) = c_zero
                     fo(3) = c_zero
                     fo(4) = dcmplx( omegap, r_zero )
                  else
                     spaz = sqrt( pabs + p(3) )
                     fo(1) = c_zero
                     fo(2) = c_zero
                     fo(3) = r_one / spaz
     &                     * dcmplx( -p(1), -p(2) )
                     fo(4) = dcmplx( spaz, r_zero )
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fo(1) = c_zero
                     fo(2) = c_zero
                     fo(3) = dcmplx( -omegap, r_zero )
                     fo(4) = c_zero
                  else
                     spaz = sqrt( pabs - p(3) )
                     fo(1) = c_zero
                     fo(2) = c_zero
                     fo(3) = spaz / plat
     &                     * dcmplx( -p(1), -p(2) )
                     fo(4) = r_one / spaz
     &                     * dcmplx( plat, r_zero )
                  end if
               end if
            else
               stop 'oqxxxxx:  fermion helicity must be +1,-1'
            end if
         else if ( nsf .eq. -1 ) then
            if ( nhel .eq. 1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fo(1) = c_zero
                     fo(2) = c_zero
                     fo(3) = c_zero
                     fo(4) = dcmplx( -omegap, r_zero )
                  else
                     spaz = sqrt( pabs + p(3) )
                     fo(1) = c_zero
                     fo(2) = c_zero
                     fo(3) = -r_one / spaz
     &                     * dcmplx( -p(1), -p(2) )
                     fo(4) = dcmplx( -spaz, r_zero )
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fo(1) = c_zero
                     fo(2) = c_zero
                     fo(3) = dcmplx( omegap, r_zero )
                     fo(4) = c_zero
                  else
                     spaz = sqrt( pabs - p(3) )
                     fo(1) = c_zero
                     fo(2) = c_zero
                     fo(3) = -spaz / plat
     &                     * dcmplx( -p(1), -p(2) )
                     fo(4) = -r_one / spaz
     &                     * dcmplx( plat, r_zero )
                  end if
               end if
            else if ( nhel .eq. -1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fo(1) = dcmplx( -omegap, r_zero )
                     fo(2) = c_zero
                     fo(3) = c_zero
                     fo(4) = c_zero
                  else
                     spaz = sqrt( pabs + p(3) )
                     fo(1) = dcmplx( -spaz, r_zero )
                     fo(2) = -r_one / spaz
     &                     * dcmplx( p(1), -p(2) )
                     fo(3) = c_zero
                     fo(4) = c_zero
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fo(1) = c_zero
                     fo(2) = dcmplx( -omegap, r_zero )
                     fo(3) = c_zero
                     fo(4) = c_zero
                  else
                     spaz = sqrt( pabs - p(3) )
                     fo(1) = -r_one / spaz
     &                     * dcmplx( plat, r_zero )
                     fo(2) = -spaz / plat
     &                     * dcmplx( p(1), -p(2) )
                     fo(3) = c_zero
                     fo(4) = c_zero
                  end if
               end if
            else
               stop 'oqxxxxx:  fermion helicity must be +1,-1'
            end if
         else
            stop 'oqxxxxx:  fermion type must be +1,-1'
         end if
      end if
c
c done
c
      return
      end



c
c       Subroutine returns the desired fermion or
c       anti-fermion spinor. ie., |f>
c       A replacement for the HELAS routine IQXXXXX
c
c       Adam Duff,  1992 August 31
c       <duff@phenom.physics.wisc.edu>
c
      subroutine iqxxxxx(
     &              p,          !in: four vector momentum
     &              fmass,      !in: fermion mass
     &              nhel,       !in: spinor helicity, -1 or 1
     &              nsf,        !in: -1=antifermion, 1=fermion
     &              fi          !out: fermion wavefunction
     &                 )
      implicit none
c
c declare input/output variables
c
      complex*16 fi(6)
      integer*4 nhel, nsf
      real*8 p(0:3), fmass
c
c declare local variables
c
      real*8 r_zero, r_one, r_two
      parameter( r_zero=0.0d0, r_one=1.0d0, r_two=2.0d0 )
      complex*16 c_zero
cccccc      parameter( c_zero=dcmplx( r_zero, r_zero ) )
c
      real*8 plat, pabs, omegap, omegam, rs2pa, spaz
c
c define kinematic parameters
c
      c_zero=dcmplx( r_zero, r_zero )
      fi(5) = dcmplx( p(0), p(3) ) * nsf
      fi(6) = dcmplx( p(1), p(2) ) * nsf
      plat = sqrt( p(1)**2 + p(2)**2 )
      pabs = sqrt( p(1)**2 + p(2)**2 + p(3)**2 )
      omegap = sqrt( p(0) + pabs )
c
c do massive fermion case
c
      if ( fmass .ne. r_zero ) then
         omegam = fmass / omegap
         if ( nsf .eq. 1 ) then
            if ( nhel .eq. 1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fi(1) = dcmplx( omegam, r_zero )
                     fi(2) = c_zero
                     fi(3) = dcmplx( omegap, r_zero )
                     fi(4) = c_zero
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs + p(3) )
                     fi(1) = omegam * rs2pa
     &                     * dcmplx( spaz, r_zero )
                     fi(2) = omegam * rs2pa / spaz
     &                     * dcmplx( p(1), p(2) )
                     fi(3) = omegap * rs2pa
     &                     * dcmplx( spaz, r_zero )
                     fi(4) = omegap * rs2pa / spaz
     &                     * dcmplx( p(1), p(2) )
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fi(1) = c_zero
                     fi(2) = dcmplx( omegam, r_zero )
                     fi(3) = c_zero
                     fi(4) = dcmplx( omegap, r_zero )
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs - p(3) )
                     fi(1) = omegam * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                     fi(2) = omegam * rs2pa * spaz / plat
     &                     * dcmplx( p(1), p(2) )
                     fi(3) = omegap * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                     fi(4) = omegap * rs2pa * spaz / plat
     &                     * dcmplx( p(1), p(2) )
                  end if
               end if
            else if ( nhel .eq. -1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fi(1) = c_zero
                     fi(2) = dcmplx( omegap, r_zero )
                     fi(3) = c_zero
                     fi(4) = dcmplx( omegam, r_zero )
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs + p(3) )
                     fi(1) = omegap * rs2pa / spaz
     &                     * dcmplx( -p(1), p(2) )
                     fi(2) = omegap * rs2pa
     &                     * dcmplx( spaz, r_zero )
                     fi(3) = omegam * rs2pa / spaz
     &                     * dcmplx( -p(1), p(2) )
                     fi(4) = omegam * rs2pa
     &                     * dcmplx( spaz, r_zero )
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fi(1) = dcmplx( -omegap, r_zero )
                     fi(2) = c_zero
                     fi(3) = dcmplx( -omegam, r_zero )
                     fi(4) = c_zero
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs - p(3) )
                     fi(1) = omegap * rs2pa * spaz / plat
     &                     * dcmplx( -p(1), p(2) )
                     fi(2) = omegap * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                     fi(3) = omegam * rs2pa * spaz / plat
     &                     * dcmplx( -p(1), p(2) )
                     fi(4) = omegam * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                  end if
               end if
            else
               stop 'iqxxxxx:  fermion helicity must be +1,-1'
            end if
         else if ( nsf .eq. -1 ) then
            if ( nhel .eq. 1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fi(1) = c_zero
                     fi(2) = dcmplx( -omegap, r_zero )
                     fi(3) = c_zero
                     fi(4) = dcmplx( omegam, r_zero )
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs + p(3) )
                     fi(1) = -omegap * rs2pa / spaz
     &                     * dcmplx( -p(1), p(2) )
                     fi(2) = -omegap * rs2pa
     &                     * dcmplx( spaz, r_zero )
                     fi(3) = omegam * rs2pa / spaz
     &                     * dcmplx( -p(1), p(2) )
                     fi(4) = omegam * rs2pa
     &                     * dcmplx( spaz, r_zero )
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fi(1) = dcmplx( omegap, r_zero )
                     fi(2) = c_zero
                     fi(3) = dcmplx( -omegam, r_zero )
                     fi(4) = c_zero
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs - p(3) )
                     fi(1) = -omegap * rs2pa * spaz / plat
     &                     * dcmplx( -p(1), p(2) )
                     fi(2) = -omegap * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                     fi(3) = omegam * rs2pa * spaz / plat
     &                     * dcmplx( -p(1), p(2) )
                     fi(4) = omegam * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                  end if
               end if
            else if ( nhel .eq. -1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fi(1) = dcmplx( omegam, r_zero )
                     fi(2) = c_zero
                     fi(3) = dcmplx( -omegap, r_zero )
                     fi(4) = c_zero
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs + p(3) )
                     fi(1) = omegam * rs2pa
     &                     * dcmplx( spaz, r_zero )
                     fi(2) = omegam * rs2pa / spaz
     &                     * dcmplx( p(1), p(2) )
                     fi(3) = -omegap * rs2pa
     &                     * dcmplx( spaz, r_zero )
                     fi(4) = -omegap * rs2pa / spaz
     &                     * dcmplx( p(1), p(2) )
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fi(1) = c_zero
                     fi(2) = dcmplx( omegam, r_zero )
                     fi(3) = c_zero
                     fi(4) = dcmplx( -omegap, r_zero )
                  else
                     rs2pa = r_one / sqrt( r_two * pabs )
                     spaz = sqrt( pabs - p(3) )
                     fi(1) = omegam * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                     fi(2) = omegam * rs2pa * spaz / plat
     &                     * dcmplx( p(1), p(2) )
                     fi(3) = -omegap * rs2pa / spaz
     &                     * dcmplx( plat, r_zero )
                     fi(4) = -omegap * rs2pa * spaz / plat
     &                     * dcmplx( p(1), p(2) )
                  end if
               end if
            else
               stop 'iqxxxxx:  fermion helicity must be +1,-1'
            end if
         else
            stop 'iqxxxxx:  fermion type must be +1,-1'
         end if
c
c do massless fermion case
c
      else
         if ( nsf .eq. 1 ) then
            if ( nhel .eq. 1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fi(1) = c_zero
                     fi(2) = c_zero
                     fi(3) = dcmplx( omegap, r_zero )
                     fi(4) = c_zero
                  else
                     spaz = sqrt( pabs + p(3) )
                     fi(1) = c_zero
                     fi(2) = c_zero
                     fi(3) = dcmplx( spaz, r_zero )
                     fi(4) = r_one / spaz
     &                     * dcmplx( p(1), p(2) )
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fi(1) = c_zero
                     fi(2) = c_zero
                     fi(3) = c_zero
                     fi(4) = dcmplx( omegap, r_zero )
                  else
                     spaz = sqrt( pabs - p(3) )
                     fi(1) = c_zero
                     fi(2) = c_zero
                     fi(3) = r_one / spaz
     &                     * dcmplx( plat, r_zero )
                     fi(4) = spaz / plat
     &                     * dcmplx( p(1), p(2) )
                  end if
               end if
            else if ( nhel .eq. -1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fi(1) = c_zero
                     fi(2) = dcmplx( omegap, r_zero )
                     fi(3) = c_zero
                     fi(4) = c_zero
                  else
                     spaz = sqrt( pabs + p(3) )
                     fi(1) = r_one / spaz
     &                     * dcmplx( -p(1), p(2) )
                     fi(2) = dcmplx( spaz, r_zero )
                     fi(3) = c_zero
                     fi(4) = c_zero
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fi(1) = dcmplx( -omegap, r_zero )
                     fi(2) = c_zero
                     fi(3) = c_zero
                     fi(4) = c_zero
                  else
                     spaz = sqrt( pabs - p(3) )
                     fi(1) = spaz / plat
     &                     * dcmplx( -p(1), p(2) )
                     fi(2) = r_one / spaz
     &                     * dcmplx( plat, r_zero )
                     fi(3) = c_zero
                     fi(4) = c_zero
                  end if
               end if
            else
               stop 'iqxxxxx:  fermion helicity must be +1,-1'
            end if
         else if ( nsf .eq. -1 ) then
            if ( nhel .eq. 1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fi(1) = c_zero
                     fi(2) = dcmplx( -omegap, r_zero )
                     fi(3) = c_zero
                     fi(4) = c_zero
                  else
                     spaz = sqrt( pabs + p(3) )
                     fi(1) = -r_one / spaz
     &                     * dcmplx( -p(1), p(2) )
                     fi(2) = dcmplx( -spaz, r_zero )
                     fi(3) = c_zero
                     fi(4) = c_zero
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fi(1) = dcmplx( omegap, r_zero )
                     fi(2) = c_zero
                     fi(3) = c_zero
                     fi(4) = c_zero
                  else
                     spaz = sqrt( pabs - p(3) )
                     fi(1) = -spaz / plat
     &                     * dcmplx( -p(1), p(2) )
                     fi(2) = -r_one / spaz
     &                     * dcmplx( plat, r_zero )
                     fi(3) = c_zero
                     fi(4) = c_zero
                  end if
               end if
            else if ( nhel .eq. -1 ) then
               if ( p(3) .ge. r_zero ) then
                  if ( plat .eq. r_zero ) then
                     fi(1) = c_zero
                     fi(2) = c_zero
                     fi(3) = dcmplx( -omegap, r_zero )
                     fi(4) = c_zero
                  else
                     spaz = sqrt( pabs + p(3) )
                     fi(1) = c_zero
                     fi(2) = c_zero
                     fi(3) = dcmplx( -spaz, r_zero )
                     fi(4) = -r_one / spaz
     &                     * dcmplx( p(1), p(2) )
                  end if
               else
                  if ( plat .eq. r_zero ) then
                     fi(1) = c_zero
                     fi(2) = c_zero
                     fi(3) = c_zero
                     fi(4) = dcmplx( -omegap, r_zero )
                  else
                     spaz = sqrt( pabs - p(3) )
                     fi(1) = c_zero
                     fi(2) = c_zero
                     fi(3) = -r_one / spaz
     &                     * dcmplx( plat, r_zero )
                     fi(4) = -spaz / plat
     &                     * dcmplx( p(1), p(2) )
                  end if
               end if
            else
               stop 'iqxxxxx:  fermion helicity must be +1,-1'
            end if
         else
            stop 'iqxxxxx:  fermion type must be +1,-1'
         end if
      end if
c
c done
c
      return
      end


c
c
c       Subroutine returns the value of evaluated
c       helicity basis boson polarisation wavefunction.
c       Replaces the HELAS routine VQXXXXX
c
c       Adam Duff,  1992 September 3
c       <duff@phenom.physics.wisc.edu>
c
      subroutine vqxxxxx(
     &              p,          !in: boson four momentum
     &              vmass,      !in: boson mass
     &              nhel,       !in: boson helicity
     &              nsv,        !in: incoming (-1) or outgoing (+1)
     &              vc          !out: boson wavefunction
     &                 )
      implicit none
c
c declare input/output variables
c
      complex*16 vc(6)
      integer*4 nhel, nsv
      real*8 p(0:3), vmass
c
c declare local variables
c
      real*8 r_zero, r_one, r_two
      parameter( r_zero=0.0d0, r_one=1.0d0, r_two=2.0d0 )
      complex*16 c_zero
cccccc      parameter( c_zero=dcmplx( r_zero, r_zero ) )
c
      real*8 plat, pabs, rs2, rplat, rpabs, rden
c
c define internal/external momenta
c
      c_zero=dcmplx( r_zero, r_zero )
      if ( nsv**2 .ne. 1 ) then
         stop 'vqxxxxx:  nsv is not one of -1, +1'
      end if
c
      rs2 = sqrt( r_one / r_two )
      vc(5) = dcmplx( p(0), p(3) ) * nsv
      vc(6) = dcmplx( p(1), p(2) ) * nsv
      plat = sqrt( p(1)**2 + p(2)**2 )
      pabs = sqrt( p(1)**2 + p(2)**2 + p(3)**2 )
c
c calculate polarisation four vectors
c
      if ( nhel**2 .eq. 1 ) then
         if ( (pabs .eq. r_zero) .or. (plat .eq. r_zero) ) then
            vc(1) = c_zero
            vc(2) = dcmplx( -nhel * rs2 * dsign( r_one, p(3) ), r_zero )
            vc(3) = dcmplx( r_zero, nsv * rs2 )
            vc(4) = c_zero
         else
            rplat = r_one / plat
            rpabs = r_one / pabs
            vc(1) = c_zero
            vc(2) = dcmplx( -nhel * rs2 * rpabs * rplat * p(1) * p(3),
     &                     -nsv * rs2 * rplat * p(2) )
            vc(3) = dcmplx( -nhel * rs2 * rpabs * rplat * p(2) * p(3),
     &                     nsv * rs2 * rplat * p(1) )
            vc(4) = dcmplx( nhel * rs2 * rpabs * plat,
     &                     r_zero )
         end if
      else if ( nhel .eq. 0 ) then
         if ( vmass .gt. r_zero ) then
            if ( pabs .eq. r_zero ) then
               vc(1) = c_zero
               vc(2) = c_zero
               vc(3) = c_zero
               vc(4) = dcmplx( r_one, r_zero )
            else
               rden = p(0) / ( vmass * pabs )
               vc(1) = dcmplx( pabs / vmass, r_zero )
               vc(2) = dcmplx( rden * p(1), r_zero )
               vc(3) = dcmplx( rden * p(2), r_zero )
               vc(4) = dcmplx( rden * p(3), r_zero )
            end if
         else
            stop  'vqxxxxx: nhel = 0 is only for massive bosons'
         end if
      else if ( nhel .eq. 4 ) then
         if ( vmass .gt. r_zero ) then
            rden = r_one / vmass
            vc(1) = dcmplx( rden * p(0), r_zero )
            vc(2) = dcmplx( rden * p(1), r_zero )
            vc(3) = dcmplx( rden * p(2), r_zero )
            vc(4) = dcmplx( rden * p(3), r_zero )
         elseif (vmass .eq. r_zero) then
            rden = r_one / p(0)
            vc(1) = dcmplx( rden * p(0), r_zero )
            vc(2) = dcmplx( rden * p(1), r_zero )
            vc(3) = dcmplx( rden * p(2), r_zero )
            vc(4) = dcmplx( rden * p(3), r_zero )
         else
            stop 'vqxxxxx: nhel = 4 is only for m>=0'
         end if
      else
         stop 'vqxxxxx:  nhel is not one of -1, 0, 1 or 4'
      end if
c
c done
c
      return
      end

      SUBROUTINE initializeq
!******************************************************************
!     sets up masses and coupling constants for Helas
!******************************************************************
      IMPLICIT NONE
!
! Constants
!
      double precision  sw2
      PARAMETER        (sw2 = .2320d0)

!   masses and widths of fermions

      double precision tmass,      bmass,     cmass
      PARAMETER       (tmass=150d0,bmass=5d0, cmass=0d0)
      double precision smass,      umass,     dmass
      PARAMETER       (smass=0d0,  umass=0d0, dmass=0d0)
      double precision twidth,     bwidth,    cwidth
      PARAMETER       (twidth=0d0, bwidth=0d0,cwidth=0d0)
      double precision swidth,     uwidth,    dwidth
      PARAMETER       (swidth=0d0, uwidth=0d0,dwidth=0d0)
      double precision emass,      mumass,    taumass
      PARAMETER       (emass=0d0,  mumass=0d0,taumass=0d0)
      double precision ewidth,     muwidth,    tauwidth
      PARAMETER       (ewidth=0d0, muwidth=0d0,tauwidth=0d0)

!   masses and widths of bosons

      double precision wmass,         zmass
      PARAMETER       (wmass=80.4d0,    zmass=91.1888d0)
      double precision wwidth,        zwidth
      PARAMETER       (wwidth=2.25d0, zwidth=2.5d0)
      double precision amass,         awidth
      PARAMETER       (amass=0d0,     awidth=0d0)
      double precision hmass,         hwidth
      PARAMETER       (hmass=200d0,   hwidth=1d0)
!
! Local Variables
!
      INTEGER i
!
! Global Variables
!
      double precision  gw, gwwa, gwwz
      COMMON /coup1/    gw, gwwa, gwwz
      double precision  gal(2),gau(2),gad(2),gwf(2)
      COMMON /coup2a/   gal,   gau,   gad,   gwf
      double precision  gzn(2),gzl(2),gzu(2),gzd(2),g1(2)
      COMMON /coup2b/   gzn,   gzl,   gzu,   gzd,   g1
      double precision  gwwh,gzzh,ghhh,gwwhh,gzzhh,ghhhh
      COMMON /coup3/    gwwh,gzzh,ghhh,gwwhh,gzzhh,ghhhh
      COMPLEX*16        gchf(2,12)
      COMMON /coup4/    gchf
      double precision  wmass1,wwidth1,zmass1,zwidth1
      COMMON /vmass1/   wmass1,wwidth1,zmass1,zwidth1
      double precision  amass1,awidth1,hmass1,hwidth1
      COMMON /vmass2/   amass1,awidth1,hmass1,hwidth1
      double precision  fmass(12), fwidth(12)
      COMMON /fermions/ fmass,     fwidth
      double precision  gg(2), g
      COMMON /coupqcd/  gg,    g

!-----------
! Begin Code
!-----------
      fmass(1) = emass
      fmass(2) = 0d0
      fmass(3) = umass
      fmass(4) = dmass
      fmass(5) = mumass
      fmass(6) = 0d0
      fmass(7) = cmass
      fmass(8) = smass
      fmass(9) = taumass
      fmass(10)= 0d0
      fmass(11)= tmass
      fmass(12)= bmass

      fwidth(1) = ewidth
      fwidth(2) = 0d0
      fwidth(3) = uwidth
      fwidth(4) = dwidth
      fwidth(5) = muwidth
      fwidth(6) = 0d0
      fwidth(7) = cwidth
      fwidth(8) = swidth
      fwidth(9) = tauwidth
      fwidth(10)= 0d0
      fwidth(11)= twidth
      fwidth(12)= bwidth

      wmass1=wmass
      zmass1=zmass
      amass1=amass
      hmass1=hmass
      wwidth1=wwidth
      zwidth1=zwidth
      awidth1=awidth
      hwidth1=hwidth

!  Calls to Helas routines to set couplings

      CALL coupq1x(sw2,gw,gwwa,gwwz)
      CALL coupq2x(sw2,gal,gau,gad,gwf,gzn,gzl,gzu,gzd,g1)
      CALL coupq3x(sw2,zmass,hmass,gwwh,gzzh,ghhh,gwwhh,gzzhh,ghhhh)
      DO i=1,12
        CALL coupq4x(sw2,zmass,fmass(i),gchf(1,i))
      ENDDO

!  QCD couplings

      g = 1d0
      gg(1)=-g
      gg(2)=-g

      END

c ----------------------------------------------------------------------
c
      SUBROUTINE fviqxxx(fi,vc,g,fmass,fwidth , fvi)
c
c this subroutine computes an off-shell fermion wavefunction from a
c flowing-in external fermion and a vector boson.
c
c input:
c       complex fi(6)          : flow-in  fermion                   |fi>
c       complex vc(6)          : input    vector                      v
c       real    g(2)           : coupling constants                  gvf
c       real    fmass          : mass  of output fermion f'
c       real    fwidth         : width of output fermion f'
c
c output:
c       complex fvi(6)         : off-shell fermion             |f',v,fi>
c
      COMPLEX*16 fi(6),vc(6),fvi(6),sl1,sl2,sr1,sr2,d
      REAL*8    g(2),pf(0:3),fmass,fwidth,pf2
c
      REAL*8 r_zero, r_one
      PARAMETER( r_zero=0.0d0, r_one=1.0d0 )
      COMPLEX*16 c_imag
ccccccc      PARAMETER( c_imag=dcmplx( r_zero, r_one ) )
      c_imag=dcmplx( r_zero, r_one )
c
      fvi(5) = fi(5)-vc(5)
      fvi(6) = fi(6)-vc(6)
c
      pf(0)=dble( fvi(5))
      pf(1)=dble( fvi(6))
      pf(2)=dimag(fvi(6))
      pf(3)=dimag(fvi(5))
      pf2=pf(0)**2-(pf(1)**2+pf(2)**2+pf(3)**2)
c
      d=-r_one/dcmplx( pf2-fmass**2,max(sign(fmass*fwidth,pf2),r_zero))
      sl1= (vc(1)+       vc(4))*fi(1)
     &    +(vc(2)-c_imag*vc(3))*fi(2)
      sl2= (vc(2)+c_imag*vc(3))*fi(1)
     &    +(vc(1)-       vc(4))*fi(2)
c
      IF ( g(2) .NE. r_zero ) THEN
        sr1= (vc(1)-       vc(4))*fi(3)
     &       -(vc(2)-c_imag*vc(3))*fi(4)
        sr2=-(vc(2)+c_imag*vc(3))*fi(3)
     &       +(vc(1)+       vc(4))*fi(4)
c
        fvi(1) = ( g(1)*((pf(0)-pf(3))*sl1 -dconjg(fvi(6))*sl2)
     &             +g(2)*fmass*sr1)*d
        fvi(2) = ( g(1)*(      -fvi(6)*sl1 +(pf(0)+pf(3))*sl2)
     &             +g(2)*fmass*sr2)*d
        fvi(3) = ( g(2)*((pf(0)+pf(3))*sr1 +dconjg(fvi(6))*sr2)
     &             +g(1)*fmass*sl1)*d
        fvi(4) = ( g(2)*(       fvi(6)*sr1 +(pf(0)-pf(3))*sr2)
     &             +g(1)*fmass*sl2)*d
c
      ELSE
        fvi(1) = g(1)*((pf(0)-pf(3))*sl1 -dconjg(fvi(6))*sl2)*d
        fvi(2) = g(1)*(      -fvi(6)*sl1 +(pf(0)+pf(3))*sl2)*d
        fvi(3) = g(1)*fmass*sl1*d
        fvi(4) = g(1)*fmass*sl2*d
      END IF
c
      RETURN
      END



c
c ======================================================================
c
      SUBROUTINE iovqxxx(fi,fo,vc,g , vertex)
c
c this subroutine computes an amplitude of the fermion-fermion-vector
c coupling.
c
c input:
c       complex fi(6)          : flow-in  fermion                   |fi>
c       complex fo(6)          : flow-out fermion                   <fo|
c       complex vc(6)          : input    vector                      v
c       real    g(2)           : coupling constants                  gvf
c
c output:
c       complex vertex         : amplitude                     <fo|v|fi>
c
      COMPLEX*16 fi(6),fo(6),vc(6),vertex
      REAL*8    g(2)
c
      REAL*8 r_zero, r_one
      PARAMETER( r_zero=0.0d0, r_one=1.0d0 )
      COMPLEX*16 c_imag
cccccccc      PARAMETER( c_imag=dcmplx( r_zero, r_one ) )
      c_imag=dcmplx( r_zero, r_one )
c

      vertex =  g(1)*( (fo(3)*fi(1)+fo(4)*fi(2))*vc(1)
     &                +(fo(3)*fi(2)+fo(4)*fi(1))*vc(2)
     &                -(fo(3)*fi(2)-fo(4)*fi(1))*vc(3)*c_imag
     &                +(fo(3)*fi(1)-fo(4)*fi(2))*vc(4)        )
c
      IF ( g(2) .NE. r_zero ) THEN
        vertex = vertex
     &          + g(2)*( (fo(1)*fi(3)+fo(2)*fi(4))*vc(1)
     &          -(fo(1)*fi(4)+fo(2)*fi(3))*vc(2)
     &          +(fo(1)*fi(4)-fo(2)*fi(3))*vc(3)*c_imag
     &          -(fo(1)*fi(3)-fo(2)*fi(4))*vc(4)        )
      END IF
c
      RETURN
      END


c
c ----------------------------------------------------------------------
c
      SUBROUTINE fvoqxxx(fo,vc,g,fmass,fwidth , fvo)
c
c this subroutine computes an off-shell fermion wavefunction from a
c flowing-out external fermion and a vector boson.
c
c input:
c       complex fo(6)          : flow-out fermion                   <fo|
c       complex vc(6)          : input    vector                      v
c       real    g(2)           : coupling constants                  gvf
c       real    fmass          : mass  of output fermion f'
c       real    fwidth         : width of output fermion f'
c
c output:
c       complex fvo(6)         : off-shell fermion             <fo,v,f'|
c
      COMPLEX*16 fo(6),vc(6),fvo(6),sl1,sl2,sr1,sr2,d
      REAL*8    g(2),pf(0:3),fmass,fwidth,pf2
c
      REAL*8 r_zero, r_one
      PARAMETER( r_zero=0.0d0, r_one=1.0d0 )
      COMPLEX*16 c_imag
cccccc      PARAMETER( c_imag=dcmplx( r_zero, r_one ) )
      c_imag=dcmplx( r_zero, r_one )
c
      fvo(5) = fo(5)+vc(5)
      fvo(6) = fo(6)+vc(6)
c
      pf(0)=dble( fvo(5))
      pf(1)=dble( fvo(6))
      pf(2)=dimag(fvo(6))
      pf(3)=dimag(fvo(5))
      pf2=pf(0)**2-(pf(1)**2+pf(2)**2+pf(3)**2)
c
      d=-r_one/dcmplx( pf2-fmass**2,max(sign(fmass*fwidth,pf2),r_zero))
      sl1= (vc(1)+       vc(4))*fo(3)
     &    +(vc(2)+c_imag*vc(3))*fo(4)
      sl2= (vc(2)-c_imag*vc(3))*fo(3)
     &    +(vc(1)-       vc(4))*fo(4)
c
      IF ( g(2) .NE. r_zero ) THEN
        sr1= (vc(1)-       vc(4))*fo(1)
     &       -(vc(2)+c_imag*vc(3))*fo(2)
        sr2=-(vc(2)-c_imag*vc(3))*fo(1)
     &       +(vc(1)+       vc(4))*fo(2)
c
        fvo(1) = ( g(2)*( (pf(0)+pf(3))*sr1        +fvo(6)*sr2)
     &             +g(1)*fmass*sl1)*d
        fvo(2) = ( g(2)*( dconjg(fvo(6))*sr1 +(pf(0)-pf(3))*sr2)
     &             +g(1)*fmass*sl2)*d
        fvo(3) = ( g(1)*( (pf(0)-pf(3))*sl1        -fvo(6)*sl2)
     &             +g(2)*fmass*sr1)*d
        fvo(4) = ( g(1)*(-dconjg(fvo(6))*sl1 +(pf(0)+pf(3))*sl2)
     &             +g(2)*fmass*sr2)*d
c
      ELSE
        fvo(1) = g(1)*fmass*sl1*d
        fvo(2) = g(1)*fmass*sl2*d
        fvo(3) = g(1)*( (pf(0)-pf(3))*sl1        -fvo(6)*sl2)*d
        fvo(4) = g(1)*(-dconjg(fvo(6))*sl1 +(pf(0)+pf(3))*sl2)*d
      END IF
c
      RETURN
      END
C
C ----------------------------------------------------------------------
C
      SUBROUTINE COUPQ4X(SW2,ZMASS,FMASS , GCHF)
C
C This subroutine sets up the coupling constant for the fermion-fermion-
C Higgs vertex in the STANDARD MODEL.  The coupling is COMPLEX and the
C array of the coupling specifies the chirality of the flowing-IN
C fermion.  GCHF(1) denotes a left-handed coupling, and GCHF(2) a right-
C handed coupling.
C
C INPUT:
C       real    SW2            : square of sine of the weak angle
C       real    ZMASS          : Z       mass
C       real    FMASS          : fermion mass
C
C OUTPUT:
C       complex GCHF(2)        : coupling of fermion and Higgs
C
      IMPLICIT NONE
      COMPLEX*16 GCHF(2)
      REAL*8    SW2,ZMASS,FMASS,ALPHA,FOURPI,EZ,G
C
      ALPHA=1.d0/128.d0
C      ALPHA=1./REAL(137.0359895)
      FOURPI=4.D0*3.14159265358979323846D0
      EZ=SQRT(ALPHA*FOURPI)/SQRT(SW2*(1.d0-SW2))
      G=EZ*FMASS*0.5d0/ZMASS
C
      GCHF(1) = DCMPLX( -G )
      GCHF(2) = DCMPLX( -G )
C
      RETURN
      END
c
c ----------------------------------------------------------------------
c
      SUBROUTINE coupq3x(sw2,zmass,hmass ,
     &                  gwwh,gzzh,ghhh,gwwhh,gzzhh,ghhhh)
c
c this subroutine sets up the coupling constants of the gauge bosons and
c higgs boson in the standard model.
c
c input:
c       real    sw2            : square of sine of the weak angle
c       real    zmass          : mass of z
c       real    hmass          : mass of higgs
c
c output:
c       real    gwwh           : dimensionful  coupling of w-,w+,h
c       real    gzzh           : dimensionful  coupling of z, z, h
c       real    ghhh           : dimensionful  coupling of h, h, h
c       real    gwwhh          : dimensionful  coupling of w-,w+,h, h
c       real    gzzhh          : dimensionful  coupling of z, z, h, h
c       real    ghhhh          : dimensionless coupling of h, h, h, h
c
      REAL*8    sw2,zmass,hmass,gwwh,gzzh,ghhh,gwwhh,gzzhh,ghhhh,
     &        alpha,fourpi,ee2,sc2,v
c
      REAL*8 r_half, r_one, r_two, r_three, r_four, r_ote
      REAL*8 r_pi, r_ialph
      PARAMETER( r_half=0.5d0, r_one=1.0d0, r_two=2.0d0, r_three=3.0d0 )
      PARAMETER( r_four=4.0d0, r_ote=128.0d0 )
      PARAMETER( r_pi=3.14159265358979323846d0, r_ialph=137.0359895d0 )
c
      alpha = r_one / r_ote
c      alpha = r_one / r_ialph
      fourpi = r_four * r_pi
      ee2=alpha*fourpi
      sc2=sw2*( r_one - sw2 )
      v = r_two * zmass*sqrt(sc2)/sqrt(ee2)
c
      gwwh  =   ee2/sw2*r_half*v
      gzzh  =   ee2/sc2*r_half*v
      ghhh  =  -hmass**2/v*r_three
      gwwhh =   ee2/sw2*r_half
      gzzhh =   ee2/sc2*r_half
      ghhhh = -(hmass/v)**2*r_three
c
      RETURN
      END
c
c ----------------------------------------------------------------------
c
      SUBROUTINE coupq2x(sw2 , gal,gau,gad,gwf,gzn,gzl,gzu,gzd,g1)
c
c this subroutine sets up the coupling constants for the fermion-
c fermion-vector vertices in the standard model.  the array of the
c couplings specifies the chirality of the flowing-in fermion.  g??(1)
c denotes a left-handed coupling, and g??(2) a right-handed coupling.
c
c input:
c       real    sw2            : square of sine of the weak angle
c
c output:
c       real    gal(2)         : coupling with a of charged leptons
c       real    gau(2)         : coupling with a of up-type quarks
c       real    gad(2)         : coupling with a of down-type quarks
c       real    gwf(2)         : coupling with w-,w+ of fermions
c       real    gzn(2)         : coupling with z of neutrinos
c       real    gzl(2)         : coupling with z of charged leptons
c       real    gzu(2)         : coupling with z of up-type quarks
c       real    gzd(2)         : coupling with z of down-type quarks
c       real    g1(2)          : unit coupling of fermions
c
      REAL*8 gal(2),gau(2),gad(2),gwf(2),gzn(2),gzl(2),gzu(2),gzd(2),
     &     g1(2),sw2,alpha,fourpi,ee,sw,cw,ez,ey
c
      REAL*8 r_zero, r_half, r_one, r_two, r_three, r_four, r_ote
      REAL*8 r_pi, r_ialph
      PARAMETER( r_zero=0.0d0, r_half=0.5d0, r_one=1.0d0, r_two=2.0d0,
     $     r_three=3.0d0 )
      PARAMETER( r_four=4.0d0, r_ote=128.0d0 )
      PARAMETER( r_pi=3.14159265358979323846d0, r_ialph=137.0359890d0 )
c
c      alpha = r_one / r_ote
      alpha = r_one / r_ialph
      fourpi = r_four * r_pi
      ee=sqrt( alpha * fourpi )
      sw=sqrt( sw2 )
      cw=sqrt( r_one - sw2 )
      ez=ee/(sw*cw)
      ey=ee*(sw/cw)
c
      gal(1) =  ee
      gal(2) =  ee
      gau(1) = -ee*r_two/r_three
      gau(2) = -ee*r_two/r_three
      gad(1) =  ee   /r_three
      gad(2) =  ee   /r_three
      gwf(1) = -ee/sqrt(r_two*sw2)
      gwf(2) =  r_zero
      gzn(1) = -ez*  r_half
      gzn(2) =  r_zero
      gzl(1) = -ez*(-r_half+sw2)
      gzl(2) = -ey
      gzu(1) = -ez*( r_half-sw2*r_two/r_three)
      gzu(2) =  ey*          r_two/r_three
      gzd(1) = -ez*(-r_half+sw2   /r_three)
      gzd(2) = -ey             /r_three
      g1(1)  =  r_one
      g1(2)  =  r_one
c
      RETURN
      END
c
c **********************************************************************
c
      SUBROUTINE coupq1x(sw2 , gw,gwwa,gwwz)
c
c this subroutine sets up the coupling constants of the gauge bosons in
c the standard model.
c
c input:
c       real    sw2            : square of sine of the weak angle
c
c output:
c       real    gw             : weak coupling constant
c       real    gwwa           : dimensionless coupling of w-,w+,a
c       real    gwwz           : dimensionless coupling of w-,w+,z
c
      REAL*8    sw2,gw,gwwa,gwwz,alpha,fourpi,ee,sw,cw
c
      REAL*8 r_one, r_four, r_ote, r_pi, r_ialph
      PARAMETER( r_one=1.0d0, r_four=4.0d0, r_ote=128.0d0 )
      PARAMETER( r_pi=3.14159265358979323846d0, r_ialph=137.0359895d0 )
c
      alpha = r_one / r_ote
c      alpha = r_one / r_ialph
      fourpi = r_four * r_pi
      ee=sqrt( alpha * fourpi )
      sw=sqrt( sw2 )
      cw=sqrt( r_one - sw2 )
c
      gw    =  ee/sw
      gwwa  =  ee
      gwwz  =  ee*cw/sw
c
      RETURN
      END
c
c ----------------------------------------------------------------------
c
      SUBROUTINE jioqxxx(fi,fo,g,vmass,vwidth , jio)
c
c this subroutine computes an off-shell vector current from an external
c fermion pair.  the vector boson propagator is given in feynman gauge
c for a massless vector and in unitary gauge for a massive vector.
c
c input:
c       complex fi(6)          : flow-in  fermion                   |fi>
c       complex fo(6)          : flow-out fermion                   <fo|
c       real    g(2)           : coupling constants                  gvf
c       real    vmass          : mass  of output vector v
c       real    vwidth         : width of output vector v
c
c output:
c       complex jio(6)         : vector current          j^mu(<fo|v|fi>)
c
      COMPLEX*16 fi(6),fo(6),jio(6),c0,c1,c2,c3,cs,d
      REAL*8    g(2),q(0:3),vmass,vwidth,q2,vm2,dd
c
      REAL*8 r_zero, r_one
      PARAMETER( r_zero=0.0d0, r_one=1.0d0 )
      COMPLEX*16 c_imag
cccccccccccccc      PARAMETER( c_imag=dcmplx( r_zero, r_one ) )
      c_imag=dcmplx( r_zero, r_one ) 
c
      jio(5) = fo(5)-fi(5)
      jio(6) = fo(6)-fi(6)
c
      q(0)=dble( jio(5))
      q(1)=dble( jio(6))
      q(2)=dimag(jio(6))
      q(3)=dimag(jio(5))
      q2=q(0)**2-(q(1)**2+q(2)**2+q(3)**2)
      vm2=vmass**2
c
      IF (vmass.NE.r_zero) THEN
c
        d=r_one/dcmplx( q2-vm2 , max(sign( vmass*vwidth ,q2),r_zero) )
c  for the running width, use below instead of the above d.
c      d=r_one/dcmplx( q2-vm2 , max( vwidth*q2/vmass ,r_zero) )
c
        IF (g(2).NE.r_zero) THEN
c
          c0=  g(1)*( fo(3)*fi(1)+fo(4)*fi(2))
     &          +g(2)*( fo(1)*fi(3)+fo(2)*fi(4))
          c1= -g(1)*( fo(3)*fi(2)+fo(4)*fi(1))
     &          +g(2)*( fo(1)*fi(4)+fo(2)*fi(3))
          c2=( g(1)*( fo(3)*fi(2)-fo(4)*fi(1))
     &          +g(2)*(-fo(1)*fi(4)+fo(2)*fi(3)))*c_imag
          c3=  g(1)*(-fo(3)*fi(1)+fo(4)*fi(2))
     &          +g(2)*( fo(1)*fi(3)-fo(2)*fi(4))
        ELSE
c
          d=d*g(1)
          c0=  fo(3)*fi(1)+fo(4)*fi(2)
          c1= -fo(3)*fi(2)-fo(4)*fi(1)
          c2=( fo(3)*fi(2)-fo(4)*fi(1))*c_imag
          c3= -fo(3)*fi(1)+fo(4)*fi(2)
        END IF
c
        cs=(q(0)*c0-q(1)*c1-q(2)*c2-q(3)*c3)/vm2
c
        jio(1) = (c0-cs*q(0))*d
        jio(2) = (c1-cs*q(1))*d
        jio(3) = (c2-cs*q(2))*d
        jio(4) = (c3-cs*q(3))*d
c
      ELSE
        dd=r_one/q2
c
        IF (g(2).NE.r_zero) THEN
          jio(1) = ( g(1)*( fo(3)*fi(1)+fo(4)*fi(2))
     &                +g(2)*( fo(1)*fi(3)+fo(2)*fi(4)) )*dd
          jio(2) = (-g(1)*( fo(3)*fi(2)+fo(4)*fi(1))
     &                +g(2)*( fo(1)*fi(4)+fo(2)*fi(3)) )*dd
          jio(3) = ( g(1)*( fo(3)*fi(2)-fo(4)*fi(1))
     &                +g(2)*(-fo(1)*fi(4)+fo(2)*fi(3)))
     $                *dcmplx(r_zero,dd)
          jio(4) = ( g(1)*(-fo(3)*fi(1)+fo(4)*fi(2))
     &                +g(2)*( fo(1)*fi(3)-fo(2)*fi(4)) )*dd
c
        ELSE
          dd=dd*g(1)
c
          jio(1) =  ( fo(3)*fi(1)+fo(4)*fi(2))*dd
          jio(2) = -( fo(3)*fi(2)+fo(4)*fi(1))*dd
          jio(3) =  ( fo(3)*fi(2)-fo(4)*fi(1))*dcmplx(r_zero,dd)
          jio(4) =  (-fo(3)*fi(1)+fo(4)*fi(2))*dd
        END IF
      END IF
c
      RETURN
      END
c
c ----------------------------------------------------------------------
c
      SUBROUTINE jvvqxxx(v1,v2,g,vmass,vwidth , jvv)
c
c this subroutine computes an off-shell vector current from the three-
c point gauge boson coupling.  the vector propagator is given in feynman
c gauge for a massless vector and in unitary gauge for a massive vector.
c
c input:
c       complex v1(6)          : first  vector                        v1
c       complex v2(6)          : second vector                        v2
c       real    g              : coupling constant (see the table below)
c       real    vmass          : mass  of output vector v
c       real    vwidth         : width of output vector v
c
c the possible sets of the inputs are as follows:
c    ------------------------------------------------------------------
c    |   v1   |   v2   |  jvv   |      g       |   vmass  |  vwidth   |
c    ------------------------------------------------------------------
c    |   w-   |   w+   |  a/z   |  gwwa/gwwz   | 0./zmass | 0./zwidth |
c    | w3/a/z |   w-   |  w+    | gw/gwwa/gwwz |   wmass  |  wwidth   |
c    |   w+   | w3/a/z |  w-    | gw/gwwa/gwwz |   wmass  |  wwidth   |
c    ------------------------------------------------------------------
c where all the bosons are defined by the flowing-out quantum number.
c
c output:
c       complex jvv(6)         : vector current            j^mu(v:v1,v2)
c
      COMPLEX*16 v1(6),v2(6),jvv(6),j12(0:3),js,dg,
     &        sv1,sv2,s11,s12,s21,s22,v12
      REAL*8    p1(0:3),p2(0:3),q(0:3),g,vmass,vwidth,gs,s,vm2,m1,m2
c
      REAL*8 r_zero
      PARAMETER( r_zero=0.0d0 )
c
      jvv(5) = v1(5)+v2(5)
      jvv(6) = v1(6)+v2(6)
c
      p1(0)=dble( v1(5))
      p1(1)=dble( v1(6))
      p1(2)=dimag(v1(6))
      p1(3)=dimag(v1(5))
      p2(0)=dble( v2(5))
      p2(1)=dble( v2(6))
      p2(2)=dimag(v2(6))
      p2(3)=dimag(v2(5))
      q(0)=-dble( jvv(5))
      q(1)=-dble( jvv(6))
      q(2)=-dimag(jvv(6))
      q(3)=-dimag(jvv(5))
      s=q(0)**2-(q(1)**2+q(2)**2+q(3)**2)
c
      v12=v1(1)*v2(1)-v1(2)*v2(2)-v1(3)*v2(3)-v1(4)*v2(4)
      sv1= (p2(0)-q(0))*v1(1) -(p2(1)-q(1))*v1(2)
     &    -(p2(2)-q(2))*v1(3) -(p2(3)-q(3))*v1(4)
      sv2=-(p1(0)-q(0))*v2(1) +(p1(1)-q(1))*v2(2)
     &    +(p1(2)-q(2))*v2(3) +(p1(3)-q(3))*v2(4)
      j12(0)=(p1(0)-p2(0))*v12 +sv1*v2(1) +sv2*v1(1)
      j12(1)=(p1(1)-p2(1))*v12 +sv1*v2(2) +sv2*v1(2)
      j12(2)=(p1(2)-p2(2))*v12 +sv1*v2(3) +sv2*v1(3)
      j12(3)=(p1(3)-p2(3))*v12 +sv1*v2(4) +sv2*v1(4)
c
      IF ( vmass .NE. r_zero ) THEN
        vm2=vmass**2
        m1=p1(0)**2-(p1(1)**2+p1(2)**2+p1(3)**2)
        m2=p2(0)**2-(p2(1)**2+p2(2)**2+p2(3)**2)
        s11=p1(0)*v1(1)-p1(1)*v1(2)-p1(2)*v1(3)-p1(3)*v1(4)
        s12=p1(0)*v2(1)-p1(1)*v2(2)-p1(2)*v2(3)-p1(3)*v2(4)
        s21=p2(0)*v1(1)-p2(1)*v1(2)-p2(2)*v1(3)-p2(3)*v1(4)
        s22=p2(0)*v2(1)-p2(1)*v2(2)-p2(2)*v2(3)-p2(3)*v2(4)
        js=(v12*(-m1+m2) +s11*s12 -s21*s22)/vm2
c
        dg=-g/dcmplx( s-vm2 , max(sign( vmass*vwidth ,s),r_zero) )
c
c  for the running width, use below instead of the above dg.
c         dg=-g/dcmplx( s-vm2 , max( vwidth*s/vmass ,r_zero) )
c
        jvv(1) = dg*(j12(0)-q(0)*js)
        jvv(2) = dg*(j12(1)-q(1)*js)
        jvv(3) = dg*(j12(2)-q(2)*js)
        jvv(4) = dg*(j12(3)-q(3)*js)
c
      ELSE
        gs=-g/s
c
        jvv(1) = gs*j12(0)
        jvv(2) = gs*j12(1)
        jvv(3) = gs*j12(2)
        jvv(4) = gs*j12(3)
      END IF
c
      RETURN
      END
c
c ======================================================================
c
      SUBROUTINE vvvqxxx(wm,wp,w3,g , vertex)
c
c this subroutine computes an amplitude of the three-point coupling of
c the gauge bosons.
c
c input:
c       complex wm(6)          : vector               flow-out w-
c       complex wp(6)          : vector               flow-out w+
c       complex w3(6)          : vector               j3 or a    or z
c       real    g              : coupling constant    gw or gwwa or gwwz
c
c output:
c       complex vertex         : amplitude               gamma(wm,wp,w3)
c
      COMPLEX*16 wm(6),wp(6),w3(6),vertex,
     &        xv1,xv2,xv3,v12,v23,v31,p12,p13,p21,p23,p31,p32
      REAL*8    pwm(0:3),pwp(0:3),pw3(0:3),g
c
      REAL*8 r_zero, r_tenth
      PARAMETER( r_zero=0.0d0, r_tenth=0.1d0 )
c
      pwm(0)=dble( wm(5))
      pwm(1)=dble( wm(6))
      pwm(2)=dimag(wm(6))
      pwm(3)=dimag(wm(5))
      pwp(0)=dble( wp(5))
      pwp(1)=dble( wp(6))
      pwp(2)=dimag(wp(6))
      pwp(3)=dimag(wp(5))
      pw3(0)=dble( w3(5))
      pw3(1)=dble( w3(6))
      pw3(2)=dimag(w3(6))
      pw3(3)=dimag(w3(5))
c
      v12=wm(1)*wp(1)-wm(2)*wp(2)-wm(3)*wp(3)-wm(4)*wp(4)
      v23=wp(1)*w3(1)-wp(2)*w3(2)-wp(3)*w3(3)-wp(4)*w3(4)
      v31=w3(1)*wm(1)-w3(2)*wm(2)-w3(3)*wm(3)-w3(4)*wm(4)
      xv1=r_zero
      xv2=r_zero
      xv3=r_zero
      IF ( abs(wm(1)) .NE. r_zero ) THEN
        IF (abs(wm(1)).GE.max(abs(wm(2)),abs(wm(3)),abs(wm(4)))
     $        *r_tenth)
     &        xv1=pwm(0)/wm(1)
      ENDIF
      IF ( abs(wp(1)) .NE. r_zero) THEN
        IF (abs(wp(1)).GE.max(abs(wp(2)),abs(wp(3)),abs(wp(4)))
     $        *r_tenth)
     &        xv2=pwp(0)/wp(1)
      ENDIF
      IF ( abs(w3(1)) .NE. r_zero) THEN
        IF ( abs(w3(1)).GE.max(abs(w3(2)),abs(w3(3)),abs(w3(4)))
     $        *r_tenth)
     &        xv3=pw3(0)/w3(1)
      ENDIF
      p12= (pwm(0)-xv1*wm(1))*wp(1)-(pwm(1)-xv1*wm(2))*wp(2)
     &    -(pwm(2)-xv1*wm(3))*wp(3)-(pwm(3)-xv1*wm(4))*wp(4)
      p13= (pwm(0)-xv1*wm(1))*w3(1)-(pwm(1)-xv1*wm(2))*w3(2)
     &    -(pwm(2)-xv1*wm(3))*w3(3)-(pwm(3)-xv1*wm(4))*w3(4)
      p21= (pwp(0)-xv2*wp(1))*wm(1)-(pwp(1)-xv2*wp(2))*wm(2)
     &    -(pwp(2)-xv2*wp(3))*wm(3)-(pwp(3)-xv2*wp(4))*wm(4)
      p23= (pwp(0)-xv2*wp(1))*w3(1)-(pwp(1)-xv2*wp(2))*w3(2)
     &    -(pwp(2)-xv2*wp(3))*w3(3)-(pwp(3)-xv2*wp(4))*w3(4)
      p31= (pw3(0)-xv3*w3(1))*wm(1)-(pw3(1)-xv3*w3(2))*wm(2)
     &    -(pw3(2)-xv3*w3(3))*wm(3)-(pw3(3)-xv3*w3(4))*wm(4)
      p32= (pw3(0)-xv3*w3(1))*wp(1)-(pw3(1)-xv3*w3(2))*wp(2)
     &    -(pw3(2)-xv3*w3(3))*wp(3)-(pw3(3)-xv3*w3(4))*wp(4)
c
      vertex = -(v12*(p13-p23)+v23*(p21-p31)+v31*(p32-p12))*g
c
      RETURN
      END


      integer function KWTKBK(IS,wei)
C--------------------------------------------------------------------
C!  BOOK and fill bank KWTK with weight info
C      B. Bloch -Devaux February 2002
C     structure : integer function
C
C     input     : IS   row number to be filled
C                 IWEI weight number to be stored
C                 WEI  weight value  to be stored
C     output    : index of KWTK bank ( should be >0 if OK)
C                 KWTK bank is written to Event list
C
C--------------------------------------------------------------------

      SAVE

      INTEGER LMHLEN, LMHCOL, LMHROW
      PARAMETER (LMHLEN=2, LMHCOL=1, LMHROW=2)
C
      COMMON /BCS/   IW(1000)
      INTEGER IW
      REAL RW(1000)
      EQUIVALENCE (RW(1),IW(1))
C
      INTEGER JKWTW1,JKWTW2,JKWTW3,JKWTW4,JKWTW5,JKWTW6,LKWTKA
      PARAMETER(JKWTW1=1,JKWTW2=2,JKWTW3=3,JKWTW4=4,JKWTW5=5,JKWTW6=6,
     +          LKWTKA=6)
      real wei
      dimension wei(6)
      INTEGER NAKWTK / 0 /
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
C--------------------------------------------------------------
C
      KWTKBK = -1
      IF( NAKWTK.EQ.0 ) NAKWTK = NAMIND('KWTK')
C
C   Get KWTK index
      JKWTK = IW(NAKWTK)
      IF ( JKWTK.LE.0) THEN
C   Create KWTK bank
         CALL AUBOS('KWTK',0,LKWTKA+LMHLEN,JKWTK,IGARB)
         IF ( JKWTK.LE.0) GO TO 999
         IW(JKWTK+LMHCOL) = LKWTKA
         IW(JKWTK+LMHROW) = 1
         CALL BKFMT('KWTK','2I,(6F)')
         CALL BLIST(IW,'E+','KWTK')
      ELSE
C  KWTK EXISTS, TEST THE LENGTH AND EXTEND IF NEEDED
         NKWTK=LROWS(JKWTK)
         IF ( IS.GT.NKWTK) THEN
           CALL AUBOS('KWTK',0,LKWTKA*IS+LMHLEN,JKWTK,IGARB)
           IF ( JKWTK.LE.0) THEN
              KWTKBK= -IS
              GO TO 999
           ELSE
              IW(JKWTK+LMHROW) = IS
           ENDIF
         ENDIF
      ENDIF
C  Fill KWTK BANK
      KKWTK = KROW(JKWTK,IS)
      call ucopy ( wei, RW(KKWTK+1),6)
      KWTKBK = JKWTK
C
 999  RETURN
      END
