function [] = Func_MatchPatch_Between_IndiSub_GrpTemplate(ProgramPath,IndiPatchPath,SubIDs,OutPath)

%%  This function is used to match individual ROIs to the group atlas 114 ROIs from 36 networks,get the match matrix
% Please get your Individual patches from the individual paercellation, before using this code
% 20160313,Meiling



GrpPatchPath = [ProgramPath '/Templates/GrpTemplate_Patches_116_FS4'];
load([ProgramPath '/Utilities/fs4_surf_distance.mat']);

hemis = {'lh','rh'};
for h = 1:length(hemis)
    hemi = hemis{h};
    eval(['Templatedist = dist_' hemi ';']); 
    for n = 1:18
      
        fprintf(['\n Matching Individual Patches from  ' hemi '   Net  %3.0f'],n);

        %% Load Grp template discrete patches as the reference subject
        Ref_Patches = load_mgh([GrpPatchPath '/' hemi '_network_' num2str(n+1) '_asym_fs4_Patch.mgh']); %Reference
        Ref_PatchNum = max(unique(Ref_Patches));
        Ref_Patches_Index = cell(Ref_PatchNum,1);
        for i = 1:Ref_PatchNum
            index = find(Ref_Patches==i);
            Ref_Patches_Index{i} = index;
        end
            
        for s = 1:length(SubIDs);% Read Patch for each subject, 
            sub = SubIDs{s};
            Target_Patches = load_mgh([IndiPatchPath '/' sub '/Network_' num2str(n+1) '_sm1_Patch_' hemi '.mgh']);
            Target_PatchNum = max(unique(Target_Patches));
            Target_Patches_Index = cell(Target_PatchNum,1);
            for i = 1:Target_PatchNum
                index = find(Target_Patches==i);
                Target_Patches_Index{i} = index;
            end
            All_Target_Patches_Index{s,1} = Target_Patches_Index;
            
        end

        %% -- Get the overlap matrix between reference & target, distance matrix(cost matrix)
         k = 1;
        for s = 1:length(All_Target_Patches_Index)
            Target_Patches_Index = All_Target_Patches_Index{s,1}; % Target subject
            DiceMat = zeros(length(Ref_Patches_Index),length(Target_Patches_Index));
            PatchDist = zeros(length(Ref_Patches_Index),length(Target_Patches_Index));
            
            for p1 = 1:length(Ref_Patches_Index)
                Ref_Patch_Index = Ref_Patches_Index{p1};

                for p2 = 1:length(Target_Patches_Index)
                    Target_Patch_Index = Target_Patches_Index{p2};
                    PatchDist(p1,p2) = mean(mean(Templatedist(Ref_Patch_Index,Target_Patch_Index)));
                    tmp = length(intersect(Ref_Patch_Index,Target_Patch_Index));
                    if tmp>3 % if two patches have overlappted more 3 vertex(~=smooth1 distance),  they are matched
                       DiceMat(p1,p2) = 1;
                    end
                end
            end
            
               %% -Match the overlapped patches come from reference and target subjects 
               MatchMatrix = DiceMat;
               MatchCost = PatchDist;
               
               
               
               %% Match the cluster in the target that do not overlap any cluster in the reference 
                            
               Cluster_Single = find(sum(DiceMat,1)==0); % Single cluster in target
               if ~isempty(Cluster_Single)
                   for p2 = 1:length(Cluster_Single)
                        Target_Patch_Index = Target_Patches_Index{Cluster_Single(p2)};
                        for p1 = 1:length(Ref_Patches_Index)
                            Ref_Patch_Index = Ref_Patches_Index{p1};
                            PatchDist_single(p1) = mean(mean(Templatedist(Ref_Patch_Index,Target_Patch_Index)));
                        end 
                       [~,Ref_MatchedPatch] = min(PatchDist_single);
                       clear PatchDist_single
                       % If the ref_matchedPatch has matched patch in the
                       % target sub, find the mean/min ditance of the
                       % matched patch
                 
                       if sum(DiceMat(Ref_MatchedPatch,:))
                           Target_MatchedPatch = find(DiceMat(Ref_MatchedPatch,:));
                           Selected_Patch_Index = [];
                           for i = 1:length(Target_MatchedPatch)
                               Selected_Patch_Index = [Selected_Patch_Index;Target_Patches_Index{Target_MatchedPatch(i)}];
                           end
                       else
                           Selected_Patch_Index = Ref_Patches_Index{Ref_MatchedPatch};
                       end
                       
                       dist_mean_WithinPatch = mean(mean(Templatedist(Selected_Patch_Index,Selected_Patch_Index)));
                       dist_min_Single = min(min(Templatedist(Selected_Patch_Index,Target_Patch_Index)));

                           if dist_min_Single<=dist_mean_WithinPatch;                 
                               Infor{k} = [n s];
                               MatchMatrix(Ref_MatchedPatch,Cluster_Single(p2)) = 1;
                               k = k+1;
                           end
                   end
               end
       

               All_Sub_MatchMatrix{s} = MatchMatrix;
               All_Sub_MatchCost{s} = MatchCost;
        end
        
        save([OutPath '/Net_' num2str(n+1) '_MatchMatrix_' hemi '.mat'],'All_Sub_MatchMatrix');
        
%         save([OutPath '/Net_' num2str(n+1) '_MatchMatrix_' hemi '.mat'],'All_Sub_MatchMatrix','All_Sub_MatchCost');
        clear All_Sub_MatchMatrix All_Sub_MatchCost
    end
end
 fprintf(['\n Matching has finished, please checking the MatchMatrix here : \n ' OutPath '\n ']);

    
    
  
