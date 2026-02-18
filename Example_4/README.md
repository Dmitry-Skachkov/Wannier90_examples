# Monolayer MoS<sub>2</sub> example

Generate k-mesh with *kmesh.pl* utility from /Wannier90/utility/ folder

> kmesh.pl 15 15 1

Insert generated k-mesh in *scf.in* input file and run QE

> pw.x < scf.in > scf.out

Calculate the band structure with QE

> pw.x     < bands.in  > bands.out

> bands.x  < bandsx.in > bandsx.out

In bands.in we used automatic generation for high-symmetry points G-M-K-G:
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

In order to spped up the calculation we can use to start calculation from previous charge density:
```
&electrons
    startingpot = 'file'
/
```
 

Insert the same k-mesh data into *d.win* file for Wannier90 and run preprocessing

> wannier90.x -pp d

This run uses *d.win* input file.

Run pw2wannier90.x 

> pw2wannier90.x -in pw2wan.in

Run Wannier90 

> wannier90.x d

This run uses the same input file *d.win*!

