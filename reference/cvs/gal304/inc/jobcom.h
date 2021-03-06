*CD jobcom
      PARAMETER (LOFFMC = 1000)
      PARAMETER (LHIS=20, LPRI=20, LTIM=6, LPRO=6, LRND=3)
      PARAMETER (LBIN=20, LST1=LBIN+3, LST2=3)
      PARAMETER (LSET=15, LTCUT=5, LKINP=20)
      PARAMETER (LDET=9,  LGEO=LDET+4, LBGE=LGEO+5)
      PARAMETER (LCVD=10, LCIT=10, LCTP=10, LCEC=15, LCHC=10, LCMU=10)
      PARAMETER (LCLC=10, LCSA=10, LCSI=10)
      COMMON /JOBCOM/   JDATJO,JTIMJO,VERSJO
     &                 ,NEVTJO,NRNDJO(LRND),FDEBJO,FDISJO
     &                 ,FBEGJO(LDET),TIMEJO(LTIM),NSTAJO(LST1,LST2)
     &                 ,IDB1JO,IDB2JO,IDB3JO,IDS1JO,IDS2JO
     &                 ,MBINJO(LST2),MHISJO,FHISJO(LHIS)
     &                 ,IRNDJO(LRND,LPRO)
     &                 ,IPRIJO(LPRI),MSETJO,IRUNJO,IEXPJO,AVERJO
     3                 ,MPROJO,IPROJO(LPRO),MGETJO,MSAVJO,TIMLJO,IDATJO
     5                 ,TCUTJO(LTCUT),IBREJO,NKINJO,BKINJO(LKINP),IPACJO
     6                 ,IDETJO(LDET),IGEOJO(LGEO),LVELJO(LGEO)
     7                 ,ICVDJO(LCVD),ICITJO(LCIT),ICTPJO(LCTP)
     8                 ,ICECJO(LCEC),ICHCJO(LCHC),ICLCJO(LCLC)
     9                 ,ICSAJO(LCSA),ICMUJO(LCMU),ICSIJO(LCSI)
     &                 ,FGALJO,FPARJO,FXXXJO,FWRDJO,FXTKJO,FXSHJO,CUTFJO
     &                 ,IDAFJO,IDCHJO,TVERJO
      LOGICAL FDEBJO,FDISJO,FHISJO,FBEGJO,FGALJO,FPARJO,FXXXJO,FWRDJO
     &       ,FXTKJO,FXSHJO
      COMMON /JOBKAR/   TITLJO,TSETJO(LSET),TPROJO(LPRO)
     1                 ,TKINJO,TGEOJO(LBGE),TRUNJO
      CHARACTER TRUNJO*60
      CHARACTER*4 TKINJO,TPROJO,TSETJO,TITLJO*40
      CHARACTER*2 TGEOJO
C
#include "joberr.h"
#if defined(DOC)

                         JOB parameters set by data cards

       LOFFMC            MonteCarlo offset to define experiment # ,
                         run type, event type and event status
       LHIS              histogram flag dimension
       LPRI              print flag dimension
       LTIM              time limit dimension
       LPRO              process flag dimension
       LRND              maximum number of random generator seeds
       LBIN              pseudo-histogram number of bins
       LST1              1st dimension of the statistic array
       LST2              2nd dimension of the statistic array
       LSET              set array dimension
       LTCUT             tracking cut array dimension
       LKINP             kinematic parameter array dimension
       LDET              number of detectors
       LGEO              number of components
       LBGE              number of geo. name-indices
       JDATJO            date of the day
       JTIMJO            time of the day
       VERSJO            program version number
       NEVTJO            current event #
       NRNDJO            first random number used by the current event
       FDEBJO            debug flag of the current event
       FDISJO            display flag of the current event
       FBEGJO (1-ldet)   beginning of detector module flags
       TIMEJO (1-ltim)   time in msec
                 1       initial time given by TIMED (ASIJOB)
                 2       time left given by TIMEL    (ASIEVE)
                 3       time elapsed since beginning of job (ASCRUN)
                 4       time
                 5       time spent before 1st event  (ASIEVE)
                 6       time spent to end the run    (ASCRUN
       NSTAJO            statistic array
       IDB1JO            first trigger to be debugged
       IDB2JO            last trigger to be debugged
       IDB3JO            period to keep 1st random number
       IDS1JO            first trigger to be dispayed
       IDS2JO            last  trigger to be displayed
       MBINJO            pseudo-hist. number of bins
       MHISJO            if > 0 histograms are required
       FHISJO (1-lhis)   histogram flags
                         set to TRUE in ASIEVE
                1        VDET  hit process
                2        ITC   -----------
                3        TPC   -----------
                4        ECAL  -----------
                5        LCAL  -----------
                6        SATR  -----------
                7        HCAL  -----------
                8        MUON  -----------
                9        SICAL -----------
                11       apply trigger process
                12       RDST process
       IRNDJO (1-lpro)   set of random numbers
                 1       kinematics root
                 2       tracking root
                 3       hit root
                 4       digitizing root
                 5       trigger root
                 6       RDST root
       IPRIJO (1-lpri)   print flags
                1        VDET
                2        ITC
                3        TPC
                4        ECAL
                5        LCAL
                6        SATR
                7        HCAL
                8        MUON
                9        SICAL
               11        TRIGGER process
               12        RDST process
               13        draw each track element during an interactive session
               14        output banks (ASRUNH, ASEVST)
               15        input banks  (ASRETP)
               16        KINE and VERT banks
               17        track element at each step (GUSTEP)
               18        IMPA banks
               19        geometry
               20        PART bank
       MSETJO            maximum number of sets defined for the job
       MPROJO            maximum number of blocks processed during the j
       IPROJO (1-lpro)   = 1 if the block must be processed
       AVERJO            ALEPHLIB version #
       IEXPJO            experiment #
       MGETJO            = 1 if blocks are read from disk/tape
       MSAVJO            = 1 if blocks are saved onto disk/tape
       TIMLJO            time required to run 1 event and end the job
       IDATJO            date of the requested survey file
       IRUNJO            run number
       TCUTJO            energy cuts used during tracking
                  1      for electrons
                  2          gammas
                  3          charged hadrons
                  4          neutral hadrons
                  5          muons
        IBREJO           Bremsstrahlung cross-section mode:
                         = 1 simple parametrization of the energy
                             spectrum of gammas
                         = 2 more sophisticated approach
        NKINJO           number of kine parameters in BKINJO
        BKINJO (1-lkinp) kinematics parameters
                  1      sigma of the x-vertex
                  2      - - -  - - - y-vertex
                  3      - - - - - -  z-vertex
                  4      beam energy in cms for full event generator
                         'a la LUND'
                  5      theta direction of the JET if a single jet
                         event has been required
                  6      phi direction of the JET
                  4      particle type# if single PART has been required
                  5      momentum range of generation of the single PART
                  6      min and max value
                  7      cos(theta) direction range of the single PART:
                  8      min and max value.
        IPACJO           = 1  GHEISHA
                         = 2  TATINA
                         = 3  CASCADE
        IDETJO (1-ldet)  digitization type for detector 1-ldet
                         = 0 means the corresponding detector has not
                             been selected on a SETS data card
                         = i means det.# i has been selected
                         the order is the following:
                         VDET, ITC, TPC, ECAL, LCAL, SATR, HCAL, MUON
                         SICA
        IGEOJO (1-lgeo)  = 0 means the component is absent
                         = 1 means the component is present
                         the order is the following:
                         VDET, ITC, TPC, ECAL, LCAL, SATR, HCAL, MUON
                         SICA, BPIP, QUAD, PMAT, COIL
        LVELJO (1-lgeo)  geometry level in the range [0,3]
        ICVDJO (1-lcvd)  VDET run condition flags
        ICITJO (1-lcit)  ITC  run condition flags
        ICTPJO (1-lctp)  TPC  run condition flags
        ICECJO (1-lcec)  ECAL run condition flags
        ICLCJO (1-lclc)  LCAL run condition flags
        ICSAJO (1-lcsa)  SATR run condition flags
        ICHCJO (1-lchc)  HCAL run condition flags
        ICMUJO (1-lcmu)  MUON run condition flags
        ICSIJO (1-lcsi)  SICA run condition flags
        FGALJO           if .TRUE. (default) write GALEPH banks
        FPARJO           if .TRUE. use geantino parametrization in calo.
        FXXXJO           if .TRUE. write Fxxx output banks
        FWRDJO           if .TRUE. write Raw Data on a separate record
        FXTKJO           IF .TRUE. drop low momentum tracks (FYXX pack.)
        FXSHJO           IF .TRUE. drop low momentum showers (FYXX)
        CUTFJO           momentum cut (FYXX package)
        IDAFJO           adbscons daf version #
        IDCHJO           date of last change of adbscons daf
        TVERJO           tpcsim version #
        TITLJO           program title
        TSETJO (1-lset)  list of selected detectors by SETS data cards
        TPROJO (1-lpro)  list of selected process   by PROC data cards
        TKINJO           kinematic type flag
        TGEOJO (1-lgeo)  2 letter-codes of various components:
                         VD, IT, TP, EC, LC, SA, HC, MU, SI, BP, QU, PM,CO
                         EB, HB, MB, MM, MC
        TRUNJO           Run title (up to 60 characters)

#endif
