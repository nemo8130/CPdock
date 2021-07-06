#!/usr/bin/perl

# runs at $tag == 0 (from his2hiped.pl)

# for dsl.out (sankar)

$path=$ARGV[0] || die "Enter full-path of working directory\n";
chomp $path;

open (INP,"<$path/inp.dsl");
@dat = <INP>;

$l = @dat;
#print $l,"\n";

@cys = ();

for $i (0..$l-1)
{
chomp $dat[$i];
	if (substr($dat[$i],7,3) eq 'CYS')
	{
	@cys = (@cys,int(substr($dat[$i],1,4)).'-'.substr($dat[$i],16,1));
	}
	if (substr($dat[$i],27,3) eq 'CYS')
	{
	@cys = (@cys,int(substr($dat[$i],21,4)).'-'.substr($dat[$i],36,1));
	}
}

$l1 = @cys;

print $l1,"\n";

%unq = ();

foreach $k (@cys)
{
$unq{$k}++;
}

@ucys = sort {$a <=> $b} keys %unq;

foreach $k (@ucys)
{
printf "%6s\n",$k;
}

$l2 = @ucys;

@rnn = ();

open (HISF,"<$path/outhisO.pdb");
open (OUTCYS,">$path/outhiscysO.pdb");

@pdat = <HISF>;

$cnt = 0;

foreach $p (@pdat)
{
chomp $p;
$rn=int(substr($p,22,4));
$rt=substr($p,17,3);
$ch=substr($p,21,1);
	foreach $c (@ucys)
	{
		@arr=split(/\-/,$c);
		if ($rn==$arr[0] && $ch eq $arr[1] && $rt eq 'CYS')
		{
		$p =~ s/CYS/CYX/;
		@rnn = (@rnn,$rn);
		}
	}
$str1 = substr($p,0,12);
$str2 = substr($p,13, );
print OUTCYS $str1,' ',$str2,"\n";
$cnt++;
}

print "\n\nNumber of lines in the outfile : $cnt\n\n";


%h = ();

foreach (@rnn)
{
$h{$_}++;
}

@uc = keys %h;
$luc = @uc;

print "\n\n$luc CYS-> CYX conversions made; OUTFILE: $path/outhiscysO.pdb \n\n";


