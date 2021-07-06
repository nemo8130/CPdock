      program transform

      character(80)::ifile
      character(5)::ci
      call getarg(1,ifile)

      open(1,file=ifile,status='old')    ! cb.Pgrid

!================================================================
!     skip HEADER (col: 1,2) : Em range, (col: 3,4) : Sm range
!================================================================

      read(1,59)
59    format(/) 


9     read(1,24,end=30)el,eu,sl,su,id,Pgr
!      write(*,80)Pgr
      eln = 300+(200*el)
      eun = 300+(200*eu)
      sln = 300+(200*sl)
      sun = 300+(200*su)
      write(ci,81)Pgr
      read(ci,81)Pgr
      write(9,45)eln,eun,sln,sun,id,Pgr
      goto 9

30    continue

81    format(f5.3)
24    format(4(f6.3,2x),3x,i5,2x,f10.8)
23    format(f8.5,1x,f8.5)
45    format(4(f8.3,2x),3x,i5,2x,f5.3)
80    format(f10.8)


      endprogram transform
