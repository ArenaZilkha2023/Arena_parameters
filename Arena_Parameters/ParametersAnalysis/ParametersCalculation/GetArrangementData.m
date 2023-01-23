function   raw=GetArrangementData(ParametersSum,IndexNewSort,...
                     ChasingEventsPerDay, BeingChasingEventsPerDay, ...
                     EloratingAveragePerDay,EloratingPerLastDay,InteractionMatrix,...
                     NormDSAll,NormDSAllD,NormDSAllDPerDay,TimeArray,RankingArray,ParametersSumTotalDetected,ParametersSumActiveTime);
% Order the data for each day


%% --------------------Arrange the data-Create an array by ordering according to elorating ranking --------------------------

raw{1,1}={'Days'};
raw(1,2)={'head chip / Days'};
raw(2,1)={'RunningTime(% of time)'};
raw(2:size(ParametersSum(:,1,:),1)+1,3:size(ParametersSum(:,1,:),3)+2)=num2cell(ParametersSumTotalDetected(IndexNewSort,1,:));
raw(2:size(ParametersSum(:,1,:),1)+1,2)=RankingArray(:,1);

Initialrow=1+size(ParametersSum(:,1,:),1)+2;
raw(Initialrow,1)={'WalkingTime(% of time)'};
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,3:size(ParametersSum(:,2,:),3)+2)=num2cell(ParametersSumTotalDetected(IndexNewSort,2,:));
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+2*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'StaticTime(% of time)'};
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,3:size(ParametersSum(:,2,:),3)+2)=num2cell(ParametersSumTotalDetected(IndexNewSort,3,:));
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+3*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'movementTime(% of time)'};
raw(Initialrow:size(ParametersSum(:,12,:),1)+Initialrow-1,3:size(ParametersSum(:,12,:),3)+2)=num2cell(ParametersSumTotalDetected(IndexNewSort,12,:));
raw(Initialrow:size(ParametersSum(:,12,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+4*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'sleepingSumTime(% of time)'};
raw(Initialrow:size(ParametersSum(:,6,:),1)+Initialrow-1,3:size(ParametersSum(:,6,:),3)+2)=num2cell(ParametersSumTotalDetected(IndexNewSort,6,:));
raw(Initialrow:size(ParametersSum(:,6,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+5*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'eatingSumTime(% of time)'};
raw(Initialrow:size(ParametersSum(:,4,:),1)+Initialrow-1,3:size(ParametersSum(:,4,:),3)+2)=num2cell(ParametersSumTotalDetected(IndexNewSort,4,:));
raw(Initialrow:size(ParametersSum(:,4,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+6*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'drinkingSumTime(% of time)'};
raw(Initialrow:size( ParametersSum(:,5,:),1)+Initialrow-1,3:size(ParametersSum(:,5,:),3)+2)=num2cell(ParametersSumTotalDetected(IndexNewSort,5,:));
raw(Initialrow:size(ParametersSum(:,5,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+7*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'hidingSumTime(% of time)'};
raw(Initialrow:size(ParametersSum(:,7,:),1)+Initialrow-1,3:size(ParametersSum(:,7,:),3)+2)=num2cell(ParametersSumTotalDetected(IndexNewSort,7,:));
raw(Initialrow:size(ParametersSum(:,7,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+8*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'ArenaSumTime(% of time)'};
raw(Initialrow:size(ParametersSum(:,8,:),1)+Initialrow-1,3:size(ParametersSum(:,8,:),3)+2)=num2cell(ParametersSumTotalDetected(IndexNewSort,8,:));
raw(Initialrow:size(ParametersSum(:,8,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+9*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'CenterTimeAlone(% of time)'};
raw(Initialrow:size(ParametersSum(:,11,:),1)+Initialrow-1,3:size(ParametersSum(:,11,:),3)+2)=num2cell(ParametersSumTotalDetected(IndexNewSort,11,:));
raw(Initialrow:size(ParametersSum(:,11,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+10*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'InsideZoneTime(% of time)'};
raw(Initialrow:size(ParametersSum(:,9,:),1)+Initialrow-1,3:size(ParametersSum(:,9,:),3)+2)=num2cell(ParametersSumTotalDetected(IndexNewSort,9,:));
raw(Initialrow:size(ParametersSum(:,9,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+11*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'OutsideZoneTime(% of time)'};
raw(Initialrow:size(ParametersSum(:,10,:),1)+Initialrow-1,3:size(ParametersSum(:,10,:),3)+2)=num2cell(ParametersSumTotalDetected(IndexNewSort,10,:));
raw(Initialrow:size(ParametersSum(:,10,:),1)+Initialrow-1,2)=RankingArray(:,1);


Initialrow=1+12*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'chasing all (N events)'};
raw(Initialrow:size(ChasingEventsPerDay,1)+Initialrow-1,3:size(ChasingEventsPerDay,2)+2)=num2cell(ChasingEventsPerDay(IndexNewSort,:));
raw(Initialrow:size(ChasingEventsPerDay,1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+13*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'being chased all(N events)'};
raw(Initialrow:size(BeingChasingEventsPerDay,1)+Initialrow-1,3:size(BeingChasingEventsPerDay,2)+2)=num2cell(BeingChasingEventsPerDay(IndexNewSort,:));
raw(Initialrow:size(BeingChasingEventsPerDay,1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+14*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Chasing plus being chasing all(N events)'};
raw(Initialrow:size(BeingChasingEventsPerDay,1)+Initialrow-1,3:size(BeingChasingEventsPerDay,2)+2)=num2cell(BeingChasingEventsPerDay(IndexNewSort,:)+ChasingEventsPerDay(IndexNewSort,:));
raw(Initialrow:size(BeingChasingEventsPerDay,1)+Initialrow-1,2)=RankingArray(:,1);

% Initialrow=1+15*(size(ParametersSum(:,1,:),1)+2);
% raw(Initialrow,1)={'%ChasingTime  (% of Active time)'};
% raw(Initialrow:size( ChasingTimePercentActive,1)+Initialrow-1,3:size( ChasingTimePercentActive,2)+2)=num2cell( ChasingTimePercentActive(IndexNewSort,:));
% raw(Initialrow:size( ChasingTimePercentActive,1)+Initialrow-1,2)=RankingArray(:,1);
% 
Initialrow=1+16*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Mean Elorating per day'};
raw(Initialrow:size(EloratingAveragePerDay,1)+Initialrow-1,3:size(EloratingAveragePerDay,2)+2)=num2cell(EloratingAveragePerDay(IndexNewSort,:));
raw(Initialrow:size(EloratingAveragePerDay,1)+Initialrow-1,2)=RankingArray(:,1);


Initialrow=1+17*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Elorating according to last event per day'};
raw(Initialrow:size(EloratingPerLastDay,1)+Initialrow-1,3:size(EloratingPerLastDay,2)+2)=EloratingPerLastDay;
raw(Initialrow:size(EloratingPerLastDay,1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+18*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Normalized David Score all the experiment'};
raw(Initialrow:size(NormDSAll,1)+Initialrow-1,3)=num2cell(NormDSAll(IndexNewSort,:));
raw(Initialrow:size(NormDSAll,1)+Initialrow-1,2)=RankingArray(:,1);



Initialrow=1+19*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Normalized David Score from Dominance matrix all the experiment'};
raw(Initialrow:size(NormDSAllD,1)+Initialrow-1,3)=num2cell(NormDSAllD(IndexNewSort,:));
raw(Initialrow:size(NormDSAllD,1)+Initialrow-1,2)=RankingArray(:,1);


Initialrow=1+20*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'DistPairs all(average (cm))'};
raw(Initialrow:size(ParametersSum(:,16,:),1)+Initialrow-1,3:size(ParametersSum(:,16,:),3)+2)=num2cell(ParametersSum(IndexNewSort,16,:));
raw(Initialrow:size(ParametersSum(:,16,:),1)+Initialrow-1,2)=RankingArray(:,1);


Initialrow=1+21*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'David score with interactions per day'};
raw(Initialrow:size(NormDSAllDPerDay,1)+Initialrow-1,3:size(NormDSAllDPerDay,2)+2)=num2cell(NormDSAllDPerDay(IndexNewSort,:));
raw(Initialrow:size(NormDSAllDPerDay,1)+Initialrow-1,2)=RankingArray(:,1);


Initialrow=1+22*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Average velocity (average (cm/sec))'};
raw(Initialrow:size(ParametersSum(:,17,:),1)+Initialrow-1,3:size(ParametersSum(:,17,:),3)+2)=num2cell(ParametersSum(IndexNewSort,17,:));
raw(Initialrow:size(ParametersSum(:,17,:),1)+Initialrow-1,2)=RankingArray(:,1);

% Initialrow=1+23*(size(ParametersSum(:,1,:),1)+2); FINISH
% raw(Initialrow,1)={'togetherAll(% of time)'};
% raw(Initialrow:size(TogetherTimePercent,1)+Initialrow-1,3:size(TogetherTimePercent,2)+2)=num2cell(TogetherTimePercent);
% %raw(Initialrow:size(TogetherTimePercent,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');
% raw(Initialrow:size(TogetherTimePercent,1)+Initialrow-1,2)=RankingArray(:,1);


Initialrow=1+24*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'RunningTimeActive(% of Active time)'};
raw(Initialrow:size(ParametersSum(:,1,:),1)+Initialrow-1,3:size(ParametersSum(:,1,:),3)+2)=num2cell(ParametersSumActiveTime(IndexNewSort,1,:));
raw(Initialrow:size(ParametersSum(:,1,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+25*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'WalkingTimeActive(% of Active time)'};
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,3:size(ParametersSum(:,2,:),3)+2)=num2cell(ParametersSumActiveTime(IndexNewSort,2,:));
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+26*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'StaticTimeActive(% of Active time)'};
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,3:size(ParametersSum(:,2,:),3)+2)=num2cell(ParametersSumActiveTime(IndexNewSort,3,:));
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+27*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'movementTimeActive(% of Active time)'};
raw(Initialrow:size(ParametersSum(:,12,:),1)+Initialrow-1,3:size(ParametersSum(:,12,:),3)+2)=num2cell(ParametersSumActiveTime(IndexNewSort,12,:));
raw(Initialrow:size(ParametersSum(:,12,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+28*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'eatingSumTimeActive(% of Active time)'};
raw(Initialrow:size(ParametersSum(:,4,:),1)+Initialrow-1,3:size(ParametersSum(:,4,:),3)+2)=num2cell(ParametersSumActiveTime(IndexNewSort,4,:));
raw(Initialrow:size(ParametersSum(:,4,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+29*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'drinkingSumTimeActive(% of Active time)'};
raw(Initialrow:size( ParametersSum(:,5,:),1)+Initialrow-1,3:size(ParametersSum(:,5,:),3)+2)=num2cell(ParametersSumActiveTime(IndexNewSort,5,:));
raw(Initialrow:size(ParametersSum(:,5,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+30*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'CenterTimeAloneActive(% of Active time)'};
raw(Initialrow:size(ParametersSum(:,11,:),1)+Initialrow-1,3:size(ParametersSum(:,11,:),3)+2)=num2cell(ParametersSumActiveTime(IndexNewSort,11,:));
raw(Initialrow:size(ParametersSum(:,11,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+31*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'InsideZoneTime(% of active time)'};
raw(Initialrow:size(ParametersSum(:,9,:),1)+Initialrow-1,3:size(ParametersSum(:,9,:),3)+2)=num2cell(ParametersSumActiveTime(IndexNewSort,9,:));
raw(Initialrow:size(ParametersSum(:,9,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+32*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'OutsideZoneTime(% of active time)'};
raw(Initialrow:size(ParametersSum(:,10,:),1)+Initialrow-1,3:size(ParametersSum(:,10,:),3)+2)=num2cell(ParametersSumActiveTime(IndexNewSort,10,:));
raw(Initialrow:size(ParametersSum(:,10,:),1)+Initialrow-1,2)=RankingArray(:,1);

%%
% Spetial for interaction matrix
Initialrow=1+33*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Interaction Matrix for each day (Chasing/being Chasing)'};
for i=1:size(InteractionMatrix,3)%loop on number of days
    
raw(Initialrow:size(InteractionMatrix,1)+Initialrow-1,3+(i-1)*(size(InteractionMatrix,2)+1):size(InteractionMatrix,2)+2+(i-1)*(size(InteractionMatrix,2)+1))=num2cell(InteractionMatrix(:,:,i));
raw(Initialrow-1,3+(i-1)*(size(InteractionMatrix,2)+1):size(InteractionMatrix,2)+2+(i-1)*(size(InteractionMatrix,2)+1))=(RankingArray(:,1))';
end
raw(Initialrow:size(InteractionMatrix,1)+Initialrow-1,2)=RankingArray(:,1); 
%% 

% Initialrow=1+34*(size(ParametersSum(:,1,:),1)+2);
% raw(Initialrow,1)={'Total frames per day(~ to total experimental time)'};
% raw(Initialrow:size(TotalExpTime,1)+Initialrow-1,3:size(TotalExpTime,2)+2)=num2cell(TotalExpTime);
% % raw(Initialrow:size(TotalTime,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');
% 
% 
% Initialrow=1+35*(size(ParametersSum(:,1,:),1)+2);
% raw(Initialrow,1)={'Duration of the experiment per day (h)'};
% raw(Initialrow:size(ElapseTimePerDay,1)+Initialrow-1,3:size(ElapseTimePerDay,2)+2)=num2cell(ElapseTimePerDay);

 Initialrow=1+34*(size(ParametersSum(:,1,:),1)+2);
 raw(Initialrow,1)={'Total time per day the mouse was detected (in min)'};
 raw(Initialrow:size(ParametersSum(:,13,:),1)+Initialrow-1,3:size(ParametersSum(:,13,:),3)+2)=num2cell(ParametersSum(IndexNewSort,13,:));
 raw(Initialrow:size(ParametersSum(:,13,:),1)+Initialrow-1,2)=RankingArray(:,1);
 
  Initialrow=1+35*(size(ParametersSum(:,1,:),1)+2);
 raw(Initialrow,1)={'Active time in the arena per day (in min)'};
 raw(Initialrow:size(ParametersSum(:,14,:),1)+Initialrow-1,3:size(ParametersSum(:,14,:),3)+2)=num2cell(ParametersSum(IndexNewSort,14,:));
 raw(Initialrow:size(ParametersSum(:,14,:),1)+Initialrow-1,2)=RankingArray(:,1);


%% Create array of days

Date=strcat(num2str(TimeArray(:,4)),'-',num2str(TimeArray(:,3)),'-',num2str(TimeArray(:,2)));

 raw(1,3:size(ParametersSum(:,1,:),3)+2)=(unique(cellstr(Date),'stable'))';%create the days
 %% -----------------------------Add ranking from elorating to get order--------------
% ChasingFile=strcat(get(h.editRunParams,'string'),'\',item_selected(t),'\','Data','\','ChasingResults','\',strcat(item_selected(t),'_ChasingResults.xlsx')); %OPen chasing excel file
%  sheet='Ranking';
%  [num txt RankingArray]=xlsread(char(ChasingFile),sheet);
 
 Initialrow=1+36*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Ranking according to elo-rating'};
raw(Initialrow:size(RankingArray,1)+Initialrow-1,3:size(RankingArray,2)+2)=RankingArray;

%% Without normalization

 Initialrow=1+37*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'RunningTime(min)'};
raw(Initialrow:size(ParametersSum(:,1,:),1)+Initialrow-1,3:size(ParametersSum(:,1,:),3)+2)=num2cell(ParametersSum(IndexNewSort,1,:));
raw(Initialrow:size(ParametersSum(:,1,:),1)+Initialrow-1,2)=RankingArray(:,1);


 Initialrow=1+38*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'WalkingTime(min)'};
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,3:size(ParametersSum(:,2,:),3)+2)=num2cell(ParametersSum(IndexNewSort,2,:));
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+39*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'StaticTime(min)'};
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,3:size(ParametersSum(:,2,:),3)+2)=num2cell(ParametersSum(IndexNewSort,3,:));
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+40*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'movementTime(min)'};
raw(Initialrow:size(ParametersSum(:,12,:),1)+Initialrow-1,3:size(ParametersSum(:,12,:),3)+2)=num2cell(ParametersSum(IndexNewSort,12,:));
raw(Initialrow:size(ParametersSum(:,12,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+41*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'sleepingSumTime(min)'};
raw(Initialrow:size(ParametersSum(:,6,:),1)+Initialrow-1,3:size(ParametersSum(:,6,:),3)+2)=num2cell(ParametersSum(IndexNewSort,6,:));
raw(Initialrow:size(ParametersSum(:,6,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+42*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'eatingSumTime(min)'};
raw(Initialrow:size(ParametersSum(:,4,:),1)+Initialrow-1,3:size(ParametersSum(:,4,:),3)+2)=num2cell(ParametersSum(IndexNewSort,4,:));
raw(Initialrow:size(ParametersSum(:,4,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+43*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'drinkingSumTime(min)'};
raw(Initialrow:size( ParametersSum(:,5,:),1)+Initialrow-1,3:size(ParametersSum(:,5,:),3)+2)=num2cell(ParametersSum(IndexNewSort,5,:));
raw(Initialrow:size(ParametersSum(:,5,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+44*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'hidingSumTime(min)'};
raw(Initialrow:size(ParametersSum(:,7,:),1)+Initialrow-1,3:size(ParametersSum(:,7,:),3)+2)=num2cell(ParametersSum(IndexNewSort,7,:));
raw(Initialrow:size(ParametersSum(:,7,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+45*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'ArenaSumTime(min)'};
raw(Initialrow:size(ParametersSum(:,8,:),1)+Initialrow-1,3:size(ParametersSum(:,8,:),3)+2)=num2cell(ParametersSum(IndexNewSort,8,:));
raw(Initialrow:size(ParametersSum(:,8,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+46*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'CenterTimeAlone(min)'};
raw(Initialrow:size(ParametersSum(:,11,:),1)+Initialrow-1,3:size(ParametersSum(:,11,:),3)+2)=num2cell(ParametersSum(IndexNewSort,11,:));
raw(Initialrow:size(ParametersSum(:,11,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+47*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'InsideZoneTime(min)'};
raw(Initialrow:size(ParametersSum(:,9,:),1)+Initialrow-1,3:size(ParametersSum(:,9,:),3)+2)=num2cell(ParametersSum(IndexNewSort,9,:));
raw(Initialrow:size(ParametersSum(:,9,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+48*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'OutsideZoneTime(min)'};
raw(Initialrow:size(ParametersSum(:,10,:),1)+Initialrow-1,3:size(ParametersSum(:,10,:),3)+2)=num2cell(ParametersSum(IndexNewSort,10,:));
raw(Initialrow:size(ParametersSum(:,10,:),1)+Initialrow-1,2)=RankingArray(:,1);






end