! UTEP Electronic Structure Lab (2020)
!> Commented out section in the main.ftn.
!> Moved here to keep the main.ftn clean.
subroutine updatescissor(JSPNX)
use common5, only :: NWFS
use LOCORB,only   :: TMAT
integer :: IWF,IORB,JWF
integer,intent(in) :: JSPNX
COMMON/LOCORB/TMAT(MAX_OCC,MAX_OCC,MXSPN)
DIMENSION     SICC(MAX_OCC,MAX_OCC)
COMMON/HMATSIC/ OVTM(MAX_OCC,MAX_OCC,2),HMTM(MAX_OCC,MAX_OCC,2)
!HAM

! UPDATE SCISSOR:
!555       CONTINUE
OPEN(76,FILE='SIC_HAM',FORM='FORMATTED',STATUS='UNKNOWN')
!DO JSPNX=1,NSPX
  IF(JSPNX.EQ.1)THEN
    OPEN(77,FILE='SCISSOR1',FORM='FORMATTED',STATUS='UNKNOWN')
    OPEN(75,FILE='SCISSOR3',FORM='FORMATTED',STATUS='UNKNOWN')
  ELSE
    OPEN(77,FILE='SCISSOR2',FORM='FORMATTED',STATUS='UNKNOWN')
    OPEN(75,FILE='SCISSOR4',FORM='FORMATTED',STATUS='UNKNOWN')
  END IF
  REWIND(77)
  REWIND(75)
  WRITE(75,*)'TMAT:'
  DO IWF=1,NWFS(JSPNX)
    WRITE(75,811)(TMAT(IORB,IWF,JSPNX),IORB=1,NWFS(JSPNX))
  END DO
  WRITE(75,*)'HMTM:'
  DO IWF=1,NWFS(JSPNX)
    WRITE(75,811)(HMTM(IORB,IWF,JSPNX),IORB=1,NWFS(JSPNX))
  END DO
  DO IWF=1,NWFS(JSPNX)
    DO JORBX=1,NWFS(JSPNX)
      HAM(JORBX,IWF)=0.0D0
      DO IORBX=1,NWFS(JSPNX)
       HAM(JORBX,IWF)=HAM(JORBX,IWF)+TMAT(IORBX,IWF,JSPNX)*  &
       (HMTM(IORBX,JORBX,JSPNX)+HMTM(JORBX,IORBX,JSPNX))/2.0D0
      END DO
    END DO
  END DO
  DO IWF=1,NWFS(JSPNX)
    DO JWF=1,NWFS(JSPNX)
      SICC(JWF,IWF)=0.0D0
      DO JORBX=1,NWFS(JSPNX)
        SICC(JWF,IWF)=SICC(JWF,IWF)+   &
         HAM(JORBX,IWF)*TMAT(JORBX,JWF,JSPNX)
      END DO
    END DO
  END DO
  WRITE(77,*)NWFS(JSPNX)
  WRITE(76,*)'HAM, SPIN =', JSPNX
  ISIZE=NWFS(JSPNX)
  DO IORBX=1,NWFS(JSPNX)
    WRITE(77,811)(SICC(I, IORBX      ),I=1,ISIZE)
    WRITE(76,810)(HMTM(I, IORBX,JSPNX),I=1,ISIZE)
  END DO
  WRITE(77,*)' '
  DO IORBX=1,NWFS(JSPNX)
    WRITE(77,810)(HMTM(I, IORBX,JSPNX),I=1,ISIZE)
  END DO

end subroutine