      SUBROUTINE QVGET4 (P,ITK)
CKEY VECTOR COPY /USER
C----------------------------------------------------------------------
C! 4-vector(ITK) --> array P
C                                                    H.Albrecht  2.1.89
C----------------------------------------------------------------------
#ifndef DOC
#include "qcdesh.h"
      DIMENSION P(4)
      J1(J) = KOQVEC + ITK * KCQVEC + J
C----------------------------------------------------------------------
C
      P(1) = RW(J1(JQVEQX))
      P(2) = RW(J1(JQVEQY))
      P(3) = RW(J1(JQVEQZ))
      P(4) = RW(J1(JQVEQE))
C
      END
#endif
