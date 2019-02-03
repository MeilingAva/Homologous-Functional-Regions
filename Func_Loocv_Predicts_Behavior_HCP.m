function [PredictY,FeaturesWeight,SelectedFeatureNumber] = Func_Loocv_Predicts_Behavior_HCP(X_Features,Y_score,SIDs,covariates,pth)

% function, leave-one-out cross-validation
% Process: feature selection, model construction and prediction
% Input:
% X_Features: all the features, SubsNum* FeatureNums
% Y_score: The target label, SubNum*1;
% p_th: threshold used to selecte features

% Output:
% All_SelectedF:Selected Features in each LOOCV
% All_SelectedW: weight for each selected features
% 20171102, Meiling

addpath(genpath('/mnt/sp5/SoftWare/liblinear-2.1'));

% create family ID
S = zeros(size(SIDs,1),1); 
for n = 1:size(SIDs,1); 
    S(n,1) = str2double(SIDs{n}); 
end; 
subs_all = S; clear n
[EB,FamilyTable] = hcp2blocks(['/mnt/sp4/IndiROI/Lists/RESTRICTED_meiling_3_28_2018_21_1_51.csv'],'',false,subs_all);
familyIDs = FamilyTable(:,5);
familyIDs_unit = unique(familyIDs);


%% Initialization
SelectedFeatureNumber = zeros(length(SIDs),1);
FeaturesWeight = zeros(length(familyIDs_unit),size(X_Features,2));

%% Leave one family prediction
index = 1:length(SIDs);
for f = 1:length(familyIDs_unit)
    familyID = familyIDs_unit(f);
    s = find(familyIDs == familyID);

    test_ind = s;
    train_ind = index;
    train_ind(s) = [];

    Y_train = Y_score(train_ind);
    Y_test = Y_score(test_ind);

    X_test = squeeze(X_Features(test_ind,:));
    X_train = squeeze(X_Features(train_ind,:));

    %% Prepare Covariates
    covariates_train = covariates(train_ind,:);
    covariates_test = covariates(test_ind,:);
    % demean 
    covariates_mean = mean(covariates_train,1);
    covariates_train = covariates_train-repmat(covariates_mean,[length(train_ind) 1]);
    covariates_test = covariates_test-repmat(covariates_mean,[length(test_ind) 1]);
        
    %% Regressing covariates from behavior
    [yb,bint,r,rint,stats] = regress(Y_train,[ones(length(train_ind),1) covariates_train]);
    Y_train = Y_train-covariates_train*yb(2:end);%
    Y_test = Y_test-covariates_test*yb(2:end);%

    %% Regressing covariates from features
    for i = 1:size(X_train,2)
        [b,bint,r_tmp,rint,stats] = regress(X_train(:,i),[ones(length(train_ind),1) covariates_train]);     
        X_train(:,i) = X_train(:,i)-covariates_train*b(2:end);
        X_test(:,i) = X_test(:,i)-covariates_test*b(2:end);
    end   
    
    %% Feature selection
    [R,P] = corr(Y_train,X_train,'type','pearson');

    ind = find(P<pth);
    SelectedFeatureNumber(s) = length(ind);
    X_train_selected = X_train(:,ind);  
    X_test_selected = X_test(:,ind);
    
    %% Model
    cmd = ['-s 11'];% c: default 1
    model = train(Y_train, sparse(X_train_selected),cmd);
    
    %% test
    [~,~,PredictY(s,1)] = predict(Y_test, sparse(X_test_selected), model);
    PredictY(s,1) = PredictY(s,1)+covariates_test*yb(2:end);
    
    FeaturesWeight(f,ind) = model.w; 
end




