#!/bin/csh -f
set InPath = $1
set tclPath = $2
cd ${InPath}

set template = (fsaverage5)
set files = `ls *FS5_*lh.mgh`

foreach file ($files)
echo $file
tksurfer $template lh inflated -overlay $file -fminmax 0.01 0.05  -tcl ${tclPath}/test.tcl
mv 1.tiff ${file}.tiff

tksurfer $template lh inflated -overlay $file -fminmax 0.01 0.05  -tcl ${tclPath}/test_med.tcl
mv 1.tiff ${file}_med.tiff

end

set files = `ls *FS5_*rh.mgh`

foreach file ($files)
echo $file
tksurfer $template rh inflated -overlay $file -fminmax 0.01 0.05  -tcl ${tclPath}/test.tcl
mv 1.tiff ${file}.tiff


tksurfer $template rh inflated -overlay $file -fminmax 0.01 0.05  -tcl ${tclPath}/test_med.tcl
mv 1.tiff ${file}_med.tiff

end







