#
#   GNUPLOT v3.6 beta multiplot script file
#
reset
set style function lines
#==========================================
#   Plot Pressure Wiggle
set grid
set yrange[*:*]
plot 'output.dat' using 1:2 with line title 'w1',\
     'output.dat' using 1:3 with line title 'w2',\
     'output.dat' using 1:4 with line title 'w3'
pause -1 "Hit return to continue"
reset



