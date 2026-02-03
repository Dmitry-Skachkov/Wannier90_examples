# Wannier90 usage

- [Installation](#installation-on-stokes-cluster)
- [Quantum Espresso + Wannier90](#example-1-srvo3)
- [Quantum Espresso + Yambo GW + Wannier90](#example-2)

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

# Example 1. SrVO<sub>3</sub>

Test example for [Quantum Espresso](https://www.quantum-espresso.org/) + [Wannier90](http://www.wannier.org/).  
The example is taken from [here](https://issp-center-dev.github.io/DCore/master/tutorial/srvo3/qe/qe.html)

Copy input files from [Example_1 directory](Example_1) to your local directory and download the pseudopotential files from [THEOS library](http://theossrv1.epfl.ch/Main/Pseudopotentials)

> wget http://theossrv1.epfl.ch/uploads/Main/NoBackup/Sr.pbe-spn-kjpaw_psl.0.2.3.upf   
> wget http://theossrv1.epfl.ch/uploads/Main/NoBackup/V.pbe-spn-kjpaw_psl.0.2.3.upf   
> wget http://theossrv1.epfl.ch/uploads/Main/NoBackup/O.pbe-n-kjpaw_psl.0.1.upf   


The script [job_wannier90](Example_1/job_wannier90)  will execute the following calculations  

- QE scf for ground state of SrVO<sub>3</sub> system
     > mpirun -np $PPN pw.x -ni 1 -nk 1 -nt 1 -nd 1 -nb 1 -input [scf.in](Example_1/scf.in) > scf.out   
- pre-process with Wannier90   
     > mpirun   -np $PPN  wannier90.x -pp d    
- convert files for Wannier90 using pw2wannier90 module from QE package   
     > mpirun   -np $PPN  pw2wannier90.x -in [pw2wan.in](Example_1/pw2wan.in) > pw2wan.out
- calculate Wannier orbitals
     > mpirun   -np $PPN  wannier90.x [d ](Example_1/d.win)   
- calculate band structure with QE  
     > mpirun -np $PPN pw.x -ni 1 -nk 1 -nt 1 -nd 1 -nb 1 -input [bands.in](Example_1/bands.in) > bands.out    
     > mpirun -np $PPN bands.x  -input [bandsx.in](Example_1/bandsx.in) > bandsx.out   

The result of the Wannier90 program is the output file [d.wout](Example_1/results/d.wout) and three xsf files with the orbitals  
```  
d_00001.xsf   
d_00001.xsf   
d_00003.xsf   
```   
You can plot the orbitals with [VESTA](https://jp-minerals.org/vesta/en/) software:

![GitHub Logo](Example_1/results/d_00003_1.png)
   
The Hamiltonian matrix in Wannier function basis is written to the file [d_hr.dat](Example_1/results/d_hr.dat). The format of the file is described in the [documentation for Wannier90 software](https://github.com/wannier-developers/wannier90/raw/v3.1.0/doc/compiled_docs/user_guide.pdf) (look at Chapter 8.19 "Seedname_hr.dat")

You can compare the band structure calculated in QE with the wannier-interpolated band structure in Wannier90:
 > gnuplot [plot.gnu](Example_1/results/plot.gnu)   

The result is [here](Example_1/results/Band_QE_vs_Wannier.pdf)

[Go to top](#wannier90-usage)

# Example 2. Silicon G0W0 corrected MLWFs

This is [**Example23**](https://wannier90.readthedocs.io/en/latest/tutorials/tutorial_23/) from Wannier90 package. 

Run QE scf and nscf calculations:

> pw.x < silicon.scf > scf.out

> pw.x < silicon.gw.nscf > nscf.gw.out

Enter directory *si.save* and prepare Yambo calculation:

> cd si.save

> p2y

> yambo

Then run Yambo GW calculation:

> yambo -F yambo_G0W0.in

Go to directory with QE calculation:

> cd ..

and run *nscf* calculation using uniform k-mesh:

> pw.x < silicon.nscf > nscf.out

Run Wannier90 preprocessing:

> wannier90.x -pp silicon

Run *pw2wannier90.x* task:

> pw2wannier90.x < silicon.pw2wan > pw2wan.out

Copy *silicon.nnkp* file into *si.save* directory:

> cp silicon.nnkp si.save

> cd si.save

> ypp

This run creates file *silicon.gw.unsorted.eig* which is necessary copy to the main directory:

> cp silicon.gw.unsorted.eig ..

Run Python script in order to update Wannier90 files including GW correction:

> python3 /Wannier90/utility/gw2wannier90.py silicon mmn amn

Run Wannier90 program to compute GW corrected MLWFs:

> wannier90.x silicon.gw


[Go to top](#wannier90-usage)

