function [subset1,labels1,ReorderRaw,RawStage1,RawStage2]=BarPlotToCompareParameters(sheet,Filename,Firstday,Finalday,location1,location2,NumberPlaces,clocal,MouseNumber,locationL,subset1,labels1,flag)
%% Load the respective excel files
for experiment=1:size(sheet,2)
   %create multidimensional matrix with the experiments 
   [~,~,raw]=xlsread(Filename,sheet{experiment});
   Data(:,:,experiment)=raw;
   if experiment==1 %only do in the first experiment
   [Parameters1,RowEachParameter1]=getParameters(raw(:,1));
    Parameters=Parameters1(1:size(Parameters1,1)-2,1); %Remove david score and average eloration
    RowEachParameter=RowEachParameter1(1:size(Parameters1,1)-2,1); 
   end
end
initialsize=size(labels1,2);
%% Find number of parameter with elorating for later use
I=strfind(Parameters,'Elorating');
t=[];
j=0
while isempty(t)==1
    j=j+1;
    t=I{j,1};
    
end
Ielorating=j;
%% With the data ,sheet, and parameters run function through each parameter 
%% For the first stage
 DataExtractionExp1=[];
for experiment=1:size(sheet,2)
    Average=[];
    ErrorST=[];
    DataExtraction=[];
   [Average,ErrorST,DataExtraction]=MeanStdEForParameter(Data(:,:,experiment),1,1,Parameters,RowEachParameter,MouseNumber,Ielorating); 
    AverageExp1(:,experiment)=Average';
    ErrorSTExp1(:,experiment)=ErrorST';
    DataExtractionExp1=[DataExtractionExp1; cell2mat(DataExtraction)];
end


AverageTotalStage1=(sum(DataExtractionExp1,1,'omitnan')/(size(DataExtractionExp1,1)))';
StandardDesviationStage1=(std(DataExtractionExp1,1,'omitnan')/sqrt(size(DataExtractionExp1,1)))';
%StandardDesviationStage1=(std(DataExtractionExp1,1,'omitnan'))';
StandardDesviationStageO1=std(DataExtractionExp1,1,'omitnan');


%% For the second stage
DataExtractionExp2=[];
for experiment=1:size(sheet,2)
    Average=[];
    ErrorST=[];
    DataExtraction=[];
   [Average,ErrorST,DataExtraction]=MeanStdEForParameter(Data(:,:,experiment),Firstday,Finalday,Parameters,RowEachParameter,MouseNumber,Ielorating); 
    AverageExp2(:,experiment)=Average';
    ErrorSTExp2(:,experiment)=ErrorST';
    %%
     DataExtractionExp2=[DataExtractionExp2; cell2mat(DataExtraction)];
end
AverageTotalStage2=(sum(DataExtractionExp2,1,'omitnan')/(size(DataExtractionExp2,1)))';
StandardDesviationStage2=(std(DataExtractionExp2,1,'omitnan')/sqrt(size(DataExtractionExp2,1)))';
StandardDesviationStageO2=std(DataExtractionExp2,1,'omitnan');


%% Plot

for countP=1:size(AverageTotalStage2,1) % Loop over parameter
 %%
   subplot(11,6,countP)
   x1=location1*ones(1,size(AverageExp1,2));
   y1=AverageExp1(countP,:); %each parameter is a row
  sz=25;
  colors={'r','b','g','y','m','c'};
  P1T=[];
  for i=1:length(x1)
   % p1=scatter(x1(i),y1(i),sz,'filled',colors{i});
    p1=plot(x1(i),y1(i),'o',  'MarkerSize',4,...
    'MarkerEdgeColor',clocal(i,:),...
    'MarkerFaceColor',clocal(i,:));
   P1T=[P1T;p1];
   hold on;
  end
 % axis tight
  hold on;
   x2=location2*ones(1,size(AverageExp2,2));
   y2=AverageExp2(countP,:); %each parameter is a row
   P2T=[];
    for i=1:length(x2)
   % p2=scatter(x2(i),y2(i),sz,'filled',colors{i});
   p2=plot(x2(i),y2(i),'o',  'MarkerSize',4,...
    'MarkerEdgeColor',clocal(i,:),...
    'MarkerFaceColor',clocal(i,:));
   P2T=[P2T;p2];
   hold on;
    end
    
  %   axis tight
  % plot the average of the all

  Pa1=scatter(location1,AverageTotalStage1(countP,1),sz,'filled','k');
  scatter(location2,AverageTotalStage2(countP,1),sz,'filled','k');
  errorbar(location1,AverageTotalStage1(countP,1),2*StandardDesviationStage1(countP,1),'CapSize',15)
  errorbar(location2,AverageTotalStage2(countP,1),2*StandardDesviationStage2(countP,1),'CapSize',15)
  % errorbar(1,AverageTotalStage1(countP,1),0.1,'CapSize',0,'horizontal')
  %errorbar(2,AverageTotalStage2(countP,1),0.1,'CapSize',0,'horizontal')
 xlim([0 NumberPlaces])
    title(char(Parameters{countP}),'FontSize', 8);
    xticks([0 1 2 3 4 5 6 7])
  xticklabels({'','1S-M','2S-M','1S-K','2S-K','1S-F','2S-F',' '}) 
   ax=gca;
   ax.FontSize=7.8;
%    hold on
%    errorbar(y',e','.')
%   hold off
%   xticklabels({'WT','NK'})
%  subset=[P1T;Pa1];
%   labels={sheet{1:size(sheet,2)},'Total Average'};
% legend(subset,labels,'bestoutside')
end
 subset=[P1T;Pa1];
%    xticklabels({'','1S-M','2S-M','1S-K','2S-K','1S-F','2S-F',' '}) 
%    ax=gca;
%    ax.FontSize=8;
subset1=[subset1;subset];
sheet1=sheet';
 labels=[sheet1(1:size(sheet1,1),1);'Total Average'];
 labels1=[labels1;labels];
if flag==1
 legend(subset1,labels1,'Location','bestoutside')
end
hold on;
%text(10,0,'From second to six day','FontSize',14,'Color','red')

%% 
%% Table of parameters

[ReorderRaw,RawStage1,RawStage2,]=ReorderData(Parameters,AverageExp1,AverageExp2,labels,AverageTotalStage1,AverageTotalStage2,StandardDesviationStageO1,StandardDesviationStageO2)
end

