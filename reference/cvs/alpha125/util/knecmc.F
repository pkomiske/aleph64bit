      INTEGER FUNCTION KNECMC(ITK)
C***********************************************************************
C Find MC track alpha with matched PECO part belonging to input EFLW objects
C The matching is circuitous -- using PEMH bank, FKIN number of MC input, and
C PECO parts of EFLW objects
C Author: Paul Bright-Thomas
C Mods:   03/03/97 PBT Created.
C         04/03/97 PBT Note that LCAL clusters are also in PECO/PEMH
C         05/03/97 PBT New level of indirection, via PECO links to PCOB object
C           For KEFOTY(I)>4, only KEFOLC is filled, with PCOB object
C           Then necessary to search all PECO rows for link to this PCOB,
C           and keep this PECO object as a match to input EFLW object.
C           Can then search PEMH for FKIN match.
C           Allow for (remote) possibility of PECO and PCOB link to same EFLW
C         06/03/97 PBT Faster for ITMC, use KFMCT and ITFK
C***********************************************************************
#ifndef DOC
#include "qdecl.h"
#include "qcde.h"
#include "qhac.h"
#include "mcef.h"
      INTEGER ITK
      INTEGER KPEMH,NPEMH,IPEMH,NMCUSE
      INTEGER KPECO,NPECO,IPECO,JPECO
      INTEGER ITFK,ITMFK,ITEF,ITMC,ITPE,ITFKPE
     +       ,ITEFPE,ITEFPC,ITEFPT,ITEFPH,ITEFTY
     +       ,JTPECO(MXMTCH),ITPECO,IPC,ITMC2
      INTEGER IEFMC,DUMMY
#include "qmacro.h"
C***********************************************************************
C-- Reset the return value
      KNECMC = 0
C-- Reset the array of PECO objects.
      DO 10 II = 1,MXMTCH
        JTPECO(II) = 0
 10   END DO
C-- Were we given an EF track number ?
      IF( ITK.LT.KFEFT .OR. ITK.GT.KLEFT ) GOTO 999
C-- Get PECO number for ALPHA EF particle ... quit if no ECAL component.
      ITEFPE = KEFOLE(ITK)
      ITEFPC = KEFOLC(ITK)
      IF( ITEFPE.LE.0 .AND. ITEFPC.LE.0 ) GOTO 999
C-- PBT debug
      IF( FCDEBU ) THEN
        ITEFPT = KEFOLT(ITK)
        ITEFPH = KEFOLH(ITK)
        ITEFTY = KEFOTY(ITK)
        IF( ITEFTY.GE.5 ) THEN
C          WRITE(6,*) ' KNECMC I: Got a residual/LCAL/SICAL'
          DUMMY = 1
        ENDIF
      ENDIF
C-- Store relevant PECO row numbers, coming from ITEFPE or match to ITEFPC
      JPECO = 0
      IF( ITEFPE.GT.0 ) THEN
        JPECO         = JPECO + 1
        JTPECO(JPECO) = ITEFPE
      ENDIF
      IF( ITEFPC.LE.0 ) GOTO 199
C-- Link the PECO bank
      KPECO  = 0
      NAPECO = NAMIND('PECO')
      IF( NAPECO.GT.0 ) KPECO = IW(NAPECO)
      IF( KPECO.GT.0 )  NPECO = LROWS(KPECO)
      IF( KPECO.EQ.0 ) GOTO 199
C-- Search PECO for rows matching PCOB
      DO 100 IPECO = 1,NPECO
        IPC = ITABL(KPECO,IPECO,JPECPC)
        IF( IPC.EQ.ITEFPC .AND. JPECO.LT.MXMTCH ) THEN
          JPECO         = JPECO + 1
          JTPECO(JPECO) = IPECO
        ENDIF
 100  END DO
C-- Are there any PECO objects to match ?
 199  IF( JPECO.LE.0 ) GOTO 299
C-- Link the PEMH bank
      KPEMH  = 0
      NAPEMH = NAMIND('PEMH')
      IF( NAPEMH.GT.0 ) KPEMH = IW(NAPEMH)
      IF( KPEMH.GT.0 )  NPEMH = LROWS(KPEMH)
      IF( KPEMH.EQ.0 ) GOTO 499
C-- Loop over all inpute JTPECO clusters
      DO 220 JJ = 1,MIN(JPECO,MXMTCH)
        ITPECO = JTPECO(JJ)
C-- EFLW ECAL: loop over PEMH to find EFLW obj w matching PECO cluster
 201    DO 200 IPEMH = 1,NPEMH
C-- Get PECO number for this cluster-FKIN match
          ITFKPE = ITABL(KPEMH,IPEMH,JPEMCO)
          IF( ITFKPE.NE.ITPECO ) GOTO 200
C-- Get FKIN number for this cluster-FKIN match
          ITFK   = ITABL(KPEMH,IPEMH,JPEMTN)
          IF( ITFK.LE.0 ) GOTO 200
C-- Search all ALPHA MC objects for same FKIN index
C          DO 230 ITMC = KFMCT,KLMCT
C            ITMFK = KTN(ITMC)
C            ITMC2 = KFMCT-1+ITMFK
C            IF( FCDEBU .AND. ITMC2.NE.ITMC ) WRITE(6,*)
C     +        ' KNECMC W: itmc .NE. kfmct-1+itfk !!!',ITMC,ITMC2
C            IF( ITMFK.EQ.ITFK ) GOTO 235
C 230      END DO
          ITMC = KFMCT-1+ITFK
 235      IF( ITMC.LT.KFMCT .OR. ITMC.GT.KLMCT ) GOTO 200
C-- Check for repetition in mathcing to this input
          NMCUSE = 0
          DO 250 KK = 1,MIN(NEFMC(NEFIN),MXMTCH)
            IF( ITEFMC(NEFIN,KK).EQ.ITMC ) NMCUSE = NMCUSE + 1
 250      END DO
          IF( NMCUSE.GT.0 ) GOTO 200
C-- We have a match ... check array bounds
          IF( NEFMC(NEFIN).GE.MXMTCH ) THEN
            CALL QWMESE(' KNECMC - increase MXMTCH limit.')
            GOTO 999
          ENDIF
C-- Increment count of matched EF objects,
          KNECMC       = KNECMC + 1
          NEFMC(NEFIN) = NEFMC(NEFIN) + 1
C-- Save ALPHA number of matching MC track
          ITEFMC(NEFIN,NEFMC(NEFIN)) = ITMC
C-- Save matching energy
          EFKIN  = FLOAT(ITABL(KPEMH,IPEMH,JPEMSE)) / 1000.
          SEFMC(NEFIN,NEFMC(NEFIN))  = EFKIN
C-- PBT debug
          IF( FCDEBU ) WRITE(6,1001) ITK,NEFIN,NEFMC(NEFIN),KNECMC
     +      ,ITFK,ITFKPE,ITPECO,ITMC,EFKIN,QE(ITMC),QE(ITK),KEFOTY(ITK)
 1001     FORMAT(' KNECMC I: ',8(1X,I3),3(1X,F6.2),1X,I2)
C
 200    END DO     ! End loop over PEMH
C
 220  END DO       ! End loop over PECO matches
C
      IF( FCDEBU .AND. KNECMC.EQ.0 .AND. NMCUSE.EQ.0 ) THEN
        WRITE(6,1003) ITK,QE(ITK),(JTPECO(JJ),JJ=1,JPECO)
 1003   FORMAT(' KNECMC W: No PEMH match made ',I3,1X,F6.3,5(1X,I3))
      ENDIF
C
 299  GOTO 999
C
 499  IF( FCWARN .AND. NEFIN.EQ.1 ) WRITE(6,*)
     +  ' KNECMC W: No PEMH matching information - no ECAL-MC matches.'
C
 999  RETURN
      END
#endif
