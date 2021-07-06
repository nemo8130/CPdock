#!/usr/bin/perl

$sqgrd=$ARGV[0] || die "Input Pgrid values\n";	# Pgrid values (DB3_single-diel-SE.trsq)
chomp $sqgrd;
$realinp=$ARGV[1] || die "Input Transformed Sc-EC values written in \$targ-tr.ScEC\n";	
chomp $realinp;
$targ=$ARGV[2] || die "Input Target-name (for header-display)\n";
chomp $targ;
$targx=$targ;
$orgScEC=$ARGV[3] || die "Input Original Sc-EC values written in \$targ.ScEC for display\n";
chomp $orgScEC;
$path=$ARGV[4] || die "Input executable path\n";
chomp $path;
$cpath=`pwd`;
chomp $cpath;

open (CMAP,"<$path/color.map") || die "$path/color.map not found\n";
@cmap=<CMAP>;

foreach (@cmap) {chomp $_;}
$col1=substr($cmap[0],0,10);
$col2=substr($cmap[1],0,10);
$col3=substr($cmap[2],0,10);
$black=~s/\s*//g;
$red=~s/\s*//g;
@cmap1=split(/\-/,$col1);
@cmap2=split(/\-/,$col2);
@cmap3=split(/\-/,$col3);

open (ScEC,"<$orgScEC");
$datScEC=<ScEC>;
close ScEC;
chomp $datScEC;
$Scval=substr($datScEC,0,8);
$ECval=substr($datScEC,9, );
$Scval=~s/\s//g;
$ECval=~s/\s//g;

#print "Sc: $Scval EC: $ECval\n";

#==============================================
open (INP3,"<$sqgrd");
@datg = <INP3>;
close INP3;

foreach $k (@datg)
{
chomp $k;
$el = substr($k,0,8);
$eu = substr($k,10,8);
$sl = substr($k,20,8);
$su = substr($k,30,8);
$Pgrid = substr($k,50,5);
	if ($Pgrid >= 0.005)
	{
	$ctag = '0.33 0.33 1 setrgbcolor';
	}
	elsif ($Pgrid < 0.005 && $Pgrid >= 0.002)
	{
	$ctag = '0.67 0.67 1 setrgbcolor';
	}
	elsif ($Pgrid < 0.002)
	{
	$ctag = '0 1 1 setrgbcolor';
	}

print "newpath\n";
print "$ctag\n";
print "$sl $el moveto\n";
print "$su $el lineto\n";
print "$su $eu lineto\n";
print "$sl $eu lineto\n";
print "closepath\n";
print "gsave\n";
print "fill\n";
print "grestore\n";
print "stroke\n\n";

}

#=========== FILL UP LEFT BOTTOM CORNER =========

print "\n\nnewpath
0 1 1 setrgbcolor
100 100 moveto
110 100 lineto
110 110 lineto
100 110 lineto
closepath
gsave
fill
grestore
stroke\n";
#==============================================

@holdn = split(/\./,$realinp);

$pdb = $holdn[0];

open (INP3,"<$realinp");
@datr = <INP3>;
$l3 = @datr;
foreach (@datr){chomp $_;}

$pre = "%!PS
0 0 0 setrgbcolor
%0.7 0.3 0 setrgbcolor
100 100 moveto 500 100 lineto
gsave
grestore
500 500 lineto
stroke
%===============================
%0.7 0.3 0 setrgbcolor
100 100 moveto 100 500 lineto
gsave
grestore
500 500 lineto
stroke
%===============================
510  90 moveto 510  90 lineto
/Helvetica 20 selectfont
(1,-1) show
%===============================
%0.7 0.3 0 setrgbcolor
80 510 moveto 80 510 lineto
/Helvetica 20 selectfont
(-1,1) show
%===============================
%0.7 0.3 0 setrgbcolor
80 80 moveto 80 80 lineto
/Helvetica 20 selectfont
(-1,-1) show
%===============================
%0.7 0.3 0 setrgbcolor
500 500 moveto 500 500 lineto
/Helvetica 20 selectfont
(1,1) show
%===============================
%0.7 0.3 0 setrgbcolor
510 295 moveto 510 295 lineto
/Helvetica 20 selectfont
(1,0) show
%===============================
%0.7 0.3 0 setrgbcolor
 60 295 moveto  60 295 lineto
/Helvetica 20 selectfont
(-1,0) show
%===============================
%0.7 0.3 0 setrgbcolor
290  80 moveto 290  80 lineto
/Helvetica 20 selectfont
(0,-1) show
%===============================
%0.7 0.3 0 setrgbcolor
290 510 moveto 290 510 lineto
/Helvetica 20 selectfont
(0,1) show
%===============================
%===============================
%===============================
%===============================
";

if ($l3==1)
{
	$pro1 = "%===============================
%===============================
%===============================
%===============================
	0 0 0 setrgbcolor
100 300 moveto 500 300 lineto
gsave
grestore
100 300 lineto
stroke
%===============================
0 0 0 setrgbcolor
300 100 moveto 300 500 lineto
gsave
grestore
300 100 lineto
stroke
%===============================
0 0 0 setrgbcolor
300 300 moveto 300 300 lineto
/Helvetica 20 selectfont
(0,0) show
%===============================
%/Helvetica 10 selectfont
%(the effect of showing this string is isolated) show
% CURRENT POINT IS AT END OF STRING (306+? 396)
%grestore
% CURRENT POINT IS AT BEGIN OF STRING (306 396)
%152 492 lineto
%stroke
%===============================
0 0 1 setrgbcolor
200 580 moveto 200 580 lineto
/Helvetica 25 selectfont
(Complementarity Plot) show
200 560 moveto 200 560 lineto
/Helvetica 15 selectfont
(              $targx) show
200 540 moveto 200 540 lineto
(        (Sc: $Scval, EC: $ECval)) show
%30.0 Center\n";
}
elsif ($l3>1)
{
	$pro1 = "%===============================
%===============================
%===============================
%===============================
0 0 0 setrgbcolor
100 300 moveto 500 300 lineto
gsave
grestore
100 300 lineto
stroke
%===============================
0 0 0 setrgbcolor
300 100 moveto 300 500 lineto
gsave
grestore
300 100 lineto
stroke
%===============================
0 0 0 setrgbcolor
300 300 moveto 300 300 lineto
/Helvetica 20 selectfont
(0,0) show
%===============================
%/Helvetica 10 selectfont
%(the effect of showing this string is isolated) show
% CURRENT POINT IS AT END OF STRING (306+? 396)
%grestore
% CURRENT POINT IS AT BEGIN OF STRING (306 396)
%152 492 lineto
%stroke
%===============================
0 0 1 setrgbcolor
200 580 moveto 200 580 lineto
/Helvetica 25 selectfont
(Complementarity Plot) show
200 560 moveto 200 560 lineto
/Helvetica 15 selectfont
(              $targx) show
200 540 moveto 200 540 lineto
(         (Multiple {Sc,EC} entries)) show
%30.0 Center\n";
}

$pro2 = "%===============================
0 0 1 setrgbcolor


%===============================
/Times-Roman findfont 20 scalefont setfont
newpath
300 50 moveto
(Sc) show
/Times-Roman findfont 10 scalefont setfont
312 48 moveto
%(m) show
stroke
/Times-Roman findfont 10 scalefont setfont
312 60 moveto
%(sc) show
stroke

%===============================


/Times-Bold findfont 30 scalefont setfont
/ps
{50 300 moveto () show } def
gsave

/Times-Bold findfont 10 scalefont setfont 
/ps2
{50 313 moveto () show } def
gsave

/Times-Bold findfont 10 scalefont setfont   
/ps3
{42 313 moveto () show } def
gsave

%===============================
    
ps
50 300 translate
90 rotate
1 1 scale
newpath
0 0 moveto
/Times-Roman findfont 20 scalefont setfont
(EC) show
ps

grestore
gsave		 

%===============================
    
ps2
50 313 translate
90 rotate
1 1 scale
newpath
0 0 moveto
/Times-Roman findfont 10 scalefont setfont
%(m) show
ps2

grestore
gsave

%===============================

ps3
42 313 translate
90 rotate
1 1 scale
newpath
0 0 moveto
/Times-Roman findfont 10 scalefont setfont
%(sc) show
ps3

grestore
gsave

%===============================
";

#============== SET:1 (RED DOTS) ===========================


print $pre,"\n";

#----------------------------
# Draw horizontal grid lines
#----------------------------

print "[3 3] 0 setdash\n";

for ($i=100;$i<=500;$i+=10)
{
print "1 0 0.5 setrgbcolor\n";
print "100 $i moveto 500 $i lineto\n";
print "gsave\n";
print "stroke\n";
}


#----------------------------
# Draw Vertical grid lines
#----------------------------

for ($i=100;$i<=500;$i+=10)
{
print "1 0 0.5 setrgbcolor\n";
print "$i 100 moveto $i 500 lineto\n";
print "gsave\n";
print "stroke\n";
}

print $pro2,"\n";

#====================================================
#   PLOT POINTS : SET 1 (BLACK DOT)
#====================================================

open (LOG,">$cpath/fix");

for $i (0..$l3-1)
{
$res = substr($datr[$i],0,3);
$point = substr($datr[$i],4,19);
$j=$i+1;
print LOG "$i $j $res $point $cmap1[0] $cmap1[1]\n";

	if ($j>=$cmap1[0] && $j<=$cmap1[1])						# BLUE
	{
		print "0 0 0 setrgbcolor\n";
		print "newpath $point 2.5 0 360 arc closepath stroke\n";
		print "0 0 0 setrgbcolor\n";
		print "newpath $point 2.5 0 360 arc closepath fill stroke\n";
		print "$point moveto\n";
		print "gsave\n";
	}
	elsif ($j>=$cmap2[0] && $j<=$cmap2[1])						# RED
	{
		print "1 0 0 setrgbcolor\n";
		print "newpath $point 2.5 0 360 arc closepath stroke\n";
		print "1 0 0 setrgbcolor\n";
		print "newpath $point 2.5 0 360 arc closepath fill stroke\n";
		print "$point moveto\n";
		print "gsave\n";
	}
	elsif ($j>=$cmap3[0] && $j<=$cmap3[1])						# BLUE
	{
		print "0 0 0.66 setrgbcolor\n";
		print "newpath $point 2.5 0 360 arc closepath stroke\n";
		print "0 0 0.66 setrgbcolor\n";
		print "newpath $point 2.5 0 360 arc closepath fill stroke\n";
		print "$point moveto\n";
		print "gsave\n";
	}
#print"/Helvetica 5 selectfont\n";
#print "($res) show\n";
#print "grestore\n";
}

#print "0 0 1 setrgbcolor\n";
print $pro1,"\n";

#print "0 0 1 setrgbcolor\n";
print $pro1,"\n";

print "showpage % END OF PROGRAM\n";


