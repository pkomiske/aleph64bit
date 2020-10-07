      SUBROUTINE TSWREV(IEVNT)
C--------------------------------------------------------------------
C!  Write out the event header, track elements, and digitizations
C!  for the current event, then drop these banks.
C
C  Called from:  TSWREV
C  Calls:        RDMOUT, BWRITE, BDROP
C
C  Inputs:   PASSED:      --IEVNT, the event number
C            /TPCOND/    --control flags
C
C  Outputs:  WRITE:       --BOS write, unit 25: list 'E' containing
C                           track element bank, hit list banks, and
C                           digitization banks
C  D. DeMille
C  M. Mermikides  18/4/86  Close and reopen file after every event
C                          to save output file in case of VAX crash
C                          (Taken from [ALLEN.FELIX]TASAN.FOR)
C                         --Write out C list and clear it on first
C                           entry
C
C  D. Cowen   12 Feb 88  --Use BWRITE instead of BOSWR so we can
C                          specify EPIO vs. FORT (native) formats.
C                          An earlier BUNIT call sets these formats.
C
C                        --Do OPEN/CLOSE on unit 25 only if we are
C                          not writing with EPIO format.
C
C  P. Janot   29 Mar 88  --Do not write out C list because it has
C                          already been done in subroutine TOEVIN
C
C  P. Janot   05 May 88  --Do not write out digitisations if DIGFIL's
C                          value is 'NONE'
C  D. Cowen   10 May 88  --Remove OPEN/CLOSE since it causes
C                          headaches with tape handling and really
C                          isn't that necessary.
C
C                        --Get routine to write out run number on
C                          first call, and event number from EVEH
C                          (instead of just the internal event
C                          counter).
C  F.Ranjard  28 Mar 89  --adapt to new random number generators.
C--------------------------------------------------------------------
      INTEGER IENDRA(3)
      INTEGER LMHLEN, LMHCOL, LMHROW
      PARAMETER (LMHLEN=2, LMHCOL=1, LMHROW=2)
C
      COMMON /BCS/   IW(1000)
      INTEGER IW
      REAL RW(1000)
      EQUIVALENCE (RW(1),IW(1))
C
C
C  TPCOND  conditions under which this simulation
C  will be performed
C
      COMMON /DEBUGS/ NTPCDD,NCALDD,NTPCDT,NCALDT,NTPCDA,NCALDA,
     &                NTPCDC,NCALDC,NTPCDS,NCALDS,NTPCDE,NCALDE,
     &                NTPCDI,NCALDI,NTPCSA,NCALSA,NTPCDR,NCALDR,
     &                LTDEBU
      LOGICAL LTDEBU
      COMMON /SIMLEV/ ILEVEL
      CHARACTER*4 ILEVEL
      COMMON /GENRUN/ NUMRUN,MXEVNT,NFEVNT,INSEED(3),LEVPRO
      COMMON /RFILES/ TRKFIL,DIGFIL,HISFIL
      CHARACTER*64 TRKFIL,DIGFIL,HISFIL
      COMMON /TLFLAG/ LTWDIG,LTPDIG,LTTDIG,LWREDC,FTPC90,LPRGEO,
     &                LHISST,LTPCSA,LRDN32,REPIO,WEPIO,LDROP,LWRITE
      COMMON /TRANSP/ MXTRAN,CFIELD,BCFGEV,BCFMEV,
     &                        DRFVEL,SIGMA,SIGTR,ITRCON
      COMMON /TPCLOK/ TPANBN,TPDGBN,NLSHAP,NSHPOF
      COMMON /AVLNCH/ NPOLYA,AMPLIT,GRANNO(1000)
      COMMON /COUPCN/ CUTOFF,NCPAD,EFFCP,SIGW,SIGH,HAXCUT
      COMMON /TGCPCN/ TREFCP,SIGR,SIGARC,RAXCUT,TCSCUT
      COMMON /DEFAUL/ PEDDEF,SPEDEF,SGADEF,SDIDEF,WPSCAL,NWSMAX,THRZTW,
     &                LTHRSH,NPRESP,NPOSTS,MINLEN,
     &                LTHRS2,NPRES2,NPOST2,MINLE2
      COMMON /SHAOPT/ WIRNRM,PADNRM,TRGNRM
C
      LOGICAL LTWDIG,LTPDIG,LTTDIG,LPRGEO,
     &        LWREDC,LTPCSA,LHISST,FTPC90,LRND32,
     &        REPIO,WEPIO,LDROP,LWRITE
C
      LOGICAL LTDIGT(3)
      EQUIVALENCE (LTWDIG,LTDIGT(1))
C
      REAL FACNRM(3)
      EQUIVALENCE (WIRNRM,FACNRM(1))
C
      DATA IENTRY/0/
C
      IF (IENTRY .EQ. 0) THEN
         NARUNH = NAMIND('RUNH')
         KRUNH  = IW(NARUNH)
         IRUN   = IW(KRUNH + 2)
         WRITE(6,105) IRUN
  105    FORMAT(//' Run Number from RUNH bank: ',I7,/)
         IENTRY = 1
      ENDIF
C
C
      NAEVEH = NAMIND('EVEH')
      KEVEH  = IW(NAEVEH)
      IEVENT = IW(KEVEH + 6)
C
      CALL RDMOUT(IENDRA)
      WRITE(6,102) IEVENT,IEVNT,IENDRA
C
C  If we have done any digitizations, write out the 'E' list
C
      IF( LTWDIG.OR.LTPDIG.OR.LTTDIG .AND. LWRITE)
     &     CALL BWRITE(IW,25,'E')
C
C  Drop the contents of list 'E'
C
      CALL BDROP(IW,'E')
C
      RETURN
C_______________________________________________________________________
C
102   FORMAT(/' Seed at end of EVEH event ',I6,' (internal count: ',
     &        I6,')',' is : ',3I20/)
C
      END