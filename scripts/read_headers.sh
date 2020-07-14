#!/bin/csh

# Name argumenst for clarity
set dir = $1

@ i = 0
foreach f ($dir/*)
    @ i++
    showhdr -in $f -v
end
