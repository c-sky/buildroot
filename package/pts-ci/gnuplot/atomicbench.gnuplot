#-- AtomicBench.gnuplot


set pointintervalbox 3
set term png size 1920,1080
set output 'atomicbench.png'
set title "SCORE for T-Head Buildroot"
set ylabel "score (SCORE)"
set yrange [0:100]
set xlabel "Machine"
set xrange [0:6]
set xtics 0,1,6

plot  'ATOMICBENCH_SCORE.dat' using 1:3:2 with labels point offset 1,1 tc rgb "blue" title "socre"
