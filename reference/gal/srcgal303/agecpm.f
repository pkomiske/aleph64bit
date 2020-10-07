      SUBROUTINE AGECPM(IFL)
C ------------------------------------------
C B. Bloch-Devaux   november 87
C!Implement passive material related to ECAL
C
C  IFL  : 1 Passive material in ECEA (B) volumes
C         2 Passive material in HCEA (B) volumes
C Note: the numbers explicitly in the code will be
C      removed when better known and thus included
C      in the Data Base
C ------------------------------------------------
      PARAMETER ( NLIMR = 9 , NLIMZ = 6)
      COMMON / AGECOM / AGLIMR(NLIMR),AGLIMZ(NLIMZ),IAGFLD,IAGFLI,IAGFLO
      COMMON/ALFGEO/ALRMAX,ALZMAX,ALFIEL,ALECMS
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
      PARAMETER  (D360=TWOPI*RADEG   ,D180=PI*RADEG   ,D90=0.5*D180)
      PARAMETER  (D45=0.5*D90   ,D15=D45/3.   ,D210=7.*D90/3.)
      PARAMETER  (D225=D180+D45   ,D270=D180+D90  ,D7P5=0.5*D15)
      PARAMETER(LSENV=30)
      PARAMETER (LIMVOL=17)
C
      COMMON/AGCONS/ IAGROT,IAGMAT,IAGMED,IAGFHB,IAGSLV,IAGSEN(LSENV,2)
     2      , NAGIMP,LAGIMP(3,LIMVOL)
C
       COMMON /WRKSPC/ WSPACE(88320)
      PARAMETER (LPTAB=50)
      DIMENSION PTAB(LPTAB),JTAB(LPTAB)
      EQUIVALENCE (PTAB(1),JTAB(1),WSPACE(1))
C
      INTEGER LMHLEN, LMHCOL, LMHROW
      PARAMETER (LMHLEN=2, LMHCOL=1, LMHROW=2)
C
      COMMON /BCS/   IW(1000)
      INTEGER IW
      REAL RW(1000)
      EQUIVALENCE (RW(1),IW(1))
C
      PARAMETER(JPMGID=1,JPMGVR=2,JPMGNA=4,JPMGRI=8,JPMGRO=9,JPMGZN=10,
     +          JPMGZX=11,JPMGPN=12,JPMGPX=13,JPMGNM=14,LPMG1A=14)
      DIMENSION DETCA(6),DEICA(2)
C! Auxillary common for ECAL geometry
      COMMON/AGEAUX/EGRIEC,IEGROT
C! Indices for Ecal related materials
      COMMON/AGECMA/IEMALU,IEMAIR,IEMPVC,IEMBLA,IEMEAV,IEMB12,IEMBS3,
     1        IEMARB,IEMCS0,IEMC12,IEMCS3,IEMLAV,IEMRAV,IEMBAV,IEMCAV
C! Indices for Passive materials related to ECAL environment
      COMMON/AGPMMA/IPMHOF,IPMVEF,IPMTCA,IPMICA,IPMEBX,IPMESP
      PARAMETER (D30=2.*D15   , D60 = 2.*D30  )
      PARAMETER (LTAB1=5    ,LMED=2)
      DIMENSION TAB1(LTAB1,LMED)
      DATA TAB1 /
     1 20.    ,  0.5  , 0.1  , 0.1  , 1. ,
     9 20.    ,  0.5  , 0.1   , 0.1  , 1.   /
      DATA DETCA /30.,60.,90.,30.,90.,0./ ,DEICA /150.,0./
C-----------------------------------------------------------------
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
C  Some more statements functions
C     Minimum radius
      RMIN (ID,NRBOS) = RTABL(ID,NRBOS,JPMGRI)
C     Maximum radius
      RMAX (ID,NRBOS) = RTABL(ID,NRBOS,JPMGRO)
C     Minimum z position
      ZMIN (ID,NRBOS) = RTABL(ID,NRBOS,JPMGZN)
C     Maximum z position
      ZMAX (ID,NRBOS) = RTABL(ID,NRBOS,JPMGZX)
C     Minimum phi range
      PHIMI(ID,NRBOS) = RTABL(ID,NRBOS,JPMGPN)
C     Maximum phi range
      PHIMA(ID,NRBOS) = RTABL(ID,NRBOS,JPMGPX)
      KPM = IW(NAMIND('PMG1'))
      IF (KPM.LE.0) RETURN
      IF (IFL.EQ.1 ) THEN
         TILT=ECTILT(DUM)
         DPHI = PIBY6
         PHI = TILT-0.5*DPHI
         IF (TILT.LT.0.) PHI=PHI+DPHI
         PHIN=PHI*RADEG
C
C       implement two volumes corresponding to passive matter between
C       barrel and petal modules EPBA(endA) , EPBB (endB) and to passive
C       matter above petal modules and below Coil EPAA(end A) EPAB(endB)
C
         RMI=ALRMAX
         RMA=0.
         ZMI=ALZMAX
         ZMA=0.
         DO 10 I=1,4
         RMI=MIN(RMI,RMIN(KPM,I))
         RMA=MAX(RMA,RMAX(KPM,I))
         ZMI=MIN(ZMI,ZMIN(KPM,I))
         ZMA=MAX(ZMA,ZMAX(KPM,I))
 10      CONTINUE
         IAGMED=IAGMED+1
         CALL GSTMED(IAGMED,'PASS. MAT. BETW.MODU$',IEMAIR ,0,IAGFLD,
     1   ALFIEL,TAB1(1,2),TAB1(2,2),TAB1(3,2),TAB1(4,2),TAB1(5,2),0,0)
C
         PTAB(1) = RMI
         PTAB(2) = MIN(RMA,AGLIMR(6))
         ZMI=MAX(ZMI,AGLIMZ(1))
         ZPMAT = ZMA-ZMI
         PTAB(3)=0.5*ZPMAT
         CALL GSVOLU('EPBA','TUBE',IAGMED,PTAB,3,IVOL)
         CALL GSVOLU('EPBB','TUBE',IAGMED,PTAB,3,IVOL)
         CALL GSVOLU('EPCA','TUBS',IAGMED,PTAB,0,IVOL)
         Z=AGLIMZ(1)+PTAB(3)
         CALL GSPOS('EPBA',1,'ECEA',0.,0.,Z,0,'ONLY')
         CALL GSPOS('EPBB',1,'ECEB',0.,0.,Z,0,'ONLY')
C
C    We must foresee two tracking media , inside uniform and non uniform
C   field as the barrel electronic boxes end in a region where the field
C  is non uniform and the end cap boxes are all contained in that region
         IAGMED=IAGMED+1
         CALL GSTMED(IAGMED,'ELEC. BOX ABOVE ECAL$',IPMEBX,0,IAGFLD,
     1   ALFIEL,TAB1(1,2),TAB1(2,2),TAB1(3,2),TAB1(4,2),TAB1(5,2),0,0)
         PTAB(1)=EGRIEC
         PTAB(2)=AGLIMR(6)
         PTAB(3)=0.5*(AGLIMZ(2)-AGLIMZ(1)-ZPMAT)
         CALL GSVOLU('EPAA','TUBE',IAGMED,PTAB,3,IVOL)
         CALL GSVOLU('EPAB','TUBE',IAGMED,PTAB,3,IVOL)
         Z=AGLIMZ(1)+PTAB(3)+ZPMAT
         CALL GSPOS('EPAA',1,'ECEA',0.,0.,Z,0,'ONLY')
         CALL GSPOS('EPAB',1,'ECEB',0.,0.,Z,0,'ONLY')
         IAGMED=IAGMED+1
         CALL GSTMED(IAGMED,'ELEC BOX IN NONUNI B$',IPMEBX,0,
     1   IAGFLI,ALFIEL,TAB1(1,2),TAB1(2,2),TAB1(3,2),TAB1(4,2),TAB1(5,2)
     2   ,0,0)
         CALL GSVOLU('EPBX','TUBE',IAGMED,PTAB,0,IVOL)
C
         PTAB(1)=EGRIEC
         PTAB(2)=AGLIMR(6)
         IR=0
         PTAB(4) = RADEG*PHIMI(KPM,7)
         PTAB(5) = RADEG*PHIMA(KPM,7)
         ZB = 0.5*(AGLIMZ(2)+ZMAX(KPM,7))-Z
         DO 40 I=1,12
            PTAB(3)=0.5*(AGLIMZ(2)-AGLIMZ(1)-ZPMAT)
            CALL GSPOSP('EPCA',I,'EPAA',0.,0.,0.,IR,'ONLY',PTAB,5)
            PTAB(3) = 0.5*(AGLIMZ(2)-ZMAX(KPM,7))
            CALL GSPOSP('EPCA',I,'EPAB',0.,0.,ZB,IR,'ONLY',PTAB,5)
            PTAB(4)=PTAB(4)+D30
            PTAB(5)=PTAB(5)+D30
 40      CONTINUE
         IAGMED=IAGMED+1
         CALL GSTMED(IAGMED,'TPC HORIZONTAL FOOT $',IPMHOF ,0,IAGFLD,
     1   ALFIEL,TAB1(1,2),TAB1(2,2),TAB1(3,2),TAB1(4,2),TAB1(5,2),0,0)
         CALL GSVOLU('ETHF','TUBS',IAGMED,PTAB,0,IVOL)
         IAGMED=IAGMED+1
         CALL GSTMED(IAGMED,'TPC VERTICAL FOOT   $',IPMVEF ,0,
     1   IAGFLD,ALFIEL,TAB1(1,2),TAB1(2,2),TAB1(3,2),TAB1(4,2),TAB1(5,2)
     2   ,0,0)
         CALL GSVOLU('ETVF','TUBS',IAGMED,PTAB,0,IVOL)
C
C   Position TPC feet  between barrel and end cap
C
         X=0.
         Y=0.
         Z=0.
C   Horizontal foot +x side
         PTAB(1) = RMIN(KPM,1)
         PTAB(2) = MIN(AGLIMR(6),RMAX(KPM,1))
         PTAB(3) = 0.5*(ZMAX(KPM,1)-ZMIN(KPM,1))
         PTAB(4) = RADEG*PHIMI(KPM,1)
         PTAB(5) = RADEG*PHIMA(KPM,1)
         CALL GSPOSP('ETHF',1,'EPBA',X,Y,Z,0,'ONLY',PTAB,5)
         CALL GSPOSP('ETHF',1,'EPBB',X,Y,Z,0,'ONLY',PTAB,5)
C   Horizontal foot -x side
         PTAB(4) = RADEG*PHIMI(KPM,9)
         PTAB(5) = RADEG*PHIMA(KPM,9)
         CALL GSPOSP('ETHF',2,'EPBA',X,Y,Z,0,'ONLY',PTAB,5)
         CALL GSPOSP('ETHF',2,'EPBB',X,Y,Z,0,'ONLY',PTAB,5)
C   Vertical   foot +y side
         PTAB(1) = RMIN(KPM,2)
         PTAB(2) = MIN(AGLIMR(6),RMAX(KPM,2))
         PTAB(3) = 0.5*(ZMAX(KPM,2)-ZMIN(KPM,2))
         PTAB(4) = RADEG*PHIMI(KPM,2)
         PTAB(5) = RADEG*PHIMA(KPM,2)
         CALL GSPOSP('ETVF',1,'EPBA',X,Y,Z,0,'ONLY',PTAB,5)
         CALL GSPOSP('ETVF',1,'EPBB',X,Y,Z,0,'ONLY',PTAB,5)
C   Vertical   foot -y side
         PTAB(4) = RADEG*PHIMI(KPM,10)
         PTAB(5) = RADEG*PHIMA(KPM,10)
         CALL GSPOSP('ETVF',2,'EPBA',X,Y,Z,0,'ONLY',PTAB,5)
         CALL GSPOSP('ETVF',2,'EPBB',X,Y,Z,0,'ONLY',PTAB,5)
C
         IAGMED=IAGMED+1
         CALL GSTMED(IAGMED,'TPC CABLES IN UNI. B$',IPMTCA ,0,IAGFLD,
     1   ALFIEL,TAB1(1,2),TAB1(2,2),TAB1(3,2),TAB1(4,2),TAB1(5,2),0,0)
         CALL GSVOLU('ETCA','TUBS',IAGMED,PTAB,0,IVOL)
         IAGMED=IAGMED+1
         CALL GSTMED(IAGMED,'TPC CABLES NON UNI B$',IPMTCA ,0,IAGFLI,
     1   ALFIEL,TAB1(1,2),TAB1(2,2),TAB1(3,2),TAB1(4,2),TAB1(5,2),0,0)
         CALL GSVOLU('ETCB','TUBS',IAGMED,PTAB,0,IVOL)
         IAGMED=IAGMED+1
         CALL GSTMED(IAGMED,'ITC CABLES IN UNI. B$',IPMICA ,0,
     1   IAGFLD,ALFIEL,TAB1(1,2),TAB1(2,2),TAB1(3,2),TAB1(4,2),TAB1(5,2)
     2   ,0,0)
         CALL GSVOLU('EICA','TUBS',IAGMED,PTAB,0,IVOL)
         IAGMED=IAGMED+1
         CALL GSTMED(IAGMED,'ITC CABLES NON UNI B$',IPMICA ,0,
     1   IAGFLI,ALFIEL,TAB1(1,2),TAB1(2,2),TAB1(3,2),TAB1(4,2),TAB1(5,2)
     2   ,0,0)
         CALL GSVOLU('EICB','TUBS',IAGMED,PTAB,0,IVOL)
C
C   Position TPC and ITC cables between barrel and end cap
C
         X=0.
         Y=0.
         Z=0.
C   Insert cables between barrel and end cap A
         DO 20 I=1,33
         J = I+10
         PTAB(1) = RMIN(KPM,J)
         PTAB(2) = MIN(AGLIMR(6),RMAX(KPM,J))
         PTAB(3) = 0.5*(ZMAX(KPM,J)-ZMIN(KPM,J))
         IF (PTAB(3).LE.0.) GO TO 20
         PTAB(4) = RADEG*PHIMI(KPM,J)
         PTAB(5) = RADEG*PHIMA(KPM,J)
         CALL GSPOSP('ETCA',I,'EPBA',X,Y,Z,0,'ONLY',PTAB,5)
 20      CONTINUE
C   Insert cables between barrel and end cap B
         DO 30 I=1,36
         J = I+43
         PTAB(1) = RMIN(KPM,J)
         PTAB(2) = MIN(AGLIMR(6),RMAX(KPM,J))
         PTAB(3) = 0.5*(ZMAX(KPM,J)-ZMIN(KPM,J))
         IF (PTAB(3).LE.0.) GO TO 30
         PTAB(4) = RADEG*PHIMI(KPM,J)
         PTAB(5) = RADEG*PHIMA(KPM,J)
         CALL GSPOSP('ETCA',I,'EPBB',X,Y,Z,0,'ONLY',PTAB,5)
 30      CONTINUE
C
C   Position cables above end cap
C
         X=0.
         Y=0.
         Z=0.
         PTAB(1)=EGRIEC
         PTAB(2)=AGLIMR(6)
         PTAB(3)=0.5*(AGLIMZ(2)-AGLIMZ(1)-ZPMAT)
         PTAB(4) = RADEG*PHIMI(KPM,3)
         PTAB(5) = RADEG*PHIMA(KPM,3)
         DO 42 I=1,6
         CALL GSPOSP('ETCA',I,'EPAA',X,Y,Z,0,'ONLY',PTAB,5)
         CALL GSPOSP('ETCA',I,'EPAB',X,Y,Z,0,'ONLY',PTAB,5)
         PTAB(4)=PTAB(4)+DETCA(I)
         PTAB(5)=PTAB(5)+DETCA(I)
 42      CONTINUE
         PTAB(4) = RADEG*PHIMI(KPM,4)
         PTAB(5) = RADEG*PHIMA(KPM,4)
         DO 50 I=1,2
         CALL GSPOSP('EICA',I,'EPAA',X,Y,Z,0,'ONLY',PTAB,5)
         CALL GSPOSP('EICA',I,'EPAB',X,Y,Z,0,'ONLY',PTAB,5)
         PTAB(4)=PTAB(4)+DEICA(I)
         PTAB(5)=PTAB(5)+DEICA(I)
 50      CONTINUE
C  Add support plate of petals
         IAGMED=IAGMED+1
         CALL GSTMED(IAGMED,'END CAP SUPPORT PLATE',IPMESP ,0,
     1   IAGFLD,ALFIEL,TAB1(1,2),TAB1(2,2),TAB1(3,2),TAB1(4,2),TAB1(5,2)
     2   ,0,0)
         X1 = RMIN(KPM,80)*ABS(TAN(PHIMI(KPM,80)))
         X2 = RMAX(KPM,80)*ABS(TAN(PHIMA(KPM,80)))
         PTAB(1)= X1
         PTAB(2)= X2
         PTAB(3)= 0.5*(ZMAX(KPM,80)-ZMIN(KPM,80))
         PTAB(4)= 0.5*(RMAX(KPM,80)-RMIN(KPM,80))
         CALL GSVOLU('ECSU','TRD1',IAGMED,PTAB,4,IVOL)
         CALL GSPOS('ECSU',1,'ECBX',X,Y,Z,0,'ONLY')
      ELSE IF ( IFL .EQ. 2) THEN
C
C     This volume is filled with electronics in non uniform field
C     it must be partly overlapped by cables, piping and even some
C     free path of air
C
         X=0.
         Y=0.
         Z=0.
         PTAB(1) = RTABL(KPM,6,9)
         PTAB(2)=AGLIMR(6)
         PTAB(3)=0.5*(AGLIMZ(3)-AGLIMZ(2))
         PTAB(4) = RADEG*RTABL(KPM,3,12)
         PTAB(5) = RADEG*RTABL(KPM,3,13)
         DO 60 I=1,6
         CALL GSPOSP('ETCB',I,'EPBX',X,Y,Z,0,'ONLY',PTAB,5)
         PTAB(4)=PTAB(4)+DETCA(I)
         PTAB(5)=PTAB(5)+DETCA(I)
 60      CONTINUE
         PTAB(4) = RADEG*RTABL(KPM,4,12)
         PTAB(5) = RADEG*RTABL(KPM,4,13)
         DO 70 I=1,2
         CALL GSPOSP('EICB',I,'EPBX',X,Y,Z,0,'ONLY',PTAB,5)
         PTAB(4)=PTAB(4)+DEICA(I)
         PTAB(5)=PTAB(5)+DEICA(I)
 70      CONTINUE
C
         IMED=3
         CALL GSVOLU('EPCB','TUBS',IMED,PTAB,0,IVOL)
C
C     now place some free air path between ecal barrel boxes
C
         PTAB(2)=AGLIMR(6)
         PTAB(3)=0.5*(AGLIMZ(3)-AGLIMZ(2))
         IR=0
         PTAB(4) = RADEG*RTABL(KPM,7,12)
         PTAB(5) = RADEG*RTABL(KPM,7,13)
         X=0.
         Y=0.
         Z=0.
         DO 41 I=1,12
            CALL GSPOSP('EPCB',I,'EPBX',X ,Y ,Z ,IR,'ONLY',PTAB,5)
            PTAB(4)=PTAB(4)+D30
            PTAB(5)=PTAB(5)+D30
 41      CONTINUE
      ENDIF
      RETURN
      END