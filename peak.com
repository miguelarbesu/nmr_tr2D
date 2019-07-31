#!/bin/csh

# Name argumenst for clarity
set expDir = $1
@ expStart = $2
@ expEnd = $3
set dirList = (`seq $expStart $expEnd`)
# Go to experiment directory
cd $expDir
# Define where processed files are
set ftFolder = ./ft-$expStart-$expEnd
set ftList  = ($ftFolder/*.ft2)
set n = $#ftList
# Remove old peaklist folder and recreate it
set tabFolder = ./tab-$expStart-$expEnd
rm -rf $tabFolder
mkdir $tabFolder

# Loop over processed spectra and peak pick
@ i = 1
while ($i <= $n)
   set inName  = (`nmrPrintf "$ftFolder/test%03d.ft2"  $i`)
   set outName = (`nmrPrintf "$tabFolder/test%03d.tab" $i`)
   set autoNoise = (`specStat.com -in $inName -x1 0% -xn 100% -y1 0% -yn 100% -stat vEstNoise -brief`)
   echo "Peak picking $inName"
   echo "----------"
   echo "Detection threshold: $autoNoise"
   pkDetect2D.tcl -in $inName -out $outName -sigma $autoNoise
   echo ""
   echo ""
   @ i++
end
