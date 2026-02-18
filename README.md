# Wannier90 usage

- [Installation](#installation-on-stokes-cluster)
- [Example 1](#example-1-srvo3): Quantum Espresso + Wannier90
- [Example 2](#example-2-silicon-g0w0-corrected-mlwfs): Quantum Espresso + Yambo GW + Wannier90
- [Example 3](Example_3): MoS<sub>2</sub> model for 7x7x1
- [Example 4](Example_4): MoS<sub>2</sub> model for 15x15x1 and using 3 orbitals
- [Example 5](Example_5): MoS<sub>2</sub> model for 15x15x1 and using 11 orbitals

# Installation on STOKES cluster

Load modules:

> module load oneapi/oneapi-2023.1.0/mpi/mpi-2021.9.0

> module load openblas/openblas-0.3.25-oneapi-2023.1.0

> module load oneapi/oneapi-2023.1.0/mkl/mkl-2023.1.0

Copy configure file for Intel compiler:

> cp ./config/make.inc.ifort ./make.inc

Check the directory for MKL library:

> module show oneapi/oneapi-2023.1.0/mkl/mkl-2023.1.0

Edit *make.inc* file:
```
F90 = mpif90
MPIF90=mpif90
LIBDIR = /apps/oneapi/oneapi-2023.1.0/mkl/2023.1.0/lib/intel64
```

Compile the program:

> make

Copy executables into *bin* directory:

> cp *.x ~/bin


# Example 2. Silicon G0W0 corrected MLWFs

This is modified [**Example23**](https://wannier90.readthedocs.io/en/latest/tutorials/tutorial_23/) from Wannier90 package. 

Run QE scf and nscf calculations using 8x8x8 k-mesh:

> pw.x < [silicon.scf](/Example_2/silicon.scf) > scf.out

> pw.x < [silicon.gw.nscf](/Example_2/silicon.gw.nscf) > nscf.gw.out

QE generates 29 unique IBZ k-mesh points from total 8x8x8 points.

Enter directory *si.save* and prepare Yambo calculation:

> cd si.save

> p2y

> yambo

Then run Yambo GW calculation using 29 k-points:

> yambo -F [yambo_G0W0.in](/Example_2/yambo_G0W0.in)

Go to directory with QE calculation:

> cd ..

and run *nscf* calculation for uniform k-mesh 4x4x4 (total 64 k-points):

> pw.x < [silicon.nscf](/Example_2/silicon.nscf) > nscf.out

Run Wannier90 preprocessing:

> wannier90.x -pp silicon

This run uses [silicon.win](/Example_2/silicon.win) input file.

Run *pw2wannier90.x* task:

> pw2wannier90.x < [silicon.pw2wan](/Example_2/silicon.pw2wan) > pw2wan.out

This run creates several files: 

Copy *silicon.nnkp* file into *si.save* directory:

> cp silicon.nnkp si.save

> cd si.save

> ypp

*ypp* program uses [ypp.in](/Example_2/ypp.in) input file. 

This run creates file *silicon.gw.unsorted.eig* which is necessary to copy to the main directory:

> cp silicon.gw.unsorted.eig ..

Run Python script in order to update Wannier90 files *silicon.mmn* and *silicon.amn* to include GW correction (you need to have the Python3 module with installed numpy and scipy modules):

> python3 /Wannier90/utility/gw2wannier90.py silicon mmn amn

Run Wannier90 program to compute GW corrected MLWFs:

> wannier90.x silicon.gw

This run uses [silicon.gw.win](/Example_2/silicon.gw.win) input file.


[Go to top](#wannier90-usage)

