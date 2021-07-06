#!/bin/bash

path=$1
pdb=$2

if [ "$#" -lt "2" ]; then
	echo "Enter \$path & $\path\$pdb (full-path) as arg-1 & arg-2"
exit
fi

ch1=`grep "^ATOM" $pdb | head -1 | cut -c21-22`
ch2=`grep "^ATOM" $pdb | tail -n 1 | cut -c21-22`

pdbtag=`echo ${pdb/.pdb}`
echo $pdbtag

pdb1=`echo $pdbtag`_`echo $ch1`.pdb
pdb2=`echo $pdbtag`_`echo $ch2`.pdb

echo $pdb1 $pdb2

$path/EXEC/chext.pl $pdb $ch1 > $pdb1
$path/EXEC/chext.pl $pdb $ch2 > $pdb2

$path/EXEC/renumber_pdb.pl $pdb1 
$path/EXEC/renumber_pdb.pl $pdb2 

cat $pdb1.renum $pdb2.renum > $pdb
rm $pdb1
rm $pdb2
rm $pdb1.renum
rm $pdb2.renum


