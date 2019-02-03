#! /bin/csh

set InPath = /mnt/sp5/Share/ScriptsForPub/IndiParGUI/IndividualROIs/Example/InputData
set OutPath = ${InPath}



##
set count = 1

set stop =  9 #change


set att_file = ${InPath}/List.txt

while($count <= $stop)
    set s = `head -n $count $att_file | tail -n 1 | awk '{print $1}'`

  mkdir ${OutPath}/sub_00${count}
  mkdir ${OutPath}/sub_00${count}/surf


    echo $s


mv ${InPath}/${s}/surf/lh.${s}_bld013_rest_reorient_skip_faln_mc_g1000000000_bpss_resid_fsaverage6_sm6_fsaverage4.nii.gz ${OutPath}/sub_00${count}/surf/lh.sub_00${count}_bld013_rest_reorient_skip_faln_mc_g1000000000_bpss_resid_fsaverage6_sm6_fsaverage4.nii.gz


mv ${InPath}/${s}/surf/lh.${s}_bld014_rest_reorient_skip_faln_mc_g1000000000_bpss_resid_fsaverage6_sm6_fsaverage4.nii.gz ${OutPath}/sub_00${count}/surf/lh.sub_00${count}_bld014_rest_reorient_skip_faln_mc_g1000000000_bpss_resid_fsaverage6_sm6_fsaverage4.nii.gz



mv ${InPath}/${s}/surf/rh.${s}_bld013_rest_reorient_skip_faln_mc_g1000000000_bpss_resid_fsaverage6_sm6_fsaverage4.nii.gz ${OutPath}/sub_00${count}/surf/rh.sub_00${count}_bld013_rest_reorient_skip_faln_mc_g1000000000_bpss_resid_fsaverage6_sm6_fsaverage4.nii.gz


mv ${InPath}/${s}/surf/rh.${s}_bld014_rest_reorient_skip_faln_mc_g1000000000_bpss_resid_fsaverage6_sm6_fsaverage4.nii.gz ${OutPath}/sub_00${count}/surf/rh.sub_00${count}_bld014_rest_reorient_skip_faln_mc_g1000000000_bpss_resid_fsaverage6_sm6_fsaverage4.nii.gz


  @ count = $count + 1
end



