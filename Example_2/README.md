This is modified [**Example23**](https://wannier90.readthedocs.io/en/latest/tutorials/tutorial_23/) from Wannier90 package. 

Run QE scf and nscf calculations using 8x8x8 k-mesh:

> pw.x < [silicon.scf](silicon.scf) > scf.out

> pw.x < [silicon.gw.nscf](silicon.gw.nscf) > nscf.gw.out

QE generates 29 unique IBZ k-mesh points from total 8x8x8 points.

Enter directory *si.save* and prepare Yambo calculation:

> cd si.save

> p2y

> yambo

Then run Yambo GW calculation using 29 k-points:

> yambo -F [yambo_G0W0.in](yambo_G0W0.in)

Go to directory with QE calculation:

> cd ..

and run *nscf* calculation for uniform k-mesh 4x4x4 (total 64 k-points):

> pw.x < [silicon.nscf](silicon.nscf) > nscf.out

Run Wannier90 preprocessing:

> wannier90.x -pp silicon

This run uses [silicon.win](silicon.win) input file.

Run *pw2wannier90.x* task:

> pw2wannier90.x < [silicon.pw2wan](silicon.pw2wan) > pw2wan.out

This run creates several files: 

Copy *silicon.nnkp* file into *si.save* directory:

> cp silicon.nnkp si.save

> cd si.save

> ypp

*ypp* program uses [ypp.in](ypp.in) input file. 

This run creates file *silicon.gw.unsorted.eig* which is necessary to copy to the main directory:

> cp silicon.gw.unsorted.eig ..

Run Python script in order to update Wannier90 files *silicon.mmn* and *silicon.amn* to include GW correction (you need to have the Python3 module with installed numpy and scipy modules):

> python3 /Wannier90/utility/gw2wannier90.py silicon mmn amn

Run Wannier90 program to compute GW corrected MLWFs:

> wannier90.x silicon.gw

This run uses [silicon.gw.win](silicon.gw.win) input file.
