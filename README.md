# quantum-espresso-codes

This project contains the Electronic structure calculation for the following:

1) Copper
2) Aluminium
3) Graphene

The calculations are properly labelled in the order of best performance.

Each directory (1-Cu, 2-Al, 3-Graphene) consist of 4 sub-directories, namely:

  a) 1-SCF                        (Contains the self consistent field calculations)
  b) 2-LATT_OPT                   (Contains the files for finding the optimized lattice parameter)
  c) 3-CONVG_TEST                 (Contains the files for the convergence test and determining 'ecutwfc')
  d) 4-BAND_STRUCT                (Contains the files related to Band structure and DOS calculation)
  
Most importantly, this project is a demonstration on how to perform the lattice optimization, convergence test
and band structure and DOS calculation using quantum espresso through a bash script.

So, in each of the directories: 1-Cu, 2-Al, 3-Graphene,
There are 3 main scripts which are executable, namely: (along with their functions)

  a) 2-latt_opt: Computes the most optimized lattice paramter for the system, by varying the lattice parameter
                (i.e. celldm(1) tag in the quantum espresso input file) and computing the SCF energy. Then it
                helps generate a plot through XMGRACE software to plot the total energy values wrt. the lattice
                parameters, Hence we can visually determine which lattice parameter has the minimum energy.
                
  b) 3-convg_test: Computes the SCF calculation for different values 'ecutwfc' and 'KPOINTS' tags in the 
                   quantum espresso input file. Hence, plotting the total energy against both the different                           K-points as well as the different ecutwfc, through XMGRACE. Hence, we can determine on which
                   lowest value does the convergence takes place. This is important because, we can save
                   computational power and time if the calculation is performed with lower values.
  
  c) 4-band_struct: This contains the band structure calculation and the DOS calculation for the different system
                    and plotting through XMGRACE.
  
  
  
