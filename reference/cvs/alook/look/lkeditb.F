      SUBROUTINE LKEDITB(COMAND)
C --------------------------------------------------------
C - author : A.Bonissent
C! Steering routine for LKXEDIT
C Call lkgtnam to abtain requested bank name;
C Look into the DAF banks to find the bank description :
C   call LKALPTAB; CALL LKATTPRMS
C
C Put the attribute names and formats into the local common
C  (one at a time) : call LKDCOMM2
C
C ----------------------------------------------------------
#ifndef DOC
#include "bcs.h"

      CHARACTER*80 ANAME
      CHARACTER*4 NMBK
      CHARACTER*(*) COMAND
C ---------------------------------------------------------
      CALL LKGTNAM(COMAND,NMBK,*997)
      CALL LKALPTAB(NMBK,I1,I2,IOK)
      IF(IOK.NE.1)THEN
         WRITE(IW(6),*)NMBK,' is not an Aleph table'
      ELSE
         ICOL=1
         IPOS=1
   40    CONTINUE
         CALL LKATTPRMS(NMBK,I1,I2,LEN,ANAME,NBID,ITYP,IOK)
         IF(IOK.NE.1)GO TO 50
         DO 41 ILOC=1,NBID
            CALL LKDCOMM2(NMBK,ANAME(1:LEN),ITYP,ICOL+ILOC-1,
     >         ILOC,NBID,irrr)
            if(irrr.ne.0)go to 998
   41    CONTINUE
         IF(I1.NE.0)I1=I1+1
         IF(I2.NE.0)I2=I2+1
         IPOS=IPOS+NBID
         ICOL=ICOL+NBID
         GO TO 40
   50    CONTINUE
      ENDIF
  998 CONTINUE
      CALL LKXEDIT
  999 CONTINUE
      RETURN
  997 CONTINUE
      WRITE(IW(6),*) '[Four character BOS bank name required, and ',
     +            'optional bank number]'
      END
#endif
