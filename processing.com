#!/bin/csh

# Name argumenst for clarity
set expDir = $1
@ expStart = $2
@ expEnd = $3
set dirList = (`seq $expStart $expEnd`)
set fidFolder = ./fid_$expStart-$expEnd
set ftFolder = ./ft_$expStart-$expEnd
# Go to experiment and create folder to store the processed spectra
cd $expDir
rm -rf $ftFolder
mkdir $ftFolder

# Loop over seelcted expnos and process converted spectra
@ i = 0
foreach fid ($fidFolder/*.fid)
    @ i++
    set outName = (`nmrPrintf $ftFolder/test%03d.ft2 $i`)
    echo "Processing $fid to $outName"
# All processing is done in the following block,
# Modify it to change parameters.
# Specially, phasing (PS) ans spectral trimmming (EXT) need to be checked.
#
# IMPORTANT: a 47.75 Hz correction for the TROSY 1H-15N splitting is applied to
# both dimensions. Comment the RS functions out if your experiments are not TROSY
    nmrPipe -in $fid \
    | nmrPipe -fn SOL \
    | nmrPipe -fn SP -off 0.5 -end 0.95 -pow 2 -elb 0.0 -glb 0.0 -c 1.0 \
    | nmrPipe -fn ZF -zf 2 -auto \
    | nmrPipe -fn FT -verb \
    | nmrPipe -fn RS -rs 47.75Hz  \
    | nmrPipe -fn PS -p0 -60.5 -p1 36.0 -di \
    | nmrPipe -fn EXT -x1 11ppm -xn 6ppm -sw \
    | nmrPipe -fn TP \
    # | nmrPipe -fn LP -fb -ord 8 \
    | nmrPipe -fn SP -off 0.5 -end 0.95 -pow 2 -elb 0.0 -glb 0.0 -c 1.0 \
    | nmrPipe -fn ZF -zf 2 -auto \
    | nmrPipe -fn FT -verb \
    | nmrPipe -fn RS -rs 47.75Hz  \
    | nmrPipe -fn PS -p0 -159.2 -p1 130.0 -di \
    | nmrPipe -fn TP \
    | nmrPipe -fn POLY -auto -verb \
    | nmrPipe -fn EXT -y1 135ppm -yn 105ppm -sw \
    -out $outName -ov

    report2D.com $outName
    echo "----------"
    echo ""
end

# For convenience, the spectral series is rescaled so that the
# max value in the entire series is 100.

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

# Make the collection of 2D planes a time-dependent serie - i.e. a pseudo3D
seriesT.com $ftList
