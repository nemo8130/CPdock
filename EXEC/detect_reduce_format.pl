#!/usr/bin/perl

if (scalar(@ARGV) == 0)
{
    die "Enter PDB file\n";
}

while (<>)
{
    chomp $_;
    if (substr($_,12,1) eq "H")
    {
	$nat=substr($_,15,1).substr($_,12,3);
    print $_,"\n";
#	print $nat,"\n";
#	print substr($_,0,12).$nat.substr($_,16, ),"\n";
    }
	elsif (substr($_,13,1) eq "H" && substr($_,15,1) =~ /\d/)
	{
#	print $_,"\n";
	}
    else
    {
#	print $_,"\n";
    }
}
