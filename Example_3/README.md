# Monolayer MoS<sub>_2</sub> example

Generate k-mesh with kmesh.pl utility from /Wannier90/utility/ folder

> kmesh.pl 7 7 1

Insert generated k-mesh in scf.in input file and run QE

> pw.x < scf.in > scf.out

Insert the same k-mesh data into d.win file for Wannier90 and run preprocessing

> wannier90.x -pp d

This run uses d.win input file.

Run pw2wannier90.x 

> pw2wannier90.x -in pw2wan.in

Run Wannier90 

> wannier90.x d

This run uses the same input file d.win!

