      integer         IBIG
      parameter (     IBIG = 5000)
      real            clat(IBIG), clong(IBIG)
      common /coast/  clat, clong
!  backward is a logical variable which is true if you read in the
!  data in the direction opposite to the direction it should be
!  written out for the grid program.
      logical         backward
      parameter (     backward = .false.     )
