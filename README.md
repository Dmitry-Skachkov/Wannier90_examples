# Examples for Quantum Espresso + Wannier90

Test example for Quantum Espresso + Wannier90 on Stokes Supercluster of UCF.  
The example is taken from [here](https://issp-center-dev.github.io/DCore/master/tutorial/srvo3/qe/qe.html)


# Example 1. SrVO<sub>3</sub>

Copy input files from [Example_1 directory](https://github.com/Dmitry-Skachkov/Wannier90_examples/tree/main/Example_1) to your local directory and download the pseudopotential files from [THEOS library](http://theossrv1.epfl.ch/Main/Pseudopotentials)

> wget http://theossrv1.epfl.ch/uploads/Main/NoBackup/Sr.pbe-spn-kjpaw_psl.0.2.3.upf   
> wget http://theossrv1.epfl.ch/uploads/Main/NoBackup/V.pbe-spn-kjpaw_psl.0.2.3.upf   
> wget http://theossrv1.epfl.ch/uploads/Main/NoBackup/O.pbe-n-kjpaw_psl.0.1.upf   


The sript [job_wannier90](https://github.com/Dmitry-Skachkov/Wannier90_examples/blob/main/Example_1/job_wannier90)  will execute the following calculations  

- QE scf for ground state of SrVO<sub>3</sub> system
     > mpirun -np $PPN pw.x -ni 1 -nk 1 -nt 1 -nd 1 -nb 1 -input scf.in > scf.out   
- pre-process with Wannier90   
     > mpirun   -np $PPN  wannier90.x -pp d    
- convert files for Wannier90 using pw2wannier90 module from QE   
     > mpirun   -np $PPN  pw2wannier90.x -in pw2wan.in > pw2wan.out
- calculate Wannier orbitals
     > mpirun   -np $PPN  wannier90.x d   
- calculate band structure with QE  
     > mpirun -np $PPN pw.x -ni 1 -nk 1 -nt 1 -nd 1 -nb 1 -input bands.in > bands.out    
     > mpirun -np $PPN bands.x  -input bandsx.in > bandsx.out   

The result of the Wannier90 program is three xsf files with the orbitals: d_00001.xsf ... d_00003.xsf 
   
You can compare the band structure calculated in QE with the wannier-interpolated band structure in Wannier90:
 > gnuplot [plot.gnu](https://github.com/Dmitry-Skachkov/Wannier90_examples/blob/main/Example_1/results/plot.gnu)   

The result is [here](https://github.com/Dmitry-Skachkov/Wannier90_examples/blob/main/Example_1/results/Band_QE_vs_Wannier.pdf)
