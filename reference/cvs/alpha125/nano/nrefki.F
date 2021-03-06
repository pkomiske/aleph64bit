      SUBROUTINE NREFKI(IRET)
CKEY NANO IN ALPHA /INTERNAL
C----------------------------------------------------------------------
C! NANO unpacking : create FKIN,FVER,FZFR banks from NDMS,NDNT,NDLV
C!
C!   Author   :- Gerrit Graefe         16-FEB-1994
C!
C!   Inputs:
C!        - none
C!
C!   Outputs:
C!        - IRET / I        return code  0=created FKIN + FVER + FZFR +
C!                                         ITMA + IASL from NDMS + NDNT
C!                                       1=can't find NDMS or NDNT
C!                                       2=no space to book FKIN or FVER
C!                                         or FZFR or IASL or ITMA
C!                                       3=unknown error
C!
C!   Libraries required: ALPHA,BOS77
C!
C!   Description
C!   ===========
C!
C?   This subroutine creates the banks FKIN, FZFR and FVER from the banks NDMS
C?   and NDNT. A problem is that not enough information is stored on the NANO-
C?   DST to get back the same order of particles as in the original FKIN, FZFR
C?   and FVER bank. Therefore a warning is printed at the first event.
C?
C!======================================================================
#ifndef DOC
      IMPLICIT NONE
      SAVE XFIRST
#include "qdecl.h"
#include "qcde.h"
#include "nbpdcl.h"
#include "nbnkpo.h"
#include "ndmsjj.h"
#include "ndntjj.h"
#include "ndlvjj.h"
#include "ndtkjj.h"
#include "fzfrjj.h"
#include "fkinjj.h"
#include "fverjj.h"
#include "partjj.h"
#include "itmajj.h"
#include "iasljj.h"
      INTEGER NLINK,NVERS,NAMIND,INTCHA
      INTEGER I,J,K,II,IGARB,IPOINT,ILAST,IVERT,IRET
      INTEGER NDAU,NFDAU,INDMS,INDNT,IFZFR,IFKIN,IFVER,IPART,IITMA,
     &        IIASL,INDTK,INDLV
      INTEGER IROFRF,IROFKI,IROFVE,IRONDN,IRONDM,IRONDL,IROFZF,IROIAS,
     &        IROITM,IRONDT
      INTEGER KOPART,KCPART,KRPART,KOFKIN,KRFKIN,KCFKIN,
     &        KOFVER,KCFVER,KRFVER,KOFZFR,KRFZFR,KCFZFR,
     &        KOITMA,KCITMA,KRITMA,KOIASL,KRIASL,KCIASL
      INTEGER KRNDMS,KRNDNT,KRNDLV,KRNDTK
      INTEGER NMTRK,IASLOF,IMTPOI,INUTRK
      INTEGER IARR(400,6),INARR(400,6),IVERAR(200,3)
      INTEGER IMTCH(400,3),ITCH(400,3),ISORT(400)
      INTEGER MASK4,MASK5,MASK8,MASK9,MASK10
      REAL    GP(3),GX,RNARR(400,6),RARR(400,6),RVERAR(200,3)
      LOGICAL XFIRST,NXVERT,BTEST
      DATA XFIRST/.TRUE./
      DATA MASK4,MASK5,MASK8,MASK9,MASK10/15,31,127,511,1023/
#include "qmacro.h"
C----------------------------------------------------------------------
C
C!..FIRST CALL TO SUBROUTINE ? IF YES PRINT WARNING.
C
      IF (XFIRST) THEN
        XFIRST=.FALSE.
        WRITE(KUPRNT,50)
        IF(KUPTER.NE.0) WRITE(KUPTER,50)
   50   FORMAT(/,' ################################################',
     &         /,' ######        A T T E N T I O N !         ######',
     &         /,' ################################################',
     &         /,' You selected MONTE CARLO input from a NANO-DST. ',
     &         /,' On this data set is not enough information to   ',
     &         /,' recreate the FKIN and FVER bank as they are on  ',
     &         /,' a DST. So beware that there is no one-to-one    ',
     &         /,' correspondence between the rows of FKIN(DST) and',
     &         /,' FKIN(NANO). Nevertheless no particle is missing ',
     &         /,' just their order has changed. The same is valid ',
     &         /,' for the FVER bank. ',
     &         /,' ================================================',/)
      ENDIF
C
C!..LINK TO BANK NDMS AND NDNT AND NDTK AND PART
C
      IRET=3
      INDMS=IW(NAMIND('NDMS'))
      INDNT=IW(NAMIND('NDNT'))
      IPART=IW(NAMIND('PART'))
      INDTK=IW(NAMIND('NDTK'))
      INDLV=IW(NAMIND('NDLV'))
      IF(INDMS.EQ.0.OR.INDNT.EQ.0.OR.IPART.EQ.0)THEN
        IRET=1
        RETURN
      ENDIF
      KONDMS=INDMS
      KCNDMS=IW(KONDMS+1)
      KRNDMS=IW(KONDMS+2)
      KONDNT=INDNT
      KCNDNT=IW(KONDNT+1)
      KRNDNT=IW(KONDNT+2)
      KOPART=IPART
      KCPART=IW(KOPART+1)
      KRPART=IW(KOPART+2)
      IF(INDTK.NE.0)THEN
        KONDTK=INDTK
        KCNDTK=IW(KONDTK+1)
        KRNDTK=IW(KONDTK+2)
      ELSE
        KONDTK=0
        KCNDTK=0
        KRNDTK=0
      ENDIF
      IF(INDLV.NE.0)THEN
        KONDLV=INDLV
        KCNDLV=IW(KONDLV+1)
        KRNDLV=IW(KONDLV+2)
      ELSE
        KONDLV=0
        KCNDLV=0
        KRNDLV=0
      ENDIF
C
C!..CREATE BANK FKIN + FZFR + ITMA + ITMA
C
C!..FKIN
      CALL AUBOS('FKIN',0,LMHLEN+LFKINA*(KRNDMS+KRNDNT),IFKIN,IGARB)
      IF(IGARB.EQ.2)THEN
        CALL QWMESE('### NREFKI ### No space to book FKIN')
        IRET=2
        RETURN
      ENDIF
      CALL BKFMT('FKIN','2I,(4F,4I)')
      NAFKIN=NAMIND('FKIN')
      KOFKIN=IFKIN
      KCFKIN=LFKINA
      KRFKIN=KRNDMS+KRNDNT
      IW(KOFKIN+1)=LFKINA
      IW(KOFKIN+2)=KRNDMS+KRNDNT
C!..FZFR
      CALL AUBOS('FZFR',0,LMHLEN+LFZFRA*(KRNDMS+KRNDNT),IFZFR,IGARB)
      IF(IGARB.EQ.2)THEN
        CALL QWMESE('### NREFKI ### No space to book FZFR')
        IRET=2
        RETURN
      ENDIF
      CALL BKFMT('FZFR','2I,(F)')
      NAFZFR=NAMIND('FZFR')
      KOFZFR=IFZFR
      KCFZFR=LFZFRA
      KRFZFR=KRNDMS+KRNDNT
      IW(KOFZFR+1)=LFZFRA
      IW(KOFZFR+2)=KRNDMS+KRNDNT
C!..ITMA
      CALL AUBOS('ITMA',0,LMHLEN+LITMAA*KRNDTK,IITMA,IGARB)
      IF(IGARB.EQ.2)THEN
        CALL QWMESE('### NREFKI ### No space to book ITMA')
        IRET=2
        RETURN
      ENDIF
      CALL BKFMT('ITMA','2I,(3I)')
      NAITMA=NAMIND('ITMA')
      KOITMA=IITMA
      KCITMA=LITMAA
      KRITMA=KRNDTK
      IW(KOITMA+1)=LITMAA
      IW(KOITMA+2)=KRNDTK
      CALL VZERO(RW(KOITMA+3),(IW(KOITMA+1)*IW(KOITMA+2)))
C
C!..LOOP OVER ALL PARTICLES (NDNT FIRST) AND PUT ALL QUANTITIES IN AN ARRAY.
C!..THIS AVOIDS PROBLEMS WITH NDMS/NDTK - BANK
C
      CALL VZERO(IARR,2400)
      CALL VZERO(RARR,2400)
      CALL VZERO(INARR,2400)
      CALL VZERO(RNARR,2400)
      CALL VZERO(IVERAR,600)
      CALL VZERO(RVERAR,600)
      CALL VZERO(IMTCH,1200)
      CALL VZERO(ITCH,1200)
      CALL VZERO(ISORT,1200)
C
C!..NDNT BANK
C
      DO 100 I=1,KRNDNT
        IRONDN=KONDNT+LMHLEN+(I-1)*LNDNTA
C!..PARTICLE CODE
        IARR(I,1)=IAND(IW(IRONDN+JNDNHI),MASK10)
C!..ORIGIN VERTEX (NOT YET KNOWN)
        IARR(I,2)=0
C!..END VERTEX (NOT YET KNOWN)
        IARR(I,3)=0
C!..HISTORY CODE
        IARR(I,4)=0
C!..ROW OF MOTHER (IN ARRAY)
        IARR(I,5)=IAND(ISHFT(IW(IRONDN+JNDNHI),-22),MASK9)
C!..MOMENTUM (TO BE RECONSTUCTED FROM DAUGHTERS)
        RARR(I,1)=0
        RARR(I,2)=0
        RARR(I,3)=0
C!..NOMINAL MASS (FROM PART BANK)
        RARR(I,4)=RW(KOPART+LMHLEN+(IARR(I,1)-1)*LPARTA+JPARMA)
C!..FRAGMENTATION VALUE Z (FOR FZFR BANK)
        GX = FLOAT(IAND(ISHFT(IW(IRONDN+JNDNHI),-10),MASK8))
        GX = ((GX+0.0001)/250.0)-0.004
        RARR(I,6)=GX
  100 CONTINUE
C
C!..NDMS BANK
C
      DO 110 I=1,KRNDMS
        IRONDM=KONDMS+LMHLEN+(I-1)*LNDMSA
C!..PARTICLE CODE
        IARR(I+KRNDNT,1)=IAND(IW(IRONDM+JNDMHI),MASK10)
C!..ORIGIN VERTEX (NOT YET KNOWN)
        IARR(I+KRNDNT,2)=0
C!..END VERTEX (NOT YET KNOWN)
        IARR(I+KRNDNT,3)=0
C!..HISTORY CODE
        IARR(I+KRNDNT,4)=0
C!..ROW OF MOTHER (IN ARRAY)
        IARR(I+KRNDNT,5)=IAND(ISHFT(IW(IRONDM+JNDMHI),-22),MASK9)
C!..MOMENTUM
        RARR(I+KRNDNT,1)=FLOAT(IW(IRONDM+JNDMPX)) / 10000000.0
        RARR(I+KRNDNT,2)=FLOAT(IW(IRONDM+JNDMPY)) / 10000000.0
        RARR(I+KRNDNT,3)=FLOAT(IW(IRONDM+JNDMPZ)) / 10000000.0
C!..NOMINAL MASS (FROM PART BANK)
        RARR(I+KRNDNT,4)=RW(KOPART+LMHLEN+(IARR(I+KRNDNT,1)-1)
     &                     *LPARTA+JPARMA)
        RARR(I,6)=0.0
C!..MATCHED TRACK IN NDTK BANK ??
        NMTRK=IAND(ISHFT(IW(IRONDM+JNDMHI),-10),MASK8)
        IF(NMTRK.NE.0.AND.BTEST(IW(IRONDM+JNDMHI),31))THEN
          IMTCH(I+KRNDNT,1)=0
          IMTCH(I+KRNDNT,2)=NMTRK
          IMTCH(I+KRNDNT,3)=I
        ENDIF
  110 CONTINUE
C
C!..EVERYTHING IS IN AN ARRAY NOW. START COPING IN ANOTHER ONE SO THAT ALL
C!..DAUGHTERS OF A MOTHER ARE TOGETHER. START WITH THOSE WHO HAVE NO MOTHER
C
      IPOINT=1
      DO 120 I=1,KRNDNT+KRNDMS
        IF (IARR(I,5).EQ.0) THEN
          DO 130 J=1,6
            INARR(IPOINT,J)=IARR(I,J)
            RNARR(IPOINT,J)=RARR(I,J)
  130     CONTINUE
          IMTCH(I,1)=IPOINT
          RNARR(IPOINT,5)=FLOAT(I)
          IPOINT=IPOINT+1
        ENDIF
  120 CONTINUE
      IVERT=1
      ILAST=IPOINT-1
      I=1
  140 CONTINUE
        NXVERT=.FALSE.
        NDAU  =0
        NFDAU =0
        DO 150 J=1,KRNDNT+KRNDMS
          IF (INT(RNARR(I,5)).EQ.IARR(J,5)) THEN
C!..FIRST COPY
            DO 160 II=1,6
              IF (II.EQ.5) GOTO 160
              INARR(IPOINT,II)=IARR(J,II)
              RNARR(IPOINT,II)=RARR(J,II)
  160       CONTINUE
            RNARR(IPOINT,5)=FLOAT(J)
            INARR(IPOINT,5)=I
            IMTCH(J,1)=IPOINT
C!..SET VERTICES
            INARR(I     ,3)=IVERT
            INARR(IPOINT,2)=IVERT
            IF(NFDAU.EQ.0)NFDAU=IPOINT
            NDAU=NDAU+1
            NXVERT=.TRUE.
            IPOINT=IPOINT+1
          ENDIF
  150   CONTINUE
        IF(NXVERT)THEN
          IVERAR(IVERT,1)=I
          IVERAR(IVERT,2)=NFDAU
          IVERAR(IVERT,3)=NDAU
C!..HERE WE HAVE TO CHECK WHETHER THE MOTHER IS A V0 OR NOT BECAUSE FOR SUCH
C!..VERTEX INFORMATION IS AVALIABLE IN NDLV BANK.
          IF(INARR(I,1).EQ. 1.OR.INARR(I,1).EQ.18.OR.
     &       INARR(I,1).EQ.26.OR.INARR(I,1).EQ.16)THEN
            DO 170 J=1,KRNDLV
              IRONDL=KONDLV+LMHLEN+(J-1)*LNDLVA
              IF(IW(IRONDL+JNDLPO).EQ.INT(RNARR(I,5))) THEN
                RVERAR(IVERT,1)=FLOAT(IW(IRONDL+JNDLDX)) / 10000.
                RVERAR(IVERT,2)=FLOAT(IW(IRONDL+JNDLDY)) / 10000.
                RVERAR(IVERT,3)=FLOAT(IW(IRONDL+JNDLDZ)) / 10000.
              ENDIF
  170       CONTINUE
          ELSE
            RVERAR(IVERT,1)=0.0
            RVERAR(IVERT,2)=0.0
            RVERAR(IVERT,3)=0.0
          ENDIF
          IVERT=IVERT+1
          NXVERT=.FALSE.
        ENDIF
        ILAST =IPOINT-1
        I=I+1
      IF (I.LE.ILAST) GOTO 140
C
C!..NOW LOOP OVER ALL PARTICLES TO RECALCULATE THE MOMENTA OF THE UNSTABLES
C
      DO 200 I=(IVERT-1),1,-1
        CALL VZERO(GP,3)
        DO 210 J=1,KRNDMS+KRNDNT
          IF(INARR(J,2).EQ.I)THEN
            GP(1)=GP(1)+RNARR(J,1)
            GP(2)=GP(2)+RNARR(J,2)
            GP(3)=GP(3)+RNARR(J,3)
          ENDIF
  210   CONTINUE
        DO 220 J=1,KRNDMS+KRNDNT
          IF((INARR(J,3).EQ.I).AND.(RNARR(J,1).EQ.0.0.AND.
     &        RNARR(J,2).EQ.0..AND.RNARR(J,3).EQ.0.0))THEN
            RNARR(J,1)=GP(1)
            RNARR(J,2)=GP(2)
            RNARR(J,3)=GP(3)
            GOTO 200
          ENDIF
  220   CONTINUE
  200 CONTINUE
C
C!..HERE WE KNOW NUMBERS OF VERTICES, WE CAN BOOK FVER
C!..NOW BOOK + START FILLING FVER AND IASL BANK
C
      CALL AUBOS('FVER',0,LMHLEN+LFVERA*(IVERT-1),IFVER,IGARB)
      IF(IGARB.EQ.2)THEN
        CALL QWMESE('### NREFKI ### No space to book FVER')
        IRET=2
        RETURN
      ENDIF
      CALL BKFMT('FVER','2I,(4F,3I,2A)')
      NAFVER=NAMIND('FVER')
      KOFVER=IFVER
      KCFVER=LFVERA
      KRFVER=IVERT-1
      IW(KOFVER+1)=LFVERA
      IW(KOFVER+2)=IVERT-1
C
C!..NOW FILL FKIN + FZFR
C
      DO 300 I=1,KRNDMS+KRNDNT
        IROFKI=KOFKIN+LMHLEN+(I-1)*LFKINA
        IROFZF=KOFZFR+LMHLEN+(I-1)*LFZFRA
        RW(IROFKI+JFKIPX)=RNARR(I,1)
        RW(IROFKI+JFKIPY)=RNARR(I,2)
        RW(IROFKI+JFKIPZ)=RNARR(I,3)
        RW(IROFKI+JFKIMA)=RNARR(I,4)
        IW(IROFKI+JFKIPA)=INARR(I,1)
        IW(IROFKI+JFKIOV)=INARR(I,2)
        IW(IROFKI+JFKIEV)=INARR(I,3)
        IW(IROFKI+JFKIHC)=INARR(I,4)
        IW(IROFZF+JFZFZF)=RNARR(I,6)
  300 CONTINUE
C
C!..AND FVER
C
      DO 310 I=1,IVERT-1
        IROFVE=KOFVER+LMHLEN+(I-1)*LFVERA
        RW(IROFVE+JFVEVX)=RVERAR(I,1)
        RW(IROFVE+JFVEVY)=RVERAR(I,2)
        RW(IROFVE+JFVEVZ)=RVERAR(I,3)
        RW(IROFVE+JFVETO)=0.0
        IW(IROFVE+JFVEIP)=IVERAR(I,1)
        IW(IROFVE+JFVEIS)=IVERAR(I,2)
        IW(IROFVE+JFVENS)=IVERAR(I,3)
        IW(IROFVE+JFVEVN)=INTCHA('    ')
        IW(IROFVE+JFVEVM)=INTCHA('    ')
  310 CONTINUE
      IW(KOFVER+2)=IVERT-1
C
C!..PREPARE MATCHING INFORMATION
C
      INUTRK=0
      DO 400 I=1,KRNDMS+KRNDNT
        IF(IMTCH(I,2).NE.0)THEN
          INUTRK=INUTRK+1
          ITCH(INUTRK,1)=IMTCH(I,1)
          ITCH(INUTRK,2)=IMTCH(I,2)
          ITCH(INUTRK,3)=IMTCH(I,3)
        ENDIF
  400 CONTINUE
      IASLOF=0
      DO 410 I=1,INUTRK
        NMTRK=ITCH(I,2)
        IMTPOI=1
        ISORT(IASLOF+IMTPOI)=I
        DO 420 J=I+1,INUTRK
          IF(ITCH(J,2).EQ.NMTRK)THEN
            IMTPOI=IMTPOI+1
            ISORT(IASLOF+IMTPOI)=J
          ENDIF
  420   CONTINUE
C
C!..FOR A GIVEN RECO TRACH WE HAVE NOW ALL MATCHING MC TRACKS. FILL ITMA.
C
        IW(KOITMA+LMHLEN+(NMTRK-1)*LITMAA+JITMNA)=IMTPOI
        IW(KOITMA+LMHLEN+(NMTRK-1)*LITMAA+JITMOF)=IASLOF
        IW(KOITMA+LMHLEN+(NMTRK-1)*LITMAA+JITMNC)=
     &    IAND(ISHFT(IW(KONDTK+LMHLEN+(NMTRK-1)*KCNDTK+JNDTTQ),
     &    -23),MASK4)+IAND(ISHFT(IW(KONDTK+LMHLEN+(NMTRK-1)*
     &    KCNDTK+JNDTTQ),-27),MASK5)
        IASLOF=IASLOF+IMTPOI
  410 CONTINUE
C
C!..BOOK IASL BANK
C
      CALL AUBOS('IASL',0,LMHLEN+LIASLA*IASLOF,IIASL,IGARB)
      IF(IGARB.EQ.2)THEN
        CALL QWMESE('### NREFKI ### No space to book IASL')
        IRET=2
      ENDIF
      CALL BKFMT('IASL','2I,(2I,F)')
      NAIASL=NAMIND('IASL')
      KOIASL=IIASL
      KCIASL=LIASLA
      KRIASL=IASLOF
      IW(KOIASL+1)=LIASLA
      IW(KOIASL+2)=IASLOF
C
C!..FILL IASL
C
      DO 430 I=1,IASLOF
        IW(KOIASL+LMHLEN+(I-1)*LIASLA+JIASFK)=ITCH(ISORT(I),1)
        IW(KOIASL+LMHLEN+(I-1)*LIASLA+JIASNH)=50
        RW(KOIASL+LMHLEN+(I-1)*LIASLA+JIASCS)=0.0
  430 CONTINUE
      CALL BLIST(IW,'S+','FKIN')
      CALL BLIST(IW,'S+','FVER')
      CALL BLIST(IW,'S+','FZFR')
      CALL BLIST(IW,'S+','ITMA')
      CALL BLIST(IW,'S+','IASL')
      IRET=0
  999 RETURN
      END
#endif
