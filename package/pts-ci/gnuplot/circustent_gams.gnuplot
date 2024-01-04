#-- CircusTent_GAMS.gnuplot


set pointintervalbox 3
set term png size 1920,1080
set output 'circustent_gams.png'
set title "Giga AMOs/sec for T-Head Buildroot"
set ylabel "Giga AMOs/sec (GAMS)"
set xlabel "Machine"
set xrange [0:6]
set xtics 0,1,6

plot  'CIRCUSTENT_GAMS.dat' using 2:4:1 with labels point offset 2,2 tc rgb "blue" title "GAMS"
