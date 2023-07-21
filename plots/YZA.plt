#set term postscript eps enhanced color solid
#set size 0.8,1.0

set tics font "Helvetica,18"
set xlabel font "Helvetica,18"
set ylabel font "Helvetica,18"
set key font "Helvetica,18"
set title font "Helvetica,18"

set ylabel "Cumulative yield"
set xlabel "Charge number"
#set title  en  . "MeV"
#set output "YZA/" . nuclide . "_" . en . ".eps"

#plot file u 1:2 w lp title nuclide . ": ". en  . "MeV"

set log y
set format y "10^{%L}"
#set yrange [1E-6:0.2]
#set xrange [30:40]
#set key outside
unset key
file= "/Users/okumuras/Documents/nucleardata/libraries/libraries/FY/n/U235/jendl5.0/tables/FY/n-U235-MT459-E2.53E-08.jendl5.0.dat"


set multiplot
do for [mass = 90:91]{

    plot "<awk -F '{if($2==mass){print $1,$4}}' file" w lp
    
 }
# pause -1


#do for [charge = 30:70]{


#plot [30:40] file u 1:4 w lp

#}


pause -1
