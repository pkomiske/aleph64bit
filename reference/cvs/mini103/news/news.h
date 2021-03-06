#if defined(DOC)
   The source code is maintained with CVS

   on AXP/VMS: 
             $ define MINI102 $2$DKB200:[GENERAL_A.MINI.MINI102]
             $ define ALINC  $2$DKB200:[GENERAL_A.ALE.INC]

              source on MINI102:[*]*.F, *.h 

              library   MIN:MINI102.OLB, _D.OLB, .NEWS
   
   on UNIX :  source on $ALROOT/mini102/
              library   /aleph/phy/libmini102.a
                        /aleph/gal/libmini102_dbx.a
              link      /aleph/lib/libmini.a
                        /aleph/lib/libmini_dbx.a
                        /aleph/src/mini

=========================================================================
! 28/06/96 V 102    for 1996 production
  -------------

1) Bank formats are now read from ALFMT : mod in MININI
2) New run header bank for BOMs in 1996 added : BLQP
              mod in MINXTR
3) Protection added in MINFRF against weird MC tracks with P=0.
4) in MINTRA : add VDET truth information for MC datasets
               in bits 10-17 of last DTRA word
5) Remove routines STRIGF and STMASK which are now in JULIA

! 06/09/95 V 101    for 1995 production
  -------------

1) Bug fixes in MINMSC and in several routines (SAVE for UNIX compilers)
2) SICAL ONLY triggers are now thrown away from the MINI :
              mods in MINPRE , JULIA routines STRIGF and STMASK are
              provisionnally put in the MINI LIB
3) Mod in MINEVT for the new PWEI ECAL bank defined in 1995
4) TPC bank TSSR added to the Run Header list on the MINI

! 20/12/94 V 100    for 1994 production
  -------------

1) New routines: MINMSC, MINPSC, MINBIP, MINTHR, MINPTH, MINGAC, MINPGA, MINDLT,
                 MINPDL, MINMLT, MINPML,MINJLT,MINPJL
2) New comdecks: DMSCJJ, DTHRJJ, DBTGJJ, DGACJJ, DDLTJJ, DLJTJJ,DMLTJJ
                 PMSCJJ, PTHRJJ, PGACJJ, PDLTJJ, PLJTJJ,PMLTJJ
3) Bug fixes or protections in MINPRE,MINFKI,MINFVE
4) Add new 1994 trigger bank X1RG in MINBLD
5) Add new QSELEP run header bank PLSC in MINRUN
6) Mod in MINEID : R2 stored now up to 20.48
7) Mod in MINHIS : new histos for new MINI banks
8) Mod in MINFRF : track momentum scaling for 1993 MINIs made with ALEPHLIB 156
9) Mod in MINMUI : add D4CD bank for 1993 MCarlos

! 01/05/93 V 90     for 1993 production
  -------------

1) New routines: MININI, MINPRE, MINBLD, MINBLM, MINEVT, MINFVB, MINGID, MINGPC,
   MINPGI, MINPGP, MINSIC.
2) New comdecks: DEVTJJ, DGIDJJ, DGPCJJ, PGIDJJ, PGPCJJ, DSICJJ, SILUJJ.
3) Remove obsolete decks: MINGAM, MINFOT, MINMUO, MINNEU, MINRES, MINPV0,
   MINPCP. Also RLEPJJ (UFITQL), FGTPJJ (UFITQL), PCHYJJ (MINNEU,MINRES),
   PEHYJJ (MINNEU), PLSDJJ, RLUNIT (MINMUO).
4) Allow version number to be set by data card - modify MINVSN.
5) Input version number from: data card, DVRS bank or RHAH - modify MINGTV.
6) Break MINDST into parts: MININI, MINPRE, MINBLD, MINBLM.
7) Consider Sical events as Lumi events too - in MINPRE.
8) Write Sical information for Lumi events - in MINBLD.
9) Build class 24 - in MINPRE.
10) Save extra banks for class 24 - in MINBLD.
11) Do not save calorimter banks for class 16 or 17 - in MINBLD.
12) Writing of EVEH (and DVRS) is compulsory - in MINBLD.
13) No longer create DNEU and DRES.
14) Simplify MINFMT and rely more on ALFMT.
15) Transmit format information to MINOUT by modified MINCOM - modify MINOUT.
16) Drop POT bank formats by refering to T list - modify MINNOF.
17) Use ALVSN - in MINPRE and modify MINRUN.
18) No longer use YV0V to build DVER - modify MINVER.
19) Remove reference to dE/dx, old EM and calo link in DTRA - modify MINTRA.
20) Move vertex bit pattern in MINTRA to MINFVB.
21) Remove R6 and R7 from DEID - modify MINEID and MINEIT.
22) Anticipate PECO/1 as input - modify MINECO and MINPEC.
23) Only write out ENFLW jets - modify MINJET.
24) Update histograms for DGID and DGPC banks - modify MINHIS.
25) Simplify searches for compressed banks with CUTOL - modify MINMON.
26) No longer call MINUPD in MINFIL - rather call it from filling routines
    where banks have to be updated. Use bank nr 100 for this.
27) Neater use of logicals for filling, especially when considering existance
    of POT/Mini banks - modify MINFIL.
28) Completely reorganise updating procedure so that input banks are not changed
    - modify MINUPD.
29) For old track EM, move components to new location (MINUPD) - modify MINTRA.
30) Use YMFMIN to reconstruct YV0V rather than MINPV0 - modify MINYV0.
31) Decide with MINGTV to update PCQA if really necessary - modify MINPCQ.
32) Decide with MINGTV to supply track quality for old data - modify MINFRI.
33) Identify qqbar events from class word - modify MINHIS.
34) Remove arguments in MINOUT.
35) Add SLUM to run list - modify MINRUN.
36) Print one bank table for MC events - modify MINMON.
37) Store mass rather than energy in DENF - modify MINENF, MINEFO.
38) For lumi events, ignore LUPA in 1993 - modify MINPRE.
39) Add ALPB to run list - modify MINRUN.
40) Remove all apparently 'undefined' variables detected by IBM compiler.

! 30/03/93 v 89
  -------------

1) Even more protection for EXP for eigen-value in MINFRF.
2) Remove warning message in MINYV0.
3) Create DVRS bank - new routine MINVRS; new comdeck DVRSJJ; modify MINFMT.
4) Use NAMIND for YV0V in MINTRA and MINVER.
5) Restore NR of YV0V from DVRS in MINYV0.

! 22/02/93 v 88
  -------------

1) Use MINGTV to determine whether have old or new EM - modify MINFRF.
2) Protect EXP for eigen-value in MINFRF.
3) Ensure that any old DTRA/3 banks read in result in FRFT/0 - modify MINFRF.
4) SAVE CURNOM and CUR92C in MINUPD.
5) Ensure PFRF/0 used if FRFT/3 used in MINTRA.
6) Correct determination of logical PACK in MINTRA.

! 05/01/93 v 87
  -------------

1) If MINGTV returns 0 in MINPUD, STOP.
2) Put NOCH in MINUPD for 7.3 modification.
3) Switch NOCH off in MINFIL and MINUPD if Eflow required.
4) Reinstall possibility to fill R5 in MINEIT.
5) Remove VDAMB (now in ALEPHLIB) and VDHVFX.
6) Update momenta from 1992 real data made with wrong B-field - modify MINUPD.
   Synchronised with ALEPHLIB 144.
7) Correct E3 precision (by factor 100) in MINGAM and MINEGI.
8) For 1990 MC, ensure FRFT/2 really not used (drop it) - modify MINTRA.
9) Improve comment in MINUPD for mod to DTRA for vsn 6.1 and move it into body
   of MINUPD. Also force UFITQL for vsn before 5.3.
10) Also move update to DEWI for vsn 5.0 into main body.
11) Put check in MINUPD for Mini vsn before 6.1.
12) In cases where input contains FRFT/3, ensure write DTRA/0 - modify MINTRA.

! 20/11/92 v 86
  -------------

1) Use MINGTV in MINUPD - which is better protected against bad run records.
2) Avoid calling VDHVFX all together.

! 17/11/92 v 85
  -------------

1) Introduce ALFMT('ALL') in MINFMT to ensure supply FMTs for muon banks.

! 02/11/92 v 84
  -------------

1) Remove check on data type in VDHVFX (which caused it not to work).
2) Avoid calling VDHVFX in MINDST for MC.

! 22/10/92 v 83
  -------------

1) New version of VDHVCK for 1992 data.
2) New version of VDAMB - just two bits.
3) Add MINGTV to obtain version number from data.

! 05/10/92 v 82
  -------------

1) Protect MINDST for boring Sical banks in reduced DST events.
   Ie. veto SPDA and SCLS banks.

! 01/10/92 v 81
  -------------

1) Correct typo in VDHVCK.

! 01/09/92 v 80 (ALPHA version)
  -------------

1) Incorporate ENFLW by using EFOL/3 - modify MINENF, MINJET, MINEFO, MINEJE.
2) Correspondingly ALPHA is used and CREFLW is called to create EFOL/3.
3) ENFLW jets created by ENFJET, called by CREFLW.
4) Add new muon code (for MUID, HMAD, MCAD) in MINMUI and call from MINDST.
5) Correspondingly ALPHA is used and MUNEWR-MUREDO are called to create MUID.
6) Drop muon formats provided dummy CFMT exists - modify MINFMT.
7) Muon histogram changed - modify MINHIS.
8) Fix Vdet HV bit in REVH - call VDHVFX in MINDST.
9) Increase precision for R2 and R3 - modify MINEID, MINEIT, MINUPD.
10) Small changes to checks in PCPJET.
11) Remove obsolete routines: MINREQ, MINCLA, MINEVT, MINMID, MINCAL, MINHEA,
    MINPRT.
12) Consequently modify MINDST - assume format of DHEA is up to date.
13) And modify MINOUT - assume EDIR will be created from REVH externally.
14) Remove obsolete comdecks: DEVTJJ, DMIDJJ, DCALJJ.
15) No longer create DEVT in MINUPD.
16) Correct EJETE0 to EJETPE in EJETJJ and MINJET, MINEJE, PCPJET.
17) Introduce NOPC, NOGA, NOEF, NOEJ - modify MINFIL.
18) Include Vdet ambiguity code - call VDAMB in MINTRA.
19) VDHVFX and VDAMB added temporarily to Mini library.

! 30/04/92 v 71
  -------------
1) Remove VDHITS as it is now in ALEPHLIB.
2) Modify call to AMUIDO and dummy routine in MINMUO for extra argument.

! 19/05/92 v 72
  -------------
1) Create jets from PCPA with PCPJET. Move MINLIS in MINJET to avoid duplication
   of DJET on MLISTE.
2) Extend timing histogram in MINHIS.

! 04/06/92 v 73
  -------------
1) Save Chisq/DoF rather than fit probability - modify MINTRA, MINFRF, MINUPD.
2) Drop empty LUPA banks for MC events (POT).

! 29/07/92 v 74
  -------------
1) Use GTSTUP to decide whether to use FRFT 0 or 2 - important for MC - modify
   MINTRA.

! 01/04/92 v 70
  -------------
1) Save BOMB bank - modify MINDST and MINFMT.
2) Introduce cards NNMC to avoid MC o/p of banks, while allowing ALPHA filling.
3) Store Vdet hit information - modify MINTRA. Include VDHITS temporarily.
4) Ensure large values of R3,R3 are set to 1000 - modify MINEID and MINEIT.
5) Decouple NOEM and NOV0 in MINFRF.

! 31/01/92 v 63
  -------------
1) Correct handling of EPIO errors in MINIMAIN.
2) Add relation bits in PECO - modify MINPEC.
3) Solve unresolved references in MINMUO - add dummy QMUINI and AMUIDO.
4) Correct units for photon momentum vector in EGPC - modify MINEGP.
5) Also correct flag for EGPC - modify MINEGP.
6) Modify N03 and N10 to be consistent with DST - modify MINQMU.

! 22/11/91 v 62
  -------------
1) Zero arrays in MINMON for cancatenation.
2) Save and restore format pointers in MINNOF. Extra call to MINNOF in MINOUT.
   Otherwise, formats not dropped and fill space for concatenated files.
3) Put MAXBNK in MINCOM - also modify MINMON to use this parameter.
4) Further mods to MINIMAIN for concatenation.
5) Include SAVE statements needed for DECStations.
6) Remove unnecessary statements in MINDST and MINPCQ.
7) Insert a missing data statement for FIRST in MINFRF.
8) Rearangement in MINQMU to ensure all bits initialised before MVBITS.
9) For MC, force IMAQQ=1 in MINHIS - ensures histograms. (LUPA always present
   on POT.)
10) Ensure DTRA/2 is created for MC - modify MINTRA.

! 05/11/91 v 61
  -------------
1) Introduce DFOT bank (results from GAMLIB) - create MINFOT, MINEGP. Modify
   MINHIS to incorporate.
2) New form of track error matrix - modify MINTRA, MINFRF, MINUPD. Incorporate
   NOEM option.
3) Make FRFT/2 the default for 1991, 1992 ... - modify MINTRA.
4) Make PTEX a formal part of Mini - modify MINTRA, MINDST.
5) Update MINIMAIN to work on concatenated DST's - also modify MINSUM, MINMON.
6) No longer call PRRHAH in MINOUT, but in MINIMAIN.

! 07/08/91 v 60
  -------------
1) Modify MINTRA to run on FRFT (because of proposed changes to error matrix in
   PFRF).
2) Remove obsolete references to PFRT in MINTRA.
3) Enable use of FRFT/2 in MINTRA. Modify all links to DTRA and FRFT in: MINDST,
   MINEID, MINMUO, MINRES, MINMID, MINHEA, MINUPD, MINFRF, MINFRT, MINPYF,
   MINYV0, MINEIT, MINFRI.
4) If PTEX appears on MINA list, do not write dE/dx in DTRA - modify MINTRA.
5) Add PTEX to lists in MINFMT.
6) Improve histogramming in MINHIS.
7) Ensure that a non-zero B field is used in MINTRA, MINFRF, MINYV0.

! 31/07/91 v 57
  -------------
1) Replace obsolete call in MINEIT to calculate R5 for EIDT.
2) Set return code from MINQMU to 0 for tracks with no DMUO information.

! 26/06/91 v 56
  -------------
1) Perform calculations with wire energies in FP representation to avoid
   overflows - mod MINHEA, MINEWI.
2) New version of MINPCQ - improved merging of particles.

! 16/05/91 v 55
  -------------
1) Ensure update of DNEU and DRES by MINUPD - move in front of DEWI update.
2) Update DTBP - mod MINUPD.
3) Correct handling of shadow information in MINMUO.
4) Use SELEVT in ALEPHLIB - remove dummy in MINCLA.
5) Use UFITQL in ALEPHLIB.
6) Introduce MINPCQ to replace MINPCP in MINFIL; also add PCQAJJ.
7) Move AUBOS in MINUPD to shrink DECO - avoid overwrite from NBANK.

! 25/04/91 v 54
  -------------
1) Protect for PCROS(3)=0 (for vax) in MINYV0.
2) Set output stream for initialisation required by QMUIDO - mod MINMUO.
3) Include banks with non-zero number in MINMON.
4) Remove all BLIST's associated with unpacking POT banks - mod MINDST, MINTRA,
   MINEID, MINMUO, MINFIL.
5) Change all 'E+'s to 'S+'s in BLIST calls in filling.
   Note: S-list is dropped by ABRREC. This may be modified by QWRITE.
6) Restore MINLIS('0') call in MINDST.
7) Don't write IPJT etc if both PASL and PITM exist - mod MINDST.
8) Include PHMH in list of MC banks to be written.
9) Move MINADD and change GOTO if read Mini in MINDST.
10) Call MINTMC etc only if DTMC not present - mod MINDST.
11) Swop order of link assignments for DEID - purely cosmetic.
12) If don't find 'MINI' in RHAH, force update - mod MINUPD.
    RHAH is interogated at beginning of run, so not affected by update of RHAH.
13) Allow DTRA and DEWI to be updated - mod MINUPD.
14) Data type recognised by ALDTYP in MINDST.
15) Check absence of MINA bank in MINADD.
16) Ensure that run/evt numbers are updated on first call to MINLIS.
17) Call MINUPD from MINDST if input is Mini.
18) Remove arguments in MINUPD and obtain logicals inside routine.
19) Do not update in MINUPD if called more than once for an event.
20) Update EIDT hypothesis flag for 1991 convention - mod MINEIT.
21) Use REVH, if filled, for class word in MINCLA.
22) Include more POT banks in drop list for formats - mod MINFMT.
23) Add XTBN to run reccord.
24) Unpack DTBP to XTRB - create MINXTR.
25) Add MCAD to E-list after AMUIDO - mod MINMUO.
26) Add PCOB link to DNEU and replace DECO link by PCOB link in DRES - mod
    MINNEU, MINRES, MINUPD.
27) Raise cut for qqbar identification to 25 GeV - mod MINHIS.
28) Set NDRES immediately after loop to avoid changes in IDRES - mod MINRES.
    Similarly for NDNEU, but purely cosmetic.
29) Swop order of check on IPCOB and IPFRF in MINRES - purely cosmetic.

! 19/03/91 v 53
  -------------
1) Loop over different bank numbers for EFOL, EJET - mod MINENF, MINJET,
   MINEFO, MINEJE.
2) Update MINHEA to be same as in current Julia and update DHEA for old
   POT's by call to MINHEA in MINDST.
3) No longer update DEWI in MINUPD.
4) Remove Time of Flight from DVMC - mod MINVMC, MINFVE.
5) Track quality from UFITQL added to DTRA - mod MINTRA, MINFRI.
6) UFITQL added as temporary measure - eventually will be in ALEPHLIB.
7) Improve initialisation of MINLIS, and move BLIST from MINDST.
8) Only call BLIST in MINOUT if compression has occurred.

! 05/03/91 v 52
  -------------

1) Add word to DTBP - mod MINTBP.
2) Update MINTBP to use XTRB.
3) Replace DEVT by DHEA + DTBP - mod MINDST, MINUPD, MINFMT.
4) Fix bug for MINI->MINI* in MINDST.
5) Rename MINMOF deck MINNOF; remove junk in cols 73-80 in MINNOF and MINCLA.
6) Return to use of DHEA in MINLOL.
7) Improve accuracy of tan(lamda) to avoid problems - mod MINFRF.
8) Extend timing histogram in MINHIS.


! 25/02/91 v 51
  -------------

1) Include RLUNIT in MINMUO to avoid empty file from initialisation.
2) Bug in MINVSN.
3) Remove NS from DECO - mod MINECO, MINUPD.
4) Add XTYP to run list - mod MINRUN.
5) Use trigger words 1 and 3 - mod MINEVT.
6) Introduce MINCLA to provide class word - mod MINOUT, MINEVT.
7) Use correct NDF in MINTRA.
8) Fill chi-squared and NDF in FRFT - mod MINFRF.
9) CMPINI modified, so remove code from library.
10) Update N03 in MINQMU.
11) Lower energy threshold for DGAM.
12) Protect HMAD bank in MINMUO from AMUIDO, else it upsets SELEVT.
13) Protect CHISIN from producing negative chi-squareds in MINYV0.
14) Clean up MINCOM - mod MINSDT, MINMON, MINLIS.
15) Avoid trailing blanks in lists in MINOUT.
16) Move call to ABUNIT into MINOUT.
17) Introduce MINNOF to kill formats for POT banks - called in MINOUT.
    Also mod MINDST, MINFMT and add MLISTF in MINCOM.
18) Remove unwanted reference to DENF, DJET in MINDST.

! 20/02/91 v 50
  -------------

New Mini-DST code for 1991.

Current banks:
Run record = RUNR RUNH RALE RLEP RHAH JSUM LEHI LUMI LBAK LVHI XTOP
             XTYP
Evt record = EVEH REVH LUPA DEVT DVER DTRA DCRL DECO DEWI DHCO DHRL
             DPOB DEID DMUO DRES DNEU DGAM DENF DJET

Current routines:
Writing = MINDST MINFMT MINREQ MINRUN MINLIS MINEVT MINVER MINTRA
          MINGAM MINEID MINMUO MINNEU MINRES MINCRL MINECO MINEWI
          MINHCO MINHRL MINPOB MINENF MINJET MINADD MINTMC MINVMC
          MINFMC MINOUT MINNOF MINHIS MINMON
Reading = MINFIL MINUPD MINLOL MINFRF MINHIT MINFRT MINPYE MINYV0
          MINPV0 MINPYF MINPCP MINPCR MINPEC MINPHC MINEGI MINEIT
          MINFRI MINEFO MINEJE MINFKI MINFVE MINFZF MINQMU

Major changes from 1990:
1) New banks (replaced banks):
   DEVT (DHEA and DTBP), DGAM, DMUO (DMID), DNEU and DRES (DCAL),
   DENF, DJET (DMJT).
2) DVER has a main vertex bit.
3) R6, R7 and pointer to DECO included in DEID.
4) Energy fractions in DECO in per mille; E4 removed.
5) Energy fractions added in DEWI.
6) Bank formats no longer written for ALEPH Mini.
Backwards compatibility provided by MINUPD which is called automatically
by MINFIL.
#endif

