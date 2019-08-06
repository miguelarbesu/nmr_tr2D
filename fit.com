#!/bin/csh

# Name argumenst for clarity
set expDir = $1
@ expStart = $2
@ expEnd = $3
# Go to experiment directory
cd $expDir
# Clean old files
rm autoFit.com *.tab *.list 
# Define where processed files are
set ftFolder = ./ft_$expStart-$expEnd
# Define where peaklists are
set tabFolder = ./tab_$expStart-$expEnd
# Define master peaklist
set masterPeaklist = $tabFolder/master.tab
# Create folders for simulated and difference spectra and clean old ones
set simFolder = ./sim_$expStart-$expEnd
set difFolder = ./dif_$expStart-$expEnd
rm -rf $simFolder $difFolder
mkdir $simFolder $difFolder

autoFit.tcl -specName $ftFolder/test%03d.ft2 -ndim 3 -series \
            -inTab $masterPeaklist \
            -simName $simFolder/test%03d.ft2 \
            -difName $difFolder/test%03d.ft2 \
