#!/usr/bin/perl
#

while (<>) 
{
	$a=$_;
	chomp $a;
	$astr=substr($a,12,8);
	if (substr($a,0,4) eq "ATOM")
	{
		print $a,"\n";
	}
	elsif (substr($a,0,6) eq "HETATM")
	{
		if ($astr eq "NA    NA" 
			|| $astr eq "MG    MG" 
			|| $astr eq "AL   ALF" 
			|| $astr eq " K     K" 
			|| $astr eq "CA    CA" 
			|| $astr eq "MN    MN"
			|| $astr eq "MN   MN3"
			|| $astr eq "FE   FE2"
			|| $astr eq "FE    FE"
			|| $astr eq "CO    CO"
			|| $astr eq "CO   3CO"
			|| $astr eq "NI    NI"
			|| $astr eq "NI   3NI"
			|| $astr eq "CU   CU1"
			|| $astr eq "CU    CU"
			|| $astr eq "ZN    ZN"
			|| $astr eq "AG    AG"
			|| $astr eq "CD    CD"
			|| $astr eq "PT1  TPT"
			|| $astr eq "AU    AU"
			|| $astr eq "AU   AU3"
			|| $astr eq "HG    HG") 
		{
		print $a,"\n";
		}
	} 
}



