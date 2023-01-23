function  raw=ParametersPerStage(ParametersSum,IndexNewSort,RankingArray,ChasingEventsPerDay,BeingChasingEventsPerDay,ChasingPlusChased,ChasingDurationPerDay,GlickoPerLastDay1,EloratingPerLastDay,ForagingCorrelationStage,...
                             EntropyDayStage,DistanceTravelDayStage,AngularVelocityStage)
                         
                  

%% --------------------Arrange the data-Create an array by ordering according to elorating ranking per day-Order into stage 1 and stage 2--------------------------

DaysT=size(ChasingEventsPerDay,2);
%%
%Get time for 2 stages
TimeStage1=ParametersSum(IndexNewSort,13,1)/60; %time detected per hour
TimeStage2=sum(ParametersSum(IndexNewSort,13,2:DaysT),3)/60; %time per hour

TimeStage1m=ParametersSum(IndexNewSort,13,1); %time per minute
TimeStage2m=sum(ParametersSum(IndexNewSort,13,2:DaysT),3); %time per minute

TimeStage1Active=ParametersSum(IndexNewSort,14,1); %time per minute active
TimeStage2Active=sum(ParametersSum(IndexNewSort,14,2:DaysT),3); %time per minute active
%%
raw{1,1}={'Days'};
raw(1,2)={'head chip / Stages'};
raw(1,3)={'Stage 1'}; %first day
raw(1,4)={'Stage 2'}; %second to six day

%% Normalization over total detection time

raw(2,1)={'%RunningTime'};
raw(2:size(ParametersSum(:,1,:),1)+1,3:4)=num2cell([(ParametersSum(IndexNewSort,1,1))./TimeStage1m,(sum(ParametersSum(IndexNewSort,1,2:DaysT),3,'omitnan'))./TimeStage2m]); %#ok<*NODEF>
raw(2:size(ParametersSum(:,1,:),1)+1,2)=RankingArray(:,1);


Initialrow=1+(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'%WalkingTime'};
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,2,1))./TimeStage1m,(sum(ParametersSum(IndexNewSort,2,2:DaysT),3,'omitnan'))./TimeStage2m]);
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+2*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'%StaticTime'};
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,3,1))./TimeStage1m,(sum(ParametersSum(IndexNewSort,3,2:DaysT),3,'omitnan'))./TimeStage2m]);
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+3*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'%RunningTimeHighVelocity'};
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,54,1))./TimeStage1m,(sum(ParametersSum(IndexNewSort,54,2:DaysT),3,'omitnan'))./TimeStage2m]);
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+4*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'%movementTime'};
raw(Initialrow:size(ParametersSum(:,12,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,12,1))./TimeStage1m,(sum(ParametersSum(IndexNewSort,12,2:DaysT),3,'omitnan'))./TimeStage2m]);
raw(Initialrow:size(ParametersSum(:,12,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+5*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'%sleepingSumTime'};
raw(Initialrow:size(ParametersSum(:,6,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,6,1))./TimeStage1m,(sum(ParametersSum(IndexNewSort,6,2:DaysT),3,'omitnan'))./TimeStage2m]);
raw(Initialrow:size(ParametersSum(:,6,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+6*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'%eatingSumTime'};
raw(Initialrow:size(ParametersSum(:,4,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,4,1))./TimeStage1m,(sum(ParametersSum(IndexNewSort,4,2:DaysT),3,'omitnan'))./TimeStage2m]);
raw(Initialrow:size(ParametersSum(:,4,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+7*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'%drinkingSumTime'};
raw(Initialrow:size( ParametersSum(:,5,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,5,1))./TimeStage1m,(sum(ParametersSum(IndexNewSort,5,2:DaysT),3,'omitnan'))./TimeStage2m]);
raw(Initialrow:size(ParametersSum(:,5,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+8*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'%hidingSumTime'};
raw(Initialrow:size(ParametersSum(:,7,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,7,1))./TimeStage1m,(sum(ParametersSum(IndexNewSort,7,2:DaysT),3,'omitnan'))./TimeStage2m]);
raw(Initialrow:size(ParametersSum(:,7,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+9*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'%ArenaSumTime'};
raw(Initialrow:size(ParametersSum(:,8,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,8,1))./TimeStage1m,(sum(ParametersSum(IndexNewSort,8,2:DaysT),3,'omitnan'))./TimeStage2m]);
raw(Initialrow:size(ParametersSum(:,8,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+10*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'%CenterTimeAlone'};
raw(Initialrow:size(ParametersSum(:,11,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,11,1))./TimeStage1m,(sum(ParametersSum(IndexNewSort,11,2:DaysT),3,'omitnan'))./TimeStage2m]);
raw(Initialrow:size(ParametersSum(:,11,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+11*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'%InsideZoneTime'};
raw(Initialrow:size(ParametersSum(:,9,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,9,1))./TimeStage1m,(sum(ParametersSum(IndexNewSort,9,2:DaysT),3,'omitnan'))./TimeStage2m]);
raw(Initialrow:size(ParametersSum(:,9,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+12*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'%OutsideZoneTime'};
raw(Initialrow:size(ParametersSum(:,10,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,10,1))./TimeStage1m,(sum(ParametersSum(IndexNewSort,10,2:DaysT),3,'omitnan'))./TimeStage2m]);
raw(Initialrow:size(ParametersSum(:,10,:),1)+Initialrow-1,2)=RankingArray(:,1);

% Social behaviour all the parameters normalizated per hour
Initialrow=1+13*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'chasing all (N events per hour)'};
raw(Initialrow:size(ParametersSum(:,18,:),1)+Initialrow-1,3:4)=num2cell([(ChasingEventsPerDay(IndexNewSort,1))./TimeStage1,(sum(ChasingEventsPerDay(IndexNewSort,2:DaysT),2))./TimeStage2]);
raw(Initialrow:size(ParametersSum(:,18,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+14*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'being chased all(N events per hour)'};
raw(Initialrow:size(ParametersSum(:,19,:),1)+Initialrow-1,3:4)=num2cell([(BeingChasingEventsPerDay(IndexNewSort,1))./TimeStage1,(sum(BeingChasingEventsPerDay(IndexNewSort,2:DaysT),2))./TimeStage2]);
raw(Initialrow:size(ParametersSum(:,19,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+15*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Chasing plus being chasing all(N events per hour)'};
raw(Initialrow:size(ParametersSum(:,20,:),1)+Initialrow-1,3:4)=num2cell([(ChasingPlusChased(IndexNewSort,1))./TimeStage1,(sum(ChasingPlusChased(IndexNewSort,2:DaysT),2))./TimeStage2]);
raw(Initialrow:size(ParametersSum(:,20,:),1)+Initialrow-1,2)=RankingArray(:,1);

% Initialrow=1+16*(size(ParametersSum(:,1,:),1)+2);
% raw(Initialrow,1)={'%Time together'};%less than 10cm normalized over the total detected time
% raw(Initialrow:size(ParametersSum(:,21,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,21,1))./TimeStage1m,(sum(ParametersSum(IndexNewSort,21,2:DaysT),3,'omitnan'))./TimeStage2m]);
% raw(Initialrow:size(ParametersSum(:,21,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+16*(size(ParametersSum(:,1,:),1)+2); %this is the mean distance
raw(Initialrow,1)={'Distance pairs(cm)'};%Mean distance between mice in cm
raw(Initialrow:size(ParametersSum(:,16,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,16,1)),(mean(ParametersSum(IndexNewSort,16,2:DaysT),3,'omitnan'))]);
raw(Initialrow:size(ParametersSum(:,16,:),1)+Initialrow-1,2)=RankingArray(:,1);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%
Initialrow=1+17*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Chasing duration (sec)'}; % mean chasing duration in sec 
raw(Initialrow:size(ParametersSum(:,22,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,22,1)),(mean(ParametersSum(IndexNewSort,22,2:DaysT),3,'omitnan'))]);
raw(Initialrow:size(ParametersSum(:,22,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+18*(size(ParametersSum(:,1,:),1)+2); %here we take the first day and the last day 
raw(Initialrow,1)={'Glicko per day'};
raw(Initialrow:size(GlickoPerLastDay1,1)+Initialrow-1,3)=(GlickoPerLastDay1(:,2));
raw(Initialrow:size(GlickoPerLastDay1,1)+Initialrow-1,4)=(GlickoPerLastDay1(:,end));
raw(Initialrow:size(GlickoPerLastDay1,1)+Initialrow-1,2)=RankingArray(:,1);

% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Initialrow=1+19*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Approaching (N events per hour)'};
raw(Initialrow:size(ParametersSum(:,37,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,37,1))./TimeStage1,(sum(ParametersSum(IndexNewSort,37,2:DaysT),3,'omitnan'))./TimeStage2]);
raw(Initialrow:size(ParametersSum(:,37,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+20*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Be avoiding (N events per hour)'};
raw(Initialrow:size(ParametersSum(:,38,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,38,1))./TimeStage1,(sum(ParametersSum(IndexNewSort,38,2:DaysT),3,'omitnan'))./TimeStage2]);
raw(Initialrow:size(ParametersSum(:,38,:),1)+Initialrow-1,2)=RankingArray(:,1);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Social parameters which were
% forget%%%%%%%%%%%%%%%%%%%%%%
Initialrow=1+21*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Together(N events per hour)'};%less than 10cm
raw(Initialrow:size(ParametersSum(:,48,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,48,1))./TimeStage1,(sum(ParametersSum(IndexNewSort,48,2:DaysT),3,'omitnan'))./TimeStage2]);
raw(Initialrow:size(ParametersSum(:,48,:),1)+Initialrow-1,2)=RankingArray(:,1);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%Number of events with head to head %%%%%%
Initialrow=1+22*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Head to head(N events per hour)'};%less than 2cm
raw(Initialrow:size(ParametersSum(:,52,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,52,1))./TimeStage1,(sum(ParametersSum(IndexNewSort,52,2:DaysT),3,'omitnan'))./TimeStage2]);
raw(Initialrow:size(ParametersSum(:,52,:),1)+Initialrow-1,2)=RankingArray(:,1);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%Number of events with head to tail %%%%%%
Initialrow=1+23*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Head to tail(N events per hour)'};%less than 2cm
raw(Initialrow:size(ParametersSum(:,53,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,53,1))./TimeStage1,(sum(ParametersSum(IndexNewSort,53,2:DaysT),3,'omitnan'))./TimeStage2]);
raw(Initialrow:size(ParametersSum(:,53,:),1)+Initialrow-1,2)=RankingArray(:,1);

% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%Number of events with head to head -Normalized to the total time TO TAKE A LOOK%%%%%%
% Initialrow=1+64*(size(ParametersSum(:,1,:),1)+2);
% raw(Initialrow,1)={'Head to head(1/min)'};%less than 2cm
% raw(Initialrow:size(ParametersSum(:,52,:),1)+Initialrow-1,3:size(ParametersSum(:,52,:),3)+2)=num2cell(ParametersSumTotalDetected(IndexNewSort,52,:));
% raw(Initialrow:size(ParametersSum(:,52,:),1)+Initialrow-1,2)=RankingArray(:,1);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%Number of events with head to tail - normalized to the total time %%%%%%
% Initialrow=1+65*(size(ParametersSum(:,1,:),1)+2);
% raw(Initialrow,1)={'Head to tail(1/min)'};%less than 2cm
% raw(Initialrow:size(ParametersSum(:,53,:),1)+Initialrow-1,3:size(ParametersSum(:,53,:),3)+2)=num2cell(ParametersSumTotalDetected(IndexNewSort,53,:));
% raw(Initialrow:size(ParametersSum(:,53,:),1)+Initialrow-1,2)=RankingArray(:,1);


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%  Events %%%%%%%%%%%%%%%%%%%%%%%%
Initialrow=1+24*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'RunningTime(N events per hour)'};
raw(Initialrow:size(ParametersSum(:,25,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,25,1))./TimeStage1,(sum(ParametersSum(IndexNewSort,25,2:DaysT),3,'omitnan'))./TimeStage2]);
raw(Initialrow:size(ParametersSum(:,25,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+25*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'WalkingTime(N events per hour)'};
raw(Initialrow:size(ParametersSum(:,26,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,26,1))./TimeStage1,(sum(ParametersSum(IndexNewSort,26,2:DaysT),3,'omitnan'))./TimeStage2]);
raw(Initialrow:size(ParametersSum(:,26,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+26*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'StaticTime(N events per hour)'};
raw(Initialrow:size(ParametersSum(:,27,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,27,1))./TimeStage1,(sum(ParametersSum(IndexNewSort,27,2:DaysT),3,'omitnan'))./TimeStage2]);
raw(Initialrow:size(ParametersSum(:,27,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+27*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'RunningTimeHighVelocity(N events per hour)'};
raw(Initialrow:size(ParametersSum(:,55,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,55,1))./TimeStage1,(sum(ParametersSum(IndexNewSort,55,2:DaysT),3,'omitnan'))./TimeStage2]);
raw(Initialrow:size(ParametersSum(:,55,:),1)+Initialrow-1,2)=RankingArray(:,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Elorating%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Initialrow=1+28*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Elorating according to last event per day'};
raw(Initialrow:size(EloratingPerLastDay,1)+Initialrow-1,3)=num2cell(EloratingPerLastDay(:,1));%first day
raw(Initialrow:size(EloratingPerLastDay,1)+Initialrow-1,4)=num2cell(EloratingPerLastDay(:,end));%lastday day
raw(Initialrow:size(EloratingPerLastDay,1)+Initialrow-1,2)=RankingArray(:,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Elorating%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%According to active
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%time%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Initialrow=1+29*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'RunningTimeActive(% of Active time)'};
raw(Initialrow:size(ParametersSum(:,1,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,1,1))./TimeStage1Active,(sum(ParametersSum(IndexNewSort,1,2:DaysT),3,'omitnan'))./TimeStage2Active]);
raw(Initialrow:size(ParametersSum(:,1,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+30*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'WalkingTimeActive(% of Active time)'};
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,2,1))./TimeStage1Active,(sum(ParametersSum(IndexNewSort,2,2:DaysT),3,'omitnan'))./TimeStage2Active]);
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+31*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'StaticTimeActive(% of Active time)'};
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,3,1))./TimeStage1Active,(sum(ParametersSum(IndexNewSort,3,2:DaysT),3,'omitnan'))./TimeStage2Active]);
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+32*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'RunningTimeHighVelocity(% of Active time)'};
raw(Initialrow:size(ParametersSum(:,54,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,54,1))./TimeStage1Active,(sum(ParametersSum(IndexNewSort,54,2:DaysT),3,'omitnan'))./TimeStage2Active]);
raw(Initialrow:size(ParametersSum(:,54,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+33*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'movementTimeActive(% of Active time)'};
raw(Initialrow:size(ParametersSum(:,12,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,12,1))./TimeStage1Active,(sum(ParametersSum(IndexNewSort,13,2:DaysT),3,'omitnan'))./TimeStage2Active]);
raw(Initialrow:size(ParametersSum(:,12,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+34*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'eatingSumTimeActive(% of Active time)'};
raw(Initialrow:size(ParametersSum(:,4,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,4,1))./TimeStage1Active,(sum(ParametersSum(IndexNewSort,4,2:DaysT),3,'omitnan'))./TimeStage2Active]);
raw(Initialrow:size(ParametersSum(:,4,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+35*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'drinkingSumTimeActive(% of Active time)'};
raw(Initialrow:size( ParametersSum(:,5,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,5,1))./TimeStage1Active,(sum(ParametersSum(IndexNewSort,5,2:DaysT),3,'omitnan'))./TimeStage2Active]);
raw(Initialrow:size(ParametersSum(:,5,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+36*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'CenterTimeAloneActive(% of Active time)'};
raw(Initialrow:size(ParametersSum(:,11,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,11,1))./TimeStage1Active,(sum(ParametersSum(IndexNewSort,11,2:DaysT),3,'omitnan'))./TimeStage2Active]);
raw(Initialrow:size(ParametersSum(:,11,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+37*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'InsideZoneTime(% of active time)'};
raw(Initialrow:size(ParametersSum(:,9,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,9,1))./TimeStage1Active,(sum(ParametersSum(IndexNewSort,9,2:DaysT),3,'omitnan'))./TimeStage2Active]);
raw(Initialrow:size(ParametersSum(:,9,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+38*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'OutsideZoneTime(% of active time)'};
raw(Initialrow:size(ParametersSum(:,10,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,10,1))./TimeStage1Active,(sum(ParametersSum(IndexNewSort,10,2:DaysT),3,'omitnan'))./TimeStage2Active]);
raw(Initialrow:size(ParametersSum(:,10,:),1)+Initialrow-1,2)=RankingArray(:,1);

%%%%%%%%%% Others %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Others %%%%%%%%%%%%%%%%%%%%%%%%%

Initialrow=1+39*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Frequency visits outside sleeping box (1/hour)'}; %normalized over the total detected time(1/h)
raw(Initialrow:size(ParametersSum(:,10,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,35,1))./TimeStage1,(sum(ParametersSum(IndexNewSort,35,2:DaysT),3,'omitnan'))./TimeStage2]);
raw(Initialrow:size(ParametersSum(:,10,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+40*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Foraging correlation'};
raw(Initialrow:size(ForagingCorrelationStage,1)+Initialrow-1,3)=num2cell(ForagingCorrelationStage(IndexNewSort,1));
raw(Initialrow:size(ForagingCorrelationStage,1)+Initialrow-1,4)=num2cell(ForagingCorrelationStage(IndexNewSort,2));
raw(Initialrow:size(ForagingCorrelationStage,1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+41*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'ROI exploration (bits/hour)'}; %Larger values less information.
raw(Initialrow:size(ParametersSum(:,10,:),1)+Initialrow-1,3)=num2cell(EntropyDayStage(IndexNewSort,1));
raw(Initialrow:size(ParametersSum(:,10,:),1)+Initialrow-1,4)=num2cell(EntropyDayStage(IndexNewSort,2));
raw(Initialrow:size(ParametersSum(:,10,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+42*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Median/mean speed (cm/sec)'}; 
raw(Initialrow:size(ParametersSum(:,17,:),1)+Initialrow-1,3)=num2cell(ParametersSum(IndexNewSort,17,1));
raw(Initialrow:size(ParametersSum(:,17,:),1)+Initialrow-1,4)=num2cell(mean(ParametersSum(IndexNewSort,17,2:DaysT),3,'omitnan'));
raw(Initialrow:size(ParametersSum(:,17,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+43*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Median/mean Aceleration (cm/sec^2)'}; 
raw(Initialrow:size(ParametersSum(:,56,:),1)+Initialrow-1,3)=num2cell(ParametersSum(IndexNewSort,56,1));
raw(Initialrow:size(ParametersSum(:,17,:),1)+Initialrow-1,4)=num2cell(mean(ParametersSum(IndexNewSort,56,2:DaysT),3,'omitnan'));
raw(Initialrow:size(ParametersSum(:,56,:),1)+Initialrow-1,2)=RankingArray(:,1);


Initialrow=1+44*(size(ParametersSum(:,1,:),1)+2);% mean distance travell in the arena
raw(Initialrow,1)={'Distance traveled (m)'}; 
raw(Initialrow:size(DistanceTravelDayStage,1)+Initialrow-1,3)=num2cell(DistanceTravelDayStage(IndexNewSort,1));
raw(Initialrow:size(DistanceTravelDayStage,1)+Initialrow-1,4)=num2cell(DistanceTravelDayStage(IndexNewSort,2));
raw(Initialrow:size(DistanceTravelDayStage,1)+Initialrow-1,2)=RankingArray(:,1);


Initialrow=1+45*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Angular velocity (rad/sec)'}; 
raw(Initialrow:size(AngularVelocityStage,1)+Initialrow-1,3)=num2cell(AngularVelocityStage(IndexNewSort,1));
raw(Initialrow:size(AngularVelocityStage,1)+Initialrow-1,4)=num2cell(AngularVelocityStage(IndexNewSort,2));
raw(Initialrow:size(AngularVelocityStage,1)+Initialrow-1,2)=RankingArray(:,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add parameters of hiding + sleeping
Initialrow=1+46*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Hiding plus sleeping (% of Total time)'};
raw(Initialrow:size(ParametersSum(:,49,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,49,1))./TimeStage1m,(sum(ParametersSum(IndexNewSort,49,2:DaysT),3,'omitnan'))./TimeStage2m]);
raw(Initialrow:size(ParametersSum(:,49,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+47*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Hiding plus sleeping (N events per hour)'};
raw(Initialrow:size(ParametersSum(:,50,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,50,1))./TimeStage1,(sum(ParametersSum(IndexNewSort,50,2:DaysT),3,'omitnan'))./TimeStage2]);
raw(Initialrow:size(ParametersSum(:,50,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+48*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Frequency visits the hiding boxes (1/hour)'}; %number of events go out of hiding boxes normalized to detection time(1/h)
raw(Initialrow:size(ParametersSum(:,10,:),1)+Initialrow-1,3:4)=num2cell([(ParametersSum(IndexNewSort,51,1))./TimeStage1,(sum(ParametersSum(IndexNewSort,51,2:DaysT),3,'omitnan'))./TimeStage2]);
raw(Initialrow:size(ParametersSum(:,10,:),1)+Initialrow-1,2)=RankingArray(:,1);
end