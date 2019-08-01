#!/usr/bin/csh

foreach dir (./data/*/ft-*)
   if (-e $dir) then
       echo "Removing $dir"
      /bin/rm -rf $dir
   endif
end

foreach dir (./data/*/tab-*)
   if (-e $dir) then
       echo "Removing $dir"
      /bin/rm -rf $dir
   endif
end
