#!/bin/csh

# Name argumenst for clarity
set expDir = $1
@ expStart = $2
@ expEnd = $3
set dirList = (`seq $expStart $expEnd`)
set ftFolder = ./ft-$expStart-$expEnd

# Go to experiment and create folde to store th processed spectra
cd $expDir
rm -rf $ftFolder
mkdir $ftFolder

# Spectra are processed once without extracting a sub-region, and the initial
# result is used for auto-phasing.
#
# Spectra are then reprocessed using the auto phase values, and the
# desired region of the directly-detected dimension is extracted.

# Loop over seelcted expnos and process converted spectra
@ i = 0
foreach d ($dirList)
    @ i++

    set cpName = (`nmrPrintf $ftFolder/test%03d.ft2 $i`)
    set inName = "$d/test.fid"
    set outName = "$d/test.ft2"

    echo "Processing $inName to $outName; then moving to $cpName"

    nmrPipe -in $inName \
    | nmrPipe -fn SOL \
    | nmrPipe -fn SP -off 0.5 -end 0.95 -pow 2 -elb 0.0 -glb 0.0 -c 0.5 \
    | nmrPipe -fn ZF -zf 2 -auto \
    | nmrPipe -fn FT -verb \
    | nmrPipe -fn PS -p0 -50.0 -p1 0.0 -di \
    | nmrPipe -fn EXT -x1 3% -xn 47% -sw \
    | nmrPipe -fn TP \
    | nmrPipe -fn LP -fb -ord 8 \
    | nmrPipe -fn SP -off 0.5 -end 0.95 -pow 2 -elb 0.0 -glb 0.0 -c 1.0 \
    | nmrPipe -fn ZF -zf 2 -auto \
    | nmrPipe -fn FT -verb \
    | nmrPipe -fn PS -p0 -159.2 -p1 130.0 -di \
    | nmrPipe -fn TP \
    | nmrPipe -fn POLY -auto -verb \
    -out $outName -ov

    mv $outName $cpName
    report2D.com $cpName
    echo "----------"
    echo ""
end

# For convenience, the spectral series is rescaled so that the
# max value in the entire series is 100.0.

set ftList  = ($ftFolder/*.ft2)
set maxVal = (`specStat.com -in $ftList[1] -stat vMaxAbs -brief`)

if (`MATH "$maxVal == 0.0"`) then
    set c = 1.0
else
    set c = (`MATH "100.0/$maxVal"`)
endif

echo "Scaling Spectra by $c ..."

foreach spectrum ($ftList)
    nmrPipe -in $spectrum -out $spectrum -inPlace -fn MULT -c $c
end