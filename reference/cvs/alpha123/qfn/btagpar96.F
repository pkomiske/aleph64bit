      SUBROUTINE BTAG_PAR96
CKEY   QIPBTAG / INTERNAL
C-----------------------------------------------------------------------
C! Define cuts and histos for QIPBTAG
C  Called from QIPBTAG
C
C  read the cuts used for the B-tagging and then store them
C  All cards are now optional.
C
C  Author  Dave Brown  29-1-93
C  MODIFIED:
C  ---------
C  03/05/95  Stephan Schael, L_SCUT CHANGED FROM 2.0/3.0 TO 1.3/1.3
C  07/11/95  Stephan Schael, data card to read in NUMJET
C  Modified  Manoj Thulasidas  Dec. 8, 1997
C      Read in the calibration from QIPC - database bank
C
C ----------------------------------------------------------------------
#ifndef DOC
      IMPLICIT NONE
#include "qdecl.h"
#include "qcde.h"
#include "btpar.h"
C
C  Jet resolution common
C
      REAL JRES(3),JMAX,JSCALE
      COMMON/JSIG/JRES,JMAX,JSCALE
C
C  Local variables
C
      INTEGER JTRA2,JCALB,JNUMJ, JBHIS,JVCUT,JBNEG,JBTRK
      INTEGER IBIN, IND, IPAR, ICHAR, IFIT, ITYPE, NJET
      INTEGER MTYPE
      INTEGER NLINK,NAMIND
      CHARACTER*4 CHAINT
      CHARACTER*8 UNAME
      REAL DMIN_BINS(101)
C
C  Duplicate local variables for putting track parameters into common
C
      INTEGER L_MINN(3),L_IDB,L_NUMJET,L_IMASK,L_NVIEW(MAXTYPE)
      REAL L_D0_CUT,L_Z0_CUT,L_MINMOM,L_MAXMOM
      REAL L_MAX_ERR,L_CHI_CUT
      REAL L_DOTCUT
      REAL L_MXDMIN(MAXTYPE),L_MXSDMIN(MAXTYPE)
      REAL L_LCUT(MAXTYPE),L_LSIGCUT(MAXTYPE),L_SCUT(MAXTYPE)
      REAL L_PCUT
C
      INTEGER L_NTYPE
      REAL L_FITP(NFIT,MAXTYPE)
      LOGICAL L_CALIB,L_PARS
      CHARACTER*80 L_CALFILE
C
      LOGICAL L_NEGPROB
C
C  Data statements; these are the default track cuts and calibrations
C
C     CHANGE CUTS AND CAL  FOR NEW ITYPE   ( JC 3 SEPT 1996)
C
C     NUMJET=4  (was 3)
C     MAXMOM=40 (was 25)
C     CHI_CUT=6.0 (was 5.0)
C     NEGPROB=.TRUE. (was .FALSE.) ie NEGPROB by default
C                    introduce NOBG to reverse
C     PCUT=1.0 (was 10.0)
C     ITYPE is changed in TRSEL so order of remaining cuts:
C     LCUT, LSIGCUT, SCUT, MXSDMIN, MXDMIN are changed as are values
C     NVIEW changed to match
      DATA L_PARS/.FALSE./
      DATA L_MINN/1,4,4/,L_NUMJET/4/,L_D0_CUT/0.5/,L_Z0_CUT/0.5/
      DATA L_MINMOM/0.4/,L_MAXMOM/40./,L_CHI_CUT/6.0/,L_MAX_ERR/0.2/
      DATA L_DOTCUT/0.7/
      DATA L_NEGPROB/.TRUE./
      DATA L_PCUT/1./
      DATA L_LCUT   /3*0.100, 0.065,0.075,5*0.065/
      DATA L_LSIGCUT/3*15.0,7*2.5/
      DATA L_SCUT   /3*1.5,1.0,1.3,5*1.0/
      DATA L_MXDMIN /3*0.50,2*0.25,0.0,0.10,3*0.0/
      DATA L_MXSDMIN/10*0.2/
      DATA L_NVIEW/4*2,6*1/
C    PRODUCE FROM CUTS46
      DATA L_FITP/
     &        0.221995,0.015005,0.977522,1.000000,5.000000
     &       ,0.205103,0.044073,1.099258,1.000000,5.000000
     &       ,0.446502,0.003326,0.827882,1.000000,5.000000
     &       ,0.288750,0.061533,0.946210,1.000000,5.000000
     &       ,0.065717,0.000000,1.081506,1.000000,5.000000
     &       ,0.200000,0.020000,1.000000,1.000000,5.000000
     &       ,0.742580,0.000000,4.112133,1.000000,5.000000
     &       ,0.742580,0.000000,4.112133,1.000000,5.000000
     &       ,0.742580,0.000000,4.112133,1.000000,5.000000
     &       ,0.742580,0.000000,4.112133,1.000000,5.000000/
C
      DATA L_NTYPE/9/
C -------------------END OF CHANGES -----------------------------------
C
C  Inlines
C
#include "qmacro.h"
C ----------------------------------------------------------------------
C
C  Make sure we only setup once
C
      IF(L_PARS)GOTO 2000
      WRITE (IW(6),*)'QIPBTAG: initializing parameters'
      L_PARS = .TRUE.
      PARS = .TRUE.
C
C  Load default parameters into common
C
      DO IPAR=1,3
        MINN(IPAR) = L_MINN(IPAR)
      END DO
      DO ITYPE=1,MAXTYPE
        LCUT(ITYPE) = L_LCUT(ITYPE)
        LSIGCUT(ITYPE) = L_LSIGCUT(ITYPE)
        SCUT(ITYPE) = L_SCUT(ITYPE)
        MXSDMIN(ITYPE) = L_MXSDMIN(ITYPE)
        MXDMIN(ITYPE) = L_MXDMIN(ITYPE)
        USRNAME(ITYPE) = 'AAAAbbbb'
        NVIEW(ITYPE) = L_NVIEW(ITYPE)
      END DO
      DOTCUT = L_DOTCUT
      NUMJET = L_NUMJET
      D0_CUT = L_D0_CUT
      Z0_CUT = L_Z0_CUT
      MINMOM = L_MINMOM
      MAXMOM = L_MAXMOM
      CHI_CUT = L_CHI_CUT
      PCUT    = L_PCUT
      MAX_ERR = L_MAX_ERR
      NTYPE = L_NTYPE
      INTYPE = NTYPE
      NEGPROB = L_NEGPROB
      DO IFIT=1,NFIT
        DO ITYPE=1,MAXTYPE
          FITP(IFIT,ITYPE) = L_FITP(IFIT,ITYPE)
        END DO
      END DO
C
C  Get the QIPBTAG calibration
C
      CALL GTIPBK(NFIT,FITP,'QIPC','FITP')
C
C  Check if user-selected tracks are being used
C
      JBTRK = IW(NAMIND('BTRK'))
      DO WHILE(JBTRK.GT.0)
C
C  Get the type and 'particle' name for each track
C
        ITYPE = IW(JBTRK+1)+INTYPE
        IF(ITYPE.LE.INTYPE.OR.ITYPE.GT.MAXTYPE)THEN
          WRITE (IW(6),*)'QIPBTAG: BTRK # out of range',ITYPE
          GOTO 444
        END IF
        UNAME = '        '
        DO ICHAR=1,MIN(2,(IW(JBTRK)-1))
          UNAME(1+(ICHAR-1)*4:ICHAR*4) = CHAINT(IW(JBTRK+1+ICHAR))
        END DO
        USRNAME(ITYPE) = UNAME
        NVIEW(ITYPE) = 2
C
C  If no calibration has been given for this type, assume that they
C  have the same calibration as 1-hit 2-d tracks
C
        IF(ITYPE.GT.NTYPE)THEN
          DO IFIT=1,NFIT
            FITP(IFIT,ITYPE) = L_FITP(IFIT,1)
          END DO
          NTYPE = ITYPE
          WRITE (IW(6),*)' Default calibration for user track, type ',
     &         USRNAME(ITYPE),ITYPE
        ELSE
          WRITE (IW(6),*)' FITP calibration for user track, type ',
     &         USRNAME(ITYPE),ITYPE
        END IF
C
C  Chain to the next bank
C
        JBTRK = IW(JBTRK-1)
      END DO
 444  CONTINUE
C
C  Check for new track cuts
C
      JTRA2 = IW(NAMIND('TRA2'))
      IF(JTRA2 .GT. 0)THEN
        WRITE (IW(6),*)'QIPBTAG: OVERWRITING track selection cuts'
        WRITE (IW(6),1100)
        MTYPE = LROWS(JTRA2)
        DO ITYPE=1,MTYPE
          LCUT(ITYPE)    = RTABL(JTRA2,ITYPE,1)
          LSIGCUT(ITYPE) = RTABL(JTRA2,ITYPE,2)
          SCUT(ITYPE)    = RTABL(JTRA2,ITYPE,3)
          MXDMIN(ITYPE)  = RTABL(JTRA2,ITYPE,4)
          MXSDMIN(ITYPE) = RTABL(JTRA2,ITYPE,5)
          WRITE (IW(6),1101)ITYPE,LCUT(ITYPE),LSIGCUT(ITYPE),
     &         SCUT(ITYPE),MXDMIN(ITYPE),MXSDMIN(ITYPE)
        END DO
      END IF
C
C Check for new jet momentum cut
C
      IND = IW(NAMIND('PJET'))
      IF ( IND .GT. 0 ) THEN
        PCUT = RW(IND+1)
        WRITE (IW(6),*)'QIPBTAG: Jet momentum cut changed from',
     .                           L_PCUT,' to ',PCUT,' GeV/c'
      ENDIF
C
C  check for jet resolution bank
C
      IND = NLINK('JRES',1)
      IF(IND .GT. 0)THEN
C
C  Dummy call to jeterr to clear the 'FIRST' flag (prevent variable over
C
        CALL JETERR(0,JRES,JRES)
        DO IPAR=1,3
          JRES(IPAR) = RW(IND+IPAR)
        END DO
        WRITE (IW(6),*)'QIPBTAG: OVERWRITING jet resolution parameters'
        WRITE (IW(6),777) JRES
 777    FORMAT(' Angle resolution = ',E11.4,' + ',E11.4,'*P + ',E11.4,
     &         '*P^2')
      END IF
C
C  Check for no negative probability track use
C
      JBNEG = IW(NAMIND('NOBG'))
      IF(JBNEG .GT. 0) THEN
         NEGPROB=.FALSE.
         WRITE (IW(6),*)'QIPBTAG: note using - tracks in probability'
      END IF
C
C  Check if different # of jets is requested
C
      JNUMJ = IW(NAMIND('NUMJ'))
      IF(JNUMJ .GT. 0)THEN
        NJET = IW(JNUMJ+1)
        IF (NJET.LE.0 .OR. NJET.GT.10) NJET = 3
        WRITE(IW(6),'(A,I6,A,I6)')
     .              'QIPBTAG: number of jets used changed from ',
     .               NUMJET,' to ',NJET
        NUMJET = NJET
      ENDIF
C
C  Check if diagnostic histograms are requested
C
      JBHIS = IW(NAMIND('BHIS'))
      IF(JBHIS .GT. 0)THEN
        IDB = IW(JBHIS+1)
        WRITE (IW(6),*) 'QIPBTAG : diagnostic histograms on, offset = ',
     &                   IDB
C
C  Track selection histograms
C
        CALL HBOOK1(IDB+100,'TRSEL',20,-.5,19.5,0.0)
        CALL HBOOK1(IDB+101,'QP',100,0.,20.,0.0)
        CALL HBOOK1(IDB+102,'NITC',10,-.5,9.5,0.0)
        CALL HBOOK1(IDB+103,'NTPC',30,-.5,29.5,0.0)
        CALL HBOOK1(IDB+104,'Track flag',11,-.5,10.5,0.0)
        CALL HBOOK1(IDB+106,'D0',100,-.5,.5,0.0)
        CALL HBOOK1(IDB+107,'Z0',100,-1.,1.,0.0)
        CALL HBOOK1(IDB+108,'CHI/DOF',100,0.,10.,0.0)
        CALL HBOOK1(IDB+109,'SIG_D0',100,0.,.2,0.0)
        CALL HBOOK1(IDB+110,'SIG_Z0',100,0.,.2,0.0)
        CALL HBOOK1(IDB+111,'IJET',10,-.5,9.5,0.0)
        CALL HBOOK1(IDB+112,'MAXDOT',100,-1.,1.0,0.0)
C
C V0 selection
C
        CALL HBOOK1(IDB+200,'TRSEL',20,-.5,19.5,0.0)
        CALL HBOOK1(IDB+204,'Track flag',11,-.5,10.5,0.0)
        CALL HBOOK1(IDB+206,'D0',100,-.5,.5,0.0)
        CALL HBOOK1(IDB+207,'Z0',100,-1.,1.,0.0)
        CALL HBOOK1(IDB+209,'SIG_D0',100,0.,.2,0.0)
        CALL HBOOK1(IDB+210,'SIG_Z0',100,0.,.2,0.0)
        CALL HBOOK1(IDB+211,'IJET',10,-.5,9.5,0.0)
        CALL HBOOK1(IDB+212,'MAXDOT',100,-1.,1.0,0.0)
C
C  Final selection
C
        DO ITYPE=1,INTYPE
          ID = IDB+ITYPE*1000
          CALL HBOOK1(ID+150,'FINAL CUT IN TRSEL2',10,-0.5,9.5,0.0)
          CALL HBOOK1(ID+151,'DMIN',100,
     &         -1.5*MXDMIN(ITYPE),1.5*MXDMIN(ITYPE),0.0)
          CALL HBOOK1(ID+152,'S_DMIN',100,
     &         0.0,1.5*MXSDMIN(ITYPE),0.0)
          CALL HBOOK1(ID+153,'LDIST',100,
     &         -1.5*LCUT(ITYPE),1.5*LCUT(ITYPE),0.0)
          CALL HBOOK1(ID+154,'LDIST/S_LDIST',100,
     &         -1.5*LSIGCUT(ITYPE),1.5*LSIGCUT(ITYPE),0.0)
          CALL HBOOK1(ID+155,'JDIST',100,
     &         -1.5*SCUT(ITYPE),1.5*SCUT(ITYPE),0.0)
        END DO
C
C  V0 removal histograms
C
        CALL HBOOK1(IDB+60,'N V0s per event',11,-0.5,10.5,0.0)
        CALL HBOOK1(IDB+61,'N V0s by type',4,-0.5,3.5,0.0)
        CALL HBOOK1(IDB+62,'V0 probability',100,0.,1.,0.0)
C
C  Generic
C
        CALL HBOOK1(IDB+10,'QIPBTAG return code',21,-10.5,10.5,0.0)
        CALL HBOOK1(IDB+20,'Track prob',200,-1.,1.,0.0)
        CALL HBOOK1(IDB+21,'Jet prob',200,0.,1.00001,0.0)
        CALL HBOOK1(IDB+22,'Hemi prob',200,0.,1.00001,0.0)
        CALL HBOOK1(IDB+23,'Event prob',200,0.,1.00001,0.0)
        CALL HBOOK1(IDB+24,'N Jet prob',200,0.,1.00001,0.0)
        CALL HBOOK1(IDB+25,'N Hemi prob',200,0.,1.00001,0.0)
        CALL HBOOK1(IDB+26,'N Event prob',200,0.,1.00001,0.0)
      ELSE
        IDB=0
      END IF
C
C  See if the CALB card is present; if so, book the histograms
C
      JCALB = IW(NAMIND('CALB'))
      IF(JCALB.GT.0 .OR. IDB.GT.0)THEN
        DO ITYPE=1,NTYPE
            CALL HBOOK1(IDB+150+ITYPE,'Neg sig',75,0.,15.,0.0)
        END DO
      END IF
      IF(JCALB.GT.0)THEN
        WRITE (IW(6),*)'QIPBTAG: calibration on, histos booked'
        CALIB = .TRUE.
C
C  Get the calibration file name
C
        DO ICHAR=1,MIN(20,IW(JCALB))
          CALFILE(1+(ICHAR-1)*4:ICHAR*4) = CHAINT(IW(JCALB+ICHAR))
        END DO
        DO ICHAR=IW(JCALB)+1,20
          CALFILE(1+(ICHAR-1)*4:ICHAR*4) = '    '
        END DO
      ELSE
        CALIB = .FALSE.
      END IF
C
 2000 CONTINUE
      RETURN
C ----------------------------------------------------------------------
 1100 FORMAT(10X,'type ','|ldist| ','|ldist|/sig ','|sdist|',
     &     ' |dmin|',' s_dmin')
 1101 FORMAT(10X,I2,1X,5(F8.3,1X))
      END
#endif

