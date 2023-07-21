set term postscript eps enhanced color solid
set size 0.8,1.0

set tics font "Helvetica,18"
set xlabel font "Helvetica,18"
set ylabel font "Helvetica,18"
set key font "Helvetica,18"
set title font "Helvetica,18"

set ylabel "Energy"
set xlabel "Mass"
set title  en  . "MeV"
set output "Eex/" . selection . "/" . nuclide . "_" . en . ".eps"

plot "Eex/" . selection . "/" . nuclide . "_" . en . ".dat" u 2:3 w p title nuclide . ": ". en  . "MeV"