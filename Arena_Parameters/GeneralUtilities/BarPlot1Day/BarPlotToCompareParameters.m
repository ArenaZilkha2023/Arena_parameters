%% Plot Plot a bar plot to compare different files
clear all;
day=1;
MouseNumber=5;
NumWtexp=5; % number of wild type exp which are the first one
sheet={'Exp19LPerDay';'Exp23LPerDay';'Exp63RPerDay';'Exp27LPerDay';'Exp44RPerDay';'Exp69LPerDay';'Exp69RPerDay'};% 69L wt and 69R mutant
%% Load the respective excel files
for experiment=1:7
    
   [FileName,PathName] = uigetfile('*.xlsx','Select the first file'); %70 Rwt right % 70Lnk Left
   %create multidimensional matrix with the experiments 
   [~,~,raw]=xlsread(fullfile(PathName,FileName),char(sheet(experiment)));
   Data(:,:,experiment)=raw;
   if experiment==1 %only do in the first experiment
   [Parameters1,RowEachParameter1]=getParameters(raw(:,1));
    Parameters=Parameters1(1:size(Parameters1,1)-2,1); %Remove david score and average eloration
    RowEachParameter=RowEachParameter1(1:size(Parameters1,1)-2,1); 
   end
end

%% Get the mean of the first 6 experiments
WtData=Data(:,:,1:NumWtexp);
[AverageWt,ErrorSTWt,DataExtractionWt]=MeanStWt(WtData,day,Parameters,RowEachParameter,MouseNumber,NumWtexp);

%% With the data ,sheet, and parameters run function through each parameter 
for experiment=6:7
    Average=[];
    ErrorST=[];
    DataExtraction=[];
   [Average,ErrorST,DataExtraction]=MeanStdEForParameter(Data(:,:,experiment),day,Parameters,RowEachParameter,MouseNumber); 
    AverageExp(:,experiment)=Average';
    ErrorSTExp(:,experiment)=ErrorST';
    DataExtractionExp(:,:,experiment)=DataExtraction;
end
AverageExpTotal=[AverageWt,AverageExp(:,6),AverageExp(:,7)];
ErrorExpTotal=[ErrorSTWt,ErrorSTExp(:,6),ErrorSTExp(:,7)];
%% Do ttest for each parameter
for countParameter=1:size(Parameters,1)
   [h,p(countParameter,1)]= ttest2( cell2mat(DataExtractionExp(:,countParameter,6)), cell2mat(DataExtractionExp(:,countParameter,7)));
    
    
end
%% Sort according less pvalue
[~,IndexSort]=sort(p);
p=p(IndexSort);
AverageExpTotal=AverageExpTotal(IndexSort,:);
ErrorExpTotal=ErrorExpTotal(IndexSort,:);
Parameters=Parameters(IndexSort,1);
%%
Newraw(1,1)={'Parameters'};
Newraw(1,2)={'mean lab males'};
Newraw(1,3)={'SE lab males'};
Newraw(1,4)={'mean wt'};
Newraw(1,5)={'SE wt'};
Newraw(1,6)={'mean mutant'};
Newraw(1,7)={'SE mutant'};
Newraw(1,8)={'p value of t-test for mutant and wt'};

Newraw(2:size(Parameters,1)+1,1)=Parameters;
Newraw(2:size(Parameters,1)+1,2)=num2cell(AverageExpTotal(:,1));
Newraw(2:size(Parameters,1)+1,3)=num2cell(ErrorExpTotal(:,1));
Newraw(2:size(Parameters,1)+1,4)=num2cell(AverageExpTotal(:,2));
Newraw(2:size(Parameters,1)+1,5)=num2cell(ErrorExpTotal(:,2));
Newraw(2:size(Parameters,1)+1,6)=num2cell(AverageExpTotal(:,3));
Newraw(2:size(Parameters,1)+1,7)=num2cell(ErrorExpTotal(:,3));
Newraw(2:size(Parameters,1)+1,8)=num2cell(p);

xlswrite(fullfile(PathName,'NuritExp.xlsx'),Newraw,'Nurit exp');
%% Plot
figure
for countP=1:size(AverageExpTotal,1)
    
   subplot(12,5,countP)
%    x=[1,2];
%    y=[AverageExp(countP,1),AverageExp(countP,2)];
%    e=[ErrorSTExp(countP,1),ErrorSTExp(countP,2)];

    x=[1,2,3];
   y=[AverageExpTotal(countP,1),AverageExpTotal(countP,2),AverageExpTotal(countP,3)];
   e=[ErrorExpTotal(countP,1),ErrorExpTotal(countP,2),ErrorExpTotal(countP,3)];


   bar(x,y,0.6);
   title(strcat(char(Parameters{countP}),'pv=',num2str(p(countP))),'FontSize', 8);
   hold on
   errorbar(y',e','.')
  hold off
  xticklabels({'Lab Males','WT','mutant'})
 
end
 text(10,0,'First day','FontSize',14,'Color','red')