      Subroutine  YKFFit(field, rowYKNK, rc)
C----------------------------------------------------------------------
C! Full fit of two tracks to seach for a kink
CKEY YKINK KINK
C
C Fit for a kink using the point information. The two tracks are refit
C     using the Kalman filter. Then, YNV0VE is used to perform the
C     vertex fit. The process is iterated once in case the division of
C     hits between the two tracks shifts. At the end, the inner track is
C     refit with the vertex as a point in order to get the helix
C     parameters with the vertex constraint applied.
C
C     FRFT is copied into a temporary work bank, so various routines
C     which use it as input will work without affecting the values
C     which will be written to POT.  FRFT is always restored before
C     returning.
C
C   Author: Paul Rensing   4-5-95
C
C  INPUT:
C     REAL FIELD        - magnetic field
C     INTEGER rowYKNK   - row in the YKNK bank to work on
C     contents of YKNKPT bank
C
C  OUTPUT:
C     INTEGER RC - 0 means OK
C     YKNK, 0 row ROWYKNK is modified
C-------------------------------------------------------------
#ifndef DOC
      implicit none

      real field
      integer rowYKNK
      integer rc

#include "bcs.h"
C
#include "yknkcm.h"
#include "yknkpt.h"
C
#include "yknkjj.h"
#include "frftjj.h"

      integer MAXITER
      parameter (MAXITER = 2)

      integer NAMIND, UF2PNT, NDROP, NSWAP
      integer UFTKAL
      external NAMIND, UF2PNT, NDROP, NSWAP, UFTKAL

      integer iter
      integer indYKNK, namYKNK, namFRFT, indFRFT0, indFRFTTmp,namVDMS
      save namYKNK, namFRFT
      integer jYKNK
      integer npts, i, iret, j, k, m
      Real dummy(30)
      real rFit(MAXPTS), uFit(MAXPTS), zFit(MAXPTS)
      real sigUFit(MAXPTS), sigZFit(MAXPTS), cor(MAXPTS)
      real radius
      real a, b, phi
      real x(3), covx(3,3), covp(3,3), p(3)
      integer innerTrk, outerTrk
      real innerPsi, outerPsi
      real pV0(3), massPar(2)
      double precision pV0Cov(3,3), ppCov(6,6), vertCov(3,3)
      double precision mpCov(2,2)
      real pFitInner(3), pFitOuter(3)
      real deriv(6,3), tmpMat(6,3)
      real sum
      real pSumIn, pSumOut, pDot
      integer igarb
      real vertex(3), vertChi2
      integer index
      integer ndof, nzhits
      integer INTCHA, nrFRFT

#include "bmacrod.h"

      data namYKNK/0/

#include "bmacro.h"

      if (namYKNK .le. 0) then
         namYKNK = NAMIND('YKNK')
         namFRFT = NAMIND('FRFT')
         namVDMS = NAMIND('VDMS')
      end if

      indFRFT0 = IW(namFRFT)
      if (indFRFT0 .le. 0) then
         call RERROR('YKFFIT', 1, ' FRFT is missing')
         Rc = -1
         goto 9999
      end if

C get the YKNK bank

      indYKNK = IW(namYKNK)
      if (indYKNK .le. 0) then
         call RERROR('YKFFIT', 4, ' Missing YKNK bank')
         rc = -4
         goto 9999
      end if
      innerTrk = ITABL(indYKNK, rowYKNK, JYKNIT)
      outerTrk = ITABL(indYKNK, rowYKNK, JYKNOT)
      radius = sqrt(RTABL(indYKNK, rowYKNK, JYKNVX)**2 +
     $     RTABL(indYKNK, rowYKNK, JYKNVX+1)**2)

C Create a temporary FRFT work bank to store the current fits

      Rc = -2
      call WBANK( IW, indFRFTTmp, IW(indFRFT0), *9999)
      IW(indFRFTTMP-3) = INTCHA('YKFT')
      nrFRFT = IW(indFRFT0-2)
      call BKTOW( IW, 'FRFT', nrFRFT, IW, indFRFTTmp, *999)

C Copy the inner track kink fit into FRFT

      call ucopy( RW(KROW(indYKNK,rowYKNK)+JYKNHI),
     $      RW(KROW(indFRFT0,innerTrk)+JFRFIR),6)
      call ucopy( RW(KROW(indYKNK,rowYKNK)+JYKNHC),
     $      RW(KROW(indFRFT0,innerTrk)+JFRFEM),15)

      call vzero(cor, MAXPTS)

C  create the VDMS banks and update the VDMS for the inner track with the
C  VDET hits to be used.  Don't worry about the VDMS bank for the outer track,
C  since there are no VDET hits on it, and we care about the track parameters
C  outside the VDET.

      call VTRKEX(field, iret)
      if (iret .ne. 0) then
         rc = -6
         goto 999
      end if
      call VDMSUP2(innerTrk, nvdet, wafers, uVDet, wVDet, igarb)
      if (igarb .ne. 0) then
         indFRFT0 = IW(namFRFT)
      end if

      Do iter = 1, MAXITER

C Fit the inner track

         npts = 0
         do i = 1, nptsIn
            if (rIn(i) .le. radius) then
               npts = npts + 1
               rfit(npts) = rIn(i)
               ufit(npts) = uIn(i)
               zfit(npts) = zIn(i)
               sigUfit(npts) = sigUIn(i)
               sigZfit(npts) = sigZIn(i)
            end if
         end do
         do i = 1, nptsOut
            if (rOut(i) .le. radius) then
               npts = npts + 1
               rfit(npts) = rOut(i)
               ufit(npts) = uOut(i)
               zfit(npts) = zOut(i)
               sigUfit(npts) = sigUOut(i)
               sigZfit(npts) = sigZOut(i)
            end if
         end do
         if (npts.lt.3) then
            Rc = -(iter*1000+1)
            goto 999
         endif
         index = KROW(indFRFT0,innerTrk)
         iret = uftkal(field, npts, rFit, uFit, zFit, sigUFit,
     $        sigZFit, cor, RW(index+JFRFIR), RW(index+JFRFC2),
     $        RW(index+JFRFIR), RW(index+JFRFEM), RW(index+JFRFC2),
     $        IW(index+JFRFDF))
C for safety
         indFRFT0 = IW(namFRFT)
         index = KROW(indFRFT0, innerTrk)
C         if (iret.ne.0)call RERROR('YKFFIT',100+iret,
C     $      'Kalman Filter error')
         if (iret .ne. 0 .or.
     $        RW(index+JFRFC2)/IW(index+JFRFDF) .gt. chi2TrkCut) then
            Rc = -(iter*1000+1)
            goto 999
         end if

C check that the z dimension is well defined
         if (RW(index + JFRFEM+14) .gt. 100.0) then
            rc = -(iter*1000+2)
            goto 999
         end if

C get the helix parameters and error matrix at the outer point
         iret = UF2PNT(field, radius, RW(index+JFRFIR),
     $        RW(index+JFRFEM))
         if (iret .ne. 0) then
            Rc = -(iter*1000+3)
            goto 999
         end if

C fit the outer track

         npts = 0
         do i = 1, nptsIn
            if (rIn(i) .ge. radius) then
               npts = npts + 1
               rfit(npts) = rIn(i)
               ufit(npts) = uIn(i)
               zfit(npts) = zIn(i)
               sigUfit(npts) = sigUIn(i)
               sigZfit(npts) = sigZIn(i)
            end if
         end do
         do i = 1, nptsOut
            if (rOut(i) .ge. radius) then
               npts = npts + 1
               rfit(npts) = rOut(i)
               ufit(npts) = uOut(i)
               zfit(npts) = zOut(i)
               sigUfit(npts) = sigUOut(i)
               sigZfit(npts) = sigZOut(i)
            end if
         end do
         if (npts.lt.3) then
            Rc = -(iter*1000+4)
            goto 999
         endif
         index = KROW(indFRFT0, outerTrk)
         iret = uftkal(field, npts, rFit, uFit, zFit, sigUFit,
     $        sigZFit, cor, RW(index+JFRFIR), RW(index+JFRFC2),
     $        RW(index+JFRFIR), RW(index+JFRFEM), RW(index+JFRFC2),
     $        IW(index+JFRFDF))
C for safety
         indFRFT0 = IW(namFRFT)
         index = KROW(indFRFT0, outerTrk)
C         if (iret.ne.0)call RERROR('YKFFIT',iret+100,
C     $      'Kalman Filter error')
         if (iret .ne. 0 .or.
     $        RW(index+JFRFC2)/IW(index+JFRFDF) .gt. chi2TrkCut) then
            Rc = -(iter*1000+4)
            goto 999
         end if

C check that the z dimension is well defined
         if (RW(index + JFRFEM+14) .gt. 100.0) then
            rc = -(iter*1000+5)
            goto 999
         end if

C get the helix parameters and error matrix at the inner point

         iret = UF2PNT(field, radius, RW(index+JFRFIR),
     $        RW(index+JFRFEM))
         if (iret .ne. 0) then
            Rc = -(iter*1000+6)
            goto 999
         end if

C find the psi angles for the tracks near the vertex

         call uhelix(innerTrk, 1, radius, innerPsi, dummy,
     $        field, x, covx, p, covp, iret)
         if (iret .ne. 0) then
            Rc = -(iter*1000+7)
            goto 999
         end if
         call uhelix(outerTrk, 1, radius, outerPsi, dummy,
     $        field, x, covx, p, covp, iret)
         if (iret .ne. 0) then
            Rc = -(iter*1000+8)
            goto 999
         end if

C perform a vertex fit to the two tracks
         call YNV0VE(innerTrk, outerTrk, innerPsi, outerPsi,
     $        pV0, pV0Cov, pFitInner, pFitOuter,
     $        ppCov, vertex, vertCov,
     $        massPar, mpCov, vertChi2, iret)
         if (iret .ne. 0) then
            Rc = iter*1000+iret
            goto 999
         end if
         
         radius = sqrt(vertex(1)**2 + vertex(2)**2)
         if (radius .lt. fidInnerRad .or. radius .gt. fidOuterRad 
     $        .or. abs(vertex(3)) .gt. fidMaxZ) then
            Rc = -10
            goto 999
         end if

C end of fitting iteration
      end do

C Refit the inner track with the vertex as a point. This is a
C     (hopefully) reasonable way of finding the correct track parameters
C     with the vertex constraint included.

      npts = 0
      nzhits = 0
      do i = 1, nptsIn
         if (rIn(i) .le. radius) then
            npts = npts + 1
            rfit(npts) = rIn(i)
            ufit(npts) = uIn(i)
            zfit(npts) = zIn(i)
            sigUfit(npts) = sigUIn(i)
            sigZfit(npts) = sigZIn(i)
            if (sigZfit(npts) .lt. 1000.0) nzhits = nzhits + 1
         end if
      end do
      do i = 1, nptsOut
         if (rOut(i) .le. radius) then
            npts = npts + 1
            rfit(npts) = rOut(i)
            ufit(npts) = uOut(i)
            zfit(npts) = zOut(i)
            sigUfit(npts) = sigUOut(i)
            sigZfit(npts) = sigZOut(i)
            if (sigZfit(npts) .lt. 1000.0) nzhits = nzhits + 1
         end if
      end do

      if (nzhits .lt. 2) then 
         rc = -7
         goto 999
      end if

C kink vertex
      npts = npts + 1
      nzhits = nzhits + 1
      zFit(npts) = vertex(3)
      rFit(npts) = radius
      phi = atan2( vertex(2), vertex(1) )
      uFit(npts) = rFit(npts) * phi
      a = ( phi * vertex(1) - vertex(2) ) / rFit(npts)
      b = ( phi * vertex(2) + vertex(1) ) / rFit(npts)
      sigUFit(npts) = a**2 * vertCov(1,1) +
     $     b**2 * vertCov(2,2) + 2.0*a*b*vertCov(1,2)
      sigZFit(npts) = vertCov(3,3)

      ndof = npts + nzhits - 5
      if (ndof .le. 0 .or. npts .lt. 3) then
         Rc = -5
         goto 999
      endif
      index = KROW(indFRFT0,innerTrk)
      iret = uftkal(field, npts, rFit, uFit, zFit, sigUFit,
     $     sigZFit, cor, RW(index+JFRFIR), RW(index+JFRFC2),
     $     RW(index+JFRFIR), RW(index+JFRFEM), RW(index+JFRFC2),
     $     IW(index+JFRFDF))
C for safety
      indFRFT0 = IW(namFRFT)
      index = KROW(indFRFT0,innerTrk)
      if (iret.ne.0)call RERROR('YKFFIT',iret+100,
     $      'Kalman Filter error')
      if (iret .ne. 0 .or.
     $     RW(index+JFRFC2)/IW(index+JFRFDF) .gt. chi2TrkCut .or. 
     $     ndof .gt. IW(index+JFRFDF)) then
         Rc = -5
         goto 999
      end if

C check that the charges of the two tracks are equal
C (we need to do this here, since the new fit of the outer track does
C     not get saved.)
      
      if (RTABL(indFRFT0,innerTrk,JFRFIR) 
     $        * RTABL(indFRFT0,outerTrk,JFRFIR) .lt. 0.0) then
         Rc = 1
         goto 999
      end if

C make sure we have the correct YKNK index
      jYKNK = KROW(IW(namYKNK), rowYKNK)

C inner helix parameters

      call ucopy( RW(index+JFRFIR), RW(jYKNK+JYKNHI), 5)
      call ucopy( RW(index+JFRFEM), RW(jYKNK+JYKNHC), 15)

C copy the vertex information into the bank

      RW(jYKNK + JYKNC2) = vertChi2
      k = 0
      do i = 1, 3
         RW(jYKNK + JYKNVX + i - 1) = vertex(i)
         do j = 1, i
            RW(jYKNK + JYKNVC + k) = vertCov(j,i)
            k = k + 1
         end do
      end do

C compute the momentum quantities and fill the bank

      pSumIn = 0.0
      pSumOut = 0.0
      pDot = 0.0
      do i = 1, 3
         pSumIn = pSumIn + pFitInner(i)**2
         pSumOut = pSumOut + pFitOuter(i)**2
         pDot = pDot + pFitInner(i) * pFitOuter(i)
      end do
      IF (pSumIn.le.0.) then
        rc = 8
        goto 999
      ENDIF
      RW(jYKNK + JYKNPK) = sqrt(pSumIn)
      RW(jYKNK + JYKNPL) = pDot / RW(jYKNK + JYKNPK)
      IF (RW(jYKNK + JYKNPL)**2 .ge. pSumOut) THEN
        rc = 9
        goto 999
      ENDIF
      RW(jYKNK + JYKNPT) = sqrt(pSumOut - RW(jYKNK + JYKNPL)**2)

C compute the derivatives of the transform

      do i = 1, 3
         deriv(i,1) = pFitInner(i) / RW(jYKNK + JYKNPK)
         deriv(i+3,1) = 0.0

         deriv(i,2) = pFitOuter(i) / RW(jYKNK + JYKNPK) -
     $        RW(jYKNK + JYKNPL) * pFitInner(i) / pSumIn
         deriv(i+3,2) = deriv(i,1)

         deriv(i,3) = ( (1.0 - RW(jYKNK + JYKNPL)/RW(jYKNK + JYKNPK))
     $        * pFitOuter(i) / RW(jYKNK + JYKNPT)
     $        + RW(jYKNK + JYKNPL)**2 * pFitInner(i)/
     $        (2.0 * pSumIn * RW(jYKNK + JYKNPT)) )
         deriv(i+3,3) = ( pFitOuter(i) -
     $        RW(jYKNK + JYKNPL) * pFitInner(i) / RW(jYKNK + JYKNPK) )
     $        / RW(jYKNK + JYKNPT)
      end do

C do the matrix multiplication to compute the new covariance

      do i = 1, 6
         do j = 1, 3
            sum = 0.0
            do k = 1, 6
               sum = sum + ppCov(k,i) * deriv(k,j)
            end do
            tmpMat(i,j) = sum
         end do
      end do

      k = 0
      do i = 1, 3
         do j = 1, i
            sum = 0.0
            do m = 1, 6
               sum = sum + deriv(m,i) * tmpMat(m,j)
            end do
            
            RW(jYKNK + JYKNPC+k) = sum
            k = k + 1
         end do
      end do

      Rc = 0

C always swap back the original FRFT and then ditch the work bank

 999  continue
      call BKFRW( IW, 'FRFT', nrFRFT, IW, indFRFTTmp, *9999)
      call WDROP( IW, indFRFTTmp)
C
C drop the banks created by VTRKEX because the bank numbers do not
C   correspond to the real FRFT track numbers!
C
 9999 continue
      call BDROP(IW, 'VDMSVTXTVTER')
      
      return
      end
#endif
