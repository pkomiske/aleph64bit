      INTEGER FUNCTION VDLCRS (XCOOR,IVIEW,RSTRP)
C ----------------------------------------------------------------------
CKEY VDETDES TRANSFORM STRIP / USER
C!  Local coordinate to readout strip.
C - Joe Rothberg, 11 February 1994
C     Returns readout strip number,
C     given position in local wafer coordinates, and view number.
C
C - Input:
C   XCOOR  / R  position in local wafer coordinates
C   IVIEW  / I  View number (=1 for z, =2 for r-phi)
C
C - Output:
C   VDLCRS / I  = VDOK if successful
C               = VDERR if error occurred
C   RSTRP  / R  readout strip number (floating number)
C ----------------------------------------------------------------------
C     IMPLICIT NONE
C!    Parameters for VDET geometry package
C ----------------------------------------------------------------------
C
C     Labels for return codes:
C
      INTEGER VDERR, VDOK
      PARAMETER (VDERR = -1)
      PARAMETER (VDOK  = 1)
C
C     Labels for views:
C
      INTEGER VVIEWZ, VVIEWP
      PARAMETER (VVIEWZ = 1)
      PARAMETER (VVIEWP = 2)
C
C     Fixed VDET geometry parameters:
C
      INTEGER NVLAYR, NVMODF, NVVIEW, NPROMM, IROMAX
      PARAMETER (NVLAYR = 2)
      PARAMETER (NVMODF = 2)
      PARAMETER (NVVIEW = 2)
      PARAMETER (NPROMM = 1)
      PARAMETER (IROMAX = 4)
C
C     Array dimensions:
C
      INTEGER NVWMMX, NVWFMX, NVFLMX, NVFMAX, NVMMAX, NVWMAX
      INTEGER NVZRMX, NVPRMX
      PARAMETER (NVWMMX = 3)
      PARAMETER (NVWFMX = NVWMMX*NVMODF)
      PARAMETER (NVFLMX = 15)
      PARAMETER (NVFMAX = 24)
      PARAMETER (NVMMAX = NVFMAX*NVMODF)
      PARAMETER (NVWMAX = NVFMAX*NVWFMX)
      PARAMETER (NVZRMX = NVFMAX*IROMAX)
      PARAMETER (NVPRMX = NVMMAX*NPROMM)
C
C
      INTEGER IVIEW
      REAL XCOOR, RSTRP
C
C     Local variables
C
C     PSTRP       physical strip number
C
      REAL PSTRP
      INTEGER STATUS
C
C functions
      INTEGER VDLCPS, VDPSRS
C
C ----------------------------------------------------------------------
C
C check validity of arguments
C
      IF ((IVIEW .NE. VVIEWZ) .AND. (IVIEW. NE. VVIEWP)) THEN
        RSTRP = 0.
        VDLCRS = VDERR
      ELSE
C
C ----------------------------------------------------------------------
C find physical strip number
        STATUS = VDLCPS(XCOOR,IVIEW,PSTRP)
C find readout strip number
        IF (STATUS .EQ. VDOK) THEN
          STATUS = VDPSRS(PSTRP,IVIEW,RSTRP)
          IF (STATUS .EQ. VDOK) THEN
            VDLCRS  = VDOK
          ELSE
            VDLCRS = VDERR
          ENDIF
        ELSE
          VDLCRS = VDERR
        ENDIF
C ----------------------------------------------------------------------
C  valid input arguments
      ENDIF
C
      RETURN
      END
