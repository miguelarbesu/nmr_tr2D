#!/bin/csh

# Name argumenst for clarity
set expDir = $1
@ expStart = $2
@ expEnd = $3

echo "CONVERTING FROM BRUKER TO NMRPIPE"
echo "---------------------------------"
echo ""
conversion.sh $expDir $expStart $expEnd

echo "PROCESSING NMRPIPE FIDs"
echo "-----------------------"
echo ""
processing.sh $expDir $expStart $expEnd

echo "CALCULATING DIFFERENCE SPECTRA VS REFERENCE"
echo "-------------------------------------------"
echo ""
difference.sh $expDir $expStart $expEnd

echo "PICKING PEAKS"
echo "-------------"
echo ""
peak.sh $expDir $expStart $expEnd

echo "EXTRACTING PEAK INTENSITIES ALONG SERIES"
echo "----------------------------------------"
echo ""
series.sh $expDir $expStart $expEnd
