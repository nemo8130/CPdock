#!/usr/bin/perl
#

$sqgrd=$ARGV[0] || die "Input Pgrid values\n";  # Pgrid values (DB3_single-diel-SE.trsq)
chomp $sqgrd;

$orgScEC=$ARGV[1] || die "Input Original Sc-EC values written in \$targ.ScEC for display\n";
chomp $orgScEC;

open (ScEC,"<$orgScEC");
$datScEC=<ScEC>;
close ScEC;

chomp $datScEC;
$Scval=substr($datScEC,0,8);
$ECval=substr($datScEC,9, );
$Scval=~s/\s//g;
$ECval=~s/\s//g;

$Sc_trans=300+(200*$Scval);
$EC_trans=300+(200*$ECval);

$scale=200;

#print "$Sc_trans $EC_trans\n";

open (INP3,"<$sqgrd");
@datg = <INP3>;
close INP3;

$reg='';
$flag=0;

#==========================================================================================================================
#========================== DETERMINE THE POINT IN THE MAP (PROBABLE / LESS_PROBABLE / IMPROBABLE) ========================
#==========================================================================================================================

foreach $k (@datg)
{
chomp $k;
$flag=0;
$el = substr($k,0,8);
$eu = substr($k,10,8);
$sl = substr($k,20,8);
$su = substr($k,30,8);
$Pgrid = substr($k,50,5);

$sm=($sl+$su)/2;
$em=($el+$eu)/2;

	if ($Sc_trans<=$su && $Sc_trans>=$sl && $EC_trans<=$eu && $EC_trans>=$el)
	{
		$flag=1;
		$sc_1=$sl;$sc_2=$su;$ec_1=$el;$ec_2=$eu;
		$Pgrid_S=$Pgrid;
	}

        if ($Pgrid_S>=0.005)
        {
        $ctag = '0.33 0.33 1 setrgbcolor';
	$reg='probable';
        }
        elsif ($Pgrid_S<0.005 && $Pgrid_S>=0.002)
        {
        $ctag = '0.67 0.67 1 setrgbcolor';
	$reg='less_probable';	
        }
        elsif ($Pgrid_S<0.002)
        {
        $ctag = '0 1 1 setrgbcolor';
	$reg='improbable';
        }
}

print "($Scval, $ECval) found in the $reg region of CPdock\n";

#==========================================================================================================================
#========== 2D DISTANCE FROM THE NEAREST PROBABLE GRID (IF THE POINT FALLS OUTSIDE THE PROBABLE REGION) ===================
#========== ELSE SET THE DISTANCE AS ZERO =================================================================================
#==========================================================================================================================

if ($reg eq 'probable')
{
	$dist_min='0.000';
}
else
{
$dist_min=10000.000;
	foreach $k (@datg)
	{
	$el = substr($k,0,8);
	$eu = substr($k,10,8);
	$sl = substr($k,20,8);
	$su = substr($k,30,8);
	$Pgrid = substr($k,50,5);

	$sm=($sl+$su)/2;
	$em=($el+$eu)/2;

		if ($Pgrid>=0.005)
		{
			$d1=sqrt(($Sc_trans-$sm)**2 + ($EC_trans-$el)**2)/$scale;
			$d2=sqrt(($Sc_trans-$sm)**2 + ($EC_trans-$eu)**2)/$scale;
			$d3=sqrt(($Sc_trans-$sl)**2 + ($EC_trans-$em)**2)/$scale;
			$d4=sqrt(($Sc_trans-$su)**2 + ($EC_trans-$em)**2)/$scale;
			#print "$d1 $d2 $d3 $d4\n";
			@d_set=($d1,$d2,$d3,$d4);
			$dm=min(\@d_set);
			if ($dm<=$dist_min)
			{
				$dist_min=$dm;
			}
		print "MINIMIZING: $dm  $dist_min\n";
		}
	}
}

print "Input (Sc,EC): $Scval $ECval\n";
print "Transformed (Sc, EC): $Sc_trans, $EC_trans\n";
print "Grid where it falls in CPdock: X: $sc_1 -> $sc_2  Y: $ec_1 -> $ec_2\n";
print "CP-Region: $reg\n";
print "Distance from Probable Region: $dist_min\n";


# ---------------------SUB ROUTINE MIN-----------------------------------------

sub min 
{
my ($b)=@_;
@arr=@$b;
my $mn=10000;
	foreach $a (@arr)
	{
		#	print "SUB: $a\n";
		if ($a<=$mn)
		{
			$mn=$a;
		}
	}
return $mn;
}



