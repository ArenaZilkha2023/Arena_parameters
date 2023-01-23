%% Plot Plot a bar plot to compare different files
clear all;
Firstday=2;
Finalday=6;
MouseNumber=5;

sheet={'Exp70RPerDay';'Exp70LPerDay'};% %70 Rwt right % 70Lnk Left
%% Load the respective excel files
for experiment=1:2
    
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



%% With the data ,sheet, and parameters run function through each parameter 
for experiment=1:2
    Average=[];
    ErrorST=[];
    DataExtraction=[];
   [Average,ErrorST,DataExtraction]=MeanStdEForParameter(Data(:,:,experiment),Firstday,Finalday,Parameters,RowEachParameter,MouseNumber); 
    AverageExp(:,experiment)=Average';
    ErrorSTExp(:,experiment)=ErrorST';
    DataExtractionExp(:,:,experiment)=DataExtraction;
end
AverageExpTotal=[AverageExp(:,1),AverageExp(:,2)];
ErrorExpTotal=[ErrorSTExp(:,1),ErrorSTExp(:,2)];
%% Do ttest for each parameter
for countParameter=1:size(Parameters,1)
   [h,p(countParameter,1)]= ttest2( cell2mat(DataExtractionExp(:,countParameter,1)), cell2mat(DataExtractionExp(:,countParameter,2)));
    
    
end
%% Sort according less pvalue
[~,IndexSort]=sort(p);
p=p(IndexSort);
AverageExpTotal=AverageExpTotal(IndexSort,:);
ErrorExpTotal=ErrorExpTotal(IndexSort,:);
Parameters=Parameters(IndexSort,1);
%% 

Newraw(1,1)={'Parameters'};
Newraw(1,2)={'mean wt'};
Newraw(1,3)={'SE wt'};
Newraw(1,4)={'mean NK'};
Newraw(1,5)={'SE NK'};
Newraw(1,6)={'p value of t-test for mutant and wt'};

Newraw(2:size(Parameters,1)+1,1)=Parameters;
Newraw(2:size(Parameters,1)+1,2)=num2cell(AverageExpTotal(:,1));
Newraw(2:size(Parameters,1)+1,3)=num2cell(ErrorExpTotal(:,1));
Newraw(2:size(Parameters,1)+1,4)=num2cell(AverageExpTotal(:,2));
Newraw(2:size(Parameters,1)+1,5)=num2cell(ErrorExpTotal(:,2));
Newraw(2:size(Parameters,1)+1,6)=num2cell(p);

xlswrite(fullfile(PathName,'AmitExpSecondPhase.xlsx'),Newraw,'Nurit exp');
%% Plot
figure
for countP=1:size(AverageExpTotal,1) %Remove time together error
    
   subplot(12,5,countP)
%    x=[1,2];
%    y=[AverageExp(countP,1),AverageExp(countP,2)];
%    e=[ErrorSTExp(countP,1),ErrorSTExp(countP,2)];

    x=[1,2];
   y=[AverageExpTotal(countP,1),AverageExpTotal(countP,2)];
   e=[ErrorExpTotal(countP,1),ErrorExpTotal(countP,2)];


   bar(x,y,0.6);
   title(strcat(char(Parameters{countP}),'pv=',num2str(p(countP))),'FontSize', 8);
   hold on
   errorbar(y',e','.')
  hold off
  xticklabels({'WT','NK'})
 
end
 text(10,0,'From second to six day','FontSize',14,'Color','red')