% This script plot different parameters of different types of experiments on the same plot, after average
% of each parameter on the all mice of the same type of experiment.
% Each type of experiment is divided into two stages, first and the rest of
% days

clear all;
Firstday=2;% for second stage
Finalday=6; % for second stage
MouseNumber=5;
figure;
NumberPlaces=7;
subset=[];
labels={};
%% First experiment 
location1=1
location2=2
flag=0;
sheet={ };
OutputFilename=char('X:\Users\Members\Silvia\YefimRawDataTrackingvs2\Presentations\ParametersLabfemalesWild.xlsx');
locationL='bestoutside';
Filename=char('X:\Users\Members\Silvia\YefimRawDataTrackingvs2\LabMales\AllParameters\AllTheParametersPerDay.xlsx');
[~,sheet] = xlsfinfo(Filename);
clocal=[];
clocal=cbrewer('qual','Paired',size(sheet,2));
%clocal1=cbrewer('qual','Paired',16);
%clocal=clocal1(1:2:15,:);
[subset,labels,ReorderRaw,RawStage1,RawStage2]=BarPlotToCompareParameters(sheet,Filename,Firstday,Finalday,location1,location2,NumberPlaces,clocal,MouseNumber,locationL,subset,labels,flag);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%save data
xlswrite(OutputFilename,ReorderRaw,'LabMales');
xlswrite(OutputFilename,RawStage1,'LabMalesOutlierFirstDay');
xlswrite(OutputFilename,RawStage2,'LabMalesOutlier2-6Day');
%% Second experiment 
location1=3
location2=4
flag=0;
sheet={ };
clear ReorderRaw;
clear RawStage1;
clear RawStage2;

Filename=char('X:\Users\Members\Silvia\YefimRawDataTrackingvs2\LabMalesTrpc--\AllParameters\AllTheParametersPerDay.xlsx');
[~,sheet] = xlsfinfo(Filename); %assign to each experiment a different color
clocal=[];
%clocal=cbrewer('qual','Paired',size(sheet,2));
clocal1=cbrewer('qual','Paired',16);
clocal=clocal1(1:2:15,:);

[subset,labels,ReorderRaw,RawStage1,RawStage2]=BarPlotToCompareParameters(sheet,Filename,Firstday,Finalday,location1,location2,NumberPlaces,clocal,MouseNumber,locationL,subset,labels,flag);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%save data
xlswrite(OutputFilename,ReorderRaw,'TPC2--');
xlswrite(OutputFilename,RawStage1,'TPC2--OutlierFirstDay');
xlswrite(OutputFilename,RawStage2,'TPC2--Outlier2-6Day');
%% Second experiment 
location1=5;
location2=6;
flag=1;
sheet={ };
clear ReorderRaw;
clear RawStage1;
clear RawStage2;

Filename=char('X:\Users\Members\Silvia\YefimRawDataTrackingvs2\LabFemales\AllParameters\AllTheParametersPerDay.xlsx');
[~,sheet] = xlsfinfo(Filename);

%clocal=cbrewer('qual','Paired',size(sheet,2));
%clocal1=cbrewer('qual','Paired',16);
%clocal=clocal1(1:2:15,:);
clocal=[];
%clocal={'r','b','g','y','m','c'};
clocal=[1 0 0;0 0 1;0 1 0;1 1 0;1 0 1;0 1 1];
[subset,labels,ReorderRaw,RawStage1,RawStage2]=BarPlotToCompareParameters(sheet,Filename,Firstday,Finalday,location1,location2,NumberPlaces,clocal,MouseNumber,locationL,subset,labels,flag);

xlswrite(OutputFilename,ReorderRaw,'LabFemales');
xlswrite(OutputFilename,RawStage1,'LabFemalesOutlierFirstDay');
xlswrite(OutputFilename,RawStage2,'LabFemalesOutlier2-6Day');