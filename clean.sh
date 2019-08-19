#!/usr/bin/csh

# Delete converted spectra
foreach dir (./data/*/fid_*)
   if (-e $dir) then
       echo "Removing $dir"
      /bin/rm -rf $dir
   endif
end

# Delete processed spectra
foreach dir (./data/*/ft_*)
   if (-e $dir) then
       echo "Removing $dir"
      /bin/rm -rf $dir
   endif
end

# Delete difference spectra
foreach dir (./data/*/dif_*)
   if (-e $dir) then
       echo "Removing $dir"
      /bin/rm -rf $dir
   endif
end

# Delete peaklists
foreach dir (./data/*/tab_*)
   if (-e $dir) then
       echo "Removing $dir"
      /bin/rm -rf $dir
   endif
end
