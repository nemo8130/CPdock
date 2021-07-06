#!/bin/bash 

EXE_PATH=`echo ${0/\/EXEC\/naccess.bash/}`
echo "EXE_PATH="$EXE_PATH
#exit;
PDBFILE=$1
VDWFILE="$EXE_PATH/LIBR/vdw.radii"
ls $VDWFILE
probe=1.40
STDFILE="$EXE_PATH/LIBR/standard.data"
ls $STDFILE
zslice=0.05
#
echo $PDBFILE
echo "PDBFILE $PDBFILE" > $EXE_PATH/accall.input.$$
echo "VDWFILE $VDWFILE" >> $EXE_PATH/accall.input.$$
echo "STDFILE $STDFILE" >> $EXE_PATH/accall.input.$$
echo "PROBE $probe"     >> $EXE_PATH/accall.input.$$
echo "ZSLICE $zslice"   >> $EXE_PATH/accall.input.$$

#if ( $hets ) thena
#  echo "HETATOMS"       >> accall.input.$$
#endif
#if ( $wats ) then
#  echo "WATERS"         >> accall.input.$$
#endif
#if ( $hyds ) then
#  echo "HYDROGENS"      >> accall.input.$$
#endif
#if ( $full ) then
#   echo "FULL"          >> accall.input.$$
#endif
#if ( $asao ) then
#   echo "ASAONLY"       >> accall.input.$$
#endif
#if ( $cont ) then
#   echo "CONTACT"       >> accall.input.$$
#endif
#if ( $oldr ) then
#   echo "OLDRSA"        >> accall.input.$$
#endif
#if ( $nbac ) then
#   echo "CSIDE"         >> accall.input.$$
#endif
#

# run accessibility calculations
#
echo "$EXE_PATH/EXEC/accall.exe < $EXE_PATH/accall.input.$$"
$EXE_PATH/EXEC/accall.exe < $EXE_PATH/accall.input.$$
#
# delete temporary input file
#
cat $EXE_PATH/accall.input.$$ 
\rm $EXE_PATH/accall.input.$$ 
#naccess_end
