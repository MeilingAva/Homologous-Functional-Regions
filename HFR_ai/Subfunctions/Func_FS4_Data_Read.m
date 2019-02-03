function [] = Func_FS4_Data_Read(InPath,OutPath,SubIDs)

% Preprocessed files should be projected on fsaverage4
mkdir([OutPath '/OrganizedData']);


for s = 1:length(SubIDs)
     sub = SubIDs{s}; 
     fprintf(['Reading data ' num2str(s) ':' sub '\n']);
     lhData = [];
     rhData = [];

     Files_LH = dir([InPath '/' sub '/surf/lh.*_fsaverage6_sm6_fsaverage4.nii.gz']);
     Files_RH = dir([InPath '/' sub '/surf/rh.*_fsaverage6_sm6_fsaverage4.nii.gz']);

 
   for i = 1:length(Files_LH)

        filename_bold_lh = [Files_LH(i).name];
        filename_bold_rh = [Files_RH(i).name];
        
        
        
        fullfilename_bold_lh = [InPath '/'  sub '/surf/' filename_bold_lh];
        fullfilename_bold_rh = [InPath '/' sub '/surf/' filename_bold_rh];

        lh_hdr = MRIread(fullfilename_bold_lh);
        lhData_tmp = reshape(lh_hdr.vol,[size(lh_hdr.vol,1)*size(lh_hdr.vol,2)*size(lh_hdr.vol,3), size(lh_hdr.vol,4)]);
        
        rh_hdr = MRIread(fullfilename_bold_rh);  
        rhData_tmp = reshape(rh_hdr.vol,[size(rh_hdr.vol,1)*size(rh_hdr.vol,2)*size(rh_hdr.vol,3), size(rh_hdr.vol,4)]);

       
        lhData = [lhData lhData_tmp];
        rhData = [rhData rhData_tmp];      
   end
   save([OutPath '/OrganizedData/' sub '_timeframes_fs4.mat'],'lhData','rhData');
end
