#!/usr/bin/perl

# MAKE TWO MODIFIED PDB FILES CONTAINING DUMMY ATOMS FROM ONE CHAIN AND REAL ATOMS FROM THE OTHER FOR EC CALCULATIONS 
# feed in the two input files already containing N and C terminal residues and HIS and CYS residues renamed accordingly 

$file1 = $ARGV[0] || die "Enter \$path/inp1m.pdb\n";
chomp $file1;

$file2 = $ARGV[1] || die "Enter \$path/inp1m.pdb\n";
chomp $file2;

$path=$ARGV[2] || die "Enter full-path of working directory\n";
chomp $path;

open (INP1,"<$file1");
@rdat1 = <INP1>;

open (INP2,"<$file2");
@rdat2 = <INP2>;

@aa3real = ('GLY','ALA','VAL','LEU','ILE','PHE','TYR','TRP','SER','THR','CYS','CYX','MET','ASP','GLU','ASN','GLN','LYS','ARG','PRO','HID','HIE','HIP');
@aa3dummy = ('GDD','ADD','VDD','LDD','IDD','FDD','YDD','WDD','SDD','TDD','CSD','CXD','MDD','DDD','EDD','NDD','QDD','KDD','RDD','PDD','HDD','HED','HPD');

open (OUT1,">$path/real1dum2.pdb");
open (OUT2,">$path/real2dum1.pdb");

@ddat1 = @rdat1;
@ddat2 = @rdat2;

#===================================== REAL1 ============================================

foreach $a (@rdat1)
{
chomp $a;
print OUT1 $a,"\n";
}

#========================================================================================
#==================================== DUM2 ==============================================

foreach $a (@ddat2)
{
chomp $a;
$res = substr($a,17,3);
	for $b (0..scalar(@aa3real)-1)
	{
		if ($res eq $aa3real[$b])
		{
		$a =~ s/$aa3real[$b]/$aa3dummy[$b]/;
		}
	}
print OUT1 $a,"\n";
}

#========================================================================================
#================================== DUM1 ================================================

foreach $a (@ddat1)
{
chomp $a;
$res = substr($a,17,3);
	for $b (0..scalar(@aa3real)-1)
	{
		if ($res eq $aa3real[$b])
		{
		$a =~ s/$aa3real[$b]/$aa3dummy[$b]/;
		}
	}
print OUT2 $a,"\n";
}

#=========================================================================================
##=============================== REAL2 ==================================================

foreach $a (@rdat2)
{
chomp $a;
print OUT2 $a,"\n";
}


#=========================================================================================
#=========================================================================================
#=========================================================================================
#=========================================================================================
#=========================================================================================



