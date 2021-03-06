      SUBROUTINE QFMCPA
CKEY FILL MC /INTERNAL
C-----------------------------------------------------------------------
C! Fill MC particles
C!                                                  H.Albrecht 18.10.88
C!                                        Modified: E.Lancon   12.07.89
C!called from QFILMC
C-----------------------------------------------------------------------
      INTEGER JFVEVX,JFVEVY,JFVEVZ,JFVETO,JFVEIP,JFVEIS,JFVENS,JFVEVN,
     +          JFVEVM,LFVERA
      PARAMETER(JFVEVX=1,JFVEVY=2,JFVEVZ=3,JFVETO=4,JFVEIP=5,JFVEIS=6,
     +          JFVENS=7,JFVEVN=8,JFVEVM=9,LFVERA=9)
      INTEGER JFKIPX,JFKIPY,JFKIPZ,JFKIMA,JFKIPA,JFKIOV,JFKIEV,JFKIHC,
     +          LFKINA
      PARAMETER(JFKIPX=1,JFKIPY=2,JFKIPZ=3,JFKIMA=4,JFKIPA=5,JFKIOV=6,
     +          JFKIEV=7,JFKIHC=8,LFKINA=8)
      INTEGER JAJOBM,JAJORM,JAJOGI,JAJOSO,JAJOSD,JAJOGC,JAJOJD,JAJOJT,
     +          JAJOGV,JAJOAV,JAJOFT,JAJOFS,JAJOFC,JAJODV,JAJODD,JAJOTV,
     +          JAJOCV,JAJOGN,LAJOBA
      PARAMETER(JAJOBM=1,JAJORM=2,JAJOGI=3,JAJOSO=4,JAJOSD=5,JAJOGC=6,
     +          JAJOJD=7,JAJOJT=8,JAJOGV=9,JAJOAV=10,JAJOFT=11,
     +          JAJOFS=12,JAJOFC=13,JAJODV=14,JAJODD=15,JAJOTV=16,
     +          JAJOCV=17,JAJOGN=18,LAJOBA=18)
C Start of QCDESH ----------------------- Description in QDATA ---------
      PARAMETER (KCQDET=34, KCQFPA=8, KCQPAR=10, KCQVEC=73, KCQVRT=30,
     & KHE=1, KHMU=2, KHPI=3, KHK=4, KHP=5, KHPHOT=1, KHNHAD=2,
     & KMONTE=-2, KRECO=-1, KLOCKM=14, KSOVT=1, KSCHT=2, KSIST=3,
     & KSAST=4, KSEHT=5, KSV0T=6, KSDCT=7, KSEFT=8, KSNET=9, KSGAT=10,
     & KSJET=11, KSMCT=12, KSREV=13,
     & KSMCV=14, KUNDEF=-12344321, QQPI=3.141593, QQE=2.718282,
     & QQ2PI=QQPI*2., QQPIH=QQPI/2., QQRADP=180./QQPI, QQC=2.997925E10,
     & QQH=6.582173E-25, QQHC=QQH*QQC, QQIRP=.00029979)
      CHARACTER CQDATE*8, CQDWRK*80, CQFHIS*80, CQFOUT*80, CQFWRK*80,
     & CQHTIT*80, CQSEC*3, CQTIME*8, CQUNPK*30, CQVERS*6, CQRLST*800,
     & CQELST*800
      COMMON /QCDEC/ CQDATE, CQDWRK, CQFHIS, CQFOUT, CQFWRK, CQHTIT,
     & CQSEC(14), CQTIME, CQUNPK, CQVERS, CQRLST, CQELST
      COMMON /QCDE/ QELEP, QMFLD ,QMFLDC, QTIME, QTIMEI, QTIMEL,
     & QTIMES, QTIMET, QDHEEC, QDHEEL, QDHEPF, QDHETH, QDHEPH, QDHEEF,
     & QDHEET, QDHET1, QDHEP1, QDHET2, QDHEP2, QDHEE1, QDHEE2, QDHEE3,
     & QKEVRN, QKEVWT, QVXNOM, QVYNOM, QVZNOM, QVXNSG, QVYNSG, QVZNSG,
     & QINLUM, QRINLN, QRINLU, QDBOFS, QEECWI(36), QVXBOM, QVYBOM,
     & QSILUM, QRSLLU, QRSLBK, QRSLEW , QVTXBP(3), QVTEBP(3), QVTSBP(3)
      COMMON /QCDE/  KFOVT, KLOVT, KNOVT, KFCHT, KLCHT, KNCHT, KFIST,
     & KLIST, KNIST, KFAST, KLAST, KNAST, KFEHT, KLEHT, KNEHT, KFV0T,
     & KLV0T, KNV0T, KFDCT, KLDCT, KNDCT, KFEFT, KLEFT, KNEFT, KFNET,
     & KLNET, KNNET, KFGAT, KLGAT, KNGAT, KFJET, KLJET, KNJET, KFMCT,
     & KLMCT, KNMCT, KFREV, KLREV, KNREV, KFMCV, KLMCV, KNMCV, KLUST,
     & KLUSV, KFFRT, KLFRT, KFFRV, KLFRV, KNRET, KNCOT, KFFRD,
     & KLFJET,KLLJET,KLNJET
      COMMON /QCDE/ KBIT(32), KCLACO(KCQFPA), KCLAFR(KCQFPA), KCLARM
     & (KCQFPA), KDEBUG, KEVT, KEXP, KFFILL, KFEOUT, KJOPTN(2,2),
     & KLEOUT, KLROUT, KLOCK0(KLOCKM,2), KLOCK1(KLOCKM,2), KLOCK2(
     & KLOCKM,2), KMATIX(6,6), KMQFPA, KNEFIL, KNEOUT, KNEVT, KNPAST,
     & KNQDET, KNQFPA, KNQLIN, KNQMTX, KNQPAR, KNQPST, KNREIN, KNREOU,
     & KOQDET, KOQFPA, KOQLIN, KOQMTL, KOQMTS, KOQPAR, KOQPBT, KOQPLI,
     & KOQTRA, KOQVEC, KOQVRT, KQPAR, KQVEC, KQVRT, KQWRK, KQZER, KRUN,
     & KSTATU, KTDROP, KUCARD, KUCONS, KUHIST, KUINPU, KUOUTP, KUPRNT,
     & KUPTER, KDEBU1, KDEBU2, KNWRLM, KEFOPT, KUEDIN, KUEDOU, KURTOX,
     & KUCAR2, KNHDRN, KNBHAB, KSBHAB, KRSLLQ, KRSLNB
      COMMON /QCDE/ INDATA
      COMMON /QCDE/ KRINNE, KRINNF, KRINDC, KRINDQ, KRINNZ, KRINNB,
     & KRINBM, KRINFR, KRINLR, KRINLF
      COMMON /QCDE/ KEVERT, KEVEDA, KEVETI, KEVEMI(4), KEVETY, KEVEES,
     & KDHEFP, KDHENP, KDHENM, KKEVNT, KKEVNV, KKEVID, KDHENX, KDHENV,
     & KDHENJ, KREVDS, KXTET1, KXTET2, KXTEL2, KXTCGC, KXTCLL, KXTCBN,
     & KXTCCL, KXTCHV, KXTCEN, KCLASW, KERBOM, KBPSTA
      DIMENSION KLOCUS(3,14)
      EQUIVALENCE (KLOCUS(1,1),KFOVT), (KFOVT,KFRET), (KLIST,KLRET),
     & (KFIST,KFCOT), (KLAST,KLCOT)
      COMMON /QCDE/ XCOPYJ, XFLIAC, XHISTO, XLREV(2), XLREV2(2), XMCEV,
     & XMINI, XSYNTX, XWREVT, XWRRUN, XFILMC, XFILCH, XFILV0, XFILCO,
     & XFILEF, XFILPC, XFILGA, XFILJE,
     & XPRHIS, XFILL, XVITC, XVTPC, XVECAL, XVLCAL, XVTPCD,
     & XVSATR, XVHCAL, XHVTRG, XSREC, XWMINI, XIOKLU, XIOKSI, XFRF2,
     & XNSEQ, XVDOK, XFRF0, XFMUID, XFILEM, XWNANO, XROKSI, XGETBP,
     & XJTHRU
      LOGICAL XCOPYJ, XFLIAC, XHISTO, XLREV, XLREV2, XMCEV, XMINI,
     & XSYNTX, XWREVT, XWRRUN, XFILMC, XFILCH, XFILV0, XFILCO, XFILEF,
     & XFILPC, XPRHIS, XFILL, XVITC, XVTPC, XVECAL, XVLCAL, XVTPCD,
     & XVSATR, XVHCAL, XHVTRG, XSREC, XWMINI, XIOKLU, XFRF2, XFILJE,
     & XNSEQ, XFILGA, XVDOK, XFRF0, XFMUID, XFILEM, XWNANO, XIOKSI,
     & XROKSI, XGETBP, XJTHRU
C-------------------- /NANCOM/ --- NanoDst steering -------------------
C! XNANO   .TRUE. if input is a NanoDst (in NANO or EPIO format, dependi
C!                   XNANOR)
C!
      LOGICAL XNANO
      COMMON /NANCOM/XNANO
C--------------------- end of NANCOM ----------------------------------
      INTEGER LMHLEN, LMHCOL, LMHROW
      PARAMETER (LMHLEN=2, LMHCOL=1, LMHROW=2)
      INTEGER IW
      REAL RW(10000)
      COMMON /BCS/ IW(10000)
      EQUIVALENCE (RW(1),IW(1))
C------------------ /QCNAMI/ --- name indices -------------------------
      COMMON /QCNAMI/ NAAFID,NAAJOB,NAASEV,NABCNT,NABHIT,NABOMB,
     1 NABOME,NABOMP,NABOMR,NABPTR,NADCAL,NADCRL,NADECO,NADEID,NADENF,
     2 NADEVT,NADEWI,NADFMC,NADFOT,NADGAM,NADHCO,NADHEA,NADHRL,NADJET,
     3 NADMID,NADMJT,NADMUO,NADNEU,NADPOB,NADRES,NADTBP,NADTMC,NADTRA,
     4 NADVER,NADVMC,NAECRQ,NAECTE,NAEGID,NAEGPC,NAEIDT,NAEJET,NAERRF,
     5 NAETDI,NAETKC,NAEVEH,NAEWHE,NAFICL,NAFKIN,NAFPOI,NAFPOL,NAFRFT,
     6 NAFRID,NAFRTL,NAFSTR,NAFTCL,NAFTCM,NAFTOC,NAFTTM,NAFVCL,NAFVER,
     7 NAFZFR,NAHCCV,NAHCTE,NAHINF,NAHMAD,NAHPDI,NAHROA,NAHSDA,NAHTUB,
     8 NAIASL,NAIPJT,NAIRJT,NAITCO,NAITMA,NAIXTR,NAIZBD,NAJBER,NAJEST,
     9 NAJSUM,NAKEVH,NAKINE,NAKJOB,NAKLIN,NAKPOL,NAKRUN,NALIDT,NALOLE,
     A NALUPA,NAMCAD,NAMHIT,NAMTHR,NAMUDG,NAMUEX,NAOSTS,NAPART,NAPASL,
     B NAPCHY,NAPCOB,NAPCOI,NAPCPA,NAPCQA,NAPCRL,NAPECO,NAPEHY,NAPEID,
     C NAPEMH,NAPEPT,NAPEST,NAPEWI,NAPFER,NAPFHR,NAPFRF,NAPFRT,NAPHCO,
     D NAPHER,NAPHHY,NAPHMH,NAPHST,NAPIDI,NAPITM,NAPLID,NAPLPD,NAPLSD,
     E NAPMSK,NAPNEU,NAPPDS,NAPPOB,NAPPRL,NAPRTM,NAPSCO,NAPSPO,NAPSTR,
     F NAPT2X,NAPTBC,NAPTCO,NAPTEX,NAPTMA,NAPTML,NAPTNC,NAPTST,NAPVCO,
     G NAPYER,NAPYFR,NAPYNE,NAQDET,NAQFPA,NAQLIN,NAQMTL,NAQMTS,NAQPAR,
     H NAQPBT,NAQPLI,NAQTRA,NAQVEC,NAQVRT,NAQWRK,NAQZER,NAREVH,NARHAH,
     I NARTLO,NARTLS,NARUNH,NARUNR,NASFTR,NATEXS,NATGMA,NATMTL,NATPCO,
     J NAVCOM,NAVCPL,NAVDCO,NAVDHT,NAVDXY,NAVDZT,NAVERT,NAVFHL,NAVFLG,
     K NAVFPH,NAVHLS,NAVPLH,NAX1AD,NAX1SC,NAX1TI,NAX2DF,NAX3EC,NAX3EW,
     L NAX3HC,NAX3IT,NAX3L2,NAX3LU,NAX3TM,NAX3TO,NAX3TP,NAX3X3,NAXTBN,
     M NAXTBP,NAXTCN,NAXTEB,NAXTOP,NAXTRB,NAYV0V,NAZPFR,NAEFOL,NAMUID,
     N NAPGID,NAPGPC,NAPGAC,NAPMSC,NAPTHR,NANBIP,NAPDLT,NAPMLT,NAPLJT
C--------------------- end of QCNAMI ----------------------------------
C------------------ /QQQQJJ/ --- HAC parameters for ALPHA banks -------
      PARAMETER (JQVEQX= 1,JQVEQY= 2,JQVEQZ= 3,JQVEQE= 4,JQVEQM= 5,
     & JQVEQP= 6,JQVECH= 7,JQVETN= 8,JQVESC= 9,JQVEKS=10,JQVECL=11,
     & JQVEPA=12,JQVEQD=13,JQVENP=14,JQVESP=15,JQVEOV=16,JQVEEV=17,
     & JQVEND=18,JQVEDL=19,JQVENO=20,JQVEOL=21,JQVENM=22,JQVEML=23,
     & JQVEBM=24,JQVELK=38,JQVEDB=39,JQVEZB=40,JQVESD=41,JQVESZ=42,
     & JQVECB=43,JQVEEM=44,JQVECF=54,JQVEEW=55,JQVEUS=56)
      PARAMETER ( JQVRVX=1,JQVRVY=2,JQVRVZ=3,JQVRVN=4,JQVRTY=5,
     1   JQVRIP=6,JQVRND=7,JQVRDL=8,JQVRAY=9,JQVRAF=10,JQVREM=11,
     2   JQVRCF=17,JQVRET=18)
      PARAMETER ( JQDEAF= 1,JQDEAL= 2,JQDENT= 3,JQDEAT= 4,JQDELT= 8,
     &  JQDEAE= 9,JQDEAH=10,JQDEAM=11,JQDECF=12,JQDEEC=13,JQDEHC=14,
     &  JQDEET=15,JQDEFI=16,JQDENF=17,JQDEFL=18,JQDENE=19,JQDEEL=20,
     &  JQDENH=21,JQDEHL=22,JQDELH=23,JQDEEF=24,JQDEPC=25,JQDEEG=26,
     &  JQDEMU=27,JQDEDX=28,JQDEPG=29,JQDEPD=30,JQDEPM=31)
      PARAMETER ( JQPAGN=1, JQPANA=2, JQPACO=5, JQPAMA=6, JQPACH=7,
     & JQPALT=8,JQPAWI=9,JQPAAN=10)
C--------------------- end of QCDESH ----------------------------------
      DIMENSION PDUM(3),XDUM(3),XHEL(5),XCEN(2)
C - # of words/row in bank with index ID
      LCOLS(ID) = IW(ID+LMHCOL)
C - # of rows in bank with index ID
      LROWS(ID) = IW(ID+LMHROW)
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
C-----------------------------------------------------------------------
C
      JFKIN = IW(NAFKIN) + LMHLEN
      LFKIN = IW(JFKIN-1)
      JFVER = IW(NAFVER)
C
C MC particle section in QVEC :
C
      KNMCT = IW(JFKIN)
      KLMCT = KLMCT + KNMCT
      IF (KLMCT .GE. KLFRT)  CALL QSBANK ('QVEC', KLMCT + 200)
      JQVEC = KOQVEC + KFMCT * KCQVEC
      KFFRT = KLMCT + 1
C
      IF (KNQLIN+KNMCT .GE. IW(KOQLIN))
     &  CALL QSBANK ('QLIN',KNQLIN+KNMCT+500)
C
      JAJOB = IW(NAAJOB)
      NAVER = 9999
      IF (JAJOB .NE. 0)  NAVER  = ITABL (JAJOB,1,JAJOAV)
      ITK = KFMCT
      MAINMO = 0
      DO 10 IGA = 1, KNMCT
C
C         basic track attributes
C
        RW(JQVEC+JQVEQX) = RW(JFKIN+JFKIPX)
        RW(JQVEC+JQVEQY) = RW(JFKIN+JFKIPY)
        RW(JQVEC+JQVEQZ) = RW(JFKIN+JFKIPZ)
        RW(JQVEC+JQVEQP) = SQRT (RW(JQVEC+JQVEQX)**2 +
     &     RW(JQVEC+JQVEQY)**2 + RW(JQVEC+JQVEQZ)**2)
C
C         Particle code and charge
C
      KVTEST=MOD(KEVERT,10000)
        IPC = KMCCOD (IW(JFKIN+JFKIPA))
        RW(JQVEC+JQVECH) = RW(KOQPAR+IPC*KCQPAR+JQPACH)
        IW(JQVEC+JQVEPA) = IPC
        IFP = IW(KOQPLI+IPC)
        IF (IFP .EQ. 0)  IFP = KFPADR (IPC)
        IW(JQVEC+JQVENP) = IW(KOQFPA+IFP*KCQFPA+2)
        IW(KOQFPA+IFP*KCQFPA+2) = ITK
C
C Be careful to deal correctly w/ mass and energy since the banks
C KINE and FKIN store mass, not energy, in ALEPHLIB versions > 9.0
        IF (NAVER .LT. 90)  THEN
C
C Fill in mass. Either from en-mom or from ALEPH part. table
C Future : mass has to be stored in FKIN and taken from there !!!
C The following statements may cause problems (accuracy) !!!
C
          RW(JQVEC+JQVEQE) = RW(JFKIN+JFKIMA)
          RW(JQVEC+JQVEQM) = RW(KOQPAR+IPC*KCQPAR+JQPAMA)
          IF (( RW(JQVEC+JQVEQM) .GE. 0.0005 .AND.
     +       (RW(JQVEC+JQVEQP) / RW(JQVEC+JQVEQM)) .LT. 500.))
     +       RW(JQVEC+JQVEQM) = SQRT (AMAX1
     +       ((RW(JQVEC+JQVEQE) + RW(JQVEC+JQVEQP)) *
     +       (RW(JQVEC+JQVEQE) - RW(JQVEC+JQVEQP)), 0.))
        ELSE
          RW(JQVEC+JQVEQM) = RW(JFKIN+JFKIMA)
          RW(JQVEC+JQVEQE) = SQRT(RW(JQVEC+JQVEQP)**2 +
     &        RW(JQVEC+JQVEQM)**2)
        ENDIF

C
        IW(JQVEC+JQVETN) = IGA
        IW(JQVEC+JQVESC) = 0
        IW(JQVEC+JQVECL) = 2
        IW(JQVEC+JQVEQD) = KOQDET
        IW(JQVEC+JQVESP) = ITK
C
C         Origin and end vertex of track
C
        IF (IW(JFKIN+JFKIOV) .EQ. 0)  THEN
          IW(JQVEC+JQVEOV) = 0
        ELSE
          IW(JQVEC+JQVEOV) = IW(JFKIN+JFKIOV) + KFMCV - 1
        ENDIF
        IF (IW(JFKIN+JFKIEV) .EQ. 0)  THEN
          IW(JQVEC+JQVEEV) = 0
        ELSE
          IW(JQVEC+JQVEEV) = IW(JFKIN+JFKIEV) + KFMCV - 1
        ENDIF
C
C         mother - daughter - mother relation
C
        IW(JQVEC+JQVEND) = 0
        IW(JQVEC+JQVENO) = 0
        IW(JQVEC+JQVENM) = 0
        IM2=0
C Take account of the different history codes for Herwig events
        IF (KVTEST/100.EQ.51) THEN
          IMCODE = IW(JFKIN+JFKIHC)
          IHIST = IMCODE / 1000000
          IW(JQVEC+JQVEKS) = IHIST
          IHIST =  IHIST - (IHIST/100)*100
          IMCODE = IMCODE - IW(JQVEC+JQVEKS)*1000000
        ELSE
          IW(JQVEC+JQVEKS) = IW(JFKIN+JFKIHC) / 10000
        ENDIF
        IF (IGA .LE. KKEVNT)  THEN
C Herwig events can have particles with 2 mothers
          IF (KVTEST/100.EQ.51) THEN
            IM2 = IMCODE / 1000
            IM = IMCODE - IM2*1000
C Patch to stop initial state gammas being their own mother and
C force Z0 to be mother of initial partons
            IF(IM.EQ.0.AND.MAINMO.EQ.0.AND.IHIST.EQ.20) MAINMO=IGA
            IF(IM.NE.0.AND.MAINMO.EQ.0) IM=0
            IF(IM.EQ.1) IM=IM+MAINMO-1
          ELSE
            IM = MOD (IW(JFKIN+JFKIHC) , 10000)
          ENDIF
          IF (IM .NE. 0)  THEN
            IW(JQVEC+JQVENO) = 1
            IW(JQVEC+JQVEOL) = KNQLIN
            KNQLIN = KNQLIN + 1
            IW(KOQLIN+KNQLIN) = IM + KFMCT - 1
C add in 2nd mother if there
            IF (IM2.NE. 0)  THEN
              IW(JQVEC+JQVENO) = 1 + IW(JQVEC+JQVENO)
              KNQLIN = KNQLIN + 1
              IW(KOQLIN+KNQLIN) = IM2+ KFMCT - 1
            ENDIF
          ENDIF
        ELSE
C We turn to the FVER bank to get the history
          IM = IW(JFKIN+JFKIOV)
          IF (IM .NE. 0)  THEN
            IM = IW(KOQVRT+(IM+KFMCV)*KCQVRT+JQVRIP-KCQVRT)
            IF (IM .NE. 0)  THEN
              IW(JQVEC+JQVENO) = 1
              IW(JQVEC+JQVEOL) = KNQLIN
              KNQLIN = KNQLIN + 1
              IW(KOQLIN+KNQLIN) = IM
            ENDIF
          ENDIF
        ENDIF
C
        RW(JQVEC+JQVEEM) = -1.
        RW(JQVEC+JQVECF) = -1.
        DO 9 IB=1,KLOCKM
          IW(JQVEC+JQVEBM+IB-1) = 0
9       CONTINUE
        IW(JQVEC+JQVELK) = 0
C
        RW(JQVEC+JQVEDB) = 0.
        RW(JQVEC+JQVEZB) = 0.
C Compute D0 and Z0 if MC track has an Origin Vertex
C And if ABS(Q) >= 1
C And if PT .ne. 0.
        IF( IW(JFKIN+JFKIOV).NE.0 .AND. QMFLD.NE.0. .AND.
     &      ABS(RW(JQVEC+JQVECH)).GE.1. ) THEN
          PDUM(1) = RW(JFKIN+JFKIPX)
          PDUM(2) = RW(JFKIN+JFKIPY)
          IF (ABS(PDUM(1)).GT.1.E-10 .OR. ABS(PDUM(2)).GT.1.E-10) THEN
             XDUM(1) = RTABL(JFVER,IW(JFKIN+JFKIOV),JFVEVX)
             XDUM(2) = RTABL(JFVER,IW(JFKIN+JFKIOV),JFVEVY)
             XDUM(3) = RTABL(JFVER,IW(JFKIN+JFKIOV),JFVEVZ)
             PDUM(3) = RW(JFKIN+JFKIPZ)
             CHRG = RW(JQVEC+JQVECH)
             CALL TNRHPA(PDUM,XDUM,CHRG,QMFLD,XHEL,XCEN,DUMMY)
             RW(JQVEC+JQVEDB) = XHEL(4)
             RW(JQVEC+JQVEZB) = XHEL(5)
          ENDIF
        ENDIF
C
        RW(JQVEC+JQVESD) = 0.
        RW(JQVEC+JQVESZ) = 0.
        RW(JQVEC+JQVECB) = 0.
        RW(JQVEC+JQVEEW) = 0.
C
        ITK = ITK + 1
        JFKIN = JFKIN + LFKIN
   10 JQVEC = JQVEC + KCQVEC
C
      END
