#!/bin/csh

# Name argumenst for clarity
set expDir = $1
@ expStart = $2
@ expEnd = $3

# Set time step  - i.e. timestamp when the experiment finishes
@ timeStep = 30 #minutes
@ t0 = 30
@ tf = $t0 + $timeStep * ($expEnd - $expStart - 1)

# Define expnos to convert
set dirList = (`seq $expStart $expEnd`)
set timeList = (`seq $t0 $timeStep $tf`)

# Define fid folder
set fidFolder = fid_$expStart-$expEnd

# Go to expdir, make fid folder and loop through selected expnos
cd $expDir
rm -rf ./$fidFolder
mkdir ./$fidFolder
printf "Processing: $expDir \nExperiments: $expStart to $expEnd\n---\n"
# Save timeList to fid folder
printf "`seq -s '\n' $t0 $timeStep $tf`\n" > $fidFolder/time.list
@ i = 0
foreach d ($dirList)
    @ i++
    cd $d
        set cpName = (`nmrPrintf $fidFolder/test%03d.fid $i`)
        nmrPrintf "Input: %s \nConversion Output: %s \nTimepoint:\t%4s min\n---\n" \
        $d/ser $cpName $timeList[$i]
        # Clean old conversion scripts and files (if any)
        rm -f fid.com test.fid
        # Headless conversion to nmrPipe format
        bruker -notk -nosleep -auto >& conv.log
        fid.com >>& conv.log
        # Write header w/ time information and display it
        sethdr test.fid -tau $timeList[$i] -u1 $timeList[$i] -title $i-$timeList[$i]
        showhdr -in test.fid -v
        # Move over to fid folder
        mv test.fid ../$cpName
        echo ""
    cd ..
end
