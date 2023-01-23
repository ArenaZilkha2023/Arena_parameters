%% Plot Plot a bar plot to compare submissive and dominant
clear all;
day=6;
MouseNumber=5;

sheet={'Exp38LPerDay';'Exp37LPerDay'};% 70R wt and 70L NK
%[FileName,PathName] = uigetfile('*.xlsx','Select the first file');
FileName=['AllTheParametersPerDay.xlsx'];
PathName=['A:\ItzikExperiments\IDO fm\qPCR\ResultsParameters\'];

%% Load the respective excel files
for experiment=1:2
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
% Get average for all mice for each exp and each parameter.
for mouse=1:2
    Average=[];
    ErrorST=[];
    DataExtraction=[];
   [Average,ErrorST,DataExtraction]=MeanStdEForParameter(Data,day,Parameters,RowEachParameter,mouse); 
    AverageExp(:,mouse)=Average';
    ErrorSTExp(:,mouse)=ErrorST';
    if mouse==1
    DataExtractionExp1=DataExtraction; % for the dominant and submissive
    else
       DataExtractionExp2=DataExtraction; 
    end
end
AverageExpTotal=[AverageExp(:,1),AverageExp(:,2)];
ErrorExpTotal=[ErrorSTExp(:,1),ErrorSTExp(:,2)];
%% Do ttest for each parameter
for countParameter=1:size(Parameters,1)
   [h,p(countParameter,1)]= ttest2( DataExtractionExp1(:,countParameter), DataExtractionExp2(:,countParameter));
    
    
end
%% Sort according less pvalue
[~,IndexSort]=sort(p);
p=p(IndexSort);
AverageExpTotal=AverageExpTotal(IndexSort,:);
ErrorExpTotal=ErrorExpTotal(IndexSort,:);
Parameters=Parameters(IndexSort,1);
%%
Newraw(1,1)={'Parameters'};
Newraw(1,2)={'Dominant Mean'};
Newraw(1,3)={'Dominant SE'};
Newraw(1,4)={'Submissive Mean'}; %NK are mice which received a medication
Newraw(1,5)={'Submissive SE'};
Newraw(1,6)={'p value of t-test for dominant and submissive'};

Newraw(2:size(Parameters,1)+1,1)=Parameters;
Newraw(2:size(Parameters,1)+1,2)=num2cell(AverageExpTotal(:,1));
Newraw(2:size(Parameters,1)+1,3)=num2cell(ErrorExpTotal(:,1));
Newraw(2:size(Parameters,1)+1,4)=num2cell(AverageExpTotal(:,2));
Newraw(2:size(Parameters,1)+1,5)=num2cell(ErrorExpTotal(:,2));
Newraw(2:size(Parameters,1)+1,6)=num2cell(p);

xlswrite(fullfile(PathName,'DomvsSubSecondDay.xlsx'),Newraw,'famales');
%% Plot
figure
for countP=1:size(AverageExpTotal,1)
    
   subplot(11,6,countP)
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
  xticklabels({'Alpha','Submissive'})
 
end
 text(10,-5,'Second Stage','FontSize',14,'Color','red')