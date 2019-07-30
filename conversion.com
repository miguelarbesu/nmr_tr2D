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

#set origDir = (`pwd`)

# Loop expnos
@ i = 0
foreach d ($dirList)
   @ i++
   echo $d
#    cd $d
#       nmrPrintf "Conversion Output: %s time %4s min ATP: %4s mM.\n" $d/test.fid $timeList[$i] $ATPCList[$i]
#
#       # Clean old conversion scripts and files
#       /bin/rm -f fid.com test.fid
#
#       bruker -notk -nosleep -auto >& conv.log
#       fid.com >>& conv.log
#
#       sethdr test.fid -tau $timeList[$i] -u1 $timeList[$i] -u2 $ATPCList[$i] -title $i-$timeList[$i]-$ATPCList[$i]
#       report2D.com test.fid
#       echo ""
#    cd $origDir
end
