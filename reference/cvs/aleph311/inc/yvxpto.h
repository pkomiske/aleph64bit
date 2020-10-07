C! YTOP vertex summary
      COMMON/YVXPTO/ NTRV00(MAXVXP),
     +   ITRV00(MKDIMM,MAXVXP),VTXMS0(3,MAXVXP),
     +   CHIVMS(MAXVXP),NVPOSS,VARVMS(6,MAXVXP),
     +   MRKEXC(MKDIMM,MAXEXC)
#if defined(DOC)
C  MAXVXP........MAXIMUM # OF VERTICES ALLOWED (CP. NTRV ETC.)
C  NTRV00(I).......NUMBER OF TRACKS IN VERTEX POSSIBILITY I
C  ITRV00(MKDIMM,I).......HAS BIT K SET IF TRACK K IS IN THIS VERTEX
C  VTXMS0(K,I)....COORDINATES OF VERTEX I
C  CHIVMS(I).....MAX CHI OF ONE TRACK / CHI**2 OF VERTEX ?????
C  NVPOSS........# OF VERTICES FOUND
C  VARVMS(K,I) ... ERROR CORRELATION MATRIX OF VERTEX I
C                  IN SEQUENCE  X ; XY ; Y ; XZ ; YZ ; Z
C  MAXEXC ........ MAXIMUM # OF EXCLUDED VERTEX COMBINATIONS
C  MRKEXC(MKDIMM,I) .. MARKERS FOR EXCLUSION OF TRACK COMBINATION
C
#endif