function edge_mean_Grp = Func_Average_ROI2ROI_FC(InPath,SubIDs)

% Read the correlation matrix of each subject, The first group
for s = 1:length(SubIDs)
    subname = SubIDs{s};

    load([InPath '/' subname '_big_corr_z.mat']);
    corr_mat_big(s,:,:) = CorrMat;
end

%% Calculate the mean value for each edge, the subject losts that edge will be excluded
k = 0;
for r1 = 1:size(corr_mat_big,2)
    for r2 = 1:size(corr_mat_big,2)
        k = k+1;
        Grp_edge = corr_mat_big(:,r1,r2);

        exclude_sub = find(Grp_edge==0);
        Grp_edge(exclude_sub) = [];
        edge_mean_Grp(r1,r2) = mean(Grp_edge);

    end
end


edge_mean_Grp(logical(eye(size(edge_mean_Grp)))) = 0;  


 