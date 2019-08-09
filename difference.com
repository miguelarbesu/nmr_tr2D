#!/bin/csh

# Name argumenst for clarity
set expDir = $1
@ expStart = $2
@ expEnd = $3
set ftFolder = ./ft_$expStart-$expEnd
set difFolder = ./dif_$expStart-$expEnd

# Go to experiment and create folder to store the difference spectra
cd $expDir
rm -rf $difFolder
mkdir $difFolder
# Make a copy of the timeList
cp $ftFolder/time.list $difFolder/time.list
# Use the 2nd spectrum as reference, assumign that the first one is t0 before
# starting the experiment - i.e. adding ATP
# https://unix.stackexchange.com/questions/214445/how-do-i-display-the-nth-result-of-an-ls-command
set ftT0 = (`ls $ftFolder/*.ft2 | sed -n 2p`)
set ftList = (`ls $ftFolder/*.ft2`)

echo "Calculating difference spectra vs $ftT0 for spectra in $ftFolder"
@ i = 0
foreach spectrum ($ftList)
    @ i++
    set outName = (`nmrPrintf $difFolder/test%03d.ft2 $i`)
    addNMR -in1 $spectrum -in2 $ftT0 -out $outName -sub
end

# Make the collection of 2D planes a time-dependent serie - i.e. a pseudo3D
set difList = ($difFolder/*.ft2)
seriesT.com $difList
