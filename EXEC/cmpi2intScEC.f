      program compplot_interpolate

!=====================================================
!   Linear Interpolation between voxels to score Pgrid
!   for a given distribution of points
!   For the Complementarity Plot corresponding to the 
!   protein-protein interface (scoring interfaces: not residues)
!=====================================================

      character(80)::ifile,libfile
      real::lprob,iprob
      character(15)::flag,flagt
      real::Smt(925),Emt(925),bur(925)
      integer::ires(925)
      character(3)::res(925)
      real::Pgrid(40,40),Em(40),Sm(40),Scen(40),Ecen(40)
      character(5)::Pi,Pij
      real::meanlod

      call getarg(1,ifile)

      libfile = 'DB3_single-diel-SE.Pgrid'

      open(1,file=ifile,status='old')
      open(2,file=libfile,status='old')
    
      read(2,67)
67    format(/)
716   format(f5.3)

      do j = 1,40           ! for Em
           do i = 1,40              ! for Sm
           read(2,56,end=10)Em(j),Sm(i),Pgrid(i,j)
           write(Pi,716)Pgrid(i,j)
           read(Pi,716)Pgrid(i,j)
           Scen(i) = (Sm(i) + (Sm(i)+0.05))/2
           Ecen(j) = (Em(j) + (Em(j)+0.05))/2
!           write(*,453)i,j,Sm(i),Em(j),Scen(i),Ecen(j),Pgrid(i,j)
           enddo
      enddo

10    continue

      write(534,454)'#i','j','Sm','Em','Scen','Ecen','Pgrid'
!      write(534,*)
454   format(2(a2,2x),4(a6,2x),2x,a6)

      do i = 1,40
           do j = 1,40
           write(534,453)i,j,Sm(i),Em(j),Scen(i),Ecen(j),Pgrid(i,j)
           enddo
      enddo

453   format(2(i2,2x),4(f6.3,2x),2x,f6.3)
56    format(f6.3,10x,f6.3,20x,f10.8)

!======================================================

      iprb = 0
      ilprb = 0
      imprb = 0
      sumlod = 0.00

      iNZ = 0
      impZ = 0

      itot = 0
      do i = 1,925
      read(1,45,end=40)Smt(i),Emt(i)
!      write(*,45)Smt(i),Emt(i)
      itot = itot + 1

      Smt1 = Smt(i)
      Emt1 = Emt(i)

!==================================================================================
!     RESET VALUES FALLING INTO THE "LEFT-BOTTOM / RIGHT-BOTTOM / LEFT-TOP / RIGHT-TOP CORNER"
!     DON'T LEAVE THEM UNDEFINED
!==================================================================================

      if (Smt1 > 0.95)then
          Smt1 = 0.95
      endif
      if (Emt1 > 0.95)then
          Emt1 = 0.95
      endif

      if (Smt1 > 0.95)then
          Smt1 = 0.95
      endif
      if (Emt1 > 0.95)then
          Emt1 = 0.95
      endif
!==================================================================================
!==================================================================================



!      print*,Smt1,Emt1

!      write(*,819)'Enter Sm'
!      read(*,781)Smt1
!      write(*,819)'Enter Em'
!      read(*,781)Emt1

819   format(a10)
781   format(f6.3)

      Sml_t = 0.00
      Smu_t = 0.00
      Eml_t = 0.00
      Emu_t = 0.00
  

      do ii = 1,40
            do jj = 1,40
            Sml = Scen(ii)
            Smu = Scen(ii)+0.05
            Eml = Ecen(jj)
            Emu = Ecen(jj)+0.05
!==================================== Original Pgrid ====================
                if (Smt1 <= Sm(ii+1) .and. Smt1 >= Sm(ii) .and.
     &Emt1 <= Em(jj+1) .and. Emt1 >= Em(jj))then 
                ip = ii
                jp = jj
                Porg = Pgrid(ii,jj)
                endif
!=================================== w.r.t. grid centers ===============

                if (Smt1 <= Smu .and. Smt1 >= Sml .and. 
     &Emt1 <= Emu .and. Emt1 >= Eml)then
                Sml_t = Sml
                Smu_t = Smu
                Eml_t = Eml
                Emu_t = Emu
                i1 = ii
                i2 = ii+1
                j1 = jj
                j2 = jj+1
                endif
            enddo
      enddo

!      write(*,821)Smt1,Emt1
!      write(*,*)
!      write(*,821)Sml_t,Smu_t
!      write(*,821)Eml_t,Emu_t
!      write(*,821)Smu_t,Eml_t
!      write(*,821)Smu_t,Emu_t

821   format(2(f6.3,2x))
822   format(2(i2,2x))

!============ TEST GRID ====================

      x = Smt1
      y = Emt1
      
!=========== 2X2 NEAREST NEGHBORING GRIDs ====

      x1 = Sml_t
      x2 = Smu_t
      y1 = Eml_t
      y2 = Emu_t

!      write(*,456)x1,x2,y1,y2,x,y

!      write(*,501)i1,j1,x1,y1
!      write(*,501)i1,j2,x1,y2
!      write(*,501)i2,j1,x2,y1
!      write(*,501)i2,j2,x2,y2

501   format(2(i2,2x),2x,2(f6.3,2x))
456   format(6(f6.3,2x))

!=========== Pgrid assignment by linear interpolation ===========

!      Pgrid_ij = (Pgrid(i1,j1)*(i2-i)*(j2-j)/((i2-i1)*(j2-j1))) + 
!     &(Pgrid(i2,j1)*(i-i1)*(j2-j)/((i2-i1)*(j2-j1))) +
!     &(Pgrid(i1,j2)*(i2-i)*(j-j1)/((i2-i1)*(j2-j1))) +
!     &(Pgrid(i2,j2)*(i-i1)*(j-j1)/((i2-i1)*(j2-j1)))

      Pgrid_ij2 = (Pgrid(i1,j1)*(x2-x)*(y2-y)/((x2-x1)*(y2-y1))) + 
     &(Pgrid(i2,j1)*(x-x1)*(y2-y)/((x2-x1)*(y2-y1))) +
     &(Pgrid(i1,j2)*(x2-x)*(y-y1)/((x2-x1)*(y2-y1))) +
     &(Pgrid(i2,j2)*(x-x1)*(y-y1)/((x2-x1)*(y2-y1)))

      write(Pij,716)Pgrid_ij2
      read(Pij,716)Pgrid_ij2

      if (Pgrid_ij2 >= 0.005)then
      flagt = 'probable'
      iprb = iprb + 1
      elseif (Pgrid_ij2 < 0.005 .and. Pgrid_ij2 >= 0.002)then
      flagt = 'less probable'
      ilprb = ilprb + 1
      elseif (Pgrid_ij2 < 0.002)then
      flagt = 'improbable'
      imprb = imprb + 1
      endif


      if (Pgrid_ij2 > 0.000)then
      Rlod = ((log(Pgrid_ij2)/log(10.0)))
!     write(*,615)Pgrid_ij2,Rlod
      sumlod = sumlod + Rlod
      iNZ = iNZ + 1
      elseif (Pgrid_ij2 == 0.000)then
      impZ = impZ + 1
      endif

      write(167,46)Smt1,Emt1,Pgrid_ij2,flagt

      enddo

40    continue

      if (iNZ==0)then
      meanlod = 0.000
      goto 718
      endif

      meanlod = sumlod/float(iNZ)

718   continue

      write(89,564)meanlod,impZ,itot
564   format(f10.5,2x,i3,2x,i3)

!      write(*,666)iprb,ilprb,imprb,iNZ,impZ
666   format(5(i3,2x))

      score = ((iprb*3.0) + (ilprb*1.0) + (imprb*(-5.0)))/itot

      write(650,891)score
891   format(f8.4)


78    format(i2,2x,i2,2x,f6.3,2x,f6.3,2x,f5.3,2x,f5.3,2x,a13)
46    format(15x,f6.3,2x,f6.3,2x,f5.3,2x,a15)
81    format(4(f10.8,2x))
45    format(15x,f8.3,f8.3)


      endprogram compplot_interpolate
