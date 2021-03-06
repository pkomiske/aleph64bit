      SUBROUTINE QFDE14
C-----------------------------------------------------------------------
C Get the results of the E14 algorithm
C If MINI write requested,  fills MINI bank DE14 
C J. Boucrot 9 Oct 2000
C-----------------------------------------------------------------------
#include "qcde.h"
#include "de14jj.h"
      PARAMETER ( FDE14 = 1000000. , EMXT = 1000.) 
      COMMON / E14VARS / E14ECA,E14HCA,ILCCVT
#include "bmacro.h"
C-----------------------------------------------------------------------
      e14ec=0.
      e14hc=0.
      lveto=0
C
C If one is not reading a MINI, call the E14 algorithm:
C
      if (.not.xmini) then
         call qcale14(e14ec,e14hc)
         lveto=lcra_e14() 
         if (e14ec.gt.emxt) e14ec=emxt
         if (e14hc.gt.emxt) e14hc=emxt
C If one is writing a MINI, build the 'DE14' bank:
         if (xwmini) then 
            call bdrop(IW,'DE14') 
            LE14=LMHLEN+LDE14A     
            CALL AUBOS('DE14',0,LE14,JDE14,IGARB)
            IF (IGARB.EQ.2) GO TO 800
            IW(JDE14+LMHROW)=1
            IW(JDE14+LMHCOL)=LDE14A
            KDE14=KROW(JDE14,1)
            IW(KDE14+JDE1EC)=NINT(FDE14*E14EC)
            IW(KDE14+JDE1HC)=NINT(FDE14*E14HC)
            IW(KDE14+JDE1LV)=LVETO 
          endif
C
C If one is reading a MINI, get the result of E14 from 
C the 'DE14' bank:
C
      else
         jde14=iw(namind('DE14'))
         if (jde14.eq.0) go to 800
         kde14=krow(jde14,1)
         e14ec=float(iw(kde14+jde1ec))/fde14
         e14hc=float(iw(kde14+jde1hc))/fde14
         lveto=iw(kde14+jde1lv)
      endif
C Fill the variables of common / E14VARS / :
 800  e14eca=e14ec
      e14hca=e14hc
      ilccvt=lveto
C
 999  return
      end
