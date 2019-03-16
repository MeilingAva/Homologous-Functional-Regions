function [] = Func_Generate_Matched_ROIs(ProgramPath,IndiPatchPath,MatchMatrixPath,IterPath,OutPath,SubIDs,MatchThreshold)


%% This function is used to get the individualized Matched ROIs(Reference: Group atlas, Target: individual 36 networks) for each network
% IndiPatchPath: individual descrete patches path
% MatchMatrixPath: the match matrix path
% IterPath: The individual parcellation path
% OutPath: set the directory you will put your results
% MatchThreshold: set the threshold you want to keep the tight or loose
% match for each patch, for example: 1 means all the subs have that Patch; 0.5 means at least
% half of the subjects have that Patch. The default is 1
% 20160313,Meiling
% 
% 32k mesh, Cifti and update, edited by Meiling, 20170819

if nargin < 6
    MatchThreshold = 1;
end

OutPath = [OutPath '/MatchRate' num2str(MatchThreshold)];
GrpPatchPath = [ProgramPath '/Templates/GrpTemplate_Patches_116_FS4'];
load([ProgramPath '/Utilities/fs4_surf_distance_lh.mat']);
load([ProgramPath '/Utilities/fs4_surf_distance_rh.mat']);




OutDir_MatchedIndi = [OutPath '/Indi_Matched_Patches_Splited'];
OutDir_MatchedGrp = [OutPath '/GrpTemplate_Matched_ROIs'];
mkdir ([OutDir_MatchedIndi]);
mkdir([OutDir_MatchedGrp]);


hemis = {'lh','rh'};
for h = 1:length(hemis)
    hemi = hemis{h};
    eval(['Templatedist = dist_' hemi ';']);
    Templatedist = double(Templatedist);
    
    for n = 1:18
        fprintf(['\n Generate Matched Patches: Split and Combination processing  ' hemi '   Net  %3.0f'],n);   
        
        load([MatchMatrixPath '/Net_' num2str(n+1) '_MatchMatrix_' hemi '.mat']);
        
        %% Find the consistent Patches in the reference subject-------
        Ref_Patches = load_mgh([GrpPatchPath '/' hemi '_network_' num2str(n+1) '_asym_fs4_Patch.mgh']);
        
        Ref_PatchNum = max(Ref_Patches);
        
          % Find the match rate in the reference subject
          Target_Patch_SubNum = zeros(Ref_PatchNum,length(SubIDs));
          for p = 1:Ref_PatchNum   
              for s = 1:length(SubIDs) % target
                 MatchMatrix_Onesub = All_Sub_MatchMatrix{s};
                 
                 if sum(MatchMatrix_Onesub(p,:))>0;   
                    Target_Patch_SubNum(p,s) = 1;  
                 end
              end
          end
          Ref_MatchPatch = sum(Target_Patch_SubNum,2);          

          Selected_Patch = unique(Ref_Patches(Ref_Patches>0));
            
          AllSelected_Patches(n) = length(Selected_Patch);
            
         
        %%  Find the Matched Patches in the target(individual) subject
        
         for s = 1:length(All_Sub_MatchMatrix)
             sub = SubIDs{s};
             if ~exist([OutDir_MatchedIndi '/Net_' num2str(n+1) '/' sub],'dir')
                mkdir([OutDir_MatchedIndi '/Net_' num2str(n+1) '/' sub]); 
             end
             
             Target_Patches = load_mgh([IndiPatchPath '/' sub '/Network_' num2str(n+1) '_sm1_Patch_' hemi '.mgh']);
                         
             MatchMatrix_Onesub = All_Sub_MatchMatrix{s};% Target subject
           
              %% Find the Many-To-One matched patches(Reference-To-Target),Split and Expand
                 tmp = sum(MatchMatrix_Onesub,1);
                 Patches_willsplit = find(tmp>1);
                 if ~isempty(Patches_willsplit)
                     for Patches_willsplit_i = 1:length(Patches_willsplit)
                         Patch_willsplit_current = Patches_willsplit(Patches_willsplit_i);
                         Patch_willsplit_Index = find(Target_Patches==Patch_willsplit_current);

                         MatchPatch = find(MatchMatrix_Onesub(:,Patch_willsplit_current));

                         Patch_all_splited_Index = [];
                         Patch_splited_Index = cell(length(MatchPatch),1);
                         
                         for p = 1:length(MatchPatch)
                             Ref_PatchIndex = find(Ref_Patches==MatchPatch(p));

                             Patch_splited_Index{p} = intersect(Ref_PatchIndex,Patch_willsplit_Index);
                             Patch_all_splited_Index = [Patch_all_splited_Index;intersect(Ref_PatchIndex,Patch_willsplit_Index)];
                         end

                         Patch_remain_Index = Patch_willsplit_Index;

                         Patch_remain_Index(ismember(Patch_remain_Index,Patch_all_splited_Index)) = [];

                         if ~isempty(Patch_remain_Index)
                             % Expand
                             for vertex_i = 1:length(Patch_remain_Index)
                                 VertexIndex_willexpand = Patch_remain_Index(vertex_i);
                                 for p = 1:length(MatchPatch)
                                     eval(['Templatedist = dist_' hemi ';']);
                                     Dist_v2p(p) = mean(Templatedist(VertexIndex_willexpand,Patch_splited_Index{p}));
                                 end
                                 [~,expand_identity] = min(Dist_v2p);
                                 Patch_splited_Index{expand_identity} = [VertexIndex_willexpand;Patch_splited_Index{expand_identity}];
                                 clear Dist_v2p
                             end
                         end
                         
                         % Save the splited patches
                         for i = 1:length(Patch_splited_Index)

                             PatchMap = zeros(2562,1);
                             PatchIndex = Patch_splited_Index{i};
                             splited_identity = find(Selected_Patch==MatchPatch(i));
                             PatchMap(PatchIndex) = 1;
                             save_mgh(PatchMap,[OutDir_MatchedIndi '/Net_' num2str(n+1) '/'...
                                 sub '/Patch_' num2str(Patch_willsplit_current) '_split2Patch' num2str(splited_identity) '_' hemi '.mgh'],eye(4));

                         end
                         clear PatchIndex_splited
                     end % Patches_willsplit_i
                     
                     MatchMatrix_Onesub(:,Patches_willsplit) = 0;
                 end
                 
                %% Find the ONE-TO-ONE and ONE-To-Many matched patches(Reference-To-Target), Merge and Combine
                Selected_Patch_current = find(sum(MatchMatrix_Onesub,2)>0);
             for ref_p = 1:length(Selected_Patch_current)
                 MatchMatrix_OnePatch = MatchMatrix_Onesub(Selected_Patch_current(ref_p),:);
                 MatchedPatches = find(MatchMatrix_OnePatch);                
                 PatchIndex = [];
                 for p = 1:length(MatchedPatches)
                     PatchIndex = [PatchIndex;find(Target_Patches==MatchedPatches(p))];
                 end

                 PatchMap = zeros(2562,1);
                 if ~isempty(PatchIndex)
                     PatchMap(PatchIndex) = 1;
                     saveorder = find(Selected_Patch==Selected_Patch_current(ref_p));
                     save_mgh(PatchMap,[OutDir_MatchedIndi '/Net_' num2str(n+1) '/' sub '/Patch_' num2str(saveorder) '_final_' hemi '.mgh'],eye(4));                   
                 end
             end
         end

    end
     save([OutDir_MatchedGrp '/AllSelected_Patches_' hemi '.mat'],'AllSelected_Patches');
     clear AllSelected_Patches
end



%% Generate the final clean matched "Patches" after we get the combined or splited patches for each network
InPath = [OutPath '/Indi_Matched_Patches_Splited'];
OutDir = [OutPath '/Indi_Matched_Patches_Clean'];
mkdir([OutDir])
for h = 1:length(hemis)
    hemi = hemis{h};
%     load([OutDir_MatchedGrp '/AllSelected_Patches_' hemi '.mat']);
%     PatchNums_ref = AllSelected_Patches;
    for n = 1:18
        fprintf(['\n Generate the Clean Matched Patches:  ' hemi '   Net  %3.0f'],n);

        for s = 1:length(SubIDs)
            sub = SubIDs{s};
            if ~exist([OutDir '/Net_' num2str(n+1) '/' sub],'dir')
               mkdir([OutDir '/Net_' num2str(n+1) '/' sub]);
            end
            
            files1 = dir([InPath '/Net_' num2str(n+1) '/' sub '/*final*' hemi '.mgh']);% final files, copy them
            files2 = dir([InPath '/Net_' num2str(n+1) '/' sub '/*split*' hemi '.mgh']);% splited files, rename and copy them


            Final_PatchNum = [];Splited_PatchNum = [];
            if ~isempty(files1)
                Final_PatchNum = zeros(length(files1),1);
                for f = 1:length(files1)
                    final_file = files1(f).name;
                    Final_PatchNum(f) = str2num(final_file(end-13));
                end
            end
            if ~isempty(files2)
                Splited_PatchNum = zeros(length(files2),1);
                for f = 1:length(files2)
                    file = files2(f).name;
                    Splited_PatchNum(f) = str2num(file(end-7));
                end
            end
            PatchNum = unique([Final_PatchNum;Splited_PatchNum]);
            
            for p = 1:length(PatchNum)
                PatchNum_current = PatchNum(p);
                % Find this patch from the final files and splited files
                final_fileNum = find(Final_PatchNum==PatchNum_current); 
                splited_fileNum = find(Splited_PatchNum==PatchNum_current); 
                if ~isempty(final_fileNum) && isempty(splited_fileNum)
                    finalPatchIndex = [];
                    for fi = 1:length(final_fileNum)
                        finalPatch = load_mgh([InPath '/Net_' num2str(n+1) '/' sub '/' files1(final_fileNum(fi)).name]);
        
                        finalPatchIndex = [finalPatchIndex;find(finalPatch>0)];
                    end
                    FinalMap = zeros(2562,1);
                    FinalMap(finalPatchIndex) = 1;
                    
                    save_mgh(FinalMap,[OutDir '/Net_' num2str(n+1) '/' sub '/Patch_' num2str(PatchNum_current) '_' hemi '.mgh'],eye(4));         
                end
                
                
                 if ~isempty(final_fileNum) && ~isempty(splited_fileNum)
                    finalPatchIndex1 = [];finalPatchIndex2 = [];
                    for fi = 1:length(final_fileNum)
                        finalPatch = load_mgh([InPath '/Net_' num2str(n+1) '/' sub '/' files1(final_fileNum(fi)).name]);

                        finalPatchIndex1 = [finalPatchIndex1;find(finalPatch>0)];
                    end
                    
                     for fi = 1:length(splited_fileNum)
                        finalPatch = load_mgh([InPath '/Net_' num2str(n+1) '/' sub '/' files2(splited_fileNum(fi)).name]);
                                  
                        finalPatchIndex2 = [finalPatchIndex2;find(finalPatch>0)];
                    end
                    finalPatchIndex = [finalPatchIndex1;finalPatchIndex2];
                    FinalMap = zeros(2562,1);
         
                    FinalMap(finalPatchIndex) = 1;
                    save_mgh(FinalMap,[OutDir '/Net_' num2str(n+1) '/' sub '/Patch_' num2str(PatchNum_current) '_' hemi '.mgh'],eye(4)); 
                
                 end
                  
                  if isempty(final_fileNum) && ~isempty(splited_fileNum)
                     finalPatchIndex = [];
                     for fi = 1:length(splited_fileNum)
                        finalPatch = load_mgh([InPath '/Net_' num2str(n+1) '/' sub '/' files2(splited_fileNum(fi)).name]);
       
                        finalPatchIndex = [finalPatchIndex;find(finalPatch>0)];
                     end
                    FinalMap = zeros(2562,1);
              
                    FinalMap(finalPatchIndex) = 1;
                   
                    save_mgh(FinalMap,[OutDir '/Net_' num2str(n+1) '/' sub '/Patch_' num2str(PatchNum_current) '_' hemi '.mgh'],eye(4)); 
             
                  end
            end
        end
    end
end
fprintf(['\n Matched Patches have generated, please checking the results here : \n ' OutDir '\n ']);
 


%% Percent of subjects who keep a ROI to survive in.
%% Get the final matched individual "ROIs" and project the clean matched individual Patches back to the individual ROIs
InPath = [OutPath '/Indi_Matched_Patches_Clean'];
OutDir = [OutPath '/Indi_Matched_ROIs'];
mkdir([OutDir]);

OutDir_MatchedGrp = [OutPath '/GrpTemplate_Matched_ROIs'];
mkdir([OutDir_MatchedGrp]);

hemis = {'lh','rh'};
for h = 1:length(hemis)
    hemi = hemis{h};
    load([OutDir_MatchedGrp '/AllSelected_Patches_' hemi '.mat']);
    PatchNums_ref = AllSelected_Patches;
    for n = 1:18
        fprintf(['\n Generate the Final Matched ROIs:  ' hemi '   Net  %3.0f'],n);
        
        load([MatchMatrixPath '/Net_' num2str(n+1) '_MatchMatrix_' hemi '.mat']);        
        
        %% Find the consistent Patches on the Atlas
      
        Ref_Patches = load_mgh([GrpPatchPath '/' hemi '_network_' num2str(n+1) '_asym_fs4_Patch.mgh']); % Reference
        Ref_PatchNum = max(Ref_Patches);  
        
          % Find the match rate in the reference subject
          Target_Patch_SubNum = zeros(Ref_PatchNum,length(SubIDs));
          for p = 1:Ref_PatchNum   
              for s = 1:length(SubIDs) % target
                 MatchMatrix_Onesub = All_Sub_MatchMatrix{s};
                 if sum(MatchMatrix_Onesub(p,:))>0;   
                    Target_Patch_SubNum(p,s) = 1;  
                 end
              end
          end
          Ref_MatchPatch = sum(Target_Patch_SubNum,2);          
          Ref_MatchPatch(Ref_MatchPatch<MatchThreshold*length(SubIDs)) = 0;
          Ref_MatchPatch(Ref_MatchPatch>=MatchThreshold*length(SubIDs))=1;
     
          ExcludePatch = find(Ref_MatchPatch==0);
         
          % Save selected consistent Patch in the reference,Atlas
            ExcludePatch_Index = [];
            if ~isempty(ExcludePatch)
                for ep = 1:length(ExcludePatch)
                    ExcludePatch_Index = [ExcludePatch_Index;find(Ref_Patches==ExcludePatch(ep))];
                end
                Ref_Patches(ExcludePatch_Index) = 0;
            end
         
            Selected_Patch = unique(Ref_Patches(Ref_Patches>0));
            
           if length(Selected_Patch)<1
              disp(['!!! Warning: MatchThreshold ',num2str(MatchThreshold), ' is TOO LARGE, Do not find consistent ROIs in NET ' num2str(n+1)])
           end
                    
            AllSelected_Patches(n) = length(Selected_Patch);
            
            % save the selected and matched ROIs on group atlas
            if ~exist([OutDir_MatchedGrp '/Net_' num2str(n+1)],'dir')
                mkdir([OutDir_MatchedGrp '/Net_' num2str(n+1)]);
            end
            for i = 1:length(Selected_Patch)
                Index = find(Ref_Patches==Selected_Patch(i));
                Map = zeros(2562,1);
                Map(Index) = 1;
                save_mgh(Map,[OutDir_MatchedGrp '/Net_' num2str(n+1) '/GrpTmplate_Net_' num2str(n+1) '_ROIs_' num2str(i) '_' hemi '.mgh'],eye(4));            
            end
        
        %% Individualized ROIs
        
        for s = 1:length(SubIDs)
            sub = SubIDs{s};
            if ~exist([OutDir '/Net_' num2str(n+1) '/' sub],'dir')
               mkdir([OutDir '/Net_' num2str(n+1) '/' sub]);
            end
            
            for p = 1:length(Selected_Patch)
                if exist([InPath '/Net_' num2str(n+1) '/' sub '/Patch_' num2str(Selected_Patch(p)) '_' hemi '.mgh']);

                    Patch = load_mgh([InPath '/Net_' num2str(n+1) '/' sub '/Patch_' num2str(Selected_Patch(p)) '_' hemi '.mgh']);
                    Net = load_mgh([IterPath '/' sub '/Iter_10/Network_' num2str(n+1) '_' hemi '.mgh']);
                    FinalROIs = Patch'.*Net;
                    save_mgh(FinalROIs,[OutDir '/Net_' num2str(n+1) '/' sub '/Net_' num2str(n+1) '_ROIs_' num2str(p) '_' hemi '.mgh'],eye(4));
   
                end

            end
        end
    end
    %repace the previously saved ROINum
   save([OutDir_MatchedGrp '/AllSelected_Patches_' hemi '.mat'],'AllSelected_Patches');
   clear AllSelected_Patches

end

fprintf(['\n Matched ROIs have generated, please checking the results here : \n ' OutDir '\n ']);
