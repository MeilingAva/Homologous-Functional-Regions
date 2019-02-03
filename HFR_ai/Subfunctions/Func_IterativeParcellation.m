function[] = Func_IterativeParcellation(ProgramPath,InPath,SubIDs,numIter,confidence_threshold, combineLeftRight)

% lhData should be fs4 surface residual matrix, 2562 x time
OutPath = [InPath '/IndiPar'];
mkdir(OutPath);


% Load distance matrix, which will be used for smooth the vertex-vertex
% correlation
load([ProgramPath '/Utilities/fs4_Firstadjacent_vertex.mat']);

% Load individual variability obtained from muller et al, Neuro, 2013
load([ ProgramPath '/Utilities/Variability_FS4.mat']);
Prior_Variability = ([lh; rh])';%Prior_Variability:0.5~0.8
Prior_SNR = ones(1, 2562*2);

hwait = waitbar(0,'Individual parcellation');
for s = 1:length(SubIDs)
    sub = SubIDs{s};
    fprintf(['Individual Parcellation ' num2str(s) ':' sub '\n']);
    str = ['Individual parcellation:' num2str(s) '/' num2str(length(SubIDs)) ', please wait!'];
    waitbar(s/length(SubIDs),hwait,str);
    load([InPath '/OrganizedData/' sub '_timeframes_fs4.mat']); %lhData rhData
    

    seedDatalh = [];
    seedDatarh = [];

    n = size(lhData,1);
    m = size(rhData,1);

    %%%%%%%%%% Think about the priors, Could include variability and SNR
    if range(Prior_Variability) > 0
        Prior_Variability = 0.4 + 0.6*(Prior_Variability- min(Prior_Variability))/(max(Prior_Variability) - min(Prior_Variability)); % normalize the range to 0.4 ~1. Therefore the inv will be between 1~2.5.
    end

    var_lh = Prior_Variability(1:n);
    var_rh = Prior_Variability(n+1:end);

    varInv_lh = 1./var_lh;
    varInv_rh = 1./var_rh;

    if range(Prior_SNR) >0
        Prior_SNR = 0.4+  0.6*(Prior_SNR- min(Prior_SNR))/(max(Prior_SNR) - min(Prior_SNR)) ; % normalize the range to 0.4 ~1. Therefore the inv will be between 1~2.5.
    end

    SNR_lh = Prior_SNR(1:n);
    SNR_rh = Prior_SNR(n+1:end);

    % ---------------------------------------------------
    %% Iterative parcellation
    % ---------------------------------------------------
    
    mkdir([OutPath '/' sub]);
    for cnt = 1:numIter
        
        mkdir([OutPath '/' sub '/Iter_' num2str(cnt)]);


        if cnt==1
            [vol, M, mr_parms, volsz] = load_mgh([ProgramPath '/Templates/Parcellation_template/lh_network_',num2str(1),'_asym_fs4.mgh']); %ROI_par_40_' num2str(i2) '_lh.mgh']);
            ventLh = find(vol>0);
            GrpNetlh{1}= ventLh;
            [vol, M, mr_parms, volsz] = load_mgh([ProgramPath '/Templates/Parcellation_template/rh_network_',num2str(1),'_asym_fs4.mgh']);
            ventRh =find(vol>0);
            GrpNetrh{1}= ventRh;
            for i2=1:18  % get the seed waveforms based on Thomas' parcellation, and weight it by inv(Variability)
                [vol, M, mr_parms, volsz] = load_mgh([ProgramPath '/Templates/Parcellation_template/lh_network_',num2str(i2+1),'_asym_fs4.mgh']); %ROI_par_40_' num2str(i2) '_lh.mgh']);
                idx =find(vol>0);

              
                seedDatalh(i2,:)= varInv_lh(idx)*lhData(idx,:); % weight the group map using the inverse of individual difference
                GrpNetlh{i2+1} = idx;

                [vol, M, mr_parms, volsz] = load_mgh([ProgramPath '/Templates/Parcellation_template/rh_network_',num2str(i2+1),'_asym_fs4.mgh']); %ROI_par_40_' num2str(i2) '_lh.mgh']);
                idx =find(vol>0);

              
                seedDatarh(i2,:)= varInv_rh(idx)*rhData(idx,:); % weight the group map using the inverse of individual difference
                GrpNetrh{i2+1} = idx;
     
            end
            GrpSeedDatalh =seedDatalh;
            GrpSeedDatarh =seedDatarh;

        else

            for i2 = 1:18  % get the seed waveforms based on the last parcellation
                [vol, M, mr_parms, volsz] = load_mgh([OutPath '/' sub '/Iter_' num2str(cnt-1) '/NetworkConfidence_' num2str(i2+1) '_lh.mgh']);
                vol(isnan(vol)) = 0;
                idx = find(vol>=confidence_threshold);
                if isempty(idx)
                    maxx = max(max(max(vol)));
                    idx = find(vol==maxx);
                end


                seedDatalh(i2,:) = SNR_lh(idx)*lhData(idx,:); % weight the individual signal based on SNR
                [vol, M, mr_parms, volsz] = load_mgh([OutPath '/' sub '/Iter_' num2str(cnt-1) '/NetworkConfidence_' num2str(i2+1) '_rh.mgh']);
                vol(isnan(vol)) = 0;
                idx = find(vol>=confidence_threshold);
                if isempty(idx)
                    maxx = max(max(max(vol)));
                    idx = find(vol==maxx);
                end

                seedDatarh(i2,:)= SNR_rh(idx)*rhData(idx,:);

            end
        end

        %% Weight in the group seed in each iteration, should throw in individual variability map as weight in the future

        if cnt>1
            seedDatalh = seedDatalh + GrpSeedDatalh/(cnt-1);
            seedDatarh = seedDatarh + GrpSeedDatarh/(cnt-1);
        end


        % Combine the same network of left hemi and right hemi?,
        % If not, uncomment the following 3 lines

        % if combine the two hemisphere, the impact of other hemisphere is decreasing during iteration
        if (combineLeftRight)
            tmp = seedDatalh;
            seedDatalh = seedDatalh+seedDatarh/(cnt+2);
            seedDatarh = seedDatarh+tmp/(cnt+2);
  
        end



        % compute vertex to seed correlation for all vertices

        cValuelh = zeros(size(lhData,1),size(seedDatalh,1));
        cValuerh = zeros(size(rhData,1),size(seedDatarh,1));


        data = [seedDatalh;lhData];
        tmp = corrcoef(data');
        cValuelh = tmp(1:size(seedDatalh,1),end-2561:end)'; % 2562*seeds

        data = [seedDatarh;rhData];
        tmp = corrcoef(data');
        cValuerh = tmp(1:size(seedDatarh,1),end-2561:end)'; % 2562*seeds 

        cValuelh = 0.5*log((1+cValuelh)./(1-cValuelh));
        cValuerh = 0.5*log((1+cValuerh)./(1-cValuerh));

        cValuelh(isnan(cValuelh(:)))=0;
        cValuerh(isnan(cValuerh(:)))=0;



        % Smooth, decrease the noise
        for i = 1:2562
            cValuelhS(i,:) = mean(cValuelh(fs4_Firstadjacent_vertex_lh{i},:),1);
            cValuerhS(i,:) = mean(cValuerh(fs4_Firstadjacent_vertex_rh{i},:),1);

        end

        cValuelh = cValuelhS;
        cValuerh = cValuerhS;

    
        % Further weight in the group map * inv(Variability) by adding correlation coefficient of 0~ 0.5 according to inv(Variability).

        for i = 1:18
            idx = GrpNetlh{i+1};
            cValuelh(idx, i) = cValuelh(idx, i) + (((varInv_lh(idx)-1)/3)/cnt)';

            idx = GrpNetrh{i+1};
            cValuerh(idx, i) = cValuerh(idx, i) + (((varInv_rh(idx)-1)/3)/cnt)';
        end

        % --------------------------------------------------------
        %%  Determine the network membership of each vertex
        % ------------  Left hemisphere---------------------------
       
        data=cValuelh(:,1:18);
        for v=1:size(data,1)

            [cor idx] = sort(data(v,:),'descend');
            parc_membership(v) = idx(1);
            parc_confidence(v) = cor(1)/cor(2);

        end


      
        for n =1:18
            network = 0*parc_membership;
            confid = 0*network;
            network(find(parc_membership==n))= 1;
            confid(find(parc_membership==n))= parc_confidence(find(parc_membership==n));

            network(ventLh) = 0; % mask out the ventrical and useless areas in the midline
            network(isnan(network)) = 0;
         
            save_mgh(network,[OutPath '/' sub '/Iter_' num2str(cnt) '/Network_' num2str(n+1) '_lh.mgh'],eye(4));
            save_mgh(network.*confid,[OutPath '/' sub '/Iter_' num2str(cnt) '/NetworkConfidence_' num2str(n+1) '_lh.mgh'],eye(4));
        end

        
        % --------------------------------------------------------
        %%  Determine the network membership of each vertex
        % ------------  Right hemisphere---------------------------

        data=cValuerh(:,1:18);
        for v=1:size(data,1)

            [cor idx] = sort(data(v,:),'descend');
            parc_membership(v) = idx(1);
            parc_confidence(v) = cor(1)/cor(2);


        end

        for n =1:18
            network = 0*parc_membership;
            confid = 0*network;
            network(find(parc_membership==n))= 1;
            confid(find(parc_membership==n))= parc_confidence(find(parc_membership==n));
            network(ventRh) = 0; % mask out the ventrical and useless areas in the midline

         
            save_mgh(network,[OutPath '/' sub '/Iter_' num2str(cnt) '/Network_' num2str(n+1) '_rh.mgh'],eye(4));
            save_mgh(network.*confid,[OutPath '/' sub '/Iter_' num2str(cnt) '/NetworkConfidence_' num2str(n+1) '_rh.mgh'],eye(4));
        end




        eval(['!cp ' ProgramPath '/Templates/Parcellation_template/lh_network_1_asym_fs4.mgh  ' OutPath '/' sub '/Iter_' num2str(cnt) '/Network_1_lh.mgh']); 

        eval(['!cp ' ProgramPath '/Templates/Parcellation_template/rh_network_1_asym_fs4.mgh  ' OutPath '/' sub '/Iter_' num2str(cnt) '/Network_1_rh.mgh']); 

        eval(['!cp ' ProgramPath '/Templates/Parcellation_template/lh_network_1_asym_fs4.mgh  ' OutPath '/' sub '/Iter_' num2str(cnt) '/NetworkConfidence_1_lh.mgh']);

        eval(['!cp ' ProgramPath '/Templates/Parcellation_template/rh_network_1_asym_fs4.mgh  ' OutPath '/' sub '/Iter_' num2str(cnt) '/NetworkConfidence_1_rh.mgh']);

    end
end

close(hwait);






