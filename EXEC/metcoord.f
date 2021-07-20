      program metcoord

!===========================================
! DETECT METAL-COORDINATING RESIDUES
!===========================================

      character(80)::pdbf,metcores,metrasview
      character(4)::atag
      character(3)::atype,rtype
      character(3)::patom(20000),pres(20000),matom(100),mres(100)
      character(3)::patom1(100)
      character(3)::prs(30),mco(30)
      character(1)::pchain(20000),mchain(20000),chn,mch(30)
      character(1)::pch(30),pch1(30)
      real::xp1(30),yp1(30),zp1(30)
      integer::ipres(20000),imres(100),iprs1(30)
      real::xp(20000),yp(20000),zp(20000),xm(100),ym(100),zm(100)
      integer::imco(30)
      character(50)::str
      character(500)::str1
      
      call getarg(1,pdbf)
      call getarg(2,metcores)
      call getarg(3,metrasview)

      open (unit=1,file=pdbf,status='old')
      open (unit=67,file=metcores,status='new')
      open (unit=68,file=metrasview,status='new')

      ic1 = 0
      ic2 = 0

9     read(1,34,end=30)atag,atype,rtype,chn,irn,xn,yn,zn
!      write(872,34)atag,atype,rtype,chn,irn,xn,yn,zn
          if (atag.eq.'ATOM')then
              if (atype(1:1).ne.'H')then
              ic1 = ic1 + 1
              patom(ic1) = atype
              pres(ic1) = rtype
              ipres(ic1) = irn
              pchain(ic1) = chn
              xp(ic1) = xn
              yp(ic1) = yn
              zp(ic1) = zn
              endif
           elseif(atag.eq.'HETA')then
           ic2 = ic2 + 1
           matom(ic2) = atype
           mres(ic2) = rtype
           imres(ic2) = irn
           mchain(ic2) = chn
           xm(ic2) = xn
           ym(ic2) = yn
           zm(ic2) = zn
           endif
       goto 9
30     continue

34     format(a4,9x,a3,1x,a3,1x,a1,i4,4x,3f8.3)

       print*,ic1,ic2

!       do i=1,ic1
!       write(872,819)patom(i),pres(i),ipres(i),pchain(i)
!       enddo

!       write(872,*)
!       write(872,*)
!       write(872,*)

!================================================
!      CONTACNT CUTOFF 4 Angstrom
!================================================

819    format(a4,1x,a3,1x,i4,1x,a1,3f8.3)
919    format(a4,1x,a3,1x,i4,1x,a1,3f8.3,2x,f10.3)

       ir1 = ipres(1)
       irl = ipres(ic1)
       Nco = 0

       do j = 1,ic2             ! On Metal ions
!       write(873,819)matom(j),mres(j),imres(j),mchain(j),
     &xm(j),ym(j),zm(j)
          do k = ir1,irl        ! On residues
          ik = 0
             do i = 1,ic1       ! On protein atoms
               if (k==ipres(i))then
               ik = ik + 1
               patom1(ik) = patom(i)
               pch(ik) = pchain(i)
               prs(ik) = pres(i)
               xp1(ik) = xp(i)
               yp1(ik) = yp(i)
               zp1(ik) = zp(i)
               endif
             enddo
       ircon = 0
!============= Howmany atoms of the iith residue does a metal coordinate to =============
             do ii = 1,ik          
             dist = sqrt((xp1(ii)-xm(j))**2 + (yp1(ii)-ym(j))**2 + 
     &(zp1(ii)-zm(j))**2)
                if (dist <= 4.0)then
!                write(874,919)patom1(ii),prs(ii),k,pch(ii),
!     &xp1(ii),yp1(ii),zp1(ii),dist
                ircon = ircon + 1
                imco(ircon) = imres(j)
                mco(ircon) = mres(j)
                mch(ircon) = mchain(j)
                endif
             enddo             
             if (ircon >= 1)then
             Nco = Nco + 1
            write(67,57)imco(ircon),'-',mco(ircon),'-',mch(ircon),
     &'<=>',k,'-',prs(ircon),'-',pch(ircon),ircon
             pch1(Nco) = pch(ircon)
             iprs1(Nco) = k
!             print*,iprs1(Nco),pch1(Nco)
             endif
          enddo
       enddo

!       print*,Nco

!       do i=1,Nco
!       print*,pch1(i)
!       enddo


       str1 = 'select '
       do i = 1,Nco
            if (i < Nco)then
            write(str,89) ':',pch1(i),'&&',iprs1(i),','
            elseif (i == Nco)then
            write(str,189) ':',pch1(i),'&&',iprs1(i)
            endif
!       print*,'----',str
       str1 = adjustl(trim(str1))//str
       enddo

       ils = LEN_TRIM(pdbf)
       ils2 = LEN_TRIM(str1)

       if (ils < 15)then
       write(68,92)'load ',adjustl(trim(pdbf))
       elseif (ils >= 15)then
       write(68,192)'load ',adjustl(trim(pdbf))
       endif

       
       write(68,93)'wireframe off'
       write(68,95)'ribbon'
       write(68,96)'color chain'
       write(68,93)'select hetero'
       write(68,97)'spacefill'
       write(68,*)'color yellow'

       if (ils2 < 100)then
       write(68,94)adjustl(str1)
       elseif (ils2 >= 100 .and. ils2 < 200)then
       write(68,194)adjustl(str1)
       elseif (ils2 >= 200 .and. ils2 < 300)then
       write(68,294)adjustl(str1)
       elseif (ils2 >= 300 .and. ils2 < 400)then
       write(68,394)adjustl(str1)
       elseif (ils2 >= 400 .and. ils2 < 500)then
       write(68,494)adjustl(str1)
       endif

       write(68,93)'wireframe 100'
       write(68,97)'color cpk'
       write(68,*)

92     format(a5,a15)
192    format(a5,a30)
93     format(a13)
94     format(a100)
194    format(a200)
294    format(a300)
394    format(a400)
494    format(a500)
95     format(a6)
96     format(a11)
97     format(a9)

89     format(1x,a1,a1,1x,a2,1x,i3,a1)
189    format(1x,a1,a1,1x,a2,1x,i3)
57     format(i4,a1,a3,a1,a1,1x,a3,1x,i4,a1,a3,a1,a1,2x,i5)


      endprogram metcoord






