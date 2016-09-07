#!/bin/bash 

# This is just to remove the files which are generated from this script for repetitive runs.
rm parse parse1 parse2
rm kx_ky_kz
rm final

#This extracts the k-points from the file "bands.dat" into kx_ky_kz file.
grep "k =" ./bands.dat | awk '{printf "k= %6.4f %6.4f %6.4f\n", $3, $4, $5}' >> kx_ky_kz

fname="kx_ky_kz"

#This calculates the distance using the formulae of distance.
#It takes the values of kx, ky and kz from the file "kx_ky_kz" and calculates the distance
#This calculated distance is written to the file "parse"
grep "k= " ./$fname | awk '{printf "%6.4f\n", sqrt(($2*$2)+($3*$3)+($4*$4))}' >> parse

sed -n '/band energies (ev)/ {n;p}' bands.dat >> parse1
#This line grep's the entire energy values of the bands from the file "bands.dat" and prints it to a temporary file "parse2"
grep " " ./parse1 | awk '{printf "%15.10f %15.10f %15.10f %15.10f %15.10f %15.10f %15.10f %15.10f\n", $1, $2, $3, $4, $5, $6, $7, $8}' >> parse2

#Inititalizing certain variables
a=0.0
b=0.0
c=0.0
d=0.0

#This counts the number of lines in the file "kx_ky_kz" and then this gives the number of k points available in the data.
n=$(wc -l < kx_ky_kz)

#Now this for loop creates arrays kx, ky, kz and takes in the values from the kx_ky_kz file.
#This loop also greps the entire total energy values from the file "parse2"
for ((i=1 ; i<=$n ; i++));
#for i in {1..81}
do
	tot_ene[$i]=$(awk 'NR=='$[i]'' parse2)
	kx[$i]=$(awk 'NR=='$i' {printf "%8.5f", $2}' kx_ky_kz)
	ky[$i]=$(awk 'NR=='$i' {printf "%8.5f", $3}' kx_ky_kz)
	kz[$i]=$(awk 'NR=='$i' {printf "%8.5f", $4}' kx_ky_kz)
#Now for easier computation, the arrays are substituted to temporary variables x, y, z	
	x=${kx[$i]}
	y=${ky[$i]}
	z=${kz[$i]}
	#echo $x $y $z 

#This computes the distance and adds the previously calculated distance repeatedly on the variable "d" (distance)
	d=`echo "scale=16; $d + sqrt( ($a-$x)^2 + ($b-$y)^2 + ($c-$z)^2 )" | bc`
#Now the values of a, b, c are changed to x, y, z since the distance is calculated with adjacent points.
	a=$x
	b=$y
	c=$z
#the values of the array "tot_ene[]" are substituted to tot_E variable for easier computation...
	tot_E=${tot_ene[$i]}
#Now this prints the final - required file for plotting the band structure.
	echo $d \ \  $tot_E >>final
#	echo $tot_E
done
