      SUBROUTINE MINTRA
C
CKEY MDST /INTERNAL
C-----------------------------------------------------------------------
C! Fill track bank DTRA for Mini-DST.
C
C     Author: Stephen Haywood      22-Jan-90
C
C     Input  : FRFT,PYFR,YV0V,FRID,dE/dx banks
C     Output : DTRA bank
C
C     Called by MINDST
C
C     If the card FRF0 is present, the fit FRFT/0 without the VDET is
C     used.
C     Track quality is obtained from FRID. For old data, a call to
C     UFITQL is made - this requires FRFT, FRTL and YV0V.
C     Unlike the original version of this routine, FRFT is now used
C     rather than PFRF because of changes to error matrix.
C     Vdet hit information is obtained by a call to VDHITS and VDAMB.
C-----------------------------------------------------------------------
C
      INTEGER LMHLEN, LMHCOL, LMHROW
      PARAMETER (LMHLEN=2, LMHCOL=1, LMHROW=2)
C
      COMMON /BCS/   IW(1000)
      INTEGER IW
      REAL RW(1000)
      EQUIVALENCE (RW(1),IW(1))
C
      REAL PI, TWOPI, PIBY2, PIBY3, PIBY4, PIBY6, PIBY8, PIBY12
      REAL RADEG, DEGRA
      REAL CLGHT, ALDEDX
      INTEGER NBITW, NBYTW, LCHAR
      PARAMETER (PI=3.141592653589)
      PARAMETER (RADEG=180./PI, DEGRA=PI/180.)
      PARAMETER (TWOPI = 2.*PI , PIBY2 = PI/2., PIBY4 = PI/4.)
      PARAMETER (PIBY6 = PI/6. , PIBY8 = PI/8.)
      PARAMETER (PIBY12= PI/12., PIBY3 = PI/3.)
      PARAMETER (CLGHT = 29.9792458, ALDEDX = 0.000307)
      PARAMETER (NBITW = 32 , NBYTW = NBITW/8 , LCHAR = 4)
C
      PARAMETER (CFACT=CLGHT/100000.)
      PARAMETER (AFACTM=10000.,DFACTM=10000.,EFACTM=1000.)
*     PARAMETER (AFACTM=100000.,DFACTM=100000.,EFACTM=10000.)
      PARAMETER(JFRFIR=1,JFRFTL=2,JFRFP0=3,JFRFD0=4,JFRFZ0=5,JFRFAL=6,
     +          JFRFEM=7,JFRFC2=28,JFRFDF=29,JFRFNO=30,LFRFTA=30)
      PARAMETER(JPFRIR=1,JPFRTL=2,JPFRP0=3,JPFRD0=4,JPFRZ0=5,JPFRAL=6,
     +          JPFREO=7,JPFREM=13,JPFRC2=28,JPFRNO=29,LPFRFA=29)
      PARAMETER(JZPFC1=1,JZPFC2=2,LZPFRA=2)
      PARAMETER(JPYFTN=1,JPYFVN=2,LPYFRA=2)
      PARAMETER(JYV0K1=1,JYV0K2=2,JYV0VX=3,JYV0VY=4,JYV0VZ=5,JYV0VM=6,
     +          JYV0PX=12,JYV0PY=13,JYV0PZ=14,JYV0PM=15,JYV0X1=21,
     +          JYV0X2=22,JYV0XM=23,JYV0C2=26,JYV0IC=27,JYV0P1=28,
     +          JYV0P2=31,JYV0EP=34,JYV0DM=55,JYV0S1=56,JYV0S2=57,
     +          LYV0VA=57)
      PARAMETER(JFRIBP=1,JFRIDZ=2,JFRIBC=3,JFRIDC=4,JFRIPE=5,JFRIPM=6,
     +          JFRIPI=7,JFRIPK=8,JFRIPP=9,JFRINK=10,JFRIQF=11,
     +          LFRIDA=11)
      PARAMETER(JDTRCH=1,JDTRP0=2,JDTRTH=3,JDTRPH=4,JDTRD0=5,JDTRZ0=6,
     +          JDTRER=7,JDTRTF=12,JDTRHO=13,JDTRHM=14,JDTRVB=15,
     +          JDTRQF=16,JDTREA=17,JDTRVI=27,LDTRAA=27)
C
      LOGICAL FIRST,XFRID,PACK
      INTEGER UFITQL,GTSTUP
      PARAMETER (MXTRA=400)
      DIMENSION INFOV(MXTRA)
      DIMENSION CMPK(15),INDXE(5),INDXA(10)
      DATA INDXE / 1,  3,    6,      10,            15 /
      DATA INDXA /   2,  4,5,  7,8,9,   11,12,13,14    /
      DATA C1,HC2, UNDFL / 0.1,2500., -20. /
      DATA FIRST / .TRUE. /
      SAVE INDXE,INDXA,C1,HC2,UNDFL,FIRST,NR
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
C++   Initialisation.
C
      IF(FIRST) THEN
C
C++      Determine which FRFT bank to use. Default is with Vdet.
C++      If FRF0 is given, no swap is made in ALPHA and FRFT/0 exists.
C++      For pre-1991 (data and MC), force FRFT/0. Since the FRFT/2 bank
C++      is unusable, drop it to be sure. FRFT/0 will appear as FRFT/3.
C
         IF(NLINK('FRF0',0).LE.0) THEN
            NR = 2
         ELSE
            NR = 0
         ENDIF
         CALL ABRUEV(IRUN,IEVT)
         IF (GTSTUP('VD',IRUN).LE.2) KFRFT = NDROP('FRFT',2)
         FIRST = .FALSE.
      ENDIF
C
C++   Ensure FRFT bank is unpacked from PFRF.
C
      KFRFT = IW(NAMIND('FRFT'))
      IF(KFRFT.LE.0) CALL FPTOJ('  ',IER)
      KFRFT = NLINK('FRFT',NR)
      IF(KFRFT.LE.0) KFRFT = IW(NAMIND('FRFT'))
C
C++   Identify the number of tracks.
C++   If no tracks, return without creating DTRA bank.
C
      IF(KFRFT.LE.0) RETURN
      NFRFT = LROWS(KFRFT)
      IF(NFRFT.LE.0) RETURN
      NDTRA = NFRFT
      IR = IW(KFRFT-2)
      IRM = IR
      IF(IR.EQ.3) IRM = 0
      KPFRF = NLINK('PFRF',IRM)
C
C++   Create the DTRA bank.
C
      LEN = LMHLEN + LDTRAA * NDTRA
      CALL AUBOS('DTRA',IRM,LEN, KDTRA,IGARB)
      IF(IGARB.GE.2) THEN
         WRITE(IW(6),'('' MINTRA: Cannot create DTRA bank'')')
         RETURN
      ELSE IF(IGARB.NE.0) THEN
         KFRFT = NLINK('FRFT',IR)
      ENDIF
      IW(KDTRA+LMHCOL) = LDTRAA
      IW(KDTRA+LMHROW) = NDTRA
C
C++   Pick up other useful banks.
C
      KFRID = NLINK('FRID',0)
C
C++   Check whether FRID contains track quality.
C
      IF(LCOLS(KFRID).GE.JFRIQF) THEN
         XFRID = .TRUE.
      ELSE
         XFRID = .FALSE.
      ENDIF
C
C++   Get the magnetic field - use ALEPHLIB routine.
C++   The -ve sign corresponds to the definition of 1/R.
C++   To obtain momenta, this is multiplied by speed of light.
C
      BFACT = - ALFIEL(DUMMY) * CFACT
      IF(BFACT.EQ.0.) BFACT = - 15. * CFACT
C
C++   Loop over the FRFT bank and fill the DTRA bank.
C
      DO 100 I=1,NFRFT
C
C++      Track parameters.
C
         RHO = RTABL(KFRFT,I,JFRFIR)
         TANL = RTABL(KFRFT,I,JFRFTL)
         SECL = SQRT(1.+TANL**2)
         P = BFACT * SECL / RHO
         IW(KROW(KDTRA,I)+JDTRCH) = NINT( SIGN(1.,P) )
         IW(KROW(KDTRA,I)+JDTRP0) = NINT(EFACTM * ABS(P))
         IW(KROW(KDTRA,I)+JDTRTH) = NINT(AFACTM * (PIBY2 - ATAN(TANL)))
         IW(KROW(KDTRA,I)+JDTRPH) = NINT(AFACTM * RTABL(KFRFT,I,JFRFP0))
         IW(KROW(KDTRA,I)+JDTRD0) = NINT(DFACTM * RTABL(KFRFT,I,JFRFD0))
         IW(KROW(KDTRA,I)+JDTRZ0) = NINT(DFACTM * RTABL(KFRFT,I,JFRFZ0))
C
C++      Error matrix:
C++      In the past, a much reduced error matrix was saved. This was
C++      unsatisfactory for vertexing, so now the approach is similar
C++      to that used for the POT packing.
C++      If the new PFRF bank exists, this can be used directly.
C
         IF (KPFRF.GT.0) THEN
            PACK = (ITABL(KPFRF,I,JPFRNO)/100000).NE.0
         ELSE
            PACK = .FALSE.
         ENDIF
         IF(KPFRF.GT.0 .AND. PACK) THEN
C
C++         Obtain compression factors.
C
            KZPFR = NLINK('ZPFR',0)
            IF(KZPFR.GT.0) THEN
               CF1 = RTABL(KZPFR,1,JZPFC1)
               CF2 = RTABL(KZPFR,1,JZPFC2)
            ELSE
               CF1 = 100.
               CF2 = 100.
            ENDIF
C
C++         Save the eigen-values with reduced precision, as logarithms.
C
            DO J=1,5
               EVAL = RTABL(KPFRF,I,JPFREO+J-1)
               IF (EVAL.GT.0.) THEN
                  IEVAL = NINT( ALOG(EVAL) / C1 )
               ELSE
                  IEVAL = NINT( UNDFL      / C1 )
               ENDIF
               IW(KROW(KDTRA,I)+JDTRER+J-1) = IEVAL
            ENDDO
C
C++         Save the integerised Euler-angles.
C++         Note, factor should be commensurate with that used for POT.
C
            DO J=1,10
               ANGL = (FLOAT(ITABL(KPFRF,I,JPFREM+J-1)) - CF2) / CF1
               IW(KROW(KDTRA,I)+JDTREA+J-1) = NINT( HC2 * ANGL + HC2 )
            ENDDO
         ELSE
            KADDR = KROW(KFRFT,I) + JFRFEM
            CALL FPKCM(RW(KADDR), CMPK)
C
C++         Save the eigen-values with reduced precision, as logarithms.
C
            DO J=1,5
               EVAL = CMPK(INDXE(J))
               IF (EVAL.GT.0.) THEN
                  IEVAL = NINT( ALOG(EVAL) / C1 )
               ELSE
                  IEVAL = NINT( UNDFL      / C1 )
               ENDIF
               IW(KROW(KDTRA,I)+JDTRER+J-1) = IEVAL
            ENDDO
C
C++         Save the integerised Euler-angles.
C
            DO J=1,10
               ANGL = CMPK(INDXA(J))
               IW(KROW(KDTRA,I)+JDTREA+J-1) = NINT( HC2 * ANGL + HC2 )
            ENDDO
         ENDIF
C
C++      Track fit probability.
C
         CHISQ = RTABL(KFRFT,I,JFRFC2)
         NDEG = ITABL(KFRFT,I,JFRFDF)
         IF(NDEG.GT.0) THEN
            CHIN = CHISQ / FLOAT(NDEG)
         ELSE
            CHIN = 0.
         ENDIF
         IW(KROW(KDTRA,I)+JDTRTF) = NINT(10.*CHIN)
C
C++      Hit pattern in tracking chambers - observed and missing.
C
         IF(KFRID.GT.0) THEN
            IW(KROW(KDTRA,I)+JDTRHO) = ITABL(KFRID,I,JFRIBP)
            IW(KROW(KDTRA,I)+JDTRHM) = ITABL(KFRID,I,JFRIDZ)
         ENDIF
C
C++      Obtain track quality.
C
         IF(XFRID) THEN
            IFLAG = ITABL(KFRID,I,JFRIQF)
         ELSE
            IFLAG = UFITQL(I)
         ENDIF
         IW(KROW(KDTRA,I)+JDTRQF) = IFLAG
C
  100 CONTINUE
C
C++   Vertex bit map.
C
      CALL MINFVB(KDTRA)
C
C++   Vdet information.
C
      CALL VDHITS(INFOV,MXTRA)
      CALL VDAMB (INFOV,MXTRA)
      DO 700 I=1,NFRFT
  700 IW(KROW(KDTRA,I)+JDTRVI) = INFOV(I)
C
C++   Add the bank to the Mini list.
C
      CALL MINLIS('DTRA')
C
      RETURN
      END