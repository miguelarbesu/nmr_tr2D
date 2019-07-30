#!/bin/csh

# Name argumenst for clarity
set expDir = $1
@ expStart = $2
@ expEnd = $3

# Set time step  - i.e. timestamp when the experiment finishes
@ timeStep = 30 #minutes
@ t0 = 0
@ tf = $timeStep * ($expEnd - $expStart)
#
set dirList      = (`seq $expStart $expEnd`)
set timeList  = (`seq $t0 $timeStep $tf`)
# set ATPCList = (`repeat 31 printf "1\n"`)

# Loop through selected expnos
cd $expDir
printf "Processing: $expDir \nExperiments: $expStart to $expEnd\n---\n"
@ i = 0
foreach d ($dirList)
    @ i++
    cd $d
        nmrPrintf "Conversion Output: %s \ntime\t%4s min\n" \
        $d/test.fid $timeList[$i]
        # Clean old conversion scripts and files
        /bin/rm -f fid.com test.fid
        # Headless conversion to nmrPipe format
        bruker -notk -nosleep -auto >& conv.log
        fid.com >>& conv.log
        # Write header w/ time information
        sethdr test.fid -tau $timeList[$i] -u1 $timeList[$i] -title $i-$timeList[$i]
        report2D.com test.fid
        echo ""
    cd ..
end
