#!/usr/bin/perl

$pdb=$ARGV[0] || die "Enter pdb\n";
$chain=$ARGV[1] || die "Enter chain\n";
chomp $pdb;
chomp $chain;

open (INP,"<$pdb");
@dat=<INP>;

foreach $a (@dat)
{
chomp $a;
	if (substr($a,21,1) eq $chain)
	{
	print $a,"\n";
	}
}


