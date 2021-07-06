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
#    print $_,"\n";
#	print $nat,"\n";
	print substr($_,0,12).$nat.substr($_,16, ),"\n";
    }
	elsif (substr($_,13,1) eq "H")
	{ 
		if (substr($_,13,3) eq "H  " || substr($_,13,2) eq "HA" || substr($_,13,2) eq "HB" || substr($_,13,2) eq "HE" || substr($_,13,2) eq "HD" || substr($_,13,2) eq "HZ" || substr($_,13,2) eq "HG")
		{
			if (substr($_,17,3) ne "PHE" && substr($_,17,3) ne "TYR" && substr($_,17,3) ne "TRP" && substr($_,17,3) ne "THR" && substr($_,17,3) ne "HIS")
			{
			print substr($_,0,15).' '.substr($_,16, ),"\n";
			}
			else
			{
			print $_,"\n";
			}
		}
		elsif (substr($_,12,1) =~ m/\d/ && substr($_,15,1) =~ m/\s/)
		{
		print $_,"\n";
		}
		elsif (substr($_,13,3) eq "HH2" && substr($_,17,3) eq "TRP")
		{
		print $_,"\n";
		}
		elsif (substr($_,13,3) eq "HH " && substr($_,17,3) eq "TYR")
		{
		print $_,"\n";
		}
		elsif ((substr($_,12,3) eq " HD" || substr($_,12,3) eq " HE" || substr($_,12,3) eq " HZ") && (substr($_,17,3) eq "PHE" || substr($_,17,3) eq "TYR" || substr($_,17,3) eq "TRP" || substr($_,17,3) eq "HIS"))
		{
		print $_,"\n";
		}
		elsif (substr($_,13,3) eq "HG1" && substr($_,17,3) eq "THR")
		{
		print $_,"\n";
		}
	}
    else
    {
	print $_,"\n";           # NON HYDROGEN ATOMS
    }
}



