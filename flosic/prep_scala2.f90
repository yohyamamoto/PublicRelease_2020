! UTEP Electronic Structure Lab (2020)
SUBROUTINE PREP_SCALA(N)
USE HSTOR1,only : HSTOR,NNZH,NNZO,IAH,JAH,IAO,JAO
IMPLICIT NONE
INTEGER,INTENT(IN)  :: N
INTEGER             :: N_TOT
INTEGER             :: I,J,K
INTEGER             :: IDXH,JDXH
INTEGER             :: IDXO,JDXO
LOGICAL             :: START_ROWH
LOGICAL             :: START_ROWO
REAL*8,PARAMETER    :: ZERO_V=1.0E-08

N_TOT=(N*(N+1))/2
NNZH=0
NNZO=0
DO I=1,N_TOT
  IF(HSTOR(I,1)>ZERO_V) NNZO=NNZO+1
  IF(HSTOR(I,2)>ZERO_V) NNZH=NNZH+1
END DO

WRITE(6,*) 'NNZH',NNZH,'NNZO',NNZO

ALLOCATE(JAH(NNZH),STAT=I)
IF(I/=0) WRITE(6,*) 'PREP_SCALA:ERROR ALLOCATING JAH'
ALLOCATE(IAH(N+1),STAT=I)
IF(I/=0) WRITE(6,*) 'PREP_SCALA:ERROR ALLOCATING IAH'
ALLOCATE(JAO(NNZO),STAT=I)
IF(I/=0) WRITE(6,*) 'PREP_SCALA:ERROR ALLOCATING JAO'
ALLOCATE(IAO(N+1),STAT=I)
IF(I/=0) WRITE(6,*) 'PREP_SCALA:ERROR ALLOCATING IAO'

K=1
JDXH=1
IDXH=1
JDXO=1
IDXO=1
DO I=1,N
  START_ROWH=.TRUE.
  START_ROWO=.TRUE.
  DO J=I,N
! WORK WITH HAMILTONIAN MATRIX
    IF(HSTOR(K,2)>ZERO_V) THEN
      JAH(JDXH)=J
      HSTOR(JDXH,2)=HSTOR(K,2)
      IF(START_ROWH) THEN
        START_ROWH=.FALSE.
        IAH(I)=JDXH
!        IDXH=IDXH+1
      ENDIF
      JDXH=JDXH+1
    ENDIF
! WORK WITH OVERLAP MATRIX
    IF(HSTOR(K,1)>ZERO_V) THEN
      JAO(JDXO)=J
      HSTOR(JDXO,1)=HSTOR(K,1)
      IF(START_ROWO) THEN
        START_ROWO=.FALSE.
        IAO(I)=JDXO
!        IDXO=IDXO+1
      ENDIF
      JDXO=JDXO+1
    ENDIF

    K=K+1
  END DO
END DO

IAH(IDXH)=IAH(IDXH-1)+1
IF(JDXH-1/=NNZH) WRITE(6,*) 'Problem in JA for HAM'
IF(I/=N+1) WRITE(6,*) 'Problem in IA for HAM'

IAO(IDXO)=IAO(IDXO-1)+1
IF(JDXO-1/=NNZO) WRITE(6,*) 'Problem in JA for OVL'
IF(I/=N+1) WRITE(6,*) 'Problem in IA for OVL'

RETURN
END SUBROUTINE PREP_SCALA
