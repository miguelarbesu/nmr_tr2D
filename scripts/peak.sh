#!/bin/csh

# Name argumenst for clarity
set expDir = $1
@ expStart = $2
@ expEnd = $3
set dirList = (`seq $expStart $expEnd`)
# Go to experiment directory
cd $expDir
# Define where processed files are
set ftFolder = ./ft_$expStart-$expEnd
set ftList  = ($ftFolder/*.ft2)
set n = $#ftList
# Remove old peaklist folder and recreate it
set tabFolder = ./tab_$expStart-$expEnd
rm -rf $tabFolder
mkdir $tabFolder
# Make a copy of the timeList
cp $ftFolder/time.list $tabFolder/time.list
# Loop over processed spectra and peak pick
@ i = 1
while ($i <= $n)
   set inName  = (`nmrPrintf "$ftFolder/test%03d.ft2"  $i`)
   set outName = (`nmrPrintf "$tabFolder/test%03d.tab" $i`)
   # The area used to estimate noise can be changed here. Use 0% / 100% as default.
   set autoNoise = (`specStat.com -in $inName -x1 10.5ppm -xn 9.5ppm \
   -y1 120ppm -yn 110ppm -stat vEstNoise -brief`)
   echo "Peak picking $inName"
   echo "$autoNoise"
   echo "----------"
   # Mult makes the peak detection threshold n*noise RMSD (i.e. $autoNoise)
   pkDetect2D.tcl -in $inName -out $outName -noise $autoNoise -mult 9 \
   -sinc -reject -pkArgs -minus -1e10
   echo ""
   echo ""
   @ i++
end
