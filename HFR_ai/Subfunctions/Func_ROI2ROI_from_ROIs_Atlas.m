function [] = Func_ROI2ROI_from_ROIs_Atlas(ROIPath,DataPath,OutPath,SubIDs)

mkdir([OutPath '/ROI2ROIFC_Atlas']);
% ----------------Suggest to not change the code below ----------------------
load([ROIPath '/GrpTemplate_Matched_ROIs/AllSelected_Patches_lh.mat']);
PatchNum_lh = AllSelected_Patches;
load([ROIPath '/GrpTemplate_Matched_ROIs/AllSelected_Patches_rh.mat']);
PatchNum_rh = AllSelected_Patches;

TotalPatches = sum(PatchNum_lh)+sum(PatchNum_rh);



% Load consist patches for Group template
k = 0;
for n = 1:18;
    PatchNum = PatchNum_lh(n); 
    for i = 1:PatchNum
        k = k+1;                 
        Patch = load_mgh([ROIPath '/GrpTemplate_Matched_ROIs/Net_' num2str(n+1) '/GrpTmplate_Net_' num2str(n+1) '_ROIs_' num2str(i) '_lh.mgh']);
        ind = find(Patch>0);
        ROI_Ind_Big{k} = ind;  
       
    end

        PatchNum = PatchNum_rh(n); 
        for i = 1:PatchNum
            k = k+1;
            Patch = load_mgh([ROIPath '/GrpTemplate_Matched_ROIs/Net_' num2str(n+1) '/GrpTmplate_Net_' num2str(n+1) '_ROIs_' num2str(i) '_rh.mgh']);
            ind = find(Patch>0);
            ROI_Ind_Big{k} = 2562+ind;
        end
 end



for s = 1:length(SubIDs)
   
    sub = SubIDs{s};
    fprintf(['Calculate Atlas-based ROI-ROI FC ' num2str(s) ':' sub '\n']);
    
    SelectedSubIndex = ROI_Ind_Big;
  % Extract the signal to compute ROI-ROI functional connectivity
  
    load([DataPath '/' sub '_timeframes_fs4.mat']);
    data = [lhData;rhData]; % 5124*frames;

    ROIs_sig = zeros(size(data,2),TotalPatches);
    for i = 1:TotalPatches
        ind = SelectedSubIndex{i};
        ROIs_sig(:,i) = nanmean(data(ind,:),1); %frames*ROIsNum;
    end
    
    CorrMat = corrcoef(ROIs_sig);%ROIsNum*ROIsNum;
    CorrMat(isnan(CorrMat)) = 0;
    save([OutPath '/ROI2ROIFC_Atlas/' sub '_big_corr.mat'],'CorrMat');
    
    % fisher_z
    CorrMat = atanh(CorrMat);
    CorrMat(isnan(CorrMat)) = 0;
    CorrMat(isinf(CorrMat)) = 0;
    save([OutPath '/ROI2ROIFC_Atlas/' sub '_big_corr_z.mat'],'CorrMat');
end

       



   
   



        
    
