      SUBROUTINE RTITLE(LUN)
C-----------------------------------------------------------------------
C!  - Print title :program name and version and computer type
C!
C!  Author      S. Orteu       23-JUN-1987
C!
C?
C!======================================================================
#ifndef DOC
#include "rjulver.h"
      CHARACTER*8 COMPU
C-----------------------------------------------------------------------
C
C Get computer type
      CALL ALMACH (COMPU)
C Alephlib number
      CALL ALVERS(ALVER)
      WRITE(LUN,500) RJVERS
      WRITE(LUN,501) COMPU,ALVER
  500 FORMAT('1'/
     +  11X,'    ================================================='/
     +  11X,'  ========= A L E P H Reconstruction Program =========='/
     +  11X,' ======================================================='/
     +  11X,'======                                             ======'/
     +  11X,'======          ////////                           ======'/
     +  11X,'======              ///         //  o              ======'/
     +  11X,'======             ///         //                  ======'/
     +  11X,'======       ///  ///  // //  //  //   /// /       ======'/
     +  11X,'======        //////  // //  //  //  //  //        ======'/
     +  11X,'======         ////--/////--//--//-- /////-        ======'/
     +  11X,'======          //                                 ======'/
     +  11X,'======                                             ======'/
     +  11X,' ======================================================='/
     +  11X,'  =================   Version',F7.2,'   ================'/
     +  11X,'    ================================================='/)
  501 FORMAT('0'/
     +  11X,'    ================================================='/
     +  11X,'  ==               Running on ' ,A, '               =='/
     +  11X,
     +  '  ==           Using ALEPHLIB Version ',F6.2,'         =='/
     +  11X,'    ================================================='/)
C
      END
#endif
