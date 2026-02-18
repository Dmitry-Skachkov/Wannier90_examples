# Wannier90 usage

- [Installation](#installation-on-stokes-cluster)
- [Example 1](Example_1): Quantum Espresso + Wannier90
- [Example 2](Example_2): Quantum Espresso + Yambo GW + Wannier90
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



