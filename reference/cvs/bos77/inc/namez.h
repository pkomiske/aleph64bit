C     ------NAMEZ
C     STATEMENTS INSERTED IN SUBPROGRAM
C     RETURNS NAMI = NAME-INDEX FOR INTEGER NAMA
C                  = 0 IF NAME NOT YET USED
C
      NWNAM=IW(IDNAM)
      IW(IDNAM)=NAMA
      NAMI=IW(IDNAM-2)+MOD(IABS(IW(IDNAM)),NPRIM)-3
    1 NAMI=IW(IDPTR+NAMI)
      IF(IW(IDNAM+NAMI).NE.IW(IDNAM)) GOTO 1
      IW(IDNAM)=NWNAM
      IF(NAMI.NE.0) NAMI=NAMI+NSYST
C     ------