#-- AtomicBench_FAX.gnuplot

set pointintervalbox 3
set term png size 1920,1080
set title "CAS/FAA/SWP for T-Head Builroot"
set output "atomicbench_fax.png"
set ylabel "Latency [ns]"
set xlabel "Data set size [bytes]"
set xrange [0:6]

plot  'ATOMICBENCH_FAX.dat' using 1:3:2 with labels linespoints offset 2,2 tc rgb "blue" title 'CAS/FAA/SWP'