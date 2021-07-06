#!/usr/bin/perl
#

$pdb=$ARGV[0] || die "Enter the PDB\n";
chomp $pdb;

$resfile=$pdb;
$resfile=~s/\.pdb/\.res/;
open (OUT,">$resfile");

open (INP,"<$pdb");
@dat=<INP>;
close INP;

$flag=0;

for $i (0..scalar(@dat)-1)
{
	chomp $dat[$i];
	if ($dat[$i] =~ m/^MODEL\s+/)
	{
		$start=$i;
		$flag=1;
		last;
	}
}

#print "$flag\n";

if ($flag==1)
{
	$flag2=0;
	for $i (($start+1)..scalar(@dat)-1)
	{
		chomp $dat[$i];
		if ($dat[$i] =~ m/^ENDMDL\s+/ || $dat[$i] =~ m/^MODEL\s+/)
		{
			#print $dat[$i],"\n";
			$stop=$i;
			$flag2=1;
			last;
		}
	}

	if ($flag2==0)
	{
		for $i ($start..scalar(@dat)-1)
		{
			chomp $dat[$i];
			if ($dat[$i] =~ m/^END/ || $dat[$i] =~ m/^TER/)
			{
				$stop=$i;
				last;
			}
		}		
	}

	print "$start $stop\n";

	@model1=();

	for $i ($start..$stop)
	{
		@model1=(@model1,$dat[$i]);
	}

print scalar(@model1),"\n";
@atoms=grep(/^ATOM\s+/,@model1);
}
else
{
#print "Am I here with flag/=1\n";
@atoms=grep(/^ATOM\s+/,@dat);
}

@ca=grep(/ CA /,@atoms);

print "CA: ",scalar(@ca),"\n";

%h=();

foreach $a (@ca)
{
	chomp $a;
	$chain=substr($a,21,1);
	$h{$chain}++;
}

@chU=sort keys %h;

print "Number of chains: ",scalar(@chU),"\n";

for $i (0..scalar(@chU)-1)
{
	print "Chain-",$chU[$i],"\n";
	@resid_chain=();
	@resid_chainS=();
	foreach $a (@ca)
	{
	chomp $a;
	$res=substr($a,17,3);
	$chain=substr($a,21,1);
	$ires=int(substr($a,22,4));
	$rescom=$ires.'-'.$res.'-'.$chain;
		if ($chU[$i] eq $chain)
		{
			if (substr($a,16,1) eq " " || substr($a,16,1) eq "A")		# Taking care of multiple occupancy
			{
				@resid_chain=(@resid_chain,$rescom);
			}
		}
	}
	@resid_chainS=sort {$a<=>$b} (@resid_chain);
	foreach $r (@resid_chainS)
	{
		printf OUT "%10s\n",$r;
	}
}

close OUT;


