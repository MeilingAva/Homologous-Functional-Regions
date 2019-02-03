function ConsistentROIsNum = Func_Find_ExcludeROIs_From116ROIs(InPath,OutPath,SubIDs,MatchRate)
% InPath = 'MatchMatrix';

SubsNum = length(SubIDs);
MatchMatrix = zeros(116,SubsNum);

% Left hemisphere, Right hemisphere for each network, Net1_L,Net1_R,
% Net2_L, Net2_R

k_start = 1;
for n = [1:4 18 14 5:7 9 10 8 11:13 15:17]
    load([InPath '/Net_' num2str(n+1) '_MatchMatrix_lh.mat']);
    tmp = All_Sub_MatchMatrix{1};
    k_end = k_start+size(tmp,1)-1;
   
    for s = 1:length(All_Sub_MatchMatrix)
        matrix = All_Sub_MatchMatrix{s};
        isMatch = logical(sum(matrix,2));
        MatchMatrix(k_start:k_end,s) = isMatch;
    end
    k_start = k_end+1;
    
    
    load([InPath '/Net_' num2str(n+1) '_MatchMatrix_rh.mat']);
    tmp = All_Sub_MatchMatrix{1};
    k_end = k_start+size(tmp,1)-1;
   
    for s = 1:length(All_Sub_MatchMatrix)
        matrix = All_Sub_MatchMatrix{s};
        isMatch = logical(sum(matrix,2));
        MatchMatrix(k_start:k_end,s) = isMatch;
    end
    k_start = k_end+1;
    
end

    
MatchVec = sum(MatchMatrix,2);
MatchMask = logical(MatchVec>=SubsNum.*MatchRate);
ConsistentROIsNum = sum(MatchMask);
save([OutPath '/Matched' num2str(ConsistentROIsNum) 'ROIs_From116ROIs.mat'],'MatchMask');



ExcludeMatchMask = find(MatchVec<SubsNum.*MatchRate);
IncludeMatchMask = find(MatchVec>=SubsNum.*MatchRate);
%Shown on FS5
% Load ROIIndex on fsaverage5
GrpInPath = 'Templates/GrpTemplate_Patches_116_FS5';

k = 0;
for net_i = [1:4 18 14 5:7 9 10 8 11:13 15:17]  
    lh = load_mgh([GrpInPath '/lh_network_' num2str(net_i+1) '_asym_fs5_Patch.mgh']);
    ROIsNum = max(lh);
    for roi_i = 1:ROIsNum
        k = k+1;
        Index = find(lh==roi_i);
        ROI_Ind_Big_fs5{k} = Index;
    end
    rh = load_mgh([GrpInPath '/rh_network_' num2str(net_i+1) '_asym_fs5_Patch.mgh']);
    ROIsNum = max(rh);
    for roi_i = 1:ROIsNum
        k = k+1;
        Index = find(rh==roi_i);
        ROI_Ind_Big_fs5{k} = 10242+Index;
    end
end

CombineExcludeMap = zeros(10242*2,1);
 for roi_i = 1:length(ExcludeMatchMask)

    index = ROI_Ind_Big_fs5{ExcludeMatchMask(roi_i)};
    CombineExcludeMap(index) = ExcludeMatchMask(roi_i);
 end
 save_mgh(CombineExcludeMap(1:10242),[OutPath '/Exclude_ROIs_FS5_lh.mgh'],eye(4));
 save_mgh(CombineExcludeMap(10243:end),[OutPath '/Exclude_ROIs_FS5_rh.mgh'],eye(4));
    
  
 CombineConsistMap = zeros(10242*2,1);
 for roi_i = 1:length(IncludeMatchMask)

    index = ROI_Ind_Big_fs5{IncludeMatchMask(roi_i)};
    CombineConsistMap(index) = IncludeMatchMask(roi_i);
 end
 save_mgh(CombineConsistMap(1:10242),[OutPath '/Include_ROIs_FS5_lh.mgh'],eye(4));
 save_mgh(CombineConsistMap(10243:end),[OutPath '/Include_ROIs_FS5_rh.mgh'],eye(4));
  
  

 
 
 
