

C=======================================================================
      subroutine qgetw_e14(module,eplane,estack,esum,t0)
C-----------------------------------------------------------------------
C get some relevant information from the wires of a given ECAL module
C Auxiliary to QFE14
C Author G. Taylor Oct 1997
C-----------------------------------------------------------------------
#include "bcs.h"
      parameter(nplane=45)
      real eplane(nplane),estack(3)
      real enoise(nplane)
      logical bpl_e14,xfound
#include "bmacro.h"
C-----------------------------------------------------------------------
      call vzero(estack(1),3)
      call vzero(eplane(1),nplane)
      esum=0.
      t0=0. 
C....
      kdewi=iw(namind('DEWI'))
      if (kdewi.gt.0) then
       do i=1,lrows(kdewi)
        if (module.eq.itabl(kdewi,i,1)) then
         esum=real(itabl(kdewi,i,2))/1000.
        endif
       enddo
C... this is all there is on the mini
       return
      endif
      xfound=.false.
C....
      kpwei=iw(namind('PWEI'))
      if (kpwei.gt.0) then
       do i=1,lrows(kpwei)
        if (module.eq.itabl(kpwei,i,1)) then
         xfound=.true.
         do iplane=1,45
          eplane(iplane)=real(itabl(kpwei,i,iplane+1))/1000000.
         enddo
         t0=real(itabl(kpwei,i,63))
        endif
       enddo
      endif
C....
      kpewi=iw(namind('PEWI'))
      if (kpewi.gt.0) then
       do i=1,lrows(kpewi)
        if (module.eq.itabl(kpewi,i,1)) then
         xfound=.true. 
         do iplane=1,45
          eplane(iplane)=real(itabl(kpewi,i,iplane+1))/1000000.
         enddo
         t0=real(itabl(kpewi,i,55))
        endif
       enddo
      endif
C
C temporarily divide stack 3 by 50% tp make more uniform
C
      do iplane=34,45
       eplane(iplane)=eplane(iplane)/2.
      enddo
C
      if (.not.xfound) return
C
C treat the dead wires ....
C
      do iplane=1,nplane
       if (bpl_e14(module,iplane)) then
        if (iplane.eq.1) then
         enew=eplane(iplane+1)
        else if (iplane.eq.45) then
         enew=eplane(iplane-1)
        else
         enew=(eplane(iplane-1)+eplane(iplane+1))/2.
        endif
        eplane(iplane)=enew
       endif
      enddo
C
C treat the noisy wires ....
C
      do iplane=1,nplane
C
C reduce allowed noise on third stack to deal with gain
C exclude first plane of stack three to be conservative
C
       if (iplane.le.34) then
        enoise(iplane)=2.5 
       else
        enoise(iplane)=1.25 
       endif
      enddo
C
      do iplane=1,nplane
C
       enew=-1.
       if (iplane.eq.1) then
        if (eplane(iplane)-eplane(iplane+1).gt.enoise(iplane))
     &    enew=eplane(iplane+1)
       else if (iplane.eq.45) then
        if (eplane(iplane)-eplane(iplane-1).gt.enoise(iplane))
     &    enew=eplane(iplane-1)
       else
        ed1=abs(eplane(iplane-1)-eplane(iplane))
        ed2=abs(eplane(iplane+1)-eplane(iplane))
        edmax=max(ed1,ed2)
        edmin=min(ed1,ed2)
        if (edmax.gt.enoise(iplane).and.edmin.gt.0.66*enoise(iplane))
     &    enew=(eplane(iplane-1)+eplane(iplane+1))/2.
       endif 
       if (enew.gt.-1.) eplane(iplane)=enew 
      enddo  
C
      do iplane=1,nplane-1
       ed1=eplane(iplane+1)-eplane(iplane)
       if (abs(ed1).gt.1.00*enoise(iplane)) then
        do jplane=iplane+1,nplane-1
         ed2=eplane(jplane+1)-eplane(jplane)
         edmax=max(abs(ed1),abs(ed2))
         edmin=min(abs(ed1),abs(ed2))
         if (edmax.gt.max(enoise(iplane),enoise(jplane)).and.
     &      edmin.gt.1.00*min(enoise(iplane),enoise(jplane)).and.
     &      ed1.gt.0..and.ed2.lt.0.) then
          enew=(eplane(iplane)+eplane(jplane+1))/2.
          do kplane=iplane+1,jplane
           eplane(kplane)=enew 
          enddo
          goto 200
         endif 
        enddo  
       endif 
 200   continue
      enddo
C
C multiply stack 3 by 2
C
      do iplane=34,45
       eplane(iplane)=eplane(iplane)*2.
      enddo
C
      do iplane=1,nplane
       esum=esum+eplane(iplane)
       istack=1
       if (istack.gt.10) istack=2
       if (istack.gt.10+23) istack=3
       estack(istack)=estack(istack)+eplane(iplane)
      enddo 
C....
      if (kpwei.gt.0) then
       f3=0.
       if (estack(3).gt.0.) f3=estack(3)/esum
       if (module.le.12.or.module.ge.25) then
        t0=(t0-8)+80*f3
       else
        t0=(t0-16)+60*f3
       endif
      endif 
      RETURN
      END
