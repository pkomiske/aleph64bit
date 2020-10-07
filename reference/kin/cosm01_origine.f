cFrom BLOCH@alws.cern.ch Fri Feb 13 16:03:07 2004
cDate: Fri, 13 Feb 2004 16:02:03 +0100
cFrom: BLOCH@alws.cern.ch
cTo: BLOCH@alws.cern.ch

C-------------------------------------------------                              
C   Original version modified by B. Bloch in March 1988                         
C   Changes are :                                                               
C introduce common                                                              
C     COMMON /COSEVT/ ENER ,EOUT , COSTH , PHI , CHRG                           
C     COMMON /COSIO/ IOU,IDB                                                    
C     COMMON /COSPAR/ EMIN,EMAX,ECUT, RVRT , ZVRT                               
C  Make calls to HBOOK conform to HBOOK4 specifications                         
C  Change range of original histo ids to be >10000                              
C  Correct typing(?) error :CHRG was always negative                            
C  Introduce test on ECUT rather than a number (10 gev)                         
C  Skip part computing direction of muon entering surface element               
      PROGRAM COSMIC                                                            
C ----------------------------------------------------------------------        
C.                                                                              
C. - Author   : A. Putzer  - 87/12/28                                           
C.                                                                              
C.                                                                              
C! - Program to generate the cosmic flux in I4                                  
C.                                                                              
C.                                                                              
C.                                                                              
      COMMON/ PAWC /DUMMY(20000)                                                
C                                                                               
C Print flux tables                                                             
C                                                                               
      CALL COSIPR                                                               
      EMIN = 70.                                                                
      EMAX = 1000.                                                              
      NACC = 0                                                                  
C                                                                               
C Initialize the cosmic muon generation                                         
C                                                                               
      CALL COSGIN(EMIN,EMAX)                                                    
      NEV  = 100                                                                
C                                                                               
C Event loop                                                                    
C                                                                               
      DO 100 I = 1,NEV                                                          
        CALL COSGEN(EMIN,EMAX,IACC)                                             
        IF(IACC.EQ.1) NACC = NACC+1                                             
 100  CONTINUE                                                                  
      CALL COSGFI(EMIN,EMAX,NEV,NACC)                                           
      CALL HPRINT(0)                                                            
      END                                                                       
      SUBROUTINE COSGIN(EMIN,EMAX)                                              
C ----------------------------------------------------------------------        
C.                                                                              
C. - Author   : A. Putzer  - 87/12/14                                           
C.                                                                              
C.                                                                              
C! - Initialize muon generation                                                 
C.                                                                              
C.                                                                              
C.   Arguments : EMIN  (input)  minimum muon energy                             
C.               EMAX  (input)  maximum muon energy                             
C.                                                                              
C.                                                                              
C.                                                                              
      COMMON/COSFLX/DIST(100)                                                   
      COMMON/COSCON/PI,TWOPI,RADEG,DEGRAD                                       
C                                                                               
      EXTERNAL COSDIA                                                           
C                                                                               
      PI = ATAN(1.)*4.                                                          
      TWOPI = 2.*PI                                                             
      RADEG = 180./PI                                                           
      DEGRAD = PI/180.                                                          
C                                                                               
      CALL HBOOK1(10001,'Energy of gener. muons(at surf.)$',50,0.,EMAX,         
     &        0.)                                                               
      CALL HBOOK1(10002,'Cos (Theta)        (at surf.)$',50,0.,1.,0.)           
      CALL HBOOK1(10003,'Energy of muons (outside the det.)$',50,0.,EMAX        
     &    ,0.)                                                                  
      CALL HBOOK1(10004,'Cos (theta)  (outside the det.)$',50,0.,1.,0.)         
      CALL HBOOK1(10005,'Energy of surv. muons  (at surf.)$',50,0.,EMAX,        
     &   0.)                                                                    
      CALL HBOOK1(10006,'Cos(theta);E> Ecut GeV outs.det.$',50,0.,1.,0.)        
      CALL HBOOK1(10007,'E of mu at surf;E> Ecut Gev outs. det.$',50,0.,        
     &       EMAX,0.)                                                           
      CALL HBOOK2(10011,'R XY VS Z OF VERTEX $',35,0.,700.,35,-700.,700.        
     &       , 0.)                                                              
      CALL HBOOK2(10012,'VERTEX POSITION X VS Y$',35,-700.,700.,35,-700.        
     &        ,700. ,0.)                                                        
      CALL HBOOK1(10013,' ENERGY MU - $',50,0.,EMAX,0.)                         
      CALL HBOOK1(10014,' ENERGY MU + $',50,0.,EMAX,0.)                         
C                                                                               
      CALL FUNPRE(COSDIA,DIST,EMIN,EMAX)                                        
C                                                                               
      RETURN                                                                    
      END                                                                       
      SUBROUTINE COSGEN(EMIN,EMAX,IACC)                                         
C ----------------------------------------------------------------------        
C.                                                                              
C. - Author   : A. Putzer  - 87/12/14                                           
C.                                                                              
C.                                                                              
C! - Generates the flux of cosmic muons at sea level                            
C.                                                                              
C.                                                                              
C.   Arguments : EMIN  (input)  minimum muon energy                             
C.               EMAX  (input)  maximum muon energy                             
C.                                                                              
C.                                                                              
      EXTERNAL COSDIA                                                           
      COMMON /COSEVT/ ENER ,EOUT , COSTH , PHI , CHRG                           
      COMMON /COSPAR/ EMI,EMA,ECUT, RVRT , ZVRT                                 
      COMMON /COSIO/ IOU ,IDB                                                   
      COMMON/COSFLX/DIST(100)                                                   
      COMMON/COSCON/PI,TWOPI,RADEG,DEGRAD                                       
C                                                                               
      DATA POSMU/0.42/,DEPTH/88./                                               
      DATA DENSI/30000./                                                        
         IACC = 0                                                               
C                                                                               
C - Generate the muon energy                                                    
C                                                                               
        CALL FUNRAN(DIST,ENER)                                                  
        CALL HF1(10001,ENER,1.)                                                 
C                                                                               
C - Get exponent for the zenith angle (THETA) dependence for this energy        
C                                                                               
        GAMMA=COSANG(ENER) + 1.                                                 
        IF (GAMMA.LT.0.1) GAMMA=0.1                                             
C                                                                               
C - Generate the zenith angle (THET)                                            
C                                                                               
        COSTH = RNDM(T)**(1./GAMMA)                                             
        THET  = ACOS(COSTH)                                                     
        CALL HF1(10002,COSTH,1.)                                                
        DDDD = DENSI/COSTH                                                      
        CALL ELOS(ENER,EOUT,DDDD)                                               
C       CALL COSLOS(ENER,DEDXM,RANGEM)                                          
C       RCUT = 120./COSTH                                                       
C       IF (RANGEM.LT.RCUT) GO TO 999                                           
C       EOUT = ENER - DEDXM*120.                                                
        IF (EOUT.LE.0.) GO TO 999                                               
        CALL HF1(10003,EOUT,1.)                                                 
        CALL HF1(10004,COSTH,1.)                                                
        CALL HF1(10005,ENER,1.)                                                 
        IF (EOUT.LT.ECUT) GO TO 998                                             
        CALL HF1(10006,COSTH,1.)                                                
        CALL HF1(10007,ENER,1.)                                                 
 998    CONTINUE                                                                
        IACC = 1                                                                
C                                                                               
C - Generate the azimuthal angle (PHI)                                          
C                                                                               
        PHI = TWOPI*RNDM(F)                                                     
C                                                                               
C - Generate the muon charge  (CHRG)                                            
C                                                                               
        CHRG = -1.                                                              
        IF (RNDM(C).GT.POSMU) CHRG = 1.                                         
        IF(IDB.GT.0) WRITE(IOU,1002) IACC,ENER,COSTH,PHI,CHRG,GAMMA             
CBBC                                                                            
CBBC - Generate the direction of a muon entering the surface element            
CBBC                                                                            
CBB        PH0 =  TWOPI*RNDM(P0)                                                
CBB        CT0 =  SQRT(RNDM(C0))                                                
CBB        TH0 =  ACOS(CT0)                                                     
CBB        WRITE(IOU,1005) PH0,CT0,TH0                                          
CBBC                                                                            
CBB        XN  =  SIN(TH0)*COS(PH0)                                             
CBB        YN  =  SIN(TH0)*SIN(PH0)                                             
CBB        ZN  =  CT0                                                           
CBB        WRITE(IOU,1005) XN,YN,ZN                                             
CBBC                                                                            
CBB        CP = COS(PHI)                                                        
CBB        SP = SIN(PHI)                                                        
CBB        ST = SIN(THET)                                                       
CBB        CT = COSTH                                                           
CBBC                                                                            
CBB        XL =  XN*SP + (  YN*CT + ZN*ST)*CP                                   
CBB        YL = -XN*CP + (  YN*CT + ZN*ST)*SP                                   
CBB        ZL =            -YN*ST + ZN*CT                                       
CBB        CONT = XL*ST*CP + YL*ST*SP + ZL*CT                                   
CBB        WRITE(IOU,1006) CT0,CONT                                             
CBB1006    FORMAT(2E20.10)                                                      
CBB        WRITE(IOU,1005) XL,YL,ZL                                             
CBBC                                                                            
CBB        XSURF = DEPTH*XL                                                     
CBB        YSURF = DEPTH*YL                                                     
CBB        ZSURF = DEPTH*ZL                                                     
CBBC                                                                            
CBB        WRITE(IOU,1005) XSURF,YSURF,ZSURF                                    
CBB 1005   FORMAT(3F10.3)                                                       
1002    FORMAT(1X,'ENERGY,COST,PHI,CHARGE,GAMMA',I10,5X,5E10.3)                 
 999  CONTINUE                                                                  
      RETURN                                                                    
      END                                                                       
      SUBROUTINE COSGFI(EMIN,EMAX,NEV,NACC)                                     
C ----------------------------------------------------------------------        
C.                                                                              
C. - Author   : A. Putzer  - 87/12/14                                           
C.                                                                              
C.                                                                              
C! - Generates the flux of cosmic muons at sea level                            
C.                                                                              
C.                                                                              
C.   Arguments : EMIN  (input)  minimum muon energy                             
C.               EMAX  (input)  maximum muon energy                             
C.                                                                              
C.                                                                              
      COMMON/COSCON/PI,TWOPI,RADEG,DEGRAD                                       
      COMMON /COSIO/ IOU ,IDB                                                   
      FLUX = COSINA(EMIN) - COSINA(EMAX)                                        
C     TOTINT = TWOPI * 88.**2 * FLUX                                            
      TOTINT = 100.**2 * FLUX                                                   
      TIME  = FLOAT(NEV)/TOTINT                                                 
      FLUX2 = FLUX*FLOAT(NACC)/FLOAT(NEV)                                       
      TOTIN2 = TOTINT*FLOAT(NACC)/FLOAT(NEV)                                    
      WRITE(IOU,1001) NEV, NACC, FLUX, TOTINT, TIME, FLUX2, TOTIN2              
1001  FORMAT(1X,'------------------------FINAL STATISTICS-------------',        
     &/,1X,'EVTS GENERATED,ACCEPTED ',2I10,                                     
     &/,1X,'       FLUX          TOTINT           TIME         FLUX2            
     &        TOTIN2 ',  /,1X,5E15.5)                                           
      RETURN                                                                    
      END                                                                       
      SUBROUTINE COSIPR                                                         
C ----------------------------------------------------------------------        
C.                                                                              
C. - Author   : A. Putzer  - 87/12/14                                           
C.                                                                              
C.                                                                              
C! - Calculates the differential flux of athmospheric muons at sea level        
C.                                                                              
C.                                                                              
C.   Arguments : EMU   (input)  final muon energy at sea level in GeV           
C.               THEMU (input)  zenith angle in radian                          
C.               WQPOS (output) pos. muon flux in (GeV*cm**2*sec*sr)**-1        
C.               WQNEG (output) neg. muon flux in (GeV*cm**2*sec*sr)**-1        
C.                                                                              
C? - The muon flux is analytically calculated following a paper of              
C?      A. Dar ,  Phys. Rev. Letters 51, 227 (1983)                             
C?   and further references therein.                                            
C.                                                                              
C.                                                                              
      PARAMETER (NEVAL = 22)                                                    
      COMMON /COSIO/ LUNOUT,IDB                                                 
      DIMENSION EVAL(NEVAL),FDIF(NEVAL),FINT(NEVAL),DANG(NEVAL)                 
      DIMENSION DINT(NEVAL),DAIN(NEVAL)                                         
C                                                                               
C- The measurements of the differential vertical muon cross section             
C- have been interpolated at 22 energy values                                   
C- Allkofer et al. Phys. Lett. B36, 425 (1971)                                  
C                                                                               
C  energy values in GeV                                                         
C                                                                               
      DATA EVAL/ 0.2, 0.4, 0.8, 1.0, 1.5, 2.0, 3.0, 5.0, 7.0,10.0, 15.0,        
     +           20., 30., 50., 70.,100.,150.,200.,300.,500.,700.,1000./        
C                                                                               
C  Differential vertical flux (cm**2 sr sec GeV)**-1  from Allkofer             
C                                                                               
      DATA FDIF/0.373E-02,0.372E-02,0.310E-02,0.279E-02,0.214E-02,              
     +          0.167E-02,0.106E-02,0.497E-03,0.273E-03,0.133E-03,              
     +          0.540E-04,0.270E-04,0.959E-05,0.236E-05,0.892E-06,              
     +          0.304E-06,0.851E-07,0.335E-07,0.870E-08,0.152E-08,              
     +          0.471E-09,0.134E-09/                                            
C                                                                               
C  Integral vertical flux (cm**2 sr sec)**-1          from Allkofer             
C                                                                               
      DATA FINT/0.994E-02,0.918E-02,0.781E-02,0.722E-02,0.600E-02,              
     +          0.505E-02,0.372E-02,0.226E-02,0.152E-02,0.942E-03,              
     +          0.513E-03,0.321E-03,0.157E-03,0.593E-04,0.298E-04,              
     +          0.138E-04,0.555E-05,0.284E-05,0.107E-05,0.303E-06,              
     +          0.130E-06,0.523E-07/                                            
C                                                                               
C  Integral vertical flux (cm**2 sr sec)**-1          from CDARFX               
C                                                                               
      DATA DINT/0.109E-01,0.100E-01,0.840E-02,0.757E-02,0.641E-02,              
     +          0.541E-02,0.397E-02,0.239E-02,0.159E-02,0.976E-03,              
     +          0.524E-03,0.325E-03,0.158E-03,0.586E-04,0.292E-04,              
     +          0.135E-04,0.543E-05,0.277E-05,0.105E-05,0.300E-06,              
     +          0.129E-06,0.523E-07/                                            
C                                                                               
C   Differential flux integrated over all angles using the                      
C   calculations of Dar                               from CDARFX               
C                                                                               
      DATA DANG/.4340E-02,.4551E-02,.4516E-02,.4363E-02,.3840E-02,              
     +          .3292E-02,.2388E-02,.1328E-02,.8104E-03,.4415E-03,              
     +          .2018E-03,.1099E-03,.4380E-04,.1252E-04,.5220E-05,              
     +          .1986E-05,.6332E-06,.2741E-06,.8152E-07,.1688E-07,              
     +          .5835E-08,.1859E-08/                                            
C                                                                               
C  Integral total flux (cm**2 sr sec)**-1             from CDARFX               
C                                                                               
      DATA DAIN/0.213E-01,0.205E-01,0.186E-01,0.178E-01,0.157E-01,              
     +          0.139E-01,0.112E-01,0.763E-02,0.556E-02,0.377E-02,              
     +          0.228E-02,0.154E-02,0.839E-03,0.365E-03,0.202E-03,              
     +          0.105E-03,0.478E-04,0.268E-04,0.116E-04,0.387E-05,              
     +          0.185E-05,0.842E-06/                                            
C                                                                               
      WRITE(LUNOUT,6001)                                                        
6001  FORMAT(//20X,' Comparison of measured and parametrized cosmic',           
     +             ' muon fluxes at sea level',/,                               
     +         20X,' ==============================================',           
     +             '=========================',///,                             
     +         40X,'A. Vertical fluxes ',/,                                     
     +         40X,'------------------',//,                                     
     +  ' 1. Differential flux as measured by Allkofer et al.',                 
     +  ' Phys. Lett. 36B (1971), 425',/,                                       
     +  ' 2. Differential flux as predicted from the primary hadron',           
     +  ' flux by A. Dar Phys. Rev. Lett. 51 (1983), 227 (CDARFX)',/,           
     +  ' 3. Differential flux as calculated from a simple',                    
     +  ' parametrization of the measured flux (COSDIF)',///,                   
     +  ' 4. Integral flux as calculated by Allkofer from',                     
     +  ' the differential flux assuming a E**-Alpha dependence',/,             
     +  ' 5. Integral flux as calculated using the DAR parametrization',        
     + /' 6. Integral flux as calculated from a simple',                        
     +  ' parametrization of the measured flux (COSINT)',/,                     
     + //7X,' Energy (GeV)    Differential vertical flux (1./GeV*cm**2',        
     +  '*sec*sr)         Integral vertical flux (1./cm**2*sec*sr)'//)          
C    F    '     PARAMETRIZED     PARAM_INTEG     PARAM_D_INTEG'//)              
C    F ' THE DIFFERENTIAL BY THE PROGRAM ASSUMING E**-ALF FORM'/                
C    F 2X,'PARAMETRIZED IS THE DIFFERENTIAL (AT 0 DEG) GIVEN BY A.DAR ',        
C    F 'PHYS.REV.LETT. 51 (1983) 227',                                          
C    F /2X,'PARAM_INTEG IS DAR-S PARAMETRIZATION INTEGRATED OVER ALL',          
C    F ' ANGLES'/2X,'PARAM_D_INTEG IS PARAM_INTEG INTEGRATED OVER'              
C    F ,' ENERGIES ASSUMING E**-ALF DEPENDENCE)'                                
C                                                                               
      DO 100 I=1,NEVAL                                                          
        EMU = EVAL(I)                                                           
        CALL CDARFX(EMU,0.,WQPOS,WQNEG)                                         
        DDIF = WQPOS + WQNEG                                                    
        WRITE(LUNOUT,6002) EMU,FDIF(I),DDIF,COSDIF(EMU),                        
     X                     FINT(I),DINT(I),COSINT(EMU)                          
6002    FORMAT(7X,F9.1,14X,3E12.3,16X,3E12.3)                                   
 100  CONTINUE                                                                  
      WRITE(LUNOUT,6003)                                                        
6003  FORMAT(1H1,///,40X,'B. Fluxes integrated over the angle',/,               
     +            40X,'-----------------------------------',//                  
     +  ' 1. Differential flux calculated using Dar.s model',                   
     +  ' integrated over the whole angle range',                               
     + /' 2. Differential flux as calculated from a simple',                    
     +  ' parametrization of the measured flux (COSDIA)',/,                     
     + /' 3. Total integral flux as a function of the cut-off',                 
     +  ' energy using a the DAR parametrization (CDARFX)',                     
     + /' 4. Total integral flux as a function of the cut-off',                 
     +  ' energy using a simple parametrization (COSINA)',/,                    
     + //7X,' Energy (GeV)    Gamma    Differential flux (1./GeV*cm**2',        
     +  '*sec)         integral flux (1./cm**2*sec)',//)                        
      DO 200 I=1,NEVAL-1                                                        
       DAIN(I) = DAIN(I+1) + FLUINT(EVAL(I),EVAL(I+1),DANG(I),DANG(I+1))        
       EMU = EVAL(I)                                                            
       WRITE(LUNOUT,6004) EMU,COSANG(EMU),DANG(I),COSDIA(EMU),DAIN(I),          
     +                     COSINA(EMU)                                          
6004   FORMAT(7X,F9.1,8X,F5.2,7X,2E12.3,18X,2E12.3)                             
 200  CONTINUE                                                                  
        PRINT 102                                                               
 102  FORMAT(/,2X,'FOR COMPARISON : MEASURED TOTAL FLUX ABOVE 0.35 GEV',        
     F/19X,'BY ALLKOFER ET AL. COSMIC RAYS ON EARTH,ISSN 0344-8401'/19X         
     F      ,'J2 = (1.90 +/- 0.12).E-2'//)                                      
      END                                                                       
      SUBROUTINE CDARFX(EMU,THEMU,WQPOS,WQNEG)                                  
C ----------------------------------------------------------------------        
C.                                                                              
C. - Author   : A. Putzer  - 87/12/14                                           
C.                                                                              
C.                                                                              
C! - Calculates the differential flux of athmospheric muons at sea level        
C.                                                                              
C.                                                                              
C.   Arguments : EMU   (input)  final muon energy at sea level in GeV           
C.               THEMU (input)  zenith angle in radian                          
C.               WQPOS (output) pos. muon flux in (GeV*cm**2*sec*sr)**-1        
C.               WQNEG (output) neg. muon flux in (GeV*cm**2*sec*sr)**-1        
C.                                                                              
C? - The muon flux is analytically calculated following a paper of              
C?      A. Dar ,  Phys. Rev. Letters 51, 227 (1983)                             
C?   and further references therein.                                            
C.                                                                              
C.                                                                              
      DIMENSION BRM(4),AM(4),AMSQ(4),CTM(4),GHH(5),DGHH(5)                      
C        Branching Ratios for  M --> mu nu   for Pions and Kaons                
      DATA BRM       /2*1.      , 2*0.632   /                                   
C                     Mass values for M in GeV/c**2                             
      DATA AM        /2*0.139567, 2*0.493669/                                   
C                    Mass squared                                               
      DATA AMSQ      /2*0.019479, 2*0.243710/                                   
C                    c*tau for M                                                
      DATA CTM       /2*7.804   , 2*3.709   /                                   
C       muon            mass             mass**2              c*tau             
      DATA AMMU      /0.10566/ , AMUSQ /0.011164/ , CTMU   /658.68/             
C       scale parameter of the upper athmosphere   in m                         
      DATA H0        /6300./                                                    
C       energy loss in athmosphere     in    GeV*m**2/kg                        
      DATA ALPHA     /2.06E-04/                                                 
C       constants to calculate athmospheric depths  in    kg/m**2               
      DATA ALAM0     /1200./,  ALAM1 /10300./                                   
C                                                                               
C      Constants to calculate the production coefficients in the athm.          
C      Values taken from A. Liland Intern. Cosmic Ray Conf. Kyoto 1979          
C      Vol 13, p. 353                                                           
C                                                                               
C                  p pi+   p pi-   p K+     p K-     p N                        
      DATA GHH / .04190, .03014, .007354, .002633, .3175/                       
      DATA DGHH/ .00655,-.01019,-.006456,-.003179, .1815/                       
C                                                                               
C  Assume a primary flux of 1.6 E**-2.67 nucleons/cm**2 sec sr GeV              
C                                                                               
      AKM(E,GM) = 1.6*E**(-2.67)/(2.67+(2.67+1)*GM*E)                           
C  Final athmospheric depths                                                    
      ALAMF = ALAM1/COS(THEMU)                                                  
C  Muon momentum at sea level                                                   
      PMU   = SQRT(EMU**2 - AMUSQ)                                              
C  Initial muon energy                                                          
      E0    = EMU + ALPHA*(ALAMF - ALAM0)                                       
C  Average energy in athmosphere                                                
      EBAR  = EMU + ALPHA*(ALAMF - ALAM0)/2.                                    
C  Gamma mu                                                                     
      GAMMU = COS(THEMU)*CTMU/(AMMU*H0)                                         
C  Probability to reach sea level before decay                                  
      SMU   =  (ALAM0/ALAMF)**(1./(GAMMU*EBAR))                                 
C                                                                               
C  Calculate contributions from the 4 decay processes                           
C                                                                               
      GN = GHH(5) + DGHH(5)/SQRT(E0)                                            
      WQPOS = 0.                                                                
      WQNEG = 0.                                                                
      DO 100 I = 1,4                                                            
        GM   = GHH(I) + DGHH(I)/SQRT(E0)                                        
C  Multiply by 1.15 for nuclear enhancement of multiplicity in air coll.        
        GMAT = GM/(1.-GN) * 1.15                                                
C  gamma M                                                                      
        GAMM = COS(THEMU)*CTM(I)/(AM(I)*H0)                                     
C  beta  M                                                                      
        BETM = AMSQ(I)/AMUSQ                                                    
C  alpha M                                                                      
        ALPHM = AMSQ(I)/(AMSQ(I) - AMUSQ)                                       
C                                                                               
        DFMDE = GMAT*BRM(I)*ALPHM*SMU*(AKM(E0,GAMM)-AKM(BETM*E0,GAMM))          
        IF (I.EQ.1.OR.I.EQ.3) THEN                                              
          WQPOS = WQPOS + DFMDE                                                 
        ELSE                                                                    
          WQNEG = WQNEG + DFMDE                                                 
        ENDIF                                                                   
100   CONTINUE                                                                  
        END                                                                     
      FUNCTION COSANG(EMU)                                                      
C ----------------------------------------------------------------------        
C.                                                                              
C. - Author   : A. Putzer  - 87/12/14                                           
C.                                                                              
C! - Calculates the angular (theta) dependence of cosmic muon                   
C.                                                                              
C.                                                                              
C.   Arguments : EMU   (input)  muon energy at sea level in GeV                 
C.                                                                              
C.                                                                              
C.                                                                              
C? - The angular dependence as a function of energy is calculated               
C?                                                                              
C?   The flux can be written in a factorized form                               
C?                                                                              
C?   FLUX(ENERGY,THETA) =  FLUX(ENERGY)*COS (THETA)) ** GAMMA(ENERGY)           
C?                                                                              
C?    The function returns the energie dependent value of gamma                 
C?                                                                              
C.                                                                              
      REAL * 8 COT,ALE,ALE2,DE,ALE3                                             
      DIMENSION COT(4)                                                          
      DATA COT/3.4240,-0.7730,-0.051078,0.011682/                               
      DE = EMU                                                                  
      ALE    = DLOG(DE)                                                         
      COSANG = COT(1) + COT(2)*ALE + COT(3)*ALE*ALE + COT(4)*ALE*ALE*ALE        
      RETURN                                                                    
      END                                                                       
      FUNCTION COSINA(EMU)                                                      
C ----------------------------------------------------------------------        
C.                                                                              
C. - Author   : A. Putzer  - 87/12/14                                           
C.                                                                              
C! - Calculates the integral flux integrated over all angles                    
C.                                                                              
C.                                                                              
C.   Arguments : EMU   (input)  muon energy at sea level in GeV                 
C.                                                                              
C.                                                                              
C.                                                                              
C? - The total flux integrated over all angles as a function of E               
C?   is calculated. The function parametrizes the measured integral             
C?   flux. The calculated values agree within few percent                       
C?   with the actual measurements.                                              
C?                                                                              
C?   The function value contains the differential flux in                       
C?          1./(cm**2 * sec )                                                   
C.                                                                              
C                                                                               
      REAL*8 COE,DE,ALE,ALE2,ALE3,ADI                                           
      DIMENSION COE(4)                                                          
      DATA COE/-3.9526  ,-0.30382 ,-.19817 ,0.0043692/                          
      DE = EMU                                                                  
      ALE    = DLOG(DE)                                                         
      ALE2   = ALE*ALE                                                          
      ALE3   = ALE2*ALE                                                         
      ADI = COE(1) + COE(2)*ALE + COE(3)*ALE2 + COE(4)*ALE3                     
      COSINA = DEXP(ADI)                                                        
      RETURN                                                                    
      END                                                                       
      FUNCTION COSDIA(EMU)                                                      
C ----------------------------------------------------------------------        
C.                                                                              
C. - Author   : A. Putzer  - 87/12/14                                           
C.                                                                              
C! - Calculates the differential flux integrated over all angles                
C.                                                                              
C.                                                                              
C.   Arguments : EMU   (input)  muon energy at sea level in GeV                 
C.                                                                              
C.                                                                              
C.                                                                              
C? - The differential flux integrated ver all angles as a function of E         
C?   is calculated. The function parametrizes the measured differential         
C?   flux. The calculated values agree within few percent                       
C?   with the actual measurements.                                              
C?                                                                              
C?   The function value contains the differential flux in                       
C?          1./(GeV * cm**2 * sec )                                             
C.                                                                              
C                                                                               
      REAL*8 COE,DE,ALE,ALE2,ALE3,ADI                                           
      DIMENSION COE(4)                                                          
      DATA COE/-5.3229  ,-0.35023 ,-.34803 ,0.012680/                           
      DE = EMU                                                                  
      ALE    = DLOG(DE)                                                         
      ALE2   = ALE*ALE                                                          
      ALE3   = ALE2*ALE                                                         
      ADI = COE(1) + COE(2)*ALE + COE(3)*ALE2 + COE(4)*ALE3                     
      COSDIA = DEXP(ADI)                                                        
      RETURN                                                                    
      END                                                                       
      FUNCTION COSDIF(EMU)                                                      
C ----------------------------------------------------------------------        
C.                                                                              
C. - Author   : A. Putzer  - 87/12/14                                           
C.                                                                              
C! - Calculates the differential vertical flux                                  
C.                                                                              
C.                                                                              
C.   Arguments : EMU   (input)  muon energy at sea level in GeV                 
C.                                                                              
C.                                                                              
C.                                                                              
C? - The differential vertical flux as a function of energy is                  
C?   calculated. The function parametrizes the measured differential            
C?   vertical flux. The calculated values agree within few percent              
C?   with the actual measurements.                                              
C?                                                                              
C?   The function value returns the differential vertical flux in               
C?          1./(GeV * cm**2 * sec * sr)                                         
C.                                                                              
C                                                                               
      REAL*8 COE,DE,ALE,ALE2,ALE3,ADI                                           
      DIMENSION COE(4)                                                          
      DATA COE/-5.8339  ,-0.51588 ,-.40199 ,0.017717/                           
      DE = EMU                                                                  
      ALE    = DLOG(DE)                                                         
      ALE2   = ALE*ALE                                                          
      ALE3   = ALE2*ALE                                                         
      ADI = COE(1) + COE(2)*ALE + COE(3)*ALE2 + COE(4)*ALE3                     
      COSDIF = DEXP(ADI)                                                        
      RETURN                                                                    
      END                                                                       
      FUNCTION COSINT(EMU)                                                      
C ----------------------------------------------------------------------        
C.                                                                              
C. - Author   : A. Putzer  - 87/12/14                                           
C.                                                                              
C! - Calculates the integral vertical flux                                      
C.                                                                              
C.                                                                              
C.   Arguments : EMU   (input)  muon energy at sea level in GeV                 
C.                                                                              
C.                                                                              
C.                                                                              
C? - The integral vertical flux as a function of energy is                      
C?   calculated. The function parametrizes the measured integral                
C?   vertical flux. The calculated values agree within few percent              
C?   with the actual measurements.                                              
C?                                                                              
C?   The function value returns the integral vertical flux in                   
C?          1./(cm**2 * sec * sr)                                               
C.                                                                              
C                                                                               
      REAL*8 COE,DE,ALE,ALE2,ALE3,ADI                                           
      DIMENSION COE(4)                                                          
      DATA COE/-4.8597  ,-0.44915 ,-.22676 ,0.0059028/                          
      DE = EMU                                                                  
      ALE    = DLOG(DE)                                                         
      ALE2   = ALE*ALE                                                          
      ALE3   = ALE2*ALE                                                         
      ADI = COE(1) + COE(2)*ALE + COE(3)*ALE2 + COE(4)*ALE3                     
      COSINT = DEXP(ADI)                                                        
      RETURN                                                                    
      END                                                                       
      SUBROUTINE COSLOS(E,DEDXM,RANGEM)                                         
C....................................................................           
C...                                                                .           
C...  This subroutine calculates the energy loss and the range      .           
C...  ********************************************************      .           
C...                                                                .           
C...  of cosmic muons in standard rock                              .           
C...  ********************************                              .           
C...                                                                .           
C...                                                                .           
C...  Input arguments                                               .           
C...                                                                .           
C...              E      : Energy value in GeV                      .           
C...                                                                .           
C...  Output arguments                                              .           
C...                                                                .           
C...              DEDXM  : Energy loss (GeV/m)                      .           
C...                                                                .           
C...              RANGEM : Range (m)                                .           
C...                                                                .           
C...  Author      A. Putzer, Heidelberg, Version 1.0, September 85  .           
C...                                                                .           
C....................................................................           
C                                                                               
C--   Standard rock :  Z/A = 0.5    Z**2/A = 5.5                                
C                                                                               
C--                    density = 2.65  g cm-3                                   
C                                                                               
      DATA DEN100/265./                                                         
C                                                                               
C--   Coefficients to calculate energy loss and range                           
C                                                                               
      DATA A/1.84/ , B/4.38E-6/ , C/0.076/                                      
C                                                                               
      EMEV   = E*1000.                                                          
C                                                                               
C     DEDX   MEV / (G/CM**2)                                                    
C                                                                               
      DEDX   = A + B * EMEV + C*ALOG10(EMEV)                                    
      DEDXM  = DEDX*DEN100/1000.                                                
      RANGE  = 1./ B * ALOG( 1. + B / A * EMEV)                                 
      RANGEM = RANGE/DEN100                                                     
      RETURN                                                                    
      END                                                                       
         FUNCTION FLUINT(E1,E2,F1,F2)                                           
C        ============================                                           
C                                                                               
C --- Given E1 and E2 lower and upper energy limits and F1 and F2 the           
C        corresponding differential distribution dN/dE = a*E**-alf              
C        at E1 and E2. Then FLUINT = Integral dN/dE from E1 to E2               
C                                                                               
         FLUINT = (E1*F1-E2*F2)/(-ALOG(F1/F2)/ALOG(E1/E2)-1.)                   
C                                                                               
         RETURN                                                                 
         END                                                                    
      SUBROUTINE FUNPRE (FUNC,XFCUM,X2LOW,X2HIGH)                               
C         F. JAMES,    MAY, 1976                                                
C         MODIFIED OCT, 1980 TO ADD PRINTOUT OF INTEGRAL                        
C         MODIFIED DEC., 1980 TO DELETE LEADING AND TRAILING                    
C            RANGES OF X WHERE FUNCTION IS ZERO.                                
C         MODIFIED JUNE,1982 TO FIX POSSIBLE INFINITE LOOP.                     
C                                                                               
C         PREPARES THE USER FUNCTION "FUNC" FOR FUNRAN                          
C         BY FINDING THE PERCENTILES                                            
C         (IN EFFECT, INVERTING THE CUMULATIVE DISTRIBUTION)                    
      EXTERNAL FUNC                                                             
      COMMON/FUNINT/TFTOT                                                       
      COMMON /COSIO/ IOU ,IDB                                                   
      DIMENSION XFCUM(100)                                                      
      DATA NBINS / 99/                                                          
      DATA NZ / 10/                                                             
      DATA MAXZ / 20/                                                           
      DATA NITMAX / 6 /                                                         
      DATA IFUNC/0/                                                             
      IFUNC = IFUNC + 1                                                         
C         FIND MACHINE ACCURACY                                                 
      COMP1 = 1.0                                                               
      DO 200 I= 1, 100                                                          
      COMP1 = COMP1*0.5                                                         
      COMP2 = 1.0 - COMP1                                                       
      IF(COMP2 .EQ. 1.0) GOTO 210                                               
  200 CONTINUE                                                                  
      COMP1 = 1.0E-10                                                           
  210 PRECIS = COMP1                                                            
C         FIND RANGE WHERE FUNCTION IS NON-ZERO.                                
      CALL FUNZER(FUNC,X2LOW,X2HIGH,XLOW,XHIGH)                                 
      XRANGE = XHIGH-XLOW                                                       
      IF(XRANGE .LE. 0.) GOTO 900                                               
      RTEPS = AMAX1(0.0001,PRECIS*10.)                                          
      TFTOT = GAUSS(FUNC,XLOW,XHIGH,RTEPS)                                      
C         PRINT OUT VALUE OF NORMALIZATION INTEGRAL                             
      WRITE (IOU,1003) IFUNC,XLOW,XHIGH,TFTOT                                   
      RTEPS = 0.001                                                             
      IF(TFTOT .LE. 0.) GOTO 900                                                
      TPCTIL = TFTOT/FLOAT(NBINS)                                               
      TZ = TPCTIL/FLOAT(NZ)                                                     
      TZMAX = TZ * 2.                                                           
       XFCUM(1) = XLOW                                                          
      XFCUM(NBINS+1) = XHIGH                                                    
      X = XLOW                                                                  
      F = FUNC(X)                                                               
      IF(F .LT. 0.) GOTO 900                                                    
      NBINM1 = NBINS - 1                                                        
C         LOOP OVER BINS (HUNDREDTH PERCENTILES)                                
      DO 600 IBIN = 1, NBINM1                                                   
      TCUM = 0.                                                                 
      X1 = X                                                                    
      F1 = F                                                                    
      DXMAX = (XHIGH -X) / FLOAT(NZ)                                            
      FMIN = TZ/DXMAX                                                           
      FMINZ = FMIN                                                              
C         LOOP OVER TRAPEZOIDS WITHIN A SUPPOSED PERCENTILE                     
      DO 500 IZ= 1, MAXZ                                                        
      XINCR = TZ/AMAX1(F1,FMIN,FMINZ)                                           
  350 X = X1 + XINCR                                                            
      F = FUNC(X)                                                               
      IF(F .LT. 0.) GOTO 900                                                    
      TINCR = (X-X1) * 0.5 * (F+F1)                                             
      IF(TINCR .LT. TZMAX) GOTO 370                                             
      XINCR = XINCR * 0.5                                                       
      GOTO 350                                                                  
  370 CONTINUE                                                                  
      TCUM = TCUM + TINCR                                                       
      IF(TCUM .GE. TPCTIL*0.99) GOTO 520                                        
      FMINZ = TZ*F/ (TPCTIL-TCUM)                                               
      F1 = F                                                                    
      X1 = X                                                                    
  500 CONTINUE                                                                  
      WRITE (IOU,2000)                                                          
 2000 FORMAT (43H0      FAILURE TO FIND TRAPEZOID   HELP.   )                   
C         END OF TRAPEZOID LOOP                                                 
C         ADJUST TRAPEZOID INTEGRAL BY GAUSS WITH NEWTON CORRECTION             
  520 CONTINUE                                                                  
      X1 = XFCUM(IBIN)                                                          
      XBEST = X                                                                 
      DTBEST = TPCTIL                                                           
      TPART = TPCTIL                                                            
C         ALLOW FOR MAXIMUM NITMAX MORE ITERATIONS ON GAUSS                     
      DO 550 IHOME= 1, NITMAX                                                   
      XINCR = (TPCTIL-TPART) / AMAX1(F,FMIN)                                    
  535 X = XBEST + XINCR                                                         
      X2 = X                                                                    
      TPART2 = GAUSS(FUNC,X1,X2,RTEPS)                                          
      DTPAR2 = TPART2-TPCTIL                                                    
      DTABS = ABS(DTPAR2)                                                       
      IF(ABS(XINCR) .LT. PRECIS) GOTO 545                                       
      IF(DTABS .LT. DTBEST) GOTO 545                                            
      XINCR = XINCR * 0.5                                                       
      GOTO 535                                                                  
  545 DTBEST = DTABS                                                            
      XBEST = X                                                                 
      IF(DTABS .LT. RTEPS*TPCTIL) GOTO 580                                      
      TPART = TPART2                                                            
      F = FUNC(X)                                                               
  550 CONTINUE                                                                  
      IHOME = NITMAX                                                            
C                                                                               
  580 CONTINUE                                                                  
      XFCUM(IBIN+1) = X                                                         
      F = FUNC(X)                                                               
      IF(F .LT. 0.) GOTO 900                                                    
  600 CONTINUE                                                                  
C         END OF LOOP OVER BINS                                                 
      X1 = XFCUM(NBINS)                                                         
      X2 = XHIGH                                                                
      TPART = GAUSS(FUNC,X1,X2,RTEPS)                                           
      ABERR = ABS(TPART-TPCTIL)/TFTOT                                           
      WRITE (IOU,1001) IFUNC,ABERR                                              
      IF(ABERR .GT. RTEPS)  WRITE (IOU,1002)                                    
      RETURN                                                                    
  900 WRITE (IOU,1000) X,F,XLOW,XHIGH                                           
      RETURN                                                                    
 1000 FORMAT (51H0FUNPRE FINDS NEGATIVE FUNCTION VALUE OR RANGE OF X/           
     + ,7H     X=,E15.6,6H,   F=,E15.6, 20X,5HXLOW=,E15.6,10H    XHIGH=,        
     +E15.6/)                                                                   
 1001 FORMAT (52H SUBROUTINE FUNPRE HAS PREPARED USER FUNCTION NUMBER,I4        
     +,  12H FOR FUNRAN./62H     MAXIMUM RELATIVE ERROR IN CUMULATIVE DI        
     +STRIBUTION WILL BE,E15.5)                                                 
 1002 FORMAT (1H+,80X,28HWARNING,THIS MAY BE TOO BIG.//)                        
 1003 FORMAT (54H0SUBROUTINE FUNPRE FINDS THE INTEGRAL OF USER FUNCTION         
     X, I2, 6H FROM ,E12.5,4H TO ,E12.5, 4H IS ,E14.6)                          
      END                                                                       
      SUBROUTINE FUNZER(FUNC,X2LOW,X2HIGH,XLOW,XHIGH)                           
C         FIND RANGE WHERE FUNC IS NON-ZERO.                                    
C         WRITTEN 1980, F. JAMES                                                
C         MODIFIED, NOV. 1985, TO FIX BUG AND GENERALIZE                        
C         TO FIND SIMPLY-CONNECTED NON-ZERO REGION (XLOW,XHIGH)                 
C         ANYWHERE WITHIN THE GIVEN REGION (X2LOW,H2HIGH).                      
C            WHERE 'ANYWHERE' MEANS EITHER AT THE LOWER OR UPPER                
C            EDGE OF THE GIVEN REGION, OR, IF IN THE MIDDLE,                    
C            COVERING AT LEAST 1% OF THE GIVEN REGION.                          
C         OTHERWISE IT IS NOT GUARANTEED TO FIND THE NON-ZERO REGION.           
C         IF FUNCTION EVERYWHERE ZERO, FUNZER SETS XLOW=XHIGH=0.                
      COMMON /COSIO/ IOU ,IDB                                                   
      EXTERNAL FUNC                                                             
      XLOW = X2LOW                                                              
      XHIGH = X2HIGH                                                            
C         FIND OUT IF FUNCTION IS ZERO AT ONE END OR BOTH                       
      XMID = XLOW                                                               
      IF (FUNC(XLOW) .GT. 0.) GO TO 120                                         
      XMID = XHIGH                                                              
      IF (FUNC(XHIGH) .GT. 0.)  GO TO 50                                        
C         FUNCTION IS ZERO AT BOTH ENDS,                                        
C         LOOK FOR PLACE WHERE IT IS NON-ZERO.                                  
      DO 30 LOGN= 1, 7                                                          
      NSLICE = 2**LOGN                                                          
      DO 20 I= 1, NSLICE, 2                                                     
      XMID = XLOW + FLOAT(I) * (XHIGH-XLOW) / FLOAT(NSLICE)                     
      IF (FUNC(XMID) .GT. 0.)  GO TO 50                                         
   20 CONTINUE                                                                  
   30 CONTINUE                                                                  
C         FALLING THROUGH LOOP MEANS CANNOT FIND NON-ZERO VALUE                 
      WRITE (IOU,554)                                                           
      WRITE (IOU,555) XLOW, XHIGH                                               
      XLOW = 0.                                                                 
      XHIGH = 0.                                                                
      GO TO 220                                                                 
C                                                                               
   50 CONTINUE                                                                  
C         DELETE 'LEADING' ZERO RANGE                                           
      XH = XMID                                                                 
      XL = XLOW                                                                 
      DO 70 K= 1, 20                                                            
      XNEW = 0.5*(XH+XL)                                                        
      IF (FUNC(XNEW) .EQ. 0.) GO TO 68                                          
      XH = XNEW                                                                 
      GO TO 70                                                                  
   68 XL = XNEW                                                                 
   70 CONTINUE                                                                  
      XLOW = XL                                                                 
      WRITE (IOU,555) X2LOW,XLOW                                                
  120 CONTINUE                                                                  
      IF (FUNC(XHIGH) .GT. 0.) GO TO 220                                        
C         DELETE 'TRAILING' RANGE OF ZEROES                                     
      XL = XMID                                                                 
      XH = XHIGH                                                                
      DO 170 K= 1, 20                                                           
      XNEW = 0.5*(XH+XL)                                                        
      IF (FUNC(XNEW) .EQ. 0.) GO TO 168                                         
      XL = XNEW                                                                 
      GO TO 170                                                                 
  168 XH = XNEW                                                                 
  170 CONTINUE                                                                  
      XHIGH = XH                                                                
      WRITE (IOU,555) XHIGH, X2HIGH                                             
C                                                                               
  220 CONTINUE                                                                  
      RETURN                                                                    
  554 FORMAT (38H0CANNOT FIND NON-ZERO FUNCTION VALUE  )                        
  555 FORMAT (25H FUNCTION IS ZERO FROM X=,E12.5,4H TO ,E12.5)                  
      END                                                                       
      SUBROUTINE FUNRAN(ARRAY,XRAN)                                             
C         GENERATION OF RANDOM NUMBERS IN ANY GIVEN DISTRIBUTION, BY            
C         4-POINT INTERPOLATION IN THE INVERSE CUMULATIVE DISTR.                
C         WHICH WAS PREVIOUSLY GENERATED BY FUNPRE                              
      COMMON/FUNINT/X                                                           
      DIMENSION ARRAY(100)                                                      
      DIMENSION RBUF(20)                                                        
      DATA IBUF/20/                                                             
      DATA GAP,GAPINV/.0101010101,99./                                          
C                                                                               
      IF (IBUF .LT. 20)  GO TO 10                                               
      CALL NRAN(RBUF,020)                                                       
      IBUF = 0                                                                  
   10 IBUF = IBUF + 1                                                           
      X = RBUF(IBUF)                                                            
      J = INT(  X    *GAPINV) + 1                                               
      J = MAX0(J,2)                                                             
      J = MIN0(J,98)                                                            
      P = (   X -GAP*FLOAT(J-1)) * GAPINV                                       
      A = (P+1.0) * ARRAY(J+2) - (P-2.0)*ARRAY(J-1)                             
      B = (P-1.0) * ARRAY(J) - P * ARRAY(J+1)                                   
      XRAN = A*P *(P-1.0) *0.16666667  + B * (P+1.0) * (P-2.0) * 0.5            
      RETURN                                                                    
      END                                                                       
      SUBROUTINE NRAN(VECTOR,N)                                                 
      DIMENSION VECTOR(N)                                                       
      DO 100 I=1,N                                                              
      VECTOR(I) = RNDM(I)                                                       
  100 CONTINUE                                                                  
      RETURN                                                                    
      ENTRY NRANIN (V)                                                          
      CALL RDMIN(V)                                                             
      RETURN                                                                    
      ENTRY NRANUT (V)                                                          
      CALL RDMOUT(V)                                                            
      RETURN                                                                    
      END                                                                       
      SUBROUTINE ELOS(EIN,EOUT,D)                                               
C     ===========================                                               
C                                                                               
C     ESTIMATES ENERGY LOSS FOR COSMIC RAYS.                                    
C     EIN,EOUT IN GEV. D IN GR*CM**-2                                           
C     MENON & MURTHY. PROGRESS IN ELEMENTARY PARTICLE AND COSMIC RAY            
C     PHYSICS. VOL9.                                                            
C                                                                               
      XF = 1000.                                                                
      EMEV=1000.*EIN                                                            
      DO 100 I=1,D/XF                                                           
C     DO 100 I=1,0.1*D                                                          
      EX=EMEV**2/(EMEV+10.9E3)                                                  
      DE=1.88+0.0766*ALOG(EX/106.)+3.6E-6*EMEV                                  
C     EMEV=EMEV-10.*DE                                                          
      EMEV=EMEV-XF*DE                                                           
      IF(EMEV.LT.0.) GOTO 200                                                   
100   CONTINUE                                                                  
      EOUT=0.001*EMEV                                                           
      RETURN                                                                    
200   CONTINUE                                                                  
      EOUT=0.                                                                   
      RETURN                                                                    
      END                                                                       