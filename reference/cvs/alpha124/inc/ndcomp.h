C?.------------------- /NDCOMP/ --- COMMON for the compression package -
      INTEGER MAXBNK
      PARAMETER(MAXBNK=1000)
      INTEGER NUMBNK,INDEXW,INFSIZ,MINGAI,IRANKB,TOLOWER
      LOGICAL CHECKS,NOFLO
      REAL    RATMAX
      COMMON/CMPINF/NUMBNK,INDEXW(MAXBNK),INFSIZ(4),MINGAI,RATMAX,
     +              IRANKB(MAXBNK),CHECKS,NOFLO,TOLOWER
