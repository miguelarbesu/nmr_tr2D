#!/bin/csh

# This script is based in this thread of the nmrPipe discussion group:
# https://groups.yahoo.com/neo/groups/nmrpipe/conversations/topics/2934
#
# seriesTab is the lowest level tool for analyzing pseudonD data:
# fit.com creates autoFit.com, which internally calls seriesTab.

# Name argumenst for clarity
set expDir = $1
@ expStart = $2
@ expEnd = $3
set dirList = (`seq $expStart $expEnd`)
# Go to experiment directory
cd $expDir
# Define where processed files are
set ftFolder = ./ft_$expStart-$expEnd
# Define peaklist folder, master and series input and series output, clean old
set tabFolder = ./tab_$expStart-$expEnd
set masterTab = $expDir/master.tab
set ftList = $tabFolder/series.list
rm $ftList
ls $ftFolder/*.ft2 > $tabFolder/series.list
set seriesTab = $tabFolder/series.tab
rm $seriesTab
# dx and dy = 0 mean strict peak positions along pseudo axis
echo "Extracting intensities for peaks in $masterTab along slices:"
cat $ftList
seriesTab -in $masterTab -list $ftList -dx 0 -dy 0 -out $seriesTab
