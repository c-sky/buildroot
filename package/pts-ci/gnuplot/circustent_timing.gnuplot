#-- CircusTent_Timing.gnuplot

set pointintervalbox 3
set term png size 1920,1080
set output 'circustent_timing.png'
set title "TIMING FOR T-Head Buildroot"
set ylabel "Timing (secs)"
set xlabel "Machine"
set xrange [0:6]
set xtics 0,1,6

plot  'CIRCUSTENT_TIMING.dat' using 2:4:1 with labels point offset 3,0 tc rgb "red" title "TIMING"

