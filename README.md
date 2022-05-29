# Wannier90 usage

- [Quantum Espresso + Wannier90](#example-1-srvo3)
- [Quantum Espresso + Yambo GW + Wannier90](#example-2)

# Example 1. SrVO<sub>3</sub>

Test example for [Quantum Espresso](https://www.quantum-espresso.org/) + Wannier90 on [Stokes Supercluster of UCF](https://arcc.ist.ucf.edu/).  
The example is taken from [here](https://issp-center-dev.github.io/DCore/master/tutorial/srvo3/qe/qe.html)

Copy input files from [Example_1 directory](https://github.com/Dmitry-Skachkov/Wannier90_examples/tree/main/Example_1) to your local directory and download the pseudopotential files from [THEOS library](http://theossrv1.epfl.ch/Main/Pseudopotentials)

> wget http://theossrv1.epfl.ch/uploads/Main/NoBackup/Sr.pbe-spn-kjpaw_psl.0.2.3.upf   
> wget http://theossrv1.epfl.ch/uploads/Main/NoBackup/V.pbe-spn-kjpaw_psl.0.2.3.upf   
> wget http://theossrv1.epfl.ch/uploads/Main/NoBackup/O.pbe-n-kjpaw_psl.0.1.upf   


The script [job_wannier90](https://github.com/Dmitry-Skachkov/Wannier90_examples/blob/main/Example_1/job_wannier90)  will execute the following calculations  

- QE scf for ground state of SrVO<sub>3</sub> system
     > mpirun -np $PPN pw.x -ni 1 -nk 1 -nt 1 -nd 1 -nb 1 -input [scf.in](https://github.com/Dmitry-Skachkov/Wannier90_examples/blob/main/Example_1/scf.in) > scf.out   
- pre-process with Wannier90   
     > mpirun   -np $PPN  wannier90.x -pp d    
- convert files for Wannier90 using pw2wannier90 module from QE package   
     > mpirun   -np $PPN  pw2wannier90.x -in [pw2wan.in](https://github.com/Dmitry-Skachkov/Wannier90_examples/blob/main/Example_1/pw2wan.in) > pw2wan.out
- calculate Wannier orbitals
     > mpirun   -np $PPN  wannier90.x [d ](https://github.com/Dmitry-Skachkov/Wannier90_examples/blob/main/Example_1/d.win)   
- calculate band structure with QE  
     > mpirun -np $PPN pw.x -ni 1 -nk 1 -nt 1 -nd 1 -nb 1 -input [bands.in](https://github.com/Dmitry-Skachkov/Wannier90_examples/blob/main/Example_1/bands.in) > bands.out    
     > mpirun -np $PPN bands.x  -input [bandsx.in](https://github.com/Dmitry-Skachkov/Wannier90_examples/blob/main/Example_1/bandsx.in) > bandsx.out   

The result of the Wannier90 program is output [d.wout](https://github.com/Dmitry-Skachkov/Wannier90_examples/blob/main/Example_1/results/d.wout) and three xsf files with the orbitals  
```  
d_00001.xsf   
d_00001.xsf   
d_00003.xsf   
```   
You can plot the orbitals with [VESTA](https://jp-minerals.org/vesta/en/) software:

![GitHub Logo](https://github.com/Dmitry-Skachkov/Wannier90_examples/blob/main/Example_1/results/d_00003_1.png)
   
The Hamiltonian matrix in Wannier function basis is written to the file [d_hr.dat](https://github.com/Dmitry-Skachkov/Wannier90_examples/blob/main/Example_1/results/d_hr.dat). The format of the file is described in the [documentation for Wannier90 software](https://github.com/wannier-developers/wannier90/raw/v3.1.0/doc/compiled_docs/user_guide.pdf) (look at Chapter 8.19 "Seedname_hr.dat")

You can compare the band structure calculated in QE with the wannier-interpolated band structure in Wannier90:
 > gnuplot [plot.gnu](https://github.com/Dmitry-Skachkov/Wannier90_examples/blob/main/Example_1/results/plot.gnu)   

The result is [here](https://github.com/Dmitry-Skachkov/Wannier90_examples/blob/main/Example_1/results/Band_QE_vs_Wannier.pdf)

# Example 2. 
