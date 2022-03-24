#!/usr/bin/perl
###########################################################################
#
#  create tabulated fpy library (ENDFB/8.0, JEFF3.3 and JENDL4.0 only)
#
#                                                       2021 March by SO
#
###########################################################################

use strict;
use warnings;
use File::Path 'mkpath';
use File::Path 'rmtree';
use File::Basename;

my $type    = undef;
my $topdir  = "FY/";
#my $topdir  = "/Users/sin/Documents/nucleardata/exforpyplot2/libraries/FY/";
my $endff   = "/files/";
my $tables  = "/tables/FY/";
my $info    = "/tables/info/";
my $decayfinite  = "decayfinite/";
my @fymt    = ("454", "459");
my $libname = undef;
my @files   = ();
my $outdir_tables = undef;
my $outdir_info   = undef;
my $outdir_files  = undef;
my $outdir_decayfinite = undef;


#=pod
#---------------------------------------------------------------------------
#
#  ENDF/B-8
#
#=pod
$libname  = "endfb8.0";
@files    =  glob "download/ENDF-B-VIII.0_*/*.endf";

foreach my $file (@files){
    my $base = basename($file);
    print "$file\n";
    if ($base =~ /nfy/){
	$type = "n";
    }
    elsif ( $base =~ /sfy/){
	$type = "0";
    }

    $base =~ /([0-9]{3})_([a-zA-Z]{1,2})_([0-9m]{3,4})/;
    my $z  = $1;
    my $el = $2;
    my $a  = $3;

    print "$libname, $type, $z, $el, $a \n";

    # create directory, delete all if exist 
    $outdir_tables = &create_dir($type, $el, $a, $libname, $tables);
    $outdir_info   = &create_dir($type, $el, $a, $libname, $info);
    $outdir_files  = &create_dir($type, $el, $a, $libname, $endff);
    $outdir_decayfinite = &create_dir($decayfinite, $el, $a, $libname, "");

    # run DeCE and output tabulated file
    &run_dece_table($file, $type, $el, $a, $libname, $outdir_tables);
    &run_dece_info($file, $type, $el, $a, $libname, $outdir_info);
    &cp_files($file, $type, $el, $a, $libname, $outdir_files);
    &inc_energy_split($type, $el, $a, $libname, $outdir_tables);
}


#---------------------------------------------------------------------------
#
#  JENDL4.0/5.0 in jendl40-or-up-fy_20120914
#
my @libs = ("jendl4.0", "jendl5.0");
# $libname  = "jendl4.0";

foreach (@libs){

    if ($_ eq "jendl4.0") {$libname  = "jendl4.0"; @files = glob "download/jendl40-or-up-fy_20120914/*.dat";}
    if ($_ eq "jendl5.0") {$libname  = "jendl5.0"; @files = glob "download/jendl5-fpy_upd2/*.dat";}

    foreach my $file (@files){
        my $el = "";
        my $a = 0;

        my $base = basename($file);
        print "$base\n";
        if ($base =~ /NF|nf/){
        $type = "n";
        }
        elsif ($base =~ /SF|sf/){
        $type = "0";
        }

        if ($libname eq "jendl4.0") {
            $base =~ /([a-zA-Z]{1,2})([0-9m]{3,4})/;
            $el = $1;
            $a  = $2;
        }
        if ($libname eq "jendl5.0") {
            $base =~ /([0-9]{3})-([a-zA-Z]{1,2})-([0-9m]{3,4})/;
            $el = $2;
            $a  = $3;
        }

        print "$libname, $type, $el, $a \n";

        # create directory, delete all if exist 
        $outdir_tables = &create_dir($type, $el, $a, $libname, $tables);
        $outdir_info   = &create_dir($type, $el, $a, $libname, $info);
        $outdir_files  = &create_dir($type, $el, $a, $libname, $endff);
        $outdir_decayfinite = &create_dir($decayfinite, $el, $a, $libname, "");
        print "$outdir_files\n";

        # run DeCE and output tabulated file
        &run_dece_table($file, $type, $el, $a, $libname, $outdir_tables);
        &run_dece_info($file, $type, $el, $a, $libname, $outdir_info);
        &cp_files($file, $type, $el, $a, $libname, $outdir_files);
        &inc_energy_split($type, $el, $a, $libname, $outdir_tables);
        }
}


#---------------------------------------------------------------------------
#
#  JEFF 3.3
#s
&jeff_split;

$libname  = "jeff3.3";
@files    =  glob "download/jeff3.3_split/*.dat";

foreach my $file (@files){
    my $base = basename($file);
    # print "$base\n";
    if ($base =~ /n-/){
	$type = "n";
    }
    elsif ($base =~ /0-/){
	$type = "0";
    }

    $base =~ /-([a-zA-Z]{1,2})([0-9m]{3,4})/;
    my $el = $1;
    my $a  = $2;

    print "$libname, $type, $el, $a \n";

    # create directory, delete all if exist 
    $outdir_tables = &create_dir($type, $el, $a, $libname, $tables);
    $outdir_info   = &create_dir($type, $el, $a, $libname, $info);
    $outdir_files  = &create_dir($type, $el, $a, $libname, $endff);
    $outdir_decayfinite = &create_dir($decayfinite, $el, $a, $libname, "");

    # run DeCE and output tabulated file
    &run_dece_table($file, $type, $el, $a, $libname, $outdir_tables);
    &run_dece_info($file, $type, $el, $a, $libname, $outdir_info);
    &cp_files($file, $type, $el, $a, $libname, $outdir_files);
    &inc_energy_split($type, $el, $a, $libname, $outdir_tables);
}
#=cut



#---------------------------------------------------------------------------
#
#  sub
#


sub create_dir{
    my ($type, $el, $a, $libname, $ti) = @_;
    my $outdir  = $topdir . $type . "/" . $el . $a . "/" . $libname . $ti;

    if (-d $outdir){
	rmtree($outdir);  # caution!
	mkpath($outdir);
    } 
    else {
	mkpath($outdir);
    }
    return $outdir;
}

sub run_dece_table{
    my ($file, $type, $el, $a, $libname, $outdir_tables) = @_;
    foreach my $mt (@fymt){
	my $outfile = $type . "-" . $el . $a . "-" . "MT" . $mt . "." . $libname;
	my $cmd = "dece -f 8 -t " . $mt . " " . $file . ">" . $outdir_tables . $outfile;
	system($cmd);
    }
}

sub run_dece_info{
    my ($file, $type, $el, $a, $libname, $outdir_info) = @_;
    foreach my $mt (@fymt){
	my $outfile = $type . "-" . $el . $a . "-MF01-MT451." . $libname;
	my $cmd = "dece " . $file . " < head.dat" . ">" . $outdir_info . $outfile;
	system($cmd);
    }
}

sub cp_files{
    my ($file, $type, $el, $a, $libname, $outdir_files) = @_;
    foreach my $mt (@fymt){
	my $outfile = $type . "-" . $el . $a . "." . $libname;
	my $cmd = "cp " . $file . " " . $outdir_files . $outfile;
	system($cmd);
    }
}

sub inc_energy_split{
    my ($type, $el, $a, $libname, $outdir_tables) = @_;
    foreach my $mt (@fymt){
	my $allen = $outdir_tables . $type . "-" . $el . $a . "-" . "MT" . $mt . "." . $libname;
	print "$allen\n";
	my $eflg = "";
	my $outfile = "";
	open(AL, "$allen") or die "No file to split";
	while (<AL>){
	    my $line  =  $_;
	    chomp $line;
	    if (/neutron energy/) {
		my $e_inc   = substr($line,15,13);
		if   ($e_inc == 2.53E-02) {$eflg = "E2.53E-08";}
		else                      {$eflg = "E" . sprintf("%08.3f", $e_inc/1E+6);}
		$outfile = $outdir_tables . $type . "-" . $el . $a . "-" . "MT" . $mt . "-" .$eflg . "." .  $libname;
		print "$outfile\n";
		open (OUT, ">>$outfile");
		print OUT "$line\n";
	    }
	    if (/^\s+/ || /Z/){
		print OUT "$line\n";
	    }
	}
	my $cmd = "rm " . $allen;
	system($cmd);
    }
    close(AL);
}


#---------------------------------------------------------------------------
#
#  Split into each fissile for JEFF3.3 file
#
sub jeff_split{
    my @jeff     = ("download/JEFF33-nfy.asc", "download/JEFF33-sfy.asc");
    my $MAT      = "0000";
    my @mats     = ();
    my @filename = ();
    my $ftype    = "";

    foreach my $j (@jeff){
	open(JF, "$j") or die "No file";
	if ($j =~ /nfy/) {$ftype = "n-";} else {$ftype = "0-";}
	while(<JF>){
	    my $line  =  $_;
	    chomp $line;

	    my $MATread   = substr($line,66,4);
	    my $mtf       = substr($line,71,4);  # MT/MF number to get 1451
	    my $lnum      = substr($line,77,5);  # line number to get 5
	    
	    if ($MAT != $MATread){
		$MAT =  $MATread;
		open(OUT, ">>$MATread");

		#print OUT "$line\n";
		push(@mats, $MAT);
	    }

	    if ($MAT == $MATread && $mtf eq "1451" && $lnum == 5){
		my $nulcide      = substr($line,1,10);
		$nulcide  =~ /([0-9]{2,3})-([a-zA-Z\s]{1,2})-([0-9mM]{3,4})/;
		my $z  = $1;
		my $el = rtrim($2);
		my $a  = lc($3);
		# print "$mtf, $nulcide, $MAT, $MATstart, $lnum\n";
		$filename[$MAT] = $ftype . $el . $a . ".dat";
	    }
	    if ($MAT == $MATread){
		print OUT "$line\n";
	    }
	}
    }
    close(JF);

    foreach my $m (@mats){
	if ($m > 9000){
	    my $cmd = "mv " . $m . " download/jeff3.3_split/" . $filename[$m];
	    system($cmd);
	}
    }
}

sub rtrim {
    my $val = shift;
    $val =~ s/\s+$//;
    return $val;
}

my @elem_list=("", 
	   "H" , "He", "Li", "Be", "B" , "C" , "N" , "O" , "F" , "Ne",
	   "Na", "Mg", "Al", "Si", "P" , "S" , "Cl", "Ar", "K" , "Ca",
	   "Sc", "Ti", "V" , "Cr", "Mn", "Fe", "Co", "Ni", "Cu", "Zn",
	   "Ga", "Ge", "As", "Se", "Br", "Kr", "Rb", "Sr", "Y" , "Zr",
	   "Nb", "Mo", "Tc", "Ru", "Rh", "Pd", "Ag", "Cd", "In", "Sn",
	   "Sb", "Te", "I" , "Xe", "Cs", "Ba", "La", "Ce", "Pr", "Nd",
	   "Pm", "Sm", "Eu", "Gd", "Tb", "Dy", "Ho", "Er", "Tm", "Yb",
	   "Lu", "Hf", "Ta", "W" , "Re", "Os", "Ir", "Pt", "Au", "Hg",
	   "Tl", "Pb", "Bi", "Po", "At", "Rn", "Fr", "Ra", "Ac", "Th",
	   "Pa", "U" , "Np", "Pu", "Am", "Cm", "Bk", "Cf", "Es", "Fm",
	   "Md", "No", "Lr", "Rf", "Db", "Sg", "Bh", "Hs", "Mt", "Ds",
	   "Rg", "Cn", "Nh", "Fl", "Mc", "Lv", "Ts", "Og", "Uue","Ubn",
	   "Ubu","Ubb","Ubt","Ubq","Ubp","Ubh","Ubs","Ubo","Ube","Utn",
	   "Utu","Utb","Utt","Utq","Utp","Uth","Uts","Uto","Ute","Uqn",);

sub ztoelem {
    my $z = shift;
    my $elem_name = "";
    if    ($z == "0")   {$elem_name = "g";}
    else{
	$elem_name = $elem_list[$z];
    }
    #print "$elem_list[$z]";
    return $elem_name;
}

sub elemtoz {
    my $elem_name = shift;
    my $z = 0;
    # $z =  grep { $elem_list[$_] eq $elem_name} 0..$#elem_list;
    while ( my($indexnum, $elemm) = each @elem_list ) {
	    if($elemm eq $elem_name){
            $z = $indexnum;
        }
    }
    print "$elem_name  --> $z\n";
    return $z;
}


#---------------------------------------------------------------------------
#
#  Create decayfinite format files and Y(A) files
#
&make_decayfinite_ind();

&make_ya_ind();
&make_ya_cum();


#  Create decayfinite format files
sub make_decayfinite_ind{
    # do not convert cumulative yield file
    my @files = glob('FY/*/*/*/tables/FY/*[454]-E*');

    foreach my $f (@files){
        my @yeild = ();
        my $basename = basename($f);
        my $dirname  = dirname($f);
        my @dirs = split(/\//, $dirname);

        $basename =~ /[0n]-([A-Za-z]{1,2})([0-9m]{3,4})-MT454-E([0-9-+E.]{8})/;
        print ("$1   $2    $3\n");
        my $tar_el = $1;
        my $tar_a  = $2;
        my $e = $3;
        my $tar_z = &elemtoz($tar_el);


        my $decayfinitef = $topdir . $decayfinite . $dirs[2] . '/' . $dirs[3] . '/' . $basename;

        print "$decayfinitef\n";
        open (FINITE, "> $decayfinitef");

        my $count = `cat $f | sed '\/\^\$\/\d' | wc -l` -2;


        print  FINITE ("#  ", $basename, "  independent fission yields\n");
        printf FINITE ("# %3d %5d %5d %5s %11.4E %11d\n", 0 ,$tar_z, $tar_a, $tar_z . "xx", $e, $count);

        open(EN, "$f") or die "No file";
        while(<EN>){
            my $line  =  $_;
            chomp $line;
            if ($line =~ /^\s/){
                $line =~ s/^\s+//;
                my ($z, $a, $level, $fpy, $dfpy) = split(/\s+/, $line);
                # print "$z, $a, $level, $fpy, $dfpy  \n"; #
                my $n = $a - $z;
                printf FINITE ("%5d %5d %5d %5d %18.6E %18.6E\n", $n ,$z ,$a ,$level, $fpy, $dfpy );
            }
        }
    close(EN);
    close(FINITE);
    }
}


sub make_ya_ind{
    my @files = glob('FY/*/*/*/tables/FY/*[4]-E*');

    foreach my $f (@files){
	my @yeild = ();
	my $basename = basename($f);
	my $dirname  = dirname($f);
	$basename =~  s/(-E)([0-9])/-YA$1$2/;

	open(EN, "$f") or die "No file";
    while(<EN>){
	my $line  =  $_;
	chomp $line;
	if ($line =~ /^\s/){
	    $line =~ s/^\s+//;
	    my ($z, $a, $level, $fpy, $dfpy) = split(/\s+/, $line);
	    # print "$z, $a, $level, $fpy, $dfpy  \n"; #
	    $yeild[$a] +=  $fpy;
	}
    }

    my $outya = $dirname . '/' . $basename;
    # print "$outya\n";
    open (YA, "> $outya");
    my $i = "";
    for ($i=1; $i <=190; $i++){
    	if (defined($yeild[$i])){printf YA ("%5d  %11.4E\n",$i,$yeild[$i]);}
        }
    }
}

sub make_ya_cum{
    my @files = glob('FY/*/*/*/tables/FY/*[9]-E*');

    foreach my $f (@files){
	my @yeild = ();
	my $basename = basename($f);
	my $dirname  = dirname($f);
	$basename =~ s/(-E)([0-9])/-YA$1$2/;

	open(EN, "$f") or die "No file";
    while(<EN>){
		my $line  =  $_;
		chomp $line;
		if ($line =~ /^\s/){
		    $line =~ s/^\s+//;
		    my ($z, $a, $level, $fpy, $dfpy) = split(/\s+/, $line);
		    #print "$z, $a, $level, $fpy, $dfpy  \n";
		    if (defined($yeild[$a]) &&  $yeild[$a] >= $fpy) {next;}
		    if (defined($yeild[$a]) &&  $yeild[$a] <= $fpy) {$yeild[$a] =  $fpy;}
		    else {$yeild[$a] =  $fpy;}
		}
    }
	close(EN);
    my $outya = $dirname . '/' . $basename;
    # print "$outya\n";
    open (YA, "> $outya");
    my $i = "";
    for ($i=1; $i <=190; $i++){
    	if (defined($yeild[$i])){printf YA ("%5d  %11.4E\n",$i,$yeild[$i]);}
        }
    }
}



