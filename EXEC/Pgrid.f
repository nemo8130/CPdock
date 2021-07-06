      program Pgrid

!==============================
! This is the correct program 
! 1600 square grids
!==============================


!==============================================================================
! Estimate Pgrid (Probability of a given residue type to occupy a square-grid
! of width 0.05 X 0.05 in the Complementarity Plot)
!==============================================================================

      character(80)::ifile
      real::Sm(50000),Em(50000)
      real::lcoS,lcoE,Pgr(50,50)
      integer::ifreq(50,50)

      call getarg(1,ifile)   ! e.g., ALA1.rSE   DB3_1792_nonblankint.SE etc.    (   0.574    0.445)

      open (unit=1,file=ifile,status='old')

      ic = 0

      do i = 1,50000
      read(1,34,end=30)Sm(i),Em(i)
      ic = ic + 1
      enddo

30    continue
34    format(f8.3,1x,f8.3)
!34    format(f6.3,3x,f6.3)

!===============================================================
! Create the square-grids
!===============================================================    
     
      k1 = 0
      k2 = 0
 
      do de = -1.0,0.95,0.05
      k1 = k1 + 1
      k2 = 0
      lcoE = de
      ucoE = de + 0.05
             do ds = -1.0,0.95,0.05
             k2 = k2 + 1
             lcoS = ds 
             ucoS = ds + 0.05
             ifreq(k1,k2) = 0
!=============================== Terminal grids along X ========
                  if (k1 == 1)then
                    do i = 1,ic
                       if (Sm(i)>=lcoS.and.Sm(i)<=ucoS.and.
     &Em(i)>=lcoE.and.Em(i)<=ucoE)then
                       ifreq(k1,k2) = ifreq(k1,k2) + 1
                       print*,'terminal grid X occupied'
                       endif
                    enddo
                  endif
!=============================== Terminal grids along Y ========
                  if (k2 == 1)then
                    do i = 1,ic
                       if (Sm(i)>=lcoS.and.Sm(i)<=ucoS.and.
     &Em(i)>=lcoE.and.Em(i)<=ucoE)then
                       ifreq(k1,k2) = ifreq(k1,k2) + 1
                       print*,'terminal grid Y occupied'
                       endif
                    enddo
                  endif
!========================== Internal grids ========
                  if (k1 /= 1 .and. k2 /= 1)then
                    do i = 1,ic
                       if (Sm(i)>lcoS.and.Sm(i)<=ucoS.and.
     &Em(i)>lcoE.and.Em(i)<=ucoE)then
                       ifreq(k1,k2) = ifreq(k1,k2) + 1
                       endif
                    enddo
                  endif
             Pgr(k1,k2) = float(ifreq(k1,k2))/float(ic)
             write(2,45)lcoE,ucoE,lcoS,ucoS,ifreq(k1,k2),Pgr(k1,k2)
             enddo
      enddo

45    format(4(f6.3,2x),3x,i5,1x,f11.8)
      

      endprogram Pgrid
