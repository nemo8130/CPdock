#!/usr/bin/perl

while (<>)   # 1NO7_A.pdb
{
chomp $_;
if (substr($_,0,4) eq "ATOM")
{
	print substr($_,0,12),' ',substr($_,13, ),"\n";
}
else
{
	print $_,"\n";
}
}


