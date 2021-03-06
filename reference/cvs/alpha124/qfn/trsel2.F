      SUBROUTINE TRSEL2(NTRACK,TPAR,TERR,JJET,JHEMI,FRF2TRK,
     &  TFLAG,DMIN,S_DMIN,PHIP,JDIST,LDIST,S_LDIST,PERP,JETS)
CKEY   QIPBTAG / INTERNAL
C ------------------------------------------------------------------------------
C! Final track selection, based on the final impact parameter.
C  Called from QIPBTAG
C  Dave Brown 5-7-91
C
C  Inputs;
C     NTRACK         Number of tracks (gets revised in this routine)
C     TPAR           FRFT type track parameters
C     TERR           track errors
C     JJET           Association of tracks to jets
C     JHEMI          Association of tracks to hemispheres
C     FRF2TRK        FRFT track numbers
C     TFLAG          Track flag
C     DMIN           3-d impact parameter
C     S_DMIN         Error on 3-d impact parameter
C     PHIP           Direction of 3-d impact parameter in special frame
C     JDIST        Distance along jet axis from IP at closest approach
C     LDIST        Distance of closest approach to jet axis
C     S_LDIST      Error on distance of closest approach to jet axis
C     PERP         Unit vector in direction of closest approach vector
C     JETS         Jet momentum vector
C  Cuts from BTPAR
C     MXDMIN         Maximum impact parameter
C     MXSDMIN        Maximum impact parameter error
C     LCUT           Cut on distance from track to jet axis
C     LSIGCUT        Cut on significance of distance track to jet axis
C     SCUT           Cut on distance along jet axis of closest approach
C
C ------------------------------------------------------------------------------
#ifndef DOC
      IMPLICIT NONE
#include "btpar.h"
      INTEGER NTRACK,JJET(*),JHEMI(*),FRF2TRK(*),TFLAG(*)
      REAL TPAR(5,*),TERR(4,4,*),DMIN(*),S_DMIN(*),PHIP(*)
      REAL JDIST(*),LDIST(*),S_LDIST(*),PERP(3,*),JETS(3,*)
C
C  Local variables
C
      INTEGER JTRACK,ITRACK,IPAR,JPAR,NHIT,ITYPE,JTYPE
C
C  Inline functions
C
      INTEGER ITRK
      LOGICAL GOOD
#include "btaginl.h"
C
C  Final track selection cut
C
      GOOD(ITRK,ITYP) =   ITYP.GT.INTYPE.OR.
     &     (ABS(DMIN(ITRK)).LE.MXDMIN(ITYP) .AND.
     &     S_DMIN(ITRK).LE.MXSDMIN(ITYP) .AND.
     &     ABS(JDIST(ITRK)).LE. SCUT(ITYP).AND.
     &     ABS(LDIST(ITRK)).LE. LCUT(ITYP) .AND.
     &     ABS(LDIST(ITRK))/S_LDIST(ITRK) .LE. LSIGCUT(ITYP))
C ------------------------------------------------------------------------------
C  Diagnostic histograms
C
      IF(IDB.GT.0) THEN
        DO ITRACK=1,NTRACK
          ITYPE = TTYPE(TFLAG(ITRACK))
          IF(ITYPE.LE.INTYPE)THEN
C
            CALL HF1(IDB+1000*ITYPE+151,DMIN(ITRACK),1.0)
            IF(ABS(DMIN(ITRACK)).GT.MXDMIN(ITYPE)) THEN
              CALL HF1(IDB+1000*ITYPE+150,2.0,1.0)
              GO TO 100
            ENDIF
C
            CALL HF1(IDB+1000*ITYPE+152,S_DMIN(ITRACK),1.0)
            IF(S_DMIN(ITRACK).GT.MXSDMIN(ITYPE)) THEN
              CALL HF1(IDB+1000*ITYPE+150,3.0,1.0)
              GO TO 100
            ENDIF
C
            CALL HF1(IDB+1000*ITYPE+153,LDIST(ITRACK),1.0)
            IF(ABS(LDIST(ITRACK)).GE.LCUT(ITYPE)) THEN
              CALL HF1(IDB+1000*ITYPE+150,4.0,1.0)
              GO TO 100
            ENDIF
C
            CALL HF1(IDB+1000*ITYPE+154,
     &           LDIST(ITRACK)/S_LDIST(ITRACK),1.0)
            IF(ABS(LDIST(ITRACK))/S_LDIST(ITRACK) .GE.
     &           LSIGCUT(ITYPE)) THEN
              CALL HF1(IDB+1000*ITYPE+150,5.0,1.0)
              GO TO 100
            ENDIF
C
            CALL HF1(IDB+1000*ITYPE+155,JDIST(ITRACK),1.0)
            IF(ABS(JDIST(ITRACK)).GE.SCUT(ITYPE)) THEN
              CALL HF1(IDB+1000*ITYPE+150,6.0,1.0)
              GO TO 100
            ENDIF
            CALL HF1(IDB+1000*ITYPE+150,9.0,1.0)
 100        CONTINUE
          END IF
        END DO
      ENDIF
C
C  Final track cuts
C
      JTRACK = 0
      DO ITRACK=1,NTRACK
        ITYPE = TTYPE(TFLAG(ITRACK))
        IF(.NOT.GOOD(ITRACK,ITYPE))THEN
          IF(ITYPE.LE.2)THEN
C
C  This is a bad 3-d track; try to recover it as a 2-d track
C
            CALL MAKE2D(FRF2TRK(ITRACK),TPAR(1,ITRACK),
     &           TERR(1,1,ITRACK),TFLAG(ITRACK),
     &           JETS(1,JJET(ITRACK)),PHIP(ITRACK),PERP(1,ITRACK),
     &           JDIST(ITRACK),DMIN(ITRACK),S_DMIN(ITRACK))
C
C  Check if the 2-d track passes
C
            JTYPE = TTYPE(TFLAG(ITRACK))
            IF(.NOT.GOOD(ITRACK,JTYPE))GOTO 1000
          ELSE
            GOTO 1000
          END IF
        END IF
C
C  Restack the arrays for the good tracks
C
        JTRACK = JTRACK+1
        IF(JTRACK.NE.ITRACK)THEN
          JJET(JTRACK)     = JJET(ITRACK)
          JHEMI(JTRACK)    = JHEMI(ITRACK)
          FRF2TRK(JTRACK)  = FRF2TRK(ITRACK)
          TFLAG(JTRACK)    = TFLAG(ITRACK)
          DMIN(JTRACK)     = DMIN(ITRACK)
          S_DMIN(JTRACK)   = S_DMIN(ITRACK)
          PHIP(JTRACK)     = PHIP(ITRACK)
          JDIST(JTRACK)    = JDIST(ITRACK)
          LDIST(JTRACK)    = LDIST(ITRACK)
          S_LDIST(JTRACK)  = S_LDIST(ITRACK)
          DO IPAR=1,5
            TPAR(IPAR,JTRACK) = TPAR(IPAR,ITRACK)
          END DO
          DO IPAR=1,4
            DO JPAR=1,4
              TERR(IPAR,JPAR,JTRACK) = TERR(IPAR,JPAR,ITRACK)
            END DO
          END DO
          DO IPAR=1,3
            PERP(IPAR,JTRACK) = PERP(IPAR,ITRACK)
          END DO
        END IF
 1000   CONTINUE
      END DO
      NTRACK = JTRACK
      RETURN
      END
#endif
