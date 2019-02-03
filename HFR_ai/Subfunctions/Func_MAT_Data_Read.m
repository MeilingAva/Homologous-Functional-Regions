function [] = Func_MAT_Data_Read(InPath,OutPath,SubIDs)

% Preprocessed files should be projected on fsaverage4
mkdir([OutPath '/OrganizedData']);


for s = 1:length(SubIDs)
    sub = SubIDs{s}; 
    fprintf(['Reading data ' num2str(s) ':' sub '\n']);
    
        
    load([InPath '/' sub '_timeframes_fs4.mat']);% 2562*times
 
 
    save([OutPath '/OrganizedData/' sub '_timeframes_fs4.mat'],'lhData','rhData');
end
