#!/bin/csh

# Name argumenst for clarity
set expDir = $1
@ expStart = $2
@ expEnd = $3

echo "CONVERTING FROM BRUKER TO NMRPIPE"
echo "---------------------------------"
echo ""
conversion.com $expDir $expStart $expEnd

echo "PROCESSING NMRPIPE FIDs"
echo "-----------------------"
echo ""
processing.com $expDir $expStart $expEnd

echo "PICKING PEAKS"
echo "-------------"
echo ""
peak.com $expDir $expStart $expEnd
