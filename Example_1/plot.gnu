set term postscript enh color font 'Times-Roman,24'
set output 'Band_QE_vs_Wannier.ps' 
plot [][11:18] "bands.out.gnu" u 1:2 w p tit "Orig", 12.3116 tit "E_F", "d_band.dat" u ($1*0.6146):2 tit "Wannier" w l


