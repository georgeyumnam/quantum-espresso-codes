#!/bin/bash

echo "###################################################################################################"
echo "#                               Band structure and DOS calculation script                         #"
echo "#                             *********************************************                       #"
echo "#                                                                                                 #"
echo "#                       Created by: George Yumnam (UG, Materials Science)                         #"
echo "#                                   Materials Research Centre                                     #"
echo "#                                   Indian Institute of Science, Bangalore                        #"
echo "###################################################################################################"


# This script is meant to perform the band structure calculation.

PREFIX="Al"

ELEMENT="Al"

MPIRUN="mpirun.openmpi"

ESPRESSO_PW="pw.x"

ESPRESSO_DOS="dos.x"

k=9

ECUT=90 # enter in Ry

UPF_FILE="Al.pbe-n-kjpaw_psl.0.1.UPF"

mkdir 4_BAND_STRUCT
cd 4_BAND_STRUCT
cp ../$UPF_FILE .

echo " "
echo "Now creating the input files for SCF calculations."
echo " "

# Create *.scf.in file to perform SCF calculation.
cat>$ELEMENT.scf.in<<EOF
 &CONTROL
                 calculation = 'scf' ,
                restart_mode = 'from_scratch' ,
                      outdir = './' ,
                  pseudo_dir = './' ,
                      prefix = '$PREFIX' ,
                   verbosity = 'low' ,
 /
 &SYSTEM
                       ibrav = 2,
                   celldm(1) = 7.63,
                         nat = 1,
                        ntyp = 1,
                     ecutwfc = $ECUT ,
                 occupations = 'smearing' ,
                    smearing = 'gaussian' ,
                     degauss = 0.003
 /
 &ELECTRONS
                    conv_thr = 1d-07 ,
                 mixing_mode = 'plain' ,
                 mixing_beta = 0.7 ,
             diagonalization = 'david' ,
 /
ATOMIC_SPECIES
   $ELEMENT  26.9815385   $UPF_FILE
ATOMIC_POSITIONS alat
   $ELEMENT      0.000000000    0.000000000    0.000000000
K_POINTS automatic
  $k $k $k 0 0 0
EOF

echo "Now running the SCF calculation !!!"
echo " "

$MPIRUN -np 4  $ESPRESSO_PW  < $ELEMENT.scf.in > $ELEMENT.scf.out

echo "Completed SCF calculation. Now starting bands calculation."
echo " "
# Create *.band.in file to perform the band structure calculation by making
# use of self-consistent charge density from the previous SCF calculation.

cat>$ELEMENT.band.in<<EOF
&CONTROL
                 calculation = 'bands' ,
                restart_mode = 'from_scratch' ,
                      outdir = './' ,
                  pseudo_dir = './' ,
                      prefix = '$PREFIX' ,
                   verbosity = 'low' ,
 /
 &SYSTEM
                       ibrav = 2,
                   celldm(1) = 10.20,
                         nat = 1,
                        ntyp = 1,
                     ecutwfc = $ECUT ,
                 occupations = 'smearing' ,
                    smearing = 'gaussian' ,
                     degauss = 0.003 ,
			nbnd = 15 ,
 /
 &ELECTRONS
                    conv_thr = 1d-08 ,
                 mixing_mode = 'plain' ,
                 mixing_beta = 0.7 ,
             diagonalization = 'david' ,
 /
ATOMIC_SPECIES
   $ELEMENT  26.9815385   $UPF_FILE
ATOMIC_POSITIONS alat
   $ELEMENT      0.000000000    0.000000000    0.000000000
K_POINTS
 81 
     0.00000    0.00000    0.00000  0.1
     0.00000    0.05000    0.00000  0.1
     0.00000    0.10000    0.00000  0.1
     0.00000    0.15000    0.00000  0.1
     0.00000    0.20000    0.00000  0.1
     0.00000    0.25000    0.00000  0.1
     0.00000    0.30000    0.00000  0.1
     0.00000    0.35000    0.00000  0.1
     0.00000    0.40000    0.00000  0.1
     0.00000    0.45000    0.00000  0.1
     0.00000    0.50000    0.00000  0.1
     0.00000    0.55000    0.00000  0.1
     0.00000    0.60000    0.00000  0.1
     0.00000    0.65000    0.00000  0.1
     0.00000    0.70000    0.00000  0.1
     0.00000    0.75000    0.00000  0.1
     0.00000    0.80000    0.00000  0.1
     0.00000    0.85000    0.00000  0.1
     0.00000    0.90000    0.00000  0.1
     0.00000    0.95000    0.00000  0.1
     0.00000    1.00000    0.00000  0.1
     0.03750    0.98750    0.00000  0.1
     0.07500    0.97500    0.00000  0.1
     0.11250    0.96250    0.00000  0.1
     0.15000    0.95000    0.00000  0.1
     0.18750    0.93750    0.00000  0.1
     0.22500    0.92500    0.00000  0.1
     0.26250    0.91250    0.00000  0.1
     0.30000    0.90000    0.00000  0.1
     0.33750    0.88750    0.00000  0.1
     0.37500    0.87500    0.00000  0.1
     0.41250    0.86250    0.00000  0.1
     0.45000    0.85000    0.00000  0.1
     0.48750    0.83750    0.00000  0.1
     0.52500    0.82500    0.00000  0.1
     0.56250    0.81250    0.00000  0.1
     0.60000    0.80000    0.00000  0.1
     0.63750    0.78750    0.00000  0.1
     0.67500    0.77500    0.00000  0.1
     0.71250    0.76250    0.00000  0.1
     0.75000    0.75000    0.00000  0.1
     0.71250    0.71250    0.00000  0.1
     0.67500    0.67500    0.00000  0.1
     0.63750    0.63750    0.00000  0.1
     0.60000    0.60000    0.00000  0.1
     0.56250    0.56250    0.00000  0.1
     0.52500    0.52500    0.00000  0.1
     0.48750    0.48750    0.00000  0.1
     0.45000    0.45000    0.00000  0.1
     0.41250    0.41250    0.00000  0.1
     0.37500    0.37500    0.00000  0.1
     0.33750    0.33750    0.00000  0.1
     0.30000    0.30000    0.00000  0.1
     0.26250    0.26250    0.00000  0.1
     0.22500    0.22500    0.00000  0.1
     0.18750    0.18750    0.00000  0.1
     0.15000    0.15000    0.00000  0.1
     0.11250    0.11250    0.00000  0.1
     0.07500    0.07500    0.00000  0.1
     0.03750    0.03750    0.00000  0.1
     0.00000    0.00000    0.00000  0.1
     0.02500    0.02500    0.02500  0.1
     0.05000    0.05000    0.05000  0.1
     0.07500    0.07500    0.07500  0.1
     0.10000    0.10000    0.10000  0.1
     0.12500    0.12500    0.12500  0.1
     0.15000    0.15000    0.15000  0.1
     0.17500    0.17500    0.17500  0.1
     0.20000    0.20000    0.20000  0.1
     0.22500    0.22500    0.22500  0.1
     0.25000    0.25000    0.25000  0.1
     0.27500    0.27500    0.27500  0.1
     0.30000    0.30000    0.30000  0.1
     0.32500    0.32500    0.32500  0.1
     0.35000    0.35000    0.35000  0.1
     0.37500    0.37500    0.37500  0.1
     0.40000    0.40000    0.40000  0.1
     0.42500    0.42500    0.42500  0.1
     0.45000    0.45000    0.45000  0.1
     0.47500    0.47500    0.47500  0.1
     0.50000    0.50000    0.50000  0.1
EOF

$MPIRUN -np 4 $ESPRESSO_PW < $ELEMENT.band.in > $ELEMENT.band.out

#############################################################################
#       			PART - 2
#############################################################################
echo " "
echo "Generating the file $ELEMENT.band.out now!!!"

fname="$ELEMENT.band.out"
#

echo " "
echo "Creating the file 'test.dat' now!!!"
echo " "
echo "`sed -n '/ band energies (ev)/,+3p' $fname`" >> test.dat
# This extracts the data corresponding to the pattern 'band energies (ev)'
# and prints that line and 2 lines below that line (+2p) into a file named test.dat
echo "Now giving a finishing touch to the file and generating 'bands.dat' now!"
sed '/^$/d' test.dat>>bands.dat
# This deletes the spaces between the lines in the file test.dat and writes
# the output to bands.dat
rm test.dat
echo " "
echo "Removed the 'test.dat' file"
#############################################################################
#       			PART - 3
#############################################################################

n=$(wc -l < bands.dat) #Total number of lines generated in the temporary file.

for ((i=1 ; i<=$n ; i++));
do
        line[$i]=$(awk 'NR=='$[i]'' bands.dat)
done

m=`expr $n / 3`

#j=1
k=2
l=3
echo " "
echo "Now generating the final files."
echo " "

echo "Preparing a temperary file 'kx_ky_kz' for auxiliary support!"
echo " "
grep "k = " ./bands.dat | awk '{printf "%6.4f %6.4f %6.4f\n", $3, $4, $5}' >> kx_ky_kz
a=0
b=0
c=0
dist=0

echo "Now the following are the K-points in the mesh and the corresponding distance."
echo " "

for ((i=1 ; i<=$m ; i++));
do 
	kx[$i]=$(awk 'NR=='$i' {printf "%8.5f", $1}' kx_ky_kz)
	ky[$i]=$(awk 'NR=='$i' {printf "%8.5f", $2}' kx_ky_kz)
	kz[$i]=$(awk 'NR=='$i' {printf "%8.5f", $3}' kx_ky_kz)
	x=${kx[$i]}
        y=${ky[$i]}
        z=${kz[$i]}
	dist1=`echo "scale=16; sqrt( ($a-$x)^2 + ($b-$y)^2 + ($c-$z)^2 )" | bc`
	dist=`echo "scale=16; $dist + $dist1" | bc`
	distance[$i]=$dist
	echo "x= " $x " y= " $y " z= " $z " --->> " $dist
	echo " "
        a=$x
        b=$y
        c=$z
done

for ((i=1 ; i<=$m ; i++));
do
        line1[$i]=${line[$k]}
        line2[$i]=${line[$l]}
        k=`expr $k + 3`
        l=`expr $l + 3`
done

echo "Now the final file is beging generated!!! --->> (-_-) <<--- Stay tuned!!!"
echo " "
for ((i=1 ; i<=$m ; i++));
do
	dist=${distance[$i]}
        line3=${line1[$i]}${line2[$i]}
	echo $dist \ \ $line3
        echo $dist \ \ $line3 >> $ELEMENT.band.dat
done
rm bands.dat
rm kx_ky_kz
echo " "
echo "Now generating the Band diagram using 'Xmgrace'"
echo " "
xmgrace -free -nxy $ELEMENT.band.dat
 
##############################################################################
#				DOS calculation				     #
##############################################################################
echo " "
echo "Now Initiating the DOS calculation."
echo " "
echo "Creating the input file for DOS calculation."
cat>$ELEMENT.dos.in<<EOF
&DOS
                      prefix = '$PREFIX' ,
                      outdir = './' ,
                      fildos = '$ELEMENT.dos_without_fermi.dat' ,
                      ngauss = 0 ,
                     degauss = 0.003 ,
                      DeltaE = 0.01 ,
 /
EOF
echo " "
echo "Now running the DOS calculation!!"
echo " "
$MPIRUN -np 4 $ESPRESSO_DOS < $ELEMENT.dos.in > $ELEMENT.dos.out

fermi=`grep "Fermi" * | awk '{printf "%6.4f\n", $6}'`

nn=$(wc -l < $ELEMENT.dos_without_fermi.dat)

for ((i=1 ; i<=$nn ; i++));
do
	if (( i > 1 ));
	then
        energy[$i]=$(awk 'NR=='$i' {printf "%8.16f", $1}' $ELEMENT.dos_without_fermi.dat)
	DOS[$i]=$(awk 'NR=='$i' {printf "%8.16f", $2}' $ELEMENT.dos_without_fermi.dat)
	Int_DOS[$i]=$(awk 'NR=='$i' {printf "%8.16f", $3}' $ELEMENT.dos_without_fermi.dat)
	ene=${energy[$i]}
	energy=`echo "scale=20; $ene - $fermi" | bc`
	DOS=${DOS[$i]}
	Int_DOS=${Int_DOS[$i]}
	echo " "
	echo $energy \ \ $DOS \ \ $Int_DOS 
	fi
	echo $energy \ \ $DOS \ \ $Int_DOS >> $ELEMENT.dos_with_fermi.dat
done

echo " "
echo " "
echo "Now generating the DOS plot using 'Xmgrace'"
echo " "

xmgrace -free -nxy $ELEMENT.dos_with_fermi.dat

##############################################################################
cd ../
##############################################################################

echo " "
echo " "
echo "############################################################################## "
echo "############################################################################## "
echo "##                   Finally the computation is done now!!!                 ## " 
echo "##                                 BYE BYE!!!                               ## "
echo "############################################################################## "
echo "############################################################################## "
echo " "
echo " "
