      SUBROUTINE QDMMCL( NJETS, CNAM, ICLASS, YCUT, EVIS )
C----------------------------------------------------------------------
CKEY ALPHA JETS /USER
C----------------------------------------------------------------------
C   Author   : C. Bowdery     17-NOV-1993
C   Based upon QJMMCL by P. Perez       28-MAR-1989
C
C
C
C   Description
C   ===========
C!   Call QGJMMC, the improved, generalised JADE algorithm jet finder
C!   with the arguments set to 'E' scheme and DURHAM algorithm.
C
C  Input   : CNAM            the name to be used for the jet 'particles'
C            ICLASS          KRECO or KMONTE
C            YCUT            YCUT value ( (M/EVIS)**2 )
C            EVIS            visible energy for normalisation
C                            (if EVIS=0., it is computed from the
C                             input particle energies)
C
C  Output  : NJETS           number of jets found or error code if -ve
C======================================================================
#ifndef DOC
C
      INTEGER    NJETS, ICLASS
      REAL       YCUT, EVIS
C
      CHARACTER  SCHEME*2, VERSN*6, CNAM*(*)
C
C-----------------------------------------------------------------------
C
C                             Use the E combination scheme and the
C                             DURHAM algorithm ('DURHAM' aka 'BETTER')
C
      SCHEME = 'E'
      VERSN  = 'DURHAM'
C
      CALL QGJMMC( NJETS, CNAM, ICLASS, YCUT, EVIS, SCHEME, VERSN )
C
      END
#endif
