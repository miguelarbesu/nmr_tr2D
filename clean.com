#!/usr/bin/csh

# Delete converted spectra
foreach dir (./data/*/fid-*)
   if (-e $dir) then
       echo "Removing $dir"
      /bin/rm -rf $dir
   endif
end

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
