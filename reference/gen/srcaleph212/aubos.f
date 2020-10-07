      SUBROUTINE AUBOS (NAME,NR,LE,KNDX,IGARB)
C ----------------------------------------------------
CKEY ALEF BOS BANK / USER
C - F.Ranjard - 851016
C - modified by : F.Ranjard - 900220 - to call USBOS
C! Book/enlarge a bank with name='NAME', number=NR, length=LE
C - Return bank index=KNDX
C - IGARB is set to 1 if a garbage collection occured
C                   2 if not enough space after garbage coll.
C - Calls    NBANK, BGARB                   from BOS77.hlb
C            USBOS                          from ALEPHLIB.hlb
C  ---------------------------------------------
      CHARACTER NAME*4
      EXTERNAL NBANK
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
            CALL USBOS (NAME,NR,LE,KNDX,IGARB)
         ENDIF
      ENDIF
C
      RETURN
      END