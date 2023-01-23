function  ManagerClustering(~,~)
%Open parameters and do clustering
%% 
%%--- Variables-----------------
global h
NumberMouse=str2num(get(h.editMousePCA,'String'));

FromDay=str2num(get(h.editDaysPCAf,'String'));
ToDay=str2num(get(h.editDaysPCAt,'String'));

cc=jet(NumberMouse);%for getting colors
%% -----------------------Read variables of the gui------------------------

%-------------------Select the experiments-------------------
index_selected = get(h.listRunParamsPCA,'Value');
list = get(h.listRunParamsPCA,'String');
item_selected = list(index_selected,1); % Convert from cell array

ExpList=item_selected'; %Input Data

%-----------------------Select the locomotion/social parameters------------------

index_selectedParams = get( h.listParamsPCA,'Value');
listParams = get( h.listParamsPCA,'String');
item_selectedParams = listParams(index_selectedParams,1); % Convert from cell array

ExpListParams=item_selectedParams'; %Input Data





% %% -----------Clear variables--------------
ExpTable=[];
MiceList={};
ExpName={};
ExpTableStandarize=[];
ExpRank=[];
%% ------------------------------Begin the program--------------------
%--Begin loop into each experiment
for i=1:length(ExpList)
%%---Clear Auxiliary variables-----------
clear AuxExpTable;
clear AuxMiceList;
clear AuxRank;
clear AuxExpTableW;

%% ---------------------Extract the intrested parameters for each experiment and arrange into column all the parameters-----------------
   [AuxExpTableW,AuxMiceList,AuxRank]=ExtractParametersClustering(ExpList(i),NumberMouse,FromDay,ToDay,ExpListParams);
   %% ------------------------Do scoring to each experiment
    
   AuxExpTable=StandarizeOutputClustering(AuxExpTableW);
  % AuxExpTable=AuxExpTableW;
   
%% ------------------------Join the experiments into the same table columns are parameters and rows are observations-------------------------------------

   ExpTable=[ExpTable;AuxExpTable];
   MiceList=[MiceList;AuxMiceList];
   ExpName=[ExpName;repmat(ExpList(i),size(AuxExpTable,1),1)];
   ExpRank=[ExpRank;AuxRank]; 
end
%% ----Close the experiment
%%
%--------------------------Do zscore of each variable column in the case of scoring all the experiments---------------------------
 % ExpTableStandarize=StandarizeOutputClustering(ExpTable);
   ExpTableStandarize=ExpTable;
%% --------------------------Calculate principal component algoritm--------------------
[coeff,score,latent,~,explained,~] = pca(ExpTableStandarize);

%% ---------Cluster the score data and get the david bouldin parameter which tell you the optimal number of cluster with the less BD value---
[OptimalCluster,DBvalues,Cdominant,Csubmisse,DB]=ClusterPCAClustering(score,ExpRank);



%% ---------------------------Plot into the parameters excel file the result
PCAsheet=plotPCAClustering(score,MiceList,ExpRank,Cdominant,Csubmisse);
%% ---------Insert the  parameters used into a matrix------
rawN{1,1}='List of experiments';
rawN(2:size(ExpList',1)+1,1)=ExpList';

rawN{1,2}='Parameters selected';
rawN(2:size(ExpListParams',1)+1,2)=ExpListParams';

rawN{1,3}='Score';
%% --------------Put the titles------------------


%% --------titles for principal components
for i=1:length(ExpListParams)
rawN(1,3+i)={strcat('Principal component',num2str(i))};
end

rawN(2:size(score,1)+1,4:size(score,2)+3)=num2cell(score);


rawN{1,size(score,2)+4}='Exp name';
rawN(2:size( ExpName,1)+1,size(score,2)+4)= ExpName;

rawN{1,size(score,2)+5}='Mice list';
rawN(2:size( MiceList,1)+1,size(score,2)+5)= MiceList;

rawN{1,size(score,2)+7}='Variance of autovalue-latent';
rawN(2:size(latent,1)+1,size(score,2)+7)=num2cell(latent);

rawN{1,size(score,2)+8}='Explained';
rawN(2:size(explained,1)+1,size(score,2)+8)=num2cell(explained);


rawN{1,size(score,2)+9}='David Bouldin values for 5 clusters';
rawN(2:size(DBvalues',1)+1,size(score,2)+9)=num2cell(DBvalues');

rawN{1,size(score,2)+10}='David Bouldin best cluster number';
rawN(2:size(OptimalCluster',1)+1,size(score,2)+10)=num2cell(OptimalCluster');

rawN{1,size(score,2)+11}='David Bouldin for dominant and submissibe cluster';
rawN(2:size(DB',1)+1,size(score,2)+11)=num2cell(DB);
%% ------------)--Insert into excel file the results of the principal component--------------------

xlswrite(get(h.editRunParamsPCA,'string'),rawN,PCAsheet)





end


