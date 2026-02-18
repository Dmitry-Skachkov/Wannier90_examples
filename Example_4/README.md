# Monolayer MoS<sub>2</sub> example

In this example we optimize band structure for MoS<sub>2</sub> for VBM, CBM, and CBM+1 bands using 3 Wannier functions.

Generate k-mesh with *kmesh.pl* utility from /Wannier90/utility/ folder

> kmesh.pl 15 15 1

Insert generated k-mesh in *scf.in* input file and run QE

> pw.x < [scf.in](scf.in) > scf.out

Calculate the band structure with QE

> pw.x     < [bands.in](bands.in)  > bands.out

> bands.x  < [bandsx.in](bandsx.in) > bandsx.out

In *bands.in* we used automatic generation for high-symmetry k-points G-M-K-G:
```
K_POINTS crystal_b
4                           # total number of high-symmetry points
gG   10                     # point Gamma with 10 intermediate points to next high-symmetry point 
M    10
K    10
gG   10
```

In order to run Wannier90 we need again to calculate QE, because calculation of band structure destroys the QE data files:

> pw.x < scf.in > scf.out

In order to speed up this calculation we can start calculation from previous charge density:
```
&electrons
    startingpot = 'file'
/
```
 
In order to prepare input file for Wannier90 calculation, we need to insert the same k-mesh data as in QE input, which we generated with *kmesh.pl* utility. And in order the band structure k-path corresponds to QE k-path,we need to extract the k-path in reciplocal crystal_b coordinates from QE output:
```
begin kpoint_path
  G 0.0       0.0      0.0  M 0.5       0.0      0.0
  M 0.5       0.0      0.0  K 0.666667 -0.333333 0.0
  K 0.666667 -0.333333 0.0  G 0.0       0.0      0.0
end kpoint_path
```

For MoS<sub>2</sub> the three band model can be built using Mo dz2, dxy, and dx2-y2 orbitals:
```
begin projections
Mo:dz2
Mo:dxy
Mo:dx2-y2
end projections
```

In order to find 3 Wannier functions, we need to provide the frozen energy zone where we have only 3 bands:
```
dis_froz_min  = -1.90
dis_froz_max  =  1.53
```
If the program finds more than 3 bands in any k-point, then it will stop with the corresponding message, and you need to narrow the frozen energy zone.

We need to use wider energy window to search the corresponding bands in disentanglement process:
```
dis_win_min   = -5.0
dis_win_max   =  4.5
```

Run Wannier90 preprocessing:

> wannier90.x -pp d

This run uses [d.win](d.win) input file.

Run pw2wannier90.x 

> pw2wannier90.x -in [pw2wan.in](pw2wan.in)

Run Wannier90 to calculate optimized Wannier functions and calculate band structure: 

> wannier90.x d

This run uses the same input file [d.win](d.win)!

To plot band structure:

> gnuplot [plot.gnu](plot.gnu)

The figure shows calculated band structure for 3 bands using 3 Wannier functions and comparison with QE band structure:

![GitHub Logo](bands_W90_2.png)
