#!/usr/bin/perl

$file=$ARGV[0] || die "Enter PDB file name: e.g., <basename>.pdb (Then, <basename>.res file should be present)\n";	# pdb
chomp $file;

$path=$ARGV[1] || die "Enter full-path of working directory\n";
chomp $path;

# Set default 
$tag=0;

open (INP,"<$file");
@dat=<INP>;
@coords=grep(/^ATOM\s+/,@dat);

$resf=$file;
$resf=~s/\.pdb/\.res/g;

open (OUT,">$path/outhisO.pdb");

open (RES,"<$resf") || die "$resf file not found at $path\n";

@rdat=<RES>;

$cnt=0;
foreach $k (@rdat)
{
chomp $k;
	if ($k=~/HIS/)
	{
	print $k,"\n";
	@store=();
	@atom=();
	@pointer=();
	$d=0;
	$e=0;
	$c=0;
	$cnt++;
		foreach $p (@coords)
		{
		chomp $p;
			if ((substr($p,17,3) eq 'HIS') && (int(substr($p,22,4))==int(substr($k,0,4))) && (substr($p,21,1) eq substr($k,9,1)))
			{
			@store=(@store,$p);
			$at=substr($p,13,3);
			@atom=(@atom,$at);
			@pointer=(@pointer,$c);
			#	print "$p      $at\n";
			}
		$c++;
		}
		foreach (@atom)
		{
			if ($_ eq 'HD1')
			{
			$d=1;
			}
			if ($_ eq 'HE2')
			{
			$e=1;
			}
		}
		if ($d==1 && $e==0)
		{
			foreach $r (@store)
			{
			$r=~s/HIS/HID/;
			}
		}
		if ($d==0 && $e==1)
		{
			foreach $r (@store)
			{
			$r=~s/HIS/HIE/;
			}
		}
		if ($d==1 && $e==1)
		{
			foreach $r (@store)
			{
			$r=~s/HIS/HIP/;
			}
		}
		for $n (0..scalar(@pointer)-1)
		{
		$dat[$pointer[$n]]=$store[$n];
		}
	}	
}

foreach $k (@dat)
{
chomp $k;
$str1=substr($k,0,12);
$str2=substr($k,13, );
#print $str1,' ',$str2,"\n";
print OUT $str1,' ',$str2,"\n";
}

close OUT;

print "$cnt HIS renamed to HID/HIE/HIP in outfile:  $path/outhisO.pdb\n";

