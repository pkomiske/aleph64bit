      SUBROUTINE ALBOS (NAME,NR,LE,KNDX,IGARB)
C ----------------------------------------------------
C - F.Ranjard - 870427
C! Book/enlarge a bank with name='NAME', number=NR, length=LE
C - Return bank index=KNDX
C - IGARB is set to 1 if a garbage collection occured
C - If not enough space to book/enlarge the bank call ALTELL
C - Calls    NBANK, BGARB                   from BOS77.hlb
C ---------------------------------------------
       CHARACTER NAME*4
       EXTERNAL NBANK, ALTELL
      INTEGER LMHLEN, LMHCOL, LMHROW
      PARAMETER (LMHLEN=2, LMHCOL=1, LMHROW=2)
C
      COMMON /BCS/   IW(1000)
      INTEGER IW
      REAL RW(1000)
      EQUIVALENCE (RW(1),IW(1))
C
C ----------------------------------------------------------
C
      IGARB = 0
      KNDX = NBANK (NAME,NR,LE)
      IF (KNDX.EQ.0) THEN
C     not enough space
         IGARB = 1
C        allow garbage collection
         CALL BGARB(IW)
C
         KNDX = NBANK (NAME,NR,LE)
         IF (KNDX.EQ.0) THEN
C        not enough space after garbage collection
            IGARB = 2
C           set end of event flag to true and increment error code
            CALL ALTELL ('ALBOS: not enough space ',1,'NEXT')
         ENDIF
      ENDIF
C
      RETURN
      END