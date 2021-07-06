#!/usr/bin/perl

$pathfn=$ARGV[0] || die "Enter full-path of the chfn.inp file: \$path/chfn.inp\n";
chomp $pathfn;
open (INP,"<$pathfn") || die "$pathfn not found\n";
$fn=<INP>;
chomp $fn;

#print $fn,"\n";

$f1 = 0;

if ($fn =~ m/.pdb/)
{
$f1 = 1;
}

$f2 = 1;

if ($fn =~ m/.PDB/)
{
$f2 = 0;
}

@h = split(//,$fn);

$cntdot = 0;

foreach (@h)
{
	if ($_ eq ".")
	{
	$cntdot++;
	}
}

$f3 = 0;

if ($cntdot == 1)
{
$f3 = 1;
}

#print "$f1  $f2 $f3\n";

if ($f1 == 1 && $f2 == 1 && $f3 == 1)
{
print "OK\n";
}
