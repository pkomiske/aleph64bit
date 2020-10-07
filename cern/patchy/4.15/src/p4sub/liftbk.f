CDECK  ID>, LIFTBK.
      SUBROUTINE LIFTBK (L,K,N,NAME,IFLAG)

C-    LIKE MQLIFT, BUT  IFLAG  +VE  HIGH BANK
C-                               0  LOW BANK
C-                             -VE  HIGH BANK WITH DATA TAKEN FROM LOW

      PARAMETER      (NQFNAE=2, NQFNAD=1, NQFNAU=3)
      PARAMETER      (IQFSTR=19, NQFSTR=6,  IQFSYS=25, NQFSYS=8)
      COMMON /MQCF/  NQNAME,NQNAMD,NQNAMU, IQSTRU,NQSTRU, IQSYSB,NQSYSB
      COMMON /MQCMOV/NQSYSS
      COMMON /MQCM/         NQSYSR,NQSYSL,NQLINK,LQWORG,LQWORK,LQTOL
     +,              LQSTA,LQEND,LQFIX,NQMAX, NQRESV,NQMEM,LQADR,LQADR2
      COMMON /QCN/   IQLS,IQID,IQNL,IQNS,IQND,IQFOUL
      PARAMETER      (IQBDRO=25, IQBMAR=26, IQBCRI=27, IQBSYS=31)
      COMMON /QBITS/ IQDROP,IQMARK,IQCRIT,IQZIM,IQZIP,IQSYS
                         DIMENSION    IQUEST(30)
                         DIMENSION                 LQ(99), IQ(99), Q(99)
                         EQUIVALENCE (QUEST,IQUEST),    (LQUSER,LQ,IQ,Q)
      COMMON //      QUEST(30),LQUSER(7),LQMAIN,LQSYS(24),LQPRIV(7)
     +,              LQ1,LQ2,LQ3,LQ4,LQ5,LQ6,LQ7,LQSV,LQAN,LQDW,LQUP
C--------------    END CDE                             -----------------  ------
      DIMENSION    NAME(4)


      CALL UCOPY (NAME,IQID,4)
      NP = NQNAMU+IQNL
      NT = NP+ IQND
      IF (LQWORK+NT.GE.LQTOL)  CALL NOMEM
      IF (IFLAG)               12,16,14

   12 CALL UCOPY2 (IQ(LQWORK+NP),IQ(LQSTA-IQND),IQND)
   14 LCREA = LQSTA - NT
      LQSTA = LCREA
      LQEND = LQSTA
      LQTOL = LQSTA - NQMEM
      GO TO 17

   16 LCREA = LQWORK
      LQWORK= LQWORK + NT
   17 CALL QLUMP (LCREA)
      IF (IQNL.NE.0)  CALL VZERO (IQ(IQLS-IQNL),IQNL)
      IF (K.EQ.0)            GO TO 29
      KN = K+N
      IF (IQNS.EQ.0)         GO TO 28
      IQ(IQLS-1) = IQ(KN)
   28 IQ(KN) = IQLS
   29 L = IQLS
      RETURN
      END