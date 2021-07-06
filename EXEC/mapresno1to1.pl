#!/usr/bin/perl

$fn = $ARGV[0] || die "Enter PDB with full-path: \$path\$pdb";		# $code.pdb
chomp $fn;

$path=$ARGV[1] || die "Enter full-path of working directory\n";
chomp $path;

open (INP, "<$fn");
@dat = <INP>;

open (RES1,">$path/res1.out");

@atoms = grep(/^ATOM/ || /^HETATM/,@dat);

$l = @atoms;

$rn1 = int(substr($atoms[0],23,3));

printf RES1 "%3d\n",$rn1;

close RES1;

for $i (0..$l-1)
{
chomp $atoms[$i];
$fp = substr($atoms[$i],0,22);
$rn = int(substr($atoms[$i],22,4));
$sp = substr($atoms[$i],26, );
$rn = $rn - ($rn1-1);
printf "%22s%4d%28s\n",$fp,$rn,$sp;
}
