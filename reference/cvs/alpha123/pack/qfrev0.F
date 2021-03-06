      SUBROUTINE QFREV0
CKEY FILL VERTEX /INTERNAL
C----------------------------------------------------------------------
C! Fill ALPHA banks with reconstructed vertex, v0 information.
C!  Author   : E. Blucher                22-APR-1989
C!  Modified : E. Blucher, R. Jacobsen   30-JAN-1992
C!  Modified : J. Boucrot                05-May-1993
C!  Description
C!  ===========
C! QVRT filled with (1) main vertex from PYER and (2) V0's from
C! YV0V.
C! QVEC V0 section filled from YV0V.
C! QVEC DC section filled with daughters from V0's after calling
C!    UHELIX to calculate track momenta at point of closest approach
C!    to the secondary vertex.
C!    30-1-92:
C!    If V0 daughter momenta are stored in YV0V, these momenta are
C!    used and UHELIX is not called.
C!  ---->  called from QFILL
C======================================================================
#ifndef DOC
      SAVE LYV0VO
#include "qcde.h"
#include "pyerjj.h"
#include "pyfrjj.h"
      LOGICAL IBOOK,BTEST
      REAL CHIOR(2,50),QGA(50),CHQGA(50),QK0(50),CHQK0(50),QLA(50),
     $CHQLA(50),QAL(50),CHQAL(50),XMGA(50),CXMGA(50),XMK0(50),CXMK0(50),
     $     XMLA(50),CXMLA(50),XMAL(50),CXMAL(50),NCOR(2,50),DISCO(2,50)
#include "pynejj.h"
      DIMENSION XR(3),XV(3),COVX(3,3),PR(3),COVP(3,3)
      DIMENSION ITKD(2)
      DATA LYV0VO/57/
#include "qmacro.h"
C ----------------------------------------------------------------------
      JQVRT(I,N) = KOQVRT + I * KCQVRT + N
      JQVEC(I,N) = KOQVEC + I * KCQVEC + N
      IQVEC(I,N) = IW (KOQVEC + I * KCQVEC + N)
      IQVRT(I,N) = IW (KOQVRT + I * KCQVRT + N)
C-----------------------------------------------------------------------
C
      IF (KNCHT.EQ.0) GO TO 999
      JPYER = IW(NAPYER)
      JPYFR = IW(NAPYFR)
      JPYNE = IW(NAPYNE)
      JYV0V = IW(NAYV0V)
C
C If one reads a POT or DST AND if the user has specified 'REV0'
C ( new V0 making giving bank YV0V NR = 3 ) then redo the V0 finding :
C
      IF (INDATA.EQ.3.OR.INDATA.EQ.4) THEN
         IREV0=IW(NAMIND('REV0'))
         NV03=NLINK('YV0V',3)
         IF (IREV0.GT.0.AND.NV03.EQ.0) THEN
            IBOOK=.FALSE.
            IV0BK=1
            CALL YMFV0V(IBOOK,IV0BK,IERCO,NUMV0,CHIOR,QGA,CHQGA,QK0,
     $                   CHQK0,QLA,CHQLA,QAL,CHQAL,XMGA,CXMGA,XMK0,
     $                   CXMK0,XMLA,CXMLA,XMAL,CXMAL,NCOR,DISCO)
            IF (IERCO.EQ.0) THEN
               JYV0V=NLINK('YV0V',3)
               CALL BLIST(IW,'S+','YV0V')
            ENDIF
         ENDIF
      ENDIF
C
      NPYER = IW(JPYER+LMHROW)
      NPYFR = IW(JPYFR+LMHROW)
      NPYNE = IW(JPYNE+LMHROW)
      KNV0T = IW(JYV0V+LMHROW)
      IF (JYV0V.EQ.0) KNV0T = 0
      IF (JPYER.EQ.0) NPYER = 0
C For CLAS 16 events only :
C if no JULIA vertex , build a dummy one , which will be filled
C with the interaction point from QFILBP :
      CALL ABGTCL(ICLAS)
      INOJU=0
      IF (NPYER.EQ.0.AND.BTEST(ICLAS,15)) THEN
         NPYER=1
         INOJU=1
      ENDIF
      IF (KNV0T.EQ.0.AND.NPYER.EQ.0.) GO TO 999
C
C---Fill QVRT with reconstructed vertices (section REV of QVRT)
C
C---First, vertices from PYER bank (only main vertex as of JULIA 224);
C---then, reconstructed V0's from YV0V.
C---Once a correspondance bank between PYER and YV0V exists, a check mus
C---be made for vertices appearing in both banks.
C
      KLREV = KLREV + NPYER + KNV0T
      KNREV=NPYER + KNV0T
      IF (KLREV .GE. KLFRV)  CALL QSBANK ('QVRT', KLREV + 100)
      JNQVRT = KOQVRT + KFREV*KCQVRT
      NSECT=0
C
C---Vertices from PYER
C
      DO 300 N = 1, NPYER
        NSECV=0
        IF (INOJU.EQ.1) THEN
           IW(JNQVRT+JQVRVN)=N
           IW(JNQVRT+JQVRTY)=1
           IW(JNQVRT+JQVRIP)=0
           IW(JNQVRT+JQVRAY)=0
           IW(JNQVRT+JQVRAF)=0
           GO TO 341
        ENDIF
        IPVER = KROW(JPYER,N)
        RW(JNQVRT+JQVRVX)=RW(IPVER+JPYEVX)
        RW(JNQVRT+JQVRVY)=RW(IPVER+JPYEVY)
        RW(JNQVRT+JQVRVZ)=RW(IPVER+JPYEVZ)
        IW(JNQVRT+JQVRVN)=N
        IW(JNQVRT+JQVRTY)=IW(IPVER+JPYETY)
        RW(JNQVRT+JQVREM  )=RW(IPVER+JPYEVM  )
        RW(JNQVRT+JQVREM+1)=RW(IPVER+JPYEVM+1)
        RW(JNQVRT+JQVREM+2)=RW(IPVER+JPYEVM+2)
        RW(JNQVRT+JQVREM+3)=RW(IPVER+JPYEVM+3)
        RW(JNQVRT+JQVREM+4)=RW(IPVER+JPYEVM+4)
        RW(JNQVRT+JQVREM+5)=RW(IPVER+JPYEVM+5)
        IW(JNQVRT+JQVRAY)= 0
        IW(JNQVRT+JQVRAF)= 0
C--- no incoming particle
        IW(JNQVRT+JQVRIP)=0
C---Loop over vertex -- charged track relation
        DO 340 N3=1,NPYFR
          NV=ITABL(JPYFR,N3,JPYFVN)
          IF(NV.EQ.N) NSECV=NSECV+1
  340   CONTINUE
  341   IW(JNQVRT+JQVRND)=NSECV
        NSECT=NSECT+NSECV
        JNQVRT = JNQVRT + KCQVRT
  300 CONTINUE
C
C---V0's from YV0V
C
      KLV0T = KLV0T + KNV0T
      IF (KLV0T .GE. KLFRT)  CALL QSBANK ('QVEC', KLV0T + 100)
      JNQVEC = KOQVEC + KFV0T*KCQVEC

      DO 301 N = 1, KNV0T
        NSECV=0
        IYV0V = KROW(JYV0V,N)
        RW(JNQVRT+JQVRVX)=RW(IYV0V+JYV0VX)
        RW(JNQVRT+JQVRVY)=RW(IYV0V+JYV0VY)
        RW(JNQVRT+JQVRVZ)=RW(IYV0V+JYV0VZ)
        IW(JNQVRT+JQVRVN)=N
        IW(JNQVRT+JQVRTY)=0
        RW(JNQVRT+JQVREM  )=RW(IYV0V+JYV0VM  )
        RW(JNQVRT+JQVREM+1)=RW(IYV0V+JYV0VM+1)
        RW(JNQVRT+JQVREM+2)=RW(IYV0V+JYV0VM+2)
        RW(JNQVRT+JQVREM+3)=RW(IYV0V+JYV0VM+3)
        RW(JNQVRT+JQVREM+4)=RW(IYV0V+JYV0VM+4)
        RW(JNQVRT+JQVREM+5)=RW(IYV0V+JYV0VM+5)
        IW(JNQVRT+JQVRAY)= IYV0V
        IW(JNQVRT+JQVRAF)= 0
        IW(JNQVRT+JQVRIP) = N + KFV0T -1
        NSECV=2
        IW(JNQVRT+JQVRND)=NSECV
        NSECT = NSECT+NSECV*2
        JNQVRT = JNQVRT + KCQVRT
C
C---Fill QVEC with V0s from YV0V (section V0T of QVEC)
C
        IV0 = KFV0T - 1 + N
        RW(JNQVEC+JQVEQX)=RW(IYV0V+JYV0PX)
        RW(JNQVEC+JQVEQY)=RW(IYV0V+JYV0PY)
        RW(JNQVEC+JQVEQZ)=RW(IYV0V+JYV0PZ)
        RW(JNQVEC+JQVEQE)=SQRT(RW(JNQVEC+JQVEQX)**2+
     &                  RW(JNQVEC+JQVEQY)**2+RW(JNQVEC+JQVEQZ)**2)
        RW(JNQVEC+JQVEQM)=0.
        RW(JNQVEC+JQVEQP)=RW(JNQVEC+JQVEQE)
        RW(JNQVEC+JQVECH)=0.
        IW(JNQVEC+JQVETN)=N
        IW(JNQVEC+JQVESC)=-2
        IW(JNQVEC+JQVEKS)=0
        IW(JNQVEC+JQVECL)=1
        IW(JNQVEC+JQVEPA)=0
        IW(JNQVEC+JQVEQD)=KQZER
        IW(JNQVEC+JQVENP)=0
        IW(JNQVEC+JQVESP)= IV0
        IW(JNQVEC+JQVEOV)=0
        IW(JNQVEC+JQVENO)=0
        IW(JNQVEC+JQVEOL)=0
        IW(JNQVEC+JQVENM)=0
        IW(JNQVEC+JQVEML)=0
        IW(JNQVEC+JQVELK)=0
        RW(JNQVEC+JQVEEW)=0.
C
  120   IW(JNQVEC+JQVEEV)=N + NPYER + KFREV - 1
        IW(JNQVEC+JQVEND)= 2
C---Set bit masks for V0s: OR of bit masks of daughters.
        IDA1=KFCHT+IW(IYV0V+JYV0K1)-1
        IDA2=KFCHT+IW(IYV0V+JYV0K2)-1
        DO 10 IDUM=1,KLOCKM
        IW(JNQVEC+JQVEBM+IDUM-1)
     &  = IOR(IQVEC(IDA1,JQVEBM+IDUM-1),IQVEC(IDA2,JQVEBM+IDUM-1))
10      CONTINUE
C
        X=RW(IYV0V + JYV0VX) - QVXNOM
        Y=RW(IYV0V + JYV0VY) - QVYNOM
        Z=RW(IYV0V + JYV0VZ) - QVZNOM
        PX =RW(JNQVEC+JQVEQX)
        PY =RW(JNQVEC+JQVEQY)
        PZ =RW(JNQVEC+JQVEQZ)
        PTSQ = PX**2 + PY**2
        IF(PTSQ.NE.0.) THEN
          XLAMB=(-X*PX-Y*PY)/PTSQ
        ELSE
          XLAMB = 0.
        ENDIF
        XDB=X+XLAMB*PX
        YDB=Y+XLAMB*PY
        ZDB=Z+XLAMB*PZ
        DB = SQRT(XDB**2+YDB**2)
        RW(JNQVEC+JQVEDB)=DB
        RW(JNQVEC+JQVEZB)=ZDB
        JNQVEC = JNQVEC + KCQVEC
  301 CONTINUE
C
C Filling QLIN and pointers to QLIN from QVEC and QVRT
C
      IF (KNQLIN+NSECT .GT. IW(KOQLIN))
     &              CALL QSBANK ('QLIN', KNQLIN+NSECT+ 1000)
C---Loop over bank of vertex positions -- all vertices
      DO 400 N=1,NPYER
        IVR=N-1+KFREV
        NDAU=IW(JQVRT(IVR,JQVRND))
        IF(NDAU.NE.0)THEN
          IW(JQVRT(IVR,JQVRDL)) = KNQLIN - IW(JQVRT(IVR,JQVRND))
          KNQLIN=KNQLIN+IW(JQVRT(IVR,JQVRND))
C---Loop over relation between vertices and charged tracks.
          DO 420 N3=1,NPYFR
            NV=ITABL(JPYFR,N3,JPYFVN)
            IF(NV.EQ.N) THEN
              NT=ITABL(JPYFR,N3,JPYFTN)
              IW(JQVRT(IVR,JQVRDL)) = IW(JQVRT(IVR,JQVRDL)) + 1
              IW(KOQLIN+IW(JQVRT(IVR,JQVRDL))+IW(JQVRT(IVR,JQVRND)))
     &    = NT+KFCHT-1
            ENDIF
  420     CONTINUE
        ENDIF
  400 CONTINUE
C
C---Fill QLIN for V0 daughters.  Also, make a copy of V0 daughters in DC
C---section with momentum calculated relative to the secondary vertex.
C
      KFDCT=KLV0T + 1
      KLDCT = KLV0T + 2*KNV0T
      KNDCT=KLDCT-KFDCT+1
      IF (KLDCT .GE. KLFRT)  CALL QSBANK ('QVEC', KLDCT + 100)
      DO 500 N4=1,KNV0T
        IV0 = KFV0T + N4 -1
        IVR=KFREV + N4 + NPYER -1
        IDA1=KFCHT - 1 + ITABL(JYV0V,N4,JYV0K1)
        IDA2=KFCHT - 1 + ITABL(JYV0V,N4,JYV0K2)
        IDC1=KFDCT+2*N4-2
        IDC2=IDC1+1
        CALL QVCOPY(IDC1,IDA1)
        CALL QVCOPY(IDC2,IDA2)
C
C---Daughter tracks copied; now swim momenta to secondary
C---vertex position.  Take daughter momenta from YV0V if they
C---exist.
C
        IF(LCOLS(JYV0V).GE.LYV0VO)THEN
C--- positive track
        RW(JQVEC(IDC1,JQVEQX))=RTABL(JYV0V,N4,JYV0P1)
        RW(JQVEC(IDC1,JQVEQY))=RTABL(JYV0V,N4,JYV0P1+1)
        RW(JQVEC(IDC1,JQVEQZ))=RTABL(JYV0V,N4,JYV0P1+2)
        RW(JQVEC(IDC1,JQVEQP))=
     &  SQRT(QX(IDC1)**2+QY(IDC1)**2+QZ(IDC1)**2)
        RW(JQVEC(IDC1,JQVEQE))=SQRT(QP(IDC1)**2 + QM(IDC1)**2)
C--- negative track
        RW(JQVEC(IDC2,JQVEQX))=RTABL(JYV0V,N4,JYV0P2)
        RW(JQVEC(IDC2,JQVEQY))=RTABL(JYV0V,N4,JYV0P2+1)
        RW(JQVEC(IDC2,JQVEQZ))=RTABL(JYV0V,N4,JYV0P2+2)
        RW(JQVEC(IDC2,JQVEQP))=
     &  SQRT(QX(IDC2)**2+QY(IDC2)**2+QZ(IDC2)**2)
        RW(JQVEC(IDC2,JQVEQE))=SQRT(QP(IDC2)**2 + QM(IDC2)**2)
        ELSE
        XV(1)=QVX(IVR)
        XV(2)=QVY(IVR)
        XV(3)=QVZ(IVR)
        RXY=0.
        PSIB=0.
        CALL UHELIX(KTN(IDA1),3,RXY,PSIB,XV,QMFLD,XR,COVX,PR,COVP,
     &    IFAIL)
        RW(JQVEC(IDC1,JQVEQX))=PR(1)
        RW(JQVEC(IDC1,JQVEQY))=PR(2)
        RW(JQVEC(IDC1,JQVEQZ))=PR(3)
C--- Recalculate p,E in case UHELIX used different track bank from
C--- that used in ALPHA.
        RW(JQVEC(IDC1,JQVEQP))=
     &  SQRT(QX(IDC1)**2+QY(IDC1)**2+QZ(IDC1)**2)
        RW(JQVEC(IDC1,JQVEQE))=SQRT(QP(IDC1)**2 + QM(IDC1)**2)
        CALL UHELIX(KTN(IDA2),3,RXY,PSIB,XV,QMFLD,XR,COVX,PR,COVP,
     &    IFAIL)
        RW(JQVEC(IDC2,JQVEQX))=PR(1)
        RW(JQVEC(IDC2,JQVEQY))=PR(2)
        RW(JQVEC(IDC2,JQVEQZ))=PR(3)
        RW(JQVEC(IDC2,JQVEQP))=
     &  SQRT(QX(IDC2)**2+QY(IDC2)**2+QZ(IDC2)**2)
        RW(JQVEC(IDC2,JQVEQE))=SQRT(QP(IDC2)**2 + QM(IDC2)**2)
        ENDIF
C---store daughter tracks (DC) in QLIN.
        IW(JQVRT(IVR,JQVRDL)) = KNQLIN - IQVRT(IVR,JQVRND)
        IW(JQVEC(IV0,JQVEDL)) = KNQLIN
        KNQLIN=KNQLIN+IQVRT(IVR,JQVRND)
        IW(JQVRT(IVR,JQVRDL)) = IQVRT(IVR,JQVRDL) + 1
        IW(KOQLIN+IQVRT(IVR,JQVRDL)+IQVRT(IVR,JQVRND))=IDC1
C     &    = KFCHT-1+ITABL(JYV0V,N4,JYV0K1)
        IW(JQVRT(IVR,JQVRDL)) = IQVRT(IVR,JQVRDL) + 1
        IW(KOQLIN+IQVRT(IVR,JQVRDL)+IQVRT(IVR,JQVRND))=IDC2
C     &    = KFCHT-1+ITABL(JYV0V,N4,JYV0K2)
C
C----Set pointers from DC tracks to V0T and REV sections.
C-------- (1) set up pointer from DC tracks to mother (V0 in QVEC).
        ITKD(1) = IDC1
        ITKD(2) = IDC2
        CALL QAMOTH(IV0,2,ITKD)
C-------- (2) set up pointer from DC tracks to mother (V0 in QVEC).
        IW(JQVEC(IDC1,JQVEOV))=IVR
        IW(JQVEC(IDC2,JQVEOV))=IVR
  500 CONTINUE
C
C Update KLOCUS pointers.
C ---QVEC pointers
      DO 20 N = KSDCT+1,KSMCT
        KLOCUS(1,N) = KLOCUS(2,KSDCT) + 1
   20 KLOCUS(2,N) = KLOCUS(2,KSDCT)
      KFFRT = KLOCUS(2,KSDCT) + 1
C ---QVRT pointers
      DO 30 N = KSMCV,KSMCV
        KLOCUS(1,N) = KLOCUS(2,KSREV) + 1
   30 KLOCUS(2,N) = KLOCUS(2,KSREV)
      KFFRV = KLOCUS(2,KSREV) + 1
  999 CONTINUE
      END
#endif
