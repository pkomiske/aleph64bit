      SUBROUTINE QMNEWR (IROLD,IRNEW)
CKEY RUN /INTERNAL
C----------------------------------------------------------------------
C! called for new run
C! called from QMREAD,QMTERM
C!                                         Author: H.Albrecht 20.09.88
C!                                       Modified: E.Blucher  03.08.90
C!                                       Modified: J.Boucrot  03.05.93
C!                                       Modified: G.Graefe   10.02.95
C!                                       Modified: S.Wasserb. 10.05.95
C----------------------------------------------------------------------
      SAVE IRPAST,IMD93
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
      PARAMETER(JJSUNT=1,JJSUNV=2,JJSUNZ=3,JJSUNL=4,JJSUNB=5,JJSUVT=6,
     +          JJSUVV=7,JJSUVZ=8,JJSUVL=9,JJSUVB=10,JJSUTT=11,
     +          JJSUTZ=12,JJSUTB=13,JJSULI=14,JJSUIZ=15,JJSULO=16,
     +          JJSULZ=17,JJSUXV=18,JJSUYV=19,JJSUZV=20,JJSUXS=21,
     +          JJSUYS=22,JJSUZS=23,JJSUKB=24,JJSUKW=25,JJSUTN=26,
     +          JJSUTS=27,JJSUTV=28,JJSUA0=29,JJSUA1=30,JJSUA2=31,
     +          JJSUA3=32,JJSUA4=33,JJSUA5=34,JJSUA6=35,JJSUA7=36,
     +          JJSUA8=37,JJSUA9=38,JJSUB0=39,JJSUB1=40,JJSUB2=41,
     +          JJSUB3=42,JJSUB4=43,JJSUB5=44,JJSUB6=45,JJSUB7=46,
     +          JJSUB8=47,JJSUB9=48,LJSUMA=48)
      PARAMETER(JKJOJD=1,JKJOJT=2,JKJOAV=3,JKJODV=4,JKJODC=5,LKJOBA=5)
      INTEGER JRHAPN,JRHAPD,JRHAPH,JRHAPV,JRHAAV,JRHADV,JRHADD,JRHANI,
     +          JRHANO,JRHACV,JRHANU,LRHAHA
      PARAMETER(JRHAPN=1,JRHAPD=3,JRHAPH=4,JRHAPV=5,JRHAAV=6,JRHADV=7,
     +          JRHADD=8,JRHANI=9,JRHANO=10,JRHACV=11,JRHANU=12,
     +          LRHAHA=12)
      PARAMETER(JRLELE=1,JRLELB=2,JRLELD=3,JRLELF=4,JRLELP=5,LRLEPA=5)
      COMMON / SCALMO / ISCP93,SCPF93
      CHARACTER CHAINT*4,PROGN*4
      DIMENSION XYZ(3),DXYZ(3),XYZL(3),DXYZL(3),XYZR(3),DXYZR(3)
      DIMENSION IRPAST(3)
      DATA IRPAST/0,0,0/
      DATA IFR93,ILR93,IMIVR,IAL94 / 20000 , 23546 , 90 , 157  /
      DATA IMD93 ,SCP93 / 0 , 0.996433 /
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
C----------------------------------------------------------------------
C
      KRUN = IRNEW
      IF (XCOPYJ)  GO TO 90
      IF (IRNEW .EQ. 0)  GO TO 80
      IF (KDEBUG .GT. 0)  CALL PRRHAH
C
C       ext. particle table
C
      LPART = IW(NAPART)
      IF (LPART .EQ. 0)  GO TO 40
C
C       get number of standard particles in PART
C
      NAM1 = INTCHA ('last')
      NAM2 = INTCHA ('_st_')
      NAM3 = INTCHA ('part')
      IADR = LPART + LMHLEN
      DO 10 KNPAST=1,IW(LPART+2)
        IF (IW(IADR+JQPANA) .EQ. NAM1 .AND.
     &      IW(IADR+JQPANA+1) .EQ. NAM2 .AND.
     &      IW(IADR+JQPANA+2) .EQ. NAM3)  GO TO 20
   10 IADR = IADR + IW(LPART+1)
      KNPAST = 0
C
C       reset particle transformation table (MC <-> int. code)
C
   20 DO 30 I = KOQTRA+1, KOQTRA+IW(KOQTRA)
C         don't reset particles set by a PTRA card !
        IF (IAND (IW(KOQPBT+IW(I)), KBIT(5)) .EQ. 0)  IW(I) = 0
   30 CONTINUE
C
C       length of particle transformation table
C
      IF (IW(LPART+2) .GE. IW(KOQTRA))
     &  CALL QSBANK ('QTRA', IW(LPART+2))
C Fix the syntax of some neutral antiparticles as given by KINGAL
C to make them understandable by ALPHA
      CALL FIXPART
C
C       run information banks RLUM and LFIL
C
   40 JJSUM = IW(NAJSUM)
      IF (JJSUM .NE. 0)  THEN
        KRINNE = IW(JJSUM+LMHLEN+JJSUVT)
      ENDIF
      CALL GETLEP(KRUN,IOKLE,KRINLF,INV,QELEP,XYZL,DXYZL)
      CALL GETOFS(KRUN,OFSL)
C
C Beam position from bank 'RXYZ'
C
      CALL GETXYB(KRUN,IOKRU,IFLGR,XYZR,DXYZR,OFSR,VLUM)
C Set status word to tell which kind of beam position is found :
      KBPSTA=0
      IF (IOKLE.GT.0) KBPSTA=3
      IF (IOKLE.GT.0.AND.IOKRU.EQ.1.AND.IFLGR.EQ.-1) KBPSTA=2
      IF (IOKRU.EQ.1.AND.IFLGR.EQ.1) KBPSTA=1
      IF (IFLGR.EQ.-1) IOKRU=0
C
C   Decide which beam position will be used
C
      DO 41 IR=1,3
         XYZ(IR)=0.
 41   DXYZ(IR)=0.
      QDBOFS=0.
      IF (IOKRU.EQ.1) THEN
         CALL UCOPY(XYZR,XYZ,3)
         CALL UCOPY(DXYZR,DXYZ,3)
         QDBOFS=OFSR
         GO TO 42
      ENDIF
      IF (IOKLE.NE.0) THEN
         CALL UCOPY(XYZL,XYZ,3)
         CALL UCOPY(DXYZL,DXYZ,3)
         QDBOFS=OFSL
      ENDIF
 42   IFROK=1
      IF (IOKRU.EQ.0.AND.(IOKLE.EQ.0.OR.(IOKLE.GT.0.AND.INV.LE.2)))
     +    IFROK=0
      IF (IFROK.EQ.0) THEN
         KRINLF=0
        QVXNOM = 0.
        QVYNOM = 0.
        QVZNOM = 0.
        QVXNSG = 1.
        QVYNSG = 1.
        QVZNSG = 4.
        QDBOFS = 0.
      ELSE
        QVXNOM=XYZ(1)
        QVYNOM=XYZ(2)
        QVZNOM=XYZ(3)
        QVXNSG=DXYZ(1)
        QVYNSG=DXYZ(2)
        QVZNSG=DXYZ(3)
      ENDIF
      CALL BDROP(IW,'JCAR')

C Fix beam position banks ALPB:
      CALL FIXALPB(KRUN)
C LCAL Luminosity :
      CALL GETLUM(KRUN,IOKLU,KRINDQ,KRINNZ,KRINNB,QRINLU,BK,BT)
      IF (IOKLU.NE.0) GO TO 46
C Nothing found in the Database for LCAL Lumi :
   45 CONTINUE
      KRINNE = 0
      KRINDC = 0
      KRINDQ = 0
      QRINLN = 0.
      QRINLU = 0.
      KRINNZ = 0
      KRINNB = 0
      KRINBM = 0
      KRINFR = KRUN
      KRINLR = KRUN
C---If not MC, print warning if some run information banks were missing.
   46 IF(IOKLU.NE.1.OR.IOKLE.NE.1)THEN
        IF (KRUN .GT. 2000)  CALL QWMESE
     +    ('_QMNEWR_ Some run information banks not available')
      ENDIF
C
C SICAL Luminosity :
      CALL GETSLU(KRUN,IOKSI,KRSLLQ,KRSLNB,QRSLLU,QRSLBK,QRSLEW)
      IF (IOKSI.NE.0) GO TO 48
C Nothing found in the Database for SICAL Lumi :
      KRSLNB = 0
      KRSLLQ = 0
      QRSLLU = 0.
      QRSLBK = 0.
      QRSLEW = 0.
 48   CONTINUE
C   keep luminosity, bhabha, and Z totals
C   protect against errors causing QMNEWR to be called more than once
C   for the same run.  Totals are updated only if run number was not
C   one of the last three runs to be encountered.
C
      IF (KRUN.GT.2000.AND.KRUN.LT.16500) THEN
         IF (IOKLU.NE.1) XIOKLU=.FALSE.
         IF (QRINLU.LE.0.) THEN
            XIOKLU = .FALSE.
            WRITE ( KUPRNT , 1011 ) KRUN
         ENDIF
         IF (KRUN.GT.16500) THEN
            XROKSI=.TRUE.
            IF (IOKSI.NE.1) XIOKSI=.FALSE.
            IF (QRSLLU.LE.0.) THEN
               XIOKSI = .FALSE.
               WRITE ( KUPRNT , 1021 ) KRUN
            ENDIF
         ENDIF
         ISKIP=0
         DO 75 I = 1,3
           IF (KRUN.EQ.IRPAST(I)) ISKIP=1
   75    CONTINUE
         IF(ISKIP.EQ.0)THEN
            IRPAST(1) = IRPAST(2)
            IRPAST(2) = IRPAST(3)
            IRPAST(3) = KRUN
            QINLUM = QINLUM + QRINLU
            KNHDRN = KNHDRN + KRINNZ
            KNBHAB = KNBHAB + KRINNB
            QSILUM = QSILUM + QRSLLU
            KSBHAB = KSBHAB + KRSLNB
         ENDIF
      ENDIF
      IF (KRINLF.EQ.0) THEN
         JRLEP=IW(NAMIND('RLEP'))
         IF (JRLEP.GT.0) KRINLF=ITABL(JRLEP,1,JRLELF)
      ENDIF
C
C--- Get BOM constants
C
      CALL QBOMRU
C
   60 QMFLD = ALFIEL (QMFLD)
      IF (QMFLD .LT. -20. .OR. QMFLD .GT. 20.)  THEN
        WRITE (KUPRNT,1001)  QMFLD
        IF (KUPTER .NE. 0)  WRITE (KUPTER,1001)  QMFLD
      ENDIF
      QMFLDC = QMFLD * QQIRP
C
C For all MINIs of 1993 data made before a correct reprocessing in 1994
C with MINI  version 90 and ALEPHLIB version 15.6 and before ,
C all particle momenta must be scaled ( a wrong BFIELD was used ) :
C
      ISCP93 = 0
      SCPF93 = SCP93
      IF (KRUN.LT.IFR93.OR.KRUN.GT.ILR93) GO TO 78
      JRHAH=IW(NARHAH)
      IF (JRHAH.GT.0) THEN
         DO 77 IRH = LROWS(JRHAH),1,-1
            KRHAH = KROW(JRHAH,IRH)
            PROGN = CHAINT(IW(KRHAH+JRHAPN))
            IF (INDEX(PROGN,'MIN').EQ.0) GO TO 77
            IF (IW(KRHAH+JRHAPV).NE.IMIVR) GO TO 77
            IF (IW(KRHAH+JRHAAV).GE.IAL94) GO TO 77
            ISCP93 = 1
            GO TO 78
 77      CONTINUE
      ENDIF
 78   IF (ISCP93.EQ.1) THEN
         IMD93 = IMD93 + 1
         IF (IMD93.EQ.1) WRITE ( KUPRNT,1023 ) SCP93
      ENDIF
C
C   QMUIDO initialization
C
      CALL QMUNEW
C
C   YTOP Initialization
C
      CALL YTOIRU(IRNEW,QMFLD)
C
C
C  QSELEP initialization
C
      CALL QLINIT
      CALL BLIST(IW,'C+','PLSC')
      CALL BLIST(IW,'R+','PLSC')
C
C Initialise the VDET geometry for the current run :
C ( but not for 1989/1990 Real Data ! )
C
      IF (KRUN.GT.2000.AND.KRUN.LE.9114) GO TO 79
      CALL VRDDAF(KUCONS,IRNEW,IFLAG)
      CALL VGRDAL(KUCONS,IRNEW,IFLAG)
 79   CONTINUE
C
C   NanoDST Initialization
C
      IF(XWNANO)CALL QNNEWR(IROLD,IRNEW)
C
   80 CALL QUNEWR (IROLD,IRNEW)
C Provisional correction for LEP 1.5 data of 1995 :
C use by default as FRFT NR = 0 the tracks without VDET
C unless a 'FRF2' data card is provided :
      IFRF2=IW(NAMIND('FRF2'))
      IF (KRUN.GT.40200.AND.KRUN.LT.40600) THEN
         IF (IFRF2.EQ.0) THEN
            XFRF0=.TRUE.
            XFRF2=.FALSE.
         ELSE
            XFRF0=.FALSE.
            XFRF2=.TRUE.
         ENDIF
      ENDIF
C
C----------------------------------------------------------------------
 1001 FORMAT ('0_QMNEWR_ Caution : Mag. field is',G14.4,
     +        '; set to 15.')
 1011 FORMAT ('0_QMNEWR_ Warning ! LCAL Luminosity NOT KNOWN ',
     +        ' for run :',I7)
 1021 FORMAT ('0_QMNEWR_ Warning ! SICAL Luminosity NOT KNOWN ',
     +        ' for run :',I7)
 1023 FORMAT ('0_QMNEWR_ 1993 data : Scale factor applied for all ',
     +        'charged tracks : ',F9.6)
   90 CONTINUE
      END
