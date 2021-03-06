      SUBROUTINE VGSTOR(ICOMP, ISOLN)
C ---------------------------------------------------------------------
C! Create the VDet hit banks for a solution to the VDet pat. rec.
CKEY VGLOB VDET TRACK
C
C      Paul Rensing   - 4-5-95
C      Dave Casper    - 3-6-96  make VCPL tabular by removing unneeded
C                               rows when finished
C
C Fill the VDCO, VCPL, FVCL banks with the hits that represent a
C     solution found by the VDet global pattern recognition. FRTL is
C     modified with the number of hits found. The FRFT bank is NOT
C     modified by this routine.
C
C  INPUT:
C     INTEGER IComp - the component number
C     INTEGER ISoln - the solution number to use
C OUTPUT:
C      VDCO and FVCL are modified and may be lengthened
C      VCPL banks are created (one for each track)
C      FRTL is modified
C      VDXY, VDZT banks are modified
C      VDGC bank is modified (VDET 95 only)
C ------------------------------------------------------------------
#ifndef DOC
      IMPLICIT NONE
C
C Function parameters
C
      INTEGER ICOMP, ISOLN
C
C  Global includes
C
#include "bcs.h"
#include "vglbcm.h"
C
#include "vcpljj.h"
#include "frtljj.h"
#include "vdxyjj.h"
#include "vdztjj.h"
#include "vdcojj.h"
#include "fvcljj.h"
#include "vgxcjj.h"
#include "vghcjj.h"
#include "vdmrjj.h"
#include "vdgcjj.h"
C
C  Function calls
C
      INTEGER NLINK, NBANK, NAMIND, VDYEAR
      EXTERNAL NLINK, NBANK, NAMIND, VDYEAR
C
C  Local variables
C
      integer namvdco, namfrtl, namfvcl, namvdgc
C
      INTEGER indfrtl, indvdco, indfvcl, indvdms, indvcpl
      integer indvdxy, indvdzt, indvdgc, indvdmr
      integer jfrtl
      integer wafer, wafxy, uhit, whit
      integer pckhitU, pckhitW
      integer index, indVGHC, indVGXC
      INTEGER I, J, HIT, itrk, ii, ix
      integer nvdhits, vdoff
      real RPErr, ZErr, WNPulH, UNPulH
      integer ntrk, irow
      real vuw(3), xyz(3)
      integer year, igc, NAssCl
C
C Parameter for the Kalman filter
C
      REAL VV0(6),CC0(21)
      REAL CHI2
      INTEGER NDOF, NPTS
      REAL RPHAVE, ZPHAVE
      INTEGER NRPH,NZPH
C
      save namvdco, namfrtl, namfvcl, namvdgc
C
#include "bmacrod.h"
C
C Data statements
C
      DATA NAMVDCO/0/
C
C  Inline functions
C
#include "bmacro.h"
C
      IF (NAMVDCO .eq. 0) THEN
         NAMVDCO = NAMIND('VDCO')
         NAMFRTL = NAMIND('FRTL')
         NAMFVCL = NAMIND('FVCL')
         NamVDGC = NAMIND('VDGC')
      END IF
C
      indVGHC = NLINK('VGHC', ICOMP)
      INDVGXC = NLINK('VGXC', ICOMP)
      IF (indVGHC .EQ. 0 .OR. INDVGXC .EQ. 0) THEN
         CALL RERROR('VGSTOR', -1, ' cannot find component banks')
         GOTO 999 
      END IF
      NTrk = itabl(indVGXC, isoln, JVGXNT)
C
      INDFVCL = IW(NAMFVCL)
      INDVDCO = IW(NAMVDCO)
      INDFRTL = IW(NAMFRTL)
      IF (INDFVCL .EQ. 0 .OR. INDVDCO .EQ. 0 .OR. INDFRTL .EQ. 0) THEN
         CALL RERROR('VGSTOR', -2, ' cannot find track banks')
         GOTO 999 
      END IF
C
      year = VDYEAR()
      if (year .eq. 95) then
         IndVDGC = IW(NamVDGC)
         If (indVDGC .le. 0) then
            Call RERROR('VGSTOR', -3,' Cannot find VDGC bank')
            goto 999
         End if
      end if
C
C Check that there is enough space in the VDCO and FVCL banks. If not,
C     lengthen them now (should not happen).
C
      If (LFRROW(indVDCO) .lt. NTrk*4) Then
         call RERROR('VGSTOR', 4, ' VDCO is too short - lengthening')
         i = IW(indVDCO) + (LFRROW(indVDCO) - NTrk*4)*LVDCOA
         indVDCO = NBANK('VDCO', IW(indVDCO-2), i)
         if (indVDCO .le. 0) then
            CALL RERROR('VGSTOR', -5, ' out of memory')
            goto 999
         end if
      end if
      If (LFRROW(indFVCL) .lt. NTrk*4) Then
         call RERROR('VGSTOR', 6, ' FVCL is too short - lengthening')
         i = IW(indFVCL) + (LFRROW(indFVCL) - NTrk*4)*LFVCLA
         indFVCL = NBANK('FVCL', IW(indFVCL-2), i)
         if (indFVCL .le. 0) then
            CALL RERROR('VGSTOR', -7, ' out of memory')
            goto 999
         end if
      end if
C
C Set the solnused column
C
      do irow = 1, LROWS(indVGXC)
         IW(KROW(indVGXC,irow)+JVGXSN) = ISOLN
      end do
C
C Loop over the tracks in the component
C
      DO I = 1, ntrk
         irow = (isoln-1)*ntrk + i
         itrk = itabl(indVGHC,irow,JVGHTN)
C
C Process the new VDet hits. Create a VCPL bank for each track. Add the
C     hits to the VDCO bank. 
C
         indvcpl = nbank('VCPL', itrk,LMHLEN+4*LVCPLA)
         if (indvcpl .eq. 0) then
            call RERROR('VGSTOR', -8,' out of memory')
            goto 999
         end if
         iw(indvcpl+LMHCOL) = lvcpla
         iw(indvcpl+LMHROW) = 0
C
         nvdhits = 0
         vdoff = LROWS(indvdco)
C
         do j = 0, 3
            pckhitU = itabl(indVGHC, irow, JVGHH1+1 + 2*j)
            pckhitW = itabl(indVGHC, irow, JVGHH1 + 2*j)
            
            if (pckhitU .gt. 0 .or. pckhitW .gt. 0) then
C
C unpack the hit(s), wafer number and compute the correct VDXY bank number
C
               if (pckhitU .gt. 0) then
                  call vhupck(pckhitU, wafer, uhit)
                  call vrmwf(wafer,2,wafxy)
               else
                  uhit = 0
                  wafxy = 0
                  wafer = 0
               end if
               if (pckhitW .gt. 0) then
                  call vhupck(pckhitW, wafer, whit)
               else
C do not reset wafer. At least one of the hits had to set it.
                  whit = 0
               end if
C
C fill the VCPL bank
C                  
               index = KNext(indvcpl)
               if (LFRROW(indvcpl) .lt. 1) then
                  call RERROR('VGSTOR', -9,' VCPL is too small')
                  goto 999
C If the hit is now used once, set the count to -1 if the relative pulse
C     height in the two views indicates that it CAN be used again.
C 

               end if
               iw(index + JVCPXB) = wafxy
               iw(index + JVCPNX) = uhit
               iw(index + JVCPZB) = wafer
               iw(index + JVCPNZ) = whit
C unused entry!
               rw(index + JVCPC2) = 0.0
               iw(indvcpl+lmhrow) = lrows(indvcpl)+1
C
C get the info needed to feed the Kalman filter
C
               call vkaerr(itrk, wafer, wHit, uHit, 
     $              vuw, xyz, RPErr, ZErr, WNPulH, UNPulH)
C
C add hit to VDCO bank
C
               index = knext(indvdco)
               if (LFRROW(indvdco) .lt. 1) then
                  call RERROR('VGSTOR', -10,' VDCO is too small')
                  goto 999
               end if
               iw(index+JVDCWI) = wafer
               rw(index+JVDCR0) = sqrt(xyz(1)**2 + xyz(2)**2)
               rw(index+JVDCPH) = atan2( xyz(2), xyz(1) )
               rw(index+JVDCZ0) = xyz(3)
               rw(index+JVDCSR) = RPerr
               rw(index+JVDCSZ) = ZErr
               IW(index+JVDCQF) = 3
               IF (uhit.le.0) IW(index+JVDCQF) = IW(index+JVDCQF) - 1
               IF (whit.le.0) IW(index+JVDCQF) = IW(index+JVDCQF) - 2
               IW(index+JVDCTN) = itrk
               IW(indvdco+LMHROW) = IW(indvdco+LMHROW) + 1
C
C increment the assignment number in VDXY, VDZT
C For VDet 95, increment assignment count in VDGC
C
C If a hit is used twice, change the uncertainty to reflect the fact
C     that double hits have worse errors. Note that VDblHt will also
C     change the current VDCO hit so this is done after the row count
C     of VDCO is incremented!!
C
C If the hit is now used once, set the count to -1 if the relative pulse
C     height in the two views indicates that it CAN be used again.
C 
               if (whit .gt. 0) then
                  indvdzt = NLINK('VDZT', wafer)
                  if (indvdzt .eq. 0) then
                     write(6,*) 'missing vdzt bank ', wafer
                     call RERROR('VGSTOR', -11,' Missing VDZT Bank')
                     goto 999
                  end if
                  iw(KROW(indvdzt,whit)+JVDZNA) =
     $                 abs(iw(KROW(indvdzt,whit)+JVDZNA)) + 1
                  if (iw(KROW(indvdzt,whit)+JVDZNA) .gt. 1) then
                     call VDblHt(1, wafer, whit)
                  else if (iw(KROW(indvdzt,whit)+JVDZNA) .eq. 1 .and.
     $                    ((WNPulH - UNPulH) .gt. PHDIFF2V
     $                    .and. WNPulH .gt. PHTHRN)) then
                     iw(KROW(indvdzt,whit)+JVDZNA) = -1
                  end if
C
                  if (year .eq. 95) then
                     indVDMR = NLINK('VDMR', wafer)
                     If (indVDMR .le. 0) then
                        call RERROR('VGSTOR', -12,' Missing VDMR bank')
                        goto 999
                     end if
                     igc = ITABL(indVDMR, whit, JVDMVD)
                     NAssCl = abs(ITABL(indVDGC, igc, JVDGNA)) + 1
                     if (NAssCl .eq. 1 .and.
     $                    iw(KROW(indvdzt,whit)+JVDZNA) .eq. -1) then
                        NAssCl = -1
                     end if
                     iw(KROW(indVDGC, igc) + JVDGNA) = NAssCl
                  end if
               end if
C
               if (uhit .gt. 0) then
                  indvdxy = NLINK('VDXY', wafxy)
                  if (indvdxy .eq. 0) then
                     write(6,*) 'missing vdxy bank ', wafxy
                     call RERROR('VGSTOR', -13,' Missing VDXY Bank')
                     goto 999
                  end if
                  iw(KROW(indvdxy,uhit)+JVDXNA) =
     $                 abs(iw(KROW(indvdxy,uhit)+JVDXNA)) + 1
                  if (iw(KROW(indvdxy,uhit)+JVDXNA) .gt. 1) then
                     call VDblHt(2, wafxy, uhit)
                  else if (iw(KROW(indvdxy,uhit)+JVDXNA) .eq. 1 .and.
     $                    ((UNPulH - WNPulH) .gt. PHDIFF2V
     $                    .and. UNPulH .gt. PHTHRN)) then
                     iw(KROW(indvdxy,uhit)+JVDXNA) = -1
                  end if
C
                  if (year .eq. 95) then
                     indVDMR = NLINK('VDMR', wafxy+1)
                     If (indVDMR .le. 0) then
                        call RERROR('VGSTOR', -14,' Missing VDMR bank')
                        goto 999
                     end if
                     igc = ITABL(indVDMR, uhit, JVDMVD)
                     NAssCl = abs(ITABL(indVDGC, igc, JVDGNA)) + 1
                     if (NAssCl .eq. 1 .and.
     $                    iw(KROW(indvdxy,uhit)+JVDXNA) .eq. -1) then
                        NAssCl = -1
                     end if
                     iw(KROW(indVDGC, igc) + JVDGNA) = NAssCl
                  end if
               end if
C
C add this hit to the list for this track in FVCL bank
C
               if (LFRROW(indfvcl) .lt. 1) then
                  call RERROR('VGSTOR', -15, ' FVCL is too small')
                  goto 999
               end if
               iw(knext(indfvcl)+1) = LROWS(indvdco)
               iw(indfvcl+LMHROW) = iw(indfvcl+LMHROW) + 1
               nvdhits = nvdhits + 1
            end if
C end of loop over hits on a track
         end do
C
C set the number of hits in the FRTL bank
C
         jfrtl = krow(indfrtl,itrk)
         iw(jfrtl+JFRTNV) = nvdhits
         iw(jfrtl+JFRTIV) = vdoff
C               
C end of loop over tracks in a component
C
      end do
C
 999  CONTINUE
      CALL AUBPRS('VCPL')
      return
      end
#endif
