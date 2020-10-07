C-----------------------------------------------------------------------
C                           H E R W I G
C
C            a Monte Carlo event generator for simulating
C        +---------------------------------------------------+
C        | Hadron Emission Reactions With Interfering Gluons |
C        +---------------------------------------------------+
C      G. Marchesini, Dipartimento di Fisica, Universita di Milano
C          I.G. Knowles(*), M.H. Seymour(+) and  B.R. Webber,
C                   Cavendish Laboratory, Cambridge
C-----------------------------------------------------------------------
C with Deep Inelastic Scattering and Heavy Flavour Electroproduction by
C G.Abbiendi(@)and L.Stanco, Dipartimento di Fisica,Universita di Padova
C-----------------------------------------------------------------------
C        and Jet Photoproduction in Lepton-Hadron Collisions
C             by J. Chyla, Institute of Physics, Prague
C-----------------------------------------------------------------------
C(*)present address: Dept. of Physics & Astronomy, University of Glasgow
C-----------------------------------------------------------------------
C(+)present address: Theory Division, CERN
C-----------------------------------------------------------------------
C(@)present address: DESY, Hamburg
C-----------------------------------------------------------------------
C                  Version 5.9 - 22nd July 1996
C-----------------------------------------------------------------------
C Main reference:
C    G.Marchesini,  B.R.Webber,  G.Abbiendi,  I.G.Knowles,  M.H.Seymour,
C    and L.Stanco, Computer Physics Communications 67 (1992) 465.
C-----------------------------------------------------------------------
C Please send e-mail about  this program  to one of the  authors at the
C following addresses:
C       Decnet   : 19616::webber, vxdesy::abbiendi, 19800::knowles
C       Internet : webber@hep.phy.cam.ac.uk,
C                  seymour@surya11.cern.ch, knowles@v2.ph.gla.ac.uk
C-----------------------------------------------------------------------
C This version has all bug fixes up to 20th December 1997.
C See http://hepwww.rl.ac.uk/theory/seymour/herwig/ for more details.
C---------------fixes --------------------------------------
C  fix programming pb June 15, 1999 BBL in HWUINE
C  replace HWUDKS code by bug-fixed version from B.Webber Nov 99
C  introduce common /HWRECO/NRECO in HWCFOR to make the # of reco per 
C   event available   B.Bloch Nov 99
C-----------------------------------------------------------------------
CDECK  ID>, DECADD.
*CMZ :-        -28/01/92  12.34.44  by  Mike Seymour
*-- Author :    Luca Stanco
C-----------------------------------------------------------------------
      SUBROUTINE DECADD(LOGI)
C-----------------------------------------------------------------------
C     DUMMY SUBROUTINE: DELETE AND SET BDECAY='CLEO'
C     IN MAIN PROGRAM IF YOU USE CLEO DECAY PACKAGE
C-----------------------------------------------------------------------
      LOGICAL LOGI
      WRITE (6,10)
   10 FORMAT(/10X,'DECADD CALLED BUT NOT LINKED')
      STOP
      END
CDECK  ID>, EUDINI.
*CMZ :-        -28/01/92  12.34.44  by  Mike Seymour
*-- Author :    Luca Stanco
C-----------------------------------------------------------------------
      SUBROUTINE EUDINI
C-----------------------------------------------------------------------
C     DUMMY SUBROUTINE: DELETE AND SET BDECAY='EURO'
C     IN MAIN PROGRAM IF YOU USE EURODEC DECAY PACKAGE
C-----------------------------------------------------------------------
      WRITE (6,10)
   10 FORMAT(/10X,'EUDINI CALLED BUT NOT LINKED')
      STOP
      END
CDECK  ID>, FRAGMT.
*CMZ :-        -28/01/92  12.34.44  by  Mike Seymour
*-- Author :    Luca Stanco
C-----------------------------------------------------------------------
      SUBROUTINE FRAGMT(I,J,K)
C-----------------------------------------------------------------------
C     DUMMY SUBROUTINE: DELETE AND SET BDECAY='EURO'
C     IN MAIN PROGRAM IF YOU USE EURODEC DECAY PACKAGE
C-----------------------------------------------------------------------
      INTEGER I,J,K
      WRITE (6,10)
   10 FORMAT(/10X,'FRAGMT CALLED BUT NOT LINKED')
      STOP
      END
CDECK  ID>, HVCBVI.
*CMZ :-        -28/01/92  12.34.44  by  Mike Seymour
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HVCBVI
C-----------------------------------------------------------------------
C     DUMMY ROUTINE: DELETE IF YOU LINK TO BARYON NUMBER VIOLATN PACKAGE
C-----------------------------------------------------------------------
      WRITE (6,10)
   10 FORMAT(/10X,'HVCBVI CALLED BUT NOT LINKED')
      STOP
      END
CDECK  ID>, HVHBVI.
*CMZ :-        -28/01/92  12.34.44  by  Mike Seymour
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HVHBVI
C-----------------------------------------------------------------------
C     DUMMY ROUTINE: DELETE IF YOU LINK TO BARYON NUMBER VIOLATN PACKAGE
C-----------------------------------------------------------------------
      WRITE (6,10)
   10 FORMAT(/10X,'HERBVI CALLED BUT NOT LINKED')
      STOP
      END
CDECK  ID>, HWBAZF.
*CMZ :-        -26/04/91  11.11.54  by  Bryan Webber
*-- Author :    Ian Knowles
C-----------------------------------------------------------------------
      SUBROUTINE HWBAZF(IPAR,JPAR,VEC1,VEC2,VEC3,VEC)
C-----------------------------------------------------------------------
C     Azimuthal correlation functions for Collins' algorithm,
C     see I.G.Knowles, Comp. Phys. Comm. 58 (90) 271 for notation.
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION Z1,Z2,DOT12,DOT23,DOT31,TR,FN(7),VEC1(2),VEC2(2),
     & VEC3(2),VEC(2)
      INTEGER IPAR,JPAR
      LOGICAL GLUI,GLUJ
      IF (.NOT.AZSPIN) RETURN
      Z1=PPAR(4,JPAR)/PPAR(4,IPAR)
      Z2=1.-Z1
      GLUI=IDPAR(IPAR).EQ.13
      GLUJ=IDPAR(JPAR).EQ.13
      IF (GLUI) THEN
         IF (GLUJ) THEN
C           Branching: g--->gg
            FN(2)=Z2/Z1
            FN(3)=1./FN(2)
            FN(4)=Z1*Z2
            FN(1)=FN(2)+FN(3)+FN(4)
            FN(5)=FN(2)+2.*Z1
            FN(6)=FN(3)+2.*Z2
            FN(7)=FN(4)-2.
         ELSE
C           Branching: g--->qqbar
            FN(1)=(Z1*Z1+Z2*Z2)/2.
            FN(2)=0.
            FN(3)=0.
            FN(4)=-Z1*Z2
            FN(5)=-(2.*Z1-1.)/2.
            FN(6)=-FN(5)
            FN(7)=FN(1)
         ENDIF
      ELSE
         IF (GLUJ) THEN
C           Branching: q--->gq
            FN(1)=(1.+Z2*Z2)/(2.*Z1)
            FN(2)=Z2/Z1
            FN(3)=0.
            FN(4)=0.
            FN(5)=FN(1)
            FN(6)=(1.+Z2)/2.
            FN(7)=-FN(6)
         ELSE
C           Branching: q--->qg
            FN(1)=(1.+Z1*Z1)/(2.*Z2)
            FN(2)=0.
            FN(3)=Z1/Z2
            FN(4)=0.
            FN(5)=(1.+Z1)/2.
            FN(6)=FN(1)
            FN(7)=-FN(5)
         ENDIF
      ENDIF
      DOT12=VEC1(1)*VEC2(1)+VEC1(2)*VEC2(2)
      DOT23=VEC2(1)*VEC3(1)+VEC2(2)*VEC3(2)
      DOT31=VEC3(1)*VEC1(1)+VEC3(2)*VEC1(2)
      TR=1./(FN(1)+FN(2)*DOT23+FN(3)*DOT31+FN(4)*DOT12)
      VEC(1)=((FN(2)+FN(5)*DOT23)*VEC1(1)
     &       +(FN(3)+FN(6)*DOT31)*VEC2(1)
     &       +(FN(4)+FN(7)*DOT12)*VEC3(1))*TR
      VEC(2)=((FN(2)+FN(5)*DOT23)*VEC1(2)
     &       +(FN(3)+FN(6)*DOT31)*VEC2(2)
     &       +(FN(4)+FN(7)*DOT12)*VEC3(2))*TR
      END
CDECK  ID>, HWBCON.
*CMZ :-        -26/04/91  10.18.56  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWBCON
C-----------------------------------------------------------------------
C     MAKES COLOUR CONNECTIONS BETWEEN JETS
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      INTEGER IHEP,IST,ID,JC,JD,JHEP,LHEP
      IF (IERROR.NE.0) RETURN
      DO 20 IHEP=1,NHEP
      IST=ISTHEP(IHEP)
C---LOOK FOR PARTONS WITHOUT COLOUR MOTHERS
      IF (IST.LT.145.OR.IST.GT.152) GOTO 20
      IF (JMOHEP(2,IHEP).EQ.0) THEN
C---FIND COLOUR-CONNECTED PARTON
        JC=JMOHEP(1,IHEP)
        IF (IST.NE.152) JC=JMOHEP(1,JC)
        JC =JMOHEP(2,JC)
C---FIND SPECTATOR WHEN JC IS DECAYED HEAVY QUARK
        IF (ISTHEP(JC).EQ.155) THEN
          IF (IDHEP(JMOHEP(1,JC)).EQ.94) THEN
C---QUARK DECAYED BEFORE HADRONIZING
            JHEP=JMOHEP(2,JC)
            ID=IDHW(JHEP)
            IF (ISTHEP(JHEP).EQ.155) THEN
              JC=JDAHEP(2,JHEP)
            ELSEIF (ID.EQ.6.OR.ID.EQ.12.OR.
     &              (ID.GE.209.AND.ID.LE.218)) THEN
C Wait for partner heavy quark to decay
              RETURN
            ELSE
              JMOHEP(2,IHEP)=JHEP
              JDAHEP(2,JHEP)=IHEP
              GOTO 20
            ENDIF
          ELSE
            JC=JMOHEP(2,JC)
          ENDIF
        ENDIF
        JC=JDAHEP(1,JC)
        JD=JDAHEP(2,JC)
C---SEARCH IN CORRESPONDING JET
        IF (JD.LT.JC) JD=JC
        LHEP=0
        DO 10 JHEP=JC,JD
        IF (ISTHEP(JHEP).LT.145.OR.ISTHEP(JHEP).GT.152) GOTO 10
        IF (JDAHEP(2,JHEP).EQ.IHEP) LHEP=JHEP
        IF (JDAHEP(2,JHEP).NE.0) GOTO 10
C---JOIN IHEP AND JHEP
        JMOHEP(2,IHEP)=JHEP
        JDAHEP(2,JHEP)=IHEP
        GOTO 20
   10   CONTINUE
        IF (LHEP.NE.0) THEN
          JMOHEP(2,IHEP)=LHEP
        ELSE
C---COULDN'T FIND PARTNER OF IHEP
          CALL HWWARN('HWBCON',100,*999)
        ENDIF
      ENDIF
  20  CONTINUE
C---BREAK COLOUR CONNECTIONS WITH PHOTONS
      IHEP=1
  30  IF (IHEP.LE.NHEP) THEN
        IF (IDHW(IHEP).EQ.59 .AND. ISTHEP(IHEP).EQ.149) THEN
          IF (JDAHEP(2,JMOHEP(2,IHEP)).EQ.IHEP)
     &      JDAHEP(2,JMOHEP(2,IHEP))=JDAHEP(2,IHEP)
          IF (JDAHEP(2,IHEP).NE.0) THEN
            IF (JMOHEP(2,JDAHEP(2,IHEP)).EQ.IHEP)
     &        JMOHEP(2,JDAHEP(2,IHEP))=JMOHEP(2,IHEP)
          ENDIF
          JMOHEP(2,IHEP)=IHEP
          JDAHEP(2,IHEP)=IHEP
        ENDIF
        IHEP=IHEP+1
        GOTO 30
      ENDIF
  999 END
CDECK  ID>, HWBDED.
*CMZ :-        -22/04/96  13.54.08  by  Mike Seymour
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HWBDED(IOPT)
C     FILL MISSING AREA OF DALITZ PLOT WITH 3-JET AND 2-JET+GAMMA EVENTS
C     IF (IOPT.EQ.1) SET UP EVENT RECORD
C     IF (IOPT.EQ.2) CLEAN UP EVENT RECORD AFTER SHOWERING
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWBVMC,HWRGEN,HWUALF,HWUSQR,X(3),W,WMAX,WSUM,
     & X1MIN,X1MAX,X2MIN,X2MAX,QSCALE,GAMFAC,GLUFAC,R(3,3),CS,SN,M(3),
     & E(3),LAMBDA,A,B,C,PTSQ,EM,P1(5),P2(5),PVRT(4),EPS,MASDEP
      INTEGER ID,ID3,EMIT,NOEMIT,IHEP,JHEP,KHEP,ICMF,IOPT,IEDT(3),I,NDEL
      EXTERNAL HWBVMC,HWRGEN,HWUALF,HWUSQR
      SAVE X,WMAX
      DATA WSUM,WMAX,X1MIN,X1MAX,EMIT,ICMF
     & /0.994651,1.84096,0,0.773459,2*0/
      LAMBDA(A,B,C)=(A**2+B**2+C**2-2*A*B-2*B*C-2*C*A)/(4*A)
      IF (IOPT.EQ.1) THEN
C---FIND AN UNTREATED CMF
        IF (EMIT.NE.0) RETURN
        ICMF=0
        DO 10 IHEP=1,NHEP
 10       IF (ICMF.EQ.0 .AND. ISTHEP(IHEP).EQ.110 .AND.
     &    JDAHEP(2,IHEP).EQ.JDAHEP(1,IHEP)+1) ICMF=IHEP
        IF (ICMF.EQ.0) RETURN
        EM=PHEP(5,ICMF)
        IF (EM.LT.2*HWBVMC(1)) RETURN
C---GENERATE X1,X2 ACCORDING TO 1/((1-X1)*(1-X2))
 100    CONTINUE
C---CHOOSE X1
        X(1)=1-(1-X1MAX)*((1-X1MIN)/(1-X1MAX))**HWRGEN(0)
C---CHOOSE X2
        X2MIN=MAX(X(1),1-X(1))
        X2MAX=(4*X(1)-3+2*REAL(  CMPLX(  X(1)**3+135*(X(1)-1)**3,
     &    3*HWUSQR(3*(128*X(1)**4-368*X(1)**3+405*X(1)**2-216*X(1)+54))*
     &    (X(1)-1)  )**(1./3)  ))/3
        IF (X2MAX.GE.1.OR.X2MIN.GE.1.OR.X2MAX.LE.X2MIN) GOTO 100
        X(2)=1-(1-X2MAX)*((1-X2MIN)/(1-X2MAX))**HWRGEN(1)
C---CALCULATE WEIGHT
        W=2 * LOG((1-X1MIN)/(1-X1MAX))*LOG((1-X2MIN)/(1-X2MAX)) *
     &    (X(1)**2+X(2)**2)
C---GENERATE UNWEIGHTED (X1,X2) PAIRS (EFFICIENCY IS ~50%)
        IF (WMAX*HWRGEN(2).GT.W) GOTO 100
C---SYMMETRIZE X1,X2
        X(3)=2-X(1)-X(2)
        IF (HWRGEN(5).GT.HALF) THEN
          X(1)=X(2)
          X(2)=2-X(3)-X(1)
        ENDIF
C---CHOOSE WHICH PARTON WILL EMIT
        EMIT=1
        IF (HWRGEN(6).LT.X(1)**2/(X(1)**2+X(2)**2)) EMIT=2
        NOEMIT=3-EMIT
        IHEP=JDAHEP(  EMIT,ICMF)
        JHEP=JDAHEP(NOEMIT,ICMF)
C---PREFACTORS FOR GAMMA AND GLUON CASES
        QSCALE=HWUSQR((1-X(1))*(1-X(2))*(1-X(3)))*EM/X(NOEMIT)
        ID=IDHW(JDAHEP(1,ICMF))
        GAMFAC=ALPFAC*ALPHEM*ICHRG(ID)**2/(18*PIFAC)
        GLUFAC=0
        IF (QSCALE.GT.HWBVMC(13))
     &    GLUFAC=CFFAC/(2*PIFAC)*HWUALF(1,QSCALE)
C---IN FRACTION FAC*WSUM OF EVENTS ADD A GAMMA/GLUON
        IF     (GAMFAC*WSUM .GT. HWRGEN(3)) THEN
          ID3=59
        ELSEIF (GLUFAC*WSUM .GT. HWRGEN(4)) THEN
          ID3=13
        ELSE
          EMIT=0
          RETURN
        ENDIF
C---CHECK INFRA-RED CUT-OFF FOR GAMMA/GLUON
        M(1)=HWBVMC(ID)
        M(2)=HWBVMC(ID)
        M(3)=HWBVMC(ID3)
        E(1)=HALF*EM*(X(1)+(M(1)**2-M(2)**2-M(3)**2)/EM**2)
        E(2)=HALF*EM*(X(2)+(M(2)**2-M(3)**2-M(1)**2)/EM**2)
        E(3)=EM-E(1)-E(2)
        PTSQ=-LAMBDA(E(NOEMIT)**2-M(NOEMIT)**2,E(3)**2-M(3)**2,
     &    E(EMIT)**2-M(EMIT)**2)
        IF (PTSQ.LE.0 .OR.
     $       E(1).LE.M(1).OR.E(2).LE.M(2).OR.E(3).LE.M(3)) THEN
          EMIT=0
          RETURN
        ENDIF
C---CALCULATE MASS-DEPENDENT SUPRESSION
        IF (MOD(IPROC,10).GT.0) THEN
          EPS=(RMASS(ID)/EM)**2
          MASDEP=X(1)**2+X(2)**2
     $         -4*EPS*X(3)-2*EPS*((1-X(2))/(1-X(1))+(1-X(1))/(1-X(2)))
     $         -4*EPS**2*X(3)**2/((1-X(1))*(1-X(2)))
          IF (MASDEP.LT.HWRGEN(7)*(X(1)**2+X(2)**2)) THEN
            EMIT=0
            RETURN
          ENDIF
        ENDIF
C---STORE OLD MOMENTA
        CALL HWVEQU(5,PHEP(1,JDAHEP(1,ICMF)),P1)
        CALL HWVEQU(5,PHEP(1,JDAHEP(2,ICMF)),P2)
C---GET THE NON-EMITTING PARTON'S CMF DIRECTION
        CALL HWULOF(PHEP(1,ICMF),PHEP(1,JHEP),PHEP(1,JHEP))
        CALL HWRAZM(ONE,CS,SN)
        CALL HWUROT(PHEP(1,JHEP),CS,SN,R)
        M(1)=PHEP(5,IHEP)
        M(2)=PHEP(5,JHEP)
        M(3)=RMASS(ID3)
C---REORDER ENTRIES: IHEP=EMITTER, JHEP=NON-EMITTER, KHEP=EMITTED
        NHEP=NHEP+1
        IF (IDHW(IHEP).LT.IDHW(JHEP)) THEN
          IHEP=JDAHEP(1,ICMF)
          JHEP=NHEP
        ELSE
          IHEP=NHEP
          JHEP=JDAHEP(1,ICMF)
        ENDIF
        KHEP=JDAHEP(2,ICMF)
C---SET UP MOMENTA
        PHEP(5,JHEP)=M(NOEMIT)
        PHEP(5,IHEP)=M(EMIT)
        PHEP(5,KHEP)=M(3)
        PHEP(4,JHEP)=HALF*EM*(X(NOEMIT)+
     &                  (M(NOEMIT)**2-M(EMIT)**2-M(3)**2)/EM**2)
        PHEP(4,IHEP)=HALF*EM*(X(EMIT)+
     &                  (M(EMIT)**2-M(NOEMIT)**2-M(3)**2)/EM**2)
        PHEP(4,KHEP)=EM-PHEP(4,IHEP)-PHEP(4,JHEP)
        PHEP(3,JHEP)=HWUSQR(PHEP(4,JHEP)**2-PHEP(5,JHEP)**2)
        PHEP(3,IHEP)=( (PHEP(4,KHEP)**2-PHEP(5,KHEP)**2) -
     &    (PHEP(4,IHEP)**2-PHEP(5,IHEP)**2) -
     &    (PHEP(3,JHEP)**2) )*HALF/PHEP(3,JHEP)
        PHEP(3,KHEP)=-PHEP(3,IHEP)-PHEP(3,JHEP)
        PHEP(2,JHEP)=0
        PHEP(2,IHEP)=0
        PHEP(2,KHEP)=0
        PHEP(1,JHEP)=0
        PHEP(1,IHEP)=HWUSQR(PHEP(4,IHEP)**2-
     &    PHEP(3,IHEP)**2-PHEP(5,IHEP)**2)
        PHEP(1,KHEP)=-PHEP(1,IHEP)
C---ORIENT IN CMF, THEN BOOST TO LAB
        CALL HWUROB(R,PHEP(1,IHEP),PHEP(1,IHEP))
        CALL HWUROB(R,PHEP(1,JHEP),PHEP(1,JHEP))
        CALL HWUROB(R,PHEP(1,KHEP),PHEP(1,KHEP))
        CALL HWULOB(PHEP(1,ICMF),PHEP(1,IHEP),PHEP(1,IHEP))
        CALL HWULOB(PHEP(1,ICMF),PHEP(1,JHEP),PHEP(1,JHEP))
        CALL HWULOB(PHEP(1,ICMF),PHEP(1,KHEP),PHEP(1,KHEP))
C---CALCULATE PRODUCTION VERTICES
        CALL HWVZRO(4,VHEP(1,JHEP))
        CALL HWVSUM(4,PHEP(1,IHEP),PHEP(1,KHEP),PVRT)
        CALL HWUDKL(ID,PVRT,VHEP(1,KHEP))
        CALL HWVEQU(4,VHEP(1,KHEP),VHEP(1,IHEP))
C---REORDER ENTRIES: IHEP=QUARK, JHEP=ANTI-QUARK, KHEP=EMITTED
        IF (IHEP.EQ.NHEP) THEN
          IHEP=JHEP
          JHEP=NHEP
        ENDIF
C---STATUS, ID AND POINTERS
        ISTHEP(JHEP)=114
        IDHW(JHEP)=IDHW(KHEP)
        IDHEP(JHEP)=IDHEP(KHEP)
        IDHW(KHEP)=ID3
        IDHEP(KHEP)=IDPDG(ID3)
        JDAHEP(2,ICMF)=JHEP
        JMOHEP(1,JHEP)=ICMF
        JDAHEP(1,JHEP)=0
C---COLOUR CONNECTIONS AND GLUON POLARIZATION
        JMOHEP(2,JHEP)=IHEP
        JDAHEP(2,IHEP)=JHEP
        IF (ID3.EQ.13) THEN
          JMOHEP(2,IHEP)=KHEP
          JMOHEP(2,KHEP)=JHEP
          JDAHEP(2,JHEP)=KHEP
          JDAHEP(2,KHEP)=IHEP
          GPOLN=((1-X(1))**2+(1-X(2))**2)/(4*(1-X(3)))
          GPOLN=1/(1+GPOLN)
        ELSE
          JMOHEP(2,IHEP)=JHEP
          JMOHEP(2,KHEP)=KHEP
          JDAHEP(2,JHEP)=IHEP
          JDAHEP(2,KHEP)=KHEP
        ENDIF
      ELSEIF (IOPT.EQ.2) THEN
C---MAKE THREE-JET EVENTS FROM THE `DEAD-ZONE' LOOK LIKE TWO-JET EVENTS
        IF (EMIT.EQ.0) THEN
          RETURN
        ELSEIF (EMIT.EQ.1) THEN
          IHEP=JDAHEP(1,JDAHEP(1,ICMF)+1)
          JHEP=JDAHEP(1,JDAHEP(1,ICMF))
        ELSE
          IHEP=JDAHEP(1,JDAHEP(2,ICMF))
          JHEP=JDAHEP(1,JDAHEP(1,ICMF)+1)
          JDAHEP(1,JDAHEP(2,ICMF))=JHEP
          IDHW(JHEP)=IDHW(IHEP)
          IF (ISTHEP(IHEP+1).EQ.100 .AND. ISTHEP(JHEP+1).EQ.100)
     &      CALL HWVEQU(5,PHEP(1,IHEP+1),PHEP(1,JHEP+1))
        ENDIF
        JMOHEP(2,JDAHEP(1,ICMF))=JDAHEP(2,ICMF)
        JDAHEP(2,JDAHEP(1,ICMF))=JDAHEP(2,ICMF)
        JMOHEP(2,JDAHEP(2,ICMF))=JDAHEP(1,ICMF)
        JDAHEP(2,JDAHEP(2,ICMF))=JDAHEP(1,ICMF)
        CALL HWVEQU(5,P1,PHEP(1,JDAHEP(1,ICMF)))
        CALL HWVEQU(5,P2,PHEP(1,JDAHEP(2,ICMF)))
        CALL HWVSUM(4,PHEP(1,IHEP),PHEP(1,JHEP),PHEP(1,JHEP))
        CALL HWUMAS(PHEP(1,JHEP))
        JDAHEP(2,JHEP)=JDAHEP(2,IHEP)
        IEDT(1)=JDAHEP(1,ICMF)+1
        IEDT(2)=IHEP
        IEDT(3)=IHEP+1
        NDEL=3
        IF (ISTHEP(IHEP+1).NE.100) NDEL=2
        CALL HWUEDT(NDEL,IEDT)
        DO 410 I=1,2
          IHEP=JDAHEP(1,JDAHEP(I,ICMF))
          JMOHEP(1,IHEP)=JDAHEP(I,ICMF)
          IF (ISTHEP(IHEP+1).EQ.100) THEN
            JMOHEP(1,IHEP+1)=JMOHEP(1,IHEP)
            JMOHEP(2,IHEP+1)=JMOHEP(2,JMOHEP(1,IHEP))
          ENDIF
          DO 400 JHEP=JDAHEP(1,IHEP),JDAHEP(2,IHEP)
            JMOHEP(1,JHEP)=IHEP
 400      CONTINUE
          CALL HWVZRO(4,VHEP(1,JDAHEP(I,ICMF)))
          CALL HWVZRO(4,VHEP(1,IHEP))
          IF (ISTHEP(IHEP+1).EQ.100) CALL HWVZRO(4,VHEP(1,IHEP+1))
 410    CONTINUE
        EMIT=0
      ELSE
        CALL HWWARN('HWBDED',500,*999)
      ENDIF
 999  END
CDECK  ID>, HWBDIS.
*CMZ :-        -17/05/94  09.33.08  by  Mike Seymour
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HWBDIS(IOPT)
C-----------------------------------------------------------------------
C     FILL MISSING AREA OF DIS PHASE-SPACE WITH 2+1-JET EVENTS
C     IF (IOPT.EQ.1) SET UP EVENT RECORD
C     IF (IOPT.EQ.2) CLEAN UP EVENT RECORD AFTER SHOWERING
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,HWBVMC,HWUALF,HWULDO,P1(5),P2(5),P3(5),
     & PCMF(5),L(5),R(3,3),Q,XBJ,RN,XPMIN,XPMAX,XP,ZPMIN,ZPMAX,ZP,FAC,
     & X1,X2,XTSQ,XT,PTSQ,SIN1,SIN2,W1,W2,CFAC,PDFOLD(13),PDFNEW(13),
     & PHI,SCALE,Q1(5),Q2(5),DIR1,DIR2,DIR,PM(5),POLD,PNEW,COMINT,
     & BGFINT,COMWGT,C1,C2,CM,B1,B2,BM,PVRT(4)
      INTEGER IOPT,EMIT,ICMF,IHEP,JHEP,IIN,IOUT,ILEP,IHAD,ID,IDNEW,
     & IEDT(3),NDEL,NTRY,ITEMP
      LOGICAL BGF
      EXTERNAL HWRGEN,HWBVMC,HWUALF,HWULDO
      SAVE BGF,IIN,IOUT,ICMF,ID,Q1,Q2,XP,XBJ
      DATA EMIT,COMINT,BGFINT,COMWGT/0,3.9827,1.2462,0.3/
      DATA C1,C2,CM,B1,B2,BM/0.56,0.20,10,0.667,0.167,3/
      IF (IERROR.NE.0) RETURN
      IF (IOPT.EQ.1) THEN
C---FIND AN UNTREATED CMF
        IF (EMIT.EQ.NEVHEP+NWGTS) RETURN
        ICMF=0
        DO 10 IHEP=1,NHEP
 10       IF (ICMF.EQ.0 .AND. ISTHEP(IHEP).EQ.110 .AND.
     &    JDAHEP(2,IHEP).EQ.JDAHEP(1,IHEP)+1) ICMF=IHEP
        IF (ICMF.EQ.0) RETURN
        IIN=JMOHEP(2,ICMF)
        IOUT=JDAHEP(2,ICMF)
        ILEP=JMOHEP(1,ICMF)
        CALL HWVEQU(5,PHEP(1,IIN),P1)
        CALL HWVEQU(5,PHEP(1,IOUT),P2)
        CALL HWVEQU(5,PHEP(1,ILEP),L)
        IHAD=2
        IF (JDAHEP(1,IHAD).NE.0) IHAD=JDAHEP(1,IHAD)
        ID=IDHW(IIN)
C---STORE OLD MOMENTA
        CALL HWVEQU(5,P1,Q1)
        CALL HWVEQU(5,P2,Q2)
C---BOOST AND ROTATE THE MOMENTA TO THE BREIT FRAME
        CALL HWVDIF(4,P2,P1,PCMF)
        CALL HWUMAS(PCMF)
        CALL HWVEQU(5,PHEP(1,IHAD),PM)
        Q=-PCMF(5)
        XBJ=HALF*Q**2/HWULDO(PM,PCMF)
        CALL HWVSCA(4,HALF/XBJ,PCMF,PCMF)
        CALL HWVSUM(4,PM,PCMF,PCMF)
        CALL HWUMAS(PCMF)
        CALL HWULOF(PCMF,L,L)
        CALL HWULOF(PCMF,PM,PM)
        CALL HWUROT(PM,ONE,ZERO,R)
        CALL HWUROF(R,L,L)
        PHI=ATAN2(L(2),L(1))
        CALL HWUROT(PM,COS(PHI),SIN(PHI),R)
C---CHOOSE THE HADRONIC-PLANE CONFIGURATION, XP,ZP
        IF (HWRGEN(0).LT.COMWGT) THEN
C-----CONSIDER GENERATING A QCD COMPTON EVENT
          BGF=.FALSE.
          P3(5)=RMASS(13)
 100      RN=HWRGEN(1)
          IF (RN.LT.C1) THEN
            ZP=HWRGEN(2)
            XPMAX=MIN(ZP,1-ZP)
            XP=HWRGEN(3)*XPMAX
            FAC=1/C1*2*XPMAX/((1-XP)*(1-ZP))*
     $           (1+(1-XP-ZP+2*XP*ZP)**2+2*(1-XP)*(1-ZP)*XP*ZP)
            IF (2*HWRGEN(4).LT.1) THEN
              ZPMAX=ZP
              ZP=XP
              XP=ZPMAX
            ENDIF
          ELSEIF (RN.LT.C1+C2) THEN
            XPMAX=0.83
            XP=XPMAX*HWRGEN(2)
            ZPMIN=MAX(XP,1-XP)
            ZPMAX=1-2./3.*XP*(1+REAL( CMPLX(10-45*XP+18*XP**2,3*SQRT(
     $         3*(9+66*XP-93*XP**2+12*XP**3-8*XP**4+24*XP**5-8*XP**6)))
     $         **(1./3.) * CMPLX(0.5,0.8660254) ))
            ZP=1-((1-ZPMIN)/(1-ZPMAX))**HWRGEN(4)*(1-ZPMAX)
            FAC=1/C2*XPMAX*LOG((1-ZPMIN)/(1-ZPMAX))/(1-XP)*
     $           (1+(1-XP-ZP+2*XP*ZP)**2+2*(1-XP)*(1-ZP)*XP*ZP)
          ELSE
            ZPMAX=0.85
            ZP=ZPMAX*HWRGEN(2)
            XPMIN=MAX(ZP,1-ZP)
            XPMAX=(1+4*ZP*(1-ZP))/(1+6*ZP*(1-ZP))
            XP=1-((1-XPMIN)/(1-XPMAX))**HWRGEN(4)*(1-XPMAX)
            FAC=1/(1-C1-C2)*ZPMAX*LOG((1-XPMIN)/(1-XPMAX))/(1-ZP)*
     $           (1+(1-XP-ZP+2*XP*ZP)**2+2*(1-XP)*(1-ZP)*XP*ZP)
          ENDIF
          XPMAX=(1+4*ZP*(1-ZP))/(1+6*ZP*(1-ZP))
          ZPMAX=1-2./3.*XP*(1+REAL( CMPLX(10-45*XP+18*XP**2,3*SQRT(
     $         3*(9+66*XP-93*XP**2+12*XP**3-8*XP**4+24*XP**5-8*XP**6)))
     $         **(1./3.) * CMPLX(0.5,0.8660254) ))
          IF (XP.GT.XPMAX.OR.ZP.GT.ZPMAX.OR.CM*HWRGEN(4).GT.FAC)
     $         GOTO 100
        ELSE
C-----CONSIDER GENERATING A BGF EVENT
          BGF=.TRUE.
          P3(5)=P1(5)
          P1(5)=RMASS(13)
 110      RN=HWRGEN(1)
          IF (RN.LT.B1) THEN
            ZP=HWRGEN(2)
            XPMAX=MIN(ZP,1-ZP)
            XP=HWRGEN(3)*XPMAX
            FAC=1/B1*2*XPMAX/(1-ZP)*
     $           ((  XP+ZP-2*XP*ZP)**2+2*(1-XP)*(1-ZP)*XP*ZP
     $           +(1-XP-ZP+2*XP*ZP)**2+2*(1-XP)*(1-ZP)*XP*ZP)
            IF (2*HWRGEN(4).LT.1) XP=1-XP
          ELSEIF (RN.LT.B1+B2) THEN
            XPMAX=0.83
            XP=XPMAX*HWRGEN(2)
            ZPMIN=MAX(XP,1-XP)
            ZPMAX=1-2./3.*XP*(1+REAL( CMPLX(10-45*XP+18*XP**2,3*SQRT(
     $         3*(9+66*XP-93*XP**2+12*XP**3-8*XP**4+24*XP**5-8*XP**6)))
     $         **(1./3.) * CMPLX(0.5,0.8660254) ))
            ZP=1-((1-ZPMIN)/(1-ZPMAX))**HWRGEN(4)*(1-ZPMAX)
            FAC=1/B2*XPMAX*LOG((1-ZPMIN)/(1-ZPMAX))*
     $           ((  XP+ZP-2*XP*ZP)**2+2*(1-XP)*(1-ZP)*XP*ZP
     $           +(1-XP-ZP+2*XP*ZP)**2+2*(1-XP)*(1-ZP)*XP*ZP)
          ELSE
            XPMAX=0.83
            XP=XPMAX*HWRGEN(2)
            ZPMAX=MIN(XP,1-XP)
            ZPMIN=2./3.*XP*(1+REAL( CMPLX(10-45*XP+18*XP**2,3*SQRT(
     $         3*(9+66*XP-93*XP**2+12*XP**3-8*XP**4+24*XP**5-8*XP**6)))
     $         **(1./3.) * CMPLX(0.5,0.8660254) ))
            ZP=(ZPMAX-ZPMIN)*HWRGEN(4)+ZPMIN
            FAC=1/(1-B1-B2)*XPMAX*(ZPMAX-ZPMIN)/(1-ZP)*
     $           ((  XP+ZP-2*XP*ZP)**2+2*(1-XP)*(1-ZP)*XP*ZP
     $           +(1-XP-ZP+2*XP*ZP)**2+2*(1-XP)*(1-ZP)*XP*ZP)
          ENDIF
          ZPMAX=1-2./3.*XP*(1+REAL( CMPLX(10-45*XP+18*XP**2,3*SQRT(
     $         3*(9+66*XP-93*XP**2+12*XP**3-8*XP**4+24*XP**5-8*XP**6)))
     $         **(1./3.) * CMPLX(0.5,0.8660254) ))
          IF (ZP.GT.ZPMAX.OR.ZP.LT.1-ZPMAX.OR.BM*HWRGEN(4).GT.FAC)
     $         GOTO 110
        ENDIF
C---CALCULATE THE ADDITIONAL FACTORS IN THE WEIGHT
        IF (BGF) THEN
          IDNEW=13
          CFAC=1./2
          FAC=BGFINT/(1-COMWGT)
        ELSE
          IDNEW=ID
          CFAC=4./3
          FAC=COMINT/COMWGT
        ENDIF
        SCALE=Q*SQRT((1-XP)*(1-ZP)*ZP/XP+1)
        ITEMP=ISTAT
        ISTAT=7
        CALL HWSFUN(XBJ,Q,IDHW(IHAD),NSTRU,PDFOLD,2)
        ISTAT=ITEMP
        IF (PDFOLD(ID).LE.0) CALL HWWARN('HWBDIS',100,*999)
        IF (XP.GT.XBJ) THEN
          CALL HWSFUN(XBJ/XP,SCALE,IDHW(IHAD),NSTRU,PDFNEW,2)
          FAC=CFAC/(2*PIFAC) * HWUALF(1,SCALE) * FAC *
     $         PDFNEW(IDNEW)/PDFOLD(ID)
        ELSE
          FAC=0
        ENDIF
C---FOR PHOTON BEAMS, INCLUDE DIRECT PHOTON COUPLING
        IF (IDHW(IHAD).EQ.59) THEN
          ZPMIN=2./3.*XBJ*(1+REAL( CMPLX(10-45*XBJ+18*XBJ**2,3*SQRT(
     $         3*(9+66*XBJ-93*XBJ**2+12*XBJ**3-8*XBJ**4+24*XBJ**5
     $         -8*XBJ**6)))**(1./3.) * CMPLX(0.5,0.8660254) ))
          ZPMAX=1-ZPMIN
          DIR1=(XBJ**2+(1-XBJ)**2)*(LOG(ZPMAX/ZPMIN)-(ZPMAX-ZPMIN))
          DIR2=4*XBJ*(1-XBJ)*(ZPMAX-ZPMIN)
          DIR=QFCH(MOD(ID-1,6)+1)**2*ALPHEM/(2*PIFAC*PDFOLD(ID))*XBJ
     $         *(DIR1+DIR2)
        ELSE
          DIR=0
        ENDIF
C---DECIDE WHETHER TO MAKE AN EVENT HERE
        IF (HWRGEN(4).GT.FAC+DIR) RETURN
C---FOR DIRECT COUPLING, CHOOSE ZP VALUE
        IF ((FAC+DIR)*HWRGEN(8).GT.FAC) THEN
          IF ((DIR1+DIR2)*HWRGEN(9).LT.DIR1) THEN
            NTRY=0
 120        NTRY=NTRY+2
            ZP=1-(ZPMAX/ZPMIN)**HWRGEN(NTRY+1)*ZPMIN
            IF ((ZPMIN**2+(1-ZPMIN)**2)*HWRGEN(NTRY).GT.ZP**2+(1-ZP)**2)
     $           GOTO 120
          ELSE
            ZP=SQRT((ZPMAX-ZPMIN)*HWRGEN(10)+ZPMIN**2)
          ENDIF
          XP=XBJ
          BGF=.TRUE.
          P3(5)=P2(5)
          P1(5)=0
        ENDIF
        X1=1-   ZP /XP
        X2=1-(1-ZP)/XP
        XTSQ=4*(1-XP)*(1-ZP)*ZP/XP
        XT=SQRT(XTSQ)
        SIN1=XT/SQRT(X1**2+XTSQ)
        SIN2=XT/SQRT(X2**2+XTSQ)
C---CHOOSE THE AZIMUTH BETWEEN THE TWO PLANES
        IF (BGF) THEN
          W1=XP**2*(X1**2+1.5*XTSQ)
        ELSE
          W1=1
        ENDIF
        W2=XP**2*(X2**2+1.5*XTSQ)
        IF (HWRGEN(5)*(W1+W2).GT.W2) THEN
          IF (BGF) THEN
C-----WEIGHTED BY (1+SIN1*COS(PHI))**2
 200        PHI=(2*HWRGEN(6)-1)*PIFAC
            IF (HWRGEN(7)*(1+SIN1)**2.GT.(1+SIN1*COS(PHI))**2) GOTO 200
          ELSE
C-----UNIFORMLY
            PHI=(2*HWRGEN(6)-1)*PIFAC
          ENDIF
        ELSE
C-----WEIGHTED BY (1-SIN2*COS(PHI))**2
 210      PHI=(2*HWRGEN(6)-1)*PIFAC
          IF (HWRGEN(7)*(1+SIN2)**2.GT.(1-SIN2*COS(PHI))**2) GOTO 210
        ENDIF
C---RECONSTRUCT MOMENTA AND BOOST BACK TO LAB
        P1(1)=0
        P1(2)=0
        P1(3)=HALF*Q/XP
        P1(4)=SQRT(P1(3)**2+P1(5)**2)
        PTSQ=((ZP*Q*(P1(4)+P1(3)-Q)-P2(5)**2)*(P1(4)-P1(3)+(1-ZP)*Q)
     $       -P3(5)**2*ZP*Q)/(P1(4)-P1(3)+Q)
C---CHECK INFRARED CUTOFF FOR THIS PARTON TYPE
        IF (PTSQ.LT.MAX(HWBVMC(ID),HWBVMC(IDHW(IOUT)))**2) RETURN
        P2(1)=SQRT(PTSQ)*COS(PHI)
        P2(2)=SQRT(PTSQ)*SIN(PHI)
        P2(3)=-0.5*(ZP*Q-(PTSQ+P2(5)**2)/(ZP*Q))
        P2(4)= 0.5*(ZP*Q+(PTSQ+P2(5)**2)/(ZP*Q))
        P3(1)=P1(1)-P2(1)
        P3(2)=P1(2)-P2(2)
        P3(3)=P1(3)-P2(3)-Q
        P3(4)=P1(4)-P2(4)
        CALL HWUROB(R,P1,P1)
        CALL HWUROB(R,P2,P2)
        CALL HWUROB(R,P3,P3)
        CALL HWULOB(PCMF,P1,P1)
        CALL HWULOB(PCMF,P2,P2)
        CALL HWULOB(PCMF,P3,P3)
C---SPECIAL CASE FOR DIRECT PHOTON - COPY THE EXACT BEAM MOMENTUM
C---SHARE THE MISMATCH EQUALLY BETWEEN THE OUTGOING PARTONS
C---AND PUT THEM BACK ON SHELL
        IF (XP.EQ.XBJ) THEN
          CALL HWVDIF(4,PHEP(1,IHAD),P1,PM)
          CALL HWVSCA(4,HALF,PM,PM)
          CALL HWVSUM(4,PM,P2,P2)
          CALL HWVSUM(4,PM,P3,P3)
          CALL HWUMAS(P2)
          CALL HWUMAS(P3)
          CALL HWVEQU(5,PHEP(1,IHAD),P1)
          CALL HWVSUM(4,P2,P3,PCMF)
          CALL HWUMAS(PCMF)
          POLD=HWULDO(P2,PCMF)**2/PCMF(5)**2-SIGN(P2(5)**2,P2(5))
          PNEW=PCMF(5)**2/4-RMASS(ID)**2
          IF (PCMF(5).LE.0.OR.POLD.LE.0.OR.PNEW.LE.0) RETURN
          CALL HWVSCA(4,SQRT(PNEW/POLD),P2,P2)
          CALL HWVSCA(4,HALF-HWULDO(P2,PCMF)/PCMF(5)**2,PCMF,PM)
          CALL HWVSUM(4,PM,P2,P2)
          CALL HWUMAS(P2)
          CALL HWVDIF(4,PCMF,P2,P3)
          CALL HWUMAS(P3)
        ENDIF
        NHEP=NHEP+1
        CALL HWVEQU(5,P1,PHEP(1,IIN))
        IF (BGF.AND.ID.GT.6.OR..NOT.BGF.AND.ID.LT.7) THEN
          CALL HWVEQU(5,P2,PHEP(1,IOUT))
          CALL HWVEQU(5,P3,PHEP(1,NHEP))
        ELSE
          CALL HWVEQU(5,P3,PHEP(1,IOUT))
          CALL HWVEQU(5,P2,PHEP(1,NHEP))
        ENDIF
        CALL HWVSUM(4,PHEP(1,ILEP),PHEP(1,IIN),PHEP(1,ICMF))
        CALL HWUMAS(PHEP(1,ICMF))
C Decide which quark radiated and assign production vertices
        IF (BGF) THEN
C Boson-Gluon fusion case
          IF (1-ZP.LT.HWRGEN(0)) THEN
C Gluon splitting to quark
            CALL HWVZRO(4,VHEP(1,NHEP-1))
            CALL HWVDIF(4,PHEP(1,NHEP-4),PHEP(1,NHEP),PVRT)
            CALL HWUDKL(ID,PVRT,VHEP(1,NHEP))
            CALL HWVEQU(4,VHEP(1,NHEP),VHEP(1,NHEP-4))
          ELSE
C Gluon splitting to antiquark
            CALL HWVZRO(4,VHEP(1,NHEP))
            CALL HWVDIF(4,PHEP(1,NHEP-4),PHEP(1,NHEP-1),PVRT)
            CALL HWUDKL(ID,PVRT,VHEP(1,NHEP-1))
            CALL HWVEQU(4,VHEP(1,NHEP-1),VHEP(1,NHEP-4))
          ENDIF
        ELSE
C QCD Compton case
          IF (1.LT.HWRGEN(0)*(1+(1-XP-ZP)**2+6*XP*(1-XP)*ZP*(1-ZP)))THEN
C Incoming quark radiated the gluon
            CALL HWVZRO(4,VHEP(1,NHEP-1))
            CALL HWVDIF(4,PHEP(1,NHEP-4),PHEP(1,NHEP),PVRT)
            CALL HWUDKL(ID,PVRT,VHEP(1,NHEP))
            CALL HWVEQU(4,VHEP(1,NHEP),VHEP(1,NHEP-4))
          ELSE
C Outgoing quark radiated the gluon
            CALL HWVZRO(4,VHEP(1,NHEP-4))
            CALL HWVSUM(4,PHEP(1,NHEP-1),PHEP(1,NHEP),PVRT)
            CALL HWUDKL(ID,PVRT,VHEP(1,NHEP))
            CALL HWVEQU(4,VHEP(1,NHEP),VHEP(1,NHEP-1))
          ENDIF
        ENDIF
C---STATUS, ID AND POINTERS
        ISTHEP(NHEP)=114
        IF (BGF) THEN
          IF (XP.EQ.XBJ) THEN
            IDHW(IIN)=59
            IDHEP(IIN)=IDPDG(59)
          ELSE
            IDHW(IIN)=13
            IDHEP(IIN)=IDPDG(13)
          ENDIF
          IF (ID.LT.7) THEN
            IDHW(NHEP)=IDHW(IOUT)
            IDHEP(NHEP)=IDHEP(IOUT)
            IDHW(IOUT)=MOD(ID,6)+6
            IDHEP(IOUT)=IDPDG(IDHW(IOUT))
          ELSE
            IDHW(NHEP)=MOD(ID,6)
            IDHEP(NHEP)=IDPDG(IDHW(NHEP))
          ENDIF
        ELSEIF (ID.LT.7) THEN
          IDHW(NHEP)=13
          IDHEP(NHEP)=IDPDG(13)
        ELSE
          IDHW(NHEP)=IDHW(IOUT)
          IDHEP(NHEP)=IDHEP(IOUT)
          IDHW(IOUT)=13
          IDHEP(IOUT)=IDPDG(13)
        ENDIF
        JDAHEP(2,ICMF)=NHEP
        JMOHEP(1,NHEP)=ICMF
C---COLOUR CONNECTIONS
        IF (XP.EQ.XBJ) THEN
          JMOHEP(2,IIN)=IIN
          JDAHEP(2,IIN)=IIN
          JMOHEP(2,IOUT)=NHEP
          JDAHEP(2,IOUT)=NHEP
          JMOHEP(2,NHEP)=IOUT
          JDAHEP(2,NHEP)=IOUT
        ELSE
          JDAHEP(2,IIN)=NHEP
          JDAHEP(2,NHEP)=IOUT
          JMOHEP(2,IOUT)=NHEP
          JMOHEP(2,NHEP)=IIN
        ENDIF
C---FACTORISATION SCALE
        EMSCA=SCALE
        EMIT=NEVHEP+NWGTS
      ELSEIF (IOPT.EQ.2) THEN
C---MAKE TWO-JET EVENTS LOOK LIKE ONE-JET EVENTS
        IF (EMIT.NE.NEVHEP+NWGTS .OR. XP.EQ.XBJ) RETURN
        IF (.NOT.BGF) THEN
          CALL HWVEQU(5,Q1,PHEP(1,IIN))
          CALL HWVEQU(5,Q2,PHEP(1,IOUT))
          JMOHEP(2,IIN)=IOUT
          JDAHEP(2,IIN)=IOUT
          JMOHEP(2,IOUT)=IIN
          JDAHEP(2,IOUT)=IIN
          JDAHEP(2,ICMF)=IOUT
          IHEP=JDAHEP(1,IOUT)
          JHEP=JDAHEP(1,IOUT+1)
          CALL HWVSUM(4,PHEP(1,IHEP),PHEP(1,JHEP),PHEP(1,IHEP))
          CALL HWUMAS(PHEP(1,IHEP))
          JDAHEP(2,IHEP)=JDAHEP(2,JHEP)
          IEDT(1)=IOUT+1
          IEDT(2)=JHEP
          IEDT(3)=JHEP+1
          NDEL=3
          IF (ISTHEP(JHEP+1).NE.100) NDEL=2
          IHEP=JDAHEP(1,IOUT)
          JMOHEP(1,IHEP)=IOUT
          IF (ISTHEP(IHEP+1).EQ.100) THEN
            JMOHEP(1,IHEP+1)=IOUT
            JMOHEP(2,IHEP+1)=IIN
          ENDIF
          DO 300 JHEP=JDAHEP(1,IHEP),JDAHEP(2,IHEP)
            JMOHEP(1,JHEP)=IHEP
 300      CONTINUE
          IF (IDHW(IOUT).EQ.13) IDHW(IOUT)=IDHW(IOUT+1)
          IDHEP(IOUT)=IDPDG(IDHW(IOUT))
          IDHW(IHEP)=IDHW(IOUT)
          CALL HWUEDT(NDEL,IEDT)
        ELSEIF (ID.LT.7) THEN
          CALL HWVEQU(5,Q1,PHEP(1,IIN))
          CALL HWVEQU(5,Q2,PHEP(1,IOUT+1))
          JMOHEP(2,IIN)=IOUT+1
          JDAHEP(2,IIN)=IOUT+1
          JMOHEP(2,IOUT+1)=IIN
          JDAHEP(2,IOUT+1)=IIN
          JDAHEP(2,ICMF)=IOUT+1
          IHEP=JDAHEP(1,IIN)
          JHEP=JDAHEP(1,IOUT)
          CALL HWVDIF(4,PHEP(1,IHEP),PHEP(1,JHEP),PHEP(1,IHEP))
          CALL HWUMAS(PHEP(1,IHEP))
          CALL HWVDIF(4,PHEP(1,ICMF),PHEP(1,JHEP),PHEP(1,ICMF))
          CALL HWUMAS(PHEP(1,ICMF))
          CALL HWUEMV(JDAHEP(2,JHEP)-JDAHEP(1,JHEP)+1,
     $         JDAHEP(1,JHEP),JDAHEP(2,IHEP))
          JHEP=JDAHEP(1,IOUT)
          JDAHEP(2,IHEP)=JDAHEP(2,JHEP)
          IEDT(1)=IOUT
          IEDT(2)=JHEP
          IEDT(3)=JHEP+1
          NDEL=3
          IF (ISTHEP(JHEP+1).NE.100) NDEL=2
          CALL HWUEDT(NDEL,IEDT)
          IHEP=JDAHEP(1,IIN)
          DO 400 JHEP=JDAHEP(1,IHEP),JDAHEP(2,IHEP)
            JMOHEP(1,JHEP)=IHEP
 400      CONTINUE
          IDHW(IIN)=ID
          IDHEP(IIN)=IDPDG(ID)
          IDHW(IHEP)=ID
        ELSE
          CALL HWVEQU(5,Q1,PHEP(1,IIN))
          CALL HWVEQU(5,Q2,PHEP(1,IOUT))
          JMOHEP(2,IIN)=IOUT
          JDAHEP(2,IIN)=IOUT
          JMOHEP(2,IOUT)=IIN
          JDAHEP(2,IOUT)=IIN
          JDAHEP(2,ICMF)=IOUT
          IHEP=JDAHEP(1,IIN)
          JHEP=JDAHEP(1,IOUT+1)
          CALL HWVDIF(4,PHEP(1,IHEP),PHEP(1,JHEP),PHEP(1,IHEP))
          CALL HWUMAS(PHEP(1,IHEP))
          CALL HWVDIF(4,PHEP(1,ICMF),PHEP(1,JHEP),PHEP(1,ICMF))
          CALL HWUMAS(PHEP(1,ICMF))
          CALL HWUEMV(JDAHEP(2,JHEP)-JDAHEP(1,JHEP)+1,
     $         JDAHEP(1,JHEP),JDAHEP(1,IHEP)-1)
          JHEP=JDAHEP(1,IOUT+1)
          JDAHEP(1,IHEP)=JDAHEP(1,JHEP)
          IEDT(1)=IOUT+1
          IEDT(2)=JHEP
          IEDT(3)=JHEP+1
          NDEL=3
          IF (ISTHEP(JHEP+1).NE.100.OR.JHEP.EQ.NHEP) NDEL=2
          CALL HWUEDT(NDEL,IEDT)
          IHEP=JDAHEP(1,IIN)
          DO 500 JHEP=JDAHEP(1,IHEP),JDAHEP(2,IHEP)
            JMOHEP(1,JHEP)=IHEP
 500      CONTINUE
          IDHW(IIN)=ID
          IDHEP(IIN)=IDPDG(ID)
          IDHW(IHEP)=ID
        ENDIF
        CALL HWVZRO(4,VHEP(1,IIN))
        CALL HWVZRO(4,VHEP(1,JDAHEP(1,IIN)))
        IF (ISTHEP(JDAHEP(1,IIN)+1).EQ.100)
     $       CALL HWVZRO(4,VHEP(1,JDAHEP(1,IIN)+1))
        CALL HWVZRO(4,VHEP(1,IOUT))
        CALL HWVZRO(4,VHEP(1,JDAHEP(1,IOUT)))
        IF (ISTHEP(JDAHEP(1,IOUT)+1).EQ.100)
     $       CALL HWVZRO(4,VHEP(1,JDAHEP(1,IOUT)+1))
        EMIT=0
      ELSE
        CALL HWWARN('HWBDIS',500,*999)
      ENDIF
 999  END
CDECK  ID>, HWBFIN.
*CMZ :-        -26/04/91  10.18.56  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWBFIN(IHEP)
C-----------------------------------------------------------------------
C     DELETES INTERNAL LINES FROM SHOWER, MAKES COLOUR CONNECTION INDEX
C     AND COPIES INTO /HEPEVT/ IN COLOUR ORDER.
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      INTEGER IHEP,ID,IJET,KHEP,IPAR,JPAR,NXPAR,IP,JP
      IF (IERROR.NE.0) RETURN
C---SAVE VIRTUAL PARTON DATA
      NHEP=NHEP+1
      ID=IDPAR(2)
      IDHW(NHEP)=ID
      IDHEP(NHEP)=IDPDG(ID)
      ISTHEP(NHEP)=ISTHEP(IHEP)+20
      JMOHEP(1,NHEP)=IHEP
      JMOHEP(2,NHEP)=JMOHEP(1,IHEP)
      JDAHEP(1,IHEP)=NHEP
      JDAHEP(1,NHEP)=0
      JDAHEP(2,NHEP)=0
      CALL HWVEQU(5,PPAR(1,2),PHEP(1,NHEP))
      CALL HWVEQU(4,VPAR(1,2),VHEP(1,NHEP))
C---FINISHED FOR SPECTATOR OR NON-PARTON JETS
      IF (ISTHEP(NHEP).GT.136) RETURN
      IF (ID.GT.13.AND.ID.LT.209 .AND. ID.NE.59) RETURN
      IF (ID.GT.220) RETURN
      IF (.NOT.TMPAR(2).AND.ID.EQ.59) RETURN
      IDHEP(NHEP)=94
      IJET=NHEP
      IF (NPAR.GT.2) THEN
C---SAVE CONE DATA
        NHEP=NHEP+1
        IDHW(NHEP)=IDPAR(1)
        IDHEP(NHEP)=0
        ISTHEP(NHEP)=100
        JMOHEP(1,NHEP)=IHEP
        JMOHEP(2,NHEP)=JCOPAR(1,1)
        JDAHEP(1,NHEP)=0
        JDAHEP(2,NHEP)=0
        CALL HWVEQU(5,PPAR,PHEP(1,NHEP))
        CALL HWVEQU(4,VPAR(1,2),VHEP(1,NHEP))
      ENDIF
      KHEP=NHEP
C---START WITH ANTICOLOUR DAUGHTER OF HARDEST PARTON
      IPAR=2
      JPAR=JCOPAR(4,IPAR)
      NXPAR=NPAR/2
      DO 20 IP=1,NXPAR
      DO 10 JP=1,NXPAR
      IF (JPAR.EQ.0) GOTO 15
      IF (JCOPAR(2,JPAR).EQ.IPAR) THEN
        IPAR=JPAR
        JPAR=JCOPAR(4,IPAR)
      ELSE
        IPAR=JPAR
        JPAR=JCOPAR(1,IPAR)
      ENDIF
   10 CONTINUE
C---COULDN'T FIND COLOUR PARTNER
      CALL HWWARN('HWBFIN',1,*999)
   15 JPAR=JCOPAR(1,IPAR)
      KHEP=KHEP+1
      ID=IDPAR(IPAR)
      IF (TMPAR(IPAR)) THEN
        IF (ID.LT.14) THEN
          ISTHEP(KHEP)=139
        ELSEIF (ID.EQ.59) THEN
          ISTHEP(KHEP)=139
        ELSEIF (ID.LT.109) THEN
          ISTHEP(KHEP)=130
        ELSEIF (ID.LT.120) THEN
          ISTHEP(KHEP)=139
        ELSE
          ISTHEP(KHEP)=130
        ENDIF
      ELSE
        ISTHEP(KHEP)=ISTHEP(IHEP)+24
      ENDIF
      IDHW(KHEP)=ID
      IDHEP(KHEP)=IDPDG(ID)
      CALL HWVEQU(5,PPAR(1,IPAR),PHEP(1,KHEP))
      CALL HWVEQU(4,VPAR(1,IPAR),VHEP(1,KHEP))
      JMOHEP(1,KHEP)=IJET
      JMOHEP(2,KHEP)=KHEP+1
      JDAHEP(1,KHEP)=0
      JDAHEP(2,KHEP)=KHEP-1
   20 CONTINUE
      JMOHEP(2,KHEP)=0
      JDAHEP(2,NHEP+1)=0
      JDAHEP(1,IJET)=NHEP+1
      JDAHEP(2,IJET)=KHEP
      NHEP=KHEP
  999 END
CDECK  ID>, HWBGEN.
*CMZ :-        -26/04/91  14.15.56  by  Federico Carminati
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWBGEN
C-----------------------------------------------------------------------
C     BRANCHING GENERATOR WITH INTERFERING GLUONS
C     HWBGEN EVOLVES QCD JETS ACCORDING TO THE METHOD OF
C     G.MARCHESINI & B.R.WEBBER, NUCL. PHYS. B238(1984)1
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWULDO,HWRGAU,EINHEP,ERTXI,RTXI,XF
      INTEGER NTRY,LASHEP,IHEP,NRHEP,ID,IST,JHEP,KPAR,I,J,IRHEP(NMXJET),
     & IRST(NMXJET)
      LOGICAL HWRLOG
      EXTERNAL HWULDO,HWRGAU
      IF (IERROR.NE.0) RETURN
      IF (IPRO.EQ.80) RETURN
C---CHECK THAT EMSCA IS SET
      IF (EMSCA.LE.ZERO) CALL HWWARN('HWBGEN',200,*999)
      IF (HARDME) THEN
C---FORCE A BRANCH INTO THE `DEAD ZONE' IN E+E-
        IF (IPROC/10.EQ.10) CALL HWBDED(1)
C---FORCE A BRANCH INTO THE `DEAD ZONE' IN DIS
        IF (IPRO.EQ.90) CALL HWBDIS(1)
      ENDIF
      NTRY=0
      LASHEP=NHEP
   10 NTRY=NTRY+1
      IF (NTRY.GT.NETRY) CALL HWWARN('HWBGEN',ISLENT*100,*999)
      NRHEP=0
      NHEP=LASHEP
      FROST=.FALSE.
      DO 100 IHEP=1,LASHEP
      IST=ISTHEP(IHEP)
      IF (IST.GE.111.AND.IST.LE.115) THEN
       NRHEP=NRHEP+1
       IRHEP(NRHEP)=IHEP
       IRST(NRHEP)=IST
       ID=IDHW(IHEP)
       IF (IST.NE.115) THEN
C---FOUND A PARTON TO EVOLVE
        NEVPAR=IHEP
        NPAR=2
        IDPAR(1)=17
        IDPAR(2)=ID
        TMPAR(1)=.TRUE.
        PPAR(2,1)=0.
        PPAR(4,1)=1.
        PPAR(5,1)=0.
        DO 15 J=1,2
        DO 15 I=1,2
        JMOPAR(I,J)=0
   15   JCOPAR(I,J)=0
C---SET UP EVOLUTION SCALE AND FRAME
        JHEP=JMOHEP(2,IHEP)
        IF (ID.EQ.13) THEN
          IF (HWRLOG(HALF)) JHEP=JDAHEP(2,IHEP)
        ELSEIF (IST.GT.112) THEN
          IF ((ID.GT.6.AND.ID.LT.13).OR.
     &        (ID.GT.214.AND.ID.LT.221)) JHEP=JDAHEP(2,IHEP)
        ELSE
          IF (ID.LT.7.OR.(ID.GT.208.AND.ID.LT.215)) JHEP=JDAHEP(2,IHEP)
        ENDIF
        IF (JHEP.EQ.0) THEN
          CALL HWWARN('HWBGEN',1,*999)
          JHEP=IHEP
        ENDIF
        JCOPAR(1,1)=JHEP
        EINHEP=PHEP(4,IHEP)
        ERTXI=HWULDO(PHEP(1,IHEP),PHEP(1,JHEP))
        IF (ERTXI.LT.0.) ERTXI=0.
        IF (IST.LE.112.AND.IHEP.EQ.JHEP) ERTXI=0.
        IF (ISTHEP(JHEP).EQ.152.OR.ISTHEP(JHEP).EQ.153) THEN
          ERTXI=ERTXI/PHEP(5,JHEP)
          RTXI=1.
        ELSE
          ERTXI=SQRT(ERTXI)
          RTXI=ERTXI/EINHEP
        ENDIF
        IF (RTXI.EQ.0.) THEN
          XF=1.
          PPAR(1,1)=0.
          PPAR(3,1)=1.
          PPAR(1,2)=EINHEP
          PPAR(2,2)=0.
          PPAR(4,2)=EINHEP
        ELSE
          XF=1./RTXI
          PPAR(1,1)=1.
          PPAR(3,1)=0.
          PPAR(1,2)=ERTXI
          PPAR(2,2)=1.
          PPAR(4,2)=ERTXI
        ENDIF
        IF (PPAR(4,2).LT.PHEP(5,IHEP)) PPAR(4,2)=PHEP(5,IHEP)
        CALL HWVZRO(4,VPAR(1,1))
        CALL HWVZRO(4,VPAR(1,2))
        IF (IST.GT.112) THEN
          TMPAR(2)=.TRUE.
          INHAD=0
          JNHAD=0
          XFACT=0.
        ELSE
          TMPAR(2)=.FALSE.
          JNHAD=IST-110
          INHAD=JNHAD
          IF (JDAHEP(1,JNHAD).NE.0) INHAD=JDAHEP(1,JNHAD)
          XFACT=XF/PHEP(4,INHAD)
          IF (PTRMS.NE.0.) THEN
C---GENERATE INTRINSIC PT
            PTINT(1,JNHAD)=HWRGAU(1,ZERO,PXRMS)
            PTINT(2,JNHAD)=HWRGAU(2,ZERO,PXRMS)
            PTINT(3,JNHAD)=PTINT(1,JNHAD)**2+PTINT(2,JNHAD)**2
          ELSE
            CALL HWVZRO(3,PTINT(1,JNHAD))
          ENDIF
          ANOMSC(1,JNHAD)=ZERO
          ANOMSC(2,JNHAD)=ZERO
        ENDIF
C---FOR QUARKS IN A COLOUR SINGLET, ALLOW SOFT MATRIX-ELEMENT CORRECTION
        HARDST=PPAR(4,2)
        IF (SOFTME.AND.IDHW(IHEP).LT.13.AND.
     $       JMOHEP(2,JHEP).EQ.IHEP.AND.JDAHEP(2,JHEP).EQ.IHEP) HARDST=0
C---CREATE BRANCHES AND COMPUTE ENERGIES
        DO 20 KPAR=2,NMXPAR
        IF (TMPAR(KPAR)) THEN
          CALL HWBRAN(KPAR)
        ELSE
          CALL HWSBRN(KPAR)
        ENDIF
        IF (IERROR.NE.0) RETURN
        IF (FROST) GOTO 100
        IF (KPAR.EQ.NPAR) GOTO 30
   20   CONTINUE
C---COMPUTE MASSES AND 3-MOMENTA
   30   CONTINUE
        CALL HWBMAS
        IF (AZSPIN) CALL HWBSPN
        IF (TMPAR(2)) THEN
           CALL HWBTIM(2,1)
        ELSE
           CALL HWBSPA
        ENDIF
C---ENTER PARTON JET IN /HEPEVT/
        CALL HWBFIN(IHEP)
       ELSE
C---COPY SPECTATOR
        NHEP=NHEP+1
        IF (ID.GT.120.AND.ID.LT.133 .OR. ID.GE.198.AND.ID.LE.201) THEN
          ISTHEP(NHEP)=190
        ELSE
          ISTHEP(NHEP)=152
        ENDIF
        IDHW(NHEP)=ID
        IDHEP(NHEP)=IDPDG(ID)
        JMOHEP(1,NHEP)=IHEP
        JMOHEP(2,NHEP)=0
        JDAHEP(2,NHEP)=0
        JDAHEP(1,IHEP)=NHEP
        CALL HWVEQU(5,PHEP(1,IHEP),PHEP(1,NHEP))
       ENDIF
       ISTHEP(IHEP)=ISTHEP(IHEP)+10
      ENDIF
  100 CONTINUE
      IF (.NOT.FROST) THEN
C---COMBINE JETS
        ISTAT=20
        CALL HWBJCO
      ENDIF
      IF (.NOT.FROST) THEN
C---ATTACH SPECTATORS
        ISTAT=30
        CALL HWSSPC
      ENDIF
      IF (FROST) THEN
C---BAD JET: RESTORE PARTONS AND RE-EVOLVE
         DO 120 I=1,NRHEP
  120    ISTHEP(IRHEP(I))=IRST(I)
         GOTO 10
      ENDIF
C---CONNECT COLOURS
      CALL HWBCON
      ISTAT=40
      IF (HARDME) THEN
C---CLEAN UP IF THERE WAS A BRANCH IN THE `DEAD ZONE' IN E+E-
        IF (IPROC/10.EQ.10) CALL HWBDED(2)
C---CLEAN UP IF THERE WAS A BRANCH IN THE `DEAD ZONE' IN DIS
        IF (IPRO.EQ.90) CALL HWBDIS(2)
      ENDIF
  999 END
CDECK  ID>, HWBJCO.
*CMZ :-        -26/04/91  14.25.31  by  Federico Carminati
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWBJCO
C-----------------------------------------------------------------------
C     COMBINES JETS WITH REQUIRED KINEMATICS
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWULDO,EPS,PTX,PTY,PF,PTINF,PTCON,CN,CP,SP,PP0,
     & PM0,ET0,DET,ECM,EMJ,EMP,EMS,DMS,ES,DPF,ALF,AL(2),ET(2),PP(2),
     & PT(3),PB(5),PC(5),PQ(5),PR(5),PS(5),RR(3,3),RS(3,3),ETC,
     & PJ(NMXJET),PM(NMXJET),PBR(5),RBR(3,3),DISP(4)
      INTEGER LJET,IJ1,IST,IP,ICM,IP1,IP2,NP,IHEP,MHEP,JP,KP,LP,KHEP,
     & JHEP,NE,IJT,IEND(2),IJET(NMXJET),IPAR(NMXJET)
      LOGICAL AZCOR,JETRAD,DISPRO,DISLOW
      EXTERNAL HWULDO
      PARAMETER (EPS=1.D-4)
      IF (IERROR.NE.0) RETURN
      AZCOR=AZSOFT.OR.AZSPIN
C---FIRST LOOK FOR SPACELIKE JETS
      LJET=131
  10  IJET(1)=1
  20  IJ1=IJET(1)
      DO 40 IHEP=IJ1,NHEP
      IST=ISTHEP(IHEP)
      IF (IST.EQ.137.OR.IST.EQ.138) IST=133
      IF (IST.EQ.LJET) THEN
C---FOUND AN UNBOOSTED JET - FIND PARTNERS
        IP=JMOHEP(1,IHEP)
        ICM=JMOHEP(1,IP)
        DISPRO=IPRO/10.EQ.9.AND.IDHW(ICM).EQ.15
        DISLOW=DISPRO.AND.JDAHEP(1,ICM).EQ.JDAHEP(2,ICM)-1
        IF (IST.EQ.131) THEN
          IP1=JMOHEP(1,ICM)
          IP2=JMOHEP(2,ICM)
        ELSE
          IP1=JDAHEP(1,ICM)
          IP2=JDAHEP(2,ICM)
        ENDIF
        IF (IP1.NE.IP) CALL HWWARN('HWBJCO',100,*999)
        NP=0
        DO 30 JHEP=IP1,IP2
        NP=NP+1
        IPAR(NP)=JHEP
  30    IJET(NP)=JDAHEP(1,JHEP)
        GOTO 50
      ENDIF
  40  CONTINUE
C---NO MORE JETS?
      IF (LJET.EQ.131) THEN
        LJET=133
        GOTO 10
      ENDIF
      RETURN
  50  IF (LJET.EQ.131) THEN
C---SPACELIKE JETS: FIND SPACELIKE PARTONS
        IF (NP.NE.2) CALL HWWARN('HWBJCO',103,*999)
C---special for DIS: FIND BOOST AND ROTATION FROM LAB TO BREIT FRAME
        IF (DISPRO.AND.BREIT) THEN
          IP=2
          IF (JDAHEP(1,IP).NE.0) IP=JDAHEP(1,IP)
          CALL HWVDIF(4,PHEP(1,JMOHEP(1,ICM)),PHEP(1,JDAHEP(1,ICM)),PB)
          CALL HWUMAS(PB)
C---IF Q**2<10**-2, SOMETHING MUST HAVE ALREADY GONE WRONG
          IF (PB(5)**2.LT.1.D-2) CALL HWWARN('HWBJCO',102,*999)
          CALL HWVSCA(4,PB(5)**2/HWULDO(PHEP(1,IP),PB),PHEP(1,IP),PBR)
          CALL HWVSUM(4,PB,PBR,PBR)
          CALL HWUMAS(PBR)
          CALL HWULOF(PBR,PB,PB)
          CALL HWUROT(PB,ONE,ZERO,RBR)
        ENDIF
        PTX=0.
        PTY=0.
        PF=1.D0
        DO 90 IP=1,2
        MHEP=IJET(IP)
        IF (JDAHEP(1,MHEP).EQ.0) THEN
C---SPECIAL FOR NON-PARTON JETS
          IHEP=MHEP
          GOTO 70
        ELSE
          IST=134+IP
          DO 60 IHEP=MHEP,NHEP
  60      IF (ISTHEP(IHEP).EQ.IST) GOTO 70
C---COULDN'T FIND SPACELIKE PARTON
          CALL HWWARN('HWBJCO',101,*999)
        ENDIF
  70    CALL HWVSCA(3,PF,PHEP(1,IHEP),PS)
        IF (PTINT(3,IP).GT.0.) THEN
C---ADD INTRINSIC PT
          PT(1)=PTINT(1,IP)
          PT(2)=PTINT(2,IP)
          PT(3)=0.
          CALL HWUROT(PS, ONE,ZERO,RS)
          CALL HWUROB(RS,PT,PT)
          CALL HWVSUM(3,PS,PT,PS)
        ENDIF
        JP=IJET(IP)+1
        IF (AZCOR.AND.JP.LE.NHEP.AND.IDHW(JP).EQ.17) THEN
C---ALIGN CONE WITH INTERFERING PARTON
          CALL HWUROT(PS, ONE,ZERO,RS)
          CALL HWUROF(RS,PHEP(1,JP),PR)
          PTCON=PR(1)**2+PR(2)**2
          KP=JMOHEP(2,JP)
          IF (KP.EQ.0) THEN
            CALL HWWARN('HWBJCO',1,*999)
            PTINF=0.
          ELSE
            CALL HWVEQU(4,PHEP(1,KP),PB)
            IF (DISPRO.AND.BREIT) THEN
              CALL HWULOF(PBR,PB,PB)
              CALL HWUROF(RBR,PB,PB)
            ENDIF
            PTINF=PB(1)**2+PB(2)**2
            IF (PTINF.LT.EPS) THEN
C---COLLINEAR JETS: ALIGN CONES
              KP=JDAHEP(1,KP)+1
              IF (ISTHEP(KP).EQ.100.AND.ISTHEP(KP-1)/10.EQ.14) THEN
                CALL HWVEQU(4,PHEP(1,KP),PB)
                IF (DISPRO.AND.BREIT) THEN
                  CALL HWULOF(PBR,PB,PB)
                  CALL HWUROF(RBR,PB,PB)
                ENDIF
                PTINF=PB(1)**2+PB(2)**2
              ELSE
                PTINF=0.
              ENDIF
            ENDIF
          ENDIF
          IF (PTCON.NE.0..AND.PTINF.NE.0.) THEN
            CN=1./SQRT(PTINF*PTCON)
            CP=CN*(PR(1)*PB(1)+PR(2)*PB(2))
            SP=CN*(PR(1)*PB(2)-PR(2)*PB(1))
          ELSE
            CALL HWRAZM( ONE,CP,SP)
          ENDIF
        ELSE
          CALL HWRAZM( ONE,CP,SP)
        ENDIF
C---ROTATE SO SPACELIKE IS ALONG AXIS (APART FROM INTRINSIC PT)
        CALL HWUROT(PS,CP,SP,RS)
        IHEP=IJET(IP)
        KHEP=JDAHEP(2,IHEP)
        IF (KHEP.LT.IHEP) KHEP=IHEP
        IEND(IP)=KHEP
        DO 80 JHEP=IHEP,KHEP
        CALL HWUROF(RS,PHEP(1,JHEP),PHEP(1,JHEP))
  80    CALL HWUROF(RS,VHEP(1,JHEP),VHEP(1,JHEP))
        PP(IP)=PHEP(4,IHEP)+PF*PHEP(3,IHEP)
        ET(IP)=PHEP(1,IHEP)**2+PHEP(2,IHEP)**2-PHEP(5,IHEP)**2
C---REDEFINE HARD CM
        PTX=PTX+PHEP(1,IHEP)
        PTY=PTY+PHEP(2,IHEP)
  90    PF=-PF
        PHEP(1,ICM)=PTX
        PHEP(2,ICM)=PTY
C---special for DIS: keep lepton momenta fixed
        IF (DISPRO) THEN
          IP1=JMOHEP(1,ICM)
          IP2=JDAHEP(1,ICM)
          IJT=IJET(1)
C---IJT will be used to store lepton momentum transfer
          CALL HWVDIF(4,PHEP(1,IP1),PHEP(1,IP2),PHEP(1,IJT))
          CALL HWUMAS(PHEP(1,IJT))
          IF (IDHEP(IP1).EQ.IDHEP(IP2)) THEN
            IDHW(IJT)=200
          ELSEIF (IDHEP(IP1).LT.IDHEP(IP2)) THEN
            IDHW(IJT)=199
          ELSE
            IDHW(IJT)=198
          ENDIF
          IDHEP(IJT)=IDPDG(IDHW(IJT))
          ISTHEP(IJT)=3
C---calculate boost for struck parton
C   PC is momentum of outgoing parton(s)
          IP2=JDAHEP(2,ICM)
          IF (.NOT.DISLOW) THEN
C---FOR heavy QQbar PQ and PC are old and new QQbar momenta
            CALL HWVSUM(4,PHEP(1,IP2-1),PHEP(1,IP2),PQ)
            CALL HWUMAS(PQ)
            PC(5)=PQ(5)
          ELSE
            PC(5)=PHEP(5,JDAHEP(1,IP2))
          ENDIF
          CALL HWVSUM(2,PHEP(1,IJT),PHEP(1,IJET(2)),PC)
          ET(1)=ET(2)
C---USE BREIT FRAME BOSON MOMENTUM IF NECESSARY
          IF (BREIT) THEN
            ET(2)=ET(1)+PC(5)**2+PHEP(5,IJET(2))**2
            PM0=PHEP(5,IJT)
            PP0=-PM0
          ELSE
            ET(2)=PC(1)**2+PC(2)**2+PC(5)**2
            PP0=PHEP(4,IJT)+PHEP(3,IJT)
            PM0=PHEP(4,IJT)-PHEP(3,IJT)
          ENDIF
          ET0=(PP0*PM0)+ET(1)-ET(2)
          DET=ET0**2-4.*(PP0*PM0)*ET(1)
          IF (DET.LT.0.) THEN
            FROST=.TRUE.
            RETURN
          ENDIF
          ALF=(SQRT(DET)-ET0)/(2.*PP0*PP(2))
          PB(1)=0.
          PB(2)=0.
          PB(5)=2.D0
          PB(3)=ALF-(1./ALF)
          PB(4)=ALF+(1./ALF)
          DO 100 IHEP=IJET(2),IEND(2)
          CALL HWULOF(PB,PHEP(1,IHEP),PHEP(1,IHEP))
          CALL HWULF4(PB,VHEP(1,IHEP),VHEP(1,IHEP))
C---BOOST FROM BREIT FRAME IF NECESSARY
          IF (BREIT) THEN
            CALL HWUROB(RBR,PHEP(1,IHEP),PHEP(1,IHEP))
            CALL HWULOB(PBR,PHEP(1,IHEP),PHEP(1,IHEP))
            CALL HWUROB(RBR,VHEP(1,IHEP),VHEP(1,IHEP))
            CALL HWULB4(PBR,VHEP(1,IHEP),VHEP(1,IHEP))
          ENDIF
  100     ISTHEP(IHEP)=ISTHEP(IHEP)+10
          CALL HWVDIF(4,VHEP(1,IPAR(2)),VHEP(1,IJET(2)),DISP)
          DO 110 IHEP=IJET(2),IEND(2)
  110     CALL HWVSUM(4,DISP,VHEP(1,IHEP),VHEP(1,IHEP))
          IF (IEND(2).GT.IJET(2)+1) ISTHEP(IJET(2)+1)=100
          CALL HWVSUM(4,PHEP(1,IJT),PHEP(1,IJET(2)),PC)
          CALL HWVSUM(4,PHEP(1,IP1),PHEP(1,IJET(2)),PHEP(1,ICM))
          CALL HWUMAS(PHEP(1,ICM))
        ELSEIF (IPRO/10.EQ.5) THEN
C Special to preserve photon momentum
           ETC=PTX**2+PTY**2+PHEP(5,ICM)**2
           ET0=ETC+ET(1)-ET(2)
           DET=ET0**2-4.*ETC*ET(1)
           IF (DET.LT.0.) THEN
              FROST=.TRUE.
              RETURN
           ENDIF
           ALF=(SQRT(DET)+ET0-2.*ET(1))/(2.*PP(1)*PP(2))
           PB(1)=0.
           PB(2)=0.
           PB(3)=ALF-1./ALF
           PB(4)=ALF+1./ALF
           PB(5)=2.
           IJT=IJET(2)
           DO 120 IHEP=IJT,IEND(2)
           CALL HWULOF(PB,PHEP(1,IHEP),PHEP(1,IHEP))
           CALL HWULF4(PB,VHEP(1,IHEP),VHEP(1,IHEP))
  120      ISTHEP(IHEP)=ISTHEP(IHEP)+10
           CALL HWVDIF(4,VHEP(1,IPAR(2)),VHEP(1,IJT),DISP)
           DO 130 IHEP=IJT,IEND(2)
  130      CALL HWVSUM(4,DISP,VHEP(1,IHEP),VHEP(1,IHEP))
           IF (IEND(2).GT.IJT+1) ISTHEP(IJT+1)=100
           ISTHEP(IJET(1))=ISTHEP(IJET(1))+10
           CALL HWVSUM(2,PHEP(3,IPAR(1)),PHEP(3,IJT),PHEP(3,ICM))
        ELSE
          PHEP(4,ICM)=SQRT(PTX**2+PTY**2+PHEP(3,ICM)**2+PHEP(5,ICM)**2)
C---NOW BOOST TO REQUIRED Q**2 AND X-F
          PP0=PHEP(4,ICM)+PHEP(3,ICM)
          PM0=PHEP(4,ICM)-PHEP(3,ICM)
          ET0=(PP0*PM0)+ET(1)-ET(2)
          DET=ET0**2-4.*(PP0*PM0)*ET(1)
          IF (DET.LT.0.) THEN
            FROST=.TRUE.
            RETURN
          ENDIF
          DET=SQRT(DET)+ET0
          AL(1)= 2.*PM0*PP(1)/DET
          AL(2)=(PM0/PP(2))*(1.-2.*ET(1)/DET)
          PB(1)=0.
          PB(2)=0.
          PB(5)=2.
          DO 160 IP=1,2
          PB(3)=AL(IP)-(1./AL(IP))
          PB(4)=AL(IP)+(1./AL(IP))
          IJT=IJET(IP)
          DO 140 IHEP=IJT,IEND(IP)
          CALL HWULOF(PB,PHEP(1,IHEP),PHEP(1,IHEP))
          CALL HWULF4(PB,VHEP(1,IHEP),VHEP(1,IHEP))
  140     ISTHEP(IHEP)=ISTHEP(IHEP)+10
          CALL HWVDIF(4,VHEP(1,IPAR(IP)),VHEP(1,IJT),DISP)
          DO 150 IHEP=IJT,IEND(IP)
  150     CALL HWVSUM(4,DISP,VHEP(1,IHEP),VHEP(1,IHEP))
          IF (IEND(IP).GT.IJT+1) THEN
            ISTHEP(IJT+1)=100
          ELSEIF (IEND(IP).EQ.IJT) THEN
C---NON-PARTON JET
            ISTHEP(IJT)=3
          ENDIF
  160     CONTINUE
        ENDIF
        ISTHEP(ICM)=120
      ELSE
C---TIMELIKE JETS
C   special for DIS: preserve outgoing lepton momentum
        IF (DISPRO) THEN
          CALL HWVEQU(5,PHEP(1,IPAR(1)),PHEP(1,IJET(1)))
          ISTHEP(IJET(1))=1
          LP=2
        ELSE
          CALL HWVEQU(5,PHEP(1,ICM),PC)
C--- PQ AND PC ARE OLD AND NEW PARTON CM
          CALL HWVSUM(4,PHEP(1,IPAR(1)),PHEP(1,IPAR(2)),PQ)
          PQ(5)=PHEP(5,ICM)
          IF (NP.GT.2) THEN
            DO 170 KP=3,NP
  170       CALL HWVSUM(4,PHEP(1,IPAR(KP)),PQ,PQ)
          ENDIF
          LP=1
        ENDIF
        IF (.NOT.DISLOW) THEN
C---FIND JET CM MOMENTA
          ECM=PQ(5)
          EMS=0.
          JETRAD=.FALSE.
          DO 180 KP=LP,NP
          EMJ=PHEP(5,IJET(KP))
          EMP=PHEP(5,IPAR(KP))
          JETRAD=JETRAD.OR.EMJ.NE.EMP
          EMS=EMS+EMJ
          PM(KP)= EMJ**2
C---N.B. ROUNDING ERRORS HERE AT HIGH ENERGIES
          PJ(KP)=(HWULDO(PHEP(1,IPAR(KP)),PQ)/ECM)**2-EMP**2
  180     IF (PJ(KP).LE.0.) CALL HWWARN('HWBJCO',104,*999)
          PF=1.
          IF (JETRAD) THEN
C---JETS DID RADIATE
            IF (EMS.GE.ECM) THEN
              FROST=.TRUE.
              RETURN
            ENDIF
            DO 200 NE=1,NETRY
            EMS=-ECM
            DMS=0.
            DO 190 KP=LP,NP
            ES=SQRT(PF*PJ(KP)+PM(KP))
            EMS=EMS+ES
  190       DMS=DMS+PJ(KP)/ES
            DPF=2.*EMS/DMS
            IF (DPF.GT.PF) DPF=0.9*PF
            PF=PF-DPF
  200       IF (ABS(DPF).LT.EPS) GOTO 210
            CALL HWWARN('HWBJCO',105,*999)
          ENDIF
  210     CONTINUE
        ENDIF
C---BOOST PC AND PQ TO BREIT FRAME IF NECESSARY
        IF (DISPRO.AND.BREIT) THEN
          CALL HWULOF(PBR,PC,PC)
          CALL HWUROF(RBR,PC,PC)
          IF (.NOT.DISLOW) THEN
            CALL HWULOF(PBR,PQ,PQ)
            CALL HWUROF(RBR,PQ,PQ)
          ENDIF
        ENDIF
        DO 230 IP=LP,NP
C---FIND CM ROTATION FOR JET IP
        IF (.NOT.DISLOW) THEN
          CALL HWVEQU(4,PHEP(1,IPAR(IP)),PR)
          IF (DISPRO.AND.BREIT) THEN
            CALL HWULOF(PBR,PR,PR)
            CALL HWUROF(RBR,PR,PR)
          ENDIF
          CALL HWULOF(PQ,PR,PR)
          CALL HWUROT(PR, ONE,ZERO,RR)
          PR(1)=0.
          PR(2)=0.
          PR(3)=SQRT(PF*PJ(IP))
          PR(4)=SQRT(PF*PJ(IP)+PM(IP))
          PR(5)=PHEP(5,IJET(IP))
          CALL HWUROB(RR,PR,PR)
          CALL HWULOB(PC,PR,PR)
        ELSE
          CALL HWVEQU(5,PC,PR)
        ENDIF
C---NOW PR IS LAB/BREIT MOMENTUM OF JET IP
        KP=IJET(IP)+1
        IF (AZCOR.AND.KP.LE.NHEP.AND.IDHW(KP).EQ.17) THEN
C---ALIGN CONE WITH INTERFERING PARTON
          CALL HWUROT(PR, ONE,ZERO,RS)
          JP=JMOHEP(2,KP)
          IF (JP.EQ.0) THEN
            CALL HWWARN('HWBJCO',2,*999)
            PTINF=0.
          ELSE
            CALL HWVEQU(4,PHEP(1,JP),PS)
            IF (DISPRO.AND.BREIT) THEN
              CALL HWULOF(PBR,PS,PS)
              CALL HWUROF(RBR,PS,PS)
            ENDIF
            CALL HWUROF(RS,PS,PS)
            PTINF=PS(1)**2+PS(2)**2
            IF (PTINF.LT.EPS) THEN
C---COLLINEAR JETS: ALIGN CONES
              JP=JDAHEP(1,JP)+1
              IF (ISTHEP(JP).EQ.100.AND.ISTHEP(JP-1)/10.EQ.14) THEN
                CALL HWVEQU(4,PHEP(1,JP),PS)
                IF (DISPRO.AND.BREIT) THEN
                  CALL HWULOF(PBR,PS,PS)
                  CALL HWUROF(RBR,PS,PS)
                ENDIF
                CALL HWUROF(RS,PS,PS)
                PTINF=PS(1)**2+PS(2)**2
              ELSE
                PTINF=0.
              ENDIF
            ENDIF
          ENDIF
          CALL HWVEQU(4,PHEP(1,KP),PB)
          IF (DISPRO.AND.BREIT) THEN
            CALL HWULOF(PBR,PB,PB)
            CALL HWUROF(RBR,PB,PB)
          ENDIF
          PTCON=PB(1)**2+PB(2)**2
          IF (PTCON.NE.0..AND.PTINF.NE.0.) THEN
            CN=1./SQRT(PTINF*PTCON)
            CP=CN*(PS(1)*PB(1)+PS(2)*PB(2))
            SP=CN*(PS(1)*PB(2)-PS(2)*PB(1))
          ELSE
            CALL HWRAZM( ONE,CP,SP)
          ENDIF
        ELSE
          CALL HWRAZM( ONE,CP,SP)
        ENDIF
        CALL HWUROT(PR,CP,SP,RS)
C---FIND BOOST FOR JET IP
C AST add protection against -ve SQRT (From MS)
        IF (PR(4).LT.PR(5)) THEN
          FROST=.TRUE.
          RETURN
        ENDIF
        ALF=(PHEP(3,IJET(IP))+PHEP(4,IJET(IP)))/
     &      (PR(4)+SQRT((PR(4)+PR(5))*(PR(4)-PR(5))))
        PB(1)=0.
        PB(2)=0.
        PB(3)=ALF-(1./ALF)
        PB(4)=ALF+(1./ALF)
        PB(5)=2.
        IHEP=IJET(IP)
        KHEP=JDAHEP(2,IHEP)
        IF (KHEP.LT.IHEP) KHEP=IHEP
        DO 220 JHEP=IHEP,KHEP
        CALL HWULOF(PB,PHEP(1,JHEP),PHEP(1,JHEP))
        CALL HWUROB(RS,PHEP(1,JHEP),PHEP(1,JHEP))
        CALL HWULF4(PB,VHEP(1,JHEP),VHEP(1,JHEP))
        CALL HWUROB(RS,VHEP(1,JHEP),VHEP(1,JHEP))
C---BOOST FROM BREIT FRAME IF NECESSARY
        IF (DISPRO.AND.BREIT) THEN
          CALL HWUROB(RBR,PHEP(1,JHEP),PHEP(1,JHEP))
          CALL HWULOB(PBR,PHEP(1,JHEP),PHEP(1,JHEP))
          CALL HWUROB(RBR,VHEP(1,JHEP),VHEP(1,JHEP))
          CALL HWULB4(PBR,VHEP(1,JHEP),VHEP(1,JHEP))
        ENDIF
        CALL HWVSUM(4,VHEP(1,JHEP),VHEP(1,IPAR(IP)),VHEP(1,JHEP))
  220   ISTHEP(JHEP)=ISTHEP(JHEP)+10
        IF (KHEP.GT.IHEP+1) THEN
          ISTHEP(IHEP+1)=100
        ELSEIF (KHEP.EQ.IHEP) THEN
C---NON-PARTON JET
          ISTHEP(IHEP)=190
        ENDIF
  230   CONTINUE
        IF (ISTHEP(ICM).EQ.110) ISTHEP(ICM)=120
      ENDIF
      GOTO 20
  999 END
CDECK  ID>, HWBMAS.
*CMZ :-        -26/04/91  11.11.54  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWBMAS
C-----------------------------------------------------------------------
C     Passes  backwards through a  jet cascade  calculating the masses
C     and magnitudes of the longitudinal and transverse three momenta.
C     Components given relative to direction of parent for a time-like
C     vertex and with respect to z-axis for space-like vertices.
C
C     On input PPAR(1-5,*) contains:
C     (E*sqrt(Xi),Xi,3-mom (if external),E,M-sq (if external))
C
C     On output PPAR(1-5,*) (if TMPAR(*)), containts:
C     (P-trans,Xi or Xilast,P-long,E,M)
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWUSQR,EXI,PISQ,PJPK,EJEK,PTSQ
      INTEGER IPAR,JPAR,KPAR,MPAR
      EXTERNAL HWUSQR
      IF (IERROR.NE.0) RETURN
      IF (NPAR.GT.2) THEN
         DO 10 MPAR=NPAR-1,3,-2
         JPAR=MPAR
C Find parent and partner of this branch
         IPAR=JMOPAR(1,JPAR)
         KPAR=JPAR+1
C Determine type of branching
         IF (TMPAR(IPAR)) THEN
C Time-like branching
C           Compute mass of parent
            EXI=PPAR(1,JPAR)*PPAR(1,KPAR)
            PPAR(5,IPAR)=PPAR(5,JPAR)+PPAR(5,KPAR)+2.*EXI
C           Compute three momentum of parent
            PISQ=PPAR(4,IPAR)*PPAR(4,IPAR)-PPAR(5,IPAR)
            PPAR(3,IPAR)=HWUSQR(PISQ)
C           Compute daughter' transverse and longitudinal momenta
            PJPK=PPAR(3,JPAR)*PPAR(3,KPAR)
            EJEK=PPAR(4,JPAR)*PPAR(4,KPAR)-EXI
            PTSQ=(PJPK+EJEK)*(PJPK-EJEK)/PISQ
            PPAR(1,JPAR)=HWUSQR(PTSQ)
            PPAR(3,JPAR)=HWUSQR(PPAR(3,JPAR)*PPAR(3,JPAR)-PTSQ)
            PPAR(1,KPAR)=-PPAR(1,JPAR)
            PPAR(3,KPAR)= PPAR(3,IPAR)-PPAR(3,JPAR)
         ELSE
C Space-like branching
C           Re-arrange such that JPAR is time-like
            IF (TMPAR(KPAR)) THEN
               KPAR=JPAR
               JPAR=JPAR+1
            ENDIF
C           Compute time-like branch
            PTSQ=(2.-PPAR(2,JPAR))*PPAR(1,JPAR)*PPAR(1,JPAR)
     &          -PPAR(5,JPAR)
            PPAR(1,JPAR)=HWUSQR(PTSQ)
            PPAR(3,JPAR)=(1.-PPAR(2,JPAR))*PPAR(4,JPAR)
            PPAR(3,IPAR)=PPAR(3,KPAR)-PPAR(3,JPAR)
            PPAR(5,IPAR)=0.
            PPAR(1,KPAR)=0.
         ENDIF
C Reset Xi to Xilast
         PPAR(2,KPAR)=PPAR(2,IPAR)
  10     CONTINUE
      ENDIF
      DO 20 IPAR=2,NPAR
  20  PPAR(5,IPAR)=HWUSQR(PPAR(5,IPAR))
      PPAR(1,2)=0.
      PPAR(2,2)=0.
      END
CDECK  ID>, HWBRAN.
*CMZ :-        -15/07/92  14.08.45  by  Mike Seymour
*-- Author :    Bryan Webber & Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HWBRAN(KPAR)
C-----------------------------------------------------------------------
C     BRANCHES TIMELIKE PARTON KPAR INTO TWO, PUTS PRODUCTS
C     INTO NPAR+1 AND NPAR+2, AND INCREASES NPAR BY TWO
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWBVMC,HWRGEN,HWUALF,HWUTAB,HWRUNI,HWULDO,PMOM,
     & QNOW,QLST,QKTHR,RN,QQBAR,DQQ,QGTHR,SNOW,QSUD,ZMIN,ZMAX,ZRAT,WMIN,
     & QLAM,Z1,Z2,ETEST,ZTEST,ENOW,XI,XIPREV,EPREV,QMAX,QGAM,SLST,SFNL,
     & TARG,ALF,BETA0(3:6),BETAP(3:6),SQRK(4:6,5),REJFAC,Z,X1,X2,OTHXI,
     & OTHZ
      INTEGER HWRINT,KPAR,ID,JD,IS,NTRY,N,ID1,ID2,MPAR,ISUD(13),IHEP,
     & JHEP,M,NF,NN,IREJ,NREJ
      EXTERNAL HWBVMC,HWRGEN,HWUALF,HWUTAB,HWRUNI,HWULDO,HWRINT
      SAVE BETA0,BETAP,SQRK
      DATA ISUD,BETA0/2,2,3,4,5,6,2,2,3,4,5,6,1,4*ZERO/
      IF (IERROR.NE.0) RETURN
C---SET SQRK(M,N) TO THE PROBABILITY THAT A GLUON WILL NOT PRODUCE A
C   QUARK-ANTIQUARK PAIR BETWEEN SCALES RMASS(M) AND 2*HWBVMC(N)
      IF (SUDORD.NE.1.AND.BETA0(3).EQ.ZERO) THEN
        DO 100 M=3,6
          BETA0(M)=(11.*CAFAC-2.*M)*0.5
 100      BETAP(M)=(17.*CAFAC**2-(5.*CAFAC+3.*CFFAC)*M)
     &            /BETA0(M)*0.25/PIFAC
        DO 120 N=1,5
          DO 110 M=4,6
            IF (M.LE.N) THEN
              SQRK(M,N)=ONE
            ELSEIF (M.EQ.4.OR.M.EQ.N+1) THEN
              NF=M
              IF (2*HWBVMC(N).GT.RMASS(M)) NF=M+1
              SQRK(M,N)=((BETAP(NF-1)+1/HWUALF(1,2*HWBVMC(N)))/
     $             (BETAP(NF-1)+1/HWUALF(1,RMASS(M))))**(1/BETA0(NF-1))
            ELSE
              SQRK(M,N)=SQRK(M-1,N)*
     $             ((BETAP(M-1)+1/HWUALF(1,RMASS(M-1)))/
     $             (BETAP(M-1)+1/HWUALF(1,RMASS(M))))**(1/BETA0(M-1))
            ENDIF
 110      CONTINUE
 120    CONTINUE
      ENDIF
      ID=IDPAR(KPAR)
C--TEST FOR PARTON TYPE
      IF (ID.LE.13) THEN
        JD=ID
        IS=ISUD(ID)
      ELSEIF (ID.GE.208) THEN
        JD=ID-200
        IS=7
      ELSE
        IS=0
      END IF
      QNOW=-1.
      IF (IS.NE.0) THEN
C--TIMELIKE PARTON BRANCHING
        ENOW=PPAR(4,KPAR)
        XIPREV=PPAR(2,KPAR)
        IF (JMOPAR(1,KPAR).EQ.0) THEN
          EPREV=PPAR(4,KPAR)
        ELSE
          EPREV=PPAR(4,JMOPAR(1,KPAR))
        ENDIF
C--IF THIS IS CHARGED & PHOTONS ARE ALLOWED, ANGLES MIGHT NOT BE ORDERED
        QMAX=0
        QLST=PPAR(1,KPAR)
        IF (ICHRG(ID).NE.0 .AND. VPCUT.LT.PPAR(1,2)) THEN
C--LOOK FOR A PREVIOUS G->QQBAR, IF ANY
          MPAR=KPAR
 1        IF (JMOPAR(1,MPAR).NE.0) THEN
            IF (IDPAR(JMOPAR(1,MPAR)).EQ.ID) THEN
              MPAR=JMOPAR(1,MPAR)
              GOTO 1
            ENDIF
          ENDIF
C--IF CLIMBED TO THE TOP OF THE LIST, FIND QED INTERFERENCE PARTNER
          IF (MPAR.EQ.2) THEN
            IF (ID.LT.7) THEN
              IHEP=JDAHEP(2,JCOPAR(1,1))
              JHEP=JDAHEP(2,IHEP)
            ELSE
              IHEP=JMOHEP(2,JCOPAR(1,1))
              JHEP=JMOHEP(2,IHEP)
            ENDIF
            QMAX=HWULDO(PHEP(1,IHEP),PHEP(1,JHEP))*(ENOW/PPAR(4,2))**2
          ELSE
            QMAX=ENOW**2*PPAR(2,MPAR)
          ENDIF
C--IF PREVIOUS BRANCHING WAS Q->QGAMMA, LOOK FOR A QCD BRANCHING
          MPAR=KPAR
 2        IF (JMOPAR(1,MPAR).NE.0) THEN
            IF (IDPAR(JDAPAR(1,JMOPAR(1,MPAR))).EQ.59 .OR.
     &        IDPAR(JDAPAR(2,JMOPAR(1,MPAR))).EQ.59) THEN
              MPAR=JMOPAR(1,MPAR)
              GOTO 2
            ENDIF
          ENDIF
          QLST=ENOW**2*PPAR(2,MPAR)
          QMAX=SQRT(MAX(ZERO,MIN(
     &         QMAX , EPREV**2*XIPREV , ENOW**2*XIPREV*(2-XIPREV))))
          QLST=SQRT(MIN(
     &         QLST , EPREV**2*XIPREV , ENOW**2*XIPREV*(2-XIPREV)))
        ENDIF
        NTRY=0
    5   NTRY=NTRY+1
        IF (NTRY.GT.NBTRY) CALL HWWARN('HWBRAN',100,*999)
        IF (ID.EQ.13) THEN
C--GLUON -> QUARK+ANTIQUARK OPTION
          IF (QLST.GT.QCDL3) THEN
            DO 8 N=1,NFLAV
            QKTHR=2.*HWBVMC(N)
            IF (QLST.GT.QKTHR) THEN
              RN=HWRGEN(N)
              IF (SUDORD.NE.1) THEN
C---FIND IN WHICH FLAVOUR INTERVAL THE UPPER LIMIT LIES
                NF=3
                DO 200 M=MAX(3,N),NFLAV
 200              IF (QLST.GT.RMASS(M)) NF=M
C---CALCULATE THE FORM FACTOR
                IF (NF.EQ.MAX(3,N)) THEN
                  SFNL=((BETAP(NF)+1/HWUALF(1,QKTHR))/
     $                 (BETAP(NF)+1/HWUALF(1,QLST)))**(1/BETA0(NF))
                  SLST=SFNL
                ELSE
                  SFNL=((BETAP(NF)+1/HWUALF(1,RMASS(NF)))/
     $                 (BETAP(NF)+1/HWUALF(1,QLST)))**(1/BETA0(NF))
                  SLST=SFNL*SQRK(NF,N)
                ENDIF
              ENDIF
              IF (RN.GT.1.E-3) THEN
                QQBAR=QCDL3*(QLST/QCDL3)**(RN**BETAF)
              ELSE
                QQBAR=QCDL3
              ENDIF
              IF (SUDORD.NE.1) THEN
C---FIND IN WHICH FLAVOUR INTERVAL THE SOLUTION LIES
                IF (RN.GE.SFNL) THEN
                  NN=NF
                ELSEIF (RN.GE.SLST) THEN
                  NN=MAX(3,N)
                  DO 210 M=MAX(3,N)+1,NF-1
 210                IF (RN.GE.SLST/SQRK(M,N)) NN=M
                ELSE
                  NN=0
                  QQBAR=QCDL3
                ENDIF
                IF (NN.GT.0) THEN
                  IF (NN.EQ.NF) THEN
                    TARG=HWUALF(1,QLST)
                  ELSE
                    TARG=HWUALF(1,RMASS(NN+1))
                    RN=RN/SLST*SQRK(NN+1,N)
                  ENDIF
                  TARG=1/((BETAP(NN)+1/TARG)*RN**BETA0(NN)-BETAP(NN))
C---NOW SOLVE HWUALF(1,QQBAR)=TARG FOR QQBAR ITERATIVELY
 7                QQBAR=MAX(QQBAR,HALF*QKTHR)
                  ALF=HWUALF(1,QQBAR)
                  IF (ABS(ALF-TARG).GT.ACCUR) THEN
                    NTRY=NTRY+1
                    IF (NTRY.GT.NBTRY) CALL HWWARN('HWBRAN',101,*999)
                    QQBAR=QQBAR*(1+3*PIFAC*(ALF-TARG)
     $                   /(BETA0(NN)*ALF**2*(1+BETAP(NN)*ALF)))
                    GOTO 7
                  ENDIF
                ENDIF
              ENDIF
              IF (QQBAR.GT.QNOW.AND.QQBAR.GT.QKTHR) THEN
                QNOW=QQBAR
                ID2=N
              ENDIF
            ELSE
              GOTO 9
            ENDIF
    8       CONTINUE
          ENDIF
C--GLUON->DIQUARKS OPTION
    9     IF (QLST.LT.QDIQK) THEN
            IF (PDIQK.NE.ZERO) THEN
              RN=HWRGEN(0)
              DQQ=QLST*EXP(-RN/PDIQK)
              IF (DQQ.GT.QNOW) THEN
                IF (DQQ.GT.2.*RMASS(115)) THEN
                  QNOW=DQQ
                  ID2=115
                ENDIF
              ENDIF
            ENDIF
          ENDIF
        ENDIF
C--ENHANCE GLUON AND PHOTON EMISSION BY A FACTOR OF TWO IF THIS BRANCH
C  IS CAPABLE OF BEING THE HARDEST SO FAR
        NREJ=1
        IF (TMPAR(2).AND.0.25*MAX(QLST,QMAX).GT.HARDST) NREJ=2
C--BRANCHING ID->ID+GLUON
        QGTHR=HWBVMC(ID)+HWBVMC(13)
        IF (QLST.GT.QGTHR) THEN
         DO 300 IREJ=1,NREJ
          RN=HWRGEN(1)
          SLST=HWUTAB(SUD(1,IS),QEV(1,IS),NQEV,QLST,INTER)
          IF (RN.EQ.0.) THEN
            SNOW=2.
          ELSE
            SNOW=SLST/RN
          ENDIF
          IF (SNOW.LT.1.) THEN
            QSUD=HWUTAB(QEV(1,IS),SUD(1,IS),NQEV,SNOW,INTER)
C---IF FORM FACTOR DID NOT GET INVERTED CORRECTLY TRY LINEAR INSTEAD
            IF (QSUD.GT.QLST) THEN
              SNOW=HWUTAB(SUD(1,IS),QEV(1,IS),NQEV,QLST,1)/RN
              QSUD=HWUTAB(QEV(1,IS),SUD(1,IS),NQEV,SNOW,1)
              IF (QSUD.GT.QLST) THEN
                CALL HWWARN('HWBRAN',1,*999)
                QSUD=-1
              ENDIF
            ENDIF
            IF (QSUD.GT.QGTHR.AND.QSUD.GT.QNOW) THEN
              ID2=13
              QNOW=QSUD
            ENDIF
          ENDIF
 300     CONTINUE
        ENDIF
C--BRANCHING ID->ID+PHOTON
        IF (ICHRG(ID).NE.0) THEN
          QGTHR=MAX(HWBVMC(ID)+HWBVMC(59),HWBVMC(59)*EXP(0.75))
          IF (QMAX.GT.QGTHR) THEN
           DO 400 IREJ=1,NREJ
            RN=HWRGEN(2)
            IF (RN.EQ.0) THEN
              QGAM=0
            ELSE
              QGAM=(LOG(QMAX/HWBVMC(59))-0.75)**2
     &            +PIFAC*9/(ICHRG(ID)**2*ALPFAC*ALPHEM)*LOG(RN)
              IF (QGAM.GT.0) THEN
                QGAM=HWBVMC(59)*EXP(0.75+SQRT(QGAM))
              ELSE
                QGAM=0
              ENDIF
            ENDIF
            IF (QGAM.GT.QGTHR.AND.QGAM.GT.QNOW) THEN
              ID2=59
              QNOW=QGAM
            ENDIF
 400       CONTINUE
          ENDIF
        ENDIF
        IF (QNOW.GT.0.) THEN
C--BRANCHING HAS OCCURRED
          ZMIN=HWBVMC(ID2)/QNOW
          ZMAX=1.-ZMIN
          IF (ID.EQ.13) THEN
            IF (ID2.EQ.13) THEN
C--GLUON -> GLUON + GLUON
              ID1=13
              WMIN=ZMIN*ZMAX
              ETEST=(1.-WMIN)**2*HWUALF(5-SUDORD*2,QNOW*WMIN)
              ZRAT=(ZMAX*(1-ZMIN))/(ZMIN*(1-ZMAX))
C--CHOOSE Z1 DISTRIBUTED ON (ZMIN,ZMAX)
C  ACCORDING TO GLUON BRANCHING FUNCTION
   10         Z1=ZMAX/(ZMAX+(1-ZMAX)*ZRAT**HWRGEN(0))
              Z2=1.-Z1
              ZTEST=(1.-(Z1*Z2))**2*HWUALF(5-SUDORD*2,QNOW*(Z1*Z2))
              IF (ZTEST.LT.ETEST*HWRGEN(1)) GOTO 10
              Z=Z1
            ELSEIF (ID2.NE.115) THEN
C--GLUON -> QUARKS
              ID1=ID2+6
              ETEST=ZMIN**2+ZMAX**2
   20         Z1=HWRUNI(0,ZMIN,ZMAX)
              Z2=1.-Z1
              ZTEST=Z1*Z1+Z2*Z2
              IF (ZTEST.LT.ETEST*HWRGEN(0)) GOTO 20
            ELSE
C--GLUON -> DIQUARKS
              ID2=HWRINT(115,117)
              ID1=ID2-6
              Z1=HWRUNI(0,ZMIN,ZMAX)
              Z2=1.-Z1
            ENDIF
          ELSE
C--QUARK OR ANTIQUARK BRANCHING
            IF (ID2.EQ.13) THEN
C--TO GLUON
              ZMAX=1.-HWBVMC(ID)/QNOW
              WMIN=MIN(ZMIN*(1.-ZMIN),ZMAX*(1.-ZMAX))
              ETEST=(1.+ZMAX**2)*HWUALF(5-SUDORD*2,QNOW*WMIN)
              ZRAT=ZMAX/ZMIN
   30         Z1=ZMIN*ZRAT**HWRGEN(0)
              Z2=1.-Z1
              ZTEST=(1.+Z2*Z2)*HWUALF(5-SUDORD*2,QNOW*Z1*Z2)
              IF (ZTEST.LT.ETEST*HWRGEN(1)) GOTO 30
            ELSE
C--TO PHOTON
              ZMIN=  HWBVMC(59)/QNOW
              ZMAX=1-HWBVMC(ID)/QNOW
              ZRAT=ZMAX/ZMIN
              ETEST=1+(1-ZMIN)**2
   40         Z1=ZMIN*ZRAT**HWRGEN(0)
              Z2=1-Z1
              ZTEST=1+Z2*Z2
              IF (ZTEST.LT.ETEST*HWRGEN(1)) GOTO 40
            ENDIF
C--QUARKS EMIT ON LOWER SIDE, ANTIQUARKS ON UPPER SIDE
            Z=Z1
            IF (JD.LE.6) THEN
              Z1=Z2
              Z2=1.-Z2
              ID1=ID
            ELSE
              ID1=ID2
              ID2=ID
            ENDIF
          ENDIF
C--UPDATE THIS BRANCH AND CREATE NEW BRANCHES
          XI=(QNOW/ENOW)**2
          IF (ID1.NE.59.AND.ID2.NE.59) THEN
            IF (ID.EQ.13.AND.ID1.NE.13) THEN
              QLAM=QNOW
            ELSE
              QLAM=QNOW*Z1*Z2
            ENDIF
            IF (SUDORD.EQ.1.AND.HWUALF(2,QLAM).LT.HWRGEN(0) .OR.
     &           (2.-XI)*(QNOW*Z1*Z2)**2.GT.EMSCA**2) THEN
C--BRANCHING REJECTED: REDUCE Q AND REPEAT
                QMAX=QNOW
                QLST=QNOW
                QNOW=-1.
                GOTO 5
            ENDIF
          ENDIF
C--IF THIS IS HARDEST EMISSION SO FAR, APPLY MATRIX-ELEMENT CORRECTION
          IF (ID.NE.13.OR.ID1.EQ.13) THEN
            QLAM=QNOW*Z1*Z2
            REJFAC=1
            IF (TMPAR(2).AND.QLAM.GT.HARDST) THEN
              IF (MOD(ISTHEP(JCOPAR(1,1)),10).GE.3) THEN
C---COLOUR PARTNER IS ALSO OUTGOING
                X1=1-Z*(1-Z)*XI
                X2=0.5*(1+Z*(1-Z)*XI +
     $               (1-Z*(1-Z)*XI)*(1-2*Z)/SQRT(1-2*Z*(1-Z)*XI))
                REJFAC=SQRT(2*X1-1)/(X1*Z*(1-Z))
     $               *(1+(1-Z)**2)/(Z*XI)
     $               *(1-X1)*(1-X2)/(X1**2+X2**2)
C---CHECK WHETHER IT IS IN THE OVERLAP REGION
                OTHXI=4*(1-X2)*X2**2/(X2**2-(2*X2-1)*(2*X1+X2-2)**2)
                IF (OTHXI.LT.1) THEN
                  OTHZ=0.5*(1-SQRT(2*X2-1)/X2*(2*X1+X2-2))
                  REJFAC=REJFAC+SQRT(2*X2-1)/(X2*OTHZ*(1-OTHZ))
     $                 *(1+(1-OTHZ)**2)/(OTHZ*OTHXI)
     $                 *(1-X2)*(1-X1)/(X2**2+X1**2)
                ENDIF
              ELSE
C---COLOUR PARTNER IS INCOMING (X1=XP, X2=ZP)
                X1=1/(1+Z*(1-Z)*XI)
                X2=0.5*(1+(1-2*Z)/SQRT(1-2*Z*(1-Z)*XI))
                REJFAC=SQRT(3-2/X1)/(X1**2*Z*(1-Z))
     $               *(1+(1-Z)**2)/(Z*XI)
     $               *(1-X1)*(1-X2)/
     $               (1+(1-X1-X2+2*X1*X2)**2+2*(1-X1)*(1-X2)*X1*X2)
C---CHECK WHETHER IT IS IN THE OVERLAP REGION
                OTHXI=(SQRT(X1+2*(1-X2)*(1-X2+X1*X2))-SQRT(X1))**2/
     $               (1+X1-X2-SQRT(X1*(X1+2*(1-X2)*(1-X2+X1*X2))))
                OTHZ=(SQRT(X1*(X1+2*(1-X2)*(1-X2+X1*X2)))-X1)/(1-X2)
                IF (OTHXI.LT.OTHZ**2) THEN
                  REJFAC=REJFAC+OTHZ**3*(1-X1-X2+2*X1*X2)
     $                 /(X1**2*(1-OTHZ)*(OTHZ+OTHXI*(1-OTHZ)))
     $                 *(1+OTHZ**2)/((1-OTHZ)*OTHXI)
     $                 *(1-X1)*(1-X2)/
     $                 (1+(1-X1-X2+2*X1*X2)**2+2*(1-X1)*(1-X2)*X1*X2)
                ENDIF
              ENDIF
            ENDIF
            IF (NREJ*REJFAC*HWRGEN(NREJ).GT.1) THEN
              QMAX=QNOW
              QLST=QNOW
              QNOW=-1.
              GOTO 5
            ENDIF
            IF (QLAM.GT.HARDST) HARDST=QLAM
          ENDIF
          MPAR=NPAR+1
          IDPAR(MPAR)=ID1
          TMPAR(MPAR)=.TRUE.
          PPAR(1,MPAR)=QNOW*Z1
          PPAR(2,MPAR)=XI
          PPAR(4,MPAR)=ENOW*Z1
          NPAR=NPAR+2
          IDPAR(NPAR)=ID2
          TMPAR(NPAR)=.TRUE.
          PPAR(1,NPAR)=QNOW*Z2
          PPAR(2,NPAR)=XI
          PPAR(4,NPAR)=ENOW*Z2
C---NEW MOTHER-DAUGHTER RELATIONS
          JDAPAR(1,KPAR)=MPAR
          JDAPAR(2,KPAR)=NPAR
          JMOPAR(1,MPAR)=KPAR
          JMOPAR(1,NPAR)=KPAR
C---NEW COLOUR CONNECTIONS
          JCOPAR(3,KPAR)=NPAR
          JCOPAR(4,KPAR)=MPAR
          JCOPAR(1,MPAR)=NPAR
          JCOPAR(2,MPAR)=KPAR
          JCOPAR(1,NPAR)=KPAR
          JCOPAR(2,NPAR)=MPAR
C
        ENDIF
      ENDIF
      IF (QNOW.LT.0.) THEN
C--BRANCHING STOPS
        PPAR(5,KPAR)=RMASS(ID)**2
        PMOM=PPAR(4,KPAR)**2-PPAR(5,KPAR)
        IF (ID.GE.198 .AND. ID.LE.201) THEN
          PPAR(5,KPAR)=PPAR(1,2)**2
          PMOM=0
        ENDIF
        IF (PMOM.LT.-1E-6) CALL HWWARN('HWBRAN',104,*999)
        IF (PMOM.LT.0) PMOM=0
        PPAR(3,KPAR)=SQRT(PMOM)
        JDAPAR(1,KPAR)=0
        JDAPAR(2,KPAR)=0
        JCOPAR(3,KPAR)=0
        JCOPAR(4,KPAR)=0
      ENDIF
  999 END
CDECK  ID>, HWBSPA.
*CMZ :-        -26/04/91  14.26.44  by  Federico Carminati
*-- Author :    Ian Knowles
C-----------------------------------------------------------------------
      SUBROUTINE HWBSPA
C-----------------------------------------------------------------------
C     Constructs time-like 4-momenta & production vertices in space-like
C     jet started by parton no.2 interference partner 1 and spin density
C     DECPAR(2). RHOPAR(2) gives the jet spin density matrix.
C     See I.G. Knowles, Comp. Phys. Comm. 58 (90) 271.
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,DMIN,PT,EIKON,EISCR,EINUM,EIDEN1,EIDEN2,
     & WT,SPIN,Z1,Z2,TR,PRMAX,CX,SX,CAZ,ROHEP(3),RMAT(3,3),ZERO2(2)
      INTEGER JPAR,KPAR,LPAR,MPAR
      LOGICAL EICOR
      EXTERNAL HWRGEN
      DATA ZERO2,DMIN/ZERO,ZERO,1.D-15/
      IF (IERROR.NE.0) RETURN
      JPAR=2
      KPAR=1
      IF (NPAR.EQ.2) THEN
         CALL HWVZRO(2,RHOPAR(1,2))
         RETURN
      ENDIF
C Generate azimuthal angle of JPAR's branching using an M-function
C     Find the daughters of JPAR, with LPAR time-like
  10  LPAR=JDAPAR(1,JPAR)
      IF (TMPAR(LPAR)) THEN
         MPAR=LPAR+1
      ELSE
         MPAR=LPAR
         LPAR=MPAR+1
      ENDIF
C Soft correlations
      CALL HWUROT(PPAR(1,JPAR), ONE,ZERO,RMAT)
      CALL HWUROF(RMAT,PPAR(1,KPAR),ROHEP)
      PT=MAX(SQRT(ROHEP(1)*ROHEP(1)+ROHEP(2)*ROHEP(2)),DMIN)
      EIKON=1.
      EICOR=AZSOFT.AND.IDPAR(LPAR).EQ.13
      IF (EICOR) THEN
         EISCR=1.-PPAR(5,MPAR)*PPAR(5,MPAR)/(MIN(PPAR(2,LPAR),
     &   PPAR(2,MPAR))*PPAR(4,MPAR)*PPAR(4,MPAR))
         EINUM=PPAR(4,KPAR)*PPAR(4,LPAR)*ABS(PPAR(2,LPAR)-PPAR(2,MPAR))
         EIDEN1=PPAR(4,KPAR)*PPAR(4,LPAR)-ROHEP(3)*PPAR(3,LPAR)
         EIDEN2=PT*ABS(PPAR(1,LPAR))
         EIKON=MAX(EISCR+EINUM/MAX(EIDEN1-EIDEN2,DMIN),ZERO)
      ENDIF
C Spin correlations
      WT=0.
      SPIN=1.
      IF (AZSPIN.AND.IDPAR(JPAR).EQ.13) THEN
         Z1=PPAR(4,JPAR)/PPAR(4,MPAR)
         Z2=1.-Z1
         IF (IDPAR(MPAR).EQ.13) THEN
            TR=Z1/Z2+Z2/Z1+Z1*Z2
         ELSEIF (IDPAR(MPAR).LT.13) THEN
            TR=(Z1*Z1+Z2*Z2)/2.
         ENDIF
         WT=Z2/(Z1*TR)
      ENDIF
C Assign the azimuthal angle
      PRMAX=(1.+ABS(WT))*EIKON
  50  CALL HWRAZM( ONE,CX,SX)
      CALL HWUROT(PPAR(1,JPAR),CX,SX,RMAT)
C Determine the angle between the branching planes
      CALL HWUROF(RMAT,PPAR(1,KPAR),ROHEP)
      CAZ=ROHEP(1)/PT
      PHIPAR(1,JPAR)=2.*CAZ*CAZ-1.
      PHIPAR(2,JPAR)=2.*CAZ*ROHEP(2)/PT
      IF (EICOR) EIKON=MAX(EISCR+EINUM/MAX(EIDEN1-EIDEN2*CAZ,DMIN),ZERO)
      IF (AZSPIN) SPIN=1.+WT*(DECPAR(1,JPAR)*PHIPAR(1,JPAR)
     &                       +DECPAR(2,JPAR)*PHIPAR(2,JPAR))
      IF (SPIN*EIKON.LT.HWRGEN(0)*PRMAX) GOTO 50
C Construct full 4-momentum of LPAR, sum P-trans of MPAR
      PPAR(2,LPAR)=0.
      PPAR(2,MPAR)=0.
      CALL HWUROB(RMAT,PPAR(1,LPAR),PPAR(1,LPAR))
      CALL HWVDIF(2,PPAR(1,2),PPAR(1,LPAR),PPAR(1,2))
C Test for end of space-like branches
      IF (JDAPAR(1,MPAR).EQ.0) GOTO 60
C     Generate new Decay matrix
      CALL HWBAZF(MPAR,JPAR,ZERO2,DECPAR(1,JPAR),
     &            PHIPAR(1,JPAR),DECPAR(1,MPAR))
C     Advance along the space-like branch
      JPAR=MPAR
      KPAR=LPAR
      GOTO 10
C Retreat along space-like line
C     Assign initial spin density matrix
  60  CALL HWVEQU(2,ZERO2,RHOPAR(1,MPAR))
      CALL HWUMAS(PPAR(1,2))
      CALL HWVZRO(4,VPAR(1,MPAR))
  70  CALL HWVEQU(4,VPAR(1,MPAR),VPAR(1,LPAR))
      IF (MPAR.EQ.2) RETURN
C Construct spin density matrix for time-like branch
      CALL HWBAZF(MPAR,JPAR,RHOPAR(1,MPAR),PHIPAR(1,JPAR),
     &                      DECPAR(1,JPAR),RHOPAR(1,LPAR))
C Evolve time-like side branch
      CALL HWBTIM(LPAR,MPAR)
C Construct spin density matrix for space-like branch
      CALL HWBAZF(MPAR,JPAR,PHIPAR(1,JPAR),RHOPAR(1,MPAR),
     &                      DECPAR(1,LPAR),RHOPAR(1,JPAR))
C Assign production vertex to J
      CALL HWVDIF(4,PPAR(1,MPAR),PPAR(1,LPAR),PPAR(1,JPAR))
      CALL HWUDKL(IDPAR(JPAR),PPAR(1,JPAR),VPAR(1,JPAR))
      CALL HWVSUM(4,VPAR(1,MPAR),VPAR(1,JPAR),VPAR(1,JPAR))
C Find parent and partner of MPAR
      MPAR=JPAR
      JPAR=JMOPAR(1,MPAR)
      LPAR=MPAR+1
      IF (JMOPAR(1,LPAR).NE.JPAR) LPAR=MPAR-1
      GOTO 70
      END
CDECK  ID>, HWBSPN.
*CMZ :-        -26/04/91  11.11.54  by  Bryan Webber
*-- Author :    Ian Knowles
C-----------------------------------------------------------------------
      SUBROUTINE HWBSPN
C-----------------------------------------------------------------------
C     Constructs appropriate spin density/decay matrix for parton
C     in hard subprocess, othwise zero. Assignments based upon
C     Comp. Phys. Comm. 58 (1990) 271.
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION C,V12,V23,V13,TR,C1,C2,C3,R1(2),R2(2)
      INTEGER IST
      SAVE R1,R2,V12
      IF (IERROR.NE.0) RETURN
      IST=MOD(ISTHEP(NEVPAR),10)
C Assumed partons processed in the order IST=1,2,3,4
      IF (IPROC.GE.100.AND.IPROC.LE.116) THEN
C  An e+e- ---> qqbar g event
         IF (IDPAR(2).EQ.13) THEN
            RHOPAR(1,2)=GPOLN
            RHOPAR(2,2)=0.
            RETURN
         ENDIF
      ELSEIF (IPRO.EQ.15.OR.IPRO.EQ.17) THEN
         IF (IHPRO.EQ. 7.OR.IHPRO.EQ. 8.OR.
     &       IHPRO.EQ.10.OR.IHPRO.EQ.11.OR.
     &       IHPRO.EQ.15.OR.IHPRO.EQ.16.OR.
     &      (IHPRO.GE.21.AND.IHPRO.LE.31)) THEN
C A hard 2 --- > 2 QCD subprocess involving gluons
            IF (IST.EQ.2) THEN
               CALL HWVEQU(2,RHOPAR(1,2),R1(1))
               C=GCOEF(2)/GCOEF(1)
               DECPAR(1,2)=C*R1(1)
               DECPAR(2,2)=C*R1(2)
               RETURN
            ELSEIF (IST.EQ.3) THEN
               CALL HWVEQU(2,RHOPAR(1,2),R2(1))
               V12=R1(1)*R2(1)+R1(2)*R2(2)
               TR=1./(GCOEF(1)+GCOEF(2)*V12)
               RHOPAR(1,2)= (GCOEF(3)*R1(1)+GCOEF(4)*R2(1))*TR
               RHOPAR(2,2)=-(GCOEF(3)*R1(2)+GCOEF(4)*R2(2))*TR
               RETURN
            ELSEIF (IST.EQ.4) THEN
               V13=R1(1)*DECPAR(1,2)+R1(2)*DECPAR(2,2)
               V23=R2(1)*DECPAR(1,2)+R2(2)*DECPAR(2,2)
               TR=1./(GCOEF(1)+GCOEF(2)*V12+GCOEF(3)*V13+GCOEF(4)*V23)
               C1=(GCOEF(2)+GCOEF(5))*TR
               C2=(GCOEF(3)+GCOEF(6))*TR
               C3=(GCOEF(4)+GCOEF(6))*TR
               RHOPAR(1,2)=C1*DECPAR(1,2)+C2*R2(1)+C3*R1(1)
               RHOPAR(2,2)=C1*DECPAR(2,2)-C2*R1(2)-C3*R2(2)
               RETURN
            ENDIF
         ENDIF
      ELSEIF (IPRO.EQ.16) THEN
C A gluon fusion ---> Higgs event
         IF (IST.EQ.2) THEN
            DECPAR(1,2)=RHOPAR(1,2)
            DECPAR(2,2)=-RHOPAR(2,2)
            RETURN
         ENDIF
      ENDIF
      CALL HWVZRO(2,RHOPAR(1,2))
      CALL HWVZRO(2,DECPAR(1,2))
      END
CDECK  ID>, HWBSU1.
*CMZ :-        -13/07/92  20.15.54  by  Mike Seymour
*-- Author :    Bryan Webber, modified by Mike Seymour
C-----------------------------------------------------------------------
      FUNCTION HWBSU1(ZLOG)
C-----------------------------------------------------------------------
C     Z TIMES THE INTEGRAND IN EXPONENT OF QUARK SUDAKOV FORM FACTOR.
C     HWBSU1 IS FOR UPPER PART OF Z INTEGRATION REGION
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWBSU1,HWBSUL,Z,ZLOG,U
      EXTERNAL HWBSUL
      Z=EXP(ZLOG)
      U=1.-Z
      HWBSU1=HWBSUL(Z)*(1.+U*U)
      END
CDECK  ID>, HWBSU2.
*CMZ :-        -13/07/92  20.15.54  by  Mike Seymour
*-- Author :    Bryan Webber, modified by Mike Seymour
C-----------------------------------------------------------------------
      FUNCTION HWBSU2(Z)
C-----------------------------------------------------------------------
C     INTEGRAND IN EXPONENT OF QUARK SUDAKOV FORM FACTOR.
C     HWBSU2 IS FOR LOWER PART OF Z INTEGRATION REGION
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWBSU2,HWBSUL,Z,U
      EXTERNAL HWBSUL
      U=1.-Z
      HWBSU2=HWBSUL(Z)*(1.+Z*Z)/U
      END
CDECK  ID>, HWBSUD.
*CMZ :-        -14/07/92  13.28.23  by  Mike Seymour
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWBSUD
C-----------------------------------------------------------------------
C     COMPUTES (OR READS) TABLES OF SUDAKOV FORM FACTORS
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWUGAU,HWBVMC,HWBSUG,HWBSU1,HWBSU2,G1,G2,QRAT,
     & QLAM,POWER,AFAC,QMIN,QFAC,QNOW,ZMIN,ZMAX,Q1,QCOLD,VGOLD,VQOLD,
     & RMOLD(6),ACOLD,ZLO,ZHI
      INTEGER IQ,IS,L1,L2,L,LL,I,INOLD,NQOLD,NSOLD,NCOLD,NFOLD,SDOLD
      EXTERNAL HWUGAU,HWBVMC,HWBSUG,HWBSU1,HWBSU2
      SAVE NQOLD,NSOLD,NCOLD,NFOLD,SDOLD,QCOLD,VGOLD,VQOLD,RMOLD,ACOLD
      COMMON/HWSINT/QRAT,QLAM
      IF (LRSUD.EQ.0) THEN
        POWER=1./FLOAT(NQEV-1)
        AFAC=6.*CAFAC/BETAF
        QMIN=QG+QG
        QFAC=(1.1*QLIM/QMIN)**POWER
        SUD(1,1)=1.
        QEV(1,1)=QMIN
C--IS=1 FOR GLUON->GLUON+GLUON FORM FACTOR
        DO 10 IQ=2,NQEV
        QNOW=QFAC*QEV(IQ-1,1)
        QLAM=QNOW/QCDL3
        ZMIN=QG/QNOW
        QRAT=1./ZMIN
        G1=0
        DO 5 I=3,6
          ZLO=ZMIN
          ZHI=HALF
          IF (I.NE.6) ZLO=MAX(ZLO,QG/RMASS(I+1))
          IF (I.NE.3) ZHI=MIN(ZHI,QG/RMASS(I))
          IF (ZHI.GT.ZLO) G1=G1+HWUGAU(HWBSUG,LOG(ZLO),LOG(ZHI),ACCUR)
    5   CONTINUE
        SUD(IQ,1)=EXP(AFAC*G1)
   10   QEV(IQ,1)=QNOW
        AFAC=3.*CFFAC/BETAF
C--QUARK FORM FACTORS.
C--IS=2,3,4,5,6,7 FOR U/D,S,C,B,T,V
        DO 15 IS=2,NSUD
        Q1=HWBVMC(IS)
        IF (IS.EQ.7) Q1=HWBVMC(209)
        QMIN=Q1+QG
        IF (QMIN.GT.QLIM) GOTO 15
        QFAC=(1.1*QLIM/QMIN)**POWER
        SUD(1,IS)=1.
        QEV(1,IS)=QMIN
        DO 14 IQ=2,NQEV
        QNOW=QFAC*QEV(IQ-1,IS)
        QLAM=QNOW/QCDL3
        ZMIN=QG/QNOW
        QRAT=1./ZMIN
        ZMAX=QG/QMIN
        G1=0
        DO 12 I=3,6
          ZLO=ZMIN
          ZHI=ZMAX
          IF (I.NE.6) ZLO=MAX(ZLO,QG/RMASS(I+1))
          IF (I.NE.3) ZHI=MIN(ZHI,QG/RMASS(I))
          IF (ZHI.GT.ZLO) G1=G1+HWUGAU(HWBSU1,LOG(ZLO),LOG(ZHI),ACCUR)
   12   CONTINUE
        ZMIN=Q1/QNOW
        QRAT=1./ZMIN
        ZMAX=Q1/QMIN
        G2=0
        DO 13 I=3,6
          ZLO=ZMIN
          ZHI=ZMAX
          IF (I.NE.6) ZLO=MAX(ZLO,Q1/RMASS(I+1))
          IF (I.NE.3) ZHI=MIN(ZHI,Q1/RMASS(I))
          IF (ZHI.GT.ZLO) G2=G2+HWUGAU(HWBSU2,ZLO,ZHI,ACCUR)
   13   CONTINUE
        SUD(IQ,IS)=EXP(AFAC*(G1+G2))
   14   QEV(IQ,IS)=QNOW
   15   CONTINUE
        QCOLD=QCDLAM
        VGOLD=VGCUT
        VQOLD=VQCUT
        ACOLD=ACCUR
        INOLD=INTER
        NQOLD=NQEV
        NSOLD=NSUD
        NCOLD=NCOLO
        NFOLD=NFLAV
        SDOLD=SUDORD
        DO 16 IS=1,NSUD
   16   RMOLD(IS)=RMASS(IS)
      ELSE
        IF (LRSUD.GT.0) THEN
          IF (IPRINT.NE.0) WRITE (6,17) LRSUD
   17     FORMAT(10X,'READING SUDAKOV TABLE ON UNIT',I4)
          OPEN(UNIT=LRSUD,FORM='UNFORMATTED',STATUS='UNKNOWN')
          READ(UNIT=LRSUD) QCOLD,VGOLD,VQOLD,RMOLD,
     &       ACOLD,QEV,SUD,INOLD,NQOLD,NSOLD,NCOLD,NFOLD,SDOLD
          CLOSE(UNIT=LRSUD)
        ENDIF
C---CHECK THAT RELEVANT PARAMETERS ARE UNCHANGED
        IF (QCDLAM.NE.QCOLD) CALL HWWARN('HWBSUD',501,*999)
        IF (VGCUT .NE.VGOLD) CALL HWWARN('HWBSUD',502,*999)
        IF (VQCUT .NE.VQOLD) CALL HWWARN('HWBSUD',503,*999)
        IF (ACCUR .NE.ACOLD) CALL HWWARN('HWBSUD',504,*999)
        IF (INTER .NE.INOLD) CALL HWWARN('HWBSUD',505,*999)
        IF (NQEV  .NE.NQOLD) CALL HWWARN('HWBSUD',506,*999)
        IF (NSUD  .NE.NSOLD) CALL HWWARN('HWBSUD',507,*999)
        IF (NCOLO .NE.NCOLD) CALL HWWARN('HWBSUD',508,*999)
        IF (NFLAV .NE.NFOLD) CALL HWWARN('HWBSUD',509,*999)
        IF (SUDORD.NE.SDOLD) CALL HWWARN('HWBSUD',510,*999)
C---CHECK MASSES AND THAT TABLES ARE BIG ENOUGH FOR THIS RUN
        DO 18 IS=1,NSUD
          IF (RMASS(IS).NE.RMOLD(IS))
     &      CALL HWWARN('HWBSUD',510+IS,*999)
          IF (QEV(NQEV,IS).LT.QLIM.AND.HWBVMC(IS)+QG.LT.QLIM)
     &      CALL HWWARN('HWBSUD',500,*999)
   18   CONTINUE
      ENDIF
      IF (LWSUD.GT.0) THEN
        IF (IPRINT.NE.0) WRITE (6,19) LWSUD
   19   FORMAT(10X,'WRITING SUDAKOV TABLE ON UNIT',I4)
        OPEN (UNIT=LWSUD,FORM='UNFORMATTED',STATUS='UNKNOWN')
        WRITE(UNIT=LWSUD)  QCDLAM,VGCUT,VQCUT,(RMASS(I),I=1,6),
     &     ACCUR,QEV,SUD,INTER,NQEV,NSUD,NCOLO,NFLAV,SUDORD
        CLOSE(UNIT=LWSUD)
      ENDIF
      IF (IPRINT.GT.2) THEN
C--PRINT EXTRACTS FROM TABLES OF FORM FACTORS
        DO 40 IS=1,NSUD
        WRITE(6,20) IS,NQEV
   20   FORMAT(1H1//10X,'EXTRACT FROM TABLE OF SUDAKOV FORM FACTOR NO.',
     &  I2,' (',I5,' ACTUAL ENTRIES)'//10X,'SUD IS PROBABILITY THAT',
     &  ' PARTON WITH GIVEN UPPER LIMIT ON Q WILL REACH THRESHOLD',
     &  ' WITHOUT BRANCHING'///2X,8('      Q     SUD ')/)
        L2=NQEV/8
        L1=L2/32
        IF (L1.LT.1) L1=1
        DO 40 L=L1,L2,L1
        LL=L+7*L2
        WRITE(6,30) (QEV(I,IS),SUD(I,IS),I=L,LL,L2)
   30   FORMAT(2X,8(F9.2,F7.4))
   40   CONTINUE
        WRITE(6,50)
   50   FORMAT(1H1)
      ENDIF
  999 END
CDECK  ID>, HWBSUG.
*CMZ :-        -13/07/92  20.15.54  by  Mike Seymour
*-- Author :    Bryan Webber, modified by Mike Seymour
C-----------------------------------------------------------------------
      FUNCTION HWBSUG(ZLOG)
C-----------------------------------------------------------------------
C     Z TIMES INTEGRAND IN EXPONENT OF GLUON SUDAKOV FORM FACTOR
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWBSUG,HWBSUL,Z,ZLOG,W
      EXTERNAL HWBSUL
      Z=EXP(ZLOG)
      W=Z*(1.-Z)
      HWBSUG=HWBSUL(Z)*(W-2.+1./W)*Z
      END
CDECK  ID>, HWBSUL.
*CMZ :-        -13/07/92  20.15.54  by  Mike Seymour
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      FUNCTION HWBSUL(Z)
C-----------------------------------------------------------------------
C     LOGARITHMIC PART OF INTEGRAND IN EXPONENT OF SUDAKOV FORM FACTOR.
C     THE SECOND ORDER ALPHAS CASE COMES FROM CONVERTING INTEGRAL OVER
C     Q^2 INTO ONE OVER ALPHAS, WITH FLAVOUR THRESHOLDS.
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWBSUL,HWUALF,Z,QRAT,QLAM,U,AL,BL,QNOW,QMIN,
     & BET(6),BEP(6),MUMI(6),MUMA(6),ALMI(6),ALMA(6),FINT(6),ALFINT,
     & MUMIN,MUMAX,ALMIN,ALMAX
      INTEGER NF
      LOGICAL FIRST
      EXTERNAL HWUALF
      SAVE FIRST,BET,BEP,MUMI,MUMA
      COMMON/HWSINT/QRAT,QLAM
      DATA FIRST/.TRUE./
      ALFINT(AL,BL)=1/BET(NF)*
     &        LOG(BL/(AL*(1+BEP(NF)*BL))*(1+BEP(NF)*AL))
      HWBSUL=0
      U=1.-Z
      IF (SUDORD.EQ.1) THEN
        AL=LOG(QRAT*Z)
        BL=LOG(QLAM*U*Z)
        HWBSUL=LOG(1.-AL/BL)
      ELSE
        IF (FIRST) THEN
          DO 10 NF=3,6
            BET(NF)=(11*CAFAC-2*NF)/(12*PIFAC)
            BEP(NF)=(17*CAFAC**2-(5*CAFAC+3*CFFAC)*NF)/(24*PIFAC**2)
     &              /BET(NF)
            IF (NF.EQ.3) THEN
              MUMI(3)=0
              ALMI(3)=1D30
            ELSE
              MUMI(NF)=RMASS(NF)
              ALMI(NF)=HWUALF(1,MUMI(NF))
            ENDIF
            IF (NF.EQ.6) THEN
              MUMA(NF)=1D30
              ALMA(NF)=0
            ELSE
              MUMA(NF)=RMASS(NF+1)
              ALMA(NF)=HWUALF(1,MUMA(NF))
            ENDIF
            IF (NF.NE.3.AND.NF.NE.6) FINT(NF)=ALFINT(ALMI(NF),ALMA(NF))
 10       CONTINUE
          FIRST=.FALSE.
        ENDIF
        QNOW=QLAM*QCDL3
        QMIN=QNOW/QRAT
        MUMIN=  U*QMIN
        MUMAX=Z*U*QNOW
        IF (MUMAX.LE.MUMIN) RETURN
        ALMIN=HWUALF(1,MUMIN)
        ALMAX=HWUALF(1,MUMAX)
        NF=3
 20     IF (MUMIN.GT.MUMA(NF)) THEN
          NF=NF+1
          GOTO 20
        ENDIF
        IF (MUMAX.LT.MUMA(NF)) THEN
          HWBSUL=ALFINT(ALMIN,ALMAX)
        ELSE
          HWBSUL=ALFINT(ALMIN,ALMA(NF))
          NF=NF+1
 30       IF (MUMAX.GT.MUMA(NF)) THEN
            HWBSUL=HWBSUL+FINT(NF)
            NF=NF+1
            GOTO 30
          ENDIF
          HWBSUL=HWBSUL+ALFINT(ALMI(NF),ALMAX)
        ENDIF
        HWBSUL=HWBSUL*BET(5)
      ENDIF
      END
CDECK  ID>, HWBTIM.
*CMZ :-        -26/04/91  14.27.17  by  Federico Carminati
*-- Author :    Ian Knowles
C-----------------------------------------------------------------------
      SUBROUTINE HWBTIM(INITBR,INTERF)
C-----------------------------------------------------------------------
C     Constructs full 4-momentum & production vertices in time-like jet
C     initiated by INITBR, interference partner INTERF and spin density
C     RHOPAR(INITBR). DECPAR(INITBR) returns jet's spin density matrix.
C     Includes azimuthal angular correlations between branching planes
C     due to spin (if AZSPIN) using the algorithm of Knowles & Collins.
C     Ses Nucl. Phys. B304 (1988) 794 & Comp. Phys. Comm. 58 (1990) 271.
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,DMIN,PT,EIKON,EINUM,EIDEN1,EIDEN2,EISCR,
     & WT,SPIN,Z1,Z2,PRMAX,CAZ,CX,SX,ROHEP(3),RMAT(3,3),ZERO2(2)
      INTEGER INITBR,INTERF,IPAR,JPAR,KPAR,LPAR,MPAR,NTRY,JOLD
      LOGICAL EICOR,SWAP
      EXTERNAL HWRGEN
      DATA ZERO2,DMIN/ZERO,ZERO,1.D-15/
      IF (IERROR.NE.0) RETURN
      JPAR=INITBR
      KPAR=INTERF
      IF ((JDAPAR(1,JPAR).NE.0).OR.(IDPAR(JPAR).EQ.13)) GOTO 30
C No branching, assign decay matrix
      CALL HWVZRO(2,DECPAR(1,JPAR))
      RETURN
C Advance up the leader
C     Find the parent and partner of J
  10  IPAR=JMOPAR(1,JPAR)
      KPAR=JPAR+1
C Generate new Rho
      IF (JMOPAR(1,KPAR).EQ.IPAR) THEN
C        Generate Rho'
         CALL HWBAZF(IPAR,JPAR,PHIPAR(1,IPAR),RHOPAR(1,IPAR),
     &                                   ZERO2,RHOPAR(1,JPAR))
      ELSE
         KPAR=JPAR-1
         IF (JMOPAR(1,KPAR).NE.IPAR)
     &   CALL HWWARN('HWBTIM',100,*999)
C        Generate Rho''
         CALL HWBAZF(IPAR,KPAR,RHOPAR(1,IPAR),PHIPAR(1,IPAR),
     &                         DECPAR(1,KPAR),RHOPAR(1,JPAR))
      ENDIF
C Generate azimuthal angle of J's branching
  30  IF (JDAPAR(1,JPAR).EQ.0) THEN
C        Final state gluon
         CALL HWVZRO(2,DECPAR(1,JPAR))
         IF (JPAR.EQ.INITBR) RETURN
         GOTO 70
      ELSE
C Assign an angle to a branching using an M-function
C        Find the daughters of J
         LPAR=JDAPAR(1,JPAR)
         MPAR=JDAPAR(2,JPAR)
C Soft correlations
         CALL HWUROT(PPAR(1,JPAR), ONE,ZERO,RMAT)
         CALL HWUROF(RMAT,PPAR(1,KPAR),ROHEP)
         PT=MAX(SQRT(ROHEP(1)*ROHEP(1)+ROHEP(2)*ROHEP(2)),DMIN)
         EIKON=1.
         SWAP=.FALSE.
         EICOR=AZSOFT.AND.((IDPAR(LPAR).EQ.13).OR.(IDPAR(MPAR).EQ.13))
         IF (EICOR) THEN
C           Rearrange s.t. LPAR is the (softest) gluon
            IF (IDPAR(MPAR).EQ.13) THEN
               IF (IDPAR(LPAR).NE.13.OR.
     &             PPAR(4,MPAR).LT.PPAR(4,LPAR)) THEN
                  SWAP=.TRUE.
                  LPAR=MPAR
                  MPAR=LPAR-1
               ENDIF
            ENDIF
            EINUM=(PPAR(4,KPAR)*PPAR(4,LPAR))
     &        *ABS(PPAR(2,LPAR)-PPAR(2,MPAR))
            EIDEN1=(PPAR(4,KPAR)*PPAR(4,LPAR))-ROHEP(3)*PPAR(3,LPAR)
            EIDEN2=PT*ABS(PPAR(1,LPAR))
            EISCR=1.-(PPAR(5,MPAR)/PPAR(4,MPAR))**2
     &           /MIN(PPAR(2,LPAR),PPAR(2,MPAR))
            EIKON=EISCR+EINUM/MAX(EIDEN1-EIDEN2,DMIN)
         ENDIF
C Spin correlations
         WT=0.
         SPIN=1.
         IF (AZSPIN) THEN
            Z1=PPAR(4,LPAR)/PPAR(4,JPAR)
            Z2=1.-Z1
            IF (IDPAR(JPAR).EQ.13.AND.IDPAR(LPAR).EQ.13) THEN
               WT=Z1*Z2/(Z1/Z2+Z2/Z1+Z1*Z2)
            ELSEIF (IDPAR(JPAR).EQ.13.AND.IDPAR(LPAR).LT.13) THEN
               WT=-2.*Z1*Z2/(Z1*Z1+Z2*Z2)
            ENDIF
         ENDIF
C Assign the azimuthal angle
         PRMAX=(1.+ABS(WT))*EIKON
         NTRY=0
   50    NTRY=NTRY+1
         IF (NTRY.GT.NBTRY) CALL HWWARN('HWBTIM',101,*999)
         CALL HWRAZM( ONE,CX,SX)
         CALL HWUROT(PPAR(1,JPAR),CX,SX,RMAT)
C Determine the angle between the branching planes
         CALL HWUROF(RMAT,PPAR(1,KPAR),ROHEP)
         CAZ=ROHEP(1)/PT
         PHIPAR(1,JPAR)=2.*CAZ*CAZ-1.
         PHIPAR(2,JPAR)=2.*CAZ*ROHEP(2)/PT
         IF (EICOR) EIKON=EISCR+EINUM/MAX(EIDEN1-EIDEN2*CAZ,DMIN)
         IF (AZSPIN) SPIN=1.+WT*(RHOPAR(1,JPAR)*PHIPAR(1,JPAR)
     &                          +RHOPAR(2,JPAR)*PHIPAR(2,JPAR))
         IF (SPIN*EIKON.LT.HWRGEN(0)*PRMAX) GOTO 50
C Construct full 4-momentum of L and M
         JOLD=JPAR
         IF (SWAP) THEN
           PPAR(1,LPAR)=-PPAR(1,LPAR)
           PPAR(1,MPAR)=-PPAR(1,MPAR)
           JPAR=MPAR
         ELSE
           JPAR=LPAR
         ENDIF
         PPAR(2,LPAR)=0.
         CALL HWUROB(RMAT,PPAR(1,LPAR),PPAR(1,LPAR))
         PPAR(2,MPAR)=0.
         CALL HWUROB(RMAT,PPAR(1,MPAR),PPAR(1,MPAR))
C Assign production vertex to L and M
         CALL HWUDKL(IDPAR(JOLD),PPAR(1,JOLD),VPAR(1,LPAR))
         CALL HWVSUM(4,VPAR(1,JOLD),VPAR(1,LPAR),VPAR(1,LPAR))
         CALL HWVEQU(4,VPAR(1,LPAR),VPAR(1,MPAR))
      ENDIF
  60  IF (JDAPAR(1,JPAR).NE.0) GOTO 10
C Assign decay matrix
      CALL HWVZRO(2,DECPAR(1,JPAR))
C Backtrack down the leader
  70  IPAR=JMOPAR(1,JPAR)
      KPAR=JDAPAR(1,IPAR)
      IF (KPAR.EQ.JPAR) THEN
C        Develop the side branch
         JPAR=JDAPAR(2,IPAR)
         GOTO 60
      ELSE
C        Construct decay matrix
         CALL HWBAZF(IPAR,KPAR,DECPAR(1,JPAR),DECPAR(1,KPAR),
     &                         PHIPAR(1,IPAR),DECPAR(1,IPAR))
      ENDIF
      IF (IPAR.EQ.INITBR) RETURN
      JPAR=IPAR
      GOTO 70
  999 END
CDECK  ID>, HWBVMC.
*CMZ :-        -26/04/91  11.11.54  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      FUNCTION HWBVMC(ID)
C-----------------------------------------------------------------------
C     VIRTUAL MASS CUTOFF FOR PARTON TYPE ID
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWBVMC
      INTEGER ID
      IF (ID.EQ.13) THEN
        HWBVMC=RMASS(ID)+VGCUT
      ELSEIF (ID.LT.13) THEN
        HWBVMC=RMASS(ID)+VQCUT
      ELSEIF (ID.EQ.59) THEN
        HWBVMC=RMASS(ID)+VPCUT
      ELSE
        HWBVMC=RMASS(ID)
      ENDIF
      END
CDECK  ID>, HWCCUT.
*CMZ :-        -26/04/91  14.29.39  by  Federico Carminati
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWCCUT(JHEP,KHEP,PCL,BTCLUS,SPLIT)
C-----------------------------------------------------------------------
C     Cuts into 2 the cluster, momentum PCL, made of partons JHEP & KHEP
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWREXQ,HWUPCM,HWRGEN,HWVDOT,EMC,QM1,QM2,EMX,EMY,
     & QM3,PXY,PCX,PCY,RCM,PCL(5),AX(5),PA(5),PB(5),PC(5),SKAPPA,DELTM,
     & VSCA,VTMP(4),RKAPPA,VCLUS
      INTEGER HWRINT,JHEP,KHEP,LHEP,MHEP,ID1,ID2,ID3,NTRY,NTRYMX,J
      LOGICAL BTCLUS,SPLIT
      EXTERNAL HWREXQ,HWUPCM,HWRGEN,HWVDOT,HWRINT
      COMMON/HWCFRM/VCLUS(4,NMXHEP)
      PARAMETER (SKAPPA=1.,NTRYMX=100)
      IF (IERROR.NE.0) RETURN
      EMC=PCL(5)
      ID1=IDHW(JHEP)
      ID2=IDHW(KHEP)
      QM1=RMASS(ID1)
      QM2=RMASS(ID2)
      SPLIT=.FALSE.
      NTRY=0
      IF (BTCLUS) THEN
C Split beam and target clusters as soft clusters
C Both (remnant) children treated like soft clusters if IOPREM=0(1)
  10    ID3=HWRINT(1,2)
        QM3=RMASS(ID3)
        IF (EMC.LE.QM1+QM2+2.*QM3) THEN
          ID3=3-ID3
          QM3=RMASS(ID3)
          IF (EMC.LE.QM1+QM2+2.*QM3) RETURN
        ENDIF
        PXY=EMC-QM1-QM2-TWO*QM3
        IF (ISTHEP(JHEP).EQ.153.OR.ISTHEP(JHEP).EQ.154.OR.
     &      IOPREM.EQ.0) THEN
          EMX=QM1+QM3+HWREXQ(BTCLM,PXY)
        ELSE
          EMX=QM1+QM3+PXY*HWRGEN(0)**PSPLT
        ENDIF
        IF (ISTHEP(KHEP).EQ.153.OR.ISTHEP(KHEP).EQ.154.OR.
     &      IOPREM.EQ.0) THEN
          EMY=QM2+QM3+HWREXQ(BTCLM,PXY)
        ELSE
          EMY=QM2+QM3+PXY*HWRGEN(1)**PSPLT
        ENDIF
        IF (EMX+EMY.GE.EMC) THEN
          NTRY=NTRY+1
          IF (NTRY.GT.NTRYMX) RETURN
          GOTO 10
        ENDIF
        PCX=HWUPCM(EMX,QM1,QM3)
        PCY=HWUPCM(EMY,QM2,QM3)
      ELSE
C Choose fragment masses for ordinary cluster
        PXY=EMC-QM1-QM2
  20    NTRY=NTRY+1
        IF (NTRY.GT.NTRYMX) RETURN
  30    EMX=QM1+PXY*HWRGEN(0)**PSPLT
        EMY=QM2+PXY*HWRGEN(1)**PSPLT
        IF (EMX+EMY.GE.EMC) GOTO 30
C u,d,s pair production with weights QWT
  40    ID3=HWRINT(1,3)
        IF (QWT(ID3).LT.HWRGEN(3)) GOTO 40
        QM3=RMASS(ID3)
        PCX=HWUPCM(EMX,QM1,QM3)
        IF (PCX.LT.0.) GOTO 20
        PCY=HWUPCM(EMY,QM2,QM3)
        IF (PCY.LT.0.) GOTO 20
        SPLIT=.TRUE.
      ENDIF
C Boost antiquark to CoM frame to find axis
      CALL HWULOF(PCL,PHEP(1,KHEP),AX)
      RCM=1./SQRT(HWVDOT(3,AX,AX))
      CALL HWVSCA(3,RCM,AX,AX)
C Construct new CoM momenta (collinear)
      PXY=HWUPCM(EMC,EMX,EMY)
      CALL HWVSCA(3,PXY,AX,PC)
      PC(4)=SQRT(PXY**2+EMY**2)
      PC(5)=EMY
      CALL HWVSCA(3,PCY,AX,PA)
      PA(4)=SQRT(PCY**2+QM2**2)
      PA(5)=QM2
      CALL HWULOB(PC,PA,PB)
      CALL HWVDIF(4,PC,PB,PA)
      PA(5)=QM3
      LHEP=NHEP+1
      MHEP=NHEP+2
      CALL HWULOB(PCL,PB,PHEP(1,KHEP))
      CALL HWULOB(PCL,PA,PHEP(1,MHEP))
      CALL HWVSCA(3,-ONE,PC,PC)
      PC(4)=EMC-PC(4)
      PC(5)=EMX
      CALL HWVSCA(3,PCX,AX,PA)
      PA(4)=SQRT(PCX**2+QM3**2)
      CALL HWULOB(PC,PA,PB)
      CALL HWULOB(PCL,PB,PHEP(1,LHEP))
      DO 50 J=1,4
  50  PHEP(J,JHEP)=PCL(J)-PHEP(J,KHEP)-PHEP(J,LHEP)-PHEP(J,MHEP)
      PHEP(5,JHEP)=QM1
      CALL HWVEQU(4,VHEP(1,LHEP),VHEP(1,MHEP))
C Construct new vertex positions
      RKAPPA=GEV2MM/SKAPPA
      CALL HWVSCA(3,RKAPPA,AX,AX)
      DELTM=(EMX-EMY)*(EMX+EMY)/(TWO*EMC)
      CALL HWVSCA(3,DELTM,AX,VTMP)
      VTMP(4)=(HALF*EMC-PXY)*RKAPPA
      CALL HWULB4(PCL,VTMP,VTMP)
      CALL HWVSUM(4,VTMP,VCLUS(1,JHEP),VHEP(1,LHEP))
      CALL HWVEQU(4,VHEP(1,LHEP),VHEP(1,MHEP))
      VSCA=0.25*EMC+HALF*(PXY+DELTM)
      CALL HWVSCA(3,VSCA,AX,VTMP)
      VTMP(4)=(EMC-VSCA)*RKAPPA
      CALL HWULB4(PCL,VTMP,VTMP)
      CALL HWVSUM(4,VTMP,VCLUS(1,JHEP),VCLUS(1,MHEP))
      VSCA=-0.25*EMC+HALF*(DELTM-PXY)
      CALL HWVSCA(3,VSCA,AX,VTMP)
      VTMP(4)=(EMC+VSCA)*RKAPPA
      CALL HWULB4(PCL,VTMP,VTMP)
      CALL HWVSUM(4,VTMP,VCLUS(1,JHEP),VCLUS(1,JHEP))
C (Re-)label quarks
      IDHW(LHEP)=ID3+6
      IDHW(MHEP)=ID3
      IDHEP(MHEP)= IDPDG(ID3)
      IDHEP(LHEP)=-IDPDG(ID3)
      ISTHEP(LHEP)=151
      ISTHEP(MHEP)=151
      JMOHEP(2,JHEP)=LHEP
      JDAHEP(2,KHEP)=MHEP
      JMOHEP(1,LHEP)=JMOHEP(1,KHEP)
      JMOHEP(2,LHEP)=MHEP
      JDAHEP(1,LHEP)=0
      JDAHEP(2,LHEP)=JHEP
      JMOHEP(1,MHEP)=JMOHEP(1,JHEP)
      JMOHEP(2,MHEP)=KHEP
      JDAHEP(1,MHEP)=0
      JDAHEP(2,MHEP)=LHEP
      NHEP=NHEP+2
  999 END
CDECK  ID>, HWCDEC.
*CMZ :-        -26/04/91  10.18.56  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWCDEC
C-----------------------------------------------------------------------
C     DECAYS CLUSTERS INTO PRIMARY HADRONS
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      INTEGER JCL,KCL,IP,JP,KP,IST,ID1,ID2,ID3
      IF (IERROR.NE.0) RETURN
      IF (IPROC/1000.EQ.9.OR.IPROC/1000.EQ.5) THEN
C---RELABEL CLUSTER CONNECTED TO REMNANT IN DIS
        DO 10 JCL=2,NHEP
        IF (ISTHEP(JCL).EQ.164) GOTO 20
        IF (ISTHEP(JCL).EQ.165) THEN
          IP=JMOHEP(1,JCL)
          JP=JMOHEP(2,JCL)
          KP=IP
          IF (ISTHEP(IP).EQ.162) THEN
            KP=JP
            JP=IP
          ENDIF
          IF (JMOHEP(2,KP).NE.JP) THEN
            IP=JMOHEP(2,KP)
          ELSE
            IP=JDAHEP(2,KP)
          ENDIF
          KCL=JDAHEP(1,IP)
          IF (ISTHEP(KCL)/10.NE.16) CALL HWWARN('HWCDEC',100,*999)
          ISTHEP(KCL)=164
          GOTO 20
        ENDIF
   10   CONTINUE
      ENDIF
   20 CONTINUE
      DO 30 JCL=1,NHEP
      IST=ISTHEP(JCL)
      IF (IST.GT.162.AND.IST.LT.166) THEN
C---DON'T HADRONIZE BEAM/TARGET CLUSTERS
        IF (IST.EQ.163.OR..NOT.GENSOF) THEN
C---SET UP FLAVOURS FOR CLUSTER DECAY
          CALL HWCFLA(IDHW(JMOHEP(1,JCL)),IDHW(JMOHEP(2,JCL)),ID1,ID3)
          CALL HWCHAD(JCL,ID1,ID3,ID2)
        ENDIF
      ENDIF
   30 CONTINUE
      ISTAT=50
  999 END
CDECK  ID>, HWCFLA.
*CMZ :-        -26/04/91  10.18.56  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWCFLA(JD1,JD2,ID1,ID2)
C-----------------------------------------------------------------------
C     SETS UP FLAVOURS FOR CLUSTER DECAY
C-----------------------------------------------------------------------
      INTEGER JD1,JD2,ID1,ID2,JD,JDEC(12)
      DATA JDEC/1,2,3,10,11,12,4,5,6,7,8,9/
      JD=JD1
      IF (JD.GT.12) JD=JD-108
      ID1=JDEC(JD)
      JD=JD2
      IF (JD.GT.12) JD=JD-96
      ID2=JDEC(JD-6)
      END
CDECK  ID>, HWCFOR.
*CMZ :-        -26/04/91  14.15.56  by  Federico Carminati
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWCFOR
C-----------------------------------------------------------------------
C     Converts colour-connected quark-antiquark pairs into clusters
C     Modified by IGK to include BRW's colour rearrangement and
C     MHS's cluster vertices
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWULDO,HWVDOT,HWRGEN,HWUPCM,DCL0,DCL(4),DCL1,
     & DFAC,DISP1(4),DISP2(4),DMAX,PCL(5),DOT1,DOT2,FAC,VCLUS,SCA1,SCA2,
     & EM0,EM1,EM2,PC0,PC1
      INTEGER HWRINT,MAP(120),NREST1,NREST2,IBHEP,IBCL,NRECO,JBHEP,JHEP,
     & KHEP,LHEP,LCL,IHEP,MCL,I,ISTJ,ISTK,JCL,ID1,ID3,L
      LOGICAL HWRLOG,QORQQB(NMXRES),QBORQQ(NMXRES),SPLIT
      EXTERNAL HWULDO,HWVDOT,HWRGEN,HWUPCM,HWRINT
      PARAMETER (NREST1=NMXRES-120,NREST2=NMXRES-114)
      COMMON/HWCFRM/VCLUS(4,NMXHEP)
      common/HWRECO/NRECO
      DATA MAP/1,2,3,4,5,6,1,2,3,4,5,6,96*0,7,8,9,10,11,12,7,8,9,10,11,
     & 12/
      DATA QORQQB/6*.TRUE.,108*.FALSE.,6*.TRUE.,NREST1*.FALSE./
      DATA QBORQQ/6*.FALSE.,6*.TRUE.,96*.FALSE.,6*.TRUE.,NREST2*.FALSE./
      IF (IERROR.NE.0) RETURN
C Split gluons
      CALL HWCGSP
C Find colour partners after baryon number violating event
      IF (HVFCEN) CALL HVCBVI
      IF (IERROR.NE.0) RETURN
C Look for partons to cluster
      DO 10 IBHEP=1,NHEP
  10  IF (ISTHEP(IBHEP).GE.150.AND.ISTHEP(IBHEP).LE.154) GOTO 20
      IBCL=1
      GOTO 130
C Allow for clour rearrangement of primary clusters
  20  IF (CLRECO) THEN
        NRECO=0
C Randomize starting point
        JBHEP=HWRINT(IBHEP,NHEP)
        JHEP=JBHEP
  30    JHEP=JHEP+1
        IF (JHEP.GT.NHEP) JHEP=IBHEP
        IF (ISTHEP(JHEP).GE.150.AND.ISTHEP(JHEP).LE.154.AND.
     &      QORQQB(IDHW(JHEP))) THEN
C Find colour connected antiquark or diquark
          KHEP=JMOHEP(2,JHEP)
C Find partner antiquark or diquark
          LHEP=JDAHEP(2,JHEP)
C Find closest antiquark or diquark
          DCL0=1.D15
          LCL=0
          DO 40 IHEP=IBHEP,NHEP
          IF (ISTHEP(IHEP).GE.150.AND.ISTHEP(IHEP).LE.154.AND.
     &        QBORQQ(IDHW(IHEP))) THEN
C Check whether already reconnected
            IF (JDAHEP(2,IHEP).GT.0.AND.IHEP.NE.LHEP) THEN
              CALL HWVDIF(4,VHEP(1,IHEP),VHEP(1,JHEP),DCL)
              DCL1=ABS(HWULDO(DCL,DCL))
              IF (DCL1.LT.DCL0) THEN
                DCL0=DCL1
                LCL=IHEP
              ENDIF
            ENDIF
          ENDIF
  40      CONTINUE
          IF (LCL.NE.0.AND.LCL.NE.KHEP) THEN
            MCL=JDAHEP(2,LCL)
            IF (JDAHEP(2,MCL).NE.KHEP) THEN
C Pairwise reconnection is possible
              CALL HWVDIF(4,VHEP(1,KHEP),VHEP(1,MCL ),DCL)
              DCL0=DCL0+ABS(HWULDO(DCL,DCL))
              CALL HWVDIF(4,VHEP(1,JHEP),VHEP(1,KHEP),DCL)
              DCL1=ABS(HWULDO(DCL,DCL))
              CALL HWVDIF(4,VHEP(1,LCL ),VHEP(1,MCL ),DCL)
              DCL1=DCL1+ABS(HWULDO(DCL,DCL))
              IF (DCL0.LT.DCL1.AND.HWRLOG(PRECO)) THEN
C Reconnection occurs
                JMOHEP(2,JHEP)= LCL
                JDAHEP(2,LCL )=-JHEP
                JMOHEP(2,MCL) = KHEP
                JDAHEP(2,KHEP)=-MCL
                NRECO=NRECO+1
              ENDIF
            ENDIF
          ENDIF
        ENDIF
        IF (JHEP.NE.JBHEP) GOTO 30
        IF (NRECO.NE.0) THEN
          DO 50 IHEP=IBHEP,NHEP
  50      JDAHEP(2,IHEP)=ABS(JDAHEP(2,IHEP))
        ENDIF
      ENDIF
C Find (adjusted) cluster positions using MHS prescription
      DFAC=10
      DMAX=1D-10
      DO 70 JHEP=IBHEP,NHEP
      IF (ISTHEP(JHEP).GE.150.AND.ISTHEP(JHEP).LE.154.AND.
     &    QORQQB(IDHW(JHEP))) THEN
        KHEP=JMOHEP(2,JHEP)
        CALL HWUDKL(IDHW(JHEP),PHEP(1,JHEP),DISP1)
        CALL HWVSCA(4,DFAC,DISP1,DISP1)
        CALL HWUDKL(IDHW(KHEP),PHEP(1,KHEP),DISP2)
        CALL HWVSCA(4,DFAC,DISP2,DISP2)
C Rescale the lengths of DISP1,DISP2 if too long
        DOT1=HWVDOT(3,DISP1,DISP1)
        DOT2=HWVDOT(3,DISP2,DISP2)
        IF (MAX(DOT1,DOT2).GT.DMAX**2) THEN
          CALL HWVSCA(4,DMAX/SQRT(DOT1),DISP1,DISP1)
          CALL HWVSCA(4,DMAX/SQRT(DOT2),DISP2,DISP2)
        ENDIF
        CALL HWVSUM(4,PHEP(1,JHEP),PHEP(1,KHEP),PCL)
        DOT1=HWVDOT(3,DISP1,PCL)
        DOT2=HWVDOT(3,DISP2,PCL)
C If PCL > 90^o from either quark, use a vector which isn't
        IF (DOT1.LE.0..OR. DOT2.LE.0.) THEN
          CALL HWVSUM(4,DISP1,DISP2,PCL)
          DOT1=HWVDOT(3,DISP1,PCL)
          DOT2=HWVDOT(3,DISP2,PCL)
        ENDIF
C If vectors are exactly opposite each other this method cannot work
        IF (DOT1.EQ.0.OR.DOT2.EQ.0) THEN
C So use midpoint of quark constituents
          CALL HWVSUM(4,VHEP(1,JHEP),VHEP(1,KHEP),VCLUS(1,JHEP))
          CALL HWVSCA(4,0.5D0,VCLUS(1,JHEP),VCLUS(1,JHEP))
          GOTO 70
        ENDIF
C Rescale DISP1 or DISP2 to give equal components in the PCL direction
        FAC=DOT1/DOT2
        IF (FAC.GT.1) THEN
          CALL HWVSCA(4,    FAC,DISP2,DISP2)
          DOT2=DOT1
        ELSE
          CALL HWVSCA(4,ONE/FAC,DISP1,DISP1)
          DOT1=DOT2
        ENDIF
C Shift VHEP(1,JHEP) or VHEP(1,KHEP) s.t. their line is perp to PCL
        FAC=(HWVDOT(3,PCL,VHEP(1,KHEP))
     &      -HWVDOT(3,PCL,VHEP(1,JHEP)))/DOT1
        SCA1=MAX(ONE,ONE+FAC)
        SCA2=MAX(ONE,ONE-FAC)
        DO 60 I=1,4
  60    VCLUS(I,JHEP)=.5*(VHEP(I,JHEP)+VHEP(I,KHEP)
     &                   +SCA1*DISP1(I)+SCA2*DISP2(I))
      ENDIF
  70  CONTINUE
C First chop up beam/target clusters
      DO 80 JHEP=IBHEP,NHEP
      KHEP=JMOHEP(2,JHEP)
      ISTJ=ISTHEP(JHEP)
      ISTK=ISTHEP(KHEP)
      IF (QORQQB(IDHW(JHEP)).AND.
     &   (((ISTJ.EQ.153.OR.ISTJ.EQ.154).AND.ISTK.NE.151).OR.
     &    ((ISTK.EQ.153.OR.ISTK.EQ.154).AND.ISTJ.NE.151))) THEN
        CALL HWVSUM(4,PHEP(1,JHEP),PHEP(1,KHEP),PCL)
        CALL HWUMAS(PCL)
        CALL HWCCUT(JHEP,KHEP,PCL,.TRUE.,SPLIT)
      ENDIF
  80  CONTINUE
C Second chop up massive pairs
      DO 100 JHEP=IBHEP,NMXHEP
      IF (JHEP.GT.NHEP) GOTO 110
      IF (ISTHEP(JHEP).GE.150.AND.ISTHEP(JHEP).LE.154.AND.
     &    QORQQB(IDHW(JHEP))) THEN
  90    KHEP=JMOHEP(2,JHEP)
        CALL HWVSUM(4,PHEP(1,JHEP),PHEP(1,KHEP),PCL)
        CALL HWUMAS(PCL)
        IF (PCL(5).GT.CTHRPW(MAP(IDHW(JHEP)),MAP(IDHW(KHEP)))) THEN
          CALL HWCCUT(JHEP,KHEP,PCL,.FALSE.,SPLIT)
          IF (SPLIT) GOTO 90
        ENDIF
      ENDIF
  100 CONTINUE
C Third create clusters and store production vertex
  110 IBCL=NHEP+1
      JCL=NHEP
      DO 120 JHEP=IBHEP,NHEP
      IF (ISTHEP(JHEP).GE.150.AND.ISTHEP(JHEP).LE.154.AND.
     &    QORQQB(IDHW(JHEP))) THEN
        JCL=JCL+1
        IDHW(JCL)=19
        IDHEP(JCL)=91
        KHEP=JMOHEP(2,JHEP)
        CALL HWVSUM(4,PHEP(1,JHEP),PHEP(1,KHEP),PHEP(1,JCL))
        CALL HWUMAS(PHEP(1,JCL))
        IF (ISTHEP(JHEP).EQ.153.OR.ISTHEP(KHEP).EQ.153) THEN
          ISTHEP(JCL)=164
        ELSEIF (ISTHEP(JHEP).EQ.154.OR.ISTHEP(KHEP).EQ.154) THEN
          ISTHEP(JCL)=165
        ELSE
          ISTHEP(JCL)=163
        ENDIF
        JMOHEP(1,JCL)=JHEP
        JMOHEP(2,JCL)=KHEP
        JDAHEP(1,JCL)=0
        JDAHEP(2,JCL)=0
        JDAHEP(1,JHEP)=JCL
        JDAHEP(1,KHEP)=JCL
        ISTHEP(JHEP)=ISTHEP(JHEP)+8
        ISTHEP(KHEP)=ISTHEP(KHEP)+8
        CALL HWVEQU(4,VCLUS(1,JHEP),VHEP(1,JCL))
      ENDIF
  120 CONTINUE
      NHEP=JCL
C Fix up momenta for single-hadron clusters
  130 DO 150 JCL=IBCL,NHEP
C Don't hadronize beam/target clusters
      IF (ISTHEP(JCL).LT.163.OR.ISTHEP(JCL).GT.165) GOTO 150
      IF (ISTHEP(JCL).NE.163.AND.GENSOF) GOTO 150
C Set up flavours for cluster decay
      CALL HWCFLA(IDHW(JMOHEP(1,JCL)),IDHW(JMOHEP(2,JCL)),ID1,ID3)
      EM0=PHEP(5,JCL)
      IF ((B1LIM.EQ.ZERO).OR.(ID1.NE.11.AND.ID3.NE.11)) THEN
        IF (EM0.GT.RMIN(ID1,2)+RMIN(2,ID3)) GOTO 150
      ELSE
C Special for b clusters: allow 1-hadron decay above threshold
        IF (B1LIM*HWRGEN(1).LT.EM0/(RMIN(ID1,2)+RMIN(2,ID3))-1.)
     &   GOTO 150
      ENDIF
      EM1=RMIN(ID1,ID3)
      IF (ABS(EM0-EM1).LT.1.D-3) GOTO 150
C Decide to go backward or forward to transfer 4-momentum
      L=1-TWO*INT(HALF+HWRGEN(2))
      MCL=NHEP-IBCL+1
      LCL=JCL
      DO 140 I=1,MCL
      LCL=LCL+L
      IF (LCL.LT.IBCL) LCL=LCL+MCL
      IF (LCL.GT.NHEP) LCL=LCL-MCL
      IF (LCL.EQ.JCL) THEN
        IF (EM0.GE.EM1+RMIN(1,1)) GOTO 150
        CALL HWWARN('HWCFOR',101,*999)
      ENDIF
      IF (ISTHEP(LCL).LT.163.OR.ISTHEP(LCL).GT.165) GOTO 140
C Rescale momenta in 2-cluster CoM
      CALL HWVSUM(4,PHEP(1,JCL),PHEP(1,LCL),PCL)
      CALL HWUMAS(PCL)
      EM2=PHEP(5,LCL)
      PC0=HWUPCM(PCL(5),EM0,EM2)
      PC1=HWUPCM(PCL(5),EM1,EM2)
      IF (PC1.LT.0.) THEN
C Need to rescale other mass as well
        CALL HWCFLA(IDHW(JMOHEP(1,LCL)),IDHW(JMOHEP(2,LCL)),ID1,ID3)
        EM2=RMIN(ID1,ID3)
        PC1=HWUPCM(PCL(5),EM1,EM2)
        IF (PC1.LT.0.) GOTO 140
        PHEP(5,LCL)=EM2
      ENDIF
      IF (PC0.GT.0.) THEN
        PC0=PC1/PC0
        CALL HWULOF(PCL,PHEP(1,JCL),PHEP(1,JCL))
        CALL HWVSCA(3,PC0,PHEP(1,JCL),PHEP(1,JCL))
        PHEP(4,JCL)=SQRT(PC1**2+EM1**2)
        PHEP(5,JCL)=EM1
        CALL HWULOB(PCL,PHEP(1,JCL),PHEP(1,JCL))
        CALL HWVDIF(4,PCL,PHEP(1,JCL),PHEP(1,LCL))
        GOTO 150
      ELSEIF (PC0.EQ.0.) THEN
        PHEP(5,JCL)=EM1
        CALL HWDTWO(PCL,PHEP(1,JCL),PHEP(1,LCL),PC1,TWO,.TRUE.)
        GOTO 150
      ELSE
        CALL HWWARN('HWCFOR',102,*999)
      ENDIF
  140 CONTINUE
      CALL HWWARN('HWCFOR',103,*999)
  150 CONTINUE
      ISTAT=60
C Non-partons labelled as partons (ie photons) should get copied
      DO 160 IHEP=1,NHEP
      IF (ISTHEP(IHEP).EQ.150) THEN
        NHEP=NHEP+1
        JDAHEP(1,IHEP)=NHEP
        ISTHEP(IHEP)=157
        ISTHEP(NHEP)=190
        IDHW(NHEP)=IDHW(IHEP)
        IDHEP(NHEP)=IDPDG(IDHW(IHEP))
        CALL HWVEQU(5,PHEP(1,IHEP),PHEP(1,NHEP))
        CALL HWVEQU(4,VHEP(1,IHEP),VHEP(1,NHEP))
        JMOHEP(1,NHEP)=IHEP
        JMOHEP(2,NHEP)=JMOHEP(1,IHEP)
        JDAHEP(1,NHEP)=0
        JDAHEP(2,NHEP)=0
      ENDIF
  160 CONTINUE
  999 END
CDECK  ID>, HWCGSP.
*CMZ :-        -13/07/92  20.15.54  by  Mike Seymour
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWCGSP
C-----------------------------------------------------------------------
C     SPLITS ANY TIMELIKE GLUONS REMAINING AFTER PERTURBATIVE
C     BRANCHING INTO LIGHT (I.E. U OR D) Q-QBAR PAIRS
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,PF
      INTEGER HWRINT,IHEP,JHEP,KHEP,LHEP,MHEP,ID,J,IST
      EXTERNAL HWRGEN,HWRINT
      IF (NGSPL.EQ.0) CALL HWWARN('HWCGSP',400,*999)
      LHEP=NHEP-1
      MHEP=NHEP
      DO 100 IHEP=1,NHEP
      IF (ISTHEP(IHEP).GE.147.AND.ISTHEP(IHEP).LE.149) THEN
        JHEP=JMOHEP(2,IHEP)
C---CHECK FOR DECAYED HEAVY ANTIQUARKS
        IF (ISTHEP(JHEP).EQ.155) THEN
          JHEP=JDAHEP(1,JDAHEP(2,JHEP))
          DO 10 J=JDAHEP(1,JHEP),JDAHEP(2,JHEP)
  10      IF (ISTHEP(J).EQ.149.AND.JDAHEP(2,J).EQ.0) GOTO 20
          CALL HWWARN('HWCGSP',100,*999)
  20      JHEP=J
        ENDIF
        KHEP=JDAHEP(2,IHEP)
C---CHECK FOR DECAYED HEAVY QUARKS
        IF (ISTHEP(KHEP).EQ.155)  CALL HWWARN('HWCGSP',101,*999)
        IF (IDHW(IHEP).EQ.13) THEN
C---SPLIT A GLUON
          LHEP=LHEP+2
          MHEP=MHEP+2
  30      ID=HWRINT(1,NGSPL)
          IF (PGSPL(ID).LT.PGSMX*HWRGEN(0)) GOTO 30
          PHEP(5,LHEP)=RMASS(ID)
          PHEP(5,MHEP)=RMASS(ID)
C---ASSUME ISOTROPIC ANGULAR DISTRIBUTION
          IF (PHEP(5,IHEP).GT.PHEP(5,LHEP)+PHEP(5,MHEP)) THEN
            CALL HWDTWO(PHEP(1,IHEP),PHEP(1,LHEP),
     &                  PHEP(1,MHEP),PGSPL(ID),TWO,.TRUE.)
          ELSE
            PF=HWRGEN(1)
            CALL HWVSCA(4,PF,PHEP(1,IHEP),PHEP(1,LHEP))
            CALL HWVDIF(4,PHEP(1,IHEP),PHEP(1,LHEP),PHEP(1,MHEP))
            PHEP(5,LHEP)=PF*PHEP(5,IHEP)
            PHEP(5,MHEP)=PHEP(5,IHEP)-PHEP(5,LHEP)
          ENDIF
          CALL HWUDKL(13,PHEP(1,IHEP),VHEP(1,LHEP))
          CALL HWVSUM(4,VHEP(1,IHEP),VHEP(1,LHEP),VHEP(1,LHEP))
          CALL HWVEQU(4,VHEP(1,LHEP),VHEP(1,MHEP))
          IDHW(LHEP)=ID+6
          IDHW(MHEP)=ID
          IDHEP(MHEP)= IDPDG(ID)
          IDHEP(LHEP)=-IDPDG(ID)
          ISTHEP(IHEP)=2
          ISTHEP(LHEP)=150
          ISTHEP(MHEP)=150
C---NEW COLOUR CONNECTIONS
          JMOHEP(2,KHEP)=LHEP
          JDAHEP(2,JHEP)=MHEP
          JMOHEP(1,LHEP)=JMOHEP(1,IHEP)
          JMOHEP(2,LHEP)=MHEP
          JMOHEP(1,MHEP)=JMOHEP(1,IHEP)
          JMOHEP(2,MHEP)=JHEP
          JDAHEP(1,LHEP)=0
          JDAHEP(2,LHEP)=KHEP
          JDAHEP(1,MHEP)=0
          JDAHEP(2,MHEP)=LHEP
          JDAHEP(1,IHEP)=LHEP
          JDAHEP(2,IHEP)=MHEP
        ELSE
C---COPY A NON-GLUON
          LHEP=LHEP+1
          MHEP=MHEP+1
          CALL HWVEQU(5,PHEP(1,IHEP),PHEP(1,MHEP))
          CALL HWVEQU(4,VHEP(1,IHEP),VHEP(1,MHEP))
          IDHW(MHEP)=IDHW(IHEP)
          IDHEP(MHEP)=IDHEP(IHEP)
          IST=ISTHEP(IHEP)
          ISTHEP(IHEP)=2
          IF (IST.EQ.149) THEN
            ISTHEP(MHEP)=150
          ELSE
            ISTHEP(MHEP)=IST+6
          ENDIF
C---NEW COLOUR CONNECTIONS
          JMOHEP(2,KHEP)=MHEP
          JDAHEP(2,JHEP)=MHEP
          JMOHEP(1,MHEP)=JMOHEP(1,IHEP)
          JMOHEP(2,MHEP)=JMOHEP(2,IHEP)
          JDAHEP(1,MHEP)=0
          JDAHEP(2,MHEP)=JDAHEP(2,IHEP)
          JDAHEP(1,IHEP)=MHEP
        ENDIF
      ENDIF
  100 CONTINUE
      NHEP=MHEP
  999 END
CDECK  ID>, HWCHAD.
*CMZ :-        -26/04/91  14.00.57  by  Federico Carminati
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWCHAD(JCL,ID1,ID3,ID2)
C-----------------------------------------------------------------------
C     HADRONIZES CLUSTER JCL, CONSISTING OF PARTONS ID1,ID3
C     ID2 RETURNS PARTON-ANTIPARTON PAIR CREATED
C     (IN SPECIAL CLUSTER CODE - SEE HWCFLA)
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,EM0,EM1,EM2,EMADU,EMSQ,PCMAX,PCM,PTEST,
     & PCQK,PP(5),EMLOW,RMAT(3,3),CT,ST,CX,SX
      INTEGER HWRINT,JCL,ID1,ID2,ID3,ID,IR1,IR2,NTRY,IDMIN,IMAX,I,MHEP,
     & IM,JM,KM
      LOGICAL DIQK
      EXTERNAL HWRGEN,HWRINT
      DIQK(ID)=ID.GT.3.AND.ID.LT.10
      IF (IERROR.NE.0) RETURN
      ID2=0
      EM0=PHEP(5,JCL)
      IR1=NCLDK(LOCN(ID1,ID3))
      EM1=RMIN(ID1,ID3)
      IF (ABS(EM0-EM1).LT.0.001) THEN
C---SINGLE-HADRON CLUSTER
        NHEP=NHEP+1
        IF (NHEP.GT.NMXHEP) CALL HWWARN('HWCHAD',100,*999)
        IDHW(NHEP)=IR1
        IDHEP(NHEP)=IDPDG(IR1)
        ISTHEP(NHEP)=191
        JDAHEP(1,JCL)=NHEP
        JDAHEP(2,JCL)=NHEP
        CALL HWVEQU(5,PHEP(1,JCL),PHEP(1,NHEP))
        CALL HWVSUM(4,VHEP(1,JCL),VTXPIP,VHEP(1,NHEP))
      ELSE
        NTRY=0
        IDMIN=1
        EMLOW=RMIN(ID1,1)+RMIN(1,ID3)
        EMADU=RMIN(ID1,2)+RMIN(2,ID3)
        IF (EMADU.LT.EMLOW) THEN
          IDMIN=2
          EMLOW=EMADU
        ENDIF
        EMSQ=EM0**2
        PCMAX=EMSQ-EMLOW**2
        IF (PCMAX.GE.0.) THEN
C---SET UP TWO QUARK-ANTIQUARK PAIRS OR A
C   QUARK-DIQUARK AND AN ANTIDIQUARK-ANTIQUARK
          PCMAX=PCMAX*(EMSQ-(RMIN(ID1,IDMIN)-RMIN(IDMIN,ID3))**2)
          IMAX=12
          IF (DIQK(ID1).OR.DIQK(ID3)) IMAX=3
          DO 10 I=3,IMAX
          IF (EM0.LT.RMIN(ID1,I)+RMIN(I,ID3)) GOTO 20
  10      CONTINUE
          I=IMAX+1
  20      ID2=HWRINT(1,I-1)
          IF (PWT(ID2).NE.1.) THEN
            IF (PWT(ID2).LT.HWRGEN(1)) GOTO 20
          ENDIF
C---PICK TWO PARTICLES WITH THESE QUANTUM NUMBERS
          NTRY=NTRY+1
  30      IR1=LOCN(ID1,ID2)+INT(RESN(ID1,ID2)*HWRGEN(2))
          IF (CLDKWT(IR1).LT.HWRGEN(3)) GOTO 30
          IR1=NCLDK(IR1)
  40      IR2=LOCN(ID2,ID3)+INT(RESN(ID2,ID3)*HWRGEN(4))
          IF (CLDKWT(IR2).LT.HWRGEN(5)) GOTO 40
          IR2=NCLDK(IR2)
          EM1=RMASS(IR1)
          EM2=RMASS(IR2)
          PCM=EMSQ-(EM1+EM2)**2
          IF (PCM.GT.0.) GOTO 70
  50      IF (NTRY.LE.NDTRY) GOTO 20
C---CAN'T FIND A DECAY MODE - CHOOSE LIGHTEST
  60      ID2=HWRINT(1,2)
          IR1=NCLDK(LOCN(ID1,ID2))
          IR2=NCLDK(LOCN(ID2,ID3))
          EM1=RMASS(IR1)
          EM2=RMASS(IR2)
          PCM=EMSQ-(EM1+EM2)**2
          IF (PCM.GT.0.) GOTO 70
          NTRY=NTRY+1
          IF (NTRY.LE.NDTRY+50) GOTO 60
          CALL HWWARN('HWCHAD',101,*999)
C---DECAY IS ALLOWED
  70      PCM=PCM*(EMSQ-(EM1-EM2)**2)
          IF (NTRY.GT.NCTRY) GOTO 80
          PTEST=PCM*SWTEF(IR1)*SWTEF(IR2)
          IF (PTEST.LT.PCMAX*HWRGEN(0)**2) GOTO 20
        ELSE
C---ALLOW DECAY BY PI0 EMISSION IF ONLY POSSIBILITY
          ID2=1
          IR2=NCLDK(LOCN(1,1))
          EM2=RMASS(IR2)
          PCM=(EMSQ-(EM1+EM2)**2)*(EMSQ-(EM1-EM2)**2)
        ENDIF
C---DECAY IS CHOSEN.  GENERATE DECAY MOMENTA
C   AND PUT PARTICLES IN /HEPEVT/
  80    IF (PCM.LT.0.) CALL HWWARN('HWCHAD',102,*999)
        PCM=0.5*SQRT(PCM)/EM0
        MHEP=NHEP+1
        NHEP=NHEP+2
        IF (NHEP.GT.NMXHEP) CALL HWWARN('HWCHAD',103,*999)
        PHEP(5,MHEP)=EM1
        PHEP(5,NHEP)=EM2
        IF (CLDIR.NE.0) THEN
          DO 110 IM=1,2
            JM=JMOHEP(IM,JCL)
            IF (JM.EQ.0) GOTO 110
            IF (ISTHEP(JM).NE.158) GOTO 110
C   LOOK FOR PARENT PARTON
            DO 100 KM=JMOHEP(1,JM)+1,JM
              IF (ISTHEP(KM).EQ.2) THEN
                IF (JDAHEP(1,KM).EQ.JM) THEN
C   FOUND PARENT PARTON
                  IF (IDHW(KM).NE.13) THEN
C   FIND ITS DIRECTION IN CLUSTER CMF
                   CALL HWULOF(PHEP(1,JCL),PHEP(1,KM),PP)
                   PCQK=PP(1)**2+PP(2)**2+PP(3)**2
                   IF (PCQK.GT.ZERO) THEN
                    PCQK=SQRT(PCQK)
                    IF (CLSMR.GT.ZERO) THEN
C   DO GAUSSIAN SMEARING OF DIRECTION
  90                 CT=ONE+CLSMR*LOG(HWRGEN(0))
                     IF (CT.LT.-ONE) GOTO 90
                     ST=ONE-CT*CT
                     IF (ST.GT.ZERO) ST=SQRT(ST)
                     CALL HWRAZM( ONE,CX,SX)
                     CALL HWUROT(PP,CX,SX,RMAT)
                     PP(1)=ZERO
                     PP(2)=PCQK*ST
                     PP(3)=PCQK*CT
                     CALL HWUROB(RMAT,PP,PP)
                    ENDIF
                    PCQK=PCM/PCQK
                    IF (IM.EQ.2) PCQK=-PCQK
                    CALL HWVSCA(3,PCQK,PP,PHEP(1,MHEP))
                    PHEP(4,MHEP)=SQRT(PHEP(5,MHEP)**2+PCM**2)
                    CALL HWULOB(PHEP(1,JCL),PHEP(1,MHEP),PHEP(1,MHEP))
                    CALL HWVDIF(4,PHEP(1,JCL),PHEP(1,MHEP),PHEP(1,NHEP))
                    GOTO 130
                   ENDIF
                  ENDIF
                  GOTO 120
                ENDIF
              ELSEIF (ISTHEP(KM).GT.140) THEN
C   FINISHED THIS JET
                GOTO 110
              ENDIF
 100        CONTINUE
 110      CONTINUE
        ENDIF
 120    CALL HWDTWO(PHEP(1,JCL),PHEP(1,MHEP),PHEP(1,NHEP),
     &              PCM,TWO,.TRUE.)
 130    IDHW(MHEP)=IR1
        IDHW(NHEP)=IR2
        IDHEP(MHEP)=IDPDG(IR1)
        IDHEP(NHEP)=IDPDG(IR2)
        ISTHEP(MHEP)=192
        ISTHEP(NHEP)=192
        JMOHEP(1,MHEP)=JCL
C---SECOND MOTHER OF HADRON IS JET
        JMOHEP(2,MHEP)=JMOHEP(1,JMOHEP(1,JCL))
        JDAHEP(1,JCL)=MHEP
        JDAHEP(2,JCL)=NHEP
        CALL HWVSUM(4,VHEP(1,JCL),VTXPIP,VHEP(1,MHEP))
        CALL HWVEQU(4,VHEP(1,MHEP),VHEP(1,NHEP))
      ENDIF
      ISTHEP(JCL)=180+MOD(ISTHEP(JCL),10)
      JMOHEP(1,NHEP)=JCL
      JMOHEP(2,NHEP)=JMOHEP(1,JMOHEP(1,JCL))
  999 END
CDECK  ID>, HWDBOS.
*CMZ :-        -23/05/96  18.34.17  by  Mike Seymour
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HWDBOS(IBOS)
C-----------------------------------------------------------------------
C     DECAY GAUGE BOSONS (ALREADY FOUND BY HWDHAD)
C     USES SPIN DENSITY MATRIX IN RHOHEP (1ST CMPT=>-VE,2=>LONG,3=>+VE)
C     IF BOSON CAME FROM HIGGS DECAY, GIVE BOTH THE SAME HELICITY (EPR)
C     IF BOSON CAME FROM W+1JET, GIVE IT THE CORRECT DECAY CORRELATIONS
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,HWRUNI,HWUPCM,HWULDO,R(3,3),CV,CA,BR,PCM,
     & PBOS(5),PMAX,PROB,RRLL,RLLR
      INTEGER HWRINT,IBOS,IPAIR,ICMF,IOPT,IHEL,IMOTH,I,IQRK,IANT,ID,IQ
      LOGICAL QUARKS
      EXTERNAL HWRGEN,HWRUNI,HWUPCM,HWULDO,HWRINT
      IF (IDHW(IBOS).LT.198.OR.IDHW(IBOS).GT.200)
     &  CALL HWWARN('HWDBOS',101,*999)
      QUARKS=.FALSE.
C---SEE IF IT IS PART OF A PAIR
      IMOTH=JMOHEP(1,IBOS)
      IPAIR=JMOHEP(2,IBOS)
      ICMF=JMOHEP(1,IBOS)
      IF (IDHW(ICMF).EQ.IDHW(IBOS).AND.ISTHEP(ICMF)/10.EQ.12)
     &  ICMF=JMOHEP(1,ICMF)
      IOPT=0
      IF (IPAIR.NE.0) THEN
        IF (JMOHEP(2,IPAIR).NE.IBOS.OR.
     &    IDHW(IPAIR).LT.198.OR.IDHW(IPAIR).GT.200) IPAIR=0
      ENDIF
      IF (IPAIR.GT.0) IOPT=1
C---SELECT DECAY PRODUCTS
   10 CALL HWDBOZ(IDHW(IBOS),IDN(1),IDN(2),CV,CA,BR,IOPT)
C---V + 1JET DECAYS ARE NOW HANDLED HERE !
      IF (IPRO.EQ.21) THEN
        IQRK=IDHW(JMOHEP(1,ICMF))
        IANT=IDHW(JMOHEP(2,ICMF))
        IF (IQRK.EQ.13 .AND. IANT.LE.6) THEN
          IQRK=JMOHEP(2,ICMF)
          IANT=JDAHEP(2,ICMF)
        ELSEIF (IQRK.EQ.13) THEN
          IQRK=JDAHEP(2,ICMF)
          IANT=JMOHEP(2,ICMF)
        ELSEIF (IANT.EQ.13 .AND. IQRK.LE.6) THEN
          IQRK=JMOHEP(1,ICMF)
          IANT=JDAHEP(2,ICMF)
        ELSEIF (IANT.EQ.13) THEN
          IQRK=JDAHEP(2,ICMF)
          IANT=JMOHEP(1,ICMF)
        ELSEIF (IQRK.GT.IANT) THEN
          IQRK=JMOHEP(2,ICMF)
          IANT=JMOHEP(1,ICMF)
        ELSE
          IQRK=JMOHEP(1,ICMF)
          IANT=JMOHEP(2,ICMF)
        ENDIF
        PHEP(5,NHEP+1)=RMASS(IDN(1))
        PHEP(5,NHEP+2)=RMASS(IDN(2))
        PCM=HWUPCM(PHEP(5,IBOS),PHEP(5,NHEP+1),PHEP(5,NHEP+2))
        IF (PCM.LT.0) CALL HWWARN('HWDBOS',103,*999)
        IF (IDHW(IBOS).EQ.200) THEN
          ID=IDN(1)
          IF (ID.GT.120) ID=ID-110
          IQ=IDHW(IQRK)
          IF (IQ.GT.6) IQ=IQ-6
          RRLL=(VFCH(IQ,1)**2+AFCH(IQ,1)**2)*
     $         (VFCH(ID,1)**2+AFCH(ID,1)**2)
     $         +4*VFCH(IQ,1)*AFCH(IQ,1)*
     $         VFCH(ID,1)*AFCH(ID,1)
          RLLR=(VFCH(IQ,1)**2+AFCH(IQ,1)**2)*
     $         (VFCH(ID,1)**2+AFCH(ID,1)**2)
     $         -4*VFCH(IQ,1)*AFCH(IQ,1)*
     $         VFCH(ID,1)*AFCH(ID,1)
        ELSE
          RRLL=1
          RLLR=0
        ENDIF
        PMAX=(RRLL+RLLR)
     &      *(HWULDO(PHEP(1,IANT),PHEP(1,IBOS))**2+
     &        HWULDO(PHEP(1,IQRK),PHEP(1,IBOS))**2)
 1      CALL HWDTWO(PHEP(1,IBOS),PHEP(1,NHEP+1),PHEP(1,NHEP+2),
     &              PCM,TWO,.TRUE.)
        PROB=RRLL*(HWULDO(PHEP(1,IANT),PHEP(1,NHEP+1))**2+
     &             HWULDO(PHEP(1,IQRK),PHEP(1,NHEP+2))**2)+
     &       RLLR*(HWULDO(PHEP(1,IANT),PHEP(1,NHEP+2))**2+
     &             HWULDO(PHEP(1,IQRK),PHEP(1,NHEP+1))**2)
        IF (PROB.GT.PMAX.OR.PROB.LT.0) CALL HWWARN('HWDBOS',104,*999)
        IF (PMAX*HWRGEN(0).GT.PROB) GOTO 1
      ELSE
C---SELECT HELICITY, UNLESS IT IS THE SECOND OF A HIGGS DECAY (EPR)
      IF (IPAIR.NE.IBOS .OR. IDHW(ICMF).NE.201) THEN
      IF (RHOHEP(1,IBOS)+RHOHEP(2,IBOS)+RHOHEP(3,IBOS).LE.0) THEN
C---COPY PARENT HELICITY IF IT WAS A GAUGE BOSON
        IF (IDHW(IMOTH).GE.198.AND.IDHW(IMOTH).LE.200) THEN
          CALL HWVEQU(3,RHOHEP(1,IMOTH),RHOHEP(1,IBOS))
          IF (RHOHEP(1,IBOS)+RHOHEP(2,IBOS)+RHOHEP(3,IBOS).GT.0)
     &    GOTO 20
        ENDIF
        CALL HWWARN('HWDBOS',1,*999)
        RHOHEP(1,IBOS)=1.
        RHOHEP(2,IBOS)=1.
        RHOHEP(3,IBOS)=1.
      ENDIF
 20   IHEL=HWRINT(1,3)
      IF (HWRGEN(0).GT.RHOHEP(IHEL,IBOS)) GOTO 20
      ENDIF
C---SELECT DIRECTION OF FERMION
 30   COSTH=HWRUNI(0,-ONE,ONE)
      IF (IHEL.EQ.1 .AND. 0.25*(1+COSTH)**2.LT.HWRGEN(0)) GOTO 30
      IF (IHEL.EQ.2 .AND.      (1-COSTH**2).LT.HWRGEN(0)) GOTO 30
      IF (IHEL.EQ.3 .AND. 0.25*(1-COSTH)**2.LT.HWRGEN(0)) GOTO 30
C---GENERATE DECAY RELATIVE TO Z-AXIS
      PHEP(5,NHEP+1)=RMASS(IDN(1))
      PHEP(5,NHEP+2)=RMASS(IDN(2))
      PCM=HWUPCM(PHEP(5,IBOS),PHEP(5,NHEP+1),PHEP(5,NHEP+2))
      IF (PCM.LT.0) CALL HWWARN('HWDBOS',102,*999)
      CALL HWRAZM(PCM*SQRT(1-COSTH**2),PHEP(1,NHEP+1),PHEP(2,NHEP+1))
      PHEP(3,NHEP+1)=PCM*COSTH
      PHEP(4,NHEP+1)=SQRT(PHEP(5,NHEP+1)**2+PCM**2)
C---ROTATE SO THAT Z-AXIS BECOMES BOSON'S DIRECTION IN ORIGINAL CM FRAME
      CALL HWULOF(PHEP(1,ICMF),PHEP(1,IBOS),PBOS)
      CALL HWUROT(PBOS, ONE,ZERO,R)
      CALL HWUROB(R,PHEP(1,NHEP+1),PHEP(1,NHEP+1))
C---BOOST BACK TO LAB
      CALL HWULOB(PHEP(1,IBOS),PHEP(1,NHEP+1),PHEP(1,NHEP+1))
      CALL HWVDIF(4,PHEP(1,IBOS),PHEP(1,NHEP+1),PHEP(1,NHEP+2))
      ENDIF
C---STATUS, IDs AND POINTERS
      ISTHEP(IBOS)=195
      DO 50 I=1,2
        ISTHEP(NHEP+I)=193
        IDHW(NHEP+I)=IDN(I)
        IDHEP(NHEP+I)=IDPDG(IDN(I))
        JDAHEP(I,IBOS)=NHEP+I
        JMOHEP(1,NHEP+I)=IBOS
        JMOHEP(2,NHEP+I)=JMOHEP(1,IBOS)
 50   CONTINUE
      NHEP=NHEP+2
      IF (IDN(1).LE.12) THEN
        ISTHEP(NHEP-1)=113
        ISTHEP(NHEP)=114
        JMOHEP(2,NHEP)=NHEP-1
        JDAHEP(2,NHEP)=NHEP-1
        JMOHEP(2,NHEP-1)=NHEP
        JDAHEP(2,NHEP-1)=NHEP
        QUARKS=.TRUE.
      ENDIF
C---IF FIRST OF A PAIR, DO SECOND DECAY
      IF (IPAIR.NE.0 .AND. IPAIR.NE.IBOS) THEN
        IBOS=IPAIR
        GOTO 10
      ENDIF
C---IF QUARK DECAY, HADRONIZE
      IF (QUARKS) THEN
        EMSCA=PHEP(5,IBOS)
        CALL HWBGEN
        CALL HWDHQK
        CALL HWCFOR
        CALL HWCDEC
      ENDIF
 999  END
CDECK  ID>, HWDBOZ.
*CMZ :-        -29/04/91  18.00.03  by  Federico Carminati
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HWDBOZ(IDBOS,IFER,IANT,CV,CA,BR,IOPT)
C-----------------------------------------------------------------------
C     CHOOSE DECAY MODE OF BOSON
C     IOPT=2 TO RESET COUNTERS, 1 FOR BOSON PAIR, 0 FOR ANY OTHERS
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,BRMODE(12,3),CV,CA,BR,BRLST,BRCOM,FACZ,
     & FACW
      INTEGER HWRINT,IDBOS,IDEC,IDMODE(2,12,3),IFER,IANT,IOPT,I1,I2,
     & I1LST,I2LST,NWGLST,NUMDEC,NPAIR,MODTMP,JFER
      LOGICAL GENLST
      EXTERNAL HWRGEN,HWRINT
      SAVE FACW,FACZ,NWGLST,GENLST,NUMDEC,NPAIR,I1LST,I2LST,BRLST
      DATA NWGLST,GENLST,NPAIR/-1,.FALSE.,0/
C---STORE THE DECAY MODES (FERMION FIRST)
      DATA IDMODE/  2,  7,  4,  9,  6, 11,  2,  9,  4,  7,
     &            122,127,124,129,126,131,8*0,
     &              1,  8,  3, 10,  5, 12,  3,  8,  1, 10,
     &            121,128,123,130,125,132,8*0,
     &              1,  7,  2,  8,  3,  9,  4, 10,  5, 11,  6, 12,
     &            121,127,123,129,125,131,122,128,124,130,126,132/
C---STORE THE BRANCHING RATIOS TO THESE MODES
      DATA BRMODE/0.321,0.321,0.000,0.017,0.017,0.108,0.108,0.108,4*0.0,
     &            0.321,0.321,0.000,0.017,0.017,0.108,0.108,0.108,4*0.0,
     &            0.154,0.120,0.154,0.120,0.152,0.000,
     &            0.033,0.033,0.033,0.067,0.067,0.067/
C---FACTORS FOR CV AND CA FOR W AND Z
      DATA FACW,FACZ/2*0.0/
      IF (FACZ.EQ.0) FACZ=SQRT(SWEIN)
      IF (FACW.EQ.0) FACW=0.5/SQRT(2D0)
      IF (IDBOS.LT.198.OR.IDBOS.GT.200) CALL HWWARN('HWDBOZ',101,*999)
C---IF THIS IS A NEW EVENT SINCE LAST TIME, ZERO COUNTERS
      IF (NWGTS.NE.NWGLST .OR.(GENEV.NEQV.GENLST).OR. IOPT.EQ.2) THEN
        NPAIR=0
        NUMDEC=0
        NWGLST=NWGTS
        GENLST=GENEV
        IF (IOPT.EQ.2) RETURN
      ENDIF
      NUMDEC=NUMDEC+1
      IF (NUMDEC.GT.MODMAX) CALL HWWARN('HWDBOZ',102,*999)
C---IF PAIR OPTION SPECIFIED FOR THE FIRST TIME, MAKE CHOICE
      IF (IOPT.EQ.1) THEN
        IF (NUMDEC.GT.MODMAX-1) CALL HWWARN('HWDBOZ',103,*999)
        IF (NPAIR.EQ.0) THEN
          IF (HWRGEN(1).GT.0.5) THEN
            MODTMP=MODBOS(NUMDEC+1)
            MODBOS(NUMDEC+1)=MODBOS(NUMDEC)
            MODBOS(NUMDEC)=MODTMP
          ENDIF
          NPAIR=NUMDEC
        ELSE
          NPAIR=0
        ENDIF
      ENDIF
C---SELECT USER'S CHOICE
      IF (IDBOS.EQ.200) THEN
        IF (MODBOS(NUMDEC).EQ.1) THEN
          I1=1
          I2=6
        ELSEIF (MODBOS(NUMDEC).EQ.2) THEN
          I1=7
          I2=7
        ELSEIF (MODBOS(NUMDEC).EQ.3) THEN
          I1=8
          I2=8
        ELSEIF (MODBOS(NUMDEC).EQ.4) THEN
          I1=9
          I2=9
        ELSEIF (MODBOS(NUMDEC).EQ.5) THEN
          I1=7
          I2=8
        ELSEIF (MODBOS(NUMDEC).EQ.6) THEN
          I1=10
          I2=12
        ELSEIF (MODBOS(NUMDEC).EQ.7) THEN
          I1=5
          I2=5
        ELSE
          I1=1
          I2=12
        ENDIF
      ELSE
        IF (MODBOS(NUMDEC).EQ.1) THEN
          I1=1
          I2=5
        ELSEIF (MODBOS(NUMDEC).EQ.2) THEN
          I1=6
          I2=6
        ELSEIF (MODBOS(NUMDEC).EQ.3) THEN
          I1=7
          I2=7
        ELSEIF (MODBOS(NUMDEC).EQ.4) THEN
          I1=8
          I2=8
        ELSEIF (MODBOS(NUMDEC).EQ.5) THEN
          I1=6
          I2=7
        ELSE
          I1=1
          I2=8
        ENDIF
      ENDIF
 10   IDEC=HWRINT(I1,I2)
      IF (HWRGEN(0).GT.BRMODE(IDEC,IDBOS-197).AND.I1.NE.I2) GOTO 10
      IFER=IDMODE(1,IDEC,IDBOS-197)
      IANT=IDMODE(2,IDEC,IDBOS-197)
C---CALCULATE BRANCHING RATIO
C   (RESULT IS NOT WELL-DEFINED AFTER THE FIRST CALL OF A PAIR)
      BR=0
      DO 20 IDEC=I1,I2
 20     BR=BR+BRMODE(IDEC,IDBOS-197)
      IF (IOPT.EQ.1) THEN
        IF (NPAIR.NE.0) THEN
          I1LST=I1
          I2LST=I2
          BRLST=BR
        ELSE
          BRCOM=0
          DO 30 IDEC=MAX(I1,I1LST),MIN(I2,I2LST)
 30         BRCOM=BRCOM+BRMODE(IDEC,IDBOS-197)
          BR=2*BR*BRLST - BRCOM**2
        ENDIF
      ENDIF
C---SET UP VECTOR AND AXIAL VECTOR COUPLINGS (NORMALIZED TO THE
C   CONVENTION WHERE THE WEAK CURRENT IS G*(CV-CA*GAM5) )
      IF (IDBOS.EQ.200) THEN
        IF (IFER.LE.6) THEN
C Quark couplings
           CV=VFCH(IFER,1)
           CA=AFCH(IFER,1)
        ELSE
C lepton couplings
           JFER=IFER-110
           CV=VFCH(JFER,1)
           CA=AFCH(JFER,1)
        ENDIF
        CV=CV * FACZ
        CA=CA * FACZ
      ELSE
        CV=FACW
        CA=FACW
      ENDIF
 999  END
CDECK  ID>, HWDCHK.
*CMZ :-        -
*-- Author :    Ian Knowles
C-----------------------------------------------------------------------
      SUBROUTINE HWDCHK(IDKY,L,*)
C-----------------------------------------------------------------------
C     Checks line L of decay table is compatible with decay of particle
C     IDKY, tidies up the line and sets NPRODS.
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION EPS,QS,Q,DM
      INTEGER IDKY,L,IFAULT,I,ID,J
      PARAMETER (EPS=1.D-6)
      IF (VTOCDK(IDKY).AND.VTORDK(IDKY)) RETURN 1
      IFAULT=0
      QS=FLOAT(ICHRG(IDKY))
      IF (IDKY.LE.12.OR.(IDKY.GE.209.AND.IDKY.LE.220)) QS=QS/3.
      DM=RMASS(IDKY)
      NPRODS(L)=0
      DO 10 I=1,5
      ID=IDKPRD(I,L)
      IF (ID.LT.0.OR.ID.EQ.20.OR.ID.GT.NRES) THEN
        WRITE(6,20) L,RNAME(IDKY),(RNAME(IDKPRD(J,L)),J=1,5)
        IFAULT=IFAULT+1
      ELSEIF (ID.NE.0) THEN
        IF (VTORDK(ID)) THEN
          WRITE(6,30) L,RNAME(IDKY),(RNAME(IDKPRD(J,L)),J=1,5),RNAME(ID)
          IFAULT=IFAULT+1
        ENDIF
        NPRODS(L)=NPRODS(L)+1
        IDKPRD(NPRODS(L),L)=ID
        Q=FLOAT(ICHRG(ID))
        IF (ID.LE.12.OR.(ID.GE.109.AND.ID.LE.120).OR.
     &                  (ID.GE.209.AND.ID.LE.220)) Q=Q/3.
        QS=QS-Q
        DM=DM-RMASS(ID)
      ENDIF
  10  CONTINUE
C print any warnings
      IF (NPRODS(L).EQ.0) THEN
        WRITE(6,20) L,RNAME(IDKY),(RNAME(IDKPRD(I,L)),I=1,5)
        IFAULT=IFAULT+1
      ELSE
        IF (ABS(QS).GT.EPS) THEN
          WRITE(6,40) L,RNAME(IDKY),(RNAME(IDKPRD(I,L)),I=1,5),QS
          IFAULT=IFAULT+1
        ENDIF
        IF (DM.LT.0.) THEN
          WRITE(6,50) L,RNAME(IDKY),(RNAME(IDKPRD(I,L)),I=1,5),DM
          IFAULT=IFAULT+1
        ENDIF
      ENDIF
  20  FORMAT(1X,'Line, ',I4,' decay: ',A8,' --> ',4(A8,1X),A8/
     &       1X,'contains no or unrecognised decay product(s)')
  30  FORMAT(1X,'Line, ',I4,' decay: ',A8,' --> ',4(A8,1X),A8/
     &       1X,'contains decay product ',A8,' which is vetoed')
  40  FORMAT(1X,'Line, ',I4,' decay: ',A8,' --> ',4(A8,1X),A8/
     &       1X,'violates charge conservation, Qin-Qout= ',F6.3)
  50  FORMAT(1X,'Line, ',I4,' decay: ',A8,' --> ',4(A8,1X),A8/
     &       1X,'is kinematically not allowed, Min-Mout= ',F10.3)
      IF (IFAULT.NE.0) THEN
        RETURN 1
      ELSE
        RETURN
      ENDIF
      END
CDECK  ID>, HWDCLE.
*CMZ :-        -28/01/92  12.34.44  by  Mike Seymour
*-- Author :    Luca Stanco
C-----------------------------------------------------------------------
      SUBROUTINE HWDCLE(IHEP)
C-----------------------------------------------------------------------
C INTERFACE TO QQ-CLEO MONTE CARLO (LS 11/12/91)
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      INTEGER IHEP,IIHEP,NHEPHF,QQLMAT
      LOGICAL QQLERR
      CHARACTER*8 NAME
      EXTERNAL QQLMAT
C---QQ-CLEO COMMON'S
C***                 MCPARS.INC
      INTEGER MCTRK, NTRKS, MCVRTX, NVTXS, MCHANS, MCDTRS, MPOLQQ
      INTEGER MCNUM, MCSTBL, MCSTAB, MCTLQQ, MDECQQ
      INTEGER MHLPRB, MHLLST, MHLANG, MCPLST, MFDECA
      PARAMETER (MCTRK = 512)
      PARAMETER (NTRKS = MCTRK)
      PARAMETER (MCVRTX = 256)
      PARAMETER (NVTXS = MCVRTX)
      PARAMETER (MCHANS = 4000)
      PARAMETER (MCDTRS = 8000)
      PARAMETER (MPOLQQ = 300)
      PARAMETER (MCNUM = 500)
      PARAMETER (MCSTBL = 40)
      PARAMETER (MCSTAB = 512)
      PARAMETER (MCTLQQ = 100)
      PARAMETER (MDECQQ = 300)
      PARAMETER (MHLPRB = 500)
      PARAMETER (MHLLST = 1000)
      PARAMETER (MHLANG = 500)
      PARAMETER (MCPLST = 200)
      PARAMETER (MFDECA = 5)
C***                 MCPROP.INC
      REAL AMASS, CHARGE, CTAU, SPIN, RWIDTH, RMASMN, RMASMX
      REAL RMIXPP, RCPMIX
      INTEGER NPMNQQ, NPMXQQ, IDMC, INVMC, LPARTY, CPARTY
      INTEGER IMIXPP, ICPMIX
      COMMON/MCMAS1/
     *       NPMNQQ, NPMXQQ,
     *       AMASS(-20:MCNUM), CHARGE(-20:MCNUM), CTAU(-20:MCNUM),
     *       IDMC(-20:MCNUM), SPIN(-20:MCNUM),
     *       RWIDTH(-20:MCNUM), RMASMN(-20:MCNUM), RMASMX(-20:MCNUM),
     *       LPARTY(-20:MCNUM), CPARTY(-20:MCNUM),
     *       IMIXPP(-20:MCNUM), RMIXPP(-20:MCNUM),
     *       ICPMIX(-20:MCNUM), RCPMIX(-20:MCNUM),
     *       INVMC(0:MCSTBL)
C
      INTEGER NPOLQQ, IPOLQQ
      COMMON/MCPOL1/
     *       NPOLQQ, IPOLQQ(5,MPOLQQ)
C
      CHARACTER QNAME*10, PNAME*10
      COMMON/MCNAMS/
     *       QNAME(37), PNAME(-20:MCNUM)
C
C***                 MCCOMS.INC
      INTEGER NCTLQQ, NDECQQ, IVRSQQ, IORGQQ, IRS1QQ
      INTEGER IEVTQQ, IRUNQQ, IBMRAD
      INTEGER NTRKMC, QQNTRK, NSTBMC, NSTBQQ, NCHGMC, NCHGQQ
      INTEGER IRANQQ, IRANMC, IRANCC, IRS2QQ
      INTEGER IPFTQQ, IPCDQQ, IPRNTV, ITYPEV, IDECSV, IDAUTV
      INTEGER ISTBMC, NDAUTV
      INTEGER IVPROD, IVDECA
      REAL BFLDQQ
      REAL ENERQQ, BEAMQQ, BMPSQQ, BMNGQQ, EWIDQQ, BWPSQQ, BWNGQQ
      REAL BPOSQQ, BSIZQQ
      REAL ECM, P4CMQQ, P4PHQQ, ENERNW, BEAMNW, BEAMP, BEAMN
      REAL PSAV, P4QQ, HELCQQ
      CHARACTER DATEQQ*20, TIMEQQ*20, FOUTQQ*80, FCTLQQ*80, FDECQQ*80
      CHARACTER FGEOQQ*80
      CHARACTER CCTLQQ*80, CDECQQ*80
C
      COMMON/MCCM1A/
     *   NCTLQQ, NDECQQ, IVRSQQ, IORGQQ, IRS1QQ(3), BFLDQQ,
     *   ENERQQ, BEAMQQ, BMPSQQ, BMNGQQ, EWIDQQ, BWPSQQ, BWNGQQ,
     *   BPOSQQ(3), BSIZQQ(3),
     *   IEVTQQ, IRUNQQ,
     *   IBMRAD, ECM, P4CMQQ(4), P4PHQQ(4),
     *   ENERNW, BEAMNW, BEAMP, BEAMN,
     *   NTRKMC, QQNTRK, NSTBMC, NSTBQQ, NCHGMC, NCHGQQ,
     *   IRANQQ(2), IRANMC(2), IRANCC(2), IRS2QQ(5),
     *   IPFTQQ(MCTRK), IPCDQQ(MCTRK), IPRNTV(MCTRK), ITYPEV(MCTRK,2),
     *   IDECSV(MCTRK), IDAUTV(MCTRK), ISTBMC(MCTRK), NDAUTV(MCTRK),
     *   IVPROD(MCTRK), IVDECA(MCTRK),
     *   PSAV(MCTRK,4), HELCQQ(MCTRK), P4QQ(4,MCTRK)
C
      COMMON/MCCM1B/
     *   DATEQQ, TIMEQQ, FOUTQQ, FCTLQQ, FDECQQ, FGEOQQ,
     *   CCTLQQ(MCTLQQ), CDECQQ(MDECQQ)
      INTEGER IDSTBL
      COMMON/MCCM1C/
     *   IDSTBL(MCSTAB)
C
      INTEGER IFINAL(MCTRK), IFINSV(MCSTAB), NFINAL
      EQUIVALENCE (IFINAL,ISTBMC), (IFINSV,IDSTBL), (NFINAL,NSTBMC)
C
      INTEGER NVRTX, ITRKIN, NTRKOU, ITRKOU, IVKODE
      REAL XVTX, TVTX, RVTX
      COMMON/MCCM2/
     *   NVRTX, XVTX(MCVRTX,3), TVTX(MCVRTX), RVTX(MCVRTX),
     *   ITRKIN(MCVRTX), NTRKOU(MCVRTX), ITRKOU(MCVRTX),
     *   IVKODE(MCVRTX)
C***                 MCGEN.INC
      INTEGER QQIST,QQIFR,QQN,QQK,QQMESO,QQNC,QQKC,QQLASTN
      REAL QQPUD,QQPS1,QQSIGM,QQMAS,QQPAR,QQCMIX,QQCND,QQBSPI,QQBSYM,QQP
      REAL QQPC,QQCZF
C
      COMMON/DATA1/QQIST,QQIFR,QQPUD,QQPS1,QQSIGM,QQMAS(15),QQPAR(25)
      COMMON/DATA2/QQCZF(15),QQMESO(36),QQCMIX(6,2)
      COMMON/DATA3/QQCND(3)
      COMMON/DATA5/QQBSPI(5),QQBSYM(3)
      COMMON/JET/QQN,QQK(250,2),QQP(250,5),QQNC,QQKC(10),QQPC(10,4),
     *  QQLASTN
C---
      IF(FSTEVT) THEN
C---INITIALIZE QQ-CLEO
        CALL QQINIT(QQLERR)
        IF(QQLERR) CALL HWWARN('HWDEUR',500,*999)
      ENDIF
C---CONSTRUCT THE HADRON FOR QQ-CLEO
C NOTE: THE IDPDG CODE IS PROVIDED THROUGH THE QQLMAT ROUTINE
C       FROM THE CLEO PACKAGE (QQ-CLEO <--> IDPDG CODE TRANSFORMATION)
      QQN=1
      IDHEP(IHEP)=IDPDG(IDHW(IHEP))
      QQK(1,1)=0
      QQK(1,2)=QQLMAT(IDHEP(IHEP),1)
      QQP(1,1)=PHEP(1,IHEP)
      QQP(1,2)=PHEP(2,IHEP)
      QQP(1,3)=PHEP(3,IHEP)
      QQP(1,5)=AMASS(QQK(1,2))
      QQP(1,4)=SQRT(QQP(1,5)**2+QQP(1,1)**2+QQP(1,2)**2+QQP(1,3)**2)
C---LET QQ-CLEO DO THE JOB
      QQNTRK=0
      NVRTX=0
      CALL DECADD(.FALSE.)
C---UPDATE THE HERWIG TABLE : LOOP OVER QQN-CLEO FINAL PARTICLES
      DO 40 IIHEP=1,QQN
      NHEP=NHEP+1
      ISTHEP(NHEP)=198
      IF(ITYPEV(IIHEP,2).GE.0) ISTHEP(NHEP)=1
      IDHEP(NHEP)=QQLMAT(ITYPEV(IIHEP,1),2)
      CALL HWUIDT(1,IDHEP(NHEP),IDHW(NHEP),NAME)
      IF(IIHEP.EQ.1) THEN
        ISTHEP(IHEP)=199
        JDAHEP(1,IHEP)=NHEP
        JDAHEP(2,IHEP)=NHEP
        ISTHEP(NHEP)=199
        NHEPHF=NHEP
        JMOHEP(1,NHEP)=IHEP
        JMOHEP(2,NHEP)=IHEP
      ELSE
        JMOHEP(1,NHEP)=IPRNTV(IIHEP)+NHEPHF-1
        JMOHEP(2,NHEP)=NHEPHF
      ENDIF
      JDAHEP(1,NHEP)=0
      JDAHEP(2,NHEP)=0
      IF(NDAUTV(IIHEP).GT.0) THEN
        JDAHEP(1,NHEP)=IDAUTV(IIHEP)+NHEPHF-1
        JDAHEP(2,NHEP)=JDAHEP(1,NHEP)+NDAUTV(IIHEP)-1
      ENDIF
      PHEP(1,NHEP)=QQP(IIHEP,1)
      PHEP(2,NHEP)=QQP(IIHEP,2)
      PHEP(3,NHEP)=QQP(IIHEP,3)
      PHEP(4,NHEP)=QQP(IIHEP,4)
      PHEP(5,NHEP)=QQP(IIHEP,5)
      VHEP(1,NHEP)=XVTX(IVPROD(IIHEP),1)
      VHEP(2,NHEP)=XVTX(IVPROD(IIHEP),2)
      VHEP(3,NHEP)=XVTX(IVPROD(IIHEP),3)
      VHEP(4,NHEP)=0.
   40 CONTINUE
  999 END
CDECK  ID>, HWDEUR.
*CMZ :-        -28/01/92  12.34.44  by  Mike Seymour
*-- Author :    Luca Stanco
C-----------------------------------------------------------------------
      SUBROUTINE HWDEUR(IHEP)
C-----------------------------------------------------------------------
C INTERFACE TO EURODEC PACKAGE (LS 10/29/91)
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      INTEGER IHEP,IIHEP,NHEPHF,IEUPDG,IPDGEU
      CHARACTER*8 NAME
C---EURODEC COMMON'S : INITIAL INPUT
      INTEGER EULUN0,EULUN1,EULUN2,EURUN,EUEVNT
      CHARACTER*4 EUDATD,EUTIT
      REAL AMINIE(12),EUWEI
      COMMON/INPOUT/EULUN0,EULUN1,EULUN2
      COMMON/FILNAM/EUDATD,EUTIT
      COMMON/HVYINI/AMINIE
      COMMON/RUNINF/EURUN,EUEVNT,EUWEI
C---EURODEC WORKING COMMON'S
      INTEGER NPMAX,NTMAX
      PARAMETER (NPMAX=18,NTMAX=2000)
      INTEGER EUNP,EUIP(NPMAX),EUPHEL(NPMAX),EUTEIL,EUINDX(NTMAX),
     &    EUORIG(NTMAX),EUDCAY(NTMAX),EUTHEL(NTMAX)
      REAL EUAPM(NPMAX),EUPCM(5,NPMAX),EUPVTX(3,NPMAX),EUPTEI(5,NTMAX),
     &    EUSECV(3,NTMAX)
      COMMON/MOMGEN/EUNP,EUIP,EUAPM,EUPCM,EUPHEL,EUPVTX
      COMMON/RESULT/EUTEIL,EUPTEI,EUINDX,EUORIG,EUDCAY,EUTHEL,EUSECV
C---EURODEC COMMON'S FOR DECAY PROPERTIES
      INTEGER NGMAX,NCMAX
      PARAMETER (NGMAX=400,NCMAX=9000)
      INTEGER EUNPA,EUIPC(NGMAX),EUIPDG(NGMAX),EUIDP(NGMAX),
     &     EUCONV(NCMAX)
      REAL EUPM(NGMAX),EUPLT(NGMAX)
      COMMON/PCTABL/EUNPA,EUIPC,EUIPDG,EUPM,EUPLT,EUIDP
      COMMON/CONVRT/EUCONV
C---
      IF(FSTEVT) THEN
C---CHANGE HERE THE DEFAULT VALUES OF EURODEC COMMON'S
C
C---INITIALIZE EURODEC COMMON'S
CC        CALL EUDCIN
C---INITIALIZE EURODEC
        CALL EUDINI
      ENDIF
C---CONSTRUCT THE HADRON FOR EURODEC FROM ID1,ID2
      EUNP=1
      IDHEP(IHEP)=IDPDG(IDHW(IHEP))
      EUIP(1)=IPDGEU(IDHEP(IHEP))
      EUAPM(1)=EUPM(EUCONV(IABS(EUIP(1))))
      EUPCM(1,1)=PHEP(1,IHEP)
      EUPCM(2,1)=PHEP(2,IHEP)
      EUPCM(3,1)=PHEP(3,IHEP)
      EUPCM(5,1)=SQRT(PHEP(1,IHEP)**2+PHEP(2,IHEP)**2+PHEP(3,IHEP)**2)
      EUPCM(4,1)=SQRT(EUPCM(5,1)**2+EUAPM(1)**2)
C NOT POLARIZED HADRONS
      EUPHEL(1)=0
C HADRONS START FROM PRIMARY VERTEX
      EUPVTX(1,1)=0.
      EUPVTX(2,1)=0.
      EUPVTX(3,1)=0.
C---LET EURODEC DO THE JOB
      EUTEIL=0
      CALL FRAGMT(1,1,0)
C---UPDATE THE HERWIG TABLE : LOOP OVER N-EURODEC FINAL PARTICLES
      DO 40 IIHEP=1,EUTEIL
      NHEP=NHEP+1
      ISTHEP(NHEP)=198
      IF(EUDCAY(IIHEP).EQ.0) ISTHEP(NHEP)=1
      IDHEP(NHEP)=IEUPDG(EUINDX(IIHEP))
      CALL HWUIDT(1,IDHEP(NHEP),IDHW(NHEP),NAME)
      IF(IIHEP.EQ.1) THEN
        ISTHEP(IHEP)=199
        JDAHEP(1,IHEP)=NHEP
        JDAHEP(2,IHEP)=NHEP
        ISTHEP(NHEP)=199
        NHEPHF=NHEP
        JMOHEP(1,NHEP)=IHEP
        JMOHEP(2,NHEP)=IHEP
        JDAHEP(1,NHEP)=EUDCAY(IIHEP)/10000+NHEPHF-1
        JDAHEP(2,NHEP)=MOD(EUDCAY(IIHEP),10000)+NHEPHF-1
      ELSE
        JMOHEP(1,NHEP)=MOD(EUORIG(IIHEP),10000)+NHEPHF-1
        JMOHEP(2,NHEP)=NHEPHF
        JDAHEP(1,NHEP)=EUDCAY(IIHEP)/10000+NHEPHF-1
        JDAHEP(2,NHEP)=MOD(EUDCAY(IIHEP),10000)+NHEPHF-1
      ENDIF
      PHEP(1,NHEP)=EUPTEI(1,IIHEP)
      PHEP(2,NHEP)=EUPTEI(2,IIHEP)
      PHEP(3,NHEP)=EUPTEI(3,IIHEP)
      PHEP(4,NHEP)=EUPTEI(4,IIHEP)
      PHEP(5,NHEP)=EUPTEI(5,IIHEP)
      VHEP(1,NHEP)=EUSECV(1,IIHEP)
      VHEP(2,NHEP)=EUSECV(2,IIHEP)
      VHEP(3,NHEP)=EUSECV(3,IIHEP)
      VHEP(4,NHEP)=0.
      IF (IIHEP.GT.NTMAX) CALL HWWARN('HWDEUR',99,*999)
   40 CONTINUE
  999 END
CDECK  ID>, HWDFOR.
*CMZ :-        -
*-- Author :    Ian Knowles
C-----------------------------------------------------------------------
      SUBROUTINE HWDFOR(P0,P1,P2,P3,P4)
C-----------------------------------------------------------------------
C     Generates 4-body decay 0->1+2+3+4 using pure phase space
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWRGEN,P0(5),P1(5),P2(5),P3(5),P4(5),B,C,AA,BB,
     & CC,DD,EE,TT,S1,RS1,FF,S2,PP,QQ,RR,P1CM,P234(5),P2CM,P34(5),P3CM
      DOUBLE PRECISION TWO
      PARAMETER (TWO=2.D0)
      EXTERNAL HWRGEN
      B=P0(5)-P1(5)
      C=P2(5)+P3(5)+P4(5)
      IF (B.LT.C) CALL HWWARN('HWDFOR',100,*999)
      AA=(P0(5)+P1(5))**2
      BB=B**2
      CC=C**2
      DD=(P3(5)+P4(5))**2
      EE=(P3(5)-P4(5))**2
      TT=(B-C)*P0(5)**3
C Select squared masses S1 and S2 of 234 and 34 subsystems
  10  S1=BB+HWRGEN(1)*(CC-BB)
      RS1=SQRT(S1)
      FF=(RS1-P2(5))**2
      S2=DD+HWRGEN(2)*(FF-DD)
      PP=(AA-S1)*(BB-S1)
      QQ=((RS1+P2(5))**2-S2)*(FF-S2)/S1
      RR=(S2-DD)*(S2-EE)/S2
      IF (PP*QQ*RR.LT.TT*S1*S2*HWRGEN(3)**2) GOTO 10
C Do two body decays: 0-->1+234, 234-->2+34 and 34-->3+4
      P1CM=SQRT(PP/4)/P0(5)
      P234(5)=RS1
      P2CM=SQRT(QQ/4)
      P34(5)=SQRT(S2)
      P3CM=SQRT(RR/4)
      CALL HWDTWO(P0  ,P1,P234,P1CM,TWO,.TRUE.)
      CALL HWDTWO(P234,P2,P34 ,P2CM,TWO,.TRUE.)
      CALL HWDTWO(P34 ,P3,P4  ,P3CM,TWO,.TRUE.)
  999 END
CDECK  ID>, HWDFIV.
*CMZ :-        -
*-- Author :    Ian Knowles
C-----------------------------------------------------------------------
      SUBROUTINE HWDFIV(P0,P1,P2,P3,P4,P5)
C-----------------------------------------------------------------------
C     Generates 5-body decay 0->1+2+3+4+5 using pure phase space
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWRGEN,P0(5),P1(5),P2(5),P3(5),P4(5),P5(5),B,C,
     & AA,BB,CC,DD,EE,FF,TT,S1,RS1,GG,S2,RS2,HH,S3,PP,QQ,RR,SS,P1CM,
     & P2345(5),P2CM,P345(5),P3CM,P45(5),P4CM
      DOUBLE PRECISION TWO
      PARAMETER (TWO=2.D0)
      EXTERNAL HWRGEN
      B=P0(5)-P1(5)
      C=P2(5)+P3(5)+P4(5)+P5(5)
      IF (B.LT.C) CALL HWWARN('HWDFIV',100,*999)
      AA=(P0(5)+P1(5))**2
      BB=B**2
      CC=C**2
      DD=(P3(5)+P4(5)+P5(5))**2
      EE=(P4(5)+P5(5))**2
      FF=(P4(5)-P5(5))**2
      TT=(B-C)*P0(5)**3
C Select squared masses S1, S2 and S3 of 2345, 345 and 45 subsystems
  10  S1=BB+HWRGEN(1)*(CC-BB)
      RS1=SQRT(S1)
      GG=(RS1-P2(5))**2
      S2=DD+HWRGEN(2)*(GG-DD)
      RS2=SQRT(S2)
      HH=(RS2-P3(5))**2
      S3=EE+HWRGEN(3)*(HH-EE)
      PP=(AA-S1)*(BB-S1)
      QQ=((RS1+P2(5))**2-S2)*(GG-S2)/S1
      RR=((RS2+P3(5))**2-S3)*(HH-S3)/S2
      SS=(S3-EE)*(S3-FF)/S3
      IF (PP*QQ*RR*SS.LT.TT*S1*S2*S3*HWRGEN(4)**2) GOTO 10
C Do two body decays: 0-->1+2345, 2345-->2+345, 345-->3+45 and 45-->4+5
      P1CM=SQRT(PP/4)/P0(5)
      P2345(5)=RS1
      P2CM=SQRT(QQ/4)
      P345(5)=RS2
      P3CM=SQRT(RR/4)
      P45(5)=SQRT(S3)
      P4CM=SQRT(SS/4)
      CALL HWDTWO(P0   ,P1,P2345,P1CM,TWO,.TRUE.)
      CALL HWDTWO(P2345,P2,P345 ,P2CM,TWO,.TRUE.)
      CALL HWDTWO(P345 ,P3,P45  ,P3CM,TWO,.TRUE.)
      CALL HWDTWO(P45  ,P4,P5   ,P4CM,TWO,.TRUE.)
  999 END
CDECK  ID>, HWDHAD.
*CMZ :-        -26/04/91  14.01.26  by  Federico Carminati
*-- Author :    Ian Knowles, Bryan Webber & Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HWDHAD
C-----------------------------------------------------------------------
C     GENERATES DECAYS OF UNSTABLE HADRONS AND LEPTONS
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,HWULDO,RN,BF,COSANG,RSUM,DIST(4),VERTX(4),
     & PMIX,WTMX,WTMX2,XS,DOT1,DOT2
      INTEGER IHEP,ID,MHEP,IDM,I,IDS,IM,MO,IPDG
      LOGICAL STABLE
      EXTERNAL HWRGEN,HWDPWT,HWDWWT,HWULDO
      IF (IERROR.NE.0) RETURN
      DO 100 IHEP=1,NMXHEP
      IF (IHEP.GT.NHEP) THEN
        ISTAT=90
        RETURN
      ELSEIF (ISTHEP(IHEP).EQ.120 .AND.
     &  JDAHEP(1,IHEP).EQ.IHEP.AND.JDAHEP(2,IHEP).EQ.IHEP) THEN
C---COPY COLOUR SINGLET CMF
        NHEP=NHEP+1
        IF (NHEP.GT.NMXHEP) CALL HWWARN('HWDHAD',100,*999)
        CALL HWVEQU(5,PHEP(1,IHEP),PHEP(1,NHEP))
        CALL HWVEQU(4,VHEP(1,IHEP),VHEP(1,NHEP))
        IDHW(NHEP)=IDHW(IHEP)
        IDHEP(NHEP)=IDHEP(IHEP)
        ISTHEP(NHEP)=190
        JMOHEP(1,NHEP)=IHEP
        JMOHEP(2,NHEP)=NHEP
        JDAHEP(2,NHEP)=NHEP
        JDAHEP(1,IHEP)=NHEP
        JDAHEP(2,IHEP)=NHEP
      ELSEIF (ISTHEP(IHEP).GE.190.AND.ISTHEP(IHEP).LE.193) THEN
C---FIRST CHECK FOR STABILITY
        ID=IDHW(IHEP)
        IF (RSTAB(ID)) THEN
          ISTHEP(IHEP)=1
          JDAHEP(1,IHEP)=0
          JDAHEP(2,IHEP)=0
C---SPECIAL FOR GAUGE BOSON DECAY
          IF (ID.GE.198.AND.ID.LE.200) CALL HWDBOS(IHEP)
C---SPECIAL FOR HIGGS BOSON DECAY
          IF (ID.EQ.201) CALL HWDHIG(ZERO)
        ELSE
C---UNSTABLE.
C Calculate position of decay vertex
          IF (DKLTM(ID).EQ.0.) THEN
            CALL HWVEQU(4,VHEP(1,IHEP),VERTX)
            MHEP=IHEP
            IDM=ID
          ELSE
            CALL HWUDKL(ID,PHEP(1,IHEP),DIST)
            CALL HWVSUM(4,VHEP(1,IHEP),DIST,VERTX)
            IF (MAXDKL) THEN
              CALL HWDXLM(VERTX,STABLE)
              IF (STABLE) THEN
                ISTHEP(IHEP)=1
                JDAHEP(1,IHEP)=0
                JDAHEP(2,IHEP)=0
                GOTO 100
              ENDIF
            ENDIF
            IF (MIXING.AND.(ID.EQ.221.OR.ID.EQ.223.OR.
     &                      ID.EQ.245.OR.ID.EQ.247)) THEN
C Select flavour of decaying b-meson allowing for flavour oscillation
              IDS=MOD(ID,3)
              PMIX=HALF*(ONE+SIN(XMRCT(IDS)*VERTX(4)/PHEP(4,IHEP))/
     &                      COSH(YMRCT(IDS)*VERTX(4)/PHEP(4,IHEP)))
              IF (HWRGEN(1).LE.PMIX) THEN
                IF (ID.LE.223) THEN
                  IDM=ID+24
                ELSE
                  IDM=ID-24
                ENDIF
              ELSE
                IDM=ID
              ENDIF
C Introduce a decaying neutral b-meson
              IF (NHEP+1.GT.NMXHEP) CALL HWWARN('HWDHAD',101,*999)
              MHEP=NHEP+1
              ISTHEP(MHEP)=ISTHEP(IHEP)
              ISTHEP(IHEP)=200
              JDAHEP(1,IHEP)=MHEP
              JDAHEP(2,IHEP)=MHEP
              IDHW(MHEP)=IDM
              IDHEP(MHEP)=IDPDG(IDM)
              JMOHEP(1,MHEP)=IHEP
              JMOHEP(2,MHEP)=JMOHEP(2,IHEP)
              CALL HWVEQU(5,PHEP(1,IHEP),PHEP(1,MHEP))
              CALL HWVEQU(4,VERTX,VHEP(1,MHEP))
              NHEP=NHEP+1
            ELSE
              MHEP=IHEP
              IDM=ID
            ENDIF
          ENDIF
C Use CLEO/EURODEC packages for b-hadrons if requested
          IF ((IDM.GE.221.AND.IDM.LE.231).OR.
     &        (IDM.GE.245.AND.IDM.LE.254)) THEN
            IF (BDECAY.EQ.'CLEO') THEN
              CALL HWDCLE(MHEP)
              GOTO 100
            ELSEIF (BDECAY.EQ.'EURO') THEN
              CALL HWDEUR(MHEP)
              GOTO 100
            ENDIF
          ENDIF
C Choose decay mode
          ISTHEP(MHEP)=ISTHEP(MHEP)+5
          RN=HWRGEN(2)
          BF=0.
          IM=LSTRT(IDM)
          DO 10 I=1,NMODES(IDM)
          BF=BF+BRFRAC(IM)
          IF (BF.GE.RN) GOTO 20
  10      IM=LNEXT(IM)
          CALL HWWARN('HWDHAD',50,*20)
  20      IF ((IDKPRD(1,IM).GE.1.AND.IDKPRD(1,IM).LE.13).OR.
     &        (IDKPRD(3,IM).GE.1.AND.IDKPRD(3,IM).LE.13)) THEN
C Partonic decay of a heavy-(b,c)-hadron, store details
            NQDK=NQDK+1
            IF (NQDK.GT.NMXQDK) CALL HWWARN('HWDHAD',102,*999)
            LOCQ(NQDK)=MHEP
            IMQDK(NQDK)=IM
            CALL HWVEQU(4,VERTX,VTXQDK(1,NQDK))
            GOTO 100
          ELSE
C Exclusive decay, add decay products to event record
            IF (NHEP+NPRODS(IM).GT.NMXHEP)
     &        CALL HWWARN('HWDHAD',103,*999)
            JDAHEP(1,MHEP)=NHEP+1
            DO 30 I=1,NPRODS(IM)
            NHEP=NHEP+1
            IDHW(NHEP)=IDKPRD(I,IM)
            IDHEP(NHEP)=IDPDG(IDKPRD(I,IM))
            ISTHEP(NHEP)=193
            JMOHEP(1,NHEP)=MHEP
            JMOHEP(2,NHEP)=JMOHEP(2,MHEP)
            PHEP(5,NHEP)=RMASS(IDKPRD(I,IM))
  30        CALL HWVEQU(4,VERTX,VHEP(1,NHEP))
            JDAHEP(2,MHEP)=NHEP
          ENDIF
C Next choose momenta:
          IF (NPRODS(IM).EQ.1) THEN
C 1-body decay: K0(BR) --> K0S,K0L
            CALL HWVEQU(4,PHEP(1,MHEP),PHEP(1,NHEP))
          ELSEIF (NPRODS(IM).EQ.2) THEN
C 2-body decay
C---SPECIAL TREATMENT OF POLARIZED MESONS
            COSANG=TWO
            IF (ID.EQ.IDHW(JMOHEP(1,MHEP))) THEN
              MO=JMOHEP(1,MHEP)
              RSUM=0
              DO 40 I=1,3
  40          RSUM=RSUM+RHOHEP(I,MO)
              IF (RSUM.GT.0) THEN
                RSUM=RSUM*HWRGEN(3)
                IF (RSUM.LT.RHOHEP(1,MO)) THEN
C---(1+COSANG)**2
                  COSANG=MAX(HWRGEN(4),HWRGEN(5),HWRGEN(6))*TWO-ONE
                ELSEIF (RSUM.LT.RHOHEP(1,MO)+RHOHEP(2,MO)) THEN
C---1-COSANG**2
                  COSANG=2*COS((ACOS(HWRGEN(7)*TWO-ONE)+PIFAC)/THREE)
                ELSE
C---(1-COSANG)**2
                  COSANG=MIN(HWRGEN(8),HWRGEN(9),HWRGEN(10))*TWO-ONE
                ENDIF
              ENDIF
            ENDIF
            CALL HWDTWO(PHEP(1,MHEP),PHEP(1,NHEP-1),
     &                  PHEP(1,NHEP),CMMOM(IM),COSANG,.FALSE.)
          ELSEIF (NPRODS(IM).EQ.3) THEN
C 3-body decay
            IF (NME(IM).EQ.100) THEN
C  Use free massless (V-A)*(V-A) Matrix Element
              CALL HWDTHR(PHEP(1,MHEP),PHEP(1,NHEP-1),PHEP(1,NHEP-2),
     &                    PHEP(1,NHEP),HWDWWT)
            ELSEIF (NME(IM).EQ.101) THEN
C  Use bound massless (V-A)*(V-A) Matrix Element
              WTMX=((PHEP(5,MHEP)-PHEP(5,NHEP))
     &             *(PHEP(5,MHEP)+PHEP(5,NHEP))
     &             +(PHEP(5,NHEP-1)-PHEP(5,NHEP-2))
     &             *(PHEP(5,NHEP-1)+PHEP(5,NHEP-2)))/TWO
              WTMX2=WTMX**2
              IPDG=ABS(IDHEP(MHEP))
              XS=ONE-MAX(RMASS(MOD(IPDG/1000,10)),
     &                   RMASS(MOD(IPDG/100,10)),RMASS(MOD(IPDG/10,10)))
     &              /(RMASS(MOD(IPDG/1000,10))+RMASS(MOD(IPDG/100,10))
     &               +RMASS(MOD(IPDG/10,10)))
  50          CALL HWDTHR(PHEP(1,MHEP),PHEP(1,NHEP-1),PHEP(1,NHEP-2),
     &                    PHEP(1,NHEP),HWDWWT)
              DOT1=HWULDO(PHEP(1,MHEP),PHEP(1,NHEP-1))
              DOT2=HWULDO(PHEP(1,MHEP),PHEP(1,NHEP-2))
              IF (DOT1*(WTMX-DOT1-XS*DOT2).LT.HWRGEN(11)*WTMX2) GOTO 50
            ELSE
              CALL HWDTHR(PHEP(1,MHEP),PHEP(1,NHEP-2),PHEP(1,NHEP-1),
     &                    PHEP(1,NHEP),HWDPWT)
            ENDIF
          ELSEIF (NPRODS(IM).EQ.4) THEN
C 4-body decay
            CALL HWDFOR(PHEP(1,MHEP  ),PHEP(1,NHEP-3),PHEP(1,NHEP-2),
     &                  PHEP(1,NHEP-1),PHEP(1,NHEP))
          ELSEIF (NPRODS(IM).EQ.5) THEN
C 5-body decay
            CALL HWDFIV(PHEP(1,MHEP  ),PHEP(1,NHEP-4),PHEP(1,NHEP-3),
     &                  PHEP(1,NHEP-2),PHEP(1,NHEP-1),PHEP(1,NHEP))
          ELSE
            CALL HWWARN('HWDHAD',104,*999)
          ENDIF
        ENDIF
      ENDIF
  100 CONTINUE
C---MAY HAVE OVERFLOWED /HEPEVT/
      CALL HWWARN('HWDHAD',105,*999)
  999 END
CDECK  ID>, HWDHGC.
*CMZ :-        -26/04/91  11.11.55  by  Bryan Webber
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HWDHGC(TAU,FNREAL,FNIMAG)
C-----------------------------------------------------------------------
C  CALCULATE THE COMPLEX FUNCTION F OF HHG eq 2.18
C  FOR USE IN H-->GAMMGAMM DECAYS
C-----------------------------------------------------------------------
      DOUBLE PRECISION TAU,FNREAL,FNIMAG,FNLOG,FNSQR,PIFAC
      PARAMETER (PIFAC=3.141519D0)
      IF (TAU.GT.1) THEN
        FNREAL=(ASIN(1/SQRT(TAU)))**2
        FNIMAG=0
      ELSEIF (TAU.LT.1) THEN
        FNSQR=SQRT(1-TAU)
        FNLOG=LOG((1+FNSQR)/(1-FNSQR))
        FNREAL=-0.25 * (FNLOG**2 - PIFAC**2)
        FNIMAG= 0.5  * PIFAC*FNLOG
      ELSE
        FNREAL=0.25*PIFAC**2
        FNIMAG=0
      ENDIF
      END
CDECK  ID>, HWDHGF.
*CMZ :-        -02/05/91  11.11.45  by  Federico Carminati
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      FUNCTION HWDHGF(X,Y)
C-----------------------------------------------------------------------
C  CALCULATE THE DOUBLE BREIT-WIGNER INTEGRAL
C  X=(EMV/EMH)**2 , Y=EMV*GAMV/EMH**2
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWDHGF,X,Y,CHANGE,X1,X2,FAC1,FAC2,TH1,TH2,TH1HI,
     & TH1LO,TH2HI,TH2LO,X2MAX,SQFAC,PIFAC
      INTEGER NBIN,IBIN1,IBIN2
      PARAMETER (PIFAC=3.1415926535D0)
C  CHANGE IS THE POINT WHERE DIRECT INTEGRATION BEGINS TO CONVERGE
C  FASTER THAN STANDARD BREIT-WIGNER SUBSTITUTION
      DATA CHANGE,NBIN/0.425,25/
      HWDHGF=0
      IF (Y.LT.0) RETURN
      IF (X.GT.CHANGE) THEN
C---DIRECT INTEGRATION
        FAC1=0.25 / NBIN
        DO 200 IBIN1=1,NBIN
          X1=(IBIN1-0.5) * FAC1
          FAC2=( (1-SQRT(X1))**2-X1 ) / NBIN
          DO 100 IBIN2=1,NBIN
            X2=(IBIN2-0.5) * FAC2 + X1
            SQFAC=1+X1**2+X2**2-2*(X1+X2+X1*X2)
            IF (SQFAC.LT.0) GOTO 100
            HWDHGF=HWDHGF + 2.
     &        * ((1-X1-X2)**2+8*X1*X2)
     &        * SQRT(SQFAC)
     &        / ((X1-X)**2+Y**2) *Y
     &        / ((X2-X)**2+Y**2) *Y
     &        * FAC1*FAC2
 100      CONTINUE
 200    CONTINUE
      ELSE
C---INTEGRATION USING TAN THETA SUBSTITUTIONS
        TH1LO=ATAN((0-X)/Y)
        TH1HI=ATAN((1-X)/Y)
        FAC1=(TH1HI-TH1LO) / NBIN
        DO 400 IBIN1=1,NBIN
          TH1=(IBIN1-0.5) * FAC1 + TH1LO
          X1=Y*TAN(TH1) + X
          X2MAX=MIN(X1,(1-SQRT(X1))**2)
          TH2LO=ATAN((0-X)/Y)
          TH2HI=ATAN((X2MAX-X)/Y)
          FAC2=(TH2HI-TH2LO) / NBIN
          DO 300 IBIN2=1,NBIN
            TH2=(IBIN2-0.5) * FAC2 + TH2LO
            X2=Y*TAN(TH2) + X
            SQFAC=1+X1**2+X2**2-2*(X1+X2+X1*X2)
            IF (SQFAC.LT.0) GOTO 300
            HWDHGF=HWDHGF + 2.
     &        * ((1-X1-X2)**2+8*X1*X2)
     &        * SQRT(SQFAC)
     &        * FAC1 * FAC2
 300      CONTINUE
 400    CONTINUE
      ENDIF
      HWDHGF=HWDHGF/(PIFAC*PIFAC)
      END
CDECK  ID>, HWDHIG.
*CMZ :-        -24/04/92  14.23.44  by  Mike Seymour
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HWDHIG(GAMINP)
C-----------------------------------------------------------------------
C     HIGGS DECAY ROUTINE
C     A) FOR GAMinp=0 FIND AND DECAY HIGGS
C     B) FOR GAMinp>0 CALCULATE TOTAL HIGGS WIDTH
C                     FOR EMH=GAMINP. STORE RESULT IN GAMINP.
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWDHGF,HWRGEN,HWRUNI,HWUSQR,HWUPCM,GAMINP,EMH,
     & EMF,COLFAC,ENF,K1,K0,BET0,BET1,GAM0,GAM1,SCLOG,CFAC,XF,EM,GAMLIM,
     & GAM,XW,EMW,XZ,EMZ,YW,YZ,EMI,TAUT,TAUW,WIDHIG,VECDEC,EMB,GAMB,
     & TMIN,TMAX1,EM1,TMAX2,EM2,X1,X2,PROB,PCM,SUMR,SUMI,TAUTR,TAUTI,
     & TAUWR,TAUWI,GFACTR
      INTEGER HWRINT,IHIG,I,IFERM,NLOOK,I1,I2,IPART,IMODE,IDEC,MMAX
      LOGICAL HWRLOG
      EXTERNAL HWDHGF,HWRGEN,HWRUNI,HWUSQR,HWUPCM,HWRINT,HWRLOG
      SAVE GAM,EM,VECDEC
      PARAMETER (NLOOK=100)
      DIMENSION VECDEC(2,0:NLOOK)
      EQUIVALENCE (EMW,RMASS(198)),(EMZ,RMASS(200))
      DATA GAMLIM,GAM,EM/10D0,2*0D0/
C---IF DECAY, FIND HIGGS (HWDHAD WILL HAVE GIVEN IT STATUS=1)
      IF (GAMINP.EQ.0) THEN
        IHIG=0
        DO 10 I=1,NHEP
 10       IF (IHIG.EQ.0.AND.IDHW(I).EQ.201.AND.ISTHEP(I).EQ.1) IHIG=I
        IF (IHIG.EQ.0) CALL HWWARN('HWDHIG',101,*999)
        EMH=PHEP(5,IHIG)
        IF (EMH.LE.0) CALL HWWARN('HWDHIG',102,*999)
        EMSCA=EMH
      ELSE
        EMH=GAMINP
        IF (EMH.LE.0) THEN
          GAMINP=0
          RETURN
        ENDIF
      ENDIF
C---CALCULATE BRANCHING FRACTIONS
C---FERMIONS
C---NLL CORRECTION TO QUARK DECAY RATE (HHG eq 2.6-9)
      ENF=0
      DO 1 I=1,6
 1      IF (2*RMASS(I).LT.EMH) ENF=ENF+1
      K1=5/PIFAC**2
      K0=3/(4*PIFAC**2)
      BET0=(11*CAFAC-2*ENF)/3
      BET1=(34*CAFAC**2-(10*CAFAC+6*CFFAC)*ENF)/3
      GAM0=-8
      GAM1=-404./3+40*ENF/9
      SCLOG=LOG(EMH**2/QCDLAM**2)
      CFAC=1 + ( K1/K0 - 2*GAM0 + GAM0*BET1/BET0**2*LOG(SCLOG)
     &       +   (GAM0*BET1-GAM1*BET0)/BET0**2) / (BET0*SCLOG)
      DO 100 IFERM=1,9
        IF (IFERM.LE.6) THEN
          EMF=RMASS(IFERM)
          XF=(EMF/EMH)**2
          COLFAC=FLOAT(NCOLO)
          IF (EMF.GT.QCDLAM)
     &      EMF=EMF*(LOG(EMH/QCDLAM)/LOG(EMF/QCDLAM))**(GAM0/(2*BET0))
        ELSE
          EMF=RMASS(107+IFERM*2)
          XF=(EMF/EMH)**2
          COLFAC=1
          CFAC=1
        ENDIF
        IF (XF.LT.0.25) THEN
        GFACTR=ALPHEM/(8.*SWEIN*EMW**2)
          BRHIG(IFERM)=COLFAC*GFACTR*EMH*EMF**2 * (1-4*XF)**1.5 * CFAC
        ELSE
          BRHIG(IFERM)=0
        ENDIF
 100  CONTINUE
C---W*W*/Z*Z*
      IF (ABS(EM-EMH).GE.GAMLIM*GAM) THEN
C---OFF EDGE OF LOOK-UP TABLE
        XW=(EMW/EMH)**2
        XZ=(EMZ/EMH)**2
        YW=EMW*GAMW/EMH**2
        YZ=EMZ*GAMZ/EMH**2
        BRHIG(10)=.50*GFACTR * EMH**3 * HWDHGF(XW,YW)
        BRHIG(11)=.25*GFACTR * EMH**3 * HWDHGF(XZ,YZ)
      ELSE
C---LOOK IT UP
        EMI=((EMH-EM)/(GAM*GAMLIM)+1)*NLOOK/2.0
        I1=INT(EMI)
        I2=INT(EMI+1)
        BRHIG(10)=.50*GFACTR * EMH**3 * ( VECDEC(1,I1)*(I2-EMI) +
     &                                    VECDEC(1,I2)*(EMI-I1) )
        BRHIG(11)=.25*GFACTR * EMH**3 * ( VECDEC(2,I1)*(I2-EMI) +
     &                                    VECDEC(2,I2)*(EMI-I1) )
      ENDIF
C---GAMMAGAMMA
      TAUT=(2*RMASS(6)/EMH)**2
      TAUW=(2*EMW/EMH)**2
      CALL HWDHGC(TAUT,TAUTR,TAUTI)
      CALL HWDHGC(TAUW,TAUWR,TAUWI)
      SUMR=4./3*(  - 2*TAUT*( 1 + (1-TAUT)*TAUTR ) ) * ENHANC(6)
     &         +(2 + 3*TAUW*( 1 + (2-TAUW)*TAUWR ) ) * ENHANC(10)
      SUMI=4./3*(  - 2*TAUT*(     (1-TAUT)*TAUTI ) ) * ENHANC(6)
     &         +(    3*TAUW*(     (2-TAUW)*TAUWI ) ) * ENHANC(10)
      BRHIG(12)=GFACTR*.03125*(ALPHEM/PIFAC)**2
     &         *EMH**3 * (SUMR**2 + SUMI**2)
      WIDHIG=0
      DO 200 IPART=1, 12
        IF (IPART.LT.12) BRHIG(IPART)=BRHIG(IPART)*ENHANC(IPART)**2
 200    WIDHIG=WIDHIG+BRHIG(IPART)
      IF (WIDHIG.EQ.0) CALL HWWARN('HWDHIG',103,*999)
      DO 300 IPART=1, 12
 300    BRHIG(IPART)=BRHIG(IPART)/WIDHIG
      IF (EM.NE.RMASS(201)) THEN
C---SET UP W*W*/Z*Z* LOOKUP TABLES
        EM=EMH
        GAM=WIDHIG
        GAMLIM=MAX(GAMLIM,GAMMAX)
        DO 400 I=0,NLOOK
          EMH=(I*2.0/NLOOK-1)*GAM*GAMLIM+EM
          XW=(EMW/EMH)**2
          XZ=(EMZ/EMH)**2
          YW=EMW*GAMW/EMH**2
          YZ=EMZ*GAMZ/EMH**2
          VECDEC(1,I)=HWDHGF(XW,YW)
          VECDEC(2,I)=HWDHGF(XZ,YZ)
 400    CONTINUE
        EMH=EM
      ENDIF
      IF (GAMINP.GT.0) THEN
        GAMINP=WIDHIG
        RETURN
      ENDIF
C---SEE IF USER SPECIFIED A DECAY MODE
      IMODE=MOD(IPROC,100)
C---IF NOT, CHOOSE ONE
      IF (IMODE.LT.1.OR.IMODE.GT.12) THEN
        MMAX=12
        IF (IMODE.LT.1) MMAX=6
 500    IMODE=HWRINT(1,MMAX)
        IF (BRHIG(IMODE).LT.HWRGEN(0)) GOTO 500
      ENDIF
C---SEE IF SPECIFIED DECAY IS POSSIBLE
      IF (BRHIG(IMODE).EQ.0) CALL HWWARN('HWDHIG',104,*999)
      IF (IMODE.LE.6) THEN
        IDEC=IMODE
      ELSEIF (IMODE.LE.9) THEN
        IDEC=107+IMODE*2
      ELSEIF (IMODE.EQ.10) THEN
        IDEC=198
      ELSEIF (IMODE.EQ.11) THEN
        IDEC=200
      ELSEIF (IMODE.EQ.12) THEN
        IDEC=59
      ENDIF
C---STATUS, IDs AND POINTERS
      ISTHEP(IHIG)=195
      DO 600 I=1,2
        ISTHEP(NHEP+I)=193
        IDHW(NHEP+I)=IDEC
        IDHEP(NHEP+I)=IDPDG(IDEC)
        JDAHEP(I,IHIG)=NHEP+I
        JMOHEP(1,NHEP+I)=IHIG
        JMOHEP(2,NHEP+I)=NHEP+(3-I)
        JDAHEP(2,NHEP+I)=NHEP+(3-I)
        PHEP(5,NHEP+I)=RMASS(IDEC)
        IDEC=IDEC+6
        IF (IDEC.EQ.204) IDEC=199
        IF (IDEC.EQ.206) IDEC=200
        IF (IDEC.EQ. 65) IDEC= 59
 600  CONTINUE
C---ALLOW W/Z TO BE OFF-SHELL
      IF (IMODE.EQ.10.OR.IMODE.EQ.11) THEN
        IF (IMODE.EQ.10) THEN
          EMB=EMW
          GAMB=GAMW
        ELSE
          EMB=EMZ
          GAMB=GAMZ
        ENDIF
C---STANDARD MASS DISTRIBUTION
 700    TMIN=ATAN(-EMB/GAMB)
        TMAX1=ATAN((EMH**2/EMB-EMB)/GAMB)
        EM1=HWUSQR(EMB*(GAMB*TAN(HWRUNI(0,TMIN,TMAX1))+EMB))
        TMAX2=ATAN(((EMH-EM1)**2/EMB-EMB)/GAMB)
        EM2=HWUSQR(EMB*(GAMB*TAN(HWRUNI(0,TMIN,TMAX2))+EMB))
        X1=(EM1/EMH)**2
        X2=(EM2/EMH)**2
C---CORRECT MASS DISTRIBUTION
        PROB=HWUSQR(1+X1**2+X2**2-2*X1-2*X2-2*X1*X2)
     &        * ((X1+X2-1)**2 + 8*X1*X2)
        IF (.NOT.HWRLOG(PROB)) GOTO 700
C---CALCULATE SPIN DENSITY MATRIX
        RHOHEP(1,NHEP+1)=4*X1*X2      / (8*X1*X2 + (X1+X2-1)**2)
        RHOHEP(2,NHEP+1)=(X1+X2-1)**2 / (8*X1*X2 + (X1+X2-1)**2)
        RHOHEP(3,NHEP+1)=RHOHEP(1,NHEP+1)
C---SYMMETRIZE DISTRIBUTIONS IN PARTICLES 1,2
        IF (HWRLOG(HALF)) THEN
          PHEP(5,NHEP+1)=EM1
          PHEP(5,NHEP+2)=EM2
        ELSE
          PHEP(5,NHEP+1)=EM2
          PHEP(5,NHEP+2)=EM1
        ENDIF
      ENDIF
C---DO DECAY
      PCM=HWUPCM(EMH,PHEP(5,NHEP+1),PHEP(5,NHEP+2))
      IF (PCM.LT.0) CALL HWWARN('HWDHIG',105,*999)
      CALL HWDTWO(PHEP(1,IHIG),PHEP(1,NHEP+1),PHEP(1,NHEP+2),
     &            PCM,TWO,.TRUE.)
      NHEP=NHEP+2
C---IF QUARK DECAY, HADRONIZE
      IF (IMODE.LE.6) THEN
        ISTHEP(NHEP-1)=113
        ISTHEP(NHEP)=114
        CALL HWBGEN
        CALL HWDHQK
        CALL HWCFOR
        CALL HWCDEC
      ENDIF
  999 END
CDECK  ID>, HWDHQK. 
*CMZ :-        -09/12/92  10.51.11  by  Bryan Webber
*-- Author :    Ian Knowles & Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWDHQK
C-----------------------------------------------------------------------
C     Performs weak decays of heavy quarks: 0 -> W + 3,  W -> 1 + 2(bar)
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,HWULDO,RN,BF,EMMX,EMWSQ,GMWSQ,EMLIM,PW(4),
     & EMTST
      INTEGER IST(3),IHEP,IS,ID,IM,I,LHEP,MHEP
      LOGICAL FOUND
      EXTERNAL HWRGEN,HWDWWT,HWULDO,HWDPWT
      DATA IST/113,114,114/
      IF (IERROR.NE.0) RETURN
  10  FOUND=.FALSE.
      DO 60 IHEP=1,NMXHEP
      IS=ISTHEP(IHEP)
      ID=IDHW(IHEP)
      IF (IS.GE.147.AND.IS.LE.151.AND.(ID.EQ.6.OR.ID.EQ.12.OR.
     &    (ID.GE.209.AND.ID.LE.212).OR.(ID.GE.215.AND.ID.LE.218))) THEN
        FOUND=.TRUE.
C Select decay mode
        RN=HWRGEN(0)
        BF=0.
        IM=LSTRT(ID)
        DO 20 I=1,NMODES(ID)
        BF=BF+BRFRAC(IM)
        IF (BF.GE.RN) GOTO 30
  20    IM=LNEXT(IM)
        CALL HWWARN('HWDHQK',50,*30)
  30    IF (NHEP+4.GT.NMXHEP) CALL HWWARN('HWDHQK',100,*999)
C Make a copy of decaying heavy (anti-)quark
        NHEP=NHEP+1
        ISTHEP(NHEP)=155
        IDHW(NHEP)=IDHW(IHEP)
        IDHEP(NHEP)=IDHEP(IHEP)
        CALL HWVEQU(5,PHEP(1,IHEP),PHEP(1,NHEP))
        CALL HWVEQU(4,VHEP(1,IHEP),VHEP(1,NHEP))
        IF (IDHEP(IHEP).GT.0) THEN
C Re-set pointer of quark's colour mother
          IF (JDAHEP(2,JMOHEP(2,IHEP)).NE.IHEP)
     &      CALL HWWARN('HWDHQK',98,*999)
          JDAHEP(2,JMOHEP(2,IHEP))=NHEP
C and pointer of flavour partner
          IF (JMOHEP(2,JDAHEP(2,IHEP)).EQ.IHEP)
     &      JMOHEP(2,JDAHEP(2,IHEP))=NHEP
        ELSE
C Re-set pointer of anti-quark's colour daughter
          IF (JMOHEP(2,JDAHEP(2,IHEP)).NE.IHEP)
     &      CALL HWWARN('HWDHQK',99,*999)
          JMOHEP(2,JDAHEP(2,IHEP))=NHEP
C and pointer of anti-flavour partner
          IF (JDAHEP(2,JMOHEP(2,IHEP)).EQ.IHEP)
     &      JDAHEP(2,JMOHEP(2,IHEP))=NHEP
        ENDIF
        JMOHEP(1,NHEP)=JMOHEP(1,IHEP)
        JMOHEP(2,NHEP)=JMOHEP(2,IHEP)
        JDAHEP(1,NHEP)=NHEP+1
        JDAHEP(2,NHEP)=NHEP+3
C Relabel original track
        ISTHEP(IHEP)=3
        JMOHEP(2,IHEP)=JMOHEP(1,IHEP)
        JDAHEP(1,IHEP)=NHEP
        JDAHEP(2,IHEP)=NHEP
C Label decaying quark and weak decay product jets
        LHEP=NHEP
        MHEP=NHEP+3
        DO 40 I=1,3
        NHEP=NHEP+1
        MHEP=MHEP-1
        IDHW(NHEP)=IDKPRD(I,IM)
        IDHEP(NHEP)=IDPDG(IDKPRD(I,IM))
        ISTHEP(NHEP)=IST(I)
        JMOHEP(1,NHEP)=LHEP
        JMOHEP(2,NHEP)=MHEP
        JDAHEP(1,NHEP)=0
        JDAHEP(2,NHEP)=MHEP
  40    PHEP(5,NHEP)=RMASS(IDKPRD(I,IM))
C Assign production vertex to 3 (and W)
        CALL HWUDKL(ID,PHEP(1,IHEP),VHEP(1,NHEP))
        CALL HWVSUM(4,VHEP(1,IHEP),VHEP(1,NHEP),VHEP(1,NHEP))
        IF (NME(IM).EQ.100) THEN
C Generate decay momenta using full (V-A)*(V-A) matrix element
          EMMX=PHEP(5,IHEP)-PHEP(5,NHEP)
          EMWSQ=RMASS(198)**2
          GMWSQ=(RMASS(198)*GAMW)**2
          EMLIM=GMWSQ
          IF (EMMX.LT.RMASS(198)) EMLIM=EMLIM+(EMWSQ-EMMX**2)**2
  50      CALL HWDTHR(PHEP(1,IHEP),PHEP(1,NHEP-1),
     &                PHEP(1,NHEP-2),PHEP(1,NHEP),HWDWWT)
          CALL HWVSUM(4,PHEP(1,NHEP-2),PHEP(1,NHEP-1),PW)
          EMTST=(EMWSQ-HWULDO(PW,PW))**2
          IF ((EMTST+GMWSQ)*HWRGEN(1).GT.EMLIM) GOTO 50
        ELSE
C Use phase space
          CALL HWDTHR(PHEP(1,IHEP),PHEP(1,NHEP-2),
     &                PHEP(1,NHEP-1),PHEP(1,NHEP),HWDPWT)
          CALL HWVSUM(4,PHEP(1,NHEP-2),PHEP(1,NHEP-1),PW)
        ENDIF
C Assign production verticies to 1 and 2
        CALL HWUDKL(198,PW,VHEP(1,NHEP-2))
        CALL HWVSUM(4,VHEP(1,NHEP),VHEP(1,NHEP-2),VHEP(1,NHEP-2))
        CALL HWVEQU(4,VHEP(1,NHEP-2),VHEP(1,NHEP-1))
C Do parton showers
        EMSCA=PHEP(5,IHEP)
        CALL HWBGEN
      ENDIF
      IF (IHEP.EQ.NHEP) GOTO 70
  60  CONTINUE
  70  IF (FOUND) THEN
C Go back to check for further heavy decay products or other heavy quarks
        GOTO 10
      ENDIF
  999 END
CDECK  ID>, HWDHVY.
*CMZ :-        -26/04/91  12.19.24  by  Federico Carminati
*-- Author :    Ian Knowles & Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWDHVY
C-----------------------------------------------------------------------
C     Performs partonic decays of hadrons containing heavy quark(s):
C     either, meson/baryon spectator model weak decays;
C     or, quarkonia -> 2-gluons, q-qbar, 3-gluons, or 2-gluons + photon.
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWULDO,HWRGEN,XS,XB,EMWSQ,GMWSQ,EMLIM,PW(4),
     & EMTST,X1,X2,X3,TEST
      INTEGER IST(3),I,IHEP,IM,ID,IDQ,IQ,IS,J
      EXTERNAL HWRGEN,HWDWWT,HWDPWT,HWULDO
      DATA IST/113,114,114/
      IF (IERROR.NE.0) RETURN
      DO 100 I=1,NMXQDK
      IF (I.GT.NQDK) RETURN
      IHEP=LOCQ(I)
      IF (ISTHEP(IHEP).EQ.199) GOTO 100
      IM=IMQDK(I)
      IF (NHEP+NPRODS(IM).GT.NMXHEP) CALL HWWARN('HWDHVY',100,*999)
      IF (IDKPRD(4,IM).NE.0) THEN
C Weak decay of meson or baryon
C Idenitify decaying heavy quark and spectator
        ID=IDHW(IHEP)
        IF (ID.EQ.136.OR.ID.EQ.140.OR.ID.EQ.144.OR.
     &      ID.EQ.150.OR.ID.EQ.155.OR.ID.EQ.158.OR.ID.EQ.161.OR.
     &     (ID.EQ.254.AND.IDKPRD(4,IM).EQ.11)) THEN
C c hadron or c decay of B_c+
          IDQ=4
          IQ=NHEP+1
          IS=NHEP+2
        ELSEIF (ID.EQ.171.OR.ID.EQ.175.OR.ID.EQ.179.OR.
     &          ID.EQ.185.OR.ID.EQ.190.OR.ID.EQ.194.OR.ID.EQ.196.OR.
     &         (ID.EQ.230.AND.IDKPRD(4,IM).EQ.5)) THEN
C cbar hadron or cbar decay of B_c-
          IDQ=10
          IS=NHEP+1
          IQ=NHEP+2
        ELSEIF ((ID.GE.221.AND.ID.LE.229).OR.
     &          (ID.EQ.230.AND.IDKPRD(4,IM).EQ.10)) THEN
C b hadron or b decay of B_c-
          IDQ=5
          IQ=NHEP+1
          IS=NHEP+2
        ELSEIF ((ID.GE.245.AND.ID.LE.253).OR.
     &          (ID.EQ.254.AND.IDKPRD(4,IM).EQ.4)) THEN
C bbar hadron or bbar decay of B_c+
          IDQ=11
          IS=NHEP+1
          IQ=NHEP+2
        ELSE
C Decay not recognized
          CALL HWWARN('HWDHVY',100,*999)
        ENDIF
C Label constituents
        IF (NHEP+5.GT.NMXHEP) CALL HWWARN('HWDHVY',101,*999)
        ISTHEP(IHEP)=199
        JDAHEP(1,IHEP)=NHEP+1
        JDAHEP(2,IHEP)=NHEP+2
        IDHW(IQ)=IDQ
        IDHW(IS)=IDKPRD(4,IM)
        IDHEP(IQ)=IDPDG(IDQ)
        IDHEP(IS)=IDPDG(IDKPRD(4,IM))
        ISTHEP(IQ)=155
        ISTHEP(IS)=115
        JMOHEP(1,IQ)=IHEP
        JMOHEP(2,IQ)=IS
        JDAHEP(1,IQ)=NHEP+3
        JDAHEP(2,IQ)=NHEP+5
        JMOHEP(1,IS)=IHEP
        JMOHEP(2,IS)=NHEP+5
        JDAHEP(1,IS)=0
        JDAHEP(2,IS)=NHEP+5
        NHEP=NHEP+2
C and weak decay product jets
        DO 10 J=1,3
        NHEP=NHEP+1
        IDHW(NHEP)=IDKPRD(J,IM)
        IDHEP(NHEP)=IDPDG(IDKPRD(J,IM))
        ISTHEP(NHEP)=IST(J)
        JMOHEP(1,NHEP)=IQ
        JDAHEP(1,NHEP)=0
  10    PHEP(5,NHEP)=RMASS(IDKPRD(J,IM))
        JMOHEP(2,NHEP-2)=NHEP-1
        JDAHEP(2,NHEP-2)=NHEP-1
        JMOHEP(2,NHEP-1)=NHEP-2
        JDAHEP(2,NHEP-1)=NHEP-2
        JMOHEP(2,NHEP  )=IQ
        JDAHEP(2,NHEP  )=IQ
C Share momenta in ratio of masses, preserving specator mass
        XS=RMASS(IDHW(IS))/PHEP(5,IHEP)
        XB=ONE-XS
        CALL HWVSCA(5,XB,PHEP(1,IHEP),PHEP(1,IQ))
        CALL HWVSCA(5,XS,PHEP(1,IHEP),PHEP(1,IS))
        IF (NME(IM).EQ.100) THEN
C Generate decay momenta using full (V-A)*(V-A) matrix element
          EMWSQ=RMASS(198)**2
          GMWSQ=(RMASS(198)*GAMW)**2
          EMLIM=GMWSQ+(EMWSQ-(PHEP(5,IQ)-PHEP(5,NHEP))**2)**2
  20      CALL HWDTHR(PHEP(1,IQ  ),PHEP(1,NHEP-1),
     &                PHEP(1,NHEP-2),PHEP(1,NHEP),HWDWWT)
          CALL HWVSUM(4,PHEP(1,NHEP-2),PHEP(1,NHEP-1),PW)
          EMTST=(HWULDO(PW,PW)-EMWSQ)**2
          IF ((EMTST+GMWSQ)*HWRGEN(0).GT.EMLIM) GOTO 20
        ELSE
C Use phase space
          CALL HWDTHR(PHEP(1,IQ  ),PHEP(1,NHEP-2),
     &                PHEP(1,NHEP-1),PHEP(1,NHEP),HWDPWT)
          CALL HWVSUM(4,PHEP(1,NHEP-2),PHEP(1,NHEP-1),PW)
        ENDIF
C Set up production vertices
        CALL HWVZRO(4,VHEP(1,IQ))
        CALL HWVEQU(4,VHEP(1,IQ),VHEP(1,IS))
        CALL HWVEQU(4,VHEP(1,IQ),VHEP(1,NHEP))
        CALL HWUDKL(198,PW,VHEP(1,NHEP-2))
        CALL HWVSUM(4,VHEP(1,IQ),VHEP(1,NHEP-2),VHEP(1,NHEP-2))
        CALL HWVEQU(4,VHEP(1,NHEP-2),VHEP(1,NHEP-1))
        EMSCA=PHEP(5,IQ)
      ELSE
C Quarkonium decay
C Label products
        ISTHEP(IHEP)=199
        JDAHEP(1,IHEP)=NHEP+1
        DO 30 J=1,NPRODS(IM)
        NHEP=NHEP+1
        IDHW(NHEP)=IDKPRD(J,IM)
        IDHEP(NHEP)=IDPDG(IDKPRD(J,IM))
        ISTHEP(NHEP)=IST(J)
        JMOHEP(1,NHEP)=IHEP
        JDAHEP(1,NHEP)=0
        PHEP(5,NHEP)=RMASS(IDKPRD(J,IM))
  30    CALL HWVZRO(4,VHEP(1,NHEP))
        JDAHEP(2,IHEP)=NHEP
C Establish colour connections and select momentum configuration
        IF (NPRODS(IM).EQ.3) THEN
          IF (IDKPRD(3,IM).EQ.13) THEN
C 3-gluon decay
            JMOHEP(2,NHEP-2)=NHEP
            JMOHEP(2,NHEP-1)=NHEP-2
            JMOHEP(2,NHEP  )=NHEP-1
            JDAHEP(2,NHEP-2)=NHEP-1
            JDAHEP(2,NHEP-1)=NHEP
            JDAHEP(2,NHEP  )=NHEP-2
          ELSE
C or 2-gluon + photon decay
            JMOHEP(2,NHEP-2)=NHEP-1
            JMOHEP(2,NHEP-1)=NHEP-2
            JMOHEP(2,NHEP  )=NHEP
            JDAHEP(2,NHEP-2)=NHEP-1
            JDAHEP(2,NHEP-1)=NHEP-2
            JDAHEP(2,NHEP  )=NHEP
          ENDIF
          IF (NME(IM).EQ.130) THEN
C Use Ore & Powell orthopositronium matrix element
  40        CALL HWDTHR(PHEP(1,IHEP),PHEP(1,NHEP-2),
     &                               PHEP(1,NHEP-1),PHEP(1,NHEP),HWDPWT)
            X1=TWO*HWULDO(PHEP(1,IHEP),PHEP(1,NHEP-2))/PHEP(5,IHEP)**2
            X2=TWO*HWULDO(PHEP(1,IHEP),PHEP(1,NHEP-1))/PHEP(5,IHEP)**2
            X3=TWO-X1-X2
            TEST=((X1*(ONE-X1))**2+(X2*(ONE-X2))**2+(X3*(ONE-X3))**2)
     &          /(X1*X2*X3)**2
            IF (TEST.LT.TWO*HWRGEN(0)) GOTO 40
          ELSE
C Use phase space
            CALL HWDTHR(PHEP(1,IHEP),PHEP(1,NHEP-2),
     &                               PHEP(1,NHEP-1),PHEP(1,NHEP),HWDPWT)
          ENDIF
        ELSE
C Parapositronium 2-gluon or q-qbar decay
          JMOHEP(2,NHEP-1)=NHEP
          JMOHEP(2,NHEP  )=NHEP-1
          JDAHEP(2,NHEP-1)=NHEP
          JDAHEP(2,NHEP  )=NHEP-1
          CALL HWDTWO(PHEP(1,IHEP),PHEP(1,NHEP-1),
     &                             PHEP(1,NHEP),CMMOM(IM),TWO,.FALSE.)
        ENDIF
        EMSCA=PHEP(5,IHEP)
      ENDIF
C Process this new hard scatter
      CALL HWVSUM(4,VHEP(1,3),VTXQDK(1,I),VTXPIP)
      CALL HWBGEN
      CALL HWCFOR
      CALL HWCDEC
      CALL HWDHAD
  100 CONTINUE
  999 END
CDECK  ID>, HWDIDP.
*CMZ :-        -26/04/91  11.11.55  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      FUNCTION HWDIDP(ID0,FBR)
C-----------------------------------------------------------------------
C     CHOOSES A PARTON FROM QUARK AND LEPTON DOUBLETS (FOR HWDHVY)
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWRGEN,RN,FR,FBR(6)
      INTEGER HWDIDP,ID0,ID,N
      EXTERNAL HWRGEN
      RN=HWRGEN(0)
      FR=0.
      ID=ID0
      DO 10 N=1,6
      FR=FR+FBR(N)
C---LEPTONS HAVE ID CODES 121-132
      IF (N.EQ.4) ID=ID0+120
      IF (RN.LT.FR) GOTO 30
   10 ID=ID+2
      ID=ID-2
   30 HWDIDP=ID
      END
CDECK  ID>, HWDPWT.
*CMZ :-        -26/04/91  11.11.55  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      FUNCTION HWDPWT(EMSQ,A,B,C)
C-----------------------------------------------------------------------
C     MATRIX ELEMENT SQUARED FOR PHASE SPACE DECAY
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWDPWT,EMSQ,A,B,C
      HWDPWT=1.
      END
CDECK  ID>, HWDTHR.
*CMZ :-        -26/04/91  14.55.44  by  Federico Carminati
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWDTHR(P0,P1,P2,P3,WEIGHT)
C-----------------------------------------------------------------------
C     GENERATES THREE-BODY DECAY 0->1+2+3 DISTRIBUTED
C     ACCORDING TO PHASE SPACE * WEIGHT
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWRGEN,HWRUNI,A,B,C,D,AA,BB,CC,DD,EE,FF,PP,QQ,WW,
     & RR,PCM1,PC23,WEIGHT,P0(5),P1(5),P2(5),P3(5),P23(5),TWO
      EXTERNAL HWRGEN,HWRUNI,WEIGHT
      PARAMETER (TWO=2.D0)
      A=P0(5)+P1(5)
      B=P0(5)-P1(5)
      C=P2(5)+P3(5)
      IF (B.LT.C) CALL HWWARN('HWDTHR',100,*999)
      D=ABS(P2(5)-P3(5))
      AA=A*A
      BB=B*B
      CC=C*C
      DD=D*D
      EE=(B-C)*(A-D)
      A=0.5*(AA+BB)
      B=0.5*(CC+DD)
      C=4./(A-B)**2
C
C  CHOOSE MASS OF SUBSYSTEM 23 WITH PRESCRIBED DISTRIBUTION
C
   10 FF=HWRUNI(0,BB,CC)
      PP=(AA-FF)*(BB-FF)
      QQ=(CC-FF)*(DD-FF)
      WW=WEIGHT(FF,A,B,C)**2
      RR=EE*FF*HWRGEN(0)
      IF (PP*QQ*WW.LT.RR*RR) GOTO 10
C
C  FF IS MASS SQUARED OF SUBSYSTEM 23.
C
C  DO 2-BODY DECAYS 0->1+23, 23->2+3
C
      P23(5)=SQRT(FF)
      PCM1=SQRT(PP)*0.5/P0(5)
      PC23=SQRT(QQ)*0.5/P23(5)
      CALL HWDTWO(P0,P1,P23,PCM1,TWO,.TRUE.)
      CALL HWDTWO(P23,P2,P3,PC23,TWO,.TRUE.)
  999 END
CDECK  ID>, HWDTOP.
*CMZ :-        -09/12/92  11.03.46  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWDTOP(DECAY)
C-----------------------------------------------------------------------
C     DECIDES WHETHER TO DO TOP QUARK DECAY BEFORE HADRONIZATION
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      LOGICAL DECAY
      DECAY=RMASS(6).GT.130D0
      END
CDECK  ID>, HWDTWO.
*CMZ :-        -27/01/94  17.38.49  by  Mike Seymour
*-- Author :    Bryan Webber & Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HWDTWO(P0,P1,P2,PCM,COSTH,ZAXIS)
C-----------------------------------------------------------------------
C     GENERATES DECAY 0 -> 1+2
C
C     PCM IS CM MOMENTUM
C
C     COSTH = COS THETA IN P0 REST FRAME (>1 FOR ISOTROPIC)
C     IF ZAXIS=.TRUE., COS THETA IS MEASURED FROM THE ZAXIS
C     IF .FALSE., IT IS MEASURED FROM P0'S DIRECTION
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWRUNI,ONE,ZERO,PCM,COSTH,C,S,P0(5),P1(5),P2(5),
     & PP(5),R(9)
      LOGICAL ZAXIS
      EXTERNAL HWRUNI
      PARAMETER (ZERO=0.D0, ONE=1.D0)
C--CHOOSE C.M. ANGLES
      C=COSTH
      IF (C.GT.1.) C=HWRUNI(0,-ONE,ONE)
      S=SQRT(1.-C*C)
      CALL HWRAZM(PCM*S,PP(1),PP(2))
C--PP IS MOMENTUM OF 2 IN C.M.
      PP(3)=-PCM*C
      PP(4)=SQRT(P2(5)**2+PCM**2)
      PP(5)=P2(5)
C--ROTATE IF NECESSARY
      IF (COSTH.LE.1..AND..NOT.ZAXIS) THEN
        CALL HWUROT(P0,ONE,ZERO,R)
        CALL HWUROB(R,PP,PP)
      ENDIF
C--BOOST FROM C.M. TO LAB FRAME
      CALL HWULOB(P0,PP,P2)
      CALL HWVDIF(4,P0,P2,P1)
      END
CDECK  ID>, HWDWWT.
*CMZ :-        -26/04/91  11.11.55  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      FUNCTION HWDWWT(EMSQ,A,B,C)
C-----------------------------------------------------------------------
C     MATRIX ELEMENT SQUARED FOR V-A WEAK DECAY
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWDWWT,EMSQ,A,B,C
      HWDWWT=(A-EMSQ)*(EMSQ-B)*C
      END
CDECK  ID>, HWDXLM
*CMZ :-        -
*-- Author :    Ian Knowles
C-----------------------------------------------------------------------
      SUBROUTINE HWDXLM(DKVRTX,STAB)
C-----------------------------------------------------------------------
C     Sets STAB=.TRUE. if DKVRTX lies outside the specified region.
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION DKVRTX(4),RCYL,RSPH,ZMAX,R,S
      LOGICAL STAB
      PARAMETER (RCYL=20,RSPH=100,ZMAX=500)
      STAB=.FALSE.
      IF (IOPDKL.EQ.1) THEN
C Cylinderical geometry
         S=SQRT(DKVRTX(1)**2+DKVRTX(2)**2)
         IF (S.GE.RCYL.OR.ABS(DKVRTX(3)).GE.ZMAX) STAB=.TRUE.
      ELSEIF (IOPDKL.EQ.2) THEN
C Spherical geometry
         R=SQRT(DKVRTX(1)**2+DKVRTX(2)**2+DKVRTX(3)**2)
         IF (R.GE.RSPH) STAB=.TRUE.
      ELSE
C User supplied geometry
      ENDIF
      RETURN
  999 END
CDECK  ID>, HWEFIN.
*CMZ :-        -26/04/91  11.11.55  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWEFIN
C-----------------------------------------------------------------------
C     TERMINAL CALCULATIONS ON ELEMENTARY PROCESS
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION RNWGT,SPWGT,ERWGT
      WRITE (6,1)
    1 FORMAT(/10X,'OUTPUT ON ELEMENTARY PROCESS'/)
      IF (NWGTS.EQ.0) THEN
        WRITE (6,10)
   10   FORMAT(10X,'NO WEIGHTS GENERATED')
      ELSE
        RNWGT=1./FLOAT(NWGTS)
        AVWGT=WGTSUM*RNWGT
        SPWGT=SQRT(MAX(WSQSUM*RNWGT-AVWGT**2,ZERO))
        ERWGT=SPWGT*SQRT(RNWGT)
        IF (.NOT.NOWGT) WGTMAX=AVWGT
        IF (WGTMAX.EQ.ZERO) WGTMAX=ONE
        WRITE (6,11) NEVHEP,NWGTS,AVWGT,SPWGT,WBIGST,WGTMAX,IPROC,
     &               1000.*AVWGT,1000.*ERWGT,100.*AVWGT/WGTMAX
   11   FORMAT(1P,
     &         10X,'NUMBER OF EVENTS   = ',I11/
     &         10X,'NUMBER OF WEIGHTS  = ',I11/
     &         10X,'MEAN VALUE OF WGT  =',E12.4/
     &         10X,'RMS SPREAD IN WGT  =',E12.4/
     &         10X,'ACTUAL MAX WEIGHT  =',E12.4/
     &         10X,'ASSUMED MAX WEIGHT =',E12.4//
     &         10X,'PROCESS CODE IPROC = ',I11/
     &         10X,'CROSS SECTION (PB) =',G12.4/
     &         10X,'ERROR IN C-S  (PB) =',G12.4/
     &         10X,'EFFICIENCY PERCENT =',G12.4)
      ENDIF
      END
CDECK  ID>, HWEGAM.
*CMZ :-        -26/04/91  11.11.55  by  Bryan Webber
*-- Author :    Bryan Webber & Luca Stanco
C-----------------------------------------------------------------------
      SUBROUTINE HWEGAM(IHEP,ZMI,ZMA,WWA)
C-----------------------------------------------------------------------
C     GENERATES A PHOTON IN WEIZSACKER-WILLIAMS (WWA=.TRUE.) OR
C     ELSE EQUIVALENT PHOTON APPROX FROM INCOMING E+, E-, MU+ OR MU-
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,HWRUNI,EGMIN,ZMIN,ZMAX,ZGAM,SS,ZMI,ZMA,
     & PPL,PMI,QT2,Q2,QQMIN,QQMAX,S0,A
      INTEGER IHEP,IHADIS,HQ
      LOGICAL WWA
      EXTERNAL HWRGEN,HWRUNI
      DATA EGMIN/5.D0/
      IF (IERROR.NE.0)  RETURN
      IF (IHEP.LT.1.OR.IHEP.GT.2) CALL HWWARN('HWEGAM',500,*999)
      SS=PHEP(5,3)
      IF (IHEP.EQ.1) THEN
        IHADIS=2
      ELSE
        IHADIS=1
        IF (JDAHEP(1,IHADIS).NE.0) IHADIS=JDAHEP(1,IHADIS)
      ENDIF
C---DEFINE LIMITS FOR GAMMA MOMENTUM FRACTION
      IF (ZMI.LE.0D0 .OR. ZMA.GT.1D0) THEN
        IF (IPRO.EQ.13.OR.IPRO.EQ.14) THEN
          S0 = EMMIN**2
        ELSEIF(IPRO.EQ.15.OR.IPRO.EQ.18.OR.IPRO.EQ.22.OR.IPRO.EQ.24.OR.
     &         IPRO.EQ.50.OR.IPRO.EQ.53.OR.IPRO.EQ.55)THEN
          S0 = 4.D0*PTMIN**2
        ELSEIF (IPRO.EQ.17.OR.IPRO.EQ.51) THEN
          HQ = MOD(IPROC,100)
          S0 = 4.D0*(PTMIN**2+RMASS(HQ)**2)
        ELSEIF (IPRO.EQ.16.OR.IPRO.EQ.19.OR.IPRO.EQ.95) THEN
          S0 = MAX(2*RMASS(1),RMASS(201)-GAMMAX*GAMH)**2
        ELSEIF (IPRO.EQ.23) THEN
          S0 = MAX(2*RMASS(1),RMASS(201)-GAMMAX*GAMH)**2
          S0 = (PTMIN+SQRT(PTMIN**2+S0))**2
        ELSEIF (IPRO.EQ.20) THEN
          S0 = RMASS(201)**2
        ELSEIF (IPRO.EQ.21) THEN
          S0 = (PTMIN+SQRT(PTMIN**2+RMASS(198)**2))**2
        ELSEIF (IPRO.EQ.52) THEN
          HQ = MOD(IPROC,100)
          S0 = (PTMIN+SQRT(PTMIN**2+RMASS(HQ)**2))**2
        ELSEIF (IPRO.EQ.80) THEN
          S0 = WHMIN**2
        ELSEIF (IPRO.EQ.90) THEN
          S0 = Q2MIN
        ELSEIF (IPRO.EQ.91.OR.IPRO.EQ.92) THEN
          S0 = Q2MIN+4.D0*PTMIN**2
          HQ = MOD(IPROC,100)
          IF (HQ.GT.0) S0 = S0+4.D0*RMASS(HQ)**2
          IF (IPRO.EQ.91) S0 = MAX(S0,EMMIN**2)
        ELSE
          S0 = 0
        ENDIF
        IF (S0.GT.0) THEN
          S0 = (SQRT(S0)+ABS(PHEP(5,IHADIS)))**2-PHEP(5,IHADIS)**2
          S0 = MAX(S0,WHMIN**2)
          ZMIN = S0 / (SS**2 - PHEP(5,IHEP)**2 - PHEP(5,IHADIS)**2)
          ZMAX = ONE
        ELSE
C---UNKNOWN PROCESS: USE ENERGY CUTOFF, AND WARN USER
          IF (FSTWGT) CALL HWWARN('HWEGAM',1,*999)
          ZMIN = EGMIN / PHEP(4,IHEP)
          ZMAX = ONE
        ENDIF
      ELSE
        ZMIN=ZMI
        ZMAX=ZMA
      ENDIF
C---APPLY USER DEFINED CUTS YWWMIN,YWWMAX AND INDIRECT LIMITS ON Z
      IF (.NOT.WWA) THEN
        ZMIN=MAX(ZMIN,YWWMIN,SQRT(Q2WWMN)/ABS(PHEP(3,IHEP)))
        ZMAX=MIN(ZMAX,YWWMAX)
        IF (ZMIN.GT.ZMAX) THEN
          GAMWT=ZERO
          RETURN
        ENDIF
      ENDIF
C---GENERATE GAMMA MOMENTUM FRACTION
      A=HALF
 10   IF (HWRGEN(2).LT.A) THEN
        ZGAM=(ZMIN/ZMAX)**HWRGEN(1)*ZMAX
      ELSE
        ZGAM=(ZMAX-ZMIN)*HWRGEN(1)+ZMIN
      ENDIF
      GAMWT = GAMWT * .5*ALPHEM/PIFAC *
     +     (1+(1-ZGAM)**2)/(A/LOG(ZMAX/ZMIN)+(1-A)/(ZMAX-ZMIN)*ZGAM)
      IF (WWA) THEN
        GAMWT = GAMWT * LOG((ONE-ZGAM)/ZGAM*(SS/PHEP(5,IHEP))**2)
      ELSE
C---Q2WWMN AND Q2WWMX ARE USER-DEFINED LIMITS IN THE Q**2 INTEGRATION
        QQMAX=MIN(Q2WWMX,(ZGAM*PHEP(3,IHEP))**2)
        QQMIN=MAX(Q2WWMN,(PHEP(5,IHEP)*ZGAM)**2/(1.-ZGAM))
        IF (QQMIN.GT.QQMAX) CALL HWWARN('HWEGAM',50,*10)
        Q2=EXP(HWRUNI(0,LOG(QQMIN),LOG(QQMAX)))
        GAMWT = GAMWT * LOG(QQMAX/QQMIN)
      ENDIF
      IF (GAMWT.LT.ZERO) GAMWT=ZERO
C---FILL PHOTON
      NHEP=NHEP+1
      IDHW(NHEP)=59
      ISTHEP(NHEP)=3
      IDHEP(NHEP)=22
      JMOHEP(1,NHEP)=IHEP
      JMOHEP(2,NHEP)=0
      JDAHEP(1,NHEP)=0
      JDAHEP(2,NHEP)=0
      JDAHEP(1,IHEP)=NHEP
      IF (WWA) THEN
C---FOR COLLINEAR KINEMATICS, ZGAM IS THE ENERGY FRACTION
        PHEP(4,NHEP)=PHEP(4,IHEP)*ZGAM
        PHEP(3,NHEP)=PHEP(3,IHEP)-SIGN(SQRT(
     &     (PHEP(4,IHEP)-PHEP(4,NHEP))**2-PHEP(5,IHEP)**2),PHEP(3,IHEP))
        PHEP(2,NHEP)=0
        PHEP(1,NHEP)=0
        CALL HWUMAS(PHEP(1,NHEP))
      ELSE
C---FOR EXACT KINEMATICS, ZGAM IS TAKEN TO BE FRACTION OF (E+PZ)
        PPL=ZGAM*(ABS(PHEP(3,IHEP))+PHEP(4,IHEP))
        QT2=(ONE-ZGAM)*Q2-(ZGAM*PHEP(5,IHEP))**2
        PMI=(QT2-Q2)/PPL
        PHEP(5,NHEP)=-SQRT(Q2)
        PHEP(4,NHEP)=(PPL+PMI)/TWO
        PHEP(3,NHEP)=SIGN((PPL-PMI)/TWO,PHEP(3,IHEP))
        CALL HWRAZM(SQRT(QT2),PHEP(1,NHEP),PHEP(2,NHEP))
      ENDIF
C---UPDATE OVERALL CM FRAME
      JMOHEP(IHEP,3)=NHEP
      CALL HWVDIF(4,PHEP(1,3),PHEP(1,IHEP),PHEP(1,3))
      CALL HWVSUM(4,PHEP(1,NHEP),PHEP(1,3),PHEP(1,3))
      CALL HWUMAS(PHEP(1,3))
C---FILL OUTGOING LEPTON
      NHEP=NHEP+1
      IDHW(NHEP)=IDHW(IHEP)
      ISTHEP(NHEP)=1
      IDHEP(NHEP)=IDHEP(IHEP)
      JMOHEP(1,NHEP)=IHEP
      JMOHEP(2,NHEP)=0
      JDAHEP(1,NHEP)=0
      JDAHEP(2,NHEP)=0
      JDAHEP(2,IHEP)=NHEP
      CALL HWVDIF(4,PHEP(1,IHEP),PHEP(1,NHEP-1),PHEP(1,NHEP))
      PHEP(5,NHEP)=PHEP(5,IHEP)
 999  END
CDECK  ID>, HWEINI.
*CMZ :-        -26/04/91  12.42.30  by  Federico Carminati
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWEINI
C-----------------------------------------------------------------------
C     INITIALISES ELEMENTARY PROCESS
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRSET,DUMMY,SAFETY
      EXTERNAL HWRSET
      PARAMETER (SAFETY=1.001)
      INTEGER NBSH,I
C---NO OF WEIGHT GENERATED
      NWGTS=0
C---ACCUMULATED WEIGHTS
      WGTSUM=0.
C---ACCUMULATED WEIGHT-SQUARED
      WSQSUM=0.
C---CURRENT MAX WEIGHT
      WBIGST=0.
C---LAST VALUE OF SCALE
      EMLST=0.
C---NUMBER OF ERRORS REPORTED
      NUMER=0
C---NUMBER OF ERRORS UNREPORTED
      NUMERU=0
C---FIND MAXIMUM EVENT WEIGHT IN CASES WHERE THIS IS REQUIRED
      IF (NOWGT) THEN
        IF (WGTMAX.EQ.0.) THEN
          NBSH=IBSH
          DUMMY = HWRSET(IBRN)
          WRITE(6,10) IPROC,IBRN,NBSH
   10     FORMAT(/10X,'INITIAL SEARCH FOR MAX WEIGHT'//
     &            10X,'PROCESS CODE IPROC = ',I11/
     &            10X,'RANDOM NO. SEED 1  = ',I11/
     &            10X,'           SEED 2  = ',I11/
     &            10X,'NUMBER OF SHOTS    = ',I11)
          NEVHEP=0
          DO 11 I=1,NBSH
          CALL HWEPRO
   11     CONTINUE
          WRITE(6,20)
   20     FORMAT(/10X,'INITIAL SEARCH FINISHED')
          IF (WBIGST*NWGTS.LT.SAFETY*WGTSUM)
     &                 WGTMAX=SAFETY*WBIGST
          CALL HWEFIN
          NWGTS=0
          WGTSUM=0.
          WSQSUM=0.
          WBIGST=0.
        ELSE
          WRITE(6,21) AVWGT,WGTMAX
   21     FORMAT(/1P,10X,'INPUT EVT WEIGHT   =',E12.4/
     &               10X,'INPUT MAX WEIGHT   =',E12.4)
        ENDIF
      ENDIF
C---RESET RANDOM NUMBER
      DUMMY = HWRSET(NRN)
      ISTAT=5
  999 END
CDECK  ID>, HWEISR.
*CMZ :-        -26/04/94  16.20.17  by  Mike Seymour
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HWEISR(IHEP)
C-----------------------------------------------------------------------
C     GENERATES AN ISR PHOTON FROM INCOMING E+, E-, MU+ OR MU-
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,QSQMAX,QSQMIN,A,B,B1,B2,B3,B4,B5,B6,B7,B8,
     $ R,AA,T0,T1,C1,C2,T,Z(2),QSQ(2),PHI(2),C
      INTEGER IHEP,I,J
      EXTERNAL HWRGEN
      SAVE Z,QSQ,PHI
C---IF ZMXISR IS ZERO, THERE CAN BE NO ISR
      IF (ZMXISR.EQ.0 .OR. IPRO.GT.3) RETURN
C---CHECK CONSISTENCY OF TMNISR AND ZMXISR
      IF (ZMXISR**2.LT.TMNISR) CALL HWWARN('HWEISR',200,*999)
C---CALCULATE VIRTUALITY LIMITS
      QSQMAX=4*PHEP(4,IHEP)**2
      QSQMIN=PHEP(5,IHEP)**2
C---AND THEREFORE THE Z DEPENDENCE
      A=ALPHEM/PIFAC
      B=A*(LOG(QSQMAX/QSQMIN)-1)
C---DECIDE HOW MUCH WEIGHT TO GIVE THE Z RESONANCE
      IF (IHEP.EQ.1.AND.IPRO.LE.3) THEN
        IF (IPRO.EQ.1) THEN
          AA=10
        ELSEIF (IPRO.EQ.2) THEN
          AA=0
        ELSEIF (IPRO.EQ.3) THEN
          AA=1
        ELSE
          RETURN
        ENDIF
        T0=RMASS(200)**2/QSQMAX
        T1=GAMZ*RMASS(200)/QSQMAX
        IF (T0.GT.1) THEN
          T0=0
          AA=0
        ENDIF
        AA=AA*(1-T0)
C---GENERATE A T VALUE BETWEEN TMNISR AND 1 ACCORDING TO:
C   ( b**2*log(zmxisr**2/t)/t + 2*b*(1-(1-zmxisr)**b)*((1-t)**(2*b-1)+1/t
C     +(1-t0)**(2b-1)*aa*t1/((t-t0)**2+t1**2)) ) *theta(zmxisr**2-t)
C  +( 2*b*(1-zmxisr)**b*((1-t)**(b-1)+1/t
C     +(1-t0)**(b-1)*aa*t1/((t-t0)**2+t1**2))  ) *theta(zmxisr-t)
C  +( (1-zmxisr)**(2*b)                        ) *delta(1-t)
        B1=(1-ZMXISR)**(2*B)
        B2=B1+2*(1-ZMXISR)**B*((1-TMNISR)**B-(1-ZMXISR)**B)
        B3=B2+2*B*(1-ZMXISR)**B*LOG(ZMXISR/TMNISR)
        B4=B3+2*B*(1-ZMXISR)**B*AA*(1-T0)**(B-1)
     $       *(ATAN((ZMXISR-T0)/T1)-ATAN((TMNISR-T0)/T1))
        B5=B4+(1-(1-ZMXISR)**B)*((1-TMNISR)**(2*B)-(1-ZMXISR**2)**(2*B))
        B6=B5+2*B*(1-(1-ZMXISR)**B)*LOG(ZMXISR**2/TMNISR)
        B7=B6+B**2*LOG(ZMXISR**2/TMNISR)**2/2
        B8=B7+2*B*(1-(1-ZMXISR)**B)*AA*(1-T0)**(2*B-1)
     $       *(ATAN((ZMXISR**2-T0)/T1)-ATAN((TMNISR-T0)/T1))
        R=B8*HWRGEN(0)
        IF (R.LE.B1) THEN
C---NEITHER EMITS
          T=1
          GAMWT=GAMWT*B8/B1
          Z(1)=1
        ELSEIF (R.LE.B4) THEN
C---ONE EMITS
          IF (R.LE.B2) THEN
            R=(R-B1)/(B2-B1)
            T=1-(1-TMNISR)*(1-R*(1-((1-ZMXISR)/(1-TMNISR))**B))**(1/B)
          ELSEIF (R.LE.B3) THEN
            R=(R-B2)/(B3-B2)
            T=(TMNISR/ZMXISR)**R*ZMXISR
          ELSE
            R=(R-B3)/(B4-B3)
            T=T0+T1*TAN(
     $           ATAN((ZMXISR-T0)/T1)*R+ATAN((TMNISR-T0)/T1)*(1-R))
          ENDIF
          GAMWT=GAMWT*B8/(2*B*(1-ZMXISR)**B*((1-T)**(B-1)+1/T+
     $         (1-T0)**(B-1)*AA*T1/((T-T0)**2+T1**2)))
          Z(1)=1
          IF (HWRGEN(1).GT.0.5) Z(1)=T
          GAMWT=GAMWT*2
        ELSE
C---BOTH EMIT
          IF (R.LE.B5) THEN
            R=(R-B4)/(B5-B4)
            T=1-(1-TMNISR)*
     $           (1-R*(1-((1-ZMXISR**2)/(1-TMNISR))**(2*B)))**(.5/B)
          ELSEIF (R.LE.B6) THEN
            R=(R-B5)/(B6-B5)
            T=(TMNISR/ZMXISR**2)**R*ZMXISR**2
          ELSEIF (R.LE.B7) THEN
            R=(R-B6)/(B7-B6)
            T=(TMNISR/ZMXISR**2)**SQRT(R)*ZMXISR**2
          ELSE
            R=(R-B7)/(B8-B7)
            T=T0+T1*TAN(
     $           ATAN((ZMXISR**2-T0)/T1)*R+ATAN((TMNISR-T0)/T1)*(1-R))
          ENDIF
          GAMWT=GAMWT*B8/(B**2*LOG(ZMXISR**2/T)/T
     $         + 2*B*(1-(1-ZMXISR)**B)*((1-T)**(2*B-1)+1/T+
     $         (1-T0)**(B-1)*AA*T1/((T-T0)**2+T1**2)))
C---GENERATE A Z VALUE BETWEEN T/ZMXISR AND ZMXISR ACCORDING TO:
C   1/z+(1-z)**(b-1)+t/z**2*(1-t/z)**(b-1)
          C1=LOG(ZMXISR**2/T)
          C2=C1+2/B*((1-T/ZMXISR)**B-(1-ZMXISR)**B)
          IF (C2.GT.0) THEN
            R=C2*HWRGEN(4)
            IF (R.LE.C1) THEN
              Z(1)=(T/ZMXISR**2)**HWRGEN(5)*ZMXISR
            ELSE
              Z(1)=1-(1-T/ZMXISR)*
     $             (1-HWRGEN(6)*(1-((1-ZMXISR)/(1-T/ZMXISR))**B))**(1/B)
              IF (2*R.LE.C2+C1) Z(1)=T/Z(1)
            ENDIF
          ELSE
            Z(1)=SQRT(T)
          ENDIF
          GAMWT=GAMWT*C2/Z(1)
     $         /(1/Z(1)+(1-Z(1))**(B-1)+T/Z(1)**2*(1-T/Z(1))**(B-1))
        ENDIF
C---INCLUDE DISTRIBUTION FUNCTIONS
        Z(2)=T/Z(1)
        DO 10 I=1,2
          IF (Z(I).GT.ZMXISR) THEN
            Z(I)=1
            GAMWT=GAMWT*(1-ZMXISR)**B*EXP(3*B/4)*(1-B**2*PIFAC**2/12)
          ELSE
            GAMWT=GAMWT*(B*(1-Z(I))**(B-1)*(1+Z(I)**2)/2
     $           *EXP(B*Z(I)/2*(1+Z(I)/2))*(1-B**2*PIFAC**2/12)
     $           +B**2/8*((1+Z(I))*((1+Z(I))**2+3*LOG(Z(I)))
     $           -4*LOG(Z(I))/(1-Z(I))))
          ENDIF
  10    CONTINUE
C---CHOOSE BOTH QSQ VALUES
        DO 30 I=1,2
          IF (Z(I).GT.ZMXISR .OR. COLISR) THEN
            QSQ(I)=0
          ELSE
            J=3-I
C---ACCORDING TO 1/(QSQ+QSQMIN) FROM 0 TO (1-Z)*(T/(Z+T))*QSQMAX
 20         QSQ(I)=(((1-Z(I))*(T/(Z(I)+T))
     $           *QSQMAX/QSQMIN+1)**HWRGEN(7)-1)*QSQMIN
C---AND REJECT TO QSQ/(QSQ+QSQMIN)**2
            IF (HWRGEN(8)*(QSQ(I)+QSQMIN).GT.QSQ(I)) GOTO 20
          ENDIF
 30     CONTINUE
C---CHOOSE BOTH AZIMUTHS
        PHI(1)=HWRGEN(9)*2*PIFAC
        PHI(2)=HWRGEN(10)*2*PIFAC
C---USE S-HAT PRESCRIPTION TO MODIFY Z VALUES
        I=0
        IF ((1-Z(1))*QSQ(1).GT.(1-Z(2))*QSQ(2)) I=1
        IF ((1-Z(2))*QSQ(2).GT.(1-Z(1))*QSQ(1)) I=2
        IF (I.GT.0) THEN
          J=3-I
          Z(I)=Z(I)+QSQ(I)/QSQMAX
          IF (QSQ(J).GT.0) THEN
            Z(J)=((QSQ(I)*QSQMAX+QSQ(J)*QSQMAX
     $           -QSQ(I)*QSQ(J))/QSQMAX**2+T)/Z(I)
            C=COS(PHI(1)-PHI(2))*SQRT(QSQ(1)*QSQ(2))/QSQMAX
            Z(J)=Z(J)+(-2*C**2*(1-Z(I))+2*C*SQRT((1-Z(I))
     $           *(C**2*(1-Z(I))+Z(I)**2*(1-Z(J)))))/Z(I)**2
          ENDIF
        ENDIF
      ELSEIF (IHEP.EQ.2) THEN
C---EVERYTHING WAS GENERATED LAST TIME
      ELSE
C---ROUTINE CALLED UNEXPECTEDLY
        CALL HWWARN('HWEISR',201,*999)
      ENDIF
C---IF Z IS TOO LARGE THERE IS NO EMISSION
      IF (Z(IHEP).GT.ZMXISR) RETURN
C---PUT NEW LEPTON IN EVENT RECORD
      NHEP=NHEP+1
      IDHW(NHEP)=IDHW(IHEP)
      IDHEP(NHEP)=IDHEP(IHEP)
      ISTHEP(NHEP)=3
      JMOHEP(1,NHEP)=IHEP
      JMOHEP(2,NHEP)=0
      JDAHEP(1,NHEP)=0
      JDAHEP(2,NHEP)=0
      JDAHEP(1,IHEP)=NHEP
C---AND OUTGOING PHOTON
      NHEP=NHEP+1
      IDHW(NHEP)=59
      IDHEP(NHEP)=22
      ISTHEP(NHEP)=1
      JMOHEP(1,NHEP)=IHEP
      JMOHEP(2,NHEP)=0
      JDAHEP(1,NHEP)=0
      JDAHEP(2,NHEP)=0
      JDAHEP(2,IHEP)=NHEP
C---RECONSTRUCT PHOTON KINEMATICS (Z IS LIGHT-CONE MOMENTUM FRACTION)
      PHEP(1,NHEP)=SQRT(QSQ(IHEP)*(1-Z(IHEP)))*COS(PHI(IHEP))
      PHEP(2,NHEP)=SQRT(QSQ(IHEP)*(1-Z(IHEP)))*SIN(PHI(IHEP))
      PHEP(3,NHEP)=(1-Z(IHEP))*PHEP(4,IHEP)-QSQ(IHEP)/(4*PHEP(4,IHEP))
      IF (IHEP.EQ.2) PHEP(3,NHEP)=-PHEP(3,NHEP)
      PHEP(4,NHEP)=(1-Z(IHEP))*PHEP(4,IHEP)+QSQ(IHEP)/(4*PHEP(4,IHEP))
      PHEP(5,NHEP)=0
C---AND LEPTON
      CALL HWVDIF(4,PHEP(1,IHEP),PHEP(1,NHEP),PHEP(1,NHEP-1))
      CALL HWUMAS(PHEP(1,NHEP-1))
C---UPDATE OVERALL CM FRAME
      JMOHEP(IHEP,3)=NHEP-1
      CALL HWVDIF(4,PHEP(1,3),PHEP(1,IHEP),PHEP(1,3))
      CALL HWVSUM(4,PHEP(1,NHEP-1),PHEP(1,3),PHEP(1,3))
      CALL HWUMAS(PHEP(1,3))
 999  END
CDECK  ID>, HWEONE.
*CMZ :-        -26/04/91  11.11.55  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWEONE
C-----------------------------------------------------------------------
C     SETS UP 2->1 (COLOUR SINGLET) HARD SUBPROCESS
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION PA
      INTEGER ICMF,I,IBM,IHEP
C---INCOMING LINES
      ICMF=NHEP+3
      DO 15 I=1,2
      IBM=I
C---FIND BEAM AND TARGET
      IF (JDAHEP(1,I).NE.0) IBM=JDAHEP(1,I)
      IHEP=NHEP+I
      IDHW(IHEP)=IDN(I)
      IDHEP(IHEP)=IDPDG(IDN(I))
      ISTHEP(IHEP)=110+I
      JMOHEP(1,IHEP)=ICMF
      JMOHEP(I,ICMF)=IHEP
      JDAHEP(1,IHEP)=ICMF
C---SPECIAL - IF INCOMING PARTON IS INCOMING BEAM THEN COPY IT
      IF (XX(I).EQ.ONE.AND.IDHW(IBM).EQ.IDN(I)) THEN
        CALL HWVEQU(5,PHEP(1,IBM),PHEP(1,IHEP))
        IF (I.EQ.2) PHEP(3,IHEP)=-PHEP(3,IHEP)
      ELSE
        PHEP(1,IHEP)=0.
        PHEP(2,IHEP)=0.
        PHEP(5,IHEP)=RMASS(IDN(I))
        PA=XX(I)*(PHEP(4,IBM)+ABS(PHEP(3,IBM)))
        PHEP(4,IHEP)=0.5*(PA+PHEP(5,IHEP)**2/PA)
        PHEP(3,IHEP)=PA-PHEP(4,IHEP)
      ENDIF
 15   CONTINUE
      PHEP(3,NHEP+2)=-PHEP(3,NHEP+2)
C---HARD CENTRE OF MASS
      IDHW(ICMF)=IDCMF
      IDHEP(ICMF)=IDPDG(IDCMF)
      ISTHEP(ICMF)=110
      CALL HWVSUM(4,PHEP(1,NHEP+1),PHEP(1,NHEP+2),PHEP(1,ICMF))
      CALL HWUMAS(PHEP(1,ICMF))
C---SET UP COLOUR STRUCTURE LABELS
      JMOHEP(2,NHEP+1)=NHEP+2
      JDAHEP(2,NHEP+1)=NHEP+2
      JMOHEP(2,NHEP+2)=NHEP+1
      JDAHEP(2,NHEP+2)=NHEP+1
      JDAHEP(1,NHEP+3)=NHEP+3
      JDAHEP(2,NHEP+3)=NHEP+3
      NHEP=NHEP+3
  999 END
CDECK  ID>, HWEPRO.
*CMZ :-        -26/04/91  14.09.18  by  Federico Carminati
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWEPRO
C-----------------------------------------------------------------------
C     WHEN NEVHEP=0, CHOOSES X VALUES AND FINDS WEIGHT FOR PROCESS IPROC
C     OTHERWISE, CHOOSES AND LOADS ALL VARIABLES FOR HARD PROCESS
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN
      EXTERNAL HWRGEN
      IF (IERROR.NE.0)  RETURN
C---ROUTINE LOOPS BACK TO HERE IF GENERATED WEIGHT WAS NOT ACCEPTED
   10 GENEV=.FALSE.
C---FSTWGT IS .TRUE. DURING FIRST CALL TO HARD PROCESS ROUTINE
      FSTWGT=NWGTS.EQ.0
C---FSTEVT IS .TRUE. THROUGHOUT THE FIRST EVENT
      FSTEVT=NEVHEP.EQ.1
C---SET UP INITIAL STATE
      NHEP=1
      ISTHEP(NHEP)=101
      PHEP(1,NHEP)=0.
      PHEP(2,NHEP)=0.
      PHEP(3,NHEP)=PBEAM1
      PHEP(4,NHEP)=EBEAM1
      PHEP(5,NHEP)=RMASS(IPART1)
      JMOHEP(1,NHEP)=0
      JMOHEP(2,NHEP)=0
      JDAHEP(1,NHEP)=0
      JDAHEP(2,NHEP)=0
      IDHW(NHEP)=IPART1
      IDHEP(NHEP)=IDPDG(IPART1)
      NHEP=NHEP+1
      ISTHEP(NHEP)=102
      PHEP(1,NHEP)=0.
      PHEP(2,NHEP)=0.
      PHEP(3,NHEP)=-PBEAM2
      PHEP(4,NHEP)=EBEAM2
      PHEP(5,NHEP)=RMASS(IPART2)
      JMOHEP(1,NHEP)=0
      JMOHEP(2,NHEP)=0
      JDAHEP(1,NHEP)=0
      JDAHEP(2,NHEP)=0
      IDHW(NHEP)=IPART2
      IDHEP(NHEP)=IDPDG(IPART2)
C---NEXT ENTRY IS OVERALL CM FRAME
      NHEP=NHEP+1
      IDHW(NHEP)=14
      IDHEP(NHEP)=0
      ISTHEP(NHEP)=103
      JMOHEP(1,NHEP)=NHEP-2
      JMOHEP(2,NHEP)=NHEP-1
      JDAHEP(1,NHEP)=0
      JDAHEP(2,NHEP)=0
      CALL HWVSUM(4,PHEP(1,NHEP-1),PHEP(1,NHEP-2),PHEP(1,NHEP))
      CALL HWUMAS(PHEP(1,NHEP))
C Select a primary interaction point
      IF (PIPSMR) THEN
        CALL HWRPIP
      ELSE
        CALL HWVZRO(4,VTXPIP)
      ENDIF
      CALL HWVEQU(3,VTXPIP,VHEP(1,NHEP))
      VHEP(4,NHEP)=0.0
C---GENERATE PHOTONS (WEIZSACKER-WILLIAMS APPROX)
C   FOR HADRONIC PROCESSES WITH LEPTON BEAMS
      GAMWT=ONE
      IF (IPRO.GT.10.AND.IPRO.LT.90) THEN
        IF (ABS(IDHEP(1)).EQ.11.OR.ABS(IDHEP(1)).EQ.13)
     &       CALL HWEGAM(1,ZERO, ONE,.FALSE.)
        IF (ABS(IDHEP(2)).EQ.11.OR.ABS(IDHEP(2)).EQ.13)
     &       CALL HWEGAM(2,ZERO, ONE,.FALSE.)
      ELSEIF (IPRO.GE.90) THEN
        IF (ABS(IDHEP(2)).EQ.11.OR.ABS(IDHEP(2)).EQ.13)
     &       CALL HWEGAM(2,ZERO, ONE,.FALSE.)
      ENDIF
C---GENERATE ISR PHOTONS FOR LEPTONIC PROCESSES
      IF (IPRO.LT.10) THEN
        CALL HWEISR(1)
        CALL HWEISR(2)
      ENDIF
C---IF USER LIMITS WERE TOO TIGHT, MIGHT NOT BE ANY PHASE-SPACE
      IF (GAMWT.LE.ZERO) GOTO 30
C---IF CMF HAS ACQUIRED A TRANSVERSE BOOST, OR USER REQUESTS IT ANYWAY,
C   BOOST EVENT RECORD BACK TO CMF
      IF (PHEP(1,3)**2+PHEP(2,3)**2.GT.0 .OR. USECMF) CALL HWUBST(1)
C---ROUTINE LOOPS BACK TO HERE IF GENERATED WEIGHT WAS ACCEPTED
   20 CONTINUE
C---IPRO=MOD(IPROC/100,100)
      IF (IPRO.EQ.1) THEN
        IF (IPROC.LT.110.OR.IPROC.GE.120) THEN
C--- E+E- -> Q-QBAR OR L-LBAR
          CALL HWHEPA
        ELSE
C--- E+E- -> Q-QBAR-GLUON
          CALL HWHEPG
        ENDIF
      ELSEIF (IPRO.EQ.2) THEN
C--- E+E- -> W+ W-
        CALL HWHEWW
      ELSEIF (IPRO.EQ.3) THEN
C---E+E- -> Z H
        CALL HWHIGZ
      ELSEIF (IPRO.EQ.4) THEN
C---E+E- -> NUEB NUE H
        CALL HWHIGW
      ELSEIF (IPRO.EQ.5 .AND. IPROC.LT.550) THEN
C---EE -> EE GAMGAM -> EE FFBAR/WW
        CALL HWHEGG
      ELSEIF (IPRO.EQ.5) THEN
C---EE -> ENU GAMW -> ENU FF'BAR/WZ
        CALL HWHEGW
      ELSEIF (IPRO.EQ.13) THEN
C---GAMMA/Z0/Z' DRELL-YAN PROCESS
        CALL HWHDYP
      ELSEIF (IPRO.EQ.14) THEN
C---W+/- PRODUCTION VIA DRELL-YAN PROCESS
        CALL HWHWPR
      ELSEIF (IPRO.EQ.15) THEN
C---QCD HARD 2->2 PROCESSES
        CALL HWHQCD
      ELSEIF (IPRO.EQ.16) THEN
C---HIGGS PRODUCTION VIA GLUON FUSION
        CALL HWHIGS
      ELSEIF (IPRO.EQ.17) THEN
C---QCD HEAVY FLAVOUR PRODUCTION
        CALL HWHHVY
      ELSEIF (IPRO.EQ.18) THEN
C---QCD DIRECT PHOTON + JET PRODUCTION
        CALL HWHPHO
      ELSEIF (IPRO.EQ.19) THEN
C---HIGGS PRODUCTION VIA W FUSION
        CALL HWHIGW
      ELSEIF (IPRO.EQ.20) THEN
C---TOP PRODUCTION FROM W EXCHANGE
        CALL HWHWEX
      ELSEIF (IPRO.EQ.21) THEN
C---VECTOR BOSON + JET PRODUCTION
        CALL HWHV1J
      ELSEIF (IPRO.EQ.22) THEN
C QCD direct photon pair production
        CALL HWHPH2
      ELSEIF (IPRO.EQ.23) THEN
C QCD Higgs plus jet production
        CALL HWHIGJ
      ELSEIF (IPRO.EQ.24) THEN
C---COLOUR-SINGLET EXCHANGE
        CALL HWHSNG
      ELSEIF (IPRO.EQ.50) THEN
C Point-like photon two-jet production
        CALL HWHPPT
      ELSEIF (IPRO.EQ.51) THEN
C Point-like photon/QCD heavy flavour pair production
        CALL HWHPPH
      ELSEIF (IPRO.EQ.52) THEN
C Point-like photon/QCD heavy flavour single excitation
        CALL HWHPPE
      ELSEIF (IPRO.EQ.53) THEN
C Compton scattering of point-like photon and (anti)quark
        CALL HWHPQS
      ELSEIF (IPRO.EQ.55) THEN
C Point-like photon/higher twist meson production
        CALL HWHPPM
      ELSEIF (IPRO.GE.70.AND.IPRO.LE.79) THEN
C---BARYON-NUMBER VIOLATION, AND OTHER MULTI-W PRODUCTION PROCESSES
        CALL HVHBVI
      ELSEIF (IPRO.EQ.80) THEN
C---MINIMUM-BIAS: NO HARD SUBPROCESS
C   FIND WEIGHT
        CALL HWMWGT
      ELSEIF (IPRO.EQ.90) THEN
C---DEEP INELASTIC
        CALL HWHDIS
      ELSEIF(IPRO.EQ.91) THEN
C---BOSON - GLUON(QUARK) FUSION -->  ANTIQUARK(GLUON) + QUARK
        CALL HWHBGF
      ELSEIF(IPRO.EQ.92) THEN
C---DEEP INELASTIC WITH EXTRA JET: OBSOLETE PROCESS
        WRITE (6,40)
 40     FORMAT (1X,' IPROC=92** is no longer supported.'
     &         /1X,' Please use IPROC=91** instead.')
        CALL HWWARN('HWEPRO',500,*999)
      ELSEIF(IPRO.EQ.95) THEN
C---HIGGS PRODUCTION VIA W FUSION IN E P
        CALL HWHIGW
      ELSE
C---UNKNOWN PROCESS
        CALL HWWARN('HWEPRO',102,*999)
      ENDIF
 30   IF (GENEV) THEN
        IF (NOWGT) EVWGT=AVWGT
        ISTAT=10
        RETURN
      ELSE
C---IF AN EVENT IS CANCELLED BEFORE IT IS GENERATED, GIVE IT ZERO WEIGHT
        IF (IERROR.NE.0) THEN
          EVWGT=ZERO
          IERROR=0
        ENDIF
        EVWGT=EVWGT*GAMWT
        NWGTS=NWGTS+1
        WGTSUM=WGTSUM+EVWGT
        WSQSUM=WSQSUM+EVWGT**2
        IF (EVWGT.GT.WBIGST) THEN
          WBIGST=EVWGT
          IF (NOWGT.AND.WBIGST.GT.WGTMAX) THEN
            IF (NEVHEP.NE.0) CALL HWWARN('HWEPRO',1,*999)
            WGTMAX=WBIGST*1.1
            WRITE (6,99) WGTMAX
          ENDIF
        ELSEIF (EVWGT.LT.0.) THEN
          IF (EVWGT.LT.-1.D-9) CALL HWWARN('HWEPRO',3,*999)
          EVWGT=0.
        ENDIF
        IF (NEVHEP.NE.0) THEN
C---LOW EFFICIENCY WARNINGS:
C   RESET AT 1 PER CENT, STOP AT 1 PER MILLE
          IF (NWGTS.GT.100*NEVHEP) THEN
            IF (NWGTS.GT.1000*NEVHEP) CALL HWWARN('HWEPRO',200,*999)
            IF (MOD(NWGTS,10000).EQ.0) THEN
              CALL HWWARN('HWEPRO',2,*999)
              WGTMAX=WBIGST*1.1
              WRITE (6,99) WGTMAX
            ENDIF
          ENDIF
          IF (NOWGT) THEN
            GENEV=EVWGT.GT.WGTMAX*HWRGEN(0)
          ELSE
            GENEV=EVWGT.NE.0.
          ENDIF
          IF (GENEV) GOTO 20
          GOTO 10
        ENDIF
      ENDIF
   99 FORMAT(10X,'NEW MAXIMUM WEIGHT =',1PG24.16)
  999 END
CDECK  ID>, HWETWO.
*CMZ :-        -26/04/91  11.11.55  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWETWO
C-----------------------------------------------------------------------
C     SETS UP 2->2 HARD SUBPROCESS
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWUPCM,PA,PCM
      INTEGER ICMF,IBM,I,J,K,IHEP
      EXTERNAL HWUPCM
C---INCOMING LINES
      ICMF=NHEP+3
      DO 15 I=1,2
      IBM=I
C---FIND BEAM AND TARGET
      IF (JDAHEP(1,I).NE.0) IBM=JDAHEP(1,I)
      IHEP=NHEP+I
      IDHW(IHEP)=IDN(I)
      IDHEP(IHEP)=IDPDG(IDN(I))
      ISTHEP(IHEP)=110+I
      JMOHEP(1,IHEP)=ICMF
      JMOHEP(I,ICMF)=IHEP
      JDAHEP(1,IHEP)=ICMF
C---SPECIAL - IF INCOMING PARTON IS INCOMING BEAM THEN COPY IT
      IF (XX(I).EQ.ONE.AND.IDHW(IBM).EQ.IDN(I)) THEN
        CALL HWVEQU(5,PHEP(1,IBM),PHEP(1,IHEP))
        IF (I.EQ.2) PHEP(3,IHEP)=-PHEP(3,IHEP)
      ELSE
        PHEP(1,IHEP)=0.
        PHEP(2,IHEP)=0.
        PHEP(5,IHEP)=RMASS(IDN(I))
        PA=XX(I)*(PHEP(4,IBM)+ABS(PHEP(3,IBM)))
        PHEP(4,IHEP)=0.5*(PA+PHEP(5,IHEP)**2/PA)
        PHEP(3,IHEP)=PA-PHEP(4,IHEP)
      ENDIF
 15   CONTINUE
      PHEP(3,NHEP+2)=-PHEP(3,NHEP+2)
C---HARD CENTRE OF MASS
      IDHW(ICMF)=IDCMF
      IDHEP(ICMF)=IDPDG(IDCMF)
      ISTHEP(ICMF)=110
      CALL HWVSUM(4,PHEP(1,NHEP+1),PHEP(1,NHEP+2),PHEP(1,ICMF))
      CALL HWUMAS(PHEP(1,ICMF))
C---OUTGOING LINES
      DO 20 I=3,4
      IHEP=NHEP+I+1
      IDHW(IHEP)=IDN(I)
      IDHEP(IHEP)=IDPDG(IDN(I))
      ISTHEP(IHEP)=110+I
      JMOHEP(1,IHEP)=ICMF
      JDAHEP(I-2,ICMF)=IHEP
   20 PHEP(5,IHEP)=RMASS(IDN(I))
      PCM=HWUPCM(PHEP(5,NHEP+3),PHEP(5,NHEP+4),PHEP(5,NHEP+5))
      IF (PCM.LT.0.) CALL HWWARN('HWETWO',103,*999)
      IHEP=NHEP+4
      PHEP(4,IHEP)=SQRT(PCM**2+PHEP(5,IHEP)**2)
      PHEP(3,IHEP)=PCM*COSTH
      PHEP(1,IHEP)=SQRT((PCM+PHEP(3,IHEP))*(PCM-PHEP(3,IHEP)))
      CALL HWRAZM(PHEP(1,IHEP),PHEP(1,IHEP),PHEP(2,IHEP))
      CALL HWULOB(PHEP(1,NHEP+3),PHEP(1,IHEP),PHEP(1,IHEP))
      CALL HWVDIF(4,PHEP(1,NHEP+3),PHEP(1,IHEP),PHEP(1,NHEP+5))
C---SET UP COLOUR STRUCTURE LABELS
      DO 30 I=1,4
      J=I
      IF (J.GT.2) J=J+1
      K=ICO(I)
      IF (K.GT.2) K=K+1
      JMOHEP(2,NHEP+J)=NHEP+K
   30 JDAHEP(2,NHEP+K)=NHEP+J
      NHEP=NHEP+5
  999 END
CDECK  ID>, HWHBGF.
*CMZ :-        -26/04/91  11.11.55  by  Bryan Webber
*-- Author :    Giovanni Abbiendi & Luca Stanco
C-----------------------------------------------------------------------
      SUBROUTINE HWHBGF
C-----------------------------------------------------------------------
C     Order Alpha_s processes in charged lepton-hadron collisions
C
C       Process code IPROC has to be set in the Main Program
C       the following codes IPROC may be selected
C
C                9100 : NC  BOSON-GLUON FUSION
C                9100+IQK (IQK=1,...,6) :  produced flavour is IQK
C                9107 : produced  J/psi + gluon
C
C                9110 : NC  QCD COMPTON
C                9110+IQK (IQK=1,...,12) : struck parton is IQK
C
C                9130 : NC order alpha_s processes (9100+9110)
C
C       Select maximum and minimum generated flavour when IQK=0
C       setting IFLMIN and IFLMAX in the Main Program
C       (allowed values from 1 to 6), default are 1 and 5
C       allowing d,u,s,c,b,dbar,ubar,sbar,cbar,bbar
C
C           CHARGED CURRENT Boson-Gluon Fusion processes
C                9141 : CC  s cbar  (c sbar)
C                9142 : CC  b cbar  (c bbar)
C                9143 : CC  s tbar  (t cbar)
C                9144 : CC  b tbar  (t bbar)
C
C       other inputs : Q2MIN,Q2MAX,YBMIN,YBMAX,PTMIN,EMMIN,EMMAX
C       when IPROC=(1)9107 : as above but Q2WWMN, Q2WWMX substitute
C                            Q2MIN and Q2MAX (EPA is used); ZJMAX cut
C
C      Add 10000 to suppress soft remnant fragmentation
C
C      Mean EVWGT = cross section in nanoBarn
C
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,LEP,Y,Q2,SHAT,Z,PHI,AJACOB,DSIGMA,ME,MP,
     & ML,MREMIF(18),MFIN1(18),MFIN2(18),RS,SMA,W2,RSHAT,FSIGMA(18),
     & SIGSUM,PROB,PRAN,PVRT(4),X
      INTEGER IQK,IFLAVU,IFLAVD,IMIN,IMAX,IFL,IPROO,LEPFIN,ID1,ID2,I,IDD
      LOGICAL CHARGD,INCLUD(18),INSIDE(18)
      EXTERNAL HWRGEN
      SAVE LEPFIN,ID1,ID2,FSIGMA,SIGSUM
      COMMON /HWAREA/ LEP,Y,Q2,SHAT,Z,PHI,AJACOB,DSIGMA,ME,MP,ML,MREMIF,
     & MFIN1,MFIN2,RS,SMA,W2,RSHAT,IQK,IFLAVU,IFLAVD,IMIN,IMAX,IFL,
     & IPROO,CHARGD,INCLUD,INSIDE
C---Initialization
      IF (FSTWGT) THEN
C---LEP = 1 FOR LEPTONS, -1 FOR ANTILEPTONS
        LEP=ZERO
        IF (IDHW(1).GE.121.AND.IDHW(1).LE.126) THEN
          LEP=ONE
        ELSEIF (IDHW(1).GE.127.AND.IDHW(1).LE.132) THEN
          LEP=-ONE
        ENDIF
        IF (LEP.EQ.ZERO) CALL HWWARN('HWHBGF',500,*999)
        IPROO=MOD(IPROC,100)/10
        IF (IPROO.EQ.0.OR.IPROO.EQ.4) THEN
          IQK=MOD(IPROC,10)
          IFL=IQK
          IF (IQK.EQ.7) IFL=164
          CHARGD=IPROO.EQ.4
        ELSEIF (IPROO.EQ.1.OR.IPROO.EQ.2) THEN
          IQK=MOD(IPROC,100)-10
          IFL=IQK+6
          CHARGD=.FALSE.
        ELSEIF (IPROO.EQ.3) THEN
          IQK=0
          IFL=0
          CHARGD=.FALSE.
        ELSE
          CALL HWWARN('HWHBGF',501,*999)
        ENDIF
C
        LEPFIN = IDHW(1)
        IF(CHARGD) THEN
          LEPFIN = IDHW(1)+1
          IF (IQK.EQ.1) THEN
            IFLAVU=4
            IFLAVD=3
            ID1  = 3
            ID2  = 10
          ELSEIF (IQK.EQ.2) THEN
            IFLAVU=4
            IFLAVD=5
            ID1  = 5
            ID2  = 10
          ELSEIF (IQK.EQ.3) THEN
            IFLAVU=6
            IFLAVD=3
            ID1  = 3
            ID2  =12
          ELSE
            IFLAVU=6
            IFLAVD=5
            ID1  = 5
            ID2  =12
          ENDIF
          IF (LEP.EQ.-1.) THEN
            IDD=ID1
            ID1=ID2-6
            ID2=IDD+6
          ENDIF
        ENDIF
C
        IF (IQK.EQ.0) THEN
          DO I=1,18
            INCLUD(I)=.TRUE.
          ENDDO
          IMIN=1
          IMAX=18
          DO I=1,6
            IF (I.LT.IFLMIN.OR.I.GT.IFLMAX) INCLUD(I)=.FALSE.
          ENDDO
          DO I=7,18
            IF (I.LE.12) THEN
              IF (I-6.LT.IFLMIN.OR.I-6.GT.IFLMAX) INCLUD(I)=.FALSE.
            ELSE
              IF (I-12.LT.IFLMIN.OR.I-12.GT.IFLMAX) INCLUD(I)=.FALSE.
            ENDIF
          ENDDO
          IF (IPROO.EQ.0) THEN
            DO I=7,18
              INCLUD(I)=.FALSE.
            ENDDO
            IMIN=IFLMIN
            IMAX=IFLMAX
          ELSEIF (IPROO.EQ.1.OR.IPROO.EQ.2) THEN
            DO I=1,6
              INCLUD(I)=.FALSE.
            ENDDO
            IMIN=IFLMIN+6
            IMAX=IFLMAX+12
          ELSEIF (IPROO.EQ.3) THEN
            IMIN=IFLMIN
            IMAX=IFLMAX+12
          ENDIF
        ELSEIF (IQK.NE.0 .AND. (.NOT.CHARGD)) THEN
          DO I=1,18
            INCLUD(I)=.FALSE.
          ENDDO
          IF (IFL.LE.18) THEN
            INCLUD(IFL)=.TRUE.
            IMIN=IFL
            IMAX=IFL
          ELSEIF (IFL.EQ.164) THEN
            INCLUD(7)=.TRUE.
            IMIN=7
            IMAX=7
          ENDIF
        ENDIF
      ENDIF
C---End of initialization
      IF(GENEV) THEN
      IF (.NOT.CHARGD) THEN
        IF (IQK.EQ.0) THEN
          PRAN= SIGSUM * HWRGEN(0)
          PROB=ZERO
          DO 10 IFL=IMIN,IMAX
            IF (.NOT.INSIDE(IFL)) GOTO 10
            PROB=PROB+FSIGMA(IFL)
            IF (PROB.GE.PRAN) GOTO 20
  10      CONTINUE
        ENDIF
C---at this point the subprocess has been selected (IFL)
  20    CONTINUE
        IF (IFL.LE.6) THEN
C---Boson-Gluon Fusion event
          IDHW(NHEP+1)=IDHW(1)
          IDHW(NHEP+2)=13
          IDHW(NHEP+3)=15
          IDHW(NHEP+4)=LEPFIN
          IDHW(NHEP+5)=IFL
          IDHW(NHEP+6)=IFL+6
        ELSEIF (IFL.GE.7.AND.IFL.LE.18) THEN
C---QCD_Compton event
          IDHW(NHEP+1)=IDHW(1)
          IDHW(NHEP+2)=IFL-6
          IDHW(NHEP+3)=15
          IDHW(NHEP+4)=LEPFIN
          IDHW(NHEP+5)=IFL-6
          IDHW(NHEP+6)=13
        ELSEIF (IFL.EQ.164) THEN
C---gamma+gluon-->J/Psi+gluon
          IDHW(NHEP+1)=IDHW(1)
          IDHW(NHEP+2)=13
          IDHW(NHEP+3)=15
          IDHW(NHEP+4)=LEPFIN
          IDHW(NHEP+5)=164
          IDHW(NHEP+6)=13
        ELSE
          CALL HWWARN('HWHBGF',503,*999)
        ENDIF
      ELSE
C---Charged current event of specified flavours
        IDHW(NHEP+1)=IDHW(1)
        IDHW(NHEP+2)=13
        IDHW(NHEP+3)=15
        IDHW(NHEP+4)=LEPFIN
        IDHW(NHEP+5)=ID1
        IDHW(NHEP+6)=ID2
      ENDIF
C
      DO 1 I=NHEP+1,NHEP+6
    1 IDHEP(I)=IDPDG(IDHW(I))
C
C---Codes common for all processes
      ISTHEP(NHEP+1)=111
      ISTHEP(NHEP+2)=112
      ISTHEP(NHEP+3)=110
      ISTHEP(NHEP+4)=113
      ISTHEP(NHEP+5)=114
      ISTHEP(NHEP+6)=114
C
      DO I=NHEP+1,NHEP+6
        JMOHEP(1,I)=NHEP+3
        JDAHEP(1,I)=0
      ENDDO
C---Incoming lepton
      JMOHEP(2,NHEP+1)=NHEP+4
      JDAHEP(2,NHEP+1)=NHEP+4
C---Hard Process C.M.
      JMOHEP(1,NHEP+3)=NHEP+1
      JMOHEP(2,NHEP+3)=NHEP+2
      JDAHEP(1,NHEP+3)=NHEP+4
      JDAHEP(2,NHEP+3)=NHEP+6
C---Outgoing lepton
      JMOHEP(2,NHEP+4)=NHEP+1
      JDAHEP(2,NHEP+4)=NHEP+1
C
      IF (IFL.LE.6 .OR. CHARGD) THEN
C---Codes for boson-gluon fusion processes
C---  Incoming gluon
        JMOHEP(2,NHEP+2)=NHEP+6
        JDAHEP(2,NHEP+2)=NHEP+5
C---  Outgoing quark
        JMOHEP(2,NHEP+5)=NHEP+2
        JDAHEP(2,NHEP+5)=NHEP+6
C---  Outgoing antiquark
        JMOHEP(2,NHEP+6)=NHEP+5
        JDAHEP(2,NHEP+6)=NHEP+2
      ELSEIF (IFL.GE.7 .AND. IFL.LE.12) THEN
C---Codes for V+q --> q+g
C---  Incoming quark
        JMOHEP(2,NHEP+2)=NHEP+5
        JDAHEP(2,NHEP+2)=NHEP+6
C---  Outgoing quark
        JMOHEP(2,NHEP+5)=NHEP+6
        JDAHEP(2,NHEP+5)=NHEP+2
C---  Outgoing gluon
        JMOHEP(2,NHEP+6)=NHEP+2
        JDAHEP(2,NHEP+6)=NHEP+5
      ELSEIF (IFL.GE.13 .AND. IFL.LE.18) THEN
C---Codes for V+qbar --> qbar+g
C---  Incoming antiquark
        JMOHEP(2,NHEP+2)=NHEP+6
        JDAHEP(2,NHEP+2)=NHEP+5
C---  Outgoing antiquark
        JMOHEP(2,NHEP+5)=NHEP+2
        JDAHEP(2,NHEP+5)=NHEP+6
C---  Outgoing gluon
        JMOHEP(2,NHEP+6)=NHEP+5
        JDAHEP(2,NHEP+6)=NHEP+2
      ELSEIF (IFL.EQ.164) THEN
C---Codes for Gamma+gluon --> J/Psi+gluon
C---  Incoming gluon
        JMOHEP(2,NHEP+2)=NHEP+6
        JDAHEP(2,NHEP+2)=NHEP+6
C---  Outgoing J/Psi
        JMOHEP(2,NHEP+5)=NHEP+1
        JDAHEP(2,NHEP+5)=NHEP+1
C---  Outgoing gluon
        JMOHEP(2,NHEP+6)=NHEP+2
        JDAHEP(2,NHEP+6)=NHEP+2
      ENDIF
C---Computation of momenta in Laboratory frame of reference
      CALL HWHBKI
      NHEP=NHEP+6
C Decide which quark radiated and assign production vertices
      IF (IFL.LE.6) THEN
C Boson-Gluon fusion case
        IF (1-Z.LT.HWRGEN(0)) THEN
C Gluon splitting to quark
          CALL HWVZRO(4,VHEP(1,NHEP-1))
          CALL HWVDIF(4,PHEP(1,NHEP-4),PHEP(1,NHEP),PVRT)
          CALL HWUDKL(IFL,PVRT,VHEP(1,NHEP))
          CALL HWVEQU(4,VHEP(1,NHEP),VHEP(1,NHEP-4))
        ELSE
C Gluon splitting to antiquark
          CALL HWVZRO(4,VHEP(1,NHEP))
          CALL HWVDIF(4,PHEP(1,NHEP-4),PHEP(1,NHEP-1),PVRT)
          CALL HWUDKL(IFL,PVRT,VHEP(1,NHEP-1))
          CALL HWVEQU(4,VHEP(1,NHEP-1),VHEP(1,NHEP-4))
        ENDIF
      ELSEIF (IFL.GE.7.AND.IFL.LE.18) THEN
C QCD Compton case
        X=1/(1+SHAT/Q2)
        IF (1.LT.HWRGEN(0)*(1+(1-X-Z)**2+6*X*(1-X)*Z*(1-Z))) THEN
C Incoming quark radiated the gluon
          CALL HWVZRO(4,VHEP(1,NHEP-1))
          CALL HWVDIF(4,PHEP(1,NHEP-4),PHEP(1,NHEP),PVRT)
          CALL HWUDKL(IFL-6,PVRT,VHEP(1,NHEP))
          CALL HWVEQU(4,VHEP(1,NHEP),VHEP(1,NHEP-4))
        ELSE
C Outgoing quark radiated the gluon
          CALL HWVZRO(4,VHEP(1,NHEP-4))
          CALL HWVSUM(4,PHEP(1,NHEP-1),PHEP(1,NHEP),PVRT)
          CALL HWUDKL(IFL-6,PVRT,VHEP(1,NHEP))
          CALL HWVEQU(4,VHEP(1,NHEP),VHEP(1,NHEP-1))
        ENDIF
      ENDIF
C---HERWIG gets confused if lepton momentum is different from beam
C   momentum, which it can be if incoming hadron has negative virtuality
C   As a temporary fix, simply copy the momentum.
C   Momentum conservation somehow gets taken care of HWBGEN!
      call hwvequ(5,phep(1,1),phep(1,nhep-5))
      ELSE
        EVWGT=ZERO
C---generation of the 5 variables Y,Q2,SHAT,Z,PHI and Jacobian computation
C---in the largest phase space avalaible for selected processes and
C---filling of logical vector INSIDE to tag contributing ones
        CALL HWHBRN (*999)
C---calculate differential cross section corresponding to the chosen
C---variables and the weight for MC generation
        IF (IQK.EQ.0) THEN
C---many subprocesses included
          DO I=1,18
            FSIGMA(I)=ZERO
          ENDDO
          SIGSUM=ZERO
          DO I=IMIN,IMAX
            IF (INSIDE(I)) THEN
              IFL=I
              DSIGMA=ZERO
              CALL HWHBSG
              FSIGMA(I)=DSIGMA
              SIGSUM=SIGSUM+DSIGMA
            ENDIF
          ENDDO
          EVWGT=SIGSUM * AJACOB
        ELSE
C---only one subprocess included
          CALL HWHBSG
          EVWGT= DSIGMA * AJACOB
        ENDIF
        IF (EVWGT.LT.ZERO) EVWGT=ZERO
      ENDIF
  999 END
CDECK  ID>, HWHBKI.
*CMZ :-        -26/04/91  13.19.32  by  Federico Carminati
*-- Author :    Giovanni Abbiendi & Luca Stanco
C----------------------------------------------------------------------
      SUBROUTINE HWHBKI
C----------------------------------------------------------------------
C     gives the fourmomenta in the laboratory system for the particles
C     of the hard 2-->3 subprocess, to match with HERWIG routines of
C     jet evolution.
C----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWUECM,HWUPCM,HWUSQR,LEP,Y,Q2,SHAT,Z,PHI,AJACOB,
     & DSIGMA,ME,MP,ML,MREMIF(18),MFIN1(18),MFIN2(18),RS,SMA,W2,RSHAT,
     & PGAMMA(5),SG,MF1,MF2,EP,PP,EL,PL,E1,E2,Q1,COSBET,SINBET,COSTHE,
     & SINTHE,SINAZI,COSAZI,ROTAZI(3,3),EGAM,A,PPROT,MREMIN,PGAM,PEP(5),
     & COSPHI,SINPHI,ROT(3,3),EPROT,PROTON(5),MPART
      INTEGER IQK,IFLAVU,IFLAVD,IMIN,IMAX,IFL,IPROO,I,IHAD,J,IS,ICMF
      LOGICAL CHARGD,INCLUD(18),INSIDE(18)
      EXTERNAL HWUECM,HWUPCM,HWUSQR
      COMMON /HWAREA/ LEP,Y,Q2,SHAT,Z,PHI,AJACOB,DSIGMA,ME,MP,ML,MREMIF,
     & MFIN1,MFIN2,RS,SMA,W2,RSHAT,IQK,IFLAVU,IFLAVD,IMIN,IMAX,IFL,
     & IPROO,CHARGD,INCLUD,INSIDE
C
      IHAD=2
      IF (JDAHEP(1,IHAD).NE.0) IHAD=JDAHEP(1,IHAD)
C---Set masses
      IF (CHARGD) THEN
        MPART=ZERO
        MF1=RMASS(IDHW(NHEP+5))
        MF2=RMASS(IDHW(NHEP+6))
        MREMIN=MP
      ELSE
        IS = IFL
        IF (IFL.EQ.164) IS=IQK
        MPART=ZERO
        IF (IFL.GE.7.AND.IFL.LE.18) MPART=RMASS(IFL-6)
        MF1=MFIN1(IS)
        MF2=MFIN2(IS)
        MREMIN = MREMIF(IS)
      ENDIF
C---Calculation of kinematical variables for the generated event
C   in the center of mass frame of the incoming boson and parton
C   with parton along +z
      EGAM = HWUECM (SHAT, -Q2, MPART**2)
      PGAM = SQRT( EGAM**2 + Q2 )
      EP = RSHAT-EGAM
      PP = PGAM
      A = (W2+Q2-MP**2)/TWO
      PPROT = (A*PGAM-EGAM*SQRT(A**2+MP**2*Q2))/Q2
      IF (PPROT.LT.ZERO) CALL HWWARN('HWHBKI',101,*999)
      EPROT = SQRT(PPROT**2+MP**2)
      IF ((EPROT+PPROT).LT.(EP+PP)) CALL HWWARN('HWHBKI',102,*999)
      EL = ( PGAM / PPROT * SMA - Q2 ) / TWO
     +     / (EGAM + PGAM / PPROT * EPROT)
      IF (EL.GT.ME) THEN
        PL = SQRT ( EL**2 - ME**2 )
      ELSE
        CALL HWWARN ('HWHBKI',103,*999)
      ENDIF
      COSBET = (TWO * EPROT * EL - SMA) / (TWO * PPROT * PL)
      IF ( ABS(COSBET) .GE. ONE ) THEN
        COSBET = SIGN (ONE,COSBET)
        SINBET = ZERO
      ELSE
        SINBET = SQRT (ONE - COSBET**2)
      ENDIF
      SG = ME**2 + MPART**2 + Q2 + TWO * RSHAT * EL
      IF (SG.LE.(RSHAT+ML)**2 .OR. SG.GE.(RS-MREMIN)**2)
     +    CALL HWWARN ('HWHBKI',104,*999)
      Q1 = HWUPCM( RSHAT, MF1, MF2)
      E1 = SQRT(Q1**2+MF1**2)
      E2 = SQRT(Q1**2+MF2**2)
      IF (Q1 .GT. ZERO) THEN
        COSTHE=(TWO*EP*E1 - Z*(SHAT+Q2))/(TWO*PP*Q1)
        IF (ABS(COSTHE) .GT. ONE) THEN
          COSTHE=SIGN(ONE,COSTHE)
          SINTHE=ZERO
        ELSE
          SINTHE=SQRT(ONE-COSTHE**2)
        ENDIF
      ELSE
        COSTHE=ZERO
        SINTHE=ONE
      ENDIF
C---Initial lepton
      PHEP(1,NHEP+1)=PL*SINBET
      PHEP(2,NHEP+1)=ZERO
      PHEP(3,NHEP+1)=PL*COSBET
      PHEP(4,NHEP+1)=EL
      PHEP(5,NHEP+1)=RMASS(IDHW(1))
C---Initial Hadron
      PROTON(1)=ZERO
      PROTON(2)=ZERO
      PROTON(3)=PPROT
      PROTON(4)=EPROT
      CALL HWUMAS (PROTON)
C---Initial parton
      PHEP(1,NHEP+2)=ZERO
      PHEP(2,NHEP+2)=ZERO
      PHEP(3,NHEP+2)=PP
      PHEP(4,NHEP+2)=EP
      PHEP(5,NHEP+2)=MPART
C---HARD SUBPROCESS 2-->3 CENTRE OF MASS
      PHEP(1,NHEP+3)=PHEP(1,NHEP+1)+PHEP(1,NHEP+2)
      PHEP(2,NHEP+3)=PHEP(2,NHEP+1)+PHEP(2,NHEP+2)
      PHEP(3,NHEP+3)=PHEP(3,NHEP+1)+PHEP(3,NHEP+2)
      PHEP(4,NHEP+3)=PHEP(4,NHEP+1)+PHEP(4,NHEP+2)
      CALL HWUMAS  ( PHEP(1,NHEP+3) )
C---Virtual boson
      PGAMMA(1)=ZERO
      PGAMMA(2)=ZERO
      PGAMMA(3)=-PGAM
      PGAMMA(4)=EGAM
      PGAMMA(5)=HWUSQR(Q2)
C---Scattered lepton
      PHEP(1,NHEP+4)=PHEP(1,NHEP+1)-PGAMMA(1)
      PHEP(2,NHEP+4)=PHEP(2,NHEP+1)-PGAMMA(2)
      PHEP(3,NHEP+4)=PHEP(3,NHEP+1)-PGAMMA(3)
      PHEP(4,NHEP+4)=PHEP(4,NHEP+1)-PGAMMA(4)
      PHEP(5,NHEP+4)=RMASS(IDHW(1))
      IF (CHARGD) PHEP(5,NHEP+4)=ZERO
C---First Final parton:  quark (or J/psi) in Boson-Gluon Fusion
C---                     quark or antiquark in QCD Compton
      PHEP(1,NHEP+5)=Q1*SINTHE*COS(PHI)
      PHEP(2,NHEP+5)=Q1*SINTHE*SIN(PHI)
      PHEP(3,NHEP+5)=Q1*COSTHE
      PHEP(4,NHEP+5)=E1
      PHEP(5,NHEP+5)=MF1
C---Second Final parton: antiquark in Boson-Gluon Fusion
C---                     gluon in QCD Compton
      PHEP(1,NHEP+6)=-PHEP(1,NHEP+5)
      PHEP(2,NHEP+6)=-PHEP(2,NHEP+5)
      PHEP(3,NHEP+6)=-PHEP(3,NHEP+5)
      PHEP(4,NHEP+6)=E2
      PHEP(5,NHEP+6)=MF2
C---Boost to lepton-hadron CM frame
      PEP(1) = PHEP(1,NHEP+1)
      PEP(2) = PHEP(2,NHEP+1)
      PEP(3) = PHEP(3,NHEP+1) + PPROT
      PEP(4) = PHEP(4,NHEP+1) + EPROT
      CALL HWUMAS (PEP)
      DO I=1,6
        CALL HWULOF (PEP,PHEP(1,NHEP+I),PHEP(1,NHEP+I))
      ENDDO
      CALL HWULOF (PEP,PROTON,PROTON)
      CALL HWULOF (PEP,PGAMMA,PGAMMA)
C---Rotation around y-axis to align lepton beam with z-axis
      COSPHI = PHEP(3,NHEP+1) /
     &           SQRT( PHEP(1,NHEP+1)**2 + PHEP(3,NHEP+1)**2 )
      SINPHI = PHEP(1,NHEP+1) /
     &           SQRT( PHEP(1,NHEP+1)**2 + PHEP(3,NHEP+1)**2 )
      DO I=1,3
      DO J=1,3
        ROT(I,J)=ZERO
      ENDDO
      ENDDO
        ROT(1,1) = COSPHI
        ROT(1,3) = -SINPHI
        ROT(2,2) = ONE
        ROT(3,1) = SINPHI
        ROT(3,3) = COSPHI
      DO I=1,6
        CALL HWUROF (ROT,PHEP(1,NHEP+I),PHEP(1,NHEP+I))
      ENDDO
      CALL HWUROF (ROT,PROTON,PROTON)
      CALL HWUROF (ROT,PGAMMA,PGAMMA)
C---Boost to the LAB frame
      ICMF=3
      DO I=1,6
        CALL HWULOB (PHEP(1,ICMF),PHEP(1,NHEP+I),PHEP(1,NHEP+I))
      ENDDO
      CALL HWULOB (PHEP(1,ICMF),PROTON,PROTON)
      CALL HWULOB (PHEP(1,ICMF),PGAMMA,PGAMMA)
C---Random azimuthal rotation
      CALL HWRAZM (ONE,COSAZI,SINAZI)
      DO I=1,3
      DO J=1,3
        ROTAZI(I,J)=ZERO
      ENDDO
      ENDDO
        ROTAZI(1,1) = COSAZI
        ROTAZI(1,2) = SINAZI
        ROTAZI(2,1) = -SINAZI
        ROTAZI(2,2) = COSAZI
        ROTAZI(3,3) = ONE
      DO I=1,6
        CALL HWUROF (ROTAZI,PHEP(1,NHEP+I),PHEP(1,NHEP+I))
      ENDDO
      CALL HWUROF (ROTAZI,PROTON,PROTON)
      CALL HWUROF (ROTAZI,PGAMMA,PGAMMA)
  999 END
CDECK  ID>, HWHBRN.
*CMZ :-        -03/07/95  19.02.12  by  Giovanni Abbiendi
*-- Author :    Giovanni Abbiendi & Luca Stanco
C-----------------------------------------------------------------------
      SUBROUTINE HWHBRN (*)
C----------------------------------------------------------------------
C     Returns a point in the phase space (Y,Q2,SHAT,Z,PHI) and the
C     corresponding Jacobian factor AJACOB
C     Fill the logical vector INSIDE to tag contributing subprocesses
C     to the cross-section
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRUNI,HWRGEN,HWUPCM,LEP,Y,Q2,SHAT,Z,PHI,AJACOB,
     & DSIGMA,ME,MP,ML,MREMIF(18),MFIN1(18),MFIN2(18),RS,SMA,W2,RSHAT,
     & MF1,MF2,YMIN,YMAX,YJAC,Q2INF,Q2SUP,Q2JAC,EMW2,ZMIN,ZMAX,ZJAC,
     & GAMMA2,LAMBDA,PHIJAC,ZINT,ZLMIN,ZL,EMW,TMIN,TMAX,EMLMIN,EMLMAX,
     & SHMIN,EMMIF(18),EMMAF(18),WMIF(18),WMIN,MREMIN,YMIF(18),Q1CM(18),
     & Q2MAF(18),EMMAWF(18),ZMIF(18),ZMAF(18),PLMAX,PINC,SHINF,SHSUP,
     & SHJAC,CTHLIM,Q1,DETDSH,SRY,SRY0,SRY1
      INTEGER IQK,IFLAVU,IFLAVD,I,IMIN,IMAX,IFL,IPROO,IHAD,NTRY,DEBUG
      LOGICAL CHARGD,INCLUD(18),INSIDE(18)
      EXTERNAL HWRUNI,HWRGEN,HWUPCM
      SAVE EMLMIN,EMLMAX,EMMIF,EMMAF,MREMIN,MF1,MF2,YMIF,
     &     YMIN,YMAX,WMIN,WMIF
      COMMON /HWAREA/ LEP,Y,Q2,SHAT,Z,PHI,AJACOB,DSIGMA,ME,MP,ML,MREMIF,
     & MFIN1,MFIN2,RS,SMA,W2,RSHAT,IQK,IFLAVU,IFLAVD,IMIN,IMAX,IFL,
     & IPROO,CHARGD,INCLUD,INSIDE
      EQUIVALENCE (EMW,RMASS(198))
C
      IHAD=2
      IF (JDAHEP(1,IHAD).NE.0) IHAD=JDAHEP(1,IHAD)
C---Initialization
      IF (FSTWGT.OR.IHAD.NE.2) THEN
        ME = RMASS(IDHW(1))
        MP = RMASS(IDHW(IHAD))
        RS = PHEP(5,3)
        SMA = RS**2-ME**2-MP**2
        PINC = HWUPCM(RS,ME,MP)
C---Charged current
        IF (CHARGD) THEN
          ML=RMASS(IDHW(1)+1)
          YMAX = ONE - TWO*ML*MP / SMA
          YMAX = MIN(YMAX,YBMAX)
          MREMIN=MP
          IF (LEP.EQ.ONE) THEN
            MF1=RMASS(IFLAVD)
            MF2=RMASS(IFLAVU)
          ELSE
            MF1=RMASS(IFLAVU)
            MF2=RMASS(IFLAVD)
          ENDIF
          SHMIN = MF1**2+MF2**2 + TWO * PTMIN**2 +
     +            TWO * SQRT(PTMIN**2+MF1**2) * SQRT(PTMIN**2+MF2**2)
          EMLMIN=MAX(EMMIN,SQRT(SHMIN))
          EMLMAX=MIN(EMMAX,RS-ML-MREMIN)
          DEBUG=1
          IF (EMLMIN.GT.EMLMAX) GOTO 888
          WMIN=EMLMIN+MREMIN
          PLMAX=HWUPCM(RS,ML,WMIN)
          YMIN = ONE-TWO*(SQRT(PINC**2+MP**2)*SQRT(PLMAX**2+ML**2)+
     +                    PINC*PLMAX)/SMA
          YMIN = MAX(YMIN,YBMIN)
          DEBUG=2
          IF (YMIN.GT.YMAX) GOTO 888
        ELSE
C---Neutral current
          ML = ME
          YMAX = ONE - TWO*ML*MP / SMA
          YMAX = MIN(YMAX,YBMAX)
          DO I=1,18
            YMIF(I)=ZERO
            EMMIF(I)=ZERO
            EMMAF(I)=ZERO
            WMIF(I)=ZERO
            IF (I.LE.8) THEN
C---Boson-Gluon Fusion (also J/Psi) and QCD Compton with struck u or d
              MREMIF(I)=MP
              IF (I.LE.6) THEN
                MFIN1(I)=RMASS(I)
                MFIN2(I)=RMASS(I+6)
              ELSE
                MFIN1(I)=RMASS(I-6)
                MFIN2(I)=ZERO
              ENDIF
            ELSE
C---QCD Compton with struck non-valence parton
              MREMIF(I)=MP+RMASS(I-6)
              MFIN1(I)=RMASS(I-6)
              MFIN2(I)=ZERO
            ENDIF
          ENDDO
          IF (IFL.EQ.164) THEN
C---J/Psi
            MFIN1(7)=RMASS(164)
            MFIN2(7)=ZERO
          ENDIF
C---y boundaries for different flavours and processes
          DO 100 I=IMIN,IMAX
            IF (INCLUD(I)) THEN
              MF1=MFIN1(I)
              MF2=MFIN2(I)
              MREMIN=MREMIF(I)
              SHMIN = MF1**2+MF2**2 + TWO * PTMIN**2 +
     +              TWO * SQRT(PTMIN**2+MF1**2) * SQRT(PTMIN**2+MF2**2)
              EMMIF(I) = MAX(EMMIN,SQRT(SHMIN))
              EMMAF(I) = MIN(EMMAX,RS-ML-MREMIN)
              IF (EMMIF(I).GT.EMMAF(I)) THEN
                INCLUD(I)=.FALSE.
      write(6,*) emmin,emmax,shmin,rs,ml,mremin
                CALL HWWARN('HWHBRN',3,*999)
                GOTO 100
              ENDIF
              WMIF(I) = EMMIF(I)+MREMIF(I)
              WMIN = WMIF(I)
              PLMAX = HWUPCM(RS,ML,WMIN)
              YMIF(I)=ONE-TWO*(SQRT(PINC**2+MP**2)*SQRT(PLMAX**2+ML**2)+
     +                         PINC*PLMAX)/SMA
              IF (YMIF(I).GT.YMAX) THEN
                INCLUD(I)=.FALSE.
                CALL HWWARN('HWHBRN',4,*999)
                GOTO 100
              ENDIF
            ENDIF
 100      CONTINUE
C---considering the largest boundaries
          EMLMIN=EMMIF(IMIN)
          EMLMAX=EMMAF(IMIN)
          IF (IPROO.EQ.3) THEN
            EMLMIN=MIN(EMMIF(IMIN),EMMIF(IMIN+6))
            EMLMAX=MAX(EMMAF(IMIN),EMMAF(IMIN+6))
          ENDIF
          DEBUG=3
          IF (EMLMIN.GT.EMLMAX) GOTO 888
          YMIN=YMIF(IMIN)
          IF (IPROO.EQ.3) YMIN=MIN(YMIF(IMIN),YMIF(IMIN+6))
          YMIN = MAX(YMIN,YBMIN)
          DEBUG=4
          IF (YMIN.GT.YMAX) GOTO 888
          WMIN = WMIF(IMIN)
          MREMIN = MREMIF(IMIN)
          MF1=MFIN1(IMIN)
          MF2=MFIN2(IMIN)
          IF (IPROO.EQ.3) THEN
            WMIN = MIN(WMIF(IMIN),WMIF(IMIN+6))
            MREMIN = MIN(MREMIF(IMIN),MREMIF(IMIN+6))
          ENDIF
        ENDIF
      ENDIF
C---Random generation in largest phase space
      Y=ZERO
      Q2=ZERO
      SHAT=ZERO
      Z=ZERO
      PHI=ZERO
      AJACOB=ZERO
C---y generation
      IF (.NOT.CHARGD) THEN
        IF (IFL.LE.5.OR.(IFL.GE.7.AND.IFL.LE.18)) THEN
          SRY0 = SQRT(YMIN)
          SRY1 = SQRT(YMAX)
          SRY = HWRUNI(0,SRY0,SRY1)
          Y = SRY**2
          YJAC = TWO*SRY*(SRY1-SRY0)
        ELSEIF (IFL.EQ.6) THEN
          Y = SQRT(HWRUNI(0,YMIN**2,YMAX**2))
          YJAC = HALF * (YMAX**2-YMIN**2) / Y
        ELSEIF (IFL.EQ.164) THEN
C---in J/psi photoproduction Y and Q2 are given by the Equivalent Photon
C   Approximation
   10     NTRY=0
   20     NTRY=NTRY+1
          IF (NTRY.GT.NETRY) CALL HWWARN('HWHBRN',50,*10)
          Y = (YMIN/YMAX)**HWRGEN(1)*YMAX
          IF (ONE+(ONE-Y)**2.LT.TWO*HWRGEN(2)) GOTO 20
          YJAC=(TWO*LOG(YMAX/YMIN)-TWO*(YMAX-YMIN)
     &                            +HALF*(YMAX**2-YMIN**2))
        ENDIF
      ELSE
        IF (IPRO.EQ.5) THEN
          Y = EXP(HWRUNI(0,LOG(YMIN),LOG(YMAX)))
          YJAC = Y * LOG(YMAX/YMIN)
        ELSE
          Y = HWRUNI(0,YMIN,YMAX)
          YJAC = YMAX - YMIN
        ENDIF
      ENDIF
C---Q**2 generation
      Q2INF = ME**2*Y**2 / (ONE-Y)
      Q2SUP = MP**2 + SMA*Y - WMIN**2
      IF (IFL.EQ.164) THEN
        Q2INF = MAX(Q2INF,Q2WWMN)
        Q2SUP = MIN(Q2SUP,Q2WWMX)
      ELSE
        Q2INF = MAX(Q2INF,Q2MIN)
        Q2SUP = MIN(Q2SUP,Q2MAX)
      ENDIF
      DEBUG=5
      IF (Q2INF .GT. Q2SUP) GOTO 888
C
      IF (.NOT.CHARGD) THEN
        IF (IFL.EQ.164) THEN
          Q2 = EXP(HWRUNI(0,LOG(Q2INF),LOG(Q2SUP)))
          Q2JAC = LOG(Q2SUP/Q2INF)
        ELSEIF (Q2INF.LT.RMASS(4)**2) THEN
          Q2 = EXP(HWRUNI(0,LOG(Q2INF),LOG(Q2SUP)))
          Q2JAC = Q2 * LOG(Q2SUP/Q2INF)
        ELSE
          Q2 = Q2INF*Q2SUP/HWRUNI(0,Q2INF,Q2SUP)
          Q2JAC = Q2**2 * (Q2SUP-Q2INF)/(Q2SUP*Q2INF)
        ENDIF
      ELSE
        EMW2=EMW**2
        Q2=(Q2INF+EMW2)*(Q2SUP+EMW2)/(HWRUNI(0,Q2INF,Q2SUP)+EMW2)-EMW2
        Q2JAC=(Q2+EMW2)**2*(Q2SUP-Q2INF)/((Q2SUP+EMW2)*(Q2INF+EMW2))
      ENDIF
      W2 = MP**2 + SMA*Y - Q2
C---s_hat generation
      SHINF = EMLMIN **2
      SHSUP = (MIN(SQRT(W2)-MREMIN,EMLMAX))**2
      DEBUG=6
      IF (SHINF .GT. SHSUP) GOTO 888
C
      IF (IPRO.EQ.91) THEN
        IF (.NOT.CHARGD) THEN
          SHAT = SHINF*SHSUP/HWRUNI(0,SHINF,SHSUP)
          SHJAC = SHAT**2 * (SHSUP-SHINF)/(SHSUP*SHINF)
        ELSE
          SHAT = EXP(HWRUNI(0,LOG(SHINF),LOG(SHSUP)))
          SHJAC = SHAT*(LOG(SHSUP/SHINF))
        ENDIF
      ELSE
        EMW2=EMW**2
        IF (SHINF.GT.EMW2+10*GAMW*EMW) THEN
          SHAT = SHINF*SHSUP/HWRUNI(0,SHINF,SHSUP)
          SHJAC = SHAT**2 * (SHSUP-SHINF)/(SHSUP*SHINF)
        ELSEIF (SHSUP.LT.EMW2-10*EMW*GAMW) THEN
          SHAT = HWRUNI(0,SHINF,SHSUP)
          SHJAC = SHSUP-SHINF
        ELSE
          TMIN=ATAN((SHINF-EMW2)/(GAMW*EMW))
          TMAX=ATAN((SHSUP-EMW2)/(GAMW*EMW))
          SHAT = GAMW*EMW*TAN(HWRUNI(0,TMIN,TMAX))+EMW2
          SHJAC=((SHAT-EMW2)**2+(GAMW*EMW)**2)/(GAMW*EMW)*(TMAX-TMIN)
        ENDIF
      ENDIF
      DETDSH = ONE/SMA/Y
      SHJAC=SHJAC*DETDSH
      RSHAT = SQRT (SHAT)
C--- z generation
      ZMIN = 10E10
      ZMAX = -ONE
      IF (.NOT.CHARGD) THEN
        DO I=1,18
          Q1CM(I) = ZERO
          ZMIF(I) = ZERO
          ZMAF(I) = ZERO
        ENDDO
        DO 150 I=IMIN,IMAX
          IF (INCLUD(I)) THEN
            Q1CM(I) = HWUPCM( RSHAT, MFIN1(I), MFIN2(I) )
            IF (Q1CM(I) .LT. PTMIN) THEN
              ZMAF(I)=-ONE
              GOTO 150
            ENDIF
            CTHLIM = SQRT(ONE - (PTMIN / Q1CM(I))**2)
            GAMMA2 = SHAT + MFIN1(I)**2 - MFIN2(I)**2
            LAMBDA = (SHAT-MFIN1(I)**2-MFIN2(I)**2)**2 -
     +                4.D0*MFIN1(I)**2*MFIN2(I)**2
            ZMIF(I) = (GAMMA2 - SQRT(LAMBDA)*CTHLIM)/TWO/SHAT
            ZMIF(I) = MAX(ZMIF(I),ZERO)
            ZMAF(I) = (GAMMA2 + SQRT(LAMBDA)*CTHLIM)/TWO/SHAT
            ZMAF(I) = MIN(ZMAF(I),ONE)
            ZMIN = MIN( ZMIN, ZMIF(I) )
            ZMAX = MAX( ZMAX, ZMAF(I) )
          ENDIF
 150    CONTINUE
        IF (IFL.EQ.164) ZMAX=MIN(ZMAX,ZJMAX)
      ELSE
        Q1 = HWUPCM(RSHAT,MF1,MF2)
        DEBUG=7
        IF (Q1.LT.PTMIN) GOTO 888
        CTHLIM = SQRT(ONE-(PTMIN/Q1)**2)
        GAMMA2 = SHAT+MF1**2-MF2**2
        LAMBDA = (SHAT-MF1**2-MF2**2)**2-4.D0*MF1**2*MF2**2
        ZMIN = (GAMMA2-SQRT(LAMBDA)*CTHLIM)/TWO/SHAT
        ZMIN = MAX(ZMIN,1D-6)
        ZMAX = (GAMMA2+SQRT(LAMBDA)*CTHLIM)/TWO/SHAT
        ZMAX = MIN(ZMAX,ONE-1D-6)
      ENDIF
      DEBUG=8
      IF (ZMIN .GT. ZMAX) GOTO 888
      ZLMIN = LOG(ZMIN/(ONE-ZMIN))
      ZINT = LOG(ZMAX/(ONE-ZMAX)) - LOG(ZMIN/(ONE-ZMIN))
      ZL = ZLMIN+HWRGEN(0)*ZINT
      Z = EXP(ZL)/(ONE+EXP(ZL))
      ZJAC = Z*(ONE-Z)*ZINT
C
      DEBUG=9
      IF ((Y.LT.YMIN.OR.Y.GT.YMAX).OR.(Q2.LT.Q2INF.OR.Q2.GT.Q2SUP).OR.
     +   (SHAT.LT.SHINF.OR.SHAT.GT.SHSUP).OR.(Z.LT.ZMIN.OR.Z.GT.ZMAX))
     +     GOTO 888
C---Phi generation
      PHI = HWRUNI(0,ZERO,2*PIFAC)
      PHIJAC = 2 * PIFAC
      IF (IFL.EQ.164) PHIJAC=ONE
C
      AJACOB = YJAC * Q2JAC * SHJAC * ZJAC * PHIJAC
C
      IF (IQK.NE.0.OR.IPRO.EQ.5) GOTO 999
C---contributing subprocesses: filling of logical vector INSIDE
      DO I=1,18
        INSIDE(I)=.FALSE.
        Q2MAF(I)=ZERO
        EMMAWF(I)=ZERO
      ENDDO
      DO 200 I=IMIN,IMAX
      IF (INCLUD(I)) THEN
      IF ( Y.LT.YMIF(I) ) GOTO 200
C
      Q2MAF(I) = MP**2 + SMA*Y - WMIF(I)**2
      Q2MAF(I) = MIN( Q2MAF(I), Q2MAX)
      IF (Q2INF .GT. Q2MAF(I)) GOTO 200
      IF (Q2.LT.Q2INF .OR. Q2.GT.Q2MAF(I)) GOTO 200
C
      EMMAWF(I) = SQRT(W2) - MREMIF(I)
      EMMAWF(I) = MIN( EMMAWF(I), EMLMAX )
C
      IF (EMMIF(I) .GT. EMMAWF(I)) GOTO 200
      IF (SHAT.LT.EMMIF(I)**2.OR.SHAT.GT.EMMAWF(I)**2) GOTO 200
C
      IF (ZMIF(I) .GT. ZMAF(I)) GOTO 200
      IF (Z.LT.ZMIF(I) .OR. Z.GT.ZMAF(I)) GOTO 200
      INSIDE(I)=.TRUE.
      ENDIF
 200  CONTINUE
 999  RETURN
 888  EVWGT=ZERO
C---UNCOMMENT THIS LINE TO GET A DEBUGGING WARNING FOR NO PHASE-SPACE
C      CALL HWWARN('HWHBRN',DEBUG,*777)
 777  RETURN 1
      END
CDECK  ID>, HWHBSG.
*CMZ :-        -03/07/95  19.02.12  by  Giovanni Abbiendi
*-- Author :    Giovanni Abbiendi & Luca Stanco
C----------------------------------------------------------------------
      SUBROUTINE HWHBSG
C----------------------------------------------------------------------
C     Returns differential cross section DSIGMA in (Y,Q2,ETA,Z,PHI)
C     Scale for structure functions and alpha_s selected by BGSHAT
C----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWUALF,HWUAEM,LEP,Y,Q2,SHAT,Z,PHI,AJACOB,DSIGMA,
     & ME,MP,ML,MREMIF(18),MFIN1(18),MFIN2(18),RS,SMA,W2,RSHAT,
     & SFUN(13),ALPHA,LDSIG,DLQ(7),SG,XG,MF1,MF2,MSUM,MDIF,MPRO,FFUN,
     & GFUN,H43,H41,H11,H12,H14,H16,H21,H22,G11,G12,G1A,G1B,G21,G22,G3,
     & GC,A11,A12,A44,ALPHAS,PDENS,AFACT,BFACT,CFACT,DFACT,GAMMA,S,T,U,
     & MREMIN,POL,CCOL,ETA
      INTEGER IQK,IFLAVU,IFLAVD,IMIN,IMAX,IFL,IPROO,IHAD,ILEPT,IQ,IS
      LOGICAL CHARGD,INCLUD(18),INSIDE(18)
      EXTERNAL HWUALF,HWUAEM
      COMMON /HWAREA/ LEP,Y,Q2,SHAT,Z,PHI,AJACOB,DSIGMA,ME,MP,ML,MREMIF,
     & MFIN1,MFIN2,RS,SMA,W2,RSHAT,IQK,IFLAVU,IFLAVD,IMIN,IMAX,IFL,
     & IPROO,CHARGD,INCLUD,INSIDE
C
      IHAD=2
      IF (JDAHEP(1,IHAD).NE.0) IHAD=JDAHEP(1,IHAD)
C---set masses
      IF (CHARGD) THEN
        MREMIN=MP
        IF (LEP.EQ.ONE) THEN
          MF1=RMASS(IFLAVD)
          MF2=RMASS(IFLAVU)
        ELSE
          MF1=RMASS(IFLAVU)
          MF2=RMASS(IFLAVD)
        ENDIF
      ELSE
        IS=IFL
        IF (IFL.EQ.164) IS=IQK
        MREMIN = MREMIF(IS)
        MF1 = MFIN1(IS)
        MF2 = MFIN2(IS)
      ENDIF
C---choose subprocess scale
      IF (BGSHAT) THEN
        EMSCA = RSHAT
      ELSE
        S=SHAT+Q2
        IF (IFL.GE.7.AND.IFL.LE.18) S=SHAT+Q2-MF1**2
        T=-S*Z
        U=-S-T
        IF (IFL.GE.7.AND.IFL.LE.18) U=-S-T-2*MF1**2
        EMSCA = SQRT(TWO*S*T*U/(S**2+T**2+U**2))
        IF (IFL.EQ.164) EMSCA=SQRT(-U)
      ENDIF
      ALPHAS = HWUALF(1,EMSCA)
      IF (ALPHAS.GE.ONE.OR.ALPHAS.LE.ZERO) CALL HWWARN('HWHBSG',51,*888)
C---structure functions
      ETA = (SHAT+Q2)/SMA/Y
      IF (ETA.GT.ONE) ETA=ONE
      CALL HWSFUN (ETA,EMSCA,IDHW(IHAD),NSTRU,SFUN,2)
      XG = Q2/(SHAT + Q2)
      SG = ETA*SMA
      IF (SG.LE.(RSHAT+ML)**2.OR.SG.GE.(RS-MREMIN)**2) GOTO 888
C
      IF (IFL.EQ.164) GOTO 200
C
C---Electroweak couplings
      ALPHA=HWUAEM(-Q2)
      IF (CHARGD) THEN
        POL = PPOLN(3) - EPOLN(3)
        DLQ(1)=.0625*VCKM(IFLAVU/2,(IFLAVD+1)/2)/SWEIN**2 *
     +         Q2**2/((Q2+RMASS(198)**2)**2+(RMASS(198)*GAMW)**2) *
     +         (ONE + POL)
        DLQ(2)=ZERO
        DLQ(3)=DLQ(1)
      ELSE
        IQ=MOD(IFL-1,6)+1
        ILEPT=MOD(IDHW(1)-121,6)+11
        CALL HWUCFF(ILEPT,IQ,-Q2,DLQ(1))
      ENDIF
C
      IF (IFL.LE.6) THEN
C---For Boson-Gluon Fusion
        PDENS = SFUN(13)/ETA
        CCOL = HALF
        MSUM = (MF1**2 + MF2**2) / (Y*SG)
        MDIF = (MF1**2 - MF2**2) / (Y*SG)
        MPRO = MF1*MF2 / (Y*SG)
C
        FFUN = (1.D0-XG)*Z*(1.D0-Z) + (MDIF*(2.D0*Z-1.D0)-MSUM)/2.D0
        GFUN = (1.D0-XG)*(1.D0-Z) + XG*Z + MDIF
        IF ( FFUN .LT. ZERO ) FFUN = ZERO
        H43 = (8.D0*(2.D0*Z**2*XG-Z**2-2.D0*Z*XG+2.D0*Z*MDIF+Z-MDIF
     &         -MSUM)) / (Z*(1.D0-Z))**2
C
        H41 = (8.D0*(Z**2-Z*XG+Z*MDIF-MDIF-MSUM)) / (Z**2*(1.D0-Z))
C
        H11 = (4.D0*(2.D0*Z**4-4.D0*Z**3+2.D0*Z**2*MSUM*XG
     &         -2.D0*Z**2*MSUM+2.D0*Z**2*XG**2-2.D0*Z**2*XG+3.D0*Z**2
     &         +2.D0*Z*MDIF*MSUM+2.D0*Z*MDIF*XG-2.D0*Z*MSUM*XG
     &         +2.D0*Z*MSUM-2.D0*Z*XG**2+2.D0*Z*XG-Z-MDIF*MSUM-MDIF*XG
     &         -MSUM**2-MSUM*XG)) / (Z*(1.D0-Z))**2
C
        H12 = (16.D0*(-Z*MDIF+Z*XG+MDIF+MSUM))/(Z**2*(1.D0-Z))
C
        H14 = (16.D0*(-2.D0*Z**2*XG-2.D0*Z*MDIF+2.D0*Z*XG+MDIF+MSUM))
     &        / (Z*(1.D0-Z))**2
C
        H16 = (32.D0*(Z*MDIF-Z*XG-MDIF-MSUM)) / (Z**2*(1.D0-Z))
C
        H21 = (8.D0*MPRO*(-2.D0*Z**2*XG+2.D0*Z**2-2.D0*Z*MDIF+2.D0*Z*XG
     +         -2.D0*Z+MDIF+MSUM)) / (Z*(1.D0-Z))**2
C
        H22 = (-32.D0*MPRO) / (Z*(1.D0-Z))
C
        G11 = -2.D0*H11 + FFUN*H14
        G12 = 2.D0*XG*FFUN*H14 + H12 + GFUN * ( H16+GFUN*H14 )
        G1A = SQRT( XG*FFUN ) * ( H16 + 2.D0*GFUN*H14 )
        G1B = FFUN*H14
        G21 = -2.D0*H21
        G22 = H22
        G3  = H41 - GFUN*H43
        GC  = SQRT( XG*FFUN ) * (-2.D0*XG*H43 )
      ELSE
C---for QCD Compton, massless matrix element
        PDENS = SFUN(IFL-6)/ETA
        CCOL = CFFAC
        FFUN = XG*(ONE-XG)*Z*(ONE-Z)
        GFUN = (ONE-XG)*(ONE-Z)+XG*Z
        G11 = 8.D0*((Z**2+XG**2)/(ONE-XG)/(ONE-Z)+TWO*(XG*Z+ONE))
        G12 = 64.D0*XG**2*Z+TWO*XG*G11
        G1A = 32.D0*XG*GFUN*SQRT(FFUN)/((ONE-XG)*(ONE-Z))
        G1B = 16.D0*XG*Z
        G3  = -16.D0*(ONE-XG)*(ONE-Z)+G11
        GC  = -16.D0*XG*SQRT(FFUN)*(ONE-Z-XG)/((ONE-XG)*(ONE-Z))
        G21 = ZERO
        G22 = ZERO
      ENDIF
C
      A11 = XG * Y**2 * G11  +  (1.D0-Y) * G12
     &      - (2.D0-Y) * SQRT( 1.D0-Y ) * G1A  *  COS( PHI )
     &      + 2.D0 * XG * (1.D0-Y) * G1B  *  COS( 2.D0*PHI )
C
      A12 = XG * Y**2 * G21  +  (1.D0-Y) * G22
C
      A44 = XG * Y * (2.D0-Y) * G3
     &      - 2.D0 * Y * SQRT( 1.D0-Y ) * GC  *  COS( PHI )
C
      IF ( Y*Q2**2 .LT. 1D-38 ) THEN
C---prevent numerical uncertainties in DSIGMA computation
        DSIGMA = PDENS*ALPHA**2*ALPHAS*GEV2NB*CCOL/(16.D0*PIFAC)
     &           *(DLQ(1)*A11 + DLQ(2)*A12 + LEP*DLQ(3)*A44)
        IF ( DSIGMA .LE. ZERO ) GOTO 888
        LDSIG = LOG (DSIGMA) - LOG (Y) - 2.D0 * LOG (Q2)
        DSIGMA = EXP (LDSIG)
      ELSE
        DSIGMA = PDENS*ALPHA**2*ALPHAS*GEV2NB*CCOL
     &         * (DLQ(1)*A11 + DLQ(2)*A12 + LEP*DLQ(3)*A44)
     &         / (16.D0*PIFAC*Y*Q2**2)
      ENDIF
      IF (DSIGMA.LT.ZERO) GOTO 888
      RETURN
C
  200 CONTINUE
C--- J/psi production
      ALPHA = HWUAEM(-Q2)
      GAMMA = 4.8D-6
      PDENS = SFUN(13)/ETA
      AFACT = (8.D0*PIFAC*ALPHAS**2*RMASS(164)**3*GAMMA)/(3.D0*ALPHA)
      BFACT = ONE/(Y*SG*Z**2*((Z-ONE)*Y*SG-RMASS(164)**2)**2)
      CFACT = (RMASS(164)**2-Z*Y*SG)**2/(Y*SG*(ONE-XG)**2*
     &        ((ONE-XG)*Y*SG-RMASS(164)**2)**2*
     &        ((Z-ONE)*Y*SG-RMASS(164)**2)**2)
      DFACT = ((Z-ONE)*Y*SG)**2/(Y*SG*(ONE-XG)**2*
     &          ((ONE-XG)*Y*SG-RMASS(164)**2)**2*(Z*Y*SG)**2)
      DSIGMA = GEV2NB*ALPHA/(TWO*PIFAC)*AFACT*(BFACT+CFACT+DFACT)*PDENS
      IF (DSIGMA.LT.ZERO ) GOTO 888
      RETURN
 888  DSIGMA=ZERO
      END
CDECK  ID>, HWHDIS.
*CMZ :-        -26/04/91  14.55.44  by  Federico Carminati
*-- Author :    Giovanni Abbiendi & Luca Stanco
C----------------------------------------------------------------------
      SUBROUTINE HWHDIS
C----------------------------------------------------------------------
C     DEEP INELASTIC LEPTON-HADRON SCATTERING: MEAN EVWGT = SIGMA IN NB
C----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,HWRUNI,HWUPCM,PRAN,PROB,SAMP,SIG,Q2,
     & XBJ,Y,W,S,MLEP,MHAD,MLSCAT,LEP,YMIN,YMAX,XXMAX,Q2JAC,XXJAC,
     & JACOBI,A1,A2,A3,B1,B2,PCM,PCMEP,PCMLW,PCMEQ,PCMLQ,COSPHI,PA,
     & EQ,PZQ,SHAT,PROP,DLEFT,DRGHT,DUP,DWN,FACT,EFACT,OMY2,YPLUS,
     & YMNUS,SIGMA,AF(7,12),SMA,Q2SUP,HWUAEM,DCHRG,DNEUT
      INTEGER I,IQK,IQKIN,IQKOUT,IDSCAT,IHAD,ILEPT
      LOGICAL CHARGD
      EXTERNAL HWRGEN,HWRUNI,HWUPCM
      SAVE MLEP,MHAD,S,SMA,PCM,MLSCAT,A1,A2,A3,B1,B2,DLEFT,DRGHT,Q2,
     & AF,XBJ,Y,YPLUS,YMNUS,OMY2,FACT,EFACT,SIGMA,IDSCAT,CHARGD,
     & ILEPT,DCHRG,DNEUT,LEP
      IQK=MOD(IPROC,10)
      IHAD=2
      IF (JDAHEP(1,IHAD).NE.0) IHAD=JDAHEP(1,IHAD)
      IF (FSTWGT.OR.IHAD.NE.2) THEN
C---INITIALISE PROCESS (MUST BE DONE EVERY TIME IF S VARIES)
C---LEPTON AND HADRON MASSES, INVARIANT MASS, MOMENTUM IN C.M. FRAME
        MLEP=PHEP(5,1)
        MHAD=PHEP(5,IHAD)
        S=PHEP(5,3)**2
        SMA=S-MLEP**2-MHAD**2
        PCM=HWUPCM(SQRT(S),MLEP,MHAD)
C---LEP = 1 FOR LEPTONS, -1 FOR ANTILEPTONS
        IF (IDHW(1).GE.121.AND.IDHW(1).LE.126) THEN
          LEP=+ONE
        ELSEIF (IDHW(1).GE.127.AND.IDHW(1).LE.132) THEN
          LEP=-ONE
        ELSE
          CALL HWWARN('HWHDIS',500,*999)
        ENDIF
        DCHRG=FLOAT(MOD(IDHW(1)  ,2))
        DNEUT=FLOAT(MOD(IDHW(1)+1,2))
        ILEPT=MOD(IDHW(1)-121,6)+11
C---DLEFT,DRIGHT = 1,0 for leptons; = 0,1 for anti-leptons
        DLEFT=MAX(+LEP,ZERO)
        DRGHT=MAX(-LEP,ZERO)
        CHARGD=MOD(IPROC,100)/10.EQ.1
C---Evaluate constant factor in cross section and
C   find and store scattered lepton identity
        IF (CHARGD) THEN
          IF ((EPOLN(3)-PPOLN(3)).EQ.1.) THEN
             WRITE(6,5)
             CALL HWWARN('HWHDIS',501,*999)
  5          FORMAT(1X,'WARNING: Cross-section is zero for the',
     &                ' specified lepton helicity')
          ENDIF
          FACT=GEV2NB*(ONE-(EPOLN(3)-PPOLN(3)))*.25D0*PIFAC
     &        /(SWEIN*RMASS(198)**2)**2
          IDSCAT=IDHW(1)+NINT(DCHRG-DNEUT)
        ELSE
          FACT=GEV2NB*TWO*PIFAC
          IDSCAT=IDHW(1)
        ENDIF
        MLSCAT=RMASS(IDSCAT)
C---PARAMETERS USED FOR THE WEIGHT GENERATION IN NEUTRAL CURRENT
C   PROCESSES. ASSUME D(SIGMA)/D(Q**2) GOES LIKE A1+A2/Q**2+A3/Q**4
C   AND D(SIGMA)/D(X) LIKE B1+B2/X
        A1=0.5
        A2=0.5
        A3=1.
        B1=0.1
        B2=1.
      ENDIF
      IF (GENEV) THEN
C---GENERATE EVENT (KINEMATICAL VARIABLES AND STRUCTURE FUNCTION
C   ALREADY FOUND)
        PRAN=SIGMA*HWRGEN(0)
        IF (CHARGD) THEN
C---CHARGED CURRENT PROCESS
          IF (IQK.EQ.0) THEN
C---FIND FLAVOUR OF THE STRUCK QUARK (IF NOT SELECTED BY THE USER)
            PROB=ZERO
            DO 10 I=1,6
            DUP=MOD(I+1,2)
            DWN=MOD(I  ,2)
            PROB=PROB+EFACT*
     &          ((DCHRG*(DLEFT*DUP+DRGHT*DWN*OMY2)
     &           +DNEUT*(DLEFT*DWN+DRGHT*DUP*OMY2))*DISF(I  ,1)
     &          +(DCHRG*(DLEFT*DWN*OMY2+DRGHT*DUP)
     &           +DNEUT*(DLEFT*DUP*OMY2+DRGHT*DWN))*DISF(I+6,1))
            IF (PROB.GE.PRAN) GOTO 20
   10       CONTINUE
            I=6
   20       IQK=I
          ENDIF
          DUP=MOD(IQK+1,2)
          DWN=MOD(IQK  ,2)
          IQKIN=IQK
          IF ((LEP.EQ. 1.AND.MOD(IQK+IDHW(1),2).EQ.0)
     &    .OR.(LEP.EQ.-1.AND.MOD(IQK+IDHW(1),2).EQ.1)) IQKIN=IQK+6
C---FIND FLAVOUR OF THE OUTGOING QUARK
          PRAN=HWRGEN(0)
          PROB=ZERO
          IF (DUP.EQ.1.) THEN
            DO 30 I=1,3
            PROB=PROB+VCKM(IQK/2,I)
            IF (PROB.GE.PRAN) GOTO 40
   30       CONTINUE
            I=3
   40       IQKOUT=2*I-1
            IF (IQKIN.GT.6) IQKOUT=IQKOUT+6
          ELSE
            DO 50 I=1,3
            PROB=PROB+VCKM(I,(IQK+1)/2)
            IF (PROB.GE.PRAN) GOTO 60
   50       CONTINUE
            I=3
   60       IQKOUT=2*I
            IF (IQKIN.GT.6) IQKOUT=IQKOUT+6
          ENDIF
        ELSE
C---NEUTRAL CURRENT PROCESS
          IF (IQK.NE.0) THEN
            IQKIN=IQK
            PROB=EFACT*(AF(1,IQK)*YPLUS*DISF(IQK,1)+
     &              LEP*AF(3,IQK)*YMNUS*DISF(IQK,1))
            IF (PROB.LT.PRAN) IQKIN=IQK+6
          ELSE
C---FIND FLAVOUR OF THE STRUCK QUARK (IF NOT SELECTED BY THE USER)
            PROB=ZERO
            SIG=ONE
            DO 70 I=1,12
            IF (I.GT.6) SIG=-ONE
            PROB=PROB+EFACT*(AF(1,I)*YPLUS*DISF(I,1)+
     &               LEP*SIG*AF(3,I)*YMNUS*DISF(I,1))
            IF (PROB.GE.PRAN) GOTO 80
   70       CONTINUE
            I=12
   80       IQKIN=I
          ENDIF
          IQKOUT=IQKIN
        ENDIF
        IDN(1)=IDHW(1)
        IDN(2)=IQKIN
        IDN(3)=IDSCAT
        IDN(4)=IQKOUT
        ICO(1)=1
        ICO(2)=4
        ICO(3)=3
        ICO(4)=2
        XX(1)=1.
        XX(2)=XBJ
C---CHECK PHASE SPACE WITH THE SELECTED FLAVOUR. IF OUTSIDE THE
C   EVENT IS KILLED.
        PA=XBJ*(PHEP(4,IHAD)+ABS(PHEP(3,IHAD)))
        EQ=HALF*(PA+RMASS(IDN(2))**2/PA)
        PZQ=-(PA-EQ)
        SHAT=(PHEP(4,1)+EQ)**2-(PHEP(3,1)+PZQ)**2
        PCMEQ=HWUPCM(SQRT(SHAT),MLEP,RMASS(IDN(2)))
        PCMLQ=HWUPCM(SQRT(SHAT),MLSCAT,RMASS(IDN(4)))
        IF (PCMLQ.LT.0.) THEN
          CALL HWWARN('HWHDIS',101,*999)
        ELSEIF (PCMLQ.EQ.0.) THEN
          COSTH=ZERO
        ELSE
          COSTH=(TWO*SQRT(PCMEQ**2+MLEP**2)*SQRT(PCMLQ**2+MLSCAT**2)
     &         -(Q2+MLEP**2+MLSCAT**2))/(TWO*PCMEQ*PCMLQ)
        ENDIF
        IF (ABS(COSTH).GT.ONE) CALL HWWARN('HWHDIS',102,*999)
        IDCMF=15
        CALL HWETWO
      ELSE
        EVWGT=ZERO
        IF (CHARGD) THEN
C---CHOOSE X,Y (CC PROCESS)
          YMIN=MAX(YBMIN,Q2MIN/SMA)
          YMAX=MIN(YBMAX,ONE)
          IF (YMIN.GT.YMAX) GOTO 999
          Y=HWRUNI(0,YMIN,YMAX)
          XXMIN=Q2MIN/S/Y
          XXMAX=MIN(Q2MAX/SMA/Y,ONE)
          IF (XXMIN.GT.XXMAX) GOTO 999
          XBJ=HWRUNI(0,XXMIN,XXMAX)
          Q2=XBJ*Y*(S-MLEP**2-MHAD**2)
          JACOBI=(YMAX-YMIN)*(XXMAX-XXMIN)*(S-MLEP**2-MHAD**2)*XBJ
        ELSE
C---CHOOSE X,Q**2 (NC PROCESS)
          Q2SUP=MIN(Q2MAX,SMA*YBMAX)
          IF (Q2MIN.GT.Q2SUP) GOTO 999
          SAMP=(A1+A2+A3)*HWRGEN(0)
          IF (SAMP.LE.A1) THEN
            Q2=HWRUNI(0,Q2MIN,Q2SUP)
          ELSEIF (SAMP.LE.(A1+A2)) THEN
            Q2=EXP(HWRUNI(0,LOG(Q2MIN),LOG(Q2SUP)))
          ELSE
            Q2=-ONE/HWRUNI(0,-ONE/Q2MIN,-ONE/Q2SUP)
          ENDIF
          Q2JAC=(A1+A2+A3)/
     &      (A1/(Q2SUP-Q2MIN)
     &      +A2/LOG(Q2SUP/Q2MIN)/Q2
     &      +A3*Q2MIN*Q2SUP/(Q2SUP-Q2MIN)/Q2**2)
          XXMIN=Q2/SMA/YBMAX
          XXMAX=ONE
          IF (YBMIN.GT.ZERO) XXMAX=MIN(Q2/SMA/YBMIN,ONE)
          IF (XXMIN.GT.XXMAX) GOTO 999
          SAMP=(B1+B2)*HWRGEN(0)
          IF (SAMP.LE.B1) THEN
            XBJ=HWRUNI(0,XXMIN,XXMAX)
          ELSE
            XBJ=EXP(HWRUNI(0,LOG(XXMIN),LOG(XXMAX)))
          ENDIF
          XXJAC=(B1+B2)/(B1/(XXMAX-XXMIN)+B2/LOG(XXMAX/XXMIN)/XBJ)
          Y=Q2/(S-MLEP**2-MHAD**2)/XBJ
          JACOBI=Q2JAC*XXJAC
        ENDIF
C---CHECK IF THE GENERATED POINT IS INSIDE PHASE SPACE. IF NOT
C   RETURN WITH WEIGHT EQUAL TO ZERO.
        W=SQRT(MHAD**2+Q2*(ONE-XBJ)/XBJ)
        IF (W.LT.WHMIN) RETURN
        PCMEP=PCM
        PCMLW=HWUPCM(SQRT(S),MLSCAT,W)
        IF (PCMLW.LT.ZERO) THEN
          EVWGT=ZERO
          RETURN
        ELSEIF (PCMLW.EQ.ZERO) THEN
          COSPHI=ZERO
        ELSE
          COSPHI=
     &    (TWO*SQRT(PCMEP**2+MLEP**2)*SQRT(PCMLW**2+MLSCAT**2)
     &    -(Q2+MLEP**2+MLSCAT**2))/(TWO*PCMEP*PCMLW)
        ENDIF
        IF (ABS(COSPHI).GT.ONE) THEN
          EVWGT=ZERO
          RETURN
        ENDIF
C---SET SCALE EQUAL Q. EVALUATE STRUCTURE FUNCTIONS.
        EMSCA=SQRT(Q2)
        CALL HWSFUN(XBJ,EMSCA,IDHW(IHAD),NSTRU,DISF,2)
C---SWITCH OFF ANY FLAVOURS THAT ARE BELOW THRESHOLD
        DO 90 I=1,12
 90     IF (W.LT.2*RMASS(I)) DISF(I,1)=0
C---EVALUATE DIFFERENTIAL CROSS SECTION
        IF (CHARGD) THEN
          PROP=RMASS(198)**2/(Q2+RMASS(198)**2)
          EFACT=FACT*(HWUAEM(-Q2)*PROP)**2/XBJ
          OMY2=(ONE-Y)**2
          SIGMA=ZERO
          DO 100 I=1,6
          DUP=MOD(I+1,2)
          DWN=MOD(I  ,2)
          IF (IQK.NE.0.AND.IQK.NE.I) GOTO 100
          SIGMA=SIGMA+EFACT*
     &        ((DCHRG*(DLEFT*DUP+DRGHT*DWN*OMY2)
     &         +DNEUT*(DLEFT*DWN+DRGHT*DUP*OMY2))*DISF(I  ,1)
     &        +(DCHRG*(DLEFT*DWN*OMY2+DRGHT*DUP)
     &         +DNEUT*(DLEFT*DUP*OMY2+DRGHT*DWN))*DISF(I+6,1))
  100     CONTINUE
        ELSE
          EFACT=FACT/XBJ*(HWUAEM(-Q2)/Q2)**2
          YPLUS=ONE+(ONE-Y)**2
          YMNUS=ONE-(ONE-Y)**2
          DO 110 I=1,6
          CALL HWUCFF(ILEPT,I,-Q2,AF(1,I))
          AF(1,I+6)=AF(1,I)
          AF(3,I+6)=AF(3,I)
  110     CONTINUE
          SIGMA=ZERO
          DO 200 I=1,6
          IF (IQK.NE.0.AND.IQK.NE.I) GOTO 200
          SIGMA=SIGMA+EFACT*(AF(1,I)*YPLUS*(DISF(I,1)+DISF(I+6,1))+
     &                   LEP*AF(3,I)*YMNUS*(DISF(I,1)-DISF(I+6,1)))
  200     CONTINUE
        ENDIF
C---FIND WEIGHT: DIFFERENTIAL CROSS SECTION TIME THE JACOBIAN FACTOR
        EVWGT=SIGMA*JACOBI
        IF (EVWGT.LT.ZERO) EVWGT=ZERO
      ENDIF
  999 END
CDECK  ID>, HWHDYP.
*CMZ :-        -16/07/96  12.41.07  by  Mike Seymour
*-- Author :    Bryan Webber, Ian Knowles and Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HWHDYP
C-----------------------------------------------------------------------
C     Drell-Yan Production of fermion pairs via photon, Z0 & (if ZPRIME)
C     Z' exchange. Lepton universality is assumed for photon and Z, and
C     for Z' if no lepton flavour is specified.
C     MEAN EVWGT = SIGMA IN NB
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,HWRUNI,HWUAEM,EPS,C1,C2,C3,EMSQZ,EMGMZ,
     & EMSQZP,EMGMZP,CQF(7,6,16),QPOW,RPOW,A01,A1,A02,A2,A03,A3,CRAN,
     & EMJ1,EMJ2,EMJ3,EMJAC,FACT,QSQ,HCS,FACTR,RCS,EXTRA,PMAX,PTHETA
      INTEGER IMODE,JQMN,JQMX,JQ,JLMN,JLMX,JL,IQ,I,IADD1,IADD2,ID1,ID2,
     & ID3,ID4,JF
      EXTERNAL HWRGEN,HWRUNI,HWUAEM
      SAVE HCS,JQMN,JQMX,JLMN,JLMX,C1,C2,C3,QPOW,RPOW,EMSQZ,EMGMZ,
     & A1,A01,A2,A02,A3,A03,EMSQZP,EMGMZP,FACT,CQF
      PARAMETER (EPS=1.D-9)
      IF (GENEV) THEN
        RCS=HCS*HWRGEN(0)
      ELSE
        IF (FSTWGT) THEN
C Set limits for which particles to include
          JLMN=1
          JLMX=0
          JQMN=1
          JQMX=0
          IMODE=MOD(IPROC,100)
          IF (IMODE.EQ.0) THEN
            JQMN=1
            JQMX=6
          ELSEIF (IMODE.LE.10) THEN
            JQMN=IMODE
            JQMX=IMODE
          ELSEIF (IMODE.EQ.50) THEN
            JLMN=11
            JLMX=16
          ELSEIF (IMODE.GE.50.AND.IMODE.LE.60) THEN
            JLMN=IMODE-40
            JLMX=IMODE-40
          ELSEIF (IMODE.EQ.99) THEN
            JQMN=1
            JQMX=6
            JLMN=11
            JLMX=16
          ELSE
            CALL HWWARN('HWHDYP',500,*999)
          ENDIF
C Set up parameters for importance sampling:
C sum of power law and two Breit-Wigners (relative weights C1,C2,C3)
          C1=ONE
          C2=ONE
          C3=ZERO
          IF (ZPRIME) C3=ONE
          IF (EMPOW.EQ.1) CALL HWWARN('HWHDYP',501,*999)
          IF (C2.EQ.0) CALL HWWARN('HWHDYP',502,*999)
          IF (C3.EQ.0.AND.ZPRIME) CALL HWWARN('HWHDYP',503,*999)
          QPOW=-EMPOW+1
          RPOW=1/QPOW
          EMSQZ=RMASS(200)**2
          EMGMZ=RMASS(200)*GAMZ
          A01=EMMIN**QPOW
          A1=(EMMAX**QPOW-A01)/C1
          A02=ATAN((EMMIN**2-EMSQZ)/EMGMZ)
          A2=(ATAN((EMMAX**2-EMSQZ)/EMGMZ)-A02)/C2
          IF (C3.GT.0) THEN
            EMSQZP=RMASS(202)**2
            EMGMZP=RMASS(202)*GAMZP
            A03=ATAN((EMMIN**2-EMSQZP)/EMGMZP)
            A3=(ATAN((EMMAX**2-EMSQZP)/EMGMZP)-A03)/C3
          ENDIF
        ENDIF
        EVWGT=0.
C Select a mass for the produced pair
        CRAN=(C1+C2+C3)*HWRGEN(1)
        IF (CRAN.LT.C1) THEN
C Use power law
          EMSCA=(A01+A1*CRAN)**RPOW
          QSQ=EMSCA**2
        ELSEIF (CRAN.LT.C1+C2) THEN
C Use Z Breit-Wigner
          CRAN=CRAN-C1
          QSQ=EMSQZ+EMGMZ*TAN(A02+A2*CRAN)
          EMSCA=SQRT(QSQ)
        ELSE
C Use Z' Breit-Wigner
          CRAN=CRAN-C1-C2
          QSQ=EMSQZP+EMGMZP*TAN(A03+A3*CRAN)
          EMSCA=SQRT(QSQ)
        ENDIF
        EMJ1=EMSCA**EMPOW/(1-EMPOW)*A1
        EMJ2=((QSQ-EMSQZ)**2+EMGMZ**2)/(2*EMSCA*EMGMZ)*A2
        IF (C3.GT.0) THEN
          EMJ3=((QSQ-EMSQZP)**2+EMGMZP**2)/(2*EMSCA*EMGMZP)*A3
          EMJAC=(C1+C2+C3)/(1/EMJ1+1/EMJ2+1/EMJ3)
        ELSE
          EMJAC=(C1+C2)/(1/EMJ1+1/EMJ2)
        ENDIF
C Select initial momentum fractions
        XXMIN=QSQ/PHEP(5,3)**2
        XLMIN=LOG(XXMIN)
        CALL HWSGEN(.TRUE.)
        FACT=-GEV2NB*HWUAEM(QSQ)**2*PIFAC*16.*EMJAC*XLMIN/
     &       (3.*EMSCA)**3
C Store cross-section coefficients
        DO 50 IQ=1,6
        DO 30 JQ=JQMN,JQMX
        IF (EMSCA.GT.2.*RMASS(JQ)) THEN
          CALL HWUCFF(IQ,JQ,QSQ,CQF(1,IQ,JQ))
        ELSE
          CALL HWVZRO(7,CQF(1,IQ,JQ))
        ENDIF
  30    CONTINUE
        DO 40 JL=JLMN,JLMX
        IF (EMSCA.GT.2.*RMASS(JQ)) THEN
          CALL HWUCFF(IQ,JL,QSQ,CQF(1,IQ,JL))
        ELSE
          CALL HWVZRO(7,CQF(1,IQ,JL))
        ENDIF
  40    CONTINUE
  50    CONTINUE
      ENDIF
C
      HCS=0.
      DO 90 I=1,2
      IF (I.EQ.1) THEN
C Quark first
        IADD1=0
        IADD2=6
      ELSE
C Anti-quark first
        IADD1=6
        IADD2=0
      ENDIF
      DO 80 IQ=1,6
      ID1=IQ+IADD1
      ID2=IQ+IADD2
      IF (DISF(ID1,1).LT.EPS.OR.DISF(ID2,2).LT.EPS) GOTO 80
      FACTR=FACT*DISF(ID1,1)*DISF(ID2,2)
C Quark final states
      DO 60 JQ=JQMN,JQMX
      ID3=JQ
      ID4=JQ+6
      IF (IQ.EQ.JQ) THEN
        HCS=HCS+FACTR*(CQF(1,IQ,JQ)+2*QFCH(IQ)**4)*FLOAT(NCOLO)
        IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID3,ID4,2143,50,*99)
      ELSE
        HCS=HCS+FACTR*CQF(1,IQ,JQ)*FLOAT(NCOLO)
        IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID3,ID4,2143,50,*99)
      ENDIF
  60  CONTINUE
C Lepton final states
      DO 70 JL=JLMN,JLMX
      ID3=110+JL
      ID4=ID3+6
      HCS=HCS+FACTR*CQF(1,IQ,JL)
      IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID3,ID4,2134,50,*99)
  70  CONTINUE
  80  CONTINUE
  90  CONTINUE
      EVWGT=HCS
      RETURN
C Generate event
  99  IDN(1)=ID1
      IDN(2)=ID2
      IDCMF=200
      IF (ID3.LE.6) THEN
        JF=JQ
      ELSE
        JF=JL
      ENDIF
C Select polar angle from distribution:
C CQF(1,IQ,JF)*(1.+COSTH**2)+CQF(3,IQ,JF)*COSTH+EXTRA*(1-COSTH)
      IF (ID1.EQ.ID3) THEN
        EXTRA=QFCH(ID1)**4
      ELSE
        EXTRA=0
      ENDIF
      PMAX=2.*(CQF(1,IQ,JF)+EXTRA)+ABS(CQF(3,IQ,JF))
  100 COSTH=HWRUNI(0,-ONE,ONE)
      PTHETA=CQF(1,IQ,JF)*(1.+COSTH**2)+CQF(3,IQ,JF)*COSTH
     &      +EXTRA*(1.-COSTH)
      IF (PTHETA.LT.PMAX*HWRGEN(1)) GOTO 100
      IF (ID1.GT.ID2) COSTH=-COSTH
      IDCMF=200
      CALL HWETWO
  999 END
CDECK  ID>, HWHEGG.
*CMZ :-        -19/03/92  10.13.56  by  Mike Seymour
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HWHEGG
C----------------------------------------------------------------------
C     HARD PROCESS: EE --> EEGAMGAM --> EEFFBAR/WW
C     MEAN EVENT WEIGHT = CROSS-SECTION IN NB
C     AFTER CUTS ON PT AND MASS OF CENTRE-OF-MASS SYSTEM
C     AND COS(THETA) IN CENTRE-OF-MASS SYSTEM
C     AND TIMES BRANCHING FRACTION IF WW
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,HWULDO,EMSQ,BETA,S,T,U,TMIN,TMAX,TRAT,
     & DSDT,PROB,X,Z(2),ZMIN,ZMAX,PCMIN,PCMAX,PCFAC,PLOGMI,PLOGMA,PTCMF,
     & Q,PC,BLOG,EMCMIN,EMCMAX,EMLMIN,EMLMAX,WGT(6),RWGT,CV,CA,BR,QT(2),
     & QX(2),QY(2),PX,PY,ROOTS,DOT,A,B,C,SHAT,PCF(2),PCM(2),PCMAC,ZZ(2),
     & COLFAC
      INTEGER I,IGAM,ID,IDL,ID1,ID2,IHEP,JHEP,NADD,NTRY,NQ,JGAM
      LOGICAL HWRLOG
      EXTERNAL HWRGEN,HWULDO,HWRLOG
      SAVE S,BETA,X,ID,NQ,WGT,EMLMIN,EMLMAX,PCFAC,PLOGMA,PLOGMI,SHAT,
     &  PCF,PCM,Z,PCMAC,NADD
      IF (IERROR.NE.0) RETURN
C---INITIALIZE LOCAL COPIES OF EMMIN,EMMAX
      IF (FSTWGT) THEN
        EMLMIN=EMMIN
        EMLMAX=EMMAX
      ENDIF
      IF (.NOT.GENEV) THEN
C---CHOOSE Z1,Z2 AND CALCULATE SUB-PROCESS CROSS-SECTION
        EVWGT=0
C-----FIND FINAL STATE PARTICLES
        IHPRO=MOD(IPROC,100)
        IF (IHPRO.EQ.0) THEN
          ID=1
          NQ=6
          COLFAC=FLOAT(NCOLO)
          NADD=6
        ELSEIF (IHPRO.LE.6) THEN
          ID=IHPRO
          NQ=1
          COLFAC=FLOAT(NCOLO)
          NADD=6
          Q=QFCH(ID)
        ELSEIF (IHPRO.LE.9) THEN
          ID=119+2*(IHPRO-6)
          NQ=1
          COLFAC=1.
          NADD=6
          Q=QFCH(ID-110)
        ELSEIF (IHPRO.LE.10) THEN
          ID=198
          NQ=1
          NADD=1
        ELSE
          CALL HWWARN('HWHEGG',200,*999)
        ENDIF
C-----SPLIT ELECTRONS TO PHOTONS
        NHEP=3
        GAMWT=1
        S=2*HWULDO(PHEP(1,1),PHEP(1,2))
        ROOTS=SQRT(S)
        EMCMIN=MAX(EMLMIN,MAX(2*RMASS(ID),PTMIN))
        EMCMAX=MIN(EMLMAX,ROOTS)
        IF (EMCMIN.GT.EMCMAX) RETURN
        ZMIN=EMCMIN**2/S
        ZMAX=1-PHEP(5,1)/PHEP(4,1)
        IF (ZMIN.GT.ZMAX) RETURN
        CALL HWEGAM(1,ZMIN,ZMAX,.TRUE.)
        Z(1)=PHEP(4,NHEP-1)/PHEP(4,1)
        ZMIN=EMCMIN**2/(Z(1)*S)
        ZMAX=MIN(EMCMAX**2/(Z(1)*S), ONE-PHEP(5,2)/PHEP(4,2))
        IF (ZMIN.GT.ZMAX) RETURN
        CALL HWEGAM(2,ZMIN,ZMAX,.TRUE.)
        Z(2)=PHEP(4,NHEP-1)/PHEP(4,2)
        EMSCA=PHEP(5,3)
        SHAT=EMSCA**2
C-----REMOVE LOG TERMS FROM WEIGHT, CALCULATE NEW ONES FROM PT LIMITS
        GAMWT=GAMWT/(0.5*LOG((1-Z(1))*S/(Z(1)*PHEP(5,1)**2))
     &              *0.5*LOG((1-Z(2))*Z(1)*S/(Z(2)*PHEP(5,2)**2)))
        PCF(1)=Z(1)*PHEP(5,1)
        PCF(2)=Z(2)*PHEP(5,2)
        PCFAC=SQRT(PCF(1)*PCF(2))
        PCM(1)=(1-Z(1))*PHEP(4,1)
        PCM(2)=(1-Z(2))*PHEP(4,2)
        PCMAC=SQRT(PCM(1)*PCM(2))
        PCMIN=MAX(PTMIN,MAX(PCF(1),PCF(2)))
        PCMAX=MIN( MIN(PTMAX,PHEP(5,3)) , MIN(PCM(1),PCM(2)) )
        IF (PCMIN.GT.PCMAX) RETURN
        PLOGMI=(LOG(PCMIN/PCFAC))**2
        PLOGMA=(LOG(PCMAX/PCFAC))**2
        GAMWT=GAMWT*(PLOGMA-PLOGMI)
C-----CALCULATE CROSS-SECTION
        DO 10 IDL=1,NQ
          WGT(IDL)=EVWGT
          IF (IHPRO.EQ.0) THEN
            ID=IDL
            Q=QFCH(ID)
          ENDIF
          EMSQ=RMASS(ID)**2
          X=4*EMSQ/SHAT
          IF (X.GT.1) GOTO 10
          BETA=SQRT(1-X)
          BLOG=LOG((1+BETA*CTMAX)/(1-BETA*CTMAX))/BETA
          IF (IHPRO.LE.9) THEN
            EVWGT=EVWGT+GEV2NB*4*PIFAC*COLFAC*Q**4*ALPHEM**2*BETA
     &           /SHAT * GAMWT * ( (1+X-0.5*X**2)*BLOG
     &                     - CTMAX*(1+X**2/(CTMAX**2*(X-1)+1)) )
            WGT(IDL)=EVWGT
          ELSE
            CALL HWDBOZ(198,ID1,ID2,CV,CA,BR,1)
            CALL HWDBOZ(199,ID1,ID2,CV,CA,BR,1)
            EVWGT=EVWGT + GEV2NB*6*PIFAC*ALPHEM**2*BETA/SHAT*BR
     &        * GAMWT * (-(  X-0.5*X**2)*BLOG
     &                     + CTMAX*(1+(X**2+16/3.)/(CTMAX**2*(X-1)+1)) )
          ENDIF
 10     CONTINUE
C-----GAMWT MUST BE RESET TO ONE, SINCE IT IS REAPPLIED LATER!
        GAMWT=ONE
      ELSE
C---GENERATE EVENT
C-----CHOOSE PT OF THE CMF
        PTCMF=PCFAC*EXP(SQRT(HWRGEN(0)*(PLOGMA-PLOGMI)+PLOGMI))
C-----CHOOSE WHICH PHOTON USUALLY HAS SMALLER PT
        NTRY=0
 20     IGAM=1
        IF (LOG(PCM(1)/PCF(1)).LT.HWRGEN(1)*2*LOG(PCMAC/PCFAC)) IGAM=2
        JGAM=3-IGAM
C-----CHOOSE ITS PT
 30     NTRY=NTRY+1
        IF (NTRY.GT.NBTRY) CALL HWWARN('HWHEGG',100,*999)
        QT(IGAM)=(PCM(IGAM)/PCF(IGAM))**HWRGEN(2)
        PROB=(QT(IGAM)**2/(QT(IGAM)**2+1))**2
        QT(IGAM)=QT(IGAM)*PCF(IGAM)
        IF (HWRLOG(1-PROB)) GOTO 30
C-----CHOOSE ITS DIRECTION
        CALL HWRAZM(QT(IGAM),QX(IGAM),QY(IGAM))
C-----CALCULATE THE OTHER PHOTON'S PT
        QX(JGAM)=PTCMF-QX(IGAM)
        QY(JGAM)=     -QY(IGAM)
        QT(JGAM)=SQRT(QX(JGAM)**2+QY(JGAM)**2)
        IF (QT(JGAM).LT.PCF(JGAM).OR.QT(JGAM).GT.PCM(JGAM)) GOTO 20
C-----APPLY A RANDOM ROTATION AROUND THE BEAM AXIS
        CALL HWRAZM(ONE,PX,PY)
        IF (PX.EQ.0) PX=1D-20
        QX(1)=(QX(1)*PX   -QY(1)*PY)
        QY(1)=(QY(1)      +QX(1)*PY)/PX
        QX(2)=(QX(2)*PX   -QY(2)*PY)
        QY(2)=(QY(2)      +QX(2)*PY)/PX
C-----RECONSTRUCT MOMENTA
        IF (QT(IGAM).GT.QT(JGAM)) THEN
          IGAM=3-IGAM
          JGAM=3-JGAM
        ENDIF
        DOT=-Z(JGAM)*S+SHAT+2*(QX(1)*QX(2)+QY(1)*QY(2))
C-------SOLVE QUADRATIC IN Z(IGAM) TO FIND ELECTRON ENERGIES
        A=S*(S*Z(JGAM)+QT(JGAM)**2)
        B=S*DOT*(1+Z(JGAM))
        C=DOT**2+S*QT(IGAM)**2*(1-Z(JGAM))**2-4*QT(IGAM)**2*QT(JGAM)**2
        IF (B**2.LT.4*A*C) GOTO 20
        ZZ(IGAM)=(-B+SQRT(B**2-4*A*C))/(2*A)
        IF (ZZ(IGAM).LT.0 .OR. ZZ(IGAM).GT.1-Z(IGAM)) GOTO 20
        ZZ(JGAM)=1-Z(JGAM)
C-------REJECT AGAINST PHOTON DISTRIBUTION FUNCTION
        PROB=((1+ZZ(IGAM)**2)/(1-ZZ(IGAM)))/((1+(1-Z(IGAM))**2)/Z(IGAM))
     &      *((1+ZZ(JGAM)**2)/(1-ZZ(JGAM)))/((1+(1-Z(JGAM))**2)/Z(JGAM))
        IF (HWRLOG(1-PROB)) GOTO 20
C-------RECONSTRUCT ALL OTHER VARIABLES
        DO 40 I=1,2
          IGAM=2*I+3
          PHEP(1,IGAM)=QX(I)
          PHEP(2,IGAM)=QY(I)
          PHEP(4,IGAM)=ZZ(I)*PHEP(4,I)
          PHEP(5,IGAM)=RMASS(IDHW(IGAM))
C---------IF MOMENTUM CANNOT BE CONSERVED TRY AGAIN
          IF (PHEP(4,IGAM)**2-PHEP(5,IGAM)**2-QT(I)**2 .LT. 0) GOTO 20
          PHEP(3,IGAM)=SIGN(SQRT(PHEP(4,IGAM)**2-PHEP(5,IGAM)**2-
     &      QT(I)**2),PHEP(3,IGAM))
          CALL HWVDIF(4,PHEP(1,I),PHEP(1,IGAM),PHEP(1,IGAM-1))
          CALL HWUMAS(PHEP(1,IGAM-1))
 40     CONTINUE
C-----TIDY UP EVENT RECORD
        NHEP=NHEP+1
        IDHW(NHEP)=IDHW(3)
        IDHEP(NHEP)=IDHEP(3)
        ISTHEP(NHEP)=110
        CALL HWVSUM(4,PHEP(1,4),PHEP(1,6),PHEP(1,NHEP))
        CALL HWVSUM(4,PHEP(1,1),PHEP(1,2),PHEP(1,3))
        CALL HWUMAS(PHEP(1,NHEP))
        CALL HWUMAS(PHEP(1,3))
        JMOHEP(1,NHEP)=4
        JMOHEP(2,NHEP)=6
        JMOHEP(1,3)=0
        JMOHEP(2,3)=0
C-----CHOOSE FINAL STATE QUARK
        IF (IHPRO.EQ.0) THEN
          RWGT=HWRGEN(2)*EVWGT
          ID=1
          DO 50 IDL=1,NQ
            IF (RWGT.GT.WGT(IDL)) ID=IDL+1
 50       CONTINUE
          EMSQ=RMASS(ID)**2
          X=4*EMSQ/SHAT
          BETA=SQRT(1-X)
        ENDIF
C-----CHOOSE T (WHERE T = MANDELSTAM_T - EMSQ)
        TMIN=-SHAT/2
        TMAX=-SHAT/2*(1-BETA*CTMAX)
        TRAT=TMAX/TMIN
        NTRY=0
        IF (IHPRO.LE.9) THEN
C-------FOR FFBAR, CHOOSE T ACCORDING TO -SHAT/T
 60       NTRY=NTRY+1
          IF (NTRY.GT.NBTRY) CALL HWWARN('HWHEGG',101,*999)
          T=TRAT**HWRGEN(3)*TMIN
          U=-T-SHAT
C-------REWEIGHT TO CORRECT DISTRIBUTION
          DSDT=(T*U-2*EMSQ*(T+2*EMSQ))/T**2
     &        +( 2*EMSQ*(SHAT-4*EMSQ))/(T*U)
     &        +(T*U-2*EMSQ*(U+2*EMSQ))/U**2
          PROB=-DSDT*T/SHAT / (1 + 2*X - 2*X**2)
          IF (HWRLOG(1-PROB)) GOTO 60
        ELSE
C-------FOR WW, CHOOSE T ACCORDING TO (SHAT/T)**2
 70       NTRY=NTRY+1
          IF (NTRY.GT.NBTRY) CALL HWWARN('HWHEGG',102,*999)
          T=TMAX/(1-(1-TRAT)*HWRGEN(4))
          U=-T-SHAT
C-------REWEIGHT TO CORRECT DISTRIBUTION
          DSDT=( 3*(T*U)**2 - SHAT*T*U*(4*SHAT+6*EMSQ)
     &      + SHAT**2*(2*SHAT**2+6*EMSQ**2) ) / (T*U)**2
          PROB=DSDT*(T/SHAT)**2 / (4.75 - 1.5*X + 1.5*X**2)
          IF (HWRLOG(1-PROB)) GOTO 70
        ENDIF
C-----SYMMETRIZE IN T,U
        IF (HWRLOG(HALF)) T=U
C-----FILL EVENT RECORD
        COSTH=(1+2*T/SHAT)/BETA
        PC=0.5*BETA*PHEP(5,NHEP)
        PHEP(5,NHEP+1)=RMASS(ID)
        PHEP(5,NHEP+2)=RMASS(ID)
        CALL HWDTWO(PHEP(1,NHEP),PHEP(1,NHEP+1),PHEP(1,NHEP+2),
     &              PC,COSTH,.TRUE.)
        DO 80 I=1,2
          IHEP=NHEP+I
          JHEP=NHEP+3-I
          ISTHEP(IHEP)=190
          IF (IHPRO.LE.6) ISTHEP(IHEP)=112+I
          IDHW(IHEP)=ID+NADD*(I-1)
          IDHEP(IHEP)=IDPDG(IDHW(IHEP))
          JDAHEP(I,NHEP)=IHEP
          JMOHEP(1,IHEP)=NHEP
          JMOHEP(2,IHEP)=JHEP
          JDAHEP(2,IHEP)=JHEP
          IF (IHPRO.EQ.10) THEN
            RHOHEP(1,IHEP)=0.3333
            RHOHEP(2,IHEP)=0.3333
            RHOHEP(3,IHEP)=0.3333
          ENDIF
 80     CONTINUE
        NHEP=NHEP+2
      ENDIF
 999  END
CDECK  ID>, HWHEGW.
*CMZ :-        -26/04/91  10.18.56  by  Bryan Webber
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HWHEGW
C----------------------------------------------------------------------
C     W + GAMMA --> FF'BAR :  MEAN EVWGT = CROSS SECTION IN NANOBARN
C     BASED ON BOSON GLUON FUSION OF ABBIENDI AND STANCO
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,GMASS,EV(3),RV,LEP,Y,Q2,SHAT,Z,PHI,AJACOB,
     & DSIGMA,ME,MP,ML,MREMIF(18),MFIN1(18),MFIN2(18),RS,SMA,W2,RSHAT
      INTEGER LEPFIN,ID1,ID2,I,IQK,IFLAVU,IFLAVD,IMIN,IMAX,IFL,IPROO
      LOGICAL CHARGD,INCLUD(18),INSIDE(18)
      EXTERNAL HWRGEN
      SAVE LEPFIN,ID1,ID2
      COMMON /HWAREA/ LEP,Y,Q2,SHAT,Z,PHI,AJACOB,DSIGMA,ME,MP,ML,MREMIF,
     & MFIN1,MFIN2,RS,SMA,W2,RSHAT,IQK,IFLAVU,IFLAVD,IMIN,IMAX,IFL,
     & IPROO,CHARGD,INCLUD,INSIDE
      IQK=MOD(IPROC,10)
      CHARGD=.TRUE.
      IF(GENEV) THEN
C
        IDHW(4)=IDHW(1)
        IDHW(5)=59
        IDHW(6)=15
        IDHW(7)=LEPFIN
        IDHW(8)=ID1
        IDHW(9)=ID2
        DO 1 I=4,9
    1   IDHEP(I)=IDPDG(IDHW(I))
C
        IFLAVD=ID1
        IFLAVU=ID2-6
C
        ISTHEP(4)=111
        ISTHEP(5)=112
        ISTHEP(6)=110
        ISTHEP(7)=113
        ISTHEP(8)=114
        ISTHEP(9)=114
C
        JMOHEP(1,4)=6
        JMOHEP(2,4)=7
        JMOHEP(1,5)=6
        JMOHEP(2,5)=5
        JMOHEP(1,6)=4
        JMOHEP(2,6)=5
        JMOHEP(1,7)=6
        JMOHEP(2,7)=4
        JMOHEP(1,8)=6
        JMOHEP(2,8)=9
        JMOHEP(1,9)=6
        JMOHEP(2,9)=8
        JDAHEP(1,4)=0
        JDAHEP(2,4)=7
        JDAHEP(1,5)=0
        JDAHEP(2,5)=5
        JDAHEP(1,6)=7
        JDAHEP(2,6)=9
        JDAHEP(1,7)=0
        JDAHEP(2,7)=4
        JDAHEP(1,8)=0
        JDAHEP(2,8)=9
        JDAHEP(1,9)=0
        JDAHEP(2,9)=8
C---COMPUTATION OF MOMENTA IN LABORATORY FRAME OF REFERENCE
C---Persuade HWHBKI that the gluon is actually a photon...
        GMASS=RMASS(13)
        RMASS(13)=0
        CALL HWHBKI
        RMASS(13)=GMASS
C---put the other outgoing lepton in as well
        IDHW(10)=IDHW(2)
        IDHEP(10)=IDPDG(IDHW(10))
        ISTHEP(10)=1
        JMOHEP(1,10)=2
        JMOHEP(2,10)=0
        JDAHEP(1,10)=0
        JDAHEP(2,10)=0
        JDAHEP(1,2)=5
        JDAHEP(2,2)=10
        CALL HWVDIF(4,PHEP(1,2),PHEP(1,5),PHEP(1,10))
        CALL HWUMAS(PHEP(1,10))
        NHEP=10
C
C---if antilepton was first, do charge conjugation
        IF (LEP.EQ.-1) THEN
          DO 27 I=7,9
            IF (IDHEP(I).NE.0 .AND. ABS(IDHEP(I)).LT.20) THEN
              IDHW(I)=IDHW(I) + 6*SIGN(1,IDHEP(I))
              IDHEP(I)=-IDHEP(I)
            ENDIF
 27       CONTINUE
        ENDIF
C
C---half the time, do charge conjugation and parity flip
        IF (HWRGEN(0).GT.0.5) THEN
          DO 2 I=4,10
            IF (IDHEP(I).NE.0 .AND. ABS(IDHEP(I)).LT.20) THEN
              IDHW(I)=IDHW(I) + 6*SIGN(1,IDHEP(I))
              IDHEP(I)=-IDHEP(I)
            ENDIF
            PHEP(1,I)=-PHEP(1,I)
            PHEP(2,I)=-PHEP(2,I)
            PHEP(3,I)=-PHEP(3,I)
 2        CONTINUE
          JMOHEP(1,10)=3-JMOHEP(1,10)
        ENDIF
C
      ELSE
C
        EVWGT=ZERO
C---LEP = 1 IF TRACK 1 IS A LEPTON, -1 FOR ANTILEPTON
        LEP=0.
        IF (IDHW(1).GE.121.AND.IDHW(1).LE.126) THEN
          LEP=1.
        ELSEIF (IDHW(1).GE.127.AND.IDHW(1).LE.132) THEN
          LEP=-1.
        ENDIF
        IF (LEP.EQ.0) CALL HWWARN('HWHEGW',500,*999)
C---program only works if beam and target are charge conjugates
        IF (LEP*(IDHW(2)-IDHW(1)).NE.6) CALL HWWARN('HWHEGW',501,*999)
C---program only works for equal energy beams colliding
        IF (PHEP(3,3).NE.0) CALL HWWARN('HWHEGW',503,*999)
C
C---FINAL STATE IS ALWAYS SET UP AS IF PARTICLE IS BEFORE ANTI-PARTICLE
C   AND THEN INVERTED IF NECESSARY
        LEPFIN = MIN(IDHW(1),IDHW(2))+1
        IF (IQK.LE.2) THEN
          IFLAVU=2
          IFLAVD=1
          ID1  = 1
          ID2  = 8
        ELSEIF (IQK.LE.4) THEN
          IFLAVU=4
          IFLAVD=3
          ID1  = 3
          ID2  =10
        ELSEIF (IQK.LE.6) THEN
          IFLAVU=6
          IFLAVD=5
          ID1  = 5
          ID2  =12
        ELSEIF (IQK.EQ.7) THEN
          IFLAVU=122
          IFLAVD=121
          ID1  = 121
          ID2  = 128
C---INTERFERENCE TERMS IN EE -> EE NUE NUEB  NEGLECTED: SIGMA UNRELIABLE
          IF (FSTWGT) CALL HWWARN('HWHEGW',1,*999)
        ELSEIF (IQK.EQ.8) THEN
          IFLAVU=124
          IFLAVD=123
          ID1  = 123
          ID2  = 130
        ELSEIF (IQK.EQ.9) THEN
          IFLAVU=126
          IFLAVD=125
          ID1  = 125
          ID2  = 132
        ELSE
          CALL HWWARN('HWHEGW',504,*999)
        ENDIF
        IF (IQK.GT.0) THEN
          IF (IQK.LE.6) IQK=0
          CALL HWHBRN(*999)
          CALL HWHEGX
          EVWGT = 2 * DSIGMA * AJACOB
          IF (EVWGT.LT.ZERO) EVWGT=ZERO
        ELSE
C---SUM OVER QUARK FLAVOURS
          CALL HWHBRN(*999)
          DO 3 I=1,3
            IF (SHAT.GT.(RMASS(IFLAVD)+RMASS(IFLAVU))**2) THEN
              CALL HWHEGX
              EV(I) = 2 * DSIGMA * AJACOB
              IF (EV(I).LT.ZERO) EV(I)=ZERO
            ELSE
              EV(I)=ZERO
            ENDIF
            EVWGT=EVWGT+EV(I)
            EV(I)=EVWGT
            IFLAVU=IFLAVU+2
            IFLAVD=IFLAVD+2
 3        CONTINUE
C---CHOOSE QUARK FLAVOUR
          RV=EV(3)*HWRGEN(1)
          IF (RV.LT.EV(1)) THEN
            ID1 = 1
            ID2 = 8
          ELSEIF (RV.LT.EV(2)) THEN
            ID1 = 3
            ID2 =10
          ELSE
            ID1 = 5
            ID2 =12
          ENDIF
        ENDIF
      ENDIF
  999 END
CDECK  ID>, HWHEGX.
*CMZ :-        -17/07/92  16.42.56  by  Mike Seymour
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HWHEGX
C-----------------------------------------------------------------------
C     COMPUTES DIFFERENTIAL CROSS SECTION DSIGMA IN (Y,Q2,ETA,Z,PHI)
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION TMAX,TMIN,A1,A2,B1,B2,I0,I1,I2,I3,I4,I5,MUSQ,
     & MDSQ,ETA,Q1,COSTHE,S,G,T,U,C1,C2,D1,D2,F1,F2,COSBET,WPROP,D(4,4),
     & C(4,4),QU,QD,QE,QW,PHOTON,EMWSQ,EMSSQ,CFAC,LEP,Y,Q2,SHAT,Z,PHI,
     & AJACOB,DSIGMA,ME,MP,ML,MREMIF(18),MFIN1(18),MFIN2(18),RS,SMA,W2,
     & RSHAT
      INTEGER IQK,IFLAVU,IFLAVD,IMIN,IMAX,IFL,IPROO,I,J
      LOGICAL CHARGD,INCLUD(18),INSIDE(18)
      COMMON /HWAREA/ LEP,Y,Q2,SHAT,Z,PHI,AJACOB,DSIGMA,ME,MP,ML,MREMIF,
     & MFIN1,MFIN2,RS,SMA,W2,RSHAT,IQK,IFLAVU,IFLAVD,IMIN,IMAX,IFL,
     & IPROO,CHARGD,INCLUD,INSIDE
C---INPUT VARIABLES
      IF (IERROR.NE.0) RETURN
      DSIGMA=0
      IF (IFLAVU.LE.12) THEN
        QU=QFCH(MOD(IFLAVU-1,6)+1)
        QD=QFCH(MOD(IFLAVD-1,6)+1)
        CFAC=CAFAC
      ELSE
        QU=QFCH(MOD(IFLAVU-1,6)+11)
        QD=QFCH(MOD(IFLAVD-1,6)+11)
        CFAC=1
      ENDIF
      QE=QFCH(11)
      QW=+1
      EMWSQ=RMASS(198)**2
      EMSCA=PHEP(5,3)
      EMSSQ=EMSCA**2
      MUSQ=RMASS(IFLAVU)**2
      MDSQ=RMASS(IFLAVD)**2
      ETA=(SHAT+Q2)/EMSSQ/Y
      IF (ETA.GT.ONE) RETURN
C---CALCULATE KINEMATIC TERMS
      G=0.5*(ETA*EMSSQ*Y-Q2) -0.5*(MUSQ+MDSQ)
      S=0.5*ETA*EMSSQ
      T=0.5*ETA*EMSSQ*(1-Y)
      U=0.5*Q2
      C1=0.5*ETA*EMSSQ*Y*Z
      C2=0.5*ETA*EMSSQ*Y*(1-Z)
      COSBET=(-ETA*EMSSQ*Y+Q2*(2-Y))/(Y*(ETA*EMSSQ-Q2))
      IF (SHAT.LE.(RMASS(IFLAVU)+RMASS(IFLAVD))**2) RETURN
      Q1=SQRT((SHAT**2+MUSQ**2+MDSQ**2
     &  -2*SHAT*MUSQ-2*SHAT*MDSQ-2*MUSQ*MDSQ)/SHAT**2)
      COSTHE=(1+(MDSQ-MUSQ)/SHAT-2*Z)/Q1
      IF (ABS(COSTHE).GE.1 .OR. ABS(COSBET).GE.1) RETURN
      D1=0.25*(ETA*EMSSQ-Q2)*(1+(MDSQ-MUSQ)/SHAT-Q1*
     &     (COSTHE*COSBET+SQRT((1-COSTHE**2)*(1-COSBET**2))*COS(PHI)))
      D2=S-U-D1
      F1=D1+C1-G            -MDSQ
      F2=U+T-F1
C---CALCULATE TRACE TERMS
      CALL HWVZRO(16,D)
      CALL HWVZRO(16,C)
      D(1,1)=2*F1*C2*S
      D(2,2)=2*C1*D2*T
      D(3,3)=-D1*(2*F2*G-D2*(F1+2*U))
     &       -D2*F1*(F2+U-D2+F1)
     &       +2*F1*F2*U
     &       -G*(-2*D1*(F1+F2+U)-F1*(D2+2*U)+2*D2*(U-F2)+2*U*(F2-U+G))
      D(4,4)=2*F1*C2*S
      D(1,2)=(D1+U-F2)*(D1*F2-F1*D2)-G*(D1*(F2+U)+U*(U-F2-G)+F1*D2)
      D(1,3)=D1*F2*(-2*F1+U-F2+D1)
     &      +F1*(F2*(D2-2*U)+F1*D2)
     &      +G*(-D1*(2*F1+F2+U)-F1*(D2+2*U)+U*(F2-U+G))
      D(1,4)=-2*F1*(D1+U)*(F2+G)
      D(2,3)=D1*(D2*(F1+2*(U-F2))+F2*(F2-U-D1))
     &      +F1*D2**2
     &      +G*(D1*(F2+U)+D2*(F1-2*(U-F2))+U*(U-F2-G))
      D(2,4)=-D1*F2*(U-F2+D1)
     &       -F1*D2*(U-D1-G-F2)
     &       -G*(U*(F2-U+G)-D1*(F2+U))
      D(3,4)=D1*(F1*(D2+2*F2)+F2*(F2-U-D1))
     &      +F1*(2*F2*U-D2*(U+F1))
     &      +G*(D1*(2*F1+F2+U)+U*(2*F1-F2+U-G))
C---REGULATE PROPAGATORS
      TMAX=EMSSQ-2*G
      TMIN=PHEP(5,2)**2
      A1=2*C1+MDSQ*(G+U)/G
      A2=2*C2+MUSQ*(G+U)/G
      B1=(2*U+MUSQ)/(2*G+2*U)
      B2=(2*U+MDSQ)/(2*G+2*U)
      I0=LOG(TMAX/TMIN)
      I1=1/A1*(I0-LOG((A1+B1*TMAX)/(A1+B1*TMIN)))
      I2=1/A2*(I0-LOG((A2+B2*TMAX)/(A2+B2*TMIN)))
      I3=(B1*I1-B2*I2)/(B1*A2-B2*A1)
      I4=1/A1*(I1+1/(A1+B1*TMAX)-1/(A1+B1*TMIN))
      I5=1/A2*(I2+1/(A2+B2*TMAX)-1/(A2+B2*TMIN))
      WPROP=1/((2*G-EMWSQ)**2+GAMW**2*EMWSQ)
C---CALCULATE COEFFICIENTS
      C(1,1)=    QU**2/(2*U+EMWSQ)**2                       *I5
      C(2,2)=    QD**2/(2*U+EMWSQ)**2                       *I4
      C(3,3)=    QW**2/(2*U+EMWSQ)**2    *WPROP             *I0
      C(4,4)=    QE**2/(2*S)**2          *WPROP             *I0
      C(1,2)=  2*QU*QD/(2*U+EMWSQ)**2                       *I3
      C(1,3)=  2*QW*QU/(2*U+EMWSQ)**2    *WPROP*(2*G-EMWSQ) *I2
      C(1,4)=  2*QU*QE/(2*S*(2*U+EMWSQ)) *WPROP*(2*G-EMWSQ) *I2
      C(2,3)=  2*QW*QD/(2*U+EMWSQ)**2    *WPROP*(2*G-EMWSQ) *I1
      C(2,4)=  2*QD*QE/(2*S*(2*U+EMWSQ)) *WPROP*(2*G-EMWSQ) *I1
      C(3,4)=  2*QW*QE/(2*S*(2*U+EMWSQ)) *WPROP             *I0
C---CALCULATE PHOTON STRUCTURE FUNCTION
      PHOTON=ALPHEM * (1+(1-ETA)**2) / (2*PIFAC*ETA)
C---SUM ALL TENSOR CONTRIBUTIONS
      DO 10 I=1,4
      DO 10 J=1,4
 10     DSIGMA=DSIGMA + C(I,J)*D(I,J)
C---CALCULATE TOTAL SUMMED AND AVERAGED MATRIX ELEMENT SQUARED
      DSIGMA = DSIGMA * 2*CFAC*(4*PIFAC*ALPHEM)**3/SWEIN**2
C---CALCULATE DIFFERENTIAL CROSS-SECTION
      DSIGMA = DSIGMA * GEV2NB*PHOTON/(512*PIFAC**4*ETA*EMSSQ)
 999  END
CDECK  ID>, HWHEPA.
*CMZ :-        -26/04/91  14.55.44  by  Federico Carminati
*-- Author :    Bryan Webber and Ian Knowles
C-----------------------------------------------------------------------
      SUBROUTINE HWHEPA
C-----------------------------------------------------------------------
C     (Initially polarised) e+e- --> ffbar (f=quark, mu or tau)
C     If IPROC=107: --> gg, distributed as sum of light quarks.
C     If fermion flavour specified mass effects fully included.
C     EVWGT=sig(e+e- --> ffbar) in nb
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,HWRUNI,HWUPCM,HWUAEM,Q2NOW,Q2LST,FACTR,
     & VF2,VF,CLF(7),PRAN,PQWT,PMAX,PTHETA,SINTH2,CPHI,SPHI,C2PHI,S2PHI,
     & PPHI,SINTH,PCM,PP(5),EWGT
      INTEGER ID1,ID2,IDF,IQ,IQ1,I
      EXTERNAL HWRGEN,HWRUNI,HWUPCM,HWUAEM
      SAVE Q2LST,FACTR,ID1,ID2,VF2,VF,CLF,EWGT
      DATA Q2LST/0./
      IF (GENEV) THEN
        IF (ID2.EQ.0) THEN
C Choose quark flavour
          PRAN=TQWT*HWRGEN(0)
          PQWT=0.
          DO 10 IQ=1,MAXFL
          PQWT=PQWT+CLQ(1,IQ)
          IF (PQWT.GT.PRAN) GOTO 11
   10     CONTINUE
          IQ=MAXFL
   11     IQ1=MAPQ(IQ)
          DO 20 I=1,7
   20     CLF(I)=CLQ(I,IQ)
        ELSE
          IQ1=ID1
        ENDIF
C Label particles, assign outgoing particle masses
        IDHW(NHEP+1)=200
        IDHEP(NHEP+1)=23
        ISTHEP(NHEP+1)=110
        IF (ID1.EQ.7) THEN
          IDHW(NHEP+2)=13
          IDHW(NHEP+3)=13
          IDHEP(NHEP+2)=21
          IDHEP(NHEP+3)=21
          PHEP(5,NHEP+2)=RMASS(13)
          PHEP(5,NHEP+3)=RMASS(13)
        ELSE
          IDHW(NHEP+2)=IQ1
          IDHW(NHEP+3)=IQ1+6
          IDHEP(NHEP+2)=IDPDG(IQ1)
          IDHEP(NHEP+3)=-IDHEP(NHEP+2)
          PHEP(5,NHEP+2)=RMASS(IQ1)
          PHEP(5,NHEP+3)=RMASS(IQ1)
        ENDIF
        ISTHEP(NHEP+2)=113
        ISTHEP(NHEP+3)=114
        JMOHEP(1,NHEP+1)=1
        IF (JDAHEP(1,1).NE.0) JMOHEP(1,NHEP+1)=JDAHEP(1,1)
        JMOHEP(2,NHEP+1)=2
        IF (JDAHEP(1,2).NE.0) JMOHEP(1,NHEP+1)=JDAHEP(1,2)
        JMOHEP(1,NHEP+2)=NHEP+1
        JMOHEP(2,NHEP+2)=NHEP+3
        JMOHEP(1,NHEP+3)=NHEP+1
        JMOHEP(2,NHEP+3)=NHEP+2
        JDAHEP(1,NHEP+1)=NHEP+2
        JDAHEP(2,NHEP+1)=NHEP+3
        JDAHEP(1,NHEP+2)=0
        JDAHEP(2,NHEP+2)=NHEP+3
        JDAHEP(1,NHEP+3)=0
        JDAHEP(2,NHEP+3)=NHEP+2
C Generate polar and azimuthal angular distributions:
C  CLF(1)*(1+(VF*COSTH)**2)+CLF(2)*(1-VF**2)+CLF(3)*2.*VF*COSTH
C +(VF*SINTH)**2*(CLF(4)*COS(2*PHI-PHI1-PHI2)
C                +CLF(6)*SIN(2*PHI-PHI1-PHI2))
        PMAX=CLF(1)*(1.+VF2)+CLF(2)*(1.-VF2)+ABS(CLF(3))*2.*VF
  30    COSTH=HWRUNI(0,-ONE, ONE)
        PTHETA=CLF(1)*(1.+VF2*COSTH**2)+CLF(2)*(1.-VF2)
     &        +CLF(3)*2.*VF*COSTH
        IF (PTHETA.LT.PMAX*HWRGEN(1)) GOTO 30
        IF (IDHW(1).GT.IDHW(2)) COSTH=-COSTH
        SINTH2=1.-COSTH**2
        IF (TPOL) THEN
          PMAX=PTHETA+VF2*SINTH2*SQRT(CLF(4)**2+CLF(6)**2)
  40      CALL HWRAZM(ONE,CPHI,SPHI)
          C2PHI=2.*CPHI**2-1.
          S2PHI=2.*CPHI*SPHI
          PPHI=PTHETA+(CLF(4)*(C2PHI*COSS+S2PHI*SINS)
     &                +CLF(6)*(S2PHI*COSS-C2PHI*SINS))*VF2*SINTH2
          IF (PPHI.LT.PMAX*HWRGEN(1)) GOTO 40
        ELSE
          CALL HWRAZM(ONE,CPHI,SPHI)
        ENDIF
C Construct final state 4-mommenta
        CALL HWVEQU(5,PHEP(1,3),PHEP(1,NHEP+1))
        PCM=HWUPCM(PHEP(5,NHEP+1),PHEP(5,NHEP+2),PHEP(5,NHEP+3))
C PP is momentum of track NHEP+2 in CoM (track NHEP+1) frame
        SINTH=SQRT(SINTH2)
        PP(5)=PHEP(5,NHEP+2)
        PP(1)=PCM*SINTH*CPHI
        PP(2)=PCM*SINTH*SPHI
        PP(3)=PCM*COSTH
        PP(4)=SQRT(PCM**2+PP(5)**2)
        CALL HWULOB(PHEP(1,NHEP+1),PP(1),PHEP(1,NHEP+2))
        CALL HWVDIF(4,PHEP(1,NHEP+1),PHEP(1,NHEP+2),PHEP(1,NHEP+3))
C Set production vertices
        CALL HWVZRO(4,VHEP(1,NHEP+2))
        CALL HWVEQU(4,VHEP(1,NHEP+2),VHEP(1,NHEP+3))
        NHEP=NHEP+3
      ELSE
        EMSCA=PHEP(5,3)
        Q2NOW=EMSCA**2
        IF (Q2NOW.NE.Q2LST) THEN
C Calculate coefficients for cross-section
          EMSCA=PHEP(5,3)
          Q2LST=Q2NOW
          FACTR=PIFAC*GEV2NB*HWUAEM(Q2NOW)**2/Q2NOW
          ID1=MOD(IPROC,10)
          ID2=MOD(ID1,7)
          IF (ID2.EQ.0) THEN
            CALL HWUEEC(1)
            VF2=1.
            VF=1.
            EWGT=FACTR*FLOAT(NCOLO)*TQWT*4./3.
          ELSE
            IF (IPROC.LT.150) THEN
              IDF=ID1
              FACTR=FACTR*FLOAT(NCOLO)
            ELSE
              ID1=2*ID1+119
              IDF=ID1-110
            ENDIF
            IF (EMSCA.LE.2.*RMASS(ID1)) then
              EWGT=0.
            ELSE
              CALL HWUCFF(11,IDF,Q2NOW,CLF(1))
              VF2=1.-4.*RMASS(ID1)**2/Q2NOW
              VF=SQRT(VF2)
              EWGT=FACTR*VF*(CLF(1)*(1.+VF2/3.)+CLF(2)*(1.-VF2))
            ENDIF
          ENDIF
        ENDIF
        EVWGT=EWGT
      ENDIF
  999 END
CDECK  ID>, HWHEPG.
*CMZ :-        -02/05/91  10.57.27  by  Federico Carminati
*-- Author :    Bryan Webber and Ian Knowles
C-----------------------------------------------------------------------
      SUBROUTINE HWHEPG
C-----------------------------------------------------------------------
C     (Initially polarised) e-e+ --> qqbar g with parton thrust < THMAX,
C     equivalent to: maximum parton energy < THMAX*EMSCA/2; or a JADE E0
c     scheme, y_cut=1.-THMAX.
C     If flavour specified mass effects fully included.
C     EVWGT=sig(e^-e^+ --> qqbar g) in nb
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,HWUALF,HWUAEM,HWULDO,HWDPWT,Q2NOW,Q2LST,
     & PHASP,QGMAX,QGMIN,FACTR,QM2,CLF(7),ORDER,PRAN,PQWT,QQG,QBG,SUM,
     & RUT,QQLM,QQLP,QBLM,QBLP,DYN1,DYN2,DYN3,DYN4,DYN5,DYN6,XQ2,X2SUM,
     & PVRT(4)
      INTEGER ID1,IQ,I,LM,LP,IQ1
      LOGICAL MASS
      EXTERNAL HWRGEN,HWUALF,HWUAEM,HWULDO,HWDPWT
      SAVE Q2NOW,Q2LST,QGMAX,QGMIN,FACTR,ORDER,ID1,MASS,QM2,CLF,LM,LP,
     & IQ1,QQG,QBG,SUM
      DATA Q2LST/0./
      IF (GENEV) THEN
C Label produced partons and calculate gluon spin
        IDHW(NHEP+1)=200
        IDHW(NHEP+2)=IQ1
        IDHW(NHEP+3)=13
        IDHW(NHEP+4)=IQ1+6
        IDHEP(NHEP+1)=23
        IDHEP(NHEP+2)=IQ1
        IDHEP(NHEP+3)=21
        IDHEP(NHEP+4)=-IQ1
        ISTHEP(NHEP+1)=110
        ISTHEP(NHEP+2)=113
        ISTHEP(NHEP+3)=114
        ISTHEP(NHEP+4)=114
        JMOHEP(1,NHEP+1)=LM
        JMOHEP(2,NHEP+1)=LP
        JMOHEP(1,NHEP+2)=NHEP+1
        JMOHEP(2,NHEP+2)=NHEP+3
        JMOHEP(1,NHEP+3)=NHEP+1
        JMOHEP(2,NHEP+3)=NHEP+4
        JMOHEP(1,NHEP+4)=NHEP+1
        JMOHEP(2,NHEP+4)=NHEP+2
        JDAHEP(1,NHEP+1)=NHEP+2
        JDAHEP(2,NHEP+1)=NHEP+4
        JDAHEP(1,NHEP+2)=0
        JDAHEP(2,NHEP+2)=NHEP+4
        JDAHEP(1,NHEP+3)=0
        JDAHEP(2,NHEP+3)=NHEP+2
        JDAHEP(1,NHEP+4)=0
        JDAHEP(2,NHEP+4)=NHEP+3
C Decide which quark radiated and assign production vertices
        XQ2=(Q2NOW-2.*QBG)**2
        X2SUM=XQ2+(Q2NOW-2.*QQG)**2
        IF (XQ2.LT.HWRGEN(0)*X2SUM) THEN
C Quark radiated the gluon
          CALL HWVZRO(4,VHEP(1,NHEP+4))
          CALL HWVSUM(4,PHEP(1,NHEP+2),PHEP(1,NHEP+3),PVRT)
          CALL HWUDKL(IQ1,PVRT,VHEP(1,NHEP+3))
          CALL HWVEQU(4,VHEP(1,NHEP+3),VHEP(1,NHEP+2))
        ELSE
C Anti-quark radiated the gluon
          CALL HWVZRO(4,VHEP(1,NHEP+2))
          CALL HWVSUM(4,PHEP(1,NHEP+4),PHEP(1,NHEP+3),PVRT)
          CALL HWUDKL(IQ1,PVRT,VHEP(1,NHEP+3))
          CALL HWVEQU(4,VHEP(1,NHEP+3),VHEP(1,NHEP+4))
        ENDIF
        IF (AZSPIN) THEN
C  Calculate the transverse polarisation of the gluon
C  Correlation with leptons presently neglected
           GPOLN=(QQG**2+QBG**2)/((Q2NOW-2.*SUM)*Q2NOW)
           GPOLN=2./(2.+GPOLN)
        ENDIF
        NHEP=NHEP+4
      ELSE
        EMSCA=PHEP(5,3)
        Q2NOW=EMSCA**2
        IF (Q2NOW.NE.Q2LST) THEN
          Q2LST=Q2NOW
          PHASP=3.*THMAX-2.
          IF (PHASP.LE.0.) CALL HWWARN('HWHEPG',400,*999)
          QGMAX=.5*Q2NOW*THMAX
          QGMIN=.5*Q2NOW*(1.-THMAX)
          FACTR=GEV2NB*FLOAT(NCOLO)*CFFAC*HWUALF(1,EMSCA)
     &         *.5*(HWUAEM(Q2NOW)*PHASP)**2/Q2NOW
          LM=1
          IF (JDAHEP(1,LM).NE.0) LM=JDAHEP(1,LM)
          LP=2
          IF (JDAHEP(1,LP).NE.0) LP=JDAHEP(1,LP)
          ORDER=1.
          IF (IDHW(1).GT.IDHW(2)) ORDER=-ORDER
          ID1=MOD(IPROC,10)
          IF (ID1.NE.0) THEN
             MASS=.TRUE.
             QM2=RMASS(ID1)**2
             CALL HWUCFF(11,ID1,Q2NOW,CLF(1))
             FACTR=FACTR*CLF(1)
          ELSE
             MASS=.FALSE.
             CALL HWUEEC(1)
             FACTR=FACTR*TQWT
          ENDIF
        ENDIF
        IF (ID1.EQ.0) THEN
C Select quark flavour
          PRAN=TQWT*HWRGEN(1)
          PQWT=0.
          DO 10 IQ=1,MAXFL
          PQWT=PQWT+CLQ(1,IQ)
          IF (PQWT.GT.PRAN) GOTO 11
   10     CONTINUE
          IQ=MAXFL
   11     IQ1=MAPQ(IQ)
          DO 20 I=1,7
   20     CLF(I)=CLQ(I,IQ)
        ELSEIF (Q2NOW.GT.4*QM2/(2*THMAX-1)) THEN
          IQ1=ID1
        ELSE
          EVWGT=0.
          RETURN
        ENDIF
C Select final state momentum configuration
        CALL HWVEQU(5,PHEP(1,3),PHEP(1,NHEP+1))
        PHEP(5,NHEP+2)=RMASS(IQ1)
        PHEP(5,NHEP+3)=RMASS(13)
        PHEP(5,NHEP+4)=RMASS(IQ1)
   30   CALL HWDTHR(PHEP(1,NHEP+1),PHEP(1,NHEP+2),
     &              PHEP(1,NHEP+3),PHEP(1,NHEP+4),HWDPWT)
        QQG=HWULDO(PHEP(1,NHEP+2),PHEP(1,NHEP+3))
        IF (QQG.LT.QGMIN) GOTO 30
        QBG=HWULDO(PHEP(1,NHEP+4),PHEP(1,NHEP+3))
        SUM=QQG+QBG
        IF (QBG.LT.QGMIN.OR.SUM.GT.QGMAX) GOTO 30
        QQLM=HWULDO(PHEP(1,NHEP+2),PHEP(1,LM))
        QQLP=HWULDO(PHEP(1,NHEP+2),PHEP(1,LP))
        QBLM=HWULDO(PHEP(1,NHEP+4),PHEP(1,LM))
        QBLP=HWULDO(PHEP(1,NHEP+4),PHEP(1,LP))
        DYN1=QQLM**2+QQLP**2+QBLM**2+QBLP**2
        DYN2=0.
        DYN3=DYN1-2.*(QQLM**2+QBLP**2)
        IF (MASS) THEN
           RUT=1./QQG+1./QBG
           DYN1=DYN1+8.*QM2*(1.-.25*Q2NOW*RUT
     &         +QQLM*QQLP/(Q2NOW*QBG)+QBLM*QBLP/(Q2NOW*QQG))
           DYN2=QM2*(Q2NOW-SUM*(2.+QM2*RUT)
     &         -4.*HWULDO(PHEP(1,NHEP+3),PHEP(1,LM))
     &            *HWULDO(PHEP(1,NHEP+3),PHEP(1,LP))/Q2NOW)
           DYN3=DYN3+QM2*2.*RUT*(QBG*(QBLP-QBLM)-QQG*(QQLP-QQLM))
        ENDIF
        EVWGT=CLF(1)*DYN1+CLF(2)*DYN2+ORDER*CLF(3)*DYN3
        IF (TPOL) THEN
C Include event plane azimuthal angle
           DYN4=.5*Q2NOW
           DYN5=DYN4
           DYN6=0.
           IF (MASS) THEN
              DYN4=DYN4-QM2*SUM/QBG
              DYN5=DYN5-QM2*SUM/QQG
              DYN6=QM2
           ENDIF
           EVWGT=EVWGT
     &     +(CLF(4)*COSS-CLF(6)*SINS)
     &      *(DYN4*(PHEP(1,NHEP+2)**2-PHEP(2,NHEP+2)**2)
     &       +DYN5*(PHEP(1,NHEP+4)**2-PHEP(2,NHEP+4)**2))
     &     +(CLF(4)*SINS+CLF(6)*COSS)*2.
     &      *(DYN4*PHEP(1,NHEP+2)*PHEP(2,NHEP+2)
     &       +DYN5*PHEP(1,NHEP+4)*PHEP(2,NHEP+4))
     &     +(CLF(5)*COSS-CLF(7)*SINS)*DYN6
     &      *(PHEP(1,NHEP+3)**2-PHEP(2,NHEP+3)**2)
     &     +(CLF(5)*SINS+CLF(7)*COSS)*DYN6*2.
     &      *PHEP(1,NHEP+3)*PHEP(2,NHEP+3)
        ENDIF
C Assign event weight
        EVWGT=EVWGT*FACTR/(QQG*QBG*CLF(1))
      ENDIF
  999 END
CDECK  ID>, HWHEW0.
*CMZ :-        -26/04/91  11.11.55  by  Bryan Webber
*-- Author :    Zoltan Kunszt, modified by Bryan Webber & Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HWHEW0(IP,ETOT,XM,PR,WEIGHT,CR)
C-----------------------------------------------------------------------
      IMPLICIT NONE
      DOUBLE PRECISION HWRGEN,ETOT,XM(2),PR(5,2),WEIGHT,CR,PI,XM1,XM2,S,
     & D1,PABS,D,CX,C,E,F,SC,G
      INTEGER IP,I
      EXTERNAL HWRGEN
      WEIGHT=0.D0
      PI=3.1415926536
      XM1=XM(1)**2
      XM2=XM(2)**2
      S=ETOT*ETOT
      D1=S-XM1-XM2
      PABS=D1*D1-4.*XM1*XM2
      IF (PABS.LE.0) RETURN
      PABS=SQRT(PABS)
      D=D1/PABS
      IF(IP.EQ.2)GOTO3
      CX=CR
      C=D-(D+CX)*((D-CR)/(D+CX))**HWRGEN(2)
      GOTO 4
3     E=((D+1.D0)/(D-1.D0))*(2D0*HWRGEN(3)-1.D0)
      C=D*((E-1.D0)/(E+1.D0))
4     F=2D0*PI*HWRGEN(4)
      SC=SQRT(1.D0-C*C)
      PR(4,1)=(S+XM1-XM2)/(2D0*ETOT)
      PR(5,1)=PR(4,1)*PR(4,1)-XM1
      IF (PR(5,1).LE.0) RETURN
      PR(5,1)=SQRT(PR(5,1))
      PR(4,2)=ETOT-PR(4,1)
      PR(3,1)=PR(5,1)*C
      PR(5,2)=PR(5,1)
      PR(2,1)=PR(5,1)*SC*COS(F)
      PR(1,1)=PR(5,1)*SC*SIN(F)
      DO 7 I=1,3
7     PR(I,2)=-PR(I,1)
      G=0.
      IF(IP.EQ.1)G=(D-C)*LOG((D+CX)/(D-CR))
      IF(IP.EQ.2)G=(D*D-C*C)/D*LOG((D+1.D0)/(D-1.D0))
      WEIGHT=PI*G*PR(5,1)/ETOT*0.5D0
      RETURN
      END
CDECK  ID>, HWHEW1.
*CMZ :-        -26/04/91  11.11.55  by  Bryan Webber
*-- Author :    Zoltan Kunszt, modified by Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWHEW1(NPART)
C-----------------------------------------------------------------------
      IMPLICIT NONE
      DOUBLE PRECISION P(4,7),XMASS,PLAB,PRW,PCM
      INTEGER NPART,I,J,K
      COMMON/HWHEWP/ XMASS(10),PLAB(5,10),PRW(5,2),PCM(5,10)
      DO 10 I=1,NPART
      P(1,I)=PLAB(3,I)
      P(2,I)=PLAB(1,I)
      P(3,I)=PLAB(2,I)
      P(4,I)=PLAB(4,I)
  10  CONTINUE
      DO 20 J=1,4
      DO 30 K=1,(NPART-2)
  30  PCM(J,K)=P(J,K+2)
      PCM(J,NPART-1)=-P(J,1)
      PCM(J,NPART)=-P(J,2)
  20  CONTINUE
      END
CDECK  ID>, HWHEW2.
*CMZ :-        -26/04/91  13.22.25  by  Federico Carminati
*-- Author :    Zoltan Kunszt, modified by Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWHEW2(NPART,PPCM,H,CH,D)
C-----------------------------------------------------------------------
C PCM SHOULD BE DEFINED SUCH THAT ALL 4-MOMENTA ARE OUTGOING.
C CONVENTION FOR PCM AND P IS THAT DIRECTION 1 =BEAM, COMPONENT
C 4 = ENERGY AND COMPONENT 2 AND 3 ARE TRANSVERSE COMPONENTS.
C THUS INCOMING MOMENTA SHOULD CORRESPOND TO OUTGOING MOMENTA
C OF NEGATIVE ENERGY.
C PCM IS FILLED BY PHASE SPACE MONTE CARLO.
C I1-I7 HERE REFER TO HOW PCM INDEXING IS MAPPED TO OUR STANDARD
C 1-6=GLUON,GLUON,Q,QBAR,QP,QPBAR ORDERING `
C-----------------------------------------------------------------------
      IMPLICIT NONE
      COMPLEX PT5,ZT,Z1,ZI,ZP,ZQ,ZD,ZPS,ZQS,ZDPM,ZDMP,H(7,7),CH(7,7),
     & D(7,7)
      DOUBLE PRECISION ZERO,ONE,PPCM(5,7),P(5,7),WRN(7),EPS,Q1,Q2,QP,QM,
     & P1,P2,PP,PM,DMP,DPM,PT,QT,PTI,QTI
      INTEGER J,L,IJ,II,JJ,I,NPART,IP1,IPP1
      PARAMETER (ZERO=0.D0,ONE=1.D0)
      EPS=0.0000001
      ZI=CMPLX(0.,1.)
      Z1=CMPLX(1.,0.)
C FOLLOWING DO LOOP IS TO CONVERT TO OUR STANDARD INDEXING
      DO 1 L=1,NPART
      DO 1 IJ=1,4
1     P(IJ,L)=PPCM(IJ,L)
      DO 2 II=1,7
      WRN(II)=ONE
      IF(P(4,II).LT.ZERO) WRN(II)=-ONE
      DO 2 JJ=1,4
      P(JJ,II)=WRN(II)*P(JJ,II)
    2 CONTINUE
C THE ABOVE CHECKS FOR MOMENTA WITH NEGATIVE ENERGY,INNER PRODUCTS
C ARE EXPRESSED DIFFERENTLY FOR DIFFERENT CASES
      DO 11 I=1,NPART-1
      IP1=I+1
      DO 11 J=IP1,NPART
      Q1=P(4,I)+P(1,I)
      QP=0.0
      IF(Q1.GT.EPS)QP=SQRT(Q1)
      Q2=P(4,I)-P(1,I)
      QM=0.0
      IF(Q2.GT.EPS)QM=SQRT(Q2)
      P1=P(4,J)+P(1,J)
      PP=0.
      IF(P1.GT.EPS)PP=SQRT(P1)
      P2=P(4,J)-P(1,J)
      PM=0.
      IF(P2.GT.EPS)PM=SQRT(P2)
      DMP=PM*QP
      ZDMP=CMPLX(DMP,ZERO)
      DPM=PP*QM
      ZDPM=CMPLX(DPM,ZERO)
C NOTE THAT IN OUR INNER PRODUCT NOTATION WE ARE COMPUTING <P,Q>
      PT=SQRT(P(2,J)**2+P(3,J)**2)
      QT=SQRT(P(2,I)**2+P(3,I)**2)
      IF(PT.GT.EPS) GOTO 99
      ZP=Z1
      GOTO 98
   99 PTI=ONE/PT
      ZP=CMPLX(PTI*P(2,J),PTI*P(3,J))
   98 ZPS=CONJG(ZP)
      IF(QT.GT.EPS) GOTO 89
      ZQ=Z1
      GOTO 88
   89 QTI=ONE/QT
      ZQ=CMPLX(QTI*P(2,I),QTI*P(3,I))
   88 ZQS=CONJG(ZQ)
      ZT=Z1
      IF(WRN(I).LT.0) ZT=ZT*ZI
      IF(WRN(J).LT.0) ZT=ZT*ZI
      H(J,I)=(ZDMP*ZP-ZDPM*ZQ)*ZT
      CH(J,I)=(ZDMP*ZPS-ZDPM*ZQS)*ZT
      ZD=H(J,I)*CH(J,I)
      PT5=CMPLX(.5,0.)
      D(J,I)=PT5*ZD
   11 CONTINUE
      DO 60 I=1,NPART-1
      IPP1=I+1
      DO 60 J=IPP1,NPART
      H(I,J)=-H(J,I)
      CH(I,J)=-CH(J,I)
   60 D(I,J)=D(J,I)
      RETURN
      END
CDECK  ID>, HWHEW3.
*CMZ :-        -27/03/92  19.48.55  by  Mike Seymour
*-- Author :    Zoltan Kunszt, modified by Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWHEW3(N1,N2,N3,N4,N5,N6,AMPWW)
C-----------------------------------------------------------------------
C RECALL THAT N1,N3,N5 MUST BE OUTGOING FERMIONS, AND N2,N4,N6 MUST BE
C OUTGOING ANTI-FERMIONS; 3,4 FOR W-, 5,6 FOR W+
C
C EQ1 AND T31 ARE FOR OUTOING INITIAL QUARK
C CHOOSE APPROPRIATE CASE ACCORDING TO NUPDN
C NUPDN=1 FOR UUBAR COLLISIONS, NUPDN=2 FOR DDBAR COLLISIONS
C NFINAL CHOOSES THE FINAL DECAYS, 1 FOR DOUBLE LEPTON, 2 FOR 1 FLAVOR
C LEPTON+2FAMILIES OF QUARKS, 3 THE SAME, 4 FOR DOUBLE 2FAM3COLOR QUARKS
C
C NOTE: EXTERNAL FACTOR OF COLOR AVERAGE AND SPIN AVERAGE AND
C COUPLING (E**8/4/9) MUST BE INCLUDED AS WELL AS COMPENSATION
C FOR ON POLE APPROXIMATION AS DESIRED.
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      COMPLEX HWHEW4,ZH,ZCH,ZD,ZAMP1,ZAMP2,ZAMP3,DWW,CWW,BWW,AWW,AWWM,
     & AWWP,AMPTEM,ZTWO,ZHALF
      DOUBLE PRECISION XW,ZMASS,T3,EQ1,RR,RL,ZM2,AMP2,RKW,COLFAC(4),
     & AMPWW(4)
      INTEGER I,N1,N2,N3,N4,N5,N6
      EXTERNAL HWHEW4
      COMMON/HWHEWQ/ZH(7,7),ZCH(7,7),ZD(7,7)
      EQUIVALENCE (XW,SWEIN),(ZMASS,RMASS(200))
      DATA COLFAC/1.D0,3.D0,3.D0,9.D0/
      DATA ZTWO,ZHALF/(2.0,0.0),(0.5,0.0)/
      T3=-1.D0
      EQ1=-1.D0
      RR=-2.D0*EQ1*XW
      RL=T3+RR
      ZM2=ZMASS*ZMASS
      ZAMP1=CMPLX(ZM2)/(ZTWO*ZD(N1,N2))
     &                /(ZTWO*ZD(N1,N2)+CMPLX(-ZM2,GAMZ*ZMASS))
      ZAMP2=ZHALF/(ZD(N1,N3)+ZD(N1,N4)+ZD(N3,N4))
      ZAMP3=ZHALF/(ZD(N1,N5)+ZD(N1,N6)+ZD(N5,N6))
      DWW=CMPLX(RL)*ZAMP1+T3/(ZTWO*ZD(N1,N2))
      CWW=CMPLX(RR)*ZAMP1
      AWW=DWW
      BWW=DWW-ZAMP3
      AWWM=AWW*HWHEW4(N1,N2,N3,N4,N5,N6)-BWW*HWHEW4(N1,N2,N5,N6,N3,N4)
      AWWP=CWW*(HWHEW4(N2,N1,N5,N6,N3,N4)-HWHEW4(N2,N1,N3,N4,N5,N6))
      AMPTEM=AWWM*CONJG(AWWM)+AWWP*CONJG(AWWP)
      AMP2=REAL(AMPTEM)
C AMP2 DOES NOT INCLUDE COLOR OR FLAVOR SUMS OR AVERAGES YET
C NOR DOES IT INCLUDE TO THIS POINT KWW**2
C 1 LEPTON FLAVOR IF APPROPRIATE FOR NFINAL CHOICE
      RKW=0.25D0/XW**2
      DO 6 I=1,4
6     AMPWW(I)=AMP2*COLFAC(I)*RKW*RKW
      RETURN
      END
CDECK  ID>, HWHEW4.
*CMZ :-        -26/04/91  10.18.57  by  Bryan Webber
*-- Author :    Zoltan Kunszt, modified by Bryan Webber
C-----------------------------------------------------------------------
      FUNCTION HWHEW4(N1,N2,N3,N4,N5,N6)
C-----------------------------------------------------------------------
      IMPLICIT NONE
      COMPLEX HWHEW4,ZH,ZCH,ZD
      INTEGER N1,N2,N3,N4,N5,N6
      COMMON/HWHEWQ/ZH(7,7),ZCH(7,7),ZD(7,7)
      HWHEW4=CMPLX(4.0)*ZH(N1,N3)*ZCH(N2,N6)*(ZH(N1,N5)*ZCH(N1,N4)
     X                                       +ZH(N3,N5)*ZCH(N3,N4))
      RETURN
      END
CDECK  ID>, HWHEW5.
*CMZ :          20/08/91  22.09.33  by  Federico Carminati
*-- Author :    Zoltan Kunszt, modified by Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HWHEW5(N1,N2,N3,N4,N5,N6,HELSUM,HELCTY,ID1,ID2)
C-----------------------------------------------------------------------
C RECALL THAT N1,N3,N5 MUST BE OUTGOING FERMIONS, AND N2,N4,N6 MUST BE
C OUTGOING ANTI-FERMIONS; 3,4 FOR Z0, 5,6 FOR Z0
C
C EQ1 AND T31 ARE FOR OUTOING INITIAL QUARK
C CHOOSE APPROPRIATE CASE ACCORDING TO NUPDN
C NUPDN=1 FOR UUBAR COLLISIONS, NUPDN=2 FOR DDBAR COLLISIONS
C NFINAL CHOOSES THE FINAL DECAYS, 1 FOR DOUBLE LEPTON, 2 FOR 1 FLAVOR
C LEPTON+2FAMILIES OF QUARKS, 3 THE SAME, 4 FOR DOUBLE 2FAM3COLOR QUARKS
C
C NOTE: EXTERNAL FACTOR OF COLOR AVERAGE AND SPIN AVERAGE AND
C COUPLING (E**8/4/9) MUST BE INCLUDED AS WELL AS COMPENSATION
C FOR ON POLE APPROXIMATION AS DESIRED.
C
C---SLIGHTLY MODIFIED BY MHS, SO THAT HELCTY REFERS TO THE FINAL STATE
C   INDICATED BY ID1,ID2
C-----------------------------------------------------------------------
      IMPLICIT NONE
      COMPLEX HWHEW4,ZH,ZCH,ZD,ZAMM(8),ZS134,ZS156,ZS234,ZS256,ZTWO
      DOUBLE PRECISION CPFAC,CPALL,HELSUM,HELCTY,AMM
      INTEGER N1,N2,N3,N4,N5,N6,ID1,ID2,I
      EXTERNAL HWHEW4
      COMMON/HWHEWQ/ZH(7,7),ZCH(7,7),ZD(7,7)
      COMMON/HWHEWR/CPFAC(12,12,8),CPALL(8)
      DATA ZTWO/(2.0,0.0)/
C THE MATRIX ELEMENT DEPENDS ON
      ZS134=(ZD(N1,N3)+ZD(N1,N4)+ZD(N3,N4))*ZTWO
      ZS156=(ZD(N1,N5)+ZD(N1,N6)+ZD(N5,N6))*ZTWO
      ZS234=(ZD(N2,N3)+ZD(N2,N4)+ZD(N3,N4))*ZTWO
      ZS256=(ZD(N2,N5)+ZD(N2,N6)+ZD(N5,N6))*ZTWO
      ZAMM(1)=HWHEW4(N1,N2,N3,N4,N5,N6)/ZS134+
     >        HWHEW4(N1,N2,N5,N6,N3,N4)/ZS156
      ZAMM(2)=HWHEW4(N1,N2,N4,N3,N5,N6)/ZS134+
     >        HWHEW4(N1,N2,N5,N6,N4,N3)/ZS156
      ZAMM(3)=HWHEW4(N1,N2,N3,N4,N6,N5)/ZS134+
     >        HWHEW4(N1,N2,N6,N5,N3,N4)/ZS156
      ZAMM(4)=HWHEW4(N1,N2,N4,N3,N6,N5)/ZS134+
     >        HWHEW4(N1,N2,N6,N5,N4,N3)/ZS156
      ZAMM(5)=HWHEW4(N2,N1,N3,N4,N5,N6)/ZS234+
     >        HWHEW4(N2,N1,N5,N6,N3,N4)/ZS256
      ZAMM(6)=HWHEW4(N2,N1,N4,N3,N5,N6)/ZS234+
     >        HWHEW4(N2,N1,N5,N6,N4,N3)/ZS256
      ZAMM(7)=HWHEW4(N2,N1,N3,N4,N6,N5)/ZS234+
     >        HWHEW4(N2,N1,N6,N5,N3,N4)/ZS256
      ZAMM(8)=HWHEW4(N2,N1,N4,N3,N6,N5)/ZS234+
     >        HWHEW4(N2,N1,N6,N5,N4,N3)/ZS256
      HELSUM=0.0
      HELCTY=0.0
      DO 1 I=1,8
        AMM=REAL(ZAMM(I)*CONJG(ZAMM(I)))
        HELSUM=HELSUM+CPALL(I)*AMM
        HELCTY=HELCTY+CPFAC(ID1,ID2,I)*AMM
 1    CONTINUE
      RETURN
      END
CDECK  ID>, HWHEWW.
*CMZ :-        -02/05/91  10.58.29  by  Federico Carminati
*-- Author :    Zoltan Kunszt, modified by Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWHEWW
C-----------------------------------------------------------------------
C     E+E- -> W+W-/Z0Z0 (BASED ON ZOLTAN KUNSZT'S PROGRAM)
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      COMPLEX ZH,ZCH,ZD
      DOUBLE PRECISION HWUAEM,HWRGEN,HWUPCM,ETOT,STOT,FLUXW,GAMM,GIMM,
     & WM2,WXMIN,WX1MAX,WX2MAX,FJAC1,FJAC2,WX1,WX2,WMM1,WMM2,XXM,W2BO,
     & PST,WEIGHT,TOTSIG,WMASS,WWIDTH,ELST,CV,CA,BR,XMASS,PLAB,PRW,PCM,
     & AMPWW(4),CCC,HELSUM,HELCTY,BRZED(12),BRTOT,CPFAC,CPALL,RLL(12),
     & RRL(12),DIST(4)
      INTEGER IB,IBOS,I,ID1,ID2,NTRY,IDP(10),IDBOS(2),J1,J2,IPRC,ILST,
     & IDZOLT(16),MAP(12),NEWHEP
      LOGICAL EISBM1,HWRLOG
      EXTERNAL HWUAEM,HWRGEN,HWUPCM
      SAVE IDP,STOT,FLUXW,GAMM,GIMM,WM2,WXMIN,WX1MAX,FJAC1,ELST,ILST,
     & IDBOS,WMASS,WWIDTH
      COMMON/HWHEWP/XMASS(10),PLAB(5,10),PRW(5,2),PCM(5,10)
      COMMON/HWHEWQ/ZH(7,7),ZCH(7,7),ZD(7,7)
      COMMON/HWHEWR/CPFAC(12,12,8),CPALL(8)
      DATA ELST,ILST/0.,0/
      DATA IDZOLT/4,3,8,7,12,11,4*0,2,1,6,5,10,9/
      DATA MAP/12,11,2,1,14,13,4,3,16,15,6,5/
      IF (IERROR.NE.0) RETURN
      EISBM1=IDHW(1).LT.IDHW(2)
      IF (GENEV) THEN
        NEWHEP=NHEP
        NHEP=NHEP+2
        DO 20 IB=1,2
        IBOS=IB+NEWHEP
        CALL HWVEQU(5,PRW(1,IB),PHEP(1,IBOS))
        IF (EISBM1) PHEP(3,IBOS)=-PHEP(3,IBOS)
        CALL HWVZRO(4,VHEP(1,IBOS))
        CALL HWUDKL(IDBOS(IB),PHEP(1,IBOS),DIST)
        CALL HWVSUM(4,VHEP(1,IBOS),DIST,DIST)
        IDHW(IBOS)=IDBOS(IB)
        IDHEP(IBOS)=IDPDG(IDBOS(IB))
        JMOHEP(1,IBOS)=1
        JMOHEP(2,IBOS)=2
        ISTHEP(IBOS)=110
        DO 10 I=1,2
          CALL HWVEQU(5,PLAB(1,2*IB+I),PHEP(1,NHEP+I))
          IF (EISBM1) PHEP(3,NHEP+I)=-PHEP(3,NHEP+I)
          CALL HWVEQU(4,DIST,VHEP(1,NHEP+I))
C---STATUS, IDs AND POINTERS
          ISTHEP(NHEP+I)=112+I
          IDHW(NHEP+I)=IDP(2*IB+I)
          IDHEP(NHEP+I)=IDPDG(IDP(2*IB+I))
          JDAHEP(I,IBOS)=NHEP+I
          JMOHEP(1,NHEP+I)=IBOS
          JMOHEP(2,NHEP+I)=JMOHEP(1,IBOS)
 10     CONTINUE
        NHEP=NHEP+2
        JMOHEP(2,NHEP)=NHEP-1
        JDAHEP(2,NHEP)=NHEP-1
        JMOHEP(2,NHEP-1)=NHEP
        JDAHEP(2,NHEP-1)=NHEP
 20     CONTINUE
      ELSE
        EMSCA=PHEP(5,3)
        ETOT=EMSCA
        IPRC=MOD(IPROC,100)
        IF (ETOT.NE.ELST .OR. IPRC.NE.ILST) THEN
          STOT=ETOT*ETOT
          FLUXW=GEV2NB*.125*(HWUAEM(STOT)/PIFAC)**4/STOT
          IF (IPRC.EQ.0) THEN
            WMASS=RMASS(198)
            WWIDTH=GAMW
            IDBOS(1)=198
            IDBOS(2)=199
          ELSEIF (IPRC.EQ.50) THEN
            WMASS=RMASS(200)
            WWIDTH=GAMZ
            IDBOS(1)=200
            IDBOS(2)=200
C---LOAD FERMION COUPLINGS TO Z
            DO 30 I=1,12
              RLL(I)=VFCH(MAP(I),1)+AFCH(MAP(I),1)
              RRL(I)=VFCH(MAP(I),1)-AFCH(MAP(I),1)
 30         CONTINUE
            RLL(11)=0
            RRL(11)=0
            BRTOT=0
            DO 60 J1=1,12
              BRZED(J1)=0
              DO 50 J2=1,12
                CCC=1
                IF (MOD(J1-1,4).GE.2) CCC=CCC*CAFAC
                IF (MOD(J2-1,4).GE.2) CCC=CCC*CAFAC
                CPFAC(J1,J2,1)=CCC*(RLL(2)**2*RLL(J1)*RLL(J2))**2
                CPFAC(J1,J2,2)=CCC*(RLL(2)**2*RRL(J1)*RLL(J2))**2
                CPFAC(J1,J2,3)=CCC*(RLL(2)**2*RLL(J1)*RRL(J2))**2
                CPFAC(J1,J2,4)=CCC*(RLL(2)**2*RRL(J1)*RRL(J2))**2
                CPFAC(J1,J2,5)=CCC*(RRL(2)**2*RLL(J1)*RLL(J2))**2
                CPFAC(J1,J2,6)=CCC*(RRL(2)**2*RRL(J1)*RLL(J2))**2
                CPFAC(J1,J2,7)=CCC*(RRL(2)**2*RLL(J1)*RRL(J2))**2
                CPFAC(J1,J2,8)=CCC*(RRL(2)**2*RRL(J1)*RRL(J2))**2
                DO 40 I=1,8
                  IF (J1.EQ.1.AND.J2.EQ.1) CPALL(I)=0
                  CPALL(I)=CPALL(I)+CPFAC(J1,J2,I)
                  BRZED(J1)=BRZED(J1)+CPFAC(J1,J2,I)
                  BRTOT=BRTOT+CPFAC(J1,J2,I)
 40             CONTINUE
 50           CONTINUE
 60         CONTINUE
            DO 70 I=1,12
 70           BRZED(I)=BRZED(I)/BRTOT
          ELSE
            CALL HWWARN('HWHEWW',500,*999)
          ENDIF
          GAMM=WMASS*WWIDTH
          GIMM=1.D0/GAMM
          WM2=WMASS*WMASS
          WXMIN=ATAN(-WMASS/WWIDTH)
          WX1MAX=ATAN((STOT-WM2)*GIMM)
          FJAC1=WX1MAX-WXMIN
          ILST=IPRC
          ELST=ETOT
        ENDIF
        EVWGT=0
C---CHOOSE W MASSES
        WX1=WXMIN+FJAC1*HWRGEN(1)
        WMM1=GAMM*TAN(WX1)+WM2
CAST        write(6,*) 'wwm1',wmm1,wx1,fjac1,wxmin,gamm
        if(wmm1.le.0) call hwwarn('HWHEWW',101,*999)
        XMASS(1)=SQRT(WMM1)
        WX2MAX=ATAN(((ETOT-XMASS(1))**2-WM2)*GIMM)
        FJAC2=WX2MAX-WXMIN
        WX2=WXMIN+FJAC2*HWRGEN(2)
        WMM2=GAMM*TAN(WX2)+WM2
CAST        write(6,*) 'wwm2',wmm2,wx2,fjac2,wm2
        if(wmm2.le.0) call hwwarn('HWHEWW',102,*999)
        XMASS(2)=SQRT(WMM2)
        IF (HWRLOG(HALF))THEN
         XXM=XMASS(1)
         XMASS(1)=XMASS(2)
         XMASS(2)=XXM
        ENDIF
C---CTMAX=ANGULAR CUT ON COS W-ANGLE
        CALL HWHEW0(1,ETOT,XMASS(1),PRW(1,1),W2BO,CTMAX)
        IF (W2BO.EQ.0) RETURN
C---FOR ZZ EVENTS, FORCE BOSE STATISTICS, BY KILLING EVENTS WITH COS1<0
        IF (IPRC.NE.0) THEN
          IF (PRW(3,1).LT.0) RETURN
C---AND THEN SYMMETRIZE (THIS PROCEDURE VASTLY IMPROVES EFFICIENCY)
          IF (HWRLOG(HALF)) THEN
            PRW(3,1)=-PRW(3,1)
            PRW(3,2)=-PRW(3,2)
          ENDIF
        ENDIF
        PLAB(3,1)=0.5*ETOT
        PLAB(4,1)=PLAB(3,1)
        PLAB(3,2)=-PLAB(3,1)
        PLAB(4,2)=PLAB(3,1)
C
C---LET THE W BOSONS DECAY
        NTRY=0
 80     NTRY=NTRY+1
        DO 90 IB=1,2
        CALL HWDBOZ(IDBOS(IB),ID1,ID2,CV,CA,BR,1)
        PST=HWUPCM(XMASS(IB),RMASS(ID1),RMASS(ID2))
        IF (PST.LT.0.) THEN
          CALL HWDBOZ(IDBOS(IB),ID1,ID2,CV,CA,BR,2)
          IF (NTRY.LE.NBTRY) GOTO 80
C          CALL HWWARN('HWHEWW',1,*999)
          RETURN
        ENDIF
        PRW(5,IB)=XMASS(IB)
        IDP(2*IB+1)=ID1
        IDP(2*IB+2)=ID2
        PLAB(5,2*IB+1)=RMASS(ID1)
        PLAB(5,2*IB+2)=RMASS(ID2)
        CALL HWDTWO(PRW(1,IB),PLAB(1,2*IB+1),PLAB(1,2*IB+2),
     &              PST,TWO,.TRUE.)
 90     CONTINUE
        WEIGHT=FLUXW*W2BO*FJAC1*FJAC2*(0.5D0*PIFAC*GIMM)**2
        CALL HWHEW1(6)
        CALL HWHEW2(6,PCM(1,1),ZH,ZCH,ZD)
        IF (IPRC.EQ.0) THEN
          CALL HWHEW3(5,6,3,4,1,2,AMPWW)
          TOTSIG=9.*AMPWW(1)+6.*(AMPWW(2)+AMPWW(3))+4.*AMPWW(4)
          EVWGT=TOTSIG*WEIGHT*BR
        ELSE
          ID1=IDZOLT(IDPDG(IDP(3)))
          ID2=IDZOLT(IDPDG(IDP(5)))
          CALL HWHEW5(5,6,3,4,1,2,HELSUM,HELCTY,ID1,ID2)
          EVWGT=HELCTY*WEIGHT*BR/(BRZED(ID1)*BRZED(ID2))
        ENDIF
      ENDIF
 999  END
CDECK  ID>, HWHHVY.
*CMZ :-        -26/04/91  14.55.44  by  Federico Carminati
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWHHVY
C-----------------------------------------------------------------------
C     QCD HEAVY FLAVOUR PRODUCTION: MEAN EVWGT = SIGMA IN NB
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,HWRUNI,HWUALF,EPS,RCS,Z1,Z2,ET,EJ,
     & QM2,QPE,FACTR,S,T,U,ST,TU,US,TUS,UST,EN,RN,AF,ASTU,
     & AUST,CF,CN,CS,CSTU,CSUT,CTSU,CTUS,HCS,UT,SU,GT,DIST,KK,KK2,
     & YJ1INF,YJ1SUP,YJ2INF,YJ2SUP
      INTEGER IQ1,IQ2,ID1,ID2
      LOGICAL HQ1,HQ2
      EXTERNAL HWRGEN,HWRUNI,HWUALF
      SAVE HCS
      PARAMETER (EPS=1.D-9)
      IF (GENEV) THEN
        RCS=HCS*HWRGEN(0)
      ELSE
        EVWGT=0.
        CALL HWRPOW(ET,EJ)
        KK = ET/PHEP(5,3)
        KK2=KK**2
        IF (KK.GE.1.) RETURN
        YJ1INF = MAX( YJMIN, LOG((ONE-SQRT(ONE-KK2))/KK) )
        YJ1SUP = MIN( YJMAX, LOG((ONE+SQRT(ONE-KK2))/KK) )
        IF (YJ1INF.GE.YJ1SUP) RETURN
        Z1=EXP(HWRUNI(1,YJ1INF,YJ1SUP))
        YJ2INF = MAX( YJMIN, -LOG(TWO/KK-ONE/Z1) )
        YJ2SUP = MIN( YJMAX, LOG(TWO/KK-Z1) )
        IF (YJ2INF.GE.YJ2SUP) RETURN
        Z2=EXP(HWRUNI(2,YJ2INF,YJ2SUP))
        XX(1)=HALF*(Z1+Z2)*KK
        IF (XX(1).GE.1.) RETURN
        XX(2)=XX(1)/(Z1*Z2)
        IF (XX(2).GE.1.) RETURN
        S=XX(1)*XX(2)*PHEP(5,3)**2
        IQ1=MOD(IPROC,100)
        QM2=RMASS(IQ1)**2
        QPE=S-4.*QM2
        IF (QPE.LT.0.) RETURN
        COSTH=HALF*ET*(Z1-Z2)/SQRT(Z1*Z2*QPE)
        IF (ABS(COSTH).GT.1.) RETURN
C---REDEFINE S, T, U AS P1.P2, -P1.P3, -P1.P4
        S=HALF*S
        T=-HALF*(1.+Z2/Z1)*(HALF*ET)**2
        U=-S-T
C---SET EMSCA TO HEAVY HARD PROCESS SCALE
        EMSCA=SQRT(4.*S*T*U/(S*S+T*T+U*U))
        FACTR = GEV2NB*.125*PIFAC*EJ*ET*(HWUALF(1,EMSCA)/S)**2
     &         *(YJ1SUP-YJ1INF)*(YJ2SUP-YJ2INF)
        CALL HWSGEN(.FALSE.)
C
        ST=S/T
        TU=T/U
        US=U/S
        TUS=US/ST
        UST=ST/TU
C
        EN=CAFAC
        RN=CFFAC/EN
        AF=FACTR*RN
        ASTU=AF*(1.-2.*UST+QM2/T)
        AUST=AF*(1.-2.*TUS+QM2/S)
        CF=FACTR/(2.*CFFAC)
        CN=1./(EN*EN)
        CS=HALF/TU-QM2/T-HALF*(QM2/T)**2
        CSTU=CF*(CS-   US**2-QM2/S - CN*(CS+QM2*QM2/(S*T)))
        CS=HALF*TU-QM2/U-HALF*(QM2/U)**2
        CSUT=CF*(CS-1./ST**2-QM2/S - CN*(CS+QM2*QM2/(S*U)))
        CS=HALF*US-QM2/S-HALF*(QM2/S)**2
        CTSU=-FACTR*(CS-1./TU**2-QM2/T - CN*(CS+QM2*QM2/(S*T)))
        CS=HALF/US-QM2/U-HALF*(QM2/U)**2
        CTUS=-FACTR*(CS-   ST**2-QM2/T - CN*(CS+QM2*QM2/(T*U)))
      ENDIF
C
      HCS=0.
      IQ2=IQ1+6
      DO 6 ID1=1,13
      IF (DISF(ID1,1).LT.EPS) GOTO 6
      HQ1=ID1.EQ.IQ1.OR.ID1.EQ.IQ2
      DO 5 ID2=1,13
      IF (DISF(ID2,2).LT.EPS) GOTO 5
      HQ2=ID2.EQ.IQ1.OR.ID2.EQ.IQ2
      DIST=DISF(ID1,1)*DISF(ID2,2)
      IF (HQ1.OR.HQ2) THEN
C---PROCESSES INVOLVING HEAVY CONSTITUENT
C   N.B. NEGLECT CASE THAT BOTH ARE HEAVY
      IF (HQ1.AND.HQ2) GOTO 5
      IF (ID1.LT.7) THEN
C---QUARK FIRST
       IF (ID2.LT.7) THEN
         HCS=HCS+ASTU*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,3421, 3,*9)
       ELSEIF (ID2.NE.13) THEN
         HCS=HCS+ASTU*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,3142, 9,*9)
       ELSE
         HCS=HCS+CTSU*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,3142,10,*9)
         HCS=HCS+CTUS*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,3421,11,*9)
       ENDIF
      ELSEIF (ID1.NE.13) THEN
C---QBAR FIRST
       IF (ID2.LT.7) THEN
         HCS=HCS+ASTU*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,2413,17,*9)
       ELSEIF (ID2.NE.13) THEN
         HCS=HCS+ASTU*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,4312,20,*9)
       ELSE
         HCS=HCS+CTSU*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,2413,21,*9)
         HCS=HCS+CTUS*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,4312,22,*9)
       ENDIF
      ELSE
C---GLUON FIRST
       IF (ID2.LT.7) THEN
         HCS=HCS+CTSU*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,2413,23,*9)
         HCS=HCS+CTUS*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,3421,24,*9)
       ELSEIF (ID2.LT.13) THEN
         HCS=HCS+CTSU*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,3142,25,*9)
         HCS=HCS+CTUS*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,4312,26,*9)
       ENDIF
      ENDIF
      ELSEIF (ID2.NE.13.AND.ID2.EQ.ID1+6) THEN
C---LIGHT Q-QBAR ANNIHILATION
         HCS=HCS+AUST*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(IQ1,IQ2,2413, 4,*9)
      ELSEIF (ID1.NE.13.AND.ID1.EQ.ID2+6) THEN
C---LIGHT QBAR-Q ANNIHILATION
         HCS=HCS+AUST*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(IQ2,IQ1,3142,12,*9)
      ELSEIF (ID1.EQ.13.AND.ID2.EQ.13) THEN
C---GLUON FUSION
         HCS=HCS+CSTU*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(IQ1,IQ2,2413,27,*9)
         HCS=HCS+CSUT*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(IQ1,IQ2,4123,28,*9)
      ENDIF
    5 CONTINUE
    6 CONTINUE
      EVWGT=HCS
      RETURN
C---GENERATE EVENT
    9 IDN(1)=ID1
      IDN(2)=ID2
      IDCMF=15
      CALL HWETWO
      IF (AZSPIN) THEN
C Calculate coefficients for constructing spin density matrices
         IF (IHPRO.EQ.7 .OR.IHPRO.EQ.8 .OR.
     &       IHPRO.EQ.15.OR.IHPRO.EQ.16) THEN
C qqbar-->gg or qbarq-->gg
            UT=1./TU
            GCOEF(1)=UT+TU
            GCOEF(2)=-2.
            GCOEF(3)=0.
            GCOEF(4)=0.
            GCOEF(5)=GCOEF(1)
            GCOEF(6)=UT-TU
            GCOEF(7)=-GCOEF(6)
         ELSEIF (IHPRO.EQ.10.OR.IHPRO.EQ.11.OR.
     &           IHPRO.EQ.21.OR.IHPRO.EQ.22.OR.
     &           IHPRO.EQ.23.OR.IHPRO.EQ.24.OR.
     &           IHPRO.EQ.25.OR.IHPRO.EQ.26) THEN
C qg-->qg or qbarg-->qbarg or gq-->gq  or gqbar-->gqbar
            SU=1./US
            GCOEF(1)=-(SU+US)
            GCOEF(2)=0.
            GCOEF(3)=2.
            GCOEF(4)=0.
            GCOEF(5)=SU-US
            GCOEF(6)=GCOEF(1)
            GCOEF(7)=-GCOEF(5)
         ELSEIF (IHPRO.EQ.27.OR.IHPRO.EQ.28) THEN
C gg-->qqbar
            UT=1./TU
            GCOEF(1)=TU+UT
            GCOEF(2)=-2.
            GCOEF(3)=0.
            GCOEF(4)=0.
            GCOEF(5)=GCOEF(1)
            GCOEF(6)=TU-UT
            GCOEF(7)=-GCOEF(6)
         ELSEIF (IHPRO.EQ.29.OR.IHPRO.EQ.30.OR.
     &                          IHPRO.EQ.31) THEN
C gg-->gg
            GT=S*S+T*T+U*U
            GCOEF(2)=2.*U*U*T*T
            GCOEF(3)=2.*S*S*U*U
            GCOEF(4)=2.*S*S*T*T
            GCOEF(1)=GT*GT-GCOEF(2)-GCOEF(3)-GCOEF(4)
            GCOEF(5)=GT*(GT-2.*S*S)-GCOEF(2)
            GCOEF(6)=GT*(GT-2.*T*T)-GCOEF(3)
            GCOEF(7)=GT*(GT-2.*U*U)-GCOEF(4)
         ELSE
            CALL HWVZRO(7,GCOEF)
         ENDIF
      ENDIF
  999 END
CDECK  ID>, HWHIG1.
*CMZ :-        -23/08/94  13.22.29  by  Mike Seymour
*-- Author :    Ulrich Baur & Nigel Glover, adapted by Ian Knowles
C-----------------------------------------------------------------------
      FUNCTION HWHIG1(S,T,U,EH2,EQ2,I,J,K,I1,J1,K1)
C-----------------------------------------------------------------------
C     Basic matrix elements for Higgs + jet production; used in HWHIGA
C-----------------------------------------------------------------------
      IMPLICIT NONE
      DOUBLE COMPLEX HWHIG1,HWHIG2,HWHIG5,BI(4),CI(7),DI(3)
      DOUBLE PRECISION S,T,U,EH2,EQ2,S1,T1,U1,ONE,TWO,FOUR,HALF
      INTEGER I,J,K,I1,J1,K1
      COMMON/CINTS/BI,CI,DI
      PARAMETER (ONE =1.D0, TWO =2.D0, FOUR =4.D0, HALF =0.5D0)
C-----------------------------------------------------------------------
C     +++ helicity amplitude for: g+g --> g+H
C-----------------------------------------------------------------------
      S1=S-EH2
      T1=T-EH2
      U1=U-EH2
      HWHIG1=EQ2*FOUR*DSQRT(TWO*S*T*U)*(
     & -FOUR*(ONE/(U*T)+ONE/(U*U1)+ONE/(T*T1))
     & -FOUR*((TWO*S+T)*BI(K)/U1**2+(TWO*S+U)*BI(J)/T1**2)/S
     & -(S-FOUR*EQ2)*(S1*CI(I1)+(U-S)*CI(J1)+(T-S)*CI(K1))/(S*T*U)
     & -8.D0*EQ2*(CI(J1)/(T*T1)+CI(K1)/(U*U1))
     & +HALF*(S-FOUR*EQ2)*(S*T*DI(K)+U*S*DI(J)-U*T*DI(I))/(S*T*U)
     & +FOUR*EQ2*DI(I)/S
     & -TWO*(U*CI(K)+T*CI(J)+U1*CI(K1)+T1*CI(J1)-U*T*DI(I))/S**2 )
      RETURN
C-----------------------------------------------------------------------
      ENTRY HWHIG2(S,T,U,EH2,EQ2,I,J,K,I1,J1,K1)
C-----------------------------------------------------------------------
C     ++- helicity amplitude for: g+g --> g+H
C-----------------------------------------------------------------------
      S1=S-EH2
      T1=T-EH2
      U1=U-EH2
      HWHIG2=EQ2*FOUR*DSQRT(TWO*S*T*U)*(FOUR*EH2
     & +(EH2-FOUR*EQ2)*(S1*CI(4)+T1*CI(5)+U1*CI(6))
     & -HALF*(EH2-FOUR*EQ2)*(S*T*DI(3)+U*S*DI(2)+U*T*DI(1)) )/(S*T*U)
      RETURN
C-----------------------------------------------------------------------
      ENTRY HWHIG5(S,T,U,EH2,EQ2,I,J,K,I1,J1,K1)
C-----------------------------------------------------------------------
C     Amplitude for: q+qbar --> g+H
C-----------------------------------------------------------------------
      HWHIG5=DCMPLX(TWO+TWO*S/(S-EH2))*BI(I)+DCMPLX(FOUR*EQ2-U-T)*CI(K)
      RETURN
      END
CDECK  ID>, HWHIGA.
*CMZ :-        -23/08/94  13.22.29  by  Mike Seymour
*-- Author :    Ulrich Baur & Nigel Glover, adapted by Ian Knowles
C-----------------------------------------------------------------------
      SUBROUTINE HWHIGA(S,T,U,EMH2,WTQQ,WTQG,WTGQ,WTGG)
C-----------------------------------------------------------------------
C     Gives amplitudes squared for q-qbar, q(bar)-g and gg -> Higgs +jet
C     IAPHIG (set in HWIGIN)=0: zero mass approximation =1: exact result
C                           =2: infinite mass limit.
C     Only top loop included. A factor (alpha_s**3*alpha_W) is extracted
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE COMPLEX HWHIGB,HWHIGC,HWHIGD,HWHIG5,HWHIG1,HWHIG2,BI(4),
     & CI(7),DI(3),EPSI,TAMP(7)
      DOUBLE PRECISION S,T,U,EMH2,WTQQ,WTQG,WTGQ,WTGG,EMW2,RNGLU,RNQRK,
     & FLUXGG,FLUXGQ,FLUXQQ,EMQ2,TAMPI(7),TAMPR(7)
      INTEGER I
      LOGICAL NOMASS
      EXTERNAL HWHIGB,HWHIGC,HWHIGD,HWHIG5,HWHIG1,HWHIG2
      COMMON/SMALL/EPSI
      COMMON/CINTS/BI,CI,DI
      EPSI=CMPLX(ZERO,-1.D-10)
      EMW2=RMASS(198)**2
C Spin and colour flux factors plus enhancement factor
      RNGLU=1./FLOAT(NCOLO**2-1)
      RNQRK=1./FLOAT(NCOLO)
      FLUXGG=.25*RNGLU**2*ENHANC(6)**2
      FLUXGQ=.25*RNGLU*RNQRK*ENHANC(6)**2
      FLUXQQ=.25*RNQRK**2*ENHANC(6)**2
      IF (IAPHIG.EQ.2) THEN
C Infinite mass limit in loops
         WTGG=2./3.*FLOAT(NCOLO*(NCOLO**2-1))
     &       *(EMH2**4+S**4+T**4+U**4)/(S*T*U*EMW2)*FLUXGG
         WTQQ= 16./9.*(U**2+T**2)/(S*EMW2)*FLUXQQ
         WTQG=-16./9.*(U**2+S**2)/(T*EMW2)*FLUXGQ
         WTGQ=-16./9.*(S**2+T**2)/(U*EMW2)*FLUXGQ
         RETURN
      ELSEIF (IAPHIG.EQ.1) THEN
C Exact result for loops
         NOMASS=.FALSE.
      ELSEIF (IAPHIG.EQ.0) THEN
C Small mass approximation in loops
         NOMASS=.TRUE.
      ELSE
         CALL HWWARN('HWHIGA',500,*999)
      ENDIF
C Include only top quark contribution
      EMQ2=RMASS(6)**2
      BI(1)=HWHIGB(NOMASS,S,0,0,EMQ2)
      BI(2)=HWHIGB(NOMASS,T,0,0,EMQ2)
      BI(3)=HWHIGB(NOMASS,U,0,0,EMQ2)
      BI(4)=HWHIGB(NOMASS,EMH2,0,0,EMQ2)
      BI(1)=BI(1)-BI(4)
      BI(2)=BI(2)-BI(4)
      BI(3)=BI(3)-BI(4)
      CI(1)=HWHIGC(NOMASS,S,0,0,EMQ2)
      CI(2)=HWHIGC(NOMASS,T,0,0,EMQ2)
      CI(3)=HWHIGC(NOMASS,U,0,0,EMQ2)
      CI(7)=HWHIGC(NOMASS,EMH2,0,0,EMQ2)
      CI(4)=(S*CI(1)-EMH2*CI(7))/(S-EMH2)
      CI(5)=(T*CI(2)-EMH2*CI(7))/(T-EMH2)
      CI(6)=(U*CI(3)-EMH2*CI(7))/(U-EMH2)
      DI(1)=HWHIGD(NOMASS,U,T,EMH2,EMQ2)
      DI(2)=HWHIGD(NOMASS,S,U,EMH2,EMQ2)
      DI(3)=HWHIGD(NOMASS,S,T,EMH2,EMQ2)
C Compute complex amplitudes
      TAMP(1)=HWHIG1(S,T,U,EMH2,EMQ2,1,2,3,4,5,6)
      TAMP(2)=HWHIG2(S,T,U,EMH2,EMQ2,1,2,3,0,0,0)
      TAMP(3)=HWHIG1(T,S,U,EMH2,EMQ2,2,1,3,5,4,6)
      TAMP(4)=HWHIG1(U,T,S,EMH2,EMQ2,3,2,1,6,5,4)
      TAMP(5)=HWHIG5(S,T,U,EMH2,EMQ2,1,0,4,0,0,0)
      TAMP(6)=HWHIG5(T,S,U,EMH2,EMQ2,2,0,5,0,0,0)
      TAMP(7)=HWHIG5(U,T,S,EMH2,EMQ2,3,0,6,0,0,0)
      DO 20 I=1,7
      TAMPI(I)= DREAL(TAMP(I))
  20  TAMPR(I)=-IMAG(TAMP(I))
C Square and add prefactors
      WTGG=0.03125*FLOAT(NCOLO*(NCOLO**2-1))
     &    *(TAMPR(1)**2+TAMPI(1)**2+TAMPR(2)**2+TAMPI(2)**2
     &     +TAMPR(3)**2+TAMPI(3)**2+TAMPR(4)**2+TAMPI(4)**2)*FLUXGG
      WTQQ= 16.*(U**2+T**2)/(U+T)**2*EMQ2**2/(S*EMW2)
     &     *(TAMPR(5)**2+TAMPI(5)**2)*FLUXQQ
      WTQG=-16.*(U**2+S**2)/(U+S)**2*EMQ2**2/(T*EMW2)
     &     *(TAMPR(6)**2+TAMPI(6)**2)*FLUXGQ
      WTGQ=-16.*(S**2+T**2)/(S+T)**2*EMQ2**2/(U*EMW2)
     &     *(TAMPR(7)**2+TAMPI(7)**2)*FLUXGQ
 999  RETURN
      END
CDECK  ID>, HWHIGB.
*CMZ :-        -23/08/94  13.22.29  by  Mike Seymour
*-- Author :    Ulrich Baur & Nigel Glover, adapted by Ian Knowles
C-----------------------------------------------------------------------
      FUNCTION HWHIGB(NOMASS,S,T,EH2,EQ2)
C-----------------------------------------------------------------------
C     One loop scalar integrals, used in HWHIGJ.
C     If NOMASS=.TRUE. use a small mass approx. for particle in loop.
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE COMPLEX HWHIGB,HWHIGC,HWHIGD,HWUCI2,HWULI2,EPSI,PII,Z1,Z2
      DOUBLE PRECISION S,T,EQ2,EH2,RAT,COSH,DLS,DLT,DLM,RZ12,DL1,DL2,
     & ST,ROOT,XP,XM
      LOGICAL NOMASS
      EXTERNAL HWULI2,HWUCI2
      COMMON/SMALL/EPSI
C-----------------------------------------------------------------------
C     B_0(2p1.p2=S;mq,mq)
C-----------------------------------------------------------------------
      PII=CMPLX(ZERO,PIFAC)
      IF (NOMASS) THEN
         RAT=DABS(S/EQ2)
         HWHIGB=-DLOG(RAT)+TWO
         IF (S.GT.ZERO) HWHIGB=HWHIGB+PII
      ELSE
         RAT=S/(FOUR*EQ2)
         IF (S.LT.ZERO) THEN
            HWHIGB=TWO-TWO*DSQRT(ONE-ONE/RAT)
     &                    *DLOG(DSQRT(-RAT)+DSQRT(ONE-RAT))
         ELSEIF (S.GT.ZERO.AND.RAT.LT.ONE) THEN
            HWHIGB=TWO-TWO*DSQRT(ONE/RAT-ONE)*DASIN(DSQRT(RAT))
         ELSEIF (RAT.GT.ONE) THEN
            HWHIGB=TWO-DSQRT(ONE-ONE/RAT)
     &                *(TWO*DLOG(DSQRT(RAT)+DSQRT(RAT-ONE))-PII)
         ENDIF
      ENDIF
      RETURN
C-----------------------------------------------------------------------
      ENTRY HWHIGC(NOMASS,S,T,EH2,EQ2)
C-----------------------------------------------------------------------
C     C_0(p{1,2}^2=0,2p1.p2=S;mq,mq,mq)
C-----------------------------------------------------------------------
      PII=CMPLX(ZERO,PIFAC)
      IF (NOMASS) THEN
         RAT=DABS(S/EQ2)
         HWHIGC=HALF*DLOG(RAT)**2
         IF (S.GT.ZERO) HWHIGC=HWHIGC-HALF*PIFAC**2-PII*DLOG(RAT)
         HWHIGC=HWHIGC/S
      ELSE
         RAT=S/(FOUR*EQ2)
         IF (S.LT.ZERO) THEN
            HWHIGC=TWO*DLOG(DSQRT(-RAT)+DSQRT(ONE-RAT))**2/S
         ELSEIF (S.GT.ZERO.AND.RAT.LT.ONE) THEN
            HWHIGC=-TWO*(DASIN(DSQRT(RAT)))**2/S
         ELSEIF (RAT.GT.ONE) THEN
            COSH=DLOG(DSQRT(RAT)+DSQRT(RAT-ONE))
            HWHIGC=TWO*(COSH**2-PIFAC**2/FOUR-PII*COSH)/S
         ENDIF
      ENDIF
      RETURN
C-----------------------------------------------------------------------
      ENTRY HWHIGD(NOMASS,S,T,EH2,EQ2)
C-----------------------------------------------------------------------
C     D_0(p{1,2,3}^2=0,p4^2=EH2,2p1.p2=S,2p2.p3=T;mq,mq,mq,mq)
C-----------------------------------------------------------------------
      PII=CMPLX(ZERO,PIFAC)
      IF (NOMASS) THEN
         DLS=DLOG(DABS(S/EQ2))
         DLT=DLOG(DABS(T/EQ2))
         DLM=DLOG(DABS(EH2/EQ2))
         IF (S.GE.ZERO.AND.T.LE.ZERO) THEN
            DL1=DLOG((EH2-T)/S)
            Z1=T/(T-EH2)
            Z2=(S-EH2)/S
            HWHIGD=DLS**2+DLT**2-DLM**2+DL1**2
     &            +TWO*(DLOG(S/(EH2-T))*DLOG(-T/S)+HWULI2(Z1)-HWULI2(Z2)
     &                 +PII*DLOG(EH2/(EH2-T)))
         ELSEIF (S.LT.ZERO.AND.T.LT.ZERO) THEN
            Z1=(S-EH2)/S
            Z2=(T-EH2)/T
            RZ12=ONE/(Z1*Z2)
            DL1=DLOG((T-EH2)/(S-EH2))
            DL2=DLOG(RZ12)
            HWHIGD=DLS**2+DLT**2-DLM**2+TWO*PIFAC**2/THREE
     &            +TWO*DLOG(S/(T-EH2))*DLOG(ONE/DBLE(Z2))
     &            +TWO*DLOG(T/(S-EH2))*DLOG(ONE/DBLE(Z1))
     &            -DL1**2-DL2**2-TWO*(HWULI2(Z1)+HWULI2(Z2))
     &            +TWO*PII*DLOG(RZ12**2*EH2/EQ2)
         ENDIF
         HWHIGD=HWHIGD/(S*T)
      ELSE
         ST=S*T
         ROOT=DSQRT(ST**2-FOUR*ST*EQ2*(S+T-EH2))
         XP=HALF*(ST+ROOT)/ST
         XM=1-XP
         HWHIGD=TWO/ROOT*(-HWUCI2(EQ2,S,XP)-HWUCI2(EQ2,T,XP)
     &         +HWUCI2(EQ2,EH2,XP)+DLOG(-XM/XP)
     &         *(LOG(EQ2+EPSI)-LOG(EQ2+EPSI-S*XP*XM)
     &          +LOG(EQ2+EPSI-EH2*XP*XM)-LOG(EQ2+EPSI-T*XP*XM)))
      ENDIF
      RETURN
      END
CDECK  ID>, HWHIGJ
*CMZ :-        -23/08/94  13.22.29  by  Mike Seymour
*-- Author :    Ian Knowles
C-----------------------------------------------------------------------
      SUBROUTINE HWHIGJ
C-----------------------------------------------------------------------
C     QCD Higgs plus jet production; mean EVWGT = Sigma in nb*Higgs B.R.
C     Adapted from the program of U. Baur and E.W.N. Glover
C     See: Nucl. Phys. B339 (1990) 38
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,HWRUNI,HWUALF,HWUAEM,EPS,RCS,EMH,EMHWT,
     & EMHTMP,BR,CV,CA,EMH2,ET,EJ,PT,EMT,EMAX,YMAX,YHINF,YHSUP,EXYH,
     & YMIN,YJINF,YJSUP,EXYJ,S,T,U,FACT,AMPQQ,AMPQG,AMPGQ,AMPGG,HCS,
     & FACTR
      INTEGER I,IDEC,ID1,ID2
      EXTERNAL HWRGEN,HWRUNI,HWUALF,HWUAEM
      SAVE HCS,IDEC
      PARAMETER (EPS=1.D-9)
      IF (GENEV) THEN
         RCS=HCS*HWRGEN(0)
      ELSE
         EVWGT=0.
C Select a Higgs mass
         CALL HWHIGM(EMH,EMHWT)
         IF (EMH.LE.0 .OR. EMH.GE.PHEP(5,3)) RETURN
C Store branching ratio for specified Higgs deacy channel
         IDEC=MOD(IPROC,100)
         BR=1.
         IF (IDEC.EQ.0) THEN
            BR=0.
            DO 10 I=1,6
  10        BR=BR+BRHIG(I)
         ELSEIF (IDEC.EQ.10) THEN
            CALL HWDBOZ(198,ID1,ID2,CV,CA,BR,1)
            CALL HWDBOZ(199,ID1,ID2,CV,CA,BR,1)
            BR=BR*BRHIG(IDEC)
         ELSEIF (IDEC.EQ.11) THEN
            CALL HWDBOZ(200,ID1,ID2,CV,CA,BR,1)
            CALL HWDBOZ(200,ID1,ID2,CV,CA,BR,1)
            BR=BR*BRHIG(IDEC)
         ELSEIF (IDEC.LE.12) THEN
            BR=BRHIG(IDEC)
         ENDIF
C Select subprocess kinematics
         EMH2=EMH**2
         CALL HWRPOW(ET,EJ)
         PT=.5*ET
         EMT=SQRT(PT**2+EMH2)
         EMAX=0.5*(PHEP(5,3)+EMH2/PHEP(5,3))
         IF (EMAX.LE.EMT) RETURN
         YMAX=LOG((EMAX+SQRT(EMAX**2-EMT**2))/EMT)
         YHINF=MAX(YJMIN,-YMAX)
         YHSUP=MIN(YJMAX, YMAX)
         IF (YHSUP.LE.YHINF) RETURN
         EXYH=EXP(HWRUNI(1,YHINF,YHSUP))
         YMIN=LOG(PT/(PHEP(5,3)-EMT/EXYH))
         YMAX=LOG((PHEP(5,3)-EMT*EXYH)/PT)
         YJINF=MAX(YJMIN,YMIN)
         YJSUP=MIN(YJMAX,YMAX)
         IF (YJSUP.LE.YJINF) RETURN
         EXYJ=EXP(HWRUNI(2,YJINF,YJSUP))
         XX(1)=(EMT*EXYH+PT*EXYJ)/PHEP(5,3)
         XX(2)=(EMT/EXYH+PT/EXYJ)/PHEP(5,3)
         S=XX(1)*XX(2)*PHEP(5,3)**2
         T=EMH2-XX(1)*EMT*PHEP(5,3)/EXYH
         U=EMH2-S-T
         COSTH=(S+2.*T-EMH2)/(S-EMH2)
C Set subprocess scale
         EMSCA=EMT
         CALL HWSGEN(.FALSE.)
         FACT=GEV2NB*PT*EJ*(YHSUP-YHINF)*(YJSUP-YJINF)*BR*EMHWT
     &       *HWUALF(1,EMSCA)**3*HWUAEM(EMH2)/(SWEIN*16*PIFAC*S**2)
         CALL HWHIGA(S,T,U,EMH2,AMPQQ,AMPQG,AMPGQ,AMPGG)
      ENDIF
      HCS=0.
      DO 30 ID1=1,13
      IF (DISF(ID1,1).LT.EPS) GOTO 30
      FACTR=FACT*DISF(ID1,1)
      IF (ID1.LT.7) THEN
C Quark first:
         ID2=ID1+6
         HCS=HCS+FACTR*DISF(ID2,2)*AMPQQ
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(13 ,201,2314,81,*99)
         ID2=13
         HCS=HCS+FACTR*DISF(ID2,2)*AMPQG
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,201,3124,82,*99)
      ELSEIF (ID1.LT.13) THEN
C Antiquark first:
         ID2=ID1-6
         HCS=HCS+FACTR*DISF(ID2,2)*AMPQQ
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(13 ,201,3124,83,*99)
         ID2=13
         HCS=HCS+FACTR*DISF(ID2,2)*AMPQG
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,201,2314,84,*99)
      ELSE
C Gluon first:
         DO 20 ID2=1,12
         IF (DISF(ID2,2).LT.EPS) GOTO 20
         IF (ID2.LT.7) THEN
            HCS=HCS+FACTR*DISF(ID2,2)*AMPGQ
            IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID2,201,2314,85,*99)
         ELSE
            HCS=HCS+FACTR*DISF(ID2,2)*AMPGQ
            IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID2,201,3124,86,*99)
         ENDIF
  20     CONTINUE
         HCS=HCS+FACTR*DISF(13,2)*AMPGG
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(13 ,201,2314,87,*99)
      ENDIF
  30  CONTINUE
      EVWGT=HCS
      RETURN
C Generate event
  99  IDN(1)=ID1
      IDN(2)=ID2
      IDCMF=15
C Trick HWETWO into using off-shell Higgs mass
      EMHTMP=RMASS(IDN(4))
      RMASS(IDN(4))=EMH
      CALL HWETWO
      RMASS(IDN(4))=EMHTMP
  999 END
CDECK  ID>, HWHIGM.
*CMZ :-        -02/05/91  11.17.14  by  Federico Carminati
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HWHIGM(EM,WEIGHT)
C-----------------------------------------------------------------------
C     CHOOSE HIGGS MASS:
C     IF (IOPHIG.EQ.0.OR.IOPHIG.EQ.2) THEN
C       CHOOSE HIGGS MASS ACCORDING TO
C       EM**4       /  (EM**2-EMH**2)**2 + (GAMH*EMH)**2
C     ELSE
C       CHOOSE HIGGS MASS ACCORDING TO
C       EMH * GAMH  /  (EM**2-EMH**2)**2 + (GAMH*EMH)**2
C     ENDIF
C     IF (IOPHIG.EQ.0.OR.IOPHIG.EQ.1) THEN
C       SUPPLY WEIGHT FACTOR TO YIELD
C       EM * GAM(EM)/  (EM**2-EMH**2)**2 + (GAM(EM)*EM)**2
C     ELSE
C       SUPPLY WEIGHT FACTOR TO YIELD
C       EM*(EMH/EM)**4 * GAM(EM)
C                   /  (EM**2-EMH**2)**2 + (GAM(EM)*EMH**2/EM)**2
C       AS SUGGESTED IN M.H.SEYMOUR, PHYS.LETT.B354(1995)409.
C     ENDIF
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRUNI,EM,WEIGHT,EMH,DIF,FUN,THETA,T,EMHLST,W0,
     & W1,EMM,GAMEM,T0,TMIN,TMAX,THEMIN,THEMAX,ZMIN,ZMAX,Z,F,GAMOFS
      INTEGER I
      EXTERNAL HWRUNI
      SAVE EMHLST,GAMEM,T0,TMIN,TMAX,THEMIN,THEMAX,ZMIN,ZMAX,W0,W1
      EQUIVALENCE (EMH,RMASS(201))
      DATA EMHLST/0D0/
C---SET UP INTEGRAND AND INDEFINITE INTEGRAL OF DISTRIBUTION
C   THETA=ATAN((EM**2-EMH**2)/(GAMH*EMH)); T=TAN(THETA); T0=EMH/GAMH
      DIF(T,T0)=(T+T0)**2
      FUN(THETA,T,T0)=T + (T0*T0-1)*THETA + T0*LOG(1+T*T)
C---SET UP CONSTANTS
      IF (EMH.NE.EMHLST .OR. FSTWGT) THEN
        EMHLST=EMH
        GAMEM=GAMH*EMH
        T0=EMH/GAMH
        TMIN=(MAX(ONE*1E-10,EMH-GAMMAX*GAMH))**2/GAMEM-T0
        TMAX=(              EMH+GAMMAX*GAMH )**2/GAMEM-T0
        THEMIN=ATAN(TMIN)
        THEMAX=ATAN(TMAX)
        ZMIN=FUN(THEMIN,TMIN,T0)
        ZMAX=FUN(THEMAX,TMAX,T0)
        W0=(ZMAX-ZMIN) / PIFAC * GAMEM
        W1=(THEMAX-THEMIN) / PIFAC
      ENDIF
C---CHOOSE HIGGS MASS
      IF (IOPHIG.EQ.0.OR.IOPHIG.EQ.2) THEN
 1      EM=0
        WEIGHT=0
        Z=HWRUNI(1,ZMIN,ZMAX)
C---SOLVE FUN(THETA,TAN(THETA))=Z BY NEWTON'S METHOD
        THETA=MAX(THEMIN, MIN(THEMAX, Z/T0**2 ))
        I=1
        F=0
 10     IF (I.LE.20 .AND. ABS(1-F/Z).GT.1E-4) THEN
          I=I+1
          IF (2*ABS(THETA).GT.PIFAC) CALL HWWARN('HWHIGM',51,*999)
          T=TAN(THETA)
          F=FUN(THETA,T,T0)
          THETA=THETA-(F-Z)/DIF(T,T0)
          GOTO 10
        ENDIF
        IF (I.GT.20) CALL HWWARN('HWHIGM',1,*999)
      ELSE
        THETA=HWRUNI(0,THEMIN,THEMAX)
      ENDIF
      EM=SQRT(GAMEM*(T0+TAN(THETA)))
C---NOW CALCULATE WEIGHT FACTOR FOR NON-CONSTANT HIGGS WIDTH
      GAMOFS=EM
      CALL HWDHIG(GAMOFS)
      IF (IOPHIG.EQ.0) THEN
        WEIGHT=W0*GAMOFS*EM /EM**4 *((EM**2-EMH**2)**2 + GAMEM**2)
     &                             /((EM**2-EMH**2)**2 +(GAMOFS*EM)**2)
      ELSEIF (IOPHIG.EQ.1) THEN
        WEIGHT=W1*GAMOFS*EM /GAMEM *((EM**2-EMH**2)**2 + GAMEM**2)
     &                             /((EM**2-EMH**2)**2 +(GAMOFS*EM)**2)
      ELSEIF (IOPHIG.EQ.2) THEN
        EMM=EM*(EMH/EM)**4
        WEIGHT=W0*GAMOFS*EMM/EM**4 *((EM**2-EMH**2)**2 + GAMEM**2)
     &                             /((EM**2-EMH**2)**2 +(GAMOFS*EMM)**2)
      ELSEIF (IOPHIG.EQ.3) THEN
        EMM=EM*(EMH/EM)**4
        WEIGHT=W1*GAMOFS*EMM/GAMEM *((EM**2-EMH**2)**2 + GAMEM**2)
     &                             /((EM**2-EMH**2)**2 +(GAMOFS*EMM)**2)
      ELSE
        CALL HWWARN('HWHIGM',500,*999)
      ENDIF
 999  END
CDECK  ID>, HWHIGS.
*CMZ :-        -26/04/91  11.11.55  by  Bryan Webber
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HWHIGS
C-----------------------------------------------------------------------
C     HIGGS PRODUCTION VIA GLUON OR QUARK FUSION
C     MEAN EVWGT = HIGGS PRODN C-S * BRANCHING FRACTION IN NB
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWUALF,HWHIGT,HWRGEN,HWUSQR,HWUAEM,BRHIGQ,EMH,
     & CSFAC(13),EVSUM(13),EMFAC,CV,CA,BR,RWGT,E1,E2,EMQ,GFACTR
      INTEGER IDEC,I,J,ID1,ID2
      EXTERNAL HWUALF,HWHIGT,HWRGEN,HWUSQR,HWUAEM
      SAVE CSFAC,BR,EVSUM
      IF (GENEV) THEN
        RWGT=HWRGEN(0)*EVSUM(13)
        IDN(1)=1
        DO 10 I=1,12
 10       IF (RWGT.GT.EVSUM(I)) IDN(1)=I+1
        IDN(2)=13
        IF (IDN(1).LE.12) IDN(2)=IDN(1)-6
        IF (IDN(1).LE. 6) IDN(2)=IDN(1)+6
        IDCMF=201
        CALL HWEONE
      ELSE
        EVWGT=0.
        CALL HWHIGM(EMH,EMFAC)
        IF (EMH.LE.0 .OR. EMH.GE.PHEP(5,3)) RETURN
        EMSCA=EMH
        IF (EMSCA.NE.EMLST) THEN
          EMLST=EMH
          XXMIN=(EMH/PHEP(5,3))**2
          XLMIN=LOG(XXMIN)
          GFACTR=GEV2NB*HWUAEM(EMH**2)/(288.*SWEIN*RMASS(198)**2)
          DO 20 I=1,13
            EMQ=RMASS(I)
            IF (I.EQ.13) THEN
              CSFAC(I)=-GFACTR*HWHIGT(RMASS(NFLAV)/EMH)*XLMIN
     &                         *HWUALF(1,EMH)**2 *EMFAC*ENHANC(NFLAV)**2
            ELSEIF (I.GT.6) THEN
              CSFAC(I)=CSFAC(I-6)
            ELSEIF (EMH.GT.2*EMQ) THEN
              CSFAC(I)=-GFACTR*96.*PIFAC**2 *(1-(2*EMQ/EMH)**2)
     &                *(EMQ/EMH)**2 *XLMIN *EMFAC*ENHANC(I)**2
            ELSE
              CSFAC(I)=0
            ENDIF
 20       CONTINUE
C  INCLUDE BRANCHING RATIO OF HIGGS
          IDEC=MOD(IPROC,100)
          BR=1
          IF (IDEC.EQ.0) THEN
            BRHIGQ=0
            DO 30 I=1,6
 30           BRHIGQ=BRHIGQ+BRHIG(I)
            BR=BRHIGQ
          ELSEIF (IDEC.EQ.10) THEN
            CALL HWDBOZ(198,ID1,ID2,CV,CA,BR,1)
            CALL HWDBOZ(199,ID1,ID2,CV,CA,BR,1)
            BR=BR*BRHIG(IDEC)
          ELSEIF (IDEC.EQ.11) THEN
            CALL HWDBOZ(200,ID1,ID2,CV,CA,BR,1)
            CALL HWDBOZ(200,ID1,ID2,CV,CA,BR,1)
            BR=BR*BRHIG(IDEC)
          ELSEIF (IDEC.LE.12) THEN
            BR=BRHIG(IDEC)
          ENDIF
        ENDIF
        CALL HWSGEN(.TRUE.)
        EVWGT=0
        E1=PHEP(4,MAX(1,JDAHEP(1,1)))
        E2=PHEP(4,MAX(2,JDAHEP(1,2)))
        DO 40 I=1,13
          EMQ=RMASS(I)
          IF (EMH.GT.2*EMQ) THEN
            J=13
            IF (I.LE.12) J=I-6
            IF (I.LE. 6) J=I+6
            IF (XX(1).LT.0.5*(1-EMQ/E1+HWUSQR(1-2*EMQ/E1)) .AND.
     &          XX(2).LT.0.5*(1-EMQ/E2+HWUSQR(1-2*EMQ/E2)))
     &          EVWGT=EVWGT+DISF(I,1)*DISF(J,2)*CSFAC(I)*BR
          ENDIF
          EVSUM(I)=EVWGT
 40     CONTINUE
      ENDIF
  999 END
CDECK  ID>, HWHIGT.
*CMZ :-        -26/04/91  11.11.55  by  Bryan Webber
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      FUNCTION HWHIGT(RATIO)
C-----------------------------------------------------------------------
C  CALCULATE MOD SQUARED I FOR RATIO = Mtop / Mhiggs
C  I DEFINED AS IN BARGER & PHILLIPS p433
C  WARNING: THIS IS A FACTOR OF 3 GREATER THAN EHLQ'S ETA FUNCTION
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWHIGT,PI,RATIO,RAT2,FREAL,FIMAG,ETALOG,AIREAL,
     & AIIMAG
      PARAMETER (PI=3.14159D0)
      RAT2=RATIO**2
      IF     (RAT2.GT.0.25) THEN
         FREAL=-2.*ASIN(0.5/RATIO)**2
         FIMAG=0
      ELSEIF (RAT2.LT.0.25) THEN
         ETALOG=LOG( (0.5+SQRT(0.25-RAT2)) / (0.5-SQRT(0.25-RAT2)) )
         FREAL=0.5 * (ETALOG**2 - PI**2)
         FIMAG=PI * ETALOG
      ELSE
         FREAL=0.5 * (          - PI**2)
         FIMAG=0
      ENDIF
      AIREAL=3*( 2*RAT2 + RAT2*(4*RAT2-1)*FREAL )
      AIIMAG=3*(          RAT2*(4*RAT2-1)*FIMAG )
      HWHIGT=AIREAL**2 + AIIMAG**2
      END
CDECK  ID>, HWHIGW.
*CMZ :-        -26/04/91  14.55.44  by  Federico Carminati
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HWHIGW
C-----------------------------------------------------------------------
C     HIGGS PRODUCTION VIA W BOSON FUSION
C     MEAN EVWGT = HIGGS PRODN C-S * BRANCHING FRACTION IN NB
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWULDO,HWRUNI,HWRGEN,HWUAEM,K1MAX2,K1MIN2,K12,
     & K2MAX2,K2MIN2,K22,EMW2,EMW,ROOTS,EMH2,EMH,ROOTS2,P1,PHI1,PHI2,
     & COSPHI,COSTH1,SINTH1,COSTH2,SINTH2,P2,WEIGHT,TAU,TAULN,CSFAC,
     & PSUM,PROB,Q1(5),Q2(5),H(5),A,B,C,TERM2,BRHIGQ,G1WW,G2WW,G1ZZ(6),
     & G2ZZ(6),AWW,AZZ(6),PWW,PZZ(6),EMZ,EMZ2,RSUM,GLUSQ,GRUSQ,GLDSQ,
     & GRDSQ,GLESQ,GRESQ,CW,CZ,EMFAC,CV,CA,BR,X2,ETA,P1JAC,FACTR,EH2
      INTEGER HWRINT,IDEC,I,ID1,ID2,IHAD
      LOGICAL EE,EP
      EXTERNAL HWULDO,HWRUNI,HWRGEN,HWUAEM,HWRINT
      SAVE EMW2,EMZ2,EE,GLUSQ,GRUSQ,GLDSQ,GRDSQ,GLESQ,GRESQ,G1ZZ,G2ZZ,
     & G1WW,G2WW,CW,CZ,PSUM,AWW,PWW,AZZ,PZZ,ROOTS,Q1,Q2,H,FACTR
      EQUIVALENCE (EMW,RMASS(198)),(EMZ,RMASS(200))
      IHAD=2
      IF (JDAHEP(1,IHAD).NE.0) IHAD=JDAHEP(1,IHAD)
      IF (FSTWGT) THEN
        EMW2=EMW**2
        EMZ2=EMZ**2
        GLUSQ=(VFCH(2,1)+AFCH(2,1))**2
        GRUSQ=(VFCH(2,1)-AFCH(2,1))**2
        GLDSQ=(VFCH(1,1)+AFCH(1,1))**2
        GRDSQ=(VFCH(1,1)-AFCH(1,1))**2
        GLESQ=(VFCH(11,1)+AFCH(11,1))**2
        GRESQ=(VFCH(11,1)-AFCH(11,1))**2
        G1ZZ(1)=GLUSQ*GLUSQ+GRUSQ*GRUSQ
        G2ZZ(1)=GLUSQ*GRUSQ+GRUSQ*GLUSQ
        G1ZZ(2)=GLUSQ*GLDSQ+GRUSQ*GRDSQ
        G2ZZ(2)=GLUSQ*GRDSQ+GRUSQ*GLDSQ
        G1ZZ(3)=GLDSQ*GLDSQ+GRDSQ*GRDSQ
        G2ZZ(3)=GLDSQ*GRDSQ+GRDSQ*GLDSQ
        G1ZZ(4)=GLESQ*GLESQ+GRESQ*GRESQ
        G2ZZ(4)=GLESQ*GRESQ+GRESQ*GLESQ
        G1ZZ(5)=GLESQ*GLUSQ+GRESQ*GRUSQ
        G2ZZ(5)=GLESQ*GRUSQ+GRESQ*GLUSQ
        G1ZZ(6)=GLESQ*GLDSQ+GRESQ*GRDSQ
        G2ZZ(6)=GLESQ*GRDSQ+GRESQ*GLDSQ
        G1WW=0.25
        G2WW=0
        FACTR=GEV2NB/(128.*PIFAC**3)
        EH2=RMASS(201)**2
        CW=256*(PIFAC*HWUAEM(EH2)/SWEIN)**3*EMW2
        CZ=256.*(PIFAC*HWUAEM(EH2))**3*EMZ2/(SWEIN*(1.-SWEIN))
      ENDIF
      EE=IPRO.LT.10
      EP=IPRO.GE.90
      IF (.NOT.GENEV) THEN
C---CHOOSE PARAMETERS
        EVWGT=0.
        CALL HWHIGM(EMH,EMFAC)
        IF (EMH.LE.0 .OR. EMH.GE.PHEP(5,3)) RETURN
        EMSCA=EMH
        IF (EE) THEN
          ROOTS=PHEP(5,3)
        ELSE
          TAU=(EMH/PHEP(5,3))**2
          TAULN=LOG(TAU)
          ROOTS=PHEP(5,3)*SQRT(EXP(HWRUNI(0,-1D-10,TAULN)))
        ENDIF
        EMH2=EMH**2
        ROOTS2=ROOTS**2
C---CHOOSE P1 ACCORDING TO (1-ETA)*(ETA-X2)/ETA**2
C   WHERE ETA=1-2P1/ROOTS AND X2=EMH**2/S
        X2=EMH2/ROOTS2
 1      ETA=X2**HWRGEN(0)
        IF (HWRGEN(0)*(1-EMH/ROOTS)**2*ETA.GT.(1-ETA)*(ETA-X2))GOTO 1
        P1JAC=0.5*ROOTS*ETA**2/((1-ETA)*(ETA-X2))
     &    *(-LOG(X2)*(1+X2)-2*(1-X2))
        P1=0.5*ROOTS*(1-ETA)
C---CHOOSE PHI1,2 UNIFORMLY
        PHI1=2*PIFAC*HWRGEN(0)
        PHI2=2*PIFAC*HWRGEN(0)
        COSPHI=COS(PHI2-PHI1)
C---CHOOSE K1^2, ON PROPAGATOR FACTOR
        K1MAX2=2*P1*ROOTS
        K1MIN2=0
        K12=EMW2-(EMW2+K1MAX2)*(EMW2+K1MIN2)/
     &           ((K1MAX2-K1MIN2)*HWRGEN(0)+(EMW2+K1MIN2))
C---CALCULATE COSTH1 FROM K1^2
        COSTH1=1+K12/(P1*ROOTS)
        SINTH1=SQRT(1-COSTH1**2)
C---CHOOSE K2^2
        K2MAX2=ROOTS*(ROOTS2-EMH2-2*ROOTS*P1)*(ROOTS-P1-P1*COSTH1)
     &        /((ROOTS-P1)**2-(P1*COSTH1)**2-(P1*SINTH1*COSPHI)**2)
        K2MIN2=0
        K22=EMW2-(EMW2+K2MAX2)*(EMW2+K2MIN2)/
     &           ((K2MAX2-K2MIN2)*HWRGEN(0)+(EMW2+K2MIN2))
C---CALCULATE A,B,C FACTORS, AND...
        A=-2*K22*P1*COSTH1 - ROOTS*(ROOTS2-EMH2-2*ROOTS*P1)
        B=-2*K22*P1*SINTH1*COSPHI
        C=+2*K22*P1 - 2*ROOTS*K22 - ROOTS*(ROOTS2-EMH2-2*ROOTS*P1)
C---SOLVE A*COSTH2 + B*SINTH2 + C = 0 FOR COSTH2
        TERM2=B**2 + A**2 - C**2
        IF (TERM2.LT.0) RETURN
        TERM2=B*SQRT(TERM2)
        IF (A.GE.0) RETURN
        COSTH2=(-A*C + TERM2)/(A**2+B**2)
        SINTH2=SQRT(1-COSTH2**2)
C---FINALLY, GET P2
        IF (COSTH2.EQ.-1) RETURN
        P2=-K22/(ROOTS*(1+COSTH2))
C---LOAD UP CMF MOMENTA
        Q1(1)=P1*SINTH1*COS(PHI1)
        Q1(2)=P1*SINTH1*SIN(PHI1)
        Q1(3)=P1*COSTH1
        Q1(4)=P1
        Q1(5)=0
        Q2(1)=P2*SINTH2*COS(PHI2)
        Q2(2)=P2*SINTH2*SIN(PHI2)
        Q2(3)=P2*COSTH2
        Q2(4)=P2
        Q2(5)=0
        H(1)=-Q1(1)-Q2(1)
        H(2)=-Q1(2)-Q2(2)
        H(3)=-Q1(3)-Q2(3)
        H(4)=-Q1(4)-Q2(4)+ROOTS
        CALL HWUMAS(H)
C---CALCULATE MATRIX ELEMENTS SQUARED
        AWW=ENHANC(10)**2 * CW*(ROOTS2/2*HWULDO(Q1,Q2)*G1WW
     &         +ROOTS2/4*P1*P2*(1+COSTH1)*(1-COSTH2)*G2WW)
        DO 10 I=1,6
          AZZ(I)=ENHANC(11)**2 * CZ*(ROOTS2/2*HWULDO(Q1,Q2)*G1ZZ(I)
     &               +ROOTS2/4*P1*P2*(1+COSTH1)*(1-COSTH2)*G2ZZ(I))
     &          *((K12-EMW2)/(K12-EMZ2)*(K22-EMW2)/(K22-EMZ2))**2
 10     CONTINUE
C---CALCULATE WEIGHT IN INTEGRAL
        WEIGHT=FACTR*P2*P1JAC/(ROOTS2**2*HWULDO(H,Q2))
     &              *(K1MAX2-K1MIN2)/((K1MAX2+EMW2)*(K1MIN2+EMW2))
     &              *(K2MAX2-K2MIN2)/((K2MAX2+EMW2)*(K2MIN2+EMW2))
     &              * EMFAC
        EMSCA=EMW
        XXMIN=(ROOTS/PHEP(5,3))**2
        XLMIN=LOG(XXMIN)
C---INCLUDE BRANCHING RATIO OF HIGGS
        IDEC=MOD(IPROC,100)
        IF (IDEC.GT.0.AND.IDEC.LE.12) WEIGHT=WEIGHT*BRHIG(IDEC)
        IF (IDEC.EQ.0) THEN
          BRHIGQ=0
          DO 20 I=1,6
 20         BRHIGQ=BRHIGQ+BRHIG(I)
          WEIGHT=WEIGHT*BRHIGQ
        ENDIF
        IF (IDEC.EQ.10) THEN
          CALL HWDBOZ(198,ID1,ID2,CV,CA,BR,1)
          CALL HWDBOZ(199,ID1,ID2,CV,CA,BR,1)
          WEIGHT=WEIGHT*BR
        ELSEIF (IDEC.EQ.11) THEN
          CALL HWDBOZ(200,ID1,ID2,CV,CA,BR,1)
          CALL HWDBOZ(200,ID1,ID2,CV,CA,BR,1)
          WEIGHT=WEIGHT*BR
        ENDIF
        IF (EE) THEN
          CSFAC=WEIGHT
          PSUM=AWW+AZZ(4)
          EVWGT=CSFAC*PSUM
        ELSEIF (EP) THEN
          CSFAC=-WEIGHT*TAULN
          XX(1)=ONE
          XX(2)=XXMIN
          CALL HWSFUN(XX(2),EMSCA,IDHW(IHAD),NSTRU,DISF(1,2),2)
          IF (IDHW(1).LE.126) THEN
            PWW=(DISF(2,2)+DISF(4,2)+DISF(7,2)+DISF( 9,2))*AWW
          ELSE
            PWW=(DISF(1,2)+DISF(3,2)+DISF(8,2)+DISF(10,2))*AWW
          ENDIF
          PZZ(5)=(DISF(2,2)+DISF(4,2)+DISF(8,2)+DISF(10,2))*AZZ(5)
          PZZ(6)=(DISF(1,2)+DISF(3,2)+DISF(7,2)+DISF( 9,2))*AZZ(6)
          PSUM=PWW+PZZ(5)+PZZ(6)
          EVWGT=CSFAC*PSUM
        ELSE
          CSFAC=WEIGHT*TAULN*XLMIN
          CALL HWSGEN(.TRUE.)
          PWW=((DISF(2,1)+DISF(4, 1)+DISF(7,1)+DISF(9,1))
     &        *(DISF(8,2)+DISF(10,2)+DISF(1,2)+DISF(3,2))
     &        +(DISF(8,1)+DISF(10,1)+DISF(1,1)+DISF(3,1))
     &        *(DISF(2,2)+DISF(4, 2)+DISF(7,2)+DISF(9,2)))
     &        *AWW
          PZZ(1)=((DISF(2,1)+DISF(4,1)+DISF(8,1)+DISF(10,1))
     &           *(DISF(2,2)+DISF(4,2)+DISF(8,2)+DISF(10,2)))
     &           *AZZ(1)
          PZZ(2)=((DISF(2,1)+DISF(4,1)+DISF(8,1)+DISF(10,1))
     &           *(DISF(1,2)+DISF(3,2)+DISF(7,2)+DISF(9, 2))
     &           +(DISF(1,1)+DISF(3,1)+DISF(7,1)+DISF(9, 1))
     &           *(DISF(2,2)+DISF(4,2)+DISF(8,2)+DISF(10,2)))
     &           *AZZ(2)
          PZZ(3)=((DISF(1,1)+DISF(3,1)+DISF(7,1)+DISF(9,1))
     &           *(DISF(1,2)+DISF(3,2)+DISF(7,2)+DISF(9,2)))
     &           *AZZ(3)
          PSUM=PWW+PZZ(1)+PZZ(2)+PZZ(3)
C---EVENT WEIGHT IS SUM OVER ALL COMBINATIONS
          EVWGT=CSFAC*PSUM
        ENDIF
      ELSE
C---GENERATE EVENT
C---CHOOSE EVENT TYPE
        RSUM=PSUM*HWRGEN(0)
C---ELECTRON BEAMS?
        IF (EE) THEN
          IDN(1)=IDHW(1)
          IDN(2)=IDHW(2)
C---WW FUSION?
          IF (RSUM.LT.AWW) THEN
            IDN(3)=IDN(1)+1
            IDN(4)=IDN(2)+1
C---ZZ FUSION?
          ELSE
            IDN(3)=IDN(1)
            IDN(4)=IDN(2)
          ENDIF
C---LEPTON-HADRON COLISION?
        ELSEIF (EP) THEN
C---WW FUSION?
          IDN(1)=IDHW(1)
          IF (RSUM.LT.PWW) THEN
 24         IDN(2)=HWRINT(1,8)
            IF (IDN(2).GE.5) IDN(2)=IDN(2)+2
            IF (ICHRG(IDN(1))*ICHRG(IDN(2)).GT.0) GOTO 24
            PROB=DISF(IDN(2),2)*AWW/PWW
            IF (HWRGEN(0).GT.PROB) GOTO 24
            IDN(3)=IDN(1)+1
            IF (HWRGEN(0).GT.SCABI) THEN
              IDN(4)= 4*INT((IDN(2)-1)/2)-IDN(2)+3
            ELSE
              IDN(4)=12*INT((IDN(2)-1)/6)-IDN(2)+5
            ENDIF
C---ZZ FUSION FROM U-TYPE QUARK?
          ELSEIF (RSUM.LT.PWW+PZZ(5)) THEN
 26         IDN(2)=2*HWRINT(1,4)
            IF (IDN(2).GE.5) IDN(2)=IDN(2)+2
            PROB=DISF(IDN(2),2)*AZZ(5)/PZZ(5)
            IF (HWRGEN(0).GT.PROB) GOTO 26
            IDN(3)=IDN(1)
            IDN(4)=IDN(2)
C---ZZ FUSION FROM D-TYPE QUARK?
          ELSE
 28         IDN(2)=2*HWRINT(1,4)-1
            IF (IDN(2).GE.5) IDN(2)=IDN(2)+2
            PROB=DISF(IDN(2),2)*AZZ(6)/PZZ(6)
            IF (HWRGEN(0).GT.PROB) GOTO 28
            IDN(3)=IDN(1)
            IDN(4)=IDN(2)
          ENDIF
C---HADRON BEAMS?
        ELSE
C---WW FUSION?
          IF (RSUM.LT.PWW) THEN
 31         DO 32 I=1,2
              IDN(I)=HWRINT(1,8)
              IF (IDN(I).GE.5) IDN(I)=IDN(I)+2
 32         CONTINUE
            IF (ICHRG(IDN(1))*ICHRG(IDN(2)).GT.0) GOTO 31
            PROB=DISF(IDN(1),1)*DISF(IDN(2),2)*AWW/PWW
            IF (HWRGEN(0).GT.PROB) GOTO 31
C---CHOOSE OUTGOING QUARKS
            DO 33 I=1,2
              IF (HWRGEN(0).GT.SCABI) THEN
                IDN(I+2)=4*INT((IDN(I)-1)/2)-IDN(I)+3
              ELSE
                IDN(I+2)=12*INT((IDN(I)-1)/6)-IDN(I)+5
              ENDIF
 33         CONTINUE
C---ZZ FUSION FROM U-TYPE QUARKS?
          ELSEIF (RSUM.LT.PWW+PZZ(1)) THEN
 41         DO 42 I=1,2
              IDN(I)=2*HWRINT(1,4)
              IF (IDN(I).GE.5) IDN(I)=IDN(I)+2
 42         CONTINUE
            PROB=DISF(IDN(1),1)*DISF(IDN(2),2)*AZZ(1)/PZZ(1)
            IF (HWRGEN(0).GT.PROB) GOTO 41
            IDN(3)=IDN(1)
            IDN(4)=IDN(2)
C---ZZ FUSION FROM D-TYPE QUARKS?
          ELSEIF (RSUM.LT.PWW+PZZ(1)+PZZ(3)) THEN
 51         DO 52 I=1,2
              IDN(I)=2*HWRINT(1,4)-1
              IF (IDN(I).GE.5) IDN(I)=IDN(I)+2
 52         CONTINUE
            PROB=DISF(IDN(1),1)*DISF(IDN(2),2)*AZZ(3)/PZZ(3)
            IF (HWRGEN(0).GT.PROB) GOTO 51
            IDN(3)=IDN(1)
            IDN(4)=IDN(2)
C---ZZ FUSION FROM UD-TYPE PAIRS?
          ELSE
 61         IF (HWRGEN(0).GT.0.5) THEN
              IDN(1)=2*HWRINT(1,4)-1
              IDN(2)=2*HWRINT(1,4)
            ELSE
              IDN(1)=2*HWRINT(1,4)
              IDN(2)=2*HWRINT(1,4)-1
            ENDIF
            DO 62 I=1,2
 62           IF (IDN(I).GE.5) IDN(I)=IDN(I)+2
            PROB=DISF(IDN(1),1)*DISF(IDN(2),2)*AZZ(2)/PZZ(2)
            IF (HWRGEN(0).GT.PROB) GOTO 61
            IDN(3)=IDN(1)
            IDN(4)=IDN(2)
          ENDIF
        ENDIF
C---NOW BOOST TO LAB, AND SET UP STATUS CODES etc
        IDCMF=15
C---INCOMING
        IF (.NOT.EE) CALL HWEONE
C---CMF POINTERS
        JDAHEP(1,NHEP)=NHEP+1
        JDAHEP(2,NHEP)=NHEP+3
        JMOHEP(1,NHEP+1)=NHEP
        JMOHEP(1,NHEP+2)=NHEP
        JMOHEP(1,NHEP+3)=NHEP
C---OUTGOING MOMENTA (GIVE QUARKS MASS NON-COVARIANTLY!)
        Q1(5)=RMASS(IDN(1))
        Q1(4)=SQRT(Q1(4)**2+Q1(5)**2)
        Q2(5)=RMASS(IDN(2))
        Q2(4)=SQRT(Q2(4)**2+Q2(5)**2)
        H(4)=-Q1(4)-Q2(4)+PHEP(5,NHEP)
        CALL HWUMAS(H)
        CALL HWULOB(PHEP(1,NHEP),Q1,PHEP(1,NHEP+1))
        CALL HWULOB(PHEP(1,NHEP),Q2,PHEP(1,NHEP+2))
        CALL HWULOB(PHEP(1,NHEP),H,PHEP(1,NHEP+3))
C---STATUS AND IDs
        ISTHEP(NHEP+1)=113
        ISTHEP(NHEP+2)=114
        ISTHEP(NHEP+3)=114
        IDHW(NHEP+1)=IDN(3)
        IDHEP(NHEP+1)=IDPDG(IDN(3))
        IDHW(NHEP+2)=IDN(4)
        IDHEP(NHEP+2)=IDPDG(IDN(4))
        IDHW(NHEP+3)=201
        IDHEP(NHEP+3)=IDPDG(201)
C---COLOUR LABELS
        JMOHEP(2,NHEP+1)=NHEP-2
        JMOHEP(2,NHEP+2)=NHEP-1
        JMOHEP(2,NHEP-1)=NHEP+2
        JMOHEP(2,NHEP-2)=NHEP+1
        JMOHEP(2,NHEP+3)=NHEP+3
        JDAHEP(2,NHEP+1)=NHEP-2
        JDAHEP(2,NHEP+2)=NHEP-1
        JDAHEP(2,NHEP-1)=NHEP+2
        JDAHEP(2,NHEP-2)=NHEP+1
        JDAHEP(2,NHEP+3)=NHEP+3
        NHEP=NHEP+3
      ENDIF
  999 END
CDECK  ID>, HWHIGY.
*CMZ :-        -26/04/91  13.37.37  by  Federico Carminati
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      FUNCTION HWHIGY(A,B,XP)
C-----------------------------------------------------------------------
C     CALCULATE THE INTEGRAL OF BERENDS AND KLEISS APPENDIX B
C-----------------------------------------------------------------------
      IMPLICIT NONE
      COMPLEX XQ,Z1,Z2,Z3,Z4,C0,C1,C2,C3,C4,C5,C6,C7,C8,FUN,Z
      DOUBLE PRECISION HWHIGY,TWO,A,B,XP,Y
      PARAMETER (TWO=2.D0)
C---DECLARE ALL THE STATEMENT-FUNCTION DEFINITIONS
      C0(Z,A)=(Z**2-A)**2*((Z**2+A)**2-24*Z*(Z**2+A)+8*Z**2*(A+6))/Z**4
      C1(Z,A)=A**4/(3*Z)
      C2(Z,A)=-A**3*(24*Z-A)/(2*Z**2)
      C3(Z,A)=A**2*(8*Z**2*(A+6)-24*A*Z+A**2)/Z**3
      C4(Z,A)=-A**2*(24*Z**3+8*Z**2*(A+6)-24*A*Z+A**2)/Z**4
      C5(Z,A)=Z**3-24*Z**2+8*Z*(A+6)+24*A
      C6(Z,A)=0.5*Z**2-12*Z+4*(A+6)
      C7(Z,A)=Z/3-8
      C8(Z,A)=0.25
      FUN(Z,Y,A)=C0(Z,A)*LOG(Y-Z)
     &          +C1(Z,A)/Y**3
     &          +C2(Z,A)/Y**2
     &          +C3(Z,A)/Y
     &          +C4(Z,A)*LOG(Y)
     &          +C5(Z,A)*Y
     &          +C6(Z,A)*Y**2
     &          +C7(Z,A)*Y**3
     &          +C8(Z,A)*Y**4
C---NOW EVALUATE THE INTEGRAL
      HWHIGY=0
      IF (A.GT.4) RETURN
      XQ=CMPLX(XP,B)
      Z1=XQ+SQRT(XQ**2-A)
      Z2=XQ-SQRT(XQ**2-A)
      Z3=FUN(Z1,TWO,A)-FUN(Z1,SQRT(A),A)
      Z4=FUN(Z2,TWO,A)-FUN(Z2,SQRT(A),A)
      HWHIGY=AIMAG((Z3-Z4)/(Z1-Z2))/(8*B)
      END
CDECK  ID>, HWHIGZ.
*CMZ :-        -02/05/91  11.18.44  by  Federico Carminati
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HWHIGZ
C-----------------------------------------------------------------------
C     HIGGS PRODUCTION VIA THE BJORKEN PROCESS: E+E- --> Z(*) --> Z(*)H
C     WHERE ONE OR BOTH OF THE Zs IS OFF-SHELL
C     USES ALGORITHM OF BERENDS AND KLEISS: NUCL.PHYS. B260(1985)32
C
C     MEAN EVWGT = CROSS-SECTION (IN NB) * HIGGS BRANCHING FRACTION
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWUAEM,HWHIGY,HWRUNI,HWRGEN,HWULDO,EMZ,CVE,CAE,
     & POL1,POL2,CE1,CE2,CE3,PMAX,EMZ2,S,B,FACTR,EMH,EMFAC,EMH2,A,XP,
     & CV,CA,BRHIGQ,BR,X1,X2,FAC1,FAC2,XPP,XPPSQ,COEF,X,XSQ,PROB,C1,C2,
     & CHIGG,PTHETA,SHIGG,C3,PHIMAX,CPHI,SPHI,C2PHI,S2PHI,PCM,ELST
      INTEGER IDEC,I,NLOOP,ICMF,IHIG,IZED,IFER,IANT,ID1,ID2,IN1,IN2
      EXTERNAL HWUAEM,HWHIGY,HWRUNI,HWRGEN,HWULDO
      SAVE CVE,CAE,CE1,CE2,CE3,PMAX,EMZ2,S,EMH,B,FACTR,A,EMH2
      EQUIVALENCE (EMZ,RMASS(200))
      DATA ELST/0/
C---SET UP CONSTANTS
      IN1=1
      IF (JDAHEP(1,IN1).NE.0) IN1=JDAHEP(1,IN1)
      IN2=2
      IF (JDAHEP(1,IN2).NE.0) IN2=JDAHEP(1,IN2)
      IF (FSTWGT.OR.ELST.NE.PHEP(5,3)) THEN
        ELST=PHEP(5,3)
        CVE=VFCH(11,1)
        CAE=AFCH(11,1)
        POL1=1.-EPOLN(3)*PPOLN(3)
        POL2=EPOLN(3)-PPOLN(3)
        CE1=(POL1*(CVE**2+CAE**2)+POL2*2.*CVE*CAE)
        CE2=(POL1*2.*CVE*CAE+POL2*(CVE**2+CAE**2))
        IF ((IDHW(IN1).GT.IDHW(IN2).AND.PHEP(3,IN1).LT.0.).OR.
     &      (IDHW(IN2).GT.IDHW(IN1).AND.PHEP(3,IN2).LT.0.)    ) CE2=-CE2
        IF (TPOL) CE3=(CVE**2-CAE**2)
        PMAX=4
        EMZ2=EMZ**2
        S=PHEP(5,3)**2
        B=EMZ*GAMZ/S
        FACTR=GEV2NB*CE1*(HWUAEM(RMASS(201)**2)*ENHANC(11))**2
     &       /(12.*S*SWEIN*(1.-SWEIN))*B/((1-EMZ2/S)**2+B**2)
      ENDIF
      IF (.NOT.GENEV) THEN
C---CHOOSE HIGGS MASS, AND CALCULATE EVENT WEIGHT
        EVWGT=0D0
        CALL HWHIGM(EMH,EMFAC)
        IF (EMH.LE.0 .OR. EMH.GT.PHEP(5,3)) RETURN
        EMSCA=EMH
        EMH2=EMH**2
        A=4*EMH2/S
        XP=1+(EMH2-EMZ2)/S
        EVWGT=FACTR*HWHIGY(A,B,XP)*EMFAC
C---INCLUDE BRANCHING RATIO OF HIGGS
        IDEC=MOD(IPROC,100)
        IF (IDEC.GT.0.AND.IDEC.LE.12) EVWGT=EVWGT*BRHIG(IDEC)
        IF (IDEC.EQ.0) THEN
          BRHIGQ=0
          DO 10 I=1,6
 10         BRHIGQ=BRHIGQ+BRHIG(I)
          EVWGT=EVWGT*BRHIGQ
        ENDIF
C Add Z branching fractions
        CALL HWDBOZ(200,ID1,ID2,CV,CA,BR,0)
        EVWGT=EVWGT*BR
        IF (IDEC.EQ.10) THEN
          CALL HWDBOZ(198,ID1,ID2,CV,CA,BR,1)
          CALL HWDBOZ(199,ID1,ID2,CV,CA,BR,1)
          EVWGT=EVWGT*BR
        ELSEIF (IDEC.EQ.11) THEN
          CALL HWDBOZ(200,ID1,ID2,CV,CA,BR,1)
          CALL HWDBOZ(200,ID1,ID2,CV,CA,BR,1)
          EVWGT=EVWGT*BR
        ENDIF
      ELSE
C---GENERATE EVENT
        ICMF=NHEP+1
        IHIG=NHEP+2
        IZED=NHEP+3
        IFER=NHEP+4
        IANT=NHEP+5
        CALL HWVEQU(5,PHEP(1,3),PHEP(1,ICMF))
        NHEP=NHEP+5
C---CHOOSE ENERGY FRACTION OF HIGGS
        X1=SQRT(A)
        X2=1+0.25*A
        XP=1+(EMH2-EMZ2)/S
        FAC1=ATAN((X1-XP)/B)
        FAC2=ATAN((X2-XP)/B)
        XPP=MIN(X2,MAX(X1+B,XP))
        XPPSQ=XPP**2
        NLOOP=0
        COEF=1./((12+2*A-12*XPP+XPPSQ)*SQRT(XPPSQ-A))
 20       NLOOP=NLOOP+1
          IF (NLOOP.GT.NBTRY) CALL HWWARN('HWHIGZ',101,*999)
          X=XP+B*TAN(HWRUNI(1,FAC1,FAC2))
          XSQ=X**2
          PROB=COEF*((12+2*A-12*X+XSQ)*SQRT(XSQ-A))
          IF (PROB.GT.PMAX) THEN
            PMAX=1.1*PROB
            CALL HWWARN('HWHIGZ',1,*999)
            WRITE (6,21) PMAX
 21         FORMAT(7X,'NEW HWHIGZ MAX WEIGHT =',F8.4)
          ENDIF
        IF (PROB.LT.PMAX*HWRGEN(0)) GOTO 20
C Choose Z decay mode
        CALL HWDBOZ(200,IDHW(IFER),IDHW(IANT),CV,CA,BR,0)
        C1=CE1*(CV**2+CA**2)
        C2=CE2*2.*CV*CA
C---CHOOSE HIGGS DIRECTION
C First polar angle
        NLOOP=0
        COEF=(XSQ-A)/(8.*(1.-X)+XSQ+A)
 30       NLOOP=NLOOP+1
          IF (NLOOP.GT.NBTRY) CALL HWWARN('HWHIGZ',102,*999)
          CHIGG=HWRUNI(2,-ONE, ONE)
          PTHETA=1-COEF*CHIGG**2
        IF (PTHETA.LT.HWRGEN(1)) GOTO 30
        SHIGG=SQRT(1-CHIGG**2)
C Now azimuthal angle
        IF (TPOL) THEN
           C3=CE3*(CV*2+CA**2)
           COEF=COEF*SHIGG**2*C3/C1
           PHIMAX=PTHETA+ABS(COEF)
  40       CALL HWRAZM(ONE,CPHI,SPHI)
           C2PHI=2.*CPHI**2-1.
           S2PHI=2.*CPHI*SPHI
           PROB=PTHETA-COEF*(C2PHI*COSS+S2PHI*SINS)
           IF (PROB.LT.HWRGEN(1)*PHIMAX) GOTO 40
        ELSE
           CALL HWRAZM(ONE,CPHI,SPHI)
        ENDIF
C Construct Higgs and Z momenta
        PHEP(5,IHIG)=EMH
        PHEP(4,IHIG)=X*PHEP(5,ICMF)/2
        PCM=SQRT(PHEP(4,IHIG)**2-EMH2)
        PHEP(3,IHIG)=CHIGG*PCM
        PHEP(1,IHIG)=SHIGG*PCM*CPHI
        PHEP(2,IHIG)=SHIGG*PCM*SPHI
        CALL HWVDIF(4,PHEP(1,ICMF),PHEP(1,IHIG),PHEP(1,IZED))
        CALL HWUMAS(PHEP(1,IZED))
C Choose orientation of Z decay
        NLOOP=0
        COEF=2.*(C1+ABS(C2))*HWULDO(PHEP(1,IN1),PHEP(1,IZED))
     &                      *HWULDO(PHEP(1,IN2),PHEP(1,IZED))/S
        IF (TPOL) COEF=COEF*(C1+ABS(C2)+ABS(C3))/(C1+ABS(C2))
        PCM=PHEP(5,IZED)/2
        PHEP(5,IFER)=0
        PHEP(5,IANT)=0
 50     NLOOP=NLOOP+1
        IF (NLOOP.GT.NBTRY) CALL HWWARN('HWHIGZ',103,*999)
        CALL HWDTWO(PHEP(1,IZED),PHEP(1,IFER),PHEP(1,IANT),
     &              PCM,TWO,.TRUE.)
        PROB=C1*(PHEP(4,IFER)*PHEP(4,IANT)-PHEP(3,IFER)*PHEP(3,IANT))
     &      +C2*(PHEP(4,IFER)*PHEP(3,IANT)-PHEP(3,IFER)*PHEP(4,IANT))
        IF (TPOL) PROB=PROB+C3*
     &   (COSS*(PHEP(1,IFER)*PHEP(1,IANT)-PHEP(2,IFER)*PHEP(2,IANT))
     &   +SINS*(PHEP(1,IFER)*PHEP(2,IANT)+PHEP(2,IFER)*PHEP(1,IANT)))
        IF (PROB.LT.HWRGEN(2)*COEF) GOTO 50
C---SET UP STATUS CODES,
        ISTHEP(ICMF)=120
        ISTHEP(IHIG)=190
        ISTHEP(IZED)=195
        ISTHEP(IFER)=113
        ISTHEP(IANT)=114
C---COLOR CONNECTIONS,
        JMOHEP(1,ICMF)=1
        JMOHEP(2,ICMF)=2
        JDAHEP(1,ICMF)=IHIG
        JDAHEP(2,ICMF)=IZED
        JMOHEP(1,IHIG)=ICMF
        JMOHEP(1,IZED)=ICMF
        JMOHEP(1,IFER)=IZED
        JMOHEP(1,IANT)=IZED
        JMOHEP(2,IFER)=IANT
        JMOHEP(2,IANT)=IFER
        JDAHEP(1,IZED)=IFER
        JDAHEP(2,IZED)=IANT
        JDAHEP(2,IFER)=IANT
        JDAHEP(2,IANT)=IFER
C---IDENTITY CODES
        IDHW(ICMF)=200
        IDHW(IHIG)=201
        IDHW(IZED)=200
        IDHEP(ICMF)=IDPDG(IDHW(ICMF))
        IDHEP(IHIG)=IDPDG(IDHW(IHIG))
        IDHEP(IZED)=IDPDG(IDHW(IZED))
        IDHEP(IFER)=IDPDG(IDHW(IFER))
        IDHEP(IANT)=IDPDG(IDHW(IANT))
      ENDIF
 999  END
CDECK  ID>, HWHPH2
*CMZ :-        -12/01/93  10.12.43  by  Bryan Webber
*-- Author :    Ian Knowles
C-----------------------------------------------------------------------
      SUBROUTINE HWHPH2
C-----------------------------------------------------------------------
C     QQD direct photon pair production: mean EVWGT = sigma in nb
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,HWRUNI,HWUALF,HWHPPB,EPS,RCS,ET,EJ,KK,KK2,
     & YJ1INF,YJ1SUP,Z1,YJ2INF,YJ2SUP,Z2,FACT,FACTR,RS,S,T,U,CSTU,TQSQ,
     & DSTU,HCS
      INTEGER ID,ID1,ID2
      EXTERNAL HWRGEN,HWRUNI,HWUALF,HWHPPB
      SAVE HCS
      PARAMETER (EPS=1.D-9)
      IF (GENEV) THEN
        RCS=HCS*HWRGEN(0)
      ELSE
        EVWGT=0.
        CALL HWRPOW(ET,EJ)
        KK=ET/PHEP(5,3)
        KK2=KK**2
        IF (KK.GE.1.) RETURN
        YJ1INF=MAX( YJMIN , LOG((1.-SQRT(1.-KK2))/KK) )
        YJ1SUP=MIN( YJMAX , LOG((1.+SQRT(1.-KK2))/KK) )
        IF (YJ1INF.GE.YJ1SUP) RETURN
        Z1=EXP(HWRUNI(1,YJ1INF,YJ1SUP))
        YJ2INF=MAX( YJMIN , -LOG(2./KK-1./Z1) )
        YJ2SUP=MIN( YJMAX ,  LOG(2./KK-Z1) )
        IF (YJ2INF.GE.YJ2SUP) RETURN
        Z2=EXP(HWRUNI(2,YJ2INF,YJ2SUP))
        XX(1)=0.5*(Z1+Z2)*KK
        IF (XX(1).GE.1.) RETURN
        XX(2)=XX(1)/(Z1*Z2)
        IF (XX(2).GE.1.) RETURN
        COSTH=(Z1-Z2)/(Z1+Z2)
        S=XX(1)*XX(2)*PHEP(5,3)**2
        RS=0.5*SQRT(S)
        T=-0.5*S*(1.-COSTH)
        U=-S-T
        EMSCA=SQRT(2.*S*T*U/(S*S+T*T+U*U))
        FACT=GEV2NB*PIFAC*0.5*ET*EJ*(YJ1SUP-YJ1INF)*(YJ2SUP-YJ2INF)
     &      *(ALPHEM/S)**2
        CALL HWSGEN(.FALSE.)
        CSTU=2.*(U/T+T/U)/CAFAC
        IF (DISF(13,1).GT.EPS.AND.DISF(13,2).GT.EPS) THEN
           TQSQ=0.
           DO 10 ID=1,6
  10       IF (RMASS(ID).LT.RS) TQSQ=TQSQ+QFCH(ID)**2
           DSTU=DISF(13,1)*DISF(13,2)*FACT*HWHPPB(S,T,U)
     &         /64.*(HWUALF(1,EMSCA)*TQSQ/PIFAC)**2
        ENDIF
      ENDIF
      HCS=0.
      DO 30 ID=1,6
      FACTR=FACT*CSTU*QFCH(ID)**4
C q+qbar ---> gamma+gamma
      ID1=ID
      ID2=ID+6
      IF (DISF(ID1,1).LT.EPS.OR.DISF(ID2,2).LT.EPS) GOTO 20
      HCS=HCS+FACTR*DISF(ID1,1)*DISF(ID2,2)
      IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(59,59,2134,61,*99)
C qbar+q ---> gamma+gamma
  20  ID1=ID+6
      ID2=ID
      IF (DISF(ID1,1).LT.EPS.OR.DISF(ID2,2).LT.EPS) GOTO 30
      HCS=HCS+FACTR*DISF(ID1,1)*DISF(ID2,2)
      IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(59,59,2134,62,*99)
  30  CONTINUE
C g+g ---> gamma+gamma
      ID1=13
      ID2=13
      HCS=HCS+DSTU
      IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(59,59,2134,63,*99)
      EVWGT=HCS
      RETURN
C Generate event
  99  IDN(1)=ID1
      IDN(2)=ID2
      IDCMF=15
      CALL HWETWO
  999 END
CDECK  ID>, HWHPHO.
*CMZ :-        -26/04/91  14.55.45  by  Federico Carminati
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWHPHO
C-----------------------------------------------------------------------
C     QCD DIRECT PHOTON + JET PRODUCTION: MEAN EVWGT = SIGMA IN NB
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,HWRUNI,HWUALF,HWHPPB,EPS,RCS,ET,EJ,KK,KK2,
     & YJ1INF,YJ1SUP,Z1,YJ2INF,YJ2SUP,Z2,FACT,FACTR,FACTF,RS,S,T,U,CF,
     & AF,CSTU,CTSU,CUST,DSTU,HCS,TQCH
      INTEGER ID,ID1,ID2
      EXTERNAL HWRGEN,HWRUNI,HWUALF,HWHPPB
      SAVE HCS
      PARAMETER (EPS=1.D-9)
      IF (GENEV) THEN
        RCS=HCS*HWRGEN(0)
      ELSE
        EVWGT=0.
        CALL HWRPOW(ET,EJ)
        KK=ET/PHEP(5,3)
        KK2=KK**2
        IF (KK.GE.1.) RETURN
        YJ1INF=MAX( YJMIN , LOG((1.-SQRT(1.-KK2))/KK) )
        YJ1SUP=MIN( YJMAX , LOG((1.+SQRT(1.-KK2))/KK) )
        IF (YJ1INF.GE.YJ1SUP) RETURN
        Z1=EXP(HWRUNI(1,YJ1INF,YJ1SUP))
        YJ2INF=MAX( YJMIN , -LOG(2./KK-1./Z1) )
        YJ2SUP=MIN( YJMAX ,  LOG(2./KK-Z1) )
        IF (YJ2INF.GE.YJ2SUP) RETURN
        Z2=EXP(HWRUNI(2,YJ2INF,YJ2SUP))
        XX(1)=0.5*(Z1+Z2)*KK
        IF (XX(1).GE.1.) RETURN
        XX(2)=XX(1)/(Z1*Z2)
        IF (XX(2).GE.1.) RETURN
        COSTH=(Z1-Z2)/(Z1+Z2)
        S=XX(1)*XX(2)*PHEP(5,3)**2
        RS=0.5*SQRT(S)
        T=-0.5*S*(1.-COSTH)
        U=-S-T
C---SET EMSCA TO HARD PROCESS SCALE (APPROX ET-JET)
        EMSCA=SQRT(2.*S*T*U/(S*S+T*T+U*U))
        FACT=GEV2NB*PIFAC*0.5*ET*EJ*ALPHEM
     &      *HWUALF(1,EMSCA)*(YJ1SUP-YJ1INF)*(YJ2SUP-YJ2INF)/S**2
        CALL HWSGEN(.FALSE.)
C
        CF=2.*CFFAC/CAFAC
        AF=-1./CAFAC
        CSTU=CF*(U/T+T/U)
        CTSU=AF*(U/S+S/U)
        CUST=AF*(T/S+S/T)
        IF (DISF(13,1).GT.EPS.AND.DISF(13,2).GT.EPS) THEN
           TQCH=0.
           DO 10 ID=1,6
  10       IF (RMASS(ID).LT.RS) TQCH=TQCH+QFCH(ID)
           DSTU=DISF(13,1)*DISF(13,2)*FACT*HWHPPB(S,T,U)
     &         *5./768.*(HWUALF(1,EMSCA)*TQCH/PIFAC)**2
        ENDIF
      ENDIF
C
      HCS=0.
      DO 30 ID=1,6
      FACTR=FACT*QFCH(ID)**2
C---QUARK FIRST
      ID1=ID
      IF (DISF(ID1,1).LT.EPS) GOTO 20
      ID2=ID1+6
      HCS=HCS+CSTU*FACTR*DISF(ID1,1)*DISF(ID2,2)
      IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP( 13, 59,2314,41,*9)
      ID2=13
      HCS=HCS+CTSU*FACTR*DISF(ID1,1)*DISF(ID2,2)
      IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1, 59,3124,42,*9)
C---QBAR FIRST
  20  ID1=ID+6
      IF (DISF(ID1,1).LT.EPS) GOTO 30
      ID2=ID
      HCS=HCS+CSTU*FACTR*DISF(ID1,1)*DISF(ID2,2)
      IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP( 13, 59,3124,43,*9)
      ID2=13
      HCS=HCS+CTSU*FACTR*DISF(ID1,1)*DISF(ID2,2)
      IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1, 59,2314,44,*9)
  30  CONTINUE
C---GLUON FIRST
      ID1=13
      FACTF=FACT*CUST*DISF(ID1,1)
      DO 50 ID=1,6
      FACTR=FACTF*QFCH(ID)**2
      ID2=ID
      IF (DISF(ID2,2).LT.EPS) GOTO 40
      HCS=HCS+FACTR*DISF(ID2,2)
      IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID2, 59,2314,45,*9)
  40  ID2=ID+6
      IF (DISF(ID2,2).LT.EPS) GOTO 50
      HCS=HCS+FACTR*DISF(ID2,2)
      IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID2, 59,3124,46,*9)
  50  CONTINUE
C g+g ---> g+gamma
      ID2=13
      HCS=HCS+DSTU
      IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP( 13, 59,2314,47,*9)
      EVWGT=HCS
      RETURN
C---GENERATE EVENT
    9 IDN(1)=ID1
      IDN(2)=ID2
      IDCMF=15
      CALL HWETWO
  999 END
CDECK  ID>, HWHPPB.
*CMZ :-        -12/01/93  10.12.43  by  Bryan Webber
*-- Author :    Ian Knowles
C-----------------------------------------------------------------------
      FUNCTION HWHPPB(S,T,U)
C-----------------------------------------------------------------------
C     Quark box diagram contribution to photon/gluon scattering
C     Internal quark mass neglected: m_q << U,T,S
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWHPPB,S,T,U,S2,T2,U2,PI2,ALNTU,ALNST,ALNSU
      PI2=ACOS(-1.D0)**2
      S2=S**2
      T2=T**2
      U2=U**2
      ALNTU=LOG(T/U)
      ALNST=LOG(-S/T)
      ALNSU=ALNST+ALNTU
      HWHPPB=5.*4.
     & +((2.*S2+2.*(U2-T2)*ALNTU+(T2+U2)*(ALNTU**2+PI2))/S2)**2
     & +((2.*U2+2.*(T2-S2)*ALNST+(T2+S2)* ALNST**2     )/U2)**2
     & +((2.*T2+2.*(U2-S2)*ALNSU+(U2+S2)* ALNSU**2     )/T2)**2
     & +4.*PI2*(((T2-S2+(T2+S2)*ALNST)/U2)**2
     &         +((U2-S2+(U2+S2)*ALNSU)/T2)**2)
      END
CDECK  ID>, HWHPPE.
*CMZ :-        -12/01/93  10.12.43  by  Bryan Webber
*-- Author :    Ian Knowles
C-----------------------------------------------------------------------
      SUBROUTINE HWHPPE
C-----------------------------------------------------------------------
C     point-like photon/QCD heavy flavour single excitation, using exact
C     massive lightcone kinematics, mean EVWGT = sigma in nb.
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,HWRUNI,HWUALF,EPS,PP1,PP2,QM2,FACTR,
     & PT,PJ,PT2,PTM,EXY,T,CC,EXY2,S,U,C,SIGE,HCS,RCS
      INTEGER IQ1,IQ2,ID1,ID2,IHAD1,IHAD2
      EXTERNAL HWRGEN,HWRUNI,HWUALF
      SAVE PP1,PP2,IQ1,IQ2,QM2,FACTR,SIGE,HCS
      PARAMETER (EPS=1.E-9)
      IHAD1=1
      IF (JDAHEP(1,IHAD1).NE.0) IHAD1=JDAHEP(1,IHAD1)
      IHAD2=2
      IF (JDAHEP(1,IHAD2).NE.0) IHAD2=JDAHEP(1,IHAD2)
      IF (FSTWGT.OR.IHAD1.NE.1.OR.IHAD2.NE.2) THEN
         PP1=PHEP(4,IHAD1)+ABS(PHEP(3,IHAD1))
         PP2=PHEP(4,IHAD2)+ABS(PHEP(3,IHAD2))
         XX(1)=1.
         IQ1=MOD(IPROC,100)
         IQ2=IQ1+6
         QM2=RMASS(IQ1)**2
         FACTR=GEV2NB*(YJMAX-YJMIN)*4.*PIFAC*CFFAC*PP1
     &        *ALPHEM*QFCH(IQ1)**2
      ENDIF
      IF (GENEV) THEN
         RCS=HCS*HWRGEN(0)
      ELSE
         EVWGT=0.
         CALL HWRPOW(PT,PJ)
         PT2=PT**2
         PTM=SQRT(PT2+QM2)
         EXY=EXP(HWRUNI(1,YJMIN,YJMAX))
         T=-PP1*PT/EXY
         CC=T**2-4.*QM2*(PT2+T)
         IF (CC.LT.0) RETURN
         EXY2=(2.*PT2+T-SQRT(CC))*PP1/(2.*T*PTM)
         IF (EXY2.LT.EXP(YJMIN).OR.EXY2.GT.EXP(YJMAX)) RETURN
         XX(2)=(PT/EXY+PTM/EXY2)/PP2
         IF (XX(2).GT.1.) RETURN
C define: S=Shat-M**2, T=That ,U=Uhat-M**2 (2p.Q, -2p.g, -2p.Q')
         S=XX(2)*PP1*PP2
         U=-S-T
         COSTH=(1.+QM2/S)*(T-U)/S-QM2/S
C Set hard process scale (Approx ET-jet)
         EMSCA=SQRT(2.*S*T*U/(S*S+T*T+U*U))
         C=QM2*T/(U*S)
         SIGE=-FACTR*PT*PJ*HWUALF(1,EMSCA)*(S/U+U/S+4.*C*(1.-C))
     &       /(S**2*EXY2*PTM*(1-QM2/(XX(2)*PP2*EXY2)**2))
         CALL HWSFUN(XX(2),EMSCA,IDHW(IHAD2),NSTRU,DISF(1,2),2)
      ENDIF
      HCS=0.
      ID1=59
C photon+Q ---> g+Q
      ID2=IQ1
      IF (DISF(ID2,2).LT.EPS) GOTO 10
      HCS=HCS+SIGE*DISF(ID2,2)
      IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(13,ID2,1423,51,*99)
C photon+Qbar ---> g+Qbar
  10  ID2=IQ2
      IF (DISF(ID2,2).LT.EPS) GOTO 20
      HCS=HCS+SIGE*DISF(ID2,2)
      IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(13,ID2,1342,52,*99)
  20  EVWGT=HCS
      RETURN
C Generate event
  99  IDN(1)=ID1
      IDN(2)=ID2
      IDCMF=15
      CALL HWETWO
  999 END
CDECK  ID>, HWHPPH.
*CMZ :-        -12/01/93  10.12.43  by  Bryan Webber
*-- Author :    Ian Knowles
C-----------------------------------------------------------------------
      SUBROUTINE HWHPPH
C-----------------------------------------------------------------------
C     Point-like photon/gluon heavy flavour pair production, with
C     exact lightcone massive kinematics, mean EVWGT = sigma in nb.
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRUNI,HWUALF,EPS,PP1,PP2,QM2,FACTR,ET,EJ,ET2,
     & EXY,EXY2,S,T,U,C
      INTEGER IQ1,IHAD1,IHAD2
      EXTERNAL HWRUNI,HWUALF
      SAVE PP1,PP2,IQ1,QM2
      PARAMETER (EPS=1.E-9)
      IHAD1=1
      IF (JDAHEP(1,IHAD1).NE.0) IHAD1=JDAHEP(1,IHAD1)
      IHAD2=2
      IF (JDAHEP(1,IHAD2).NE.0) IHAD2=JDAHEP(1,IHAD2)
      IF (FSTWGT.OR.IHAD1.NE.1.OR.IHAD2.NE.2) THEN
         PP1=PHEP(4,IHAD1)+ABS(PHEP(3,IHAD1))
         PP2=PHEP(4,IHAD2)+ABS(PHEP(3,IHAD2))
         XX(1)=1.
         IQ1=MOD(IPROC,100)
         QM2=RMASS(IQ1)**2
         IHPRO=53
         FACTR=-GEV2NB*(YJMAX-YJMIN)*.5*PIFAC*ALPHEM*QFCH(IQ1)**2
      ENDIF
      IF (GENEV) THEN
C Generate event
         IDN(1)=59
         IDN(2)=13
         IDN(3)=IQ1
         IDN(4)=IQ1+6
         ICO(1)=1
         ICO(2)=4
         ICO(3)=2
         ICO(4)=3
         IDCMF=15
         CALL HWETWO
      ELSE
C Select kinematics
         EVWGT=0.
         CALL HWRPOW(ET,EJ)
         ET2=ET**2
         EXY=EXP(HWRUNI(1,YJMIN,YJMAX))
         EXY2=2.*PP1/ET-EXY
         IF (EXY2.LT.EXP(YJMIN).OR.EXY2.GT.EXP(YJMAX)) RETURN
         XX(2)=.5*ET*(1./EXY+1./EXY2)/PP2
         IF (XX(2).LT.0..OR.XX(2).GT.1.) RETURN
         S=XX(2)*PP1*PP2
         IF (S.LT.ET2) RETURN
C define: S=Shat, T=That-M**2, U=Uhat-M**2 (2p.g, -2p.Q, -2p.QBar)
         T=-.5*PP1*ET/EXY
         U=-S-T
         COSTH=(T-U)/(S*SQRT(1.-4.*QM2/S))
         EMSCA=SQRT(2.*S*T*U/(S*S+T*T+U*U))
         CALL HWSFUN(XX(2),EMSCA,IDHW(IHAD2),NSTRU,DISF(1,2),2)
C photon+g ---> Q+Qbar
         IF (DISF(13,2).LT.EPS) THEN
            EVWGT=0.
         ELSE
            C=QM2*S/(U*T)
            EVWGT=FACTR*EJ*ET*HWUALF(1,EMSCA)
     &           *DISF(13,2)*(T/U+U/T+4.*C*(1.-C))/(S*T)
         ENDIF
      ENDIF
  999 END
CDECK  ID>, HWHPPM.
*CMZ :-        -09/12/93  15.50.26  by  Mike Seymour
*-- Author :    Ian Knowles & Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HWHPPM
C-----------------------------------------------------------------------
C     Point-like photon/QCD direct meson production
C     See M. Benayoun, et al., Nucl. Phys. B282 (1987) 653 for details.
C     mean EVWGT = sigma in nb
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,HWRUNI,HWUALF,EPS,PP1,PP2,ET,EJ,EXY,EXY2,
     & FACT,FACTR,S,T,U,REDS,DELT(3,3),C1STU,C3STU,HCS,RCS,CMIX,SMIX,
     & C1WVFN,FPI,FETA8,FETA1,FRHO,FPHI8,FPHI1,FPI2,FETA2(3),FETAP2(3),
     7 FRHO2,FPHI2(3),FOMEG2(3)
      INTEGER MNAME(3,3,2),N4(3),I,J,ID2,ID4,I2,I4,M1,M2,IHAD1,IHAD2
      LOGICAL SPIN0,SPIN1
      EXTERNAL HWRGEN,HWRUNI,HWUALF
      SAVE FPI2,FETA2,FETAP2,FRHO2,FPHI2,FOMEG2,HCS,REDS,FACT,DELT,
     & C1STU,C3STU
      PARAMETER (EPS=1.D-20)
      DATA MNAME/21,38,42,30,21,34,50,46,0,23,39,43,31,23,35,51,47,0/
      DATA N4,SPIN0,SPIN1/3,3,2,.TRUE.,.TRUE./
      DATA C1WVFN,FPI,FETA8,FETA1,FRHO,FPHI8,FPHI1/1.,3*0.093,3*0.107/
      IF (FSTWGT) THEN
         FPI2=FPI**2
         CMIX=COS(ETAMIX*PIFAC/180.D0)
         SMIX=SIN(ETAMIX*PIFAC/180.D0)
         FETA2(1) =(+CMIX*FETA8/SQRT(TWO)-SMIX*FETA1)**2/THREE
         FETA2(2) =FETA2(1)
         FETA2(3) =(-CMIX*FETA8*SQRT(TWO)-SMIX*FETA1)**2/THREE
         FETAP2(1)=(+SMIX*FETA8/SQRT(TWO)+CMIX*FETA1)**2/THREE
         FETAP2(2)=FETAP2(1)
         FETAP2(3)=(-SMIX*FETA8*SQRT(TWO)+CMIX*FETA1)**2/THREE
         FRHO2=FRHO**2
         CMIX=COS(PHIMIX*PIFAC/180.D0)
         SMIX=SIN(PHIMIX*PIFAC/180.D0)
         FPHI2(1) =(+CMIX*FPHI8/SQRT(TWO)-SMIX*FPHI1)**2/THREE
         FPHI2(2) =FPHI2(1)
         FPHI2(3) =(-CMIX*FPHI8*SQRT(TWO)-SMIX*FPHI1)**2/THREE
         FOMEG2(1)=(+SMIX*FPHI8/SQRT(TWO)+CMIX*FPHI1)**2/THREE
         FOMEG2(2)=FOMEG2(1)
         FOMEG2(3)=(-SMIX*FPHI8*SQRT(TWO)+CMIX*FPHI1)**2/THREE
      ENDIF
      SPIN0=.NOT.(MOD(IPROC/10,10).EQ.2)
      SPIN1=.NOT.(MOD(IPROC/10,10).EQ.1)
      IF (GENEV) THEN
         RCS=HCS*HWRGEN(0)
      ELSE
         EVWGT=ZERO
         IHAD1=1
         IF (JDAHEP(1,IHAD1).NE.0) IHAD1=JDAHEP(1,IHAD1)
         IHAD2=2
         IF (JDAHEP(1,IHAD2).NE.0) IHAD2=JDAHEP(1,IHAD2)
         PP1=PHEP(4,IHAD1)+ABS(PHEP(3,IHAD1))
         PP2=PHEP(4,IHAD2)+ABS(PHEP(3,IHAD2))
         XX(1)=ONE
         CALL HWRPOW(ET,EJ)
         EXY=EXP(HWRUNI(1,YJMIN,YJMAX))
         EXY2=TWO*PP1/ET-EXY
         IF (EXY2.LE.EXP(YJMIN).OR.EXY2.GE.EXP(YJMAX)) RETURN
         XX(2)=PP1/(PP2*EXY*EXY2)
         IF (XX(2).LE.ZERO.OR.XX(2).GE.ONE) RETURN
         S=XX(2)*PP1*PP2
         REDS=SQRT(S-ET*SQRT(S))
         T=-HALF*PP1*ET/EXY
         U=-S-T
         COSTH=(T-U)/S
C Set EMSCA to hard process scale (Approx ET-jet)
         EMSCA=SQRT(TWO*S*T*U/(S*S+T*T+U*U))
         FACT=-GEV2NB*ET*EJ*(YJMAX-YJMIN)*ALPHEM*CFFAC
     &       *(HWUALF(1,EMSCA)*PIFAC*C1WVFN)**2*32.D0/(THREE*S*T)
         CALL HWSFUN(XX(2),EMSCA,IDHW(IHAD2),NSTRU,DISF(1,2),2)
         DO 10 I=1,3
         DO 10 J=1,3
 10      DELT(I,J)=(QFCH(I)*U+QFCH(J)*S)**2
         C1STU=-(S**2+U**2)/(T*S**2*U**2)
         C3STU=-8.D0*T/(S**2*U**2)
      ENDIF
      HCS=ZERO
      DO 50 I2=1,3
C Quark initiated processes
      ID2=I2
      IF (DISF(ID2,2).LT.EPS) GOTO 30
      DO 20 ID4=1,N4(I2)
      M1=MNAME(ID2,ID4,1)
      FACTR=FACT*DELT(ID2,ID4)*DISF(ID2,2)
      IF (ID2.EQ.ID4) FACTR=HALF*FACTR
      IF (SPIN0.AND.REDS.GT.RMASS(M1)) THEN
C  photon+q --> meson_0+q'
         HCS=HCS+HALF*FACTR*C1STU*FPI2
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(M1,ID4,1432,71,*99)
      ENDIF
      M2=MNAME(ID2,ID4,2)
      IF (SPIN1.AND.REDS.GT.RMASS(M2)) THEN
C  photon+q --> meson_L+q'
         HCS=HCS+FACTR*C1STU*FRHO2
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(M2,ID4,1432,72,*99)
C  photon+q --> meson_T+q'
         HCS=HCS+FACTR*C3STU*FRHO2
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(M2,ID4,1432,73,*99)
      ENDIF
  20  CONTINUE
      FACTR=FACT*DELT(I2,I2)*DISF(ID2,2)
      IF (SPIN0.AND.REDS.GT.RMASS(22)) THEN
C  photon+q -->eta+q
         HCS=HCS+HALF*FACTR*C1STU*FETA2(I2)
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(22,ID2,1432,71,*99)
      ENDIF
      IF (SPIN0.AND.REDS.GT.RMASS(25)) THEN
C  photon+q -->eta'+q
         HCS=HCS+HALF*FACTR*C1STU*FETAP2(I2)
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(25,ID2,1432,71,*99)
      ENDIF
      IF (SPIN1.AND.REDS.GT.RMASS(56)) THEN
C  photon+q -->phi_L+q
         HCS=HCS+FACTR*C1STU*FPHI2(I2)
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(56,ID2,1432,72,*99)
C  photon+q -->phi_T+q
         HCS=HCS+FACTR*C3STU*FPHI2(I2)
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(56,ID2,1432,73,*99)
      ENDIF
      IF (SPIN1.AND.REDS.GT.RMASS(24)) THEN
C  photon+q -->omega_L+q
         HCS=HCS+FACTR*C1STU*FOMEG2(I2)
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(24,ID2,1432,72,*99)
C  photon+q -->omega_T+q
         HCS=HCS+FACTR*C3STU*FOMEG2(I2)
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(24,ID2,1432,73,*99)
      ENDIF
C Anti-quark initiated processes
  30  ID2=I2+6
      IF (DISF(ID2,2).LT.EPS) GOTO 50
      DO 40 I4=1,N4(I2)
      ID4=I4+6
      FACTR=FACT*DELT(I2,I4)*DISF(ID2,2)
      IF (ID2.EQ.ID4) FACTR=HALF*FACTR
      M1=MNAME(I4,I2,1)
      IF (SPIN0.AND.REDS.GT.RMASS(M1)) THEN
C  photon+qbar --> meson_0+qbar'
         HCS=HCS+HALF*FACTR*C1STU*FPI2
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(M1,ID4,1432,74,*99)
      ENDIF
      M2=MNAME(I4,I2,2)
      IF (SPIN1.AND.REDS.GT.RMASS(M2)) THEN
C  photon+qbar --> meson_L+qbar'
         HCS=HCS+FACTR*C1STU*FRHO2
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(M2,ID4,1432,75,*99)
C  photon+qbar --> meson_T+qbar'
         HCS=HCS+FACTR*C3STU*FRHO2
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(M2,ID4,1432,76,*99)
      ENDIF
  40  CONTINUE
      FACTR=FACT*DELT(I2,I2)*DISF(ID2,2)
      IF (SPIN0.AND.REDS.GT.RMASS(22)) THEN
C  photon+qbar -->eta+qbar
         HCS=HCS+HALF*FACTR*C1STU*FETA2(I2)
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(22,ID2,1432,74,*99)
      ENDIF
      IF (SPIN0.AND.REDS.GT.RMASS(25)) THEN
C  photon+qbar -->eta'+qbar
         HCS=HCS+HALF*FACTR*C1STU*FETAP2(I2)
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(25,ID2,1432,74,*99)
      ENDIF
      IF (SPIN1.AND.REDS.GT.RMASS(56)) THEN
C  photon+qbar -->phi_L+qbar
         HCS=HCS+FACTR*C1STU*FPHI2(I2)
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(56,ID2,1432,75,*99)
C  photon+qbar -->phi_T+qbar
         HCS=HCS+FACTR*C3STU*FPHI2(I2)
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(56,ID2,1432,76,*99)
      ENDIF
      IF (SPIN1.AND.REDS.GT.RMASS(24)) THEN
C  photon+qbar -->omega_L+qbar
         HCS=HCS+FACTR*C1STU*FOMEG2(I2)
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(24,ID2,1432,75,*99)
C  photon+qbar -->omega_T+qbar
         HCS=HCS+FACTR*C3STU*FOMEG2(I2)
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(24,ID2,1432,76,*99)
      ENDIF
  50  CONTINUE
      EVWGT=HCS
      RETURN
C Generate event
  99  IDN(1)=59
      IDN(2)=ID2
      IDCMF=15
      CALL HWETWO
C Set polarization vector
      IF (IHPRO.EQ.72.OR.IHPRO.EQ.75) THEN
        RHOHEP(2,NHEP-1)=ONE
      ELSEIF (IHPRO.EQ.73.OR.IHPRO.EQ.76) THEN
        RHOHEP(1,NHEP-1)=HALF
        RHOHEP(3,NHEP-1)=HALF
      ENDIF
  999 END
CDECK  ID>, HWHPPT.
*CMZ :-        -12/01/93  10.12.43  by  Bryan Webber
*-- Author :    Ian Knowles
C-----------------------------------------------------------------------
      SUBROUTINE HWHPPT
C-----------------------------------------------------------------------
C     point-like photon/QCD di-jet production: mean EVWGT = sigma in nb
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,HWRUNI,HWUALF,EPS,RCS,PP1,PP2,ET,EJ,
     & EXY,EXY2,FACTR,RS,S,T,U,CSTU,CTSU,HCS
      INTEGER ID1,ID2,ID3,ID4,IHAD1,IHAD2
      EXTERNAL HWRGEN,HWRUNI,HWUALF
      SAVE CSTU,CTSU,HCS
      PARAMETER (EPS=1.E-9)
      IHAD1=1
      IF (JDAHEP(1,IHAD1).NE.0) IHAD1=JDAHEP(1,IHAD1)
      IHAD2=2
      IF (JDAHEP(1,IHAD2).NE.0) IHAD2=JDAHEP(1,IHAD2)
      IF (GENEV) THEN
         RCS=HCS*HWRGEN(0)
      ELSE
         EVWGT=0.
         PP1=PHEP(4,IHAD1)+ABS(PHEP(3,IHAD1))
         PP2=PHEP(4,IHAD2)+ABS(PHEP(3,IHAD2))
         XX(1)=1.
         CALL HWRPOW(ET,EJ)
         EXY=EXP(HWRUNI(1,YJMIN,YJMAX))
         EXY2=2.*PP1/ET-EXY
         IF (EXY2.LE.EXP(YJMIN).OR.EXY2.GE.EXP(YJMAX)) RETURN
         XX(2)=PP1/(PP2*EXY*EXY2)
         IF (XX(2).LE.0..OR.XX(2).GE.1.) RETURN
         S=XX(2)*PP1*PP2
         RS=.5*SQRT(S)
         T=-PP1*0.5*ET/EXY
         U=-S-T
         COSTH=(T-U)/S
C Set EMSCA to hard process scale (Approx ET-jet)
         EMSCA=SQRT(2.*S*T*U/(S*S+T*T+U*U))
         FACTR=-GEV2NB*0.5*EJ*(YJMAX-YJMIN)*ET*PIFAC*ALPHEM
     &        *HWUALF(1,EMSCA)/(S*T)
         CALL HWSFUN(XX(2),EMSCA,IDHW(IHAD2),NSTRU,DISF(1,2),2)
         CSTU=U/T+T/U
         CTSU=-2.*CFFAC*(U/S+S/U)
      ENDIF
      HCS=0.
      ID1=59
      DO 20 ID2=1,13
      IF (DISF(ID2,2).LT.EPS) GOTO 20
      IF (ID2.LT.7) THEN
C photon+q ---> g+q
         HCS=HCS+CTSU*DISF(ID2,2)*QFCH(ID2)**2
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP( 13,ID2,1423,51,*99)
      ELSEIF (ID2.LT.13) THEN
C photon+qbar ---> g+qbar
         HCS=HCS+CTSU*DISF(ID2,2)*QFCH(ID2-6)**2
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP( 13,ID2,1342,52,*99)
      ELSE
C photon+g ---> q+qbar
         DO 10 ID3=1,6
         IF (RS.GT.RMASS(ID3)) THEN
            ID4=ID3+6
            HCS=HCS+CSTU*DISF(ID2,2)*QFCH(ID3)**2
            IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID3,ID4,1423,53,*99)
         ENDIF
  10     CONTINUE
      ENDIF
  20  CONTINUE
      EVWGT=FACTR*HCS
      RETURN
C Generate event
  99  IDN(1)=ID1
      IDN(2)=ID2
      IDCMF=15
      CALL HWETWO
  999 END
CDECK  ID>, HWHPQS.
*CMZ :-        -27/03/95  13.27.22  by  Mike Seymour
*-- Author :    Ian Knowles
C-----------------------------------------------------------------------
      SUBROUTINE HWHPQS
C-----------------------------------------------------------------------
C     Compton scattering of point-like photon and (anti)quark
C     mean EVWGT = sigma in nb
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,HWRUNI,EPS,RCS,PP1,PP2,ET,EJ,EXY,EXY2,
     & FACTR,RS,S,T,U,CTSU,HCS
      INTEGER ID1,ID2,IHAD1,IHAD2
      EXTERNAL HWRGEN,HWRUNI
      SAVE CTSU,HCS
      PARAMETER (EPS=1.E-9)
      IHAD1=1
      IF (JDAHEP(1,IHAD1).NE.0) IHAD1=JDAHEP(1,IHAD1)
      IHAD2=2
      IF (JDAHEP(1,IHAD2).NE.0) IHAD2=JDAHEP(1,IHAD2)
      IF (GENEV) THEN
         RCS=HCS*HWRGEN(0)
      ELSE
         EVWGT=0.
         PP1=PHEP(4,IHAD1)+ABS(PHEP(3,IHAD1))
         PP2=PHEP(4,IHAD2)+ABS(PHEP(3,IHAD2))
         XX(1)=1.
         CALL HWRPOW(ET,EJ)
         EXY=EXP(HWRUNI(1,YJMIN,YJMAX))
         EXY2=2.*PP1/ET-EXY
         IF (EXY2.LE.EXP(YJMIN).OR.EXY2.GE.EXP(YJMAX)) RETURN
         XX(2)=PP1/(PP2*EXY*EXY2)
         IF (XX(2).LE.0..OR.XX(2).GE.1.) RETURN
         S=XX(2)*PP1*PP2
         RS=.5*SQRT(S)
         T=-PP1*0.5*ET/EXY
         U=-S-T
         COSTH=(T-U)/S
C Set EMSCA to hard process scale (Approx ET-jet)
         EMSCA=SQRT(2.*S*T*U/(S*S+T*T+U*U))
         FACTR=-GEV2NB*0.5*EJ*(YJMAX-YJMIN)*ET*PIFAC*ALPHEM**2/(S*T)
         CALL HWSFUN(XX(2),EMSCA,IDHW(IHAD2),NSTRU,DISF(1,2),2)
         CTSU=-2.*(U/S+S/U)
      ENDIF
      HCS=0.
      ID1=59
      DO 20 ID2=1,12
      IF (DISF(ID2,2).LT.EPS) GOTO 20
      IF (ID2.LT.7) THEN
C photon+q ---> photon+q
         HCS=HCS+CTSU*DISF(ID2,2)*QFCH(ID2)**4
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP( 59,ID2,1432,66,*99)
      ELSE
C photon+qbar ---> photon+qbar
         HCS=HCS+CTSU*DISF(ID2,2)*QFCH(ID2-6)**4
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP( 59,ID2,1432,67,*99)
      ENDIF
  20  CONTINUE
      EVWGT=FACTR*HCS
      RETURN
C Generate event
  99  IDN(1)=ID1
      IDN(2)=ID2
      IDCMF=15
      CALL HWETWO
  999 END
CDECK  ID>, HWHQCD.
*CMZ :-        -26/04/91  14.55.45  by  Federico Carminati
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWHQCD
C-----------------------------------------------------------------------
C     QCD HARD 2->2 PROCESSES: MEAN EVWGT = SIGMA IN NB
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,HWRUNI,HWUALF,RS,EPS,HF,RCS,Z1,Z2,ET,EJ,
     & FACTR,S,T,U,ST,TU,US,STU,TUS,UST,EN,RN,GFLA,AF,ASTU,ASUT,AUST,
     & BF,BSTU,BSUT,BUST,BUTS,CF,CSTU,CSUT,CTSU,CTUS,DF,DSTU,DTSU,DUTS,
     & DIST,HCS,UT,SU,GT,KK,KK2,YJ1INF,YJ1SUP,YJ2INF,YJ2SUP
      INTEGER ID1,ID2,I
      EXTERNAL HWRGEN,HWRUNI,HWUALF
      SAVE HCS
      PARAMETER (EPS=1.E-9,HF=0.5)
      IF (GENEV) THEN
        RCS=HCS*HWRGEN(0)
      ELSE
        EVWGT=0.
        CALL HWRPOW(ET,EJ)
        KK = ET/PHEP(5,3)
        KK2=KK**2
        IF (KK.GE.1.) RETURN
        YJ1INF = MAX( YJMIN, LOG((ONE-SQRT(ONE-KK2))/KK) )
        YJ1SUP = MIN( YJMAX, LOG((ONE+SQRT(ONE-KK2))/KK) )
        IF (YJ1INF.GE.YJ1SUP) RETURN
        Z1=EXP(HWRUNI(1,YJ1INF,YJ1SUP))
        YJ2INF = MAX( YJMIN, -LOG(TWO/KK-ONE/Z1) )
        YJ2SUP = MIN( YJMAX, LOG(TWO/KK-Z1) )
        IF (YJ2INF.GE.YJ2SUP) RETURN
        Z2=EXP(HWRUNI(2,YJ2INF,YJ2SUP))
        XX(1)=.5*(Z1+Z2)*KK
        IF (XX(1).GE.1.) RETURN
        XX(2)=XX(1)/(Z1*Z2)
        IF (XX(2).GE.1.) RETURN
        COSTH=(Z1-Z2)/(Z1+Z2)
        S=XX(1)*XX(2)*PHEP(5,3)**2
        RS=HF*SQRT(S)
        DO 3 I=1,NFLAV
        IF (RS.LT.RMASS(I)) GOTO 4
    3   CONTINUE
        I=NFLAV+1
    4   MAXFL=I-1
        IF (MAXFL.EQ.0) CALL HWWARN('HWHQCD',100,*999)
C
        T=-HF*S*(1.-COSTH)
        U=-S-T
C---SET EMSCA TO HARD PROCESS SCALE (APPROX ET-JET)
        EMSCA=SQRT(2.*S*T*U/(S*S+T*T+U*U))
        FACTR = GEV2NB*.5*PIFAC*EJ*ET*(HWUALF(1,EMSCA)/S)**2
     &        * (YJ1SUP-YJ1INF)*(YJ2SUP-YJ2INF)
        CALL HWSGEN(.FALSE.)
C
        ST=S/T
        TU=T/U
        US=U/S
        STU=TU/US
        TUS=US/ST
        UST=ST/TU
C
        EN=CAFAC
        RN=CFFAC/EN
        GFLA=HF*FLOAT(MAXFL)/(EN*RN)**2
        AF=FACTR*RN
        ASTU=AF*(1.-2.*UST)
        ASUT=AF*(1.-2.*STU)
        AUST=AF*(1.-2.*TUS)
        BF=2.*AF/EN
        BSTU=HF*(ASTU+BF*ST)
        BSUT=HF*(ASUT+BF/US)
        BUST=AUST+BF*US
        BUTS=ASTU+BF/TU
        CF=AF*EN
        CSTU=(CF*(RN-TUS))/TU
        CSUT=(CF*(RN-TUS))*TU
        CTSU=(FACTR*(UST-RN))*US
        CTUS=(FACTR*(UST-RN))/US
        DF=HF*FACTR/RN
        DSTU=DF*(1.+1./TUS-STU-UST)
        DTSU=DF*(1.+1./UST-STU-TUS)
        DUTS=DF*(1.+1./STU-UST-TUS)
      ENDIF
C
      HCS=0.
      DO 6 ID1=1,13
      IF (DISF(ID1,1).LT.EPS) GOTO 6
      DO 5 ID2=1,13
      IF (DISF(ID2,2).LT.EPS) GOTO 5
      DIST=DISF(ID1,1)*DISF(ID2,2)
      IF (ID1.LT.7) THEN
C---QUARK FIRST
       IF (ID2.LT.7) THEN
        IF (ID1.NE.ID2) THEN
         HCS=HCS+ASTU*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,3421, 3,*9)
        ELSE
         HCS=HCS+BSTU*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,3421, 1,*9)
         HCS=HCS+BSUT*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,4312, 2,*9)
        ENDIF
       ELSEIF (ID2.NE.13) THEN
        IF (ID2.NE.ID1+6) THEN
         HCS=HCS+ASTU*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,3142, 9,*9)
        ELSE
         HCS=HCS+FLOAT(MAXFL-1)*AUST*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(-ID1, 0,2413, 4,*9)
         HCS=HCS+BUTS*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,3142, 5,*9)
         HCS=HCS+BUST*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,2413, 6,*9)
         HCS=HCS+CSTU*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP( 13, 13,2413, 7,*9)
         HCS=HCS+CSUT*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP( 13, 13,2341, 8,*9)
        ENDIF
       ELSE
         HCS=HCS+CTSU*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,3142,10,*9)
         HCS=HCS+CTUS*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,3421,11,*9)
       ENDIF
      ELSEIF (ID1.NE.13) THEN
C---QBAR FIRST
       IF (ID2.LT.7) THEN
        IF (ID1.NE.ID2+6) THEN
         HCS=HCS+ASTU*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,2413,17,*9)
        ELSE
         HCS=HCS+FLOAT(MAXFL-1)*AUST*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(-ID1, 0,3142,12,*9)
         HCS=HCS+BUTS*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,2413,13,*9)
         HCS=HCS+BUST*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,3142,14,*9)
         HCS=HCS+CSTU*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP( 13, 13,3142,15,*9)
         HCS=HCS+CSUT*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP( 13, 13,4123,16,*9)
        ENDIF
       ELSEIF (ID2.NE.13) THEN
        IF (ID1.NE.ID2) THEN
         HCS=HCS+ASTU*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,4312,20,*9)
        ELSE
         HCS=HCS+BSTU*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,4312,18,*9)
         HCS=HCS+BSUT*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,3421,19,*9)
        ENDIF
       ELSE
         HCS=HCS+CTSU*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,2413,21,*9)
         HCS=HCS+CTUS*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,4312,22,*9)
       ENDIF
      ELSE
C---GLUON FIRST
       IF (ID2.LT.7) THEN
         HCS=HCS+CTSU*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,2413,23,*9)
         HCS=HCS+CTUS*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,3421,24,*9)
       ELSEIF (ID2.LT.13) THEN
         HCS=HCS+CTSU*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,3142,25,*9)
         HCS=HCS+CTUS*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,4312,26,*9)
       ELSE
         HCS=HCS+GFLA*CSTU*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(  0,  0,2413,27,*9)
         HCS=HCS+GFLA*CSUT*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(  0,  0,4123,28,*9)
         HCS=HCS+DTSU*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,2341,29,*9)
         HCS=HCS+DSTU*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,3421,30,*9)
         HCS=HCS+DUTS*DIST
         IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,2413,31,*9)
       ENDIF
      ENDIF
    5 CONTINUE
    6 CONTINUE
      EVWGT=HCS
      RETURN
C---GENERATE EVENT
    9 IDN(1)=ID1
      IDN(2)=ID2
      IDCMF=15
      CALL HWETWO
      IF (AZSPIN) THEN
C Calculate coefficients for constructing spin density matrices
         IF (IHPRO.EQ.7 .OR.IHPRO.EQ.8 .OR.
     &       IHPRO.EQ.15.OR.IHPRO.EQ.16) THEN
C qqbar-->gg or qbarq-->gg
            UT=1./TU
            GCOEF(1)=UT+TU
            GCOEF(2)=-2.
            GCOEF(3)=0.
            GCOEF(4)=0.
            GCOEF(5)=GCOEF(1)
            GCOEF(6)=UT-TU
            GCOEF(7)=-GCOEF(6)
         ELSEIF (IHPRO.EQ.10.OR.IHPRO.EQ.11.OR.
     &           IHPRO.EQ.21.OR.IHPRO.EQ.22.OR.
     &           IHPRO.EQ.23.OR.IHPRO.EQ.24.OR.
     &           IHPRO.EQ.25.OR.IHPRO.EQ.26) THEN
C qg-->qg or qbarg-->qbarg or gq-->gq  or gqbar-->gqbar
            SU=1./US
            GCOEF(1)=-(SU+US)
            GCOEF(2)=0.
            GCOEF(3)=2.
            GCOEF(4)=0.
            GCOEF(5)=SU-US
            GCOEF(6)=GCOEF(1)
            GCOEF(7)=-GCOEF(5)
         ELSEIF (IHPRO.EQ.27.OR.IHPRO.EQ.28) THEN
C gg-->qqbar
            UT=1./TU
            GCOEF(1)=TU+UT
            GCOEF(2)=-2.
            GCOEF(3)=0.
            GCOEF(4)=0.
            GCOEF(5)=GCOEF(1)
            GCOEF(6)=TU-UT
            GCOEF(7)=-GCOEF(6)
         ELSEIF (IHPRO.EQ.29.OR.IHPRO.EQ.30.OR.
     &                          IHPRO.EQ.31) THEN
C gg-->gg
            GT=S*S+T*T+U*U
            GCOEF(2)=2.*U*U*T*T
            GCOEF(3)=2.*S*S*U*U
            GCOEF(4)=2.*S*S*T*T
            GCOEF(1)=GT*GT-GCOEF(2)-GCOEF(3)-GCOEF(4)
            GCOEF(5)=GT*(GT-2.*S*S)-GCOEF(2)
            GCOEF(6)=GT*(GT-2.*T*T)-GCOEF(3)
            GCOEF(7)=GT*(GT-2.*U*U)-GCOEF(4)
         ELSE
            CALL HWVZRO(7,GCOEF)
         ENDIF
      ENDIF
  999 END
CDECK  ID>, HWHQCP.
*CMZ :-        -26/04/91  10.18.57  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWHQCP(ID3,ID4,IPERM,IHPR,*)
C-----------------------------------------------------------------------
C     IDENTIFIES HARD SUBPROCESS
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      INTEGER HWRINT,ID3,ID4,IPERM,IHPR,ND3
      EXTERNAL HWRINT
      IHPRO=IHPR
      IF (ID3.GT.0) THEN
        IDN(3)=ID3
        IDN(4)=ID4
      ELSE
        ND3=-ID3
        IF (ID3.GT.-7) THEN
    1     IDN(3)=HWRINT(1,MAXFL)
          IF (IDN(3).EQ.ND3) GOTO 1
          IDN(4)=IDN(3)+6
        ELSE
    2     IDN(3)=HWRINT(1,MAXFL)+6
          IF (IDN(3).EQ.ND3) GOTO 2
          IDN(4)=IDN(3)-6
        ENDIF
      ENDIF
      ICO(1)=IPERM/1000
      ICO(2)=IPERM/100-10*ICO(1)
      ICO(3)=IPERM/10 -10*(IPERM/100)
      ICO(4)=IPERM    -10*(IPERM/10)
      RETURN 1
      END
CDECK  ID>, HWHREM.
*CMZ :-        -01/06/94  17.03.31  by  Mike Seymour
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HWHREM(IBEAM,ITARG)
C-----------------------------------------------------------------------
C     IDENTIFY THE REMNANTS OF THE HARD SCATTERING
C     AND BREAK THEIR COLOUR CONNECTION IF NECESSARY
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION PCL(5)
      INTEGER IBEAM,ITARG,IHEP,NTEMP,I,ICOL,IANT
      LOGICAL LTEMP,T,COL,ANT
      PARAMETER (T=.TRUE.)
      COL(I)=I.EQ.13 .OR. I.GE.1.AND.I.LE.6 .OR. I.GE.115.AND.I.LE.120
      ANT(I)=I.EQ.13 .OR. I.GE.7.AND.I.LE.12.OR. I.GE.109.AND.I.LE.114
C---LOOK FOR UNTREATED BEAM AND TARGET REMNANTS
      IBEAM=0
      ITARG=0
      DO 10 IHEP=1,NHEP
        IF (ISTHEP(IHEP).EQ.148) THEN
          IF (ITARG.NE.0) CALL HWWARN('HWHREM',100,*999)
          ITARG=IHEP
        ELSEIF (ISTHEP(IHEP).EQ.147) THEN
          IF (IBEAM.NE.0) CALL HWWARN('HWHREM',101,*999)
          IBEAM=IHEP
        ENDIF
  10  CONTINUE
      IF (ITARG.EQ.0) CALL HWWARN('HWHREM',102,*999)
      IF (IBEAM.EQ.0) CALL HWWARN('HWHREM',103,*999)
C---IF THEY ARE COLOUR CONNECTED, DISCONNECT THEM BY EMITTING A SOFT
C   GLUON AND SPLITTING THAT GLUON TO LIGHT QUARKS
C  (WHICH NORMALLY GETS DONE AS THE FIRST STAGE OF CLUSTER FORMATION)
C---LOOP OVER COLOUR/ANTICOLOUR LINE
      DO 20 I=1,2
        IF (I.EQ.1) THEN
          ICOL=IBEAM
          IANT=ITARG
        ELSE
          ICOL=ITARG
          IANT=IBEAM
        ENDIF
        IF (COL(IDHW(ICOL)).AND.ANT(IDHW(IANT)).AND.
     $       JMOHEP(2,ICOL).EQ.IANT.AND.JDAHEP(2,IANT).EQ.ICOL) THEN
          CALL HWVSUM(4,PHEP(1,ICOL),PHEP(1,IANT),PCL)
          CALL HWUMAS(PCL)
          NTEMP=NHEP
          CALL HWCCUT(ICOL,IANT,PCL,T,LTEMP)
C---IF NOTHING WAS CREATED THEY MUST BE BELOW THRESHOLD, SO GIVE UP
          IF (NHEP.NE.NTEMP+2) RETURN
C---RELABEL THEM AS PERTUBATIVE JUST TO NEATEN UP THE EVENT RECORD
          ISTHEP(NHEP-1)=149
          ISTHEP(NHEP)=149
        ENDIF
 20   CONTINUE
 999  END
CDECK  ID>, HWHSCT.
*CMZ :-        -30/05/94  18.42.43  by  Mike Seymour
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HWHSCT(REPORT)
C-----------------------------------------------------------------------
C     RELABEL THE EVENT RECORD FOR EXTRA HARD SCATTERING,
C     DO THE SCATTERING, PARTON SHOWER IT, AND CLEAN UP THE EVENT RECORD
C     REPORT RETURNS THE OUTCOME:
C     0 = SUCCESSFUL
C     1 = FAILED DUE TO ERROR IN HARD SCATTERING GENERATION
C     2 = FAILED DUE TO ENERGY CONSERVATION IN HARD SCATTERING
C     3 = FAILED DUE TO ERROR IN PARTON EVOLUTION
C     4 = FAILED DUE TO ENERGY CONSERVATION IN PARTON EVOLUTION
C     5 = COMPLETELY FAILED (IERROR IS ALSO NON-ZERO TO CANCEL EVENT)
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,TMPWGT,PBOOST(5),RBOOST(3,3)
      INTEGER IHEP,IBM,ITG,IBMN,ITGN,IBMT,ITGT,I,REPORT
      LOGICAL COL
      EXTERNAL HWRGEN
      COL(I)=I.EQ.13 .OR. I.GE.1.AND.I.LE.6 .OR. I.GE.115.AND.I.LE.120
      REPORT=5
      IF (IERROR.NE.0) RETURN
C---FIND BEAM AND TARGET REMNANTS
      CALL HWHREM(IBM,ITG)
      IF (IERROR.NE.0) RETURN
C---RECALCULATE THEIR MASS CORRECTLY
      CALL HWUMAS(PHEP(1,IBM))
      CALL HWUMAS(PHEP(1,ITG))
C---SET UP NEW ENTRIES IN THE EVENT RECORD
      NHEP=NHEP+1
      CALL HWVEQU(5,PHEP(1,IBM),PHEP(1,NHEP))
      ISTHEP(NHEP)=3
      IBMN=NHEP
      IBMT=JDAHEP(1,1)
      IF (IBMT.EQ.0) THEN
        JMOHEP(1,NHEP)=1
        IDHW(NHEP)=72
      ELSE
        JMOHEP(1,NHEP)=IBMT
        IDHW(NHEP)=71
      ENDIF
      JMOHEP(2,NHEP)=0
      JDAHEP(1,NHEP)=0
      JDAHEP(2,NHEP)=0
      IDHEP(NHEP)=IDPDG(IDHW(NHEP))
      NHEP=NHEP+1
      CALL HWVEQU(5,PHEP(1,ITG),PHEP(1,NHEP))
      ISTHEP(NHEP)=3
      ITGN=NHEP
      ITGT=JDAHEP(1,2)
      IF (ITGT.EQ.0) THEN
        JMOHEP(1,NHEP)=2
        IDHW(NHEP)=72
      ELSE
        JMOHEP(1,NHEP)=ITGT
        IDHW(NHEP)=71
      ENDIF
      JMOHEP(2,NHEP)=0
      JDAHEP(1,NHEP)=0
      JDAHEP(2,NHEP)=0
      IDHEP(NHEP)=IDPDG(IDHW(NHEP))
C---BOOST TO THEIR CENTRE-OF-MASS FRAME
      CALL HWVSUM(4,PHEP(1,IBMN),PHEP(1,ITGN),PBOOST)
      CALL HWUMAS(PBOOST)
      DO 100 IHEP=IBMN,NHEP
        CALL HWULOF(PBOOST,PHEP(1,IHEP),PHEP(1,IHEP))
 100  CONTINUE
      CALL HWUROT(PHEP(1,IBMN),ONE,ZERO,RBOOST)
      DO 110 IHEP=IBMN,NHEP
        CALL HWUROF(RBOOST,PHEP(1,IHEP),PHEP(1,IHEP))
 110  CONTINUE
C---GENERATE A NEW HARD SCATTERING
      TMPWGT=EVWGT
      GENEV=.FALSE.
 10   CALL HWHQCD
      IF (IERROR.NE.0.OR.GAMWT*EVWGT.LE.WGTMAX*HWRGEN(0)) THEN
        IERROR=0
        GOTO 10
      ENDIF
      GENEV=.TRUE.
      CALL HWHQCD
      EVWGT=TMPWGT
C---IF MOMENTUM CANNOT BE CONSERVED, STOP GENERATING HARD SCATTERS
      IF (  PHEP(4,IBMN+2) .GT. PHEP(4,IBMN).OR.
     $      PHEP(4,ITGN+2) .GT. PHEP(4,ITGN).OR.
     $      PHEP(3,IBMN+2) .GT. PHEP(3,IBMN).OR.
     $     -PHEP(3,ITGN+2) .GT.-PHEP(3,ITGN).OR.IERROR.NE.0) THEN
        IF (IERROR.GT.0) THEN
          WRITE (6,'(A/A)')
     $       ' THIS ERROR OCCURED DURING A SECONDARY SCATTER AND WAS',
     $       ' CAUGHT BY HWHSCT, SO EVENT IS NOT KILLED AFTER ALL'
          REPORT=1
        ELSE
          REPORT=2
        ENDIF
        NHEP=IBMN-1
        IERROR=0
        RETURN
      ENDIF
C---RELABEL OUTGOING REMNANTS AS INCOMING HADRONS
      JDAHEP(1,1)=IBMN
      JDAHEP(1,2)=ITGN
C---EVOLVE THEM
      ISLENT=-1
      CALL HWBGEN
      ISLENT=1
C---PUT THE LABELS BACK
      JDAHEP(1,1)=IBMT
      JDAHEP(1,2)=ITGT
C---IF THERE WERE ANY PROBLEMS, STOP GENERATING HARD SCATTERS
      IF (IERROR.NE.0) THEN
        IF (IERROR.GT.0) THEN
          WRITE (6,'(A/A)')
     $       ' THIS ERROR OCCURED DURING A SECONDARY SCATTER AND WAS',
     $       ' CAUGHT BY HWHSCT, SO EVENT IS NOT KILLED AFTER ALL'
          REPORT=3
        ELSE
          REPORT=4
        ENDIF
        NHEP=IBMN-1
        IERROR=0
        RETURN
      ENDIF
C---UNDO THE LORENTZ BOOST
      DO 200 IHEP=IBMN,NHEP
        CALL HWUROB(RBOOST,PHEP(1,IHEP),PHEP(1,IHEP))
        CALL HWULOB(PBOOST,PHEP(1,IHEP),PHEP(1,IHEP))
 200  CONTINUE
C---FIND THE NEW BEAM AND TARGET REMNANTS
      ISTHEP(IBM)=3
      ISTHEP(ITG)=3
      CALL HWHREM(IBMN,ITGN)
      IF (IERROR.NE.0) RETURN
C---CONNECT UP THE COLOUR/FLAVOUR LINES OF THE TWO SCATTERS
      IDHW(IBMN)=IDHW(IBM)
      IDHEP(IBMN)=IDHEP(IBM)
      IF (COL(IDHW(IBM))) THEN
        JMOHEP(2,JDAHEP(2,IBMN))=JMOHEP(2,IBM)
        JDAHEP(2,JMOHEP(2,IBM))=JDAHEP(2,IBMN)
        JDAHEP(2,IBMN)=JDAHEP(2,IBM)
        JMOHEP(2,JDAHEP(2,IBM))=IBMN
      ELSE
        JDAHEP(2,JMOHEP(2,IBMN))=JDAHEP(2,IBM)
        JMOHEP(2,JDAHEP(2,IBM))=JMOHEP(2,IBMN)
        JMOHEP(2,IBMN)=JMOHEP(2,IBM)
        JDAHEP(2,JMOHEP(2,IBM))=IBMN
      ENDIF
      JMOHEP(2,IBM)=0
      JDAHEP(1,IBM)=IBMN
      JDAHEP(2,IBM)=0
      IDHW(ITGN)=IDHW(ITG)
      IDHEP(ITGN)=IDHEP(ITG)
      IF (COL(IDHW(ITG))) THEN
        JMOHEP(2,JDAHEP(2,ITGN))=JMOHEP(2,ITG)
        JDAHEP(2,JMOHEP(2,ITG))=JDAHEP(2,ITGN)
        JDAHEP(2,ITGN)=JDAHEP(2,ITG)
        JMOHEP(2,JDAHEP(2,ITG))=ITGN
      ELSE
        JDAHEP(2,JMOHEP(2,ITGN))=JDAHEP(2,ITG)
        JMOHEP(2,JDAHEP(2,ITG))=JMOHEP(2,ITGN)
        JMOHEP(2,ITGN)=JMOHEP(2,ITG)
        JDAHEP(2,JMOHEP(2,ITG))=ITGN
      ENDIF
      JMOHEP(2,ITG)=0
      JDAHEP(1,ITG)=ITGN
      JDAHEP(2,ITG)=0
C---LOOK FOR COLOUR SINGLET GLUONS (A RARE BUT ANNOYING SPECIAL CASE)
      DO 20 IHEP=1,NHEP
        IF (IDHW(IHEP).EQ.13.AND.JMOHEP(2,IHEP).EQ.IHEP)
     $       CALL HWWARN('HWHSCT',120,*999)
 20   CONTINUE
      REPORT=0
 999  END
CDECK  ID>, HWHSNG. 
*CMZ :-        -20/09/95  14.59.15  by  Mike Seymour
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HWHSNG
C     PARTON-PARTON SCATTERING VIA COLOUR SINGLET
C     MEAN EVWGT = SIGMA IN NB
C     TREATS ALL PARTONS ON EQUAL FOOTING WITH HWHSNM(ID1,ID2,S,T)
C     PROVIDING THE MATRIX ELEMENT SQUARED FOR PARTON TYPES ID1 AND ID2
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      INTEGER ID1,ID2
      DOUBLE PRECISION HWRGEN,HWRUNI,HWHSNM,EPS,RCS,ET,EJ,KK,KK2,
     & YJ1INF,YJ1SUP,Z1,YJ2INF,YJ2SUP,Z2,FACT,S,T,U,HCS
      SAVE HCS
      PARAMETER (EPS=1.D-9)
      IF (GENEV) THEN
        RCS=HCS*HWRGEN(0)
      ELSE
        EVWGT=0.
        CALL HWRPOW(ET,EJ)
        KK=ET/PHEP(5,3)
        KK2=KK**2
        IF (KK.GE.1.) RETURN
        YJ1INF=MAX( YJMIN , LOG((1.-SQRT(1.-KK2))/KK) )
        YJ1SUP=MIN( YJMAX , LOG((1.+SQRT(1.-KK2))/KK) )
        IF (YJ1INF.GE.YJ1SUP) RETURN
        Z1=EXP(HWRUNI(1,YJ1INF,YJ1SUP))
        YJ2INF=MAX( YJMIN , -LOG(2./KK-1./Z1) )
        YJ2SUP=MIN( YJMAX ,  LOG(2./KK-Z1) )
        IF (YJ2INF.GE.YJ2SUP) RETURN
        Z2=EXP(HWRUNI(2,YJ2INF,YJ2SUP))
        XX(1)=0.5*(Z1+Z2)*KK
        IF (XX(1).GE.1.) RETURN
        XX(2)=XX(1)/(Z1*Z2)
        IF (XX(2).GE.1.) RETURN
        COSTH=(Z1-Z2)/(Z1+Z2)
        S=XX(1)*XX(2)*PHEP(5,3)**2
        T=-0.5*S*(1.-COSTH)
        U=-S-T
C---SET EMSCA TO HARD PROCESS SCALE (APPROX ET-JET)
        EMSCA=SQRT(2.*S*T*U/(S*S+T*T+U*U))
        FACT=GEV2NB*0.5*ET*EJ*(YJ1SUP-YJ1INF)*(YJ2SUP-YJ2INF)
     $      /(16*PIFAC*S**2)
        CALL HWSGEN(.FALSE.)
      ENDIF
C
      HCS=0.
      DO 20 ID1=1,13
        IF (DISF(ID1,1).LT.EPS) GOTO 20
        DO 10 ID2=1,13
          IF (DISF(ID2,1).LT.EPS) GOTO 10
          HCS=HCS+FACT*DISF(ID1,1)*DISF(ID2,2)*HWHSNM(ID1,ID2,S,T)
          IF (GENEV.AND.HCS.GT.RCS) CALL HWHQCP(ID1,ID2,3412,90,*30)
 10     CONTINUE
 20   CONTINUE
      EVWGT=HCS
      RETURN
C---GENERATE EVENT
 30   IDN(1)=ID1
      IDN(2)=ID2
      IDCMF=15
      CALL HWETWO
 999  END
CDECK  ID>, HWHSNM. 
*CMZ :-        -20/09/95  15.28.53  by  Mike Seymour
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      FUNCTION HWHSNM(ID1,ID2,S,T)
C     MATRIX ELEMENT SQUARED FOR COLOUR-SINGLET PARTON-PARTON SCATTERING
C     INCLUDES SPIN AND COLOUR AVERAGES AND SUMS.
C     FOR PHOTON EXCHANGE, INTERFERENCE WITH U-CHANNEL CONTRIBUTION IS
C     INCLUDED FOR IDENTICAL QUARKS AND LIKEWISE S-CHANNEL CONTRIBUTION
C     FOR IDENTICAL QUARK-ANTIQUARK PAIRS.
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWHSNM,HWUAEM,HWUALF,S,T,ASQ,AINU,AINS,Y,SOLD,
     $ TOLD,QQ(13,13),ZETA3
      INTEGER ID1,ID2
      LOGICAL PHOTON
C---ZETA3=RIEMANN ZETA FUNCTION(3)
      PARAMETER (ZETA3=1.202056903159594D0)
C---PHOTON=.TRUE. FOR PHOTON EXCHANGE, .FALSE. FOR MUELLER-TANG
      PHOTON=MOD(IPROC,100).GE.50
      DATA ASQ,AINU,AINS,SOLD,TOLD,QQ/5*0,169*-1/
C---QQ CACHES THE KINEMATIC-INDEPENDENT FACTORS, TO MAKE IT RUN FASTER
C  (BEARING IN MIND THAT THIS ROUTINE IS CALLED 169 TIMES PER EVENT)
      IF (QQ(ID1,ID2).LT.0) THEN
        IF (PHOTON) THEN
          IF (ID1.EQ.13.OR.ID2.EQ.13) THEN
            QQ(ID1,ID2)=0
          ELSE
            QQ(ID1,ID2)=(QFCH(MOD(ID1-1,6)+1)*QFCH(MOD(ID2-1,6)+1))**2
     $           *(4*PIFAC)**2
          ENDIF
        ELSE
          IF (ID1.EQ.13.AND.ID2.EQ.13) THEN
            QQ(ID1,ID2)=CAFAC**4
          ELSEIF (ID1.EQ.13.OR.ID2.EQ.13) THEN
            QQ(ID1,ID2)=(CAFAC*CFFAC)**2
          ELSE
            QQ(ID1,ID2)=CFFAC**4
          ENDIF
          QQ(ID1,ID2)=QQ(ID1,ID2)*
     $         PIFAC**3/(4*(3.5*ASFIXD*CAFAC*ZETA3)**3)
     $         *(16*PIFAC)
        ENDIF
      ENDIF
C---THE KINEMATIC-DEPENDENT PART IS ALSO CACHED
      IF (S.NE.SOLD.OR.T.NE.TOLD) THEN
        IF (PHOTON) THEN
          AINS=HWUAEM(T)**2
          ASQ=2*(S**2+(S+T)**2)/T**2*AINS
          AINU=-2*S/T*AINS
          AINS=2*AINS-AINU
        ELSE
          Y=LOG(S/(-T))+ONE
          ASQ=HWUALF(1,EMSCA)**4*(S/T)**2*EXP(2*OMEGA0*Y)/Y**3
          AINU=0
          AINS=0
        ENDIF
      ENDIF
C---THE FINAL ANSWER IS JUST THEIR PRODUCT
      IF (ID1.EQ.ID2) THEN
        HWHSNM=QQ(ID1,ID2)*(ASQ+AINU)
      ELSEIF (ABS(ID1-ID2).EQ.6) THEN
        HWHSNM=QQ(ID1,ID2)*(ASQ+AINS)
      ELSE
        HWHSNM=QQ(ID1,ID2)*ASQ
      ENDIF
      END
CDECK  ID>, HWHV1J.
*CMZ :-        -21/04/96  14.37.45  by  Mike Seymour
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HWHV1J
C-----------------------------------------------------------------------
C   V + 1 JET PRODUCTION, WHERE V=W (IHPRO.LT.5) OR Z (IHPRO.GE.5).
C   USES CROSS-SECTIONS OF EHLQ FOR ANNIHILATION AND COMPTON SCATTERING
C   IHPRO=0 FOR BOTH, 1 FOR ANNIHILATION, AND 2 FOR COMPTON.
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,HWRUNI,DISFAC(2,12,2),EMV2,DISMAX,S,T,U,
     & SHAT,THAT,UHAT,Z,HWUALF,PT,EMT,GFACTR,SIGANN,SIGCOM(2),CSFAC,ET,
     & EJ,YMIN,YMAX,EMAX,CV,CA,BR,EMV,GAMV
      INTEGER HWRINT,IDINIT(2,12,2),ICOFLO(4,2),I,J,K,L,M,ID1,ID2,
     $     IDV,IDI,IDM
      EXTERNAL HWRINT
      SAVE DISFAC,SHAT,THAT,EMV,EMV2,IDV,IDI
C---IDINIT HOLDS THE INITIAL STATES FOR ANNIHILATION PROCESSES
      DATA IDINIT/1,8,2,7,3,10,4,9,5,12,6,11,1,10,2,9,3,8,4,7,5,12,6,11,
     $            1,7,2,8,3,9,4,10,5,11,6,12,1,7,2,8,3,9,4,10,5,11,6,12/
C---ICOFLO HOLDS THE COLOR FLOW FOR EACH PROCESS
C---DISFAC HOLDS THE DISTRIBUTION FUNCTION*CROSS-SECTION FOR EACH
C   POSSIBLE SUB-PROCESS.
C   INDEX1=INITIAL STATE PERMUTATION (1=AS IDINIT/QG;2=OPPOSITE/GQ),
C        2=QUARK (FOR ANNIHILATION, >6 IMPLIES CABIBBO ROTATED PAIR),
C        3=PROCESS (1=ANNIHILATION, 2=COMPTON)
      DATA ICOFLO,DISFAC/2,4,3,1,4,1,3,2,48*0./
      IF (GENEV) THEN
        DISMAX=0
        DO 110 I=1,2
        DO 110 J=1,12
        DO 110 K=1,2
 110      DISMAX=MAX(DISFAC(K,J,I),DISMAX)
 120    I=HWRINT(1,2)
        J=HWRINT(1,12)
        K=HWRINT(1,2)
        IF (HWRGEN(0)*DISMAX.GT.DISFAC(K,J,I)) GOTO 120
        IF (I.EQ.1) THEN
C---ANNIHILATION
          IDN(1)=IDINIT(K,J,IDI)
          IDN(2)=IDINIT(3-K,J,IDI)
          IDN(4)=13
        ELSE
C---COMPTON SCATTERING
          IDN(1)=J
          IDN(2)=13
          IF (IDV.EQ.200) THEN
            IDN(4)=J
          ELSE
            IF (J.EQ.5.OR.J.EQ.6.OR.J.GE.11.OR.HWRGEN(0).GT.SCABI) THEN
C---CHANGE QUARKS (1->2,2->1,3->4,4->3,...)
              IDN(4)=4*INT((J-1)/2)-J+3
            ELSE
C---CHANGE AND CABIBBO ROTATE QUARKS (1->4,2->3,3->2,...)
              IDN(4)=12*INT((J-1)/6)-J+5
            ENDIF
          ENDIF
          IF ((SQRT(EMV2)+RMASS(IDN(4)))**2.GT.SHAT) GOTO 120
          IF (K.EQ.2) THEN
C---SWAP INITIAL STATES
            IDN(3)=IDN(1)
            IDN(1)=IDN(2)
            IDN(2)=IDN(3)
          ENDIF
        ENDIF
        IF (IDV.EQ.200) THEN
          IDN(3)=200
        ELSE
C---W+ OR W-? USE CHARGE CONSERVATION TO WORK OUT
          IDN(3)=NINT(198.5-.1667*FLOAT(ICHRG(IDN(1))+ICHRG(IDN(2))))
        ENDIF
        M=K
        IF (I.EQ.2.AND.J.LE.6) M=3-K
        DO 130 L=1,4
 130      ICO(L)=ICOFLO(L,M)
        IDCMF=15
        COSTH=(SHAT+2*THAT-EMV2)/(SHAT-EMV2)
C---TRICK HWETWO INTO USING THE OFF-SHELL V MASS
        RMASS(IDN(3))=SQRT(EMV2)
        CALL HWETWO
        RMASS(IDN(3))=EMV
        RHOHEP(1,NHEP-1)=0.5
        RHOHEP(2,NHEP-1)=0.0
        RHOHEP(3,NHEP-1)=0.5
      ELSE
        EVWGT=0.
        IHPRO=MOD(IPROC,100)/10
        IF (IHPRO.LT.5) THEN
          IDV=198
          IDI=1
          IDM=10
          GAMV=GAMW
        ELSE
          IDV=200
          IDI=2
          IDM=6
          GAMV=GAMZ
          IHPRO=IHPRO-5
        ENDIF
        EMV=RMASS(IDV)
        EMV2=EMV*(EMV+GAMV*TAN(HWRUNI(0,-ONE-HALF,ONE+HALF)))
        IF (EMV2.LE.0) RETURN
        CALL HWRPOW(ET,EJ)
        PT=0.5*ET
        EMT=SQRT(PT**2+EMV2)
        EMAX=0.5*(PHEP(5,3)+EMV2/PHEP(5,3))
        IF (EMAX.LE.EMT) RETURN
        YMAX=0.5*LOG((EMAX+SQRT(EMAX**2-EMT**2))
     &              /(EMAX-SQRT(EMAX**2-EMT**2)))
        YMIN=MAX(YJMIN,-YMAX)
        YMAX=MIN(YJMAX, YMAX)
        IF (YMAX.LE.YMIN) RETURN
        Z=EXP(HWRUNI(0,YMIN,YMAX))
        S= PHEP(5,3)**2
        T=-PHEP(5,3)*EMT/Z+EMV2
        U=-PHEP(5,3)*EMT*Z+EMV2
        XXMIN=-U/(S+T-EMV2)
        IF (XXMIN.LT.0..OR.XXMIN.GT.1.) RETURN
        XLMIN=LOG(XXMIN)
        XX(1)=EXP(HWRUNI(2,XLMIN,ZERO))
        THAT =XX(1)*T+(1.-XX(1))*EMV2
        XX(2)=-THAT / (XX(1)*S+U-EMV2)
        IF (XX(2).LT.0..OR.XX(2).GT.1.) RETURN
        UHAT =XX(2)*U+(1.-XX(2))*EMV2
        SHAT =XX(1)*XX(2)*S
        EMSCA=EMT
        CALL HWSGEN(.FALSE.)
        GFACTR=GEV2NB*2.*PIFAC*ALPHEM*HWUALF(1,EMSCA)/(9.*SWEIN)
        SIGANN=GFACTR*((THAT-EMV2)**2+(UHAT-EMV2)**2)
     &               /(SHAT**2*THAT*UHAT)
        SIGCOM(1)=.375*GFACTR*(SHAT**2+UHAT**2+2*EMV2*THAT)
     &                       /(-UHAT*SHAT**3)
        SIGCOM(2)=.375*GFACTR*(SHAT**2+THAT**2+2*EMV2*UHAT)
     &                       /(-THAT*SHAT**3)
C---IF USER SPECIFIED A SUB-PROCESS, ZERO THE OTHER
        IF (IHPRO.EQ.1) THEN
          SIGCOM(1)=0.
          SIGCOM(2)=0.
        ENDIF
        IF (IHPRO.EQ.2) SIGANN=0.
        DO 210 I=1,IDM
          IF (IDV.EQ.200) THEN
            J=I
            IF(I.GT.6) J=I-6
            DISFAC(1,I,1)=SWEIN*(VFCH(J,1)**2+AFCH(J,1)**2)
          ELSE
            IF (I.LE.4) THEN
              DISFAC(1,I,1)=1-SCABI
            ELSEIF (I.GE.7) THEN
              DISFAC(1,I,1)=SCABI
            ELSE
              DISFAC(1,I,1)=1.
            ENDIF
          ENDIF
          DISFAC(2,I,1)=DISFAC(1,I,1) *
     &         SIGANN*DISF(IDINIT(1,I,IDI),2)*DISF(IDINIT(2,I,IDI),1)
          DISFAC(1,I,1)=DISFAC(1,I,1) *
     &         SIGANN*DISF(IDINIT(1,I,IDI),1)*DISF(IDINIT(2,I,IDI),2)
 210    CONTINUE
        DO 211 I=IDM+1,12
          DISFAC(1,I,1)=0
          DISFAC(2,I,1)=0
 211    CONTINUE
        DO 220 I=1,12
          IF (IDV.EQ.200) THEN
            J=I
            IF(I.GT.6) J=I-6
            DISFAC(1,I,2)=SWEIN*(VFCH(J,1)**2+AFCH(J,1)**2)
          ELSE
            DISFAC(1,I,2)=1.
          ENDIF
          DISFAC(2,I,2)=DISFAC(1,I,2)*SIGCOM(2)*DISF(I,2)*DISF(13,1)
          DISFAC(1,I,2)=DISFAC(1,I,2)*SIGCOM(1)*DISF(I,1)*DISF(13,2)
 220    CONTINUE
        DO 230 I=1,2
        DO 230 J=1,12
        DO 230 K=1,2
 230      EVWGT=EVWGT+DISFAC(K,J,I)
        CSFAC=-PT*S/(XX(1)*S+U-EMV2)*EJ
     &        *(YMAX-YMIN)*XLMIN*XX(1)
C---INCLUDE BRANCHING RATIO OF V
        CALL HWDBOZ(IDV,ID1,ID2,CV,CA,BR,0)
        EVWGT=EVWGT*CSFAC*BR
      ENDIF
 999  END
CDECK  ID>, HWHWEX.
*CMZ :-        -26/04/91  14.55.45  by  Federico Carminati
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HWHWEX
C-----------------------------------------------------------------------
C     TOP QUARK PRODUCTION VIA W EXCHANGE: MEAN EVWGT=TOP PROD C-S IN NB
C     C-S IS SUM OF:
C     UbarBbar, DBbar, DbarB, UB, CbarBbar, SBbar, SbarB, AND CB
C     UNLESS USER SPECIFIES OTHERWISE BY MOD(IPROC,100)=1-8 RESPECTIVELY
C---DSDCOS HOLDS THE CROSS-SECTIONS FOR THE PROCESSES LISTED ABOVE
C   (1-8) ARE WITH B FROM BEAM 1, (9-16) ARE WITH B FROM BEAM 2.
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,HWRUNI,DSDCOS(16),EMT2,EMT,EMW2,EMW,
     & CMFMIN,TAUMIN,TAUMLN,S,T,U,ROOTS,DSMAX
      INTEGER HWRINT,IDHWEX(2,16),I
      EXTERNAL HWRGEN,HWRUNI,HWRINT
      SAVE DSDCOS,DSMAX
      EQUIVALENCE (EMW,RMASS(198)),(EMT,RMASS(6))
C---IDHWEX HOLDS THE IDs OF THE INCOMING PARTICLES FOR EACH SUB-PROCESS
      DATA IDHWEX/11,8,11,1,5,7,5,2,11,10,11,3,5,9,5,4,
     &            8,11,1,11,7,5,2,5,10,11,3,11,9,5,4,5/
      EMT2=EMT**2
      EMW2=EMW**2
      IF (GENEV) THEN
 300    IHPRO=HWRINT(1,16)
        IF (HWRGEN(0).GT.DSDCOS(IHPRO)/DSMAX) GOTO 300
        DO 10 I=1,2
          IDN(I)=IDHWEX(I,IHPRO)
          IF (IDN(I).EQ.5 .OR. IDN(I).EQ.11) THEN
C---CHANGE B QUARK INTO T QUARK
            IDN(I+2)=IDN(I)+1
          ELSEIF (HWRGEN(0).GT.SCABI) THEN
C---CHANGE QUARKS (1->2,2->1,3->4,4->3,7->8,8->7,...)
            IDN(I+2)=4*INT((IDN(I)-1)/2)-IDN(I)+3
          ELSE
C---CHANGE AND CABIBBO ROTATE QUARKS (1->4,2->3,3->2,4->1,7->10,...)
            IDN(I+2)=12*INT((IDN(I)-1)/6)-IDN(I)+5
          ENDIF
          ICO(I)=I+2
          ICO(I+2)=I
 10     CONTINUE
        IDCMF=15
        CALL HWETWO
      ELSE
        EVWGT=0.
        CMFMIN=EMT
        TAUMIN=(CMFMIN/PHEP(5,3))**2
        TAUMLN=LOG(TAUMIN)
        ROOTS=PHEP(5,3)*SQRT(EXP(HWRUNI(0,ZERO,TAUMLN)))
        XXMIN=(ROOTS/PHEP(5,3))**2
        XLMIN=LOG(XXMIN)
        COSTH=HWRUNI(0,-ONE, ONE)
        S=ROOTS**2
        T=-0.5*S*(1-COSTH)
        U=-0.5*S*(1+COSTH)
        EMSCA=SQRT(2*S*T*U/(S*S+T*T+U*U))
        DSDCOS(1)=GEV2NB*PIFAC*.125*(ALPHEM/SWEIN)**2
     &           *(S-EMT2)**2 / S / (EMW2 + 0.5*(S-EMT2)*(1-COSTH))**2
        DSDCOS(2)=DSDCOS(1) / 4
     &    * (1 + EMT2/S + 2*COSTH + (1-EMT2/S)*COSTH**2)
        DSDCOS(3)=DSDCOS(2)
        DSDCOS(4)=DSDCOS(1)
C---IF USER SPECIFIED SUB-PROCESS THEN ZERO ALL THE OTHERS
        IHPRO=MOD(IPROC,100)
        IF (IHPRO.GT.8) THEN
          CALL HWWARN('HWHWEX',1,*999)
          IHPRO=0
        ENDIF
        DO 100 I=1,8
          IF (I.LE.4) DSDCOS(I+4)=DSDCOS(I)
          IF (IHPRO.NE.0 .AND. IHPRO.NE.I) DSDCOS(I)=0
          DSDCOS(I+8)=DSDCOS(I)
 100    CONTINUE
        CALL HWSGEN(.TRUE.)
        DSMAX=0
        DO 200 I=1,16
          DSDCOS(I)=DSDCOS(I)*DISF(IDHWEX(1,I),1)*DISF(IDHWEX(2,I),2)
          EVWGT=EVWGT + 2*TAUMLN*XLMIN*DSDCOS(I)
          IF (DSDCOS(I).GT.DSMAX) DSMAX=DSDCOS(I)
 200    CONTINUE
      ENDIF
 999  END
CDECK  ID>, HWHWPR.
*CMZ :-        -24/03/92  14.22.13  by  Mike Seymour
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWHWPR
C-----------------------------------------------------------------------
C     W+/- PRODUCTION AND DECAY VIA DRELL-YAN PROCESS
C     MEAN EVWGT IS SIG(W+/-)*(BRANCHING FRACTION) IN NB
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,HWRUNI,HWUPCM,PRAN,PROB,COEF,CSFAC,EMW,
     & FTQK,PTOP,ETOP,EBOT,PMAX,FHAD,FTOT,BRAF,FLEP,TMIN,HWUAEM
      INTEGER HWRINT,ICH,IC,IL,ID,IDEC,JDEC,IWP(2,16)
      LOGICAL HWRLOG
      EXTERNAL HWRGEN,HWRUNI,HWUPCM,HWRINT,HWRLOG
      SAVE CSFAC,IDEC,FLEP,FTQK,ETOP,PTOP,EBOT,PMAX,PROB
      DATA IWP/2,7,1,8,7,2,8,1,4,9,3,10,9,4,10,3,
     &         2,9,3,8,9,2,8,3,4,7,1,10,7,4,10,1/
      IF (GENEV) THEN
C---GENERATE EVENT (X'S AND STRUCTURE FUNCTIONS ALREADY FOUND)
        PRAN=PROB*HWRGEN(0)
C---LOOP OVER PARTON FLAVOURS
        PROB=0.
        COEF=1.-SCABI
        DO 10 IC=1,16
          IF (IC.EQ.9) COEF=SCABI
          PROB=PROB+DISF(IWP(1,IC),1)*DISF(IWP(2,IC),2)*COEF
          IF (PROB.GE.PRAN) GOTO 20
   10   CONTINUE
C---STORE INCOMING PARTONS
   20   IDN(1)=IWP(1,IC)
        IDN(2)=IWP(2,IC)
        ICO(1)=2
        ICO(2)=1
C---ICH=1/2 FOR W+/-
        ICH=2-MOD(IC,2)
        IF ((IDEC.GT.49.AND.IDEC.LT.54).OR.
     &      (IDEC.EQ.99.AND.HWRLOG(FLEP))) THEN
C---LEPTONIC DECAY
          IL=IDEC-50
          IF (IL.EQ.0.OR.IL.GT.3) IL=HWRINT(1,3)
          IDN(3)=2*IL+121-ICH
          IDN(4)=2*IL+124+ICH
C---W DECAY ANGLE (1+COSTH)**2
          COSTH=2.*HWRGEN(1)**0.3333-1.
        ELSEIF (IDEC.EQ.5.OR.IDEC.EQ.6.OR.
     &        ((IDEC.EQ.0.OR.IDEC.EQ.99).AND.HWRLOG(FTQK))) THEN
C---W -> TOP + BOTTOM DECAY
          IDN(3)=7-ICH
          IDN(4)=10+ICH
   21     COSTH=HWRUNI(1,-ONE, ONE)
          IF ((ETOP+(PTOP*COSTH))*(EBOT+(PTOP*COSTH)).LT.
     &         PMAX*HWRGEN(1)) GOTO 21
        ELSE
C---OTHER HADRONIC DECAY
   25     PROB=0.
          PRAN=2.*HWRGEN(2)
          COEF=1.-SCABI
          DO 30 ID=ICH,16,4
            IF (ID.GT.8) COEF=SCABI
            PROB=PROB+COEF
            IF (PROB.GE.PRAN) THEN
              IDN(3)=IWP(1,ID)
              IDN(4)=IWP(2,ID)
              GOTO 40
            ENDIF
   30     CONTINUE
   40     CONTINUE
          IF (IDEC.GT.0.AND.IDEC.LT.5) THEN
            JDEC=IDEC+6
            IF (IDN(3).NE.IDEC.AND.IDN(4).NE.IDEC
     &     .AND.IDN(3).NE.JDEC.AND.IDN(4).NE.JDEC) GOTO 25
          ENDIF
          COSTH=2.*HWRGEN(1)**0.3333-1.
        ENDIF
        IDCMF=197+ICH
        IF (IDN(1).GT.6) COSTH=-COSTH
        ICO(3)=4
        ICO(4)=3
        CALL HWETWO
      ELSE
        IDEC=MOD(IPROC,100)
        IF (IDEC.EQ.5.OR.IDEC.EQ.6) THEN
          TMIN=ATAN((RMASS(6)**2-RMASS(199)**2)/(GAMW*RMASS(199)))
        ELSE
          TMIN=-ATAN(RMASS(199)/GAMW)
        ENDIF
        EVWGT=0.
        EMW=GAMW*TAN(HWRUNI(0,TMIN,PIFAC/2.))+RMASS(199)
        IF (EMW.LE.QSPAC) RETURN
        EMW=SQRT(EMW*RMASS(199))
        IF (EMW.GE.PHEP(5,3)) RETURN
        IF (EMLST.NE.EMW) THEN
          EMLST=EMW
          EMSCA=EMW
          XXMIN=(EMW/PHEP(5,3))**2
          XLMIN=LOG(XXMIN)
          CSFAC=-GEV2NB*PIFAC**2*HWUAEM(EMSCA**2)
     &          /(3.*SWEIN*EMW**2)*XLMIN
C---COMPUTE TOP AND LEPTONIC FRACTIONS
          FTQK=0.
          IF (NFLAV.GT.5) THEN
            PTOP=HWUPCM(EMW,RMASS(5),RMASS(6))
            IF (PTOP.GT.0.) THEN
              ETOP=SQRT(PTOP**2+RMASS(6)**2)
              EBOT=EMW-ETOP
              FTQK=2.*PTOP*(3.*ETOP*EBOT+PTOP**2)/EMW**3
              PMAX=(ETOP+PTOP)*(EBOT+PTOP)
            ENDIF
          ENDIF
          FHAD=FTQK+2.
          FTOT=FTQK+3.
C---MULTIPLY WEIGHT BY BRANCHING FRACTION
          IF (IDEC.EQ.0) THEN
            BRAF=FHAD
          ELSEIF (IDEC.LT.5.OR.IDEC.EQ.50) THEN
            BRAF=1.
          ELSEIF (IDEC.LT.7) THEN
            BRAF=FTQK
          ELSEIF (IDEC.EQ.99) THEN
            BRAF=FTOT
          ELSE
            BRAF=0.3333
          ENDIF
          CSFAC=CSFAC*BRAF/FTOT*(0.5-TMIN/PIFAC)
          FTQK=FTQK/FHAD
          FLEP=1./FTOT
        ENDIF
        CALL HWSGEN(.TRUE.)
C---LOOP OVER PARTON FLAVOURS
        PROB=0.
        COEF=1.-SCABI
        DO 100 IC=1,16
          IF (IC.EQ.9) COEF=SCABI
          PROB=PROB+DISF(IWP(1,IC),1)*DISF(IWP(2,IC),2)*COEF
  100   CONTINUE
        EVWGT=PROB*CSFAC
      ENDIF
  999 END
CDECK  ID>, HWIGIN.
*CMZ :-        -14/07/92  19.49.55  by  Mike Seymour
*-- Author :    Bryan Webber
C----------------------------------------------------------------------
      SUBROUTINE HWIGIN
C-----------------------------------------------------------------------
C     SETS INPUT PARAMETERS
C----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION FAC,ANGLE
      INTEGER I,J,N,L
      CHARACTER*28 TITLE
      DATA TITLE/'HERWIG 5.9    22nd July 1996'/
      WRITE (6,10) TITLE
  10  FORMAT(//10X,A28//,
     &         10X,'Please reference: G. Marchesini, B.R. Webber,',/,
     &         10X,'G.Abbiendi, I.G.Knowles, M.H.Seymour & L.Stanco',/,
     &         10X,'Computer Physics Communications 67 (1992) 465')
C---PRINT OPTIONS:
C
C     IPRINT=0     NO PRINTOUT
C            1     PRINT SELECTED INPUT PARAMETERS
C            2     1 + TABLE OF PARTICLE CODES AND PROPERTIES
C            3     2 + TABLES OF SUDAKOV FORM FACTORS
C----------------------------------------------------------------------
C     PRNDEC=.TRUE.  to use decimal for track numbers in event listing
C            .FALSE. to use hexadecimal
C----------------------------------------------------------------------
      IPRINT=1
      PRNDEC=(NMXHEP.LE.9999)
C Print out vertex information
      PRVTX=.TRUE.
C---UNIT FOR READING SUDAKOV FORM FACTORS (IF ZERO THEN COMPUTE THEM)
      LRSUD=0
C---UNIT FOR WRITING SUDAKOV FORM FACTORS (IF ZERO THEN NOT WRITTEN)
      LWSUD=77
C---UNIT FOR WRITING EVENT DATA IN HWANAL (IF ZERO THEN NOT WRITTEN)
      LWEVT=0
C---SEEDS FOR RANDOM NUMBER GENERATOR (CALLED HWRGEN)
      NRN(1)= 17673
      NRN(2)= 63565
C---AZIMUTHAL CORRELATIONS?
C   THESE INCLUDE SOFT GLUON (INSIDE CONE)
      AZSOFT=.TRUE.
C   AND NEAREST-NEIGHBOUR SPIN CORRELATIONS
      AZSPIN=.TRUE.
C---MATCH HARD EMISSION IN E+E- AND DIS TO MATRIX-ELEMENT
      HARDME=.TRUE.
C---MATCH SOFT EMISSION IN E+E- AND DIS TO MATRIX-ELEMENT
      SOFTME=.TRUE.
C Electromagnetic fine structure constant: Thomson limit
      ALPHEM=.0072993
C---QCD LAMBDA: CORRESPONDS TO 5-FLAVOUR LAMBDA-MS-BAR AT LARGE X ONLY
      QCDLAM=0.18
C---NUMBER OF COLOURS
      NCOLO=3
C---NUMBER OF FLAVOURS
      NFLAV=6
C---QUARK, GLUON AND PHOTON VIRTUAL MASS CUTOFFS IN
C   PARTON SHOWER (ADDED TO MASSES GIVEN BELOW)
      VQCUT=0.48
      VGCUT=0.10
      VPCUT=0.40
      ALPFAC=1
C---D,U,S,C,B,T QUARK AND GLUON MASSES (IN THAT ORDER)
      RMASS(1)=0.32
      RMASS(2)=0.32
      RMASS(3)=0.5
      RMASS(4)=1.55
      RMASS(5)=4.95
      RMASS(6)=170.
      RMASS(13)=0.75
C---W+/- AND Z0 MASSES
      RMASS(198)=80.4
      RMASS(199)=80.4
      RMASS(200)=91.2
C---HIGGS BOSON MASS
      RMASS(201)=150.
C---WIDTHS OF W, Z, HIGGS
      GAMW=2.0
      GAMZ=2.5
      GAMH=0.02
C Include additional neutral, massive vector boson (Z')
      ZPRIME=.FALSE.
C Z' mass and width
      RMASS(202)=500.
      GAMZP=5.
C Lepton (EPOLN) and anti-lepton (PPOLN) beam polarisations used in:
C e+e- --> ffbar/qqbar g; and l/lbar N DIS.
C Cpts. 1,2 Transverse polarisation; cpt. 3 longitudinal polarisation.
C Note require POLN(1)**2+POLN(2)**2+POLN(3)**2 < 1.
      DO 20 I=1,3
      EPOLN(I)=0.
  20  PPOLN(I)=0.
C-----------------------------------------------------------------------
C     Specify couplings of weak vector bosons to fermions:
C
C     electric current:      QFCH(I)*e*G_mu       (electric charge, e>0)
C     weak neutral current: [VFCH(I,J).1+AFCH(I,J).G_5]*e*G_mu
C     weak charged current: SQRT(VCKM(K,L)/2.)*g*(1+G_5)*G_mu
C
C     I= 1- 6: d,u,s,c,b,t (quarks)
C      =11-16: e,nu_e,mu,nu_mu,tau,nu_tau (leptons) (`I=IDHW-110')
C     J=1 for minimal SM:
C      =2 for Z' couplings (ZPRIME=.TRUE.)
C     K=1,2,3 for u,c,t;    L=1,2,3 for d,s,b
C-----------------------------------------------------------------------
C Minimal standard model neutral vector boson couplings
C VFCH(I,1)=(T3/2-Q*S^2_W)/(C_W*S_W);  AFCH(I,1)=T3/(2*C_W*S_W)
C sin**2 Weinberg angle (PDG '94)
      SWEIN=.2319
      FAC=1./SQRT(SWEIN*(1.-SWEIN))
      DO 30 I=1,3
C Down-type quarks
      J=2*I-1
      QFCH(J)=-1./3.
      VFCH(J,1)=(-0.25+SWEIN/3.)*FAC
      AFCH(J,1)= -0.25*FAC
C Up-type quarks
      J=2*I
      QFCH(J)=+2./3.
      VFCH(J,1)=(+0.25-2.*SWEIN/3.)*FAC
      AFCH(J,1)= +0.25*FAC
C Charged leptons
      J=2*I+9
      QFCH(J)=-1.
      VFCH(J,1)=(-0.25+SWEIN)*FAC
      AFCH(J,1)= -0.25*FAC
C Neutrinos
      J=2*I+10
      QFCH(J)=0.
      VFCH(J,1)=+0.25*FAC
      AFCH(J,1)=+0.25*FAC
  30  CONTINUE
C Additional Z' couplings (To be set by the user)
      IF (.NOT.ZPRIME) THEN
         DO 40 I=1,6
         AFCH(I,2)=0.
         AFCH(10+I,2)=0.
         VFCH(I,2)=0.
         VFCH(10+I,2)=0.
  40     CONTINUE
      ENDIF
C Cabibbo-Kobayashi-Maskawa matrix elements squared (PDG '92):
C sin**2 of Cabibbo angle
      SCABI=.0488
C u ---> d,s,b
      VCKM(1,1)=1.-SCABI
      VCKM(1,2)=SCABI
      VCKM(1,3)=0.0
C c ---> d,s,b
      VCKM(2,1)=SCABI
      VCKM(2,2)=1.-SCABI-.002
      VCKM(2,3)=0.002
C t ---> d,b,s
      VCKM(3,1)=0.0
      VCKM(3,2)=0.002
      VCKM(3,3)=0.998
C---GAUGE BOSON DECAYS
      DO 50 I=1,12
      BRHIG(I)=1.D0/12
      ENHANC(I)=1.D0
 50   IF (I.LE.MODMAX) MODBOS(I)=0
C
C THE iTH GAUGE BOSON DECAY PER EVENT IS CONTROLLED BY MODBOS AS FOLLOWS
C         MODBOS(i)     W DECAY        Z DECAY
C             0           all            all
C             1          qqbar          qqbar
C             2           enu            e+e-
C             3           munu          mu+mu-
C             4          taunu         tau+tau-
C             5        enu & munu      ee & mumu
C             6           all            nunu
C             7           all           bbbar
C            >7           all            all
C BOSON PAIRS (eg FROM HIGGS DECAY) ARE CHOSEN FROM MODBOS(i),MODBOS(i+1
C
C---CONTROL OF LARGE EMH BEHAVIOUR (SEE HWHIGM FOR DETAILS)
      IOPHIG=3
      GAMMAX=10.
C Specicify approximation used in HWHIGA
      IAPHIG=1
C---MASSES OF HYPOTHETICAL NEW QUARKS GO
C   INTO 209-214 (ANTIQUARKS IN 215-220)
C   ID = 209,210 ARE B',T' WITH DECAYS T'->B'->C
C        211,212 ARE B',T' WITH DECAYS T'->B'->T
C        215-218 ARE THEIR ANTIQUARKS
      RMASS(209)=200.
      RMASS(215)=200.
C---MAXIMUM CLUSTER MASS PARAMETERS
C   N.B. LIMIT FOR Q1-Q2BAR CLUSTER MASS
C   IS (CLMAX**CLPOW + (QM1+QM2)**CLPOW)**(1/CLPOW)
      CLMAX=3.35
      CLPOW=2.0
C---MASS SPECTRUM OF PRODUCTS IN CLUSTER
C   SPLITTING ABOVE CLMAX - FLAT IN M**PSPLT
      PSPLT=1.0
C---KINEMATIC TREATMENT OF CLUSTER DECAY
C   0=ISOTROPIC, 1=REMEMBER DIRECTION OF PERTURBATIVELY PRODUCED QUARKS
      CLDIR=1
C   IF CLDIR=1, DO GAUSSIAN SMEARING OF DIRECTION:
C   ACTUALLY EXPONENTIAL IN 1-COS(THETA) WITH MEAN CLSMR
      CLSMR=0.0
C---OPTION FOR TREATMENT OF REMNANT CLUSTERS:
C   0=BOTH CHILDREN ARE SOFT, (EQUIVALENT TO PREVIOUS VERSIONS)
C   1=REMNANT CHILD IS SOFT, BUT PERTURBATIVE CHILD IS NORMAL
      IOPREM=1
C---TREATMENT OF LOWER LIMIT FOR SPACELIKE EVOLUTION
C   0=EVOLUTION STOPS AT QSPAC, BUT STRUCT FUNS CAN GET CALLED AT
C   SMALLER SCALES IN FORCED EMISSION (EQUIVALENT TO V5.7 AND EARLIER)
C   1=EVOLUTION STOPS AT QSPAC, STRUCTURE FUNCTIONS FREEZE AT QSPAC
C   2=EVOLUTION CONTINUES TO INFRARED CUT, BUT S.F.S FREEZE AT QSPAC
      ISPAC=0
C---LOWER LIMIT FOR SPACELIKE EVOLUTION
      QSPAC=2.5
C---SWITCH OFF SPACE-LIKE SHOWERS
      NOSPAC=.FALSE.
C---INTRINSIC PT OF SPACELIKE PARTONS (RMS)
      PTRMS=0.0
C---MASS PARAMETER IN REMNANT FRAGMENTATION
      BTCLM=1.0
C---STRUCTURE FUNCTION SET:
C   SET MODPDF(I)=MODE AND AUTPDF='AUTHOR GROUP' TO USE CERN LIBRARY
C   PDFLIB PACKAGE FOR STRUCTURE FUNCTIONS IN BEAM I
      MODPDF(1)=-1
      MODPDF(2)=-1
      AUTPDF(1)='MRS'
      AUTPDF(2)='MRS'
C   OR SET MODPDF(I)=-1 TO USE BUILT-IN STRUCTURE FUNCTION SET:
C   1,2 FOR DUKE+OWENS SETS 1,2 (SOFT/HARD GLUE)
C   3,4 FOR EICHTEN+AL SETS 1,2 (NUCLEONS ONLY)
C    5  FOR OWENS      SET  1.1 (SOFT GLUE ONLY)
      NSTRU=5
C   PARAMETER FOR B CLUSTER DECAY TO 1 HADRON. IF MCL IS CLUSTER MASS
C   AND MTH IS THRESHOLD FOR 2-HADRON DECAY, THEN PROBABILITY IS
C   1 IF MCL<MTH, 0 IF MCL>(1+B1LIM)*MTH, WITH LINEAR INTERPOLATION,
      B1LIM=0.0
C---B DECAY PACKAGE ('HERW'=>HERWIG, 'EURO'=>EURODEC, 'CLEO'=>CLEO)
      BDECAY='HERW'
C---HARD SUBPROCESS SCALE TO BE USED IN BOSON-GLUON FUSION
C   IF (BGSHAT) THEN SCALE=SHAT
C   ELSE SCALE=2.*SHAT*THAT*UHAT/(SHAT**2+THAT**2+UHAT**2)
      BGSHAT=.FALSE.
C---RECONSTRUCT DIS EVENTS IN BREIT FRAME
      BREIT=.TRUE.
C---TREAT ALL EVENTS IN THEIR CMF (ELSE USE LAB FRAME)
      USECMF=.TRUE.
C---PROBABILITY OF UNDERLYING SOFT EVENT:
      PRSOF=1.
C---MULTIPLICITY ENHANCEMENT FOR UNDERLYING SOFT EVENT:
C   NCH = NCH(PPBAR AT ENSOF*SQRT(S))
      ENSOF=1.
C   PARAMETERS FOR MUELLER TANG FORMUA: IPROC=2400
C---THE VALUE TO USE FOR FIXED ALPHA_S IN DENOMINATOR
      ASFIXD=0.25
C---OMEGA0=12*LOG(2)*ALPHA_S/PI, BUT NOT NECESSARILY THE SAME ALPHA_S
      OMEGA0=0.3
C---MIN AND MAX JET RAPIDITIES IN QCD 2->2,
C   HEAVY FLAVOUR AND DIRECT PHOTON PROCESSES
      YJMAX=8.
      YJMIN=-YJMAX
C---MIN AND MAX PARTON TRANSVERSE MOMENTUM
C   IN ELEMENTARY 2 -> 2 SUBPROCESSES
      PTMIN=1D1
      PTMAX=1D8
C---UPPER LIMIT ON HARD PROCESS SCALE
      QLIM=1D8
C---MAX PARTON THRUST IN 2->3 HARD PROCESSES
      THMAX=0.9
C---MIN AND MAX DILEPTON INVARIANT MASS IN DRELL-YAN PROCESS
      EMMIN=0D0
      EMMAX=1D8
C---MIN AND MAX ABS(Q**2) IN DEEP INELASTIC LEPTON SCATTERING
      Q2MIN=0D0
      Q2MAX=1D10
C---MIN AND MAX ABS(Q**2) IN WEISZACKER-WILLIAMS APPROXIMATION
      Q2WWMN=0.
      Q2WWMX=4.
C---MIN AND MAX ENERGY FRACTION IN WEISZACKER-WILLIAMS APPROXIMATION
      YWWMIN=0.
      YWWMAX=1.
C---MINIMUM HADRONIC MASS FOR PHOTON-INDUCED PROCESSES (INCLUDING DIS)
      WHMIN=0.
C---IF PHOMAS IS NON-ZERO, PARTON DISTRIBUTION FUNCTIONS FOR OFF-SHELL
C   PHOTONS IS DAMPED, WITH MASS PARAMETER = PHOMAS
      PHOMAS=0.
C---MIN AND MAX FLAVOURS GENERATED BY IPROC=9100,9110,9130
      IFLMIN=1
      IFLMAX=5
C---MAX Z IN J/PSI PHOTO- AND ELECTRO- PRODUCTION
      ZJMAX=0.9
C---MIN AND MAX BJORKEN-Y
      YBMIN=0.
      YBMAX=1.
C---MAX COS(THETA) FOR W'S IN E+E- -> W+W-
      CTMAX=0.9999
C   Minimum virtuality^2 of partons to use in calculating distances
      VMIN2=1.D-4
C   Exageration factor for lifetimes of weakly decaying heavy particles
      EXAG=1.
C   Include colour rearrangement in cluster formation
      CLRECO=.FALSE.
C   Probability for colour rearrangement to occur
      PRECO=1./9.
C   Minimum lifetime for particle to be considered stable
      PLTCUT=1.D-8
C   Incude neutral B-meson mixing
      MIXING=.TRUE.
C   Set B_s and B_d mixing parameters: X=Delta m/Gamma
      XMIX(1)=10.0
      XMIX(2)=0.70
C   Y=Delta Gamma/2*Gamma
      YMIX(1)=0.2
      YMIX(2)=0.0
C   Include a cut on particle decay lengths
      MAXDKL=.FALSE.
C   Set option for decay length cut (see HWDXLM)
      IOPDKL=1
C   Smear the primary interaction vertex: see HWRIPT for details
      PIPSMR=.TRUE.
      DO 60 I=0,NMXRES
C   Veto cluster decays into particle type I
      VTOCDK(I)=.FALSE.
C   Veto unstable particle decays into modes involving particle type I
  60  VTORDK(I)=.FALSE.
C---MINIMUM AND MAXIMUM S-HAT/S RANGE FOR PHOTON ISR
      TMNISR=1D-4
      ZMXISR=1-1D-6
C---COLISR IS .TRUE. TO MAKE ISR PHOTONS COLLINEAR WITH BEAMS
      COLISR=.FALSE.
C A Priori weights for mesons w.r.t. pionic n=1, 0-(+) states:
C old VECWT=REPWT(0,1,0) & TENWT=REPWT(0,2,0)
      DO 70 N=0,4
      DO 70 J=0,4
      DO 70 L=0,3
  70  REPWT(L,J,N)=1.
C and singlet (Lambda-like) and decuplet barons
      SNGWT=1.
      DECWT=1.
C---A PRIORI WEIGHTS FOR D,U,S,C,B,T QUARKS AND DIQUARKS (IN THAT ORDER)
      PWT(1)=1.
      PWT(2)=1.
      PWT(3)=1.
      PWT(4)=1.
      PWT(5)=1.
      PWT(6)=1.
      PWT(7)=1.
C   Octet-scalar mixing angles in degrees (use ANGLE for ideal mixing)
      ANGLE=ATAN(ONE/SQRT(TWO))*180./ACOS(-ONE)
      ETAMIX=-20.
      PHIMIX=36.
      H1MIX=ANGLE
      F0MIX=ANGLE
      F1MIX=ANGLE
      F2MIX=26.
C---PARAMETERS FOR NON-PERTURBATIVE SPLITTING OF GLUONS INTO
C   DIQUARK-ANTIDIQUARK PAIRS:
C   SCALE AT WHICH GLUONS CAN BE SPLIT INTO DIQUARKS
C   (0.0 FOR NO SPLITTING)
      QDIQK=0.0
C   PROBABILITY (PER UNIT LOG SCALE) OF DIQUARK SPLITTING
      PDIQK=5.0
C---PARAMETERS FOR IMPORTANCE SAMPLING
C   ASSUME QCD 2->2 DSIG/DET FALLS LIKE ET**(-PTPOW)
C   WHERE ET=SQRT(MQ**2+PT**2) FOR HEAVY FLAVOURS
      PTPOW=4.
C   ASSUME DRELL-YAN DSIG/DEM FALLS LIKE EM**(-EMPOW)
      EMPOW=4.
C   ASSUME DEEP INELASTIC DSIG/DQ**2 FALLS LIKE (Q**2)**(-Q2POW)
      Q2POW=2.5
C---GENERATE UNWEIGHTED EVENTS (EVWGT=AVWGT)?
      NOWGT=.TRUE.
C---DEFAULT MEAN EVENT WEIGHT
      AVWGT=1.
C---ASSUMED MAXIMUM WEIGHT (ZERO TO RECOMPUTE)
      WGTMAX=0.
C---MAX NO OF (CODE.GE.100) ERRORS
      MAXER=10
C---MAX NO OF EVENTS TO PRINT
      MAXPR=1
C---TIME (SEC) NEEDED TO TERMINATE GRACEFULLY
      TLOUT=5.
C---CURRENT NO OF EVENTS
      NEVHEP=0
C---CURRENT NO OF ENTRIES IN /HEPEVT/
      NHEP=0
C---ISTAT IS STATUS OF EVENT (I.E. STAGE IN PROCESSING)
      ISTAT=0
C---IERROR IS ERROR CODE
      IERROR=0
C---MORE TECHNICAL PARAMETERS - SHOULDN'T NEED ADJUSTMENT
C---PI
      PIFAC=ACOS(-1.D0)
C Speed of light (mm/s)
      CSPEED=2.99792D11
C Cross-section conversion factor (hbar.c/e)**2
      GEV2NB=389380
C---NUMBER OF SHOTS FOR INITIAL MAX WEIGHT SEARCH
      IBSH=2000
C---RANDOM NO. SEEDS FOR INITIAL MAX WEIGHT SEARCH
      IBRN(1)=1246579
      IBRN(2)=8447766
C---NUMBER OF ENTRIES IN LOOKUP TABLES OF SUDAKOV FORM FACTORS
      NQEV=1024
C---MAXIMUM BIN SIZE IN Z FOR SPACELIKE BRANCHING
      ZBINM=0.05
C---MAXIMUM NUMBER OF Z BINS FOR SPACELIKE BRANCHING
      NZBIN=100
C---MAXIMUM NUMBER OF BRANCH REJECTIONS (TO AVOID INFINITE LOOPS)
      NBTRY=200
C---MAXIMUM NUMBER OF TRIES TO GENERATE CLUSTER DECAY
      NCTRY=200
C---MAXIMUM NUMBER OF TRIES TO GENERATE MASS REQUESTED
      NETRY=50
C---MAXIMUM NUMBER OF TRIES TO GENERATE SOFT SUBPROCESS
      NSTRY=200
C---PRECISION FOR GAUSSIAN INTEGRATION
      ACCUR=1.D-6
C---ORDER OF INTERPOLATION IN SUDAKOV TABLES
      INTER=3
C---ORDER TO USE FOR ALPHAS IN SUDAKOV TABLES
      SUDORD=1
  999 END
CDECK  ID>, HWIODK.
*CMZ :-        -
*-- Author :    Ian Knowles
C-----------------------------------------------------------------------
      SUBROUTINE HWIODK(IUNIT,IOPT,IME)
C-----------------------------------------------------------------------
C     If IUNIT > 0 writes out present HERWIG decay tables to unit IUNIT
C              < 0 reads in decay tables from unit IUNIT
C     The format used during the read/write is specified by IOPT
C     =1 PDG; =2 HERWIG numeric; =3 HERWIG character name.
C     When reading in if IME =1 matrix element codes >= 100 are accepted
C                             0                            are set zero.
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      INTEGER IUNIT,IOPT,IME,JUNIT,I,J,K,L,IDKY,ITMP(5),IDUM
      CHARACTER*8 CDK(NMXDKS),CDKPRD(5,NMXDKS),CDUM
      JUNIT=ABS(IUNIT)
      OPEN(UNIT=JUNIT,FORM='FORMATTED',STATUS='UNKNOWN')
      IF (IUNIT.GT.0) THEN
C Write out the decay table
        WRITE(JUNIT,100) NDKYS
        IF (IOPT.EQ.1) THEN
          DO 20 I=1,NRES
          IF (NMODES(I).EQ.0) GOTO 20
          K=LSTRT(I)
          DO 10 J=1,NMODES(I)
          WRITE(JUNIT,110) IDPDG(I),BRFRAC(K),NME(K),
     &                    (IDPDG(IDKPRD(L,K)),L=1,5)
  10      K=LNEXT(K)
  20      CONTINUE
        ELSEIF (IOPT.EQ.2) THEN
          DO 40 I=1,NRES
          IF (NMODES(I).EQ.0) GOTO 40
          K=LSTRT(I)
          DO 30 J=1,NMODES(I)
          WRITE(JUNIT,120) I,BRFRAC(K),NME(K),(IDKPRD(L,K),L=1,5)
  30      K=LNEXT(K)
  40      CONTINUE
        ELSEIF (IOPT.EQ.3) THEN
          DO 60 I=1,NRES
          IF (NMODES(I).EQ.0) GOTO 60
          K=LSTRT(I)
          DO 50 J=1,NMODES(I)
          WRITE(JUNIT,130) RNAME(I),BRFRAC(K),NME(K),
     &                    (RNAME(IDKPRD(L,K)),L=1,5)
  50      K=LNEXT(K)
  60      CONTINUE
        ENDIF
      ELSEIF (IUNIT.LT.0) THEN
C Read in the decay table and convert to HERWIG numeric format
        READ(JUNIT,100) NDKYS
        IF (NDKYS.GT.NMXDKS) CALL HWWARN('HWIODK',100,*999)
        IF (IOPT.EQ.1) THEN
          DO 70 I=1,NDKYS
          READ(JUNIT,110) IDKY,BRFRAC(I),NME(I),ITMP
          IF (IME.EQ.0.AND.NME(I).GE.100) NME(I)=0
          CALL HWUIDT(1,IDKY,IDK(I),CDUM)
          DO 70 J=1,5
  70      CALL HWUIDT(1,ITMP(J),IDKPRD(J,I),CDUM)
        ELSEIF (IOPT.EQ.2) THEN
          DO 80 I=1,NDKYS
          READ(JUNIT,120) IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5)
          IF (IDK(I).LT.0.OR.IDK(I).GT.NRES) IDK(I)=20
  80      IF (IME.EQ.0.AND.NME(I).GE.100) NME(I)=0
        ELSEIF (IOPT.EQ.3) THEN
          DO 90 I=1,NDKYS
          READ(JUNIT,130) CDK(I),BRFRAC(I),NME(I),(CDKPRD(J,I),J=1,5)
          IF (IME.EQ.0.AND.NME(I).GE.100) NME(I)=0
          CALL HWUIDT(3,IDUM,IDK(I),CDK(I))
          DO 90 J=1,5
  90      CALL HWUIDT(3,IDUM,IDKPRD(J,I),CDKPRD(J,I))
        ELSE
          CALL HWWARN('HWIODK',101,*999)
        ENDIF
      ENDIF
      CLOSE(UNIT=JUNIT)
  100 FORMAT(1X,I4)
  110 FORMAT(1X,I7,1X,F7.5,1X,I3,5(1X,I7))
  120 FORMAT(1X,I3,1X,F7.5,6(1X,I3))
  130 FORMAT(1X,A8,1X,F7.5,1X,I3,5(1X,A8))
  999 RETURN
      END
CDECK  ID>, HWMEVT.
*CMZ :-        -26/04/91  14.28.59  by  Federico Carminati
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWMEVT
C-----------------------------------------------------------------------
C     IPROC = 1000,... ADDS SOFT UNDERLYING EVENT
C           = 8000:  CREATES MINIMUM-BIAS EVENT
C     SUPPRESSED BY ADDING 10000 TO IPROC
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWREXP,ENFAC,TECM,SECM,SUMM,EMCL,BMP(5),BMR(3,3)
      INTEGER HWRINT,NETC,IBT,IDBT,ID1,ID2,ID3,KHEP,LHEP,NTRY,ICMS,
     & NPPBAR,NCL,MCHT,JCL,JD1,JD2,JD3,ICH,MODC,NCHT,INHEP(2),
     & INID(2,2),JBT
      EXTERNAL HWREXP,HWRINT
      IF (IERROR.NE.0) RETURN
      IF (.NOT.GENSOF) GOTO 990
      IF (IPROC.EQ.8000) THEN
C---SET UP BEAM AND TARGET CLUSTERS
    5   NETC=0
        DO 10 IBT=1,2
        JBT=IBT
        IF (JDAHEP(1,IBT).NE.0) JBT=JDAHEP(1,IBT)
        IDBT=IDHW(JBT)
        IF (IDBT.EQ.73.OR.IDBT.EQ.75) THEN
          INID(1,IBT)=HWRINT(1,2)
          INID(2,IBT)=110
        ELSEIF (IDBT.EQ.91.OR.IDBT.EQ.93) THEN
          INID(1,IBT)=116
          INID(2,IBT)=HWRINT(7,8)
        ELSEIF (IDBT.EQ.30) THEN
          INID(1,IBT)=HWRINT(1,2)
          INID(2,IBT)=8
        ELSEIF (IDBT.EQ.38) THEN
          INID(1,IBT)=2
          INID(2,IBT)=HWRINT(7,8)
        ELSEIF (IDBT.EQ.34) THEN
          INID(1,IBT)=3
          INID(2,IBT)=HWRINT(7,8)
        ELSEIF (IDBT.EQ.46) THEN
          INID(1,IBT)=HWRINT(1,2)
          INID(2,IBT)=9
        ELSEIF (IDBT.EQ.59) THEN
          INID(1,IBT)=HWRINT(1,2)
          INID(2,IBT)=HWRINT(7,8)
        ELSE
          CALL HWWARN('HWMEVT',100,*999)
        ENDIF
        NETC=NETC+ICHRG(IDBT)
     &    -(ICHRG(INID(1,IBT))+ICHRG(INID(2,IBT)))/3
        ENFAC=1.
        IDHW(NHEP+IBT)=19
        IDHEP(NHEP+IBT)=91
        ISTHEP(NHEP+IBT)=163+IBT
        JMOHEP(1,NHEP+IBT)=JBT
   10   CONTINUE
        IF (NETC.EQ.0) THEN
          ID3=HWRINT(1,2)
        ELSEIF (NETC.EQ.-1) THEN
          ID3=1
        ELSEIF (NETC.EQ.1) THEN
          ID3=2
        ELSE
          GOTO 5
        ENDIF
        DO 12 IBT=1,2
        NHEP=NHEP+1
        JBT=IBT
        IF (JDAHEP(1,IBT).NE.0) JBT=JDAHEP(1,IBT)
        CALL HWVEQU(5,PHEP(1,JBT),PHEP(1,NHEP))
   12   INHEP(IBT)=NHEP
      ELSE
C---FIND BEAM AND TARGET CLUSTERS
        DO 20 IBT=1,2
        DO 15 KHEP=1,NHEP
        IF (ISTHEP(KHEP).EQ.163+IBT) THEN
          INHEP(IBT)=KHEP
          INID(1,IBT)=IDHW(JMOHEP(1,KHEP))
          INID(2,IBT)=IDHW(JMOHEP(2,KHEP))
          GOTO 20
        ENDIF
   15   CONTINUE
C---COULDN'T FIND ONE
        INHEP(IBT)=0
   20   CONTINUE
        JCL=-1
C---TEST FOR BOTH FOUND
        IF (INHEP(1).EQ.0) JCL=INHEP(2)
        IF (INHEP(2).EQ.0) JCL=INHEP(1)
        IF (JCL.EQ.0) CALL HWWARN('HWMEVT',101,*999)
        IF (JCL.GT.0) THEN
          ISTHEP(JCL)=163
          CALL HWCFOR
          CALL HWCDEC
          CALL HWDHAD
          GOTO 90
        ENDIF
        ID3=HWRINT(1,2)
        ENFAC=ENSOF
        NETC=0
      ENDIF
C---FIND SOFT CM MOMENTUM AND MULTIPLICITY
      NTRY=0
      NHEP=NHEP+1
      IF (NHEP.GT.NMXHEP) CALL HWWARN('HWMEVT',102,*999)
      ICMS=NHEP
      IDHW(NHEP)=16
      IDHEP(NHEP)=0
      ISTHEP(NHEP)=170
      CALL HWVSUM(4,PHEP(1,INHEP(1)),PHEP(1,INHEP(2)),PHEP(1,NHEP))
      CALL HWUMAS(PHEP(1,NHEP))
      TECM=PHEP(5,NHEP)
      IF (IPROC/1000.EQ.9.OR.IPROC/1000.EQ.5) THEN
        SECM=TECM*ENFAC
      ELSE
        SECM=PHEP(5,3)*ENFAC
      ENDIF
C---CHOOSE MULTIPLICITY
   25 CALL HWMULT(SECM,NPPBAR)
   30 NCL=0
      MCHT=0
      IERROR=0
      NHEP =ICMS
      SUMM=0.
      NTRY=NTRY+1
C---CREATE CLUSTERS
   35 NCL=NCL+1
      NHEP=NHEP+1
      IF (NHEP.GT.NMXHEP) CALL HWWARN('HWMEVT',103,*999)
      JCL=NHEP
      IDHW(JCL)=19
      IDHEP(JCL)=91
      IF (NCL.LT.3) THEN
        ISTHEP(JCL)=170+NCL
        ID1=INID(1,NCL)
        ID2=INID(2,NCL)
      ELSE
        ID1=ID2-6
        IF (NCL.EQ.3) ID1=ID3
        ID2=HWRINT(7,8)
        ISTHEP(JCL)=173
      ENDIF
      JMOHEP(1,JCL)=ICMS
      JMOHEP(2,JCL)=0
      CALL HWVZRO(3,PHEP(1,JCL))
      PHEP(4,JCL)=RMASS(ID1)+RMASS(ID2)+0.4+HWREXP( ONE)
      PHEP(5,JCL)=PHEP(4,JCL)
C---HADRONIZE AND DECAY CLUSTERS
      CALL HWCFLA(ID1,ID2,JD1,JD2)
      CALL HWCHAD(JCL,JD1,JD2,JD3)
      IF (IERROR.NE.0) RETURN
      IF (JD3.EQ.0) THEN
        EMCL=RMASS(IDHW(NHEP))
        IF (PHEP(4,JCL).NE.EMCL) THEN
          PHEP(4,JCL)=EMCL
          PHEP(5,JCL)=EMCL
          PHEP(4,NHEP)=EMCL
          PHEP(5,NHEP)=EMCL
        ENDIF
      ELSE
        EMCL=PHEP(5,JCL)
      ENDIF
      IDPAR(NCL)=JD3
      PPAR(5,NCL)=EMCL
      SUMM=SUMM +EMCL
      CALL HWDHAD
      IF (IERROR.NE.0) RETURN
C---CHECK CHARGED MULTIPLICITY
      MODC=0
      DO 50 KHEP=JCL,NHEP
      IF (ISTHEP(KHEP).EQ.1) THEN
         ICH=ICHRG(IDHW(KHEP))
         IF (ICH.NE.0) THEN
            MCHT=MCHT+ABS(ICH)
            MODC=MODC+ICH
         ENDIF
      ENDIF
   50 CONTINUE
      IF (NCL.EQ.1) THEN
         NCHT=NPPBAR+NETC+ABS(MODC)
         GOTO 35
      ELSEIF (NCL.EQ.2) THEN
         NCHT=NCHT+ABS(MODC)
         IF (NCHT.LT.0) NCHT=NCHT+2
      ENDIF
      IF (MCHT.LT.NCHT) THEN
        GOTO 35
      ELSEIF (MCHT.GT.NCHT) THEN
        IF (MOD(NTRY,50).EQ.0) GOTO 25
        IF (NTRY.LT.NSTRY) GOTO 30
C---NO PHASE SPACE FOR SOFT EVENT
        NHEP=ICMS-1
        IF (IPROC.EQ.8000) THEN
C---MINIMUM BIAS: RELABEL BEAM AND TARGET CLUSTERS
          DO 60 IBT=1,2
            KHEP=INHEP(IBT)
            LHEP=JMOHEP(1,KHEP)
            ISTHEP(KHEP)=1
            IDHEP(KHEP)=IDHEP(LHEP)
            IDHW(KHEP)=IDHW(LHEP)
   60     CONTINUE
        ELSE
C---UNDERLYING EVENT: DECAY THEM
          ISTHEP(INHEP(1))=163
          ISTHEP(INHEP(2))=163
          CALL HWCFOR
          CALL HWCDEC
          CALL HWDHAD
        ENDIF
        GOTO 90
      ENDIF
C---GENERATE CLUSTER MOMENTA IN CLUSTER CM
C   FRAME.   N.B. SECOND CLUSTER IS TARGET
      IF (SUMM.GT.TECM) GOTO 25
      CALL HWMLPS(NCL,TECM)
      IF (NCL.EQ.0) GOTO 25
      JCL=0
C---ROTATE & BOOST CLUSTERS & DECAY PRODUCTS
      CALL HWULOF(PHEP(1,ICMS),PHEP(1,INHEP(1)),BMP)
      CALL HWUROT(BMP, ONE,ZERO,BMR)
C---BMR PUTS BEAM ALONG Z AXIS (WE WANT INVERSE)
      DO 70 KHEP=ICMS+1,NHEP
      IF (ISTHEP(KHEP).GT.180.AND.ISTHEP(KHEP).LT.190) THEN
          ISTHEP(KHEP)=ISTHEP(KHEP)+3
          LHEP=KHEP
          JCL=JCL+1
          CALL HWUROB(BMR,PPAR(1,JCL),PPAR(1,JCL))
          CALL HWULOB(PHEP(1,ICMS),PPAR(1,JCL),PPAR(1,JCL))
C---NOW PPAR(*,JCL) IS LAB MOMENTUM OF JTH CLUSTER
      ENDIF
      CALL HWULOB(PPAR(1,JCL),PHEP(1,KHEP),PHEP(1,KHEP))
   70 CONTINUE
      ISTHEP(INHEP(1))=167
      ISTHEP(INHEP(2))=168
      JMOHEP(1,ICMS)=INHEP(1)
      JMOHEP(2,ICMS)=INHEP(2)
      JDAHEP(1,INHEP(1))=ICMS
      JDAHEP(2,INHEP(1))=0
      JDAHEP(1,INHEP(2))=ICMS
      JDAHEP(2,INHEP(2))=0
      JDAHEP(1,ICMS)=ICMS+1
      JDAHEP(2,ICMS)=LHEP
   90 CONTINUE
C---DO SOFT HEAVY FLAVOUR DECAYS (IF ANY)
      CALL HWDHVY
  990 ISTAT=100
  999 END
CDECK  ID>, HWMLPS.
*CMZ :-        -26/04/91  14.17.04  by  Federico Carminati
*-- Author :    David Ward, modified by Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWMLPS(NCL,TECM)
C-----------------------------------------------------------------------
C     GENERATES CYLINDRICAL PHASE SPACE USING THE METHOD OF JADACH
C     RETURNS NCL=0 IF UNSUCCESSFUL
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWREXT,HWRUNG,HWUSQR,TECM,ESS,ALOGS,EPS,SUMX,
     & SUMY,PT,PX,PY,PT2,SUMPT2,SUMTM,XIMIN,XIMAX,YY,SUM1,SUM2,SUM3,
     & SUM4,EX,FY,DD,DYY,ZZ,E1,TM,SLOP(11),XI(NMXPAR)
      INTEGER NTRY,NCL,I,NIT,IY(NMXPAR)
      EXTERNAL HWREXT,HWRUNG,HWUSQR
      EQUIVALENCE (XI,VPAR),(IY,ISTPAR)
C---Factors for pt slopes to fit data.  IDBR contains the type of
C   q-qbar pair produced in this cluster (0 if 1-particle cluster).
C   Corresponding slopes here:
      DATA SLOP/5.2,5.2,5.2,3.0,5.2,5.2,5.2,5.2,5.2,5.2,3.0/
C                -   d   u   s   uu  ud  dd  us  ds  ss  c
      IF (NCL.GT.NMXPAR) THEN
        CALL HWWARN('HWMLPS',1,*999)
        NCL=NMXPAR
      ENDIF
      ESS=TECM**2
      ALOGS=LOG(ESS)
      EPS=1.E-5/NCL
      NTRY=0
  11  NTRY=NTRY+1
      IF (NTRY.GT.NSTRY) THEN
        NCL=0
        RETURN
      ENDIF
      SUMX=0.
      SUMY=0.
      DO 12 I=1,NCL
C---Pt distribution of form exp(-b*Mt)
      PT=HWREXT(PPAR(5,I),SLOP(IDPAR(I)+1))
      PT=HWUSQR(PT**2-PPAR(5,I)**2)
      CALL HWRAZM(PT,PX,PY)
      PPAR(1,I)=PX
      PPAR(2,I)=PY
      SUMX=SUMX+PPAR(1,I)
  12  SUMY=SUMY+PPAR(2,I)
      SUMX=SUMX/NCL
      SUMY=SUMY/NCL
      SUMPT2=0.
      SUMTM=0.
      DO 13 I=1,NCL
      PPAR(1,I)=PPAR(1,I)-SUMX
      PPAR(2,I)=PPAR(2,I)-SUMY
      PT2=PPAR(1,I)**2+PPAR(2,I)**2
      SUMPT2=SUMPT2+PT2
C---STORE TRANSVERSE MASS IN PPAR(3,I) TEMPORARILY
      PPAR(3,I)=SQRT(PT2+PPAR(5,I)**2)
  13  SUMTM=SUMTM+PPAR(3,I)
      IF (SUMTM.GT.TECM) GOTO 11
      DO 14 I=1,NCL
C---Form of "reduced rapidity" distribution
      XI(I)=HWRUNG(0.6*ONE,ONE)
  14  CONTINUE
      CALL HWUSOR(XI,NCL,IY,1)
      XIMIN=XI(1)
      XIMAX=XI(NCL)-XI(1)
C---N.B. TARGET CLUSTER IS SECOND
      XI(1)=0.
      DO 16 I=NCL-1,2,-1
      XI(I+1)=(XI(I)-XIMIN)/XIMAX
  16  CONTINUE
      XI(2)=1.
      YY=LOG(ESS/(PPAR(3,1)*PPAR(3,2)))
      DO 18 NIT=1,10
      SUM1=0.
      SUM2=0.
      SUM3=0.
      SUM4=0.
      DO 19 I=1,NCL
      TM=PPAR(3,I)
      EX=EXP(YY*XI(I))
      SUM1=SUM1+(TM*EX)
      SUM2=SUM2+(TM/EX)
      SUM3=SUM3+(TM*EX)*XI(I)
  19  SUM4=SUM4+(TM/EX)*XI(I)
      FY=ALOGS-LOG(SUM1*SUM2)
      DD=(SUM3*SUM2-SUM1*SUM4)/(SUM1*SUM2)
      DYY=FY/DD
      IF(ABS(DYY/YY).LT.EPS) GOTO 20
  18  YY=YY+DYY
C---Y ITERATIONS EXCEEDED - TRY AGAIN
      IF (NTRY.LT.10) GOTO 11
      EPS=10.*EPS
      IF (EPS.GT.1.) CALL HWWARN('HWMLPS',100,*999)
      CALL HWWARN('HWMLPS',50,*11)
   20 YY=YY+DYY
      ZZ=LOG(TECM/SUM1)
      DO 22 I=1,NCL
      TM=PPAR(3,I)
      E1=EXP(ZZ+YY*XI(I))
      PPAR(3,I)=(0.5*TM)*((1./E1)-E1)
      PPAR(4,I)=(0.5*TM)*((1./E1)+E1)
  22  CONTINUE
 999  END
CDECK  ID>, HWMNBI.
*CMZ :-        -26/04/91  11.11.55  by  Bryan Webber
*-- Author :    David Ward, modified by Bryan Webber
C-----------------------------------------------------------------------
      FUNCTION HWMNBI(N,AVNCH,EK)
C-----------------------------------------------------------------------
C---Computes negative binomial probability
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWMNBI,AVNCH,EK,R
      INTEGER N,I
      IF(N.LE.0) THEN
       HWMNBI=0
      ELSE
       R=AVNCH/EK
       HWMNBI=(1.+R)**(-EK)
       R=R/(1.+R)
       DO 1 I=1,N
       HWMNBI=HWMNBI*R*(EK+I-1)/I
    1  CONTINUE
      ENDIF
      END
CDECK  ID>, HWMODK.
*CMZ :-        -
*-- Author :    Ian Knowles
C-----------------------------------------------------------------------
      SUBROUTINE HWMODK(IDKTMP,BRTMP,IMETMP,
     & IATMP,IBTMP,ICTMP,IDTMP,IETMP)
C-----------------------------------------------------------------------
C     Takes the decay, IDKTMP -> I-(A+B+C+D+E)-TMP, and simply stores it
C     if internal pointers not set up (.NOT.DKPSET) else if pre-existing
C     mode updates branching ratio BRTMP and matrix element code IMETMP,
C     if -ve leaves as is. If a new mode adds to table and if consistent
C     adjusts pointers,  sets CMMOM (for two-body mode) and resets RSTAB
C     if necessary.  The branching ratios of any other IDKTMP decays are
C     scaled by (1.-BRTMP)/(1.-BR_OLD)
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWUPCM,BRTMP,SCALE,EPS
      INTEGER IDKTMP,IMETMP,IATMP,IBTMP,ICTMP,IDTMP,IETMP,IDKY,ITMP(5),
     & L,I,J,K,JPREV
      LOGICAL MATCH(5)
      CHARACTER*8 CDUM
      EXTERNAL HWUPCM
      PARAMETER (EPS=1.D-6)
C Convert to internal format
      CALL HWUIDT(1,IDKTMP,IDKY,CDUM)
      IF (IDKY.EQ.20) THEN
        WRITE(6,10) IDKTMP
  10    FORMAT(1X,'Particle decaying,',I7,', is not recognised')
        RETURN
      ENDIF
      CALL HWUIDT(1,IATMP,ITMP(1),CDUM)
      CALL HWUIDT(1,IBTMP,ITMP(2),CDUM)
      CALL HWUIDT(1,ICTMP,ITMP(3),CDUM)
      CALL HWUIDT(1,IDTMP,ITMP(4),CDUM)
      CALL HWUIDT(1,IETMP,ITMP(5),CDUM)
C If internal pointers not yet set up simply store decay
      IF (.NOT.DKPSET) THEN
        NDKYS=NDKYS+1
        IF (NDKYS.GT.NMXDKS) CALL HWWARN('HWMODK',100,*999)
        IDK(NDKYS)=IDKY
        BRFRAC(NDKYS)=BRTMP
        NME(NDKYS)=IMETMP
        DO 20 I=1,5
  20    IDKPRD(I,NDKYS)=ITMP(I)
      ELSE
        IF (NMODES(IDKY).GT.0) THEN
C First search to see if mode pre-exists
          IF ((ITMP(2).GE.1.AND.ITMP(2).LE.13).OR.
     &        (ITMP(3).GE.1.AND.ITMP(3).LE.13)) THEN
C Partonic respect order
            L=LSTRT(IDKY)
            DO 30 K=1,NMODES(IDKY)
                IF (ITMP(1).EQ.IDKPRD(1,L).AND.
     &              ITMP(2).EQ.IDKPRD(2,L).AND.
     &              ITMP(3).EQ.IDKPRD(3,L).AND.
     &              ITMP(4).EQ.IDKPRD(4,L).AND.
     &              ITMP(5).EQ.IDKPRD(5,L)) GOTO 90
  30        L=LNEXT(L)
          ELSE
C Allow for different order in matching
            L=LSTRT(IDKY)
            DO 70 I=1,NMODES(IDKY)
            DO 40 J=1,5
  40        MATCH(J)=.FALSE.
            DO 60 J=1,5
            DO 50 K=1,5
            IF (.NOT.MATCH(K).AND.ITMP(K).EQ.IDKPRD(J,L)) THEN
              MATCH(K)=.TRUE.
              GOTO 60
            ENDIF
  50        CONTINUE
  60        CONTINUE
            IF (MATCH(1).AND.MATCH(2).AND.MATCH(3).AND.
     &          MATCH(4).AND.MATCH(5)) GOTO 90
  70        L=LNEXT(L)
          ENDIF
        ENDIF
C A new mode put decay products in table
        NDKYS=NDKYS+1
        IF (NDKYS.GT.NMXDKS) CALL HWWARN('HWMODK',100,*999)
        DO 80 I=1,5
  80    IDKPRD(I,NDKYS)=ITMP(I)
C If decay consistent set up new pointers
        CALL HWDCHK(IDKY,NDKYS,*980)
        IF (NMODES(IDKY).EQ.0) THEN
          LSTRT(IDKY)=NDKYS
          IF (RLTIM(IDKY).LT.PLTCUT.AND.RMASS(IDKY).NE.0.) THEN
            RSTAB(IDKY)=.FALSE.
            DKLTM(IDKY)=RLTIM(IDKY)*RMASS(IDKY)/HBAR
          ELSE
            RSTAB(IDKY)=.TRUE.
          ENDIF
        ELSE
          LNEXT(L)=NDKYS
        ENDIF
        NMODES(IDKY)=NMODES(IDKY)+1
        LNEXT(NDKYS)=NDKYS
        L=NDKYS
C Set CMMOM if two body decay
        IF (NPRODS(L).EQ.2) CMMOM(L)=
     &   HWUPCM(RMASS(IDKY),RMASS(IDKPRD(1,L)),RMASS(IDKPRD(2,L)))
C A Pre-existing mode, line L, add/update ME code and BR, scaling all
C other branching fractions
  90    IF (IMETMP.GT.0) NME(L)=IMETMP
        IF (ABS(BRTMP-1.).LT.EPS) THEN
C This modes dominant: eliminate others
          NMODES(IDKY)=1
          LSTRT(IDKY)=L
          BRFRAC(L)=1.D0
          LNEXT(L)=L
        ELSEIF (ABS(BRTMP).LT.EPS) THEN
C This mode to be eliminated
          IF (NMODES(IDKY).EQ.1) THEN
            RSTAB(IDKY)=.TRUE.
          ELSE
            J=LSTRT(IDKY)
            IF (J.EQ.L) THEN
              LSTRT(IDKY)=LNEXT(J)
            ELSE
              JPREV=J
              DO 100 I=2,NMODES(IDKY)
              J=LNEXT(J)
              IF (J.EQ.L) LNEXT(JPREV)=LNEXT(J)
  100         JPREV=(J)
            ENDIF
          ENDIF
          NMODES(IDKY)=NMODES(IDKY)-1
        ELSE
C Rescale all other modes
          BRFRAC(L)=BRTMP
          IF (L.EQ.NDKYS) THEN
            SCALE=ONE-BRTMP
          ELSEIF (NMODES(IDKY).EQ.1) THEN
            BRFRAC(L)=ONE
          ELSE
            SCALE=(ONE-BRTMP)/(ONE-BRFRAC(L))
          ENDIF
          J=LSTRT(IDKY)
          DO 110 I=1,NMODES(IDKY)
          IF (J.NE.L) BRFRAC(J)=SCALE*BRFRAC(J)
  110     J=LNEXT(J)
        ENDIF
      ENDIF
      GOTO 999
  980 WRITE(6,990)
  990 FORMAT(1X,'Decay mode inconsistent, no modifications made')
  999 RETURN
      END
CDECK  ID>, HWMULT.
*CMZ :-        -26/04/91  11.11.55  by  Bryan Webber
*-- Author :    David Ward, modified by Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWMULT(EPPBAR,NCHT)
C-----------------------------------------------------------------------
C     Chooses charged multiplicity NCHT at the p-pbar c.m. energy EPPBAR
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWMNBI,HWRGEN,EPPBAR,E0,ALOGS,RK,EK,AVN,SUM,R,
     & CUM(100)
      INTEGER NCHT,IMAX,I,N
      EXTERNAL HWMNBI,HWRGEN
      DATA E0/0./
      IF (EPPBAR.NE.E0) THEN
         E0=EPPBAR
C---Initialize
         ALOGS=2.*LOG(EPPBAR)
         RK=.029*ALOGS-.104
         IF (ABS(RK).GT.1000.) RK=1000.
         EK=1./RK
         AVN=-9.50+9.11*EPPBAR**0.23
         IF (AVN.LT.1.) AVN=1.
         SUM=0.
         IMAX=1
         DO 10 I=1,100
         N=2*I
         CUM(I)=HWMNBI(N,AVN,EK)
         IF (CUM(I).LT.1.E-6*SUM) GOTO 11
         IMAX=I
         SUM=SUM+CUM(I)
         CUM(I)=SUM
  10     CONTINUE
  11     CONTINUE
         IF (IMAX.LE.1) THEN
            IMAX=1
            CUM(1)=1
         ELSE
            DO 12 I=1,IMAX
  12        CUM(I)=CUM(I)/SUM
         ENDIF
      ENDIF
C --- Select NCHT
      R=HWRGEN(0)
      DO 20 I=1,IMAX
      IF(R.GT.CUM(I)) GOTO 20
      NCHT=2*I
      RETURN
  20  CONTINUE
      CALL HWWARN('HWMULT',100,*999)
  999 END
CDECK  ID>, HWMWGT.
*CMZ :-        -02/11/93  11.11.55  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWMWGT
C-----------------------------------------------------------------------
C COMPUTES WEIGHT FOR MINIMUM-BIAS EVENT
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION S,X,Y
      INTEGER IDB,IDT,IDBT
      IF (IERROR.NE.0) RETURN
      IDB=IDHW(1)
      IF (JDAHEP(1,1).NE.0) IDB=IDHW(JDAHEP(1,1))
      IDT=IDHW(2)
      IF (JDAHEP(1,2).NE.0) IDT=IDHW(JDAHEP(1,2))
      IDBT=100*IDB+IDT
      IF (IDT.GT.IDB) IDBT=100*IDT+IDB
C---USE TOTAL CROSS SECTION FITS OF DONNACHIE & LANDSHOFF
C   CERN-TH.6635/92
      IF (IDBT.EQ.9173) THEN
        X=21.70
        Y=98.39
      ELSEIF (IDBT.EQ.7373) THEN
        X=21.70
        Y=56.08
      ELSEIF (IDBT.EQ.7330) THEN
        X=13.63
        Y=36.02
      ELSEIF (IDBT.EQ.7338) THEN
        X=13.63
        Y=27.56
      ELSEIF (IDBT.EQ.7334) THEN
        X=11.82
        Y=26.36
      ELSEIF (IDBT.EQ.7346) THEN
        X=11.82
        Y= 8.15
      ELSEIF (IDBT.EQ.7359) THEN
        X=.0677
        Y=.1290
      ELSEIF (IDBT.EQ.9175) THEN
        X=21.70
        Y=92.71
      ELSEIF (IDBT.EQ.7573) THEN
        X=21.70
        Y=54.77
      ELSEIF (IDBT.EQ.5959) THEN
C---FOR GAMMA-GAMMA ASSUME X AND Y FACTORIZE
        X=2.1E-4
        Y=3.0E-4
      ELSE
        PRINT *,' IDBT=',IDBT
        CALL HWWARN('HWMWGT',100,*999)
      ENDIF
      S=PHEP(5,3)**2
C---EVWGT IS NON-DIFFRACTIVE CROSS SECTION IN NANOBARNS
C   ASSUMING NON-DIFFRACTIVE = TOTAL*0.7
      EVWGT=.7E6*(X*S**.0808 + Y*S**(-.4525))
  999 END
CDECK  ID>, HWRAZM.
*CMZ :-        -26/04/91  11.11.55  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWRAZM(PT,PX,PY)
C-----------------------------------------------------------------------
C     RANDOMLY ROTATED 2-VECTOR (PX,PY) OF LENGTH PT
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWRGEN,PT,PX,PY,C,S,CS,QT
      EXTERNAL HWRGEN
   10 C=2.*HWRGEN(1)-1.
      S=2.*HWRGEN(2)-1.
      CS=C*C+S*S
      IF (CS.GT.1. .OR. CS.EQ.0) GOTO 10
      QT=PT/CS
      PX=(C*C-S*S)*QT
      PY=2.*C*S*QT
      END
CDECK  ID>, HWREXP.
*CMZ :-        -26/04/91  11.11.55  by  Bryan Webber
*-- Author :    David Ward, modified by Bryan Webber
C-----------------------------------------------------------------------
      FUNCTION HWREXP(AV)
C-----------------------------------------------------------------------
C     Random number from dN/d(x**2)=exp(-b*x) with mean AV
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWREXP,HWRGEN,AV,B,R1,R2
      EXTERNAL HWRGEN
      B=2./AV
      R1=HWRGEN(0)
      R2=HWRGEN(1)
      HWREXP=-LOG(R1*R2)/B
      END
CDECK  ID>, HWREXQ.
*CMZ :-        -02/06/94  11.02.47  by  Mike Seymour
*-- Author :    David Ward, modified by Bryan Webber and Mike Seymour
C-----------------------------------------------------------------------
      FUNCTION HWREXQ(AV,XMAX)
C-----------------------------------------------------------------------
C     Random number from dN/d(x**2)=EXQ(-b*x) with mean AV,
C     But truncated at XMAX
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWREXQ,HWRGEN,AV,B,BXMAX,R1,R2,XMAX,R,RMIN
      EXTERNAL HWRGEN
      B=2./AV
      BXMAX=B*XMAX
      IF (BXMAX.LT.50) THEN
        RMIN=EXP(-BXMAX)
      ELSE
        RMIN=0
      ENDIF
 10   R1=HWRGEN(0)*(1-RMIN)+RMIN
      R2=HWRGEN(1)*(1-RMIN)+RMIN
      R=R1*R2
      IF (R.LT.RMIN) GOTO 10
      HWREXQ=-LOG(R)/B
      END
CDECK  ID>, HWREXT.
*CMZ :-        -26/04/91  11.11.55  by  Bryan Webber
*-- Author :    David Ward, modified by Bryan Webber
C-----------------------------------------------------------------------
      FUNCTION HWREXT(AM0,B)
C-----------------------------------------------------------------------
C     Random number from dN/d(x**2)=exp(-B*TM) distribution, where
C     TM = SQRT(X**2+AM0**2).  Uses Newton's method to solve F-R=0
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWREXT,HWRGEN,AM0,B,R,A,F,DF,DAM,AM
      INTEGER NIT
      EXTERNAL HWRGEN
      R=HWRGEN(0)
C --- Starting value
      AM=AM0-LOG(R)/B
      DO 1 NIT=1,20
      A=EXP(-B*(AM-AM0))/(1.+B*AM0)
      F=(1.+B*AM)*A-R
      DF=-B**2*AM*A
      DAM=-F/DF
      AM=AM+DAM
      IF(AM.LT.AM0) AM=AM0+.001
      IF(ABS(DAM).LT..001) GOTO 2
   1  CONTINUE
      CALL HWWARN('HWREXT',1,*2)
   2  HWREXT=AM
      END
CDECK  ID>, HWRGAU.
*CMZ :-        -16/10/93  11.11.56  by  Mike Seymour
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      FUNCTION HWRGAU(J,A,B)
C-----------------------------------------------------------------------
C     Gaussian random number, mean A, standard deviation B.
C     Generates uncorrelated pairs and caches one of them.
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWRGAU,HWRGEN,A,B,X,CACHE,EMPTY
      INTEGER J
      EXTERNAL HWRGEN
      DATA CACHE,EMPTY/2*1D20/
      IF (CACHE.EQ.EMPTY) THEN
 10     X=HWRGEN(J)
        IF (X.LE.0.OR.X.GT.1) GOTO 10
        X=SQRT(-2*LOG(X))
        CALL HWRAZM(X,X,CACHE)
        HWRGAU=A+B*X
      ELSE
        HWRGAU=A+B*CACHE
        CACHE=EMPTY
      ENDIF
      END
CDECK  ID>, HWRGEN.
*CMZ :-        -26/04/91  12.42.30  by  Federico Carminati
*-- Author :    F. James, modified by Mike Seymour
C-----------------------------------------------------------------------
      FUNCTION HWRGEN(I)
C-----------------------------------------------------------------------
C     MAIN RANDOM NUMBER GENERATOR
C AST    To be used with ALEPH interface to RANMAR
C-----------------------------------------------------------------------
      IMPLICIT NONE
      DOUBLE PRECISION HWRGEN,HWRSET,HWRGET
      REAL*4 RNDM
      INTEGER I,I1,I2,I3,JSEED(2),ISEED(3)
      HWRGEN=RNDM(I)
      RETURN
      ENTRY HWRSET(JSEED)
      I1=JSEED(1)
      I2=JSEED(2)
      I3=0
      CALL RMARIN(I1,I2,I3)
      RETURN
      ENTRY HWRGET(JSEED)
      CALL RMARUT(I1,I2,I3)
      JSEED(1)=I1
      JSEED(2)=I2
      RETURN
      END
CDECK  ID>, HWRINT.
*CMZ :-        -26/04/91  11.11.56  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      FUNCTION HWRINT(IMIN,IMAX)
C-----------------------------------------------------------------------
C     RANDOM INTEGER IN [IMIN,IMAX]. N.B. ASSUMES IMAX.GE.IMIN
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWRGEN,RN
      INTEGER HWRINT,IMIN,IMAX
      EXTERNAL HWRGEN
    1 RN=HWRGEN(0)
      IF (RN.EQ.1.) GOTO 1
      RN=RN*(IMAX-IMIN+1)
      HWRINT=IMIN+INT(RN)
      END
CDECK  ID>, HWRLOG.
*CMZ :-        -26/04/91  14.15.56  by  Federico Carminati
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      FUNCTION HWRLOG(A)
C-----------------------------------------------------------------------
C     Returns .TRUE. with probability A
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWRGEN,A,R
      LOGICAL HWRLOG
      EXTERNAL HWRGEN
      HWRLOG=.TRUE.
      R=HWRGEN(0)
      IF(R.GT.A) HWRLOG=.FALSE.
      END
CDECK  ID>, HWRPIP.
*CMZ :-        -
*-- Author :    Ian Knowles
C-----------------------------------------------------------------------
      SUBROUTINE HWRPIP
C-----------------------------------------------------------------------
C     Generates a random primary IP using a triple Gaussian distribution
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGAU,VIP(3),VIPWID(3)
      INTEGER I
      EXTERNAL HWRGAU
      DATA VIP,VIPWID/3*0.0,.25,.015,1.8/
      DO 10 I=1,3
  10  VTXPIP(I)=HWRGAU(I,VIP(I),VIPWID(I))
      VTXPIP(4)=0.
      END
CDECK  ID>, HWRPOW.
*CMZ :-        -26/04/91  11.11.56  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWRPOW(XVAL,XJAC)
C-----------------------------------------------------------------------
C     RETURNS XVAL DISTRIBUTED ON (XMIN,XMAX) LIKE XVAL**XPOW
C     AND CORRESPONDING JACOBIAN FACTOR XJAC
C     SET FIRST=.TRUE. IF NEW XMIN,XMAX OR XPOW
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWRGEN,XVAL,XJAC,XMIN,XMAX,XPOW,P,Q,A,B,C,Z
      LOGICAL FIRST
      EXTERNAL HWRGEN
      SAVE Q,A,B,C
      COMMON/HWRPIN/XMIN,XMAX,XPOW,FIRST
      IF (FIRST) THEN
        P=XPOW+1.
        IF (P.EQ.0.) CALL HWWARN('HWRPOW',500,*999)
        Q=1./P
        A=XMIN**P
        B=XMAX**P-A
        C=B*Q
        FIRST=.FALSE.
      ENDIF
      Z=A+B*HWRGEN(0)
      XVAL=Z**Q
      XJAC=XVAL*C/Z
  999 END
CDECK  ID>, HWRUNG.
*CMZ :-        -26/04/91  14.55.45  by  Federico Carminati
*-- Author :    David Ward, modified by Bryan Webber
C-----------------------------------------------------------------------
      FUNCTION HWRUNG(A,B)
C-----------------------------------------------------------------------
C     Random number from distribution having flat top [-A,A] & gaussian
C     tail of s.d. B
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWRUNG,HWRGAU,HWRUNI,A,B,PRUN,ZERO
      LOGICAL HWRLOG
      EXTERNAL HWRGAU,HWRUNI,HWRLOG
      PARAMETER (ZERO=0.D0)
      IF (A.EQ.0) THEN
        PRUN=0
      ELSE
        PRUN=1./(1.+B*1.2533/A)
      ENDIF
      IF(HWRLOG(PRUN)) THEN
        HWRUNG=HWRUNI(0,-A,A)
      ELSE
        HWRUNG=HWRGAU(0,ZERO,B)
        HWRUNG=HWRUNG+SIGN(A,HWRUNG)
      ENDIF
      END
CDECK  ID>, HWRUNI.
*CMZ :-        -26/04/91  14.55.45  by  Federico Carminati
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      FUNCTION HWRUNI(I,A,B)
C-----------------------------------------------------------------------
C     Uniform random random number in range [A,B]
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWRUNI,HWRGEN,A,B,RN
      INTEGER I
      EXTERNAL HWRGEN
      RN=HWRGEN(I)
      HWRUNI=A+RN*(B-A)
      END
CDECK  ID>, HWSBRN.
*CMZ :-        -15/07/92  14.08.45  by  Mike Seymour
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWSBRN(KPAR)
C-----------------------------------------------------------------------
C     DOES BRANCHING OF SPACELIKE PARTON KPAR
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWBVMC,HWRGEN,HWRUNI,HWSTAB,HWUALF,HWUTAB,HWSGQQ,
     & HWSSUD,XLAST,QNOW,QLST,QP,QMIN,QLAM,QSAV,SMAX,SLST,SNOW,RN,SUDA,
     & SUDB,ZZ,ENOW,XI,PMOM,DIST(13),DMIN,X1,X2,REJFAC,OTHXI,OTHZ,QTMP,
     & PTMP(2)
      INTEGER N0,IS,ID,ID1,ID2,IDHAD,N1,I,MQ,NTRY,NDEL,NA,NB,IW1,IW2,
     & KPAR,LPAR,MPAR,ISUD(13),IREJ,NREJ
      LOGICAL HWSVAL,FORCE,VALPAR,FTMP
      EXTERNAL HWBVMC,HWRGEN,HWRUNI,HWSTAB,HWUALF,HWUTAB,HWSGQQ,HWSSUD,
     & HWSVAL
      COMMON/HWTABC/XLAST,N0,IS,ID
      DATA ISUD,DMIN/2,2,3,4,5,6,2,2,3,4,5,6,1,1.D-15/
      IF (IERROR.NE.0) RETURN
      ID=IDPAR(KPAR)
C--TEST FOR PARTON TYPE
      IF (ID.LE.13) THEN
        IS=ISUD(ID)
      ELSEIF (ID.GE.208) THEN
        IS=7
      ELSE
        IS=0
      END IF
      QNOW=-1.
      IF (IS.NE.0) THEN
C--SPACELIKE PARTON BRANCHING
        QLST=PPAR(1,KPAR)
        IDHAD=IDHW(INHAD)
        VALPAR=HWSVAL(ID)
        QP=HWBVMC(ID)
        XLAST=XFACT*PPAR(4,KPAR)
        IF (XLAST.GE.1.) CALL HWWARN('HWSBRN',107,*999)
C--SET UP Q BOUNDARY
        IF (VALPAR) THEN
          QMIN=QG/(1.-XLAST)
        ELSEIF (ID.EQ.13) THEN
          QMIN=QV/(1.-XLAST)
        ELSE
          QMIN=.5*(QP+QV+SQRT((QP-QV)**2+4.*QP*QV*XLAST))/(1.-XLAST)
        ENDIF
        QSAV=QMIN
        IF (QMIN.LE.QSPAC.AND.ISPAC.LT.2) THEN
          QMIN=QSPAC
          N1=NSPAC(IS)
        ELSEIF (QMIN.LE.QEV(1,IS)) THEN
          QMIN=QEV(1,IS)
          N1=1
        ELSE
          DO 110 I=2,NQEV
          IF (QEV(I,IS).GT.QMIN) GOTO 120
  110     CONTINUE
  120     N1=I-1
        ENDIF
        N0=N1-1
        MQ=NQEV-N0
        NTRY=0
  125   NTRY=NTRY+1
        NREJ=1
        IF (QLST.GT.QMIN.AND..NOT.NOSPAC.OR..NOT.VALPAR) THEN
          IF (QLST.LE.QMIN) THEN
C--CHECK PHASE SPACE FOR FORCED SPLITTING OF NON-VALENCE PARTON
            IF (QLST.LT.QSAV) CALL HWWARN('HWSBRN',ISLENT*105,*999)
            FORCE=.TRUE.
            QNOW=(QLST/QSAV)**HWRGEN(0)*QSAV
          ELSE
C--ENHANCE EMISSION BY A FACTOR OF TWO IF THIS BRANCH
C  IS CAPABLE OF BEING THE HARDEST SO FAR
           IF (QLST.GT.HARDST) NREJ=2
           QTMP=-1
           DO 300 IREJ=1,NREJ
C--FIND NEW VALUE OF SUD/DIST
            CALL HWSFUN(XLAST,QMIN,IDHAD,NSTRU,DIST,JNHAD)
            IF (ID.EQ.13) DIST(ID)=DIST(ID)*HWSGQQ(QMIN)
            IF (DIST(ID).LT.DMIN) DIST(ID)=DMIN
            SMAX=HWUTAB(SUD(N1,IS),QEV(N1,IS),MQ,QMIN,INTER)/DIST(ID)
            CALL HWSFUN(XLAST,QLST,IDHAD,NSTRU,DIST,JNHAD)
            IF (ID.EQ.13) DIST(ID)=DIST(ID)*HWSGQQ(QLST)
            IF (DIST(ID).LT.DMIN) DIST(ID)=DMIN
            SLST=HWUTAB(SUD(N1,IS),QEV(N1,IS),MQ,QLST,INTER)/DIST(ID)
            RN=HWRGEN(0)
            IF (RN.EQ.0.) THEN
              SNOW=SLST*2.
            ELSE
              SNOW=SLST/RN
            ENDIF
            IF (VALPAR.AND.SNOW.GE.SMAX) GOTO 200
            IF (SNOW.LT.SMAX.AND..NOT.NOSPAC) THEN
              FORCE=.FALSE.
            ELSE
C--FORCE SPLITTING OF NON-VALENCE PARTON
              FORCE=.TRUE.
              QNOW=(MIN(QLST,1.1*QMIN)/QSAV)**HWRGEN(0)*QSAV
            ENDIF
            IF (QNOW.LT.0.) THEN
C--BRANCHING OCCURS. FIRST CHECK FOR MONOTONIC FORM FACTOR
              SUDA=SMAX
              NDEL=32
              NA=N1
  130         NB=NA+NDEL
              IF (NB.GT.NQEV) CALL HWWARN('HWSBRN',103,*999)
              CALL HWSFUN(XLAST,QEV(NB,IS),IDHAD,NSTRU,DIST,JNHAD)
              IF (ID.EQ.13) DIST(ID)=DIST(ID)*HWSGQQ(QEV(NB,IS))
              IF (DIST(ID).LT.DMIN) DIST(ID)=DMIN
              SUDB=SUD(NB,IS)/DIST(ID)
              IF (SUDB.GT.SUDA) THEN
                SUDA=SUDB
                NA=NB
                GOTO 130
              ELSEIF (NA.NE.N1) THEN
                IF (SUDB.LT.SNOW) THEN
                  NDEL=NDEL/2
                  IF (NDEL.EQ.0) CALL HWWARN('HWSBRN',100,*999)
                  GOTO 130
                ENDIF
                N1=NB
                N0=N1-1
                MQ=NQEV-N0
              ENDIF
C--NOW FIND NEW Q
              QNOW=HWSTAB(QEV(N1,IS),HWSSUD,MQ,SNOW,INTER)
              IF (QNOW.LE.QMIN.OR.QNOW.GT.QLST) THEN
C--INTERPOLATION PROBLEM: USE LINEAR INSTEAD
C                CALL HWWARN('HWSBRN',1,*999)
                QNOW=HWRUNI(0,QMIN,QLST)
              ENDIF
            ENDIF
 200        CONTINUE
            IF (QNOW.GT.QTMP) THEN
              QTMP=QNOW
              FTMP=FORCE
            ENDIF
            QNOW=-1
 300       CONTINUE
           QNOW=QTMP
           FORCE=FTMP
          ENDIF
          IF (QNOW.LT.0) GOTO 210
C--NOW FIND NEW X
          CALL HWSFBR(XLAST,QNOW,FORCE,ID,1,ID1,ID2,IW1,IW2,ZZ)
          IF (ID1.LT.0) THEN
C--NO PHASE SPACE FOR BRANCHING
            CALL HWWARN('HWSBRN',ISLENT*101,*999)
          ELSEIF (ID1.EQ.0) THEN
C--BRANCHING REJECTED: REDUCE Q AND REPEAT
            IF (NTRY.GT.NBTRY.OR.IERROR.NE.0)
     $           CALL HWWARN('HWSBRN',102,*999)
            QLST=QNOW
            QNOW=-1.
            GOTO 125
          ELSEIF (ID1.EQ.59) THEN
C--ANOMALOUS PHOTON SPLITTING: ADD PT TO INTRINSIC PT AND STOP BRANCHING
            IF (IDHAD.NE.59) CALL HWWARN('HWSBRN',109,*999)
            ENOW=PPAR(4,KPAR)/XLAST
            XI=(QNOW/ENOW)**2
            QLAM=QNOW*(1.-XLAST)
            IF ((2.-XI)*QLAM**2.GT.EMSCA**2) THEN
C--BRANCHING REJECTED: REDUCE Q AND REPEAT
              IF (NTRY.GT.NBTRY) CALL HWWARN('HWSBRN',110,*999)
              QLST=QNOW
              QNOW=-1.
              GOTO 125
            ENDIF
            CALL HWRAZM(QNOW*(1.-XLAST),PTMP(1),PTMP(2))
            CALL HWVSUM(2,PTMP,PTINT(1,JNHAD),PTINT(1,JNHAD))
            PTINT(3,JNHAD)=PTINT(1,JNHAD)**2+PTINT(2,JNHAD)**2
            ANOMSC(1,JNHAD)=QNOW
            ANOMSC(2,JNHAD)=QNOW*(1.-XLAST)
            QNOW=-1.
            QLST=QNOW
            GOTO 125
          ELSEIF (FORCE.AND..NOT.HWSVAL(ID1).AND.ID1.NE.13) THEN
C--FORCED BRANCHING PRODUCED A NON-VALENCE PARTON: TRY AGAIN
            IF (NTRY.GT.NBTRY) CALL HWWARN('HWSBRN',108,*999)
            QLST=QNOW
            QNOW=-1.
            GOTO 125
          ENDIF
        ENDIF
  210   CONTINUE
        IF (QNOW.GT.0.) THEN
C--BRANCHING HAS OCCURRED
          ENOW=PPAR(4,KPAR)/ZZ
          XI=(QNOW/ENOW)**2
          QLAM=QNOW*(1.-ZZ)
          IF (SUDORD.EQ.1.AND.HWUALF(2,QLAM).LT.HWRGEN(0) .OR.
     &        (2.-XI)*QLAM**2.GT.EMSCA**2.AND..NOT.FORCE) THEN
C--BRANCHING REJECTED: REDUCE Q AND REPEAT
              IF (NTRY.GT.NBTRY) CALL HWWARN('HWSBRN',104,*999)
              QLST=QNOW
              QNOW=-1.
              GOTO 125
          ENDIF
C--IF THIS IS HARDEST EMISSION SO FAR, APPLY MATRIX-ELEMENT CORRECTION
          IF (.NOT.FORCE) THEN
            REJFAC=1
            IF (QLAM.GT.HARDST) THEN
              IF (MOD(ISTHEP(JCOPAR(1,1)),10).GE.3) THEN
C---COLOUR PARTNER IS OUTGOING (X1=XP, X2=ZP)
                X2=SQRT((ZZ**2-(1-ZZ)*XI)**2+2*(ZZ*(1-ZZ))**2*XI*(2-XI))
                X1=(ZZ**2+(1-ZZ)*XI-X2)/(2*(1-ZZ)*XI)
                X2=(ZZ**2-(1-ZZ)*XI+X2)/(2*ZZ**2)
                IF (ID2.EQ.13) THEN
C---GLUON EMISSION
                  REJFAC=ZZ**3*(1-X1-X2+2*X1*X2)
     $                 /(X1**2*(1-ZZ)*(ZZ+XI*(1-ZZ)))
     $                 *(1+ZZ**2)/((1-ZZ)*XI)
     $                 *(1-X1)*(1-X2)/
     $                 (1+(1-X1-X2+2*X1*X2)**2+2*(1-X1)*(1-X2)*X1*X2)
C---CHECK WHETHER IT IS IN THE OVERLAP REGION
                  OTHXI=2*(1-X1)/(1-X1+2*(3*X1-2)*X2*(1-X2))
                  IF (OTHXI.LT.1) THEN
                    OTHZ=(1-(2*X2-1)*SQRT((3*X1-2)/X1))/2
                    REJFAC=REJFAC+SQRT(3-2/X1)/(X1**2*OTHZ*(1-OTHZ))
     $               *(1+(1-OTHZ)**2)/(OTHZ*OTHXI)
     $               *(1-X1)*(1-X2)/
     $               (1+(1-X1-X2+2*X1*X2)**2+2*(1-X1)*(1-X2)*X1*X2)
                  ENDIF
                ELSEIF (ID1.EQ.13) THEN
C---GLUON SPLITTING
                  REJFAC=ZZ**3*(1-X1-X2+2*X1*X2)
     $                 /(X1**2*(1-ZZ)*(ZZ+XI*(1-ZZ)))
     $                 *(ZZ**2+(1-ZZ)**2)/XI
     $                 *(1-X2)/
     $                 ((  X1+X2-2*X1*X2)**2+2*(1-X1)*(1-X2)*X1*X2
     $                 +(1-X1-X2+2*X1*X2)**2+2*(1-X1)*(1-X2)*X1*X2)
                ENDIF
              ELSE
C---COLOUR PARTNER IS ALSO INCOMING (NOT IMPLEMENTED YET)
                REJFAC=1
              ENDIF
            ENDIF
            IF (NREJ*REJFAC*HWRGEN(NREJ).GT.1) THEN
              QLST=QNOW
              QNOW=-1.
              GOTO 125
            ENDIF
            IF (QLAM.GT.HARDST) HARDST=QLAM
          ENDIF
          IF (IW2.GT.IW1) THEN
            LPAR=NPAR+1
            MPAR=NPAR+2
C---NEW MOTHER-DAUGHTER RELATIONS
C   N.B. DEFINED MOVING AWAY FROM HARD PROCESS
            JDAPAR(1,KPAR)=LPAR
            JDAPAR(2,KPAR)=MPAR
C---NEW COLOUR CONNECTIONS
            JCOPAR(3,KPAR)=MPAR
            JCOPAR(4,KPAR)=LPAR
            JCOPAR(1,MPAR)=KPAR
            JCOPAR(2,MPAR)=LPAR
            JCOPAR(1,LPAR)=MPAR
            JCOPAR(2,LPAR)=KPAR
          ELSE
            MPAR=NPAR+1
            LPAR=NPAR+2
            JDAPAR(1,KPAR)=MPAR
            JDAPAR(2,KPAR)=LPAR
            JCOPAR(3,KPAR)=LPAR
            JCOPAR(4,KPAR)=MPAR
            JCOPAR(1,MPAR)=LPAR
            JCOPAR(2,MPAR)=KPAR
            JCOPAR(1,LPAR)=KPAR
            JCOPAR(2,LPAR)=MPAR
          ENDIF
          JMOPAR(1,LPAR)=KPAR
          JMOPAR(1,MPAR)=KPAR
          IDPAR(LPAR)=ID1
          IDPAR(MPAR)=ID2
          TMPAR(LPAR)=.FALSE.
          TMPAR(MPAR)=.TRUE.
          PPAR(1,LPAR)=QNOW
          PPAR(2,LPAR)=XI
          PPAR(4,LPAR)=ENOW
          PPAR(1,MPAR)=QNOW*(1.-ZZ)
          PPAR(2,MPAR)=XI
          PPAR(4,MPAR)=ENOW*(1.-ZZ)
          NPAR=NPAR+2
        ENDIF
      ENDIF
      IF (QNOW.LT.0.) THEN
C--BRANCHING STOPS
        JDAPAR(1,KPAR)=0
        JDAPAR(2,KPAR)=0
        JCOPAR(3,KPAR)=0
        JCOPAR(4,KPAR)=0
        IF (ID.LE.13) THEN
          IF (IDHEP(INHAD).EQ.22) THEN
C---PUT SPECTATOR QUARK IN PHOTON ON-SHELL
            XLAST=XFACT*PPAR(4,KPAR)
            IF ((1-XLAST)**2.LT.(RMASS(ID)**2+PTINT(3,JNHAD))*XFACT**2)
     &           THEN
              FROST=.TRUE.
              RETURN
            ENDIF
            PPAR(5,KPAR)=-(RMASS(ID)**2*XLAST+PTINT(3,JNHAD))/(1.-XLAST)
     &           +XLAST*SIGN(PHEP(5,INHAD)**2,PHEP(5,INHAD))
          ELSE
            PPAR(5,KPAR)=-RMASS(ID)**2-PTINT(3,JNHAD)
            IF (PPAR(5,KPAR).LT.-QSPAC**2) PPAR(5,KPAR)=-QSPAC**2
          ENDIF
        ELSEIF (ID.EQ.IDHW(INHAD)) THEN
C---IF INCOMING PARTON IS INCOMING BEAM, ALLOW IT TO BE OFF-SHELL
          PPAR(5,KPAR)=SIGN(PHEP(5,INHAD)**2,PHEP(5,INHAD))
        ELSE
          PPAR(5,KPAR)=RMASS(ID)**2
        ENDIF
        PMOM=PPAR(4,KPAR)**2-PPAR(5,KPAR)
        IF (PMOM.LT.0.) THEN
          FROST=.TRUE.
          RETURN
        ENDIF
        PPAR(3,KPAR)=SQRT(PMOM)
      ENDIF
  999 END
CDECK  ID>, HWSDGG.
*CMZ :=        =26/04/91  12.47.48  by  Federico Carminati
*-- Author :    Drees, Grassie, Charchula, modified by Bryan Webber
C ===============================================================
C  DREES & GRASSIE PARAMETRIZATION OF PHOTON STRUCTURE FUNCTION
C
C    HWSDGQ(X,Q2,NFL,NCH) - X*QUARK_IN_PHOTON/ALPHA  (!)
C    HWSDGG(X,Q2,NFL)     - X*GLUON_IN_PHOTON/ALPHA  (!)
C WHERE:
C        (INTEGER) NCH - QUARK CHARGE: 1 FOR 1/3
C                                      2 FOR 2/3
C        (INTEGER) NFL - NUMBER OF QUARK FLAVOURS /3 OR 4/
C                   Q2 - SQUARE OF MOMENTUM Q /IN GEV2/
C                   X  - LONGITUDINAL FRACTION
C  LAMBDA=0.4 GEV
C
C       NFL=3:     1 < Q2 < 50   GEV^2
C       NFL=4:    20 < Q2 < 500  GEV^2
C       NFL=5:   200 < Q2 < 10^4 GEV^2
C
C
C  KRZYSZTOF CHARCHULA  /14.02.1989/
C================================================================
C
C PS. Note that for the case of three flavors, one has to add
C the QPM charm contribution for getting F2.
C
C================================================================
C MODIFIED FOR HERWIG BY BRW 19/4/91
C--- -----------------------------------------------
C        GLUON PART OF THE PHOTON SF
C--- -----------------------------------------------
      FUNCTION HWSDGG(X,Q2,NFL)
      IMPLICIT REAL (A-H,P-Z)
      INTEGER NFL
      DIMENSION A(3,4,3),AT(3)
      ALAM2=0.160
      T=LOG(Q2/ALAM2)
C- ---  CHECK WHETHER NFL  HAVE RIGHT VALUES -----
      IF (.NOT.((NFL.EQ.3).OR.(NFL.EQ.4).OR.(NFL.EQ.5)))THEN
 130   WRITE(6,131)
 131   FORMAT(' NUMBER OF FLAVOURS(NFL) HAS NOT BEEN SET TO: 3,4 OR 5;'/
     *'          NFL=3 IS ASSUMED')
       NFL=3
      ELSEIF (T.LE.0) THEN
       WRITE(6,132)
 132   FORMAT(' HWSDGG CALLED WITH SCALE < LAMBDA. RETURNING ZERO.')
       HWSDGG=0
       RETURN
      ENDIF
C ------ INITIALIZATION OF PARAMETERS ARRAY -----
      DATA(((A(I,J,K),I=1,3),J=1,4),K=1,3)/
     + -0.20700,-0.19870, 5.11900,
     +  0.61580, 0.62570,-0.27520,
     +  1.07400, 8.35200,-6.99300,
     +  0.00000, 5.02400, 2.29800,
     +    0.8926E-2, 0.05090,-0.23130,
     +    0.659400, 0.27740, 0.13820,
     +    0.476600,-0.39060, 6.54200,
     +    0.019750,-0.32120, 0.51620,
     +  0.031970, -0.618E-2, -0.1216,
     +  1.0180,    0.94760,  0.90470,
     +  0.24610,  -0.60940,  2.6530,
     +  0.027070, -0.010670, 0.2003E-2/
C ------ Q2 DEPENDENCE -----------
      LF=NFL-2
      DO 20 I=1,3
        AT(I)=A(I,1,LF)*T**A(I,2,LF)+A(I,3,LF)*T**(-A(I,4,LF))
 20   CONTINUE
C ------ GLUON DISTRIBUTION -------------
      HWSDGG=AT(1)*X**AT(2)*(1.0-X)**AT(3)/137.
      RETURN
      END
CDECK  ID>, HWSDGQ.
*CMZ :-        -26/04/91  13.04.45  by  Federico Carminati
*-- Author :    Drees, Grassie, Charchula, modified by Bryan Webber
C --------------------------------------
C  QUARK PART OF THE PHOTON SF
C --------------------------------------
      FUNCTION HWSDGQ(X,Q2,NFL,NCH)
      IMPLICIT REAL (A-H,P-Z)
      INTEGER NFL,NCH
      DIMENSION A(5,4,2,3),AT(5,2),XQPOM(2),E(2)
      COMMON/DG/F2
C SQUARE OF LAMBDA=0.4 GEV
      ALAM2=0.160
      T=LOG(Q2/ALAM2)
C
C  CHECK WHETHER NFL AND NCH HAVE RIGHT VALUES
C
      IF(.NOT.((NFL.EQ.3).OR.(NFL.EQ.4).OR.(NFL.EQ.5))) THEN
 110   WRITE(6,111)
 111   FORMAT('NUMBER OF FLAVOURS (NFL) HAS NOT BEEN SET TO: 3,4 OR 5'/
     *'          NFL=3 IS ASSUMED')
       NFL=3
      ELSEIF (T.LE.0) THEN
       WRITE(6,132)
 132   FORMAT(' HWSDGQ CALLED WITH SCALE < LAMBDA. RETURNING ZERO.')
       HWSDGQ=0
       RETURN
      ENDIF
      IF (.NOT.((NCH.EQ.1).OR.(NCH.EQ.2))) THEN
 120     WRITE(6,121)
 121     FORMAT(' QUARK CHARGE NUMBER (NCH) HAS NOT BEEN SET',
     *'           TO 1 OR 2;'/
     *'           NCH=1 IS ASSUMED')
         NCH=1
      ENDIF
C ------ INITIALIZATION ------
      DATA(((A(I,J,K,1),I=1,5),J=1,4),K=1,2)/
     + 2.28500,  6.07300, -0.42020,-0.08080, 0.05530,
     +-0.01530, -0.81320,  0.01780, 0.63460, 1.13600,
     + 1.3300E3,-41.3100,   0.92160, 1.20800, 0.95120,
     + 4.21900,  3.16500,  0.18000, 0.20300, 0.01160,
     +16.6900,   0.17600, -0.02080,-0.01680,-0.19860,
     +-0.79160,  0.04790,  0.3386E-2,1.35300, 1.10000,
     + 1.0990E3,  1.04700,  4.85300, 1.42600, 1.13600,
     + 4.42800,  0.02500,  0.84040, 1.23900,-0.27790/
        DATA(((A(I,J,K,2),I=1,5),J=1,4),K=1,2)/
     +-0.37110,-0.17170, 0.087660,-0.89150,-0.18160,
     + 1.06100, 0.78150, 0.021970, 0.28570, 0.58660,
     + 4.75800, 1.53500, 0.109600, 2.97300, 2.42100,
     +-0.01500, 0.7067E-2,0.204000, 0.11850, 0.40590,
     +-0.12070,25.00000,-0.012300,-0.09190, 0.020150,
     + 1.07100,-1.64800, 1.162000, 0.79120, 0.98690,
     + 1.97700,-0.015630,0.482400, 0.63970,-0.070360,
     +-0.8625E-2,6.43800,-0.011000, 2.32700, 0.016940/
        DATA(((A(I,J,K,3),I=1,5),J=1,4),K=1,2)/
     +15.80,     2.7420,  0.029170,-0.03420, -0.023020,
     +-0.94640, -0.73320, 0.046570, 0.71960,  0.92290,
     +-0.50,     0.71480, 0.17850,  0.73380,  0.58730,
     +-0.21180,  3.2870,  0.048110, 0.081390,-0.79E-4,
     + 6.7340,  59.880,  -0.3226E-2,-0.03321,   0.10590,
     +-1.0080,  -2.9830,  0.84320,  0.94750,  0.69540,
     +-0.085940, 4.480,   0.36160, -0.31980, -0.66630,
     + 0.076250, 0.96860, 0.1383E-2, 0.021320, 0.36830/
      CF=10.0
C ------- EVALUATION OF PARAMETERS IN Q2 ---------
      E(1)=1.0
      IF (NFL.EQ.3) THEN
        E(2)=9.0
        LF=1
      ELSEIF (NFL.EQ.4) THEN
        E(2)=10.0
        LF=2
      ELSEIF (NFL.EQ.5) THEN
        E(2)=55.0/6.0
        LF=3
      ENDIF
      DO 10 J=1,2
        DO 20 I=1,5
           ATP=A(I,1,J,LF)*T**A(I,2,J,LF)
           AT(I,J)=ATP+A(I,3,J,LF)*T**(-A(I,4,J,LF))
 20     CONTINUE
 10   CONTINUE
      DO 30 J=1,2
       POM1=X*(X*X+(1.0-X)**2)/(AT(1,J)-AT(2,J)*ALOG(1.0-X))
       POM2=AT(3,J)*X**AT(4,J)*(1.0-X)**AT(5,J)
       XQPOM(J)=E(J)*POM1+POM2
 30   CONTINUE
C -------  QUARK DISTRIBUTIONS ----------
      IF (NFL.EQ.3) THEN
         IF (NCH.EQ.2) THEN
           HWSDGQ=1.0/6.0*(XQPOM(2)+9.0*XQPOM(1))
         ELSEIF(NCH.EQ.1) THEN
           HWSDGQ=1.0/6.0*(XQPOM(2)-9.0/2.0*XQPOM(1))
         ENDIF
        F2=2.0/9.0*XQPOM(2)+XQPOM(1)
      ELSEIF (NFL.EQ.4) THEN
         IF (NCH.EQ.2) THEN
           HWSDGQ=1.0/8.0*(XQPOM(2)+6.0*XQPOM(1))
         ELSEIF(NCH.EQ.1) THEN
           HWSDGQ=1.0/8.0*(XQPOM(2)-6.0*XQPOM(1))
         ENDIF
        F2=5.0/18.0*XQPOM(2)+XQPOM(1)
      ELSEIF (NFL.EQ.5) THEN
         IF (NCH.EQ.2) THEN
           HWSDGQ=1.0/10.0*(XQPOM(2)+15.0/2.0*XQPOM(1))
         ELSEIF(NCH.EQ.1) THEN
           HWSDGQ=1.0/10.0*(XQPOM(2)-5.0*XQPOM(1))
         ENDIF
        F2=11.0/45.0*XQPOM(2)+XQPOM(1)
      ENDIF
      HWSDGQ=HWSDGQ/137.
      RETURN
      END
CDECK  ID>, HWSFBR.
*CMZ :-        -15/07/92  14.08.45  by  Mike Seymour
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWSFBR(X,QQ,FORCED,ID,IW,ID1,ID2,IW1,IW2,Z)
C-----------------------------------------------------------------------
C     FINDS BRANCHING (ID1->ID+ID2) AND Z=X/X1 IN BACKWARD
C     EVOLUTION AT ENERGY FRACTION X AND SCALE QQ
C
C     FORCED=.TRUE. FORCES SPLITTING OF NON-VALENCE PARTON
C
C     IW,IW1,IW2 ARE COLOUR CONNECTION WORDS
C
C     ID1.LT.0 ON RETURN MEANS NO PHASE SPACE
C     ID1.EQ.0 ON RETURN FLAGS REJECTED BRANCHINGS
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWBVMC,HWRGEN,HWUALF,HWUAEM,QP,X,QQ,Z,WQG,WQV,
     & WQP,XQV,ZMIN,ZMAX,YMIN,YMAX,DELY,YY,PSUM,EZ,WQN,WR,ZR,WZ,ZZ,AZ,
     & PVAL,EY,DIST(13),PROB(13,100),PPHO
      INTEGER ID,IW,ID1,ID2,IW1,IW2,NZ,IDHAD,IP,IZ
      LOGICAL HWRLOG,HWSVAL,FORCED,NONF,NONV,PHOTPR
      EXTERNAL HWBVMC,HWRGEN,HWUALF,HWUAEM,HWRLOG,HWSVAL
      ID1=-1
      QP=HWBVMC(ID)
      WQG=1.-QG/QQ
      WQV=1.-QV/QQ
      WQP=1.-QP/QQ
      XQV=X/WQV
      NONV=.NOT.HWSVAL(ID)
      NONF=.NOT.FORCED
    5 IF (ID.EQ.13) THEN
        ZMIN=X
        IF (NONF) THEN
          ZMAX=WQG
        ELSE
          ZMAX=WQV
        ENDIF
      ELSE
        IF (NONV) THEN
          ZMIN=XQV
          IF (NONF) THEN
            ZMAX=WQG
          ELSE
            ZMAX=WQP
          ENDIF
        ELSE
          ZMIN=X
          ZMAX=MAX(WQG,WQP)
        ENDIF
      ENDIF
      IF (ZMIN.GE.ZMAX) RETURN
      ID1=0
C---INTERPOLATION VARIABLE IS Y=LN(Z/(1-Z))
      YMIN=LOG(ZMIN/(1.-ZMIN))
      YMAX=LOG(ZMAX/(1.-ZMAX))
      DELY=YMAX-YMIN
      NZ=MIN(INT(ZBINM*DELY)+1,NZBIN)
      DELY=(YMAX-YMIN)/FLOAT(NZ)
      YY=YMIN+0.5*DELY
      PSUM=0.
      IDHAD=IDHW(INHAD)
C---SET UP TABLES FOR CHOOSING BRANCHING
      DO 40 IZ=1,NZ
      EZ=EXP(YY)
      WR=1.+EZ
      ZR=WR/EZ
      WZ=1./WR
      ZZ=WZ*EZ
      AZ=WZ*ZZ*HWUALF(5-2*SUDORD,MAX(WZ*QQ,QG))
      CALL HWSFUN(X*ZR,QQ,IDHAD,NSTRU,DIST,JNHAD)
      IF (ID.NE.13) THEN
C---SPLITTING INTO QUARK
        DO 10 IP=1,ID-1
   10   PROB(IP,IZ)=PSUM
        IF (NONF) PSUM=PSUM+DIST(ID)*AZ*CFFAC*(1.+ZZ*ZZ)*WR
        DO 20 IP=ID,12
   20   PROB(IP,IZ)=PSUM
        PSUM=PSUM+DIST(13)*AZ*0.5*(ZZ*ZZ+WZ*WZ)
        PROB(13,IZ)=PSUM
      ELSE
C---SPLITTING INTO GLUON
        DO 30 IP=1,12
        PSUM=PSUM+DIST(IP)*AZ*CFFAC*(1.+WZ*WZ)*ZR
   30   PROB(IP,IZ)=PSUM
        IF (NONF) PSUM=PSUM+DIST(13)*AZ*2.*CAFAC*(WZ*ZR+ZZ*WR+WZ*ZZ)
        PROB(13,IZ)=PSUM
      ENDIF
   40 YY=YY+DELY
   50 PHOTPR=IDHAD.EQ.59.AND.ID.NE.13
      IF (PHOTPR) THEN
C---ALLOW ANOMALOUS PHOTON SPLITTING
         PPHO=HWUAEM(-QQ*QQ)*CAFAC*(ZMIN**2+(1.-ZMIN)**2)
     &        *ICHRG(ID)**2/(18.*PIFAC)
         IF (PPHO.GT.(PPHO+PSUM*DELY)*HWRGEN(2)) THEN
C---ANOMALOUS PHOTON SPLITTING OCCURRED
           ID1=59
           RETURN
         ENDIF
       ENDIF
      IF (PSUM.LE.0.) RETURN
C---CHOOSE Z
      PVAL=PSUM*HWRGEN(0)
      DO 60 IZ=1,NZ
      IF (PROB(13,IZ).GT.PVAL) GOTO 70
   60 CONTINUE
      IZ=NZ
   70 EY=EXP(YMIN+DELY*(FLOAT(IZ)-HWRGEN(1)))
      ZZ=EY/(1.+EY)
C---CHOOSE BRANCHING
      DO 80 IP=1,13
      IF (PROB(IP,IZ).GT.PVAL) GOTO 90
   80 CONTINUE
      IP=13
C---CHECK THAT Z IS INSIDE PHASE SPACE (RETURN IF NOT)
   90 CONTINUE
      IF (ID.NE.13) THEN
        IF (IP.EQ.ID) THEN
          IF ((NONV.AND.ZZ*WQP.LT.XQV).OR.ZZ.GT.WQG) THEN
            IF (PHOTPR) GOTO 50
            RETURN
          ENDIF
        ELSE
          IF (ZZ.LT.XQV.OR.ZZ.GT.WQP) THEN
            IF (PHOTPR) GOTO 50
            RETURN
          ENDIF
        ENDIF
      ELSE
        IF (IP.EQ.ID) THEN
          IF (ZZ.LT.XQV.OR.ZZ.GT.WQG) RETURN
        ELSEIF (.NOT.HWSVAL(IP)) THEN
          WQN=1.-HWBVMC(IP)/QQ
          IF (ZZ*WQN.LT.XQV.OR.ZZ.GT.WQN) RETURN
        ENDIF
      ENDIF
C---EVERYTHING OK: LABEL NEW BRANCHES
      Z=ZZ
      ID1=IP
      IW1=IW*2
      IW2=IW1+1
      IF (ID.LE.6) THEN
        IF (ID1.EQ.13) THEN
          ID2=ID+6
        ELSE
          ID2=13
          IW2=IW1
        ENDIF
      ELSE IF (ID.NE.13) THEN
        IF (ID1.EQ.13) THEN
          ID2=ID-6
          IW2=IW1
        ELSE
          ID2=13
        ENDIF
      ELSE
        ID2=ID1
        IF (ID1.EQ.13) THEN
          IF (HWRLOG(HALF)) IW2=IW1
        ELSE IF (ID1.GT.6) THEN
          IW2=IW1
        END IF
      END IF
      IF (IW2.EQ.IW1) IW1=IW1+1
  999 END
CDECK  ID>, HWSFUN.
*CMZ :-        -02/05/91  11.30.51  by  Federico Carminati
*-- Author :    Miscellaneous, combined by Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWSFUN(X,SCALE,IDHAD,NSET,DIST,IBEAM)
C-----------------------------------------------------------------------
C     NUCLEON AND PION STRUCTURE FUNCTIONS DIST=X*QRK(X,Q=SCALE)
C
C     IDHAD = TYPE OF HADRON:
C     73=P  91=PBAR  75=N  93=NBAR  38=PI+  30=PI-  59=PHOTON
C
C     NEW SPECIAL CODES:
C     71=`REMNANT PHOTON' 72=`REMNANT NUCLEON'
C
C     NSET = STRUCTURE FUNCTION SET
C          = 1,2 FOR DUKE+OWENS SETS 1,2 (SOFT/HARD GLUE)
C          = 3,4 FOR EICHTEN ET AL SETS 1,2 (NUCLEON ONLY)
C          = 5   FOR OWENS SET 1.1 (PREPRINT FSU-HEP-910606)
C
C     FOR PHOTON DREES+GRASSIE IS USED
C
C     N.B. IF IBEAM.GT.0.AND.MODPDF(IBEAM).GE.0 THEN NSET IS
C     IGNORED AND CERN PDFLIB WITH AUTHOR GROUP=AUTPDF(IBEAM) AND
C     SET=MODPDF(IBEAM) IS USED.  FOR COMPATABILITY WITH VERSIONS 3
C     AND EARLIER, AUTPDF SHOULD BE SET TO 'MODE'
C     NOTE THAT NO CONSISTENCY CHECK IS MADE, FOR EXAMPLE THAT THE
C     REQUESTED SET FOR A PHOTON IS ACTUALLY A PHOTON SET
C
C     IF (ISPAC.GT.0) SCALE IS REPLACED BY MAX(SCALE,QSPAC)
C
C     FOR PHOTON, IF (PHOMAS.GT.0) THEN QUARK DISTRIBUTIONS ARE
C     SUPPRESSED BY      LOG((Q**2+PHOMAS**2)/(P**2+PHOMAS**2))
C                    L = -------------------------------------- ,
C                        LOG((Q**2+PHOMAS**2)/(     PHOMAS**2))
C     WHILE GLUON DISTRIBUTIONS ARE SUPPRESSED BY L**2,
C     WHERE Q=SCALE AND P=VIRTUALITY OF THE PHOTON
C
C   DUKE+OWENS = D.W.DUKE AND J.F.OWENS, PHYS. REV. D30 (1984) 49 (P/N)
C              + J.F.OWENS, PHYS. REV. D30 (1984) 943 (PI+/-)
C   WITH EXTRA SIGNIFICANT FIGURES VIA ED BERGER
C   WARNING....MOMENTUM SUM RULE BADLY VIOLATED ABOVE 1 TEV
C   DUKE+OWENS SETS 1,2 OBSOLETE. SET 1 UPDATED TO OWENS 1.1 (1991)
C   PION NOT RELIABLE ABOVE SCALE = 50 GEV
C
C   EICHTEN ET AL = E.EICHTEN,I.HINCHLIFFE,K.LANE AND C.QUIGG,
C                   REV. MOD. PHYS. 56 (1984) 579
C   REVISED AS IN   REV. MOD. PHYS. 58 (1986) 1065
C   RELIABLE RANGE : SQRT(5)GEV < SCALE < 10TEV, 1E-4 < X < 1
C
C   DREES+GRASSIE = M.DREES & K.GRASSIE, ZEIT. PHYS. C28 (1985) 451
C   MODIFIED IN     M.DREES & C.S.KIM, DESY 91-039
C                         AND C.S.KIM, DTP/91/16   FOR HEAVY QUARKS
C
C   FOR CERN PDFLIB DETAILS SEE PDFLIB DOC Q ON CERNVM OR
C   CERN_ROOT:[DOC]PDFLIB.TXT ON VXCERN
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWSGAM,X,SCALE,XOLD,QOLD,XMWN,QSCA,SS,SMIN,S,T,
     & TMIN,TMAX,VX,AA,VT,WT,UPV,DNV,SEA,STR,CHM,BTM,TOP,GLU,WX,XQSUM,
     & DMIN,TPMIN,TPMAX,DIST(13),G(2),Q0(5),QL(5),F(5),A(6,5),
     & B(3,6,5,4),XQ(6),TX(6),TT(6),TB(6),NEHLQ(8,2),CEHLQ(6,6,2,8,2),
     & BB(4,6,5),VAL(20),USEA,DSEA,TOTAL,SCALEF,FAC,TBMIN(2),TTMIN(2)
      REAL HWSDGG,HWSDGQ,XSP,Q2,P2,W2,EMB2,EMC2,ALAM2,XPGA(-6:6),F2GM,
     & XPVMD,XPANL,XPANH,XPBEH,XPDIR
      COMMON/SASCOM/XPVMD(-6:6),XPANL(-6:6),XPANH(-6:6),XPBEH(-6:6),
     &     XPDIR(-6:6)
      INTEGER IDHAD,NSET,IBEAM,IOLD,NOLD,IP,I,J,K,NX,IT,IX,IFL,NFL,
     & MPDF,IHAD,ISET,IOP1,IOP2,IP2
      CHARACTER*20 PARM(20)
      EXTERNAL HWSGAM,HWSDGG,HWSDGQ
      SAVE QOLD,IOLD,NOLD,XOLD,SS,S,T,TMIN,TMAX,G,A,TX,TT,TB,IP,NX
      DATA (((B(I,J,K,1),I=1,3),J=1,6),K=1,5)/
     &3.,0.,0.,.419,.004383,-.007412,
     &3.46,.72432,-.065998,4.4,-4.8644,1.3274,
     &6*0.,1.,
     &0.,0.,.763,-.23696,.025836,4.,.62664,-.019163,
     &0.,-.42068,.032809,6*0.,1.265,-1.1323,.29268,
     &0.,-.37162,-.028977,8.05,1.5877,-.15291,
     &0.,6.3059,-.27342,0.,-10.543,-3.1674,
     &0.,14.698,9.798,0.,.13479,-.074693,
     &-.0355,-.22237,-.057685,6.3494,3.2649,-.90945,
     &0.,-3.0331,1.5042,0.,17.431,-11.255,
     &0.,-17.861,15.571,1.564,-1.7112,.63751,
     &0.,-.94892,.32505,6.,1.4345,-1.0485,
     &9.,-7.1858,.25494,0.,-16.457,10.947,
     &0.,15.261,-10.085/
      DATA (((B(I,J,K,2),I=1,3),J=1,6),K=1,5)/
     &3.,0.,0.,.3743,.013946,-.00031695,
     &3.329,.75343,-.076125,6.032,-6.2153,1.5561,
     &6*0.,1.,0.,
     &0.,.7608,-.2317,.023232,3.83,.62746,-.019155,
     &0.,-.41843,.035972,6*0.,1.6714,-1.9168,.58175,
     &0.,-.27307,-.16392,9.145,.53045,-.76271,
     &0.,15.665,-2.8341,0.,-100.63,44.658,
     &0.,223.24,-116.76,0.,.067368,-.030574,
     &-.11989,-.23293,-.023273,3.5087,3.6554,-.45313,
     &0.,-.47369,.35793,0.,9.5041,-5.4303,
     &0.,-16.563,15.524,.8789,-.97093,.43388,
     &0.,-1.1612,.4759,4.,1.2271,-.25369,
     &9.,-5.6354,-.81747,0.,-7.5438,5.5034,
     &0.,-.59649,.12611/
      DATA (((B(I,J,K,3),I=1,3),J=1,6),K=1,5)/
     &1.,0.,0.,0.4,-0.06212,-0.007109,0.7,0.6478,0.01335,27*0.,
     &0.9,-0.2428,0.1386,0.,-0.2120,0.003671,5.0,0.8673,0.04747,
     &0.,1.266,-2.215,0.,2.382,0.3482,3*0.,
     &0.,0.07928,-0.06134,-0.02212,-0.3785,-0.1088,2.894,9.433,
     &-10.852,0.,5.248,-7.187,0.,8.388,-11.61,3*0.,
     &0.888,-1.802,1.812,0.,-1.576,1.20,3.11,-0.1317,0.5068,
     &6.0,2.801,-12.16,0.,-17.28,20.49,3*0./
      DATA (((B(I,J,K,4),I=1,3),J=1,6),K=1,5)/
     &1.,0.,0.,0.4,-0.05909,-0.006524,0.628,0.6436,0.01451,27*0.,
     &0.90,-0.1417,-0.1740,0.,-0.1697,-0.09623,5.0,-2.474,1.575,
     &0.,-2.534,1.378,0.,0.5621,-0.2701,3*0.,
     &0.,0.06229,-0.04099,-0.0882,-0.2892,-0.1082,1.924,0.2424,
     &2.036,0.,-4.463,5.209,0.,-0.8367,-0.04840,3*0.,
     &0.794,-0.9144,0.5966,0.,-1.237,0.6582,2.89,0.5966,-0.2550,
     &6.0,-3.671,-2.304,0.,-8.191,7.758,3*0./
C---COEFFTS FOR NEW OWENS 1.1 SET
      DATA BB/3.,3*0.,.665,-.1097,-.002442,0.,
     &3.614,.8395,-.02186,0.,.8673,-1.6637,.342,0.,
     &0.,1.1049,-.2369,5*0.,1.,3*0.,
     &.8388,-.2092,.02657,0.,4.667,.7951,.1081,0.,
     &0.,-1.0232,.05799,0.,0.,.8616,.153,5*0.,
     &.909,-.4023,.006305,0.,
     &0.,-.3823,.02766,0.,7.278,-.7904,.8108,0.,
     &0.,-1.6629,.5719,0.,0.,-.01333,.5299,0.,
     &0.,.1211,-.1739,0.,0.,.09469,-.07066,.01236,
     &-.1447,-.402,.1533,-.06479,6.7599,1.6596,.6798,-.8525,
     &0.,-4.4559,3.3756,-.9468,
     &0.,7.862,-3.6591,.03672,0.,-.2472,-.751,.0487,
     &3.017,-4.7347,3.3594,-.9443,0.,-.9342,.5454,-.1668,
     &5.304,1.4654,-1.4292,.7569,0.,-3.9141,2.8445,-.8411,
     &0.,9.0176,-10.426,4.0983,0.,-5.9602,7.515,-2.7329/
C...THE FOLLOWING DATA LINES ARE COEFFICIENTS NEEDED IN THE
C...EICHTEN, HINCHLIFFE, LANE, QUIGG PROTON STRUCTURE FUNCTION
C...POWERS OF 1-X IN DIFFERENT CASES
      DATA NEHLQ/3,4,7,5,7,7,7,7,3,4,7,6,7,7,7,7/
C...EXPANSION COEFFICIENTS FOR UP VALENCE QUARK DISTRIBUTION
      DATA (((CEHLQ(IX,IT,NX,1,1),IX=1,6),IT=1,6),NX=1,2)/
     1 7.677E-01,-2.087E-01,-3.303E-01,-2.517E-02,-1.570E-02,-1.000E-04,
     2-5.326E-01,-2.661E-01, 3.201E-01, 1.192E-01, 2.434E-02, 7.620E-03,
     3 2.162E-01, 1.881E-01,-8.375E-02,-6.515E-02,-1.743E-02,-5.040E-03,
     4-9.211E-02,-9.952E-02, 1.373E-02, 2.506E-02, 8.770E-03, 2.550E-03,
     5 3.670E-02, 4.409E-02, 9.600E-04,-7.960E-03,-3.420E-03,-1.050E-03,
     6-1.549E-02,-2.026E-02,-3.060E-03, 2.220E-03, 1.240E-03, 4.100E-04,
     1 2.395E-01, 2.905E-01, 9.778E-02, 2.149E-02, 3.440E-03, 5.000E-04,
     2 1.751E-02,-6.090E-03,-2.687E-02,-1.916E-02,-7.970E-03,-2.750E-03,
     3-5.760E-03,-5.040E-03, 1.080E-03, 2.490E-03, 1.530E-03, 7.500E-04,
     4 1.740E-03, 1.960E-03, 3.000E-04,-3.400E-04,-2.900E-04,-1.800E-04,
     5-5.300E-04,-6.400E-04,-1.700E-04, 4.000E-05, 6.000E-05, 4.000E-05,
     6 1.700E-04, 2.200E-04, 8.000E-05, 1.000E-05,-1.000E-05,-1.000E-05/
      DATA (((CEHLQ(IX,IT,NX,1,2),IX=1,6),IT=1,6),NX=1,2)/
     1 7.237E-01,-2.189E-01,-2.995E-01,-1.909E-02,-1.477E-02, 2.500E-04,
     2-5.314E-01,-2.425E-01, 3.283E-01, 1.119E-01, 2.223E-02, 7.070E-03,
     3 2.289E-01, 1.890E-01,-9.859E-02,-6.900E-02,-1.747E-02,-5.080E-03,
     4-1.041E-01,-1.084E-01, 2.108E-02, 2.975E-02, 9.830E-03, 2.830E-03,
     5 4.394E-02, 5.116E-02,-1.410E-03,-1.055E-02,-4.230E-03,-1.270E-03,
     6-1.991E-02,-2.539E-02,-2.780E-03, 3.430E-03, 1.720E-03, 5.500E-04,
     1 2.410E-01, 2.884E-01, 9.369E-02, 1.900E-02, 2.530E-03, 2.400E-04,
     2 1.765E-02,-9.220E-03,-3.037E-02,-2.085E-02,-8.440E-03,-2.810E-03,
     3-6.450E-03,-5.260E-03, 1.720E-03, 3.110E-03, 1.830E-03, 8.700E-04,
     4 2.120E-03, 2.320E-03, 2.600E-04,-4.900E-04,-3.900E-04,-2.300E-04,
     5-6.900E-04,-8.200E-04,-2.000E-04, 7.000E-05, 9.000E-05, 6.000E-05,
     6 2.400E-04, 3.100E-04, 1.100E-04, 0.000E+00,-2.000E-05,-2.000E-05/
C...EXPANSION COEFFICIENTS FOR DOWN VALENCE QUARK DISTRIBUTION
      DATA (((CEHLQ(IX,IT,NX,2,1),IX=1,6),IT=1,6),NX=1,2)/
     1 3.813E-01,-8.090E-02,-1.634E-01,-2.185E-02,-8.430E-03,-6.200E-04,
     2-2.948E-01,-1.435E-01, 1.665E-01, 6.638E-02, 1.473E-02, 4.080E-03,
     3 1.252E-01, 1.042E-01,-4.722E-02,-3.683E-02,-1.038E-02,-2.860E-03,
     4-5.478E-02,-5.678E-02, 8.900E-03, 1.484E-02, 5.340E-03, 1.520E-03,
     5 2.220E-02, 2.567E-02,-3.000E-05,-4.970E-03,-2.160E-03,-6.500E-04,
     6-9.530E-03,-1.204E-02,-1.510E-03, 1.510E-03, 8.300E-04, 2.700E-04,
     1 1.261E-01, 1.354E-01, 3.958E-02, 8.240E-03, 1.660E-03, 4.500E-04,
     2 3.890E-03,-1.159E-02,-1.625E-02,-9.610E-03,-3.710E-03,-1.260E-03,
     3-1.910E-03,-5.600E-04, 1.590E-03, 1.590E-03, 8.400E-04, 3.900E-04,
     4 6.400E-04, 4.900E-04,-1.500E-04,-2.900E-04,-1.800E-04,-1.000E-04,
     5-2.000E-04,-1.900E-04, 0.000E+00, 6.000E-05, 4.000E-05, 3.000E-05,
     6 7.000E-05, 8.000E-05, 2.000E-05,-1.000E-05,-1.000E-05,-1.000E-05/
      DATA (((CEHLQ(IX,IT,NX,2,2),IX=1,6),IT=1,6),NX=1,2)/
     1 3.578E-01,-8.622E-02,-1.480E-01,-1.840E-02,-7.820E-03,-4.500E-04,
     2-2.925E-01,-1.304E-01, 1.696E-01, 6.243E-02, 1.353E-02, 3.750E-03,
     3 1.318E-01, 1.041E-01,-5.486E-02,-3.872E-02,-1.038E-02,-2.850E-03,
     4-6.162E-02,-6.143E-02, 1.303E-02, 1.740E-02, 5.940E-03, 1.670E-03,
     5 2.643E-02, 2.957E-02,-1.490E-03,-6.450E-03,-2.630E-03,-7.700E-04,
     6-1.218E-02,-1.497E-02,-1.260E-03, 2.240E-03, 1.120E-03, 3.500E-04,
     1 1.263E-01, 1.334E-01, 3.732E-02, 7.070E-03, 1.260E-03, 3.400E-04,
     2 3.660E-03,-1.357E-02,-1.795E-02,-1.031E-02,-3.880E-03,-1.280E-03,
     3-2.100E-03,-3.600E-04, 2.050E-03, 1.920E-03, 9.800E-04, 4.400E-04,
     4 7.700E-04, 5.400E-04,-2.400E-04,-3.900E-04,-2.400E-04,-1.300E-04,
     5-2.600E-04,-2.300E-04, 2.000E-05, 9.000E-05, 6.000E-05, 4.000E-05,
     6 9.000E-05, 1.000E-04, 2.000E-05,-2.000E-05,-2.000E-05,-1.000E-05/
C...EXPANSION COEFFICIENTS FOR UP AND DOWN SEA QUARK DISTRIBUTIONS
      DATA (((CEHLQ(IX,IT,NX,3,1),IX=1,6),IT=1,6),NX=1,2)/
     1 6.870E-02,-6.861E-02, 2.973E-02,-5.400E-03, 3.780E-03,-9.700E-04,
     2-1.802E-02, 1.400E-04, 6.490E-03,-8.540E-03, 1.220E-03,-1.750E-03,
     3-4.650E-03, 1.480E-03,-5.930E-03, 6.000E-04,-1.030E-03,-8.000E-05,
     4 6.440E-03, 2.570E-03, 2.830E-03, 1.150E-03, 7.100E-04, 3.300E-04,
     5-3.930E-03,-2.540E-03,-1.160E-03,-7.700E-04,-3.600E-04,-1.900E-04,
     6 2.340E-03, 1.930E-03, 5.300E-04, 3.700E-04, 1.600E-04, 9.000E-05,
     1 1.014E+00,-1.106E+00, 3.374E-01,-7.444E-02, 8.850E-03,-8.700E-04,
     2 9.233E-01,-1.285E+00, 4.475E-01,-9.786E-02, 1.419E-02,-1.120E-03,
     3 4.888E-02,-1.271E-01, 8.606E-02,-2.608E-02, 4.780E-03,-6.000E-04,
     4-2.691E-02, 4.887E-02,-1.771E-02, 1.620E-03, 2.500E-04,-6.000E-05,
     5 7.040E-03,-1.113E-02, 1.590E-03, 7.000E-04,-2.000E-04, 0.000E+00,
     6-1.710E-03, 2.290E-03, 3.800E-04,-3.500E-04, 4.000E-05, 1.000E-05/
      DATA (((CEHLQ(IX,IT,NX,3,2),IX=1,6),IT=1,6),NX=1,2)/
     1 1.008E-01,-7.100E-02, 1.973E-02,-5.710E-03, 2.930E-03,-9.900E-04,
     2-5.271E-02,-1.823E-02, 1.792E-02,-6.580E-03, 1.750E-03,-1.550E-03,
     3 1.220E-02, 1.763E-02,-8.690E-03,-8.800E-04,-1.160E-03,-2.100E-04,
     4-1.190E-03,-7.180E-03, 2.360E-03, 1.890E-03, 7.700E-04, 4.100E-04,
     5-9.100E-04, 2.040E-03,-3.100E-04,-1.050E-03,-4.000E-04,-2.400E-04,
     6 1.190E-03,-1.700E-04,-2.000E-04, 4.200E-04, 1.700E-04, 1.000E-04,
     1 1.081E+00,-1.189E+00, 3.868E-01,-8.617E-02, 1.115E-02,-1.180E-03,
     2 9.917E-01,-1.396E+00, 4.998E-01,-1.159E-01, 1.674E-02,-1.720E-03,
     3 5.099E-02,-1.338E-01, 9.173E-02,-2.885E-02, 5.890E-03,-6.500E-04,
     4-3.178E-02, 5.703E-02,-2.070E-02, 2.440E-03, 1.100E-04,-9.000E-05,
     5 8.970E-03,-1.392E-02, 2.050E-03, 6.500E-04,-2.300E-04, 2.000E-05,
     6-2.340E-03, 3.010E-03, 5.000E-04,-3.900E-04, 6.000E-05, 1.000E-05/
C...EXPANSION COEFFICIENTS FOR GLUON DISTRIBUTION
      DATA (((CEHLQ(IX,IT,NX,4,1),IX=1,6),IT=1,6),NX=1,2)/
     1 9.482E-01,-9.578E-01, 1.009E-01,-1.051E-01, 3.456E-02,-3.054E-02,
     2-9.627E-01, 5.379E-01, 3.368E-01,-9.525E-02, 1.488E-02,-2.051E-02,
     3 4.300E-01,-8.306E-02,-3.372E-01, 4.902E-02,-9.160E-03, 1.041E-02,
     4-1.925E-01,-1.790E-02, 2.183E-01, 7.490E-03, 4.140E-03,-1.860E-03,
     5 8.183E-02, 1.926E-02,-1.072E-01,-1.944E-02,-2.770E-03,-5.200E-04,
     6-3.884E-02,-1.234E-02, 5.410E-02, 1.879E-02, 3.350E-03, 1.040E-03,
     1 2.948E+01,-3.902E+01, 1.464E+01,-3.335E+00, 5.054E-01,-5.915E-02,
     2 2.559E+01,-3.955E+01, 1.661E+01,-4.299E+00, 6.904E-01,-8.243E-02,
     3-1.663E+00, 1.176E+00, 1.118E+00,-7.099E-01, 1.948E-01,-2.404E-02,
     4-2.168E-01, 8.170E-01,-7.169E-01, 1.851E-01,-1.924E-02,-3.250E-03,
     5 2.088E-01,-4.355E-01, 2.239E-01,-2.446E-02,-3.620E-03, 1.910E-03,
     6-9.097E-02, 1.601E-01,-5.681E-02,-2.500E-03, 2.580E-03,-4.700E-04/
      DATA (((CEHLQ(IX,IT,NX,4,2),IX=1,6),IT=1,6),NX=1,2)/
     1 2.367E+00, 4.453E-01, 3.660E-01, 9.467E-02, 1.341E-01, 1.661E-02,
     2-3.170E+00,-1.795E+00, 3.313E-02,-2.874E-01,-9.827E-02,-7.119E-02,
     3 1.823E+00, 1.457E+00,-2.465E-01, 3.739E-02, 6.090E-03, 1.814E-02,
     4-1.033E+00,-9.827E-01, 2.136E-01, 1.169E-01, 5.001E-02, 1.684E-02,
     5 5.133E-01, 5.259E-01,-1.173E-01,-1.139E-01,-4.988E-02,-2.021E-02,
     6-2.881E-01,-3.145E-01, 5.667E-02, 9.161E-02, 4.568E-02, 1.951E-02,
     1 3.036E+01,-4.062E+01, 1.578E+01,-3.699E+00, 6.020E-01,-7.031E-02,
     2 2.700E+01,-4.167E+01, 1.770E+01,-4.804E+00, 7.862E-01,-1.060E-01,
     3-1.909E+00, 1.357E+00, 1.127E+00,-7.181E-01, 2.232E-01,-2.481E-02,
     4-2.488E-01, 9.781E-01,-8.127E-01, 2.094E-01,-2.997E-02,-4.710E-03,
     5 2.506E-01,-5.427E-01, 2.672E-01,-3.103E-02,-1.800E-03, 2.870E-03,
     6-1.128E-01, 2.087E-01,-6.972E-02,-2.480E-03, 2.630E-03,-8.400E-04/
C...EXPANSION COEFFICIENTS FOR STRANGE SEA QUARK DISTRIBUTION
      DATA (((CEHLQ(IX,IT,NX,5,1),IX=1,6),IT=1,6),NX=1,2)/
     1 4.968E-02,-4.173E-02, 2.102E-02,-3.270E-03, 3.240E-03,-6.700E-04,
     2-6.150E-03,-1.294E-02, 6.740E-03,-6.890E-03, 9.000E-04,-1.510E-03,
     3-8.580E-03, 5.050E-03,-4.900E-03,-1.600E-04,-9.400E-04,-1.500E-04,
     4 7.840E-03, 1.510E-03, 2.220E-03, 1.400E-03, 7.000E-04, 3.500E-04,
     5-4.410E-03,-2.220E-03,-8.900E-04,-8.500E-04,-3.600E-04,-2.000E-04,
     6 2.520E-03, 1.840E-03, 4.100E-04, 3.900E-04, 1.600E-04, 9.000E-05,
     1 9.235E-01,-1.085E+00, 3.464E-01,-7.210E-02, 9.140E-03,-9.100E-04,
     2 9.315E-01,-1.274E+00, 4.512E-01,-9.775E-02, 1.380E-02,-1.310E-03,
     3 4.739E-02,-1.296E-01, 8.482E-02,-2.642E-02, 4.760E-03,-5.700E-04,
     4-2.653E-02, 4.953E-02,-1.735E-02, 1.750E-03, 2.800E-04,-6.000E-05,
     5 6.940E-03,-1.132E-02, 1.480E-03, 6.500E-04,-2.100E-04, 0.000E+00,
     6-1.680E-03, 2.340E-03, 4.200E-04,-3.400E-04, 5.000E-05, 1.000E-05/
      DATA (((CEHLQ(IX,IT,NX,5,2),IX=1,6),IT=1,6),NX=1,2)/
     1 6.478E-02,-4.537E-02, 1.643E-02,-3.490E-03, 2.710E-03,-6.700E-04,
     2-2.223E-02,-2.126E-02, 1.247E-02,-6.290E-03, 1.120E-03,-1.440E-03,
     3-1.340E-03, 1.362E-02,-6.130E-03,-7.900E-04,-9.000E-04,-2.000E-04,
     4 5.080E-03,-3.610E-03, 1.700E-03, 1.830E-03, 6.800E-04, 4.000E-04,
     5-3.580E-03, 6.000E-05,-2.600E-04,-1.050E-03,-3.800E-04,-2.300E-04,
     6 2.420E-03, 9.300E-04,-1.000E-04, 4.500E-04, 1.700E-04, 1.100E-04,
     1 9.868E-01,-1.171E+00, 3.940E-01,-8.459E-02, 1.124E-02,-1.250E-03,
     2 1.001E+00,-1.383E+00, 5.044E-01,-1.152E-01, 1.658E-02,-1.830E-03,
     3 4.928E-02,-1.368E-01, 9.021E-02,-2.935E-02, 5.800E-03,-6.600E-04,
     4-3.133E-02, 5.785E-02,-2.023E-02, 2.630E-03, 1.600E-04,-8.000E-05,
     5 8.840E-03,-1.416E-02, 1.900E-03, 5.800E-04,-2.500E-04, 1.000E-05,
     6-2.300E-03, 3.080E-03, 5.500E-04,-3.700E-04, 7.000E-05, 1.000E-05/
C...EXPANSION COEFFICIENTS FOR CHARM SEA QUARK DISTRIBUTION
      DATA (((CEHLQ(IX,IT,NX,6,1),IX=1,6),IT=1,6),NX=1,2)/
     1 9.270E-03,-1.817E-02, 9.590E-03,-6.390E-03, 1.690E-03,-1.540E-03,
     2 5.710E-03,-1.188E-02, 6.090E-03,-4.650E-03, 1.240E-03,-1.310E-03,
     3-3.960E-03, 7.100E-03,-3.590E-03, 1.840E-03,-3.900E-04, 3.400E-04,
     4 1.120E-03,-1.960E-03, 1.120E-03,-4.800E-04, 1.000E-04,-4.000E-05,
     5 4.000E-05,-3.000E-05,-1.800E-04, 9.000E-05,-5.000E-05,-2.000E-05,
     6-4.200E-04, 7.300E-04,-1.600E-04, 5.000E-05, 5.000E-05, 5.000E-05,
     1 8.098E-01,-1.042E+00, 3.398E-01,-6.824E-02, 8.760E-03,-9.000E-04,
     2 8.961E-01,-1.217E+00, 4.339E-01,-9.287E-02, 1.304E-02,-1.290E-03,
     3 3.058E-02,-1.040E-01, 7.604E-02,-2.415E-02, 4.600E-03,-5.000E-04,
     4-2.451E-02, 4.432E-02,-1.651E-02, 1.430E-03, 1.200E-04,-1.000E-04,
     5 1.122E-02,-1.457E-02, 2.680E-03, 5.800E-04,-1.200E-04, 3.000E-05,
     6-7.730E-03, 7.330E-03,-7.600E-04,-2.400E-04, 1.000E-05, 0.000E+00/
      DATA (((CEHLQ(IX,IT,NX,6,2),IX=1,6),IT=1,6),NX=1,2)/
     1 9.980E-03,-1.945E-02, 1.055E-02,-6.870E-03, 1.860E-03,-1.560E-03,
     2 5.700E-03,-1.203E-02, 6.250E-03,-4.860E-03, 1.310E-03,-1.370E-03,
     3-4.490E-03, 7.990E-03,-4.170E-03, 2.050E-03,-4.400E-04, 3.300E-04,
     4 1.470E-03,-2.480E-03, 1.460E-03,-5.700E-04, 1.200E-04,-1.000E-05,
     5-9.000E-05, 1.500E-04,-3.200E-04, 1.200E-04,-6.000E-05,-4.000E-05,
     6-4.200E-04, 7.600E-04,-1.400E-04, 4.000E-05, 7.000E-05, 5.000E-05,
     1 8.698E-01,-1.131E+00, 3.836E-01,-8.111E-02, 1.048E-02,-1.300E-03,
     2 9.626E-01,-1.321E+00, 4.854E-01,-1.091E-01, 1.583E-02,-1.700E-03,
     3 3.057E-02,-1.088E-01, 8.022E-02,-2.676E-02, 5.590E-03,-5.600E-04,
     4-2.845E-02, 5.164E-02,-1.918E-02, 2.210E-03,-4.000E-05,-1.500E-04,
     5 1.311E-02,-1.751E-02, 3.310E-03, 5.100E-04,-1.200E-04, 5.000E-05,
     6-8.590E-03, 8.380E-03,-9.200E-04,-2.600E-04, 1.000E-05,-1.000E-05/
C...EXPANSION COEFFICIENTS FOR BOTTOM SEA QUARK DISTRIBUTION
      DATA (((CEHLQ(IX,IT,NX,7,1),IX=1,6),IT=1,6),NX=1,2)/
     1 9.010E-03,-1.401E-02, 7.150E-03,-4.130E-03, 1.260E-03,-1.040E-03,
     2 6.280E-03,-9.320E-03, 4.780E-03,-2.890E-03, 9.100E-04,-8.200E-04,
     3-2.930E-03, 4.090E-03,-1.890E-03, 7.600E-04,-2.300E-04, 1.400E-04,
     4 3.900E-04,-1.200E-03, 4.400E-04,-2.500E-04, 2.000E-05,-2.000E-05,
     5 2.600E-04, 1.400E-04,-8.000E-05, 1.000E-04, 1.000E-05, 1.000E-05,
     6-2.600E-04, 3.200E-04, 1.000E-05,-1.000E-05, 1.000E-05,-1.000E-05,
     1 8.029E-01,-1.075E+00, 3.792E-01,-7.843E-02, 1.007E-02,-1.090E-03,
     2 7.903E-01,-1.099E+00, 4.153E-01,-9.301E-02, 1.317E-02,-1.410E-03,
     3-1.704E-02,-1.130E-02, 2.882E-02,-1.341E-02, 3.040E-03,-3.600E-04,
     4-7.200E-04, 7.230E-03,-5.160E-03, 1.080E-03,-5.000E-05,-4.000E-05,
     5 3.050E-03,-4.610E-03, 1.660E-03,-1.300E-04,-1.000E-05, 1.000E-05,
     6-4.360E-03, 5.230E-03,-1.610E-03, 2.000E-04,-2.000E-05, 0.000E+00/
      DATA (((CEHLQ(IX,IT,NX,7,2),IX=1,6),IT=1,6),NX=1,2)/
     1 8.980E-03,-1.459E-02, 7.510E-03,-4.410E-03, 1.310E-03,-1.070E-03,
     2 5.970E-03,-9.440E-03, 4.800E-03,-3.020E-03, 9.100E-04,-8.500E-04,
     3-3.050E-03, 4.440E-03,-2.100E-03, 8.500E-04,-2.400E-04, 1.400E-04,
     4 5.300E-04,-1.300E-03, 5.600E-04,-2.700E-04, 3.000E-05,-2.000E-05,
     5 2.000E-04, 1.400E-04,-1.100E-04, 1.000E-04, 0.000E+00, 0.000E+00,
     6-2.600E-04, 3.200E-04, 0.000E+00,-3.000E-05, 1.000E-05,-1.000E-05,
     1 8.672E-01,-1.174E+00, 4.265E-01,-9.252E-02, 1.244E-02,-1.460E-03,
     2 8.500E-01,-1.194E+00, 4.630E-01,-1.083E-01, 1.614E-02,-1.830E-03,
     3-2.241E-02,-5.630E-03, 2.815E-02,-1.425E-02, 3.520E-03,-4.300E-04,
     4-7.300E-04, 8.030E-03,-5.780E-03, 1.380E-03,-1.300E-04,-4.000E-05,
     5 3.460E-03,-5.380E-03, 1.960E-03,-2.100E-04, 1.000E-05, 1.000E-05,
     6-4.850E-03, 5.950E-03,-1.890E-03, 2.600E-04,-3.000E-05, 0.000E+00/
C...EXPANSION COEFFICIENTS FOR TOP SEA QUARK DISTRIBUTION
      DATA (((CEHLQ(IX,IT,NX,8,1),IX=1,6),IT=1,6),NX=1,2)/
     1 4.410E-03,-7.480E-03, 3.770E-03,-2.580E-03, 7.300E-04,-7.100E-04,
     2 3.840E-03,-6.050E-03, 3.030E-03,-2.030E-03, 5.800E-04,-5.900E-04,
     3-8.800E-04, 1.660E-03,-7.500E-04, 4.700E-04,-1.000E-04, 1.000E-04,
     4-8.000E-05,-1.500E-04, 1.200E-04,-9.000E-05, 3.000E-05, 0.000E+00,
     5 1.300E-04,-2.200E-04,-2.000E-05,-2.000E-05,-2.000E-05,-2.000E-05,
     6-7.000E-05, 1.900E-04,-4.000E-05, 2.000E-05, 0.000E+00, 0.000E+00,
     1 6.623E-01,-9.248E-01, 3.519E-01,-7.930E-02, 1.110E-02,-1.180E-03,
     2 6.380E-01,-9.062E-01, 3.582E-01,-8.479E-02, 1.265E-02,-1.390E-03,
     3-2.581E-02, 2.125E-02, 4.190E-03,-4.980E-03, 1.490E-03,-2.100E-04,
     4 7.100E-04, 5.300E-04,-1.270E-03, 3.900E-04,-5.000E-05,-1.000E-05,
     5 3.850E-03,-5.060E-03, 1.860E-03,-3.500E-04, 4.000E-05, 0.000E+00,
     6-3.530E-03, 4.460E-03,-1.500E-03, 2.700E-04,-3.000E-05, 0.000E+00/
      DATA (((CEHLQ(IX,IT,NX,8,2),IX=1,6),IT=1,6),NX=1,2)/
     1 4.260E-03,-7.530E-03, 3.830E-03,-2.680E-03, 7.600E-04,-7.300E-04,
     2 3.640E-03,-6.050E-03, 3.030E-03,-2.090E-03, 5.900E-04,-6.000E-04,
     3-9.200E-04, 1.710E-03,-8.200E-04, 5.000E-04,-1.200E-04, 1.000E-04,
     4-5.000E-05,-1.600E-04, 1.300E-04,-9.000E-05, 3.000E-05, 0.000E+00,
     5 1.300E-04,-2.100E-04,-1.000E-05,-2.000E-05,-2.000E-05,-1.000E-05,
     6-8.000E-05, 1.800E-04,-5.000E-05, 2.000E-05, 0.000E+00, 0.000E+00,
     1 7.146E-01,-1.007E+00, 3.932E-01,-9.246E-02, 1.366E-02,-1.540E-03,
     2 6.856E-01,-9.828E-01, 3.977E-01,-9.795E-02, 1.540E-02,-1.790E-03,
     3-3.053E-02, 2.758E-02, 2.150E-03,-4.880E-03, 1.640E-03,-2.500E-04,
     4 9.200E-04, 4.200E-04,-1.340E-03, 4.600E-04,-8.000E-05,-1.000E-05,
     5 4.230E-03,-5.660E-03, 2.140E-03,-4.300E-04, 6.000E-05, 0.000E+00,
     6-3.890E-03, 5.000E-03,-1.740E-03, 3.300E-04,-4.000E-05, 0.000E+00/
      DATA TBMIN,TTMIN/8.1905,7.4474,11.5528,10.8097/
      DATA XOLD,QOLD,IOLD,NOLD/-1.,0.,0,0/
      DATA DMIN,Q0,QL/0.,2*2.,2*2.236,2.,.2,.4,.2,.29,.177/
      IF (X.LE.0.) CALL HWWARN('HWSFUN',100,*999)
      XMWN=ONE-X
      IF (XMWN.LE.0.) CALL HWWARN('HWSFUN',101,*999)
C---FREEZE THE SCALE IF REQUIRED
      SCALEF=SCALE
      IF (ISPAC.GT.0) SCALEF=MAX(SCALEF,QSPAC)
C---CHECK IF PDFLIB REQUESTED
      IF (IBEAM.EQ.1.OR.IBEAM.EQ.2) THEN
        MPDF=MODPDF(IBEAM)
      ELSE
        MPDF=-1
      ENDIF
      QSCA=ABS(SCALEF)
      IF (IDHAD.EQ.59.OR.IDHAD.EQ.71) THEN
        IF (MPDF.GE.0) THEN
C---USE PDFLIB PHOTON STRUCTURE FUNCTIONS
          PARM(1)=AUTPDF(IBEAM)
          VAL(1)=FLOAT(MPDF)
C---FIX TO CALL SCHULER-SJOSTRAND CODE
          IF (AUTPDF(IBEAM).EQ.'SaSph') THEN
            XSP=X
            IF (XSP.LE.0.) CALL HWWARN('HWSFUN',102,*999)
            IF (1.-XSP.LE.0.) CALL HWWARN('HWSFUN',103,*999)
            Q2=QSCA**2
            ISET=MOD(MODPDF(IBEAM),10)
            IOP1=MOD(MODPDF(IBEAM)/10,2)
            IOP2=MOD(MODPDF(IBEAM)/20,2)
            IP2=MODPDF(IBEAM)/100
            IF (IOP2.EQ.0) THEN
              P2=0.
            ELSE
              IHAD=IBEAM
              IF (JDAHEP(1,IHAD).NE.0) IHAD=JDAHEP(1,IHAD)
              P2=PHEP(5,IHAD)**2
            ENDIF
            CALL SASGAM(ISET,XSP,Q2,P2,IP2,F2GM,XPGA)
            IF (IOP1.EQ.1 .AND. ISTAT.LT.10) THEN
              DO 5 I=-6,6
 5            XPGA(I)=XPVMD(I)+XPANL(I)+XPBEH(I)+XPDIR(I)
            ENDIF
            UPV=XPGA(2)
            DNV=XPGA(1)
            USEA=XPGA(2)
            DSEA=XPGA(1)
            STR=XPGA(3)
            CHM=XPGA(4)
            BTM=XPGA(5)
            TOP=XPGA(6)
            GLU=XPGA(0)
          ELSE
            CALL PDFSET(PARM,VAL)
            CALL STRUCTM(X,QSCA,UPV,DNV,USEA,DSEA,STR,CHM,BTM,TOP,GLU)
          ENDIF
          DIST(1)=DSEA
          DIST(2)=USEA
          DIST(7)=DSEA
          DIST(8)=USEA
        ELSE
          XSP=X
          IF (XSP.LE.0.) CALL HWWARN('HWSFUN',102,*999)
          IF (1.-XSP.LE.0.) CALL HWWARN('HWSFUN',103,*999)
          Q2=SCALEF**2
          W2=Q2*(1-X)/X
          EMC2=4*RMASS(4)**2
          EMB2=4*RMASS(5)**2
          ALAM2=0.160
          NFL=3
          IF (Q2.GT.50.) NFL=4
          IF (Q2.GT.500.) NFL=5
          STR=HWSDGQ(XSP,Q2,NFL,1)
          CHM=HWSDGQ(XSP,Q2,NFL,2)
          GLU=HWSDGG(XSP,Q2,NFL)
          DIST(1)=STR
          DIST(2)=CHM
          DIST(7)=STR
          DIST(8)=CHM
          IF (W2.GT.EMB2) THEN
            BTM=STR
            IF (W2*ALAM2.LT.Q2*EMB2)
     &          BTM=BTM*LOG(W2/EMB2)/LOG(Q2/ALAM2)
          ELSE
            BTM=0.
          ENDIF
          IF (W2.GT.EMC2) THEN
            IF (W2*ALAM2.LT.Q2*EMC2)
     &          CHM=CHM*LOG(W2/EMC2)/LOG(Q2/ALAM2)
          ELSE
            CHM=0.
          ENDIF
          TOP=0.
        ENDIF
C---INCLUDE SUPPRESSION FROM PHOTON VIRTUALITY IF NECESSARY
        IF (PHOMAS.GT.ZERO.AND.(IBEAM.EQ.1.OR.IBEAM.EQ.2)) THEN
          IHAD=IBEAM
          IF (JDAHEP(1,IHAD).NE.0) IHAD=JDAHEP(1,IHAD)
          IF (IDHW(IHAD).EQ.59) THEN
            FAC=LOG((QSCA**2+PHOMAS**2)/(PHEP(5,IHAD)**2+PHOMAS**2))/
     $          LOG((QSCA**2+PHOMAS**2)/(                PHOMAS**2))
            IF (FAC.LT.ZERO) FAC=ZERO
            DIST(1)=DIST(1)*FAC
            DIST(2)=DIST(2)*FAC
            DIST(7)=DIST(7)*FAC
            DIST(8)=DIST(8)*FAC
            STR=STR*FAC
            CHM=CHM*FAC
            BTM=BTM*FAC
            TOP=TOP*FAC
            GLU=GLU*FAC**2
          ELSE
            CALL HWWARN('HWSFUN',1,*999)
          ENDIF
        ENDIF
        GOTO 900
      ENDIF
      IF (MPDF.GE.0) THEN
C---USE PDFLIB NUCLEON STRUCTURE FUNCTIONS
        PARM(1)=AUTPDF(IBEAM)
        VAL(1)=FLOAT(MPDF)
        CALL PDFSET(PARM,VAL)
        CALL STRUCTM(X,QSCA,UPV,DNV,USEA,DSEA,STR,CHM,BTM,TOP,GLU)
      ELSE
        IF (QSCA.LT.Q0(NSET)) QSCA=Q0(NSET)
        IF (QSCA.NE.QOLD.OR.IDHAD.NE.IOLD.OR.NSET.NE.NOLD) THEN
C---INITIALIZE
          IF (NSET.LT.1.OR.NSET.GT.5) CALL HWWARN('HWSFUN',400,*999)
          QOLD=QSCA
          IOLD=IDHAD
          NOLD=NSET
          SS=LOG(QSCA/QL(NSET))
          SMIN=LOG(Q0(NSET)/QL(NSET))
          IF (NSET.LT.3.OR.NSET.EQ.5) THEN
            S=LOG(SS/SMIN)
          ELSE
            T=2.*SS
            TMIN=2.*SMIN
            TMAX=2.*LOG(1.E4/QL(NSET))
          ENDIF
          IF (IDHAD.GE.72) THEN
            IF (NSET.LT.3) THEN
              IP=NSET
              DO 10 I=1,5
              DO 10 J=1,6
   10         A(J,I)=B(1,J,I,IP)+S*(B(2,J,I,IP)+S*B(3,J,I,IP))
              DO 20 K=1,2
              AA=ONE+A(2,K)+A(3,K)
   20         G(K)=HWSGAM(AA)/((ONE+A(2,K)*A(4,K)/AA)*HWSGAM(A(2,K))
     &            *HWSGAM(ONE+A(3,K)))
            ELSEIF (NSET.EQ.5) THEN
              DO 21 I=1,5
              DO 21 J=1,6
   21         A(J,I)=BB(1,J,I)+S*(BB(2,J,I)+S*(BB(3,J,I)+S*BB(4,J,I)))
              DO 22 K=1,2
              AA=ONE+A(2,K)+A(3,K)
   22         G(K)=HWSGAM(AA)/((ONE+A(2,K)/AA*(A(4,K)+
     &            (ONE+A(2,K))/(ONE+AA)*A(5,K)))*HWSGAM(A(2,K))
     &            *HWSGAM(ONE+A(3,K)))
            ELSE
              IP=NSET-2
              VT=MAX(-ONE,MIN(ONE,(2.*T-TMAX-TMIN)/(TMAX-TMIN)))
              WT=VT*VT
C...CHEBYSHEV POLYNOMIALS FOR T EXPANSION
              TT(1)=1.
              TT(2)=VT
              TT(3)=   2.*WT- 1.
              TT(4)=  (4.*WT- 3.)*VT
              TT(5)=  (8.*WT- 8.)*WT+1.
              TT(6)=((16.*WT-20.)*WT+5.)*VT
            ENDIF
          ELSEIF (NSET.LT.3) THEN
              IP=NSET+2
              DO 30 I=1,5
              DO 30 J=1,6
   30         A(J,I)=B(1,J,I,IP)+S*(B(2,J,I,IP)+S*B(3,J,I,IP))
              AA=ONE+A(2,1)+A(3,1)
              G(1)=HWSGAM(AA)/(HWSGAM(A(2,1))*HWSGAM(ONE+A(3,1)))
              G(2)=0.
           ENDIF
        ENDIF
C
        IF (NSET.LT.3.OR.NSET.EQ.5) THEN
          DO 50 I=1,5
   50     F(I)=A(1,I)*X**A(2,I)*XMWN**A(3,I)*(ONE+X*
     &        (A(4,I)+X*(A(5,I)  +  X*A(6,I))))
          F(1)=F(1)*G(1)
          F(2)=F(2)*G(2)
          UPV=F(1)-F(2)
          DNV=F(2)
          SEA=F(3)/6.
          STR=SEA
          CHM=F(4)
          BTM=0.
          TOP=0.
          GLU=F(5)
        ELSE
          IF (X.NE.XOLD) THEN
            XOLD=X
            IF (X.GT.0.1) THEN
              NX=1
              VX=(2.*X-1.1)/0.9
            ELSE
              NX=2
              VX=MAX(-ONE,(2.*LOG(X)+11.51293)/6.90776)
            ENDIF
            WX=VX*VX
            TX(1)=1.
            TX(2)=VX
            TX(3)=   2.*WX- 1.
            TX(4)=  (4.*WX- 3.)*VX
            TX(5)=  (8.*WX- 8.)*WX+1.
            TX(6)=((16.*WX-20.)*WX+5.)*VX
          ENDIF
C...CALCULATE STRUCTURE FUNCTIONS
          DO 120 IFL=1,6
          XQSUM=0.
          DO 110 IT=1,6
          DO 110 IX=1,6
  110     XQSUM=XQSUM+CEHLQ(IX,IT,NX,IFL,IP)*TX(IX)*TT(IT)
  120     XQ(IFL)=XQSUM*XMWN**NEHLQ(IFL,IP)
          UPV=XQ(1)
          DNV=XQ(2)
          STR=XQ(5)
          CHM=XQ(6)
          SEA=XQ(3)
          GLU=XQ(4)
C...SPECIAL EXPANSION FOR BOTTOM (THRESHOLD EFFECTS)
          IF (NFLAV.LT.5.OR.T.LE.TBMIN(IP)) THEN
            BTM=0.
          ELSE
            VT=MAX(-ONE,MIN(ONE,(2.*T-TMAX-TBMIN(IP))/(TMAX-TBMIN(IP))))
            WT=VT*VT
            TB(1)=1.
            TB(2)=VT
            TB(3)=   2.*WT- 1.
            TB(4)=  (4.*WT- 3.)*VT
            TB(5)=  (8.*WT- 8.)*WT+1.
            TB(6)=((16.*WT-20.)*WT+5.)*VT
            XQSUM=0.
            DO 130 IT=1,6
            DO 130 IX=1,6
  130       XQSUM=XQSUM+CEHLQ(IX,IT,NX,7,IP)*TX(IX)*TB(IT)
            BTM=XQSUM*XMWN**NEHLQ(7,IP)
          ENDIF
C...SPECIAL EXPANSION FOR TOP (THRESHOLD EFFECTS)
          TPMIN=TTMIN(IP)+TMTOP
C---TMTOP=2.*LOG(TOPMAS/30.)
          TPMAX=TMAX+TMTOP
          IF (NFLAV.LT.6.OR.T.LE.TPMIN) THEN
            TOP=0.
          ELSE
            VT=MAX(-ONE,MIN(ONE,(2.*T-TPMAX-TPMIN)/(TPMAX-TPMIN)))
            WT=VT*VT
            TB(1)=1.
            TB(2)=VT
            TB(3)=   2.*WT- 1.
            TB(4)=  (4.*WT- 3.)*VT
            TB(5)=  (8.*WT- 8.)*WT+1.
            TB(6)=((16.*WT-20.)*WT+5.)*VT
            XQSUM=0.
            DO 150 IT=1,6
            DO 150 IX=1,6
  150       XQSUM=XQSUM+CEHLQ(IX,IT,NX,8,IP)*TX(IX)*TB(IT)
            TOP=XQSUM*XMWN**NEHLQ(8,IP)
          ENDIF
        ENDIF
      ENDIF
      IF (MPDF.LT.0) THEN
        USEA=SEA
        DSEA=USEA
      ENDIF
      IF (IDHAD.EQ.73.OR.IDHAD.EQ.72) THEN
         DIST(1)=DSEA+DNV
         DIST(2)=USEA+UPV
         DIST(7)=DSEA
         DIST(8)=USEA
      ELSEIF (IDHAD.EQ.91) THEN
         DIST(1)=DSEA
         DIST(2)=USEA
         DIST(7)=DSEA+DNV
         DIST(8)=USEA+UPV
      ELSEIF (IDHAD.EQ.75) THEN
         DIST(1)=USEA+UPV
         DIST(2)=DSEA+DNV
         DIST(7)=USEA
         DIST(8)=DSEA
      ELSEIF (IDHAD.EQ.93) THEN
         DIST(1)=USEA
         DIST(2)=DSEA
         DIST(7)=USEA+UPV
         DIST(8)=DSEA+DNV
      ELSEIF (IDHAD.EQ.38) THEN
         DIST(1)=USEA
         DIST(2)=USEA+UPV
         DIST(7)=USEA+UPV
         DIST(8)=USEA
      ELSEIF (IDHAD.EQ.30) THEN
         DIST(1)=USEA+UPV
         DIST(2)=USEA
         DIST(7)=USEA
         DIST(8)=USEA+UPV
      ELSE
         PRINT *,' CALLED HWSFUN FOR IDHAD =',IDHAD
         CALL HWWARN('HWSFUN',400,*999)
      ENDIF
  900 DIST(3)=STR
      DIST(4)=CHM
      DIST(5)=BTM
      DIST(6)=TOP
      DIST(9)=STR
      DIST(10)=CHM
      DIST(11)=BTM
      DIST(12)=TOP
      DIST(13)=GLU
      DO 901 I=1,13
      IF (DIST(I).LT.DMIN) DIST(I)=DMIN
  901 CONTINUE
C---FOR REMNANT NUCLEONS SWITCH OFF VALENCE QUARKS,
C   WHILE MAINTAINING MOMENTUM SUM RULE
      IF (IDHAD.EQ.72) THEN
        TOTAL=0
        DO 910 I=1,13
          TOTAL=TOTAL+DIST(I)
 910    CONTINUE
        DIST(1)=DIST(1)-DNV
        DIST(2)=DIST(2)-UPV
        IF (TOTAL.GT.DNV+UPV) THEN
          DO 920 I=1,13
            DIST(I)=DIST(I)*TOTAL/(TOTAL-DNV-UPV)
 920      CONTINUE
        ENDIF
      ENDIF
  999 END
CDECK  ID>, HWSGAM.
*CMZ :-        -26/04/91  11.11.56  by  Bryan Webber
*-- Author :    Adapted by Bryan Webber
C-----------------------------------------------------------------------
      FUNCTION HWSGAM(ZINPUT)
C-----------------------------------------------------------------------
C   Gamma function computed by eq. 6.1.40, Abramowitz.
C   B(M) = B2m/(2m *(2m-1)) where B2m is the 2m'th Bernoulli number.
C   HLNTPI = .5*LOG(2.*PI)
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWSGAM,ZINPUT,B(10),HLNTPI,Z,SHIFT,G,T,RECZSQ
      INTEGER I
      DATA B/
     1       0.83333333333333333333D-01,   -0.27777777777777777778D-02,
     1       0.79365079365079365079D-03,   -0.59523809523809523810D-03,
     1       0.84175084175084175084D-03,   -0.19175269175269175269D-02,
     1       0.64102564102564102564D-02,   -0.29550653594771241830D-01,
     1       0.17964437236883057316D0  ,    -1.3924322169059011164D0  /
      DATA HLNTPI/0.91893853320467274178D0/
C
C   Shift argument to large value ( > 20 )
C
      Z=ZINPUT
      SHIFT=1.
   10 IF (Z.LT.20.D0) THEN
         SHIFT = SHIFT*Z
         Z = Z + 1.D0
         GOTO 10
      ENDIF
C
C   Compute asymptotic formula
C
      G = (Z-.5D0)*LOG(Z) - Z + HLNTPI
      T = 1.D0/Z
      RECZSQ = T**2
      DO 20 I = 1,10
         G = G + B(I)*T
         T = T*RECZSQ
   20 CONTINUE
      HWSGAM = EXP(G)/SHIFT
      END
CDECK  ID>, HWSGEN.
*CMZ :-        -26/04/91  14.55.45  by  Federico Carminati
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWSGEN(GENEX)
C-----------------------------------------------------------------------
C     GENERATES X VALUES (IF GENEX)
C     EVALUATES STRUCTURE FUNCTIONS AND ENFORCES CUTOFFS ON X
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWBVMC,HWRUNI,X,QL
      INTEGER I,J
      LOGICAL GENEX
      EXTERNAL HWBVMC,HWRUNI
      IF (GENEX) THEN
        XX(1)=EXP(HWRUNI(0,ZERO,XLMIN))
        XX(2)=XXMIN/XX(1)
      ENDIF
      DO 10 I=1,2
        J=I
        IF (JDAHEP(1,I).NE.0) J=JDAHEP(1,I)
        X=XX(I)
        QL=(1.-X)*EMSCA
        CALL HWSFUN(X,EMSCA,IDHW(J),NSTRU,DISF(1,I),I)
      DO 10 J=1,13
        IF (QL.LT.HWBVMC(J)) DISF(J,I)=0.
   10 CONTINUE
      END
CDECK  ID>, HWSGQQ.
*CMZ :-        -26/04/91  11.11.56  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      FUNCTION HWSGQQ(QSCA)
C-----------------------------------------------------------------------
C     CORRECTION TO GLUON STRUCTURE FUNCTION FOR BACKWARD EVOLUTION:
C     G->Q-QBAR PART OF FORM FACTOR
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWSGQQ,HWUALF,QSCA,GG
      EXTERNAL HWUALF
      GG=HWUALF(1,QSCA)**(-1.D0/BETAF)
      IF (GG.LT.1.D0) GG=1.D0
      IF (QSCA.GT.RMASS(6)) THEN
        HWSGQQ=GG**6
      ELSEIF (QSCA.GT.RMASS(5)) THEN
        HWSGQQ=GG**5
      ELSEIF (QSCA.GT.RMASS(4)) THEN
        HWSGQQ=GG**4
      ELSE
        HWSGQQ=GG**3
      ENDIF
      END
CDECK  ID>, HWSSPC.
*CMZ :-        -26/04/91  11.11.56  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWSSPC
C-----------------------------------------------------------------------
C     REPLACES SPACELIKE PARTONS BY SPECTATORS
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWUSQR,EMSQ,EMTR,EPAR,XPAR,QSQ
      INTEGER KHEP,IP,JP,IDH,IDP,ISP,IDSPC
      EXTERNAL HWUSQR
      IF (IERROR.NE.0) RETURN
      DO 50 KHEP=1,NHEP
      IF (ISTHEP(KHEP).EQ.145.OR.ISTHEP(KHEP).EQ.146) THEN
        IP=ISTHEP(KHEP)-144
        JP=IP
        IF (JDAHEP(1,IP).NE.0) JP=JDAHEP(1,IP)
        IDH=IDHW(JP)
        IDP=IDHW(KHEP)
        IF (IDH.NE.IDP) THEN
          IF (IDH.EQ.59) THEN
C---PHOTON CASE
            IF (IDP.LT.7) THEN
              IDSPC=IDP+6
            ELSEIF (IDP.LT.13) THEN
              IDSPC=IDP-6
            ELSE
              CALL HWWARN('HWSSPC',100,*999)
            ENDIF
C---IDENTIFY SPECTATOR
C   (1) QUARK CASE
          ELSEIF (IDP.LE.3) THEN
            DO 10 ISP=1,12
  10        IF (IDH.EQ.NCLDK(LOCN(IDP,ISP))) GOTO 20
            CALL HWWARN('HWSSPC',101,*999)
  20        IF (ISP.LE.3) THEN
              IDSPC=ISP+6
            ELSEIF (ISP.LE.9) THEN
              IDSPC=ISP+105
            ELSE
              IDSPC=ISP
            ENDIF
C---(2) ANTIQUARK CASE
          ELSEIF (IDP.GT.6.AND.IDP.LE.9) THEN
            IDP=IDP-6
            DO 30 ISP=1,12
  30        IF (IDH.EQ.NCLDK(LOCN(ISP,IDP))) GOTO 40
            CALL HWWARN('HWSSPC',103,*999)
            RETURN
  40        IF (ISP.LE.3) THEN
              IDSPC=ISP
            ELSEIF (ISP.LE.9) THEN
              IDSPC=ISP+111
            ELSE
              IDSPC=ISP-6
            ENDIF
C---SPECIAL CASE FOR REMNANT HADRON
          ELSEIF (IDH.EQ.71.OR.IDH.EQ.72) THEN
            IF (IDP.EQ.13) THEN
              IDSPC=IDP
            ELSE
              CALL HWWARN('HWSSPC',106,*999)
            ENDIF
          ELSE
            CALL HWWARN('HWSSPC',105,*999)
          ENDIF
C---REPLACE PARTON BY SPECTATOR
          IDHW(KHEP)=IDSPC
          IDHEP(KHEP)=IDPDG(IDSPC)
          ISTHEP(KHEP)=146+IP
          EMSQ=SIGN(PHEP(5,KHEP)**2,PHEP(5,KHEP))
          EMTR=EMSQ+PHEP(1,KHEP)**2+PHEP(2,KHEP)**2
          EPAR=PHEP(4,KHEP)
          CALL HWVDIF(4,PHEP(1,JP),PHEP(1,KHEP),PHEP(1,KHEP))
          IF (EPAR**2.LT.10000.*ABS(EMTR)) THEN
            CALL HWUMAS(PHEP(1,KHEP))
          ELSE
C---COMPUTE SPECTATOR MASS ELIMINATING ROUNDING ERRORS
            XPAR=EPAR/PHEP(4,JP)
            QSQ=SIGN(PHEP(5,JP)**2,PHEP(5,JP))
            PHEP(5,KHEP)=HWUSQR((1.-XPAR)*QSQ+EMSQ-EMTR/XPAR
     &                 -((QSQ*XPAR**2-EMTR)/(2*EPAR*XPAR**2))**2*XPAR)
          ENDIF
C---CHECK FOR UNPHYSICAL SPECTATOR
          IF (PHEP(4,KHEP).LT.0..OR.PHEP(5,KHEP).LT.0.) FROST=.TRUE.
        ENDIF
      ENDIF
  50  CONTINUE
  999 END
CDECK  ID>, HWSSUD.
*CMZ :-        -26/04/91  11.11.56  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      FUNCTION HWSSUD(I)
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWSSUD,HWSGQQ,DMIN,QSCA,XLAST,DIST(13)
      INTEGER I,N0,IS,ID
      EXTERNAL HWSGQQ
      COMMON/HWTABC/XLAST,N0,IS,ID
      DATA DMIN/1.D-15/
      QSCA=QEV(N0+I,IS)
      CALL HWSFUN(XLAST,QSCA,IDHW(INHAD),NSTRU,DIST,JNHAD)
      IF (ID.EQ.13) DIST(ID)=DIST(ID)*HWSGQQ(QSCA)
      IF (DIST(ID).LT.DMIN) DIST(ID)=DMIN
      HWSSUD=SUD(N0+I,IS)/DIST(ID)
      END
CDECK  ID>, HWSTAB.
*CMZ :-        -26/04/91  11.11.56  by  Bryan Webber
*-- Author :    Adapted by Bryan Webber
C-----------------------------------------------------------------------
      FUNCTION HWSTAB(F,AFUN,NN,X,MM)
C-----------------------------------------------------------------------
C     MODIFIED CERN INTERPOLATION ROUTINE DIVDIF
C     LIKE HWUTAB BUT USES FUNCTION AFUN IN PLACE OF ARRAY A
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWSTAB,AFUN,SUM,X,F(NN),T(20),D(20)
      INTEGER NN,MM,MMAX,N,M,MPLUS,IX,IY,MID,NPTS,IP,I,J,L,ISUB
      LOGICAL EXTRA
      EXTERNAL AFUN
      DATA MMAX/10/
      N=NN
      M=MIN(MM,MMAX,N-1)
      MPLUS=M+1
      IX=0
      IY=N+1
      IF (AFUN(1).GT.AFUN(N)) GOTO 94
   91 MID=(IX+IY)/2
      IF (X.GE.AFUN(MID)) GOTO 92
      IY=MID
      GOTO 93
   92 IX=MID
   93 IF (IY-IX.GT.1) GOTO 91
      GOTO 97
   94 MID=(IX+IY)/2
      IF (X.LE.AFUN(MID)) GOTO 95
      IY=MID
      GOTO 96
   95 IX=MID
   96 IF (IY-IX.GT.1) GOTO 94
   97 NPTS=M+2-MOD(M,2)
      IP=0
      L=0
      GOTO 99
   98 L=-L
      IF (L.GE.0) L=L+1
   99 ISUB=IX+L
      IF ((1.LE.ISUB).AND.(ISUB.LE.N)) GOTO 100
      NPTS=MPLUS
      GOTO 101
  100 IP=IP+1
      T(IP)=AFUN(ISUB)
      D(IP)=F(ISUB)
  101 IF (IP.LT.NPTS) GOTO 98
      EXTRA=NPTS.NE.MPLUS
      DO 14 L=1,M
      IF (.NOT.EXTRA) GOTO 12
      ISUB=MPLUS-L
      D(M+2)=(D(M+2)-D(M))/(T(M+2)-T(ISUB))
   12 I=MPLUS
      DO 13 J=L,M
      ISUB=I-L
      D(I)=(D(I)-D(I-1))/(T(I)-T(ISUB))
      I=I-1
   13 CONTINUE
   14 CONTINUE
      SUM=D(MPLUS)
      IF (EXTRA) SUM=0.5*(SUM+D(M+2))
      J=M
      DO 15 L=1,M
      SUM=D(J)+(X-T(J))*SUM
      J=J-1
   15 CONTINUE
      HWSTAB=SUM
      END
CDECK  ID>, HWSVAL.
*CMZ :-        -26/04/91  10.18.58  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      FUNCTION HWSVAL(ID)
C-----------------------------------------------------------------------
C     TRUE FOR VALENCE PARTON ID IN INCOMING HADRON INHAD
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      INTEGER ID,IDHAD
      LOGICAL HWSVAL
      HWSVAL=.FALSE.
      IDHAD=IDHW(INHAD)
      IF (IDHAD.EQ.73.OR.IDHAD.EQ.75) THEN
        IF (ID.EQ.1.OR.ID.EQ.2) HWSVAL=.TRUE.
      ELSEIF (IDHAD.EQ.91.OR.IDHAD.EQ.93) THEN
        IF (ID.EQ.7.OR.ID.EQ.8) HWSVAL=.TRUE.
      ELSEIF (IDHAD.EQ.30) THEN
        IF (ID.EQ.1.OR.ID.EQ.8) HWSVAL=.TRUE.
      ELSEIF (IDHAD.EQ.38) THEN
        IF (ID.EQ.2.OR.ID.EQ.7) HWSVAL=.TRUE.
      ELSEIF (IDHAD.EQ.59) THEN
        IF (ID.LT.6.OR.(ID.GT.6.AND.ID.LT.12)) HWSVAL=.TRUE.
      ELSEIF (IDHAD.EQ.71.OR.IDHAD.EQ.72) THEN
        IF (ID.EQ.13) HWSVAL=.TRUE.
      ELSE
        CALL HWWARN('HWSVAL',100,*999)
      ENDIF
  999 END
CDECK  ID>, HWUAEM.
*CMZ :-        -23/08/94  13.22.29  by  Mike Seymour
*-- Author :    Ian Knowles
C-----------------------------------------------------------------------
      FUNCTION HWUAEM(Q2)
C-----------------------------------------------------------------------
C     Running electromagnetic coupling constant.
C     See R. Kleiss et al.: CERN yellow report 89-08, vol.3 p.129
C     Hadronic component from: H. Burkhardt et al.: Z. Phys C43 (89) 497
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWUAEM,HWUAER,Q2,EPS,A1,B1,C1,A2,B2,C2,A3,B3,C3,
     & A4,B4,C4,AEMPI,EEL2,EMU2,ETAU2,ETOP2,REPIGG,X
      LOGICAL FIRST
      EXTERNAL HWUAER
      SAVE FIRST,AEMPI,EEL2,EMU2,ETAU2,ETOP2
      PARAMETER (EPS=1.D-6)
      DATA A1,B1,C1/0.0    ,0.00835,1.000/
      DATA A2,B2,C2/0.0    ,0.00238,3.927/
      DATA A3,B3,C3/0.00165,0.00299,1.000/
      DATA A4,B4,C4/0.00221,0.00293,1.000/
      DATA FIRST/.TRUE./
      IF (FIRST) THEN
         AEMPI=ALPHEM/(3.*PIFAC)
         EEL2 =RMASS(121)**2
         EMU2 =RMASS(123)**2
         ETAU2=RMASS(125)**2
         ETOP2=RMASS(6)**2
         FIRST=.FALSE.
      ENDIF
      IF (ABS(Q2).LT.EPS) THEN
          HWUAEM=ALPHEM
          RETURN
      ENDIF
C Leptonic component
      REPIGG=AEMPI*(HWUAER(EEL2/Q2)+HWUAER(EMU2/Q2)+HWUAER(ETAU2/Q2))
C Hadronic component from light quarks
      X=ABS(Q2)
      IF (X.LT.9.D-2) THEN
          REPIGG=REPIGG+A1+B1*LOG(ONE+C1*X)
      ELSEIF (X.LT.9.D0) THEN
          REPIGG=REPIGG+A2+B2*LOG(ONE+C2*X)
      ELSEIF (X.LT.1.D4) THEN
          REPIGG=REPIGG+A3+B3*LOG(ONE+C3*X)
      ELSE
          REPIGG=REPIGG+A4+B4*LOG(ONE+C4*X)
      ENDIF
C Top Contribution
      REPIGG=REPIGG+AEMPI*HWUAER(ETOP2/Q2)
      HWUAEM=ALPHEM/(ONE-REPIGG)
      RETURN
      END
CDECK  ID>, HWUAER.
*CMZ :-        -23/08/94  13.22.29  by  Mike Seymour
*-- Author :    Ian Knowles
C-----------------------------------------------------------------------
      FUNCTION HWUAER(R)
C-----------------------------------------------------------------------
C     Real part of photon self-energy: Pi_{gg}(R=M^2/Q^2)
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWUAER,R,ZERO,ONE,TWO,FOUR,FVTHR,THIRD,RMAX,BETA
      PARAMETER (ZERO=0.D0, ONE=1.D0, TWO=2.D0, FOUR=4.D0,
     &           FVTHR=1.666666666666667D0, THIRD=.3333333333333333D0)
      PARAMETER (RMAX=1.D6)
      IF (ABS(R).LT.1.D-3) THEN
C Use assymptotic formula
         HWUAER=-FVTHR-LOG(ABS(R))
      ELSEIF (ABS(R).GT.RMAX) THEN
         HWUAER=ZERO
      ELSEIF (R.GT.0.25) THEN
         BETA=SQRT(FOUR*R-ONE)
         HWUAER=THIRD
     &         -(ONE+TWO*R)*(TWO-BETA*ACOS(ONE-ONE/(TWO*R)))
      ELSE
         BETA=SQRT(ONE-FOUR*R)
         HWUAER=THIRD
     &         -(ONE+TWO*R)*(TWO+BETA*LOG(ABS((BETA-ONE)/(BETA+ONE))))
      ENDIF
      RETURN
      END
CDECK  ID>, HWUALF.
*CMZ :-        -15/07/92  14.08.45  by  Mike Seymour
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      FUNCTION HWUALF(IOPT,SCALE)
C-----------------------------------------------------------------------
C     STRONG COUPLING CONSTANT
C     IOPT.EQ.0  INITIALIZES
C         .EQ.1  TWO-LOOP, FLAVOUR THRESHOLDS
C         .EQ.2  RATIO OF ABOVE TO ONE-LOOP
C                WITH 5-FLAVOUR BETA, LAMBDA=QCDL3
C         .EQ.3  ONE-LOOP WITH 5-FLAVOUR BETA, LAMBDA=QCDL3
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWUALF,SCALE,KAFAC,B3,B4,B5,B6,C3,C4,C5,C6,C35,
     & C45,C65,D35,RHO,RAT,RLF,DRH,EPS
      INTEGER IOPT,ITN
      SAVE B3,B4,B5,B6,C3,C4,C5,C6,C35,C45,C65,D35
      DATA EPS/1.D-6/
      IF (IOPT.EQ.0) THEN
C---INITIALIZE CONSTANTS
        CAFAC=FLOAT(NCOLO)
        CFFAC=FLOAT(NCOLO**2-1)/(2.*CAFAC)
        B3=((11.*CAFAC)- 6.)/(12.*PIFAC)
        B4=((11.*CAFAC)- 8.)/(12.*PIFAC)
        B5=((11.*CAFAC)-10.)/(12.*PIFAC)
        B6=((11.*CAFAC)-12.)/(12.*PIFAC)
        BETAF=6.*PIFAC*B5
        C3=((17.*CAFAC**2)-(5.*CAFAC+3.*CFFAC)*3.)/(24.*PIFAC**2)/B3**2
        C4=((17.*CAFAC**2)-(5.*CAFAC+3.*CFFAC)*4.)/(24.*PIFAC**2)/B4**2
        C5=((17.*CAFAC**2)-(5.*CAFAC+3.*CFFAC)*5.)/(24.*PIFAC**2)/B5**2
        C6=((17.*CAFAC**2)-(5.*CAFAC+3.*CFFAC)*6.)/(24.*PIFAC**2)/B6**2
        KAFAC=CAFAC*(67./18.-PIFAC**2/6.)-25./9.
C---QCDLAM IS 5-FLAVOUR LAMBDA-MS-BAR AT LARGE X OR Z
C---QCDL5  IS 5-FLAVOUR LAMBDA-MC
        QCDL5=QCDLAM*EXP(KAFAC/(4.*PIFAC*B5))/SQRT(2.D0)
C---COMPUTE THRESHOLD MATCHING
        RHO=2.*LOG(RMASS(6)/QCDL5)
        RAT=LOG(RHO)/RHO
        C65=(B5/(1.-C5*RAT)-B6/(1.-C6*RAT))*RHO
        RHO=2.*LOG(RMASS(5)/QCDL5)
        RAT=LOG(RHO)/RHO
        C45=(B5/(1.-C5*RAT)-B4/(1.-C4*RAT))*RHO
        RHO=2.*LOG(RMASS(4)/QCDL5)
        RAT=LOG(RHO)/RHO
        C35=(B4/(1.-C4*RAT)-B3/(1.-C3*RAT))*RHO+C45
C---FIND QCDL3
        D35=-1./(B3*C35)
        DO 10 ITN=1,100
          RAT=LOG(D35)/D35
          RLF=B3*D35/(1.-C3*RAT)
          DRH=B3*(RLF+C35)*D35**2/((1.-2.*C3*RAT+C3/D35)*RLF**2)
          D35=D35-DRH
          IF (ABS(DRH).LT.EPS*D35) GOTO 20
   10   CONTINUE
   20   QCDL3=QCDL5*EXP(0.5*D35)
      ENDIF
      IF (SCALE.LE.QCDL5) CALL HWWARN('HWUALF',51,*999)
      RHO=2.*LOG(SCALE/QCDL5)
      IF (IOPT.EQ.3) THEN
        IF (RHO.LE.D35) CALL HWWARN('HWUALF',52,*999)
        HWUALF=1./(B5*(RHO-D35))
        RETURN
      ENDIF
      RAT=LOG(RHO)/RHO
      IF (SCALE.GT.RMASS(6)) THEN
        RLF=B6*RHO/(1.-C6*RAT)+C65
      ELSEIF (SCALE.GT.RMASS(5)) THEN
        RLF=B5*RHO/(1.-C5*RAT)
      ELSEIF (SCALE.GT.RMASS(4)) THEN
        RLF=B4*RHO/(1.-C4*RAT)+C45
      ELSE
        RLF=B3*RHO/(1.-C3*RAT)+C35
      ENDIF
      IF (RLF.LE.ZERO) CALL HWWARN('HWUALF',53,*999)
      IF (IOPT.EQ.1) THEN
        HWUALF=1./RLF
      ELSE
        HWUALF=B5*(RHO-D35)/RLF
        IF (HWUALF.GT.1.) CALL HWWARN('HWUALF',54,*999)
      ENDIF
      RETURN
 999  HWUALF=ZERO
      END
CDECK  ID>, HWUANT.
*CMZ :-        -
*-- Author :    Ian Knowles
C-----------------------------------------------------------------------
      FUNCTION HWUANT(IPART)
C-----------------------------------------------------------------------
C     Returns the antiparticle of IPART; uses HERWIG numbering
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      INTEGER HWUANT,IPART,IPDG,IANTI,OLDERR
      CHARACTER*8 CDUM
      OLDERR=IERROR
      IPDG=IDPDG(IPART)
      IF (IPDG.EQ. 9.OR.IPDG.EQ.21.OR.IPDG.EQ.22.OR.IPDG.EQ.23.OR.
     &    IPDG.EQ.25.OR.IPDG.EQ.32.OR.IPDG.EQ.91.OR.IPDG.EQ.130.OR.
     &    IPDG.EQ.310.OR.(FLOAT(INT(RSPIN(IPART))).EQ.RSPIN(IPART).AND.
     &                    MOD(IPDG/100,10).EQ.MOD(IPDG/10,10))) THEN
C Self-conjugate boson
        IANTI=IPART
      ELSEIF(IPART.EQ.211.OR.IPART.EQ.212) THEN
        IANTI=IPART+6
      ELSEIF(IPART.EQ.217.OR.IPART.EQ.218) THEN
        IANTI=IPART-6
      ELSE
        CALL HWUIDT(1,-IPDG,IANTI,CDUM)
      ENDIF
      IF (IANTI.EQ.20) WRITE(6,10) RNAME(IPART)
  10  FORMAT(1X,A8,' has no antiparticle')
      HWUANT=IANTI
      IERROR=OLDERR
      END
CDECK  ID>, HWUBPR.
*CMZ :-        -26/04/91  10.18.58  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWUBPR
C-----------------------------------------------------------------------
C     PRINTS OUT DATA ON PARTON SHOWER
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      INTEGER I,J
      IF (PRVTX) THEN
        WRITE(6,10) INHAD,XFACT
  10    FORMAT(///10X,'DATA ON LAST PARTON SHOWER:   INHAD =',I3,
     &  '    XFACT =',E11.3//'  IPAR ID     TM  DA1 CMO AMO CDA',
     &  ' ADA  P-X     P-Y     P-Z   ENERGY    MASS',
     &  '   V-X        V-Y        V-Z        V-C*T')
        DO 20 J=1,NPAR
  20    WRITE(6,30) J,RNAME(ABS(IDPAR(J))),TMPAR(J),JDAPAR(1,J),
     &   (JCOPAR(I,J),I=1,4),(PPAR(I,J),I=1,5),(VPAR(I,J),I=1,4)
  30    FORMAT(I5,1X,A8,L2,5I4,F7.2,4F8.2,4E11.4)
      ELSE
        WRITE(6,40) INHAD,XFACT
  40    FORMAT(///10X,'DATA ON LAST PARTON SHOWER:   INHAD =',I3,
     &  '    XFACT =',E11.3//'  IPAR ID     TM  DA1 CMO AMO CDA',
     &  ' ADA  P-X     P-Y     P-Z   ENERGY    MASS')
        DO 50 J=1,NPAR
  50    WRITE(6,60) J,RNAME(ABS(IDPAR(J))),TMPAR(J),JDAPAR(1,J),
     &   (JCOPAR(I,J),I=1,4),(PPAR(I,J),I=1,5)
  60    FORMAT(I5,1X,A8,L2,5I4,F7.2,4F8.2)
      ENDIF
      END
CDECK  ID>, HWUBST.
*CMZ :-        -18/10/93  10.21.56  by  Mike Seymour
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HWUBST(IOPT)
C-----------------------------------------------------------------------
C     BOOST THE ENTIRE EVENT RECORD TO (IOPT=1) OR FROM (IOPT=0) ITS
C     CENTRE-OF-MASS FRAME, WITH INCOMING HADRONS ON Z-AXIS
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION PBOOST(5),RBOOST(3,3)
      INTEGER IOPT,IHEP,BOOSTD,IHAD
      SAVE BOOSTD,PBOOST,RBOOST
      DATA BOOSTD/-1/
      IF (IERROR.NE.0) RETURN
      IF (IOPT.EQ.1) THEN
C---FIND FIRST INCOMING HADRON
        IHAD=1
        IF (JDAHEP(1,IHAD).NE.0) IHAD=JDAHEP(1,IHAD)
C---IF WE'RE ALREADY IN THE RIGHT FRAME, DON'T DO ANYTHING
        IF (PHEP(1,3)**2+PHEP(2,3)**2+PHEP(3,3)**2.EQ.0 .AND.
     &       PHEP(1,IHAD)**2+PHEP(2,IHAD)**2.EQ.0) RETURN
C---FIND AND APPLY BOOST
        CALL HWVEQU(5,PHEP(1,3),PBOOST)
        DO 100 IHEP=1,NHEP
          CALL HWULOF(PBOOST,PHEP(1,IHEP),PHEP(1,IHEP))
          CALL HWULOF(PBOOST,VHEP(1,IHEP),VHEP(1,IHEP))
 100    CONTINUE
        CALL HWULOF(PBOOST,VTXPIP,VTXPIP)
C---FIND AND APPLY ROTATION TO PUT IT ON Z-AXIS
        CALL HWUROT(PHEP(1,IHAD),ONE,ZERO,RBOOST)
        DO 110 IHEP=1,NHEP
          CALL HWUROF(RBOOST,PHEP(1,IHEP),PHEP(1,IHEP))
          CALL HWUROF(RBOOST,VHEP(1,IHEP),VHEP(1,IHEP))
 110    CONTINUE
        CALL HWUROF(RBOOST,VTXPIP,VTXPIP)
C---ENSURE THAT WE ONLY EVER UNBOOST THE SAME EVENT THAT WE BOOSTED
C   (BEARING IN MIND THAT NWGTS IS UPDATED AFTER GENERATING THE WEIGHT)
        BOOSTD=NWGTS+1
      ELSEIF (IOPT.EQ.0) THEN
        IF (BOOSTD.NE.NWGTS) RETURN
C---UNDO ROTATION AND BOOST
        DO 200 IHEP=1,NHEP
          CALL HWUROB(RBOOST,PHEP(1,IHEP),PHEP(1,IHEP))
          CALL HWULOB(PBOOST,PHEP(1,IHEP),PHEP(1,IHEP))
          CALL HWUROB(RBOOST,VHEP(1,IHEP),VHEP(1,IHEP))
          CALL HWULB4(PBOOST,VHEP(1,IHEP),VHEP(1,IHEP))
 200    CONTINUE
      ENDIF
      END
CDECK  ID>, HWUCFF.
*CMZ :-        -23/08/94  13.22.29  by  Mike Seymour
*-- Author :    Bryan Webber and Ian Knowles
C-----------------------------------------------------------------------
      SUBROUTINE HWUCFF(I,J,QSQ,CLF)
C-----------------------------------------------------------------------
C     Calculates basic coefficients in cross-section formula for
C     ffbar --> f'fbar', at virtuality QSQ, I labels initial, J
C     labels final fermion; type given as:
C        I,J= 1- 6: d,u,s,c,b,t
C           =11-16: e,nu_e,mu,nu_mu,tau,nu_tau
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION QSQ,CLF(7),POL1,POL2,QIF,VI,AI,VF,AF,PG,DQM,PMW,
     & DEN,XRE,XIM,XSQ,VI2,AI2,VF2,AF2,PG2,PG12,DQM2,PMW2,DEN2,XRE2,
     & XIM2,XSQ2,XRE12,XIM12
      INTEGER I,J
C Longitudinal Polarisation factors
      POL1=1.-EPOLN(3)*PPOLN(3)
      POL2=PPOLN(3)-EPOLN(3)
C Standard model couplings
      QIF=QFCH(I)*QFCH(J)
      VI=VFCH(I,1)
      AI=AFCH(I,1)
      VF=VFCH(J,1)
      AF=AFCH(J,1)
      PG=POL1*(VI**2+AI**2)+POL2*2.*VI*AI
C Z propagator factors
      DQM=QSQ-RMASS(200)**2
      PMW=GAMZ*RMASS(200)
      DEN=QSQ/(DQM**2+PMW**2)
      XRE=DEN*DQM
      XIM=DEN*PMW
      XSQ=DEN*QSQ
C Calculate cross-section coefficients
      CLF(1)=POL1*QIF**2+XRE*2.*QIF*(POL1*VI+POL2*AI)*VF
     &      +XSQ*PG*(VF**2+AF**2)
      CLF(2)=CLF(1)-2.*XSQ*PG*AF**2
      CLF(3)=2.*(XRE*QIF*(POL1*AI+POL2*VI)*AF
     &      +XSQ*(POL1*2.*VI*AI+POL2*(VI**2+AI**2))*VF*AF)
      IF (TPOL) THEN
         CLF(4)=QIF**2+XRE*2.*QIF*VI*VF+XSQ*(VI**2-AI**2)*(VF**2+AF**2)
         CLF(5)=CLF(4)-2.*XSQ*(VI**2-AI**2)*AF**2
         CLF(6)=XIM*2.*QIF*AI*VF
         CLF(7)=CLF(6)
      ENDIF
      IF (ZPRIME) THEN
C Z' couplings:
         VI2=VFCH(I,2)
         AI2=AFCH(I,2)
         VF2=VFCH(J,2)
         AF2=AFCH(J,2)
         PG2=POL1*(VI2**2+AI2**2)+POL2*2.*VI2*AI2
         PG12=POL1*(VI*VI2+AI*AI2)+POL2*(VI*AI2+AI+VI2)
C Z' propagator factors
         DQM2=QSQ-RMASS(202)**2
         PMW2=RMASS(202)*GAMZP
         DEN2=QSQ/(DQM2**2+PMW2**2)
         XRE2=DEN2*DQM2
         XIM2=DEN2*PMW2
         XSQ2=DEN2*QSQ
         XRE12=DEN*DEN2*(DQM*DQM2+PMW*PMW2)
         XIM12=DEN*DEN2*(DQM*PMW2-DQM2*PMW)
C Additional contributions to cross-section coefficients
         CLF(1)=CLF(1)+XRE2*2.*QIF*(POL1*VI2+POL2*AI2)*VF2
     &    +XSQ2*PG2*(VF2**2+AF2**2)+XRE12*2.*PG12*(VF*VF2+AF*AF2)
         CLF(2)=CLF(1)-2.*(XSQ2*PG2*AF2**2+XRE12*2.*PG12*AF*AF2)
         CLF(3)=CLF(3)+2.*(XRE2*QIF*(POL1*AI2+POL2*VI2)*AF2
     &    +XSQ2*(POL1*2.*VI2*AI2+POL2*(VI2**2+AI2**2))*VF2*AF2
     &    +XRE12*(POL1*(VI*AI2+AI*VI2)+POL1*(VI*VI2+AI*AI2))
     &    *(VF*VF2+AF*AF2))
         IF (TPOL) THEN
            CLF(4)=CLF(4)+XRE2*2.*QIF*VI2*VF2
     &       +XSQ2*(VI2**2-AI2**2)*(VF2**2+AF2**2)
     &       +XRE12*2.*(VI*VI2-AI*AI2)*(VF*VF2+AF*AF2)
            CLF(5)=CLF(4)-2*(XSQ2*(VI2**2-AI2**2)*AF2**2
     &       +XRE12*2.*(VI*VI2-AI*AI2)*AF*AF2)
            CLF(6)=CLF(6)+2.*(XIM2*QIF*AI2*VF2
     &       -XIM12*(VI*AI2-AI*VI2)*(VF*VF2+AF*AF2))
            CLF(7)=CLF(6)+4.*XIM12*(VI*AI2-AI*AI2)*AF*AF2
         ENDIF
      ENDIF
      RETURN
      END
CDECK  ID>, HWUCI2.
*CMZ :-        -23/08/94  13.22.29  by  Mike Seymour
*-- Author :    Ulrich Baur & Nigel Glover, adapted by Ian Knowles
C-----------------------------------------------------------------------
      FUNCTION HWUCI2(A,B,Y0)
C-----------------------------------------------------------------------
C     Integral  LOG(A-EPSI-BY(1-Y))/(Y-Y0)
C-----------------------------------------------------------------------
      IMPLICIT NONE
      DOUBLE COMPLEX HWUCI2,HWULI2,EPSI,Y1,Y2,Z1,Z2,Z3,Z4
      DOUBLE PRECISION A,B,Y0,ZERO,ONE,FOUR,HALF
      EXTERNAL HWULI2
      COMMON/SMALL/EPSI
      PARAMETER (ZERO=0.D0, ONE =1.D0, FOUR= 4.D0, HALF=0.5D0)
      IF(B.EQ.ZERO)THEN
         HWUCI2=CMPLX(ZERO,ZERO)
      ELSE
         Y1=HALF*(ONE+SQRT(ONE-FOUR*(A+EPSI)/B))
         Y2=ONE-Y1
         Z1=Y0/(Y0-Y1)
         Z2=(Y0-ONE)/(Y0-Y1)
         Z3=Y0/(Y0-Y2)
         Z4=(Y0-ONE)/(Y0-Y2)
         HWUCI2=HWULI2(Z1)-HWULI2(Z2)+HWULI2(Z3)-HWULI2(Z4)
      ENDIF
      RETURN
      END
CDECK  ID>, HWUDAT.
*CMZ :-        -26/04/91  10.18.58  by  Bryan Webber
*-- Author :    Ian Knowles & Bryan Webber
C-----------------------------------------------------------------------
      BLOCK DATA HWUDAT
C-----------------------------------------------------------------------
C     Loads common blocks with particle properties data; for particle I:
C        RNAME(I) = Name
C        IDPDG(I) = PDG code
C        IFLAV(I) = HERWIG flavour code
C        ICHRG(I) = Electric charge (|e-|)          (*3 for (di-)quarks)
C        RMASS(I) = Mass (GeV/c^2)
C        RLTIM(I) = Proper life time (s)
C        RSPIN(I) = Spin
C     And stores the particle decay tables: call HWUDPR to print them
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      INTEGER NLAST,NNEXT,NLEFT,I,J
      PARAMETER (NLAST=393,NNEXT=393+1,NLEFT=NMXRES-393)
      DATA NRES/393/
C Don't forget to change the three occurances above as well
      DATA (RNAME(I),IDPDG(I),IFLAV(I),ICHRG(I),RMASS(I),RLTIM(I),
     &      RSPIN(I),I=0,16)/
     & '        ',      0,   0, 0,0.000,0.000D+00,0.0,
     & 'DQRK    ',      1,   0,-1,0.320,0.000D+00,0.5,
     & 'UQRK    ',      2,   0,+2,0.320,0.000D+00,0.5,
     & 'SQRK    ',      3,   0,-1,0.500,0.000D+00,0.5,
     & 'CQRK    ',      4,   0,+2,1.550,0.000D+00,0.5,
     & 'BQRK    ',      5,   0,-1,4.950,0.000D+00,0.5,
     & 'TQRK    ',      6,   0,+2,170.0,0.000D+00,0.5,
     & 'DBAR    ',     -1,   0,+1,0.320,0.000D+00,0.5,
     & 'UBAR    ',     -2,   0,-2,0.320,0.000D+00,0.5,
     & 'SBAR    ',     -3,   0,+1,0.500,0.000D+00,0.5,
     & 'CBAR    ',     -4,   0,-2,1.550,0.000D+00,0.5,
     & 'BBAR    ',     -5,   0,+1,4.950,0.000D+00,0.5,
     & 'TBAR    ',     -6,   0,-2,170.0,0.000D+00,0.5,
     & 'GLUON   ',     21,   0, 0,0.750,0.000D+00,1.0,
     & 'CMF     ',      0,   0, 0,0.000,0.000D+00,0.0,
     & 'HARD    ',      0,   0, 0,0.000,0.000D+00,0.0,
     & 'SOFT    ',      0,   0, 0,0.000,0.000D+00,0.0/
      DATA (RNAME(I),IDPDG(I),IFLAV(I),ICHRG(I),RMASS(I),RLTIM(I),
     &      RSPIN(I),I=17,32)/
     & 'CONE    ',      0,   0, 0,0.000,0.000D+00,0.0,
     & 'HEAVY   ',      0,   0, 0,0.000,0.000D+00,0.0,
     & 'CLUS    ',     91,   0, 0,0.000,0.000D+00,0.0,
     & '****    ',      0,   0, 0,0.000,0.000D+00,0.0,
     & 'PI0     ',    111,  11, 0,0.135,8.400D-17,0.0,
     & 'ETA     ',    221,  33, 0,0.547,0.000D+00,0.0,
     & 'RHO0    ',    113,  11, 0,0.770,0.000D+00,1.0,
     & 'OMEGA   ',    223,  33, 0,0.782,0.000D+00,1.0,
     & 'ETAP    ',    331,  33, 0,0.958,0.000D+00,0.0,
     & 'F_2     ',    225,  33, 0,1.275,0.000D+00,2.0,
     & 'A_10    ',  20113,  11, 0,1.230,0.000D+00,1.0,
     & 'FL_1    ',  20223,  33, 0,1.282,0.000D+00,1.0,
     & 'A_20    ',    115,  11, 0,1.318,0.000D+00,2.0,
     & 'PI-     ',   -211,  12,-1,0.140,2.603D-08,0.0,
     & 'RHO-    ',   -213,  12,-1,0.770,0.000D+00,1.0,
     & 'A_1-    ', -20213,  12,-1,1.230,0.000D+00,1.0/
      DATA (RNAME(I),IDPDG(I),IFLAV(I),ICHRG(I),RMASS(I),RLTIM(I),
     &      RSPIN(I),I=33,48)/
     & 'A_2-    ',   -215,  12,-1,1.318,0.000D+00,2.0,
     & 'K-      ',   -321,  32,-1,0.494,1.237D-08,0.0,
     & 'K*-     ',   -323,  32,-1,0.892,0.000D+00,1.0,
     & 'KH_1-   ', -20323,  32,-1,1.750,0.000D+00,1.0,
     & 'K*_2-   ',   -325,  32,-1,1.425,0.000D+00,2.0,
     & 'PI+     ',    211,  21,+1,0.140,2.603D-08,0.0,
     & 'RHO+    ',    213,  21,+1,0.770,0.000D+00,1.0,
     & 'A_1+    ',  20213,  21,+1,1.230,0.000D+00,1.0,
     & 'A_2+    ',    215,  21,+1,1.318,0.000D+00,2.0,
     & 'KBAR0   ',   -311,  31, 0,0.498,0.000D+00,0.0,
     & 'K*BAR0  ',   -313,  31, 0,0.896,0.000D+00,1.0,
     & 'KH_1BAR0', -20313,  31, 0,1.750,0.000D+00,1.0,
     & 'K*_2BAR0',   -315,  31, 0,1.432,0.000D+00,2.0,
     & 'K+      ',    321,  23,+1,0.494,1.237D-08,0.0,
     & 'K*+     ',    323,  23,+1,0.892,0.000D+00,1.0,
     & 'KH_1+   ',  20323,  23,+1,1.750,0.000D+00,1.0/
      DATA (RNAME(I),IDPDG(I),IFLAV(I),ICHRG(I),RMASS(I),RLTIM(I),
     &      RSPIN(I),I=49,64)/
     & 'K*_2+   ',    325,  23,+1,1.425,0.000D+00,2.0,
     & 'K0      ',    311,  13, 0,0.498,0.000D+00,0.0,
     & 'K*0     ',    313,  13, 0,0.896,0.000D+00,1.0,
     & 'KH_10   ',  20313,  13, 0,1.750,0.000D+00,1.0,
     & 'K*_20   ',    315,  13, 0,1.432,0.000D+00,2.0,
     & '        ',      0,   0, 0,0.000,0.000D+00,0.0,
     & '        ',      0,   0, 0,0.000,0.000D+00,0.0,
     & 'PHI     ',    333,  33, 0,1.019,0.000D+00,1.0,
     & 'FH_1    ',  20333,  33, 0,1.512,0.000D+00,1.0,
     & 'FP_2    ',    335,  33, 0,1.525,0.000D+00,2.0,
     & 'GAMMA   ',     22,   0, 0,0.000,1.000D+30,1.0,
     & 'K_S0    ',    310,   0, 0,0.498,8.926D-11,0.0,
     & 'K_L0    ',    130,   0, 0,0.498,5.170D-08,0.0,
     & '        ',      0,   0, 0,0.000,0.000D+00,0.0,
     & '        ',      0,   0, 0,0.000,0.000D+00,0.0,
     & '        ',      0,   0, 0,0.000,0.000D+00,0.0/
      DATA (RNAME(I),IDPDG(I),IFLAV(I),ICHRG(I),RMASS(I),RLTIM(I),
     &      RSPIN(I),I=65,80)/
     & '        ',      0,   0, 0,0.000,0.000D+00,0.0,
     & '        ',      0,   0, 0,0.000,0.000D+00,0.0,
     & '        ',      0,   0, 0,0.000,0.000D+00,0.0,
     & '        ',      0,   0, 0,0.000,0.000D+00,0.0,
     & '        ',      0,   0, 0,0.000,0.000D+00,0.0,
     & '        ',      0,   0, 0,0.000,0.000D+00,0.0,
     & 'REMG    ',   9998,   0, 0,0.000,0.000D+00,0.0,
     & 'REMN    ',   9999,   0, 0,0.000,0.000D+00,0.0,
     & 'P       ',   2212, 122,+1,0.938,1.000D+30,0.5,
     & 'DELTA+  ',   2214, 122,+1,1.232,0.000D+00,1.5,
     & 'N       ',   2112, 112, 0,0.940,8.870D+02,0.5,
     & 'DELTA0  ',   2114, 112, 0,1.232,0.000D+00,1.5,
     & 'DELTA-  ',   1114, 111,-1,1.232,0.000D+00,1.5,
     & 'LAMBDA  ',   3122, 123, 0,1.116,2.632D-10,0.5,
     & 'SIGMA0  ',   3212, 123, 0,1.192,7.400D-20,0.5,
     & 'SIGMA*0 ',   3214, 123, 0,1.384,0.000D+00,1.5/
      DATA (RNAME(I),IDPDG(I),IFLAV(I),ICHRG(I),RMASS(I),RLTIM(I),
     &      RSPIN(I),I=81,96)/
     & 'SIGMA-  ',   3112, 113,-1,1.197,1.479D-10,0.5,
     & 'SIGMA*- ',   3114, 113,-1,1.387,0.000D+00,1.5,
     & 'XI-     ',   3312, 133,-1,1.321,1.639D-10,0.5,
     & 'XI*-    ',   3314, 133,-1,1.535,0.000D+00,1.5,
     & 'DELTA++ ',   2224, 222,+2,1.232,0.000D+00,1.5,
     & 'SIGMA+  ',   3222, 223,+1,1.189,7.990D-11,0.5,
     & 'SIGMA*+ ',   3224, 223,+1,1.383,0.000D+00,1.5,
     & 'XI0     ',   3322, 233, 0,1.315,2.900D-10,0.5,
     & 'XI*0    ',   3324, 233, 0,1.532,0.000D+00,1.5,
     & 'OMEGA-  ',   3334, 333,-1,1.672,8.220D-11,1.5,
     & 'PBAR    ',  -2212,-122,-1,0.938,1.000D+30,0.5,
     & 'DELTABR-',  -2214,-122,-1,1.232,0.000D+00,1.5,
     & 'NBAR    ',  -2112,-112, 0,0.940,8.870D+02,0.5,
     & 'DELTABR0',  -2114,-112, 0,1.232,0.000D+00,1.5,
     & 'DELTABR+',  -1114,-111,+1,1.232,0.000D+00,1.5,
     & 'LAMBDABR',  -3122,-123, 0,1.116,2.632D-10,0.5/
      DATA (RNAME(I),IDPDG(I),IFLAV(I),ICHRG(I),RMASS(I),RLTIM(I),
     &      RSPIN(I),I=97,112)/
     & 'SIGMABR0',  -3212,-123, 0,1.192,7.400D-20,0.5,
     & 'SGMA*BR0',  -3214,-123, 0,1.384,0.000D+00,1.5,
     & 'SIGMABR+',  -3112,-113,+1,1.197,1.479D-10,0.5,
     & 'SGMA*BR+',  -3114,-113,+1,1.387,0.000D+00,1.5,
     & 'XIBAR+  ',  -3312,-133,+1,1.321,1.639D-10,0.5,
     & 'XI*BAR+ ',  -3314,-133,+1,1.535,0.000D+00,1.5,
     & 'DLTABR--',  -2224,-222,-2,1.232,0.000D+00,1.5,
     & 'SIGMABR-',  -3222,-223,-1,1.189,7.990D-11,0.5,
     & 'SGMA*BR-',  -3224,-223,-1,1.383,0.000D+00,1.5,
     & 'XIBAR0  ',  -3322,-233, 0,1.315,2.900D-10,0.5,
     & 'XI*BAR  ',  -3324,-233, 0,1.532,0.000D+00,1.5,
     & 'OMEGABR+',  -3334,-333,+1,1.672,8.220D-11,1.5,
     & 'UU      ',   2203,   0,+4,0.640,0.000D+00,0.0,
     & 'UD      ',   2101,   0,+1,0.640,0.000D+00,0.0,
     & 'DD      ',   1103,   0,-2,0.640,0.000D+00,0.0,
     & 'US      ',   3201,   0,+1,0.820,0.000D+00,0.0/
      DATA (RNAME(I),IDPDG(I),IFLAV(I),ICHRG(I),RMASS(I),RLTIM(I),
     &      RSPIN(I),I=113,128)/
     & 'DS      ',   3101,   0,-2,0.820,0.000D+00,0.0,
     & 'SS      ',   3303,   0,-2,1.000,0.000D+00,0.0,
     & 'UBARUBAR',  -2203,   0,-4,0.640,0.000D+00,0.0,
     & 'UBARDBAR',  -2101,   0,-1,0.640,0.000D+00,0.0,
     & 'DBARDBAR',  -1103,   0,+2,0.640,0.000D+00,0.0,
     & 'UBARSBAR',  -3201,   0,-1,0.820,0.000D+00,0.0,
     & 'DBARSBAR',  -3101,   0,+2,0.820,0.000D+00,0.0,
     & 'SBARSBAR',  -3303,   0,+2,1.000,0.000D+00,0.0,
     & 'E-      ',     11,   0,-1,.0005,1.000D+30,0.5,
     & 'NU_E    ',     12,   0, 0,0.000,1.000D+30,0.5,
     & 'MU-     ',     13,   0,-1,0.106,2.197D-06,0.5,
     & 'NU_MU   ',     14,   0, 0,0.000,1.000D+30,0.5,
     & 'TAU-    ',     15,   0,-1,1.777,2.916D-13,0.5,
     & 'NU_TAU  ',     16,   0, 0,0.000,1.000D+30,0.5,
     & 'E+      ',    -11,   0,+1,.0005,1.000D+30,0.5,
     & 'NU_EBAR ',    -12,   0, 0,0.000,1.000D+30,0.5/
      DATA (RNAME(I),IDPDG(I),IFLAV(I),ICHRG(I),RMASS(I),RLTIM(I),
     &      RSPIN(I),I=129,144)/
     & 'MU+     ',    -13,   0,+1,0.106,2.197D-06,0.5,
     & 'NU_MUBAR',    -14,   0, 0,0.000,1.000D+30,0.5,
     & 'TAU+    ',    -15,   0,+1,1.777,2.916D-13,0.5,
     & 'NU_TAUBR',    -16,   0, 0,0.000,1.000D+30,0.5,
     & '        ',      0,   0, 0,0.000,0.000D+00,0.0,
     & '        ',      0,   0, 0,0.000,0.000D+00,0.0,
     & '        ',      0,   0, 0,0.000,0.000D+00,0.0,
     & 'D+      ',    411,  41,+1,1.869,1.057D-12,0.0,
     & 'D*+     ',    413,  41,+1,2.010,0.000D+00,1.0,
     & 'DH_1+   ',  20413,  41,+1,2.426,0.000D+00,1.0,
     & 'D*_2+   ',    415,  41,+1,2.456,0.000D+00,2.0,
     & 'D0      ',    421,  42, 0,1.865,4.150D-13,0.0,
     & 'D*0     ',    423,  42, 0,2.007,0.000D+00,1.0,
     & 'DH_10   ',  20423,  42, 0,2.423,0.000D+00,1.0,
     & 'D*_20   ',    425,  42, 0,2.458,0.000D+00,2.0,
     & 'D_S+    ',    431,  43,+1,1.969,4.670D-13,0.0/
      DATA (RNAME(I),IDPDG(I),IFLAV(I),ICHRG(I),RMASS(I),RLTIM(I),
     &      RSPIN(I),I=145,160)/
     & 'D*_S+   ',    433,  43,+1,2.110,0.000D+00,1.0,
     & 'DH_S1+  ',  20433,  43,+1,2.535,0.000D+00,1.0,
     & 'D*_S2+  ',    435,  43,+1,2.573,0.000D+00,2.0,
     & 'SGMA_C++',   4222, 224,+2,2.453,0.000D+00,0.5,
     & 'SGM*_C++',   4224, 224,+2,2.530,0.000D+00,1.5,
     & 'LMBDA_C+',   4122, 124,+1,2.285,2.060D-13,0.5,
     & 'SIGMA_C+',   4212, 124,+1,2.454,0.000D+00,0.5,
     & 'SGMA*_C+',   4214, 124,+1,2.530,0.000D+00,1.5,
     & 'SIGMA_C0',   4112, 114, 0,2.452,0.000D+00,0.5,
     & 'SGMA*_C0',   4114, 114, 0,2.530,0.000D+00,1.5,
     & 'XI_C+   ',   4232, 234,+1,2.466,3.500D-13,0.5,
     & 'XIP_C+  ',   4322, 234,+1,2.575,0.000D+00,0.5,
     & 'XI*_C+  ',   4324, 234,+1,2.639,0.000D+00,1.5,
     & 'XI_C0   ',   4132, 134, 0,2.470,9.800D-14,0.5,
     & 'XIP_C0  ',   4312, 134, 0,2.580,0.000D+00,0.5,
     & 'XI*_C0  ',   4314, 134, 0,2.644,0.000D+00,1.5/
      DATA (RNAME(I),IDPDG(I),IFLAV(I),ICHRG(I),RMASS(I),RLTIM(I),
     &      RSPIN(I),I=161,176)/
     & 'OMEGA_C0',   4332, 334, 0,2.704,6.400D-14,0.5,
     & 'OMGA*_C0',   4334, 334, 0,2.730,0.000D+00,1.5,
     & 'ETA_C   ',    441,  44, 0,2.979,0.000D+00,0.0,
     & 'JPSI    ',    443,  44, 0,3.097,0.000D+00,1.0,
     & 'CHI_C1  ',  10441,  44, 0,3.415,0.000D+00,0.0,
     & 'PSI2S   ', 100443,  44, 0,3.686,0.000D+00,1.0,
     & 'PSID    ',  30443,  44, 0,3.770,0.000D+00,1.0,
     & '        ',      0,   0, 0,0.000,0.000D+00,0.0,
     & '        ',      0,   0, 0,0.000,0.000D+00,0.0,
     & '        ',      0,   0, 0,0.000,0.000D+00,0.0,
     & 'D-      ',   -411,  14,-1,1.869,1.057D-12,0.0,
     & 'D*-     ',   -413,  14,-1,2.010,0.000D+00,1.0,
     & 'DH_1-   ', -20413,  14,-1,2.426,0.000D+00,1.0,
     & 'D*_2-   ',   -415,  14,-1,2.456,0.000D+00,2.0,
     & 'DBAR0   ',   -421,  24, 0,1.865,4.140D-13,0.0,
     & 'D*BAR0  ',   -423,  24, 0,2.007,0.000D+00,1.0/
      DATA (RNAME(I),IDPDG(I),IFLAV(I),ICHRG(I),RMASS(I),RLTIM(I),
     &      RSPIN(I),I=177,192)/
     & 'DH_1BAR0', -20423,  24, 0,2.423,0.000D+00,1.0,
     & 'D*_2BAR0',   -425,  24, 0,2.458,0.000D+00,2.0,
     & 'D_S-    ',   -431,  34,-1,1.969,4.670D-13,0.0,
     & 'D*_S-   ',   -433,  34,-1,2.110,0.000D+00,1.0,
     & 'DH_S1-  ', -20433,  34,-1,2.535,0.000D+00,1.0,
     & 'D*_S2-  ',   -435,  34,-1,2.573,0.000D+00,2.0,
     & 'SGMA_C--',  -4222,-224,-2,2.453,0.000D+00,0.5,
     & 'SGM*_C--',  -4224,-224,-2,2.530,0.000D+00,1.5,
     & 'LMBDA_C-',  -4122,-124,-1,2.285,2.060D-13,0.5,
     & 'SIGMA_C-',  -4212,-124,-1,2.454,0.000D+00,0.5,
     & 'SGMA*_C-',  -4214,-124,-1,2.530,0.000D+00,1.5,
     & 'SGM_CBR0',  -4112,-114, 0,2.452,0.000D+00,0.5,
     & 'SG*_CBR0',  -4114,-114, 0,2.530,0.000D+00,1.5,
     & 'XI_C-   ',  -4232,-234,-1,2.466,3.500D-13,0.5,
     & 'XIP_C-  ',  -4322,-234,-1,2.575,0.000D+00,0.5,
     & 'XI*_C-  ',  -4324,-234,-1,2.639,0.000D+00,1.5/
      DATA (RNAME(I),IDPDG(I),IFLAV(I),ICHRG(I),RMASS(I),RLTIM(I),
     &      RSPIN(I),I=193,208)/
     & 'XI_CBAR0',  -4132,-134, 0,2.470,9.800D-14,0.5,
     & 'XIP_CBR0',  -4312,-134, 0,2.580,0.000D+00,0.5,
     & 'XI*_CBR0',  -4314,-134, 0,2.644,0.000D+00,1.5,
     & 'OMG_CBR0',  -4332,-334, 0,2.704,6.400D-14,0.5,
     & 'OM*_CBR0',  -4334,-334, 0,2.730,0.000D+00,1.5,
     & 'W+      ',     24,   0,+1,80.22,0.000D+00,1.0,
     & 'W-      ',    -24,   0,-1,80.22,0.000D+00,1.0,
     & 'Z0/GAMA*',     23,   0, 0,91.19,0.000D+00,1.0,
     & 'HIGGS   ',     25,   0, 0,150.0,0.000D+00,0.0,
     & 'Z0P     ',     32,   0, 0,500.0,0.000D+00,1.0,
     & '        ',      0,   0, 0,0.000,0.000D+00,0.0,
     & '        ',      0,   0, 0,0.000,0.000D+00,0.0,
     & '        ',      0,   0, 0,0.000,0.000D+00,0.0,
     & '        ',      0,   0, 0,0.000,0.000D+00,0.0,
     & '        ',      0,   0, 0,0.000,0.000D+00,0.0,
     & '        ',      0,   0, 0,0.000,0.000D+00,0.0/
      DATA (RNAME(I),IDPDG(I),IFLAV(I),ICHRG(I),RMASS(I),RLTIM(I),
     &      RSPIN(I),I=209,224)/
     & 'VQRK    ',      7,   0,-1,200.0,0.000D+00,0.5,
     & 'AQRK    ',      8,   0,+2,400.0,0.000D+00,0.5,
     & 'HQRK    ',      7,   0,-1,400.0,0.000D+00,0.5,
     & 'HPQK    ',      8,   0,+2,600.0,0.000D+00,0.5,
     & '        ',      0,   0, 0,0.000,0.000D+00,0.0,
     & '        ',      0,   0, 0,0.000,0.000D+00,0.0,
     & 'VBAR    ',     -7,   0,+1,200.0,0.000D+00,0.5,
     & 'ABAR    ',     -8,   0,-2,400.0,0.000D+00,0.5,
     & 'HBAR    ',     -7,   0,+1,400.0,0.000D+00,0.5,
     & 'HPBR    ',     -8,   0,-2,600.0,0.000D+00,0.5,
     & '        ',      0,   0, 0,0.000,0.000D+00,0.0,
     & '        ',      0,   0, 0,0.000,0.000D+00,0.0,
     & 'B_DBAR0 ',   -511,  51, 0,5.279,1.614D-12,0.0,
     & 'B-      ',   -521,  52,-1,5.278,1.652D-12,0.0,
     & 'B_SBAR0 ',   -531,  53, 0,5.375,1.540D-12,0.0,
     & 'SIGMA_B+',   5222, 225,+1,5.820,1.070D-12,0.5/
      DATA (RNAME(I),IDPDG(I),IFLAV(I),ICHRG(I),RMASS(I),RLTIM(I),
     &      RSPIN(I),I=225,240)/
     & 'LMBDA_B0',   5122, 125, 0,5.641,1.070D-12,0.5,
     & 'SIGMA_B-',   5112, 115,-1,5.820,1.070D-12,0.5,
     & 'XI_B0   ',   5232, 235, 0,5.800,1.070D-12,0.5,
     & 'XI_B-   ',   5132, 135,-1,5.800,1.070D-12,0.5,
     & 'OMEGA_B-',   5332, 335,-1,6.040,1.070D-12,0.5,
     & 'B_C-    ',   -541,  54,-1,6.250,1.000D-12,0.5,
     & 'UPSLON1S',    553,  55, 0,9.460,0.000D+00,1.0,
     & 'T_B-    ',   -651,  56,-1,0.000,0.000D+00,0.0,
     & 'T+      ',    611,  61,+1,0.000,0.000D+00,0.0,
     & 'T0      ',    621,  62, 0,0.000,0.000D+00,0.0,
     & 'T_S+    ',    631,  63,+1,0.000,0.000D+00,0.0,
     & 'SGMA_T++',   6222, 226,+2,0.000,0.000D+00,0.5,
     & 'LMBDA_T0',   6122, 126,+1,0.000,0.000D+00,0.5,
     & 'SIGMA_T0',   6112, 116, 0,0.000,0.000D+00,0.5,
     & 'XI_T+   ',   6232, 236,+1,0.000,0.000D+00,0.5,
     & 'XI_T0   ',   6132, 136, 0,0.000,0.000D+00,0.5/
      DATA (RNAME(I),IDPDG(I),IFLAV(I),ICHRG(I),RMASS(I),RLTIM(I),
     &      RSPIN(I),I=241,256)/
     & 'OMEGA_T0',   6332, 336, 0,0.000,0.000D+00,0.5,
     & 'T_C0    ',    641,  64, 0,0.000,0.000D+00,0.0,
     & 'T_B+    ',    651,  65,+1,0.000,0.000D+00,0.0,
     & 'TOPONIUM',    663,  66, 0,0.000,0.000D+00,1.0,
     & 'B_D0    ',    511,  15, 0,5.279,1.614D-12,0.0,
     & 'B+      ',    521,  25,+1,5.278,1.652D-12,0.0,
     & 'B_S0    ',    531,  35, 0,5.375,1.540D-12,0.0,
     & 'SGM_BBR-',  -5222,-225,-1,5.820,1.070D-12,0.5,
     & 'LMD_BBR0',  -5122,-125, 0,5.641,1.070D-12,0.5,
     & 'SGM_BBR+',  -5112,-115,+1,5.820,1.070D-12,0.5,
     & 'XI_BBAR0',  -5232,-235, 0,5.800,1.070D-12,0.5,
     & 'XI_B+   ',  -5132,-135,+1,5.800,1.070D-12,0.5,
     & 'OMG_BBR+',  -5332,-335,+1,6.040,1.070D-12,0.5,
     & 'B_C+    ',    541,  45,+1,6.250,1.000D-12,0.5,
     & 'T-      ',   -611,  16,-1,0.000,0.000D+00,0.0,
     & 'TBAR0   ',   -621,  26, 0,0.000,0.000D+00,0.0/
      DATA (RNAME(I),IDPDG(I),IFLAV(I),ICHRG(I),RMASS(I),RLTIM(I),
     &      RSPIN(I),I=257,272)/
     & 'T_S-    ',   -631,  36,-1,0.000,0.000D+00,0.0,
     & 'SGMA_T--',  -6222,-226,-2,0.000,0.000D+00,0.5,
     & 'LAMDA_T-',  -6122,-126,-1,0.000,0.000D+00,0.5,
     & 'SGM_TBR0',  -6112,-116, 0,0.000,0.000D+00,0.5,
     & 'XI_T-   ',  -6232,-236,-1,0.000,0.000D+00,0.5,
     & 'XI_TBAR0',  -6132,-136, 0,0.000,0.000D+00,0.5,
     & 'OMG_TBR0',  -6332,-336, 0,0.000,0.000D+00,0.5,
     & 'T_CBAR0 ',   -641,  46, 0,0.000,0.000D+00,0.0,
     & 'B*BAR0  ',   -513,  51, 0,5.325,0.000D+00,1.0,
     & 'B*-     ',   -523,  52,-1,5.325,0.000D+00,1.0,
     & 'B*_SBAR0',   -533,  53, 0,5.422,0.000D+00,1.0,
     & 'BH_1BAR0', -20513,  51, 0,5.760,0.000D+00,1.0,
     & 'BH_1-   ', -20523,  52,-1,5.760,0.000D+00,1.0,
     & 'BH_S1BR0', -20533,  53, 0,5.855,0.000D+00,1.0,
     & 'B*_2BAR0',   -515,  51, 0,5.770,0.000D+00,2.0,
     & 'B*_2-   ',   -525,  52,-1,5.770,0.000D+00,2.0/
      DATA (RNAME(I),IDPDG(I),IFLAV(I),ICHRG(I),RMASS(I),RLTIM(I),
     &      RSPIN(I),I=273,288)/
     & 'B*_S2BR0',   -535,  53, 0,5.865,0.000D+00,2.0,
     & 'B*0     ',    513,  15, 0,5.325,0.000D+00,1.0,
     & 'B*+     ',    523,  25,+1,5.325,0.000D+00,1.0,
     & 'B*_S0   ',    533,  35, 0,5.422,0.000D+00,1.0,
     & 'BH_10   ',  20513,  15, 0,5.760,0.000D+00,1.0,
     & 'BH_1+   ',  20523,  25,+1,5.760,0.000D+00,1.0,
     & 'BH_S10  ',  20533,  35, 0,5.855,0.000D+00,1.0,
     & 'B*_20   ',    515,  15, 0,5.770,0.000D+00,2.0,
     & 'B*_2+   ',    525,  25,+1,5.770,0.000D+00,2.0,
     & 'B*_S20  ',    535,  35, 0,5.865,0.000D+00,2.0,
     & '        ',      0,   0, 0,0.000,0.000D+00,  0,
     & '        ',      0,   0, 0,0.000,0.000D+00,  0,
     & 'B_10    ',  10113,  11, 0,1.231,0.000D+00,1.0,
     & 'B_1+    ',  10213,  21,+1,1.231,0.000D+00,1.0,
     & 'B_1-    ', -10213,  12,-1,1.231,0.000D+00,1.0,
     & 'HL_10   ',  10223,  33, 0,1.170,0.000D+00,1.0/
      DATA (RNAME(I),IDPDG(I),IFLAV(I),ICHRG(I),RMASS(I),RLTIM(I),
     &      RSPIN(I),I=289,304)/
     & 'HH_10   ',  10333,  33, 0,1.395,0.000D+00,1.0,
     & 'A_00    ',  10111,  11, 0,0.996,0.000D+00,0.0,
     & 'A_0+    ',  10211,  21,+1,0.996,0.000D+00,0.0,
     & 'A_0-    ', -10211,  12,-1,0.996,0.000D+00,0.0,
     & 'F0P0    ',  10221,  33, 0,0.996,0.000D+00,0.0,
     & 'FH_00   ',  10331,  33, 0,1.250,0.000D+00,0.0,
     & 'B*_C+   ',    543,  45,+1,6.295,0.000D+00,1.0,
     & 'B*_C-   ',   -543,  54,-1,6.295,0.000D+00,1.0,
     & 'BH_C1+  ',  20543,  45,+1,6.730,0.000D+00,1.0,
     & 'BH_C1-  ', -20543,  54,-1,6.730,0.000D+00,1.0,
     & 'B*_C2+  ',    545,  45,+1,6.740,0.000D+00,2.0,
     & 'B*_C2-  ',   -545,  54,-1,6.740,0.000D+00,2.0,
     & 'H_C     ',  10443,  44, 0,3.526,0.000D+00,1.0,
     & 'CHI_C0  ',  20443,  44, 0,3.415,0.000D+00,0.0,
     & 'CHI_C2  ',    445,  44, 0,3.556,0.000D+00,2.0,
     & 'ETA_B   ',    551,  55, 0,9.000,0.000D+00,0.0/
      DATA (RNAME(I),IDPDG(I),IFLAV(I),ICHRG(I),RMASS(I),RLTIM(I),
     &      RSPIN(I),I=305,320)/
     & 'H_B     ',  10553,  55, 0,9.888,0.000D+00,1.0,
     & 'CHI_B0  ',  10551,  55, 0,9.860,0.000D+00,0.0,
     & 'CHI_B1  ',  20553,  55, 0,9.892,0.000D+00,1.0,
     & 'CHI_B2  ',    555,  55, 0,9.913,0.000D+00,2.0,
     & 'KL_10   ',  10313,  13, 0,1.570,0.000D+00,1.0,
     & 'KL_1+   ',  10323,  23,+1,1.570,0.000D+00,1.0,
     & 'KL_1BAR0', -10313,  31, 0,1.570,0.000D+00,1.0,
     & 'KL_1-   ', -10323,  32,-1,1.570,0.000D+00,1.0,
     & 'DL_1+   ',  10413,  41,+1,2.425,0.000D+00,1.0,
     & 'DL_10   ',  10423,  42, 0,2.423,0.000D+00,1.0,
     & 'DL_S1+  ',  10433,  43,+1,2.535,0.000D+00,1.0,
     & 'DL_1-   ', -10413,  14,-1,2.425,0.000D+00,1.0,
     & 'DL_1BAR0', -10423,  24, 0,2.423,0.000D+00,1.0,
     & 'DL_S1-  ', -10433,  34,-1,2.535,0.000D+00,1.0,
     & 'BL_10   ',  10513,  15, 0,5.760,0.000D+00,1.0,
     & 'BL_1+   ',  10523,  25,+1,5.760,0.000D+00,1.0/
      DATA (RNAME(I),IDPDG(I),IFLAV(I),ICHRG(I),RMASS(I),RLTIM(I),
     &      RSPIN(I),I=321,336)/
     & 'BL_S10  ',  10533,  35, 0,5.855,0.000D+00,1.0,
     & 'BL_C1+  ',  10543,  45,+1,6.730,0.000D+00,1.0,
     & 'BL_1BAR0', -10513,  51, 0,5.760,0.000D+00,1.0,
     & 'BL_1-   ', -10523,  52,-1,5.760,0.000D+00,1.0,
     & 'BL_S1BR0', -10533,  53, 0,5.855,0.000D+00,1.0,
     & 'BL_C1-  ', -10543,  54,-1,6.730,0.000D+00,1.0,
     & 'K*_0+   ',  10321,  23,+1,1.429,0.000D+00,0.0,
     & 'K*_00   ',  10311,  13, 0,1.429,0.000D+00,0.0,
     & 'K*_0BAR0', -10311,  31, 0,1.429,0.000D+00,0.0,
     & 'K*_0-   ', -10321,  32,-1,1.429,0.000D+00,0.0,
     & 'D*_0+   ',  10411,  41,+1,2.423,0.000D+00,0.0,
     & 'D*_00   ',  10421,  42, 0,2.423,0.000D+00,0.0,
     & 'D*_S0+  ',  10431,  43,+1,2.525,0.000D+00,0.0,
     & 'D*_0-   ', -10411,  14,-1,2.423,0.000D+00,0.0,
     & 'D*_0BAR0', -10421,  24, 0,2.423,0.000D+00,0.0,
     & 'D*_S0-  ', -10431,  34,-1,2.525,0.000D+00,0.0/
      DATA (RNAME(I),IDPDG(I),IFLAV(I),ICHRG(I),RMASS(I),RLTIM(I),
     &      RSPIN(I),I=337,352)/
     & 'B*_00   ',  10511,  15, 0,5.760,0.000D+00,0.0,
     & 'B*_0+   ',  10521,  25,+1,5.760,0.000D+00,0.0,
     & 'B*_S00  ',  10531,  35, 0,5.855,0.000D+00,0.0,
     & 'B*_C0+  ',  10541,  45,+1,6.730,0.000D+00,0.0,
     & 'B*_0BAR0', -10511,  51, 0,5.760,0.000D+00,0.0,
     & 'B*_0-   ', -10521,  52,-1,5.760,0.000D+00,0.0,
     & 'B*_S0BR0', -10531,  53, 0,5.855,0.000D+00,0.0,
     & 'B*_C0-  ', -10541,  54,-1,6.730,0.000D+00,0.0,
     & 'SGMA*_B-',   5114, 115,-1,5.840,0.000D+00,1.5,
     & 'SIGMA_B0',   5212, 125, 0,5.820,0.000D+00,0.5,
     & 'SGMA*_B0',   5214, 125, 0,5.840,0.000D+00,1.5,
     & 'SGMA*_B+',   5224, 225,+1,5.840,0.000D+00,1.5,
     & 'XIP_B0  ',   5322, 235, 0,5.945,0.000D+00,0.5,
     & 'XI*_B0  ',   5324, 235, 0,5.945,0.000D+00,1.5,
     & 'XIP_B-  ',   5312, 135,-1,5.945,0.000D+00,0.5,
     & 'XI*_B-  ',   5314, 135,-1,5.945,0.000D+00,1.5/
      DATA (RNAME(I),IDPDG(I),IFLAV(I),ICHRG(I),RMASS(I),RLTIM(I),
     &      RSPIN(I),I=353,368)/
     & '0MGA*_B-',   5334, 335,-1,6.060,0.000D+00,1.5,
     & 'SG*_BBR+',  -5114,-115,+1,5.840,0.000D+00,1.5,
     & 'SGM_BBR0',  -5212,-125, 0,5.820,0.000D+00,0.5,
     & 'SG*_BBR0',  -5214,-125, 0,5.840,0.000D+00,1.5,
     & 'SG*_BBR-',  -5224,-225,-1,5.840,0.000D+00,1.5,
     & 'XIP_BBR0',  -5322,-235, 0,5.945,0.000D+00,0.5,
     & 'XI*_BBR0',  -5324,-235, 0,5.945,0.000D+00,1.5,
     & 'XIP_B+  ',  -5312,-135,+1,5.945,0.000D+00,0.5,
     & 'XI*_B+  ',  -5314,-135,+1,5.945,0.000D+00,1.5,
     & '0MGA*_B+',  -5334,-335,+1,6.060,0.000D+00,1.5,
     & 'KDL_2+  ',  10325,  23,+1,1.773,0.000D+00,2.0,
     & 'KDL_20  ',  10315,  13, 0,1.773,0.000D+00,2.0,
     & 'KDL_2BR0', -10315,  31, 0,1.773,0.000D+00,2.0,
     & 'KDL_2-  ', -10325,  32,-1,1.773,0.000D+00,2.0,
     & 'KD*+    ',  30323,  23,+1,1.714,0.000D+00,1.0,
     & 'KD*0    ',  30313,  13, 0,1.714,0.000D+00,1.0/
      DATA (RNAME(I),IDPDG(I),IFLAV(I),ICHRG(I),RMASS(I),RLTIM(I),
     &      RSPIN(I),I=369,384)/
     & 'KD*BAR0 ', -30313,  31, 0,1.714,0.000D+00,1.0,
     & 'KD*-    ', -30323,  32,-1,1.714,0.000D+00,1.0,
     & 'KDH_2+  ',  20325,  23,+1,1.816,0.000D+00,2.0,
     & 'KDH_20  ',  20315,  13, 0,1.816,0.000D+00,2.0,
     & 'KDH_2BR0', -20315,  31, 0,1.816,0.000D+00,2.0,
     & 'KDH_2-  ', -20325,  32,-1,1.816,0.000D+00,2.0,
     & 'KD_3+   ',    327,  23,+1,1.770,0.000D+00,3.0,
     & 'KD_30   ',    317,  13, 0,1.770,0.000D+00,3.0,
     & 'KD_3BAR0',   -317,  31, 0,1.770,0.000D+00,3.0,
     & 'KD_3-   ',   -327,  32,-1,1.770,0.000D+00,3.0,
     & 'PI_2+   ',  10215,  21,+1,1.670,0.000D+00,2.0,
     & 'PI_20   ',  10115,  11, 0,1.670,0.000D+00,2.0,
     & 'PI_2-   ', -10215,  12,-1,1.670,0.000D+00,2.0,
     & 'RHOD+   ',  30213,  21,+1,1.700,0.000D+00,1.0,
     & 'RHOD0   ',  30113,  11, 0,1.700,0.000D+00,1.0,
     & 'RHOD-   ', -30213,  12,-1,1.700,0.000D+00,1.0/
      DATA (RNAME(I),IDPDG(I),IFLAV(I),ICHRG(I),RMASS(I),RLTIM(I),
     &      RSPIN(I),I=385,NLAST)/
     & 'RHO_3+  ',    217,  21,+1,1.691,0.000D+00,3.0,
     & 'RHO_30  ',    117,  11, 0,1.691,0.000D+00,3.0,
     & 'RHO_3-  ',   -217,  12,-1,1.691,0.000D+00,3.0,
     & 'UPSLON2S', 100553,  55, 0,10.023,0.000D+00,1.0,
     & 'CHI2P_B0', 110551,  55, 0,10.232,0.000D+00,0.0,
     & 'CHI2P_B1', 120553,  55, 0,10.255,0.000D+00,1.0,
     & 'CHI2P_B2', 100555,  55, 0,10.269,0.000D+00,2.0,
     & 'UPSLON3S', 200553,  55, 0,10.355,0.000D+00,1.0,
     & 'UPSLON4S', 300553,  55, 0,10.580,0.000D+00,1.0/
C
      DATA (RNAME(I),I=NNEXT,NMXRES)/NLEFT*'        '/
      DATA (IDPDG(I),I=NNEXT,NMXRES)/NLEFT*0/
      DATA (IFLAV(I),I=NNEXT,NMXRES)/NLEFT*0/
      DATA (RMASS(I),I=NNEXT,NMXRES)/NLEFT*0.000/
      DATA (RLTIM(I),I=NNEXT,NMXRES)/NLEFT*0.000D+00/
      DATA (RSPIN(I),I=NNEXT,NMXRES)/NLEFT*0.0/
C
      DATA (RSTAB(I),I=1,NMXRES)/NMXRES*.FALSE./
      DATA DKPSET/.FALSE./
C
      DATA NDKYS/2226/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=   1,  19)/
     &   6,0.340,100,  2,  7,  5,  0,  0,
     &   6,0.330,100,  4,  9,  5,  0,  0,
     &   6,0.110,100,122,127,  5,  0,  0,
     &   6,0.110,100,124,129,  5,  0,  0,
     &   6,0.110,100,126,131,  5,  0,  0,
     &  12,0.340,100,  8,  1, 11,  0,  0,
     &  12,0.330,100, 10,  3, 11,  0,  0,
     &  12,0.110,100,128,121, 11,  0,  0,
     &  12,0.110,100,130,123, 11,  0,  0,
     &  12,0.110,100,132,125, 11,  0,  0,
     &  21,0.988,  0, 59, 59,  0,  0,  0,
     &  21,0.012,  0,127,121, 59,  0,  0,
     &  22,0.388,  0, 59, 59,  0,  0,  0,
     &  22,0.319,  0, 21, 21, 21,  0,  0,
     &  22,0.001,  0, 21, 59, 59,  0,  0,
     &  22,0.236,  0, 38, 30, 21,  0,  0,
     &  22,0.049,  0, 38, 30, 59,  0,  0,
     &  22,0.005,  0,127,121, 59,  0,  0,
     &  22,0.002,  0, 38, 30,127,121,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=  20,  38)/
     &  23,0.989,  0, 38, 30,  0,  0,  0,
     &  23,0.010,  0, 38, 30, 59,  0,  0,
     &  23,0.001,  0, 21, 59,  0,  0,  0,
     &  24,0.888,  0, 38, 30, 21,  0,  0,
     &  24,0.085,  0, 21, 59,  0,  0,  0,
     &  24,0.022,  0, 38, 30,  0,  0,  0,
     &  24,0.001,  0, 22, 59,  0,  0,  0,
     &  24,0.001,  0, 21,127,121,  0,  0,
     &  24,0.003,  0, 38, 30, 21, 21,  0,
     &  25,0.437,  0, 38, 30, 22,  0,  0,
     &  25,0.302,  0, 23, 59,  0,  0,  0,
     &  25,0.208,  0, 21, 21, 22,  0,  0,
     &  25,0.030,  0, 24, 59,  0,  0,  0,
     &  25,0.021,  0, 59, 59,  0,  0,  0,
     &  25,0.002,  0, 21, 21, 21,  0,  0,
     &  26,0.566,  0, 38, 30,  0,  0,  0,
     &  26,0.283,  0, 21, 21,  0,  0,  0,
     &  26,0.069,  0, 38, 30, 21, 21,  0,
     &  26,0.023,  0, 46, 34,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=  39,  57)/
     &  26,0.023,  0, 50, 42,  0,  0,  0,
     &  26,0.028,  0, 38, 38, 30, 30,  0,
     &  26,0.005,  0, 22, 22,  0,  0,  0,
     &  26,0.003,  0, 21, 21, 21, 21,  0,
     &  27,0.499,  0, 39, 30,  0,  0,  0,
     &  27,0.499,  0, 31, 38,  0,  0,  0,
     &  27,0.002,  0, 21, 59, 59,  0,  0,
     &  28,0.148,  0, 21, 21, 38, 30,  0,
     &  28,0.148,  0, 23, 38, 30,  0,  0,
     &  28,0.147,  0,291, 30,  0,  0,  0,
     &  28,0.147,  0,290, 21,  0,  0,  0,
     &  28,0.147,  0,292, 38,  0,  0,  0,
     &  28,0.067,  0, 22, 38, 30,  0,  0,
     &  28,0.033,  0, 22, 21, 21,  0,  0,
     &  28,0.032,  0, 46, 42, 30,  0,  0,
     &  28,0.016,  0, 46, 34, 21,  0,  0,
     &  28,0.016,  0, 50, 42, 21,  0,  0,
     &  28,0.032,  0, 50, 34, 38,  0,  0,
     &  28,0.066,  0, 59, 23,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=  58,  76)/
     &  28,0.001,  0, 56, 59,  0,  0,  0,
     &  29,0.349,  0, 39, 30,  0,  0,  0,
     &  29,0.349,  0, 31, 38,  0,  0,  0,
     &  29,0.144,  0, 22, 21,  0,  0,  0,
     &  29,0.104,  0, 24, 38, 30,  0,  0,
     &  29,0.024,  0, 46, 34,  0,  0,  0,
     &  29,0.024,  0, 50, 42,  0,  0,  0,
     &  29,0.006,  0, 25, 21,  0,  0,  0,
     &  30,1.000,  0,123,130,  0,  0,  0,
     &  31,1.000,  0, 30, 21,  0,  0,  0,
     &  32,0.499,  0, 31, 21,  0,  0,  0,
     &  32,0.499,  0, 23, 30,  0,  0,  0,
     &  32,0.002,  0, 30, 59,  0,  0,  0,
     &  33,0.349,  0, 31, 21,  0,  0,  0,
     &  33,0.349,  0, 23, 30,  0,  0,  0,
     &  33,0.144,  0, 22, 30,  0,  0,  0,
     &  33,0.101,  0, 24, 30, 21,  0,  0,
     &  33,0.048,  0, 50, 34,  0,  0,  0,
     &  33,0.006,  0, 25, 30,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=  77,  95)/
     &  33,0.003,  0, 30, 59,  0,  0,  0,
     &  34,0.629,  0,123,130,  0,  0,  0,
     &  34,0.212,  0, 30, 21,  0,  0,  0,
     &  34,0.056,  0, 30, 38, 30,  0,  0,
     &  34,0.017,  0, 30, 21, 21,  0,  0,
     &  34,0.048,101,121,128, 21,  0,  0,
     &  34,0.032,101,123,130, 21,  0,  0,
     &  34,0.006,  0,123,130, 59,  0,  0,
     &  35,0.666,  0, 42, 30,  0,  0,  0,
     &  35,0.333,  0, 34, 21,  0,  0,  0,
     &  35,0.001,  0, 34, 59,  0,  0,  0,
     &  36,0.627,  0, 43, 30,  0,  0,  0,
     &  36,0.313,  0, 35, 21,  0,  0,  0,
     &  36,0.020,  0, 42, 31,  0,  0,  0,
     &  36,0.010,  0, 34, 23,  0,  0,  0,
     &  36,0.020,  0, 34,294,  0,  0,  0,
     &  36,0.010,  0, 34, 24,  0,  0,  0,
     &  37,0.331,  0, 42, 30,  0,  0,  0,
     &  37,0.166,  0, 34, 21,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=  96, 114)/
     &  37,0.168,  0, 43, 30,  0,  0,  0,
     &  37,0.084,  0, 35, 21,  0,  0,  0,
     &  37,0.087,  0, 35, 38, 30,  0,  0,
     &  37,0.044,  0, 35, 21, 21,  0,  0,
     &  37,0.059,  0, 42, 31,  0,  0,  0,
     &  37,0.029,  0, 34, 23,  0,  0,  0,
     &  37,0.029,  0, 34, 24,  0,  0,  0,
     &  37,0.002,  0, 34, 59,  0,  0,  0,
     &  37,0.001,  0, 34, 22,  0,  0,  0,
     &  38,1.000,  0,129,124,  0,  0,  0,
     &  39,1.000,  0, 38, 21,  0,  0,  0,
     &  40,0.499,  0, 39, 21,  0,  0,  0,
     &  40,0.499,  0, 23, 38,  0,  0,  0,
     &  40,0.002,  0, 38, 59,  0,  0,  0,
     &  41,0.349,  0, 39, 21,  0,  0,  0,
     &  41,0.349,  0, 23, 38,  0,  0,  0,
     &  41,0.144,  0, 22, 38,  0,  0,  0,
     &  41,0.101,  0, 24, 38, 21,  0,  0,
     &  41,0.048,  0, 46, 42,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 115, 133)/
     &  41,0.006,  0, 25, 38,  0,  0,  0,
     &  41,0.003,  0, 38, 59,  0,  0,  0,
     &  42,0.500,  0, 60,  0,  0,  0,  0,
     &  42,0.500,  0, 61,  0,  0,  0,  0,
     &  43,0.665,  0, 34, 38,  0,  0,  0,
     &  43,0.333,  0, 42, 21,  0,  0,  0,
     &  43,0.002,  0, 42, 59,  0,  0,  0,
     &  44,0.627,  0, 35, 38,  0,  0,  0,
     &  44,0.313,  0, 43, 21,  0,  0,  0,
     &  44,0.020,  0, 34, 39,  0,  0,  0,
     &  44,0.010,  0, 42, 23,  0,  0,  0,
     &  44,0.020,  0, 42,294,  0,  0,  0,
     &  44,0.010,  0, 42, 24,  0,  0,  0,
     &  45,0.331,  0, 34, 38,  0,  0,  0,
     &  45,0.166,  0, 42, 21,  0,  0,  0,
     &  45,0.168,  0, 35, 38,  0,  0,  0,
     &  45,0.084,  0, 43, 21,  0,  0,  0,
     &  45,0.089,  0, 42, 38, 30,  0,  0,
     &  45,0.044,  0, 42, 21, 21,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 134, 152)/
     &  45,0.059,  0, 34, 39,  0,  0,  0,
     &  45,0.029,  0, 42, 23,  0,  0,  0,
     &  45,0.029,  0, 42, 24,  0,  0,  0,
     &  45,0.001,  0, 42, 22,  0,  0,  0,
     &  46,0.629,  0,129,124,  0,  0,  0,
     &  46,0.212,  0, 38, 21,  0,  0,  0,
     &  46,0.056,  0, 38, 38, 30,  0,  0,
     &  46,0.017,  0, 38, 21, 21,  0,  0,
     &  46,0.032,101,129,124, 21,  0,  0,
     &  46,0.048,101,127,122, 21,  0,  0,
     &  46,0.006,  0,129,124, 59,  0,  0,
     &  47,0.666,  0, 50, 38,  0,  0,  0,
     &  47,0.333,  0, 46, 21,  0,  0,  0,
     &  47,0.001,  0, 46, 59,  0,  0,  0,
     &  48,0.627,  0, 51, 38,  0,  0,  0,
     &  48,0.313,  0, 47, 21,  0,  0,  0,
     &  48,0.020,  0, 50, 39,  0,  0,  0,
     &  48,0.010,  0, 46, 23,  0,  0,  0,
     &  48,0.020,  0, 46,294,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 153, 171)/
     &  48,0.010,  0, 46, 24,  0,  0,  0,
     &  49,0.331,  0, 50, 38,  0,  0,  0,
     &  49,0.166,  0, 46, 21,  0,  0,  0,
     &  49,0.168,  0, 51, 38,  0,  0,  0,
     &  49,0.084,  0, 47, 21,  0,  0,  0,
     &  49,0.087,  0, 47, 38, 30,  0,  0,
     &  49,0.044,  0, 47, 21, 21,  0,  0,
     &  49,0.059,  0, 50, 39,  0,  0,  0,
     &  49,0.029,  0, 46, 23,  0,  0,  0,
     &  49,0.029,  0, 46, 24,  0,  0,  0,
     &  49,0.002,  0, 46, 59,  0,  0,  0,
     &  49,0.001,  0, 46, 22,  0,  0,  0,
     &  50,0.500,  0, 60,  0,  0,  0,  0,
     &  50,0.500,  0, 61,  0,  0,  0,  0,
     &  51,0.665,  0, 46, 30,  0,  0,  0,
     &  51,0.333,  0, 50, 21,  0,  0,  0,
     &  51,0.002,  0, 50, 59,  0,  0,  0,
     &  52,0.627,  0, 47, 30,  0,  0,  0,
     &  52,0.313,  0, 51, 21,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 172, 190)/
     &  52,0.020,  0, 46, 31,  0,  0,  0,
     &  52,0.010,  0, 50, 23,  0,  0,  0,
     &  52,0.020,  0, 50,294,  0,  0,  0,
     &  52,0.010,  0, 50, 24,  0,  0,  0,
     &  53,0.331,  0, 46, 30,  0,  0,  0,
     &  53,0.166,  0, 50, 21,  0,  0,  0,
     &  53,0.168,  0, 47, 30,  0,  0,  0,
     &  53,0.084,  0, 51, 21,  0,  0,  0,
     &  53,0.089,  0, 50, 38, 30,  0,  0,
     &  53,0.044,  0, 50, 21, 21,  0,  0,
     &  53,0.059,  0, 46, 31,  0,  0,  0,
     &  53,0.029,  0, 50, 23,  0,  0,  0,
     &  53,0.029,  0, 50, 24,  0,  0,  0,
     &  53,0.001,  0, 50, 22,  0,  0,  0,
     &  56,0.490,  0, 46, 34,  0,  0,  0,
     &  56,0.342,  0, 61, 60,  0,  0,  0,
     &  56,0.043,  0, 39, 30,  0,  0,  0,
     &  56,0.043,  0, 23, 21,  0,  0,  0,
     &  56,0.043,  0, 31, 38,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 191, 209)/
     &  56,0.025,  0, 38, 30, 21,  0,  0,
     &  56,0.013,  0, 22, 59,  0,  0,  0,
     &  56,0.001,  0, 21, 59,  0,  0,  0,
     &  57,0.250,  0, 50, 43,  0,  0,  0,
     &  57,0.250,  0, 34, 47,  0,  0,  0,
     &  57,0.250,  0, 42, 51,  0,  0,  0,
     &  57,0.250,  0, 46, 35,  0,  0,  0,
     &  58,0.356,  0, 46, 34,  0,  0,  0,
     &  58,0.356,  0, 50, 42,  0,  0,  0,
     &  58,0.279,  0, 22, 22,  0,  0,  0,
     &  58,0.006,  0, 38, 30,  0,  0,  0,
     &  58,0.003,  0, 21, 21,  0,  0,  0,
     &  60,0.684,  0, 38, 30,  0,  0,  0,
     &  60,0.314,  0, 21, 21,  0,  0,  0,
     &  60,0.002,  0, 38, 30, 59,  0,  0,
     &  61,0.216,  0, 21, 21, 21,  0,  0,
     &  61,0.124,  0, 38, 30, 21,  0,  0,
     &  61,0.135,101,123,130, 38,  0,  0,
     &  61,0.135,101,124,129, 30,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 210, 228)/
     &  61,0.187,101,121,128, 38,  0,  0,
     &  61,0.187,101,122,127, 30,  0,  0,
     &  61,0.006,  0,121,128, 38, 59,  0,
     &  61,0.006,  0,122,127, 30, 59,  0,
     &  61,0.002,  0, 38, 30,  0,  0,  0,
     &  61,0.001,  0, 21, 21,  0,  0,  0,
     &  61,0.001,  0, 59, 59,  0,  0,  0,
     &  74,0.663,  0, 73, 21,  0,  0,  0,
     &  74,0.331,  0, 75, 38,  0,  0,  0,
     &  74,0.006,  0, 73, 59,  0,  0,  0,
     &  75,1.000,101,121,128, 73,  0,  0,
     &  76,0.663,  0, 75, 21,  0,  0,  0,
     &  76,0.331,  0, 73, 30,  0,  0,  0,
     &  76,0.006,  0, 75, 59,  0,  0,  0,
     &  77,1.000,  0, 75, 30,  0,  0,  0,
     &  78,0.638,  0, 73, 30,  0,  0,  0,
     &  78,0.358,  0, 75, 21,  0,  0,  0,
     &  78,0.002,  0, 75, 59,  0,  0,  0,
     &  78,0.001,  0, 73, 30, 59,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 229, 247)/
     &  78,0.001,101,121,128, 73,  0,  0,
     &  79,0.995,  0, 78, 59,  0,  0,  0,
     &  79,0.005,  0, 78,127,121,  0,  0,
     &  80,0.880,  0, 78, 21,  0,  0,  0,
     &  80,0.060,  0, 86, 30,  0,  0,  0,
     &  80,0.060,  0, 81, 38,  0,  0,  0,
     &  81,0.998,  0, 75, 30,  0,  0,  0,
     &  81,0.001,  0, 75, 30, 59,  0,  0,
     &  81,0.001,101,121,128, 75,  0,  0,
     &  82,0.880,  0, 78, 30,  0,  0,  0,
     &  82,0.060,  0, 79, 30,  0,  0,  0,
     &  82,0.060,  0, 81, 21,  0,  0,  0,
     &  83,0.999,  0, 78, 30,  0,  0,  0,
     &  83,0.001,101,121,128, 78,  0,  0,
     &  84,0.667,  0, 88, 30,  0,  0,  0,
     &  84,0.333,  0, 83, 21,  0,  0,  0,
     &  85,1.000,  0, 73, 38,  0,  0,  0,
     &  86,0.516,  0, 73, 21,  0,  0,  0,
     &  86,0.483,  0, 75, 38,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 248, 266)/
     &  86,0.001,  0, 73, 59,  0,  0,  0,
     &  87,0.880,  0, 78, 38,  0,  0,  0,
     &  87,0.060,  0, 86, 21,  0,  0,  0,
     &  87,0.060,  0, 79, 38,  0,  0,  0,
     &  88,0.995,  0, 78, 21,  0,  0,  0,
     &  88,0.001,  0, 78, 59,  0,  0,  0,
     &  88,0.004,  0, 79, 59,  0,  0,  0,
     &  89,0.667,  0, 83, 38,  0,  0,  0,
     &  89,0.333,  0, 88, 21,  0,  0,  0,
     &  90,0.675,  0, 78, 34,  0,  0,  0,
     &  90,0.233,  0, 88, 30,  0,  0,  0,
     &  90,0.086,  0, 83, 21,  0,  0,  0,
     &  90,0.006,101,121,128, 88,  0,  0,
     &  92,0.663,  0, 91, 21,  0,  0,  0,
     &  92,0.331,  0, 93, 30,  0,  0,  0,
     &  92,0.006,  0, 91, 59,  0,  0,  0,
     &  93,1.000,101,127,122, 91,  0,  0,
     &  94,0.663,  0, 93, 21,  0,  0,  0,
     &  94,0.331,  0, 91, 38,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 267, 285)/
     &  94,0.006,  0, 93, 59,  0,  0,  0,
     &  95,1.000,  0, 93, 38,  0,  0,  0,
     &  96,0.638,  0, 91, 38,  0,  0,  0,
     &  96,0.358,  0, 93, 21,  0,  0,  0,
     &  96,0.002,  0, 93, 59,  0,  0,  0,
     &  96,0.001,  0, 91, 38, 59,  0,  0,
     &  96,0.001,101,127,122, 91,  0,  0,
     &  97,0.995,  0, 96, 59,  0,  0,  0,
     &  97,0.005,  0, 96,127,121,  0,  0,
     &  98,0.880,  0, 96, 21,  0,  0,  0,
     &  98,0.060,  0,104, 38,  0,  0,  0,
     &  98,0.060,  0, 99, 30,  0,  0,  0,
     &  99,0.998,  0, 93, 38,  0,  0,  0,
     &  99,0.001,  0, 93, 38, 59,  0,  0,
     &  99,0.001,101,127,122, 93,  0,  0,
     & 100,0.880,  0, 96, 38,  0,  0,  0,
     & 100,0.060,  0, 97, 38,  0,  0,  0,
     & 100,0.060,  0, 99, 21,  0,  0,  0,
     & 101,0.999,  0, 96, 38,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 286, 304)/
     & 101,0.001,101,127,122, 96,  0,  0,
     & 102,0.667,  0,106, 38,  0,  0,  0,
     & 102,0.333,  0,101, 21,  0,  0,  0,
     & 103,1.000,  0, 91, 30,  0,  0,  0,
     & 104,0.516,  0, 91, 21,  0,  0,  0,
     & 104,0.483,  0, 93, 30,  0,  0,  0,
     & 104,0.001,  0, 91, 59,  0,  0,  0,
     & 105,0.880,  0, 96, 30,  0,  0,  0,
     & 105,0.060,  0,104, 21,  0,  0,  0,
     & 105,0.060,  0, 97, 30,  0,  0,  0,
     & 106,0.995,  0, 96, 21,  0,  0,  0,
     & 106,0.001,  0, 96, 59,  0,  0,  0,
     & 106,0.004,  0, 97, 59,  0,  0,  0,
     & 107,0.667,  0,101, 30,  0,  0,  0,
     & 107,0.333,  0,106, 21,  0,  0,  0,
     & 108,0.675,  0, 96, 46,  0,  0,  0,
     & 108,0.233,  0,106, 38,  0,  0,  0,
     & 108,0.086,  0,101, 21,  0,  0,  0,
     & 108,0.006,101,127,122,106,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 305, 323)/
     & 123,0.986,100,121,128,124,  0,  0,
     & 123,0.014,  0,121,128,124, 59,  0,
     & 125,0.178,100,121,128,126,  0,  0,
     & 125,0.171,100,123,130,126,  0,  0,
     & 125,0.002,  0,123,130, 59,126,  0,
     & 125,0.111,  0, 30,126,  0,  0,  0,
     & 125,0.253,  0, 31,126,  0,  0,  0,
     & 125,0.181,  0, 32,126,  0,  0,  0,
     & 125,0.002,  0, 30, 22, 21,126,  0,
     & 125,0.018,  0, 30, 24,126,  0,  0,
     & 125,0.004,  0, 30, 24, 21,126,  0,
     & 125,0.015,  0, 31, 23,126,  0,  0,
     & 125,0.001,  0, 31, 24, 21,126,  0,
     & 125,0.024,  0, 32, 21,126,  0,  0,
     & 125,0.002,  0, 32, 38, 30,126,  0,
     & 125,0.007,  0, 34,126,  0,  0,  0,
     & 125,0.014,  0, 35,126,  0,  0,  0,
     & 125,0.003,  0, 35, 21,126,  0,  0,
     & 125,0.001,  0, 34, 38, 30,126,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 324, 342)/
     & 125,0.004,  0, 30, 43,126,  0,  0,
     & 125,0.003,  0, 34, 50,126,  0,  0,
     & 125,0.003,  0, 34, 51,126,  0,  0,
     & 125,0.003,  0, 30, 50, 42,126,  0,
     & 129,0.986,100,127,122,130,  0,  0,
     & 129,0.014,  0,127,122,130, 59,  0,
     & 131,0.178,100,127,122,132,  0,  0,
     & 131,0.171,100,129,124,132,  0,  0,
     & 131,0.002,  0,129,124, 59,132,  0,
     & 131,0.111,  0, 38,132,  0,  0,  0,
     & 131,0.253,  0, 39,132,  0,  0,  0,
     & 131,0.181,  0, 40,132,  0,  0,  0,
     & 131,0.002,  0, 38, 22, 21,132,  0,
     & 131,0.018,  0, 38, 24,132,  0,  0,
     & 131,0.004,  0, 38, 24, 21,132,  0,
     & 131,0.015,  0, 39, 23,132,  0,  0,
     & 131,0.001,  0, 39, 24, 21,132,  0,
     & 131,0.024,  0, 40, 21,132,  0,  0,
     & 131,0.002,  0, 40, 38, 30,132,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 343, 361)/
     & 131,0.007,  0, 46,132,  0,  0,  0,
     & 131,0.014,  0, 47,132,  0,  0,  0,
     & 131,0.003,  0, 47, 21,132,  0,  0,
     & 131,0.001,  0, 46, 38, 30,132,  0,
     & 131,0.004,  0, 38, 51,132,  0,  0,
     & 131,0.003,  0, 46, 42,132,  0,  0,
     & 131,0.003,  0, 46, 43,132,  0,  0,
     & 131,0.003,  0, 38, 50, 42,132,  0,
     & 136,0.067,101,122,127, 42,  0,  0,
     & 136,0.067,101,124,129, 42,  0,  0,
     & 136,0.048,101,122,127, 43,  0,  0,
     & 136,0.048,101,124,129, 43,  0,  0,
     & 136,0.003,  0, 34, 38,122,127,  0,
     & 136,0.003,  0, 34, 38,124,129,  0,
     & 136,0.006,101,122,127, 21,  0,  0,
     & 136,0.006,101,124,129, 21,  0,  0,
     & 136,0.002,101,122,127, 23,  0,  0,
     & 136,0.002,101,124,129, 23,  0,  0,
     & 136,0.055,  0, 34, 38, 38,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 362, 380)/
     & 136,0.031,  0, 34, 39, 38,  0,  0,
     & 136,0.042,  0, 34, 38, 38, 21, 21,
     & 136,0.002,  0, 34, 38, 38, 38, 31,
     & 136,0.021,  0, 35, 38, 38,  0,  0,
     & 136,0.027,  0, 42, 38,  0,  0,  0,
     & 136,0.066,  0, 42, 39,  0,  0,  0,
     & 136,0.081,  0, 42, 40,  0,  0,  0,
     & 136,0.024,  0, 42, 38, 21,  0,  0,
     & 136,0.004,  0, 42, 38, 23,  0,  0,
     & 136,0.069,  0, 42, 38, 38, 30, 21,
     & 136,0.001,  0, 42, 38, 38, 30, 23,
     & 136,0.022,  0, 43, 38,  0,  0,  0,
     & 136,0.021,  0, 43, 39,  0,  0,  0,
     & 136,0.042,  0, 43, 38, 21,  0,  0,
     & 136,0.008,  0, 43, 38, 23,  0,  0,
     & 136,0.010,  0, 43, 38, 38, 30,  0,
     & 136,0.050,  0,311, 38,  0,  0,  0,
     & 136,0.034,  0,329, 38,  0,  0,  0,
     & 136,0.010,  0,369, 38,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 381, 399)/
     & 136,0.031,  0, 46, 42, 42,  0,  0,
     & 136,0.003,  0, 38, 21,  0,  0,  0,
     & 136,0.001,  0, 38, 23,  0,  0,  0,
     & 136,0.002,  0, 38, 38, 30,  0,  0,
     & 136,0.008,  0, 38, 22,  0,  0,  0,
     & 136,0.001,  0, 38, 38, 38, 30, 30,
     & 136,0.003,  0, 38, 38, 38, 30, 31,
     & 136,0.008,  0, 46, 42,  0,  0,  0,
     & 136,0.005,  0, 46, 43,  0,  0,  0,
     & 136,0.026,  0, 47, 43,  0,  0,  0,
     & 136,0.005,  0, 46, 34, 38,  0,  0,
     & 136,0.007,  0, 38, 56,  0,  0,  0,
     & 136,0.023,  0, 38, 56, 21,  0,  0,
     & 136,0.005,  0, 46, 46, 34,  0,  0,
     & 137,0.683,  0,140, 38,  0,  0,  0,
     & 137,0.306,  0,136, 21,  0,  0,  0,
     & 137,0.011,  0,136, 59,  0,  0,  0,
     & 138,0.667,  0,141, 38,  0,  0,  0,
     & 138,0.333,  0,137, 21,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 400, 418)/
     & 139,0.220,  0,140, 38,  0,  0,  0,
     & 139,0.110,  0,136, 21,  0,  0,  0,
     & 139,0.380,  0,141, 38,  0,  0,  0,
     & 139,0.190,  0,137, 21,  0,  0,  0,
     & 139,0.004,  0,136, 22,  0,  0,  0,
     & 139,0.064,  0,141, 38, 21,  0,  0,
     & 139,0.032,  0,137, 38, 30,  0,  0,
     & 140,0.037,101,122,127, 34,  0,  0,
     & 140,0.037,101,124,129, 34,  0,  0,
     & 140,0.016,101,122,127, 35,  0,  0,
     & 140,0.016,101,124,129, 35,  0,  0,
     & 140,0.013,  0, 34, 21,122,127,  0,
     & 140,0.013,  0, 34, 21,124,129,  0,
     & 140,0.012,  0, 42, 30,122,127,  0,
     & 140,0.012,  0, 42, 30,124,129,  0,
     & 140,0.003,101,122,127, 30,  0,  0,
     & 140,0.003,101,124,129, 30,  0,  0,
     & 140,0.039,  0, 34, 38,  0,  0,  0,
     & 140,0.091,  0, 34, 39,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 419, 437)/
     & 140,0.067,  0, 34, 40,  0,  0,  0,
     & 140,0.004,  0, 34, 38, 21,  0,  0,
     & 140,0.100,  0, 34, 38, 21, 21,  0,
     & 140,0.058,  0, 34, 38, 23,  0,  0,
     & 140,0.020,  0, 34, 38, 24,  0,  0,
     & 140,0.006,  0, 34, 38, 25,  0,  0,
     & 140,0.043,  0, 35, 38,  0,  0,  0,
     & 140,0.035,  0, 35, 39,  0,  0,  0,
     & 140,0.007,  0,312, 38,  0,  0,  0,
     & 140,0.007,  0,330, 38,  0,  0,  0,
     & 140,0.020,  0, 42, 21,  0,  0,  0,
     & 140,0.006,  0, 42, 22,  0,  0,  0,
     & 140,0.009,  0, 42, 23,  0,  0,  0,
     & 140,0.016,  0, 42, 24,  0,  0,  0,
     & 140,0.014,  0, 42, 25,  0,  0,  0,
     & 140,0.003,  0, 42,293,  0,  0,  0,
     & 140,0.007,  0, 42, 56,  0,  0,  0,
     & 140,0.003,  0, 42, 26,  0,  0,  0,
     & 140,0.004,  0, 42,294,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 438, 456)/
     & 140,0.006,  0, 42, 21, 21,  0,  0,
     & 140,0.042,  0, 42, 38, 30, 21,  0,
     & 140,0.004,  0, 42, 38, 38, 30, 30,
     & 140,0.076,  0, 42, 38, 30, 21, 21,
     & 140,0.026,  0, 43, 21,  0,  0,  0,
     & 140,0.014,  0, 43, 22,  0,  0,  0,
     & 140,0.014,  0, 43, 23,  0,  0,  0,
     & 140,0.011,  0, 43, 24,  0,  0,  0,
     & 140,0.018,  0, 43, 38, 30,  0,  0,
     & 140,0.004,  0, 42, 46, 34,  0,  0,
     & 140,0.004,  0, 42, 46, 34, 21,  0,
     & 140,0.005,  0, 42, 42, 50,  0,  0,
     & 140,0.002,  0, 38, 30,  0,  0,  0,
     & 140,0.001,  0, 21, 21,  0,  0,  0,
     & 140,0.008,  0, 38, 30, 21,  0,  0,
     & 140,0.007,  0, 38, 38, 30, 30,  0,
     & 140,0.015,  0, 38, 38, 30, 30, 21,
     & 140,0.004,  0, 46, 34,  0,  0,  0,
     & 140,0.003,  0, 47, 34,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 457, 475)/
     & 140,0.002,  0, 46, 35,  0,  0,  0,
     & 140,0.001,  0, 50, 42,  0,  0,  0,
     & 140,0.002,  0, 51, 43,  0,  0,  0,
     & 140,0.003,  0, 50, 34, 38,  0,  0,
     & 140,0.003,  0, 42, 46, 30,  0,  0,
     & 140,0.001,  0, 46, 34, 38, 30, 21,
     & 140,0.002,  0, 56, 23,  0,  0,  0,
     & 140,0.001,  0, 56, 38, 30,  0,  0,
     & 141,0.636,  0,140, 21,  0,  0,  0,
     & 141,0.364,  0,140, 59,  0,  0,  0,
     & 142,0.667,  0,137, 30,  0,  0,  0,
     & 142,0.333,  0,141, 21,  0,  0,  0,
     & 143,0.220,  0,136, 30,  0,  0,  0,
     & 143,0.110,  0,140, 21,  0,  0,  0,
     & 143,0.380,  0,137, 30,  0,  0,  0,
     & 143,0.190,  0,141, 21,  0,  0,  0,
     & 143,0.004,  0,140, 22,  0,  0,  0,
     & 143,0.064,  0,137, 30, 21,  0,  0,
     & 143,0.032,  0,141, 38, 30,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 476, 494)/
     & 144,0.009,  0,124,129,  0,  0,  0,
     & 144,0.019,101,122,127, 56,  0,  0,
     & 144,0.019,101,124,129, 56,  0,  0,
     & 144,0.025,101,122,127, 22,  0,  0,
     & 144,0.025,101,124,129, 22,  0,  0,
     & 144,0.009,101,122,127, 25,  0,  0,
     & 144,0.009,101,124,129, 25,  0,  0,
     & 144,0.036,  0, 46, 42,  0,  0,  0,
     & 144,0.034,  0, 46, 43,  0,  0,  0,
     & 144,0.007,  0, 46,329,  0,  0,  0,
     & 144,0.043,  0, 47, 42,  0,  0,  0,
     & 144,0.058,  0, 47, 43,  0,  0,  0,
     & 144,0.011,  0, 46, 34, 38,  0,  0,
     & 144,0.055,  0, 46, 34, 38, 21,  0,
     & 144,0.003,  0, 46, 34, 38, 38, 30,
     & 144,0.014,  0, 46, 42, 38, 30,  0,
     & 144,0.017,  0, 50, 34, 38, 38,  0,
     & 144,0.036,  0, 56, 38,  0,  0,  0,
     & 144,0.067,  0, 56, 39,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 495, 513)/
     & 144,0.023,  0, 56, 38, 21,  0,  0,
     & 144,0.018,  0, 56, 38, 38, 30,  0,
     & 144,0.020,  0, 22, 38,  0,  0,  0,
     & 144,0.001,  0, 23, 38,  0,  0,  0,
     & 144,0.009,  0, 24, 38,  0,  0,  0,
     & 144,0.049,  0, 25, 38,  0,  0,  0,
     & 144,0.011,  0,293, 38,  0,  0,  0,
     & 144,0.015,  0, 22, 38, 21,  0,  0,
     & 144,0.016,  0, 25, 38, 21,  0,  0,
     & 144,0.103,  0, 22, 39,  0,  0,  0,
     & 144,0.120,  0, 25, 39,  0,  0,  0,
     & 144,0.010,  0, 38, 38, 30,  0,  0,
     & 144,0.046,  0, 38, 38, 30, 21,  0,
     & 144,0.003,  0, 38, 38, 38, 30, 30,
     & 144,0.042,  0, 38, 30, 30, 38, 39,
     & 144,0.001,  0, 46, 23,  0,  0,  0,
     & 144,0.005,  0, 46, 38, 30,  0,  0,
     & 144,0.001,  0, 46, 56,  0,  0,  0,
     & 144,0.004,  0, 50, 38,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 514, 532)/
     & 144,0.007,  0, 51, 38,  0,  0,  0,
     & 145,0.900,  0,144, 59,  0,  0,  0,
     & 145,0.100,  0,144, 21,  0,  0,  0,
     & 146,0.500,  0,137, 50,  0,  0,  0,
     & 146,0.500,  0,141, 46,  0,  0,  0,
     & 147,0.440,  0,136, 50,  0,  0,  0,
     & 147,0.440,  0,140, 46,  0,  0,  0,
     & 147,0.055,  0,137, 50,  0,  0,  0,
     & 147,0.055,  0,141, 46,  0,  0,  0,
     & 147,0.010,  0,144, 22,  0,  0,  0,
     & 148,1.000,  0,150, 38,  0,  0,  0,
     & 149,1.000,  0,150, 38,  0,  0,  0,
     & 150,0.028,101,122,127, 78,  0,  0,
     & 150,0.010,101,122,127, 80,  0,  0,
     & 150,0.028,101,124,129, 78,  0,  0,
     & 150,0.010,101,124,129, 80,  0,  0,
     & 150,0.026,  0, 73, 42,  0,  0,  0,
     & 150,0.030,  0, 73, 42, 21,  0,  0,
     & 150,0.029,  0, 73, 42, 38, 30,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 533, 551)/
     & 150,0.014,  0, 73, 42, 22,  0,  0,
     & 150,0.020,  0, 73, 43,  0,  0,  0,
     & 150,0.029,  0, 73, 34, 38,  0,  0,
     & 150,0.039,  0, 73, 34, 38, 21,  0,
     & 150,0.002,  0, 73, 34, 38, 38, 30,
     & 150,0.010,  0, 73, 34, 38, 21, 21,
     & 150,0.014,  0, 73, 35, 38,  0,  0,
     & 150,0.010,  0, 74, 42,  0,  0,  0,
     & 150,0.020,  0, 74, 43,  0,  0,  0,
     & 150,0.010,  0, 74, 43, 21,  0,  0,
     & 150,0.007,  0, 85, 34,  0,  0,  0,
     & 150,0.014,  0, 85, 35,  0,  0,  0,
     & 150,0.004,  0, 73,293,  0,  0,  0,
     & 150,0.003,  0, 73, 38, 30,  0,  0,
     & 150,0.003,  0, 73, 38, 30, 38, 30,
     & 150,0.001,  0, 73, 56,  0,  0,  0,
     & 150,0.002,  0, 73, 46, 34,  0,  0,
     & 150,0.010,  0, 78, 38,  0,  0,  0,
     & 150,0.020,  0, 78, 39,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 552, 570)/
     & 150,0.030,  0, 78, 38, 21,  0,  0,
     & 150,0.010,  0, 78, 38, 22,  0,  0,
     & 150,0.020,  0, 78, 38, 24,  0,  0,
     & 150,0.035,  0, 78, 38, 38, 30,  0,
     & 150,0.020,  0, 78, 38, 21, 21,  0,
     & 150,0.010,  0, 78, 38, 38, 30, 21,
     & 150,0.010,  0, 78, 38, 21, 21, 21,
     & 150,0.007,  0, 78, 46, 42,  0,  0,
     & 150,0.011,  0, 79, 38,  0,  0,  0,
     & 150,0.022,  0, 79, 38, 21,  0,  0,
     & 150,0.013,  0, 79, 38, 38, 30,  0,
     & 150,0.010,  0, 79, 38, 21, 21,  0,
     & 150,0.007,  0, 79, 38, 38, 30, 21,
     & 150,0.005,  0, 79, 38, 21, 21, 21,
     & 150,0.005,  0, 80, 38,  0,  0,  0,
     & 150,0.015,  0, 80, 39,  0,  0,  0,
     & 150,0.011,  0, 86, 21,  0,  0,  0,
     & 150,0.007,  0, 86, 22,  0,  0,  0,
     & 150,0.010,  0, 86, 23,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 571, 589)/
     & 150,0.031,  0, 86, 24,  0,  0,  0,
     & 150,0.010,  0, 86, 25,  0,  0,  0,
     & 150,0.004,  0, 86, 56,  0,  0,  0,
     & 150,0.026,  0, 86, 38, 30,  0,  0,
     & 150,0.005,  0, 86, 38, 38, 30, 30,
     & 150,0.005,  0, 86, 38, 30, 21, 21,
     & 150,0.005,  0, 87, 21,  0,  0,  0,
     & 150,0.006,  0, 87, 23,  0,  0,  0,
     & 150,0.004,  0, 86, 46, 34,  0,  0,
     & 150,0.002,  0, 86, 46, 30,  0,  0,
     & 150,0.001,  0, 86, 46, 30, 21,  0,
     & 150,0.016,  0, 81, 38, 38,  0,  0,
     & 150,0.003,  0, 88, 46,  0,  0,  0,
     & 150,0.002,  0, 89, 46,  0,  0,  0,
     & 150,0.003,  0, 83, 46, 38,  0,  0,
     & 150,0.040,  0, 75, 46, 21,  0,  0,
     & 150,0.040,  0, 75, 46, 38, 30,  0,
     & 150,0.020,  0, 75, 46, 21, 21,  0,
     & 150,0.010,  0, 75, 46, 38, 30, 21/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 590, 608)/
     & 150,0.010,  0, 75, 46, 21, 21, 21,
     & 150,0.020,  0, 75, 47, 21,  0,  0,
     & 150,0.040,  0, 75, 42, 38,  0,  0,
     & 150,0.020,  0, 75, 42, 39,  0,  0,
     & 150,0.010,  0, 75, 42, 38, 38, 30,
     & 150,0.010,  0, 75, 42, 38, 21, 21,
     & 150,0.006,  0, 75, 43, 38,  0,  0,
     & 151,1.000,  0,150, 21,  0,  0,  0,
     & 152,1.000,  0,150, 21,  0,  0,  0,
     & 153,1.000,  0,150, 30,  0,  0,  0,
     & 154,1.000,  0,150, 30,  0,  0,  0,
     & 155,0.045,101,122,127, 88,  0,  0,
     & 155,0.005,101,122,127, 89,  0,  0,
     & 155,0.045,101,124,129, 88,  0,  0,
     & 155,0.005,101,124,129, 89,  0,  0,
     & 155,0.021,  0, 86, 42,  0,  0,  0,
     & 155,0.032,  0, 87, 42,  0,  0,  0,
     & 155,0.032,  0, 79, 38, 42,  0,  0,
     & 155,0.045,  0, 86, 43,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 609, 627)/
     & 155,0.065,  0, 87, 43,  0,  0,  0,
     & 155,0.065,  0, 79, 38, 43,  0,  0,
     & 155,0.055,  0, 88, 38,  0,  0,  0,
     & 155,0.160,  0, 88, 39,  0,  0,  0,
     & 155,0.105,  0, 89, 38,  0,  0,  0,
     & 155,0.320,  0, 89, 39,  0,  0,  0,
     & 156,1.000,  0,155, 59,  0,  0,  0,
     & 157,0.667,  0,158, 38,  0,  0,  0,
     & 157,0.333,  0,155, 21,  0,  0,  0,
     & 158,0.045,101,122,127, 83,  0,  0,
     & 158,0.045,101,124,129, 83,  0,  0,
     & 158,0.005,101,122,127, 84,  0,  0,
     & 158,0.005,101,124,129, 84,  0,  0,
     & 158,0.020,  0, 79, 42,  0,  0,  0,
     & 158,0.020,  0, 79, 21, 42,  0,  0,
     & 158,0.020,  0, 80, 42,  0,  0,  0,
     & 158,0.060,  0, 79, 43,  0,  0,  0,
     & 158,0.060,  0, 79, 21, 43,  0,  0,
     & 158,0.060,  0, 80, 43,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 628, 646)/
     & 158,0.020,  0, 86, 34,  0,  0,  0,
     & 158,0.060,  0, 86, 35,  0,  0,  0,
     & 158,0.040,  0, 87, 34,  0,  0,  0,
     & 158,0.120,  0, 87, 35,  0,  0,  0,
     & 158,0.020,  0, 83, 38,  0,  0,  0,
     & 158,0.060,  0, 83, 39,  0,  0,  0,
     & 158,0.040,  0, 84, 38,  0,  0,  0,
     & 158,0.120,  0, 84, 39,  0,  0,  0,
     & 158,0.010,  0, 88, 21,  0,  0,  0,
     & 158,0.030,  0, 88, 23,  0,  0,  0,
     & 158,0.020,  0, 89, 21,  0,  0,  0,
     & 158,0.060,  0, 89, 23,  0,  0,  0,
     & 158,0.030,  0, 88, 56,  0,  0,  0,
     & 158,0.030,  0, 90, 46,  0,  0,  0,
     & 159,1.000,  0,158, 59,  0,  0,  0,
     & 160,0.670,  0,155, 30,  0,  0,  0,
     & 160,0.330,  0,158, 21,  0,  0,  0,
     & 161,0.050,101,122,127, 90,  0,  0,
     & 161,0.050,101,124,129, 90,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 647, 665)/
     & 161,0.075,  0, 88, 42,  0,  0,  0,
     & 161,0.225,  0, 88, 43,  0,  0,  0,
     & 161,0.150,  0, 89, 42,  0,  0,  0,
     & 161,0.450,  0, 89, 43,  0,  0,  0,
     & 162,1.000,  0,161, 59,  0,  0,  0,
     & 163,0.028,  0, 25, 38, 30,  0,  0,
     & 163,0.014,  0, 25, 21, 21,  0,  0,
     & 163,0.018,  0, 39, 31,  0,  0,  0,
     & 163,0.009,  0, 23, 23,  0,  0,  0,
     & 163,0.010,  0, 51, 34, 38,  0,  0,
     & 163,0.010,  0, 43, 47, 30,  0,  0,
     & 163,0.004,  0, 51, 43,  0,  0,  0,
     & 163,0.004,  0, 47, 35,  0,  0,  0,
     & 163,0.007,  0, 56, 56,  0,  0,  0,
     & 163,0.022,  0, 46, 42, 30,  0,  0,
     & 163,0.011,  0, 46, 34, 21,  0,  0,
     & 163,0.011,  0, 50, 42, 21,  0,  0,
     & 163,0.022,  0, 50, 34, 38,  0,  0,
     & 163,0.032,  0, 22, 38, 30,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 666, 684)/
     & 163,0.016,  0, 22, 21, 21,  0,  0,
     & 163,0.020,  0, 38, 30, 46, 34,  0,
     & 163,0.012,  0, 38, 30, 38, 30,  0,
     & 163,0.001,  0, 73, 91,  0,  0,  0,
     & 163,0.001,  0, 59, 59,  0,  0,  0,
     & 163,0.748,  0, 13, 13,  0,  0,  0,
     & 164,0.060,  0,121,127,  0,  0,  0,
     & 164,0.060,  0,123,129,  0,  0,  0,
     & 164,0.004,  0, 39, 30,  0,  0,  0,
     & 164,0.004,  0, 23, 21,  0,  0,  0,
     & 164,0.004,  0, 31, 38,  0,  0,  0,
     & 164,0.003,  0, 41, 31,  0,  0,  0,
     & 164,0.003,  0, 29, 23,  0,  0,  0,
     & 164,0.003,  0, 33, 39,  0,  0,  0,
     & 164,0.009,  0, 24, 38, 38, 30, 30,
     & 164,0.007,  0, 24, 38, 30,  0,  0,
     & 164,0.003,  0, 51, 45,  0,  0,  0,
     & 164,0.003,  0, 43, 53,  0,  0,  0,
     & 164,0.003,  0, 24, 51, 42,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 685, 703)/
     & 164,0.003,  0, 24, 43, 50,  0,  0,
     & 164,0.004,  0, 24, 26,  0,  0,  0,
     & 164,0.003,  0, 46, 35,  0,  0,  0,
     & 164,0.003,  0, 34, 47,  0,  0,  0,
     & 164,0.002,  0, 50, 43,  0,  0,  0,
     & 164,0.002,  0, 42, 51,  0,  0,  0,
     & 164,0.003,  0, 24, 21, 21,  0,  0,
     & 164,0.002,  0,286, 30,  0,  0,  0,
     & 164,0.002,  0,287, 38,  0,  0,  0,
     & 164,0.003,  0, 24, 46, 42, 30,  0,
     & 164,0.003,  0, 24, 34, 50, 38,  0,
     & 164,0.002,  0,285, 21,  0,  0,  0,
     & 164,0.001,  0, 56, 51, 42,  0,  0,
     & 164,0.001,  0, 56, 43, 50,  0,  0,
     & 164,0.001,  0, 24, 50, 42,  0,  0,
     & 164,0.001,  0, 24, 46, 34,  0,  0,
     & 164,0.002,  0, 56, 38, 30, 38, 30,
     & 164,0.002,  0, 85, 91, 30,  0,  0,
     & 164,0.002,  0,103, 73, 38,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 704, 722)/
     & 164,0.002,  0, 24, 22,  0,  0,  0,
     & 164,0.001,  0, 56, 50, 42,  0,  0,
     & 164,0.001,  0, 56, 46, 34,  0,  0,
     & 164,0.001,  0, 73, 91, 24,  0,  0,
     & 164,0.001,  0, 85,103,  0,  0,  0,
     & 164,0.001,  0, 82,100,  0,  0,  0,
     & 164,0.001,  0, 87,105,  0,  0,  0,
     & 164,0.001,  0, 73, 91, 25,  0,  0,
     & 164,0.001,  0, 56, 58,  0,  0,  0,
     & 164,0.001,  0, 56, 38, 30,  0,  0,
     & 164,0.001,  0, 56, 46, 42, 30,  0,
     & 164,0.001,  0, 56, 34, 50, 38,  0,
     & 164,0.001,  0, 56, 22,  0,  0,  0,
     & 164,0.001,  0, 84,102,  0,  0,  0,
     & 164,0.001,  0, 73, 34, 98,  0,  0,
     & 164,0.001,  0, 91, 46, 80,  0,  0,
     & 164,0.034,  0, 38, 38, 30, 30, 21,
     & 164,0.029,  0, 23, 23, 23, 21,  0,
     & 164,0.015,  0, 38, 30, 21,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 723, 741)/
     & 164,0.012,  0, 38, 30, 21, 34, 46,
     & 164,0.009,  0, 23, 23, 23, 24,  0,
     & 164,0.007,  0, 38, 30, 34, 46,  0,
     & 164,0.002,  0, 46, 42, 30,  0,  0,
     & 164,0.001,  0, 46, 34, 21,  0,  0,
     & 164,0.001,  0, 50, 42, 21,  0,  0,
     & 164,0.002,  0, 50, 34, 38,  0,  0,
     & 164,0.006,  0, 73, 91, 38, 30,  0,
     & 164,0.004,  0, 38, 30, 38, 30,  0,
     & 164,0.004,  0, 38, 30, 38, 30, 23,
     & 164,0.004,  0, 75, 93, 38, 30,  0,
     & 164,0.001,  0, 86,104,  0,  0,  0,
     & 164,0.001,  0, 79, 97,  0,  0,  0,
     & 164,0.001,  0, 81, 99,  0,  0,  0,
     & 164,0.003,  0, 23, 23, 34, 46,  0,
     & 164,0.002,  0, 73, 91, 38, 30, 21,
     & 164,0.002,  0, 73, 91,  0,  0,  0,
     & 164,0.002,  0, 73, 91, 22,  0,  0,
     & 164,0.002,  0, 73, 93, 30,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 742, 760)/
     & 164,0.002,  0, 75, 93,  0,  0,  0,
     & 164,0.001,  0, 83,102,  0,  0,  0,
     & 164,0.001,  0, 88,106,  0,  0,  0,
     & 164,0.001,  0, 78, 96,  0,  0,  0,
     & 164,0.001,  0, 73, 91, 21,  0,  0,
     & 164,0.001,  0, 78,104, 38,  0,  0,
     & 164,0.001,  0, 96, 86, 30,  0,  0,
     & 164,0.001,  0, 73, 34, 96,  0,  0,
     & 164,0.001,  0, 91, 46, 78,  0,  0,
     & 164,0.001,  0, 46, 34, 46, 34,  0,
     & 164,0.013,  0, 59,163,  0,  0,  0,
     & 164,0.008,  0, 59, 38, 30, 21, 21,
     & 164,0.004,  0, 59, 22, 38, 30,  0,
     & 164,0.002,  0, 59, 22, 21, 21,  0,
     & 164,0.003,  0, 59, 39, 31,  0,  0,
     & 164,0.002,  0, 59, 23, 23,  0,  0,
     & 164,0.004,  0, 59, 25,  0,  0,  0,
     & 164,0.003,  0, 59, 38, 30, 38, 30,
     & 164,0.002,  0, 59, 24, 24,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 761, 779)/
     & 164,0.001,  0, 59, 26,  0,  0,  0,
     & 164,0.001,  0, 59, 22,  0,  0,  0,
     & 164,0.001,  0, 59, 28,  0,  0,  0,
     & 164,0.001,  0, 59, 58,  0,  0,  0,
     & 164,0.020,  0,  1,  7,  0,  0,  0,
     & 164,0.080,  0,  2,  8,  0,  0,  0,
     & 164,0.020,  0,  3,  9,  0,  0,  0,
     & 164,0.364,130, 13, 13, 13,  0,  0,
     & 164,0.091,130, 13, 13, 59,  0,  0,
     & 165,0.037,  0, 38, 30, 38, 30,  0,
     & 165,0.030,  0, 38, 30, 46, 34,  0,
     & 165,0.016,  0, 23, 38, 30,  0,  0,
     & 165,0.015,  0, 23, 38, 30, 38, 30,
     & 165,0.004,  0, 46, 43, 30,  0,  0,
     & 165,0.002,  0, 46, 35, 21,  0,  0,
     & 165,0.002,  0, 51, 43, 21,  0,  0,
     & 165,0.004,  0, 51, 35, 38,  0,  0,
     & 165,0.008,  0, 38, 30,  0,  0,  0,
     & 165,0.007,  0, 46, 34,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 780, 798)/
     & 165,0.005,  0, 38, 30, 73, 91,  0,
     & 165,0.003,  0, 21, 21,  0,  0,  0,
     & 165,0.003,  0, 22, 22,  0,  0,  0,
     & 165,0.007,  0, 59,164,  0,  0,  0,
     & 165,0.857,  0, 13, 13,  0,  0,  0,
     & 166,0.008,  0,121,127,  0,  0,  0,
     & 166,0.008,  0,123,129,  0,  0,  0,
     & 166,0.001,  0,125,131,  0,  0,  0,
     & 166,0.338,  0,164, 38, 30,  0,  0,
     & 166,0.169,  0,164, 21, 21,  0,  0,
     & 166,0.027,  0,164, 22,  0,  0,  0,
     & 166,0.001,  0,164, 21,  0,  0,  0,
     & 166,0.004,  0, 23, 23, 23, 21,  0,
     & 166,0.003,  0, 23, 23, 21,  0,  0,
     & 166,0.002,  0, 38, 30, 46, 34,  0,
     & 166,0.001,  0, 38, 30, 73, 91,  0,
     & 166,0.093,  0, 59,165,  0,  0,  0,
     & 166,0.087,  0, 59,302,  0,  0,  0,
     & 166,0.078,  0, 59,303,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 799, 817)/
     & 166,0.003,  0, 59,163,  0,  0,  0,
     & 166,0.003,  0,  1,  7,  0,  0,  0,
     & 166,0.012,  0,  2,  8,  0,  0,  0,
     & 166,0.003,  0,  3,  9,  0,  0,  0,
     & 166,0.127,130, 13, 13, 13,  0,  0,
     & 166,0.032,130, 13, 13, 59,  0,  0,
     & 167,0.500,  0,136,171,  0,  0,  0,
     & 167,0.500,  0,140,175,  0,  0,  0,
     & 171,0.067,101,128,121, 50,  0,  0,
     & 171,0.067,101,130,123, 50,  0,  0,
     & 171,0.048,101,128,121, 51,  0,  0,
     & 171,0.048,101,130,123, 51,  0,  0,
     & 171,0.003,  0,128,121, 46, 30,  0,
     & 171,0.003,  0,130,123, 46, 30,  0,
     & 171,0.006,101,128,121, 21,  0,  0,
     & 171,0.006,101,130,123, 21,  0,  0,
     & 171,0.002,101,128,121, 23,  0,  0,
     & 171,0.002,101,130,123, 23,  0,  0,
     & 171,0.055,  0, 46, 30, 30,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 818, 836)/
     & 171,0.031,  0, 46, 31, 30,  0,  0,
     & 171,0.042,  0, 46, 30, 30, 21, 21,
     & 171,0.002,  0, 46, 30, 30, 30, 39,
     & 171,0.021,  0, 47, 30, 30,  0,  0,
     & 171,0.027,  0, 50, 30,  0,  0,  0,
     & 171,0.066,  0, 50, 31,  0,  0,  0,
     & 171,0.081,  0, 50, 32,  0,  0,  0,
     & 171,0.024,  0, 50, 30, 21,  0,  0,
     & 171,0.004,  0, 50, 30, 23,  0,  0,
     & 171,0.069,  0, 50, 30, 30, 38, 21,
     & 171,0.001,  0, 50, 30, 30, 38, 23,
     & 171,0.022,  0, 51, 30,  0,  0,  0,
     & 171,0.021,  0, 51, 31,  0,  0,  0,
     & 171,0.042,  0, 51, 30, 21,  0,  0,
     & 171,0.008,  0, 51, 30, 23,  0,  0,
     & 171,0.010,  0, 51, 30, 30, 38,  0,
     & 171,0.050,  0,309, 30,  0,  0,  0,
     & 171,0.034,  0,328, 30,  0,  0,  0,
     & 171,0.010,  0,368, 30,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 837, 855)/
     & 171,0.031,  0, 34, 50, 50,  0,  0,
     & 171,0.003,  0, 30, 21,  0,  0,  0,
     & 171,0.001,  0, 30, 23,  0,  0,  0,
     & 171,0.002,  0, 30, 30, 38,  0,  0,
     & 171,0.008,  0, 30, 22,  0,  0,  0,
     & 171,0.001,  0, 30, 30, 30, 38, 38,
     & 171,0.003,  0, 30, 30, 30, 38, 39,
     & 171,0.008,  0, 34, 50,  0,  0,  0,
     & 171,0.005,  0, 34, 51,  0,  0,  0,
     & 171,0.026,  0, 35, 51,  0,  0,  0,
     & 171,0.005,  0, 34, 46, 30,  0,  0,
     & 171,0.007,  0, 30, 56,  0,  0,  0,
     & 171,0.023,  0, 30, 56, 21,  0,  0,
     & 171,0.005,  0, 34, 34, 46,  0,  0,
     & 172,0.683,  0,175, 30,  0,  0,  0,
     & 172,0.306,  0,171, 21,  0,  0,  0,
     & 172,0.011,  0,171, 59,  0,  0,  0,
     & 173,0.667,  0,176, 30,  0,  0,  0,
     & 173,0.333,  0,172, 21,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 856, 874)/
     & 174,0.220,  0,175, 30,  0,  0,  0,
     & 174,0.110,  0,171, 21,  0,  0,  0,
     & 174,0.380,  0,176, 30,  0,  0,  0,
     & 174,0.190,  0,172, 21,  0,  0,  0,
     & 174,0.004,  0,171, 22,  0,  0,  0,
     & 174,0.064,  0,176, 30, 21,  0,  0,
     & 174,0.032,  0,172, 38, 30,  0,  0,
     & 175,0.037,101,128,121, 46,  0,  0,
     & 175,0.037,101,130,123, 46,  0,  0,
     & 175,0.016,101,128,121, 47,  0,  0,
     & 175,0.016,101,130,123, 47,  0,  0,
     & 175,0.013,  0,128,121, 46, 21,  0,
     & 175,0.013,  0,130,123, 46, 21,  0,
     & 175,0.012,  0,128,121, 50, 38,  0,
     & 175,0.012,  0,130,123, 50, 38,  0,
     & 175,0.003,101,128,121, 38,  0,  0,
     & 175,0.003,101,130,123, 38,  0,  0,
     & 175,0.039,  0, 46, 30,  0,  0,  0,
     & 175,0.091,  0, 46, 31,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 875, 893)/
     & 175,0.067,  0, 46, 32,  0,  0,  0,
     & 175,0.004,  0, 46, 30, 21,  0,  0,
     & 175,0.100,  0, 46, 30, 21, 21,  0,
     & 175,0.058,  0, 46, 30, 23,  0,  0,
     & 175,0.020,  0, 46, 30, 24,  0,  0,
     & 175,0.006,  0, 46, 30, 25,  0,  0,
     & 175,0.043,  0, 47, 30,  0,  0,  0,
     & 175,0.035,  0, 47, 31,  0,  0,  0,
     & 175,0.007,  0,310, 30,  0,  0,  0,
     & 175,0.007,  0,327, 30,  0,  0,  0,
     & 175,0.020,  0, 50, 21,  0,  0,  0,
     & 175,0.006,  0, 50, 22,  0,  0,  0,
     & 175,0.009,  0, 50, 23,  0,  0,  0,
     & 175,0.016,  0, 50, 24,  0,  0,  0,
     & 175,0.014,  0, 50, 25,  0,  0,  0,
     & 175,0.003,  0, 50,293,  0,  0,  0,
     & 175,0.007,  0, 50, 56,  0,  0,  0,
     & 175,0.003,  0, 50, 26,  0,  0,  0,
     & 175,0.004,  0, 50,294,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 894, 912)/
     & 175,0.006,  0, 50, 21, 21,  0,  0,
     & 175,0.042,  0, 50, 30, 38, 21,  0,
     & 175,0.004,  0, 50, 30, 30, 38, 38,
     & 175,0.076,  0, 50, 30, 38, 21, 21,
     & 175,0.026,  0, 51, 21,  0,  0,  0,
     & 175,0.014,  0, 51, 22,  0,  0,  0,
     & 175,0.014,  0, 51, 23,  0,  0,  0,
     & 175,0.011,  0, 51, 24,  0,  0,  0,
     & 175,0.018,  0, 51, 30, 38,  0,  0,
     & 175,0.004,  0, 50, 34, 46,  0,  0,
     & 175,0.004,  0, 50, 34, 46, 21,  0,
     & 175,0.005,  0, 50, 50, 42,  0,  0,
     & 175,0.002,  0, 30, 38,  0,  0,  0,
     & 175,0.001,  0, 21, 21,  0,  0,  0,
     & 175,0.008,  0, 30, 38, 21,  0,  0,
     & 175,0.007,  0, 30, 30, 38, 38,  0,
     & 175,0.015,  0, 30, 30, 38, 38, 21,
     & 175,0.004,  0, 34, 46,  0,  0,  0,
     & 175,0.003,  0, 35, 46,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 913, 931)/
     & 175,0.002,  0, 34, 47,  0,  0,  0,
     & 175,0.001,  0, 42, 50,  0,  0,  0,
     & 175,0.002,  0, 43, 51,  0,  0,  0,
     & 175,0.003,  0, 42, 46, 30,  0,  0,
     & 175,0.003,  0, 50, 34, 38,  0,  0,
     & 175,0.001,  0, 34, 46, 30, 38, 21,
     & 175,0.002,  0, 56, 23,  0,  0,  0,
     & 175,0.001,  0, 56, 30, 38,  0,  0,
     & 176,0.636,  0,175, 21,  0,  0,  0,
     & 176,0.364,  0,175, 59,  0,  0,  0,
     & 177,0.667,  0,172, 38,  0,  0,  0,
     & 177,0.333,  0,176, 21,  0,  0,  0,
     & 178,0.220,  0,171, 38,  0,  0,  0,
     & 178,0.110,  0,175, 21,  0,  0,  0,
     & 178,0.380,  0,172, 38,  0,  0,  0,
     & 178,0.190,  0,176, 21,  0,  0,  0,
     & 178,0.004,  0,175, 22,  0,  0,  0,
     & 178,0.064,  0,172, 38, 21,  0,  0,
     & 178,0.032,  0,176, 38, 30,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 932, 950)/
     & 179,0.009,  0,130,123,  0,  0,  0,
     & 179,0.019,101,128,121, 56,  0,  0,
     & 179,0.019,101,130,123, 56,  0,  0,
     & 179,0.025,101,128,121, 22,  0,  0,
     & 179,0.025,101,130,123, 22,  0,  0,
     & 179,0.009,101,128,121, 25,  0,  0,
     & 179,0.009,101,130,123, 25,  0,  0,
     & 179,0.036,  0, 34, 50,  0,  0,  0,
     & 179,0.034,  0, 34, 51,  0,  0,  0,
     & 179,0.007,  0, 34,328,  0,  0,  0,
     & 179,0.043,  0, 35, 50,  0,  0,  0,
     & 179,0.058,  0, 35, 51,  0,  0,  0,
     & 179,0.011,  0, 34, 46, 30,  0,  0,
     & 179,0.055,  0, 34, 46, 30, 21,  0,
     & 179,0.003,  0, 34, 46, 30, 38, 30,
     & 179,0.014,  0, 34, 50, 38, 30,  0,
     & 179,0.017,  0, 42, 46, 30, 30,  0,
     & 179,0.036,  0, 56, 30,  0,  0,  0,
     & 179,0.067,  0, 56, 31,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 951, 969)/
     & 179,0.023,  0, 56, 30, 21,  0,  0,
     & 179,0.018,  0, 56, 30, 38, 30,  0,
     & 179,0.020,  0, 22, 30,  0,  0,  0,
     & 179,0.001,  0, 23, 30,  0,  0,  0,
     & 179,0.009,  0, 24, 30,  0,  0,  0,
     & 179,0.049,  0, 25, 30,  0,  0,  0,
     & 179,0.011,  0,293, 30,  0,  0,  0,
     & 179,0.015,  0, 22, 30, 21,  0,  0,
     & 179,0.016,  0, 25, 30, 21,  0,  0,
     & 179,0.103,  0, 22, 31,  0,  0,  0,
     & 179,0.120,  0, 25, 31,  0,  0,  0,
     & 179,0.010,  0, 30, 38, 30,  0,  0,
     & 179,0.046,  0, 30, 38, 30, 21,  0,
     & 179,0.003,  0, 30, 38, 38, 30, 30,
     & 179,0.042,  0, 30, 38, 38, 30, 31,
     & 179,0.001,  0, 34, 23,  0,  0,  0,
     & 179,0.005,  0, 34, 38, 30,  0,  0,
     & 179,0.001,  0, 34, 56,  0,  0,  0,
     & 179,0.004,  0, 42, 30,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 970, 988)/
     & 179,0.007,  0, 43, 30,  0,  0,  0,
     & 180,0.900,  0,179, 59,  0,  0,  0,
     & 180,0.100,  0,179, 21,  0,  0,  0,
     & 181,0.500,  0,172, 42,  0,  0,  0,
     & 181,0.500,  0,176, 34,  0,  0,  0,
     & 182,0.440,  0,171, 42,  0,  0,  0,
     & 182,0.440,  0,175, 34,  0,  0,  0,
     & 182,0.055,  0,172, 42,  0,  0,  0,
     & 182,0.055,  0,176, 34,  0,  0,  0,
     & 182,0.010,  0,179, 22,  0,  0,  0,
     & 183,1.000,  0,185, 30,  0,  0,  0,
     & 184,1.000,  0,185, 30,  0,  0,  0,
     & 185,0.028,101,128,121, 96,  0,  0,
     & 185,0.010,101,128,121, 98,  0,  0,
     & 185,0.028,101,130,123, 96,  0,  0,
     & 185,0.010,101,130,123, 98,  0,  0,
     & 185,0.026,  0, 91, 50,  0,  0,  0,
     & 185,0.030,  0, 91, 50, 21,  0,  0,
     & 185,0.029,  0, 91, 50, 38, 30,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I= 989,1007)/
     & 185,0.014,  0, 91, 50, 22,  0,  0,
     & 185,0.020,  0, 91, 51,  0,  0,  0,
     & 185,0.029,  0, 91, 46, 30,  0,  0,
     & 185,0.039,  0, 91, 46, 30, 21,  0,
     & 185,0.002,  0, 91, 46, 30, 30, 38,
     & 185,0.010,  0, 91, 46, 30, 21, 21,
     & 185,0.014,  0, 91, 47, 30,  0,  0,
     & 185,0.010,  0, 92, 50,  0,  0,  0,
     & 185,0.020,  0, 92, 51,  0,  0,  0,
     & 185,0.010,  0, 92, 51, 21,  0,  0,
     & 185,0.007,  0,103, 46,  0,  0,  0,
     & 185,0.014,  0,103, 47,  0,  0,  0,
     & 185,0.004,  0, 91,293,  0,  0,  0,
     & 185,0.003,  0, 91, 38, 30,  0,  0,
     & 185,0.003,  0, 91, 38, 30, 38, 30,
     & 185,0.001,  0, 91, 56,  0,  0,  0,
     & 185,0.002,  0, 91, 46, 34,  0,  0,
     & 185,0.010,  0, 96, 30,  0,  0,  0,
     & 185,0.020,  0, 96, 31,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1008,1026)/
     & 185,0.030,  0, 96, 30, 21,  0,  0,
     & 185,0.010,  0, 96, 30, 22,  0,  0,
     & 185,0.020,  0, 96, 30, 24,  0,  0,
     & 185,0.035,  0, 96, 30, 30, 38,  0,
     & 185,0.020,  0, 96, 30, 21, 21,  0,
     & 185,0.010,  0, 96, 30, 38, 30, 21,
     & 185,0.010,  0, 96, 30, 21, 21, 21,
     & 185,0.007,  0, 96, 34, 50,  0,  0,
     & 185,0.011,  0, 97, 30,  0,  0,  0,
     & 185,0.022,  0, 97, 30, 21,  0,  0,
     & 185,0.013,  0, 97, 30, 38, 30,  0,
     & 185,0.010,  0, 97, 30, 21, 21,  0,
     & 185,0.007,  0, 97, 30, 38, 30, 21,
     & 185,0.005,  0, 97, 30, 21, 21, 21,
     & 185,0.005,  0, 98, 30,  0,  0,  0,
     & 185,0.015,  0, 98, 31,  0,  0,  0,
     & 185,0.011,  0,104, 21,  0,  0,  0,
     & 185,0.007,  0,104, 22,  0,  0,  0,
     & 185,0.010,  0,104, 23,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1027,1045)/
     & 185,0.031,  0,104, 24,  0,  0,  0,
     & 185,0.010,  0,104, 25,  0,  0,  0,
     & 185,0.004,  0,104, 56,  0,  0,  0,
     & 185,0.026,  0,104, 38, 30,  0,  0,
     & 185,0.005,  0,104, 38, 38, 30, 30,
     & 185,0.005,  0,104, 38, 30, 21, 21,
     & 185,0.005,  0,105, 21,  0,  0,  0,
     & 185,0.006,  0,105, 23,  0,  0,  0,
     & 185,0.004,  0,104, 46, 34,  0,  0,
     & 185,0.002,  0,104, 34, 38,  0,  0,
     & 185,0.001,  0,104, 34, 38, 21,  0,
     & 185,0.016,  0, 99, 30, 30,  0,  0,
     & 185,0.003,  0,106, 34,  0,  0,  0,
     & 185,0.002,  0,107, 34,  0,  0,  0,
     & 185,0.003,  0,101, 34, 30,  0,  0,
     & 185,0.040,  0, 93, 34, 21,  0,  0,
     & 185,0.040,  0, 93, 34, 38, 30,  0,
     & 185,0.020,  0, 93, 34, 21, 21,  0,
     & 185,0.010,  0, 93, 34, 38, 30, 21/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1046,1064)/
     & 185,0.010,  0, 93, 34, 21, 21, 21,
     & 185,0.020,  0, 93, 35, 21,  0,  0,
     & 185,0.040,  0, 93, 50, 30,  0,  0,
     & 185,0.020,  0, 93, 50, 31,  0,  0,
     & 185,0.010,  0, 93, 50, 30, 38, 30,
     & 185,0.010,  0, 93, 50, 30, 21, 21,
     & 185,0.006,  0, 93, 51, 30,  0,  0,
     & 186,1.000,  0,185, 21,  0,  0,  0,
     & 187,1.000,  0,185, 21,  0,  0,  0,
     & 188,1.000,  0,185, 38,  0,  0,  0,
     & 189,1.000,  0,185, 38,  0,  0,  0,
     & 190,0.045,101,128,121,106,  0,  0,
     & 190,0.005,101,128,121,107,  0,  0,
     & 190,0.045,101,130,123,106,  0,  0,
     & 190,0.005,101,130,123,107,  0,  0,
     & 190,0.021,  0,104, 50,  0,  0,  0,
     & 190,0.032,  0,105, 50,  0,  0,  0,
     & 190,0.032,  0, 97, 30, 50,  0,  0,
     & 190,0.045,  0,104, 51,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1065,1083)/
     & 190,0.065,  0,105, 51,  0,  0,  0,
     & 190,0.065,  0, 97, 30, 51,  0,  0,
     & 190,0.055,  0,106, 30,  0,  0,  0,
     & 190,0.160,  0,106, 31,  0,  0,  0,
     & 190,0.105,  0,107, 30,  0,  0,  0,
     & 190,0.320,  0,107, 31,  0,  0,  0,
     & 191,1.000,  0,190, 59,  0,  0,  0,
     & 192,0.667,  0,193, 30,  0,  0,  0,
     & 192,0.333,  0,190, 21,  0,  0,  0,
     & 193,0.045,101,128,121,101,  0,  0,
     & 193,0.045,101,130,123,101,  0,  0,
     & 193,0.005,101,128,121,102,  0,  0,
     & 193,0.005,101,130,123,102,  0,  0,
     & 193,0.020,  0, 97, 50,  0,  0,  0,
     & 193,0.020,  0, 97, 21, 50,  0,  0,
     & 193,0.020,  0, 98, 50,  0,  0,  0,
     & 193,0.060,  0, 97, 51,  0,  0,  0,
     & 193,0.060,  0, 97, 21, 51,  0,  0,
     & 193,0.060,  0, 98, 51,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1084,1102)/
     & 193,0.020,  0,104, 46,  0,  0,  0,
     & 193,0.060,  0,104, 47,  0,  0,  0,
     & 193,0.040,  0,105, 46,  0,  0,  0,
     & 193,0.120,  0,105, 47,  0,  0,  0,
     & 193,0.020,  0,101, 30,  0,  0,  0,
     & 193,0.060,  0,101, 31,  0,  0,  0,
     & 193,0.040,  0,102, 30,  0,  0,  0,
     & 193,0.120,  0,102, 31,  0,  0,  0,
     & 193,0.010,  0,106, 21,  0,  0,  0,
     & 193,0.030,  0,106, 23,  0,  0,  0,
     & 193,0.020,  0,107, 21,  0,  0,  0,
     & 193,0.060,  0,107, 23,  0,  0,  0,
     & 193,0.030,  0,106, 56,  0,  0,  0,
     & 193,0.030,  0,108, 34,  0,  0,  0,
     & 194,1.000,  0,193, 59,  0,  0,  0,
     & 195,0.670,  0,190, 38,  0,  0,  0,
     & 195,0.330,  0,193, 21,  0,  0,  0,
     & 196,0.050,101,128,121,108,  0,  0,
     & 196,0.050,101,130,123,108,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1103,1121)/
     & 196,0.075,  0,106, 50,  0,  0,  0,
     & 196,0.225,  0,106, 51,  0,  0,  0,
     & 196,0.150,  0,107, 50,  0,  0,  0,
     & 196,0.450,  0,107, 51,  0,  0,  0,
     & 197,1.000,  0,196, 59,  0,  0,  0,
     & 209,0.250,100,  1,  8,  4,  0,  0,
     & 209,0.250,100,  3, 10,  4,  0,  0,
     & 209,0.250,100,  5, 12,  4,  0,  0,
     & 209,0.085,100,121,128,  4,  0,  0,
     & 209,0.085,100,123,130,  4,  0,  0,
     & 209,0.080,100,125,132,  4,  0,  0,
     & 210,0.250,100,  2,  7,209,  0,  0,
     & 210,0.250,100,  4,  9,209,  0,  0,
     & 210,0.250,100,  6, 11,209,  0,  0,
     & 210,0.085,100,122,127,209,  0,  0,
     & 210,0.085,100,124,129,209,  0,  0,
     & 210,0.080,100,126,131,209,  0,  0,
     & 211,0.250,100,  1,  8,  6,  0,  0,
     & 211,0.250,100,  3, 10,  6,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1122,1140)/
     & 211,0.250,100,  5, 12,  6,  0,  0,
     & 211,0.085,100,121,128,  6,  0,  0,
     & 211,0.085,100,123,130,  6,  0,  0,
     & 211,0.080,100,125,132,  6,  0,  0,
     & 212,0.250,100,  2,  7,211,  0,  0,
     & 212,0.250,100,  4,  9,211,  0,  0,
     & 212,0.250,100,  6, 11,211,  0,  0,
     & 212,0.085,100,122,127,211,  0,  0,
     & 212,0.085,100,124,129,211,  0,  0,
     & 212,0.080,100,126,131,211,  0,  0,
     & 215,0.250,100,  7,  2, 10,  0,  0,
     & 215,0.250,100,  9,  4, 10,  0,  0,
     & 215,0.250,100, 11,  6, 10,  0,  0,
     & 215,0.085,100,127,122, 10,  0,  0,
     & 215,0.085,100,129,124, 10,  0,  0,
     & 215,0.080,100,131,126, 10,  0,  0,
     & 216,0.250,100,  8,  1,215,  0,  0,
     & 216,0.250,100, 10,  3,215,  0,  0,
     & 216,0.250,100, 12,  5,215,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1141,1159)/
     & 216,0.085,100,128,121,215,  0,  0,
     & 216,0.085,100,130,123,215,  0,  0,
     & 216,0.080,100,132,125,215,  0,  0,
     & 217,0.250,100,  7,  2, 12,  0,  0,
     & 217,0.250,100,  9,  4, 12,  0,  0,
     & 217,0.250,100, 11,  6, 12,  0,  0,
     & 217,0.085,100,127,122, 12,  0,  0,
     & 217,0.085,100,129,124, 12,  0,  0,
     & 217,0.080,100,131,126, 12,  0,  0,
     & 218,0.250,100,  8,  1,217,  0,  0,
     & 218,0.250,100, 10,  3,217,  0,  0,
     & 218,0.250,100, 12,  5,217,  0,  0,
     & 218,0.085,100,128,121,217,  0,  0,
     & 218,0.085,100,130,123,217,  0,  0,
     & 218,0.080,100,132,125,217,  0,  0,
     & 221,0.016,101,121,128,136,  0,  0,
     & 221,0.016,101,123,130,136,  0,  0,
     & 221,0.008,101,125,132,136,  0,  0,
     & 221,0.048,101,121,128,137,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1160,1178)/
     & 221,0.048,101,123,130,137,  0,  0,
     & 221,0.022,101,125,132,137,  0,  0,
     & 221,0.003,101,121,128,331,  0,  0,
     & 221,0.003,101,123,130,331,  0,  0,
     & 221,0.001,101,125,132,331,  0,  0,
     & 221,0.008,101,121,128,138,  0,  0,
     & 221,0.008,101,123,130,138,  0,  0,
     & 221,0.004,101,125,132,138,  0,  0,
     & 221,0.008,101,121,128,313,  0,  0,
     & 221,0.008,101,123,130,313,  0,  0,
     & 221,0.004,101,125,132,313,  0,  0,
     & 221,0.013,101,121,128,139,  0,  0,
     & 221,0.013,101,123,130,139,  0,  0,
     & 221,0.006,101,125,132,139,  0,  0,
     & 221,0.004,  0,136, 30,  0,  0,  0,
     & 221,0.010,  0,136, 31,  0,  0,  0,
     & 221,0.006,  0,136, 32,  0,  0,  0,
     & 221,0.003,  0,137, 30,  0,  0,  0,
     & 221,0.009,  0,137, 31,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1179,1197)/
     & 221,0.017,  0,137, 32,  0,  0,  0,
     & 221,0.011,  0,136,179,  0,  0,  0,
     & 221,0.015,  0,136,180,  0,  0,  0,
     & 221,0.011,  0,137,179,  0,  0,  0,
     & 221,0.022,  0,137,180,  0,  0,  0,
     & 221,0.001,  0,164, 42,  0,  0,  0,
     & 221,0.002,  0,164, 43,  0,  0,  0,
     & 221,0.001,  0,165, 42,  0,  0,  0,
     & 221,0.001,  0,165, 43,  0,  0,  0,
     & 221,0.001,  0,166, 42,  0,  0,  0,
     & 221,0.001,  0,166, 43,  0,  0,  0,
     & 221,0.207,100,  1,  8,  4,  7,  0,
     & 221,0.207,100,  3, 10,  4,  7,  0,
     & 221,0.024,100,  1,  8,  2,  7,  0,
     & 221,0.024,100,  3, 10,  2,  7,  0,
     & 221,0.012,100,  3,  8,  4,  7,  0,
     & 221,0.012,100,  1, 10,  4,  7,  0,
     & 221,0.069,100,  4,  8,  1,  7,  0,
     & 221,0.069,100,  4, 10,  3,  7,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1198,1216)/
     & 221,0.008,100,  2,  8,  1,  7,  0,
     & 221,0.008,100,  2, 10,  3,  7,  0,
     & 221,0.004,100,  4,  8,  3,  7,  0,
     & 221,0.004,100,  4, 10,  1,  7,  0,
     & 222,0.016,101,121,128,140,  0,  0,
     & 222,0.016,101,123,130,140,  0,  0,
     & 222,0.008,101,125,132,140,  0,  0,
     & 222,0.048,101,121,128,141,  0,  0,
     & 222,0.048,101,123,130,141,  0,  0,
     & 222,0.022,101,125,132,141,  0,  0,
     & 222,0.003,101,121,128,332,  0,  0,
     & 222,0.003,101,123,130,332,  0,  0,
     & 222,0.001,101,125,132,332,  0,  0,
     & 222,0.008,101,121,128,142,  0,  0,
     & 222,0.008,101,123,130,142,  0,  0,
     & 222,0.004,101,125,132,142,  0,  0,
     & 222,0.008,101,121,128,314,  0,  0,
     & 222,0.008,101,123,130,314,  0,  0,
     & 222,0.004,101,125,132,314,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1217,1235)/
     & 222,0.013,101,121,128,143,  0,  0,
     & 222,0.013,101,123,130,143,  0,  0,
     & 222,0.006,101,125,132,143,  0,  0,
     & 222,0.004,  0,140, 30,  0,  0,  0,
     & 222,0.010,  0,140, 31,  0,  0,  0,
     & 222,0.006,  0,140, 32,  0,  0,  0,
     & 222,0.003,  0,141, 30,  0,  0,  0,
     & 222,0.009,  0,141, 31,  0,  0,  0,
     & 222,0.017,  0,141, 32,  0,  0,  0,
     & 222,0.011,  0,140,179,  0,  0,  0,
     & 222,0.015,  0,140,180,  0,  0,  0,
     & 222,0.011,  0,141,179,  0,  0,  0,
     & 222,0.022,  0,141,180,  0,  0,  0,
     & 222,0.001,  0,164, 34,  0,  0,  0,
     & 222,0.002,  0,164, 35,  0,  0,  0,
     & 222,0.001,  0,165, 34,  0,  0,  0,
     & 222,0.001,  0,165, 35,  0,  0,  0,
     & 222,0.001,  0,166, 34,  0,  0,  0,
     & 222,0.001,  0,166, 35,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1236,1254)/
     & 222,0.207,100,  1,  8,  4,  8,  0,
     & 222,0.207,100,  3, 10,  4,  8,  0,
     & 222,0.024,100,  1,  8,  2,  8,  0,
     & 222,0.024,100,  3, 10,  2,  8,  0,
     & 222,0.012,100,  3,  8,  4,  8,  0,
     & 222,0.012,100,  1, 10,  4,  8,  0,
     & 222,0.069,100,  4,  8,  1,  8,  0,
     & 222,0.069,100,  4, 10,  3,  8,  0,
     & 222,0.008,100,  2,  8,  1,  8,  0,
     & 222,0.008,100,  2, 10,  3,  8,  0,
     & 222,0.004,100,  4,  8,  3,  8,  0,
     & 222,0.004,100,  4, 10,  1,  8,  0,
     & 223,0.016,101,121,128,144,  0,  0,
     & 223,0.016,101,123,130,144,  0,  0,
     & 223,0.008,101,125,132,144,  0,  0,
     & 223,0.048,101,121,128,145,  0,  0,
     & 223,0.048,101,123,130,145,  0,  0,
     & 223,0.022,101,125,132,145,  0,  0,
     & 223,0.003,101,121,128,333,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1255,1273)/
     & 223,0.003,101,123,130,333,  0,  0,
     & 223,0.001,101,125,132,333,  0,  0,
     & 223,0.008,101,121,128,146,  0,  0,
     & 223,0.008,101,123,130,146,  0,  0,
     & 223,0.004,101,125,132,146,  0,  0,
     & 223,0.008,101,121,128,315,  0,  0,
     & 223,0.008,101,123,130,315,  0,  0,
     & 223,0.004,101,125,132,315,  0,  0,
     & 223,0.013,101,121,128,147,  0,  0,
     & 223,0.013,101,123,130,147,  0,  0,
     & 223,0.006,101,125,132,147,  0,  0,
     & 223,0.004,  0,144, 30,  0,  0,  0,
     & 223,0.010,  0,144, 31,  0,  0,  0,
     & 223,0.006,  0,144, 32,  0,  0,  0,
     & 223,0.003,  0,145, 30,  0,  0,  0,
     & 223,0.009,  0,145, 31,  0,  0,  0,
     & 223,0.017,  0,145, 32,  0,  0,  0,
     & 223,0.011,  0,144,179,  0,  0,  0,
     & 223,0.015,  0,144,180,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1274,1292)/
     & 223,0.011,  0,145,179,  0,  0,  0,
     & 223,0.022,  0,145,180,  0,  0,  0,
     & 223,0.001,  0,164, 25,  0,  0,  0,
     & 223,0.002,  0,164, 56,  0,  0,  0,
     & 223,0.001,  0,165, 25,  0,  0,  0,
     & 223,0.001,  0,165, 56,  0,  0,  0,
     & 223,0.001,  0,166, 25,  0,  0,  0,
     & 223,0.001,  0,166, 56,  0,  0,  0,
     & 223,0.207,100,  1,  8,  4,  9,  0,
     & 223,0.207,100,  3, 10,  4,  9,  0,
     & 223,0.024,100,  1,  8,  2,  9,  0,
     & 223,0.024,100,  3, 10,  2,  9,  0,
     & 223,0.012,100,  3,  8,  4,  9,  0,
     & 223,0.012,100,  1, 10,  4,  9,  0,
     & 223,0.069,100,  4,  8,  1,  9,  0,
     & 223,0.069,100,  4, 10,  3,  9,  0,
     & 223,0.008,100,  2,  8,  1,  9,  0,
     & 223,0.008,100,  2, 10,  3,  9,  0,
     & 223,0.004,100,  4,  8,  3,  9,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1293,1311)/
     & 223,0.004,100,  4, 10,  1,  9,  0,
     & 224,0.090,100,121,128,  4,109,  0,
     & 224,0.090,100,123,130,  4,109,  0,
     & 224,0.045,100,125,132,  4,109,  0,
     & 224,0.010,100,121,128,  2,109,  0,
     & 224,0.010,100,123,130,  2,109,  0,
     & 224,0.005,100,125,132,  2,109,  0,
     & 224,0.242,100,  1,  8,  4,109,  0,
     & 224,0.242,100,  3, 10,  4,109,  0,
     & 224,0.027,100,  1,  8,  2,109,  0,
     & 224,0.027,100,  3, 10,  2,109,  0,
     & 224,0.012,100,  3,  8,  4,109,  0,
     & 224,0.012,100,  1, 10,  4,109,  0,
     & 224,0.081,100,  4,  8,  1,109,  0,
     & 224,0.081,100,  4, 10,  3,109,  0,
     & 224,0.009,100,  2,  8,  1,109,  0,
     & 224,0.009,100,  2, 10,  3,109,  0,
     & 224,0.004,100,  4,  8,  3,109,  0,
     & 224,0.004,100,  4, 10,  1,109,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1312,1330)/
     & 225,0.090,100,121,128,  4,110,  0,
     & 225,0.090,100,123,130,  4,110,  0,
     & 225,0.045,100,125,132,  4,110,  0,
     & 225,0.010,100,121,128,  2,110,  0,
     & 225,0.010,100,123,130,  2,110,  0,
     & 225,0.005,100,125,132,  2,110,  0,
     & 225,0.242,100,  1,  8,  4,110,  0,
     & 225,0.242,100,  3, 10,  4,110,  0,
     & 225,0.027,100,  1,  8,  2,110,  0,
     & 225,0.027,100,  3, 10,  2,110,  0,
     & 225,0.012,100,  3,  8,  4,110,  0,
     & 225,0.012,100,  1, 10,  4,110,  0,
     & 225,0.081,100,  4,  8,  1,110,  0,
     & 225,0.081,100,  4, 10,  3,110,  0,
     & 225,0.009,100,  2,  8,  1,110,  0,
     & 225,0.009,100,  2, 10,  3,110,  0,
     & 225,0.004,100,  4,  8,  3,110,  0,
     & 225,0.004,100,  4, 10,  1,110,  0,
     & 226,0.090,100,121,128,  4,111,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1331,1349)/
     & 226,0.090,100,123,130,  4,111,  0,
     & 226,0.045,100,125,132,  4,111,  0,
     & 226,0.010,100,121,128,  2,111,  0,
     & 226,0.010,100,123,130,  2,111,  0,
     & 226,0.005,100,125,132,  2,111,  0,
     & 226,0.242,100,  1,  8,  4,111,  0,
     & 226,0.242,100,  3, 10,  4,111,  0,
     & 226,0.027,100,  1,  8,  2,111,  0,
     & 226,0.027,100,  3, 10,  2,111,  0,
     & 226,0.012,100,  3,  8,  4,111,  0,
     & 226,0.012,100,  1, 10,  4,111,  0,
     & 226,0.081,100,  4,  8,  1,111,  0,
     & 226,0.081,100,  4, 10,  3,111,  0,
     & 226,0.009,100,  2,  8,  1,111,  0,
     & 226,0.009,100,  2, 10,  3,111,  0,
     & 226,0.004,100,  4,  8,  3,111,  0,
     & 226,0.004,100,  4, 10,  1,111,  0,
     & 227,0.090,100,121,128,  4,112,  0,
     & 227,0.090,100,123,130,  4,112,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1350,1368)/
     & 227,0.045,100,125,132,  4,112,  0,
     & 227,0.010,100,121,128,  2,112,  0,
     & 227,0.010,100,123,130,  2,112,  0,
     & 227,0.005,100,125,132,  2,112,  0,
     & 227,0.242,100,  1,  8,  4,112,  0,
     & 227,0.242,100,  3, 10,  4,112,  0,
     & 227,0.027,100,  1,  8,  2,112,  0,
     & 227,0.027,100,  3, 10,  2,112,  0,
     & 227,0.012,100,  3,  8,  4,112,  0,
     & 227,0.012,100,  1, 10,  4,112,  0,
     & 227,0.081,100,  4,  8,  1,112,  0,
     & 227,0.081,100,  4, 10,  3,112,  0,
     & 227,0.009,100,  2,  8,  1,112,  0,
     & 227,0.009,100,  2, 10,  3,112,  0,
     & 227,0.004,100,  4,  8,  3,112,  0,
     & 227,0.004,100,  4, 10,  1,112,  0,
     & 228,0.090,100,121,128,  4,113,  0,
     & 228,0.090,100,123,130,  4,113,  0,
     & 228,0.045,100,125,132,  4,113,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1369,1387)/
     & 228,0.010,100,121,128,  2,113,  0,
     & 228,0.010,100,123,130,  2,113,  0,
     & 228,0.005,100,125,132,  2,113,  0,
     & 228,0.242,100,  1,  8,  4,113,  0,
     & 228,0.242,100,  3, 10,  4,113,  0,
     & 228,0.027,100,  1,  8,  2,113,  0,
     & 228,0.027,100,  3, 10,  2,113,  0,
     & 228,0.012,100,  3,  8,  4,113,  0,
     & 228,0.012,100,  1, 10,  4,113,  0,
     & 228,0.081,100,  4,  8,  1,113,  0,
     & 228,0.081,100,  4, 10,  3,113,  0,
     & 228,0.009,100,  2,  8,  1,113,  0,
     & 228,0.009,100,  2, 10,  3,113,  0,
     & 228,0.004,100,  4,  8,  3,113,  0,
     & 228,0.004,100,  4, 10,  1,113,  0,
     & 229,0.090,100,121,128,  4,114,  0,
     & 229,0.090,100,123,130,  4,114,  0,
     & 229,0.045,100,125,132,  4,114,  0,
     & 229,0.010,100,121,128,  2,114,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1388,1406)/
     & 229,0.010,100,123,130,  2,114,  0,
     & 229,0.005,100,125,132,  2,114,  0,
     & 229,0.242,100,  1,  8,  4,114,  0,
     & 229,0.242,100,  3, 10,  4,114,  0,
     & 229,0.027,100,  1,  8,  2,114,  0,
     & 229,0.027,100,  3, 10,  2,114,  0,
     & 229,0.012,100,  3,  8,  4,114,  0,
     & 229,0.012,100,  1, 10,  4,114,  0,
     & 229,0.081,100,  4,  8,  1,114,  0,
     & 229,0.081,100,  4, 10,  3,114,  0,
     & 229,0.009,100,  2,  8,  1,114,  0,
     & 229,0.009,100,  2, 10,  3,114,  0,
     & 229,0.004,100,  4,  8,  3,114,  0,
     & 229,0.004,100,  4, 10,  1,114,  0,
     & 230,0.080,100,121,128,  4, 10,  0,
     & 230,0.080,100,123,130,  4, 10,  0,
     & 230,0.040,100,125,132,  4, 10,  0,
     & 230,0.080,100,121,128,  9,  5,  0,
     & 230,0.080,100,123,130,  9,  5,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1407,1425)/
     & 230,0.228,100,  1,  8,  4, 10,  0,
     & 230,0.228,100,  3, 10,  4, 10,  0,
     & 230,0.012,100,  3,  8,  4, 10,  0,
     & 230,0.012,100,  1, 10,  4, 10,  0,
     & 230,0.076,100,  4,  8,  1, 10,  0,
     & 230,0.076,100,  4, 10,  3, 10,  0,
     & 230,0.004,100,  4,  8,  3, 10,  0,
     & 230,0.004,100,  4, 10,  1, 10,  0,
     & 231,0.025,  0,121,127,  0,  0,  0,
     & 231,0.025,  0,123,129,  0,  0,  0,
     & 231,0.025,  0,125,131,  0,  0,  0,
     & 231,0.008,  0,  1,  7,  0,  0,  0,
     & 231,0.033,  0,  2,  8,  0,  0,  0,
     & 231,0.008,  0,  3,  9,  0,  0,  0,
     & 231,0.033,  0,  4, 10,  0,  0,  0,
     & 231,0.801,130, 13, 13, 13,  0,  0,
     & 231,0.042,130, 13, 13, 59,  0,  0,
     & 245,0.016,101,127,122,171,  0,  0,
     & 245,0.016,101,129,124,171,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1426,1444)/
     & 245,0.008,101,131,126,171,  0,  0,
     & 245,0.048,101,127,122,172,  0,  0,
     & 245,0.048,101,129,124,172,  0,  0,
     & 245,0.022,101,131,126,172,  0,  0,
     & 245,0.003,101,127,122,334,  0,  0,
     & 245,0.003,101,129,124,334,  0,  0,
     & 245,0.001,101,131,126,334,  0,  0,
     & 245,0.008,101,127,122,173,  0,  0,
     & 245,0.008,101,129,124,173,  0,  0,
     & 245,0.004,101,131,126,173,  0,  0,
     & 245,0.008,101,127,122,316,  0,  0,
     & 245,0.008,101,129,124,316,  0,  0,
     & 245,0.004,101,131,126,316,  0,  0,
     & 245,0.013,101,127,122,174,  0,  0,
     & 245,0.013,101,129,124,174,  0,  0,
     & 245,0.006,101,131,126,174,  0,  0,
     & 245,0.004,  0,171, 38,  0,  0,  0,
     & 245,0.010,  0,171, 39,  0,  0,  0,
     & 245,0.006,  0,171, 40,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1445,1463)/
     & 245,0.003,  0,172, 38,  0,  0,  0,
     & 245,0.009,  0,172, 39,  0,  0,  0,
     & 245,0.017,  0,172, 40,  0,  0,  0,
     & 245,0.011,  0,171,144,  0,  0,  0,
     & 245,0.015,  0,171,145,  0,  0,  0,
     & 245,0.011,  0,172,144,  0,  0,  0,
     & 245,0.022,  0,172,145,  0,  0,  0,
     & 245,0.001,  0,164, 50,  0,  0,  0,
     & 245,0.002,  0,164, 51,  0,  0,  0,
     & 245,0.001,  0,165, 50,  0,  0,  0,
     & 245,0.001,  0,165, 51,  0,  0,  0,
     & 245,0.001,  0,166, 50,  0,  0,  0,
     & 245,0.001,  0,166, 51,  0,  0,  0,
     & 245,0.207,100,  7,  2, 10,  1,  0,
     & 245,0.207,100,  9,  4, 10,  1,  0,
     & 245,0.024,100,  7,  2,  8,  1,  0,
     & 245,0.024,100,  9,  4,  8,  1,  0,
     & 245,0.012,100,  9,  2, 10,  1,  0,
     & 245,0.012,100,  7,  4, 10,  1,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1464,1482)/
     & 245,0.069,100, 10,  2,  7,  1,  0,
     & 245,0.069,100, 10,  4,  9,  1,  0,
     & 245,0.008,100,  8,  2,  7,  1,  0,
     & 245,0.008,100,  8,  4,  9,  1,  0,
     & 245,0.004,100, 10,  2,  9,  1,  0,
     & 245,0.004,100, 10,  4,  7,  1,  0,
     & 246,0.016,101,127,122,175,  0,  0,
     & 246,0.016,101,129,124,175,  0,  0,
     & 246,0.008,101,131,126,175,  0,  0,
     & 246,0.048,101,127,122,176,  0,  0,
     & 246,0.048,101,129,124,176,  0,  0,
     & 246,0.022,101,131,126,176,  0,  0,
     & 246,0.003,101,127,122,335,  0,  0,
     & 246,0.003,101,129,124,335,  0,  0,
     & 246,0.001,101,131,126,335,  0,  0,
     & 246,0.008,101,127,122,177,  0,  0,
     & 246,0.008,101,129,124,177,  0,  0,
     & 246,0.004,101,131,126,177,  0,  0,
     & 246,0.008,101,127,122,317,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1483,1501)/
     & 246,0.008,101,129,124,317,  0,  0,
     & 246,0.004,101,131,126,317,  0,  0,
     & 246,0.013,101,127,122,178,  0,  0,
     & 246,0.013,101,129,124,178,  0,  0,
     & 246,0.006,101,131,126,178,  0,  0,
     & 246,0.004,  0,175, 38,  0,  0,  0,
     & 246,0.010,  0,175, 39,  0,  0,  0,
     & 246,0.006,  0,175, 40,  0,  0,  0,
     & 246,0.003,  0,176, 38,  0,  0,  0,
     & 246,0.009,  0,176, 39,  0,  0,  0,
     & 246,0.017,  0,176, 40,  0,  0,  0,
     & 246,0.011,  0,175,144,  0,  0,  0,
     & 246,0.015,  0,175,145,  0,  0,  0,
     & 246,0.011,  0,176,144,  0,  0,  0,
     & 246,0.022,  0,176,145,  0,  0,  0,
     & 246,0.001,  0,164, 46,  0,  0,  0,
     & 246,0.002,  0,164, 47,  0,  0,  0,
     & 246,0.001,  0,165, 46,  0,  0,  0,
     & 246,0.001,  0,165, 47,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1502,1520)/
     & 246,0.001,  0,166, 46,  0,  0,  0,
     & 246,0.001,  0,166, 47,  0,  0,  0,
     & 246,0.207,100,  7,  2, 10,  2,  0,
     & 246,0.207,100,  9,  4, 10,  2,  0,
     & 246,0.024,100,  7,  2,  8,  2,  0,
     & 246,0.024,100,  9,  4,  8,  2,  0,
     & 246,0.012,100,  9,  2, 10,  2,  0,
     & 246,0.012,100,  7,  4, 10,  2,  0,
     & 246,0.069,100, 10,  2,  7,  2,  0,
     & 246,0.069,100, 10,  4,  9,  2,  0,
     & 246,0.008,100,  8,  2,  7,  2,  0,
     & 246,0.008,100,  8,  4,  9,  2,  0,
     & 246,0.004,100, 10,  2,  9,  2,  0,
     & 246,0.004,100, 10,  4,  7,  2,  0,
     & 247,0.016,101,127,122,179,  0,  0,
     & 247,0.016,101,129,124,179,  0,  0,
     & 247,0.008,101,131,126,179,  0,  0,
     & 247,0.048,101,127,122,180,  0,  0,
     & 247,0.048,101,129,124,180,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1521,1539)/
     & 247,0.022,101,131,126,180,  0,  0,
     & 247,0.003,101,127,122,336,  0,  0,
     & 247,0.003,101,129,124,336,  0,  0,
     & 247,0.001,101,131,126,336,  0,  0,
     & 247,0.008,101,127,122,181,  0,  0,
     & 247,0.008,101,129,124,181,  0,  0,
     & 247,0.004,101,131,126,181,  0,  0,
     & 247,0.008,101,127,122,318,  0,  0,
     & 247,0.008,101,129,124,318,  0,  0,
     & 247,0.004,101,131,126,318,  0,  0,
     & 247,0.013,101,127,122,182,  0,  0,
     & 247,0.013,101,129,124,182,  0,  0,
     & 247,0.006,101,131,126,182,  0,  0,
     & 247,0.004,  0,179, 38,  0,  0,  0,
     & 247,0.010,  0,179, 39,  0,  0,  0,
     & 247,0.006,  0,179, 40,  0,  0,  0,
     & 247,0.003,  0,180, 38,  0,  0,  0,
     & 247,0.009,  0,180, 39,  0,  0,  0,
     & 247,0.017,  0,180, 40,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1540,1558)/
     & 247,0.011,  0,179,144,  0,  0,  0,
     & 247,0.015,  0,179,145,  0,  0,  0,
     & 247,0.011,  0,180,144,  0,  0,  0,
     & 247,0.022,  0,180,145,  0,  0,  0,
     & 247,0.001,  0,164, 25,  0,  0,  0,
     & 247,0.002,  0,164, 56,  0,  0,  0,
     & 247,0.001,  0,165, 25,  0,  0,  0,
     & 247,0.001,  0,165, 56,  0,  0,  0,
     & 247,0.001,  0,166, 25,  0,  0,  0,
     & 247,0.001,  0,166, 56,  0,  0,  0,
     & 247,0.207,100,  7,  2, 10,  3,  0,
     & 247,0.207,100,  9,  4, 10,  3,  0,
     & 247,0.024,100,  7,  2,  8,  3,  0,
     & 247,0.024,100,  9,  4,  8,  3,  0,
     & 247,0.012,100,  9,  2, 10,  3,  0,
     & 247,0.012,100,  7,  4, 10,  3,  0,
     & 247,0.069,100, 10,  2,  7,  3,  0,
     & 247,0.069,100, 10,  4,  9,  3,  0,
     & 247,0.008,100,  8,  2,  7,  3,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1559,1577)/
     & 247,0.008,100,  8,  4,  9,  3,  0,
     & 247,0.004,100, 10,  2,  9,  3,  0,
     & 247,0.004,100, 10,  4,  7,  3,  0,
     & 248,0.090,100,127,122, 10,115,  0,
     & 248,0.090,100,129,124, 10,115,  0,
     & 248,0.045,100,131,126, 10,115,  0,
     & 248,0.010,100,127,122,  8,115,  0,
     & 248,0.010,100,129,124,  8,115,  0,
     & 248,0.005,100,131,126,  8,115,  0,
     & 248,0.242,100,  7,  2, 10,115,  0,
     & 248,0.242,100,  9,  4, 10,115,  0,
     & 248,0.027,100,  7,  2,  8,115,  0,
     & 248,0.027,100,  9,  4,  8,115,  0,
     & 248,0.012,100,  9,  2, 10,115,  0,
     & 248,0.012,100,  7,  4, 10,115,  0,
     & 248,0.081,100, 10,  2,  7,115,  0,
     & 248,0.081,100, 10,  4,  9,115,  0,
     & 248,0.009,100,  8,  2,  7,115,  0,
     & 248,0.009,100,  8,  4,  9,115,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1578,1596)/
     & 248,0.004,100, 10,  2,  9,115,  0,
     & 248,0.004,100, 10,  4,  7,115,  0,
     & 249,0.090,100,127,122, 10,116,  0,
     & 249,0.090,100,129,124, 10,116,  0,
     & 249,0.045,100,131,126, 10,116,  0,
     & 249,0.010,100,127,122,  8,116,  0,
     & 249,0.010,100,129,124,  8,116,  0,
     & 249,0.005,100,131,126,  8,116,  0,
     & 249,0.242,100,  7,  2, 10,116,  0,
     & 249,0.242,100,  9,  4, 10,116,  0,
     & 249,0.027,100,  7,  2,  8,116,  0,
     & 249,0.027,100,  9,  4,  8,116,  0,
     & 249,0.012,100,  9,  2, 10,116,  0,
     & 249,0.012,100,  7,  4, 10,116,  0,
     & 249,0.081,100, 10,  2,  7,116,  0,
     & 249,0.081,100, 10,  4,  9,116,  0,
     & 249,0.009,100,  8,  2,  7,116,  0,
     & 249,0.009,100,  8,  4,  9,116,  0,
     & 249,0.004,100, 10,  2,  9,116,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1597,1615)/
     & 249,0.004,100, 10,  4,  7,116,  0,
     & 250,0.090,100,127,122, 10,117,  0,
     & 250,0.090,100,129,124, 10,117,  0,
     & 250,0.045,100,131,126, 10,117,  0,
     & 250,0.010,100,127,122,  8,117,  0,
     & 250,0.010,100,129,124,  8,117,  0,
     & 250,0.005,100,131,126,  8,117,  0,
     & 250,0.242,100,  7,  2, 10,117,  0,
     & 250,0.242,100,  9,  4, 10,117,  0,
     & 250,0.027,100,  7,  2,  8,117,  0,
     & 250,0.027,100,  9,  4,  8,117,  0,
     & 250,0.012,100,  9,  2, 10,117,  0,
     & 250,0.012,100,  7,  4, 10,117,  0,
     & 250,0.081,100, 10,  2,  7,117,  0,
     & 250,0.081,100, 10,  4,  9,117,  0,
     & 250,0.009,100,  8,  2,  7,117,  0,
     & 250,0.009,100,  8,  4,  9,117,  0,
     & 250,0.004,100, 10,  2,  9,117,  0,
     & 250,0.004,100, 10,  4,  7,117,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1616,1634)/
     & 251,0.090,100,127,122, 10,118,  0,
     & 251,0.090,100,129,124, 10,118,  0,
     & 251,0.045,100,131,126, 10,118,  0,
     & 251,0.010,100,127,122,  8,118,  0,
     & 251,0.010,100,129,124,  8,118,  0,
     & 251,0.005,100,131,126,  8,118,  0,
     & 251,0.242,100,  7,  2, 10,118,  0,
     & 251,0.242,100,  9,  4, 10,118,  0,
     & 251,0.027,100,  7,  2,  8,118,  0,
     & 251,0.027,100,  9,  4,  8,118,  0,
     & 251,0.012,100,  9,  2, 10,118,  0,
     & 251,0.012,100,  7,  4, 10,118,  0,
     & 251,0.081,100, 10,  2,  7,118,  0,
     & 251,0.081,100, 10,  4,  9,118,  0,
     & 251,0.009,100,  8,  2,  7,118,  0,
     & 251,0.009,100,  8,  4,  9,118,  0,
     & 251,0.004,100, 10,  2,  9,118,  0,
     & 251,0.004,100, 10,  4,  7,118,  0,
     & 252,0.090,100,127,122, 10,119,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1635,1653)/
     & 252,0.090,100,129,124, 10,119,  0,
     & 252,0.045,100,131,126, 10,119,  0,
     & 252,0.010,100,127,122,  8,119,  0,
     & 252,0.010,100,129,124,  8,119,  0,
     & 252,0.005,100,131,126,  8,119,  0,
     & 252,0.242,100,  7,  2, 10,119,  0,
     & 252,0.242,100,  9,  4, 10,119,  0,
     & 252,0.027,100,  7,  2,  8,119,  0,
     & 252,0.027,100,  9,  4,  8,119,  0,
     & 252,0.012,100,  9,  2, 10,119,  0,
     & 252,0.012,100,  7,  4, 10,119,  0,
     & 252,0.081,100, 10,  2,  7,119,  0,
     & 252,0.081,100, 10,  4,  9,119,  0,
     & 252,0.009,100,  8,  2,  7,119,  0,
     & 252,0.009,100,  8,  4,  9,119,  0,
     & 252,0.004,100, 10,  2,  9,119,  0,
     & 252,0.004,100, 10,  4,  7,119,  0,
     & 253,0.090,100,127,122, 10,120,  0,
     & 253,0.090,100,129,124, 10,120,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1654,1672)/
     & 253,0.045,100,131,126, 10,120,  0,
     & 253,0.010,100,127,122,  8,120,  0,
     & 253,0.010,100,129,124,  8,120,  0,
     & 253,0.005,100,131,126,  8,120,  0,
     & 253,0.242,100,  7,  2, 10,120,  0,
     & 253,0.242,100,  9,  4, 10,120,  0,
     & 253,0.027,100,  7,  2,  8,120,  0,
     & 253,0.027,100,  9,  4,  8,120,  0,
     & 253,0.012,100,  9,  2, 10,120,  0,
     & 253,0.012,100,  7,  4, 10,120,  0,
     & 253,0.081,100, 10,  2,  7,120,  0,
     & 253,0.081,100, 10,  4,  9,120,  0,
     & 253,0.009,100,  8,  2,  7,120,  0,
     & 253,0.009,100,  8,  4,  9,120,  0,
     & 253,0.004,100, 10,  2,  9,120,  0,
     & 253,0.004,100, 10,  4,  7,120,  0,
     & 254,0.080,100,127,122, 10,  4,  0,
     & 254,0.080,100,129,124, 10,  4,  0,
     & 254,0.040,100,131,126, 10,  4,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1673,1691)/
     & 254,0.080,100,127,122,  3, 11,  0,
     & 254,0.080,100,129,124,  3, 11,  0,
     & 254,0.228,100,  7,  2, 10,  4,  0,
     & 254,0.228,100,  9,  4, 10,  4,  0,
     & 254,0.012,100,  9,  2, 10,  4,  0,
     & 254,0.012,100,  7,  4, 10,  4,  0,
     & 254,0.076,100, 10,  2,  7,  4,  0,
     & 254,0.076,100, 10,  4,  9,  4,  0,
     & 254,0.004,100, 10,  2,  9,  4,  0,
     & 254,0.004,100, 10,  4,  7,  4,  0,
     & 265,1.000,  0,221, 59,  0,  0,  0,
     & 266,1.000,  0,222, 59,  0,  0,  0,
     & 267,1.000,  0,223, 59,  0,  0,  0,
     & 268,0.667,  0,266, 38,  0,  0,  0,
     & 268,0.333,  0,265, 21,  0,  0,  0,
     & 269,0.667,  0,265, 30,  0,  0,  0,
     & 269,0.333,  0,266, 21,  0,  0,  0,
     & 270,0.500,  0,265, 50,  0,  0,  0,
     & 270,0.500,  0,266, 46,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1692,1710)/
     & 271,0.290,  0,266, 38,  0,  0,  0,
     & 271,0.150,  0,265, 21,  0,  0,  0,
     & 271,0.290,  0,222, 38,  0,  0,  0,
     & 271,0.150,  0,221, 21,  0,  0,  0,
     & 271,0.060,  0,266, 38, 21,  0,  0,
     & 271,0.020,  0,265, 38, 30,  0,  0,
     & 271,0.010,  0,265, 21, 21,  0,  0,
     & 271,0.020,  0,222, 38, 21,  0,  0,
     & 271,0.010,  0,221, 38, 30,  0,  0,
     & 272,0.290,  0,265, 30,  0,  0,  0,
     & 272,0.150,  0,266, 21,  0,  0,  0,
     & 272,0.290,  0,221, 30,  0,  0,  0,
     & 272,0.150,  0,222, 21,  0,  0,  0,
     & 272,0.060,  0,265, 30, 21,  0,  0,
     & 272,0.020,  0,266, 38, 30,  0,  0,
     & 272,0.010,  0,266, 21, 21,  0,  0,
     & 272,0.020,  0,221, 30, 21,  0,  0,
     & 272,0.010,  0,222, 38, 30,  0,  0,
     & 273,0.350,  0,221, 50,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1711,1729)/
     & 273,0.350,  0,222, 46,  0,  0,  0,
     & 273,0.150,  0,265, 50,  0,  0,  0,
     & 273,0.150,  0,266, 46,  0,  0,  0,
     & 274,1.000,  0,245, 59,  0,  0,  0,
     & 275,1.000,  0,246, 59,  0,  0,  0,
     & 276,1.000,  0,247, 59,  0,  0,  0,
     & 277,0.667,  0,275, 30,  0,  0,  0,
     & 277,0.333,  0,274, 21,  0,  0,  0,
     & 278,0.667,  0,274, 38,  0,  0,  0,
     & 278,0.333,  0,275, 21,  0,  0,  0,
     & 279,0.500,  0,274, 42,  0,  0,  0,
     & 279,0.500,  0,275, 34,  0,  0,  0,
     & 280,0.290,  0,275, 30,  0,  0,  0,
     & 280,0.150,  0,274, 21,  0,  0,  0,
     & 280,0.290,  0,246, 30,  0,  0,  0,
     & 280,0.150,  0,245, 21,  0,  0,  0,
     & 280,0.060,  0,275, 30, 21,  0,  0,
     & 280,0.020,  0,274, 38, 30,  0,  0,
     & 280,0.010,  0,274, 21, 21,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1730,1748)/
     & 280,0.020,  0,246, 30, 21,  0,  0,
     & 280,0.010,  0,245, 38, 30,  0,  0,
     & 281,0.290,  0,274, 38,  0,  0,  0,
     & 281,0.150,  0,275, 21,  0,  0,  0,
     & 281,0.290,  0,245, 38,  0,  0,  0,
     & 281,0.150,  0,246, 21,  0,  0,  0,
     & 281,0.060,  0,274, 38, 21,  0,  0,
     & 281,0.020,  0,275, 38, 30,  0,  0,
     & 281,0.010,  0,275, 21, 21,  0,  0,
     & 281,0.020,  0,245, 38, 21,  0,  0,
     & 281,0.010,  0,246, 38, 30,  0,  0,
     & 282,0.350,  0,245, 42,  0,  0,  0,
     & 282,0.350,  0,246, 34,  0,  0,  0,
     & 282,0.150,  0,274, 42,  0,  0,  0,
     & 282,0.150,  0,275, 34,  0,  0,  0,
     & 285,1.000,  0, 24, 21,  0,  0,  0,
     & 286,0.998,  0, 24, 38,  0,  0,  0,
     & 286,0.002,  0, 38, 59,  0,  0,  0,
     & 287,0.998,  0, 24, 30,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1749,1767)/
     & 287,0.002,  0, 30, 59,  0,  0,  0,
     & 288,0.330,  0, 39, 30,  0,  0,  0,
     & 288,0.340,  0, 23, 21,  0,  0,  0,
     & 288,0.330,  0, 31, 38,  0,  0,  0,
     & 289,0.250,  0, 46, 35,  0,  0,  0,
     & 289,0.250,  0, 34, 47,  0,  0,  0,
     & 289,0.250,  0, 50, 43,  0,  0,  0,
     & 289,0.250,  0, 42, 51,  0,  0,  0,
     & 290,0.996,  0, 22, 21,  0,  0,  0,
     & 290,0.002,  0, 46, 34,  0,  0,  0,
     & 290,0.002,  0, 50, 42,  0,  0,  0,
     & 291,0.996,  0, 22, 38,  0,  0,  0,
     & 291,0.004,  0, 46, 42,  0,  0,  0,
     & 292,0.996,  0, 22, 30,  0,  0,  0,
     & 292,0.004,  0, 50, 34,  0,  0,  0,
     & 293,0.520,  0, 38, 30,  0,  0,  0,
     & 293,0.260,  0, 21, 21,  0,  0,  0,
     & 293,0.110,  0, 46, 34,  0,  0,  0,
     & 293,0.110,  0, 50, 42,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1768,1786)/
     & 294,0.620,  0, 38, 30,  0,  0,  0,
     & 294,0.310,  0, 21, 21,  0,  0,  0,
     & 294,0.035,  0, 46, 34,  0,  0,  0,
     & 294,0.035,  0, 50, 42,  0,  0,  0,
     & 295,1.000,  0,254, 59,  0,  0,  0,
     & 296,1.000,  0,230, 59,  0,  0,  0,
     & 297,1.000,  0,254, 59,  0,  0,  0,
     & 298,1.000,  0,230, 59,  0,  0,  0,
     & 299,1.000,  0,254, 59,  0,  0,  0,
     & 300,1.000,  0,230, 59,  0,  0,  0,
     & 301,0.050,  0,121,127,  0,  0,  0,
     & 301,0.050,  0,123,129,  0,  0,  0,
     & 301,0.017,  0,  1,  7,  0,  0,  0,
     & 301,0.066,  0,  2,  8,  0,  0,  0,
     & 301,0.017,  0,  3,  9,  0,  0,  0,
     & 301,0.640,130, 13, 13, 13,  0,  0,
     & 301,0.160,130, 13, 13, 59,  0,  0,
     & 302,0.022,  0, 38, 30, 38, 30, 23,
     & 302,0.016,  0, 38, 30, 38, 30,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1787,1805)/
     & 302,0.009,  0, 38, 30, 46, 34,  0,
     & 302,0.004,  0, 23, 38, 30,  0,  0,
     & 302,0.002,  0, 46, 43, 30,  0,  0,
     & 302,0.002,  0, 34, 51, 38,  0,  0,
     & 302,0.001,  0, 38, 30, 73, 91,  0,
     & 302,0.273,  0, 59,164,  0,  0,  0,
     & 302,0.671,  0, 13, 13,  0,  0,  0,
     & 303,0.022,  0, 38, 30, 38, 30,  0,
     & 303,0.019,  0, 38, 30, 46, 34,  0,
     & 303,0.012,  0, 38, 30, 38, 30, 23,
     & 303,0.007,  0, 23, 38, 30,  0,  0,
     & 303,0.002,  0, 46, 43, 30,  0,  0,
     & 303,0.002,  0, 34, 51, 38,  0,  0,
     & 303,0.003,  0, 38, 30, 73, 91,  0,
     & 303,0.002,  0, 38, 30,  0,  0,  0,
     & 303,0.002,  0, 46, 34,  0,  0,  0,
     & 303,0.001,  0, 21, 21,  0,  0,  0,
     & 303,0.135,  0, 59,164,  0,  0,  0,
     & 303,0.793,  0, 13, 13,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1806,1824)/
     & 304,1.000,  0, 13, 13,  0,  0,  0,
     & 305,1.000,  0, 13, 13,  0,  0,  0,
     & 306,0.050,  0, 59,231,  0,  0,  0,
     & 306,0.950,  0, 13, 13,  0,  0,  0,
     & 307,0.350,  0, 59,231,  0,  0,  0,
     & 307,0.650,  0, 13, 13,  0,  0,  0,
     & 308,0.220,  0, 59,231,  0,  0,  0,
     & 308,0.780,  0, 13, 13,  0,  0,  0,
     & 309,0.280,  0, 46, 31,  0,  0,  0,
     & 309,0.140,  0, 50, 23,  0,  0,  0,
     & 309,0.187,  0,327, 30,  0,  0,  0,
     & 309,0.093,  0,328, 21,  0,  0,  0,
     & 309,0.110,  0, 50, 24,  0,  0,  0,
     & 309,0.107,  0, 47, 30,  0,  0,  0,
     & 309,0.053,  0, 51, 21,  0,  0,  0,
     & 309,0.030,  0, 50,293,  0,  0,  0,
     & 310,0.280,  0, 50, 39,  0,  0,  0,
     & 310,0.140,  0, 46, 23,  0,  0,  0,
     & 310,0.187,  0,328, 38,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1825,1843)/
     & 310,0.093,  0,327, 21,  0,  0,  0,
     & 310,0.110,  0, 46, 24,  0,  0,  0,
     & 310,0.107,  0, 51, 38,  0,  0,  0,
     & 310,0.053,  0, 47, 21,  0,  0,  0,
     & 310,0.030,  0, 46,293,  0,  0,  0,
     & 311,0.280,  0, 34, 39,  0,  0,  0,
     & 311,0.140,  0, 42, 23,  0,  0,  0,
     & 311,0.187,  0,330, 38,  0,  0,  0,
     & 311,0.093,  0,329, 21,  0,  0,  0,
     & 311,0.110,  0, 42, 24,  0,  0,  0,
     & 311,0.107,  0, 35, 38,  0,  0,  0,
     & 311,0.053,  0, 43, 21,  0,  0,  0,
     & 311,0.030,  0, 42,293,  0,  0,  0,
     & 312,0.280,  0, 42, 31,  0,  0,  0,
     & 312,0.140,  0, 34, 23,  0,  0,  0,
     & 312,0.187,  0,329, 30,  0,  0,  0,
     & 312,0.093,  0,330, 21,  0,  0,  0,
     & 312,0.110,  0, 34, 24,  0,  0,  0,
     & 312,0.107,  0, 43, 30,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1844,1862)/
     & 312,0.053,  0, 35, 21,  0,  0,  0,
     & 312,0.030,  0, 34,293,  0,  0,  0,
     & 313,0.430,  0,140, 38,  0,  0,  0,
     & 313,0.215,  0,136, 21,  0,  0,  0,
     & 313,0.235,  0,140, 38, 21,  0,  0,
     & 313,0.120,  0,136, 38, 30,  0,  0,
     & 314,0.430,  0,136, 30,  0,  0,  0,
     & 314,0.215,  0,140, 21,  0,  0,  0,
     & 314,0.235,  0,136, 30, 21,  0,  0,
     & 314,0.120,  0,140, 38, 30,  0,  0,
     & 315,0.480,  0,136, 50,  0,  0,  0,
     & 315,0.480,  0,140, 46,  0,  0,  0,
     & 315,0.040,  0,145, 59,  0,  0,  0,
     & 316,0.430,  0,175, 30,  0,  0,  0,
     & 316,0.215,  0,171, 21,  0,  0,  0,
     & 316,0.235,  0,175, 30, 21,  0,  0,
     & 316,0.120,  0,171, 38, 30,  0,  0,
     & 317,0.430,  0,171, 38,  0,  0,  0,
     & 317,0.215,  0,175, 21,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1863,1881)/
     & 317,0.235,  0,171, 38, 21,  0,  0,
     & 317,0.120,  0,175, 38, 30,  0,  0,
     & 318,0.480,  0,171, 42,  0,  0,  0,
     & 318,0.480,  0,175, 34,  0,  0,  0,
     & 318,0.040,  0,180, 59,  0,  0,  0,
     & 319,0.540,  0,275, 30,  0,  0,  0,
     & 319,0.270,  0,274, 21,  0,  0,  0,
     & 319,0.030,  0,275, 30, 21,  0,  0,
     & 319,0.010,  0,274, 38, 30,  0,  0,
     & 319,0.010,  0,274, 21, 21,  0,  0,
     & 319,0.090,  0,246, 30, 21,  0,  0,
     & 319,0.030,  0,245, 38, 30,  0,  0,
     & 319,0.020,  0,245, 21, 21,  0,  0,
     & 320,0.540,  0,274, 38,  0,  0,  0,
     & 320,0.270,  0,275, 21,  0,  0,  0,
     & 320,0.030,  0,274, 38, 21,  0,  0,
     & 320,0.010,  0,275, 38, 30,  0,  0,
     & 320,0.010,  0,275, 21, 21,  0,  0,
     & 320,0.090,  0,245, 38, 21,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1882,1900)/
     & 320,0.030,  0,246, 38, 30,  0,  0,
     & 320,0.020,  0,246, 21, 21,  0,  0,
     & 321,0.500,  0,266, 46,  0,  0,  0,
     & 321,0.500,  0,265, 50,  0,  0,  0,
     & 322,1.000,  0,254, 59,  0,  0,  0,
     & 323,0.540,  0,266, 38,  0,  0,  0,
     & 323,0.270,  0,265, 21,  0,  0,  0,
     & 323,0.030,  0,266, 38, 21,  0,  0,
     & 323,0.010,  0,265, 38, 30,  0,  0,
     & 323,0.010,  0,265, 21, 21,  0,  0,
     & 323,0.090,  0,222, 38, 21,  0,  0,
     & 323,0.030,  0,221, 38, 30,  0,  0,
     & 323,0.020,  0,221, 21, 21,  0,  0,
     & 324,0.540,  0,265, 30,  0,  0,  0,
     & 324,0.270,  0,266, 21,  0,  0,  0,
     & 324,0.030,  0,265, 30, 21,  0,  0,
     & 324,0.010,  0,266, 38, 30,  0,  0,
     & 324,0.010,  0,266, 21, 21,  0,  0,
     & 324,0.090,  0,221, 30, 21,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1901,1919)/
     & 324,0.030,  0,222, 38, 30,  0,  0,
     & 324,0.020,  0,222, 21, 21,  0,  0,
     & 325,0.500,  0,275, 34,  0,  0,  0,
     & 325,0.500,  0,274, 42,  0,  0,  0,
     & 326,1.000,  0,230, 59,  0,  0,  0,
     & 327,0.667,  0, 50, 38,  0,  0,  0,
     & 327,0.333,  0, 46, 21,  0,  0,  0,
     & 328,0.667,  0, 46, 30,  0,  0,  0,
     & 328,0.333,  0, 50, 21,  0,  0,  0,
     & 329,0.667,  0, 34, 38,  0,  0,  0,
     & 329,0.333,  0, 42, 21,  0,  0,  0,
     & 330,0.667,  0, 42, 30,  0,  0,  0,
     & 330,0.333,  0, 34, 21,  0,  0,  0,
     & 331,0.667,  0,140, 38,  0,  0,  0,
     & 331,0.333,  0,136, 21,  0,  0,  0,
     & 332,0.667,  0,136, 30,  0,  0,  0,
     & 332,0.333,  0,140, 21,  0,  0,  0,
     & 333,0.500,  0,136, 50,  0,  0,  0,
     & 333,0.500,  0,140, 46,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1920,1938)/
     & 334,0.667,  0,175, 30,  0,  0,  0,
     & 334,0.333,  0,171, 21,  0,  0,  0,
     & 335,0.667,  0,171, 38,  0,  0,  0,
     & 335,0.333,  0,175, 21,  0,  0,  0,
     & 336,0.500,  0,171, 42,  0,  0,  0,
     & 336,0.500,  0,175, 34,  0,  0,  0,
     & 337,0.667,  0,246, 30,  0,  0,  0,
     & 337,0.333,  0,245, 21,  0,  0,  0,
     & 338,0.667,  0,245, 38,  0,  0,  0,
     & 338,0.333,  0,246, 21,  0,  0,  0,
     & 339,0.500,  0,246, 34,  0,  0,  0,
     & 339,0.500,  0,245, 42,  0,  0,  0,
     & 340,1.000,  0,254, 59,  0,  0,  0,
     & 341,0.667,  0,222, 38,  0,  0,  0,
     & 341,0.333,  0,221, 21,  0,  0,  0,
     & 342,0.667,  0,221, 30,  0,  0,  0,
     & 342,0.333,  0,222, 21,  0,  0,  0,
     & 343,0.500,  0,222, 46,  0,  0,  0,
     & 343,0.500,  0,221, 50,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1939,1957)/
     & 344,1.000,  0,230, 59,  0,  0,  0,
     & 345,1.000,  0,225, 30,  0,  0,  0,
     & 346,1.000,  0,225, 21,  0,  0,  0,
     & 347,1.000,  0,225, 21,  0,  0,  0,
     & 348,1.000,  0,225, 38,  0,  0,  0,
     & 349,0.600,  0,228, 38,  0,  0,  0,
     & 349,0.300,  0,227, 21,  0,  0,  0,
     & 349,0.100,  0,227, 59,  0,  0,  0,
     & 350,0.600,  0,228, 38,  0,  0,  0,
     & 350,0.300,  0,227, 21,  0,  0,  0,
     & 350,0.100,  0,227, 59,  0,  0,  0,
     & 351,0.600,  0,227, 30,  0,  0,  0,
     & 351,0.300,  0,228, 21,  0,  0,  0,
     & 351,0.100,  0,228, 59,  0,  0,  0,
     & 352,0.600,  0,227, 30,  0,  0,  0,
     & 352,0.300,  0,228, 21,  0,  0,  0,
     & 352,0.100,  0,228, 59,  0,  0,  0,
     & 353,1.000,  0,229, 59,  0,  0,  0,
     & 354,1.000,  0,249, 38,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1958,1976)/
     & 355,1.000,  0,249, 21,  0,  0,  0,
     & 356,1.000,  0,249, 21,  0,  0,  0,
     & 357,1.000,  0,249, 30,  0,  0,  0,
     & 358,0.600,  0,252, 30,  0,  0,  0,
     & 358,0.300,  0,251, 21,  0,  0,  0,
     & 358,0.100,  0,251, 59,  0,  0,  0,
     & 359,0.600,  0,252, 30,  0,  0,  0,
     & 359,0.300,  0,251, 21,  0,  0,  0,
     & 359,0.100,  0,251, 59,  0,  0,  0,
     & 360,0.600,  0,251, 38,  0,  0,  0,
     & 360,0.300,  0,252, 21,  0,  0,  0,
     & 360,0.100,  0,252, 59,  0,  0,  0,
     & 361,0.600,  0,251, 38,  0,  0,  0,
     & 361,0.300,  0,252, 21,  0,  0,  0,
     & 361,0.100,  0,252, 59,  0,  0,  0,
     & 362,1.000,  0,253, 59,  0,  0,  0,
     & 363,0.400,  0, 53, 38,  0,  0,  0,
     & 363,0.200,  0, 49, 21,  0,  0,  0,
     & 363,0.100,  0, 51, 38,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1977,1995)/
     & 363,0.050,  0, 47, 21,  0,  0,  0,
     & 363,0.150,  0, 46, 26,  0,  0,  0,
     & 363,0.050,  0, 46, 56,  0,  0,  0,
     & 363,0.050,  0, 46, 24,  0,  0,  0,
     & 364,0.400,  0, 49, 30,  0,  0,  0,
     & 364,0.200,  0, 53, 21,  0,  0,  0,
     & 364,0.100,  0, 47, 30,  0,  0,  0,
     & 364,0.050,  0, 51, 21,  0,  0,  0,
     & 364,0.150,  0, 50, 26,  0,  0,  0,
     & 364,0.050,  0, 50, 56,  0,  0,  0,
     & 364,0.050,  0, 50, 24,  0,  0,  0,
     & 365,0.400,  0, 37, 38,  0,  0,  0,
     & 365,0.200,  0, 45, 21,  0,  0,  0,
     & 365,0.100,  0, 35, 38,  0,  0,  0,
     & 365,0.050,  0, 43, 21,  0,  0,  0,
     & 365,0.150,  0, 42, 26,  0,  0,  0,
     & 365,0.050,  0, 42, 56,  0,  0,  0,
     & 365,0.050,  0, 42, 24,  0,  0,  0,
     & 366,0.400,  0, 45, 30,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=1996,2014)/
     & 366,0.200,  0, 37, 21,  0,  0,  0,
     & 366,0.100,  0, 43, 30,  0,  0,  0,
     & 366,0.050,  0, 35, 21,  0,  0,  0,
     & 366,0.150,  0, 34, 26,  0,  0,  0,
     & 366,0.050,  0, 34, 56,  0,  0,  0,
     & 366,0.050,  0, 34, 24,  0,  0,  0,
     & 367,0.258,  0, 50, 38,  0,  0,  0,
     & 367,0.129,  0, 46, 21,  0,  0,  0,
     & 367,0.209,  0, 50, 39,  0,  0,  0,
     & 367,0.105,  0, 46, 23,  0,  0,  0,
     & 367,0.199,  0, 51, 38,  0,  0,  0,
     & 367,0.100,  0, 47, 21,  0,  0,  0,
     & 368,0.258,  0, 46, 30,  0,  0,  0,
     & 368,0.129,  0, 50, 21,  0,  0,  0,
     & 368,0.209,  0, 46, 31,  0,  0,  0,
     & 368,0.105,  0, 50, 23,  0,  0,  0,
     & 368,0.199,  0, 47, 30,  0,  0,  0,
     & 368,0.100,  0, 51, 21,  0,  0,  0,
     & 369,0.258,  0, 34, 38,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=2015,2033)/
     & 369,0.129,  0, 42, 21,  0,  0,  0,
     & 369,0.209,  0, 34, 39,  0,  0,  0,
     & 369,0.105,  0, 42, 23,  0,  0,  0,
     & 369,0.199,  0, 35, 38,  0,  0,  0,
     & 369,0.100,  0, 43, 21,  0,  0,  0,
     & 370,0.258,  0, 42, 30,  0,  0,  0,
     & 370,0.129,  0, 34, 21,  0,  0,  0,
     & 370,0.209,  0, 42, 31,  0,  0,  0,
     & 370,0.105,  0, 34, 23,  0,  0,  0,
     & 370,0.199,  0, 43, 30,  0,  0,  0,
     & 370,0.100,  0, 35, 21,  0,  0,  0,
     & 371,0.400,  0, 53, 38,  0,  0,  0,
     & 371,0.200,  0, 49, 21,  0,  0,  0,
     & 371,0.100,  0, 51, 38,  0,  0,  0,
     & 371,0.050,  0, 47, 21,  0,  0,  0,
     & 371,0.150,  0, 46, 26,  0,  0,  0,
     & 371,0.050,  0, 46, 56,  0,  0,  0,
     & 371,0.050,  0, 46, 24,  0,  0,  0,
     & 372,0.400,  0, 49, 30,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=2034,2052)/
     & 372,0.200,  0, 53, 21,  0,  0,  0,
     & 372,0.100,  0, 47, 30,  0,  0,  0,
     & 372,0.050,  0, 51, 21,  0,  0,  0,
     & 372,0.150,  0, 50, 26,  0,  0,  0,
     & 372,0.050,  0, 50, 56,  0,  0,  0,
     & 372,0.050,  0, 50, 24,  0,  0,  0,
     & 373,0.400,  0, 37, 38,  0,  0,  0,
     & 373,0.200,  0, 45, 21,  0,  0,  0,
     & 373,0.100,  0, 35, 38,  0,  0,  0,
     & 373,0.050,  0, 43, 21,  0,  0,  0,
     & 373,0.150,  0, 42, 26,  0,  0,  0,
     & 373,0.050,  0, 42, 56,  0,  0,  0,
     & 373,0.050,  0, 42, 24,  0,  0,  0,
     & 374,0.400,  0, 45, 30,  0,  0,  0,
     & 374,0.200,  0, 37, 21,  0,  0,  0,
     & 374,0.100,  0, 43, 30,  0,  0,  0,
     & 374,0.050,  0, 35, 21,  0,  0,  0,
     & 374,0.150,  0, 34, 26,  0,  0,  0,
     & 374,0.050,  0, 34, 56,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=2053,2071)/
     & 374,0.050,  0, 34, 24,  0,  0,  0,
     & 375,0.300,  0, 50, 39,  0,  0,  0,
     & 375,0.150,  0, 46, 23,  0,  0,  0,
     & 375,0.182,  0, 51, 38,  0,  0,  0,
     & 375,0.091,  0, 47, 21,  0,  0,  0,
     & 375,0.130,  0, 50, 38,  0,  0,  0,
     & 375,0.065,  0, 46, 21,  0,  0,  0,
     & 375,0.082,  0, 46, 22,  0,  0,  0,
     & 376,0.300,  0, 46, 31,  0,  0,  0,
     & 376,0.150,  0, 50, 23,  0,  0,  0,
     & 376,0.182,  0, 47, 30,  0,  0,  0,
     & 376,0.091,  0, 51, 21,  0,  0,  0,
     & 376,0.130,  0, 46, 30,  0,  0,  0,
     & 376,0.065,  0, 50, 21,  0,  0,  0,
     & 376,0.082,  0, 50, 22,  0,  0,  0,
     & 377,0.300,  0, 34, 39,  0,  0,  0,
     & 377,0.150,  0, 42, 23,  0,  0,  0,
     & 377,0.182,  0, 35, 38,  0,  0,  0,
     & 377,0.091,  0, 43, 21,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=2072,2090)/
     & 377,0.130,  0, 34, 38,  0,  0,  0,
     & 377,0.065,  0, 42, 21,  0,  0,  0,
     & 377,0.082,  0, 42, 22,  0,  0,  0,
     & 378,0.300,  0, 42, 31,  0,  0,  0,
     & 378,0.150,  0, 34, 23,  0,  0,  0,
     & 378,0.182,  0, 43, 30,  0,  0,  0,
     & 378,0.091,  0, 35, 21,  0,  0,  0,
     & 378,0.130,  0, 42, 30,  0,  0,  0,
     & 378,0.065,  0, 34, 21,  0,  0,  0,
     & 378,0.082,  0, 34, 22,  0,  0,  0,
     & 379,0.562,  0, 26, 38,  0,  0,  0,
     & 379,0.155,  0, 39, 21,  0,  0,  0,
     & 379,0.155,  0, 23, 38,  0,  0,  0,
     & 379,0.088,  0,293, 38,  0,  0,  0,
     & 379,0.020,  0, 46, 43,  0,  0,  0,
     & 379,0.020,  0, 42, 47,  0,  0,  0,
     & 380,0.562,  0, 26, 21,  0,  0,  0,
     & 380,0.155,  0, 39, 30,  0,  0,  0,
     & 380,0.155,  0, 31, 38,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=2091,2109)/
     & 380,0.088,  0,293, 21,  0,  0,  0,
     & 380,0.010,  0, 46, 35,  0,  0,  0,
     & 380,0.010,  0, 50, 43,  0,  0,  0,
     & 380,0.010,  0, 34, 47,  0,  0,  0,
     & 380,0.010,  0, 42, 51,  0,  0,  0,
     & 381,0.562,  0, 26, 30,  0,  0,  0,
     & 381,0.155,  0, 31, 21,  0,  0,  0,
     & 381,0.155,  0, 23, 30,  0,  0,  0,
     & 381,0.088,  0,293, 30,  0,  0,  0,
     & 381,0.020,  0, 34, 51,  0,  0,  0,
     & 381,0.020,  0, 50, 35,  0,  0,  0,
     & 382,0.360,  0, 31, 38, 38,  0,  0,
     & 382,0.180,  0, 23, 38, 21,  0,  0,
     & 382,0.040,  0, 39, 21, 21,  0,  0,
     & 382,0.020,  0, 39, 38, 30,  0,  0,
     & 382,0.300,  0, 38, 21,  0,  0,  0,
     & 382,0.040,  0, 46, 43,  0,  0,  0,
     & 382,0.040,  0, 42, 47,  0,  0,  0,
     & 382,0.020,  0, 22, 39,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=2110,2128)/
     & 383,0.180,  0, 39, 30, 21,  0,  0,
     & 383,0.180,  0, 31, 38, 21,  0,  0,
     & 383,0.160,  0, 23, 21, 21,  0,  0,
     & 383,0.080,  0, 23, 38, 30,  0,  0,
     & 383,0.300,  0, 38, 30,  0,  0,  0,
     & 383,0.020,  0, 46, 35,  0,  0,  0,
     & 383,0.020,  0, 50, 43,  0,  0,  0,
     & 383,0.020,  0, 34, 47,  0,  0,  0,
     & 383,0.020,  0, 42, 51,  0,  0,  0,
     & 383,0.020,  0, 22, 23,  0,  0,  0,
     & 384,0.360,  0, 39, 30, 30,  0,  0,
     & 384,0.180,  0, 23, 30, 21,  0,  0,
     & 384,0.040,  0, 31, 21, 21,  0,  0,
     & 384,0.020,  0, 31, 30, 38,  0,  0,
     & 384,0.300,  0, 30, 21,  0,  0,  0,
     & 384,0.040,  0, 34, 51,  0,  0,  0,
     & 384,0.040,  0, 50, 35,  0,  0,  0,
     & 384,0.020,  0, 22, 31,  0,  0,  0,
     & 385,0.184,  0, 41, 21,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=2129,2147)/
     & 385,0.184,  0, 29, 38,  0,  0,  0,
     & 385,0.184,  0, 39, 23,  0,  0,  0,
     & 385,0.236,  0, 38, 21,  0,  0,  0,
     & 385,0.160,  0, 24, 38,  0,  0,  0,
     & 385,0.018,  0, 46, 43,  0,  0,  0,
     & 385,0.018,  0, 42, 47,  0,  0,  0,
     & 385,0.016,  0, 46, 42,  0,  0,  0,
     & 386,0.184,  0, 41, 30,  0,  0,  0,
     & 386,0.184,  0, 33, 38,  0,  0,  0,
     & 386,0.184,  0, 39, 31,  0,  0,  0,
     & 386,0.236,  0, 38, 30,  0,  0,  0,
     & 386,0.160,  0, 24, 21,  0,  0,  0,
     & 386,0.009,  0, 46, 35,  0,  0,  0,
     & 386,0.009,  0, 50, 43,  0,  0,  0,
     & 386,0.009,  0, 34, 47,  0,  0,  0,
     & 386,0.009,  0, 42, 51,  0,  0,  0,
     & 386,0.008,  0, 46, 34,  0,  0,  0,
     & 386,0.008,  0, 42, 50,  0,  0,  0,
     & 387,0.184,  0, 33, 21,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=2148,2166)/
     & 387,0.184,  0, 29, 30,  0,  0,  0,
     & 387,0.184,  0, 31, 23,  0,  0,  0,
     & 387,0.236,  0, 30, 21,  0,  0,  0,
     & 387,0.160,  0, 24, 30,  0,  0,  0,
     & 387,0.018,  0, 34, 51,  0,  0,  0,
     & 387,0.018,  0, 50, 35,  0,  0,  0,
     & 387,0.016,  0, 34, 50,  0,  0,  0,
     & 388,0.183,  0,231, 38, 30,  0,  0,
     & 388,0.091,  0,231, 21, 21,  0,  0,
     & 388,0.067,  0, 59,307,  0,  0,  0,
     & 388,0.066,  0, 59,308,  0,  0,  0,
     & 388,0.043,  0, 59,309,  0,  0,  0,
     & 388,0.446,130, 13, 13, 13,  0,  0,
     & 388,0.023,130, 13, 13, 59,  0,  0,
     & 388,0.013,  0,121,127,  0,  0,  0,
     & 388,0.013,  0,123,129,  0,  0,  0,
     & 388,0.013,  0,125,131,  0,  0,  0,
     & 388,0.004,  0,  1,  7,  0,  0,  0,
     & 388,0.017,  0,  2,  8,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=2167,2185)/
     & 388,0.004,  0,  3,  9,  0,  0,  0,
     & 388,0.017,  0,  4, 10,  0,  0,  0,
     & 389,0.046,  0, 59,388,  0,  0,  0,
     & 389,0.009,  0, 59,231,  0,  0,  0,
     & 389,0.755,  0, 13, 13,  0,  0,  0,
     & 389,0.030,  0,121,127,  0,  0,  0,
     & 389,0.030,  0,123,129,  0,  0,  0,
     & 389,0.030,  0,125,131,  0,  0,  0,
     & 389,0.010,  0,  1,  7,  0,  0,  0,
     & 389,0.040,  0,  2,  8,  0,  0,  0,
     & 389,0.010,  0,  3,  9,  0,  0,  0,
     & 389,0.040,  0,  4, 10,  0,  0,  0,
     & 390,0.210,  0, 59,388,  0,  0,  0,
     & 390,0.085,  0, 59,231,  0,  0,  0,
     & 390,0.565,  0, 13, 13,  0,  0,  0,
     & 390,0.022,  0,121,127,  0,  0,  0,
     & 390,0.022,  0,123,129,  0,  0,  0,
     & 390,0.022,  0,125,131,  0,  0,  0,
     & 390,0.007,  0,  1,  7,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=2186,2204)/
     & 390,0.030,  0,  2,  8,  0,  0,  0,
     & 390,0.007,  0,  3,  9,  0,  0,  0,
     & 390,0.030,  0,  4, 10,  0,  0,  0,
     & 391,0.162,  0, 59,388,  0,  0,  0,
     & 391,0.071,  0, 59,231,  0,  0,  0,
     & 391,0.615,  0, 13, 13,  0,  0,  0,
     & 391,0.024,  0,121,127,  0,  0,  0,
     & 391,0.024,  0,123,129,  0,  0,  0,
     & 391,0.024,  0,125,131,  0,  0,  0,
     & 391,0.008,  0,  1,  7,  0,  0,  0,
     & 391,0.032,  0,  2,  8,  0,  0,  0,
     & 391,0.008,  0,  3,  9,  0,  0,  0,
     & 391,0.032,  0,  4, 10,  0,  0,  0,
     & 392,0.034,  0,267, 38, 30,  0,  0,
     & 392,0.017,  0,267, 21, 21,  0,  0,
     & 392,0.044,  0,231, 38, 30,  0,  0,
     & 392,0.022,  0,231, 21, 21,  0,  0,
     & 392,0.050,  0,267, 59, 59,  0,  0,
     & 392,0.114,  0, 59,389,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=2205,2223)/
     & 392,0.113,  0, 59,390,  0,  0,  0,
     & 392,0.054,  0, 59,391,  0,  0,  0,
     & 392,0.403,130, 13, 13, 13,  0,  0,
     & 392,0.021,130, 13, 13, 59,  0,  0,
     & 392,0.020,  0,121,127,  0,  0,  0,
     & 392,0.020,  0,123,129,  0,  0,  0,
     & 392,0.020,  0,125,131,  0,  0,  0,
     & 392,0.007,  0,  1,  7,  0,  0,  0,
     & 392,0.027,  0,  2,  8,  0,  0,  0,
     & 392,0.007,  0,  3,  9,  0,  0,  0,
     & 392,0.027,  0,  4, 10,  0,  0,  0,
     & 393,0.250,  0,246,222,  0,  0,  0,
     & 393,0.250,  0,245,221,  0,  0,  0,
     & 393,0.385,130, 13, 13, 13,  0,  0,
     & 393,0.020,130, 13, 13, 59,  0,  0,
     & 393,0.015,  0,121,127,  0,  0,  0,
     & 393,0.015,  0,123,129,  0,  0,  0,
     & 393,0.015,  0,125,131,  0,  0,  0,
     & 393,0.005,  0,  1,  7,  0,  0,  0/
      DATA (IDK(I),BRFRAC(I),NME(I),(IDKPRD(J,I),J=1,5),I=2224,2226)/
     & 393,0.020,  0,  2,  8,  0,  0,  0,
     & 393,0.005,  0,  3,  9,  0,  0,  0,
     & 393,0.020,  0,  4, 10,  0,  0,  0/
      END
CDECK  ID>, HWUDKL.
*CMZ :-        -
*-- Author :    Ian Knowles
C-----------------------------------------------------------------------
      SUBROUTINE HWUDKL(ID,PMOM,DISP)
C-----------------------------------------------------------------------
C     Given a real or virtual particle, flavour ID and 4-momentum PMOM,
C     returns DISP its distance travelled in mm.
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,PMOM(4),DISP(4),PMOM2,SCALE
      INTEGER ID
      EXTERNAL HWRGEN
      PMOM2=(PMOM(4)+PMOM(3))*(PMOM(4)-PMOM(3))-PMOM(1)**2-PMOM(2)**2
      SCALE=-GEV2MM*LOG(HWRGEN(0))
     &      /SQRT((PMOM2-RMASS(ID)**2)**2+(PMOM2/DKLTM(ID))**2)
      CALL HWVSCA(4,SCALE,PMOM,DISP)
      END
CDECK  ID>, HWUDKS.
*CMZ :-        -
*-- Author :    Ian Knowles
C-----------------------------------------------------------------------
      SUBROUTINE HWUDKS
C-----------------------------------------------------------------------
C     Sets up internal pointers based on the decay table in HWUDAT or as
C     supplied via HWIODK. Computes CoM momenta of two-body decay modes.
C     Particles with long lifetimes or no allowed decay (excepting light
C     b hadrons when CLEO/EURODEC decays requested) are set stable, else
C     calculate DKLTM(I) = mass/width ( = mass * lifetime/hbar).
C     Gives warnings if: a particle has no decay modes or antiparticle's
C     modes are not the charge conjugates of the particles.
C     (N.B. CP violation permits this).
C
C     CORRECTED BY BRW 9/11/99 TO AGREE WITH VERSION 6.008
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWUPCM,HWUAEM,BRSUM,EPS,SCALE,BRTMP(NMXDKS),FN,X,
     & W,Q,FAC
      INTEGER HWUANT,I,IDKY,LAST,LTMP(NMXMOD),J,L,K,M,N,INDX(NMXMOD),
     & IRES,IAPDG,IPART,LR,LP,KPRDLR
      LOGICAL BPDK,TOPDKS,MATCH(5),PMATCH(NMXMOD)
      CHARACTER*7 CVETO(2)
      CHARACTER*8 CDUM
      EXTERNAL HWUPCM,HWUAEM,HWUANT
      PARAMETER(EPS=1.E-6)
      FN(X,Q,W)=X**6/(((X*X-Q*Q)**2+W*W*(X*X+Q*Q)-2.*W**4)
     &               *SQRT(X**4+Q**4+W**4-2.*(X*X*Q*Q+X*X*W*W+Q*Q*W*W)))
      WRITE(6,10)
  10  FORMAT(/10X,'Checking consistency of decay tables'/
     1        10X,'HWUDKS corrected by BW on 9 Nov 99'/)
      DKPSET=.TRUE.
C First zero arrays
      DO 20 I=1,NMXRES
      LSTRT(I)=0
  20  NMODES(I)=0
      DO 30 I=1,NMXDKS
      NPRODS(I)=0
      LNEXT(I)=0.
  30  CMMOM(I)=0
      BPDK=BDECAY.NE.'HERW'
      DO 180 I=1,NDKYS
C Search for next decaying particle type
      IDKY=IDK(I)
C Skip if particle is not recognised or already dealt with
      IF (IDKY.EQ.0.OR.IDKY.EQ.20) THEN
        WRITE(6,40) I
  40    FORMAT(1X,'Line ',I4,': decaying particle not recognised')
        GOTO 180
      ENDIF
      IF (NMODES(IDKY).GT.0) GOTO 180
C Check and include first decay mode, storing a copy
      CALL HWDCHK(IDKY,I,*180)
      LSTRT(IDKY)=I
      NMODES(IDKY)=1
      BRSUM=BRFRAC(I)
      LTMP(1)=I
      BRTMP(1)=-BRFRAC(I)
      LAST=I
C Sets CMMOM(IDKY) = CoM momentum for first 2-body decay mode I (else 0)
      IF (NPRODS(I).EQ.2) CMMOM(I)=
     & HWUPCM(RMASS(IDKY),RMASS(IDKPRD(1,I)),RMASS(IDKPRD(2,I)))
C Include any other decay modes of IDKY
      DO 120 J=I+1,NDKYS
      IF (IDK(J).EQ.IDKY) THEN
C First see if it is a copy of the same decay channel
        IF ((IDKPRD(2,J).GE.1.AND.IDKPRD(2,J).LE.13).OR.
     &      (IDKPRD(3,J).GE.1.AND.IDKPRD(3,J).LE.13)) THEN
C Partonic respect order
          L=LSTRT(IDKY)
          DO 50 K=1,NMODES(IDKY)
              IF (IDKPRD(1,L).EQ.IDKPRD(1,J).AND.
     &            IDKPRD(2,L).EQ.IDKPRD(2,J).AND.
     &            IDKPRD(3,L).EQ.IDKPRD(3,J).AND.
     &            IDKPRD(4,L).EQ.IDKPRD(4,J).AND.
     &            IDKPRD(5,L).EQ.IDKPRD(5,J)) GOTO 100
  50      L=LNEXT(L)
        ELSE
C Allow for different order in matching
          L=LSTRT(IDKY)
          DO 90 K=1,NMODES(IDKY)
          DO 60 M=1,5
  60      MATCH(M)=.FALSE.
          DO 80 M=1,5
          DO 70 N=1,5
          IF (.NOT.MATCH(N).AND.IDKPRD(N,L).EQ.IDKPRD(M,J)) THEN
            MATCH(N)=.TRUE.
            GOTO 80
          ENDIF
  70      CONTINUE
  80      CONTINUE
          IF (MATCH(1).AND.MATCH(2).AND.MATCH(3).AND.
     &        MATCH(4).AND.MATCH(5)) GOTO 100
  90      L=LNEXT(L)
        ENDIF
        CALL HWDCHK(IDKY,J,*120)
        NMODES(IDKY)=NMODES(IDKY)+1
        IF (NMODES(IDKY).GT.NMXMOD) CALL HWWARN('HWUDKS',100,*999)
        LNEXT(LAST)=J
        BRSUM=BRSUM+BRFRAC(J)
        LTMP(NMODES(IDKY))=J
        BRTMP(NMODES(IDKY))=-BRFRAC(J)
        LAST=J
C Sets CMMOM(IDKY) = CoM momentum for next 2-body decay mode J (else 0)
        IF (NPRODS(J).EQ.2) CMMOM(J)=
     &   HWUPCM(RMASS(IDKY),RMASS(IDKPRD(1,J)),RMASS(IDKPRD(2,J)))
      ENDIF
      GOTO 120
  100 WRITE(6,110) L,J,BRFRAC(J),NME(J)
      BRSUM=BRSUM-BRFRAC(L)+BRFRAC(J)
      BRFRAC(L)=BRFRAC(J)
      BRTMP(L)=-BRFRAC(L)
      NME(L)=NME(J)
  110 FORMAT(1X,'Line ',I4,' is the same as line ',I4/
     &       1X,'Take BR ',F5.3,' and ME code ',I3,' from second entry')
  120 CONTINUE
C Set sum of branching ratios to 1. if necessary
      IF (ABS(BRSUM-1.).GT.EPS) THEN
        WRITE(6,130) RNAME(IDKY),BRSUM
  130   FORMAT(1X,A8,': BR sum =',F8.5)
        IF (ABS(BRSUM).LT.EPS) THEN
          WRITE(6,140)
  140     FORMAT(1X,'Setting particle stable'/)
          NMODES(IDKY)=0
        ELSE
          WRITE(6,150)
  150     FORMAT(1X,'Rescaling to 1'/)
          SCALE=1./BRSUM
          K=LSTRT(IDKY)
          DO 160 J=1,NMODES(IDKY)
          BRFRAC(K)=SCALE*BRFRAC(K)
  160     K=LNEXT(K)
        ENDIF
      ENDIF
C Sort branching ratios into descending order and rearrange pointers
      CALL HWUSOR(BRTMP,NMODES(IDKY),INDX,2)
      LSTRT(IDKY)=LTMP(INDX(1))
      LNEXT(LTMP(INDX(1)))=LTMP(INDX(1))
      DO 170 J=2,NMODES(IDKY)
      IF (ABS(BRFRAC(LTMP(INDX(J)))).LT.EPS) THEN
        NMODES(IDKY)=J-1
        GOTO 175
      ENDIF
  170 LNEXT(LTMP(INDX(J-1)))=LTMP(INDX(J))
  175 LNEXT(LTMP(INDX(NMODES(IDKY))))=LTMP(INDX(NMODES(IDKY)))
  180 CONTINUE
C If not a short lived particle with a decay mode then set stable
      DO 190 I=1,NRES
      IF (.NOT.RSTAB(I).AND.RLTIM(I).LT.PLTCUT.AND.
     &    (NMODES(I).GT.0.OR.
     &     (BPDK.AND.((I.GE.221.AND.I.LE.231).OR.
     &                (I.GE.245.AND.I.LE.254))))) THEN
        DKLTM(I)=RLTIM(I)*RMASS(I)/HBAR
      ELSE
        RSTAB(I)=.TRUE.
      ENDIF
  190 CONTINUE
C Set up DKLTM for light quarks
      DO 200 I=1,5
      DKLTM(I)=RMASS(I)**2/VMIN2
  200 DKLTM(I+6)=DKLTM(I)
C gluon
      DKLTM(13)=RMASS(13)**2/VMIN2
C and diquarks
      DO 210 I=109,114
      DKLTM(I)=RMASS(I)**2/VMIN2
  210 DKLTM(I+6)=DKLTM(I)
C Set up DKLTM for weak bosons
      DKLTM(198)=EXAG*RMASS(198)/GAMW
      DKLTM(199)=DKLTM(198)
      DKLTM(200)=EXAG*RMASS(200)/GAMZ
      DKLTM(201)=EXAG*RMASS(201)/GAMH
      DKLTM(202)=EXAG*RMASS(202)/GAMZP
C Set up DKTRM for massive quarks (plus check m_Q > M_W + m_q)
      FAC=EXAG*HWUAEM(RMASS(198)**2)/(FOUR*SCABI*RMASS(198))**2
      IF (RMASS(6).GT.RMASS(5)+RMASS(198)) THEN
        DKLTM(6)=FAC*FN(RMASS(6  ),RMASS(5  ),RMASS(198))
        DKLTM(12)=DKLTM(6)
      ELSE
        WRITE(6,220) RNAME(6),RNAME(5),RNAME(198)
      ENDIF
      IF (RMASS(209).GT.RMASS(4)+RMASS(198)) THEN
        DKLTM(209)=FAC*FN(RMASS(209),RMASS(4  ),RMASS(198))
        DKLTM(215)=DKLTM(209)
      ELSE
        WRITE(6,220) RNAME(209),RNAME(4),RNAME(198)
      ENDIF
      IF (RMASS(210).GT.RMASS(209)+RMASS(198)) THEN
        DKLTM(210)=FAC*FN(RMASS(210),RMASS(209),RMASS(198))
        DKLTM(216)=DKLTM(210)
      ELSE
        WRITE(6,220) RNAME(210),RNAME(209),RNAME(198)
      ENDIF
      IF (RMASS(211).GT.RMASS(6)+RMASS(198)) THEN
        DKLTM(211)=FAC*FN(RMASS(211),RMASS(6  ),RMASS(198))
        DKLTM(217)=DKLTM(211)
      ELSE
        WRITE(6,220) RNAME(211),RNAME(6),RNAME(198)
      ENDIF
      IF (RMASS(212).GT.RMASS(211)+RMASS(198)) THEN
        DKLTM(212)=FAC*FN(RMASS(212),RMASS(211),RMASS(198))
        DKLTM(218)=DKLTM(212)
      ELSE
        WRITE(6,220) RNAME(212),RNAME(211),RNAME(198)
      ENDIF
 220  FORMAT(1X,'W not real in the decay: ',A8,' --> ',A8,' + ',A8)
C Now carry out diagnostic checks on decay table
      CALL HWDTOP(TOPDKS)
      DO 310 IRES=1,NRES
      IAPDG=ABS(IDPDG(IRES))
C Do not check (di-)quarks, gauge bosons, higgses or special particles
      IF ((IAPDG.GE.1.AND.IAPDG.LE.9).OR.MOD(IAPDG/10,10).EQ.0.OR.
     &    (IAPDG.GE.21.AND.IAPDG.LE.25).OR.IAPDG.EQ.32.OR.
     &    (IAPDG.GE.35.AND.IAPDG.LE.37).OR.
     &    IAPDG.EQ.91.OR.IAPDG.EQ.98.OR.IAPDG.EQ.99) THEN
        GOTO 310
C Ignore top hadrons if top decays
      ELSEIF(TOPDKS.AND.((IRES.GE.232.AND.IRES.LE.244).OR.
     &                   (IRES.GE.255.AND.IRES.LE.264))) THEN
        GOTO 310
C Ignore particles not produced in cluster or particle decays
      ELSEIF(VTOCDK(IRES).AND.VTORDK(IRES)) THEN
        GOTO 310
C Ignore B's if EURO or CLEO decay package used
      ELSEIF(((IRES.GE.221.AND.IRES.LE.223).OR.
     &        (IRES.GE.245.AND.IRES.LE.247)).AND.BDECAY.NE.'HERW') THEN
        WRITE(6,320) BDECAY,RNAME(IRES)
C Check decay modes exist for massive, short lived particles
      ELSEIF (NMODES(IRES).EQ.0.AND.RMASS(IRES).NE.ZERO.AND.
     &        RLTIM(IRES).LT.PLTCUT) THEN
        IF (VTOCDK(IRES)) THEN
          CVETO(1)='VETOED '
        ELSE
          CVETO(1)='ALLOWED'
        ENDIF
        IF (VTORDK(IRES)) THEN
          CVETO(2)='VETOED '
        ELSE
          CVETO(2)='ALLOWED'
        ENDIF
        WRITE(6,330) RNAME(IRES),CVETO(1),CVETO(2)
C ignore particles with no modes if massless or long lived
      ELSEIF (NMODES(IRES).EQ.0.AND.
     &        (RMASS(IRES).EQ.ZERO.OR.RLTIM(IRES).GT.PLTCUT)) THEN
        GOTO 310
      ELSEIF (IDPDG(IRES).LT.0) THEN
C Antiparticle: check decays are charge conjugates of particle decays
        CALL HWUIDT(1,-IDPDG(IRES),IPART,CDUM)
        IF (NMODES(IPART).EQ.0) THEN
C Nothing to compare to
          WRITE(6,340) RNAME(IPART),RNAME(IRES)
        ELSE
C First initialize particle matching array
          DO 230 I=1,NMODES(IPART)
  230     PMATCH(I)=.FALSE.
C Loop through antiparticle decay modes
          LR=LSTRT(IRES)
          DO 290 I=1,NMODES(IRES)
C Search for conjugate mode allowing for different particle order
          LP=LSTRT(IPART)
          DO 270 J=1,NMODES(IPART)
          IF (PMATCH(J)) GOTO 270
          DO 240 K=1,5
  240     MATCH(K)=.FALSE.
          DO 260 K=1,5
          KPRDLR=HWUANT(IDKPRD(K,LR))
          DO 250 L=1,5
          IF (.NOT.MATCH(L).AND.KPRDLR.EQ.IDKPRD(L,LP) ) THEN
            MATCH(L)=.TRUE.
            GOTO 260
          ENDIF
  250     CONTINUE
  260     CONTINUE
          IF (MATCH(1).AND.MATCH(2).AND.MATCH(3).AND.
     &        MATCH(4).AND.MATCH(5)) GOTO 280
  270     LP=LNEXT(LP)
C No match found
          WRITE(6,350) LR,RNAME(IRES),(RNAME(IDKPRD(J,LR)),J=1,5)
          GOTO 290
C Match found, check branching ratios and matrix element codes
  280     PMATCH(J)=.TRUE.
          IF (BRFRAC(LR).NE.BRFRAC(LP))
     &     WRITE(6,360) LR,RNAME(IRES),(RNAME(IDKPRD(J,LR)),J=1,5),
     &                  BRFRAC(LR),BRFRAC(LP)
          IF (NME(LR).NE.NME(LP))
     &     WRITE(6,370) LR,RNAME(IRES),(RNAME(IDKPRD(J,LR)),J=1,5),
     &                  NME(LR),NME(LP)
  290     LR=LNEXT(LR)
C Check for unmatched modes of particle conjugate to antiparticle
          LP=LSTRT(IPART)
          DO 300 I=1,NMODES(IPART)
          IF (.NOT.PMATCH(I))
     &     WRITE(6,350) LP,RNAME(IPART),(RNAME(IDKPRD(J,LP)),J=1,5)
  300     LP=LNEXT(LP)
        ENDIF
      ENDIF
  310 CONTINUE
  320 FORMAT(1X,A8,' decay package to be used for particle ',A8)
  330 FORMAT(1X,'No decay modes available for particle ',A8/
     & 1X,'Production in cluster decays ',A7,' and particle decays ',A7)
  340 FORMAT(1X,A8,' has no modes conjugate to those of ',A8)
  350 FORMAT(1X,'Line, ',I4,' decay: ',A8,' --> ',4(A8,1X),A8/
     &       1X,'A charge conjugate decay mode does not exist')
  360 FORMAT(1X,'Line, ',I4,' decay: ',A8,' --> ',4(A8,1X),A8/
     &       1X,'BR ',F5.3,' unequal to that of conjugate mode ',F5.3)
  370 FORMAT(1X,'Line, ',I4,' decay: ',A8,' --> ',4(A8,1X),A8/
     &       1X,'ME code ',I3,' unequal to that of conjugate mode ',I3)
  999 RETURN
      END

      SUBROUTINE OHWUDKS
C-----------------------------------------------------------------------
C     Sets up internal pointers based on the decay table in HWUDAT or as
C     supplied via HWIODK. Computes CoM momenta of two-body decay modes.
C     Particles with long lifetimes or no allowed decay (excepting light
C     b hadrons when CLEO/EURODEC decays requested) are set stable, else
C     calculate DKLTM(I) = mass/width ( = mass * lifetime/hbar).
C     Gives warnings if: a particle has no decay modes or antiparticle's
C     modes are not the charge conjugates of the particles.
C     (N.B. CP violation permits this).
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWUPCM,HWUAEM,BRSUM,EPS,SCALE,BRTMP(NMXMOD),FN,X,
     & W,Q,FAC
      INTEGER HWUANT,I,IDKY,LAST,LTMP(NMXMOD),J,L,K,M,N,INDX(NMXMOD),
     & IRES,IAPDG,IPART,LR,LP,KPRDLR
      LOGICAL BPDK,TOPDKS,MATCH(5),PMATCH(NMXMOD)
      CHARACTER*7 CVETO(2)
      CHARACTER*8 CDUM
      EXTERNAL HWUPCM,HWUAEM,HWUANT
      PARAMETER(EPS=1.E-6)
      FN(X,Q,W)=X**6/(((X*X-Q*Q)**2+W*W*(X*X+Q*Q)-2.*W**4)
     &               *SQRT(X**4+Q**4+W**4-2.*(X*X*Q*Q+X*X*W*W+Q*Q*W*W)))
      WRITE(6,10)
  10  FORMAT(/10X,'Checking consistency of decay tables'/)
      DKPSET=.TRUE.
C First zero arrays
      DO 20 I=1,NMXRES
      LSTRT(I)=0
  20  NMODES(I)=0
      DO 30 I=1,NMXDKS
      NPRODS(I)=0
      LNEXT(I)=0.
  30  CMMOM(I)=0
      BPDK=BDECAY.NE.'HERW'
      DO 180 I=1,NDKYS
C Search for next decaying particle type
      IDKY=IDK(I)
C Skip if particle is not recognised or already dealt with
      IF (IDKY.EQ.0.OR.IDKY.EQ.20) THEN
        WRITE(6,40) I
  40    FORMAT(1X,'Line ',I4,': decaying particle not recognised')
        GOTO 180
      ENDIF
      IF (NMODES(IDKY).GT.0) GOTO 180
C Check and include first decay mode, storing a copy
      CALL HWDCHK(IDKY,I,*180)
      LSTRT(IDKY)=I
      NMODES(IDKY)=1
      BRSUM=BRFRAC(I)
      LTMP(1)=I
      BRTMP(1)=-BRFRAC(I)
      LAST=I
C Sets CMMOM(IDKY) = CoM momentum for first 2-body decay mode I (else 0)
      IF (NPRODS(I).EQ.2) CMMOM(I)=
     & HWUPCM(RMASS(IDKY),RMASS(IDKPRD(1,I)),RMASS(IDKPRD(2,I)))
C Include any other decay modes of IDKY
      DO 120 J=I+1,NDKYS
      IF (IDK(J).EQ.IDKY) THEN
C First see if it is a copy of the same decay channel
        IF ((IDKPRD(2,J).GE.1.AND.IDKPRD(2,J).LE.13).OR.
     &      (IDKPRD(3,J).GE.1.AND.IDKPRD(3,J).LE.13)) THEN
C Partonic respect order
          L=LSTRT(IDKY)
          DO 50 K=1,NMODES(IDKY)
              IF (IDKPRD(1,L).EQ.IDKPRD(1,J).AND.
     &            IDKPRD(2,L).EQ.IDKPRD(2,J).AND.
     &            IDKPRD(3,L).EQ.IDKPRD(3,J).AND.
     &            IDKPRD(4,L).EQ.IDKPRD(4,J).AND.
     &            IDKPRD(5,L).EQ.IDKPRD(5,J)) GOTO 100
  50      L=LNEXT(L)
        ELSE
C Allow for different order in matching
          L=LSTRT(IDKY)
          DO 90 K=1,NMODES(IDKY)
          DO 60 M=1,5
  60      MATCH(M)=.FALSE.
          DO 80 M=1,5
          DO 70 N=1,5
          IF (.NOT.MATCH(N).AND.IDKPRD(N,L).EQ.IDKPRD(M,J)) THEN
            MATCH(N)=.TRUE.
            GOTO 80
          ENDIF
  70      CONTINUE
  80      CONTINUE
          IF (MATCH(1).AND.MATCH(2).AND.MATCH(3).AND.
     &        MATCH(4).AND.MATCH(5)) GOTO 100
  90      L=LNEXT(L)
        ENDIF
        CALL HWDCHK(IDKY,J,*120)
        NMODES(IDKY)=NMODES(IDKY)+1
        IF (NMODES(IDKY).GT.NMXMOD) CALL HWWARN('HWUDKS',100,*999)
        LNEXT(LAST)=J
        BRSUM=BRSUM+BRFRAC(J)
        LTMP(NMODES(IDKY))=J
        BRTMP(NMODES(IDKY))=-BRFRAC(J)
        LAST=J
C Sets CMMOM(IDKY) = CoM momentum for next 2-body decay mode J (else 0)
        IF (NPRODS(J).EQ.2) CMMOM(J)=
     &   HWUPCM(RMASS(IDKY),RMASS(IDKPRD(1,J)),RMASS(IDKPRD(2,J)))
      ENDIF
      GOTO 120
  100 WRITE(6,110) L,J,BRFRAC(L),NME(L)
      BRFRAC(J)=BRFRAC(L)
      NME(J)=NME(L)
  110 FORMAT(1X,'Line ',I4,' is the same as line ',I4/
     &       1X,'Take BR ',F5.3,' and ME code ',I3,' from second entry')
  120 CONTINUE
C Set sum of branching ratios to 1. if necessary
      IF (ABS(BRSUM-1.).GT.EPS) THEN
        WRITE(6,130) RNAME(IDKY),BRSUM
  130   FORMAT(1X,A8,': BR sum =',F8.5)
        IF (ABS(BRSUM).LT.EPS) THEN
          WRITE(6,140)
  140     FORMAT(1X,'Setting particle stable'/)
          NMODES(IDKY)=0
        ELSE
          WRITE(6,150)
  150     FORMAT(1X,'Rescaling to 1'/)
          SCALE=1./BRSUM
          K=LSTRT(IDKY)
          DO 160 J=1,NMODES(IDKY)
          BRFRAC(K)=SCALE*BRFRAC(K)
  160     K=LNEXT(K)
        ENDIF
      ENDIF
C Sort branching ratios into descending order and rearrange pointers
      CALL HWUSOR(BRTMP,NMODES(IDKY),INDX,2)
      LSTRT(IDKY)=LTMP(INDX(1))
      LNEXT(LTMP(INDX(1)))=LTMP(INDX(1))
      DO 170 J=2,NMODES(IDKY)
  170 LNEXT(LTMP(INDX(J-1)))=LTMP(INDX(J))
      LNEXT(LTMP(INDX(NMODES(IDKY))))=LTMP(INDX(NMODES(IDKY)))
  180 CONTINUE
C If not a short lived particle with a decay mode then set stable
      DO 190 I=1,NRES
      IF (.NOT.RSTAB(I).AND.RLTIM(I).LT.PLTCUT.AND.
     &    (NMODES(I).GT.0.OR.
     &     (BPDK.AND.((I.GE.221.AND.I.LE.231).OR.
     &                (I.GE.245.AND.I.LE.254))))) THEN
        DKLTM(I)=RLTIM(I)*RMASS(I)/HBAR
      ELSE
        RSTAB(I)=.TRUE.
      ENDIF
  190 CONTINUE
C Set up DKLTM for light quarks
      DO 200 I=1,5
      DKLTM(I)=VMIN2/RMASS(I)**2
  200 DKLTM(I+6)=DKLTM(I)
C gluon
      DKLTM(13)=VMIN2/RMASS(13)**2
C and diquarks
      DO 210 I=109,114
      DKLTM(I)=VMIN2/RMASS(I)**2
  210 DKLTM(I+6)=DKLTM(I)
C Set up DKLTM for weak bosons
      DKLTM(198)=EXAG*RMASS(198)/GAMW
      DKLTM(199)=DKLTM(198)
      DKLTM(200)=EXAG*RMASS(200)/GAMZ
      DKLTM(201)=EXAG*RMASS(201)/GAMH
      DKLTM(202)=EXAG*RMASS(202)/GAMZP
C Set up DKTRM for massive quarks (plus check m_Q > M_W + m_q)
      FAC=EXAG*HWUAEM(RMASS(198)**2)/(FOUR*SCABI*RMASS(198))**2
      IF (RMASS(6).GT.RMASS(5)+RMASS(198)) THEN
        DKLTM(6)=FAC*FN(RMASS(6  ),RMASS(5  ),RMASS(198))
        DKLTM(12)=DKLTM(6)
      ELSE
        WRITE(6,220) RNAME(6),RNAME(5),RNAME(198)
      ENDIF
      IF (RMASS(209).GT.RMASS(4)+RMASS(198)) THEN
        DKLTM(209)=FAC*FN(RMASS(209),RMASS(4  ),RMASS(198))
        DKLTM(215)=DKLTM(209)
      ELSE
        WRITE(6,220) RNAME(209),RNAME(4),RNAME(198)
      ENDIF
      IF (RMASS(210).GT.RMASS(209)+RMASS(198)) THEN
        DKLTM(210)=FAC*FN(RMASS(210),RMASS(209),RMASS(198))
        DKLTM(216)=DKLTM(210)
      ELSE
        WRITE(6,220) RNAME(210),RNAME(209),RNAME(198)
      ENDIF
      IF (RMASS(211).GT.RMASS(6)+RMASS(198)) THEN      
        DKLTM(211)=FAC*FN(RMASS(211),RMASS(6  ),RMASS(198))
        DKLTM(217)=DKLTM(211)
      ELSE
        WRITE(6,220) RNAME(211),RNAME(6),RNAME(198)
      ENDIF
      IF (RMASS(212).GT.RMASS(211)+RMASS(198)) THEN
        DKLTM(212)=FAC*FN(RMASS(212),RMASS(211),RMASS(198))
        DKLTM(218)=DKLTM(212)
      ELSE
        WRITE(6,220) RNAME(212),RNAME(211),RNAME(198)
      ENDIF
 220  FORMAT(1X,'W not real in the decay: ',A8,' --> ',A8,' + ',A8)
C Now carry out diagnostic checks on decay table
      CALL HWDTOP(TOPDKS)
      DO 310 IRES=1,NRES
      IAPDG=ABS(IDPDG(IRES))
C Do not check (di-)quarks, gauge bosons, higgses or special particles
      IF ((IAPDG.GE.1.AND.IAPDG.LE.9).OR.MOD(IAPDG/10,10).EQ.0.OR.
     &    (IAPDG.GE.21.AND.IAPDG.LE.25).OR.IAPDG.EQ.32.OR.
     &    (IAPDG.GE.35.AND.IAPDG.LE.37).OR.
     &    IAPDG.EQ.91.OR.IAPDG.EQ.9998.OR.IAPDG.EQ.9999) THEN
        GOTO 310
C Ignore top hadrons if top decays
      ELSEIF(TOPDKS.AND.((IRES.GE.232.AND.IRES.LE.244).OR.
     &                   (IRES.GE.255.AND.IRES.LE.264))) THEN
        GOTO 310
C Ignore particles not produced in cluster or particle decays
      ELSEIF(VTOCDK(IRES).AND.VTORDK(IRES)) THEN
        GOTO 310
C Ignore B's if EURO or CLEO decay package used
      ELSEIF(((IRES.GE.221.AND.IRES.LE.223).OR.
     &        (IRES.GE.245.AND.IRES.LE.247)).AND.BDECAY.NE.'HERW') THEN
        WRITE(6,320) BDECAY,RNAME(IRES)
C Check decay modes exist for massive, short lived particles
      ELSEIF (NMODES(IRES).EQ.0.AND.RMASS(IRES).NE.0..AND.
     &        RLTIM(IRES).LT.PLTCUT) THEN
        IF (VTOCDK(IRES)) THEN
          CVETO(1)='VETOED '
        ELSE
          CVETO(1)='ALLOWED'
        ENDIF
        IF (VTORDK(IRES)) THEN
          CVETO(2)='VETOED '
        ELSE
          CVETO(2)='ALLOWED'
        ENDIF
        WRITE(6,330) RNAME(IRES),CVETO(1),CVETO(2)
C ignore particles with no modes if massless or long lived
      ELSEIF (NMODES(IRES).EQ.0.AND.
     &        (RMASS(IRES).EQ.0..OR.RLTIM(IRES).GT.PLTCUT)) THEN
        GOTO 310
      ELSEIF (IDPDG(IRES).LT.0) THEN
C Antiparticle: check decays are charge conjugates of particle decays
        CALL HWUIDT(1,-IDPDG(IRES),IPART,CDUM)
        IF (NMODES(IPART).EQ.0) THEN
C Nothing to compare to
          WRITE(6,340) RNAME(IPART),RNAME(IRES)
        ELSE
C First initialize particle matching array
          DO 230 I=1,NMODES(IPART)
  230     PMATCH(I)=.FALSE.
C Loop through antiparticle decay modes
          LR=LSTRT(IRES)
          DO 290 I=1,NMODES(IRES)
C Search for conjugate mode allowing for different particle order
          LP=LSTRT(IPART)
          DO 270 J=1,NMODES(IPART)
          IF (PMATCH(J)) GOTO 270
          DO 240 K=1,5
  240     MATCH(K)=.FALSE.
          DO 260 K=1,5
          KPRDLR=HWUANT(IDKPRD(K,LR))
          DO 250 L=1,5
          IF (.NOT.MATCH(L).AND.KPRDLR.EQ.IDKPRD(L,LP) ) THEN
            MATCH(L)=.TRUE.
            GOTO 260
          ENDIF
  250     CONTINUE
  260     CONTINUE
          IF (MATCH(1).AND.MATCH(2).AND.MATCH(3).AND.
     &        MATCH(4).AND.MATCH(5)) GOTO 280
  270     LP=LNEXT(LP)
C No match found
          WRITE(6,350) LR,RNAME(IRES),(RNAME(IDKPRD(J,LR)),J=1,5)
          GOTO 290
C Match found, check branching ratios and matrix element codes
  280     PMATCH(J)=.TRUE.
          IF (BRFRAC(LR).NE.BRFRAC(LP))
     &     WRITE(6,360) LR,RNAME(IRES),(RNAME(IDKPRD(J,LR)),J=1,5),
     &                  BRFRAC(LR),BRFRAC(LP)
          IF (NME(LR).NE.NME(LP))
     &     WRITE(6,370) LR,RNAME(IRES),(RNAME(IDKPRD(J,LR)),J=1,5),
     &                  NME(LR),NME(LP)
  290     LR=LNEXT(LR)
C Check for unmatched modes of particle conjugate to antiparticle
          LP=LSTRT(IPART)
          DO 300 I=1,NMODES(IPART)
          IF (.NOT.PMATCH(I))
     &     WRITE(6,350) LP,RNAME(IPART),(RNAME(IDKPRD(J,LP)),J=1,5)
  300     LP=LNEXT(LP)
        ENDIF
      ENDIF
  310 CONTINUE
  320 FORMAT(1X,A8,' decay package to be used for particle ',A8)
  330 FORMAT(1X,'No decay modes available for particle ',A8/
     & 1X,'Production in cluster decays ',A7,' and particle decays ',A7)
  340 FORMAT(1X,A8,' has no modes conjugate to those of ',A8)
  350 FORMAT(1X,'Line, ',I4,' decay: ',A8,' --> ',4(A8,1X),A8/
     &       1X,'A charge conjugate decay mode does not exist')
  360 FORMAT(1X,'Line, ',I4,' decay: ',A8,' --> ',4(A8,1X),A8/
     &       1X,'BR ',F5.3,' unequal to that of conjugate mode ',F5.3)
  370 FORMAT(1X,'Line, ',I4,' decay: ',A8,' --> ',4(A8,1X),A8/
     &       1X,'ME code ',I3,' unequal to that of conjugate mode ',I3)
  999 RETURN
      END
CDECK  ID>, HWUDPR.
*CMZ :-        -
*-- Author :    Ian Knowles & Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWUDPR
C-----------------------------------------------------------------------
C     Prints out particle properies/decay tables
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      INTEGER I,NM,J,K,L
C---Print out table of particle properties
      WRITE (6,10) NRES
  10  FORMAT(1H1//30X,'TABLE OF PROPERTIES OF',I4,' PARTICLES USED'//
     &/5X,'Name IDPDG    Mass   Chg Spn Lifetime  Modes',
     &' Branching fractions ME codes and decay products')
      DO 60 I=1,NRES
      IF (VTOCDK(I).AND.VTORDK(I)) GOTO 60
      IF (NMODES(I).EQ.0) THEN
        WRITE (6,20) I,RNAME(I),IDPDG(I),RMASS(I),ICHRG(I),RSPIN(I),
     &               RLTIM(I),0
  20    FORMAT(/I4,1X,A8,1X,I8,1X,F7.3,1X,I2,1X,F3.1,1X,E9.3,1X,I3)
      ELSE
C and any decay modes
        IF (RSTAB(I)) THEN
          NM=0
        ELSEIF (VTOCDK(I)) THEN
          NM=-NMODES(I)
        ELSE
          NM=NMODES(I)
        ENDIF
        K=LSTRT(I)
        WRITE (6,30) I,RNAME(I),IDPDG(I),RMASS(I),ICHRG(I),RSPIN(I),
     &      RLTIM(I),NM,BRFRAC(K),NME(K),(RNAME(IDKPRD(L,K)),L=1,5)
  30    FORMAT(/I4,1X,A8,1X,I8,1X,F7.3,1X,I2,1X,F3.1,1X,E9.3,1X,I3,2X,
     &         F5.3,1X,I3,5(1X,A8))
        IF (NMODES(I).GE.2) THEN
          DO 40 J=2,NMODES(I)
          K=LNEXT(K)
  40      WRITE(6,50) BRFRAC(K),NME(K),(RNAME(IDKPRD(L,K)),L=1,5)
  50      FORMAT(53X,F5.3,1X,I3,5(1X,A8))
        ENDIF
      ENDIF
  60  CONTINUE
      END
CDECK  ID>, HWUECM.
*CMZ :-        -29/01/93  11.11.55  by  Bryan Webber
*-- Author :    Giovanni Abbiendi & Luca Stanco
C---------------------------------------------------------------------
      FUNCTION HWUECM (S,M1QUAD,M2QUAD)
C-----------------------------------------------------------------------
C     C.M. ENERGY OF A PARTICLE IN 1-->2 BRANCH, MAY BE SPACELIKE
C---------------------------------------------------------------------
      DOUBLE PRECISION HWUECM,S,M1QUAD,M2QUAD
      HWUECM = (S+M1QUAD-M2QUAD)/(2.D0*SQRT(S))
      END
CDECK  ID>, HWUEDT.
*CMZ :-        -09/12/91  12.07.08  by  Mike Seymour
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HWUEDT(N,IEDT)
C-----------------------------------------------------------------------
C     EDIT THE EVENT RECORD
C     IF N>0 DELETE THE N ENTRIES IN IEDT FROM EVENT RECORD
C     IF N<0 INSERT LINES AFTER THE -N ENTRIES IN IEDT
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      INTEGER N,IEDT(*),IMAP(0:NMXHEP),IHEP,I,J,I1,I2
      COMMON /HWUMAP/IMAP
C---MOVE ENTRIES AND CALCULATE MAPPING OF POINTERS
      IF (N.EQ.0) THEN
        RETURN
      ELSEIF (N.GT.0) THEN
        I=1
        I1=1
        I2=NHEP
      ELSE
        I=NHEP-N
        I1=NHEP
        I2=1
      ENDIF
      DO 110 IHEP=I1,I2,SIGN(1,I2-I1)
        IMAP(IHEP)=I
        DO 100 J=1,ABS(N)
          IF (IHEP.EQ.IEDT(J)) THEN
            IF (N.GT.0) IMAP(IHEP)=0
            I=I-1
            IF (N.LT.0) IMAP(IHEP)=I
          ENDIF
 100    CONTINUE
        IF (IMAP(IHEP).EQ.I .AND. IHEP.NE.I) THEN
          ISTHEP(I)=ISTHEP(IHEP)
          IDHW(I)=IDHW(IHEP)
          IDHEP(I)=IDHEP(IHEP)
          JMOHEP(1,I)=JMOHEP(1,IHEP)
          JMOHEP(2,I)=JMOHEP(2,IHEP)
          JDAHEP(1,I)=JDAHEP(1,IHEP)
          JDAHEP(2,I)=JDAHEP(2,IHEP)
          CALL HWVEQU(5,PHEP(1,IHEP),PHEP(1,I))
          CALL HWVEQU(4,VHEP(1,IHEP),VHEP(1,I))
          ISTHEP(IHEP)=0
          IDHW(IHEP)=20
          IDHEP(IHEP)=0
          JMOHEP(1,IHEP)=0
          JMOHEP(2,IHEP)=0
          JDAHEP(1,IHEP)=0
          JDAHEP(2,IHEP)=0
          CALL HWVZRO(5,PHEP(1,IHEP))
          CALL HWVZRO(4,VHEP(1,IHEP))
        ENDIF
        I=I+SIGN(1,N)
 110  CONTINUE
      NHEP=NHEP-N
C---RELABEL POINTERS, SETTING ANY WHICH WERE TO DELETED ENTRIES TO ZERO
      IMAP(0)=0
      DO 200 IHEP=1,NHEP
        JMOHEP(1,IHEP)=IMAP(JMOHEP(1,IHEP))
        JMOHEP(2,IHEP)=IMAP(JMOHEP(2,IHEP))
        JDAHEP(1,IHEP)=IMAP(JDAHEP(1,IHEP))
        JDAHEP(2,IHEP)=IMAP(JDAHEP(2,IHEP))
 200  CONTINUE
      END
CDECK  ID>, HWUEEC.
*CMZ :-        -26/04/91  14.22.30  by  Federico Carminati
*-- Author :    Bryan Webber and Ian Knowles
C-----------------------------------------------------------------------
      SUBROUTINE HWUEEC(IL)
C-----------------------------------------------------------------------
C     Loads cross-section coefficients, for kinematically open channels,
C     in llbar-->qqbar; lepton label IL=1-6: e,nu_e,mu,nu_mu,tau,nu_tau.
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION Q2
      INTEGER IL,JL,IQ
      Q2=EMSCA**2
      JL=IL+10
      MAXFL=0
      TQWT=0.
      DO 10 IQ=1,NFLAV
      IF (EMSCA.GT.2.*RMASS(IQ)) THEN
         MAXFL=MAXFL+1
         MAPQ(MAXFL)=IQ
         CALL HWUCFF(JL,IQ,Q2,CLQ(1,MAXFL))
         TQWT=TQWT+CLQ(1,MAXFL)
      ENDIF
  10  CONTINUE
      IF (MAXFL.EQ.0) CALL HWWARN('HWUEEC',100,*999)
  999 END
CDECK  ID>, HWUEMV.
*CMZ :-        -30/06/94  19.31.08  by  Mike Seymour
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HWUEMV(N,IFROM,ITO)
C-----------------------------------------------------------------------
C     MOVE A BLOCK OF ENTRIES IN THE EVENT RECORD
C     N ENTRIES IN HEPEVT STARTING AT IFROM ARE MOVED TO AFTER ITO
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      INTEGER N,IFROM,ITO,IMAP(0:NMXHEP),LFROM,LTO,I,IEDT(NMXHEP),IHEP,
     $ JHEP,KHEP
      COMMON /HWUMAP/IMAP
      LFROM=IFROM
      LTO=ITO
      DO 100 I=1,N
 100  IEDT(I)=LTO
      CALL HWUEDT(-N,IEDT)
      DO 300 I=1,N
        IHEP=LTO+I
        JHEP=IMAP(LFROM+I-1)
        ISTHEP(IHEP)=ISTHEP(JHEP)
        IDHW(IHEP)=IDHW(JHEP)
        IDHEP(IHEP)=IDHEP(JHEP)
        JMOHEP(1,IHEP)=JMOHEP(1,JHEP)
        JMOHEP(2,IHEP)=JMOHEP(2,JHEP)
        JDAHEP(1,IHEP)=JDAHEP(1,JHEP)
        JDAHEP(2,IHEP)=JDAHEP(2,JHEP)
        CALL HWVEQU(5,PHEP(1,JHEP),PHEP(1,IHEP))
        CALL HWVEQU(4,VHEP(1,JHEP),VHEP(1,IHEP))
        DO 200 KHEP=1,NHEP
          IF (JMOHEP(1,KHEP).EQ.JHEP) JMOHEP(1,KHEP)=IHEP
          IF (JMOHEP(2,KHEP).EQ.JHEP) JMOHEP(2,KHEP)=IHEP
          IF (JDAHEP(1,KHEP).EQ.JHEP) JDAHEP(1,KHEP)=IHEP
          IF (JDAHEP(2,KHEP).EQ.JHEP) JDAHEP(2,KHEP)=IHEP
 200    CONTINUE
        IEDT(I)=JHEP
 300  CONTINUE
      CALL HWUEDT(N,IEDT)
 999  END
CDECK  ID>, HWUEPR.
*CMZ :-        -26/04/91  10.18.58  by  Bryan Webber
*-- Author :    Bryan Webber
C----------------------------------------------------------------------
      SUBROUTINE HWUEPR
C-----------------------------------------------------------------------
C     PRINTS OUT EVENT DATA
C----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      INTEGER IH,K,IST,IS,JS,I,J,ID
      CHARACTER*28 TITLE(11)
      CHARACTER*40 HEADER(3)
      LOGICAL FIRST(11)
      DATA TITLE/'     ---INITIAL STATE---    ',
     &           '    ---HARD SUBPROCESS---   ',
     &           '    ---PARTON SHOWERS---    ',
     &           '    ---GLUON SPLITTING---   ',
     &           '   ---CLUSTER FORMATION---  ',
     &           '    ---CLUSTER DECAYS---    ',
     &           ' ---STRONG HADRON DECAYS--- ',
     &           ' ---HEAVY FLAVOUR DECAYS--- ',
     &           '  ---H/W/Z BOSON DECAYS---  ',
     &           ' ---SOFT UNDERLYING EVENT---',
     &           '  ---MULTIPLE SCATTERING--- '/
      DATA HEADER/' IHEP    ID    IDPDG IST MO1 MO2 DA1 DA2',
     &            '    P-X     P-Y     P-Z   ENERGY   MASS ',
     &            '   V-X        V-Y        V-Z       V-C*T'/
      IF (PRVTX) THEN
        IH=3
      ELSE
        IH=2
      ENDIF
      WRITE(6,10) NEVHEP,PBEAM1,PART1,PBEAM2,PART2,IPROC,
     &            NRN,ISTAT,IERROR,EVWGT
  10  FORMAT(///'  EVENT',I7,':',F8.2,' GEV/C ',A8,' ON',F8.2,
     & ' GEV/C ',A8,'  PROCESS:',I6//'  SEEDS:',I11,' &',I11,
     & '   STATUS:',I4,'  ERROR:',I4,'  WEIGHT:',E11.4)
  20  FORMAT(/23X,A28//1X,3A40)
      DO 30 K=1,11
  30  FIRST(K)=.TRUE.
      DO 40 J=1,NHEP
      IST=ISTHEP(J)
      IS=IST/10
      ID=IDHW(J)
      IF (IST.EQ.101) THEN
        WRITE (6,20) TITLE(1),(HEADER(I),I=1,IH)
      ELSEIF (FIRST(2).AND.IS.EQ.12) THEN
        WRITE (6,20) TITLE(2),(HEADER(I),I=1,IH)
        FIRST(2)=.FALSE.
      ELSEIF (FIRST(3).AND.IS.EQ.14) THEN
        WRITE (6,20) TITLE(3),(HEADER(I),I=1,IH)
        FIRST(3)=.FALSE.
        FIRST(8)=.TRUE.
        FIRST(9)=.TRUE.
        FIRST(11)=.TRUE.
      ELSEIF (FIRST(4).AND.IST.GE.158.AND.IST.NE.160
     &                .AND.IST.LE.162) THEN
        WRITE (6,20) TITLE(4),(HEADER(I),I=1,IH)
        FIRST(4)=.FALSE.
      ELSEIF (FIRST(5).AND.(IS.EQ.16.OR.IS.EQ.18)
     &                .AND.IST.GT.162) THEN
        WRITE (6,20) TITLE(5),(HEADER(I),I=1,IH)
        FIRST(5)=.FALSE.
      ELSEIF (IS.EQ.19.OR.IST.EQ.1.OR.IST.EQ.200) THEN
        JS=ISTHEP(JMOHEP(1,J))/10
        IF (JS.EQ.15.OR.JS.EQ.16.OR.JS.EQ.18) THEN
          IF (FIRST(6)) THEN
            WRITE (6,20) TITLE(6),(HEADER(I),I=1,IH)
            FIRST(6)=.FALSE.
          ENDIF
        ELSEIF (FIRST(7).AND.(.NOT.FIRST(6))) THEN
          WRITE (6,20) TITLE(7),(HEADER(I),I=1,IH)
          FIRST(7)=.FALSE.
        ENDIF
      ELSEIF (FIRST(8).AND.(IST.EQ.125.OR.IST.EQ.155.OR.
     &        (IST.EQ.123.AND.ISTHEP(JMOHEP(1,J)).EQ.199))) THEN
        WRITE (6,20) TITLE(8),(HEADER(I),I=1,IH)
        FIRST(3)=.TRUE.
        FIRST(4)=.TRUE.
        FIRST(5)=.TRUE.
        FIRST(6)=.TRUE.
        FIRST(7)=.TRUE.
        FIRST(8)=.FALSE.
      ELSEIF (FIRST(9).AND.(IST.EQ.123.OR.IST.EQ.124)) THEN
        JS=ABS(IDHEP(JMOHEP(1,J)))
        IF (JS.EQ.23.OR.JS.EQ.24.OR.JS.EQ.25) THEN
          WRITE (6,20) TITLE(9),(HEADER(I),I=1,IH)
          FIRST(3)=.TRUE.
          FIRST(4)=.TRUE.
          FIRST(5)=.TRUE.
          FIRST(6)=.TRUE.
          FIRST(7)=.TRUE.
          FIRST(8)=.TRUE.
          FIRST(9)=.FALSE.
        ENDIF
      ELSEIF (IST.EQ.170) THEN
        WRITE (6,20) TITLE(10),(HEADER(I),I=1,IH)
      ELSEIF (FIRST(11).AND.(ID.EQ.71.OR.ID.EQ.72)) THEN
        WRITE (6,20) TITLE(11),(HEADER(I),I=1,IH)
        FIRST(3)=.TRUE.
        FIRST(11)=.FALSE.
      ENDIF
      IF (PRNDEC) THEN
        IF (PRVTX) THEN
          WRITE(6,50) J,RNAME(IDHW(J)),IDHEP(J),IST,JMOHEP(1,J),
     &       JMOHEP(2,J),JDAHEP(1,J),JDAHEP(2,J),(PHEP(I,J),I=1,5),
     &       (VHEP(I,J),I=1,4)
        ELSE
          WRITE(6,51) J,RNAME(IDHW(J)),IDHEP(J),IST,JMOHEP(1,J),
     &       JMOHEP(2,J),JDAHEP(1,J),JDAHEP(2,J),(PHEP(I,J),I=1,5)
        ENDIF
      ELSE
        IF (PRVTX) THEN
          WRITE(6,60) J,RNAME(IDHW(J)),IDHEP(J),IST,JMOHEP(1,J),
     &     JMOHEP(2,J),JDAHEP(1,J),JDAHEP(2,J),(PHEP(I,J),I=1,5),
     &     (VHEP(I,J),I=1,4)
        ELSE
          WRITE(6,61) J,RNAME(IDHW(J)),IDHEP(J),IST,JMOHEP(1,J),
     &     JMOHEP(2,J),JDAHEP(1,J),JDAHEP(2,J),(PHEP(I,J),I=1,5)
        ENDIF
      ENDIF
  40  CONTINUE
  50  FORMAT(I5,1X,A8,I7,5I4,5F8.2,1P,4E11.3)
  51  FORMAT(I5,1X,A8,I7,5I4,5F8.2)
  60  FORMAT(Z5,1X,A8,I7,I4,4Z4,5F8.2,1P,4E11.3)
  61  FORMAT(Z5,1X,A8,I7,I4,4Z4,5F8.2)
      END
CDECK  ID>, HWUFNE.
*CMZ :-        -16/10/93  12.42.15  by  Mike Seymour
*-- Author :    Mike Seymour
C-----------------------------------------------------------------------
      SUBROUTINE HWUFNE
C-----------------------------------------------------------------------
C     FINALISES THE EVENT BY UNDOING THE LORENTZ BOOST IF THERE WAS ONE,
C     CHECKING FOR ERRORS, AND PRINTING
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      LOGICAL CALLED
      COMMON/HWDBUG/CALLED
      CALLED=.TRUE.
C---UNBOOST EVENT RECORD IF NECESSARY
      CALL HWUBST(0)
C---CHECK FOR FATAL ERROR
      IF (IERROR.NE.0) THEN
        IF (IERROR.GT.0) THEN
          NUMER=NUMER+1
        ELSE
          NUMERU=NUMERU+1
        ENDIF
        IF (NUMER.GT.MAXER) CALL HWWARN('HWUFNE',300,*999)
        NEVHEP=NEVHEP-1
C---PRINT FIRST MAXPR EVENTS
      ELSEIF (NEVHEP.LE.MAXPR) THEN
        CALL HWUEPR
      END IF
  999 END
CDECK  ID>, HWUGAU.
*CMZ :-        -26/04/91  11.11.56  by  Bryan Webber
*-- Author :    Adapted by Bryan Webber
C-----------------------------------------------------------------------
      FUNCTION HWUGAU(F,A,B,EPS)
C-----------------------------------------------------------------------
C     ADAPTIVE GAUSSIAN INTEGRATION OF FUNCTION F
C     IN INTERVAL (A,B) WITH PRECISION EPS
C     (MODIFIED CERN LIBRARY ROUTINE GAUSS)
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWUGAU,F,A,B,EPS,CONST,AA,BB,C1,C2,S8,U,S16,
     & W(12),X(12)
      INTEGER I
      EXTERNAL F
      DATA W/.1012285363D0,.2223810345D0,.3137066459D0,
     &       .3626837834D0,.0271524594D0,.0622535239D0,
     &       .0951585117D0,.1246289713D0,.1495959888D0,
     &       .1691565194D0,.1826034150D0,.1894506105D0/
      DATA X/.9602898565D0,.7966664774D0,.5255324099D0,
     &       .1834346425D0,.9894009350D0,.9445750231D0,
     &       .8656312024D0,.7554044084D0,.6178762444D0,
     &       .4580167777D0,.2816035508D0,.0950125098D0/
      HWUGAU=0.
      IF (A.EQ.B) RETURN
      CONST=.005/ABS(B-A)
      BB=A
    1 AA=BB
      BB=B
    2    C1=0.5*(BB+AA)
         C2=0.5*(BB-AA)
         S8=0.
         DO 3 I=1,4
            U=C2*X(I)
            S8=S8+W(I)*(F(C1+U)+F(C1-U))
    3    CONTINUE
         S8=C2*S8
         S16=0.
         DO 4 I=5,12
            U=C2*X(I)
            S16=S16+W(I)*(F(C1+U)+F(C1-U))
    4    CONTINUE
         S16=C2*S16
         IF (ABS(S16-S8).LE.EPS*(1.+ABS(S16))) GOTO 5
         BB=C1
         IF (1.+CONST*ABS(C2).NE.1.) GOTO 2
C---TOO HIGH ACCURACY REQUESTED
         CALL HWWARN('HWUGAU',500,*999)
    5 HWUGAU=HWUGAU+S16
      IF (BB.NE.B) GOTO 1
  999 END
CDECK  ID>, HWUIDT.
*CMZ :-        -26/04/91  10.18.58  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWUIDT(IOPT,IPDG,IWIG,NWIG)
C-----------------------------------------------------------------------
C     TRANSLATES PARTICLE IDENTIFIERS:
C     IPDG = PARTICLE DATA GROUP CODE
C     IWIG = HERWIG IDENTITY CODE
C     NWIG = HERWIG CHARACTER*8 NAME
C
C     IOPT= 1 GIVEN IPDG, RETURNS IWIG AND NWIG
C     IOPT= 2 GIVEN IWIG, RETURNS IPDG AND NWIG
C     IOPT= 3 GIVEN NWIG, RETURNS IPDG AND IWIG
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      INTEGER IOPT,IPDG,IWIG,I
      CHARACTER*8 NWIG
      IF (IOPT.EQ.1) THEN
        DO 10 I=0,NRES
        IF (IDPDG(I).EQ.IPDG) THEN
          IWIG=I
          NWIG=RNAME(I)
          RETURN
        ENDIF
  10    CONTINUE
        WRITE(6,20) IPDG
  20    FORMAT(1X,'Particle not recognised, PDG code: ',I7)
        IWIG=20
        NWIG=RNAME(20)
        CALL HWWARN('HWUIDT',101,*999)
      ELSEIF (IOPT.EQ.2) THEN
        IF (IWIG.LT.0.OR.IWIG.GT.NRES) THEN
          WRITE(6,30) IWIG
  30      FORMAT(1X,'Particle not recognised, HERWIG code: ',I3)
          IPDG=0
          NWIG=RNAME(20)
          CALL HWWARN('HWUIDT',102,*999)
        ELSE
          IPDG=IDPDG(IWIG)
          NWIG=RNAME(IWIG)
          RETURN
        ENDIF
      ELSEIF (IOPT.EQ.3) THEN
        DO 40 I=0,NRES
        IF (RNAME(I).EQ.NWIG) THEN
          IWIG=I
          IPDG=IDPDG(I)
          RETURN
        ENDIF
  40    CONTINUE
        WRITE(6,50) NWIG
  50    FORMAT(1X,'Particle not recognised, HERWIG name: ',A8)
        IWIG=20
        IPDG=0
        CALL HWWARN('HWUIDT',103,*999)
      ELSE
        CALL HWWARN('HWUIDT',404,*999)
      ENDIF
  999 END
CDECK  ID>, HWUINC.
*CMZ :-        -26/04/91  11.11.56  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWUINC
C-----------------------------------------------------------------------
C     COMPUTES CONSTANTS AND LOOKUP TABLES
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWBVMC,HWUALF,HWUPCM,XMIN,XMAX,XPOW,QR,DQKWT,
     & UQKWT,SQKWT,DIQWT,QMAX,PMAX,PTLIM,ETLIM,PGS,PTELM,X,QSCA,UPV,DNV,
     & USEA,DSEA,STR,CHM,BTM,TOP,GLU,VAL(20),CLMXPW,RCLPOW
      INTEGER ISTOP,I,J,IQK,IDB,IDT,ISET,IOP1,IOP2,IP2
      LOGICAL FIRST,FSTPDF
      CHARACTER*20 PARM(20)
      EXTERNAL HWBVMC,HWUALF,HWUPCM
      COMMON/HWRPIN/XMIN,XMAX,XPOW,FIRST
      COMMON/W50516/FSTPDF
      IPRO=MOD(IPROC/100,100)
      IQK=MOD(IPROC,100)
C---SET UP BEAMS
      CALL HWUIDT(3,IDB,IPART1,PART1)
      CALL HWUIDT(3,IDT,IPART2,PART2)
      EBEAM1=SQRT(PBEAM1**2+RMASS(IPART1)**2)
      EBEAM2=SQRT(PBEAM2**2+RMASS(IPART2)**2)
C---PHOTON CUTOFF DEFAULTS TO ROOT S
      PTLIM=SQRT(HALF*(EBEAM1*EBEAM2+PBEAM1*PBEAM2))
      ETLIM=TWO*PTLIM
      IF (VPCUT.GT.ETLIM) VPCUT=ETLIM
      IF (Q2MAX.GT.ETLIM**2) Q2MAX=ETLIM**2
C---PRINT OUT MOST IMPORTANT INPUT PARAMETERS
      IF (IPRINT.EQ.0) GOTO 50
      WRITE (6,10) PART1,PBEAM1,PART2,PBEAM2,IPROC,NFLAV,NSTRU,
     & AZSPIN,AZSOFT,QCDLAM,(RMASS(I),I=1,6),RMASS(13)
      IF (ISPAC.LE.1) THEN
        WRITE (6,20) VQCUT,VGCUT,VPCUT,CLMAX,QSPAC,PTRMS
      ELSE
        WRITE (6,30) VQCUT,VGCUT,VPCUT,CLMAX,QSPAC,PTRMS
      ENDIF
      IF (NOSPAC) WRITE (6,40)
  10  FORMAT(/10X,'INPUT CONDITIONS FOR THIS RUN'//
     &        10X,'BEAM 1 (',A8,') MOM. =',F10.2/
     &        10X,'BEAM 2 (',A8,') MOM. =',F10.2/
     &        10X,'PROCESS CODE (IPROC)   =',I8/
     &        10X,'NUMBER OF FLAVOURS     =',I5/
     &        10X,'STRUCTURE FUNCTION SET =',I5/
     &        10X,'AZIM SPIN CORRELATIONS =',L5/
     &        10X,'AZIM SOFT CORRELATIONS =',L5/
     &        10X,'QCD LAMBDA (GEV)       =',F10.4/
     &        10X,'DOWN     QUARK  MASS   =',F10.4/
     &        10X,'UP       QUARK  MASS   =',F10.4/
     &        10X,'STRANGE  QUARK  MASS   =',F10.4/
     &        10X,'CHARMED  QUARK  MASS   =',F10.4/
     &        10X,'BOTTOM   QUARK  MASS   =',F10.4/
     &        10X,'TOP      QUARK  MASS   =',F10.4/
     &        10X,'GLUON EFFECTIVE MASS   =',F10.4)
  20  FORMAT(10X,'EXTRA SHOWER CUTOFF (Q)=',F10.4/
     &       10X,'EXTRA SHOWER CUTOFF (G)=',F10.4/
     &       10X,'PHOTON SHOWER CUTOFF   =',F10.4/
     &       10X,'CLUSTER MASS PARAMETER =',F10.4/
     &       10X,'SPACELIKE EVOLN CUTOFF =',F10.4/
     &       10X,'INTRINSIC P-TRAN (RMS) =',F10.4)
  30  FORMAT(10X,'EXTRA SHOWER CUTOFF (Q)=',F10.4/
     &       10X,'EXTRA SHOWER CUTOFF (G)=',F10.4/
     &       10X,'PHOTON SHOWER CUTOFF   =',F10.4/
     &       10X,'CLUSTER MASS PARAMETER =',F10.4/
     &       10X,'PDF FREEZING CUTOFF    =',F10.4/
     &       10X,'INTRINSIC P-TRAN (RMS) =',F10.4)
  40  FORMAT(10X,'NO SPACE-LIKE SHOWERS')
  50  ISTOP=0
C---INITIALIZE ALPHA-STRONG
      IF ( QLIM.GT.ETLIM)  QLIM=ETLIM
      QR=HWUALF(0,QLIM)
C---DO SOME SAFETY CHECKS ON INPUT PARAMETERS
C Check beam order for point-like photon/QCD processes
      IF (IPRO.GE.50.AND.IPRO.LE.59.AND.
     &     IDB.NE.22.AND.ABS(IDB).NE.11.AND.ABS(IDB).NE.13) THEN
         WRITE(6,60)
  60     FORMAT(1X,'WARNING: require FIRST beam to be a photon/lepton')
         ISTOP=ISTOP+1
      ENDIF
      QG=HWBVMC(13)
      QR=QG/QCDL3
      IF (QR.GE.2.01) GOTO 80
      WRITE (6,70) QG,QCDLAM,QCDL3
  70  FORMAT(//10X,'SHOWER GLUON VIRTUAL MASS CUTOFF =',F8.5/
     &         10X,'TOO SMALL RELATIVE TO QCD LAMBDA =',F8.5/
     &         10X,'CORRESPONDS TO  3-FLAV MC LAMBDA =',F8.5)
      ISTOP=ISTOP+1
  80  QV=MIN(HWBVMC(1),HWBVMC(2))
      IF (QV.GE.QG/(QR-1.)) GOTO 100
      ISTOP=ISTOP+1
      WRITE (6,90) QV,QCDLAM,QCDL3
  90  FORMAT(//10X,'SHOWER QUARK VIRTUAL MASS CUTOFF =',F8.5/
     &         10X,'TOO SMALL RELATIVE TO QCD LAMBDA =',F8.5/
     &         10X,'CORRESPONDS TO  3-FLAV MC LAMBDA =',F8.5)
  100 IF (ISTOP.NE.0) THEN
        WRITE (6,110) ISTOP
  110   FORMAT(//10X,'EXECUTION PREVENTED BY',I2,
     &  ' ERRORS IN INPUT PARAMETERS.')
        STOP
      ENDIF
      DO 120 I=1,6
  120 RMASS(I+6)=RMASS(I)
      RMASS(199)=RMASS(198)
C---A PRIORI WEIGHTS FOR QUARK AND DIQUARKS
      DQKWT=PWT(1)
      UQKWT=PWT(2)
      SQKWT=PWT(3)
      DIQWT=PWT(7)
      PWT(10)=PWT(4)
      PWT(11)=PWT(5)
      PWT(12)=PWT(6)
C
      PWT(4)=UQKWT*UQKWT*DIQWT
      PWT(5)=UQKWT*DQKWT*DIQWT*HALF
      PWT(6)=DQKWT*DQKWT*DIQWT
      PWT(7)=UQKWT*SQKWT*DIQWT*HALF
      PWT(8)=DQKWT*SQKWT*DIQWT*HALF
      PWT(9)=SQKWT*SQKWT*DIQWT
      QMAX=MAX(PWT(1),PWT(2),PWT(3))
      PMAX=MAX(PWT(4),PWT(5),PWT(6),PWT(7),PWT(8),PWT(9),
     &         PWT(10),PWT(11),PWT(12),QMAX)
      PMAX=1./PMAX
      QMAX=1./QMAX
      DO 130 I=1,3
  130 QWT(I)=PWT(I)*QMAX
      DO 140 I=1,12
  140 PWT(I)=PWT(I)*PMAX
C  MASSES OF DIQUARKS (ASSUME BINDING NEGLIGIBLE)
      RMASS(109)=RMASS(2)+RMASS(2)
      RMASS(110)=RMASS(1)+RMASS(2)
      RMASS(111)=RMASS(1)+RMASS(1)
      RMASS(112)=RMASS(2)+RMASS(3)
      RMASS(113)=RMASS(1)+RMASS(3)
      RMASS(114)=RMASS(3)+RMASS(3)
      DO 150 I=109,114
  150 RMASS(I+6)=RMASS(I)
C  MASSES OF TOP HADRONS (ASSUME BINDING NEGLIGIBLE)
      RMASS(232)=RMASS(6)+RMASS(5)
      RMASS(233)=RMASS(6)+RMASS(1)
      RMASS(234)=RMASS(6)+RMASS(2)
      RMASS(235)=RMASS(6)+RMASS(3)
      RMASS(236)=RMASS(6)+RMASS(2)+RMASS(2)
      RMASS(237)=RMASS(6)+RMASS(1)+RMASS(2)
      RMASS(238)=RMASS(6)+RMASS(1)+RMASS(1)
      RMASS(239)=RMASS(6)+RMASS(2)+RMASS(3)
      RMASS(240)=RMASS(6)+RMASS(1)+RMASS(3)
      RMASS(241)=RMASS(6)+RMASS(3)+RMASS(3)
      RMASS(242)=RMASS(6)+RMASS(4)
      RMASS(243)=RMASS(6)+RMASS(5)
      RMASS(244)=RMASS(6)+RMASS(6)
      RMASS(232)=RMASS(243)
      DO 160 I=233,242
  160 RMASS(I+22)=RMASS(I)
C Set up an array of cluster mass threholds
      CLMXPW=CLMAX**CLPOW
      RCLPOW=ONE/CLPOW
      CALL HWVZRO(144,CTHRPW(1,1))
      DO 170 I=1,6
      DO 170 J=1,6
      CTHRPW(I ,J  )=(CLMXPW+(RMASS(I    )+RMASS(J+6  ))**CLPOW)**RCLPOW
      CTHRPW(I ,J+6)=(CLMXPW+(RMASS(I    )+RMASS(J+108))**CLPOW)**RCLPOW
  170 CTHRPW(I+6,J )=(CLMXPW+(RMASS(I+114)+RMASS(J+6  ))**CLPOW)**RCLPOW
C Decay length conversion factor GEV2MM hbar.c/e
      GEV2MM=1.D-15*SQRT(GEV2NB/10.)
C Plank's constant/2pi (GeV.s)
      HBAR=GEV2MM/CSPEED
C---IMPORTANCE SAMPLING
      FIRST=.TRUE.
      IF (IPRO.EQ.5) THEN
        IF (EMMAX.GT.ETLIM)  EMMAX=ETLIM
        IF (PTMAX.GT.PTLIM)  PTMAX=PTLIM
      ELSEIF (IPRO.EQ.13) THEN
        IF (EMMIN.EQ.0)      EMMIN=10
        IF (EMMAX.GT.ETLIM)  EMMAX=ETLIM
        IF (IQK.GT.0.AND.IQK.LE.6) EMMIN=MAX(EMMIN,2*RMASS(IQK))
        XMIN=EMMIN
        XMAX=EMMAX
        XPOW=-EMPOW
      ELSEIF (IPRO.EQ.15.OR.IPRO.EQ.17.OR.IPRO.EQ.18.OR.IPRO.EQ.21
     &    .OR.IPRO.EQ.22.OR.IPRO.EQ.23.OR.IPRO.EQ.24.OR.IPRO.EQ.50
     &    .OR.IPRO.EQ.51.OR.IPRO.EQ.53.OR.IPRO.EQ.55) THEN
        IF (PTMAX.GT.PTLIM)  PTMAX=PTLIM
        IF (IQK.NE.0.AND.IQK.LT.7.AND.IPRO.NE.23) THEN
          XMIN=2.*SQRT(PTMIN**2+RMASS(IQK)**2)
          XMAX=2.*SQRT(PTMAX**2+RMASS(IQK)**2)
          IF (XMAX.GT.ETLIM)  XMAX=ETLIM
        ELSE
          XMIN=2.*PTMIN
          XMAX=2.*PTMAX
        ENDIF
        XPOW=-PTPOW
      ELSEIF (IPRO.EQ.52) THEN
         PTELM=PTLIM-RMASS(IQK)**2/(4.*PTLIM)
         IF (PTMAX.GT.PTELM) PTMAX=PTELM
         XMIN=PTMIN
         XMAX=PTMAX
         XPOW=-PTPOW
      ELSEIF (IPRO.EQ.90) THEN
        XMIN=SQRT(Q2MIN)
        XMAX=SQRT(Q2MAX)
        XPOW=1.-2.*Q2POW
      ELSEIF (IPRO.EQ.91) THEN
        IF (EMMAX.GT.ETLIM) EMMAX=ETLIM
      ENDIF
C---CALCULATE HIGGS WIDTH
      IF (IPRO.EQ. 3.OR.IPRO.EQ. 4.OR.IPRO.EQ.16.OR.IPRO.EQ.19
     &.OR.IPRO.EQ.23.OR.IPRO.EQ.95) THEN
        GAMH=RMASS(201)
        CALL HWDHIG(GAMH)
      ENDIF
C---IF Q**2 CAN BE TOO SMALL, BREIT FRAME MAKES NO SENSE
      IF ((IPRO/10.EQ.9.AND.Q2MIN.LE.1.D-2).OR.
     &    (IPRO.EQ.91.AND.IQK.EQ.7)) BREIT=.FALSE.
      IF (IPRINT.NE.0) THEN
        IF (PBEAM1.NE.PBEAM2) WRITE (6,180) USECMF
        IF (IPRO.EQ.91.OR.IPRO.EQ.92)
     &      WRITE (6,190) PTMIN
        IF (IPRO.EQ.90.OR.(IPRO.EQ.91.AND.IQK.NE.7).OR.IPRO.EQ.92)
     &      WRITE (6,200) Q2MIN,Q2MAX,BREIT
        IF (IPRO.EQ.90.OR.(IPRO.EQ.91.AND.IQK.NE.7).OR.IPRO.EQ.92)
     &      WRITE (6,210) YBMIN,YBMAX
        IF (IPRO.EQ.91.AND.IQK.EQ.7)
     &      WRITE (6,220) Q2WWMN,Q2WWMX,BREIT,ZJMAX
        IF (IPROC/10.EQ.11) WRITE (6,230) THMAX
        IF (IPRO.EQ.13) WRITE (6,240) EMMIN,EMMAX
        IF (IPRO.EQ.15.OR.IPRO.EQ.17.OR.IPRO.EQ.18.OR.IPRO.EQ.21
     &  .OR.IPRO.EQ.22.OR.IPRO.EQ.23.OR.IPRO.EQ.24.OR.IPRO.EQ.50
     &  .OR.IPRO.EQ.51.OR.IPRO.EQ.52.OR.IPRO.EQ.53.OR.IPRO.EQ.55)
     &      WRITE (6,250) PTMIN,PTMAX
        IF (IPRO.EQ. 3.OR.IPRO.EQ. 4.OR.IPRO.EQ.16.OR.IPRO.EQ.19
     &  .OR.IPRO.EQ.23.OR.IPRO.EQ.95)
     &      WRITE (6,260) RMASS(201),GAMH,
     &      GAMMAX,RMASS(201)+GAMMAX*GAMH,(BRHIG(I)*100,I=1,12)
        IF (IPRO.EQ.91) WRITE (6,270) BGSHAT,EMMIN,EMMAX
        IF (IPRO.EQ.5.AND.IQK.LT.50)
     &      WRITE (6,280) EMMIN,EMMAX,PTMIN,PTMAX,CTMAX
        IF (IPRO.EQ.5.AND.IQK.GE.50)
     &      WRITE (6,290) EMMIN,EMMAX,Q2MIN,Q2MAX,PTMIN
        IF (IPRO.GT.10.AND.
     &    (IPRO.LT.90.AND.(ABS(IDB).EQ.11.OR.ABS(IDB).EQ.13).OR.
     &                    (ABS(IDT).EQ.11.OR.ABS(IDT).EQ.13))) THEN
          WRITE (6,300) Q2WWMN,Q2WWMX,YWWMIN,YWWMAX
          IF (PHOMAS.GT.ZERO) WRITE (6,310) PHOMAS
        ENDIF
        IF (IPROC/10.EQ.10.OR.IPRO.EQ.90)
     &      WRITE (6,320) HARDME,SOFTME
        IF (IPRO.LE.3 .AND. ZMXISR.GT.0) WRITE (6,330) TMNISR,ONE-ZMXISR
        IF (WHMIN.GT.ZERO .AND. IPRO.GT.10.AND.(IPRO.EQ.90.OR.
     &       (ABS(IDB).EQ.11.OR.ABS(IDB).EQ.13).OR.
     &       (ABS(IDT).EQ.11.OR.ABS(IDT).EQ.13))) WRITE (6,340) WHMIN
  180   FORMAT(10X,'USE BEAM-TARGET C.M.F. =',L5)
  190   FORMAT(10X,'MIN P-T FOR O(AS) DILS =',F10.4)
  200   FORMAT(10X,'MIN ABS(Q**2) FOR DILS =',E10.4/
     &         10X,'MAX ABS(Q**2) FOR DILS =',E10.4/
     &         10X,'BREIT FRAME SHOWERING  =',L5)
  210   FORMAT(10X,'MIN BJORKEN Y FOR DILS =',F10.4/
     &         10X,'MAX BJORKEN Y FOR DILS =',F10.4)
  220   FORMAT(10X,'MIN ABS(Q**2) FOR J/PSI=',E10.4/
     &         10X,'MAX ABS(Q**2) FOR J/PSI=',E10.4/
     &         10X,'BREIT FRAME SHOWERING  =',L5/
     &         10X,'MAX Z FOR J/PSI        =',F10.4)
  230   FORMAT(10X,'MAX THRUST FOR 2->3    =',F10.4)
  240   FORMAT(10X,'MIN MASS FOR DRELL-YAN =',F10.4/
     &         10X,'MAX MASS FOR DRELL-YAN =',F10.4)
  250   FORMAT(10X,'MIN P-TRAN FOR 2->2    =',F10.4/
     &         10X,'MAX P-TRAN FOR 2->2    =',F10.4)
  260   FORMAT(10X,'HIGGS BOSON MASS       =',F10.4/
     &         10X,'HIGGS BOSON WIDTH      =',F10.4/
     &         10X,'CUTOFF = EMH +',F4.1,'*GAMH=',F10.4/
     &         10X,'HIGGS          D DBAR  =',F10.4/
     &         10X,'BRANCHING      U UBAR  =',F10.4/
     &         10X,'FRACTIONS      S SBAR  =',F10.4/
     &         10X,'(PER CENT)     C CBAR  =',F10.4/
     &         10X,'               B BBAR  =',F10.4/
     &         10X,'               T TBAR  =',F10.4/
     &         10X,'              E+ E-    =',F10.4/
     &         10X,'             MU+ MU-   =',F10.4/
     &         10X,'            TAU+ TAU-  =',F10.4/
     &         10X,'               W W     =',F10.4/
     &         10X,'               Z Z     =',F10.4/
     &         10X,'           GAMMA GAMMA =',F10.4)
  270   FORMAT(10X,'SCALE FOR BGF IS S-HAT =',L5/
     &         10X,'MIN MASS FOR BGF       =',F10.4/
     &         10X,'MAX MASS FOR BGF       =',F10.4)
  280   FORMAT(10X,'MIN MASS FOR 2 PHOTONS =',F10.4/
     &         10X,'MAX MASS FOR 2 PHOTONS =',F10.4/
     &         10X,'MIN PT OF 2 PHOTON CMF =',F10.4/
     &         10X,'MAX PT OF 2 PHOTON CMF =',F10.4/
     &         10X,'MAX COS THETA IN CMF   =',F10.4)
  290   FORMAT(10X,'MIN MASS FOR GAMMA + W =',F10.4/
     &         10X,'MAX MASS FOR GAMMA + W =',F10.4/
     &         10X,'MIN ABS(Q**2)          =',E10.4/
     &         10X,'MAX ABS(Q**2)          =',E10.4/
     &         10X,'MIN PT                 =',F10.4)
  300   FORMAT(10X,'MIN Q**2 FOR WW PHOTON =',F10.4/
     &         10X,'MAX Q**2 FOR WW PHOTON =',F10.4/
     &         10X,'MIN MOMENTUM FRACTION  =',F10.4/
     &         10X,'MAX MOMENTUM FRACTION  =',F10.4)
  310   FORMAT(10X,'GAMMA* S.F. MASS PARAM =',F10.4)
  320   FORMAT(10X,'HARD M.E. MATCHING     =',L5/
     &         10X,'SOFT M.E. MATCHING     =',L5)
  330   FORMAT(10X,'MIN MTM FRAC FOR ISR   =',1PE10.4/
     &         10X,'1-MAX MTM FRAC FOR ISR =',1PE10.4)
  340   FORMAT(10X,'MINIMUM HADRONIC MASS  =',F10.4)
        IF (LWEVT.LE.0) THEN
          WRITE (6,350)
        ELSE
          WRITE (6,360) LWEVT
        ENDIF
  350   FORMAT(/10X,'NO EVENTS WILL BE WRITTEN TO DISK')
  360   FORMAT(/10X,'EVENTS WILL BE OUTPUT ON UNIT',I4)
      ENDIF
C Verify and print beam polarisations
      IF (IPRO.EQ.1.OR.IPRO.EQ.3) THEN
C Set up transverse polarisation parameters for e+e-
        IF ((EPOLN(1)**2+EPOLN(2)**2)
     &     *(PPOLN(1)**2+PPOLN(2)**2).GT.0.) THEN
          TPOL=.TRUE.
          COSS=EPOLN(1)*PPOLN(1)-EPOLN(2)*PPOLN(2)
          SINS=EPOLN(2)*PPOLN(1)+EPOLN(1)*PPOLN(2)
        ELSE
          TPOL=.FALSE.
        ENDIF
C print out lepton beam polarisation(s)
        IF (IPRINT.NE.0) THEN
          IF (IPART1.EQ.121) THEN
            WRITE (6,370) PART1,EPOLN,PART2,PPOLN
          ELSE
            WRITE (6,370) PART1,PPOLN,PART2,EPOLN
          ENDIF
 370      FORMAT(/10X,A8,'Beam polarisation=',3F10.4/
     &            10X,A8,'Beam polarisation=',3F10.4)
        ENDIF
      ELSEIF (IPRO.GE.90.AND.IPRO.LE.99) THEN
        IF (IDB.GE.11.AND.IDB.LE.16) THEN
          CALL HWVZRO(3,PPOLN)
C Check neutrino polarisations for DIS
          IF (IDB.EQ. 12.OR.IDB.EQ. 14.OR.IDB.EQ. 16.AND.
     &        EPOLN(3).NE.-1.) EPOLN(3)=-1.
          IF (IPRINT.NE.0) WRITE(6,380) PART1,EPOLN(3)
        ELSE
          CALL HWVZRO(3,EPOLN)
C Check anti-neutrino polarisations for DIS
          IF (IDB.EQ.-12.OR.IDB.EQ.-14.OR.IDB.EQ.-16.AND.
     &        PPOLN(3).NE. 1.) PPOLN(3)=+1.
          IF (IPRINT.NE.0) WRITE(6,380) PART1,PPOLN(3)
        ENDIF
 380    FORMAT(/10X,A8,1X,'Longitudinal beam polarisation=',F10.4/)
      ENDIF
      IF (IPRINT.NE.0) THEN
        IF (ZPRIME) THEN
          WRITE(6,390) RMASS(200),RMASS(202),GAMZ,GAMZP
          WRITE(6,400) (RNAME(I),VFCH(I,1),AFCH(I,1),VFCH(I,2),
     &                  AFCH(I,2),I=1,6)
          WRITE(6,400) (RNAME(110+I),VFCH(I,1),AFCH(I,1),
     &                  VFCH(I,2),AFCH(I,2),I=11,16)
  390     FORMAT(/10X,'MASSIVE NEUTRAL VECTOR BOSON PARAMS'/
     &            10X,'Z   MASS=',F10.4,7X,'Z-PRIME MASS=',F10.4/
     &            10X,'   WIDTH=',F10.4,7X,'       WIDTH=',F10.4/
     &            10X,'FERMION COUPLINGS: e.(V.1+A.G_5)G_mu'/
     &            10X,'FERMION:  VECTOR     AXIAL',6X,
     &                'VECTOR     AXIAL'/)
  400     FORMAT(10X,A8,2X,F10.4,1X,F10.4,1X,F10.4,1X,F10.4)
        ENDIF
        IF (MIXING) THEN
          WRITE(6,410) XMIX(2),YMIX(2),XMIX(1),YMIX(1)
  410     FORMAT(/10X,'B_d: Delt-M/Gam =',F6.4,
     &                ' Delt-Gam/2*Gam =',F6.4,/
     &            10X,'B_s: Delt-M/Gam =',F6.2,
     &                ' Delt-Gam/2*Gam =',F6.4)
        ENDIF
        IF (CLRECO) WRITE(6,420) PRECO,EXAG
  420   FORMAT(/10X,'Colour rearrangement ALLOWED, probability =',F6.4,/
     &          10x,'Weak boson life-time exaggeration factor =',F10.6)
C---PDF STRUCTURE FUNCTIONS
        WRITE (6,'(X)')
        DO 450 I=1,2
          IF (MODPDF(I).GE.0) THEN
            WRITE (6,430) I,MODPDF(I),AUTPDF(I)
          ELSE
            WRITE (6,440) I
          ENDIF
 430      FORMAT(10X,'PDFLIB USED FOR BEAM',I2,': SET',I3,' OF ',A20)
 440      FORMAT(10X,'PDFLIB NOT USED FOR BEAM',I2)
 450    CONTINUE
C---GET THE UGLY INITIALISATION MESSAGES OVER AND DONE WITH NOW TOO
        DO 460 I=1,2
          IF (MODPDF(I).GE.0) THEN
            PARM(1)=AUTPDF(I)
            VAL(1)=MODPDF(I)
            FSTPDF=.TRUE.
            X=0.5
            QSCA=10
C---FIX TO CALL SCHULER-SJOSTRAND CODE
            IF (AUTPDF(I).EQ.'SaSph') THEN
              ISET=MOD(MODPDF(I),10)
              IOP1=MOD(MODPDF(I)/10,2)
              IOP2=MOD(MODPDF(I)/20,2)
              IP2=MODPDF(I)/100
              IF (ISET.EQ.1) THEN
                WRITE (6,'(10X,A)')'SCHULER-SJOSTRAND PHOTON PDF SET 1D'
              ELSEIF (ISET.EQ.2) THEN
                WRITE (6,'(10X,A)')'SCHULER-SJOSTRAND PHOTON PDF SET 1M'
              ELSEIF (ISET.EQ.3) THEN
                WRITE (6,'(10X,A)')'SCHULER-SJOSTRAND PHOTON PDF SET 2D'
              ELSEIF (ISET.EQ.4) THEN
                WRITE (6,'(10X,A)')'SCHULER-SJOSTRAND PHOTON PDF SET 2M'
              ELSE
                WRITE (6,'(10X,A)')'UNKNOWN SCHULER-SJOSTRAND PDF SET'
                CALL HWWARN('HWUINC',500,*999)
              ENDIF
              IF (IOP1.EQ.1) THEN
                WRITE (6,'(10X,A)') 'WITH DIRECT COMPONENT IN DIS'
                IF (IPRO.NE.90) WRITE (6,'(10X,A)')
     $               'NOT RECOMMENDED FOR NON-DIS PROCESSES'
              ENDIF
              IF (IOP2.EQ.1) THEN
                WRITE (6,'(10X,A)') 'WITH P**2 DEPENDENCE INCLUDED'
                IF (PHOMAS.GT.0)
     $          WRITE (6,'(10X,A)') 'NOT RECOMMENDED WITH PHOMAS.GT.0'
                IF (IP2.GT.0)
     $          WRITE (6,'(10X,A,I2)') 'WITH IP2 OPTION EQUAL TO',IP2
              ENDIF
            ELSEIF (AUTPDF(I).EQ.'SSph') THEN
              WRITE (6,'(10X,A)') 'THE ACRONYM FOR SCHULER-SJOSTRAND'
              WRITE (6,'(10X,A)') 'HAS CHANGED TO SaSph ACCORDING TO'
              WRITE (6,'(10X,A)') 'THEIR WISHES.  SSph NO LONGER WORKS'
              STOP
            ELSE
              CALL PDFSET(PARM,VAL)
              CALL STRUCTM(X,QSCA,UPV,DNV,USEA,DSEA,STR,CHM,BTM,TOP,GLU)
            ENDIF
          ENDIF
 460    CONTINUE
        WRITE (6,'(X)')
      ENDIF
C Set up neutral B meson mixing parameters
      IF (MIXING.AND..NOT.(RSTAB(223).AND.RSTAB(247))) THEN
        XMRCT(1)=XMIX(1)*RMASS(223)/(CSPEED*RLTIM(223))
        YMRCT(1)=YMIX(1)*RMASS(223)/(CSPEED*RLTIM(223))
      ENDIF
      IF (MIXING.AND..NOT.(RSTAB(221).AND.RSTAB(245))) THEN
        XMRCT(2)=XMIX(2)*RMASS(221)/(CSPEED*RLTIM(221))
        YMRCT(2)=YMIX(2)*RMASS(221)/(CSPEED*RLTIM(221))
      ENDIF
C---B DECAY PACKAGE
      IF (BDECAY.EQ.'EURO') THEN
        IF (IPRINT.NE.0) WRITE (6,470) 'EURODEC'
      ELSEIF (BDECAY.EQ.'CLEO') THEN
        IF (IPRINT.NE.0) WRITE (6,470) 'CLEO'
      ELSE
        BDECAY='HERW'
      ENDIF
  470 FORMAT (10X,A,' B DECAY PACKAGE WILL BE USED')
C---COMPUTE PARTICLE PROPERTIES FOR HADRONIZATION
      CALL HWURES
C Prepare internal decay tables and do diagnostic checks
      CALL HWUDKS
C Print particle decay tables here
      IF (IPRINT.GE.2) CALL HWUDPR
C---MISCELLANEOUS DERIVED QUANTITIES
      TMTOP=2.*LOG(RMASS(6)/30.)
      PXRMS=PTRMS/SQRT(2.)
      ZBINM=0.25/ZBINM
      PSPLT=1./PSPLT
      NDTRY=2*NCTRY
      NGSPL=0
      PGSMX=0.
      DO 480 I=1,4
      PGS=HWUPCM(RMASS(13),RMASS(I),RMASS(I))
      IF (PGS.GE.0.) NGSPL=I
      IF (PGS.GE.PGSMX) PGSMX=PGS
  480 PGSPL(I)=PGS
      CALL HWVZRO(6,PTINT)
      IF (IPRO.NE.80) THEN
C---SET UP TABLES OF SUDAKOV FORM FACTORS, GIVING
C   PROBABILITY DISTRIBUTION IN VARIABLE Q = E*SQRT(XI)
        NSUD=NFLAV
        CALL HWBSUD
C---SET PARAMETERS FOR SPACELIKE BRANCHING
        DO 500 I=1,NSUD
        DO 490 J=2,NQEV
        IF (QEV(J,I).GT.QSPAC) GOTO 500
  490   CONTINUE
  500   NSPAC(I)=J-1
      ENDIF
      EVWGT=AVWGT
      ISTAT=1
  999 END
CDECK  ID>, HWUINE.
*CMZ :-        -16/10/93  12.42.15  by  Mike Seymour
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWUINE
C-----------------------------------------------------------------------
C     INITIALISES AN EVENT
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      DOUBLE PRECISION HWRGEN,HWRGET,DUMMY
      REAL TL
      LOGICAL CALLED
      EXTERNAL HWRGEN,HWRGET
      COMMON/HWDBUG/CALLED
C---CHECK THAT MAIN PROGRAM HAS BEEN MODIFIED CORRECTLY
      IF (NEVHEP.GT.0.AND..NOT.CALLED) THEN
        WRITE (6,10)
 10     FORMAT (1X,'A call to the subroutine HWUFNE should be added to',
     &      /,' the main program, immediately after the call to HWMEVT')
        CALL HWWARN('HWUINE',500,*999)
      ENDIF
      CALLED=.FALSE.
C---CHECK TIME LEFT
      CALL HWUTIM(TL)
      IF (TL.LT.TLOUT) CALL HWWARN('HWUINE',200,*999)
C---UPDATE RANDOM NUMBER SEED
      DUMMY = HWRGET(NRN)
      NEVHEP=NEVHEP+1
      NHEP=0
      ISTAT=6
      IERROR=0
      EVWGT=AVWGT
      HVFCEN=.FALSE.
      ISLENT=1
      NQDK=0
C---DECIDE WHETHER TO GENERATE SOFT UNDERLYING EVENT
CBB   compute GENSOFT in 2 steps to avoid calling HWRGEN on some
CBB   platforms ...      
CBB      GENSOF=IPROC.GT.1000.AND.IPROC.LT.10000.AND.
CBB     &      (IPROC.EQ.8000.OR.HWRGEN(0).LT.PRSOF)
      GENSOF=.FALSE.
      IF (IPROC.GT.1000.AND.IPROC.LT.10000) THEN
         IF  (IPROC.EQ.8000.OR.HWRGEN(0).LT.PRSOF) GENSOF=.TRUE.
      ENDIF 
C Zero arrays
      CALL HWVZRO(2*NMXHEP,JMOHEP)
      CALL HWVZRO(2*NMXHEP,JDAHEP)
      CALL HWVZRO(4*NMXHEP,VHEP)
      CALL HWVZRO(3*NMXHEP,RHOHEP)
      EMSCA=ZERO
  999 END
CDECK  ID>, HWULB4.
*CMZ :-        -05/11/95  19.33.42  by  Mike Seymour
*-- Author :    Adapted by Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWULB4(PS,PI,PF)
C-----------------------------------------------------------------------
C     TRANSFORMS PI (GIVEN IN REST FRAME OF PS) INTO PF (IN LAB)
C     N.B. P(1,2,3,4) = (PX,PY,PZ,E); PS(5)=M
C-----------------------------------------------------------------------
      DOUBLE PRECISION PF4,FN,PS(5),PI(4),PF(4)
      IF (PS(4).EQ.PS(5)) THEN
        PF(1)= PI(1)
        PF(2)= PI(2)
        PF(3)= PI(3)
        PF(4)= PI(4)
      ELSE
        PF4  = (PI(1)*PS(1)+PI(2)*PS(2)
     &         +PI(3)*PS(3)+PI(4)*PS(4))/PS(5)
        FN   = (PF4+PI(4)) / (PS(4)+PS(5))
        PF(1)= PI(1) + FN*PS(1)
        PF(2)= PI(2) + FN*PS(2)
        PF(3)= PI(3) + FN*PS(3)
        PF(4)= PF4
      END IF
      END
CDECK  ID>, HWULDO.
*CMZ :-        -26/04/91  11.11.56  by  Bryan Webber
*-- Author :    Bryan Webber
C----------------------------------------------------------------------
      FUNCTION HWULDO(P,Q)
C----------------------------------------------------------------------
C   LORENTZ 4-VECTOR DOT PRODUCT
C----------------------------------------------------------------------
      DOUBLE PRECISION HWULDO,P(4),Q(4)
      HWULDO=P(4)*Q(4)-(P(1)*Q(1)+P(2)*Q(2)+P(3)*Q(3))
      END
CDECK  ID>, HWULF4.
*CMZ :-        -05/11/95  19.33.42  by  Mike Seymour
*-- Author :    Adapted by Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWULF4(PS,PI,PF)
C-----------------------------------------------------------------------
C     TRANSFORMS PI (GIVEN IN LAB) INTO PF (IN REST FRAME OF PS)
C     N.B. P(1,2,3,4) = (PX,PY,PZ,E); PS(5)=M
C-----------------------------------------------------------------------
      DOUBLE PRECISION PF4,FN,PS(5),PI(4),PF(4)
      IF (PS(4).EQ.PS(5)) THEN
        PF(1)= PI(1)
        PF(2)= PI(2)
        PF(3)= PI(3)
        PF(4)= PI(4)
      ELSE
        PF4  = (PI(4)*PS(4)-PI(3)*PS(3)
     &         -PI(2)*PS(2)-PI(1)*PS(1))/PS(5)
        FN   = (PF4+PI(4)) / (PS(4)+PS(5))
        PF(1)= PI(1) - FN*PS(1)
        PF(2)= PI(2) - FN*PS(2)
        PF(3)= PI(3) - FN*PS(3)
        PF(4)= PF4
      END IF
      END
CDECK  ID>, HWULI2.
*CMZ :-        -23/08/94  13.22.29  by  Mike Seymour
*-- Author :    Ulrich Baur & Nigel Glover, adapted by Ian Knowles
C-----------------------------------------------------------------------
      FUNCTION HWULI2(X)
C-----------------------------------------------------------------------
C     Complex dilogarithm function, Li_2 (Spence function)
C-----------------------------------------------------------------------
      IMPLICIT NONE
      DOUBLE COMPLEX HWULI2,PROD,Y,Y2,X,Z
      DOUBLE PRECISION XR,XI,R2,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,ZETA2,
     & ZERO,ONE,HALF
      PARAMETER (ZERO =0.D0, ONE =1.D0, HALF=0.5D0)
      DATA A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,ZETA2/ -0.250000000000000D0,
     & -0.111111111111111D0,-0.010000000000000D0,-0.017006802721088D0,
     & -0.019444444444444D0,-0.020661157024793D0,-0.021417300648069D0,
     & -0.021948866377231D0,-0.022349233811171D0,-0.022663689135191D0,
     &  1.644934066848226D0/
      PROD(Y,Y2)=Y*(ONE+A1*Y*(ONE+A2*Y*(ONE+A3*Y2*(ONE+A4*Y2*(ONE+A5*Y2*
     & (ONE+A6*Y2*(ONE+A7*Y2*(ONE+A8*Y2*(ONE+A9*Y2*(ONE+A10*Y2))))))))))
      XR=DREAL(X)
      XI=IMAG(X)
      R2=XR*XR+XI*XI
      IF (R2.GT.ONE.AND.(XR/R2).GT.HALF) THEN
         Z=-LOG(ONE/X)
         HWULI2=PROD(Z,Z*Z)+ZETA2-LOG(X)*LOG(ONE-X)+HALF*LOG(X)**2
      ELSEIF (R2.GT.ONE.AND.(XR/R2).LE.HALF) THEN
         Z=-LOG(ONE-ONE/X)
         HWULI2=-PROD(Z,Z*Z)-ZETA2-HALF*LOG(-X)**2
      ELSEIF (R2.EQ.ONE.AND.XI.EQ.ZERO) THEN
         HWULI2=ZETA2
      ELSEIF (R2.LE.ONE.AND.XR.GT.HALF) THEN
         Z=-LOG(X)
         HWULI2=-PROD(Z,Z*Z)+ZETA2-LOG(X)*LOG(ONE-X)
      ELSE
         Z=-LOG(ONE-X)
         HWULI2=PROD(Z,Z*Z)
      ENDIF
      END
CDECK  ID>, HWULOB.
*CMZ :-        -05/11/95  19.33.42  by  Mike Seymour
*-- Author :    Adapted by Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWULOB(PS,PI,PF)
C-----------------------------------------------------------------------
C     TRANSFORMS PI (GIVEN IN REST FRAME OF PS) INTO PF (IN LAB)
C     N.B. P(1,2,3,4,5) = (PX,PY,PZ,E,M)
C-----------------------------------------------------------------------
      DOUBLE PRECISION PS(5),PI(5),PF(5)
      CALL HWULB4(PS,PI,PF)
      PF(5)= PI(5)
      END
CDECK  ID>, HWULOF.
*CMZ :-        -05/11/95  19.33.42  by  Mike Seymour
*-- Author :    Adapted by Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWULOF(PS,PI,PF)
C-----------------------------------------------------------------------
C     TRANSFORMS PI (GIVEN IN LAB) INTO PF (IN REST FRAME OF PS)
C     N.B. P(1,2,3,4,5) = (PX,PY,PZ,E,M)
C-----------------------------------------------------------------------
      DOUBLE PRECISION PS(5),PI(5),PF(5)
      CALL HWULF4(PS,PI,PF)
      PF(5)= PI(5)
      END
CDECK  ID>, HWULOR.
*CMZ :-        -26/04/91  11.11.56  by  Bryan Webber
*-- Author :    Giovanni Abbiendi & Luca Stanco
C-----------------------------------------------------------------------
      SUBROUTINE HWULOR (TRANSF,PI,PF)
C-----------------------------------------------------------------------
C     Makes the HWULOR transformation specified by TRANSF on the
C     quadrivector PI(5), giving PF(5).
C-----------------------------------------------------------------------
      DOUBLE PRECISION TRANSF(4,4),PI(5),PF(5)
      INTEGER I,J
      DO 1 I=1,5
        PF(I)=0.D0
    1 CONTINUE
      DO 3 I=1,4
       DO 2 J=1,4
         PF(I) = PF(I) + TRANSF(I,J) * PI(J)
    2  CONTINUE
    3 CONTINUE
      PF(5) = PI(5)
      RETURN
      END
CDECK  ID>, HWUMAS.
*CMZ :-        -26/04/91  11.11.56  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWUMAS(P)
C-----------------------------------------------------------------------
C     PUTS INVARIANT MASS IN 5TH COMPONENT OF VECTOR
C     (NEGATIVE SIGN IF SPACELIKE)
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWUSQR,P(5)
      EXTERNAL HWUSQR
      P(5)=HWUSQR((P(4)+P(3))*(P(4)-P(3))-P(1)**2-P(2)**2)
      END
CDECK  ID>, HWUPCM.
*CMZ :-        -26/04/91  11.11.56  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      FUNCTION HWUPCM(EM0,EM1,EM2)
C-----------------------------------------------------------------------
C     C.M. MOMENTUM FOR DECAY MASSES EM0 -> EM1 + EM2
C     SET TO -1 BELOW THRESHOLD
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWUPCM,EM0,EM1,EM2,EMS,EMD
      EMS=ABS(EM1+EM2)
      EMD=ABS(EM1-EM2)
      IF (EM0.LT.EMS.OR.EM0.LT.EMD) THEN
        HWUPCM=-1.
      ELSEIF (EM0.EQ.EMS.OR.EM0.EQ.EMD) THEN
        HWUPCM=0.
      ELSE
        HWUPCM=SQRT((EM0+EMD)*(EM0-EMD)*
     &              (EM0+EMS)*(EM0-EMS))*.5/EM0
      ENDIF
      END
CDECK  ID>, HWURAP.
*CMZ :-        -26/04/91  11.11.56  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      FUNCTION HWURAP(P)
C-----------------------------------------------------------------------
C     LONGITUDINAL RAPIDITY (SET TO +/-1000 IF TOO LARGE)
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWURAP,EMT2,P(5)
      EMT2=P(1)**2+P(2)**2+P(5)**2
      IF (P(3).GT.0.) THEN
        IF (EMT2.EQ.0.) THEN
          HWURAP=1000.
        ELSE
          HWURAP= 0.5*LOG((P(3)+P(4))**2/EMT2)
        ENDIF
      ELSEIF (P(3).LT.0.) THEN
        IF (EMT2.EQ.0.) THEN
          HWURAP=-1000.
        ELSE
          HWURAP=-0.5*LOG((P(3)-P(4))**2/EMT2)
        ENDIF
      ELSE
          HWURAP=0.
      ENDIF
      END
CDECK  ID>, HWURES.
*CMZ :-        -26/04/91  11.11.56  by  Bryan Webber
*-- Author :    Ian Knowles & Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWURES
C-----------------------------------------------------------------------
C     Using properties of particle I supplied in HWUDAT checks particles
C     and antiparticles have compatible properties and sets   SWTEF(I) =
C     ( rep. enhancement factor)^2  - used in cluster decays
C     Finds iso-flavour hadrons and creates pointers for cluster decays.
C     Sets CLDKWT(K) =(2J+1) spin weight normalizing largest value to 1.
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      INTEGER NMXTMP
      PARAMETER (NMXTMP=20)
      DOUBLE PRECISION HWUPCM,HWUAEM,EPS,WTMX,REMMN,RWTMX,WTMP,
     & RESTMP(91),WTMX2,REMMN2,WT,CDWTMP(NMXTMP)
      INTEGER HWUANT,MAPF(89),MAPC(12,12),I,IANT,IABPDG,J,L,N,K,LTMP,
     & NCDKS,IMN,ITMP,LOCTMP(91),NTMP,NCDTMP(NMXTMP),IMN2
      EXTERNAL HWUANT,HWUPCM,HWUAEM
      PARAMETER (EPS=1.D-6)
      DATA MAPF/21,31,41,51,61,12,32,42,52,62,13,23,43,53,63,14,24,34,
     & 44,54,64,15,25,35,45,55,65,16,26,36,46,56,66,111,112,113,122,123,
     & 133,222,223,233,333,-111,-112,-113,-122,-123,-133,-222,-223,-233,
     & -333,114,124,134,224,234,334,-114,-124,-134,-224,-234,-334,115,
     & 125,135,225,235,335,-115,-125,-135,-225,-235,-335,116,126,136,
     & 226,236,336,-116,-126,-136,-226,-236,-336/
      DATA MAPC/90,1,2,47,45,44,48,46,49,3,4,5,6,90,7,50,47,45,51,48,52,
     & 8,9,10,11,12,91,51,48,46,52,49,53,13,14,15,37,40,41,6*0,57,69,81,
     & 35,37,38,6*0,55,67,79,34,35,36,6*0,54,66,78,38,41,42,6*0,58,70,
     & 82,36,38,39,6*0,56,68,80,39,42,43,6*0,59,71,83,16,17,18,63,61,60,
     & 64,62,65,19,20,21,22,23,24,75,73,72,76,74,77,25,26,27,28,29,30,
     & 87,85,84,88,86,89,31,32,33/
C Check particle/anti-particle properties are compatible
      WRITE(6,10)
  10  FORMAT(/10X,'Checking consistency of particle properties'/)
      DO 20 I=10,NRES
      IF (IDPDG(I).GT.0) THEN
        IANT=HWUANT(I)
        IF (IANT.EQ.20) GOTO 20
        IF (MOD(IDPDG(I)/1000,10).EQ.0.AND.
     &      MOD(IDPDG(I)/100 ,10).NE.0) THEN
          IF (MOD(IFLAV(I)/10-IFLAV(IANT),10).NE.0.OR.
     &        MOD(IFLAV(I)-IFLAV(IANT)/10,10).NE.0)
     &     WRITE(6,30) RNAME(I),IFLAV(I),IFLAV(IANT)
        ELSE
          IF (IFLAV(I)+IFLAV(IANT).NE.0)
     &     WRITE(6,30) RNAME(I),IFLAV(I),IFLAV(IANT)
        ENDIF
        IF (ICHRG(I)+ICHRG(IANT).NE.0)
     &   WRITE(6,40) RNAME(I),ICHRG(I),ICHRG(IANT)
        IF (ABS(RMASS(I)-RMASS(IANT)).GT.EPS)
     &   WRITE(6,50) RNAME(I),RMASS(I),RMASS(IANT)
        IF (ABS(RLTIM(I)-RLTIM(IANT)).GT.EPS)
     &   WRITE(6,60) RNAME(I),RLTIM(I),RLTIM(IANT)
        IF (ABS(RSPIN(I)-RSPIN(IANT)).GT.EPS)
     &   WRITE(6,70) RNAME(I),RSPIN(I),RSPIN(IANT)
      ENDIF
  20  CONTINUE
  30  FORMAT(10X,A8,' flavour code=',I4,5X,' antiparticle=',I4)
  40  FORMAT(10X,A8,' charge      =',I2,7X,' antiparticle=',I2)
  50  FORMAT(10X,A8,' mass        =',F7.3,2X,' antiparticle=',F7.3)
  60  FORMAT(10X,A8,' life time   =',E9.3,' antiparticle=',E9.3)
  70  FORMAT(10X,A8,' spin        =',F3.1,6X,' antiparticle=',F3.1)
C Compute resonance properties
      DO 80 I=21,NRES
C Compute representation weights for hadrons, used in cluster decays
      IABPDG=ABS(IDPDG(I))
      J=MOD(IABPDG,10)
      IF (J.EQ.2.AND.MOD(IABPDG/100,10).LT.MOD(IABPDG/10,10)) THEN
C Singlet (Lambda-like) baryon
        SWTEF(I)=SNGWT**2
      ELSEIF (J.EQ.4) THEN
C Decuplet baryon
        SWTEF(I)=DECWT**2
      ELSEIF(2*(J/2).NE.J) THEN
C Mesons: identify by spin, angular momentum & radial excitation
        J=(J-1)/2
        L= MOD(IABPDG/10000 ,10)
        N= MOD(IABPDG/100000,10)
        IF (L.EQ.0.AND.J.EQ.0.AND.N.EQ.0.OR.
     &      L.GT.3.OR. J.GT.4.OR .N.GT.4) THEN
          SWTEF(I)=1.
        ELSE
          SWTEF(I)=REPWT(L,J,N)**2
        ENDIF
      ELSE
C Not recognized
        SWTEF(I)=1.
      ENDIF
  80  CONTINUE
C Prepare tables for cluster decays, except flavourless light mesons
      LTMP=1
      NCDKS=0
      DO 120 I=1,89
C Store particles, flavour MAPF(I), noting highest spin and lowest mass
      WTMX=0.
      REMMN=1000.
      DO 90 J=21,NRES
      IF (VTOCDK(J).OR.IFLAV(J).NE.MAPF(I)) GOTO 90
      NCDKS=NCDKS+1
      IF (NCDKS.GT.NMXCDK) CALL HWWARN('HWURES',101,*999)
      NCLDK(NCDKS)=J
      CLDKWT(NCDKS)=TWO*RSPIN(J)+ONE
      IF (CLDKWT(NCDKS).GT.WTMX) WTMX=CLDKWT(NCDKS)
      IF (RMASS(J).LT.REMMN) THEN
        REMMN=RMASS(J)
        IMN=NCDKS
      ENDIF
  90  CONTINUE
      IF (NCDKS+1-LTMP.EQ.0) THEN
        WRITE(6,100) MAPF(I)
  100   FORMAT(1X,'No particles exist for a cluster with flavour, ',I4,
     &            ' to decay into')
        CALL HWWARN('HWURES',51,*120)
      ENDIF
C Set scaled spin weights
      RWTMX=1./WTMX
      DO 110 J=LTMP,NCDKS
  110 CLDKWT(J)=CLDKWT(J)*RWTMX
C Swap order if lightest hadron of given flavour not first
      IF (IMN.NE.LTMP) THEN
        ITMP=NCLDK(LTMP)
        WTMP=CLDKWT(LTMP)
        NCLDK(LTMP)=NCLDK(IMN)
        CLDKWT(LTMP)=CLDKWT(IMN)
        NCLDK(IMN)=ITMP
        CLDKWT(IMN)=WTMP
      ENDIF
C Set pointers etc
      LOCTMP(I)=LTMP
      RESTMP(I)=FLOAT(NCDKS+1-LTMP)
      LTMP=NCDKS+1
  120 CONTINUE
C Now do flavourless light mesons, allowing for mixing in weights
      WTMX=0.
      REMMN=1000.
      WTMX2=0.
      REMMN2=1000.
      NTMP=0
      DO 140 J=21,NRES
      IF (VTOCDK(J)) THEN
        GOTO 140
C Calculate mixing weight for (|uubar>+|ddbar>)/sqrt(2) component
      ELSEIF (IFLAV(J).EQ.11) THEN
        WT=1.
      ELSEIF (IFLAV(J).EQ.33) THEN
        IF (J.EQ.22) THEN
          WT=SIN(ETAMIX*PIFAC/180.+ATAN(SQRT(TWO)))**2
        ELSEIF (J.EQ.25) THEN
          WT=COS(ETAMIX*PIFAC/180.+ATAN(SQRT(TWO)))**2
        ELSEIF (J.EQ.24) THEN
          WT=SIN(PHIMIX*PIFAC/180.+ATAN(SQRT(TWO)))**2
        ELSEIF (J.EQ.56) THEN
          WT=COS(PHIMIX*PIFAC/180.+ATAN(SQRT(TWO)))**2
        ELSEIF (J.EQ.26) THEN
          WT=SIN(F2MIX*PIFAC/180.+ATAN(SQRT(TWO)))**2
        ELSEIF (J.EQ.58) THEN
          WT=COS(F2MIX*PIFAC/180.+ATAN(SQRT(TWO)))**2
        ELSEIF (J.EQ.28) THEN
          WT=SIN(F1MIX*PIFAC/180.+ATAN(SQRT(TWO)))**2
        ELSEIF (J.EQ.57) THEN
          WT=COS(F1MIX*PIFAC/180.+ATAN(SQRT(TWO)))**2
        ELSEIF (J.EQ.288) THEN
          WT=SIN(H1MIX*PIFAC/180.+ATAN(SQRT(TWO)))**2
        ELSEIF (J.EQ.289) THEN
          WT=COS(H1MIX*PIFAC/180.+ATAN(SQRT(TWO)))**2
        ELSEIF (J.EQ.293) THEN
          WT=SIN(F0MIX*PIFAC/180.+ATAN(SQRT(TWO)))**2
        ELSEIF (J.EQ.294) THEN
          WT=COS(F0MIX*PIFAC/180.+ATAN(SQRT(TWO)))**2
        ELSE
          WT=1./3.
          WRITE(6,130) J
  130   FORMAT(1X,'Particle ',I3,' not recognised, no I=0 mixing',
     &           ' assumed')
        ENDIF
      ELSE
        GOTO 140
      ENDIF
      IF (WT.GT.EPS) THEN
        NCDKS=NCDKS+1
        IF (NCDKS.GT.NMXCDK) CALL HWWARN('HWURES',102,*999)
        NCLDK(NCDKS)=J
        CLDKWT(NCDKS)=WT*(TWO*RSPIN(J)+ONE)
        IF (CLDKWT(NCDKS).GT.WTMX) WTMX=CLDKWT(NCDKS)
        IF (RMASS(J).LT.REMMN) THEN
          REMMN=RMASS(J)
          IMN=NCDKS
        ENDIF
      ENDIF
      IF (ONE-WT.GT.EPS) THEN
        NTMP=NTMP+1
        IF (NTMP.GT.NMXTMP) CALL HWWARN('HWURES',103,*999)
        NCDTMP(NTMP)=J
        CDWTMP(NTMP)=(ONE-WT)*(TWO*RSPIN(J)+ONE)
        IF (CDWTMP(NTMP).GT.WTMX2) WTMX2=CDWTMP(NTMP)
        IF (RMASS(J).LT.REMMN2) THEN
          REMMN2=RMASS(J)
          IMN2=NTMP
        ENDIF
      ENDIF
  140 CONTINUE
      IF (NCDKS+1-LTMP.EQ.0) THEN
        WRITE(6,100) 11
        CALL HWWARN('HWURES',52,*160)
      ENDIF
C Normalize scaled spin weights
      RWTMX=1./WTMX
      DO 150 I=LTMP,NCDKS
  150 CLDKWT(I)=CLDKWT(I)*RWTMX
C Swap order if lightest hadron of flavour 11 not first
      IF (IMN.NE.LTMP) THEN
        ITMP=NCLDK(LTMP)
        WTMP=CLDKWT(LTMP)
        NCLDK(LTMP)=NCLDK(IMN)
        CLDKWT(LTMP)=CLDKWT(IMN)
        NCLDK(IMN)=ITMP
        CLDKWT(IMN)=WTMP
      ENDIF
  160 IF (NTMP.EQ.0) THEN
        WRITE(6,100) 33
        CALL HWWARN('HWURES',53,*180)
      ENDIF
      IF (NCDKS+NTMP.GT.NMXCDK) CALL HWWARN('HWURES',104,*999)
C Store hadrons for |ssbar> channel and normalize their weights
      RWTMX=1./WTMX2
      DO 170 I=1,NTMP
      J=NCDKS+I
      NCLDK(J)=NCDTMP(I)
  170 CLDKWT(J)=CDWTMP(I)*RWTMX
C Swap order if lightest hadron of flavour 33 not first
      IF (IMN2.NE.1) THEN
        ITMP=NCLDK(NCDKS+1)
        WTMP=CLDKWT(NCDKS+1)
        NCLDK(NCDKS+1)=NCLDK(NCDKS+IMN2)
        CLDKWT(NCDKS+1)=CLDKWT(NCDKS+IMN2)
        NCLDK(NCDKS+IMN2)=ITMP
        CLDKWT(NCDKS+IMN2)=WTMP
      ENDIF
C Set pointers etc
  180 LOCTMP(90)=LTMP
      RESTMP(90)=FLOAT(NCDKS+1-LTMP)
      LOCTMP(91)=NCDKS+1
      RESTMP(91)=FLOAT(NTMP)
C Set pointers to hadrons of given flavours for cluster decays
      DO 190 I=1,12
      DO 190 J=1,12
      K=MAPC(I,J)
      IF (K.EQ.0) THEN
        RMIN(I,J)=RMASS(NCLDK(LOCN(I,2)))+RMASS(NCLDK(LOCN(I,2)))+1.D-2
      ELSE
        LOCN(I,J)=LOCTMP(K)
        RESN(I,J)=RESTMP(K)
        RMIN(I,J)=RMASS(NCLDK(LOCN(I,J)))
      ENDIF
  190 CONTINUE
  999 END
CDECK  ID>, HWUROB.
*CMZ :-        -26/04/91  11.11.56  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWUROB(R,P,Q)
C-----------------------------------------------------------------------
C     ROTATES VECTORS BY INVERSE OF ROTATION MATRIX R
C-----------------------------------------------------------------------
      DOUBLE PRECISION S1,S2,S3,R(3,3),P(3),Q(3)
      S1=P(1)*R(1,1)+P(2)*R(2,1)+P(3)*R(3,1)
      S2=P(1)*R(1,2)+P(2)*R(2,2)+P(3)*R(3,2)
      S3=P(1)*R(1,3)+P(2)*R(2,3)+P(3)*R(3,3)
      Q(1)=S1
      Q(2)=S2
      Q(3)=S3
      END
CDECK  ID>, HWUROF.
*CMZ :-        -26/04/91  11.11.56  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWUROF(R,P,Q)
C-----------------------------------------------------------------------
C     ROTATES VECTORS BY ROTATION MATRIX R
C-----------------------------------------------------------------------
      DOUBLE PRECISION S1,S2,S3,R(3,3),P(3),Q(3)
      S1=R(1,1)*P(1)+R(1,2)*P(2)+R(1,3)*P(3)
      S2=R(2,1)*P(1)+R(2,2)*P(2)+R(2,3)*P(3)
      S3=R(3,1)*P(1)+R(3,2)*P(2)+R(3,3)*P(3)
      Q(1)=S1
      Q(2)=S2
      Q(3)=S3
      END
CDECK  ID>, HWUROT.
*CMZ :-        -26/04/91  11.11.56  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWUROT(P,CP,SP,R)
C-----------------------------------------------------------------------
C     R IS ROTATION MATRIX TO GET FROM VECTOR P TO Z AXIS, FOLLOWED BY
C     A ROTATION BY PSI ABOUT Z AXIS, WHERE CP = COS-PSI, SP = SIN-PSI
C-----------------------------------------------------------------------
      DOUBLE PRECISION WN,CP,SP,PTCUT,PP,PT,CT,ST,CF,SF,P(3),R(3,3)
      DATA WN,PTCUT/1.,1.D-20/
      PT=P(1)**2+P(2)**2
      PP=P(3)**2+PT
      IF (PT.LE.PP*PTCUT) THEN
         CT=SIGN(WN,P(3))
         ST=0.
         CF=1.
         SF=0.
      ELSE
         PP=SQRT(PP)
         PT=SQRT(PT)
         CT=P(3)/PP
         ST=PT/PP
         CF=P(1)/PT
         SF=P(2)/PT
      END IF
      R(1,1)= CP*CF*CT+SP*SF
      R(1,2)= CP*SF*CT-SP*CF
      R(1,3)=-CP*ST
      R(2,1)=-CP*SF+SP*CF*CT
      R(2,2)= CP*CF+SP*SF*CT
      R(2,3)=-SP*ST
      R(3,1)= CF*ST
      R(3,2)= SF*ST
      R(3,3)= CT
      END
CDECK  ID>, HWUSOR.
*CMZ :-        -26/04/91  11.11.56  by  Bryan Webber
*-- Author :    Adapted by Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWUSOR(A,N,K,IOPT)
C-----------------------------------------------------------------------
C     Sort A(N) into ascending order
C     IOPT = 1 : return sorted A and index array K
C     IOPT = 2 : return index array K only
C-----------------------------------------------------------------------
      DOUBLE PRECISION A(N),B(500)
      INTEGER N,I,J,IOPT,K(N),IL(500),IR(500)
      IF (N.GT.500) CALL HWWARN('HWUSOR',100,*999)
      IL(1)=0
      IR(1)=0
      DO 10 I=2,N
      IL(I)=0
      IR(I)=0
      J=1
   2  IF(A(I).GT.A(J)) GOTO 5
   3  IF(IL(J).EQ.0) GOTO 4
      J=IL(J)
      GOTO 2
   4  IR(I)=-J
      IL(J)=I
      GOTO 10
   5  IF(IR(J).LE.0) GOTO 6
      J=IR(J)
      GOTO 2
   6  IR(I)=IR(J)
      IR(J)=I
  10  CONTINUE
      I=1
      J=1
      GOTO 8
  20  J=IL(J)
   8  IF(IL(J).GT.0) GOTO 20
   9  K(I)=J
      B(I)=A(J)
      I=I+1
      IF(IR(J)) 12,30,13
  13  J=IR(J)
      GOTO 8
  12  J=-IR(J)
      GOTO 9
  30  IF(IOPT.EQ.2) RETURN
      DO 31 I=1,N
  31  A(I)=B(I)
 999  END
CDECK  ID>, HWUSQR.
*CMZ :-        -26/04/91  11.11.56  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      FUNCTION HWUSQR(X)
C-----------------------------------------------------------------------
C     SQUARE ROOT WITH SIGN RETENTION
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWUSQR,X
      HWUSQR=SIGN(SQRT(ABS(X)),X)
      END
CDECK  ID>, HWUSTA.
*CMZ :-        -26/04/91  10.18.58  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWUSTA(NAME)
C-----------------------------------------------------------------------
C     MAKES PARTICLE TYPE 'NAME' STABLE
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      INTEGER IPDG,IWIG
      CHARACTER*8 NAME
      CALL HWUIDT(3,IPDG,IWIG,NAME)
      IF (IWIG.EQ.20) CALL HWWARN('HWUSTA',500,*999)
      RSTAB(IWIG)=.TRUE.
      WRITE (6,10) IWIG,NAME
   10 FORMAT(/10X,'PARTICLE TYPE',I4,'=',A8,' SET STABLE')
  999 END
CDECK  ID>, HWUTAB.
*CMZ :-        -26/04/91  11.11.56  by  Bryan Webber
*-- Author :    Adapted by Bryan Webber
C-----------------------------------------------------------------------
      FUNCTION HWUTAB(F,A,NN,X,MM)
C-----------------------------------------------------------------------
C     MODIFIED CERN INTERPOLATION ROUTINE DIVDIF
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWUTAB,SUM,X,F(NN),A(NN),T(20),D(20)
      INTEGER NN,MM,MMAX,N,M,MPLUS,IX,IY,MID,NPTS,IP,I,J,L,ISUB
      LOGICAL EXTRA
      DATA MMAX/10/
      N=NN
      M=MIN(MM,MMAX,N-1)
      MPLUS=M+1
      IX=0
      IY=N+1
      IF (A(1).GT.A(N)) GOTO 4
    1 MID=(IX+IY)/2
      IF (X.GE.A(MID)) GOTO 2
      IY=MID
      GOTO 3
    2 IX=MID
    3 IF (IY-IX.GT.1) GOTO 1
      GOTO 7
    4 MID=(IX+IY)/2
      IF (X.LE.A(MID)) GOTO 5
      IY=MID
      GOTO 6
    5 IX=MID
    6 IF (IY-IX.GT.1) GOTO 4
    7 NPTS=M+2-MOD(M,2)
      IP=0
      L=0
      GOTO 9
    8 L=-L
      IF (L.GE.0) L=L+1
    9 ISUB=IX+L
      IF ((1.LE.ISUB).AND.(ISUB.LE.N)) GOTO 10
      NPTS=MPLUS
      GOTO 11
   10 IP=IP+1
      T(IP)=A(ISUB)
      D(IP)=F(ISUB)
   11 IF (IP.LT.NPTS) GOTO 8
      EXTRA=NPTS.NE.MPLUS
      DO 14 L=1,M
      IF (.NOT.EXTRA) GOTO 12
      ISUB=MPLUS-L
      D(M+2)=(D(M+2)-D(M))/(T(M+2)-T(ISUB))
   12 I=MPLUS
      DO 13 J=L,M
      ISUB=I-L
      D(I)=(D(I)-D(I-1))/(T(I)-T(ISUB))
      I=I-1
   13 CONTINUE
   14 CONTINUE
      SUM=D(MPLUS)
      IF (EXTRA) SUM=0.5*(SUM+D(M+2))
      J=M
      DO 15 L=1,M
      SUM=D(J)+(X-T(J))*SUM
      J=J-1
   15 CONTINUE
      HWUTAB=SUM
      END
CDECK  ID>, HWUTIM.
*CMZ :-        -26/04/91  11.38.43  by  Federico Carminati
*-- Author :    Federico Carminati
C-----------------------------------------------------------------------
      SUBROUTINE HWUTIM(TRES)
C-----------------------------------------------------------------------
      CALL TIMEL(TRES)
      END
CDECK  ID>, HWVDIF.
*CMZ :-        -26/04/91  11.11.56  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWVDIF(N,P,Q,R)
C-----------------------------------------------------------------------
C     VECTOR DIFFERENCE
C-----------------------------------------------------------------------
      DOUBLE PRECISION P(N),Q(N),R(N)
      INTEGER N,I
      DO 10 I=1,N
   10 R(I)=P(I)-Q(I)
      END
CDECK  ID>, HWVDOT.
*CMZ :-        -26/04/91  11.11.56  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      FUNCTION HWVDOT(N,P,Q)
C-----------------------------------------------------------------------
C     VECTOR DOT PRODUCT
C-----------------------------------------------------------------------
      DOUBLE PRECISION HWVDOT,PQ,P(N),Q(N)
      INTEGER N,I
      PQ=0.
      DO 10 I=1,N
   10 PQ=PQ+P(I)*Q(I)
      HWVDOT=PQ
      END
CDECK  ID>, HWVEQU.
*CMZ :-        -26/04/91  11.11.56  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWVEQU(N,P,Q)
C-----------------------------------------------------------------------
C     VECTOR EQUALITY
C-----------------------------------------------------------------------
      DOUBLE PRECISION P(N),Q(N)
      INTEGER N,I
      DO 10 I=1,N
   10 Q(I)=P(I)
      END
CDECK  ID>, HWVSCA.
*CMZ :-        -26/04/91  11.11.56  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWVSCA(N,C,P,Q)
C-----------------------------------------------------------------------
C     VECTOR TIMES SCALAR
C-----------------------------------------------------------------------
      DOUBLE PRECISION C,P(N),Q(N)
      INTEGER N,I
      DO 10 I=1,N
   10 Q(I)=C*P(I)
      END
CDECK  ID>, HWVSUM.
*CMZ :-        -26/04/91  11.11.56  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWVSUM(N,P,Q,R)
C-----------------------------------------------------------------------
C    VECTOR SUM
C-----------------------------------------------------------------------
      DOUBLE PRECISION P(N),Q(N),R(N)
      INTEGER N,I
      DO 10 I=1,N
   10 R(I)=P(I)+Q(I)
      END
CDECK  ID>, HWVZRO.
*CMZ :-        -26/04/91  11.11.56  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWVZRO(N,P)
C-----------------------------------------------------------------------
C     ZERO VECTOR
C-----------------------------------------------------------------------
      DOUBLE PRECISION P(N)
      INTEGER N,I
      DO 10 I=1,N
   10 P(I)=0.
      END
CDECK  ID>, HWWARN.
*CMZ :-        -26/04/91  10.18.58  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE HWWARN(SUBRTN,ICODE,*)
C-----------------------------------------------------------------------
C     DEALS WITH ERRORS DURING EXECUTION
C     SUBRTN = NAME OF CALLING SUBROUTINE
C     ICODE  = ERROR CODE:    - -1 NONFATAL, KILL EVENT & PRINT NOTHING
C                            0- 49 NONFATAL, PRINT WARNING & CONTINUE
C                           50- 99 NONFATAL, PRINT WARNING & JUMP
C                          100-199 NONFATAL, DUMP & KILL EVENT
C                          200-299    FATAL, TERMINATE RUN
C                          300-399    FATAL, DUMP EVENT & TERMINATE RUN
C                          400-499    FATAL, DUMP EVENT & STOP DEAD
C                          500-       FATAL, STOP DEAD WITH NO DUMP
C-----------------------------------------------------------------------
      INCLUDE 'HERWIG59.INC'
      INTEGER ICODE
      CHARACTER*6 SUBRTN
      IF (ICODE.GE.0) WRITE (6,10) SUBRTN,ICODE
   10 FORMAT(/' HWWARN CALLED FROM SUBPROGRAM ',A6,': CODE =',I4)
      IF (ICODE.LT.0) THEN
         IERROR=ICODE
         RETURN 1
      ELSEIF (ICODE.LT.100) THEN
         WRITE (6,20) NEVHEP,NRN,EVWGT
   20    FORMAT(' EVENT',I8,':   SEEDS =',I11,' &',I11,
     &'  WEIGHT =',E11.4/' EVENT SURVIVES. EXECUTION CONTINUES')
         IF (ICODE.GT.49) RETURN 1
      ELSEIF (ICODE.LT.200) THEN
         WRITE (6,30) NEVHEP,NRN,EVWGT
   30    FORMAT(' EVENT',I8,':   SEEDS =',I11,' &',I11,
     &'  WEIGHT =',E11.4/' EVENT KILLED.   EXECUTION CONTINUES')
         IERROR=ICODE
         RETURN 1
      ELSEIF (ICODE.LT.300) THEN
         WRITE (6,40)
   40    FORMAT(' EVENT SURVIVES.  RUN ENDS GRACEFULLY')
         CALL HWEFIN
         CALL HWAEND
         STOP
      ELSEIF (ICODE.LT.400) THEN
         WRITE (6,50)
   50    FORMAT(' EVENT KILLED: DUMP FOLLOWS.  RUN ENDS GRACEFULLY')
         IERROR=ICODE
         CALL HWUEPR
         CALL HWUBPR
         CALL HWEFIN
         CALL HWAEND
         STOP
      ELSEIF (ICODE.LT.500) THEN
         WRITE (6,60)
   60    FORMAT(' EVENT KILLED: DUMP FOLLOWS.  RUN STOPS DEAD')
         IERROR=ICODE
         CALL HWUEPR
         CALL HWUBPR
         STOP
      ELSE
         WRITE (6,70)
   70    FORMAT(' RUN CANNOT CONTINUE')
         STOP
      ENDIF
      END
CDECK  ID>, IEUPDG.
*CMZ :-        -28/01/92  12.34.44  by  Mike Seymour
*-- Author :    Luca Stanco
C-----------------------------------------------------------------------
      FUNCTION IEUPDG(I)
C-----------------------------------------------------------------------
C     DUMMY SUBROUTINE: DELETE AND SET BDECAY='EURO'
C     IN MAIN PROGRAM IF YOU USE EURODEC DECAY PACKAGE
C-----------------------------------------------------------------------
      INTEGER IEUPDG,I
      WRITE (6,10)
   10 FORMAT(/10X,'IEUPDG CALLED BUT NOT LINKED')
      IEUPDG=0
      STOP
      END
CDECK  ID>, IPDGEU.
*CMZ :-        -28/01/92  12.34.44  by  Mike Seymour
*-- Author :    Luca Stanco
C-----------------------------------------------------------------------
      FUNCTION IPDGEU(I)
C-----------------------------------------------------------------------
C     DUMMY SUBROUTINE: DELETE AND SET BDECAY='EURO'
C     IN MAIN PROGRAM IF YOU USE EURODEC DECAY PACKAGE
C-----------------------------------------------------------------------
      INTEGER IPDGEU,I
      WRITE (6,10)
   10 FORMAT(/10X,'IPDGEU CALLED BUT NOT LINKED')
      IPDGEU=0
      STOP
      END
CDECK  ID>, PDFSET.
*CMZ :-        -26/04/91  11.11.54  by  Bryan Webber
*-- Author :    Bryan Webber
C----------------------------------------------------------------------
      SUBROUTINE PDFDUM(PARM,VAL)
CAST      SUBROUTINE PDFSET(PARM,VAL)
C----------------------------------------------------------------------
C     DUMMY SUBROUTINE: DELETE AND SET MODPDF(I)
C     IN MAIN PROGRAM IF YOU USE PDFLIB CERN-LIBRARY
C     PACKAGE FOR NUCLEON STRUCTURE FUNCTIONS
C----------------------------------------------------------------------
      DOUBLE PRECISION VAL(20)
      CHARACTER*20 PARM(20)
      WRITE (6,10)
   10 FORMAT(/10X,'PDFSET CALLED BUT NOT LINKED')
      STOP
      END
CDECK  ID>, QQINIT.
*CMZ :-        -28/01/92  12.34.44  by  Mike Seymour
*-- Author :    Luca Stanco
C-----------------------------------------------------------------------
      SUBROUTINE QQINIT(QQLERR)
C-----------------------------------------------------------------------
C     DUMMY SUBROUTINE: DELETE AND SET BDECAY='CLEO'
C     IN MAIN PROGRAM IF YOU USE CLEO DECAY PACKAGE
C-----------------------------------------------------------------------
      LOGICAL QQLERR
      WRITE (6,10)
   10 FORMAT(/10X,'QQINIT CALLED BUT NOT LINKED')
      STOP
      END
CDECK  ID>, QQLMAT.
*CMZ :-        -28/01/92  12.34.44  by  Mike Seymour
*-- Author :    Luca Stanco
C-----------------------------------------------------------------------
      INTEGER FUNCTION QQLMAT(IDL,NDIR)
C-----------------------------------------------------------------------
C. QQLMAT - Given a particle flavor (KF), converts it to QQ particle number
C.          (KF = IDPDG code)
C.
C. Inputs    : IDL    (input  particle code)
C              NDIR = 1   LUND --> QQ
C              NDIR = 2   QQ   --> LUND
C
C. Outputs   : QQLMAT (output particle code)
C.
C-----------------------------------------------------------------------
      IMPLICIT NONE
C-- Calling variable
      INTEGER IDL,NDIR
C-- External declaration
C-- Local variables
      INTEGER AKF(321),I
      DATA (AKF(I), I=1,151) /
     +    0,    0,    0,    0,    0,    0,    0,   21,   -6,   -5,
     +   -4,   -3,   -1,   -2,    6,    5,    4,    3,    1,    2,
     +    0,
     +   22,   23,   24,  -24,   90,    0,   11,  -11,   12,  -12,
     +   13,  -13,   14,  -14,   15,  -15,   16,  -16,20313,-20313,
     +  211, -211,  321, -321,  311, -311,  421, -421,  411, -411,
     +  431, -431, -521,  521, -511,  511, -531,  531, -541,  541,
     +  621, -621,  611, -611,  631, -631,  641, -641,  651, -651,
     +  111,  221,  331,  441,20551,  661,  310,  130,10313,-10313,
     +  213, -213,  323, -323,  313, -313,  423, -423,  413, -413,
     +  433, -433, -523,  523, -513,  513, -533,  533, -543,  543,
     +  623, -623,  613, -613,  633, -633,  643, -643,  653, -653,
     +  113,  223,  333,  443,  553,  136,  20553, 30553, 40553, 551,
     +  10553, 555, 10551,70553,10555, 0, 20213, 20113, -20213, 10441,
     +  10443, 445, 8*0,
     +  3122, -3122, 4122, -4122, 4232, -4232, 4132, -4132, 3212, -3212/
      DATA (AKF(I), I=152,321) /
     +  4212, -4212, 4322, -4322, 4312, -4312, 2212, -2212, 3222, -3222,
     +  4222, -4222, 2112, -2112, 3112, -3112, 4112, -4112, 3322, -3322,
     +  3312, -3312, 4332, -4332, 6*0,
     +  3214, -3214, 4214, -4214, 4324, -4324, 4314, -4314, 2214, -2214,
     +  3224, -3224, 4224, -4224, 2114, -2114, 3114, -3114, 4114, -4114,
     +  3324, -3324, 3314, -3314, 4334, -4334, 4*0,
     +  0, 0,  2224, -2224, 1114, -1114, 3334, -3334, 0, 0,
     +  10323, -10323, 20323, -20323, 6*0,
     +  30443, 0, 0, 0, 70443, 50553, 60553, 80553, 20443, 0,
     +  10411, 20413, 10413, 415,
     + -10411,-20413,-10413,-415,
     +  10421, 20423, 10423, 425,
     + -10421,-20423,-10423,-425,
     +  10431, 20433, 10433, 435,
     + -10431,-20433,-10433,-435, 0,0,0,0,0,0,
     +  10111, 10211,-10211, 115, 215, -215,10221,10331,20223,20333,
     +  225, 335, 10223, 10333, 10113, 10213,-10213, 33*0 /
      IF(NDIR.EQ.1) THEN
        DO 10 I=1,321
        IF (IDL.EQ.AKF(I)) THEN
          QQLMAT=I-21
          RETURN
        ENDIF
  10    CONTINUE
        WRITE(6,20) IDL
  20    FORMAT(1X,'Lund code particle ',I6,' not recognized')
      ELSEIF(NDIR.EQ.2) THEN
        QQLMAT = AKF(IDL+21)
      ENDIF
      RETURN
      END
CDECK  ID>, STRUCTM.
*CMZ :S        E26/04/91  11.11.54  by  Bryan Webber
*-- Author :    Bryan Webber
C-----------------------------------------------------------------------
      SUBROUTINE STRUCTX(X,QSCA,UPV,DNV,USEA,DSEA,STR,CHM,BOT,TOP,GLU)
CAST      SUBROUTINE STRUCTM(X,QSCA,UPV,DNV,USEA,DSEA,STR,CHM,BOT,TOP,GLU)
C-----------------------------------------------------------------------
C     DUMMY SUBROUTINE: DELETE IF YOU USE PDFLIB CERN-LIBRARY
C     PACKAGE FOR NUCLEON STRUCTURE FUNCTIONS
C-----------------------------------------------------------------------
      DOUBLE PRECISION X,QSCA,UPV,DNV,USEA,DSEA,STR,CHM,BOT,TOP,GLU
      WRITE (6,10)
  10  FORMAT(/10X,'STRUCTM CALLED BUT NOT LINKED')
      STOP
      END
C-----------------------------------------------------------------------
C...SaSgam version 2 - parton distributions of the photon
C...by Gerhard A. Schuler and Torbjorn Sjostrand
C...For further information see Z. Phys. C68 (1995) 607
C...and CERN-TH/96-04 and LU TP 96-2.
C...Program last changed on 18 January 1996.
C
C!!!Note that one further call parameter - IP2 - has been added
C!!!to the SASGAM argument list compared with version 1.
C
C...The user should only need to call the SASGAM routine,
C...which in turn calls the auxiliary routines SASVMD, SASANO,
C...SASBEH and SASDIR. The package is self-contained.
C
C...One particular aspect of these parametrizations is that F2 for
C...the photon is not obtained just as the charge-squared-weighted
C...sum of quark distributions, but differ in the treatment of
C...heavy flavours (in F2 the DIS relation W2 = Q2*(1-x)/x restricts
C...the kinematics range of heavy-flavour production, but the same
C...kinematics is not relevant e.g. for jet production) and, for the
C...'MSbar' fits, in the addition of a Cgamma term related to the
C...separation of direct processes. Schematically:
C...PDF = VMD (rho, omega, phi) + anomalous (d, u, s, c, b).
C...F2  = VMD (rho, omega, phi) + anomalous (d, u, s) +
C...      Bethe-Heitler (c, b) (+ Cgamma (d, u, s)).
C...The J/psi and Upsilon states have not been included in the VMD sum,
C...but low c and b masses in the other components should compensate
C...for this in a duality sense.
C
C...The calling sequence is the following:
C     CALL SASGAM(ISET,X,Q2,P2,IP2,F2GM,XPDFGM)
C...with the following declaration statement:
C     DIMENSION XPDFGM(-6:6)
C...and, optionally, further information in:
C     COMMON/SASCOM/XPVMD(-6:6),XPANL(-6:6),XPANH(-6:6),XPBEH(-6:6),
C    &XPDIR(-6:6)
C     COMMON/SASVAL/VXPVMD(-6:6),VXPANL(-6:6),VXPANH(-6:6),VXPDGM(-6:6)
C...Input:  ISET = 1 : SaS set 1D ('DIS',   Q0 = 0.6 GeV)
C                = 2 : SaS set 1M ('MSbar', Q0 = 0.6 GeV)
C                = 3 : SaS set 2D ('DIS',   Q0 =  2  GeV)
C                = 4 : SaS set 2M ('MSbar', Q0 =  2  GeV)
C           X : x value.
C           Q2 : Q2 value.
C           P2 : P2 value; should be = 0. for an on-shell photon.
C           IP2 : scheme used to evaluate off-shell anomalous component.
C               = 0 : recommended default, see = 7.
C               = 1 : dipole dampening by integration; very time-consuming.
C               = 2 : P_0^2 = max( Q_0^2, P^2 )
C               = 3 : P'_0^2 = Q_0^2 + P^2.
C               = 4 : P_{eff} that preserves momentum sum.
C               = 5 : P_{int} that preserves momentum and average
C                     evolution range.
C               = 6 : P_{eff}, matched to P_0 in P2 -> Q2 limit.
C               = 7 : P_{eff}, matched to P_0 in P2 -> Q2 limit.
C...Output: F2GM : F2 value of the photon (including factors of alpha_em).
C           XPFDGM :  x times parton distribution functions of the photon,
C               with elements 0 = g, 1 = d, 2 = u, 3 = s, 4 = c, 5 = b,
C               6 = t (always empty!), - for antiquarks (result is same).
C...The breakdown by component is stored in the commonblock SASCOM,
C               with elements as above.
C           XPVMD : rho, omega, phi VMD part only of output.
C           XPANL : d, u, s anomalous part only of output.
C           XPANH : c, b anomalous part only of output.
C           XPBEH : c, b Bethe-Heitler part only of output.
C           XPDIR : Cgamma (direct contribution) part only of output.
C...The above arrays do not distinguish valence and sea contributions,
C...although this information is available internally. The additional
C...commonblock SASVAL provides the valence part only of the above
C...distributions. Array names VXPVMD, VXPANL and VXPANH correspond
C...to XPVMD, XPANL and XPANH, while XPBEH and XPDIR are valence only
C...and therefore not given doubly. VXPDGM gives the sum of valence
C...parts, and so matches XPDFGM. The difference, i.e. XPVMD-VXPVMD
C...and so on, gives the sea part only.
C
      SUBROUTINE SASGAM(ISET,X,Q2,P2,IP2,F2GM,XPDFGM)
C...Purpose: to construct the F2 and parton distributions of the photon
C...by summing homogeneous (VMD) and inhomogeneous (anomalous) terms.
C...For F2, c and b are included by the Bethe-Heitler formula;
C...in the 'MSbar' scheme additionally a Cgamma term is added.
      DIMENSION XPDFGM(-6:6)
      COMMON/SASCOM/XPVMD(-6:6),XPANL(-6:6),XPANH(-6:6),XPBEH(-6:6),
     &XPDIR(-6:6)
      COMMON/SASVAL/VXPVMD(-6:6),VXPANL(-6:6),VXPANH(-6:6),VXPDGM(-6:6)
      SAVE /SASCOM/,/SASVAL/
C
C...Temporary array.
      DIMENSION XPGA(-6:6), VXPGA(-6:6)
C...Charm and bottom masses (low to compensate for J/psi etc.).
      DATA PMC/1.3/, PMB/4.6/
C...alpha_em and alpha_em/(2*pi).
      DATA AEM/0.007297/, AEM2PI/0.0011614/
C...Lambda value for 4 flavours.
      DATA ALAM/0.20/
C...Mixture u/(u+d), = 0.5 for incoherent and = 0.8 for coherent sum.
      DATA FRACU/0.8/
C...VMD couplings f_V**2/(4*pi).
      DATA FRHO/2.20/, FOMEGA/23.6/, FPHI/18.4/
C...Masses for rho (=omega) and phi.
      DATA PMRHO/0.770/, PMPHI/1.020/
C...Number of points in integration for IP2=1.
      DATA NSTEP/100/
C
C...Reset output.
      F2GM=0.
      DO 100 KFL=-6,6
      XPDFGM(KFL)=0.
      XPVMD(KFL)=0.
      XPANL(KFL)=0.
      XPANH(KFL)=0.
      XPBEH(KFL)=0.
      XPDIR(KFL)=0.
      VXPVMD(KFL)=0.
      VXPANL(KFL)=0.
      VXPANH(KFL)=0.
      VXPDGM(KFL)=0.
  100 CONTINUE
C
C...Check that input sensible.
      IF(ISET.LE.0.OR.ISET.GE.5) THEN
        WRITE(*,*) ' FATAL ERROR: SaSgam called for unknown set'
        WRITE(*,*) ' ISET = ',ISET
        STOP
      ENDIF
      IF(X.LE.0..OR.X.GT.1.) THEN
        WRITE(*,*) ' FATAL ERROR: SaSgam called for unphysical x'
        WRITE(*,*) ' X = ',X
        STOP
      ENDIF
C
C...Set Q0 cut-off parameter as function of set used.
      IF(ISET.LE.2) THEN
        Q0=0.6
      ELSE
        Q0=2.
      ENDIF
      Q02=Q0**2
C
C...Scale choice for off-shell photon; common factors.
      Q2A=Q2
      FACNOR=1.
      IF(IP2.EQ.1) THEN
        P2MX=P2+Q02
        Q2A=Q2+P2*Q02/MAX(Q02,Q2)
        FACNOR=LOG(Q2/Q02)/NSTEP
      ELSEIF(IP2.EQ.2) THEN
        P2MX=MAX(P2,Q02)
      ELSEIF(IP2.EQ.3) THEN
        P2MX=P2+Q02
        Q2A=Q2+P2*Q02/MAX(Q02,Q2)
      ELSEIF(IP2.EQ.4) THEN
        P2MX=Q2*(Q02+P2)/(Q2+P2)*EXP(P2*(Q2-Q02)/
     &  ((Q2+P2)*(Q02+P2)))
      ELSEIF(IP2.EQ.5) THEN
        P2MXA=Q2*(Q02+P2)/(Q2+P2)*EXP(P2*(Q2-Q02)/
     &  ((Q2+P2)*(Q02+P2)))
        P2MX=Q0*SQRT(P2MXA)
        FACNOR=LOG(Q2/P2MXA)/LOG(Q2/P2MX)
      ELSEIF(IP2.EQ.6) THEN
        P2MX=Q2*(Q02+P2)/(Q2+P2)*EXP(P2*(Q2-Q02)/
     &  ((Q2+P2)*(Q02+P2)))
        P2MX=MAX(0.,1.-P2/Q2)*P2MX+MIN(1.,P2/Q2)*MAX(P2,Q02)
      ELSE
        P2MXA=Q2*(Q02+P2)/(Q2+P2)*EXP(P2*(Q2-Q02)/
     &  ((Q2+P2)*(Q02+P2)))
        P2MX=Q0*SQRT(P2MXA)
        P2MXB=P2MX
        P2MX=MAX(0.,1.-P2/Q2)*P2MX+MIN(1.,P2/Q2)*MAX(P2,Q02)
        P2MXB=MAX(0.,1.-P2/Q2)*P2MXB+MIN(1.,P2/Q2)*P2MXA
        FACNOR=LOG(Q2/P2MXA)/LOG(Q2/P2MXB)
      ENDIF
C
C...Call VMD parametrization for d quark and use to give rho, omega,
C...phi. Note dipole dampening for off-shell photon.
      CALL SASVMD(ISET,1,X,Q2A,P2MX,ALAM,XPGA,VXPGA)
      XFVAL=VXPGA(1)
      XPGA(1)=XPGA(2)
      XPGA(-1)=XPGA(-2)
      FACUD=AEM*(1./FRHO+1./FOMEGA)*(PMRHO**2/(PMRHO**2+P2))**2
      FACS=AEM*(1./FPHI)*(PMPHI**2/(PMPHI**2+P2))**2
      DO 110 KFL=-5,5
      XPVMD(KFL)=(FACUD+FACS)*XPGA(KFL)
  110 CONTINUE
      XPVMD(1)=XPVMD(1)+(1.-FRACU)*FACUD*XFVAL
      XPVMD(2)=XPVMD(2)+FRACU*FACUD*XFVAL
      XPVMD(3)=XPVMD(3)+FACS*XFVAL
      XPVMD(-1)=XPVMD(-1)+(1.-FRACU)*FACUD*XFVAL
      XPVMD(-2)=XPVMD(-2)+FRACU*FACUD*XFVAL
      XPVMD(-3)=XPVMD(-3)+FACS*XFVAL
      VXPVMD(1)=(1.-FRACU)*FACUD*XFVAL
      VXPVMD(2)=FRACU*FACUD*XFVAL
      VXPVMD(3)=FACS*XFVAL
      VXPVMD(-1)=(1.-FRACU)*FACUD*XFVAL
      VXPVMD(-2)=FRACU*FACUD*XFVAL
      VXPVMD(-3)=FACS*XFVAL
C
      IF(IP2.NE.1) THEN
C...Anomalous parametrizations for different strategies
C...for off-shell photons; except full integration.
C
C...Call anomalous parametrization for d + u + s.
        CALL SASANO(-3,X,Q2A,P2MX,ALAM,XPGA,VXPGA)
        DO 120 KFL=-5,5
        XPANL(KFL)=FACNOR*XPGA(KFL)
        VXPANL(KFL)=FACNOR*VXPGA(KFL)
  120   CONTINUE
C
C...Call anomalous parametrization for c and b.
        CALL SASANO(4,X,Q2A,P2MX,ALAM,XPGA,VXPGA)
        DO 130 KFL=-5,5
        XPANH(KFL)=FACNOR*XPGA(KFL)
        VXPANH(KFL)=FACNOR*VXPGA(KFL)
  130   CONTINUE
        CALL SASANO(5,X,Q2A,P2MX,ALAM,XPGA,VXPGA)
        DO 140 KFL=-5,5
        XPANH(KFL)=XPANH(KFL)+FACNOR*XPGA(KFL)
        VXPANH(KFL)=VXPANH(KFL)+FACNOR*VXPGA(KFL)
  140   CONTINUE
C
      ELSE
C...Special option: loop over flavours and integrate over k2.
        DO 170 KF=1,5
        DO 160 ISTEP=1,NSTEP
        Q2STEP=Q02*(Q2/Q02)**((ISTEP-0.5)/NSTEP)
        IF((KF.EQ.4.AND.Q2STEP.LT.PMC**2).OR.
     &  (KF.EQ.5.AND.Q2STEP.LT.PMB**2)) GOTO 160
        CALL SASVMD(0,KF,X,Q2,Q2STEP,ALAM,XPGA,VXPGA)
        FACQ=AEM2PI*(Q2STEP/(Q2STEP+P2))**2*FACNOR
        IF(MOD(KF,2).EQ.0) FACQ=FACQ*(8./9.)
        IF(MOD(KF,2).EQ.1) FACQ=FACQ*(2./9.)
        DO 150 KFL=-5,5
        IF(KF.LE.3) XPANL(KFL)=XPANL(KFL)+FACQ*XPGA(KFL)
        IF(KF.GE.4) XPANH(KFL)=XPANH(KFL)+FACQ*XPGA(KFL)
        IF(KF.LE.3) VXPANL(KFL)=VXPANL(KFL)+FACQ*VXPGA(KFL)
        IF(KF.GE.4) VXPANH(KFL)=VXPANH(KFL)+FACQ*VXPGA(KFL)
  150   CONTINUE
  160   CONTINUE
  170   CONTINUE
      ENDIF
C
C...Call Bethe-Heitler term expression for charm and bottom.
      CALL SASBEH(4,X,Q2,P2,PMC**2,XPBH)
      XPBEH(4)=XPBH
      XPBEH(-4)=XPBH
      CALL SASBEH(5,X,Q2,P2,PMB**2,XPBH)
      XPBEH(5)=XPBH
      XPBEH(-5)=XPBH
C
C...For MSbar subtraction call C^gamma term expression for d, u, s.
      IF(ISET.EQ.2.OR.ISET.EQ.4) THEN
        CALL SASDIR(X,Q2,P2,Q02,XPGA)
        DO 180 KFL=-5,5
        XPDIR(KFL)=XPGA(KFL)
  180   CONTINUE
      ENDIF
C
C...Store result in output array.
      DO 190 KFL=-5,5
      CHSQ=1./9.
      IF(IABS(KFL).EQ.2.OR.IABS(KFL).EQ.4) CHSQ=4./9.
      XPF2=XPVMD(KFL)+XPANL(KFL)+XPBEH(KFL)+XPDIR(KFL)
      IF(KFL.NE.0) F2GM=F2GM+CHSQ*XPF2
      XPDFGM(KFL)=XPVMD(KFL)+XPANL(KFL)+XPANH(KFL)
      VXPDGM(KFL)=VXPVMD(KFL)+VXPANL(KFL)+VXPANH(KFL)
  190 CONTINUE
C
      RETURN
      END
C
C*********************************************************************
C
      SUBROUTINE SASVMD(ISET,KF,X,Q2,P2,ALAM,XPGA,VXPGA)
C...Purpose: to evaluate the VMD parton distributions of a photon,
C...evolved homogeneously from an initial scale P2 to Q2.
C...Does not include dipole suppression factor.
C...ISET is parton distribution set, see above;
C...additionally ISET=0 is used for the evolution of an anomalous photon
C...which branched at a scale P2 and then evolved homogeneously to Q2.
C...ALAM is the 4-flavour Lambda, which is automatically converted
C...to 3- and 5-flavour equivalents as needed.
      DIMENSION XPGA(-6:6), VXPGA(-6:6)
      DATA PMC/1.3/, PMB/4.6/
C
C...Reset output.
      DO 100 KFL=-6,6
      XPGA(KFL)=0.
      VXPGA(KFL)=0.
  100 CONTINUE
      KFA=IABS(KF)
C
C...Calculate Lambda; protect against unphysical Q2 and P2 input.
      ALAM3=ALAM*(PMC/ALAM)**(2./27.)
      ALAM5=ALAM*(ALAM/PMB)**(2./23.)
      P2EFF=MAX(P2,1.2*ALAM3**2)
      IF(KFA.EQ.4) P2EFF=MAX(P2EFF,PMC**2)
      IF(KFA.EQ.5) P2EFF=MAX(P2EFF,PMB**2)
      Q2EFF=MAX(Q2,P2EFF)
C
C...Find number of flavours at lower and upper scale.
      NFP=4
      IF(P2EFF.LT.PMC**2) NFP=3
      IF(P2EFF.GT.PMB**2) NFP=5
      NFQ=4
      IF(Q2EFF.LT.PMC**2) NFQ=3
      IF(Q2EFF.GT.PMB**2) NFQ=5
C
C...Find s as sum of 3-, 4- and 5-flavour parts.
      S=0.
      IF(NFP.EQ.3) THEN
        Q2DIV=PMC**2
        IF(NFQ.EQ.3) Q2DIV=Q2EFF
        S=S+(6./27.)*LOG(LOG(Q2DIV/ALAM3**2)/LOG(P2EFF/ALAM3**2))
      ENDIF
      IF(NFP.LE.4.AND.NFQ.GE.4) THEN
        P2DIV=P2EFF
        IF(NFP.EQ.3) P2DIV=PMC**2
        Q2DIV=Q2EFF
        IF(NFQ.EQ.5) Q2DIV=PMB**2
        S=S+(6./25.)*LOG(LOG(Q2DIV/ALAM**2)/LOG(P2DIV/ALAM**2))
      ENDIF
      IF(NFQ.EQ.5) THEN
        P2DIV=PMB**2
        IF(NFP.EQ.5) P2DIV=P2EFF
        S=S+(6./23.)*LOG(LOG(Q2EFF/ALAM5**2)/LOG(P2DIV/ALAM5**2))
      ENDIF
C
C...Calculate frequent combinations of x and s.
      X1=1.-X
      XL=-LOG(X)
      S2=S**2
      S3=S**3
      S4=S**4
C
C...Evaluate homogeneous anomalous parton distributions below or
C...above threshold.
      IF(ISET.EQ.0) THEN
      IF(Q2.LE.P2.OR.(KFA.EQ.4.AND.Q2.LT.PMC**2).OR.
     &(KFA.EQ.5.AND.Q2.LT.PMB**2)) THEN
        XVAL = X * 1.5 * (X**2+X1**2)
        XGLU = 0.
        XSEA = 0.
      ELSE
        XVAL = (1.5/(1.-0.197*S+4.33*S2)*X**2 + (1.5+2.10*S)/
     &  (1.+3.29*S)*X1**2 + 5.23*S/(1.+1.17*S+19.9*S3)*X*X1) *
     &  X**(1./(1.+1.5*S)) * (1.-X**2)**(2.667*S)
        XGLU = 4.*S/(1.+4.76*S+15.2*S2+29.3*S4) *
     &  X**(-2.03*S/(1.+2.44*S)) * (X1*XL)**(1.333*S) *
     &  ((4.*X**2+7.*X+4.)*X1/3. - 2.*X*(1.+X)*XL)
        XSEA = S2/(1.+4.54*S+8.19*S2+8.05*S3) *
     &  X**(-1.54*S/(1.+1.29*S)) * X1**(2.667*S) *
     &  ((8.-73.*X+62.*X**2)*X1/9. + (3.-8.*X**2/3.)*X*XL +
     &  (2.*X-1.)*X*XL**2)
      ENDIF
C
C...Evaluate set 1D parton distributions below or above threshold.
      ELSEIF(ISET.EQ.1) THEN
      IF(Q2.LE.P2.OR.(KFA.EQ.4.AND.Q2.LT.PMC**2).OR.
     &(KFA.EQ.5.AND.Q2.LT.PMB**2)) THEN
        XVAL = 1.294 * X**0.80 * X1**0.76
        XGLU = 1.273 * X**0.40 * X1**1.76
        XSEA = 0.100 * X1**3.76
      ELSE
        XVAL = 1.294/(1.+0.252*S+3.079*S2) * X**(0.80-0.13*S) *
     &  X1**(0.76+0.667*S) * XL**(2.*S)
        XGLU = 7.90*S/(1.+5.50*S) * EXP(-5.16*S) *
     &  X**(-1.90*S/(1.+3.60*S)) * X1**1.30 * XL**(0.50+3.*S) +
     &  1.273 * EXP(-10.*S) * X**0.40 * X1**(1.76+3.*S)
        XSEA = (0.1-0.397*S2+1.121*S3)/(1.+5.61*S2+5.26*S3) *
     &  X**(-7.32*S2/(1.+10.3*S2)) *
     &  X1**((3.76+15.*S+12.*S2)/(1.+4.*S))
        XSEA0 = 0.100 * X1**3.76
      ENDIF
C
C...Evaluate set 1M parton distributions below or above threshold.
      ELSEIF(ISET.EQ.2) THEN
      IF(Q2.LE.P2.OR.(KFA.EQ.4.AND.Q2.LT.PMC**2).OR.
     &(KFA.EQ.5.AND.Q2.LT.PMB**2)) THEN
        XVAL = 0.8477 * X**0.51 * X1**1.37
        XGLU = 3.42 * X**0.255 * X1**2.37
        XSEA = 0.
      ELSE
        XVAL = 0.8477/(1.+1.37*S+2.18*S2+3.73*S3) * X**(0.51+0.21*S)
     &  * X1**1.37 * XL**(2.667*S)
        XGLU = 24.*S/(1.+9.6*S+0.92*S2+14.34*S3) * EXP(-5.94*S) *
     &  X**((-0.013-1.80*S)/(1.+3.14*S)) * X1**(2.37+0.4*S) *
     &  XL**(0.32+3.6*S) + 3.42 * EXP(-12.*S) * X**0.255 *
     &  X1**(2.37+3.*S)
        XSEA = 0.842*S/(1.+21.3*S-33.2*S2+229.*S3) *
     &  X**((0.13-2.90*S)/(1.+5.44*S)) * X1**(3.45+0.5*S) *
     &  XL**(2.8*S)
        XSEA0 = 0.
      ENDIF
C
C...Evaluate set 2D parton distributions below or above threshold.
      ELSEIF(ISET.EQ.3) THEN
      IF(Q2.LE.P2.OR.(KFA.EQ.4.AND.Q2.LT.PMC**2).OR.
     &(KFA.EQ.5.AND.Q2.LT.PMB**2)) THEN
        XVAL = X**0.46 * X1**0.64 + 0.76 * X
        XGLU = 1.925 * X1**2
        XSEA = 0.242 * X1**4
      ELSE
        XVAL = (1.+0.186*S)/(1.-0.209*S+1.495*S2) * X**(0.46+0.25*S)
     &  * X1**((0.64+0.14*S+5.*S2)/(1.+S)) * XL**(1.9*S) +
     &  (0.76+0.4*S) * X * X1**(2.667*S)
        XGLU = (1.925+5.55*S+147.*S2)/(1.-3.59*S+3.32*S2) *
     &  EXP(-18.67*S) * X**((-5.81*S-5.34*S2)/(1.+29.*S-4.26*S2))
     &  * X1**((2.-5.9*S)/(1.+1.7*S)) * XL**(9.3*S/(1.+1.7*S))
        XSEA = (0.242-0.252*S+1.19*S2)/(1.-0.607*S+21.95*S2) *
     &  X**(-12.1*S2/(1.+2.62*S+16.7*S2)) * X1**4 * XL**S
        XSEA0 = 0.242 * X1**4
      ENDIF
C
C...Evaluate set 2M parton distributions below or above threshold.
      ELSEIF(ISET.EQ.4) THEN
      IF(Q2.LE.P2.OR.(KFA.EQ.4.AND.Q2.LT.PMC**2).OR.
     &(KFA.EQ.5.AND.Q2.LT.PMB**2)) THEN
        XVAL = 1.168 * X**0.50 * X1**2.60 + 0.965 * X
        XGLU = 1.808 * X1**2
        XSEA = 0.209 * X1**4
      ELSE
        XVAL = (1.168+1.771*S+29.35*S2) * EXP(-5.776*S) *
     &  X**((0.5+0.208*S)/(1.-0.794*S+1.516*S2)) *
     &  X1**((2.6+7.6*S)/(1.+5.*S)) * XL**(5.15*S/(1.+2.*S)) +
     &  (0.965+22.35*S)/(1.+18.4*S) * X * X1**(2.667*S)
        XGLU = (1.808+29.9*S)/(1.+26.4*S) * EXP(-5.28*S) *
     &  X**((-5.35*S-10.11*S2)/(1.+31.71*S)) *
     &  X1**((2.-7.3*S+4.*S2)/(1.+2.5*S)) *
     &  XL**(10.9*S/(1.+2.5*S))
        XSEA = (0.209+0.644*S2)/(1.+0.319*S+17.6*S2) *
     &  X**((-0.373*S-7.71*S2)/(1.+0.815*S+11.0*S2)) *
     &  X1**(4.+S) * XL**(0.45*S)
        XSEA0 = 0.209 * X1**4
      ENDIF
      ENDIF
C
C...Threshold factors for c and b sea.
      SLL=LOG(LOG(Q2EFF/ALAM**2)/LOG(P2EFF/ALAM**2))
      XCHM=0.
      IF(Q2.GT.PMC**2.AND.Q2.GT.1.001*P2EFF) THEN
        SCH=MAX(0.,LOG(LOG(PMC**2/ALAM**2)/LOG(P2EFF/ALAM**2)))
        IF(ISET.EQ.0) THEN
          XCHM=XSEA*(1.-(SCH/SLL)**2)
        ELSE
          XCHM=MAX(0.,XSEA-XSEA0*X1**(2.667*S))*(1.-SCH/SLL)
        ENDIF
      ENDIF
      XBOT=0.
      IF(Q2.GT.PMB**2.AND.Q2.GT.1.001*P2EFF) THEN
        SBT=MAX(0.,LOG(LOG(PMB**2/ALAM**2)/LOG(P2EFF/ALAM**2)))
        IF(ISET.EQ.0) THEN
          XBOT=XSEA*(1.-(SBT/SLL)**2)
        ELSE
          XBOT=MAX(0.,XSEA-XSEA0*X1**(2.667*S))*(1.-SBT/SLL)
        ENDIF
      ENDIF
C
C...Fill parton distributions.
      XPGA(0)=XGLU
      XPGA(1)=XSEA
      XPGA(2)=XSEA
      XPGA(3)=XSEA
      XPGA(4)=XCHM
      XPGA(5)=XBOT
      XPGA(KFA)=XPGA(KFA)+XVAL
      DO 110 KFL=1,5
      XPGA(-KFL)=XPGA(KFL)
  110 CONTINUE
      VXPGA(KFA)=XVAL
      VXPGA(-KFA)=XVAL
C
      RETURN
      END
C
C*********************************************************************
C
      SUBROUTINE SASANO(KF,X,Q2,P2,ALAM,XPGA,VXPGA)
C...Purpose: to evaluate the parton distributions of the anomalous
C...photon, inhomogeneously evolved from a scale P2 (where it vanishes)
C...to Q2.
C...KF=0 gives the sum over (up to) 5 flavours,
C...KF<0 limits to flavours up to abs(KF),
C...KF>0 is for flavour KF only.
C...ALAM is the 4-flavour Lambda, which is automatically converted
C...to 3- and 5-flavour equivalents as needed.
      DIMENSION XPGA(-6:6), VXPGA(-6:6), ALAMSQ(3:5)
      DATA PMC/1.3/, PMB/4.6/, AEM2PI/0.0011614/
C
C...Reset output.
      DO 100 KFL=-6,6
      XPGA(KFL)=0.
      VXPGA(KFL)=0.
  100 CONTINUE
      IF(Q2.LE.P2) RETURN
      KFA=IABS(KF)
C
C...Calculate Lambda; protect against unphysical Q2 and P2 input.
      ALAMSQ(3)=(ALAM*(PMC/ALAM)**(2./27.))**2
      ALAMSQ(4)=ALAM**2
      ALAMSQ(5)=(ALAM*(ALAM/PMB)**(2./23.))**2
      P2EFF=MAX(P2,1.2*ALAMSQ(3))
      IF(KF.EQ.4) P2EFF=MAX(P2EFF,PMC**2)
      IF(KF.EQ.5) P2EFF=MAX(P2EFF,PMB**2)
      Q2EFF=MAX(Q2,P2EFF)
      XL=-LOG(X)
C
C...Find number of flavours at lower and upper scale.
      NFP=4
      IF(P2EFF.LT.PMC**2) NFP=3
      IF(P2EFF.GT.PMB**2) NFP=5
      NFQ=4
      IF(Q2EFF.LT.PMC**2) NFQ=3
      IF(Q2EFF.GT.PMB**2) NFQ=5
C
C...Define range of flavour loop.
      IF(KF.EQ.0) THEN
        KFLMN=1
        KFLMX=5
      ELSEIF(KF.LT.0) THEN
        KFLMN=1
        KFLMX=KFA
      ELSE
        KFLMN=KFA
        KFLMX=KFA
      ENDIF
C
C...Loop over flavours the photon can branch into.
      DO 110 KFL=KFLMN,KFLMX
C
C...Light flavours: calculate t range and (approximate) s range.
      IF(KFL.LE.3.AND.(KFL.EQ.1.OR.KFL.EQ.KF)) THEN
        TDIFF=LOG(Q2EFF/P2EFF)
        S=(6./(33.-2.*NFQ))*LOG(LOG(Q2EFF/ALAMSQ(NFQ))/
     &  LOG(P2EFF/ALAMSQ(NFQ)))
        IF(NFQ.GT.NFP) THEN
          Q2DIV=PMB**2
          IF(NFQ.EQ.4) Q2DIV=PMC**2
          SNFQ=(6./(33.-2.*NFQ))*LOG(LOG(Q2DIV/ALAMSQ(NFQ))/
     &    LOG(P2EFF/ALAMSQ(NFQ)))
          SNFP=(6./(33.-2.*(NFQ-1)))*LOG(LOG(Q2DIV/ALAMSQ(NFQ-1))/
     &    LOG(P2EFF/ALAMSQ(NFQ-1)))
          S=S+(LOG(Q2DIV/P2EFF)/LOG(Q2EFF/P2EFF))*(SNFP-SNFQ)
        ENDIF
        IF(NFQ.EQ.5.AND.NFP.EQ.3) THEN
          Q2DIV=PMC**2
          SNF4=(6./(33.-2.*4))*LOG(LOG(Q2DIV/ALAMSQ(4))/
     &    LOG(P2EFF/ALAMSQ(4)))
          SNF3=(6./(33.-2.*3))*LOG(LOG(Q2DIV/ALAMSQ(3))/
     &    LOG(P2EFF/ALAMSQ(3)))
          S=S+(LOG(Q2DIV/P2EFF)/LOG(Q2EFF/P2EFF))*(SNF3-SNF4)
        ENDIF
C
C...u and s quark do not need a separate treatment when d has been done.
      ELSEIF(KFL.EQ.2.OR.KFL.EQ.3) THEN
C
C...Charm: as above, but only include range above c threshold.
      ELSEIF(KFL.EQ.4) THEN
        IF(Q2.LE.PMC**2) GOTO 110
        P2EFF=MAX(P2EFF,PMC**2)
        Q2EFF=MAX(Q2EFF,P2EFF)
        TDIFF=LOG(Q2EFF/P2EFF)
        S=(6./(33.-2.*NFQ))*LOG(LOG(Q2EFF/ALAMSQ(NFQ))/
     &  LOG(P2EFF/ALAMSQ(NFQ)))
        IF(NFQ.EQ.5.AND.NFP.EQ.4) THEN
          Q2DIV=PMB**2
          SNFQ=(6./(33.-2.*NFQ))*LOG(LOG(Q2DIV/ALAMSQ(NFQ))/
     &    LOG(P2EFF/ALAMSQ(NFQ)))
          SNFP=(6./(33.-2.*(NFQ-1)))*LOG(LOG(Q2DIV/ALAMSQ(NFQ-1))/
     &    LOG(P2EFF/ALAMSQ(NFQ-1)))
          S=S+(LOG(Q2DIV/P2EFF)/LOG(Q2EFF/P2EFF))*(SNFP-SNFQ)
        ENDIF
C
C...Bottom: as above, but only include range above b threshold.
      ELSEIF(KFL.EQ.5) THEN
        IF(Q2.LE.PMB**2) GOTO 110
        P2EFF=MAX(P2EFF,PMB**2)
        Q2EFF=MAX(Q2,P2EFF)
        TDIFF=LOG(Q2EFF/P2EFF)
        S=(6./(33.-2.*NFQ))*LOG(LOG(Q2EFF/ALAMSQ(NFQ))/
     &  LOG(P2EFF/ALAMSQ(NFQ)))
      ENDIF
C
C...Evaluate flavour-dependent prefactor (charge^2 etc.).
      CHSQ=1./9.
      IF(KFL.EQ.2.OR.KFL.EQ.4) CHSQ=4./9.
      FAC=AEM2PI*2.*CHSQ*TDIFF
C
C...Evaluate parton distributions (normalized to unit momentum sum).
      IF(KFL.EQ.1.OR.KFL.EQ.4.OR.KFL.EQ.5.OR.KFL.EQ.KF) THEN
        XVAL= ((1.5+2.49*S+26.9*S**2)/(1.+32.3*S**2)*X**2 +
     &  (1.5-0.49*S+7.83*S**2)/(1.+7.68*S**2)*(1.-X)**2 +
     &  1.5*S/(1.-3.2*S+7.*S**2)*X*(1.-X)) *
     &  X**(1./(1.+0.58*S)) * (1.-X**2)**(2.5*S/(1.+10.*S))
        XGLU= 2.*S/(1.+4.*S+7.*S**2) *
     &  X**(-1.67*S/(1.+2.*S)) * (1.-X**2)**(1.2*S) *
     &  ((4.*X**2+7.*X+4.)*(1.-X)/3. - 2.*X*(1.+X)*XL)
        XSEA= 0.333*S**2/(1.+4.90*S+4.69*S**2+21.4*S**3) *
     &  X**(-1.18*S/(1.+1.22*S)) * (1.-X)**(1.2*S) *
     &  ((8.-73.*X+62.*X**2)*(1.-X)/9. + (3.-8.*X**2/3.)*X*XL +
     &  (2.*X-1.)*X*XL**2)
C
C...Threshold factors for c and b sea.
        SLL=LOG(LOG(Q2EFF/ALAM**2)/LOG(P2EFF/ALAM**2))
        XCHM=0.
        IF(Q2.GT.PMC**2.AND.Q2.GT.1.001*P2EFF) THEN
          SCH=MAX(0.,LOG(LOG(PMC**2/ALAM**2)/LOG(P2EFF/ALAM**2)))
          XCHM=XSEA*(1.-(SCH/SLL)**3)
        ENDIF
        XBOT=0.
        IF(Q2.GT.PMB**2.AND.Q2.GT.1.001*P2EFF) THEN
          SBT=MAX(0.,LOG(LOG(PMB**2/ALAM**2)/LOG(P2EFF/ALAM**2)))
          XBOT=XSEA*(1.-(SBT/SLL)**3)
        ENDIF
      ENDIF
C
C...Add contribution of each valence flavour.
      XPGA(0)=XPGA(0)+FAC*XGLU
      XPGA(1)=XPGA(1)+FAC*XSEA
      XPGA(2)=XPGA(2)+FAC*XSEA
      XPGA(3)=XPGA(3)+FAC*XSEA
      XPGA(4)=XPGA(4)+FAC*XCHM
      XPGA(5)=XPGA(5)+FAC*XBOT
      XPGA(KFL)=XPGA(KFL)+FAC*XVAL
      VXPGA(KFL)=VXPGA(KFL)+FAC*XVAL
  110 CONTINUE
      DO 120 KFL=1,5
      XPGA(-KFL)=XPGA(KFL)
      VXPGA(-KFL)=VXPGA(KFL)
  120 CONTINUE
C
      RETURN
      END
C
C*********************************************************************
C
      SUBROUTINE SASBEH(KF,X,Q2,P2,PM2,XPBH)
C...Purpose: to evaluate the Bethe-Heitler cross section for
C...heavy flavour production.
      DATA AEM2PI/0.0011614/
C
C...Reset output.
      XPBH=0.
      SIGBH=0.
C
C...Check kinematics limits.
      IF(X.GE.Q2/(4.*PM2+Q2+P2)) RETURN
      W2=Q2*(1.-X)/X-P2
      BETA2=1.-4.*PM2/W2
      IF(BETA2.LT.1E-10) RETURN
      BETA=SQRT(BETA2)
      RMQ=4.*PM2/Q2
C
C...Simple case: P2 = 0.
      IF(P2.LT.1E-4) THEN
        IF(BETA.LT.0.99) THEN
          XBL=LOG((1.+BETA)/(1.-BETA))
        ELSE
          XBL=LOG((1.+BETA)**2*W2/(4.*PM2))
        ENDIF
        SIGBH=BETA*(8.*X*(1.-X)-1.-RMQ*X*(1.-X))+
     &  XBL*(X**2+(1.-X)**2+RMQ*X*(1.-3.*X)-0.5*RMQ**2*X**2)
C
C...Complicated case: P2 > 0, based on approximation of
C...C.T. Hill and G.G. Ross, Nucl. Phys. B148 (1979) 373
      ELSE
        RPQ=1.-4.*X**2*P2/Q2
        IF(RPQ.GT.1E-10) THEN
          RPBE=SQRT(RPQ*BETA2)
          IF(RPBE.LT.0.99) THEN
            XBL=LOG((1.+RPBE)/(1.-RPBE))
            XBI=2.*RPBE/(1.-RPBE**2)
          ELSE
            RPBESN=4.*PM2/W2+(4.*X**2*P2/Q2)*BETA2
            XBL=LOG((1.+RPBE)**2/RPBESN)
            XBI=2.*RPBE/RPBESN
          ENDIF
          SIGBH=BETA*(6.*X*(1.-X)-1.)+
     &    XBL*(X**2+(1.-X)**2+RMQ*X*(1.-3.*X)-0.5*RMQ**2*X**2)+
     &    XBI*(2.*X/Q2)*(PM2*X*(2.-RMQ)-P2*X)
        ENDIF
      ENDIF
C
C...Multiply by charge-squared etc. to get parton distribution.
      CHSQ=1./9.
      IF(IABS(KF).EQ.2.OR.IABS(KF).EQ.4) CHSQ=4./9.
      XPBH=3.*CHSQ*AEM2PI*X*SIGBH
C
      RETURN
      END
C
C*********************************************************************
C
      SUBROUTINE SASDIR(X,Q2,P2,Q02,XPGA)
C...Purpose: to evaluate the direct contribution, i.e. the C^gamma term,
C...as needed in MSbar parametrizations.
      DIMENSION XPGA(-6:6)
      DATA AEM2PI/0.0011614/
C
C...Reset output.
      DO 100 KFL=-6,6
      XPGA(KFL)=0.
  100 CONTINUE
C
C...Evaluate common x-dependent expression.
      XTMP = (X**2+(1.-X)**2) * (-LOG(X)) - 1.
      CGAM = 3.*AEM2PI*X * (XTMP*(1.+P2/(P2+Q02)) + 6.*X*(1.-X))
C
C...d, u, s part by simple charge factor.
      XPGA(1)=(1./9.)*CGAM
      XPGA(2)=(4./9.)*CGAM
      XPGA(3)=(1./9.)*CGAM
C
C...Also fill for antiquarks.
      DO 110 KF=1,5
      XPGA(-KF)=XPGA(KF)
  110 CONTINUE
C
      RETURN
      END
C-----------------------------------------------------------------------