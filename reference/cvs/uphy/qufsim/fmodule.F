      subroutine fmodule(theta,ph,M_ECAL,M_HCAL)
C-----------------------------------------------------------------------
C
C find out to which module theta ph corresponds
C
C argument : theta phi       : angles in degrees
C            M_ECAL (M_HCAL) : module touched
C
C for ECAL, module 37 is in fact LCAL/SICAL
C-----------------------------------------------------------------------
#include "qcde.h"
      real poleca,polecb,polEclow
      parameter (poleca=40.,polecb=140.,polEclow=13.)
#include "qmacro.h"

C... make sure that phi is between 0 and 360,
      phi = mod(ph+360.,360.)

      if ( theta .lt. poleca ) then
        m_offE = 0
        m_offH = 0
        EcPhiOff = 16.875
      elseif ( theta .gt. polecb ) then
        m_offE = 24
        m_offH = 30
        EcPhiOff = 16.875
      else
        m_offE = 12
        m_offH = 6
        EcPhiOff = 1.875
      endif

      if ( theta .lt. polEclow .or. theta .gt. 180.-polEClow ) then
C... this is rather LCAL/SICAL
        M_ECAL = 37
      else
C... ECAL barrel is slightly shifted in phi
C    End-Caps shifted by 15 deg. vrt Barrel
        iphi =  int(mod(phi+EcPhiOff,360.)/30.)
        M_ECAL = m_offE + iphi + 1
      endif

C.. HCAL modules : EA 1->6 (unit=2 modules)
C                  BA 7->30 (unit=half-modules)
C                  EB 31->36
      if ( theta .gt. poleca .and. theta .lt. polecb ) then
        M_HCAL = m_offH + int(phi/15.) + 1
      else
        M_HCAL = m_offH + int(phi/60.) + 1
      endif


      return
      end
