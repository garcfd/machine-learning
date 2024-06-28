#
#   GNUPLOT v3.6 beta multiplot script file
#
reset
set style function lines
#==========================================
#   Plot Pressure Wiggle
set grid
plot 'output.dat' using 1:2  with line title 'w1',\
     'output.dat' using 1:3  with line title 'w2',\
     'output.dat' using 1:4  with line title 'w3',\
     'output.dat' using 1:5  with line title 'w4',\
     'output.dat' using 1:6  with line title 'w5',\
     'output.dat' using 1:7  with line title 'w6',\
     'output.dat' using 1:8  with line title 'w7',\
     'output.dat' using 1:9  with line title 'w8',\
     'output.dat' using 1:10 with line title 'w9',\
     'output.dat' using 1:11 with line title 'w10',\
     'output.dat' using 1:12 with line title 'w11',\
     'output.dat' using 1:13 with line title 'w12',\
     'output.dat' using 1:14 with line title 'w13',\
     'output.dat' using 1:15 with line title 'w14',\
     'output.dat' using 1:16 with line title 'w15',\
     'output.dat' using 1:17 with line title 'w16'
pause -1 "Hit return to continue"
reset



