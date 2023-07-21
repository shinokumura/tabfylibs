#!/usr/bin/perl
###########################################################################
#
#  Check FPY distribution
#    1. you need to run run.pl to generate tabulated FPY data
#    2. Run this script to make plots/pdf by Gnuplot
#                                                       2022 Aug by SO
#
###########################################################################

use strict;
use warnings;
use File::Basename;
require "../run.pl";

my $amin = 1;
my $amax = 190;
my $topdir  = "/Users/okumuras/Documents/nucleardata/libraries/libraries/FY/";

@libnames = ("jendl5.0", "jeff3.3", "endfb8.0");
@particles = ("n");


sub get_files{
    my ($libname) = @_;

	## glob directries in the particle directory
	for $par (@particles){
		my $path = "/Users/okumuras/Documents/nucleardata/libraries/libraries/FY/" . $par;
		my @nuclides = glob($path. '*');
		
		## loop over nuclides
		foreach my $n (@nuclides){
			## loop over libraries
			foreach my $libname (@libnames){
				my $file = $path . $n . $libname . "/tables/FY/" . $par . "-" . $n . "-" . "MT459-E2.53E-08." . $libname . ".dat";
				
				&read_fpy($n, $file);
			}
		}
		@files = glob "download/ENDF-B-VIII.0_*/*.endf";
	}
}



sub read_fpy{
    my @ya = ();
    my @yza = ();
    my ($nuclide, $file) = @_;
    
    open(F, $file) or die "no such ff file";
    while(<F>){
		if(/^\#/){ next; }
		$line = $_;
		$line  =~ s/^\s+//;
 
		my ($z, $a, $m, $fpy, $dfpy) = split(/\s+/, $line);
		    $ya[$a] += $fpy;
		    # $yza[$z][$a][$m] = $fpy;
	    	# print "$z, $a, $m, $fpy, $dfpy\n";
		}
    }
    close(F);
    return @ya;
}


    
sub out_ya_eps{    
    my ($nuclide, $en, @ffya) = @_;
    #print(@ffya);
    
    # define output file
    my $outya = "YA/" .  $nuclide . "_" . $en . ".dat";
    open (YA, "> $outya");
    
    my $mass = 0;
    for ($mass=$amin; $mass <=$amax; $mass++){
    	if (defined($ffya[$mass]))  {
	    printf YA ("%5d  %11.4E\n",$mass, $ffya[$mass]);
	}
    }
    # output eps
    my $cmd = `gnuplot -e "nuclide='$nuclide'; en='$en'" YA.plt`;
    system($cmd);
    close(YA);
}


sub outtex{    
    my ($nuclide, @energy) = @_;
    print(@energy);
    
    # define output file
    my $listtex = "YA/list.tex";
    
    my $outtex = "YA/" .  $nuclide . ".tex";
    open (LIST, ">> $listtex");
    print LIST "\\input{$outtex} \n";
    
    open (TEX, ">> $outtex");
    my $i = 0;
    print TEX "\\section{$nuclide}\n";
    for ($i=1; $i < $#energy+1; $i++){
        chomp($energy[$i-1]);
	my $epsname = "YA/" .  $nuclide . "_" . $energy[$i-1] . ".eps";
	# if ($i == 1){print TEX "\\begin{figure}[htbp]\n";}
	if ($i % 3  == 0) {print TEX "\\begin{minipage}{0.33\\textwidth} \\begin{center} \\includegraphics[width=\\textwidth]{$epsname} \\end{center} \\end{minipage}\n\\end{figure}\n";}
	if ($i % 3  == 1) {print TEX "\\begin{figure}[htbp]\n \\begin{minipage}{0.33\\textwidth} \\begin{center} \\includegraphics[width=\\textwidth]{$epsname} \\end{center} \\end{minipage}\n";}
	if ($i % 3  == 2) {print TEX "\\begin{minipage}{0.33\\textwidth} \\begin{center} \\includegraphics[width=\\textwidth]{$epsname} \\end{center} \\end{minipage}\n";}
    }
    print TEX "\\clearpage\n\n";
    close(LIST);
    close(TEX);
}


# Run tex compile
my $return_value = `pdflatex main.tex`;
