      Subroutine YKVDet(field, vertex, vertexCov, helParm, helCov,
     $     vdhits, minChi2, sndChi2)
C-------------------------------------------------------------------------
C! Look for free VDET hits which match the inner track of a potential kink
CKEY YKINK VDET
C
C  Author:   Paul Rensing  15-1-96
C  Modified: D.Smith       991027  Double precision fixes for Linux
C
C This routine looks for VDET hits which match the inner track of a
C   potential kink. If the inner track does not enough z measurements to
C   define the track, the track is refit with the kink vertex and/or
C   the beam spot used as contraints. The work of finding matching hits
C   is done by the routines from the VGLOB package.
C
C INPUT:
C     real field         - magnetic field
C     real vertex(3)     - position of kink vertex
C     real vertexCov(6)  - covariance of kink vertex
C
C     contents of YKNKPT common
C
C OUTPUT:
C     real helParm(5)    - parameters of inner helix with constaints added
C     real helCov(15)    - covariance of inner helix with constaints added
C     integer vdhits(8)  - list of VDET hits, packed as in VGHC bank
C     real minChi2       - chi**2 of association for best combination
C     real sndChi2       - chi**2 of assoc. for second best combination
C
C     YKNKPT is updated to reflect any VDET hits found
C     
C-------------------------------------------------------------------------
#ifndef DOC
      implicit none
C
      real field
      real vertex(3), vertexCov(6)
      real helParm(5), helCov(15)
      integer vdhits(8)
      real minChi2, sndChi2
C
#include "bcs.h"
C
#include "pyerjj.h"
#include "frftjj.h"
#include "fxtrjj.h"
#include "vmucjj.h"
#include "vmwcjj.h"
C
#include "yknkcm.h"
#include "yknkpt.h"
C
C Functions
C
      integer NLINK, NDROP
C
C Parameters
C
      real XYCHILIM
      parameter (XYCHILIM = 25.0)
C
      integer i
      real radius
      real rFit(MAXPTS), zFit(MAXPTS)
      real phiFit(MAXPTS), icovZFit(MAXPTS)
C !!!
      double precision xFit(MAXPTS), yFit(MAXPTS), icovUFit(MAXPTS)
      integer nptsFit, nZHits
      logical useVertex
      integer indPYER
      real a, b
      real chi2XY, chi2Z
      integer nrank, rc
      real chi2
      integer igarb
      real helix(5), cov(15)
C
#include "bmacrod.h"
#include "bmacro.h"

      radius = sqrt(vertex(1)**2 + vertex(2)**2)
     
      nptsFit = 0
      nZHits = 0
      useVertex = .TRUE.

      do i = 1, nptsIn
         if (rIn(i) .lt. radius) then
            if (rIn(i) .gt. 30.0) useVertex = .FALSE.
            if (sigZIn(i) .lt. 1000.0) nZHits = nZHits + 1

            nptsFit = nptsFit + 1
            rFit(nptsFit) = rIn(i)
            zFit(nptsFit) = zIn(i)
            icovUFit(nptsFit) = 1.0 / sigUIn(i)
            icovZFit(nptsFit) = 1.0 / sigZIn(i)
            phiFit(nptsFit) = uIn(i) / rFit(nptsFit)
            xFit(nptsFit) = rFit(nptsFit) * cos(phiFit(nptsFit))
            yFit(nptsFit) = rFit(nptsFit) * sin(phiFit(nptsFit))
         end if
      end do
      do i = 1, nptsOut
         if (rOut(i) .lt. radius) then
            if (rOut(i) .gt. 30.0) useVertex = .FALSE.
            if (sigZOut(i) .lt. 1000.0) nZHits = nZHits + 1
            
            nptsFit = nptsFit + 1
            rFit(nptsFit) = rOut(i)
            zFit(nptsFit) = zOut(i)
            icovUFit(nptsFit) = 1.0 / sigUOut(i)
            icovZFit(nptsFit) = 1.0 / sigZOut(i)
            phiFit(nptsFit) = uOut(i) / rFit(nptsFit)
            xFit(nptsFit) = rFit(nptsFit) * cos(phiFit(nptsFit))
            yFit(nptsFit) = rFit(nptsFit) * sin(phiFit(nptsFit))
         end if
      end do

      if (nptsFit .lt. 3) return

C if there are no TPC points to provide Z measurement at end of track, 
C     use the vertex as a constraint

      if (useVertex) then
         nptsFit = nptsFit + 1
         if (vertexCov(6) .lt. 400.0) nZHits = nZhits + 1
         xFit(nptsFit) = vertex(1)
         yFit(nptsFit) = vertex(2)
         zFit(nptsFit) = vertex(3)
         rFit(nptsFit) = radius
         phiFit(nptsFit) = datan2( yFit(nptsFit), xFit(nptsFit) )
         a = (phiFit(nptsFit) * xFit(nptsFit) - yFit(nptsFit))
     $        / rFit(nptsFit)
         b = (phiFit(nptsFit) * yFit(nptsFit) + xFit(nptsFit))
     $        / rFit(nptsFit)
C blow up the u error by sqrt(2) to de-weight it
         icovUFit(nptsFit) = 0.5 / (a**2 * vertexCov(1) +
     $        b**2 * vertexCov(3) + 2.0*a*b*vertexCov(2))
         iCovZFit(nptsFit) = 1.0 / vertexCov(6)
      end if
      
C add the beam spot as a constraint
C read primary vertex from the pyer bank

      if (nZHits .lt. 2) then
         indPYER = NLINK('PYER',0)
         IF (indPYER .EQ. 0) Then
            call RERROR('YKVDet', 1, 'PYER bank is missing')
            return
         end if
         nZHits = nZHits + 1
         DO I = 1, LROWS(indPYER)
            IF (ITABL(indPYER,I,JPYETY) .EQ. 1) Then
               nptsFit = nptsFit + 1
               
               xFit(nptsFit) = RTABL(indPYER,I,JPYEVX)
               yFit(nptsFit) = RTABL(indPYER,I,JPYEVY)
               zFit(nptsFit) = RTABL(indPYER,I,JPYEVZ)
               
               rFit(nptsFit) = sqrt(xFit(nptsFit)**2 + yFit(nptsFit)**2)
               
C the fitting algorithms are unstable if you give them a point 
C       with r=0, so put it very slightly off.
               if (rFit(nptsFit) .lt. 0.01) then
                  rFit(nptsFit) = 0.01
                  phiFit(nptsFit) = phiFit(nptsFit-1)
                  xFit(nptsFit) = rFit(nptsFit) * cos(phiFit(nptsFit))
                  yFit(nptsFit) = rFit(nptsFit) * sin(phiFit(nptsFit))
               else
                  phiFit(nptsFit) =datan2(yFit(nptsFit), xFit(nptsFit))
               end if
               
               a = (phiFit(nptsFit) * xFit(nptsFit) - yFit(nptsFit))
     $              / rFit(nptsFit)
               b = (phiFit(nptsFit) * yFit(nptsFit) + xFit(nptsFit))
     $              / rFit(nptsFit)
C This is the primary vertex position. Blow up the uncertainty!
C Blow up U dimension more, since this should be measured by the points.
               icovUFit(nptsFit) = 0.01/ (a**2 * RTABL(indPYER,I,JPYEVM)
     $              + b**2 * RTABL(indPYER,I,JPYEVM+2)
     $              + 2.0*a*b * RTABL(indPYER,I,JPYEVM+1) )
               iCovZFit(nptsFit) = 0.1 / RTABL(indPYER,I,JPYEVM+5)
               goto 10
            end if
         end do
         call RERROR('YKVDet', 2, 'Primary Vertex not in PYER')
         return
      end if
 10   continue

C circle fit

      if (nZHits .lt. 2) return

      call TFITHL( nptsFit, xFit, yFit, rFit, phiFit, iCovUFit,
     $     zFit, iCovZFit, 3, helix, cov, chi2XY, chi2Z )
C test for no convergence
      if (chi2XY + chi2Z .gt. 5000.0) then
         return
      end if
      
C check that XY chi2 is reasonable

      if (chi2XY / MAX(1, (nptsFit - 3)) .gt. XYCHILIM) then
         return
      end if

C TFitHL returns the inverse ofthe covariance matrix. Re-invert it. 
C   (argument "a" is a dummy).

      call SMINV(cov, a, 5, 0, nrank)
      if (nrank .ne. 5) then
         return
      end if
   
C fix up the sign convention!!! Can't someone fix this properly!!!

      helix(1) = -helix(1)
      if (helix(1) .lt. 0.0) then
         helix(4) = -helix(4)
         cov(8) = -cov(8)
         cov(9) = -cov(9)
         cov(14) = -cov(14)
      else
         cov(7) = -cov(7)
      end if
      cov(2) = -cov(2)
      cov(4) = -cov(4)
      cov(11) = -cov(11)

C Now, call the VGLOB routines to find the potential VDET hits

      call VGSrch(field, helix, cov, minChi2, sndChi2,
     $     vdhits, nvdet, rIn(nptsIn+1), uIn(nptsIn+1), zIn(nptsIn+1),
     $     sigUIn(nptsIn+1), sigZIn(nptsIn+1),
     $     wafers, uVDet, wVDet)

      if (minChi2 .gt. vdetChiCut .or.
     $     sndChi2 - minChi2 .lt. vdetChiDiff) then

C this does not pass the cuts. Clear out the variables.

         nvdet = 0
         call vzero(vdhits, 8)
         minchi2 = 1e10
         sndchi2 = 1e10
      else
         nptsIn = nptsIn + nvdet

C modify the helix parameter function arguments.
         call ucopy(helix, helParm, 5)
         call ucopy(cov, helCov, 15)
      end if
      
 999  continue
      return
      end
#endif
