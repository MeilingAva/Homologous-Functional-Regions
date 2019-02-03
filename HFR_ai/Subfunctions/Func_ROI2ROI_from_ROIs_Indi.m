function [] = Func_ROI2ROI_from_ROIs_Indi(ROIPath,DataPath,OutPath,SubIDs)

mkdir([OutPath '/ROI2ROIFC_Indi']);
% ----------------Suggest to not change the code below ----------------------
load([ROIPath '/GrpTemplate_Matched_ROIs/AllSelected_Patches_lh.mat']);
PatchNum_lh = AllSelected_Patches;
load([ROIPath '/GrpTemplate_Matched_ROIs/AllSelected_Patches_rh.mat']);
PatchNum_rh = AllSelected_Patches;

TotalPatches = sum(PatchNum_lh)+sum(PatchNum_rh);



% Load consist patches for all the subjects

for s = 1:length(SubIDs)
    
    sub = SubIDs{s};
   
    k = 0;
    for n = 1:18 %[1:4 18 5:17];
        PatchNum = PatchNum_lh(n); 
        for i = 1:PatchNum          
            k = k+1;  
            if exist([ROIPath '/Indi_Matched_ROIs/Net_' num2str(n+1) '/' sub '/Net_' num2str(n+1) '_ROIs_' num2str(i) '_lh.mgh'])
            Patch = load_mgh([ROIPath '/Indi_Matched_ROIs/Net_' num2str(n+1) '/' sub '/Net_' num2str(n+1) '_ROIs_' num2str(i) '_lh.mgh']);
            ind = find(Patch>0);
            ROI_ind_Big{k} = ind;
            else
                ROI_ind_Big{k} = [];
            end
        end

            PatchNum = PatchNum_rh(n); 
            for i = 1:PatchNum
                k = k+1;
                if exist([ROIPath '/Indi_Matched_ROIs/Net_' num2str(n+1) '/' sub '/Net_' num2str(n+1) '_ROIs_' num2str(i) '_rh.mgh'])
                    Patch = load_mgh([ROIPath '/Indi_Matched_ROIs/Net_' num2str(n+1) '/' sub '/Net_' num2str(n+1) '_ROIs_' num2str(i) '_rh.mgh']);
                    ind = find(Patch>0);
                    ROI_ind_Big{k} = 2562+ind;
                else
                   ROI_ind_Big{k} = []; 
                end
            end
     end

All_ROI_Ind_Big{s} = ROI_ind_Big; % Whole brain ROIs
end


for s = 1:length(SubIDs)
  
    sub = SubIDs{s};
    fprintf(['Calculate individualized ROI-ROI FC ' num2str(s) ':' sub '\n']);
    
    SelectedSubIndex = All_ROI_Ind_Big{s};
    
  % Extract the signal to compute ROI-ROI functional connectivity
 
    load([DataPath '/' sub '_timeframes_fs4.mat']);
   
 
    data = [lhData;rhData]; % 5124*frames;
    ROIs_sig = zeros(size(data,2),TotalPatches);
    for i = 1:TotalPatches
        ind = SelectedSubIndex{i};
        if ~isempty(ind)
            ROIs_sig(:,i) = nanmean(data(ind,:),1); %frames*ROIsNum;
        end
    end
    
    CorrMat = corrcoef(ROIs_sig);%ROIsNum*ROIsNum;
    CorrMat(isnan(CorrMat)) = 0;
    save([OutPath '/ROI2ROIFC_Indi/' sub '_big_corr.mat'],'CorrMat');
    
    % fisher_z
    CorrMat = atanh(CorrMat);
    CorrMat(isnan(CorrMat)) = 0;
    CorrMat(isinf(CorrMat)) = 0;
    save([OutPath '/ROI2ROIFC_Indi/' sub '_big_corr_z.mat'],'CorrMat');
end

       



   
   



        
    
