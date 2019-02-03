#!/bin/csh

set InPath = $1
set OutPath = $2
set sub = $3
set Iter = $4
set hemis = ('lh' 'rh')
set nets = (2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19)
mkdir $OutPath/$sub


foreach hemi($hemis)
foreach net ($nets)

# Preprocessing,smooth with 1
mri_surf2surf --srcsubject fsaverage4 --sval ${InPath}/${sub}/Iter_$Iter/Network_${net}_${hemi}.mgh --trgsubject fsaverage4 --tval $OutPath/${sub}/Network_${net}_sm1_${hemi}.mgh --hemi $hemi --nsmooth-in 1

# Get the discrete patches
mri_surfcluster --in ${OutPath}/${sub}/Network_${net}_sm1_${hemi}.mgh --subject fsaverage4 --hemi $hemi --thmin 0.01  --ocn ${OutPath}/${sub}/Network_${net}_sm1_Patch_${hemi}.mgh

rm ${OutPath}/${sub}/Network_${net}_sm1_${hemi}.mgh
end
end



