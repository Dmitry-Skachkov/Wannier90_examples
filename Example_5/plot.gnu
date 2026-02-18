set terminal pngcairo size 600,600
set output 'bands_W90_2.png'

coef = 3.11619/1.5774             # connect Wannier90 and QE (taken from d_band.gnu and bands.out.gnu)

set xtics ("G"  0.00000,\
           "M"  0.5774, \
           "K"  0.9107, \
           "G"  1.57749) # taken from bands.out.gnu corresponding to M, K, and G points 

set arrow from 0.5774, graph 0 to 0.5774, graph 1 nohead
set arrow from 0.9107, graph 0 to 0.9107, graph 1 nohead

set xrange [  0 : 1.57749]
set yrange [ -16 :  10]

plot "bands.out.gnu" u 1:2         with points title "Orig", 0.0000 title "E_F", \
     "d_band.dat"    u ($1/coef):2 with lines  title "Wannier" 

