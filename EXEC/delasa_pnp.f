      program delasa

      character(80)::ifile1,ifile2,ifile3,path,out1,out2,out3

      integer::ires1(50000),ires2(50000),ires3(50000)
      character(1)::chain1(50000),chain2(50000),chain3(50000)
      character(3)::res1(50000),res2(50000),res3(50000)
      character(3)::atom1(50000),atom2(50000),atom3(50000)
      real::asa1(50000),asa2(50000),asa12(50000)

      integer::ires_int1(50000),ires_int2(50000)
      character(3)::atom_int1(50000),atom_int2(50000)
      character(3)::res_int1(50000),res_int2(50000)
      character(1)::chain_int1(50000),chain_int2(50000)
      real::dls1(50000),dls2(50000)
      real::dls1np(50000),dls1p(50000)
      real::dls2np(50000),dls2p(50000)
      real::nBSA,nBSAp,nBSAnp

      call getarg(1,ifile1)
      call getarg(2,ifile2)
      call getarg(3,ifile3)
      call getarg(4,path)

      out1=adjustl(trim(path))//'/fort.14'
      out2=adjustl(trim(path))//'/fort.15'
      out3=adjustl(trim(path))//'/fort.16'

      write(*,813)out1
      write(*,813)out2
      write(*,813)out3

813   format(a80)      

!      goto 999

      open(1,file=ifile1,status='old')
      open(2,file=ifile2,status='old')
      open(3,file=ifile3,status='old')
      open(14,file=out1)
      open(15,file=out2)
      open(16,file=out3)

!     print*,ifile1
!     print*,ifile2
!     print*,ifile3


      ic1 = 0
      do i = 1,50000
      read(1,34,end=10)atom1(i),res1(i),chain1(i),ires1(i),asa1(i)
      ic1 = ic1 + 1
      enddo

10    continue

      ic2 = 0
      do i = 1,50000
      read(2,34,end=20)atom2(i),res2(i),chain2(i),ires2(i),asa2(i)
      ic2 = ic2 + 1
      enddo

20    continue

      sumasa12=0.00
      sumasa12p=0.00
      sumasa12np=0.00
      ic3 = 0
      do i = 1,50000
      read(3,34,end=30)atom3(i),res3(i),chain3(i),ires3(i),asa12(i)
      ic3 = ic3 + 1
      sumasa12=sumasa12+asa12(i)
          if ((atom3(i)(1:1).eq.'O').or.
     &(atom3(i)(1:1).eq.'N'))then
            sumasa12p=sumasa12p+asa12(i)
          else
            sumasa12np=sumasa12np+asa12(i)
          endif
      enddo

30    continue

34    format(13x,a3,1x,a3,1x,a1,1x,i3,28x,f8.3)

!      print*,ic1,ic2,ic3

      int1 = 0

      do i = 1,ic1
           do j = 1,ic3
                if ((atom1(i).eq.atom3(j)).and.(ires1(i)==ires3(j)).and.
     &(res1(i).eq.res3(j)).and.(chain1(i).eq.chain3(j)))then
                 dbsa = abs(asa1(i)-asa12(j))
                      if (dbsa > 0.00)then
                      int1 = int1 + 1
                      atom_int1(int1) = atom1(i)
                      res_int1(int1) = res1(i)
                      ires_int1(int1) = ires1(i)
                      chain_int1(int1) = chain1(i)
                      dls1(int1) = dbsa
!                     print*,dls1(int1)
                         if ((atom1(i)(1:1).eq.'O').or.
     &(atom1(i)(1:1).eq.'N'))then
                         dls1p(int1) = dbsa
                         else
                         dls1np(int1) = dbsa
                         endif
                      endif 
                endif
           enddo
      enddo

      int2 = 0

      do i = 1,ic2
           do j = 1,ic3
                if ((atom2(i).eq.atom3(j)).and.(ires2(i)==ires3(j)).and.
     &(res2(i).eq.res3(j)).and.(chain2(i).eq.chain3(j)))then
                 dbsa = abs(asa2(i)-asa12(j))
                      if (dbsa > 0.00)then
                      int2 = int2 + 1
                      atom_int2(int2) = atom2(i)
                      res_int2(int2) = res2(i)
                      ires_int2(int2) = ires2(i)
                      chain_int2(int2) = chain2(i)
                      dls2(int2) = dbsa
!                     print*,dls2(int2)
                         if ((atom2(i)(1:1).eq.'O').or.
     &(atom2(i)(1:1).eq.'N'))then
                         dls2p(int2) = dbsa
                         else
                         dls2np(int2) = dbsa
                         endif
                      endif 
                endif
           enddo
      enddo

      int_tot = int1 + int2


!      print*,int1,int2

      write(14,67)

      sumbsa1 = 0.000 
      sumbsa1p = 0.000 
      sumbsa1np = 0.000 
      sumbsa2 = 0.000 
      sumbsa2p = 0.000 
      sumbsa2np = 0.000 

      do i = 1,int1
      write(14,56)atom_int1(i),res_int1(i),ires_int1(i),chain_int1(i),
     &dls1(i),dls1np(i),dls1p(i)
      sumbsa1 = sumbsa1 + dls1(i)
      sumbsa1p = sumbsa1p + dls1p(i)
      sumbsa1np = sumbsa1np + dls1np(i)
      enddo

      write(15,68)
               
      do i = 1,int2
      write(15,56)atom_int2(i),res_int2(i),ires_int2(i),chain_int2(i),
     &dls2(i),dls2np(i),dls2p(i)
      sumbsa2 = sumbsa2 + dls2(i)
      sumbsa2p = sumbsa2p + dls2p(i)
      sumbsa2np = sumbsa2np + dls2np(i)
      enddo

      print*,"SUM(BSA)(M1)=",sumbsa1,sumbsa1p,sumbsa1np
      print*,"SUM(BSA)(M2)=",sumbsa2,sumbsa2p,sumbsa2np

      bsa12=(sumbsa1+sumbsa2)
      bsa12p=(sumbsa1p+sumbsa2p)
      bsa12np=(sumbsa1np+sumbsa2np)

      print*,"BSA=",bsa12,bsa12p,bsa12np
      print*,"sum(ASA12)=",sumasa12,sumasa12p,sumasa12np

      nBSA=bsa12/sumasa12
      nBSAp=bsa12p/sumasa12p
      nBSAnp=bsa12np/sumasa12np

      write(*,281)"nBSA=",nBSA,nBSAp,nBSAnp
281   format(a10,3(2x,f10.3))      

      write(*,192)bsa12,sumasa12,nBSA,nBSAnp,nBSAp
192   format(1x,f12.3,5x,f12.3,5x,f12.5,5x,f12.5,5x,f12.5,5x,f12.5)     

      write(16,134)'|sum(∆ASA)~|','|ASAcomplex|','|nBSA------|',
     &'|nBSAp-----|','|nBSAnp----|'
      write(16,192)bsa12,sumasa12,nBSA,nBSAp,nBSAnp

      write(*,*)'------------------------------------------------------'
      write(*,*)'------------------------------------------------------'
      write(*,134)'|sum(∆ASA)~|','|ASAcomplex|','|nBSA------|',
     &'|nBSAp-----|','|nBSAnp----|'
      write(*,192)bsa12,sumasa12,nBSA,nBSAp,nBSAnp
      write(*,*)'------------------------------------------------------'
      write(*,*)'------------------------------------------------------'

134   format(5(a15,2x))

      write(*,812)int_tot,sumbsa1,sumbsa2,bsa12
812   format(i6,2x,f10.3,2x,f10.3,2x,f10.3)

56    format(a3,2x,a3,2x,i3,2x,a1,2x,f9.4,2x,f9.3,2x,f9.3)
67    format('# INTERFACE 1 OF THE COMPLEX')
68    format('# INTERFACE 2 OF THE COMPLEX')

999   continue      

      endprogram delasa
