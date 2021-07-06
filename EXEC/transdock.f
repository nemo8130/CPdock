      program transform

!=====================================================
!     Give appropriate linear transformations to the (Sm, Em) values 
!     [Y = mX + C] in order to generate postscripts for CPs
!=====================================================

      character(80)::ifile,path,out1
      call getarg(1,ifile)
      call getarg(2,path)

      out1=adjustl(trim(path))//'/fort.9'
      print*,out1

      open(1,file=ifile,status='old')
      open(9,file=out1)

      ic=0
9     read(1,23,end=30)x,y
      ic=ic+1
      xn = 300+(200*(x))
      yn = 300+(200*(y))
      write(9,45)ic,xn,yn
      goto 9

30    continue

!23    format(i3,10x,2(2x,f6.3))
23    format(f8.3,1x,f8.3)
45    format(i5,2x,f8.3,2x,f8.3)


      endprogram transform
