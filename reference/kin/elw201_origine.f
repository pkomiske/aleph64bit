C-----------------------------------------------------------------------
C  A  L  E  P  H   I  N  S  T  A  L  L  A  T  I  O  N    N  O  T  E  S |
C                                                                      |
C    original code : ELW2TAG  FROM Berends,Kleiss,Daverveldt           |
C    transmitted by : WISCONSIN group as modifications were            |
C    introduced                                                        |
C    more modifications to the code ( description,author,date)         |
C    1.Fix some formats for missing commas, etc..for IBM               |
C                                 B. Bloch February 1991               |
C    2.Introduce label 189 in subroutine MCD to fix fortran error on   |
C       IBM                                                            |
C    3.Rename subroutine CENDEC to CENDTC to avoid clash with CENDEC   |
C       common block                                                   |
C      Rename common /WEIGHT/ to /WEIGHC/ to avoid clash with WEIGHT   |
C       variable                                                       |
C      Rename common /LOG   / to /LOGCM / to avoid clash with LOG func.|
C!   THIS WAS OVERWRITTING THE CODE OF THE LOG FUNCTION!!!!!!!!!       |
C!   AND PREVENTED ANY USE OF IT ( LIKE RANNOR AS AN EXAMPLE)          |
C    4.Reorder variables in common /MYCOMN/ to avoid byte alignment    |
C       problems                                                       |
C      Dimensions of arrays in /MOMENZ/  declared in common not after  |
C    5.Declare FUNCTION TWORND as DOUBLE PRECISION and not REAL*8 to   |
C       avoid IBM misunderstanding                                     |
C    6.Remove in function MYFINS reference to undefined variable SNERR |
C      as advertised by John Higart.                                   |
C    7.Always initialise variable SWEIG ,SNORM and SNERR in FINISH     |
C    8.Replaces RNF100 by RNDM to allow RANMAR usage                   |
C    9.Give the right number of arguments to HISTO1 when called by MCC |
C      with number 16  ident                                           |
C   10.Give the right direction to beam electron and positron          |
C-----------------------------------------------------------------------
C--------------------------------------------------------------------
C-----MONTE CARLO COMPUTER SIMULATION OF THE TWO PHOTON PROCESS:-----
C--------------------------------------------------------------------
C
C
C   DDDD    OOOO    U    U  BBBB    L       EEEEE
C   D   D  O    O   U    U  B   B   L       E
C   D   D  O    O   U    U  B   B   L       E
C   D   D  O    O   U    U  B BB    L       EEEEE    ======
C   D   D  O    O   U    U  B   B   L       E
C   D   D  O    O   U    U  B   B   L       E
C   DDDD    OOOO     UUUU   BBBB    LLLLL   EEEEE
C
C
C   TTTTT   AAAA     GGGG    GGGG    I   N     N    GGGG
C     T    A    A   G    G  G    G       NN    N   G    G
C     T    A    A   G       G        I   N N   N   G
C     T    AAAAAA   G GGG   G GGG    I   N  N  N   G GGG
C     T    A    A   G    G  G    G   I   N   N N   G    G
C     T    A    A   G    G  G    G   I   N    NN   G    G
C     T    A    A    GGGG    GGGG    I   N     N    GGGG
C
C
C SELECTION ROUTINE FOR VARIOUS 'SUB'PROCESSES OF E E ---> E E E E
C IPROC =1: MU+(Q3)  L+(Q5) MU-(Q4)  L-(Q6)
C        2: MU+(Q3) MU+(Q5) MU-(Q4) MU-(Q6)
C        3:  E+(Q3) MU+(Q5)  E-(Q4) MU-(Q6)
C        4:  E+(Q3)  L+(Q5)  E-(Q4)  L-(Q6)
C        5:  E+(Q3)  E+(Q5)  E-(Q4)  E-(Q6)
CJ.H.    6:  TAU+(Q3)TAU+(Q5)TAU-(Q4)TAU-(Q6)
C--------------------------------------------------------------------
C
C BOTH PHOTON AND Z0 EXCHANGE ARE ACCOUNTED FOR
C
C--------------------------------------------------------------------
C-----ALL THE FEYNMAN DIAGRAMS CONTRIBUTING IN LOWEST ORDER----------
C-----(IPROC=1  6 DIAGRAMS, IPROC=2 12 DIAGRAMS, IPROC=3 12DIAGRAMS,-
C----- IPROC=4 12 DIAGRAMS, IPROC=5 36 DIAGRAMS, IPROC=6 12 DIAGRAMS)
C-----ARE TAKEN INTO ACCOUNT-----------------------------------------
C-----THE KINEMATICS IS TREATED EXACTLY------------------------------
C-----THE PROGRAMS GENERATES EVENTS EFFICIENTLY UNDER----------------
C-----NO- OR SMALL ANGLE TAGGING CONDITIONS--------------------------
C
C********************************************************************
C*
C*    AUTHORS : F.A. BERENDS, P.H. DAVERVELDT, R. KLEISS
C*
C*              UNIVERSITY OF LEIDEN
C*              INSTITUUT-LORENTZ VOOR THEORETISCHE NATUURKUNDE
C*              NIEUWSTEEG 18
C*              2311 SB LEIDEN
C*              THE NETHERLANDS
C*
C*    PROBLEMS : CONTACT P.H. DAVERVELDT
C*               TEL. 011 31 71 148333 EXTENSION 2724
C*
C*    INSTALLATION DATE :
C*    LAST UPDATE       : 28 JANUAR 1985
C*    Minor Improvements  20 September 1989 J. Hilgart
C********************************************************************
C
C FOR DETAILED INFORMATION ON THE CALCULATION OF THE MATRIX ELEMENT
C SQUARED AND ON THE PROCEDURE USED FOR THE EVENT GENERATION WE REFER
C TO THE LEIDEN PREPRINT (1984) :
C "COMPLETE LOWEST ORDER CALCULATIONS FOR FOUR-LEPTON PROCESSES IN E+
C E- COLLISIONS"
C
CJ.Hilgart
C SEE ALSO Daverveldt's thesis:
C MONTE CARLO SIMULATION OF TWO-PHOTON PROCESSES (LEIDEN, 1985)
C FOR COMPUTATIONAL DETAILS :
C Program Writeup: MONTE CARLO SIMULATION OF TWO-PHOTON PROCESSES
C COMP. PHYS. COMM. 40(1986) 285-307
CJ.HILGART
C
C THIS PROGRAM RUNS IN DOUBLE PRECISION FORTRAN H-EXT.
C
C   4MOMENTUM INCOMING ELECTRON    P1(4)
C   4MOMENTUM INCOMING POSITRON    P2(4)
C
C   CONVENTION : A(1) = X COMPONENT VECTOR A
C                A(2) = Y COMPONENT VECTOR A
C                A(3) = Z COMPONENT VECTOR A
C                A(4) = TIME (ENERGY) COMPONENT VECTOR A
C   INCOMING ELECTRON BEAM GOES ALONG THE POSITIVE Z-AXIS
C
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C   INPUT PARAMETERS :
C     IDUMP   = 0    NO INFORMATION ON EVENT GENERATION IS PRINTED
C             = 1    INFORMATION ON WEIGHTS IS PRINTED
C             = 2    ALSO INFORMATION ON ANGLES AND ENERGIES IS PRINT
C             = 3    ALSO INFORMATION ON COMMON BLOCKS IS PRINTED
C             = 4    ALSO INFORMATION ON KINEMATICS IS PRINTED
C             = 5    ALSO INFORMATION ON RANDOM NUMBERS IS PRINTED
C   VERY DETAILED INFORMATION ON THE ACTUAL EVENT GENERATION CAN BE
C   OBTAINED BY INCREASING THE PARAMETER IDUMP UP TO 5
C   BECAUSE OF THE ENORMOUS AMOUNT OF OUTPUT ONE THEN OBTAINS,
C   ONE IS ADVIZED ONLY TO DO THIS IN CASE ONE SUSPECTS THAT AN
C   ERROR IN THE EVENT GENERATION OCCURRED.
C
C    INFO
C   VERY DETAILED INFORMATION ON THE CALCULATION OF THE COMPLETE
C   MATRIX ELEMENT (ON THE AMPLITUDE LEVEL) IS OBTAINED BY INCREASING
C   THE PARAMETER INFO. IF INFO EQUALS 1 ONE GETS INFORMATION ON THE
C   INITIALIZATION OCCURRING IN SUBROUTINE SPINOX AND GETRID. IF INFO
C   EQUALS 2 ADDITIONAL INFORMATION ON THE OCCURRING HELICITY AMPLITUDE
C   IS PRINTED. IF ONE INCREASES INFO UP TO 5 MORE AND MORE RESULTS FOR
C   INTERMEDIATE CALCULATIONS IN FUNCTIONS GRAAF AND ZZ ARE PRINTED.
C   IN THIS CASE ONE GETS AN EXTREMELY LARGE AMOUNT OF OUTPUT FOR EACH
C   EVENT.
C
C   ILEARN     = 1 if program should 'learn' good values for
C                ESWE,ESFT,WAP(4),WBP(4). At present only works if
C                IREJEC = 2
C   IWRITE     = 1 if program should write out 4-vectors of un-weighted
C                 events
C   ISEED      random number generator's initialization seed
C    IPROC        = CHOICE OF PROCESS
C               = 1  MU MU L L, the mu mu pair may be a quark-antiquark
C               = 2  MU MU MU MU
C               = 3  E E MU MU
C               = 4  E E MU MU the mu mu pair may be a quark-antiquark
C               = 5  E E E E
C               = 6  TAU TAU TAU TAU
C    EB4           = BEAM ENERGY IN GEV
C**  ESWE4         = ESTIMATED MAXIMUM WEEV WEIGHT, only used if
C                       IREJEC = 2
C**  ESFT4         = ESTIMATED MAXIMUM FT WEIGHT
C    ITOT         = NUMBER OF REQUESTED WEIGHTED EVENTS. IGNORED IF
C                    ILEARN = 1
C    IREQAC       = MAXIMUM NUMBER OF REQUESTED EVENTS WITH WEIGHT 1
C    ZMAS4      =  ZMASS in GEV
C    ZWID4      =  Zwidth in GEV
C    SINW24     = sin**2(theta Weinberg)
C    THMIN4        = MINIMUM SCATTERING ANGLE ELECTRON IN DEGREES
C    THMAX4        = MAXIMUM SCATTERING ANGLE ELECTRON IN DEGREES
C    THMUI4       = MINIMUM SCATTERING ANGLE of 'muon' IN DEGREES
C    THMUA4       = MAXIMUM SCATTERING ANGLE of 'muon' IN DEGREES
C              IF any of WMIN4,WMAX4, or PERR4  < 0., a default is
C                   taken
C    WMIN4        = MINIMUM INVARIANT MASS MUON PAIR IN GEV (or of
C                any opp. ch pair if 4 identical fermions in final state)
C    WMAX4        = MAXIMUM INVARIANT MASS MUON PAIR IN GEV (or of
C                any opp. ch. pair if 4 identical fermions in final state)
C    WMINE4        = MINIMUM INVARIANT MASS NON-MUON PAIR IN GEV (ignored
C                     if 4 identical fermions in final state)
C    WMAXE4        = MAXIMUM INVARIANT MASS NON-MUON PAIR IN GEV (ignored
C                     if 4 identical fermions in final state)
C    PMIN4        = MINIMUM MOMENTUM (IN GEV) OF EACH MUON
C    PMINE4        = MINIMUM MOMENTUM (IN GEV) OF EACH NON-MUON
C    PERR4        = % uncertainty desired on final cross-section
C                     (operational if ILEARN = 1, and default = .1)
C**  WAP4(1)       = RELATIVE IMPORTANCE FACTOR OF SUBGENERATOR MCA
C**  WAP4(2)       = RELATIVE IMPORTANCE FACTOR OF SUBGENERATOR MCB
C**  WAP4(3)       = RELATIVE IMPORTANCE FACTOR OF SUBGENERATOR MCC
C**  WAP4(4)       = RELATIVE IMPORTANCE FACTOR OF SUBGENERATOR MCD
C**  WBP4(1)       = INVERSE WEIGHT FACTOR OF SUBGENERATOR MCA's events
C**  WBP4(2)       = INVERSE WEIGHT FACTOR OF SUBGENERATOR MCB's events
C**  WBP4(3)       = INVERSE WEIGHT FACTOR OF SUBGENERATOR MCC's events
C**  WBP4(4)       = INVERSE WEIGHT FACTOR OF SUBGENERATOR MCD's events
C
C ** NOTE ** IF ILEARN = 1, ESWE4, ESFT4, WAP(1-4), WBP(1-4) ARE GIVEN
C HARD-WIRED VALUES FOR THE 1ST ITERATION, AND THEN OPTIMAL VALUES ARE
C 'LEARNED' BY THE PROGRAM IN SUBSEQUENT ITERATIONS
C################
C A note about the WAP factors...
C    THE PROGRAM RUNS MOST EFFICIENTLY (I.E. FAST) WHEN ONE CHOOSES
C    THESE WAP FACTORS SUCH THAT THE MAXIMUM WEIGHTS WHICH OCCUR IN EACH
C    SUBGENERATOR ARE APPROXIMATELY EQUAL TO EACH OTHER. IT IS IMPORTANT
C    TO KEEP IN MIND THAT THE OPTIMAL CHOICE FOR THE WAP FACTORS DEPENDS
C    ON THE CUTS THAT ARE APPLIED TO THE EVENTS. WHEN ONE WANTS TO BE
C    THAT ALL THE PEAKS IN THE DIFFERENTIAL CROSS SECTION ARE ACCOUNTED
C    ONE SHOULD CHOOSE THE WAP FACTORS SUCH THAT THE PROBABILITIES TO
C    EACH OF THE SUBGENERATORS MCA, MCB, MCC AND MCD ARE APPROXIMATELY
C    EQUAL TO EACH OTHER. THESE PROBABILITIES ARE PROPORTIONAL TO THE
C    APPROXIMATE TOTAL CROSS SECTIONS FOR EACH SUBGENERATOR (ARRAY SA
C    BY ADJUSTING THE WAP FACTORS ONE CAN TUNE THESE APPROXIMATE TOTAL
C    CROSS SECTIONS TO ANY VALUE. OF COURSE THE WEIGHTS OF THE GENERATOR
C    EVENTS ARE INVERSELY PROPORTIONAL TO THE WAP FACTORS. CONSEQUENTLY
C    IF ONE INCREASES WAP(1) SUBGENERATOR MCA WILL GENERATE MORE EVENTS AND
C    THE WEIGHTS OF THESE EVENTS WILL BE SMALLER ACCORDINGLY
C################
C    IREJEC = 2 : A REJECTION ALGORITHM IS USED TWICE.
C              FIRST IT IS USED TO OBTAIN EVENTS DISTRIBUTED
C              ACCORDING TO THE SUM OF THE MATRIX ELEMENTS SQUARED
C              OF ALL THE CONTRIBUTING SUBGROUPS OF FEYNMAN GRAPHS
C              (AT THIS STAGE THE INTERFERENCE BETWEEN DIFFERENT
C              SUBGROUPS IS NOT INCLUDED).
C              LATER IT IS USED TO OBTAIN UNWEIGHTED EVENTS.
C              IT IS ADVICED TO SET IREJEC EQUAL TO 2 WHEN ONE APPLIE
C              NO SEVERE CUTS TO THE EVENTS (E.G. WHEN ONE CALCULATES
C              THE TOTAL CROSS SECTION) BECAUSE THE CALCULATION OF TH
C              TOTAL MATRIX ELEMENT SQUARED TAKES RELATIVELY A LOT OF
C              COMPUTER TIME.
C    IREJEC = 1 : A REJECTION ALGORITHM IS USED ONLY ONCE IN ORDER TO
C              OBTAIN UNWEIGHTED EVENTS.
C              WHEN STRICT CUTS ARE APPLIED IT IS ADVICED TO SET
C              IREJEC EQUAL TO 1 SO THAT ONE GETS REASONABLE
C              STATISTICS.
C+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C Some other variables which are set early on...(but not input)
C    FACE         = VARIABLE PARAMETER WHICH DETERMINES WITH WHICH
C                   ACCURACY THE EXACT MATRIX ELEMENT IS CALCULATED.
C                   IF ONE OF THE ELECTRON PROPAGATORS IS GREATER THAN
C                   FACE*(ELECTRON MASS)**2
C                   THE CORRESPONDING SPIN CONFIGURATIONS WHICH
C                   ARE SUPPRESSED WITH THE ELECTRON MASS ARE OMITTED
C                   THUS THE MATRIX ELEMENT SQUARED IS CALCULATED
C                   EXACTLY WHEN FACE IS MADE VERY LARGE COMPARED TO
C                   THE MASSES (E.G. FACE = 1.D+50).
C                   WHEN ONE CHOOSES FACE EQUAL TO 1000.D0 THE DOMINANT
C                   PART IN THE AMPLITUDE WILL BE CALCULATED CORRECTLY.
C                   FACE IS USED IN SUBROUTINE GETRID.
C    FACM         = SEE REMARKS CONCERNING FACE BUT NOW FOR MASS XMU
C    FACL         = SEE REMARKS CONCERNING FACE BUT NOW FOR MASS XML
C    PROC         = VARIABLE PARAMETER WHICH DETERMINES WITH WHICH
C                   ACCURACY THE EXACT MATRIX ELEMENT IS CALCULATED.
C                   ALL THE SETS OF FEYNMAN DIAGRAMS WHICH CONTRIBUTE
C                   ROUGLY A FACTOR 1/PROMIN OR LESS OF THE BIGGEST
C                   CONTRIBUTION TO THE TOTAL MATRIX ELEMENT ARE
C                   NEGLECTED. SO IN ORDER TO PERFORM AN EXACT
C                   CALCULATION ONE SHOULD MAKE PROMIN VERY BIG.
C                   HOWEVER IF ONE PUTS PROMIN EQUAL TO E.G. 1.D+09
C                   ONE GAINS CONSIDERABLY ON THE SPEED OF THE PROGRAM
C                   WITHOUT AFFECTING THE FINAL RESULT VERY MUCH.
C
C  OUTPUT RESULTS :
C    COMMON /VECTOR/ CONTAINS ALL THE 4MOMENTA OF THE GENERATED EVENT
C    COMMON /WESTAT/ CONTAINS :
C                    SWE  = SUM OF WEIGHTS      FOR EACH SUBGENERATOR
C                    SWEK = SUM OF WEIGHTS**2    "    "     "
C                    MWE  = MAXIMUM WEIGHT       "    "     "
C                    IWE  = # OF GENERATED EVENTS "   "     "
C                    SUM  = SUM OF ALL WEIGHTS
C                    SUM  = SUM OF ALL WEIGHTS**2
C                    MAXWE= MAXIMUM OF ALL WEIGHTS
C                    IGEN = TOTAL # OF GENERATED EVENTS
C    COMMON /WECOUN/ IFAIL= # OF EVENTS WITH WEIGHT < 0 "  " "
C                    INUL = # OF EVENTS WITH WEIGHT = 0 "  " "
C                    IACC = # OF ACCEPTED EVENTS        "  " "
C                    INEG = TOTAL # OF EVENTS WITH WEIGHTS < 0
C                    IZERO= TOTAL # OF EVENTS WITH WEIGHTS = 0
C                    IONE = TOTAL # ACCEPTED EVENTS
C    COMMON /WEIGHC/ CONTAINS :
C                    WEEV = WEIGHT OF GENERATED EVENT (INTERFERENCE
C                           BETWEEN VARIOUS SUBGROUPS OF FEYNMAN
C                           DIAGRAMS IS NOT INCLUDED)
C                    IEVACC = 0 THEN EVENT IS REJECTED IN THE FIRST
C                               OPTIONAL REJECTION ALGORITHM
C                           = 1 THEN EVENT IS ACCEPTED
C    COMMON /SELECT/ IC = 1 MULTIPERIPHERAL EVENT IS GENERATED (MCA)
C                       = 2 BREMSSTRAHLUNG EVENT IS GENERATED (MCB)
C                       = 3 CONVERSION EVENT IS GENERATED (MCC)
C                       = 4 ANNIHILATION EVENT IS GENERATED (MCD)
C    COMMON /LOGCM / IF OUTFL(IC) = TRUE THEN EVENT COULD NOT BE
C                                        GENERATED BECAUSE IT LIES
C                                        OUTSIDE PHYSICAL PHASE SPACE
C                                 = FALSE THEN EVENT IS GENERATED
C   COMMON /FTSTAT/ CONTAINS :
C                   SUMFT = SUM FINAL WEIGHT
C                   SUMFT2= SUM FINAL WEIGHT**2
C                   FTMAX = MAXIMUM FINAL WEIGHT
C                   IEEN  = # OF EVENTS WITH WEIGHT 1
C           THE FINAL WEIGHT FT TAKES INTO ACCOUNT ALL THE INTERFEREN
C           BETWEEN THE VARIOUS SUBGROUPS OF FEYNMAN DIAGRAMS.
C
C   OUTPUT IS PRINTED BY CALLING SUBROUTINE FINISH
C
C*********************************************************************
C*********************************************************************
C
C           FLOW CHART OF MOST IMPORTANT SUBROUTINES AND FUNCTIONS
C
C
C                        ------------
C                        I   MAIN   I
C                        ------------
C       _________________/ /    \_ \_____________________________
C      /           _______/______ \_________       \             \
C     /           /     /    \   \          \       \             \
C ---------   -------------------------   --------  ----------  -------
C I START I   I MCA I MCB I MCC I MCD I   I DIAM I  I FINISH I  I HIS I
C ---------   -------------------------   --------  ----------  -------
C     I         I_____I_\____I___/_I         I                \
C     I            I     \      /            I                 \
C ---------   --------- ---------            I                  -------
C I SETWS I   I DIAG2 I I DIAG4 I            I                  I HIS I
C ---------   --------- ---------            I                  -------
C                                            I
C       ---------------------------------------------------------
C       I           I          I          I          I          I
C  ----------  ----------  ---------  ---------  ----------  ---------
C  I SPINOX I  I GETRID I  I GROUP I  I PERMU I  I CHOICE I  I GRAAF I
C  ----------  ----------  ---------  ---------  ----------  ---------
C                                                                I
C                                                                I
C                                                              ------
C                                                              I ZZ I
C                                                              ------
C
C*********************************************************************
C*********************************************************************
C
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON /REDUCE/ ISEL(6,3),ILZ(6,3,64)
      COMMON /ANGLE / THMUMI,THMUMA
      COMMON /BOUND / W2MIN,W2MAX
      COMMON /CENINI/ THETA0,C0
      COMMON /CHARGE/ QCHARG,QCHRG2,QCHRG3,QCHRG4
      COMMON /CONST / ALFA,BARN,PI,TWOPI
      COMMON /EDGE  / WDMIN,WDMAX,SDMIN,SDMAX
      COMMON /FACTOR/ FACE,FACL,FACM,PROC
      COMMON /FTSTAT/ SUMFT,SUMFT2,FTMAX,IEEN
      COMMON /GENC  / XLC1(4),XLC2(4),SA3(4),EA3(3)
      COMMON /GEND  / XLD1(4),SAPD(4),SA4(2),EA4
      COMMON /INIT  / PB,ET,EP(3),ECH(3)
      COMMON /INPUT / EB,THMIN,THMAX,ESWE,ESFT,WAP(4),WBP(4),VAP(4)
      COMMON /LOGCM / OUTFL(4)
      COMMON /MASSES/ XM,XMU,XML,XM2,XMU2,XML2
      COMMON /MOMENZ/ Q1(5),Q2(5),Q3(5),Q4(5),Q5(5),Q6(5)
      COMMON /PROPAR/ ID
      COMMON /SELECT/ IC,ICH
      COMMON /VECTOR/ P1(4),P2(4),QM(4),QP(4),PM(4),PP(4)
      COMMON /WESTAT/ SWE(4),SWEK(4),MWE(4),SUM,SUMK,MAXWE,IWE(4),IGEN
      COMMON /WECOUN/ IFAIL(4),IACC(4),INUL(4),ICHG(4),
     .                INEG,IONE,IZERO
      COMMON /WEIGHC/ WEIGHT(4),WEEV,IEVACC
      COMMON /MYCOMN/ PERROR,FTADD(4),ITER
      COMMON /CENDEC/ ICD(16),WCD(16),WCDK(16),ECD(16),XSEC(16),
     &   ESEC(16)
      COMMON /TRANS / IY
      COMMON /COUNTB/ IREGB1,IREGB2,IPROB1,IPROB2
CB      DIMENSION Q1(5),Q2(5),Q3(5),Q4(5),Q5(5),Q6(5)
      DIMENSION IDUMP4(4)
      REAL*8 MWE,MAXWE
      REAL*4 ZMAS4,ZWID4,SINW24,EB4,ESWE4,ESFT4,THMIN4,THMAX4,THMUI4,
     &   THMUA4,THET04,WMIN4,WMAX4,WMINE4,WMAXE4,PMIN4,PMAX4,
     &   WAP4(4),WBP4(4),PERR4
      REAL*4 PMOM(5,6),RNF100
      INTEGER ITYP(6)
      LOGICAL OUTFL
      LOGICAL MYFINS
      DATA IDIA /0/
C
C ALEPH particle codes.
C
      DATA IBEAME /362/, IBEAMP /361/, ICELEC /3/, ICPOSI /2/,
     &     ICMUPL /5/, ICMUMI /6/, ICTAUP/33/, ICTAUM /34/
C-------------------------------------------------------------
C
C J.Hilgart
C read in data cards
C First integers
      READ(15,*)
      READ(15,*) IPROC,ITOT,IREQAC,IREJEC,IDUMP,INFO,ILEARN,IWRITE,
     &   ISEED
C then reals
      READ(15,*)
      READ(15,*) ZMAS4,ZWID4,SINW24
      READ(15,*)
      READ(15,*) EB4,ESWE4,ESFT4,THMIN4,THMAX4,THMUI4,THMUA4,THET04
      READ(15,*)
      READ(15,*) WMIN4,WMAX4,WMINE4,WMAXE4,PMIN4,PMINE4,PERR4
      READ(15,*)
      READ(15,*) (WAP4(J),J=1,4),(WBP4(J),J=1,4)
      CLOSE(15)
      PRINT 151,IPROC,ITOT,IREQAC,IREJEC,IDUMP,INFO,ILEARN,IWRITE,ISEED
      PRINT 152,ZMAS4,ZWID4,SINW24
      PRINT 153,EB4,ESWE4,ESFT4,THMIN4,THMAX4,THMUI4,THMUA4,THET04
      PRINT 154,WMIN4,WMAX4,WMINE4,WMAXE4,PMIN4,PMINE4,PERR4
      PRINT 155,(WAP4(J),J=1,4),(WBP4(J),J=1,4)
  151 FORMAT(/' I have read in these parameters:'/' IPROC ',I2/
     &   ' ITOT ',I10/' IREQAC ',I10/' IREJEC ',I2/' IDUMP ',I2/
     &   ' INFO ',I2/' ILEARN ',I2/' IWRITE ',I2/' ISEED ',I11)
  152 FORMAT(/' ZMAS4 ',G12.6/' ZWID4 ',G12.6/' SINW24 ',G12.6)
  153 FORMAT(/' EB4 ',G12.6/' ESWE4,ESFT4 ',2G12.6/
     &   ' THMIN4,THMAX4 ',2G12.6/' THMUI4,THMUA4 ',2G12.6/
     &   ' THET04 ',G12.6)
  154 FORMAT(/' WMIN4,WMAX4 ',2G12.6/' WMINE4,WMAXE4 ',2G12.6/
     &   ' PMIN4,PMINE4 ',2G12.6/' PERR4 ',G12.6)
  155 FORMAT(/' WAP4 ',4(G12.6,1X)/' WBP4 ',4(G12.6,1X)/)
C
      CALL RDMIN(ISEED)
C Get values from data cards and set other default values
      IF (.TRUE.) THEN
C.....MAXIMUM EXECUTION TIME IN MINUTES
         ITIME = 98
C
      PRINT 1000,IPROC
 1000 FORMAT('0PROCESS NUMBER',I5,' HAS BEEN SELECTED'//
     .       ' DOUBLE TAGGING :'/
     .       '  THMIN < THQM < THMAX'/
     .       '  THMIN < THQP < THMAX'//)
C
C.....BEAM ENERGY (IN GEV)....................................
         EB     = DBLE(EB4)
C
C.....MASS OF BEAM PARTICLES (ELECTRON MASS)..................
         XM     = 0.511D-3/EB
C
C.....MASS OF PRODUCED PARTICLES..............................
         XMU    = 0.1057D0/EB
C
C.....MASS OF SCATTERED OR PRODUCED PARICLES..................
         XML    = 1.784D0/EB
C
C.....ESTIMATED MAXIMUM WEIGHT................................
         ESWE   =  DBLE(ESWE4)
         ESFT   =  DBLE(ESFT4)
C
C.....MINIMUM AND MAXIMUM ANGLE SCATTERED POSITRON
C
C.....MINIMUM AND MAXIMUM ANGLE SCATTERED ELECTRON
         THMIN  = DBLE(THMIN4)
         THMAX  = DBLE(THMAX4)
C
C.....CUTS ON MUON ANGLES
         THMUMI =   DBLE(THMUI4)
         THMUMA =   DBLE(THMUA4)
C
C.....CENTRAL DETECTOR DEFINITION (USED IN CENDTC)
         THETA0 =  DBLE(THET04)
C
C.....RELATIVE IMPORTANCE OF SUBGENERATORS A,B,C AND D........
         DO 201 IDL = 1, 4
            WAP(IDL) = DBLE(WAP4(IDL))
            WBP(IDL) = DBLE(WBP4(IDL))
  201    CONTINUE
         IF (PERR4.LT.0.) THEN
            PERROR = 10.D0
         ELSE
            PERROR = DBLE(PERR4)
         ENDIF
C
C
         IF (ILEARN.EQ.1) THEN
C Set some default starting values if ILEARN = 1
            ESFT = 2.D0
            ESWE = 5.D0
            IF (IREJEC.EQ.1) THEN
               PRINT'(
     &'' IREJEC = 1 option w/ ILEARN = 1 not yet implemented.'')'
               STOP
C               ITOT = 100
            ELSE
               ITOT = 1000
            ENDIF
            DO 2112 IDL = 1, 4
               WAP(IDL) = 1.D0
               WBP(IDL) = 1.D0
 2112       CONTINUE
         ENDIF
      ENDIF
      IY = 0
C
C J.Hilgart  Start the generator over at this point if ILEARN = 1
C
      ITER = 0
 2109 CONTINUE
C J.Hilgart
C Set things to zer0
      IGEN = 0
      DO 141 IO = 1, 3
         DO 141 IN = 1, 6
  141       ISEL(IN,IO) = 0
      DO 142 IO = 1, 64
         DO 142 IN = 1, 3
            DO 142 IN1 = 1, 6
  142          ILZ(IN1,IN,IO) = 0
      DO 143 IDL = 1, 4
         FTADD(IDL) = 0.D0
         SWE(IDL) = 0.D0
         SWEK(IDL) = 0.D0
         MWE(IDL) = 0.D0
         IWE(IDL) = 0
         IFAIL(IDL) = 0
         IACC(IDL) = 0
         INUL(IDL) = 0
  143 CONTINUE
      SUM = 0.D0
      SUMK = 0.D0
      MAXWE = 0.D0
      SUMFT = 0.D0
      SUMFT2 = 0.D0
      FTMAX = 0.D0
      IEEN = 0
      INEG = 0
      IONE = 0
      IZERO = 0
      IREGA1 = 0
      IREGA2 = 0
      IREGB1 = 0
      IREGB2 = 0
      IPROB1 = 0
      IPROB2 = 0
      IPROD1 = 0
      IPROD2 = 0
C
      DO 145 IDL = 1, 16
         ICD(IDL) = 0
         WCD(IDL) = 0.D0
         WCDK(IDL) = 0.D0
         ECD(IDL) = 0.D0
         XSEC(IDL) = 0.D0
         ESEC(IDL) = 0.D0
  145 CONTINUE
      FACE   = 1.D+03
      FACL   = 1.D+03
      FACM   = 1.D+03
      PROC   = 1.D+06
      ITER = ITER + 1
      IF (ILEARN.EQ.1)  THEN
         IF (ITER.EQ.1) PRINT 2113
         PRINT 2111,ITER,ITOT,(WAP(J),J=1,4),(WBP(K),K=1,4)
      ENDIF
 2113 FORMAT(/' WE ARE GOING TO FIND SOME OPTIMAL VALUES USING ',
     &   ' SEVERAL ITERATIONS.')
 2111 FORMAT(/' ',6X,'STARTING ITERATION ',I3/
     &   ' ITOT events is',I10/
     &       ' ',6X,'ARRAY WAP : ',4(D18.6,2X)/
     &       ' ',6X,'ARRAY WBP : ',4(D18.6,2X))
      PRINT 2110,ESFT,ESWE
 2110 FORMAT(/' ',6X,'Maximum weights '/
     &   ' ',6X,'ESFT = ',D19.6/
     &   ' ',6X,'ESWE = ',D19.6/)
C
      GOTO (1001,1002,1003,1004,1005,1006), IPROC
 1001 CONTINUE
C E E --> MU MU L L
C THE MU MU PAIR MAY BE A QUARK ANTI QUARK PAIR WITH CHARGE QCHARG
C QM = FOUR MOMENTUM L-   MASS = XML
C QP = FOUR MOMENTUM L+   MASS = XML
C PM = FOUR MOMENTUM MU-  MASS = XMU
C PP = FOUR MOMENTUM MU+  MASS = XMU
C ONLY MCC AND MCD CONTRIBUTE
      WAP(1) = 0.D0
      WAP(2) = 0.D0
      VAP(1) = 0.D0
      VAP(2) = 0.D0
      VAP(3) = 1.D0
      VAP(4) = 1.D0
C...W2MIN W2MAX FREE TO CHOOSE
C...W2MIN = MINIMUM (PM+PP)**2
C LEPTONS      : QCHARG = 1    , ID = 1
C U,C,T QUARKS : QCHARG = -2/3 , ID = 2
C D,S,B QUARKS : QCHARG = 1/3  , ID = 3
C QCHARG = CHARGE CORRESPONDING TO THE LINES WITH 4MOMENTUM PM AND PP
C CONSEQUENTLY IN EE --> L L QUARK ANTI-QUARK CASE THE QUARK 4MOMENTA
C ARE PM AND PP, WHEREAS THE QM AND QP ARE THE L L 4MOMENTA. NOW THE
C XMU IS THE QUARK MASS AND XML IS THE LEPTON MASS.
      ID     = 1
      QCHARG = 1.D0
      ICPAR1 = ICTAUM
      ICPAR2 = ICTAUP
      ICPAR3 = ICMUMI
      ICPAR4 = ICMUPL
C      IF (ITER.EQ.1) PRINT 1011,XM,XMU,XML,QCHARG,W2MIN,W2MAX,
C     &   WAP,WBP,VAP
      IF (ITER.EQ.1) PRINT 1011
 1011 FORMAT('0',130(1H*)//
     .       ' MONTE CARLO SIMULATION OF THE PROCESS : ',
     .       'E+ E- ---> MU+ MU- L+ L-'//' ',130(1H*)//)
      GOTO 1007
 1002 CONTINUE
C E E --> MU MU MU MU
C QM = FOUR MOMENTUM MU-  MASS = XMU
C QP = FOUR MOMENTUM MU+  MASS = XMU
C PM = FOUR MOMENTUM MU-  MASS = XMU
C PP = FOUR MOMENTUM MU+  MASS = XMU
C ONLY MCC AND MCD CONTRIBUTE
      WAP(1) = 0.D0
      WAP(2) = 0.D0
      VAP(1) = 0.D0
      VAP(2) = 0.D0
      VAP(3) = 0.5D0
      VAP(4) = 0.5D0
      XML    = XMU
C QCHARG MAY NOT BE CHANGED
      ID     = 1
      QCHARG = 1.D0
      ICPAR1 = ICMUMI
      ICPAR2 = ICMUPL
      ICPAR3 = ICMUMI
      ICPAR4 = ICMUPL
      IF (ITER.EQ.1) PRINT 1021
 1021 FORMAT('0',130(1H*)//
     .       ' MONTE CARLO SIMULATION OF THE PROCESS : ',
     .       'E+ E- ---> MU+ MU- MU+ MU-'//' ',130(1H*)//)
      GOTO 1007
 1003 CONTINUE
C E E --> E E MU MU
C QM = FOUR MOMENTUM E-   MASS = XM
C QP = FOUR MOMENTUM E+   MASS = XM
C PM = FOUR MOMENTUM MU-  MASS = XMU
C PP = FOUR MOMENTUM MU+  MASS = XMU
C MCA MCB MCC AND MCD CONTRIBUTE
      VAP(1) = 1.D0
      VAP(2) = 1.D0
      VAP(3) = 1.D0
      VAP(4) = 1.D0
      XML    = XM
C...W2MIN W2MAX FREE TO CHOOSE
C W2MIN = MINIMUM (PM+PP)**2
C QCHARG MAY NOT BE CHANGED
      ID     = 1
      QCHARG = 1.D0
      ICPAR1 = ICELEC
      ICPAR2 = ICPOSI
      ICPAR3 = ICMUMI
      ICPAR4 = ICMUPL
      IF (ITER.EQ.1) PRINT 1031
 1031 FORMAT('0',130(1H*)//
     .       ' MONTE CARLO SIMULATION OF THE PROCESS : ',
     .       'E+ E- ---> E+ E- MU+ MU-'//' ',130(1H*)//)
      GOTO 1007
 1004 CONTINUE
C J.Hilgart Changed from eemumu to ee tau tau
C E E --> E E L L
C THE L L PAIR MAY BE A QUARK ANTI QUARK PAIR WITH CHARGE QCHARG
C QM = FOUR MOMENTUM E-  MASS = XM
C QP = FOUR MOMENTUM E+  MASS = XM
C PM = FOUR MOMENTUM L-  MASS = XML
C PP = FOUR MOMENTUM L+  MASS = XML
C MCA MCB MCC AND MCD CONTRIBUTE
      VAP(1) = 1.D0
      VAP(2) = 1.D0
      VAP(3) = 1.D0
      VAP(4) = 1.D0
      IF (ITER.EQ.1) THEN
         XMU    = XML
         XML    = XM
      ENDIF
C...W2MIN W2MAX FREE TO CHOOSE
C W2MIN = MINIMUM (PM+PP)**2
C LEPTONS      : QCHARG = 1
C U,C,T QUARKS : QCHARG = -2/3
C D,S,B QUARKS : QCHARG = 1/3
C QCHARG = CHARGE CORRESPONDING TO THE LINES WITH 4MOMENTUM PM AND PP
      ID     = 1
      QCHARG = 1.D0
      ICPAR1 = ICELEC
      ICPAR2 = ICPOSI
      ICPAR3 = ICTAUM
      ICPAR4 = ICTAUP
      IF (ITER.EQ.1) PRINT 1041
 1041 FORMAT('0',130(1H*)//
     .       ' MONTE CARLO SIMULATION OF THE PROCESS : ',
     .       'E+ E- ---> E+ E- L+ L-'//' ',130(1H*)//)
      GOTO 1007
 1005 VAP(1) = 1.D0
      VAP(2) = 1.D0
      VAP(3) = 0.5D0
      VAP(4) = 0.5D0
      XML    = XM
      XMU    = XM
C QCHARG MAY NOT BE CHANGED
      ID     = 1
      QCHARG = 1.D0
      ICPAR1 = ICELEC
      ICPAR2 = ICPOSI
      ICPAR3 = ICELEC
      ICPAR4 = ICPOSI
C      IF (ITER.EQ.1) PRINT 1051,XM,XMU,XML,QCHARG,W2MIN,W2MAX,
C     &   WAP,WBP,VAP
      IF (ITER.EQ.1) PRINT 1051
 1051 FORMAT('0',130(1H*)//
     .       ' MONTE CARLO SIMULATION OF THE PROCESS : ',
     .       'E+ E- ---> E+ E- E+ E-'//' ',130(1H*)//)
      GOTO 1007
 1006 CONTINUE
C J.H. Modelled after mu mu mu mu
C E E --> TAU TAU TAU TAU
C QM = FOUR MOMENTUM TAU-  MASS = XML
C QP = FOUR MOMENTUM TAU+  MASS = XML
C PM = FOUR MOMENTUM TAU-  MASS = XML
C PP = FOUR MOMENTUM TAU+  MASS = XML
C ONLY MCC AND MCD CONTRIBUTE
      WAP(1) = 0.D0
      WAP(2) = 0.D0
      VAP(1) = 0.D0
      VAP(2) = 0.D0
      VAP(3) = 0.5D0
      VAP(4) = 0.5D0
      XMU    = XML
C QCHARG MAY NOT BE CHANGED
      ID     = 1
      QCHARG = 1.D0
      ICPAR1 = ICTAUM
      ICPAR2 = ICTAUP
      ICPAR3 = ICTAUM
      ICPAR4 = ICTAUP
      IF (ITER.EQ.1) PRINT 1061
 1061 FORMAT('0',130(1H*)//
     .       ' MONTE CARLO SIMULATION OF THE PROCESS : ',
     .       'E+ E- ---> TAU+ TAU- TAU+ TAU-'//' ',130(1H*)//)
      GOTO 1007
 1007 CONTINUE
C
C J.Hilgart
      IF (WMIN4.LE.0.) THEN
         W2MIN  = 4.D0*XMU*XMU
      ELSE
         W2MIN = (DBLE(WMIN4)/EB)**2
      ENDIF
      IF (WMAX4.LE.0.) THEN
         W2MAX  = 4.D0*(1.D0-XML)*(1.D0-XML)
      ELSE
         W2MAX = (DBLE(WMAX4)/EB)**2
      ENDIF
      IF (WMINE4.LE.0.) THEN
         W2MINE = 4.D0*XML*XML
      ELSE
         W2MINE = (DBLE(WMINE4)/EB)**2
      ENDIF
      IF (WMAXE4.LE.0.) THEN
         W2MAXE = 4.D0*(1.D0-XMU)*(1.D0-XMU)
      ELSE
         W2MAXE = (DBLE(WMAXE4)/EB)**2
      ENDIF
C
C Momentum cuts
C
      PMIN = DBLE(PMIN4)/EB
      PMINE = DBLE(PMINE4)/EB
      IF (ITER.EQ.1) PRINT 1012,XM,XMU,XML,QCHARG,W2MIN,W2MAX,
     &   W2MINE,W2MAXE,PMIN,PMINE,WAP,WBP,VAP
 1012 FORMAT(' ',6X,'XM     = ',D19.6/
     .       ' ',6X,'XMU    = ',D19.6/
     .       ' ',6X,'XML    = ',D19.6/
     .       ' ',6X,'QCHARG = ',D19.6/
     .       ' ',6X,'W2MIN  = ',D19.6/
     .       ' ',6X,'W2MAX  = ',D19.6/
     .       ' ',6X,'W2MINE  = ',D19.6/
     .       ' ',6X,'W2MAXE  = ',D19.6/
     .       ' ',6X,'PMIN  = ',D19.6/
     .       ' ',6X,'PMINE  = ',D19.6/
     .       ' ',6X,'ARRAY WAP : ',4(D19.6,2X)/
     .       ' ',6X,'ARRAY WBP : ',4(D19.6,2X)/
     .       ' ',6X,'ARRAY VAP : ',4(D19.6,2X))
 
C end J.Hilgart
      XM2    = XM*XM
      XMU2   = XMU*XMU
      XML2   = XML*XML
      QCHRG2 = QCHARG*QCHARG
      QCHRG3 = QCHARG*QCHRG2
      QCHRG4 = QCHRG2*QCHRG2
C
      CALL START(ZMAS4,ZWID4,SINW24,IPROC,ITOT)
      IF (IREJEC.EQ.2) X = 1.D0
C
C
C SET TIME MAXIMUM IN CPU (IN MINUTES)
C THIS STATEMENT IS MACHINE DEPENDENT
CJ.Hilgart
C      CALL SETCPU(ITIME)
C
C-----START EVENT LOOP----------------------------------------
      DO 10 I = 1, ITOT
C
C CHECK HOW MUCH TIME IS STILL LEFT (IN MILLI SECONDS)
C THIS STATEMENT IS MACHINE DEPENDENT
CJ.Hilgart
C      CALL TIMEO(ITI)
C      IF (ITI.LT.3000) GOTO 14
      CALL TIMEL(TT)
      IF (TT.LT.20.D0)  GOTO 14
      IS     = 1
      ETA0   = RNF100(12)
      IF (ETA0.LT.EP(2)) IS = -1
      IF (ETA0.LT.EP(2+IS)) GOTO 1
      IC     = 3 + IS
      GOTO 2
    1 IC     = 2 + IS
    2 CONTINUE
C
      IDUMP4(IC) = IDUMP
C
      GOTO (3,4,5,6),IC
    3 CALL MCA(IPROC,IDUMP4(1))
      GOTO 7
    4 CALL MCB(IPROC,IDUMP4(2))
      GOTO 7
    5 CONTINUE
      ETA = RNF100(12)
      IF (ETA.LT.EA3(1)) IDEC=1
      IF (ETA.LT.EA3(2).AND.ETA.GT.EA3(1)) IDEC=2
      IF (ETA.LT.EA3(3).AND.ETA.GT.EA3(2)) IDEC=3
      IF (ETA.GT.EA3(3)) IDEC=4
      IF (IDEC.NE.1.AND.IDEC.NE.2.AND.
     .    IDEC.NE.3.AND.IDEC.NE.4) PRINT 666
  666 FORMAT(' $$$$ERROR$$$$ IN MAIN IDEC .NE. 1,2,3,4')
      CALL MCC(IPROC,IDEC,IDUMP4(3))
      GOTO 7
    6 CONTINUE
      ETA = RNF100(12)
      IDEC=1
      IF (ETA.GT.EA4) IDEC=2
      CALL MCD(IPROC,IDEC,IDUMP4(4))
    7 CONTINUE
C
      IF (OUTFL(IC)) GOTO 800
      PMV       = DSQRT(PM(1)*PM(1)+PM(2)*PM(2)+PM(3)*PM(3))
      PPV       = DSQRT(PP(1)*PP(1)+PP(2)*PP(2)+PP(3)*PP(3))
      QMV       = DSQRT(QM(1)*QM(1)+QM(2)*QM(2)+QM(3)*QM(3))
      QPV       = DSQRT(QP(1)*QP(1)+QP(2)*QP(2)+QP(3)*QP(3))
C J.Hilgart
      IF (PMV.LT.PMIN .OR. PPV.LT.PMIN .OR. QMV.LT.PMINE .OR.
     &   QPV.LT.PMINE)  GOTO 800
      CSPM      =  PM(3)/PMV
      CSPP      =  PP(3)/PPV
      CSQM      =  QM(3)/QMV
      CSQP      = -QP(3)/QPV
      THQM      = ACOS(CSQM)/PI*180.D0
      THQP      = ACOS(CSQP)/PI*180.D0
      THPM      = ACOS(CSPM)/PI*180.D0
      THPP      = ACOS(CSPP)/PI*180.D0
      IF (THPM.LT.THMUMI.OR.THPM.GT.THMUMA.OR.
     .    THPP.LT.THMUMI.OR.THPP.GT.THMUMA) GOTO 800
      IF (THQM.LT.THMIN .OR.THQM.GT.THMAX .OR.
     .    THQP.LT.THMIN .OR.THQP.GT.THMAX ) GOTO 800
      W2MU      = 2.D0*DOT(PM,PP)+2.D0*XMU2
      W2EL     = 2.D0*DOT(QM,QP)+ 2.D0*XML2
      W2MU2     = 2.D0*DOT(QM,PP)+ XMU2 + XML2
      W2MU3     = 2.D0*DOT(QP,PM) + XMU2 + XML2
      IF (W2MU.LT.W2MIN.OR.W2MU.GT.W2MAX) GOTO 800
      IF (W2EL.LT.W2MINE.OR.W2EL.GT.W2MAXE)  GOTO 800
C      IF (IPROC.NE.2.AND.IPROC.NE.5) GOTO 801
      IF (IPROC.NE.2.AND.IPROC.NE.5.AND.IPROC.NE.6) GOTO 801
      IF (W2EL.LT.W2MIN.OR.W2EL.GT.W2MAX) GOTO 800
      IF (W2MU2.LT.W2MIN.OR.W2MU2.GT.W2MAX) GOTO 800
      IF (W2MU3.LT.W2MIN.OR.W2MU3.GT.W2MAX) GOTO 800
      GOTO 801
  800 CONTINUE
      WEIGHT(IC) = 0.D0
      WEEV       = 0.D0
      FT         = 0.D0
      INUL(IC)   = INUL(IC) + 1
      IZERO      = IZERO    + 1
  801 CONTINUE
C
      IEVACC    = 0
      IWE(IC)   = IWE(IC)  + 1
      IGEN      = IGEN     + 1
      IF (WEIGHT(IC).LE.0.D0.OR.WEIGHT(IC).GT.1.D-30) GOTO 17
      WEIGHT(IC) = 0.D0
      WEEV       = 0.D0
      FT         = 0.D0
   17 CONTINUE
      SWE(IC)   = SWE(IC)  + WEIGHT(IC)
      SUM       = SUM      + WEEV
      SWEK(IC)  = SWEK(IC) + WEIGHT(IC)*WEIGHT(IC)
      SUMK      = SUMK     + WEEV*WEEV
      IF (MWE(IC).LT.WEIGHT(IC)) MWE(IC) = WEIGHT(IC)
      IF (MAXWE.LT.WEEV) MAXWE = WEEV
C
C-----PRODUCTION OF EVENTS WITH WEIGHT 1-------------------------
      GOTO (25,26) ,IREJEC
   26 CONTINUE
      ETA1   = RNF100(11)
      IF (ETA1*ESWE.GT.WEIGHT(IC)) GOTO 8
      GOTO 27
   25 X      = WEEV
   27 CONTINUE
      IEVACC    = 1
      IACC(IC)  = IACC(IC) + 1
      IONE      = IONE     + 1
    8 CONTINUE
C      CALL HISTO1(1,8HWEIGHT   ,20,0.D0,2.D0,WEEV,1.D0)
      CALL HISTO1(1,8HWEIGHT  ,20,0.D0,ESWE,WEEV,1.D0)
      IF (IEVACC.EQ.0) GOTO 10
      IF (X.EQ.0.D0) GOTO 28
      IDIA  = IDIA + 1
      Q1(5) = -XM
      Q2(5) =  XM
      Q3(5) = -XML
      Q4(5) =  XML
      Q5(5) = -XMU
      Q6(5) =  XMU
      DO 13 IV=1,4
      Q1(IV) = P2(IV)
      Q2(IV) = P1(IV)
      Q3(IV) = QP(IV)
      Q4(IV) = QM(IV)
      Q5(IV) = PP(IV)
      Q6(IV) = PM(IV)
   13 CONTINUE
      INFO  = -1
      IF (IDIA.EQ.1) INFO = 1
C
      FT    = DIAM(IPROC,INFO)
      FT    = X*FT
      FTADD(IC) = FTADD(IC) + FT
   28 CONTINUE
      CALL CENDTC(FT)
C      CALL HISTO1(2,8HFT      ,20,0.D0,2.D0,FT,1.D0)
      CALL HISTO1(2,8HFT      ,20,0.D0,ESFT,FT,1.D0)
      SUMFT = SUMFT  + FT
      SUMFT2= SUMFT2 + FT*FT
      IF (FTMAX.LT.FT) FTMAX = FT
C
C REJECTION ALGORITHM WHICH PRODUCES UNWEIGHTED EVENTS
      ETA2  = RNF100(2)
      IF (ETA2*ESFT.GT.FT) GOTO 20
C
C We have an unweighted event. Write it out if requested.
      IEEN  = IEEN + 1
      IF (IWRITE.NE.1) GOTO 20
C
C The beam particles
C
      IP = 1
      DO 531 IDL = 1, 4
  531    PMOM(IDL,IP) = Q1(IDL)*EB
      PMOM(5,IP) = ABS(Q1(5))*EB
      ITYP(IP) = IBEAME
      IP = 2
      DO 532 IDL = 1, 4
  532    PMOM(IDL,IP) = Q2(IDL)*EB
      PMOM(5,IP) = ABS(Q2(5))*EB
      ITYP(IP) = IBEAMP
C
C Final fermions
C
      IP = 3
      DO 533 IDL = 1, 4
  533    PMOM(IDL,IP) = Q3(IDL)*EB
      PMOM(5,IP) = ABS(Q3(5))*EB
      ITYP(IP) = ICPAR1
      IP = 4
      DO 534 IDL = 1, 4
  534    PMOM(IDL,IP) = Q4(IDL)*EB
      PMOM(5,IP) = ABS(Q4(5))*EB
      ITYP(IP) = ICPAR2
      IP = 5
      DO 535 IDL = 1, 4
  535    PMOM(IDL,IP) = Q5(IDL)*EB
      PMOM(5,IP) = ABS(Q5(5))*EB
      ITYP(IP) = ICPAR3
      IP = 6
      DO 536 IDL = 1, 4
  536    PMOM(IDL,IP) = Q6(IDL)*EB
      PMOM(5,IP) = ABS(Q6(5))*EB
      ITYP(IP) = ICPAR4
C
C Write it out.
C
      WRITE(21,*) IEEN
      DO 537 IDL = 1, 6
  537    WRITE(21,*) (PMOM(J,IDL),J=1,5),ITYP(IDL)
C
      IF (MOD(IEEN,50).EQ.0)  PRINT'(I6,''  events written out.'')',
     &   IEEN
   20 CONTINUE
      IF (IEEN.GE.IREQAC) GOTO 9
   10 CONTINUE
C
C-----RESULTS----------------------------------------------------
      GOTO 11
    9 CONTINUE
      PRINT 12
   12 FORMAT('0',6X,'REQUESTED NUMBER OF EVENTS WITH WEIGHT 1 REACHED')
   11 CONTINUE
      GOTO 15
   14 PRINT 16
   16 FORMAT('0************TIME LIMIT REACHED***************')
   15 CONTINUE
C
C J.Hilgart Go back to almost the top if ILEARN = 1 and we have not finished
      IF (ILEARN.EQ.1) THEN
         IF (.NOT.MYFINS(IPROC,ITOT,IREJEC))  GOTO 2109
      ENDIF
      CALL FINISH(IPROC,ITOT,IREJEC)
      STOP
      END
      SUBROUTINE START(ZMAS4,ZWID4,SINW24,IPROC,ITOT)
C J.Hilgart throw in the arguments concerning the Z mass, width, and
C sinw2
C...THIS SUBROUTINE PERFORMS THE NECESSARY INITIALIZATION.
C...IT SHOULD ALWAYS BE CALLED BEFORE GENERATING THE FIRST EVENT.
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON /ANGLE / THMUMI,THMUMA
      COMMON /BOUND / W2MIN,W2MAX
      COMMON /CENINI/ THETA0,C0
      COMMON /CHARGE/ QCHARG,QCHRG2,QCHRG3,QCHRG4
      COMMON /CONST / ALFA,BARN,PI,TWOPI
      COMMON /CUT   / VMIN,VMAX,CMIN,CMAX,SMIN,SMAX
      COMMON /EDGE  / WDMIN,WDMAX,SDMIN,SDMAX
      COMMON /FACTOR/ FACE,FACL,FACM,PROC
      COMMON /GENA  / XLA1
      COMMON /GENB  / XLB1,XLB2(2),SAPB(2)
      COMMON /GENC  / XLC1(4),XLC2(4),SA3(4),EA3(3)
      COMMON /GEND  / XLD1(4),SAPD(4),SA4(2),EA4
      COMMON /INIT  / PB,ET,EP(3),ECH(3)
      COMMON /INPUT / EB,THMIN,THMAX,ESWE,ESFT,WAP(4),WBP(4),VAP(4)
      COMMON /MASSES/ XM,XMU,XML,XM2,XMU2,XML2
      COMMON /MATRIX/ XME(4)
      COMMON /RNF   / INIRAN,NGEN
      COMMON /SAP   / SAP(4),SAPT
      COMMON /TRANS / IY
      COMMON /VECTOR/ P1(4),P2(4),QM(4),QP(4),PM(4),PP(4)
      COMMON /VECTOB/ P1B(4),P2B(4),QMB(4),QPB(4),PMB(4),PPB(4)
      COMMON /ZPAR  / AMZ,AMZ2,GZ,AMG,AMG2,CV,CA,CVU,CAU,CVD,CAD
      COMMON /MYCOMN/ PERROR,FTADD(4),ITER
      REAL*4 ZMAS4,ZWID4,SINW24,RNF100,DUMM
C-------------------------------------------------------------
      F(W2)  = -4.D0/(0.5D0*W2*(1.D0+CMAX)+2.D0*(1.D0-CMAX))
     .              /(1.D0+CMAX)
     .         +DSQRT(W2)*2.D0/(0.5D0*W2*(1.D0+CMAX)+2.D0*(1.D0-CMAX))
     .                        /(1.D0+CMAX)
     .         -2.D0/((1.D0+CMAX)*SMAX)*DATAN(0.5D0*DSQRT((1.D0+CMAX)
     .                                  *W2/(1.D0-CMAX)))
C
C.....INITIALIZATION OF RANDOM NUMBER GENERATOR RNF1000.......
      IF (ITER.EQ.1) PRINT 200,IY
  200 FORMAT(' ',6X,'START VALUE RNDM = ',I9/)
      NGEN   = 12
      INIRAN =  1
CBB   DUMM   = RNF100(-2)
C
C.....NATURAL CONSTANTS.......................................
      PI     = 4.D0*DATAN(1.D0)
      TWOPI  = 2.D0*PI
      ALFA   = 1.D0/137.036D0
      ALFA4  = ALFA**4
      BARN   = 3.89385D+05/(EB*EB)
      SINW2  = DBLE(SINW24)
C
C Z PARAMETERS
      CALL SETWS(SINW2,AMZ,CV,CA,CVU,CAU,CVD,CAD)
C
C J.Hilgart Ignore the AMZ returned here. Use the hand-chosen value.
      AMZ = DBLE(ZMAS4)
      AMZ    = AMZ/EB
      AMZ2   = AMZ*AMZ
      GZ     = DBLE(ZWID4)/EB
      AMG    = AMZ*GZ
      AMG2   = AMG*AMG
C
C.....CENTRAL DETECTOR
      CFAC   = PI/180.D0
      C0     = DCOS(THETA0*CFAC)
      CMIN   = DCOS(THMAX*CFAC)
      CMAX   = DCOS(THMIN*CFAC)
      SMIN   = DSQRT(1.D0-CMIN*CMIN)
      SMAX   = DSQRT(1.D0-CMAX*CMAX)
      VMIN   = 1.D0-CMAX
      VMAX   = 1.D0-CMIN
C
C.....BEAM FOUR-MOMENTA.......................................
      PB     = DSQRT(1.D0-XM2)
      ET     = 1.D0 + PB
C This is in accordance w/ ALEPH convention (Kleiss got it right):
C... ELECTRON BEAM
      P1(1)  = 0.D0
      P1(2)  = 0.D0
      P1(3)  =  PB
      P1(4)  = 1.D0
C... POSITRON BEAM
      P2(1)  = 0.D0
      P2(2)  = 0.D0
      P2(3)  = -PB
      P2(4)  = 1.D0
C
      DO 1 I = 1,4
      P1B(I) = -P1(I)
      P2B(I) = -P2(I)
    1 CONTINUE
C
C
      SDMIN   = 4.D0*XML2
      SDMAX   = 4.D0*(1.D0-XMU)*(1.D0-XMU)
      WDMIN   = 4.D0*XMU2
      WDMAX   = 4.D0*(1.D0-XML)*(1.D0-XML)
C
      XLA1    = DLOG(2.D0*W2MIN/XMU2)
C
C...APPROXIMATE TOTAL CROSS SECTION
      SAP(1)  = ALFA**4*BARN*16.D0/PI*XLA1
     .         *(F(W2MAX)-F(W2MIN))*0.25D0/SMAX
     .         *(DLOG((1.D0-CMIN)/(1.D0-CMAX)))**2
     .         *WAP(1)*WBP(1)*VAP(1)*QCHRG4
C
      XLB1   = DLOG(4.D0/(XM2*W2MIN))
      XLB2(1)= DLOG((1.D0+0.25D0*WDMAX)*(1.D0-CMAX)
     .             /(WDMIN+WDMIN*(1.D0-CMAX)))
      XLB2(2)= DLOG((1.D0-XM2+0.25D0*W2MIN)*(2.D0-XM)
     .             /(2.D0-2.D0*XM+0.5D0*W2MIN))
      SAPB(1)= ALFA4/PI*BARN*2.D0*DLOG(W2MAX/W2MIN)/(1.D0-CMAX)
     .        *DLOG(VMAX/VMIN)*XLB1*XLB2(1)*WAP(2)*WBP(2)
     .        *VAP(2)*QCHRG2
      SAPB(2)= ALFA4/PI*BARN*2.D0*DLOG(W2MAX/W2MIN)/(1.D0-CMAX)
     .        *DLOG(VMAX/VMIN)*XLB1*XLB2(2)*WAP(2)*WBP(2)
     .        *VAP(2)*QCHRG2
      SAPB(1)= 2.D0*SAPB(1)
      SAPB(2)= 2.D0*SAPB(2)
      SAP(2) = SAPB(1) + SAPB(2)
C
      XLC1(1) = DLOG(4.D0/(WDMIN*XML2))
      XLC2(1) = DLOG(1.D0/(DSQRT(WDMIN)*XML2))
      XLC1(2) = XLC1(1)
      XLC2(2) = DLOG(1.D0/(DSQRT(SDMIN)*XMU2))
      XLC1(3) = XLC1(1)
      XLC2(3) = XLC2(1)
      XLC1(4) = XLC1(1)
      XLC2(4) = DLOG(DSQRT(WDMAX)/(2.D0*XML))
C... TOTAL APPROXIMATE CROSS SECTION FOR MCC
      SA3(1)  = ALFA4*0.0625D0/PI*BARN*DLOG(WDMAX*(4.D0-WDMIN)/
     .          (WDMIN*(4.D0-WDMAX)))*XLC1(1)*XLC2(1)*
     .          WAP(3)*WBP(3)*VAP(3)*QCHRG2
      SA3(2)  = ALFA4*0.25D0/PI*BARN/((4.D0-AMZ2)**2+AMG2)*
     .          (DLOG((4.D0-SDMIN)/(4.D0-SDMAX))+0.5D0*
     .           DLOG(((SDMAX-AMZ2)**2+AMG2)/((SDMIN-AMZ2)**2+AMG2))+
     .           (4.D0-AMZ2)/AMG*(DATAN((SDMAX-AMZ2)/AMG)-
     .                            DATAN((SDMIN-AMZ2)/AMG)))*
     .          XLC1(2)*XLC2(2)*WAP(3)*WBP(3)*VAP(3)*QCHRG2
      SA3(3)  = ALFA4*0.25D0/PI*BARN/((4.D0-AMZ2)**2+AMG2)*
     .          (DLOG((4.D0-WDMIN)/(4.D0-WDMAX))+0.5D0*
     .           DLOG(((WDMAX-AMZ2)**2+AMG2)/((WDMIN-AMZ2)**2+AMG2))+
     .           (4.D0-AMZ2)/AMG*(DATAN((WDMAX-AMZ2)/AMG)-
     .                            DATAN((WDMIN-AMZ2)/AMG)))*
     .          XLC1(3)*XLC2(3)*WAP(3)*WBP(3)*VAP(3)*QCHRG2
      IF (AMZ2.EQ.2.D0) GOTO 3000
      SA3(4)  = ALFA4*0.25D0/PI*BARN/((4.D0-2.D0*AMZ2)**2+4.D0*AMG2)*
     .          (1.D0/AMG*(DATAN((WDMAX-AMZ2)/AMG)-
     .                     DATAN((WDMIN-AMZ2)/AMG)+
     .                     DATAN((WDMAX+AMZ2-4.D0)/AMG)-
     .                     DATAN((WDMIN+AMZ2-4.D0)/AMG))+
     .           1.D0/(4.D0-2.D0*AMZ2)*DLOG(((WDMAX-AMZ2)**2+AMG2)*
     .           ((WDMIN+AMZ2-4.D0)**2+AMG2)/(((WDMIN-AMZ2)**2+AMG2)*
     .           ((WDMAX+AMZ2-4.D0)**2+AMG2))))*XLC1(4)*XLC2(4)*
     .           WAP(3)*WBP(3)*VAP(3)*QCHRG2
      GOTO 3001
 3000 SA3(4)  = ALFA4*0.25D0/PI*BARN/(2.D0*AMG2)*
     .          ((WDMAX-AMZ2)/((WDMAX-AMZ2)**2+AMG2)-
     .           (WDMIN-AMZ2)/((WDMIN-AMZ2)**2+AMG2)+
     .           1.D0/AMG*(DATAN((WDMAX-AMZ2)/AMG)-
     .                     DATAN((WDMIN-AMZ2)/AMG)))*XLC1(4)*XLC2(4)*
     .           WAP(3)*WBP(3)*VAP(3)*QCHRG2
 3001 CONTINUE
      SAP(3)  = SA3(1)+SA3(2)+SA3(3)+SA3(4)
      EA3(1)  = 0.D0
      EA3(2)  = 0.D0
      EA3(3)  = 0.D0
      IF (SAP(3).EQ.0.D0) GOTO 3002
      EA3(1)  = SA3(1)/SAP(3)
      EA3(2)  = SA3(2)/SAP(3)+EA3(1)
      EA3(3)  = SA3(3)/SAP(3)+EA3(2)
 3002 CONTINUE
C
      COD     = 0.25D0+1.D0/((4.D0-AMZ2)**2+AMG2)
      XLD1(1) = DLOG(4.D0/WDMIN)
      XLD1(2) = DLOG(4.D0/SDMIN)
      SAPD(1) = ALFA4/8.D0/PI*BARN*COD*DLOG(WDMAX/WDMIN)*
     .          XLD1(1)**2*WAP(4)*WBP(4)*VAP(4)*QCHRG2
      SAPD(2) = ALFA4/8.D0/PI*BARN*COD*DLOG(SDMAX/SDMIN)*
     .          XLD1(2)**2*WAP(4)*WBP(4)*VAP(4)*QCHRG4
      XLD1(3) = XLD1(1)
      XLD1(4) = XLD1(2)
      SAPD(3) = ALFA4/8.D0/PI*BARN*COD/AMG*
     .          (DATAN((WDMAX-AMZ2)/AMG)-DATAN((WDMIN-AMZ2)/AMG))*
     .          XLD1(3)**2*WAP(4)*WBP(4)*VAP(4)*QCHRG2
      SAPD(4) = ALFA4/8.D0/PI*BARN*COD/AMG*
     .          (DATAN((SDMAX-AMZ2)/AMG)-DATAN((SDMIN-AMZ2)/AMG))*
     .          XLD1(4)**2*WAP(4)*WBP(4)*VAP(4)*QCHRG4
C... TOTAL APPROXIMATE CROSS SECTION FOR MCD
      SA4(1)  = SAPD(1) + SAPD(2)
      SA4(2)  = SAPD(3) + SAPD(4)
      SAP(4)  = SA4(1)+SA4(2)
      EA4     = 0.D0
      IF (SAP(4).EQ.0.D0) GOTO 3003
      EA4     = SA4(1)/SAP(4)
 3003 CONTINUE
C
      SAPT    = SAP(1) + SAP(2) + SAP(3) + SAP(4)
      EP(1)   =         SAP(1)/SAPT
      EP(2)   = EP(1) + SAP(2)/SAPT
      EP(3)   = EP(2) + SAP(3)/SAPT
C
      ECH(1)  = 0.25D0
      ECH(2)  = 0.5D0
      ECH(3)  = 0.75D0
C
      IF (ITER.EQ.1) PRINT 100,IPROC
  100 FORMAT('0',130(1H*)///
     .    7X,'MONTE CARLO SIMULATION OF TWO-PHOTON PROCESS NO:',I2,//
     .    7X,'SUBGENERATOR A GENERATES EVENTS ACCORDING TO THE '
     .      ,'MULTIPERIPHERAL FEYNMAN DIAGRAMS'/
     .    7X,'SUBGENERATOR B GENERATES EVENTS ACCORDING TO THE '
     .      ,'BREMSSTRAHLUNG FEYNMAN DIAGRAMS'/
     .    7X,'SUBGENERATOR C GENERATES EVENTS ACCORDING TO THE '
     .      ,'TWO GAMMA CONVERSION FEYNMAN DIAGRAMS'/
     .    7X,'SUBGENERATOR D GENERATES EVENTS ACCORDING TO THE '
     .      ,'ANNIHILATION FEYNMAN DIAGRAMS'///
     .    7X,'QED AND Z EXCHANGE ARE TAKEN INTO ACCOUNT'///
     .    1X,130(1H*))
      IF (ITER.EQ.1) PRINT 2,XM,XM2,XMU,XMU2,PI,TWOPI,ALFA,BARN
    2 FORMAT('0','........NATURAL CONSTANTS........'/
     .        2(1X,4(D19.6,2X)/))
      IF (ITER.EQ.1) PRINT 3,EB,FACE,FACL,FACM,PROC,ESWE,
     &   ESFT,WAP,ITOT
    3 FORMAT('0',130(1H*)//50X,'INPUT PARAMETERS'//
     .           7X,'BEAM ENERGY                    = ',D19.6,' GEV'/
     .           7X,'SUPPRESION LIMIT FACE          = ',D19.6/
     .           7X,'SUPPRESION LIMIT FACL          = ',D19.6/
     .           7X,'SUPPRESION LIMIT FACM          = ',D19.6/
     .           7X,'SUPPRESION LIMIT PROC          = ',D19.6/
     .           7X,'ESTIMATED MAXIMUM WEIGHT ESWE  = ',D19.6/
     .           7X,'ESTIMATED MAXIMUM WEIGHT ESFT  = ',D19.6/
     .           7X,'REL. IMPORTANCE SUBGENERATOR A = ',D19.6/
     .           7X,'REL. IMPORTANCE SUBGENERATOR B = ',D19.6/
     .           7X,'REL. IMPORTANCE SUBGENERATOR C = ',D19.6/
     .           7X,'REL. IMPORTANCE SUBGENERATOR D = ',D19.6/
     .           7X,'# EVENTS REQUESTED       = ',I9//
     .           1X,130(1H*))
      IF (ITER.EQ.1) PRINT 4,WDMIN,WDMAX,SDMIN,SDMAX
    4 FORMAT('0',6X,'WDMIN                    = ',D19.6/
     .           7X,'WDMAX                    = ',D19.6/
     .           7X,'SDMIN                    = ',D19.6/
     .           7X,'SDMAX                    = ',D19.6)
      IF (ITER.EQ.1) PRINT 12,W2MIN,W2MAX,THMIN,THMAX,THMUMI,THMUMA
   12 FORMAT('0',6X,'CUTS DEFINED BY THE USER : '/
     .           7X,'W2MIN                    = ',D19.6/
     .           7X,'W2MAX                    = ',D19.6/
     .           7X,'THMIN                    = ',D19.6,' DEGREES'/
     .           7X,'THMAX                    = ',D19.6,' DEGREES'/
     .           7X,'THMUMI                   = ',D19.6,' DEGREES'/
     .           7X,'THMUMA                   = ',D19.6,' DEGREES'/)
      IF (ITER.EQ.1) PRINT 5,P1,P2
    5 FORMAT('0',6X,'ELECTRON BEAM FOUR-MOMENTUM : '/
     .           1X,4(D30.20,2X)//
     .           7X,'POSITRON BEAM FOUR-MOMENTUM : '/
     .           1X,4(D30.20,2X))
      IF (ITER.EQ.1) PRINT 6,SAP(1)
    6 FORMAT('0',6X,'APPROXIMATE CROSS SECTIONS SUBGENERATOR A :'//
     .           7X,'TOTAL       = ',D19.6,' NANOBARN'///)
      IF (ITER.EQ.1) PRINT 7,SAPB,SAP(2)
    7 FORMAT('0',6X,'APPROXIMATE CROSS SECTIONS SUBGENERATOR B :'//
     .           7X,'REGION 1    = ',D19.6,' NANOBARN'/
     .           7X,'REGION 2    = ',D19.6,' NANOBARN'/
     .           7X,'TOTAL       = ',D19.6,' NANOBARN'///)
      IF (ITER.EQ.1) PRINT 8,SA3,SAP(3)
    8 FORMAT('0',6X,'APPROXIMATE CROSS SECTION  SUBGENERATOR C :'//
     .           7X,'SA3(1)      = ',D19.6,' NANOBARN'/
     .           7X,'SA3(2)      = ',D19.6,' NANOBARN'/
     .           7X,'SA3(3)      = ',D19.6,' NANOBARN'/
     .           7X,'SA3(4)      = ',D19.6,' NANOBARN'/
     .           7X,'TOTAL       = ',D19.6,' NANOBARN'///)
      IF (ITER.EQ.1) PRINT 9,SAPD(1),SAPD(2),SA4(1),
     .        SAPD(3),SAPD(4),SA4(2),SAP(4)
    9 FORMAT('0',6X,'APPROXIMATE CROSS SECTIONS SUBGENERATOR D :'//
     .           7X,'PROCESS 1   = ',D19.6,' NANOBARN'/
     .           7X,'PROCESS 2   = ',D19.6,' NANOBARN'/
     .           7X,'SA4(1)      = ',D19.6,' NANOBARN'/
     .           7X,'PROCESS 1   = ',D19.6,' NANOBARN'/
     .           7X,'PROCESS 2   = ',D19.6,' NANOBARN'/
     .           7X,'SA4(2)      = ',D19.6,' NANOBARN'/
     .           7X,'TOTAL       = ',D19.6,' NANOBARN')
      IF (ITER.EQ.1) PRINT 10,EP
   10 FORMAT('0',6X,'EP(1)  = ',D19.6/
     .           7X,'EP(2)  = ',D19.6/
     .           7X,'EP(3)  = ',D19.6/)
      IF (ITER.EQ.1) PRINT 11,EA3,EA4
   11 FORMAT('0',6X,'EA3(1) = ',D19.6/
     .           7X,'EA3(2) = ',D19.6/
     .           7X,'EA3(3) = ',D19.6//
     .           7X,'EA4    = ',D19.6/)
C
      RETURN
      END
      SUBROUTINE CENDTC(FT)
C------------------------------------------------------------
C CENDTC DETERMINES HOW MANY TRACKS ARE VISIBLE IN THE CENTRAL
C DETECTOR, I.E. ARE AT AN ANGLE LARGER THAT THETA0 W.R.T.
C THE BEAMS. SIXTEEN SIGNATURES ARE POSSIBLE RANGING FROM NO
C TRACKS TO FOUR TRACKS IN THE CENTRAL DETECTOR. THE CORRESPONDING
C WEIGHTS ('FT') ARE SUMMED WITH SOME STATISTICS.
C------------------------------------------------------------
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON / CENINI / THETA0,C0
      COMMON / FTSTAT / SUMFT,SUMFT2,FTMAX,IEEN
      COMMON / SAP    / SAP(4),SAPT
      COMMON / VECTOR / P1,P2,QM,QP,PM,PP
      COMMON / WECOUN / IFAIL(4),IACC(4),INUL(4),ICHG(4),
     .                  INEG,IONE,IZERO
      COMMON /MYCOMN/ PERROR,FTADD(4),ITER
      DIMENSION P1(4),P2(4),QM(4),QP(4),PM(4),PP(4)
      COMMON /CENDEC/ ICD(16),WCD(16),WCDK(16),ECD(16),XSEC(16),
     &   ESEC(16)
      DATA INIY /0/
C
C INITIALIZE : DETERMINE SCATTERING ANGLE CUT ETCETERA
      IF(INIY . NE . 0) GOTO 1000
      INIY = 1
      IF (ITER.EQ.1) PRINT 999,THETA0,C0
  999 FORMAT('0ROUTINE CENDTC CALLED : THETA0 =',F8.2,
     .  '(COSINE =',F8.3,' )')
 1000 CONTINUE
C
C DETERMINE FOR EACH TRACK ( QP,QM,PP,PM ) IF IT IS IN THE C.D.
      QPV = DSQRT(QP(1)**2+QP(2)**2+QP(3)**2)
      QMV = DSQRT(QM(1)**2+QM(2)**2+QM(3)**2)
      PPV = DSQRT(PP(1)**2+PP(2)**2+PP(3)**2)
      PMV = DSQRT(PM(1)**2+PM(2)**2+PM(3)**2)
      JQP = 0
      IF( DABS(QP(3)/QPV) . LT . C0 ) JQP = 1
      JQM = 0
      IF( DABS(QM(3)/QMV) . LT . C0 ) JQM = 2
      JPP = 0
      IF( DABS(PP(3)/PPV) . LT . C0 ) JPP = 4
      JPM = 0
      IF( DABS(PM(3)/PMV) . LT . C0 ) JPM = 8
C
C DETERMINE SIGNATURE PARAMETER AND DO BOOKKEEPING
      KCD = 1 + JQP + JQM + JPP + JPM
      ICD(KCD)  = ICD(KCD)  + 1
      WCD(KCD)  = WCD(KCD)  + FT
      WCDK(KCD) = WCDK(KCD) + FT*FT
C
      RETURN
C
      ENTRY CENINF(CROSEC,ERCROS)
C---------------------------------------------------------------
C THIS ROUTINE CALCULATES THE TOTAL WEIGHT FOR ALL OF THE 16
C EVENT SIGNATURES, TOGETHER WITH THE ESTIMATED ERROR ON IT
      DO 2000 K=1,16
      XI     = ICD(K)
      IF( XI . EQ . 0 ) GOTO 2000
C      XSEC(K)= WCD(K)/SUMFT*CROSEC
C      ECD(K) = DSQRT( WCDK(K) - WCD(K)**2/XI )
C      ESEC(K)= ECD(K)/SUMFT*CROSEC+
C     .         WCD(K)/SUMFT*ERCROS
      XSEC(K)= WCD(K)/DFLOAT(IONE)*SAPT
      ECD(K) = DSQRT(WCDK(K)-WCD(K)**2/DFLOAT(IONE))
      ESEC(K)= ECD(K)*SAPT/DFLOAT(IONE)
 2000 CONTINUE
C
C PRINT OUT RESULTS
      PRINT 3000,(ICD(J),WCD(J),ECD(J),XSEC(J),ESEC(J),J=1,16)
 3000 FORMAT('0'/,
     .'0 FINAL RESULTS FOR CENTRAL DETECTOR SIGNATURES:'/,'0',
     .'TRACKS IN C.D.',4X,'# OF EVENTS',5X,'TOT.WEIGHT',10X,'ERROR'/,
     .'  NONE        ',I15,4D15.6/,
     .'  QP          ',I15,4D15.6/,
     .'  QM          ',I15,4D15.6/,
     .'  QP,QM       ',I15,4D15.6/,
     .'  PP          ',I15,4D15.6/,
     .'  PP,QP       ',I15,4D15.6/,
     .'  PP,QM       ',I15,4D15.6/,
     .'  PP,QP,QM    ',I15,4D15.6/,
     .'  PM          ',I15,4D15.6/,
     .'  PM,QP       ',I15,4D15.6/,
     .'  PM,QM       ',I15,4D15.6/,
     .'  PM,QP,QM    ',I15,4D15.6/,
     .'  PM,PP       ',I15,4D15.6/,
     .'  PM,PP,QP    ',I15,4D15.6/,
     .'  PM,PP,QM    ',I15,4D15.6/,
     .'  PM,PP,QP,QM ',I15,4D15.6)
C
      RETURN
      END
      SUBROUTINE FINISH(IPROC,ITOT,IREJEC)
C... SUBROUTINE FINISH PRINTS RESULTS ON EVENT GENERATION
C... INFORMATION ON CROSS SECTION AND EVENT STATISTICS IS PRINTED.
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON /COUNTA/ IREGA1,IREGA2
      COMMON /COUNTB/ IREGB1,IREGB2,IPROB1,IPROB2
      COMMON /COUNTD/ IPROD1,IPROD2
      COMMON /FTSTAT/ SUMFT,SUMFT2,FTMAX,IEEN
      COMMON /INPUT / EB,THMIN,THMAX,ESWE,ESFT,WAP(4),WBP(4),VAP(4)
      COMMON /SAP   / SAP(4),SAPT
      COMMON /TRANS / IY
      COMMON /WESTAT/ SWE(4),SWEK(4),MWE(4),SUM,SUMK,MAXWE,IWE(4),IGEN
      COMMON /WECOUN/ IFAIL(4),IACC(4),INUL(4),ICHG(4),
     .                INEG,IONE,IZERO
      COMMON /MYCOMN/ PERROR,FTADD(4),ITER
      REAL*8 MWE,MAXWE,MEAN(4),MEANT
      DIMENSION SDD(4),SIGMA(4),ERROR(4),EFF(4),SNORM(4),SNER(4),
     &   SWEIG(4)
C---------------------------------------------------------------
      DO 1 I = 1,4
      IF (IWE(I).EQ.0) GOTO 11
      MEAN(I)  = SWE(I)/DFLOAT(IWE(I))
      SDD(I)   = DSQRT(SWEK(I)-SWE(I)*SWE(I)/DFLOAT(IWE(I)))/
     .           DFLOAT(IWE(I))
      SIGMA(I) = MEAN(I)*SAP(I)
      ERROR(I) = SDD(I) *SAP(I)
C This SWEIG I use to calculate WAP and WBP factors.
      IF (WAP(I).GT.1.D-15) THEN
         SWEIG(I) = MEAN(I)*SAP(I)/WAP(I)
      ELSE
         SWEIG(I) = 0.D0
      ENDIF
C Get correctly normalized x-sections
C Get correctly normalized x-sections. These were determined 'experimentally'
C because the program did not give what I expected based on the
C documentation. But this formula seems to work. I cross-checked w/
C another 4-fermion generator. J.Hilgart
         IF (IREJEC.EQ.1) THEN
            SNORM(I) = FTADD(I)*SAPT/DFLOAT(IONE)
         ELSE
            IF (IONE.GT.0) THEN
C               SNORM(I) = (FTADD(I)*SWE(I) + .5D0*FTADD(I)*(SUM-SWE(I))
C     &       + .5D0*SWE(I)*(SUMFT-FTADD(I)))*SAPT/(DFLOAT(IONE*IGEN))
               SNORM(I) = (SAP(I)*SWE(I) + .5D0*SAP(I)*(SUM-SWE(I))+
     &         .5D0*SWE(I)*(SAPT-SAP(I)))*SUMFT/
     &         (DFLOAT(IONE)*DFLOAT(IGEN))
            ELSE
               SNORM(I) = 0.D0
            ENDIF
         ENDIF
         SNER(I) = 0.D0
      IF (MWE(I).NE.0.D0) EFF(I) = MEAN(I)/MWE(I)*100.D0
      GOTO 1
   11 CONTINUE
      MEAN(I)  = 0.D0
      SDD(I)   = 0.D0
      SIGMA(I) = 0.D0
      ERROR(I) = 0.D0
      SWEIG(I) = 0.D0
      SNORM(I) = 0.D0
      SNER(I) = 0.D0
    1 CONTINUE
C---------------------------------------------------------------
      GOTO (101,102,103,104,105,106) ,IPROC
  101 PRINT 201
  201 FORMAT('0',6X,'RESULTS OF THE MONTE CARLO SIMULATION OF ',
     .              'E+ E- ---> MU+ MU- L+ L-'/)
      GOTO 107
  102 PRINT 202
  202 FORMAT('0',6X,'RESULTS OF THE MONTE CARLO SIMULATION OF ',
     .              'E+ E- ---> MU+ MU- MU+ MU-'/)
      GOTO 107
  103 PRINT 203
  203 FORMAT('0',6X,'RESULTS OF THE MONTE CARLO SIMULATION OF ',
     .              'E+ E- ---> E+ E- MU+ MU-'/)
      GOTO 107
  104 PRINT 204
  204 FORMAT('0',6X,'RESULTS OF THE MONTE CARLO SIMULATION OF ',
     .              'E+ E- ---> E+ E- L+ L-'/)
      GOTO 107
  105 PRINT 205
  205 FORMAT('0',6X,'RESULTS OF THE MONTE CARLO SIMULATION OF ',
     .              'E+ E- ---> E+ E- E+ E-'/)
  106 PRINT 206
  206 FORMAT('0',6X,'RESULTS OF THE MONTE CARLO SIMULATION OF ',
     .              'E+ E- ---> TAU+ TAU- TAU+ TAU-'/)
      GOTO 107
  107 CONTINUE
      PRINT 3
      IF (MWE(1).GT.ESWE) PRINT 12
C      PRINT 4,MWE(1),SWE(1),MEAN(1),SDD(1),SAP(1),SIGMA(1),ERROR(1),
C     .        IWE(1),IACC(1),INUL(1),IFAIL(1)
      PRINT 4,MWE(1),SWE(1),MEAN(1),SDD(1),SAP(1),SNORM(1),SNER(1),
     .        IWE(1),IACC(1),INUL(1),IFAIL(1),SWEIG(1)
      PRINT 13,IREGA1,IREGA2
      IF (MWE(1).NE.0.D0) PRINT 10,EFF(1)
      PRINT 5
      IF (MWE(2).GT.ESWE) PRINT 12
C      PRINT 4,MWE(2),SWE(2),MEAN(2),SDD(2),SAP(2),SIGMA(2),ERROR(2),
C     .        IWE(2),IACC(2),INUL(2),IFAIL(2)
      PRINT 4,MWE(2),SWE(2),MEAN(2),SDD(2),SAP(2),SNORM(2),SNER(2),
     .        IWE(2),IACC(2),INUL(2),IFAIL(2),SWEIG(2)
      PRINT 14,IREGB1,IREGB2,IPROB1,IPROB2
      IF (MWE(2).NE.0.D0) PRINT 10,EFF(2)
      PRINT 6
      IF (MWE(3).GT.ESWE) PRINT 12
C      PRINT 4,MWE(3),SWE(3),MEAN(3),SDD(3),SAP(3),SIGMA(3),ERROR(3),
C     .        IWE(3),IACC(3),INUL(3),IFAIL(3)
      PRINT 4,MWE(3),SWE(3),MEAN(3),SDD(3),SAP(3),SNORM(3),SNER(3),
     .        IWE(3),IACC(3),INUL(3),IFAIL(3),SWEIG(3)
      IF (MWE(3).NE.0.D0) PRINT 10,EFF(3)
      PRINT 7
      IF (MWE(4).GT.ESWE) PRINT 12
C      PRINT 4,MWE(4),SWE(4),MEAN(4),SDD(4),SAP(4),SIGMA(4),ERROR(4),
C     .        IWE(4),IACC(4),INUL(4),IFAIL(4)
      PRINT 4,MWE(4),SWE(4),MEAN(4),SDD(4),SAP(4),SNORM(4),SNER(4),
     .        IWE(4),IACC(4),INUL(4),IFAIL(4),SWEIG(4)
      PRINT 15,IPROD1,IPROD2
      IF (MWE(4).NE.0.D0) PRINT 10,EFF(4)
C------------------------------------------------------------------
      IF (IREJEC.EQ.1) GOTO 500
      MEANT  = SUM/DFLOAT(IGEN)
      SDDT   = DSQRT(SUMK-SUM*SUM/DFLOAT(IGEN))/DFLOAT(IGEN)
      SIGMAT = MEANT*SAPT
      ERRORT = SDDT *SAPT
C------------------------------------------------------------------
      PRINT 8
      PRINT 9,MAXWE,SUM,MEANT,SDDT,SAPT,SIGMAT,ERRORT,
     .        IGEN,IONE,IZERO,INEG
  500 CONTINUE
C------------------------------------------------------------------
      IF (IONE.EQ.0) GOTO 25
      XONE   = DFLOAT(IONE)
      FTMEAN = SUMFT/XONE
      FERROR = DSQRT(SUMFT2-SUMFT*SUMFT/XONE)/XONE
      GOTO (501,502) ,IREJEC
  501 CROSEC = FTMEAN*SAPT
      ERCROS = FERROR*SAPT
      GOTO 503
  502 CROSEC = FTMEAN*SIGMAT
      ERCROS = FTMEAN*ERRORT + FERROR*SIGMAT
  503 CONTINUE
C------------------------------------------------------------------
      IF (FTMAX.GT.ESFT) PRINT 504
      PRINT 20,FTMAX,SUMFT,FTMEAN,FERROR,CROSEC,ERCROS,IEEN,IY
C------------------------------------------------------------------
    3 FORMAT('0',4X,'CONTRIBUTION FROM THE MULTIPERIPHERAL ',
     .              'FEYNMAN DIAGRAMS...')
    5 FORMAT('0',4X,'CONTRIBUTION FROM THE BREMSSTRAHLUNG ',
     .              'FEYNMAN DIAGRAMS...')
    6 FORMAT('0',4X,'CONTRIBUTION FROM THE TWO GAMMA CONVERSION ',
     .              'FEYNMAN DIAGRAMS...')
    7 FORMAT('0',4X,'CONTRIBUTION FROM THE ANNIHILATION ',
     .              'FEYNMAN DIAGRAMS...')
    4 FORMAT('0',6X,'MAXIMUM WEIGHT                  = ',D19.6/
     .           7X,'SUM OF WEIGHTS                  = ',D19.6/
     .           7X,'MEAN WEIGHT                     = ',D19.6,
     .           2X,'w/ RMS ',D19.6/
     .           7X,'APPROXIMATE CROSS SECTION       = ',D19.6/
     .           7X,'Normalized x-section          = ',D19.6,
     .           ' +- ',D19.6,' Nanobarns'/
C     .           7X,'EXACT       CROSS SECTION       = ',D19.6,
C     .              ' NANOBARN',2X,'+ - ',D19.6,' NANOBARN'/
     .           7X,'# GENERATED EVENTS              = ',I9/
     .           7X,'# ACCEPTED  EVENTS              = ',I9/
     .           7X,'# EVENTS WITH WEIGHT = 0        = ',I9/
     .           7X,'# EVENTS WITH WEIGHT < 0        = ',I9/
     .           7X,' Weight parameter               = ',D19.6)
   10 FORMAT(' ',6X,'EFFICIENCY                      = ',D19.6,
     .              ' PERCENT')
   13 FORMAT(' ',6X,'# EVENTS GENERATED IN REGION 1  = ',I9/
     .           7X,'# EVENTS GENERATED IN REGION 2  = ',I9)
   14 FORMAT(' ',6X,'# EVENTS GENERATED IN REGION 1  = ',I9/
     .           7X,'# EVENTS GENERATED IN REGION 2  = ',I9/
     .           7X,'# EVENTS OF PROCESS 2           = ',I9)
   15 FORMAT(' ',6X,'# EVENTS OF PROCESS 1           = ',I9/
     .           7X,'# EVENTS OF PROCESS 2           = ',I9)
    8 FORMAT(/'0',4X,'TOTAL RESULT FROM SUBGENERATORS')
    9 FORMAT('0',6X,'MAXIMUM OF ALL WEIGHTS          = ',D19.6/
     .           7X,'SUM OF ALL WEIGHTS              = ',D19.6/
     .           7X,'MEAN OF ALL WEIGHTS             = ',D19.6,
     .           2X,'+ - ',D19.6/
     .           7X,'TOTAL APPROXIMATE CROSS SECTION = ',D19.6/
     .           7X,'TOTAL EXACT       CROSS SECTION = ',D19.6,
     .           ' NANOBARN',2X,'+ - ',D19.6,' NANOBARN'/
     .           7X,'# GENERATED EVENTS         = ',I9/
     .           7X,'# ACCEPTED  EVENTS         = ',I9/
     .           7X,'# EVENTS WITH WEIGHT = 0   = ',I9/
     .           7X,'# EVENTS WITH WEIGHT < 0   = ',I9)
   12 FORMAT('0*****WARNING***** ESTIMATED MAXIMUM WEIGHT ESWE',
     .       ' IS TOO SMALL')
  504 FORMAT('0*****WARNING***** ESTIMATED MAXIMUM WEIGHT ESFT',
     .       ' IS TOO SMALL')
   20 FORMAT('0',130(1H*)//50X,'FINAL RESULTS'//
     .           7X,'MAXIMUM FTWEIGHT                = ',D19.6/
     .           7X,'SUM OF FTWEIGHTS                = ',D19.6/
     .           7X,'MEAN FTWEIGHT                   = ',D19.6,
     .           2X,'+ - ',D19.6/
     .           7X,'EXACT TOTAL CROSS SECTION       = ',D19.6,
     .              ' NANOBARN',2X,'+ - ',D19.6,' NANOBARN'/
     .           7X,'# UNWEIGHTED EVENTS             = ',I9//
     .           7X,'START VALUE RNDM                = ',I9//
     .           1X,130(1H*))
C
   25 CONTINUE
      CALL CENINF(CROSEC,ERCROS)
      CALL HISTO2(1)
      CALL HISTO2(2)
      CALL HISTO2(16)
      CALL HISTO2(17)
      CALL HISTO2(18)
      CALL HISTO2(19)
      CALL HISTO2(20)
      RETURN
      END
      LOGICAL FUNCTION MYFINS(IPROC,ITOT,IREJEC)
C J.Hilgart
C Learn if we are finished according to the criteria set up.
C For use when ILEARN = 1
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON /COUNTA/ IREGA1,IREGA2
      COMMON /COUNTB/ IREGB1,IREGB2,IPROB1,IPROB2
      COMMON /COUNTD/ IPROD1,IPROD2
      COMMON /FTSTAT/ SUMFT,SUMFT2,FTMAX,IEEN
      COMMON /INPUT / EB,THMIN,THMAX,ESWE,ESFT,WAP(4),WBP(4),VAP(4)
      COMMON /SAP   / SAP(4),SAPT
      COMMON /TRANS / IY
      COMMON /WESTAT/ SWE(4),SWEK(4),MWE(4),SUM,SUMK,MAXWE,IWE(4),IGEN
      COMMON /WECOUN/ IFAIL(4),IACC(4),INUL(4),ICHG(4),
     .                INEG,IONE,IZERO
      COMMON /MYCOMN/ PERROR,FTADD(4),ITER
      REAL*8 MWE,MAXWE,MEAN(4),MEANT
      DIMENSION SDD(4),SIGMA(4),ERROR(4),EFF(4),SNORM(4),SNER(4),SCHK(4)
      DIMENSION WAPT(4),WAPTO(4),SAPO(4),WBPO(4),SWEIG(4),SNERR(4)
      LOGICAL TST1,NWWT
C---------------------------------------------------------------
      MYFINS = .TRUE.
      SNTOT = 0.D0
      SIGMX = -1.D0
      SIGMN = 1.D10
      DO 1 I = 1,4
         WBPO(I) = WBP(I)
         MEAN(I) = 1.D0
         IF (IWE(I).EQ.0 .OR. WAP(I).LT.1.D-15) GOTO 1
         MEAN(I)  = SWE(I)/DFLOAT(IWE(I))
         SDD(I)   = DSQRT(SWEK(I)-SWE(I)*SWE(I)/DFLOAT(IWE(I)))/
     .           DFLOAT(IWE(I))
         SIGMA(I) = MEAN(I)*SAP(I)
         ERROR(I) = SDD(I) *SAP(I)
         IF (MWE(I).NE.0.D0) EFF(I) = MEAN(I)/MWE(I)*100.D0
         IF (MWE(I).GT.ESWE .AND. IREJEC.EQ.2)  PRINT 12
C This SWEIG I use to calculate WAP and WBP factors.
         SWEIG(I) = MEAN(I)*SAP(I)/WAP(I)
         SCHK(I) = SAP(I)*SWE(I)/IWE(I)/WAP(I)
         IF (IONE.GT.0) THEN
            IF (IREJEC.EQ.1) THEN
               SNORM(I) = FTADD(I)*SAPT/DFLOAT(IONE)
               SNER(I) = 0.D0
            ELSE
               IF (IACC(I).GT.0) THEN
C Get correctly normalized x-sections. These were determined 'experimentally'
C because the program did not give what I expected based on the
C documentation. But this formula seems to work. I cross-checked w/
C another 4-fermion generator. J.Hilgart
C               SNORM(I) = (FTADD(I)*SWE(I) + .5D0*FTADD(I)*(SUM-SWE(I))+
C     &         .5D0*SWE(I)*(SUMFT-FTADD(I)))*SAPT/(DFLOAT(IONE*IGEN))
               SNORM(I) = (SAP(I)*SWE(I) + .5D0*SAP(I)*(SUM-SWE(I))+
     &         .5D0*SWE(I)*(SAPT-SAP(I)))*SUMFT/
     &         (DFLOAT(IONE)*DFLOAT(IGEN))
               ELSE
                  SNORM(I) = SCHK(I)*SUMFT/IONE
               ENDIF
               SNER(I) = 0.D0
            ENDIF
         ELSE
            SNORM(I) = 0.D0
            SNER(I) = 0.D0
         ENDIF
C            SNERR(I) = SAP(I)/WAP(I)*SDD(I)/
C     &         DSQRT(DFLOAT(IWE(I)))
         SNTOT = SNTOT + SWEIG(I)
         IF (SWEIG(I).GT.SIGMX) THEN
            SIGMX = SWEIG(I)
            IKPS = I
         ENDIF
         IF (SWEIG(I).LT.SIGMN .AND. SWEIG(I).GT.1.D-15) THEN
            SIGMN = SWEIG(I)
            IKSMN = I
         ENDIF
    1 CONTINUE
C---------------------------------------------------------------
c
      IF (IREJEC.EQ.1) GOTO 500
      MEANT  = SUM/DFLOAT(IGEN)
      SDDT   = DSQRT(SUMK-SUM*SUM/DFLOAT(IGEN))/DFLOAT(IGEN)
      SIGMAT = MEANT*SAPT
      ERRORT = SDDT *SAPT
C------------------------------------------------------------------
  500 CONTINUE
C------------------------------------------------------------------
    3 FORMAT('0',4X,'CONTRIBUTION FROM THE MULTIPERIPHERAL ',
     .              'FEYNMAN DIAGRAMS...')
    5 FORMAT('0',4X,'CONTRIBUTION FROM THE BREMSSTRAHLUNG ',
     .              'FEYNMAN DIAGRAMS...')
    6 FORMAT('0',4X,'CONTRIBUTION FROM THE TWO GAMMA CONVERSION ',
     .              'FEYNMAN DIAGRAMS...')
    7 FORMAT('0',4X,'CONTRIBUTION FROM THE ANNIHILATION ',
     .              'FEYNMAN DIAGRAMS...')
    4 FORMAT('0',6X,'MAXIMUM WEIGHT                  = ',D19.6/
     .           7X,'SUM OF WEIGHTS                  = ',D19.6/
     .           7X,'MEAN WEIGHT                     = ',D19.6,
     .           2X,'w/ RMS ',D19.6/
     .           7X,'APPROXIMATE CROSS SECTION       = ',D19.6/
     .           7X,'Normalized x-section          = ',D19.6,
     .           ' +- ',D19.6,' Nanobarns'/
C     .           7X,'EXACT       CROSS SECTION       = ',D19.6,
C     .              ' NANOBARN',2X,'+ - ',D19.6,' NANOBARN'/
     .           7X,'# GENERATED EVENTS              = ',I9/
     .           7X,'# ACCEPTED  EVENTS              = ',I9/
     .           7X,'# EVENTS WITH WEIGHT = 0        = ',I9/
     .           7X,'# EVENTS WITH WEIGHT < 0        = ',I9/
     .           7X,' Weight parameter               = ',D19.6)
   13 FORMAT(' ',6X,'# EVENTS GENERATED IN REGION 1  = ',I9/
     .           7X,'# EVENTS GENERATED IN REGION 2  = ',I9)
   14 FORMAT(' ',6X,'# EVENTS GENERATED IN REGION 1  = ',I9/
     .           7X,'# EVENTS GENERATED IN REGION 2  = ',I9/
     .           7X,'# EVENTS OF PROCESS 2           = ',I9)
   15 FORMAT(' ',6X,'# EVENTS OF PROCESS 1           = ',I9/
     .           7X,'# EVENTS OF PROCESS 2           = ',I9)
C Is ESWE too low?
      IF ((IREJEC.EQ.2 .AND. ESWE.LT.MAXWE).OR.ESFT.LT.FTMAX)
     &   THEN
         MYFINS = .FALSE.
      ENDIF
      IF ((IREJEC.EQ.2.AND.IONE.EQ.0).OR.(IREJEC.EQ.1.AND.
     &   SUMFT.LT.1.D-15)) THEN
         MYFINS = .FALSE.
         TST1 = .TRUE.
         GOTO 25
      ENDIF
      XONE   = DFLOAT(IONE)
      FTMEAN = SUMFT/XONE
      FERROR = DSQRT(SUMFT2-SUMFT*SUMFT/XONE)/XONE
      GOTO (501,502) ,IREJEC
  501 CROSEC = FTMEAN*SAPT
      ERCROS = FERROR*SAPT
      GOTO 503
  502 CROSEC = FTMEAN*SIGMAT
      ERCROS = FTMEAN*ERRORT + FERROR*SIGMAT
  503 CONTINUE
C------------------------------------------------------------------
C
C
C Is the cross-section good enough?
      TST1 = ERCROS/MAX(CROSEC,1.D-10).GT.PERROR*.01D0
      IF (TST1)  MYFINS = .FALSE.
    8 FORMAT(/'0',4X,'TOTAL RESULT FROM SUBGENERATORS')
    9 FORMAT('0',6X,'MAXIMUM OF ALL WEIGHTS          = ',D19.6/
     .           7X,'SUM OF ALL WEIGHTS              = ',D19.6/
     .           7X,'MEAN OF ALL WEIGHTS             = ',D19.6,
     .           2X,'+ - ',D19.6/
     .           7X,'TOTAL APPROXIMATE CROSS SECTION = ',D19.6/
     .           7X,'TOTAL EXACT       CROSS SECTION = ',D19.6,
     .           ' NANOBARN',2X,'+ - ',D19.6,' NANOBARN'/
     .           7X,'# GENERATED EVENTS         = ',I9/
     .           7X,'# ACCEPTED  EVENTS         = ',I9/
     .           7X,'# EVENTS WITH WEIGHT = 0   = ',I9/
     .           7X,'# EVENTS WITH WEIGHT < 0   = ',I9)
   12 FORMAT('0*****WARNING***** ESTIMATED MAXIMUM WEIGHT ESWE',
     .       ' IS TOO SMALL')
  504 FORMAT('0*****WARNING***** ESTIMATED MAXIMUM WEIGHT ESFT',
     .       ' IS TOO SMALL')
   20 FORMAT('0',130(1H*)//50X,'FINAL RESULTS'//
     .           7X,'MAXIMUM FTWEIGHT                = ',D19.6/
     .           7X,'SUM OF FTWEIGHTS                = ',D19.6/
     .           7X,'MEAN FTWEIGHT                   = ',D19.6,
     .           2X,'+ - ',D19.6/
     .           7X,'EXACT TOTAL CROSS SECTION       = ',D19.6,
     .              ' NANOBARN',2X,'+ - ',D19.6,' NANOBARN'/
     .           7X,'# UNWEIGHTED EVENTS             = ',I9//
     .           7X,'START VALUE RNDM                = ',I9//
     .           1X,130(1H*))
C
   25 CONTINUE
C
      IF (MYFINS)  THEN
C
C We don't need another go, but perhaps the weights could be
C optimized for the next running.
C
C Was ESFT or ESWE too high?
         NWWT = .FALSE.
         IF (IREJEC.EQ.2 .AND. ESWE.GT.3.D0*MAXWE) THEN
            ESWE = TWORND(2.0D0*MAXWE)
            NWWT = .TRUE.
         ENDIF
         IF (ESFT.GT.3.D0*FTMAX) THEN
            ESFT = TWORND(2.0D0*FTMAX)
            NWWT = .TRUE.
         ENDIF
         IF (NWWT) PRINT 101,ESFT,ESWE
  101    FORMAT(/' For the next time, I recommend these values'
     &      ,' for the weights.'/
     &   ' ',6X,'ESFT = ',D12.3/
     &   ' ',6X,'ESWE = ',D12.3/)
         RETURN
      ENDIF
C
C We do need another go.
C Print out some relevant info
C
      PRINT 3
      PRINT 4,MWE(1),SWE(1),MEAN(1),SDD(1),SAP(1),SNORM(1),SNER(1),
     .        IWE(1),IACC(1),INUL(1),IFAIL(1),SWEIG(1)
      PRINT 13,IREGA1,IREGA2
      PRINT 5
      PRINT 4,MWE(2),SWE(2),MEAN(2),SDD(2),SAP(2),SNORM(2),SNER(2),
     .        IWE(2),IACC(2),INUL(2),IFAIL(2),SWEIG(2)
      PRINT 14,IREGB1,IREGB2,IPROB1,IPROB2
      PRINT 6
      PRINT 4,MWE(3),SWE(3),MEAN(3),SDD(3),SAP(3),SNORM(3),SNER(3),
     .        IWE(3),IACC(3),INUL(3),IFAIL(3),SWEIG(3)
      PRINT 7
      PRINT 4,MWE(4),SWE(4),MEAN(4),SDD(4),SAP(4),SNORM(4),SNER(4),
     .        IWE(4),IACC(4),INUL(4),IFAIL(4),SWEIG(4)
      PRINT 15,IPROD1,IPROD2
C
C Was ESFT or ESWE too high?
      IF (IONE.EQ.0)  GOTO 102
      PRINT 8
      PRINT 9,MAXWE,SUM,MEANT,SDDT,SAPT,SIGMAT,ERRORT,
     .        IGEN,IONE,IZERO,INEG
C------------------------------------------------------------------
      IF (FTMAX.GT.ESFT.AND. IONE.NE.0) PRINT 504
      PRINT 20,FTMAX,SUMFT,FTMEAN,FERROR,CROSEC,ERCROS,IEEN,IY
C------------------------------------------------------------------
 102  IF (TST1)  ITOT = ITOT*5
C
C Save original SAP factors. Set WAP kill factors.
      IF (ITER.EQ.1) THEN
         DO 38 ID = 1, 4
 38         SAPO(ID) = SAP(ID)
      ENDIF
C
C Do we have any non-zero results?
      IF (MEAN(IKPS).LT.1.D-15)  GOTO 999
C
C Normalize beta factors such that graph which contributes most to
C x-section has mean 1, adjusting maximum weights to the max. wt.
C of this graph to increase efficiency.
C
      WBP(IKPS) = TWORND(WBP(IKPS)*MEAN(IKPS))
C
C New max wt. , ESWE, and ESFT
      WTMX = MWE(IKPS)/MEAN(IKPS)
      FAC = 2.D0 + 30.D0/FLOAT(ITOT)**.33
      IF (WTMX.GT.1.D-15)  ESWE = TWORND(FAC*WTMX)
      IF (FTMAX.GT.1.D-15)  THEN
         ESFTO = ESFT
         FAC1 = 2.D0 + 15.D0/FLOAT(ITOT)**.33
         ESFT = TWORND(FAC1*FTMAX)
         IF (ESFT.LT.ESFTO) ESFT = ESFT + .33*(ESFTO-ESFT)
      ENDIF
      DO 52 ID = 1, 4
         IF (ID.EQ.IKPS)  GOTO 52
         IF (MWE(ID) .LT. 1.D-15)  GOTO 52
         WBP(ID) = TWORND(WBPO(ID)*MWE(ID)/WTMX)
   52 CONTINUE
C
C WAP factors
      DO 53 ID = 1, 4
C
C Phase out non-important generators
         IF (WAP(ID).LT.1.D-15)  GOTO 53
C
C If we tried this generator for >50 events, but it contributes < 1%
C drop it from further consideration
         IF (SWEIG(ID).GT.1.D-15 .AND. CROSEC.GT.1.D-15) THEN
C           IF (SNERR(ID)/SWEIG(ID).LT..25 .AND.
C     &      SWEIG(ID)/SNTOT.LT..01 .AND. IWE(ID).GT.50) THEN
         IF(SNORM(ID)/CROSEC.LT..01 .AND. IWE(ID).GT.50) THEN
               WAP(ID) = 0.D0
               GOTO 53
            ENDIF
         ELSE
            GOTO 53
         ENDIF
C         IF (SWEIG(ID).LT.1.D-15)  GOTO 53
         WAP(ID) = TWORND(SWEIG(ID)/(SAPO(ID)*WBP(ID)))
C Help the underdog
         IF (ID.EQ.IKSMN)  WAP(ID) = TWORND(3.D0*WAP(ID))
C         IF (ID.EQ.IKPS)  GOTO 53
C         WAP(ID) = TWORND(MIN(2.D0*WAP(ID),SIGMX/SWEIG(ID)*WAP(ID)))
   53 CONTINUE
      DO 54 ID = 1, 4
         IF (WAP(ID).LT.1.D-15)  GOTO 54
         IF (SWEIG(ID).LT.1.D-15 .AND. SNTOT.GT.1.D-10 .AND.
     &      IWE(ID).GT.10) THEN
            IF (IWE(ID).GT.400)  THEN
               WAP(ID) = 0.D0
               GOTO 54
            ENDIF
C
C Set WAP and WBP such that next time this generator gets 10% of the evts
               SUM = 0.
               DO 55 IE = 1, 4
                  IF (IE.EQ.ID)  GOTO 55
                  SUM = SUM + WAP(IE)*WBP(IE)*SAPO(IE)
   55          CONTINUE
               WAP(ID) = .1*SUM/SAPO(ID)
               WBP(ID) = 1.D0
         ENDIF
   54 CONTINUE
  999 CONTINUE
C
      END
      SUBROUTINE MCA(IPROC,IDUMP)
C... MULTIPERIPHERAL SUBGENERATOR
C
C... COMMON /MATRIX / CONTAINS :
C            XME(1) = EXACT MULTIPERIPHERAL /MATRIX ELEMENT/**2
C... COMMON /DIAG   / CONTAINS :
C            CALCULATED PHOTON PROPAGATORS AND INVARIANT MASS**2 MUON
C            THESE VALUES ARE USED IN FUNCTION DIAG2
C
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON /BOUND / W2MIN,W2MAX
      COMMON /CHARGE/ QCHARG,QCHRG2,QCHRG3,QCHRG4
      COMMON /CONST / ALFA,BARN,PI,TWOPI
      COMMON /CUT   / VMIN,VMAX,CMIN,CMAX,SMIN,SMAX
      COMMON /DIAG  / U1,U2,U3,U4,U5,U6,U7,U8,U9
      COMMON /GENA  / XLA1
      COMMON /INIT  / PB,ET,EP(3),ECH(3)
      COMMON /INPUT / EB,THMIN,THMAX,ESWE,ESFT,WAP(4),WBP(4),VAP(4)
      COMMON /LOGCM / OUTFL(4)
      COMMON /MASSES/ XM,XMU,XML,XM2,XMU2,XML2
      COMMON /MATRIX/ XME(4)
      COMMON /SAP   / SAP(4),SAPT
      COMMON /VECTOR/ P1(4),P2(4),QM(4),QP(4),PM(4),PP(4)
      COMMON /VECTOB/ P1B(4),P2B(4),QMB(4),QPB(4),PMB(4),PPB(4)
      COMMON /WEIGHT/ WEIGHT(4),WEEV,IEVACC
      COMMON /WECOUN/ IFAIL(4),IACC(4),INUL(4),ICHG(4),INEG,IONE,IZER
      COMMON /WESTAT/ SWE(4),SWEK(4),MWE(4),SUM,SUMK,MAXWE,IWE(4),IGEN
      REAL*8 MWE,MAXWE
      REAL*4 RNF100
      LOGICAL OUTFL
      OUTFL(1) = .FALSE.
C
C... GENERATE W2
    1 CONTINUE
      ETA1   = DBLE(RNF100(1))
      HW2    = (0.5D0*W2MAX*(1.D0+CMAX)+2.D0*(1.D0-CMAX))
     .        *(0.5D0*W2MIN*(1.D0+CMAX)+2.D0*(1.D0-CMAX))
     .        /(0.5D0*W2MAX*(1.D0+CMAX)*(1.D0-ETA1)
     .         +0.5D0*W2MIN*(1.D0+CMAX)*ETA1+2.D0*(1.D0-CMAX))
      W2     = (HW2-2.D0*(1.D0-CMAX))*2.D0/(1.D0+CMAX)
      W      = DSQRT(W2)
C...APPLY REJECTION ALGORITHM WITH WEIGHT WEW2
      WEW2   = 1.D0-0.5D0*W
      ETA2   = DBLE(RNF100(2))
      IF (ETA2.GT.WEW2) GOTO 1
C
C... GENERATE X
      XMIN   = 0.D0
      XMAX   = 1.D0-0.25D0*W2
      ETA3   = DBLE(RNF100(3))
      HX     = (1.D0-ETA3)*DSQRT(1.D0-XMIN)+ETA3*DSQRT(1.D0-XMAX)
      X      = 1.D0-HX*HX
C
C... GENERATE CM
      ETA4   = DBLE(RNF100(4))
      CM     = 1.D0-((1.D0-CMIN)/(1.D0-CMAX))**ETA4*(1.D0-CMAX)
      SM     = DSQRT(1.D0-CM*CM)
C
C... GENERATE CP
      ETA5   = DBLE(RNF100(5))
      CP     = 1.D0-((1.D0-CMIN)/(1.D0-CMAX))**ETA5*(1.D0-CMAX)
      SP     = DSQRT(1.D0-CP*CP)
C
C... GENERATE COS(PHIP+PHIM)
      ACO    = 4.D0-2.D0*X*(1.D0+CM*CP)
      BCO    = -2.D0*X*SM*SP
      DCO    = DSQRT(ACO*ACO-BCO*BCO)
      ETA6   = 2.D0*DBLE(RNF100(6))-1.D0
      ETA    = DABS(ETA6)
      HCAZ   = (DCO*DTAN(0.5D0*PI*ETA+DATAN((ACO+BCO)/DCO))-BCO)
     .        /ACO
      CAZ    = 2.D0*HCAZ/(HCAZ*HCAZ+1.D0)
      SAZ    = DSIGN(1.D0,ETA6)*DSQRT(1.D0-CAZ*CAZ)
C
C... GENERATE COS AZIMUTHAL ANGLE PHIP
      ETA7   = DBLE(RNF100(7))
      PHIP   = TWOPI*ETA7
      CPP    = DCOS(PHIP)
      SPP    = DSIN(PHIP)
C
      CPM    = -CAZ*CPP-SAZ*SPP
      SPM    =  SAZ*CPP-CAZ*SPP
C
      COZ    = -CP*CM-SP*SM*CAZ
C
C... CALCULATE ENERGY OF POSITRON
      Y      = (4.D0-4.D0*X-W2)/(4.D0-2.D0*X*(1.D0-COZ))
C
C... PHOTON MASSES
      TE     = -2.D0*X*(1.D0-CM)
      TP     = -2.D0*Y*(1.D0-CP)
C
C... CONSTRUCT FOUR-MOMENTA
      QP(1)  =  Y*SP*CPP
      QP(2)  =  Y*SP*SPP
      QP(3)  = -Y*CP
      QP(4)  =  Y
      QM(1)  =  X*SM*CPM
      QM(2)  =  X*SM*SPM
      QM(3)  =  X*CM
      QM(4)  =  X
C
C... FOUR-MOMENTUM VIRTUAL PHOTON
      QKMX   = -QM(1)
      QKMY   = -QM(2)
      QKMZ   = 1.D0-X*CM
      EQKM   = 1.D0-X
C
C... FOUR-MOMENTUM MUON PAIR
      QWX    = -QM(1)-QP(1)
      QWY    = -QM(2)-QP(2)
      QWZ    = -QM(3)-QP(3)
      EW     = 2.D0-X-Y
C
C... BOOST TO CM FRAME MUON PAIR
      EKMCM  = (W2+TE-TP)/(2.D0*W)
      FAC    = -(EKMCM+EQKM)/(EW+W)
      QKMXCM = QKMX + FAC*QWX
      QKMYCM = QKMY + FAC*QWY
      QKMZCM = QKMZ + FAC*QWZ
C
C... MUON GENERATION
      ACT    = -0.5D0*(W2-TE-TP)
      HB     = (1.D0-4.D0*XMU2/W2)*((W2-TE-TP)**2-4.D0*TE*TP)
      BCT    = 0.5D0*DSQRT(HB)
      APB    = (XMU2*((W2-TE-TP)**2-4.D0*TE*TP)+TE*TP*W2)
     .        /((ACT-BCT)*W2)
      ETA8   = DBLE(RNF100(8))
      ETA    = 2.D0*ETA8-1.D0
      HCT    = (APB/(ACT-BCT))**DABS(ETA)
      CTCME  = (APB+HCT*(BCT-ACT))/(BCT*(1.D0+HCT))
      CTCM   = 1.D0-CTCME
      IF (ETA.LT.0.D0) CTCM=-CTCM
      STCM   = SQRT(CTCME*(2.D0-CTCME))
C
C... GENERATION AZIMUTHAL ANGLE MUON
      ETA9   = DBLE(RNF100(9))
      PHICM  = TWOPI*ETA9
      CPCM   = DCOS(PHICM)
      SPCM   = DSIN(PHICM)
C
C... CONSTRUCT FOUR-MOMENTA
      EMCM   = 0.5D0*W
      PMCM   = SQRT(EMCM*EMCM-XMU2)
      PMXCM  = PMCM*STCM*CPCM
      PMYCM  = PMCM*STCM*SPCM
      PMZCM  = PMCM*CTCM
C
      XLEN   = DSQRT((W2-TE-TP)**2-4.D0*TE*TP)/(2.D0*W)
      CTRO   = QKMZCM/XLEN
      STRO   = DSQRT(QKMXCM**2+QKMYCM**2)/XLEN
      IF (STRO.EQ.0.D0) GOTO 2
      CFRO   = QKMXCM/XLEN/STRO
      SFRO   = QKMYCM/XLEN/STRO
      PMXRO  = PMXCM*CTRO*CFRO-PMYCM*SFRO+PMZCM*STRO*CFRO
      PMYRO  = PMXCM*CTRO*SFRO+PMYCM*CFRO+PMZCM*STRO*SFRO
      PMZRO  =-PMXCM*STRO                +PMZCM*CTRO
      GOTO 3
    2 CONTINUE
      PMXRO  = PMXCM
      PMYRO  = PMYCM
      PMZRO  = PMZCM
    3 CONTINUE
      PM(4)  = (EW*EMCM+QWX*PMXRO+QWY*PMYRO+QWZ*PMZRO)/W
      FAC1   = (PM(4)+EMCM)/(EW+W)
      PM(1)  = PMXRO + FAC1*QWX
      PM(2)  = PMYRO + FAC1*QWY
      PM(3)  = PMZRO + FAC1*QWZ
      PP(1)  = QWX - PM(1)
      PP(2)  = QWY - PM(2)
      PP(3)  = QWZ - PM(3)
      PP(4)  = EW  - PM(4)
C
      DD1    = APB - BCT*CTCME
      DD2    = ACT - BCT + BCT*CTCME
      IF (CTCM.GT.0.D0) GOTO 4
      DDU    = DD1
      DD1    = DD2
      DD2    = DDU
    4 CONTINUE
C
C... EXACT MATRIX ELEMENT SQUARED
      QP(4)  = DSQRT(QP(4)**2+XM2)
      QM(4)  = DSQRT(QM(4)**2+XM2)
      U1     = TE
      U2     = TP
      U3     = W2
      U4     = DD1
      U5     = DD2
      U6     = 0.D0
      U7     = 0.D0
      U8     = 1.D0-QM(4)
      U9     = 1.D0-QP(4)
      XME(1) = DIAG2(P1,QM,XM,P2,QP,XM,PM,PP,XMU,IDUMP)
C
      WE1    = XME(1)*TE*TP*DD1*DD2/512.D0
      WE2    = 0.25D0*(0.5D0*W2*(1.D0+CMAX)+2.D0*(1.D0-CMAX))**2
     .        *DLOG(APB/(ACT-BCT))/(ACT*BCT*XLA1)
      WE3    = 4.D0*DSQRT(1.D0-X)*SMAX/DCO
      WE4    = DSQRT(1.D0-4.D0*XMU2/W2)
C
      WEIGHT(1) = WE1*WE2*WE3*WE4/WBP(1)
      WEEV      = WEIGHT(1)
C
      XXM1    = DOT(QP,QP)-XM2
      XXM2    = DOT(QM,QM)-XM2
      XXM3    = DOT(PP,PP)-XMU2
      XXM4    = DOT(PM,PM)-XMU2
      XXM5    = 2.D0*DOT(PM,PP)+2.D0*XMU2-W2
C      CALL HISTO1(4,8HXXM1    ,20,-1.D0,1.D0,XXM1,1.D0)
C      CALL HISTO1(5,8HXXM2    ,20,-1.D0,1.D0,XXM2,1.D0)
C      CALL HISTO1(6,8HXXM3    ,20,-1.D0,1.D0,XXM3,1.D0)
C      CALL HISTO1(7,8HXXM4    ,20,-1.D0,1.D0,XXM4,1.D0)
C      CALL HISTO1(8,8HWE1     ,20,0.D0,1.D0,WE1,1.D0)
C      CALL HISTO1(9,8HWE2     ,20,0.D0,1.D0,WE2,1.D0)
C      CALL HISTO1(10,8HWE3     ,20,0.D0,1.D0,WE3,1.D0)
C      CALL HISTO1(11,8HWE4     ,20,0.D0,1.D0,WE4,1.D0)
C      CALL HISTO1(12,8HXXM5    ,20,-1.D0,1.D0,XXM5,1.D0)
C
      IF (WEIGHT(1).GE.0.D0) GOTO 201
      IFAIL(1)  = IFAIL(1) + 1
      INEG      = INEG     + 1
      IDUMP     = 5
  201 CONTINUE
C
C-----START DUMP INFORMATION----------------------------------------
      IF (WEEV.GE.0.D0) GOTO 1081
      PRINT 1080,WEIGHT(1)
 1080 FORMAT(' $$$WARNING$$$ : WEIGHT < 0 : WEIGHT = ',D30.20)
 1081 CONTINUE
      IF (IDUMP.LT.1) RETURN
      PRINT 1079
 1079 FORMAT ('0---------INFORMATION ON WEIGHTS------------------')
      PRINT 1082,XME(1),WE1,WE2,WE3,WE4,WEEV
 1082 FORMAT('0XME = ',D30.20,2X,/
     .       ' WEIGHTS = ',4(D15.4,2X)/
     .       ' TOTAL WEIGHT = ',D30.20)
      IF (IDUMP.LT.2) RETURN
      RETURN
      END
      SUBROUTINE MCB(IPROC,IDUMP)
C... BREMSSTRAHLUNG SUBGENERATOR
C
C... COMMON /MATRIX / CONTAINS :
C            XME(2) = EXACT BREMSSTRAHLUNG /MATRIX ELEMENT/**2
C... COMMON /DIAG   / CONTAINS :
C            CALCULATED PHOTON PROPAGATORS AND INVARIANT MASS**2 MUON
C            THESE VALUES ARE USED IN FUNCTION DIAG2
C
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON /BOUND / W2MIN,W2MAX
      COMMON /CHARGE/ QCHARG,QCHRG2,QCHRG3,QCHRG4
      COMMON /CONST / ALFA,BARN,PI,TWOPI
      COMMON /COUNTB/ IREGB1,IREGB2,IPROB1,IPROB2
      COMMON /CUT   / VMIN,VMAX,CMIN,CMAX,SMIN,SMAX
      COMMON /DIAG  / U1,U2,U3,U4,U5,U6,U7,U8,U9
      COMMON /GENB  / XLB1,XLB2(2),SAPB(2)
      COMMON /INIT  / PB,ET,EP(3),ECH(3)
      COMMON /INPUT / EB,THMIN,THMAX,ESWE,ESFT,WAP(4),WBP(4),VAP(4)
      COMMON /LOGCM / OUTFL(4)
      COMMON /MASSES/ XM,XMU,XML,XM2,XMU2,XML2
      COMMON /MATRIX/ XME(4)
      COMMON /SAP   / SAP(4),SAPT
      COMMON /VECTOR/ P1(4),P2(4),QM(4),QP(4),PM(4),PP(4)
      COMMON /VECTOB/ P1B(4),P2B(4),QMB(4),QPB(4),PMB(4),PPB(4)
      COMMON /WEIGHC/ WEIGHT(4),WEEV,IEVACC
      COMMON /WECOUN/ IFAIL(4),IACC(4),INUL(4),ICHG(4),INEG,IONE,IZER
      COMMON /WESTAT/ SWE(4),SWEK(4),MWE(4),SUM,SUMK,MAXWE,IWE(4),IGEN
      DIMENSION PH(4)
      LOGICAL OUTFL
      REAL*8 MWE,MAXWE
      REAL*4 RNDM,RNF100,DUMMY
      EXTERNAL RNDM,RNF100
      OUTFL(2) = .FALSE.
      IY     = 1
      ETA0   = DBLE(RNDM(DUMMY))
      IF (ETA0.LT.SAPB(2)/SAP(2)) IY = -1
      IYY    = (-IY+1)/2 + 1
      IF (IYY.EQ.1) IREGB1 = IREGB1 + 1
      IF (IYY.EQ.2) IREGB2 = IREGB2 + 1
C--------W2 GENERATION-------------------------------------------
      ETA1   = DBLE(RNF100(1))
      W2     = (W2MAX/W2MIN)**ETA1*W2MIN
      W      = DSQRT(W2)
      O2     = W2/4.D0
      O      = W /2.D0
C--------Y GENERATION--------------------------------------------
      XK0MIN = W
      XK0MAX = 1.D0-XM2+O2
      IF (IY.EQ.-1) XK0MIN = (4.D0-4.D0*XM+W2)/(4.D0-2.D0*XM)
      ETA2   = DBLE(RNF100(2))
      HXK0   = ((W2*(1.D0-XK0MAX+O2)+XK0MAX*(1.D0-CMAX))
     .         /(W2*(1.D0-XK0MIN+O2)+XK0MIN*(1.D0-CMAX)))**ETA2
     .         *(W2*(1.D0-XK0MIN+O2)+XK0MIN*(1.D0-CMAX))
      XK0    = (HXK0-W2*(1.D0+O2))/(1.D0-CMAX-W2)
      XKV2   = XK0*XK0 - W2
      XKV    = SQRT(XKV2)
      XKM    = 2.D0 - XK0
      XKH    = 2.D0*XK0 - W2
      Y      = 1.D0-XK0+O2
C--------CK GENERATION--------------------------------------------
      ETA3   = DBLE(RNF100(3))
      VK     = ((1.D0+4.D0*XKV/(W2*Y))**ETA3-1.D0)*0.5D0*W2*Y/XKV
      CK     = 1.D0 - VK
      SK     = SQRT(VK*(2.D0-VK))
C--------CTP GENERATION-------------------------------------------
      ETA4   = DBLE(RNF100(4))
      CTP    = 1.D0-((1.D0-CMIN)/(1.D0-CMAX))**ETA4*(1.D0-CMAX)
      STP    = SQRT(1.D0-CTP*CTP)
      VP     = 1.D0-CTP
C--------COS(PHIP+PHIK) GENERATION--------------------------------
      ACO    = XKH-2.D0*XKV*CK*CTP
      BCO    = 2.D0*XKV*SK*STP
      DCO    = SQRT(ACO*ACO-BCO*BCO)
      ETA5   = 2.D0*DBLE(RNF100(5))-1.D0
      ETA    = ABS(ETA5)
      HCAZ   = (DCO*DTAN(0.5D0*PI*ETA+DATAN((ACO+BCO)/DCO))-BCO)
     .        /ACO
      CAZ    = 2.D0*HCAZ/(HCAZ*HCAZ+1.D0)
      SAZ    = DSIGN(1.D0,ETA5)*DSQRT(1.D0-CAZ*CAZ)
C-----AZIMUTHAL ANGLE GENERATION----------------------------------
      ETA6   = DBLE(RNF100(6))
      PHIK   = TWOPI*ETA5
      CPK    = DCOS(PHIK)
      SPK    = DSIN(PHIK)
C-----CALCULATION COS ANISOTROPY ANGLE----------------------------
      CAS    = (-4.D0*Y*Y+XM2*XKM*XKM)/(XM2*XKV2)
      CA     = 1.D0
      IF (CAS.GT.0.D0) CA = -DSQRT(CAS)
C-----CALCULATION COS(ANGLE BETWEEN QK AND QP)--------------------
      ZMP    = VK + VP - VK*VP + SK*STP*CAZ
      ZM     = ZMP - 1.D0
      IF (ZM.GT.CA) GOTO 200
      DISC   = DSQRT(4.D0*Y*Y-4.D0*Y*XM2-XM2*XKV2*ZMP*(1.D0-ZM))
C-----CALCULATION ENERGY POSITRON---------------------------------
      IF (IY.EQ.-1) GOTO 103
      X      = (2.D0*XKM*Y-XKV*ZM*DISC)/(4.D0*Y+XKV2*ZMP*(1.D0-ZM))
      GOTO 104
  103 CONTINUE
      IF (ZM.GT.0.D0) PRINT 110,ZM
  110 FORMAT(' $$$WARNING$$$ : ZM > 0 : ZM = ',D19.6)
      X      = (4.D0*Y*Y+XM2*XKV2*ZM*ZM)/
     .         (2.D0*XKM*Y-XKV*ZM*DISC)
  104 CONTINUE
      IF (X.LT.XM) PRINT 105,X,DISC,XK0,XKV,W2,ZM,CAS,CA
  105 FORMAT(' ####WARNING#### : X < XMIN '/
     .       ' X     = ',D19.6,7X,'DISC  = ',D19.6/
     .       ' XK0   = ',D19.6,7X,'XKV   = ',D19.6/
     .       ' W2    = ',D19.6,7X,'ZM    = ',D19.6/
     .       ' CAS   = ',D19.6,7X,'CA    = ',D19.9)
      IF (X.GT.1.D0-XM*O-O2) PRINT 106,X,DISC,XK0,XKV,W2,ZM,CAS,CA
  106 FORMAT(' ####WARNING#### : X > XMAX '/
     .       ' X     = ',D19.6,7X,'DISC  = ',D19.6/
     .       ' XK0   = ',D19.6,7X,'XKV   = ',D19.6/
     .       ' W2    = ',D19.6,7X,'ZM    = ',D19.6/
     .       ' CAS   = ',D19.6,7X,'CA    = ',D19.6)
      XV     = DSQRT(X*X-XM2)
      ETX    = X + XV
      DE     = 0.5D0/(PB*XV*ET*ETX)*XM2*(ETX-ET)**2
C------------------------------------------------------------------
      CPP    = CAZ*CPK - SAZ*SPK
      SPP    = SAZ*CPK + CAZ*SPK
C--------CONSTRUCTION OF THE 4MOMENTA------------------------------
      QKE    = XK0
      QKX    = XKV*SK*CPK
      QKY    = XKV*SK*SPK
      QKZ    = XKV*CK
      QP(1)  =  XV*STP*CPP
      QP(2)  =  XV*STP*SPP
      QP(3)  = -XV*CTP
      QP(4)  =  X
      QM(1)  = -QP(1) - QKX
      QM(2)  = -QP(2) - QKY
      QM(3)  = -QP(3) - QKZ
      QM(4)  = -QP(4) - QKE + 2.D0
C--------GENERATION OF MUON PAIR IN ITS CM SYSTEM-------------------
      ETA7   = DBLE(RNF100(7))
      CMU    = 2.D0*ETA7-1.D0
      SMU    = SQRT(1.D0-CMU*CMU)
      ETA8   = DBLE(RNF100(8))
      PHIM   = TWOPI*ETA8
      CPMU   = DCOS(PHIM)
      SPMU   = DSIN(PHIM)
      EKCM   = O
      PKCM   = SQRT(EKCM*EKCM-XMU2)
      PXCM   = PKCM*SMU*CPMU
      PYCM   = PKCM*SMU*SPMU
      PZCM   = PKCM*CMU
C--------BOOST BACK TO LABORATORY SYSTEM--------------------------
      PM(4)  = (QKE*EKCM+QKX*PXCM+QKY*PYCM+QKZ*PZCM)/W
      FAC    = (PM(4)+EKCM)/(QKE+W)
      PM(1)  = PXCM + FAC*QKX
      PM(2)  = PYCM + FAC*QKY
      PM(3)  = PZCM + FAC*QKZ
      PP(1)  = QKX  - PM(1)
      PP(2)  = QKY  - PM(2)
      PP(3)  = QKZ  - PM(3)
      PP(4)  = QKE  - PM(4)
C-------------------------------------------------------------------
      DO 5 I = 1,4
      QMB(I) = -QM(I)
      QPB(I) = -QP(I)
      PMB(I) = -PM(I)
      PPB(I) = -PP(I)
    5 CONTINUE
      T1     =  2.D0*XM2-2.D0*DOT(P1,QM)
      T2     = -2.D0*XV*PB*(VP+DE)
      DD3    =  4.D0*(1.D0-X)
      DD4    =  4.D0*W2*Y/(W2-2.D0*XK0-2.D0*XKV)-2.D0*XM2*XKV/ET
     .         -2.D0*PB*XKV*VK
      DD5    =  4.D0*(1.D0-QM(4))
      DD6    =  4.D0*W2*Y/(W2-2.D0*XK0-2.D0*XKV)-2.D0*XM2*XKV/ET
     .         -2.D0*PB*XKV*(1.D0+CK)
C--------CALCULATION OF 1/4(SPIN SUM)/M/**2--------------------------
C
C--------THE CONTRIBUTION OF THE BREMSSTRAHLUNG ON THE---------------
C--------ELECTRON LINE IS CALCULATED---------------------------------
C
      U1     = W2
      U2     = T2
      U3     = T1
      U4     = DD3
      U5     = DD4
      U6     = 0.D0
      U7     = 0.D0
      U8     = PPB(4) - PM(4)
      U9     = P2(4)  - QP(4)
      XMB1   = DIAG2(PPB, PM,XMU, P2, QP, XM, QM,P1B,XM ,IDUMP)
C
C--------THE CONTRIBUTION OF THE BREMSSTRAHLUNG ON THE---------------
C--------POSITRON LINE IS CALCULATED---------------------------------
C
      U1     = T1
      U2     = W2
      U3     = T2
      U4     = DD5
      U5     = DD6
      U6     = 0.D0
      U7     = 0.D0
      U8     = P1(4)  - QM(4)
      U9     = PMB(4) - PP(4)
      XMB2   = DIAG2( P1, QM, XM,PMB, PP,XMU,P2B, QP,XM ,IDUMP)
C
C--------CALCULATION OF THE INTERFERENCE BETWEEN BREMSSTRAHLUNG------
C--------DIAGRAMS ON THE ELECTRON AND POSITRON LINE------------------
C
      U1     = T1
      U2     = T2
      U3     = W2
      U4     = DD3
      U5     = DD4
      U6     = DD5
      U7     = DD6
      U8     = 0.D0
      U9     = 0.D0
      XMB3   = DIAG4( P1, QM, XM, P2, QP, XM, PM, PP,XMU)
C
      XME(2) = XMB1 + XMB2 + XMB3
C
C
      WE0    = (XMB1+XMB2+XMB3)/(XMB1+XMB2)
      WE1    = XMB1*W2*T2*DD3*DD4/512.D0
      WE2    = XV/((1.D0-X)*DABS(2.D0*XKM*XV+2.D0*X*XKV*ZM))*
     .         (4.D0*Y*W2/(XKH+2.D0*XKV)+2.D0*XKV*ZMP)
      WE3    = -2.D0*XKV*(VK+0.5D0*W2*Y/XKV)/DD4
      WE4    = -2.D0*XV*VP/T2
      WE5    = (W2*Y+XK0*(1.D0-CMAX))/DCO
      WE6    = DLOG(1.D0+4.D0*XKV/(W2*Y))/XLB1
      WE7    = DLOG((W2*(1.D0-XK0MAX+O2)+XK0MAX*(1.D0-CMAX))
     .             /(W2*(1.D0-XK0MIN+O2)+XK0MIN*(1.D0-CMAX)))
     .        *(1.D0-CMAX)/(XLB2(IYY)*(1.D0-CMAX-W2))
      WE8    = DSQRT(1.D0-4.D0*XMU2/W2)
C
      CALL HISTO1(3,8HWE0     ,20,0.D0,2.D0,WE0,1.D0)
      CALL HISTO1(4,8HWE1     ,20,0.D0,2.D0,WE1,1.D0)
      CALL HISTO1(5,8HWE2     ,20,0.D0,2.D0,WE2,1.D0)
      CALL HISTO1(6,8HWE3     ,20,0.D0,2.D0,WE3,1.D0)
      CALL HISTO1(7,8HWE4     ,20,0.D0,2.D0,WE4,1.D0)
      CALL HISTO1(8,8HWE5     ,20,0.D0,2.D0,WE5,1.D0)
      CALL HISTO1(9,8HWE6     ,20,0.D0,2.D0,WE6,1.D0)
      CALL HISTO1(10,8HWE7     ,20,0.D0,2.D0,WE7,1.D0)
      CALL HISTO1(11,8HWE8     ,20,0.D0,2.D0,WE8,1.D0)
C
      DO 199 I=1,4
      WEIGHT(I) = 0.D0
  199 CONTINUE
C
      WEIGHT(2) = WE0*WE1*WE2*WE3*WE4*WE5*WE6*WE7*WE8/WBP(2)
      WEEV      = WEIGHT(2)
C
      IF (WEIGHT(2).GE.0.D0) GOTO 201
      IFAIL(2)  = IFAIL(2) + 1
      INEG      = INEG + 1
      IDUMP     = 5
      GOTO 201
  200 CONTINUE
      OUTFL(2)  = .TRUE.
      RETURN
  201 CONTINUE
C
C--------SYMMETRIZATION----------------------------------------------
      IF (RNDM(DUMMY).LT.0.5) GOTO 9
      ICHG(2) = 1
      IPROB2  = IPROB2 + 1
      PH(4)  =  QP(4)
      QP(4)  =  QM(4)
      QM(4)  =  PH(4)
      DO 10 I=1,3
      PH(I)  =  QP(I)
      QP(I)  = -QM(I)
      QM(I)  = -PH(I)
      PM(I)  = -PM(I)
      PP(I)  = -PP(I)
   10 CONTINUE
      GOTO 8
    9 CONTINUE
      ICHG(2) = 0
      IPROB1 = IPROB1 + 1
    8 CONTINUE
C
C-----START DUMP INFORMATION---------------------------------------
      IF (WEEV.GE.0.D0) GOTO 1081
      PRINT 1080,WEIGHT(2)
 1080 FORMAT(' $$$WARNING$$$ : WEIGHT < 0 : WEIGHT = ',D30.20)
 1081 CONTINUE
      IF (IDUMP.LT.1) RETURN
      PRINT 1079
 1079 FORMAT ('0---------INFORMATION ON WEIGHTS------------------')
      PRINT 1082,XME(2),WEEV
 1082 FORMAT('0XME = ',D30.20,2X,' WEIGHT(2) = ',D30.20)
      IF (IDUMP.LT.2) RETURN
      PRINT 1083
 1083 FORMAT ('0----------INFORMATION ON ANGLES AND ENERGIES-----')
      PRINT 1084,W2,W,Y,XK0,XKM,XKV,VK,CK,X,XV,VP,CTP,ZM,ZMP,
     .           Z,ZV,ZP,VM,DD3,DD4,DD5,DD6,T1,T2,XMB1,XMB2,
     .           XMB3,XMBP1,XMBP2,IYY,IZZ
 1084 FORMAT(' W2   = ',D30.20,7X,'W     = ',D30.20/
     .       ' Y    = ',D30.20,7X,'XK0   = ',D30.20/
     .       ' XKM  = ',D30.20,7X,'XKV   = ',D30.20/
     .       ' VK   = ',D30.20,7X,'CK    = ',D30.20/
     .       ' X    = ',D30.20,7X,'XV    = ',D30.20/
     .       ' VP   = ',D30.20,7X,'CTP   = ',D30.20/
     .       ' ZM   = ',D30.20,7X,'ZMP   = ',D30.20/
     .       ' Z    = ',D30.20,7X,'ZV    = ',D30.20/
     .       ' ZP   = ',D30.20,7X,'VM    = ',D30.20/
     .       ' DD3  = ',D30.20,7X,'DD4   = ',D30.20/
     .       ' DD5  = ',D30.20,7X,'DD6   = ',D30.20/
     .       ' T1   = ',D30.20,7X,'T2    = ',D30.20/
     .       ' XMB1 = ',D30.20,7X,'XMB2  = ',D30.20/
     .       ' XMB3 = ',D30.20/
     .       ' XMBP1= ',D30.20,7X,'XMBP2 = ',D30.20/
     .       ' IYY  = ',I9    ,2X,'IZZ   = ',I9    )
      IF (IDUMP.LT.3) RETURN
      PRINT 999
  999 FORMAT('0--------INFORMATION ON COMMON BLOCKS--------------')
      PRINT 1008,W2MIN,W2MAX,S1MIN,S1MAX,VMIN,VMAX
 1008 FORMAT(' COMMON BOUND CONTAINS '/2(1X,3(D35.25,2X)/))
      PRINT 1007,XM,XM2,XMU,XMU2,ALFA,BARN,PI,TWOPI
 1007 FORMAT(' COMMON CONST CONTAINS '/2(1X,3(D35.25,2X)/),
     .       1X,2(D35.25,2X))
      PRINT 1101,U1,U2,U3
 1101 FORMAT(' COMMON DIAG CONTAINS '/1X,3(D30.20,2X))
      PRINT 1102,XLB1,XLB2,SAPB
 1102 FORMAT(' COMMON GENB CONTAINS '/1X,3(D30.20,2X)/
     .       1X,2(D30.20,2X))
      PRINT 1103,PB,ET,EP
 1103 FORMAT(' COMMON INIT CONTAINS '/1X,2(D30.20,2X)/
     .       1X,3(D30.20,2X))
      PRINT 1002,EB,ESWE,WAP
 1002 FORMAT(' COMMON INPUT CONTAINS '/1X,2(D30.20,2X)/
     .       1X,4(D30.20,2X))
      PRINT 1104,OUTFL
 1104 FORMAT(' COMMON LOG CONTAINS '/1X,4L9)
      PRINT 1105,XME
 1105 FORMAT(' COMMON MATRIX CONTAINS '/1X,4(D30.20,2X))
      PRINT 1106,SAP
 1106 FORMAT(' COMMON SAP CONTAINS '/1X,4(D30.20,2X))
      PRINT 1003,P1B,P2B,QMB,QPB,PMB,PPB
 1003 FORMAT(' COMMON VECTOB CONTAINS'/6(1X,4(D30.20,2X)/))
      PRINT 1004,P1,P2,QM,QP,PM,PP
 1004 FORMAT(' COMMON VECTOR CONTAINS '/6(1X,4(D30.20,2X)/))
      PRINT 1001,IFAIL,IACC,INUL,ICHG,INEG,IONE,IZERO
 1001 FORMAT(' COMMON WECOUN CONTAINS '/4(1X,4(I9,2X)/)/
     .       1X,3(I9,2X))
      PRINT 1005,WEIGHT,WEEV,IEVACC
 1005 FORMAT(' COMMON WEIGHT CONTAINS '/1X,4(D30.20,2X)/
     .       1X,D30.20,2X,I9)
      PRINT 1000,SWE,SWEK,MWE,SUM,SUMK,MAXWE,IWE,IGEN
 1000 FORMAT(' COMMON WESTAT CONTAINS '/3(1X,4(D30.20,2X)/),
     .       1X,3(D30.20,2X)/1X,5(I9,2X))
      IF (IDUMP.LT.4) RETURN
      PRINT 1009
 1009 FORMAT('0-------------INFORMATION ON KINEMATICS-----------')
 
      XPOS = QP(4)**2-QP(1)**2-QP(2)**2-QP(3)**2-XM2
      XELE = QM(4)**2-QM(1)**2-QM(2)**2-QM(3)**2-XM2
      XMUP = PP(4)**2-PP(1)**2-PP(2)**2-PP(3)**2-XMU2
      XMUM = PM(4)**2-PM(1)**2-PM(2)**2-PM(3)**2-XMU2
      XW   = QKE**2-QKX**2-QKY**2-QKZ**2-W2
      PRINT 1010,XPOS,XELE,XMUP,XMUM,XW
 1010 FORMAT(' QP**2        = ',D35.25,' QM**2-XM2     = ',D35.25/
     .       ' PP**2-XMU2   = ',D35.25,' PM**2-XMU2    = ',D35.25/
     .       ' (PM+PP)**2-W2= ',D35.25)
      SUMX = QM(1)+QP(1)+PM(1)+PP(1)
      SUMY = QM(2)+QP(2)+PM(2)+PP(2)
      SUMZ = QM(3)+QP(3)+PM(3)+PP(3)
      SUME = 2-QM(4)-QP(4)-PM(4)-PP(4)
      PRINT 1011,SUMX,SUMY,SUMZ,SUME
 1011 FORMAT(' SUM X COMPONENTS   = ',D35.25,
     .       ' SUM Y COMPONENTS   = ',D35.25/
     .       ' SUM Z COMPONENTS   = ',D35.25,
     .       ' 2-SUM E COMPONENTS = ',D35.25)
      IF (IDUMP.LT.5) RETURN
      PRINT 2999
 2999 FORMAT('0---------INFORMATION ON RANDOM NUMBERS------------')
      PRINT 3001,ETA1
 3001 FORMAT(' RANDOM NUMBER (W2)                = ',D35.25)
      PRINT 3002,ETA2
 3002 FORMAT(' RANDOM NUMBER (Y)                 = ',D35.25)
      PRINT 3003,ETA3
 3003 FORMAT(' RANDOM NUMBER (CK)                = ',D35.25)
      PRINT 3004,ETA4
 3004 FORMAT(' RANDOM NUMBER (FEYNMAN PARAMETER) = ',D35.25)
      PRINT 3005,ETA5
 3005 FORMAT(' RANDOM NUMBER (PHIR)              = ',D35.25)
      PRINT 3006,ETA6
 3006 FORMAT(' RANDOM NUMBER (CTG)               = ',D35.25)
      PRINT 3007,ETA7
 3007 FORMAT(' RANDOM NUMBER (PHIK)              = ',D35.25)
      PRINT 3008,ETA8
 3008 FORMAT(' RANDOM NUMBER (CMU)               = ',D35.25)
      PRINT 3009,ETA9
 3009 FORMAT(' RANDOM NUMBER (PHIM)              = ',D35.25)
      RETURN
      END
      SUBROUTINE MCC(IPROC,IDEC,IDUMP)
C... CONVERSION SUBGENERATOR
C
C... COMMON /MATRIX / CONTAINS :
C            XME(3) = EXACT CONVERSION /MATRIX ELEMENT/**2
C... COMMON /DIAG   / CONTAINS :
C            CALCULATED PHOTON PROPAGATORS AND INVARIANT MASS**2 MUON
C            THESE VALUES ARE USED IN FUNCTION DIAG2
C
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON /CHARGE/ QCHARG,QCHRG2,QCHRG3,QCHRG4
      COMMON /CONST / ALFA,BARN,PI,TWOPI
      COMMON /DIAG  / U1,U2,U3,U4,U5,U6,U7,U8,U9
      COMMON /EDGE  / WDMIN,WDMAX,SDMIN,SDMAX
      COMMON /GENC  / XLC1(4),XLC2(4),SA3(4),EA3(3)
      COMMON /INIT  / PB,ET,EP(3),ECH(3)
      COMMON /INPUT / EB,THMIN,THMAX,ESWE,ESFT,WAP(4),WBP(4),VAP(4)
      COMMON /LOGCM / OUTFL(4)
      COMMON /MASSES/ XM,XMU,XML,XM2,XMU2,XML2
      COMMON /MATRIX/ XME(4)
      COMMON /PROSTA/ PROP1,PROP2,PROP3,PROP4
      COMMON /SAP   / SAP(4),SAPT
      COMMON /SELECT/ IC,ICH
      COMMON /VECTOR/ P1(4),P2(4),QM(4),QP(4),PM(4),PP(4)
      COMMON /VECTOB/ P1B(4),P2B(4),QMB(4),QPB(4),PMB(4),PPB(4)
      COMMON /WEIGHC/ WEIGHT(4),WEEV,IEVACC
      COMMON /WECOUN/ IFAIL(4),IACC(4),INUL(4),ICHG(4),
     .                INEG,IONE,IZERO
      COMMON /WESTAT/ SWE(4),SWEK(4),MWE(4),SUM,SUMK,MAXWE,IWE(4),IGEN
      COMMON /ZPAR  / AMZ,AMZ2,GZ,AMG,AMG2,CV,CA,CVU,CAU,CVD,CAD
      DIMENSION APW(4),BPW(4),CPW(4)
      LOGICAL OUTFL
      REAL*8 MWE,MAXWE
      REAL*4 RNF100
      OUTFL(3) = .FALSE.
      GOTO (10000,20000,30000,40000),IDEC
C--------W2 GENERATION----------------------------------------------
10000 CONTINUE
      ETA1   = DBLE(RNF100(1))
      HW2    = (WDMAX*(4.D0-WDMIN)/(WDMIN*(4.D0-WDMAX)))**ETA1*
     .          WDMIN/(4.D0-WDMIN)
      W2     = 4.D0*HW2/(1.D0+HW2)
      W      = DSQRT(W2)
      O2     = W2/4.D0
      O      = W /2.D0
C--------S1 GENERATION----------------------------------------------
      S1MIN  = 4.D0*XML2
      S1MAX  = (2.D0 - W)*(2.D0 - W)
      ETA2   = DBLE(RNF100(2))
      HS1    = (S1MAX*(4.D0-W2-S1MIN)/(S1MIN*(4.D0-W2-S1MAX)))**ETA2
     .         *S1MIN/(4.D0-W2-S1MIN)
      S1     = HS1*(4.D0-W2)/(HS1+1.D0)
      WS1    = DSQRT(S1)
      APW(1) = 32.D0/(W2*S1)
      BPW(1) = DLOG(S1MAX*(4.D0-W2-S1MIN)/(S1MIN*(4.D0-W2-S1MAX)))
      CPW(1) = 1.D0
      GOTO 50000
20000 CONTINUE
      SXMAX  = SDMAX-AMZ2
      SXMIN  = SDMIN-AMZ2
      AA     = 1.D0/((4.D0-AMZ2)**2+AMG2)
      BB     = (4.D0-AMZ2)*AA
      IF (BB.LT.0.D0) BB=0.D0
      AR1    = AA*DLOG((4.D0-SDMIN)/(4.D0-SDMAX))
      SHMAX  = 0.D0
      IF(SXMAX.GT.0.D0) SHMAX=SXMAX
      SHMIN  = DMAX1(0.D0,SXMIN)
      AR2    = AA/2.D0*DLOG((SHMAX**2+AMG2)/(SHMIN**2+AMG2))
      AR3    = BB/AMG*(DATAN(SXMAX/AMG)-DATAN(SXMIN/AMG))
      ART    = AR1+AR2+AR3
      IF (AR1.LT.0.D0.OR.AR2.LT.0.D0.OR.AR3.LT.0.D0)
     .         PRINT 222,AR1,AR2,AR3
  222 FORMAT(' $$$$WARNING$$$$ AR1 OR AR2 OR AR3 < 0'/
     .       ' AR1 AR2 AR3 : ',3(D15.4,2X))
   20 CONTINUE
      ETA0   = DBLE(RNF100(12))
      IF (ETA0.GT.(AR1+AR2)/ART) GOTO 21
      IF (ETA0.GT.AR1/ART      ) GOTO 22
      ETA1   = DBLE(RNF100(1))
      S1     = 4.D0 - ((4.D0-SDMAX)/(4.D0-SDMIN))**ETA1*(4.D0-SDMIN)
      GOTO 23
   21 CONTINUE
      ETA1   = DBLE(RNF100(1))
      S1     = AMZ2+AMG*DTAN(ETA1*DATAN(SXMAX/AMG)+
     .                       (1.D0-ETA1)*DATAN(SXMIN/AMG))
      GOTO 23
   22 CONTINUE
      ETA1   = DBLE(RNF100(1))
      HS1    = ((SHMAX**2+AMG2)/(SHMIN**2+AMG2))**ETA1*(SHMIN**2+AMG2)
     .         -AMG2
      S1     = DSQRT(HS1)+AMZ2
   23 CONTINUE
      S1Z    = S1-AMZ2
      S1H    = DMAX1(S1Z,0.D0)
      WES1   = 1.D0/((4.D0-S1)*(S1Z**2+AMG2))/
     .         (AA/(4.D0-S1)+AA*S1H/(S1Z**2+AMG2)+BB/(S1Z**2+AMG2))
      ETA2   = DBLE(RNF100(2))
      CALL HISTO1(20,8HWES1 MCC,20,0.D0,2.D0,WES1,1.D0)
      IF (ETA2.GT.WES1) GOTO 20
      WS1    = DSQRT(S1)
C--------W2 GENERATION----------------------------------------------
      W2MIN  = 4.D0*XMU2
      W2MAX  = (2.D0-WS1)*(2.D0-WS1)
      ETA3   = DBLE(RNF100(3))
      HW2    = (W2MAX*(4.D0-W2MIN-S1)/(W2MIN*(4.D0-W2MAX-S1)))**ETA3*
     .         W2MIN/(4.D0-W2MIN-S1)
      W2     = HW2*(4.D0-S1)/(1.D0+HW2)
      W      = DSQRT(W2)
      O2     = W2/4.D0
      O      = W /2.D0
      APW(2) = 32.D0/((S1Z**2+AMG2)*W2)
      BPW(2) = DLOG(W2MAX*(4.D0-W2MIN-S1)/(W2MIN*(4.D0-W2MAX-S1)))
      CPW(2) = S1**2/(S1Z**2+AMG2)
      GOTO 50000
30000 CONTINUE
      WXMAX  = WDMAX-AMZ2
      WXMIN  = WDMIN-AMZ2
      AA     = 1.D0/((4.D0-AMZ2)**2+AMG2)
      BB     = (4.D0-AMZ2)*AA
      IF (BB.LT.0.D0) BB=0.D0
      BR1    = AA*DLOG((4.D0-WDMIN)/(4.D0-WDMAX))
      WHMAX  = 0.D0
      IF(WXMAX.GT.0.D0) WHMAX=WXMAX
      WHMIN  = DMAX1(0.D0,WXMIN)
      BR2    = AA/2.D0*DLOG((WHMAX**2+AMG2)/(WHMIN**2+AMG2))
      BR3    = BB/AMG*(DATAN(WXMAX/AMG)-DATAN(WXMIN/AMG))
      BRT    = BR1+BR2+BR3
      IF (BR1.LT.0.D0.OR.BR2.LT.0.D0.OR.BR3.LT.0.D0)
     .         PRINT 333,BR1,BR2,BR3
  333 FORMAT(' $$$$WARNING$$$$ BR1 OR BR2 OR BR3 < 0'/
     .       ' BR1 BR2 BR3 : ',3(D15.4,2X))
   30 CONTINUE
      ETA0   = RNF100(12)
      IF (ETA0.GT.(BR1+BR2)/BRT) GOTO 31
      IF (ETA0.GT.BR1/BRT      ) GOTO 32
      ETA1   = RNF100(1)
      W2     = 4.D0 - ((4.D0-WDMAX)/(4.D0-WDMIN))**ETA1*(4.D0-WDMIN)
      GOTO 33
   31 CONTINUE
      ETA1   = RNF100(1)
      W2     = AMZ2+AMG*DTAN(ETA1*DATAN(WXMAX/AMG)+
     .                       (1.D0-ETA1)*DATAN(WXMIN/AMG))
      GOTO 33
   32 CONTINUE
      ETA1   = RNF100(1)
      HW2    = ((WHMAX**2+AMG2)/(WHMIN**2+AMG2))**ETA1*(WHMIN**2+AMG2)
     .         -AMG2
      W2     = DSQRT(HW2)+AMZ2
   33 CONTINUE
      W2Z    = W2-AMZ2
      W2H    = DMAX1(W2Z,0.D0)
      WEW2   = 1.D0/((4.D0-W2)*(W2Z**2+AMG2))/
     .         (AA/(4.D0-W2)+AA*W2H/(W2Z**2+AMG2)+BB/(W2Z**2+AMG2))
      ETA2   = RNF100(2)
      CALL HISTO1(19,8HWEW2 MCC,20,0.D0,2.D0,WEW2,1.D0)
      IF (ETA2.GT.WEW2) GOTO 30
      W      = DSQRT(W2)
      O2     = W2/4.D0
      O      = W /2.D0
C--------S1 GENERATION----------------------------------------------
      S1MIN  = 4.D0*XML2
      S1MAX  = (2.D0 - W)*(2.D0 - W)
      ETA2   = RNF100(2)
      HS1    = (S1MAX*(4.D0-W2-S1MIN)/(S1MIN*(4.D0-W2-S1MAX)))**ETA2
     .         *S1MIN/(4.D0-W2-S1MIN)
      S1     = HS1*(4.D0-W2)/(HS1+1.D0)
      WS1    = DSQRT(S1)
      APW(3) = 32.D0/((W2Z**2+AMG2)*S1)
      BPW(3) = DLOG(S1MAX*(4.D0-W2-S1MIN)/(S1MIN*(4.D0-W2-S1MAX)))
      CPW(3) = W2**2/(W2Z**2+AMG2)
      GOTO 50000
40000 CONTINUE
      WXMAX  = WDMAX-AMZ2
      WXMIN  = WDMIN-AMZ2
      WYMAX  = 4.D0-AMZ2-WDMIN
      WYMIN  = 4.D0-AMZ2-WDMAX
      IF (AMZ2.EQ.2.D0) GOTO 45
      AA     = 1.D0/((4.D0-2.D0*AMZ2)**2+4.D0*AMG2)
      CR1    = AA/AMG*(DATAN(WXMAX/AMG)-DATAN(WXMIN/AMG))
      CR2    = AA/AMG*(DATAN(WYMAX/AMG)-DATAN(WYMIN/AMG))
      BB     = 2.D0/(4.D0-2.D0*AMZ2)
      WHP    = 0.D0
      WIP    = 0.D0
      WHM    = 0.D0
      WIM    = 0.D0
      IF (BB.LE.0.D0) GOTO 51
      IBP    = 1
      IF(WXMAX.GT.0.D0) WHP=WXMAX
      IF(WYMAX.GT.0.D0) WIP=WYMAX
      WHM    = DMAX1(0.D0,WXMIN)
      WIM    = DMAX1(0.D0,WYMIN)
      GOTO 52
   51 CONTINUE
      IBP    = -1
      IF(WXMIN.LT.0.D0) WHM=WXMIN
      IF(WYMIN.LT.0.D0) WIM=WYMIN
      WHP    = DMIN1(0.D0,WXMAX)
      WIP    = DMIN1(0.D0,WYMAX)
   52 CONTINUE
      CR3    = AA*BB/2.D0*DLOG((WHP**2+AMG2)/(WHM**2+AMG2))
      CR4    = AA*BB/2.D0*DLOG((WIP**2+AMG2)/(WIM**2+AMG2))
      CRT    = CR1+CR2+CR3+CR4
      IF (CR1.LT.0.D0.OR.CR2.LT.0.D0.OR.CR3.LT.0.D0.OR.CR4.LT.0.D0)
     .         PRINT 444,CR1,CR2,CR3,CR4
  444 FORMAT(' $$$$WARNING$$$$ CR1 OR CR2 OR CR3 CR4 < 0'/
     .       ' CR1 CR2 CR3 CR4 : ',4(D15.4,2X))
   40 CONTINUE
      ETA0   = RNF100(12)
      IF (ETA0.GT.(CR1+CR2+CR3)/CRT) GOTO 41
      IF (ETA0.GT.(CR1+CR2)/CRT    ) GOTO 42
      IF (ETA0.GT.CR1/CRT          ) GOTO 43
      ETA1   = RNF100(1)
      WX     = AMG*DTAN(ETA1*DATAN(WXMAX/AMG)+
     .                  (1.D0-ETA1)*DATAN(WXMIN/AMG))
      W2     = WX+AMZ2
      GOTO 44
   41 CONTINUE
      ETA1   = RNF100(1)
      HWY    = ((WIP**2+AMG2)/(WIM**2+AMG2))**ETA1*(WIM**2+AMG2)-AMG2
      W2     = 4.D0-AMZ2-DSQRT(HWY)*DFLOAT(IBP)
      GOTO 44
   42 CONTINUE
      ETA1   = RNF100(1)
      HWX    = ((WHP**2+AMG2)/(WHM**2+AMG2))**ETA1*(WHM**2+AMG2)-AMG2
      W2     = DSQRT(HWX)*DFLOAT(IBP)+AMZ2
      GOTO 44
   43 CONTINUE
      ETA1   = RNF100(1)
      WY     = AMG*DTAN(ETA1*DATAN(WYMAX/AMG)+
     .                  (1.D0-ETA1)*DATAN(WYMIN/AMG))
      W2     = 4.D0-AMZ2-WY
   44 CONTINUE
      W2X    = W2-AMZ2
      W2Y    = 4.D0-AMZ2-W2
      IF (IBP.EQ.-1) GOTO 53
      W2H    = DMAX1(W2X,0.D0)
      W2I    = DMAX1(W2Y,0.D0)
      GOTO 54
   53 CONTINUE
      W2H    = DMIN1(W2X,0.D0)
      W2I    = DMIN1(W2Y,0.D0)
   54 CONTINUE
      WEW2   = 1.D0/((W2X**2+AMG2)*(W2Y**2+AMG2))/
     .         (AA/(W2X**2+AMG2)+AA*BB*W2H/(W2X**2+AMG2)+
     .          AA/(W2Y**2+AMG2)+AA*BB*W2I/(W2Y**2+AMG2))
      ETA2   = RNF100(2)
      CALL HISTO1(18,8HWEXY MCC,20,0.D0,2.D0,WEW2,1.D0)
      IF (ETA2.GT.WEW2) GOTO 40
      GOTO 46
   45 CONTINUE
      ETA1   = RNF100(1)
      WX     = AMG*DTAN(ETA1*DATAN(WXMAX/AMG)+
     .                  (1.D0-ETA1)*DATAN(WXMIN/AMG))
      W2     = WX+AMZ2
      WEW2   = AMG2/(WX**2+AMG2)
      ETA2   = RNF100(2)
      CALL HISTO1(17,8HWEW2 MCC,20,0.D0,2.D0,WEW2,1.D0)
      IF (ETA2.GT.WEW2) GOTO 45
   46 CONTINUE
      W2X    = W2-AMZ2
      W2Y    = 4.D0-AMZ2-W2
      W      = DSQRT(W2)
      O2     = W2/4.D0
      O      = W /2.D0
C--------S1 GENERATION----------------------------------------------
      S1MIN  = 4.D0*XML2
      S1MAX  = (2.D0-W)*(2.D0-W)
      SYMAX  = S1MAX-AMZ2
      SYMIN  = S1MIN-AMZ2
      AA     = 1.D0/(W2Y**2+AMG2)
      BB     = W2Y*AA
      IF (BB.LT.0.D0) BB=0.D0
      DR1    = AA*DLOG((W2Y-SYMIN)/(W2Y-SYMAX))
      IF (W2Y.LT.SYMIN.OR.W2Y.LT.SYMAX) PRINT 446,W2,W2Y,SYMIN,SYMAX
  446 FORMAT(' $$$$WARNING$$$$ : W2Y < SYMIN OR SYMAX '/
     .       ' W2 W2Y SYMIN SYMAX : ',4(D15.4,2X))
      SHMAX  = 0.D0
      IF(SYMAX.GT.0.D0) SHMAX=SYMAX
      SHMIN  = DMAX1(0.D0,SYMIN)
      DR2    = AA/2.D0*DLOG((SHMAX**2+AMG2)/(SHMIN**2+AMG2))
      DR3    = BB/AMG*(DATAN(SYMAX/AMG)-DATAN(SYMIN/AMG))
      DRT    = DR1+DR2+DR3
      IF (DR1.LT.0.D0.OR.DR2.LT.0.D0.OR.DR3.LT.0.D0)
     .         PRINT 445,DR1,DR2,DR3
  445 FORMAT(' $$$$WARNING$$$$ DR1 OR DR2 OR DR3 < 0'/
     .       ' DR1 DR2 DR3 : ',3(D15.4,2X))
   47 CONTINUE
      ETA0   = RNF100(12)
      IF (ETA0.GT.(DR1+DR2)/DRT) GOTO 48
      IF (ETA0.GT.DR1/DRT      ) GOTO 49
      ETA1   = RNF100(1)
      HS1    = W2Y - ((W2Y-SYMAX)/(W2Y-SYMIN))**ETA1*(W2Y-SYMIN)
      S1     = HS1+AMZ2
      GOTO 50
   48 CONTINUE
      ETA1   = RNF100(1)
      S1     = AMZ2+AMG*DTAN(ETA1*DATAN(SYMAX/AMG)+
     .                       (1.D0-ETA1)*DATAN(SYMIN/AMG))
      GOTO 50
   49 CONTINUE
      ETA1   = RNF100(1)
      HS1    = ((SHMAX**2+AMG2)/(SHMIN**2+AMG2))**ETA1*(SHMIN**2+AMG2)
     .         -AMG2
      S1     = DSQRT(HS1)+AMZ2
   50 CONTINUE
      S1Y    = S1-AMZ2
      S1H    = DMAX1(S1Y,0.D0)
      WES1   = 1.D0/((W2Y-S1Y)*(S1Y**2+AMG2))/
     .         (AA/(W2Y-S1Y)+AA*S1H/(S1Y**2+AMG2)+BB/(S1Y**2+AMG2))
      ETA2   = RNF100(2)
      CALL HISTO1(16,8HWES1 MCC,20,0.D0,2.D0,WES1,1.D0)
      IF (ETA2.GT.WES1) GOTO 47
      WS1    = DSQRT(S1)
      APW(4)  = 32.D0/((W2X**2+AMG2)*(S1Y**2+AMG2))
      BPW(4)  = DLOG((W2Y-SYMIN)/(W2Y-SYMAX))+
     .         0.5D0*DLOG((SYMAX**2+AMG2)/(SYMIN**2+AMG2))+
     .         W2Y/AMG*(DATAN(SYMAX/AMG)-DATAN(SYMIN/AMG))
      CPW(4)  = W2**2*S1**2/((W2X**2+AMG2)*(S1Y**2+AMG2))
50000 CONTINUE
C
      IF (W2.LT.WDMIN.OR.W2.GT.WDMAX) PRINT 555,IDEC,W2,S1
  555 FORMAT(' $$$$WARNING$$$$ : W2 OUT OF BOUNDS '/
     .       ' IDEC = ',I2,2X,' W2 = ',D15.4,2X,' S1 = ',D15.4)
      IF (S1.LT.SDMIN.OR.S1.GT.SDMAX) PRINT 556,IDEC,W2,S1
  556 FORMAT(' $$$$WARNING$$$$ : S1 OUT OF BOUNDS '/
     .       ' IDEC = ',I2,2X,' W2 = ',D15.4,2X,' S1 = ',D15.4)
C
      XK0    = 1.D0 + O2 - S1/4.D0
      XKV2   = XK0*XK0-W2
      XKV    = DSQRT(XKV2)
C--------CK GENERATION----------------------------------------------
      AH     = -0.5D0*(4.D0 - W2 - S1)
      XLAM   = (4.D0 - W2 - S1)*(4.D0 - W2 - S1) - 4.D0*W2*S1
      WXLAM  = DSQRT(XLAM)
      BH     =  0.5D0*PB*WXLAM
      ABH    = 0.25D0*(XM2*XLAM+4.D0*W2*S1)/(AH-BH)
      ETA3   = RNF100(3)
      ETA    = 2.D0*ETA3 - 1.D0
      HCK    = (ABH/(AH-BH))**DABS(ETA)
      VK     = (ABH+(BH-AH)*HCK)/(BH*(HCK+1.D0))
      CK     = 1.D0 - VK
      IF (ETA.LT.0.D0) CK = -CK
      SK     = DSQRT(VK*(2.D0-VK))
C--------PHIK GENERATION-------------------------------------------
      ETA4   = RNF100(4)
      PHIK   = TWOPI*ETA4
      CPK    = DCOS(PHIK)
      SPK    = DSIN(PHIK)
C--------CONSTRUCTION 4MOMENTA QM+QK AND PM+PK---------------------
      XKX    = XKV*SK*CPK
      XKY    = XKV*SK*SPK
      XKZ    = XKV*CK
      QE     = 2.D0 - XK0
      QX     = -XKX
      QY     = -XKY
      QZ     = -XKZ
C--------GENERATION ELECTRON AND POSITRON IN THEIR CM SYSTEM-------
      ETA5   = RNF100(5)
      CP     = 2.D0*ETA5 - 1.D0
      SP     = DSQRT(1.D0-CP*CP)
      ETA6   = RNF100(6)
      PHIP   = TWOPI*ETA6
      CPP    = DCOS(PHIP)
      SPP    = DSIN(PHIP)
      EQCM   = 0.5D0*WS1
      PQCM   = DSQRT(EQCM*EQCM-XML2)
      QXCM   = PQCM*SP*CPP
      QYCM   = PQCM*SP*SPP
      QZCM   = PQCM*CP
C--------BOOST BACK TO LABORATORY SYSTEM-------------------------
      QM(4)  = (QE*EQCM+QX*QXCM+QY*QYCM+QZ*QZCM)/WS1
      FACQ   = (QM(4)+EQCM)/(QE+WS1)
      QM(1)  = QXCM  + FACQ*QX
      QM(2)  = QYCM  + FACQ*QY
      QM(3)  = QZCM  + FACQ*QZ
      QP(1)  = QX    - QM(1)
      QP(2)  = QY    - QM(2)
      QP(3)  = QZ    - QM(3)
      QP(4)  = QE    - QM(4)
C--------GENERATION OF MUON PAIR IN ITS CM SYSTEM-------------------
      ETA7   = RNF100(7)
      CMU    = 2.D0*ETA7 - 1.D0
      SMU    = DSQRT(1.D0-CMU*CMU)
      ETA8   = RNF100(8)
      PHIM   = TWOPI*ETA8
      CPMU   = DCOS(PHIM)
      SPMU   = DSIN(PHIM)
      EKCM   = O
      PKCM   = DSQRT(EKCM*EKCM-XMU2)
      PXCM   = PKCM*SMU*CPMU
      PYCM   = PKCM*SMU*SPMU
      PZCM   = PKCM*CMU
C--------BOOST BACK TO LABORATORY SYSTEM--------------------------
      PM(4)  = (XK0*EKCM+XKX*PXCM+XKY*PYCM+XKZ*PZCM)/W
      FACP   = (PM(4)+EKCM)/(XK0+W)
      PM(1)  = PXCM + FACP*XKX
      PM(2)  = PYCM + FACP*XKY
      PM(3)  = PZCM + FACP*XKZ
      PP(1)  = XKX  - PM(1)
      PP(2)  = XKY  - PM(2)
      PP(3)  = XKZ  - PM(3)
      PP(4)  = XK0  - PM(4)
C-------------------------------------------------------------------
      DO 5 I = 1,4
      QMB(I) = -QM(I)
      QPB(I) = -QP(I)
      PMB(I) = -PM(I)
      PPB(I) = -PP(I)
    5 CONTINUE
      DD7    = ABH - BH*VK
      DD8    = AH - BH + BH*VK
      IF (CK.GT.0.D0) GOTO 12
      DDU    = DD7
      DD7    = DD8
      DD8    = DDU
   12 CONTINUE
      PROP1  = S1*W2*DD7
      PROP2  = S1*W2*DD8
      PROP3  = 0.D0
      PROP4  = 0.D0
C
C-----CALCULATION OF 1/4(SPIN SUM) /M/**2----------------------
C
      U1     = S1
      U2     = W2
      U3     = 4.D0
      U4     = DD7
      U5     = DD8
      U6     = 0.D0
      U7     = 0.D0
      U8     = QPB(4) - QM(4)
      U9     = PMB(4) - PP(4)
      XME(3) = DIAG2(QPB, QM,XML,PMB, PP,XMU,P2B,P1B, XM,IDUMP)*
     .         CPW(IDEC)
C
C-----CALCULATTION APPROXIMATION-------------------------------
C
      WE1    = XME(3)*DD7*DD8/APW(IDEC)
      WE2    = (4.D0-W2-S1)*XKV*DLOG(ABH/(AH-BH))/(AH*BH*XLC1(IDEC))*
     .         DSQRT(1.D0-4.D0*XML2/S1)*DSQRT(1.D0-4.D0*XMU2/W2)
      WE3    = BPW(IDEC)/XLC2(IDEC)
      DO 199 I=1,4
      WEIGHT(I) = 0.D0
  199 CONTINUE
C
      WEIGHT(3) = WE1*WE2*WE3/WBP(3)
      WEEV      = WEIGHT(3)
C
      IF (WEIGHT(3).GE.0.D0) GOTO 201
      IFAIL(3)  = IFAIL(3) + 1
      INEG      = INEG + 1
      IDUMP     = 5
  201 CONTINUE
C
      ICH   = 0
C      IF (IPROC.NE.2.AND.IPROC.NE.5) GOTO 305
      IF (IPROC.NE.2.AND.IPROC.NE.5.AND.IPROC.NE.6) GOTO 305
      ETA10 = RNF100(10)
      IF (ETA10.LT.0.5D0) GOTO 305
      CALL CHANGE(QM,PM)
      ICH   = 1
  305 CONTINUE
C
C-----START DUMP INFORMATION---------------------------------------
      IF (WEEV.GE.0.D0) GOTO 1081
      PRINT 1080,WEIGHT(3)
 1080 FORMAT(' $$$WARNING$$$ : WEIGHT < 0 : WEIGHT = ',D30.20)
 1081 CONTINUE
      IF (IDUMP.LT.1) RETURN
      PRINT 1079
 1079 FORMAT ('0---------INFORMATION ON WEIGHTS------------------')
      PRINT 1082,XME(3),WEEV
 1082 FORMAT('0XME = ',D30.20,2X,'WEIGHT = ',D30.20)
      IF (IDUMP.LT.2) RETURN
      PRINT 1083
 1083 FORMAT ('0----------INFORMATION ON ANGLES AND ENERGIES-----')
      PRINT 1084,W2,W,S1,WS1,XK0,XKV,VK,CK,DD7,DD8,XME(3),IDEC
 1084 FORMAT(' W2   = ',D30.20,7X,'W     = ',D30.20/
     .       ' S1   = ',D30.20,7X,'WS1   = ',D30.20/
     .       ' XK0  = ',D30.20,7X,'XKV   = ',D30.20/
     .       ' VK   = ',D30.20,7X,'CK    = ',D30.20/
     .       ' DD7  = ',D30.20,7X,'DD8   = ',D30.20/
     .       ' XME  = ',D30.20,7X,'IDEC  = ',I2)
      IF (IDUMP.LT.3) RETURN
      PRINT 999
  999 FORMAT('0--------INFORMATION ON COMMON BLOCKS--------------')
      PRINT 1007,XM,XM2,XMU,XMU2,ALFA,BARN,PI,TWOPI
 1007 FORMAT(' COMMON CONST CONTAINS '/2(1X,3(D35.25,2X)/),
     .       1X,2(D35.25,2X))
      PRINT 1101,U1,U2,U3
 1101 FORMAT(' COMMON DIAG CONTAINS '/1X,3(D30.20,2X))
      PRINT 1103,PB,ET,EP
 1103 FORMAT(' COMMON INIT CONTAINS '/1X,2(D30.20,2X)/
     .       1X,3(D30.20,2X))
      PRINT 1002,EB,ESWE,WAP
 1002 FORMAT(' COMMON INPUT CONTAINS '/1X,2(D30.20,2X)/
     .       1X,4(D30.20,2X))
      PRINT 1104,OUTFL
 1104 FORMAT(' COMMON LOG CONTAINS '/1X,4L9)
      PRINT 1106,SAP
 1106 FORMAT(' COMMON SAP CONTAINS '/1X,4(D30.20,2X))
      PRINT 1003,P1B,P2B,QMB,QPB,PMB,PPB
 1003 FORMAT(' COMMON VECTOB CONTAINS'/6(1X,4(D30.20,2X)/))
      PRINT 1004,P1,P2,QM,QP,PM,PP
 1004 FORMAT(' COMMON VECTOR CONTAINS '/6(1X,4(D30.20,2X)/))
      PRINT 1001,IFAIL,IACC,INUL,ICHG,INEG,IONE,IZERO
 1001 FORMAT(' COMMON WECOUN CONTAINS '/4(1X,4(I9,2X)/)/
     .       1X,3(I9,2X))
      PRINT 1005,WEIGHT,WEEV,IEVACC
 1005 FORMAT(' COMMON WEIGHT CONTAINS '/1X,4(D30.20,2X)/
     .       1X,D30.20,2X,I9)
      PRINT 1000,SWE,SWEK,MWE,SUM,SUMK,MAXWE,IWE,IGEN
 1000 FORMAT(' COMMON WESTAT CONTAINS '/3(1X,4(D30.20,2X)/),
     .       1X,3(D30.20,2X)/1X,5(I9,2X))
      IF (IDUMP.LT.4) RETURN
      PRINT 1009
 1009 FORMAT('0-------------INFORMATION ON KINEMATICS-----------')
 
      XPOS = QP(4)**2-QP(1)**2-QP(2)**2-QP(3)**2-XML2
      XELE = QM(4)**2-QM(1)**2-QM(2)**2-QM(3)**2-XML2
      XMUP = PP(4)**2-PP(1)**2-PP(2)**2-PP(3)**2-XMU2
      XMUM = PM(4)**2-PM(1)**2-PM(2)**2-PM(3)**2-XMU2
      XW   = XK0**2-XKX**2-XKY**2-XKZ**2-W2
      XQ   =  QE**2- QX**2- QY**2- QZ**2-S1
      PRINT 1010,XPOS,XELE,XMUP,XMUM,XW,XQ
 1010 FORMAT(' QP**2-XML2   = ',D35.25,' QM**2-XML2    = ',D35.25/
     .       ' PP**2-XMU2   = ',D35.25,' PM**2-XMU2    = ',D35.25/
     .       ' (PM+PP)**2-W2= ',D35.25,' (QM+QP)**2-S1 = ',D35.25)
      SUMX = QM(1)+QP(1)+PM(1)+PP(1)
      SUMY = QM(2)+QP(2)+PM(2)+PP(2)
      SUMZ = QM(3)+QP(3)+PM(3)+PP(3)
      SUME = 2-QM(4)-QP(4)-PM(4)-PP(4)
      PRINT 1011,SUMX,SUMY,SUMZ,SUME
 1011 FORMAT(' SUM X COMPONENTS   = ',D35.25,
     .       ' SUM Y COMPONENTS   = ',D35.25/
     .       ' SUM Z COMPONENTS   = ',D35.25,
     .       ' 2-SUM E COMPONENTS = ',D35.25)
      IF (IDUMP.LT.5) RETURN
      PRINT 2999
 2999 FORMAT('0---------INFORMATION ON RANDOM NUMBERS------------')
      PRINT 3001,ETA1
 3001 FORMAT(' RANDOM NUMBER (W2)              = ',D35.25)
      PRINT 3002,ETA2
 3002 FORMAT(' RANDOM NUMBER (S1)              = ',D35.25)
      PRINT 3003,ETA3
 3003 FORMAT(' RANDOM NUMBER (VK)              = ',D35.25)
      PRINT 3004,ETA4
 3004 FORMAT(' RANDOM NUMBER (PHIK)            = ',D35.25)
      PRINT 3005,ETA5
 3005 FORMAT(' RANDOM NUMBER (CP)              = ',D35.25)
      PRINT 3006,ETA6
 3006 FORMAT(' RANDOM NUMBER (PHIP)            = ',D35.25)
      PRINT 3007,ETA7
 3007 FORMAT(' RANDOM NUMBER (CMU)             = ',D35.25)
      PRINT 3008,ETA8
 3008 FORMAT(' RANDOM NUMBER (PHIM)            = ',D35.25)
      RETURN
      END
      SUBROUTINE MCD(IPROC,IDEC,IDUMP)
C... ANNIHILATION SUBGENERATOR
C
C... COMMON /MATRIX / CONTAINS :
C            XME(4) = EXACT ANNIHILATION /MATRIX ELEMENT/**2
C... COMMON /DIAG   / CONTAINS :
C            CALCULATED PHOTON PROPAGATORS AND INVARIANT MASS**2 MUON
C            THESE VALUES ARE USED IN FUNCTION DIAG2
C
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON /CHARGE/ QCHARG,QCHRG2,QCHRG3,QCHRG4
      COMMON /CONST / ALFA,BARN,PI,TWOPI
      COMMON /COUNTD/ IPROD1,IPROD2
      COMMON /DIAG  / U1,U2,U3,U4,U5,U6,U7,U8,U9
      COMMON /GEND  / XLD1(4),SAPD(4),SA4(2),EA4
      COMMON /INIT  / PB,ET,EP(3),ECH(3)
      COMMON /INPUT / EB,THMIN,THMAX,ESWE,ESFT,WAP(4),WBP(4),VAP(4)
      COMMON /LOGCM / OUTFL(4)
      COMMON /MASSES/ XM,XMU,XML,XM2,XMU2,XML2
      COMMON /MATRIX/ XME(4)
      COMMON /PROSTA/ PROP1,PROP2,PROP3,PROP4
      COMMON /SAP   / SAP(4),SAPT
      COMMON /SELECT/ IC,ICH
      COMMON /VECTOR/ P1(4),P2(4),QM(4),QP(4),PM(4),PP(4)
      COMMON /VECTOB/ P1B(4),P2B(4),QMB(4),QPB(4),PMB(4),PPB(4)
      COMMON /WEIGHC/ WEIGHT(4),WEEV,IEVACC
      COMMON /WECOUN/ IFAIL(4),IACC(4),INUL(4),ICHG(4),
     .                INEG,IONE,IZERO
      COMMON /WESTAT/ SWE(4),SWEK(4),MWE(4),SUM,SUMK,MAXWE,IWE(4),IGEN
      COMMON /ZPAR  / AMZ,AMZ2,GZ,AMG,AMG2,CV,CA,CVU,CAU,CVD,CAD
      DIMENSION PH(4)
      DIMENSION APW(2,2),CPW(3,2)
      LOGICAL OUTFL,AFLAG
      REAL*8 MWE,MAXWE
      REAL*4 RNDM,RNF100,DUMMY
      EXTERNAL RNDM,RNF100
      OUTFL(4) = .FALSE.
      GOTO (10000,20000),IDEC
10000 CONTINUE
C........IF ETA11 > SAPD(2)/SA4(1) E+E- ANNIHILATES INTO E+E- ....
C........IF ETA11 < SAPD(2)/SA4(1) E+E- ANNIHILATES INTO MU+MU-...
      ETA11   = DBLE(RNDM(DUMMY))
      IF (ETA11.LT.SAPD(2)/SA4(1)) GOTO 15
C
      IPROD1 = IPROD1 + 1
      AFLAG  = .TRUE.
      XN1    = XML
      XN12   = XML2
      XN2    = XMU
      XN22   = XMU2
      CHFAC1 = QCHRG2
      CHFAC2 = QCHRG4
      CHFAC3 = QCHRG3
      GOTO 16
   15 CONTINUE
      IPROD2 = IPROD2 + 1
      AFLAG  = .FALSE.
      XN1    = XMU
      XN12   = XMU2
      XN2    = XML
      XN22   = XML2
      CHFAC1 = QCHRG4
      CHFAC2 = QCHRG2
      CHFAC3 = QCHRG3
   16 CONTINUE
C--------W2 GENERATION----------------------------------------------
      WSMIN  = 4.D0*XN22
      WSMAX  = 4.D0*(1.D0-XN1)*(1.D0-XN1)
      ETA1   = RNF100(1)
      W2     = (WSMAX/WSMIN)**ETA1*WSMIN
      GOTO 30000
20000 CONTINUE
C........IF ETA11 > SAPD(3)/SA4(2) E+E- ANNIHILATES INTO E+E- ....
C........IF ETA11 < SAPD(4)/SA4(2) E+E- ANNIHILATES INTO MU+MU-...
      ETA11   = DBLE(RNDM(DUMMY))
      IF (ETA11.LT.SAPD(4)/SA4(2)) GOTO 25
C
      IPROD1 = IPROD1 + 1
      AFLAG  = .TRUE.
      XN1    = XML
      XN12   = XML2
      XN2    = XMU
      XN22   = XMU2
      CHFAC1 = QCHRG2
      CHFAC2 = QCHRG4
      CHFAC3 = QCHRG3
      GOTO 26
   25 CONTINUE
      IPROD2 = IPROD2 + 1
      AFLAG  = .FALSE.
      XN1    = XMU
      XN12   = XMU2
      XN2    = XML
      XN22   = XML2
      CHFAC1 = QCHRG4
      CHFAC2 = QCHRG2
      CHFAC3 = QCHRG3
   26 CONTINUE
C--------W2 GENERATION----------------------------------------------
      WSMIN  = 4.D0*XN22
      WSMAX  = 4.D0*(1.D0-XN1)*(1.D0-XN1)
      ETA1   = RNF100(1)
      W2     = AMZ2 + AMG*DTAN(ETA1*DATAN((WSMAX-AMZ2)/AMG)+
     .                         (1.D0-ETA1)*DATAN((WSMIN-AMZ2)/AMG))
30000 CONTINUE
      W      = DSQRT(W2)
      O2     = W2/4.D0
      O      = W /2.D0
C--------X0 GENERATION----------------------------------------------
      XMIN   = XN1
      XMAX   = 1.D0 - XN1*O - O2
      ETA2   = RNF100(2)
      XE     = ((1.D0-XMIN)/(1.D0-XMAX))**ETA2*(1.D0-XMAX)
      X0     = 1.D0 - XE
      XV2    = X0*X0 - XN12
      XV     = DSQRT(XV2)
C--------Y GENERATION-----------------------------------------------
      HY     = 4.D0*XE + 2.D0*XN12 - W2
      DELT   = DSQRT(HY*HY-4.D0*(2.D0-X0)*(2.D0-X0)*XN12
     .              +4.D0*XV2*XN12)
      YMAX   = ((2.D0-X0)*HY+XV*DELT)/(2.D0*((2.D0-X0)*(2.D0-X0)-XV2))
      YMIN   = ((2.D0-X0)*HY-XV*DELT)/(2.D0*((2.D0-X0)*(2.D0-X0)-XV2))
      ETA3   = RNF100(3)
      YE     = ((1.D0-YMIN)/(1.D0-YMAX))**ETA3*(1.D0-YMAX)
      Y0     = 1.D0 - YE
      YV2    = Y0*Y0 - XN12
      YV     = DSQRT(YV2)
C--------CALCULATION COSINE OF ANGLE BETWEEN QM AND QP--------------
      CZ     = (HY-4.D0*Y0+2.D0*X0*Y0)/(2.D0*XV*YV)
      SZ     = DSQRT(1.D0-CZ*CZ)
C--------PHIP GENERATION--------------------------------------------
      ETA4   = DBLE(RNF100(4))
      PHIP   = TWOPI*ETA4
      CPP    = DCOS(PHIP)
      SPP    = DSIN(PHIP)
C--------CM GENERATION----------------------------------------------
      ETA5   = DBLE(RNF100(5))
      CM     = 2.D0*ETA5 - 1.D0
      SM     = DSQRT(1.D0-CM*CM)
      ETA6   = RNF100(6)
      PHIM   = TWOPI*ETA6
      CPM    = DCOS(PHIM)
      SPM    = DSIN(PHIM)
C--------CONSTRUCTION 4MOMENTA QM AND QK----------------------------
      QM(1)  = XV*SM*CPM
      QM(2)  = XV*SM*SPM
      QM(3)  = XV*CM
      QM(4)  = X0
      QP(1)  = YV*( CM*CPM*SZ*CPP-   SPM*SZ*SPP+SM*CPM*CZ    )
      QP(2)  = YV*( CM*SPM*SZ*CPP+   CPM*SZ*SPP+SM*SPM*CZ    )
      QP(3)  = YV*(-SM*    SZ*CPP+              CM*    CZ    )
      QP(4)  = Y0
      QKE    = 2.D0 - X0 - Y0
      QKX    = -QM(1) - QP(1)
      QKY    = -QM(2) - QP(2)
      QKZ    = -QM(3) - QP(3)
      S1     = 2.D0*XN12 + 2.D0*DOT(QM,QP)
      GOTO (40000,50000),IDEC
40000 CONTINUE
      APW(1,1) = W2
      APW(2,1) = S1
      CPW(1,1) = 1.D0+16.D0/((4.D0-AMZ2)**2+AMG2)
      CPW(2,1) = CPW(1,1)
      CPW(3,1) = CPW(1,1)
      GOTO 60000
50000 CONTINUE
      W2ZH   = W2/DSQRT((W2-AMZ2)**2+AMG2)
      S1ZH   = S1/DSQRT((S1-AMZ2)**2+AMG2)
      APW(1,2) = (W2-AMZ2)**2+AMG2
      APW(2,2) = (S1-AMZ2)**2+AMG2
      CPW(1,2) = (1.D0+16.D0/((4.D0-AMZ2)**2+AMG2))*W2ZH**2
      CPW(2,2) = (1.D0+16.D0/((4.D0-AMZ2)**2+AMG2))*S1ZH**2
      CPW(3,2) = (1.D0+16.D0/((4.D0-AMZ2)**2+AMG2))*W2ZH*S1ZH
60000 CONTINUE
      WS1    = DSQRT(S1)
C--------GENERATION OF MUON PAIR IN ITS CM SYSTEM-------------------
      ETA7   = DBLE(RNF100(7))
      CMU    = 2.D0*ETA7 - 1.D0
      SMU    = DSQRT(1.D0-CMU*CMU)
      ETA8   = DBLE(RNF100(8))
      PHIMU  = TWOPI*ETA8
      CPMU   = DCOS(PHIMU)
      SPMU   = DSIN(PHIMU)
      EKCM   = O
      PKCM   = DSQRT(EKCM*EKCM-XN22)
      PXCM   = PKCM*SMU*CPMU
      PYCM   = PKCM*SMU*SPMU
      PZCM   = PKCM*CMU
C--------BOOST BACK TO LABORATORY SYSTEM-----------------------------
      PM(4)  = (QKE*EKCM+QKX*PXCM+QKY*PYCM+QKZ*PZCM)/W
      FACP   = (PM(4)+EKCM)/(QKE+W)
      PM(1)  = PXCM + FACP*QKX
      PM(2)  = PYCM + FACP*QKY
      PM(3)  = PZCM + FACP*QKZ
      PP(1)  = QKX  - PM(1)
      PP(2)  = QKY  - PM(2)
      PP(3)  = QKZ  - PM(3)
      PP(4)  = QKE  - PM(4)
C-------------------------------------------------------------------
      DO 5 I = 1,4
      QMB(I) = -QM(I)
      QPB(I) = -QP(I)
      PMB(I) = -PM(I)
      PPB(I) = -PP(I)
    5 CONTINUE
      DDA    = 4.D0*(1.D0-X0)
      DDB    = 4.D0*(1.D0-Y0)
      DDC    = 4.D0*(1.D0-PM(4))
      DDD    = 4.D0*(1.D0-PP(4))
      PROP1  = 4.D0*S1*DDC
      PROP2  = 4.D0*S1*DDD
      PROP3  = 4.D0*W2*DDA
      PROP4  = 4.D0*W2*DDB
C
C-----CALCULATION OF 1/4(SPIN SUM) /M/**2----------------------
C
      U1     = 4.D0
      U2     = W2
      U3     = S1
      U4     = DDA
      U5     = DDB
      U6     = 0.D0
      U7     = 0.D0
      U8     = P1(4)  - P2B(4)
      U9     = PMB(4) - PP(4)
      XMD1   = DIAG2( P1,P2B, XM,PMB, PP,XN2, QM, QP,XN1,IDUMP)
C
      U1     = 4.D0
      U2     = S1
      U3     = W2
      U4     = DDC
      U5     = DDD
      U6     = 0.D0
      U7     = 0.D0
      U8     = P1(4)  - P2B(4)
      U9     = QMB(4) - QP(4)
      XMD2   = DIAG2( P1,P2B, XM,QMB, QP,XN1, PM, PP,XN2,IDUMP)
C
      U1     = W2
      U2     = S1
      U3     = 4.D0
      U4     = DDC
      U5     = DDD
      U6     = DDB
      U7     = DDA
      U8     = 0.D0
      U9     = 0.D0
      XMD3   = DIAG4(PPB, PM,XN2,QMB, QP,XN1,P2B,P1B, XM)
C
      XME(4) = (XMD1*CPW(1,IDEC)*CHFAC1 +
     .          XMD2*CPW(2,IDEC)*CHFAC2 +
     .          XMD3*CPW(3,IDEC)*CHFAC3)
C
C-----CALCULATION APPROXIMATION-----------------------------------
C
      SWMIN  = 4.D0*XN12
      SWMAX  = 4.D0*(1.D0-XN2)*(1.D0-XN2)
      AMIN   = XN2
      AMAX   = 1.D0 - 0.5D0*XN2*WS1 - 0.25D0*S1
      VX0    = PM(4)
      VXE    = 1.D0 - VX0
      VXV2   = VX0*VX0 - XN22
      VXV    = DSQRT(VXV2)
      VHY    = 4.D0*VXE + 2.D0*XN22 - S1
      VDELT  = DSQRT(VHY*VHY-4.D0*(2.D0-VX0)*(2.D0-VX0)*XN22
     .              +4.D0*VXV2*XN22)
      BMAX   = ((2.D0-VX0)*VHY+VXV*VDELT)/(2.D0*((2.D0-VX0)*
     .          (2.D0-VX0)-VXV2))
      BMIN   = ((2.D0-VX0)*VHY-VXV*VDELT)/(2.D0*((2.D0-VX0)*
     .          (2.D0-VX0)-VXV2))
      XMDP1  = 2.D0/(APW(1,IDEC)*(1.D0-QM(4))*(1.D0-QP(4)))*
     .         (1.D0/4.D0+1.D0/((4.D0-AMZ2)**2+AMG2))*
     .         DLOG(4.D0/WSMIN)*DLOG(4.D0/WSMIN)/
     .        (DLOG((1.D0-YMIN)/(1.D0-YMAX))*
     .         DLOG((1.D0-XMIN)/(1.D0-XMAX))*
     .         DSQRT(1.D0-4.D0*XN22/W2))
      XMDP2  = 2.D0/(APW(2,IDEC)*(1.D0-PM(4))*(1.D0-PP(4)))*
     .         (1.D0/4.D0+1.D0/((4.D0-AMZ2)**2+AMG2))*
     .         DLOG(4.D0/SWMIN)*DLOG(4.D0/SWMIN)/
     .        (DLOG((1.D0-BMIN)/(1.D0-BMAX))*
     .         DLOG((1.D0-AMIN)/(1.D0-AMAX))*
     .         DSQRT(1.D0-4.D0*XN12/S1))
C
      XMP    = XMDP1*CHFAC1 + XMDP2*CHFAC2
C
      ICHG(4) = 0
      IF (AFLAG) GOTO 189
      ICHG(4) = 1
      PROPU = PROP1
      PROP1 = PROP3
      PROP3 = PROPU
      PROPU = PROP2
      PROP2 = PROP4
      PROP4 = PROPU
      DO 18 I=1,4
      PH(I)  = QM(I)
      QM(I)  = PM(I)
      PM(I)  = PH(I)
      PH(I)  = QP(I)
      QP(I)  = PP(I)
      PP(I)  = PH(I)
   18 CONTINUE
  189 CONTINUE
C
      DO 199 I=1,4
      WEIGHT(I) = 0.D0
  199 CONTINUE
C
      WEIGHT(4) = XME(4)/(XMP*WBP(4))
      WEEV      = WEIGHT(4)
C
      IF (WEIGHT(4).GE.0.D0) GOTO 201
      IFAIL(4)  = IFAIL(4) + 1
      INEG      = INEG + 1
      IDUMP     = 5
  201 CONTINUE
C
      ICH   = 0
C      IF (IPROC.NE.2.AND.IPROC.NE.5) GOTO 305
      IF (IPROC.NE.2.AND.IPROC.NE.5.AND.IPROC.NE.6) GOTO 305
      ETA10 = RNF100(10)
      IF (ETA10.LT.0.5D0) GOTO 305
      CALL CHANGE(QM,PM)
      ICH   = 1
  305 CONTINUE
C
C-----START DUMP INFORMATION---------------------------------------
      IF (WEEV.GE.0.D0) GOTO 1081
      PRINT 1080,WEIGHT(4)
 1080 FORMAT(' $$$WARNING$$$ : WEIGHT < 0 : WEIGHT = ',D30.20)
 1081 CONTINUE
      IF (IDUMP.LT.1) RETURN
      PRINT 1079
 1079 FORMAT ('0---------INFORMATION ON WEIGHTS------------------')
      PRINT 1082,XME(4),WEEV
 1082 FORMAT('0XME = ',D30.20,2X,'WEIGHT = ',D30.20)
      IF (IDUMP.LT.2) RETURN
      PRINT 1083
 1083 FORMAT ('0----------INFORMATION ON ANGLES AND ENERGIES-----')
      PRINT 1084,W2,W,X0,Y0,CZ,SZ,S1,QKE,DDA,DDB,XMD1,XMD2,XMD3,
     .           XMDP1,XMDP2,IDEC
 1084 FORMAT(' W2   = ',D30.20,7X,'W     = ',D30.20/
     .       ' X0   = ',D30.20,7X,'Y0    = ',D30.20/
     .       ' CZ   = ',D30.20,7X,'SZ    = ',D30.20/
     .       ' S1   = ',D30.20,7X,'QKE   = ',D30.20/
     .       ' DDA  = ',D30.20,7X,'DDB   = ',D30.20/
     .       ' XMD1 = ',D30.20,7X,'XMD2  = ',D30.20/
     .       ' XMD3 = ',D30.20/
     .       ' XMDP1= ',D30.20,7X,'XMDP2 = ',D30.20/
     .       ' IDEC = ',I2)
      IF (IDUMP.LT.3) RETURN
      PRINT 999
  999 FORMAT('0--------INFORMATION ON COMMON BLOCKS--------------')
      PRINT 1007,XM,XM2,XMU,XMU2,ALFA,BARN,PI,TWOPI
 1007 FORMAT(' COMMON CONST CONTAINS '/2(1X,3(D35.25,2X)/),
     .       1X,2(D35.25,2X))
      PRINT 1101,U1,U2,U3
 1101 FORMAT(' COMMON DIAG CONTAINS '/1X,3(D30.20,2X))
      PRINT 1103,PB,ET,EP
 1103 FORMAT(' COMMON INIT CONTAINS '/1X,2(D30.20,2X)/
     .       1X,3(D30.20,2X))
      PRINT 1002,EB,ESWE,WAP
 1002 FORMAT(' COMMON INPUT CONTAINS '/1X,2(D30.20,2X)/
     .       1X,4(D30.20,2X))
      PRINT 1104,OUTFL
 1104 FORMAT(' COMMON LOG CONTAINS '/1X,4L9)
      PRINT 1106,SAP
 1106 FORMAT(' COMMON SAP CONTAINS '/1X,4(D30.20,2X))
      PRINT 1003,P1B,P2B,QMB,QPB,PMB,PPB
 1003 FORMAT(' COMMON VECTOB CONTAINS'/6(1X,4(D30.20,2X)/))
      PRINT 1004,P1,P2,QM,QP,PM,PP
 1004 FORMAT(' COMMON VECTOR CONTAINS '/6(1X,4(D30.20,2X)/))
      PRINT 1001,IFAIL,IACC,INUL,ICHG,INEG,IONE,IZERO
 1001 FORMAT(' COMMON WECOUN CONTAINS '/4(1X,4(I9,2X)/)/
     .       1X,3(I9,2X))
      PRINT 1005,WEIGHT,WEEV,IEVACC
 1005 FORMAT(' COMMON WEIGHT CONTAINS '/1X,4(D30.20,2X)/
     .       1X,D30.20,2X,I9)
      PRINT 1000,SWE,SWEK,MWE,SUM,SUMK,MAXWE,IWE,IGEN
 1000 FORMAT(' COMMON WESTAT CONTAINS '/3(1X,4(D30.20,2X)/),
     .       1X,3(D30.20,2X)/1X,5(I9,2X))
      IF (IDUMP.LT.4) RETURN
      PRINT 1009
 1009 FORMAT('0-------------INFORMATION ON KINEMATICS-----------')
      XPOS = QP(4)**2-QP(1)**2-QP(2)**2-QP(3)**2-XML2
      XELE = QM(4)**2-QM(1)**2-QM(2)**2-QM(3)**2-XML2
      XMUP = PP(4)**2-PP(1)**2-PP(2)**2-PP(3)**2-XMU2
      XMUM = PM(4)**2-PM(1)**2-PM(2)**2-PM(3)**2-XMU2
      XW   = QKE**2-QKX**2-QKY**2-QKZ**2-W2
      PRINT 1010,XPOS,XELE,XMUP,XMUM,XW
 1010 FORMAT(' QP**2-XML2  = ',D35.25,' QM**2-XML2    = ',D35.25/
     .       ' PP**2-XMU2  = ',D35.25,' PM**2-XMU2    = ',D35.25/
     .       ' (PM+PP)**2-W2= ',D35.25)
      SUMX = QM(1)+QP(1)+PM(1)+PP(1)
      SUMY = QM(2)+QP(2)+PM(2)+PP(2)
      SUMZ = QM(3)+QP(3)+PM(3)+PP(3)
      SUME = 2-QM(4)-QP(4)-PM(4)-PP(4)
      PRINT 1011,SUMX,SUMY,SUMZ,SUME
 1011 FORMAT(' SUM X COMPONENTS   = ',D35.25,
     .       ' SUM Y COMPONENTS   = ',D35.25/
     .       ' SUM Z COMPONENTS   = ',D35.25,
     .       ' 2-SUM E COMPONENTS = ',D35.25)
      IF (IDUMP.LT.5) RETURN
      PRINT 2999
 2999 FORMAT('0---------INFORMATION ON RANDOM NUMBERS------------')
      PRINT 3001,ETA1
 3001 FORMAT(' RANDOM NUMBER (W2)              = ',D35.25)
      PRINT 3002,ETA2
 3002 FORMAT(' RANDOM NUMBER (X0)              = ',D35.25)
      PRINT 3003,ETA3
 3003 FORMAT(' RANDOM NUMBER (Y0)              = ',D35.25)
      PRINT 3004,ETA4
 3004 FORMAT(' RANDOM NUMBER (PHIP)            = ',D35.25)
      PRINT 3005,ETA5
 3005 FORMAT(' RANDOM NUMBER (CM)              = ',D35.25)
      PRINT 3006,ETA6
 3006 FORMAT(' RANDOM NUMBER (PHIM)            = ',D35.25)
      PRINT 3007,ETA7
 3007 FORMAT(' RANDOM NUMBER (CMU)             = ',D35.25)
      PRINT 3008,ETA8
 3008 FORMAT(' RANDOM NUMBER (PHIMU)           = ',D35.25)
      RETURN
      END
      SUBROUTINE SPINOX(INFO)
C... CALCULATION SCALAR PRODUCTS BETWEEN SPINORS : S, T, Y.
C... THE SPINOR PART OF THE AMPLITUDE WILL BE EXPRESSED IN TERMS
C... OF THESE SCALAR PRODUCTS
C... THIS SUBROUTINE IS CALLED FROM FUNCTION DIAM
      IMPLICIT REAL*8(A-H,O-Z)
      COMPLEX*16 S,T
      COMMON / MOMENZ / P1,P2,P3,P4,P5,P6
      COMMON / PRODUX / S,T,Y,Z,X,D
      COMMON /MYCOMN/ PERROR,FTADD(4),ITER
      DIMENSION P1(5),P2(5),P3(5),P4(5),P5(5),P6(5)
      DIMENSION Q(5,6),R(6,6),S(6,6),T(6,6),D(6,6)
      DIMENSION X(6),Y(6,6),Z(6)
      EQUIVALENCE ( P1(1) , Q(1,1) )
      DO 1 I=1,6
      Z(I) = DSQRT( 2.*( Q(4,I) - Q(1,I) )  )
    1 X(I) = Q(5,I)/Z(I)
      DO 2 I=1,6
      DO 2 J=1,6
    2 R(I,J) = Z(I)/Z(J)
      DO 3 I=1,6
      DO 3 J=I,6
      S(I,J) = DCMPLX( Q(2,I) , Q(3,I) ) * R(J,I)
     .       - DCMPLX( Q(2,J) , Q(3,J) ) * R(I,J)
      T(I,J) = -DCONJG( S(I,J) )
    3 Y(I,J) = X(I)*Z(J) + X(J)*Z(I)
      DO 4 I=2,6
      IMIN1=I-1
      DO 4 J=1,IMIN1
      S(I,J) = -S(J,I)
      T(I,J) = -T(J,I)
    4 Y(I,J) =  Y(J,I)
      DO 5 I=1,6
      DO 5 J=1,I
    5 D(I,J) = S(I,J)*T(J,I) + (X(I)*Z(J))**2 + (X(J)*Z(I))**2
      DO 6 I=1,5
      I1=I+1
      DO 6 J=I1,6
    6 D(I,J)=D(J,I)
      IF(INFO.LT.1) RETURN
      IF (ITER.NE.1)  RETURN
      WRITE(6,100)
  100 FORMAT(' ',40(1H-),' SPINOX INFO ',40(1H-))
      WRITE(6,101) (P1(I),P2(I),P3(I),P4(I),P5(I),P6(I),I=1,5)
  101 FORMAT('0INPUT FOUR-VECTORS WITH MASSES',/,(6D15.6))
      WRITE(6,102) (Z(I),X(I),I=1,6)
  102 FORMAT('0MATRICES Z(ROW) AND X(ROW)',/,(2D15.6))
      WRITE(6,103) ((R(I,J),J=1,6),I=1,6)
  103 FORMAT('0MATRIX R(ROW,COLUMN)',/,(6D15.6))
      WRITE(6,104) ((S(I,J),J=1,6),I=1,6)
  104 FORMAT('0MATRIX S(ROW,COLUMN)',/,(6('  ',2D10.3)))
      WRITE(6,105) ((T(I,J),J=1,6),I=1,6)
  105 FORMAT('0MATRIX T(ROW,COLUMN)',/,(6('  ',2D10.3)))
      WRITE(6,106) ((Y(I,J),J=1,6),I=1,6)
  106 FORMAT('0MATRIX Y(ROW,COLUMN)',/,(6('  ',D15.6)))
      WRITE(6,107) ((D(I,J),J=1,6),I=1,6)
  107 FORMAT('0MATRIX D(ROW,COLUMN)',/,(6('  ',D15.6)))
      RETURN
      END
      FUNCTION ZZ(P1,L1,P2,L2,P3,L3,P4,L4,A1,B1,A2,B2,INFO)
C... CALCULATION OF ALL THE Z FUNCTIONS :
C... THESE ARE LORENTZ CONTRACTED SPINOR CURRENTS WITH DIFFERENT
C... SPINS L1,L2,L3,L4
      IMPLICIT REAL*8(A-H,O-Z)
      COMPLEX*16 ZZ,S,T
      INTEGER P1,P2,P3,P4
      DIMENSION S(6,6),T(6,6),Y(6,6),D(6,6),X(6),Z(6)
      COMMON / PRODUX / S,T,Y,Z,X,D
      LZ=9-4*L1-2*L2-L3-(L4+1)/2
      GOTO(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16),LZ
    1 ZZ= -2.*( B1*B2*S(P1,P3)*T(P2,P4)
     .        - B1*A2*Z(P1)*Z(P2)*X(P3)*X(P4)
     .        - A1*B2*Z(P3)*Z(P4)*X(P1)*X(P2) )
      GOTO 17
    2 ZZ= -2.*Z(P2)*(    B1*B2*S(P1,P3)*X(P4)
     .                 - B1*A2*S(P1,P4)*X(P3) )
      GOTO 17
    3 ZZ= -2.*Z(P1)*(    B1*A2*T(P2,P3)*X(P4)
     .                 - B1*B2*T(P2,P4)*X(P3) )
      GOTO 17
    4 ZZ= -2.*( B1*A2*S(P1,P4)*T(P2,P3)
     .        - B1*B2*Z(P1)*Z(P2)*X(P3)*X(P4)
     .        - A1*A2*Z(P3)*Z(P4)*X(P1)*X(P2) )
      GOTO 17
    5 ZZ= -2.*Z(P4)*(    B1*B2*S(P3,P1)*X(P2)
     .                 - A1*B2*S(P3,P2)*X(P1) )
      GOTO 17
    6 ZZ=(0.D0,0.D0)
      GOTO 17
    7 ZZ=   2*A1*B2*X(P1)*X(P3)*Z(P2)*Z(P4)
     .    - 2*A1*A2*X(P1)*X(P4)*Z(P2)*Z(P3)
     .    - 2*B1*B2*X(P2)*X(P3)*Z(P1)*Z(P4)
     .    + 2*B1*A2*X(P2)*X(P4)*Z(P1)*Z(P3)
      GOTO 17
    8 ZZ=  2.*Z(P3)*(    B1*A2*S(P1,P4)*X(P2)
     .                 - A1*A2*S(P2,P4)*X(P1) )
      GOTO 17
    9 ZZ=  2.*Z(P3)*(    A1*B2*T(P1,P4)*X(P2)
     .                 - B1*B2*T(P2,P4)*X(P1) )
      GOTO 17
   10 ZZ=   2*B1*A2*X(P1)*X(P3)*Z(P2)*Z(P4)
     .    - 2*B1*B2*X(P1)*X(P4)*Z(P2)*Z(P3)
     .    - 2*A1*A2*X(P2)*X(P3)*Z(P1)*Z(P4)
     .    + 2*A1*B2*X(P2)*X(P4)*Z(P1)*Z(P3)
      GOTO 17
   11 ZZ=(0.D0,0.D0)
      GOTO 17
   12 ZZ=  2.*Z(P4)*(    A1*A2*T(P1,P3)*X(P2)
     .                 - B1*A2*T(P2,P3)*X(P1) )
      GOTO 17
   13 ZZ= -2.*( A1*B2*S(P2,P3)*T(P1,P4)
     .        - A1*A2*Z(P1)*Z(P2)*X(P3)*X(P4)
     .        - B1*B2*Z(P3)*Z(P4)*X(P1)*X(P2) )
      GOTO 17
   14 ZZ= -2.*Z(P1)*(    A1*B2*S(P2,P3)*X(P4)
     .                 - A1*A2*S(P2,P4)*X(P3) )
      GOTO 17
   15 ZZ= -2.*Z(P2)*(    A1*A2*T(P1,P3)*X(P4)
     .                 - A1*B2*T(P1,P4)*X(P3) )
      GOTO 17
   16 ZZ= -2.*( A1*A2*S(P2,P4)*T(P1,P3)
     .        - A1*B2*Z(P1)*Z(P2)*X(P3)*X(P4)
     .        - B1*A2*Z(P3)*Z(P4)*X(P1)*X(P2) )
   17 IF(INFO.LT.5) RETURN
      PRINT 18,L1,L2,L3,L4,LZ,ZZ
   18 FORMAT(' ZZ:   L1,L2,L3,L4,  LZ,  ZZ =',4I3,I6,D20.6,D15.6)
      RETURN
      END
      FUNCTION YY(P1,L1,P2,L2,A,B)
C CALCULATION OF MASS TERMS
      IMPLICIT REAL*8(A-H,O-Z)
      COMPLEX*16 YY,S,T
      INTEGER P1,P2
      DIMENSION S(6,6),T(6,6),Y(6,6),D(6,6),X(6),Z(6)
      COMMON / PRODUX / S,T,Y,Z,X,D
      LZ=3-L1-(L2+1)/2
      GOTO (1,2,3,4),LZ
    1 YY= B*X(P1)*Z(P2)**2+A*X(P2)*Z(P1)**2
      GOTO 5
    2 YY= A*S(P1,P2)
      GOTO 5
    3 YY= B*T(P1,P2)
      GOTO 5
    4 YY= A*X(P1)*Z(P2)**2+B*X(P2)*Z(P1)**2
    5 RETURN
      END
      FUNCTION GRAAF(IGR,IPER,P1,L1,P2,L2,P3,L3,P4,L4,P5,L5,P6,L6,INF)
C... FUNCTION GRAAF CALCULATES THE COMPLETE AMPLITUDE OF A GIVEN
C... AMPLITUDE.
C... GRAAF IS CALLED FROM FUNCTION DIAM FOR EVERY FEYNMAN DIAGRAM.
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON /INOUT / B(6)
      COMMON /INPUT / EB,THMIN,THMAX,ESWE,ESFT,WAP(4),WBP(4),VAP(4)
      COMMON /MOMENZ/ Q1(5),Q2(5),Q3(5),Q4(5),Q5(5),Q6(5)
      COMMON /PRODUX/ S,T,Y,Z,X,D
      COMMON /PROPAR/ ID
      COMMON /SUBGRA/ GRAPH(4),GRAP(4)
      COMMON /ZPAR  / AMZ,AMZ2,GZ,AMG,AMG2,CV,CA,CVU,CAU,CVD,CAD
      DIMENSION Q(5,6),S(6,6),T(6,6),Y(6,6),D(6,6),X(6),Z(6)
CB      DIMENSION Q1(5),Q2(5),Q3(5),Q4(5),Q5(5),Q6(5),QQ(5)
      DIMENSION AP(3),BP(3),QQ(5)
      EQUIVALENCE ( Q1(1) , Q(1,1) )
      COMPLEX*16 ZZ,YY,S,T,GRAAF,GRAPH,GRAP,TERM1,TERM2,TERMZ,
     .           PROP1,PROP2,PROP
      COMPLEX*16 ZZ3B,ZZ3E,ZZ2B,ZZ2E,ZZ1B,ZZ1E,
     .           YY1E,YY2E,YY13,YY23,YY12,YY22,YY11,YY21,
     .           YY35,YY36,YY25,YY26,YY15,YY16,YY5B,YY6B
      INTEGER P1,P2,P3,P4,P5,P6
      DATA IC/0/
      IF (IC.NE.0) GOTO 100
      IC   = 1
      AP(1)   = CV + CA
      BP(1)   = CV - CA
      AP(2)   = CVU + CAU
      BP(2)   = CVU - CAU
      AP(3)   = CVD + CAD
      BP(3)   = CVD - CAD
      TERMZ = DCMPLX(0.D0,1.D0)*AMZ*GZ - AMZ2
      GRAPH(1) = (0.D0,0.D0)
      GRAPH(2) = (0.D0,0.D0)
      GRAPH(3) = (0.D0,0.D0)
      GRAPH(4) = (0.D0,0.D0)
      GRAP(1)  = (0.D0,0.D0)
      GRAP(2)  = (0.D0,0.D0)
      GRAP(3)  = (0.D0,0.D0)
      GRAP(4)  = (0.D0,0.D0)
  100 CONTINUE
      PRO1  = 0.5D0*D(P1,P1)+0.5D0*D(P2,P2)+B(P1)*B(P2)*D(P1,P2)
      APRO1 = DABS(PRO1)
      IF (APRO1.LT.1.D-10)
     . PRO1 = 0.5D0*D(P1,P1)+0.5D0*D(P2,P2)+2.D0*B(P1)*B(P2)*
     .  ( (Q(4,P1)*Q(4,P1)*(Q(1,P2)*Q(1,P2)+Q(2,P2)*Q(2,P2)+
     .                      Q(5,P2)*Q(5,P2))+
     .     Q(3,P2)*Q(3,P2)*(Q(1,P1)*Q(1,P1)+Q(2,P1)*Q(2,P1)+
     .                      Q(5,P1)*Q(5,P1)))/
     .    (Q(4,P1)*Q(4,P2)+Q(3,P1)*Q(3,P2))-
     .     Q(2,P1)*Q(2,P2)-Q(1,P1)*Q(1,P2) )
      APRO1 = DABS(PRO1)
      PRO2  = 0.5D0*D(P5,P5)+0.5D0*D(P6,P6)+B(P5)*B(P6)*D(P5,P6)
      APRO2 = DABS(PRO2)
      IF (APRO2.LT.1.D-10)
     . PRO2 =  0.5D0*D(P5,P5)+0.5D0*D(P6,P6)+2.D0*B(P5)*B(P6)*
     .  ( (Q(4,P5)*Q(4,P5)*(Q(1,P6)*Q(1,P6)+Q(2,P6)*Q(2,P6)+
     .                      Q(5,P6)*Q(5,P6))+
     .     Q(3,P6)*Q(3,P6)*(Q(1,P5)*Q(1,P5)+Q(2,P5)*Q(2,P5)+
     .                      Q(5,P5)*Q(5,P5)))/
     .    (Q(4,P5)*Q(4,P6)+Q(3,P5)*Q(3,P6))-
     .     Q(2,P5)*Q(2,P6)-Q(1,P5)*Q(1,P6) )
      APRO2 = DABS(PRO2)
      PROP3 = 0.5D0*D(P1,P1)+0.5D0*D(P2,P2)+B(P1)*B(P2)*D(P1,P2)+
     .                  B(P1)*B(P3)*D(P1,P3)+B(P2)*B(P3)*D(P2,P3)
      APROP3 = DABS(PROP3)
      IF (APROP3.GT.1.D-10) GOTO 6
      IF (APRO1.GT.APRO2) GOTO 7
      DO 8 I=1,4
      QQ(I) = B(P1)*Q(I,P1) + B(P2)*Q(I,P2)
    8 CONTINUE
      QQ(5) = PRO1
      PROP3 = PRO1 + 2.D0*B(P3)*
     .  ( (QQ(4)*QQ(4)*(Q(1,P3)*Q(1,P3)+Q(2,P3)*Q(2,P3)+
     .                  Q(5,P3)*Q(5,P3))+
     .     Q(3,P3)*Q(3,P3)*(QQ(1)*QQ(1)+QQ(2)*QQ(2)+QQ(5)))/
     .    (QQ(4)*Q(4,P3)+QQ(3)*Q(3,P3))-
     .     QQ(1)*Q(1,P3)-QQ(2)*Q(2,P3) )
      GOTO 6
    7 CONTINUE
      DO 9 I=1,4
      QQ(I) = B(P5)*Q(I,P5) + B(P6)*Q(I,P6)
    9 CONTINUE
      QQ(5) = PRO2
      PROP3 = PRO2 + 2.D0*B(P4)*
     .  ( (QQ(4)*QQ(4)*(Q(1,P4)*Q(1,P4)+Q(2,P4)*Q(2,P4)+
     .                  Q(5,P4)*Q(5,P4))+
     .     Q(3,P4)*Q(3,P4)*(QQ(1)*QQ(1)+QQ(2)*QQ(2)+QQ(5)))/
     .    (QQ(4)*Q(4,P4)+QQ(3)*Q(3,P4))-
     .     QQ(1)*Q(1,P4)-QQ(2)*Q(2,P4) )
    6 CONTINUE
      DO 10 II=1,4
      GOTO (11,12,13,14), II
   11 A1 = 1.D0
      B1 = 1.D0
      A2 = 1.D0
      B2 = 1.D0
      A3 = 1.D0
      B3 = 1.D0
      A4 = 1.D0
      B4 = 1.D0
      TERM1 = (0.D0,0.D0)
      TERM2 = (0.D0,0.D0)
      GRAPH(II) = (0.D0,0.D0)
      DO 1110 I=1,2
      IL  = 2*I - 3
      ZZ3B = ZZ(P3,IL,P4,L4,P5,L5,P6,L6,A3,B3,A4,B4,INF)
      ZZ2B = ZZ(P2,IL,P4,L4,P5,L5,P6,L6,A3,B3,A4,B4,INF)
      ZZ1B = ZZ(P1,IL,P4,L4,P5,L5,P6,L6,A3,B3,A4,B4,INF)
      ZZ3E = ZZ(P1,L1,P2,L2,P3,L3,P3,IL,A1,B1,A2,B2,INF)
      ZZ2E = ZZ(P1,L1,P2,L2,P3,L3,P2,IL,A1,B1,A2,B2,INF)
      ZZ1E = ZZ(P1,L1,P2,L2,P3,L3,P1,IL,A1,B1,A2,B2,INF)
      GRAPH(II) = GRAPH(II)
     .  + B(P3)*ZZ3E*ZZ3B + B(P2)*ZZ2E*ZZ2B + B(P1)*ZZ1E*ZZ1B
 1110 CONTINUE
      GOTO 15
   12 A1 = 1.D0
      B1 = 1.D0
      A2 = 1.D0
      B2 = 1.D0
      A3 = AP(1)
      B3 = BP(1)
      A4 = AP(1)
      B4 = BP(1)
      TERM1 = (0.D0,0.D0)
      TERM2 = TERMZ
      IF (ID.EQ.1) GOTO 1122
      IF (IPER.NE.3.AND.IPER.NE.4) GOTO 120
      A3 = AP(ID)
      B3 = BP(ID)
      GOTO 1122
  120 IF (IPER.NE.1.AND.IPER.NE.6) GOTO 1122
      A4 = AP(ID)
      B4 = BP(ID)
 1122 GRAPH(II) = (0.D0,0.D0)
      DO 1120 I=1,2
      IL  = 2*I - 3
      ZZ3B = ZZ(P3,IL,P4,L4,P5,L5,P6,L6,A3,B3,A4,B4,INF)
      ZZ2B = ZZ(P2,IL,P4,L4,P5,L5,P6,L6,A3,B3,A4,B4,INF)
      ZZ1B = ZZ(P1,IL,P4,L4,P5,L5,P6,L6,A3,B3,A4,B4,INF)
      ZZ3E = ZZ(P1,L1,P2,L2,P3,L3,P3,IL,A1,B1,A2,B2,INF)
      ZZ2E = ZZ(P1,L1,P2,L2,P3,L3,P2,IL,A1,B1,A2,B2,INF)
      ZZ1E = ZZ(P1,L1,P2,L2,P3,L3,P1,IL,A1,B1,A2,B2,INF)
      GRAPH(II) = GRAPH(II)
     .  + B(P3)*ZZ3E*ZZ3B + B(P2)*ZZ2E*ZZ2B + B(P1)*ZZ1E*ZZ1B
      DO 1121 K=1,2
      KL  = 2*K - 3
      YY35 = YY(P3,IL,P5,KL,1.D0,1.D0)
      YY36 = YY(P3,IL,P6,KL,1.D0,1.D0)
      YY25 = YY(P2,IL,P5,KL,1.D0,1.D0)
      YY26 = YY(P2,IL,P6,KL,1.D0,1.D0)
      YY15 = YY(P1,IL,P5,KL,1.D0,1.D0)
      YY16 = YY(P1,IL,P6,KL,1.D0,1.D0)
      YY5B = YY(P5,KL,P4,L4,A3,B3)
      YY6B = YY(P6,KL,P4,L4,A3,B3)
      GRAPH(II) = GRAPH(II) - 1.D0/AMZ2*
     .    (B(P5)*Q(5,P5)*YY(P5,L5,P6,L6,A4,B4)+
     .     B(P6)*Q(5,P6)*YY(P5,L5,P6,L6,B4,A4))*
     .   ((B(P3)*B(P5)*YY35*YY5B+B(P3)*B(P6)*YY36*YY6B)*ZZ3E+
     .    (B(P2)*B(P5)*YY25*YY5B+B(P2)*B(P6)*YY26*YY6B)*ZZ2E+
     .    (B(P1)*B(P5)*YY15*YY5B+B(P1)*B(P6)*YY16*YY6B)*ZZ1E)
 1121 CONTINUE
 1120 CONTINUE
      GOTO 15
   13 A1 = AP(1)
      B1 = BP(1)
      A2 = AP(1)
      B2 = BP(1)
      A3 = 1.D0
      B3 = 1.D0
      A4 = 1.D0
      B4 = 1.D0
      TERM1 = TERMZ
      TERM2 = (0.D0,0.D0)
      IF (ID.EQ.1) GOTO 1132
      IF (IPER.NE.3.AND.IPER.NE.4) GOTO 130
      A2 = AP(ID)
      B2 = BP(ID)
      GOTO 1132
  130 IF (IPER.NE.2.AND.IPER.NE.5) GOTO 1132
      A1 = AP(ID)
      B1 = BP(ID)
 1132 GRAPH(II) = (0.D0,0.D0)
      DO 1130 I=1,2
      IL  = 2*I - 3
      ZZ3B = ZZ(P3,IL,P4,L4,P5,L5,P6,L6,A3,B3,A4,B4,INF)
      ZZ2B = ZZ(P2,IL,P4,L4,P5,L5,P6,L6,A3,B3,A4,B4,INF)
      ZZ1B = ZZ(P1,IL,P4,L4,P5,L5,P6,L6,A3,B3,A4,B4,INF)
      ZZ3E = ZZ(P1,L1,P2,L2,P3,L3,P3,IL,A1,B1,A2,B2,INF)
      ZZ2E = ZZ(P1,L1,P2,L2,P3,L3,P2,IL,A1,B1,A2,B2,INF)
      ZZ1E = ZZ(P1,L1,P2,L2,P3,L3,P1,IL,A1,B1,A2,B2,INF)
      GRAPH(II) = GRAPH(II)
     .  + B(P3)*ZZ3E*ZZ3B + B(P2)*ZZ2E*ZZ2B + B(P1)*ZZ1E*ZZ1B
      DO 1131 J=1,2
      JL  = 2*J - 3
      YY1E = YY(P3,L3,P1,JL,1.D0,1.D0)
      YY2E = YY(P3,L3,P2,JL,1.D0,1.D0)
      YY13 = YY(P1,JL,P3,IL,A2,B2)
      YY23 = YY(P2,JL,P3,IL,A2,B2)
      YY12 = YY(P1,JL,P2,IL,A2,B2)
      YY22 = YY(P2,JL,P2,IL,A2,B2)
      YY11 = YY(P1,JL,P1,IL,A2,B2)
      YY21 = YY(P2,JL,P1,IL,A2,B2)
      GRAPH(II) = GRAPH(II) - 1.D0/AMZ2*
     .    (B(P1)*Q(5,P1)*YY(P1,L1,P2,L2,A1,B1)+
     .     B(P2)*Q(5,P2)*YY(P1,L1,P2,L2,B1,A1))*
     .   ((B(P3)*B(P1)*YY1E*YY13+B(P3)*B(P2)*YY2E*YY23)*ZZ3B+
     .    (B(P2)*B(P1)*YY1E*YY12+B(P2)*B(P2)*YY2E*YY22)*ZZ2B+
     .    (B(P1)*B(P1)*YY1E*YY11+B(P1)*B(P2)*YY2E*YY21)*ZZ1B)
 1131 CONTINUE
 1130 CONTINUE
      GOTO 15
   14 A1 = AP(1)
      B1 = BP(1)
      A2 = AP(1)
      B2 = BP(1)
      A3 = AP(1)
      B3 = BP(1)
      A4 = AP(1)
      B4 = BP(1)
      TERM1 = TERMZ
      TERM2 = TERMZ
      IF (ID.EQ.1) GOTO 1143
      IF (IPER.NE.3.AND.IPER.NE.4) GOTO 140
      A2 = AP(ID)
      B2 = BP(ID)
      A3 = AP(ID)
      B3 = BP(ID)
      GOTO 1143
  140 IF (IPER.NE.1.AND.IPER.NE.6) GOTO 141
      A4 = AP(ID)
      B4 = BP(ID)
      GOTO 1143
  141 A1 = AP(ID)
      B1 = BP(ID)
 1143 GRAPH(II) = (0.D0,0.D0)
      DO 1140 I=1,2
      IL  = 2*I - 3
      ZZ3B = ZZ(P3,IL,P4,L4,P5,L5,P6,L6,A3,B3,A4,B4,INF)
      ZZ2B = ZZ(P2,IL,P4,L4,P5,L5,P6,L6,A3,B3,A4,B4,INF)
      ZZ1B = ZZ(P1,IL,P4,L4,P5,L5,P6,L6,A3,B3,A4,B4,INF)
      ZZ3E = ZZ(P1,L1,P2,L2,P3,L3,P3,IL,A1,B1,A2,B2,INF)
      ZZ2E = ZZ(P1,L1,P2,L2,P3,L3,P2,IL,A1,B1,A2,B2,INF)
      ZZ1E = ZZ(P1,L1,P2,L2,P3,L3,P1,IL,A1,B1,A2,B2,INF)
      GRAPH(II) = GRAPH(II)
     .  + B(P3)*ZZ3E*ZZ3B + B(P2)*ZZ2E*ZZ2B + B(P1)*ZZ1E*ZZ1B
      DO 1141 K=1,2
      KL  = 2*K - 3
      YY35 = YY(P3,IL,P5,KL,1.D0,1.D0)
      YY36 = YY(P3,IL,P6,KL,1.D0,1.D0)
      YY25 = YY(P2,IL,P5,KL,1.D0,1.D0)
      YY26 = YY(P2,IL,P6,KL,1.D0,1.D0)
      YY15 = YY(P1,IL,P5,KL,1.D0,1.D0)
      YY16 = YY(P1,IL,P6,KL,1.D0,1.D0)
      YY5B = YY(P5,KL,P4,L4,A3,B3)
      YY6B = YY(P6,KL,P4,L4,A3,B3)
      GRAPH(II) = GRAPH(II) - 1.D0/AMZ2*
     .    (B(P5)*Q(5,P5)*YY(P5,L5,P6,L6,A4,B4)+
     .     B(P6)*Q(5,P6)*YY(P5,L5,P6,L6,B4,A4))*
     .   ((B(P3)*B(P5)*YY35*YY5B+B(P3)*B(P6)*YY36*YY6B)*ZZ3E+
     .    (B(P2)*B(P5)*YY25*YY5B+B(P2)*B(P6)*YY26*YY6B)*ZZ2E+
     .    (B(P1)*B(P5)*YY15*YY5B+B(P1)*B(P6)*YY16*YY6B)*ZZ1E)
      YY1E = YY(P3,L3,P1,KL,1.D0,1.D0)
      YY2E = YY(P3,L3,P2,KL,1.D0,1.D0)
      YY13 = YY(P1,KL,P3,IL,A2,B2)
      YY23 = YY(P2,KL,P3,IL,A2,B2)
      YY12 = YY(P1,KL,P2,IL,A2,B2)
      YY22 = YY(P2,KL,P2,IL,A2,B2)
      YY11 = YY(P1,KL,P1,IL,A2,B2)
      YY21 = YY(P2,KL,P1,IL,A2,B2)
      GRAPH(II) = GRAPH(II) - 1.D0/AMZ2*
     .    (B(P1)*Q(5,P1)*YY(P1,L1,P2,L2,A1,B1)+
     .     B(P2)*Q(5,P2)*YY(P1,L1,P2,L2,B1,A1))*
     .   ((B(P3)*B(P1)*YY1E*YY13+B(P3)*B(P2)*YY2E*YY23)*ZZ3B+
     .    (B(P2)*B(P1)*YY1E*YY12+B(P2)*B(P2)*YY2E*YY22)*ZZ2B+
     .    (B(P1)*B(P1)*YY1E*YY11+B(P1)*B(P2)*YY2E*YY21)*ZZ1B)
      DO 1142 J=1,2
      JL  = 2*J - 3
      YY1E = YY(P3,L3,P1,JL,1.D0,1.D0)
      YY2E = YY(P3,L3,P2,JL,1.D0,1.D0)
      YY13 = YY(P1,JL,P3,IL,A2,B2)
      YY23 = YY(P2,JL,P3,IL,A2,B2)
      YY12 = YY(P1,JL,P2,IL,A2,B2)
      YY22 = YY(P2,JL,P2,IL,A2,B2)
      YY11 = YY(P1,JL,P1,IL,A2,B2)
      YY21 = YY(P2,JL,P1,IL,A2,B2)
      GRAPH(II) = GRAPH(II) + 1.D0/(AMZ2**2)*
     .    (B(P1)*Q(5,P1)*YY(P1,L1,P2,L2,A1,B1)+
     .     B(P2)*Q(5,P2)*YY(P1,L1,P2,L2,B1,A1))*
     .    (B(P5)*Q(5,P5)*YY(P5,L5,P6,L6,A4,B4)+
     .     B(P6)*Q(5,P6)*YY(P5,L5,P6,L6,B4,A4))*
     .   ((B(P3)*B(P1)*YY1E*YY13+B(P3)*B(P2)*YY2E*YY23)*
     .    (      B(P5)*YY35*YY5B+      B(P6)*YY36*YY6B)+
     .    (B(P2)*B(P1)*YY1E*YY12+B(P2)*B(P2)*YY2E*YY22)*
     .    (      B(P5)*YY25*YY5B+      B(P6)*YY26*YY6B)+
     .    (B(P1)*B(P1)*YY1E*YY11+B(P1)*B(P2)*YY2E*YY21)*
     .    (      B(P5)*YY15*YY5B+      B(P6)*YY16*YY6B))
 1142 CONTINUE
 1141 CONTINUE
 1140 CONTINUE
   15 CONTINUE
      IF (INF.GE.4) PRINT 50,IL,P1,L1,P2,L2,P3,L3,P4,L4,P5,L5,P6,L6,
     .                      GRAPH(II)
   50 FORMAT(' GRAPH: IL,P(I),L(I),GRAPH =',I3,' ',6(2I3,' '),2D15.6)
      PROP1 = PRO1 + TERM1
      PROP2 = PRO2 + TERM2
      PROP  = PROP1*PROP2*PROP3
      GRAPH(II) = GRAPH(II)/PROP
      IF (INF.GE.3) PRINT 51,PROP,GRAPH(II)
   51 FORMAT(' GRAAF:------------------ PROP,GRAPH =',4D15.6)
   10 CONTINUE
      GRAAF = GRAPH(1) + GRAPH(2) + GRAPH(3) + GRAPH(4)
      GRAP(1) = GRAPH(1)
C
      IF (IGR.NE.1.AND.IGR.NE.2) RETURN
      PROZ1   = DSQRT((PRO1-AMZ2)**2+AMG2)
      PROZ2   = DSQRT((PRO2-AMZ2)**2+AMG2)
      GOTO (16,17,17,16,16,17),IPER
   16 CONTINUE
      GRAP(2) = GRAPH(1)*PRO1/PROZ1
      GRAP(3) = GRAPH(1)*PRO2/PROZ2
      GOTO 18
   17 CONTINUE
      GRAP(2) = GRAPH(1)*PRO2/PROZ2
      GRAP(3) = GRAPH(1)*PRO1/PROZ1
   18 CONTINUE
      GRAP(4) = GRAPH(1)*PRO1*PRO2/(PROZ1*PROZ2)
      RETURN
      END
C   01/10/81 110011356  MEMBER NAME  SETWS    (S)           FORTRAN
      SUBROUTINE SETWS(SIN2W,MZ,CVE,CAE,CVU,CAU,CVD,CAD)
C CALCULATE Z0 MASS AND LEPTON COUPLING CONSTANTS IN THE STANDARD
C MODEL AS A FUNCTION OF THE WEAK MIXING ANGLE (SIN**2)
C SIN2W=SIN**2 OF WEAK MIXING ANGLE (INPUT)
C MZ   =Z0 MASS IN GEV
C CVE  =VECTOR COUPLING OF ELECTRON,MUON,TAU
C CAE  =AXIAL  COUPLING OF ELECTRON,MUON,TAU
C CVU  =VECTOR COUPLING OF UP,CHARM,TOP QUARKS
C CAU  =AXIAL  COUPLING OF UP,CHARM,TOP QUARKS
C CVD  =VECTOR COUPLING OF DOWN,STRANGE,BOTTOM QUARKS
C CAD  =AXIAL  COUPLING OF DOWN,STRANGE,BOTTOM QUARKS
C THE COUPLING CONSTANTS ARE NORMALIZED TO THE CHARGE OF THE E- .
      IMPLICIT REAL*8(A-Z)
      FOURSS=4.*SIN2W
      FOURSC=4.*DSQRT(SIN2W*(1.-SIN2W))
      MZ =149.168/FOURSC
      CVE=(FOURSS-1. )/FOURSC
      CAE=-1. /FOURSC
      CVU=(FOURSS-1.5)/FOURSC
      CAU=-1.5/FOURSC
      CVD=(FOURSS-3. )/FOURSC
      CAD=-3. /FOURSC
      RETURN
      END
      SUBROUTINE GROUP(IG,K1,K2,K3,K4,K5,K6,IREL)
C--------------------------------------------------------------
C THIS SUBROUTINE ORDERS THE LABELS OF THE MOMENTA INTO THE
C CORRECT GROUPS
C--------------------------------------------------------------
      K1 = 1
      K3 = 4
      K5 = 6
      GOTO (1,2,3,4,5,6),IG
    1 CONTINUE
      K2 = 2
      K4 = 3
      K6 = 5
      IREL =  1
      RETURN
    2 CONTINUE
      K2 = 2
      K4 = 5
      K6 = 3
      IREL = -1
      RETURN
    3 CONTINUE
      K2 = 3
      K4 = 5
      K6 = 2
      IREL =  1
      RETURN
    4 CONTINUE
      K2 = 5
      K4 = 3
      K6 = 2
      IREL = -1
      RETURN
    5 CONTINUE
      K2 = 5
      K4 = 2
      K6 = 3
      IREL =  1
      RETURN
    6 CONTINUE
      K2 = 3
      K4 = 2
      K6 = 5
      IREL = -1
      RETURN
      END
      SUBROUTINE PERMU(IP,L1,L2,L3,L4,L5,L6,K1,K2,K3,K4,K5,K6)
C---------------------------------------------------------------
C ORDERS THE MOMENTUM LABELS ACCORDING TO THE PERMUTATION NUMBER
C INSIDE A GIVEN GROUP : ACCORDING TO TABLE 2.
C---------------------------------------------------------------
      GOTO (1,2,3,4,5,6),IP
    1 K1=L1
      K2=L2
      K3=L3
      K4=L4
      K5=L5
      K6=L6
      RETURN
    2 K1=L5
      K2=L6
      K3=L3
      K4=L4
      K5=L1
      K6=L2
      RETURN
    3 K1=L3
      K2=L4
      K3=L5
      K4=L6
      K5=L1
      K6=L2
      RETURN
    4 K1=L1
      K2=L2
      K3=L5
      K4=L6
      K5=L3
      K6=L4
      RETURN
    5 K1=L5
      K2=L6
      K3=L1
      K4=L2
      K5=L3
      K6=L4
      RETURN
    6 K1=L3
      K2=L4
      K3=L1
      K4=L2
      K5=L5
      K6=L6
      RETURN
      END
      SUBROUTINE CHANGE(A,B)
      IMPLICIT REAL*8(A-H,O-Z)
      DIMENSION A(4),B(4),C(4)
      DO 1 I=1,4
      C(I) = A(I)
      A(I) = B(I)
      B(I) = C(I)
    1 CONTINUE
      RETURN
      END
      FUNCTION CHOICE(IPROCS,IGROUP,IPERMU)
C------------------------------------------------------------------
C SELECTION ROUTINE FOR VARIOUS 'SUB'PROCESSES OF E E ---> E E E E
C IPROCS=1: MU+(Q3)  L+(Q5) MU-(Q4)  L-(Q6)
C        2: MU+(Q3) MU+(Q5) MU-(Q4) MU-(Q6)
C        3:  E+(Q3) MU+(Q5)  E-(Q4) MU-(Q6)
C        4:  E+(Q3)  L+(Q5)  E-(Q4)  L-(Q6)
C        5:  E+(Q3)  E+(Q5)  E-(Q4)  E-(Q6)
C        6:TAU+(Q3)TAU+(Q5)TAU-(Q4)TAU-(Q6)
C------------------------------------------------------------------
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON /CHARGE/ QCHARG,QCHRG2,QCHRG3,QCHRG4
      CHOICE = 0.D0
      GOTO (1,2,3,4,5,2),IPROCS
    1 CONTINUE
      IF (IGROUP.NE.1) RETURN
      IF (IPERMU.EQ.3. OR.IPERMU.EQ.4) CHOICE = QCHRG2
      IF (IPERMU.NE.3.AND.IPERMU.NE.4) CHOICE = QCHARG
      RETURN
    2 CONTINUE
      IF (IGROUP.EQ.1.OR.IGROUP.EQ.2) CHOICE = 1.D0
      RETURN
    3 CONTINUE
      IF (IGROUP.EQ.1.OR.IGROUP.EQ.6) CHOICE = 1.D0
      RETURN
    4 CONTINUE
      IF (IGROUP.NE.1.AND.IGROUP.NE.6) RETURN
      IF (IPERMU.EQ.3. OR.IPERMU.EQ.4) CHOICE = QCHRG2
      IF (IPERMU.NE.3.AND.IPERMU.NE.4) CHOICE = QCHARG
      RETURN
    5 CONTINUE
      CHOICE = 1.D0
      RETURN
      END
      SUBROUTINE GETRID(IPROC,INF)
C... GETRID DETERMINES WHICH OF THE SUPPRESSED SPIN CONFIGURATIONS
C... WILL BE OMITTED DURING THE SUMMATION OF THE EXACT /MATRIX
C... ELEMENT/**2 OVER ALL THE POSSIBLE SPIN CONFIGURATIONS.
C... THIS SPEEDS UP THE CALCULATION OF THE FINAL WEIGHT CONSIDERABLY.
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON /MASSES/ XM,XMU,XML,XM2,XMU2,XML2
      COMMON /PROP  / PROP(6,3,4)
      COMMON /REDUCE/ ISEL(6,3),ILZ(6,3,64)
      COMMON /VECTOR/ P1(4),P2(4),QM(4),QP(4),PM(4),PP(4)
      COMMON /FACTOR/ FCE,FCL,FCM,PROC
      COMMON /ZPAR  / AMZ,AMZ2,GZ,AMG,AMG2,CV,CA,CVU,CAU,CVD,CAD
      COMMON /MYCOMN/ PERROR,FTADD(4),ITER
      DIMENSION VP1QM(4),VP2QP(4),VP1PM(4),VP2PP(4),
     .          SQMQP(4),SQMPP(4),SPMQP(4),SPMPP(4)
      DIMENSION I12(3),J12(64),I34(3),J34(64),I56(3),J56(64),
     .          I45(3),J45(64),I36(3),J36(64),I13(3),J13(64),
     .          I26(3),J26(64),I15(3),J15(64),I24(3),J24(64)
      DIMENSION II(6,8,64),IT(3)
      DATA J12/1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
     .         0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
     .         0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
     .         1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1/
      DATA J34/1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1,
     .         1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1,
     .         1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1,
     .         1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1/
      DATA J56/1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,
     .         1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,
     .         1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,
     .         1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1/
      DATA J45/1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,
     .         1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,
     .         1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,
     .         1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1/
      DATA J36/1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1,
     .         1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1,
     .         1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1,
     .         1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1/
      DATA J13/1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,
     .         1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,
     .         0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,
     .         0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1/
      DATA J26/1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,
     .         0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
     .         1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,
     .         0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1/
      DATA J15/1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,
     .         1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,
     .         0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,
     .         0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1/
      DATA J24/1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,
     .         0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,
     .         1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,
     .         0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1/
C
      DATA INIT/0/
      IF (INIT.NE.0) GOTO 1
      INIT = 1
      FACE = FCE*XM2
      FACM = FCM*XMU2
      FACL = FCL*XML2
      DO 2 J=1,64
      II(1,1,J) = 1
      II(1,2,J) = J56(J)
      II(1,3,J) = J34(J)
      II(1,4,J) = J56(J)*J34(J)
      II(1,5,J) = J12(J)
      II(1,6,J) = J56(J)*J12(J)
      II(1,7,J) = J34(J)*J12(J)
      II(1,8,J) = II(1,7,J)*J56(J)
      II(2,1,J) = 1
      II(2,2,J) = J36(J)
      II(2,3,J) = J45(J)
      II(2,4,J) = J36(J)*J45(J)
      II(2,5,J) = J12(J)
      II(2,6,J) = J36(J)*J12(J)
      II(2,7,J) = J45(J)*J12(J)
      II(2,8,J) = II(2,7,J)*J36(J)
      II(3,1,J) = 1
      II(3,2,J) = J26(J)
      II(3,3,J) = J45(J)
      II(3,4,J) = J26(J)*J45(J)
      II(3,5,J) = J13(J)
      II(3,6,J) = J26(J)*J13(J)
      II(3,7,J) = J45(J)*J13(J)
      II(3,8,J) = II(3,7,J)*J26(J)
      II(4,1,J) = 1
      II(4,2,J) = J26(J)
      II(4,3,J) = J34(J)
      II(4,4,J) = J26(J)*J34(J)
      II(4,5,J) = J15(J)
      II(4,6,J) = J26(J)*J15(J)
      II(4,7,J) = J34(J)*J15(J)
      II(4,8,J) = II(4,7,J)*J26(J)
      II(5,1,J) = 1
      II(5,2,J) = J36(J)
      II(5,3,J) = J24(J)
      II(5,4,J) = J36(J)*J24(J)
      II(5,5,J) = J15(J)
      II(5,6,J) = J36(J)*J15(J)
      II(5,7,J) = J24(J)*J15(J)
      II(5,8,J) = II(5,7,J)*J36(J)
      II(6,1,J) = 1
      II(6,2,J) = J56(J)
      II(6,3,J) = J24(J)
      II(6,4,J) = J56(J)*J24(J)
      II(6,5,J) = J13(J)
      II(6,6,J) = J56(J)*J13(J)
      II(6,7,J) = J24(J)*J13(J)
      II(6,8,J) = II(6,7,J)*J56(J)
    2 CONTINUE
    1 CONTINUE
C
      DO 4 I=1,4
      VP1QM(I) = P1(I) - QM(I)
      VP2QP(I) = P2(I) - QP(I)
      VP1PM(I) = P1(I) - PM(I)
      VP2PP(I) = P2(I) - PP(I)
      SQMQP(I) = QM(I) + QP(I)
      SQMPP(I) = QM(I) + PP(I)
      SPMQP(I) = PM(I) + QP(I)
      SPMPP(I) = PM(I) + PP(I)
    4 CONTINUE
      WE = 4.D0
      WL = DOT(SQMQP,SQMQP)
      WM = DOT(SPMPP,SPMPP)
      W1 = DOT(SPMQP,SPMQP)
      W2 = DOT(SQMPP,SQMPP)
      AT1 = DOT(VP2QP,VP2QP)
      AT2 = DOT(VP1QM,VP1QM)
      AT3 = DOT(VP2PP,VP2PP)
      AT4 = DOT(VP1PM,VP1PM)
      WEZ = WE-AMZ2
      WLZ = WL-AMZ2
      WMZ = WM-AMZ2
      W1Z = W1-AMZ2
      W2Z = W2-AMZ2
      AT1Z= AT1-AMZ2
      AT2Z= AT2-AMZ2
      AT3Z= AT3-AMZ2
      AT4Z= AT4-AMZ2
      T1 = DABS(AT1)
      T2 = DABS(AT2)
      T3 = DABS(AT3)
      T4 = DABS(AT4)
      T1Z = DABS(AT1Z)
      T2Z = DABS(AT2Z)
      T3Z = DABS(AT3Z)
      T4Z = DABS(AT4Z)
      E1 = 4.D0*(1.D0-PP(4))
      E2 = 4.D0*(1.D0-PM(4))
      E3 = 4.D0*(1.D0-QP(4))
      E4 = 4.D0*(1.D0-QM(4))
      AD1 = WM-2.D0*DOT(P2,SPMPP)
      AD2 = WL-2.D0*DOT(P2,SQMQP)
      AD3 = W1-2.D0*DOT(P2,SPMQP)
      AD4 = W2-2.D0*DOT(P2,SQMPP)
      AD5 = AT1-2.D0*DOT(PP,VP2QP)
      AD6 = AT1-2.D0*DOT(PM,VP2QP)
      D1 = DABS(AD1)
      D2 = DABS(AD2)
      D3 = DABS(AD3)
      D4 = DABS(AD4)
      D5 = DABS(AD5)
      D6 = DABS(AD6)
C
      PROP(1,1,1) = WE*WM*E3*E4
      PROP(1,1,2) = DABS(WEZ*WM*E3*E4)
      PROP(1,1,3) = DABS(WE*WMZ*E3*E4)
      PROP(1,1,4) = DABS(WEZ*WMZ*E3*E4)
      PROP(1,2,1) = WE*WL*E1*E2
      PROP(1,2,2) = DABS(WEZ*WL*E1*E2)
      PROP(1,2,3) = DABS(WE*WLZ*E1*E2)
      PROP(1,2,4) = DABS(WEZ*WLZ*E1*E2)
      PROP(1,3,1) = WL*WM*D1*D2
      PROP(1,3,2) = DABS(WLZ*WM*D1*D2)
      PROP(1,3,3) = DABS(WL*WMZ*D1*D2)
      PROP(1,3,4) = DABS(WLZ*WMZ*D1*D2)
C
      GOTO(1001,2001,3001,3001,4001,2001),IPROC
 1001 CONTINUE
      PROMIN = DMIN1(PROP(1,1,1),PROP(1,1,2),PROP(1,1,3),PROP(1,1,4),
     .               PROP(1,2,1),PROP(1,2,2),PROP(1,2,3),PROP(1,2,4),
     .               PROP(1,3,1),PROP(1,3,2),PROP(1,3,3),PROP(1,3,4))
      PROM   = PROC*PROMIN
      DO 1002 I=1,3
      ISEL(1,I) = 1
      IF (PROP(1,I,1).GT.PROM.AND.PROP(1,I,2).GT.PROM.AND.
     .    PROP(1,I,3).GT.PROM.AND.PROP(1,I,4).GT.PROM) ISEL(1,I) = 0
 1002 CONTINUE
      DO 1003 I=1,3
      I12(I) = -1
      I34(I) = -1
      I56(I) = -1
 1003 CONTINUE
      IF (WE.LE.FACE.OR.WEZ.LE.FACE) I12(1) = 1
      IF (E3.LE.FACL.OR.E4 .LE.FACL) I34(1) = 1
      IF (WM.LE.FACM.OR.WMZ.LE.FACM) I56(1) = 1
      IF (WL.LE.FACL.OR.WLZ.LE.FACL) I34(2) = 1
      IF (E1.LE.FACM.OR.E2 .LE.FACM) I56(2) = 1
      IF (D1.LE.FACE.OR.D2 .LE.FACE) I12(3) = 1
      I12(2) = I12(1)
      I34(3) = I34(2)
      I56(3) = I56(1)
      DO 1004 I=1,3
      IT(I) = 5 - 2*I12(I) - I34(I) - (I56(I)+1)/2
      DO 1004 J=1,64
      ILZ(1,I,J) = II(1,IT(I),J)
 1004 CONTINUE
      IF (INF.LT.0) RETURN
      IF (ITER.NE.0) RETURN
      PRINT 110, WE,WM,E3,E4,WE,WL,E1,E2,WL,WM,D1,D2
  110 FORMAT(' WE = ',D15.4,2X,'WM = ',D15.4,2X,
     .        'E3 = ',D15.4,2X,'E4 = ',D15.4/
     .       ' WE = ',D15.4,2X,'WL = ',D15.4,2X,
     .        'E1 = ',D15.4,2X,'E2 = ',D15.4/
     .       ' WL = ',D15.4,2X,'WM = ',D15.4,2X,
     .        'D1 = ',D15.4,2X,'D2 = ',D15.4)
      PRINT 100,((PROP(1,J,I),I=1,4),J=1,3)
  100 FORMAT(' PROP(1,J,I) (I=1,4) (J=1,3) = '/' ',4(D15.4,2X))
      PRINT 101,PROMIN
  101 FORMAT(' PROMIN = ',D15.4)
      PRINT 102,(ISEL(1,J),J=1,3),
     .              ((ILZ(1,I,J),J=1,64),I=1,3)
  102 FORMAT(' ISEL(1,J) (J=1,3) = ',3I2//
     .       ' ILZ(1,I,J) (J=1,64 I=1,3) = '/
     .       3(' ',64I2/))
      RETURN
C
 2001 CONTINUE
      PROP(2,1,1) = WE*W1*E1*E4
      PROP(2,1,2) = DABS(WEZ*W1*E1*E4)
      PROP(2,1,3) = DABS(WE*W1Z*E1*E4)
      PROP(2,1,4) = DABS(WEZ*W1Z*E1*E4)
      PROP(2,2,1) = WE*W2*E2*E3
      PROP(2,2,2) = DABS(WEZ*W2*E2*E3)
      PROP(2,2,3) = DABS(WE*W2Z*E2*E3)
      PROP(2,2,4) = DABS(WEZ*W2Z*E2*E3)
      PROP(2,3,1) = W1*W2*D3*D4
      PROP(2,3,2) = DABS(W1Z*W2*D3*D4)
      PROP(2,3,3) = DABS(W1*W2Z*D3*D4)
      PROP(2,3,4) = DABS(W1Z*W2Z*D3*D4)
      PROMIN = DMIN1(PROP(1,1,1),PROP(1,1,2),PROP(1,1,3),PROP(1,1,4),
     .               PROP(1,2,1),PROP(1,2,2),PROP(1,2,3),PROP(1,2,4),
     .               PROP(1,3,1),PROP(1,3,2),PROP(1,3,3),PROP(1,3,4),
     .               PROP(2,1,1),PROP(2,1,2),PROP(2,1,3),PROP(2,1,4),
     .               PROP(2,2,1),PROP(2,2,2),PROP(2,2,3),PROP(2,2,4),
     .               PROP(2,3,1),PROP(2,3,2),PROP(2,3,3),PROP(2,3,4))
      PROM   = PROC*PROMIN
      DO 2002 IGR=1,2
      DO 2002 I=1,3
      ISEL(IGR,I) = 1
      IF (PROP(IGR,I,1).GT.PROM.AND.PROP(IGR,I,2).GT.PROM.AND.
     .    PROP(IGR,I,3).GT.PROM.AND.PROP(IGR,I,4).GT.PROM)
     .   ISEL(IGR,I) = 0
 2002 CONTINUE
      DO 2003 I=1,3
      I12(I) = -1
      I34(I) = -1
      I56(I) = -1
 2003 CONTINUE
      IF (WE.LE.FACE.OR.WEZ.LE.FACE) I12(1) = 1
      IF (E3.LE.FACM.OR.E4 .LE.FACM) I34(1) = 1
      IF (WM.LE.FACM.OR.WMZ.LE.FACM) I56(1) = 1
      IF (WL.LE.FACM.OR.WLZ.LE.FACM) I34(2) = 1
      IF (E1.LE.FACM.OR.E2 .LE.FACM) I56(2) = 1
      IF (D1.LE.FACE.OR.D2 .LE.FACE) I12(3) = 1
      I12(2) = I12(1)
      I34(3) = I34(2)
      I56(3) = I56(1)
      DO 2004 I=1,3
      IT(I) = 5 - 2*I12(I) - I34(I) - (I56(I)+1)/2
      DO 2004 J=1,64
      ILZ(1,I,J) = II(1,IT(I),J)
 2004 CONTINUE
      DO 2005 I=1,3
      I12(I) = -1
      I45(I) = -1
      I36(I) = -1
 2005 CONTINUE
      IF (WE.LE.FACE.OR.WEZ.LE.FACE) I12(1) = 1
      IF (E1.LE.FACM.OR.E4 .LE.FACM) I45(1) = 1
      IF (W1.LE.FACM.OR.W1Z.LE.FACM) I36(1) = 1
      IF (W2.LE.FACM.OR.W2Z.LE.FACM) I45(2) = 1
      IF (E2.LE.FACM.OR.E3 .LE.FACM) I36(2) = 1
      IF (D3.LE.FACE.OR.D4 .LE.FACE) I12(3) = 1
      I12(2) = I12(1)
      I45(3) = I45(2)
      I36(3) = I36(1)
      DO 2006 I=1,3
      IT(I) = 5 - 2*I12(I) - I45(I) - (I36(I)+1)/2
      DO 2006 J=1,64
      ILZ(2,I,J) = II(2,IT(I),J)
 2006 CONTINUE
      IF (ITER.NE.0) RETURN
      IF (INF.LT.0) RETURN
      PRINT 210, WE,WM,E3,E4,WE,WL,E1,E2,WL,WM,D1,D2
  210 FORMAT(' WE = ',D15.4,2X,'WM = ',D15.4,2X,
     .        'E3 = ',D15.4,2X,'E4 = ',D15.4/
     .       ' WE = ',D15.4,2X,'WL = ',D15.4,2X,
     .        'E1 = ',D15.4,2X,'E2 = ',D15.4/
     .       ' WL = ',D15.4,2X,'WM = ',D15.4,2X,
     .        'D1 = ',D15.4,2X,'D2 = ',D15.4)
      PRINT 211, WE,W1,E1,E4,WE,W2,E2,E3,W1,W2,D3,D4
  211 FORMAT(' WE = ',D15.4,2X,'W1 = ',D15.4,2X,
     .        'E1 = ',D15.4,2X,'E4 = ',D15.4/
     .       ' WE = ',D15.4,2X,'W2 = ',D15.4,2X,
     .        'E2 = ',D15.4,2X,'E3 = ',D15.4/
     .       ' W1 = ',D15.4,2X,'W2 = ',D15.4,2X,
     .        'D3 = ',D15.4,2X,'D4 = ',D15.4)
      PRINT 200,(((PROP(I,J,IJ),IJ=1,4),J=1,3),I=1,2)
  200 FORMAT(' PROP(I,J,K) (K=1,4 J=1,3 I=1,2) = '/4(D15.4,2X))
      PRINT 201,PROMIN
  201 FORMAT(' PROMIN = ',D15.4)
      PRINT 202,(ISEL(1,J),J=1,3),
     .              ((ILZ(1,I,J),J=1,64),I=1,3)
  202 FORMAT(' ISEL(1,J) (J=1,3) = ',3I2//
     .       ' ILZ(1,I,J) (J=1,64 I=1,3) = '/
     .       3(' ',64I2/))
      PRINT 203,(ISEL(2,J),J=1,3),
     .              ((ILZ(2,I,J),J=1,64),I=1,3)
  203 FORMAT(' ISEL(2,J) (J=1,3) = ',3I2//
     .       ' ILZ(2,I,J) (J=1,64 I=1,3) = '/
     .       3(' ',64I2/))
      RETURN
 3001 CONTINUE
      PROP(6,1,1) = WM*T1*D2*E3
      PROP(6,1,2) = DABS(WMZ*T1*D2*E3)
      PROP(6,1,3) = DABS(WM*T1Z*D2*E3)
      PROP(6,1,4) = DABS(WMZ*T1Z*D2*E3)
      PROP(6,2,1) = T1*T2*D5*D6
      PROP(6,2,2) = DABS(T1Z*T2*D5*D6)
      PROP(6,2,3) = DABS(T1*T2Z*D5*D6)
      PROP(6,2,4) = DABS(T1Z*T2Z*D5*D6)
      PROP(6,3,1) = WM*T2*D1*E4
      PROP(6,3,2) = DABS(WMZ*T2*D1*E4)
      PROP(6,3,3) = DABS(WM*T2Z*D1*E4)
      PROP(6,3,4) = DABS(WMZ*T2Z*D1*E4)
      PROMIN = DMIN1(PROP(1,1,1),PROP(1,1,2),PROP(1,1,3),PROP(1,1,4),
     .               PROP(1,2,1),PROP(1,2,2),PROP(1,2,3),PROP(1,2,4),
     .               PROP(1,3,1),PROP(1,3,2),PROP(1,3,3),PROP(1,3,4),
     .               PROP(6,1,1),PROP(6,1,2),PROP(6,1,3),PROP(6,1,4),
     .               PROP(6,2,1),PROP(6,2,2),PROP(6,2,3),PROP(6,2,4),
     .               PROP(6,3,1),PROP(6,3,2),PROP(6,3,3),PROP(6,3,4))
      PROM   = PROC*PROMIN
      DO 3002 IGR=1,6,5
      DO 3002 I=1,3
      ISEL(IGR,I) = 1
      IF (PROP(IGR,I,1).GT.PROM.AND.PROP(IGR,I,2).GT.PROM.AND.
     .    PROP(IGR,I,3).GT.PROM.AND.PROP(IGR,I,4).GT.PROM)
     .    ISEL(IGR,I) = 0
 3002 CONTINUE
      DO 3003 I=1,3
      I12(I) = -1
      I34(I) = -1
      I56(I) = -1
 3003 CONTINUE
      IF (WE.LE.FACE.OR.WEZ.LE.FACE) I12(1) = 1
      IF (E3.LE.FACE.OR.E4 .LE.FACE) I34(1) = 1
      IF (WM.LE.FACM.OR.WMZ.LE.FACM) I56(1) = 1
      IF (WL.LE.FACE.OR.WLZ.LE.FACM) I34(2) = 1
      IF (E1.LE.FACM.OR.E2 .LE.FACM) I56(2) = 1
      IF (D1.LE.FACE.OR.D2 .LE.FACE) I12(3) = 1
      I12(2) = I12(1)
      I34(3) = I34(2)
      I56(3) = I56(1)
      DO 3004 I=1,3
      IT(I) = 5 - 2*I12(I) - I34(I) - (I56(I)+1)/2
      DO 3004 J=1,64
      ILZ(1,I,J) = II(1,IT(I),J)
 3004 CONTINUE
      DO 3005 I=1,3
      I13(I) = -1
      I24(I) = -1
      I56(I) = -1
 3005 CONTINUE
      IF (T1.LE.FACE.OR.T1Z.LE.FACE) I13(1) = 1
      IF (D2.LE.FACE.OR.E3 .LE.FACE) I24(1) = 1
      IF (WM.LE.FACM.OR.WMZ.LE.FACM) I56(1) = 1
      IF (T2.LE.FACE.OR.T2Z.LE.FACE) I24(2) = 1
      IF (D5.LE.FACM.OR.D6 .LE.FACM) I56(2) = 1
      IF (D1.LE.FACE.OR.E4 .LE.FACE) I13(3) = 1
      I13(2) = I13(1)
      I24(3) = I24(2)
      I56(3) = I56(1)
      DO 3006 I=1,3
      IT(I) = 5 - 2*I13(I) - I24(I) - (I56(I)+1)/2
      DO 3006 J=1,64
      ILZ(6,I,J) = II(6,IT(I),J)
 3006 CONTINUE
      IF (ITER.NE.0) RETURN
      IF (INF.LT.0) RETURN
      PRINT 310, WE,WM,E3,E4,WE,WL,E1,E2,WL,WM,D1,D2
  310 FORMAT(' WE = ',D15.4,2X,'WM = ',D15.4,2X,
     .        'E3 = ',D15.4,2X,'E4 = ',D15.4/
     .       ' WE = ',D15.4,2X,'WL = ',D15.4,2X,
     .        'E1 = ',D15.4,2X,'E2 = ',D15.4/
     .       ' WL = ',D15.4,2X,'WM = ',D15.4,2X,
     .        'D1 = ',D15.4,2X,'D2 = ',D15.4)
      PRINT 311, WM,T1,D2,E3,T1,T2,D5,D6,WM,T2,D1,E4
  311 FORMAT(' WM = ',D15.4,2X,'T1 = ',D15.4,2X,
     .        'D2 = ',D15.4,2X,'E3 = ',D15.4/
     .       ' T1 = ',D15.4,2X,'T2 = ',D15.4,2X,
     .        'D5 = ',D15.4,2X,'D6 = ',D15.4/
     .       ' WM = ',D15.4,2X,'T2 = ',D15.4,2X,
     .        'D1 = ',D15.4,2X,'E4 = ',D15.4)
      PRINT 300,((PROP(1,J,IJ),IJ=1,4),J=1,3),
     .          ((PROP(6,I,JI),JI=1,4),I=1,3)
  300 FORMAT(' PROP(I,J,K) (K=1,4 J=1,3 I=1 OR 6) = '/4(D15.4,2X))
      PRINT 301,PROMIN
  301 FORMAT(' PROMIN = ',D15.4)
      PRINT 302,(ISEL(1,J),J=1,3),
     .              ((ILZ(1,I,J),J=1,64),I=1,3)
  302 FORMAT(' ISEL(1,J) (J=1,3) = ',3I2//
     .       ' ILZ(1,I,J) (J=1,64 I=1,3) = '/
     .       3(' ',64I2/))
      PRINT 303,(ISEL(6,J),J=1,3),
     .              ((ILZ(6,I,J),J=1,64),I=1,3)
  303 FORMAT(' ISEL(6,J) (J=1,3) = ',3I2//
     .       ' ILZ(6,I,J) (J=1,64 I=1,3) = '/
     .       3(' ',64I2/))
      RETURN
 4001 CONTINUE
      PROP(2,1,1) = WE*W1*E1*E4
      PROP(2,1,2) = DABS(WEZ*W1*E1*E4)
      PROP(2,1,3) = DABS(WE*W1Z*E1*E4)
      PROP(2,1,4) = DABS(WEZ*W1Z*E1*E4)
      PROP(2,2,1) = WE*W2*E2*E3
      PROP(2,2,2) = DABS(WEZ*W2*E2*E3)
      PROP(2,2,3) = DABS(WE*W2Z*E2*E3)
      PROP(2,2,4) = DABS(WEZ*W2Z*E2*E3)
      PROP(2,3,1) = W1*W2*D3*D4
      PROP(2,3,2) = DABS(W1Z*W2*D3*D4)
      PROP(2,3,3) = DABS(W1*W2Z*D3*D4)
      PROP(2,3,4) = DABS(W1Z*W2Z*D3*D4)
C
      PROP(3,1,1) = T1*T4*D2*D5
      PROP(3,1,2) = DABS(T1Z*T4*D2*D5)
      PROP(3,1,3) = DABS(T1*T4Z*D2*D5)
      PROP(3,1,4) = DABS(T1Z*T4Z*D2*D5)
      PROP(3,2,1) = T1*W2*E3*D3
      PROP(3,2,2) = DABS(T1Z*W2*E3*D3)
      PROP(3,2,3) = DABS(T1*W2Z*E3*D3)
      PROP(3,2,4) = DABS(T1Z*W2Z*E3*D3)
      PROP(3,3,1) = T4*W2*E2*D4
      PROP(3,3,2) = DABS(T4Z*W2*E2*D4)
      PROP(3,3,3) = DABS(T4*W2Z*E2*D4)
      PROP(3,3,4) = DABS(T4Z*W2Z*E2*D4)
C
      PROP(4,1,1) = T3*T4*D4*D5
      PROP(4,1,2) = DABS(T3Z*T4*D4*D5)
      PROP(4,1,3) = DABS(T3*T4Z*D4*D5)
      PROP(4,1,4) = DABS(T3Z*T4Z*D4*D5)
      PROP(4,2,1) = T3*WL*E1*D1
      PROP(4,2,2) = DABS(T3Z*WL*E1*D1)
      PROP(4,2,3) = DABS(T3*WLZ*E1*D1)
      PROP(4,2,4) = DABS(T3Z*WLZ*E1*D1)
      PROP(4,3,1) = T4*WL*E2*D2
      PROP(4,3,2) = DABS(T4Z*WL*E2*D2)
      PROP(4,3,3) = DABS(T4*WLZ*E2*D2)
      PROP(4,3,4) = DABS(T4Z*WLZ*E2*D2)
C
      PROP(5,1,1) = T3*W1*D4*E1
      PROP(5,1,2) = DABS(T3Z*W1*D4*E1)
      PROP(5,1,3) = DABS(T3*W1Z*D4*E1)
      PROP(5,1,4) = DABS(T3Z*W1Z*D4*E1)
      PROP(5,2,1) = T3*T2*D5*D1
      PROP(5,2,2) = DABS(T3Z*T2*D5*D1)
      PROP(5,2,3) = DABS(T3*T2Z*D5*D1)
      PROP(5,2,4) = DABS(T3Z*T2Z*D5*D1)
      PROP(5,3,1) = T2*W1*D3*E4
      PROP(5,3,2) = DABS(T2Z*W1*D3*E4)
      PROP(5,3,3) = DABS(T2*W1Z*D3*E4)
      PROP(5,3,4) = DABS(T2Z*W1Z*D3*E4)
C
      PROP(6,1,1) = WM*T1*D2*E3
      PROP(6,1,2) = DABS(WMZ*T1*D2*E3)
      PROP(6,1,3) = DABS(WM*T1Z*D2*E3)
      PROP(6,1,4) = DABS(WMZ*T1Z*D2*E3)
      PROP(6,2,1) = T1*T2*D5*D6
      PROP(6,2,2) = DABS(T1Z*T2*D5*D6)
      PROP(6,2,3) = DABS(T1*T2Z*D5*D6)
      PROP(6,2,4) = DABS(T1Z*T2Z*D5*D6)
      PROP(6,3,1) = WM*T2*D1*E4
      PROP(6,3,2) = DABS(WMZ*T2*D1*E4)
      PROP(6,3,3) = DABS(WM*T2Z*D1*E4)
      PROP(6,3,4) = DABS(WMZ*T2Z*D1*E4)
C
      PROMIN = DMIN1(PROP(1,1,1),PROP(1,1,2),PROP(1,1,3),PROP(1,1,4),
     .               PROP(1,2,1),PROP(1,2,2),PROP(1,2,3),PROP(1,2,4),
     .               PROP(1,3,1),PROP(1,3,2),PROP(1,3,3),PROP(1,3,4),
     .               PROP(2,1,1),PROP(2,1,2),PROP(2,1,3),PROP(2,1,4),
     .               PROP(2,2,1),PROP(2,2,2),PROP(2,2,3),PROP(2,2,4),
     .               PROP(2,3,1),PROP(2,3,2),PROP(2,3,3),PROP(2,3,4),
     .               PROP(3,1,1),PROP(3,1,2),PROP(3,1,3),PROP(3,1,4),
     .               PROP(3,2,1),PROP(3,2,2),PROP(3,2,3),PROP(3,2,4),
     .               PROP(3,3,1),PROP(3,3,2),PROP(3,3,3),PROP(3,3,4),
     .               PROP(4,1,1),PROP(4,1,2),PROP(4,1,3),PROP(4,1,4),
     .               PROP(4,2,1),PROP(4,2,2),PROP(4,2,3),PROP(4,2,4),
     .               PROP(4,3,1),PROP(4,3,2),PROP(4,3,3),PROP(4,3,4),
     .               PROP(5,1,1),PROP(5,1,2),PROP(5,1,3),PROP(5,1,4),
     .               PROP(5,2,1),PROP(5,2,2),PROP(5,2,3),PROP(5,2,4),
     .               PROP(5,3,1),PROP(5,3,2),PROP(5,3,3),PROP(5,3,4),
     .               PROP(6,1,1),PROP(6,1,2),PROP(6,1,3),PROP(6,1,4),
     .               PROP(6,2,1),PROP(6,2,2),PROP(6,2,3),PROP(6,2,4),
     .               PROP(6,3,1),PROP(6,3,2),PROP(6,3,3),PROP(6,3,4))
      PROM   = PROC*PROMIN
      DO 4002 IGR=1,6
      DO 4002 I=1,3
      ISEL(IGR,I) = 1
      IF (PROP(IGR,I,1).GT.PROM.AND.PROP(IGR,I,2).GT.PROM.AND.
     .    PROP(IGR,I,3).GT.PROM.AND.PROP(IGR,I,4).GT.PROM)
     .    ISEL(IGR,I) = 0
 4002 CONTINUE
      DO 4003 I=1,3
      I12(I) = -1
      I34(I) = -1
      I56(I) = -1
 4003 CONTINUE
      IF (WE.LE.FACE.OR.WEZ.LE.FACE) I12(1) = 1
      IF (E3.LE.FACE.OR.E4 .LE.FACE) I34(1) = 1
      IF (WM.LE.FACE.OR.WMZ.LE.FACE) I56(1) = 1
      IF (WL.LE.FACE.OR.WLZ.LE.FACE) I34(2) = 1
      IF (E1.LE.FACE.OR.E2 .LE.FACE) I56(2) = 1
      IF (D1.LE.FACE.OR.D2 .LE.FACE) I12(3) = 1
      I12(2) = I12(1)
      I34(3) = I34(2)
      I56(3) = I56(1)
      DO 4004 I=1,3
      IT(I) = 5 - 2*I12(I) - I34(I) - (I56(I)+1)/2
      DO 4004 J=1,64
      ILZ(1,I,J) = II(1,IT(I),J)
 4004 CONTINUE
      DO 4005 I=1,3
      I12(I) = -1
      I45(I) = -1
      I36(I) = -1
 4005 CONTINUE
      IF (WE.LE.FACE.OR.WEZ.LE.FACE) I12(1) = 1
      IF (E1.LE.FACE.OR.E4 .LE.FACE) I45(1) = 1
      IF (W1.LE.FACE.OR.W1Z.LE.FACE) I36(1) = 1
      IF (W2.LE.FACE.OR.W2Z.LE.FACE) I45(2) = 1
      IF (E2.LE.FACE.OR.E3 .LE.FACE) I36(2) = 1
      IF (D3.LE.FACE.OR.D4 .LE.FACE) I12(3) = 1
      I12(2) = I12(1)
      I45(3) = I45(2)
      I36(3) = I36(1)
      DO 4006 I=1,3
      IT(I) = 5 - 2*I12(I) - I45(I) - (I36(I)+1)/2
      DO 4006 J=1,64
      ILZ(2,I,J) = II(2,IT(I),J)
 4006 CONTINUE
      DO 4007 I=1,3
      I13(I) = -1
      I45(I) = -1
      I26(I) = -1
 4007 CONTINUE
      IF (T1.LE.FACE.OR.T1Z.LE.FACE) I13(1) = 1
      IF (D5.LE.FACE.OR.D2 .LE.FACE) I45(1) = 1
      IF (T4.LE.FACE.OR.T4Z.LE.FACE) I26(1) = 1
      IF (W2.LE.FACE.OR.W2Z.LE.FACE) I45(2) = 1
      IF (E3.LE.FACE.OR.D3 .LE.FACE) I26(2) = 1
      IF (E2.LE.FACE.OR.D4 .LE.FACE) I13(3) = 1
      I13(2) = I13(1)
      I45(3) = I45(2)
      I26(3) = I26(1)
      DO 4008 I=1,3
      IT(I) = 5 - 2*I13(I) - I45(I) - (I26(I)+1)/2
      DO 4008 J=1,64
      ILZ(3,I,J) = II(3,IT(I),J)
 4008 CONTINUE
      DO 4009 I=1,3
      I15(I) = -1
      I34(I) = -1
      I26(I) = -1
 4009 CONTINUE
      IF (T3.LE.FACE.OR.T3Z.LE.FACE) I15(1) = 1
      IF (D5.LE.FACE.OR.D4 .LE.FACE) I34(1) = 1
      IF (T4.LE.FACE.OR.T4Z.LE.FACE) I26(1) = 1
      IF (WL.LE.FACE.OR.WLZ.LE.FACE) I34(2) = 1
      IF (E1.LE.FACE.OR.D1 .LE.FACE) I26(2) = 1
      IF (E2.LE.FACE.OR.D2 .LE.FACE) I15(3) = 1
      I15(2) = I15(1)
      I34(3) = I34(2)
      I26(3) = I26(1)
      DO 4010 I=1,3
      IT(I) = 5 - 2*I15(I) - I34(I) - (I26(I)+1)/2
      DO 4010 J=1,64
      ILZ(4,I,J) = II(4,IT(I),J)
 4010 CONTINUE
      DO 4011 I=1,3
      I15(I) = -1
      I24(I) = -1
      I36(I) = -1
 4011 CONTINUE
      IF (T3.LE.FACE.OR.T3Z.LE.FACE) I15(1) = 1
      IF (D4.LE.FACE.OR.E1 .LE.FACE) I24(1) = 1
      IF (W1.LE.FACE.OR.W1Z.LE.FACE) I36(1) = 1
      IF (T2.LE.FACE.OR.T2Z.LE.FACE) I24(2) = 1
      IF (D5.LE.FACE.OR.D1 .LE.FACE) I36(2) = 1
      IF (D3.LE.FACE.OR.E4 .LE.FACE) I15(3) = 1
      I15(2) = I15(1)
      I24(3) = I24(2)
      I36(3) = I36(1)
      DO 4012 I=1,3
      IT(I) = 5 - 2*I15(I) - I24(I) - (I36(I)+1)/2
      DO 4012 J=1,64
      ILZ(5,I,J) = II(5,IT(I),J)
 4012 CONTINUE
      DO 4013 I=1,3
      I13(I) = -1
      I24(I) = -1
      I56(I) = -1
 4013 CONTINUE
      IF (T1.LE.FACE.OR.T1Z.LE.FACE) I13(1) = 1
      IF (D2.LE.FACE.OR.E3 .LE.FACE) I24(1) = 1
      IF (WM.LE.FACE.OR.WMZ.LE.FACE) I56(1) = 1
      IF (T2.LE.FACE.OR.T2Z.LE.FACE) I24(2) = 1
      IF (D5.LE.FACE.OR.D6 .LE.FACE) I56(2) = 1
      IF (D1.LE.FACE.OR.E4 .LE.FACE) I13(3) = 1
      I13(2) = I13(1)
      I24(3) = I24(2)
      I56(3) = I56(1)
      DO 4014 I=1,3
      IT(I) = 5 - 2*I13(I) - I24(I) - (I56(I)+1)/2
      DO 4014 J=1,64
      ILZ(6,I,J) = II(6,IT(I),J)
 4014 CONTINUE
      IF (ITER.NE.0) RETURN
      IF (INF.LT.0) RETURN
      PRINT 410, WE,WM,E3,E4,WE,WL,E1,E2,WL,WM,D1,D2
  410 FORMAT(' WE = ',D15.4,2X,'WM = ',D15.4,2X,
     .        'E3 = ',D15.4,2X,'E4 = ',D15.4/
     .       ' WE = ',D15.4,2X,'WL = ',D15.4,2X,
     .        'E1 = ',D15.4,2X,'E2 = ',D15.4/
     .       ' WL = ',D15.4,2X,'WM = ',D15.4,2X,
     .        'D1 = ',D15.4,2X,'D2 = ',D15.4)
      PRINT 411, WE,W1,E1,E4,WE,W2,E2,E3,W1,W2,D3,D4
  411 FORMAT(' WE = ',D15.4,2X,'W1 = ',D15.4,2X,
     .        'E1 = ',D15.4,2X,'E4 = ',D15.4/
     .       ' WE = ',D15.4,2X,'W2 = ',D15.4,2X,
     .        'E2 = ',D15.4,2X,'E3 = ',D15.4/
     .       ' W1 = ',D15.4,2X,'W2 = ',D15.4,2X,
     .        'D3 = ',D15.4,2X,'D4 = ',D15.4)
      PRINT 412, T1,T4,D2,D5,T1,W2,E3,D3,T4,W2,E2,D4
  412 FORMAT(' T1 = ',D15.4,2X,'T4 = ',D15.4,2X,
     .        'D2 = ',D15.4,2X,'D5 = ',D15.4/
     .       ' T1 = ',D15.4,2X,'W2 = ',D15.4,2X,
     .        'E3 = ',D15.4,2X,'D3 = ',D15.4/
     .       ' T4 = ',D15.4,2X,'W2 = ',D15.4,2X,
     .        'E2 = ',D15.4,2X,'D4 = ',D15.4)
      PRINT 413, T3,T4,D4,D5,T3,WL,E1,D1,T4,WL,E2,D2
  413 FORMAT(' T3 = ',D15.4,2X,'T4 = ',D15.4,2X,
     .        'D4 = ',D15.4,2X,'D5 = ',D15.4/
     .       ' T3 = ',D15.4,2X,'WL = ',D15.4,2X,
     .        'E1 = ',D15.4,2X,'D1 = ',D15.4/
     .       ' T4 = ',D15.4,2X,'WL = ',D15.4,2X,
     .        'E2 = ',D15.4,2X,'D2 = ',D15.4)
      PRINT 414, T3,W1,D4,E1,T3,T2,D5,D1,T2,W1,D3,E4
  414 FORMAT(' T3 = ',D15.4,2X,'W1 = ',D15.4,2X,
     .        'D4 = ',D15.4,2X,'E1 = ',D15.4/
     .       ' T3 = ',D15.4,2X,'T2 = ',D15.4,2X,
     .        'D5 = ',D15.4,2X,'D1 = ',D15.4/
     .       ' T2 = ',D15.4,2X,'W1 = ',D15.4,2X,
     .        'D3 = ',D15.4,2X,'E4 = ',D15.4)
      PRINT 415, WM,T1,D2,E3,T1,T2,D5,D6,WM,T2,D1,E4
  415 FORMAT(' WM = ',D15.4,2X,'T1 = ',D15.4,2X,
     .        'D2 = ',D15.4,2X,'E3 = ',D15.4/
     .       ' T1 = ',D15.4,2X,'T2 = ',D15.4,2X,
     .        'D5 = ',D15.4,2X,'D6 = ',D15.4/
     .       ' WM = ',D15.4,2X,'T2 = ',D15.4,2X,
     .        'D1 = ',D15.4,2X,'E4 = ',D15.4)
      PRINT 400,(((PROP(I,J,IJ),IJ=1,4),J=1,3),I=1,6)
  400 FORMAT(' PROP(I,J,K) (K=1,4 J=1,3 I=1,6) = '/4(D15.4,2X))
      PRINT 401,PROMIN
  401 FORMAT(' PROMIN = ',D15.4)
      PRINT 402,(ISEL(1,J),J=1,3),
     .              ((ILZ(1,I,J),J=1,64),I=1,3)
  402 FORMAT(' ISEL(1,J) (J=1,3) = ',3I2//
     .       ' ILZ(1,I,J) (J=1,64 I=1,3) = '/
     .       3(' ',64I2/))
      PRINT 403,(ISEL(2,J),J=1,3),
     .              ((ILZ(2,I,J),J=1,64),I=1,3)
  403 FORMAT(' ISEL(2,J) (J=1,3) = ',3I2//
     .       ' ILZ(2,I,J) (J=1,64 I=1,3) = '/
     .       3(' ',64I2/))
      PRINT 404,(ISEL(3,J),J=1,3),
     .              ((ILZ(3,I,J),J=1,64),I=1,3)
  404 FORMAT(' ISEL(3,J) (J=1,3) = ',3I2//
     .       ' ILZ(3,I,J) (J=1,64 I=1,3) = '/
     .       3(' ',64I2/))
      PRINT 405,(ISEL(4,J),J=1,3),
     .              ((ILZ(4,I,J),J=1,64),I=1,3)
  405 FORMAT(' ISEL(4,J) (J=1,3) = ',3I2//
     .       ' ILZ(4,I,J) (J=1,64 I=1,3) = '/
     .       3(' ',64I2/))
      PRINT 406,(ISEL(5,J),J=1,3),
     .              ((ILZ(5,I,J),J=1,64),I=1,3)
  406 FORMAT(' ISEL(5,J) (J=1,3) = ',3I2//
     .       ' ILZ(5,I,J) (J=1,64 I=1,3) = '/
     .       3(' ',64I2/))
      PRINT 407,(ISEL(6,J),J=1,3),
     .              ((ILZ(6,I,J),J=1,64),I=1,3)
  407 FORMAT(' ISEL(6,J) (J=1,3) = ',3I2//
     .       ' ILZ(6,I,J) (J=1,64 I=1,3) = '/
     .       3(' ',64I2/))
      RETURN
      END
      FUNCTION DIAM(IPROC,INF)
C... FUNCTION DIAM CALCULATES THE COMPLETE /MATRIX ELEMENT/**2
C... FOR A GIVEN SET OF 4MOMENTA (Q1,...Q6).
C... IT USES SPINOX FOR INITIALIZATION, GETRID FOR REDUCTION
C    AND FOR THE ACTUAL CALCULATION GRAAF.
C... ALSO RESULTS ON SUBSETS OF FEYNMAN GRAPHS (MULTIPERIPHERAL,
C    BREMSSTRAHLUNG, CONVERSION AND ANNIHILATION) ARE CALCULATED.
C... ALSO THE FINAL WEIGHT IS CALCULATED. DIAM(5,INF) EQUALS THIS
C    FINAL WEIGHT.
      IMPLICIT REAL*8(A-H,O-Z)
      COMPLEX*16 DIAG,DIA1,DIA2,DIA3,DIA4,GRAAF,TEL,GRAPH,GRAP
      COMMON / INOUT  / B(6)
      COMMON / INPUT  / EB,THMIN,THMAX,ESWE,ESFT,WAP(4),WBP(4),VAP(4)
      COMMON / REDUCE / ISEL(6,3),ILZ(6,3,64)
      COMMON / SUBGRA / GRAPH(4),GRAP(4)
      COMMON /MYCOMN/ PERROR,FTADD(4),ITER
      DIMENSION L(6)
      DIMENSION DIAG(6,6,64),
     .          DIA1(6,6,64),DIA2(6,6,64),DIA3(6,6,64),DIA4(6,6,64)
      DIMENSION AT(64),AM(4,64),AB(4,64),
     .          AC1(2,64),AC2(2,64),AC3(2,64),AC4(2,64),
     .          AA1(2,64),AA2(2,64),AA3(2,64),AA4(2,64)
      DIMENSION TCHANN(4),BREMSS(4),CONVE1(2),ANNIH1(2),
     .          CONVE2(2),ANNIH2(2),CONVE3(2),ANNIH3(2),
     .          CONVE4(2),ANNIH4(2)
C
C-----INITIALIZATION-------------------------------------------------
      DATA DIAG/2304*(0.D0,0.D0)/,DIA1/2304*(0.D0,0.D0)/,
     .     DIA2/2304*(0.D0,0.D0)/,DIA3/2304*(0.D0,0.D0)/,
     .     DIA4/2304*(0.D0,0.D0)/,
     .     AT/64*0.D0/,AM/256*0.D0/,AB/256*0.D0/,
     .     AC1/128*0.D0/,AC2/128*0.D0/,AC3/128*0.D0/,AC4/128*0.D0/,
     .     AA1/128*0.D0/,AA2/128*0.D0/,AA3/128*0.D0/,AA4/128*0.D0/
      DATA INIT/0/
      IF (INIT.NE.0) GOTO 001
      INIT = 1
      B(1) = -1.D0
      B(2) = -1.D0
      B(3) =  1.D0
      B(4) =  1.D0
      B(5) =  1.D0
      B(6) =  1.D0
  001 CONTINUE
      CALL SPINOX(INF)
      CALL GETRID(IPROC,INF)
C
      DO 9999 I1=1,2
      L(1)  = 2*I1 - 3
      DO 9999 I2=1,2
      L(2)  = 2*I2 - 3
      DO 9999 I3=1,2
      L(3)  = 2*I3 - 3
      DO 9999 I4=1,2
      L(4)  = 2*I4 - 3
      DO 9999 I5=1,2
      L(5)  = 2*I5 - 3
      DO 9999 I6=1,2
      L(6)  = 2*I6 - 3
      LZ  = 33 - 16*L(1) - 8*L(2) - 4*L(3) - 2*L(4) -
     .              L(5) - (L(6)+1)/2
      DO 9998 IGR = 1,6
      CALL GROUP(IGR,K1,K2,K3,K4,K5,K6,IREL)
      DO 9997 IPER = 1,6
C
      CALL PERMU(IPER,K1,K2,K3,K4,K5,K6,J1,J2,J3,J4,J5,J6)
C
      DIAG(IGR,IPER,LZ) = (0.D0,0.D0)
      DIA1(IGR,IPER,LZ) = (0.D0,0.D0)
      DIA2(IGR,IPER,LZ) = (0.D0,0.D0)
      DIA3(IGR,IPER,LZ) = (0.D0,0.D0)
      DIA4(IGR,IPER,LZ) = (0.D0,0.D0)
      XSEL = CHOICE(IPROC,IGR,IPER)
      IF (XSEL.EQ.0.D0) GOTO 9996
      JPER = (IPER+1)/2
      IF (ISEL(IGR,JPER   ).EQ.0) GOTO 9996
      IF ( ILZ(IGR,JPER,LZ).EQ.0) GOTO 9996
      DIAG(IGR,IPER,LZ) = DFLOAT(IREL)*XSEL*
     . GRAAF(IGR,IPER,J1,L(J1),J2,L(J2),J3,L(J3),
     .                J4,L(J4),J5,L(J5),J6,L(J6),INF)
      DIA1(IGR,IPER,LZ) = GRAP(1)*DFLOAT(IREL)*XSEL
      DIA2(IGR,IPER,LZ) = GRAP(2)*DFLOAT(IREL)*XSEL
      DIA3(IGR,IPER,LZ) = GRAP(3)*DFLOAT(IREL)*XSEL
      DIA4(IGR,IPER,LZ) = GRAP(4)*DFLOAT(IREL)*XSEL
C
      IF (INF.GE.2) PRINT 2, L,LZ,IGR,IPER,LZ,DIAG(IGR,IPER,LZ)
    2 FORMAT('0 DIAG ARRAY CONTENTS : '/
     .       '  L(I),LZ = ',7I4/
     .       '  DIAG(',I2,',',I2,',',I2,') = ',2D15.6/)
 9996 CONTINUE
 9997 CONTINUE
 9998 CONTINUE
C
C CALCULATE TOTAL AND SUBTOTAL SQUARES OF AMPLITUDES
      TEL=(0.D0,0.D0)
      DO 330 IG=1,6
      DO 330 IP=1,6
      TEL = TEL + DIAG(IG,IP,LZ)
  330 CONTINUE
      AT(LZ) = CDABS(TEL)**2
C
      AM(1,LZ) = CDABS( DIA1( 6, 3,LZ) + DIA1( 6, 4,LZ) )**2
      AM(2,LZ) = CDABS( DIA1( 5, 3,LZ) + DIA1( 5, 4,LZ) )**2
      AM(3,LZ) = CDABS( DIA1( 4, 1,LZ) + DIA1( 4, 2,LZ) )**2
      AM(4,LZ) = CDABS( DIA1( 3, 1,LZ) + DIA1( 3, 2,LZ) )**2
C
      AB(1,LZ) = CDABS( DIA1( 6, 1,LZ) + DIA1( 6, 2,LZ)
     .                + DIA1( 6, 5,LZ) + DIA1( 6, 6,LZ) )**2
      AB(2,LZ) = CDABS( DIA1( 5, 1,LZ) + DIA1( 5, 2,LZ)
     .                + DIA1( 5, 5,LZ) + DIA1( 5, 6,LZ) )**2
      AB(3,LZ) = CDABS( DIA1( 4, 3,LZ) + DIA1( 4, 4,LZ)
     .                + DIA1( 4, 5,LZ) + DIA1( 4, 6,LZ) )**2
      AB(4,LZ) = CDABS( DIA1( 3, 3,LZ) + DIA1( 3, 4,LZ)
     .                + DIA1( 3, 5,LZ) + DIA1( 3, 6,LZ) )**2
C
      AC1(1,LZ) = CDABS( DIA1( 1, 5,LZ) + DIA1( 1, 6,LZ) )**2
      AC1(2,LZ) = CDABS( DIA1( 2, 5,LZ) + DIA1( 2, 6,LZ) )**2
      AC2(1,LZ) = CDABS( DIA2( 1, 5,LZ) + DIA2( 1, 6,LZ) )**2
      AC2(2,LZ) = CDABS( DIA2( 2, 5,LZ) + DIA2( 2, 6,LZ) )**2
      AC3(1,LZ) = CDABS( DIA3( 1, 5,LZ) + DIA3( 1, 6,LZ) )**2
      AC3(2,LZ) = CDABS( DIA3( 2, 5,LZ) + DIA3( 2, 6,LZ) )**2
      AC4(1,LZ) = CDABS( DIA4( 1, 5,LZ) + DIA4( 1, 6,LZ) )**2
      AC4(2,LZ) = CDABS( DIA4( 2, 5,LZ) + DIA4( 2, 6,LZ) )**2
C
      AA1(1,LZ) = CDABS( DIA1( 1, 1,LZ) + DIA1( 1, 2,LZ)
     .                 + DIA1( 1, 3,LZ) + DIA1( 1, 4,LZ) )**2
      AA1(2,LZ) = CDABS( DIA1( 2, 1,LZ) + DIA1( 2, 2,LZ)
     .                 + DIA1( 2, 3,LZ) + DIA1( 2, 4,LZ) )**2
      AA2(1,LZ) = CDABS( DIA2( 1, 1,LZ) + DIA2( 1, 2,LZ)
     .                 + DIA2( 1, 3,LZ) + DIA2( 1, 4,LZ) )**2
      AA2(2,LZ) = CDABS( DIA2( 2, 1,LZ) + DIA2( 2, 2,LZ)
     .                 + DIA2( 2, 3,LZ) + DIA2( 2, 4,LZ) )**2
      AA3(1,LZ) = CDABS( DIA3( 1, 1,LZ) + DIA3( 1, 2,LZ)
     .                 + DIA3( 1, 3,LZ) + DIA3( 1, 4,LZ) )**2
      AA3(2,LZ) = CDABS( DIA3( 2, 1,LZ) + DIA3( 2, 2,LZ)
     .                 + DIA3( 2, 3,LZ) + DIA3( 2, 4,LZ) )**2
      AA4(1,LZ) = CDABS( DIA4( 1, 1,LZ) + DIA4( 1, 2,LZ)
     .                 + DIA4( 1, 3,LZ) + DIA4( 1, 4,LZ) )**2
      AA4(2,LZ) = CDABS( DIA4( 2, 1,LZ) + DIA4( 2, 2,LZ)
     .                 + DIA4( 2, 3,LZ) + DIA4( 2, 4,LZ) )**2
C
C      IF(INF.GE.2) PRINT 329,AT(LZ),(AM(M4,LZ),M4=1,4),
C     . (AB(M4,LZ),M4=1,4),(AC(M2,LZ),M2=1,2),(AA(M2,LZ),M2=1,2)
C  329 FORMAT(' CONTRIBUTIONS: TOT,M,B,C,A :',D15.6/2(6(D15.6,2X)/))
 9999 CONTINUE
C
C SUM OVER HELICITIES
      TOTAAL = 0.D0
      DO 9995 M2=1,2
      M4 = M2+ 2
      TCHANN(M2) = 0.D0
      TCHANN(M4) = 0.D0
      BREMSS(M2) = 0.D0
      BREMSS(M4) = 0.D0
      CONVE1(M2) = 0.D0
      CONVE2(M2) = 0.D0
      CONVE3(M2) = 0.D0
      CONVE4(M2) = 0.D0
      ANNIH1(M2) = 0.D0
      ANNIH2(M2) = 0.D0
      ANNIH3(M2) = 0.D0
      ANNIH4(M2) = 0.D0
 9995 CONTINUE
      DO 331 LHEL=1,64
      TOTAAL = TOTAAL + AT(LHEL)
      DO 331 M2=1,2
      M4 = M2 + 2
      TCHANN(M2) = TCHANN(M2) + AM(M2,LHEL)
      TCHANN(M4) = TCHANN(M4) + AM(M4,LHEL)
      BREMSS(M2) = BREMSS(M2) + AB(M2,LHEL)
      BREMSS(M4) = BREMSS(M4) + AB(M4,LHEL)
      CONVE1(M2) = CONVE1(M2) + AC1(M2,LHEL)
      CONVE2(M2) = CONVE2(M2) + AC2(M2,LHEL)
      CONVE3(M2) = CONVE3(M2) + AC3(M2,LHEL)
      CONVE4(M2) = CONVE4(M2) + AC4(M2,LHEL)
      ANNIH1(M2) = ANNIH1(M2) + AA1(M2,LHEL)
      ANNIH2(M2) = ANNIH2(M2) + AA2(M2,LHEL)
      ANNIH3(M2) = ANNIH3(M2) + AA3(M2,LHEL)
      ANNIH4(M2) = ANNIH4(M2) + AA4(M2,LHEL)
  331 CONTINUE
C
C SELECT YOUR FAVORITE PROCESS !
C FACTOR 1/4 TAKES AVERAGING OVER E+E- SPINS INTO ACCOUNT.
      TOTAAL = 0.25D0*TOTAAL
      DO 333 M2=1,2
      M4 = M2 + 2
      TCHANN(M2) = 0.25D0*TCHANN(M2)*WAP(1)
      TCHANN(M4) = 0.25D0*TCHANN(M4)*WAP(1)
      BREMSS(M2) = 0.25D0*BREMSS(M2)*WAP(2)
      BREMSS(M4) = 0.25D0*BREMSS(M4)*WAP(2)
      CONVE1(M2) = 0.25D0*CONVE1(M2)*WAP(3)
      CONVE2(M2) = 0.25D0*CONVE2(M2)*WAP(3)
      CONVE3(M2) = 0.25D0*CONVE3(M2)*WAP(3)
      CONVE4(M2) = 0.25D0*CONVE4(M2)*WAP(3)
      ANNIH1(M2) = 0.25D0*ANNIH1(M2)*WAP(4)
      ANNIH2(M2) = 0.25D0*ANNIH2(M2)*WAP(4)
      ANNIH3(M2) = 0.25D0*ANNIH3(M2)*WAP(4)
      ANNIH4(M2) = 0.25D0*ANNIH4(M2)*WAP(4)
  333 CONTINUE
      IF (INF.GE.1.AND.ITER.EQ.1)
     &   PRINT 332,TOTAAL,TCHANN,BREMSS,CONVE1,CONVE2,
     .                 CONVE3,CONVE4,ANNIH1,ANNIH2,ANNIH3,ANNIH4
  332 FORMAT('0---------------- FINALLY : --------------'/
     .       ' SUM OF ALL FEYNMAN DIAGRAMS =',D15.6/
     .       ' MULTIPERIPHERAL GRAPHS ONLY =',4(D15.6,2X)/
     .       '  BREMSSTRAHLUNG GRAPHS ONLY =',4(D15.6,2X)/
     .       '  TWO-PHOTON CONVERSION ONLY =',4(D15.6,2X)/
     .       '                              ',4(D15.6,2X)/
     .       '   ANNIHILATION CHANNEL ONLY =',4(D15.6,2X)/
     .       '                              ',4(D15.6,2X))
      GOTO (1001,1002,1003,1004,1005,1002) , IPROC
 1001 SUM1 = CONVE1(1)+ANNIH1(1)+
     .       CONVE2(1)+ANNIH2(1)+
     .       CONVE3(1)+ANNIH3(1)+
     .       CONVE4(1)+ANNIH4(1)
      DIAM = TOTAAL/SUM1
      RETURN
 1002 SUM2 = CONVE1(1)+CONVE1(2)+ANNIH1(1)+ANNIH1(2)+
     .       CONVE2(1)+CONVE2(2)+ANNIH2(1)+ANNIH2(2)+
     .       CONVE3(1)+CONVE3(2)+ANNIH3(1)+ANNIH3(2)+
     .       CONVE4(1)+CONVE4(2)+ANNIH4(1)+ANNIH4(2)
      DIAM = TOTAAL/SUM2
      RETURN
 1003 SUM3 = TCHANN(1)+BREMSS(1)+CONVE1(1)+ANNIH1(1)
     .                          +CONVE2(1)+ANNIH2(1)
     .                          +CONVE3(1)+ANNIH3(1)
     .                          +CONVE4(1)+ANNIH4(1)
      DIAM = TOTAAL/SUM3
      RETURN
 1004 SUM4 = TCHANN(1)+BREMSS(1)+CONVE1(1)+ANNIH1(1)
     .                          +CONVE2(1)+ANNIH2(1)
     .                          +CONVE3(1)+ANNIH3(1)
     .                          +CONVE4(1)+ANNIH4(1)
      DIAM = TOTAAL/SUM4
      RETURN
 1005 SUM5 = TCHANN(1)+TCHANN(2)+TCHANN(3)+TCHANN(4)+
     .       BREMSS(1)+BREMSS(2)+BREMSS(3)+BREMSS(4)+
     .       CONVE1(1)+CONVE1(2)+ANNIH1(1)+ANNIH1(2)+
     .       CONVE2(1)+CONVE2(2)+ANNIH2(1)+ANNIH2(2)+
     .       CONVE3(1)+CONVE3(2)+ANNIH3(1)+ANNIH3(2)+
     .       CONVE4(1)+CONVE4(2)+ANNIH4(1)+ANNIH4(2)
      DIAM = TOTAAL/SUM5
      RETURN
      END
      FUNCTION DIAG2(P1,Q1,M1,P2,Q2,M2,P3,Q3,M3,IDUMP)
C... DIAG2 CALCULATES THE /MATRIX ELEMENT/**2 OF TWO GAUGE
C    INVARIANT FEYNMAN DIAGRAMS.
C... DIAG2 IS USED IN MCA, MCB, MCC AND MCD TO CALCULATE XME.
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON /DIAG  / T1,T2,W2,DD1,DD2,DD3,DD4,R14,R24
      REAL*8 M1,M2,M3,M1K,M2K,M3K
      DIMENSION P1(4),Q1(4),P2(4),Q2(4),P3(4),Q3(4),
     .          D1(4),D2(4),E1(4),E2(4),R1(4),R2(4)
C-------------------------------------------------------------------
      M1K=M1*M1
      M2K=M2*M2
      M3K=M3*M3
      IF (IDUMP.EQ.5) PRINT 99,T1,T2,W2,DD1,DD2,DD3,DD4,R14,R24
   99 FORMAT(' COMMON DIAG : '/3(1X,3(D35.25,2X)/))
      DO 1 I=1,4
      D1(I) = P1(I) + Q1(I)
      D2(I) = P2(I) + Q2(I)
      R1(I) = P1(I) - Q1(I)
      R2(I) = P2(I) - Q2(I)
    1 CONTINUE
      IF (IDUMP.EQ.5) PRINT 100, R1(4),R2(4)
  100 FORMAT(' R1(4) R2(4) = ',2(D35.25,2X))
      Z1    = - D1(4)/R14
      Z2    = - D2(4)/R24
      IF (IDUMP.EQ.5) PRINT 101, R14,R24
  101 FORMAT(' R14 R24     = ',2(D35.25,2X))
      DO 2 I=1,4
      E1(I) = D1(I) + Z1*R1(I)
      E2(I) = D2(I) + Z2*R2(I)
    2 CONTINUE
C-------------------------------------------------------------------
C      T1    = DOT(R1,R1)
C      T2    = DOT(R2,R2)
C      W2    = DOT(P3,Q3)*2.D0+2.D0*M3K
      Q11   = DOT(P3,D1)
      Q12   = DOT(P3,D2)
      Q21   = DOT(Q3,D1)
      Q22   = DOT(Q3,D2)
      P11   = DOT(P3,E1)-0.5D0*Z1*T1
      P12   = DOT(P3,E2)-0.5D0*Z2*T2
      P21   = DOT(Q3,E1)-0.5D0*Z1*T1
      P22   = DOT(Q3,E2)-0.5D0*Z2*T2
      D     = DOT(E1,E2)
      D0    = DOT(D1,D2)
      IF (IDUMP.EQ.5) PRINT 102, D,D0
  102 FORMAT(' D D0 = ',2(D35.25,2X))
C      DD1   = T1-2.D0*DOT(P3,R1)
C      DD2   = T2-2.D0*DOT(P3,R2)
C-------------------------------------------------------------------
      XM1   = (P11*P11+T1*(0.25D0*T1+M3K+M1K))*
     .        (P22*P22+T2*(0.25D0*T2+M3K+M2K))
      IF (IDUMP.EQ.5) PRINT 103, XM1
  103 FORMAT(' XM1 = ',D35.25)
      XM2   = (P21*P21+T1*(0.25D0*T1+M3K+M1K))*
     .        (P12*P12+T2*(0.25D0*T2+M3K+M2K))
      IF (IDUMP.EQ.5) PRINT 104, XM2
  104 FORMAT(' XM2 = ',D35.25)
      XM3   = 2.D0*P11*P12*P21*P22+D*DD1*P12*P21+D*DD2*P11*P22+
     .        0.25D0*D*D*DD1*DD2-M1K*M2K*(T1+T2-W2)**2-
     .        2.D0*P11*P21*T2*(0.25D0*T2+M3K+M2K)-
     .        2.D0*P12*P22*T1*(0.25D0*T1+M3K+M1K)-
     .        M1K*T2*(Q12+Q22)**2-M2K*T1*(Q11+Q21)**2-
     .        0.25D0*(DD1-DD2)**2*(M2K*T1+M1K*T2)
      IF (IDUMP.EQ.5) PRINT 105, XM3
  105 FORMAT(' XM3 = ',D35.25)
      XM4   = 0.0625D0*T1*T2*(-4.D0*(Q11-Q21)**2-4.D0*(Q12-Q22)**2-
     .        4.D0*D0*D0-(W2+T1+T2)**2-16.D0*(W2-T1-T2)*M3K-
     .        16.D0*W2*(M1K+M2K)+
     .        32.D0*(0.25D0*T1-M1K-M3K)*(0.25D0*T2-M2K-M3K))
      IF (IDUMP.EQ.5) PRINT 106, XM4
  106 FORMAT(' XM4 = ',D35.25)
C-------------------------------------------------------------------
      DIAG2  = -(XM1/DD1/DD1+XM2/DD2/DD2+(XM3+XM4)/DD1/DD2)/
     .          T1/T1/T2/T2*32.D0
      IF (IDUMP.EQ.5) PRINT 107, DIAG2
  107 FORMAT(' DIAG2 = ',D35.25)
      RETURN
      END
      FUNCTION DIAG4(P1,Q1,M1,P2,Q2,M2,P3,Q3,M3)
C... INTERFERENCE CALCULATION BETWEEN 4 BREMSSTRAHLUNG OR
C    ANNIHILATION GRAPHS.(MORE PRECISELY: THE INTERFERENCE BETWEEN
C    BREMSSTRAHLUNG FROM THE ELECTRON AND BREMSSTRAHLUNG FROM THE
C    POSITRON LINE)
C... DIAG4 IS USED IN MCB AND MCD.
      IMPLICIT REAL*8(A-H,O-Z)
      REAL*8 M1,M2,M3,M1K,M2K,M3K,M12
      COMMON /DIAG  / T1,T2,W2,D3,D4,D5,D6,U8,U9
      DIMENSION P1(4),Q1(4),P2(4),Q2(4),P3(4),Q3(4),E(4)
C------------------------------------------------------------------
      M1K  = M1*M1
      M2K  = M2*M2
      M3K  = M3*M3
      M12  = M1K+M2K
C------------------------------------------------------------------
      DO 1 I=1,4
      E(I) = Q3(I) - P3(I)
    1 CONTINUE
      DP1P2  = DOT(P1,P2)
      DQ1Q2  = DOT(Q1,Q2)
      DP1Q2  = DOT(P1,Q2)
      DP2Q1  = DOT(P2,Q1)
      DP1Q1  = DOT(P1,Q1)
      DP2Q2  = DOT(P2,Q2)
C------------------------------------------------------------------
      S      =  2.D0*DP1P2+M12
      SE     =  2.D0*DP1P2
      SW     =  2.D0*DP1P2-M12
      U1     = -2.D0*DP1Q2+M12
      U1E    = -2.D0*DP1Q2
      U1W    = -2.D0*DP1Q2-M12
      U2     = -2.D0*DP2Q1+M12
      U2E    = -2.D0*DP2Q1
      U2W    = -2.D0*DP2Q1-M12
      S1     =  2.D0*DQ1Q2+M12
      S1E    =  2.D0*DQ1Q2
      S1W    =  2.D0*DQ1Q2-M12
C      T1     = -2.D0*DP1Q1+2.D0*M1K
C      T2     = -2.D0*DP2Q2+2.D0*M2K
C      W2     =  2.D0*M3K + 2.D0*DOT(P3,Q3)
      P11    =  DOT(E,P2)
      P12    =  DOT(E,P1)
      P21    =  DOT(E,Q2)
      P22    =  DOT(E,Q1)
C------------------------------------------------------------------
C      D3     =  SE  + U1E + T2
C      D4     =  S1E + U2E + T2
C      D5     =  SE  + U2E + T1
C      D6     =  S1E + U1E + T1
C------------------------------------------------------------------
      X1 = 32.D0*(P11+P21)*(P12+P22)
     .   + 32.D0*((SW *SW +U1W*U2W-2.D0*M12*M12)*P22*P21-
     .             W2*(M1K*P11*P22+M2K*P12*P21))/(D3*D5)
     .   + 32.D0*((U1W*U1W+SW *S1W-2.D0*M12*M12)*P11*P22-
     .             W2*(M1K*P21*P22+M2K*P11*P12))/(D3*D6)
     .   + 32.D0*((U2W*U2W+SW *S1W-2.D0*M12*M12)*P12*P21-
     .             W2*(M1K*P11*P12+M2K*P21*P22))/(D4*D5)
     .   + 32.D0*((S1W*S1W+U1W*U2W-2.D0*M12*M12)*P11*P12-
     .             W2*(M1K*P12*P21+M2K*P11*P22))/(D4*D6)
      X2 = 16.D0*W2*((P11+P12)**2+(P12-P21)**2)*
     .     (SE/(D3*D5)-U1E/(D3*D6)-U2E/(D4*D5)+S1E/(D4*D6))
      X3 = -32.D0*(SW *P22*(P11+P12)+U1W*P22*(P11-P22))/D3
     .     -32.D0*(S1W*P12*(P21+P22)+U2W*P12*(P21-P12))/D4
     .     -32.D0*(SW *P21*(P11+P12)-U2W*P21*(P11-P22))/D5
     .     -32.D0*(S1W*P11*(P21+P22)-U1W*P11*(P21-P12))/D6
      X4 = 8.D0*W2*(SE*SE+U1E*U1E+U2E*U2E+S1E*S1E)*
     .     (SE/(D3*D5)-U1E/(D3*D6)-U2E/(D4*D5)+S1E/(D4*D6))
      X5 = 4.D0*(4.D0*M3K-W2)*((S-S1)**2-(U1-U2)**2)*
     .     (T2/(D3*D4)+T1/(D5*D6))
      X6 = -8.D0*(4.D0*M3K+W2)*W2*T1*T2*((S-S1)**2-(U1-U2)**2)/
     .     (D3*D4*D5*D6)
      X7 = 16.D0*W2*M12*(T1+T2+W2)*
     .     (SE/(D3*D5)-U1E/(D3*D6)-U2E/(D4*D5)+S1E/(D4*D6))
      X8 = -32.D0*M1K*W2*(S -U1)/D3
     .     -32.D0*M1K*W2*(S1-U2)/D4
     .     -32.D0*M2K*W2*(S -U2)/D5
     .     -32.D0*M2K*W2*(S1-U1)/D6
      X9 = 4.D0*(4.D0*M3K-W2)*(W2*(S1-S )+(T1-T2)*(U1-U2))*SE /(D3*D5)
     .    -4.D0*(4.D0*M3K-W2)*(W2*(U2-U1)+(T1-T2)*(S -S1))*U1E/(D3*D6)
     .    -4.D0*(4.D0*M3K-W2)*(W2*(U1-U2)+(T1-T2)*(S1-S ))*U2E/(D4*D5)
     .    +4.D0*(4.D0*M3K-W2)*(W2*(S -S1)+(T1-T2)*(U2-U1))*S1E/(D4*D6)
C------------------------------------------------------------------
      DIAG4 = (X1+X2+X3+X4+X5+X6+X7+X8+X9)/(T1*T2*W2*W2)
      RETURN
      END
      FUNCTION DOT(A,B)
C-------------------------------------------------------------------
C  DOT PRODUCT OF FOUR-VECTORS IN MINKOWSKI METRIC
C-------------------------------------------------------------------
      IMPLICIT REAL*8(A-H,O-Z)
      DIMENSION A(4),B(4)
      DOT   = A(4)*B(4)-A(1)*B(1)-A(2)*B(2)-A(3)*B(3)
      RETURN
      END
      REAL FUNCTION RNF100(IGEN)
C DON'T FORGET TO INITIALIZE RNF100
CB    IMPLICIT REAL*8(A-H,O-Z)
CCC   THIS IS QUASIRANDOM SHUFFLING TYPE RANDOM NUMBER GENERATOR
CCC   EQUIVALENT TO THAT IN FOWL CERN PROGRAM LIBRARY W-505
CCC   IT CONTAINS NGEN INDEPENDENT PARALLEL SUBGENERATORS INDEXED
CCC   WITH IGEN PARAMETER ( GENERALLY NGEN.LE.20 )
CB    COMMON /RNF/ INIRAN,NGEN
CB    DIMENSION BUFOR(480)
CCC   RANDOM NUMBERS PASS THROUGH A BUFFER ( MATRIX BUFOR ) OF THE
CCC   LENGTH NGEN*LENBUF IN ORDER TO KILL CORRELATIONS BETWEEN
CCC   SUBGENERATORS. EVERY SUBGENNERATOR SHOULD SERVICE ONE INTEGRATION
CCC   VARIABLE. INIRAN IS AN INITIALIZATION POSITIVE INTEGER PARAMETER
CCC   COMMON TO ALL SUBGENERATORS.
CCC   LENBUF SHOULD NOT BE LESS THEN NGEN.
CCC                 ***  WARNING   ***
CCC   THIS PARTICULAR VERSION IS LIMITED TO 12 SUBGENERATORS, FOR MORE
CCC   ONE SHOULD EXTEND BUFOR AND LENBUF
CCC                 ******************
CB    DIMENSION QQCONS(20),SSER(20)
CB    REAL*4 XLEN,RNDM
CB    DATA LENBUF/40/
CB    DATA QQCONS /2.D0,3.D0,5.D0,7.D0,11.D0,13.D0,17.D0,19.D0,23.D0,
CB   .             29.D0,31.D0,37.D0,41.D0,43.D0,47.D0,53.D0,59.D0,
CB   .             61.D0,67.D0,71.D0/
CB    IF(IGEN.GT.0) GO TO 300
CB    XLEN=FLOAT(LENBUF)
CB    DO 30 IGN=1,NGEN
CB    QQCONS(IGN)=DSQRT(QQCONS(IGN))
CB    NDEX=LENBUF*(IGN-1)
CB    SER=INIRAN
CB    DO 29 K=1,LENBUF
CB    INDEX=NDEX+K
CB    BUFOR(INDEX)=DMOD((SER*QQCONS(IGN)),1.D0)
CB 29 SER=SER+1.
CB 30 SSER(IGN)=SER
CB    RNF100=0.D0
CB    RETURN
C
C
CB300 CONTINUE
CB    INDEX=LENBUF*(IGEN-1)+IFIX(XLEN*RNDM(1.))+1
CB    RNF100=BUFOR(INDEX)
CB    IF ((RNF100.LE.0.D0).OR.(RNF100.GE.1.D0)) PRINT 1,RNF100
CB  1 FORMAT(' ***WARNING*** RNF100 = ',D35.25)
CB    SER=SSER(IGEN)
CB    BUFOR(INDEX)=DMOD((SER*QQCONS(IGEN)),1.D0)
CB    SSER(IGEN)=SER+1.
CB    REPLACES RNF100 BY RNDM TO BE ABLE TO USE RANMAR
      RNF100 = RNDM(DUM)
      RETURN
C
      END
C Pick up RNDM from CERNLIBS  - J.H.
C      FUNCTION RNDM(DUMM)
C      COMMON /TRANS / IY
C      DATA IC /65536/
C      IY=IY*25
C      IY=MOD(IY,IC)
C      IY=IY*125
C      IY=MOD(IY,IC)
C      RNDM=FLOAT(IY)/FLOAT(IC)
C      RETURN
C      END
      SUBROUTINE HISTO1(IH,XNAME,IBB,XX0,XX1,X,W)
C THIS VERSION CAN NOT BE USED ON WATFIV COMPILER
C ONE CAN MAKE HISTO SUITABLE FOR WATFIV BY OMITTING
C THE INPUT PARAMETER XNAME
C FILLING OF HISTOGRAM
C IH=HISTOGRAM NUMBER
C IB=NUMBER OF ENTRIES IN HISTOGRAM
C X0=LOWER LIMIT OF HISTOGRAM RANGE
C X1=UPPER LIMIT OF HISTOGRAM RANGE
C X =VALUE TO BE BINNED
C W =WEIGHT CORRESPONDING WITH VALUE X
      IMPLICIT REAL*8(A-H,K-Z)
      LOGICAL*1 R,LINE,BLANK,STAR
      DIMENSION HISTO(20,50),R(80),LINE(10),XMAX(20)
      DIMENSION LOW(20),HIGH(20),XEMIN(20),XEMAX(20)
      DIMENSION CALL(20),SOM(20),HISTW(20,50),LOWW(20),HIGHW(20)
      DIMENSION RAT(20,50),HNAME(20),X0(20),X1(20)
      DIMENSION IB(20)
      DATA R/80*1H /,LINE/4*1H-,1H+,4*1H-,1HI/
      DATA STAR/1H*/,BLANK/1H /
      DATA XMAX/20*0.D0/
      DATA LOW/20*0.D0/,HIGH/20*0.D0/,LOWW/20*0.D0/,HIGHW/20*0.D0/
      DATA RAT/1000*0.D0/
      DATA XEMIN/20*1.D+09/,XEMAX/20*-1.D+09/
      DATA CALL/20*0.D0/,SOM/20*0.D0/
      DATA HISTO/1000*0.D0/,HISTW/1000*0.D0/
      IF (CALL(IH).NE.0.D0) GOTO 20
      HNAME(IH)=XNAME
      IB(IH)=IBB
      X0(IH)=XX0
      X1(IH)=XX1
   20 CONTINUE
      CALL(IH)=CALL(IH)+W
      SOM(IH)=SOM(IH)+X*W
      IX=IDINT(DFLOAT(IB(IH))*(X-X0(IH))/(X1(IH)-X0(IH)))+1
      IF (XEMIN(IH).GT.X) XEMIN(IH)=X
      IF (XEMAX(IH).LT.X) XEMAX(IH)=X
      IF(X.LT.X0(IH)) GOTO 101
      IF(X.GT.X1(IH)) GOTO 102
      HISTW(IH,IX)=HISTW(IH,IX)+1.D0
      HISTO(IH,IX)=HISTO(IH,IX)+W
      XMAX(IH)=DMAX1(XMAX(IH),HISTO(IH,IX))
      RETURN
  101 LOW(IH)=LOW(IH)+1.D0
      LOWW(IH)=LOWW(IH)+W
      RETURN
  102 HIGH(IH)=HIGH(IH)+1.D0
      HIGHW(IH)=HIGHW(IH)+W
      RETURN
      ENTRY HISTO2(IH)
C PRINTING OF HISTOGRAM
C ILOG=0 LINEAR SCALE
C ILOG=1 LOGARITHMIC SCALE
      ILOG = 0
      IF ((XEMIN(IH).GT.X1(IH)).OR.(XEMAX(IH).LT.X0(IH))) GOTO 21
      PRINT 1,IH,HNAME(IH),((LINE(I),I=1,10),J=1,8)
    1 FORMAT(1H1,/,1H ,'HISTOGRAM NUMBER',I4,/,1H ,10X,
     .       1A8,32X,80A1)
      XMAX(IH)=XMAX(IH)*1.0000001D0
      II=IB(IH)
      DO 6 I=1,II
      IF (HISTW(IH,I).EQ.0.D0) GOTO 15
      RAT(IH,I)=HISTO(IH,I)/HISTW(IH,I)
   15 CONTINUE
      IF(ILOG.EQ.1) GOTO 2
      IK=IDINT(80.D0*HISTO(IH,I)/XMAX(IH))+1
      GOTO 3
    2 IF(HISTO(IH,I).LE.0.D0) GOTO 4
      IK=IDINT(80.D0*DLOG(HISTO(IH,I))/DLOG(XMAX(IH)))+1
      IF (IK.LE.0) IK=1
    3 R(IK)=STAR
    4 BIN=X0(IH)+(X1(IH)-X0(IH))/DFLOAT(II)*DFLOAT(I)
      IF (HISTW(IH,I).EQ.0.D0) GOTO 16
      PRINT 5,BIN,HISTW(IH,I),HISTO(IH,I),RAT(IH,I),(R(J),J=1,80)
    5 FORMAT(1H ,4G12.4,1X,1HI,80A1,1HI)
      GOTO 17
   16 PRINT 18,BIN,(R(J),J=1,80)
   18 FORMAT(1H ,G12.4,37X,1HI,80A1,1HI)
   17 CONTINUE
C
      R(IK)=BLANK
    6 CONTINUE
      PRINT 7,((LINE(I),I=1,10),J=1,8)
    7 FORMAT(1H ,50X,80A1)
      IF(ILOG.EQ.0) PRINT 8
    8 FORMAT(1H ,41X,'LINEAR SCALE')
      IF(ILOG.EQ.1) PRINT 9
    9 FORMAT(1H ,41X,'LOGARITHMIC SCALE')
      PRINT 10,LOW(IH),LOWW(IH),HIGH(IH),HIGHW(IH)
   10 FORMAT(1H0,10X,'UNDERFLOW ',F10.1,5X,'WEIGHTED UNDERFLOW ',
     .       F19.6,/,1H ,11X,'OVERFLOW ',F10.1,5X,
     .       ' WEIGHTED OVERFLOW ',F19.6)
      ME=SOM(IH)/CALL(IH)
      PRINT 11,XEMIN(IH),XEMAX(IH),ME
   11 FORMAT(1H0,10X,'MIN. ENTRY = ',G15.4,/,1H ,10X,
     .    'MAX. ENTRY = ',G15.4,/,1H ,10X,'WEIGHTED MEAN ENTRY = '
     .    ,G15.4)
      RETURN
   21 PRINT 22,XEMIN(IH),XEMAX(IH),X0(IH),X1(IH)
   22 FORMAT(' ',6X,'CHANGE UPPER OR LOWER LIMIT ON ENTRIES',/,
     .           7X,'MIN. ENTRY = ',G15.4,2X,'MAX. ENTRY = ',G15.4,/,
     .           7X,'X0         = ',G15.4,2X,'X1         = ',G15.4)
      RETURN
      END
      DOUBLEPRECISION FUNCTION TWORND(ARG)
C Try to round ARG to 2 significant digits  J.Hilgart June, 1989
C INPUT arguments
C   ARG : no. to be rounded
C OUTPUT
C   TWORND : value of ARG roundedto 2 significant places
C
      REAL*8 ARG,ARR(-11:10)
      DATA IONC /0/
C
      IF (IONC.EQ.0) THEN
         ARR(-11) = 1.D-10
         DO 1 ID = -10, 10
 1          ARR(ID) = ARR(ID-1)*10.D0
         IONC = 1
      ENDIF
C
      IER = 1
      TWORND = ARG
      IF (ARG.LT.ARR(-10) .OR. ARG.GT.ARR(10))  GOTO 999
      DO 11 ID = -9, 10
 11      IF (ARG.LT.ARR(ID))  GOTO 12
   12 CONTINUE
      TMPA = ARG/ARR(ID-2)
      IMPA= NINT(TMPA)
      TWORND = DBLE(FLOAT(IMPA))*ARR(ID-2)
  999 RETURN
      END