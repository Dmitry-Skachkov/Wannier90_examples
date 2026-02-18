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

In order to speed up the calculation we can start calculation from previous charge density:
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

Run Wannier90 preprocessing:

> wannier90.x -pp d

This run uses *d.win* input file.

Run pw2wannier90.x 

> pw2wannier90.x -in pw2wan.in

Run Wannier90 to calculate optimized Wannier functions and calculate band structure: 

> wannier90.x d

This run uses the same input file *d.win*!

The figure shows calculated band structure for 3 bands using 3 Wannier functions and comparison with QE band structure:

