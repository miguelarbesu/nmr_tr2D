#!/usr/bin/csh

# Delete processed spectra
foreach dir (./data/*/ft-*)
   if (-e $dir) then
       echo "Removing $dir"
      /bin/rm -rf $dir
   endif
end

# Delete peaklists
foreach dir (./data/*/tab-*)
   if (-e $dir) then
       echo "Removing $dir"
      /bin/rm -rf $dir
   endif
end
