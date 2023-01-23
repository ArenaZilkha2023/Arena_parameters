function raw=GetArrangementDatavs2(ParametersSum,IndexNewSort,...
                     ChasingEventsPerDay, BeingChasingEventsPerDay, ...
                     EloratingAveragePerDay,EloratingPerLastDay,InteractionMatrix,...
                      NormDSAll,AverageElorating,ItemUsedToScore,TimeArray,RankingArray,ParametersSumTotalDetected,ParametersSumActiveTime,...
                     FrequencyVisitsOutside,ForagingCorrelation,EntropyDay,DistanceTravelDay,AngularVelocityDay,FrequencyVisitsHidingBox,ChasingPlusChased,ChasingDurationPerDay,...
                     GlickoPerLastDay1,SocialMatrix,GlickoErrorPerDay2,BeingChasingDurationPerDay,ChasingBeingChasedEventsPerDay)

%% --------------------Arrange the data-Create an array by ordering according to elorating ranking per day--------------------------


raw{1,1}={'Days'};
raw(1,2)={'head chip / Days'};
raw(2,1)={'RunningTime(min)'};
raw(2:size(ParametersSum(:,1,:),1)+1,3:size(ParametersSum(:,1,:),3)+2)=num2cell(ParametersSum(IndexNewSort,1,:)); %#ok<*NODEF>
raw(2:size(ParametersSum(:,1,:),1)+1,2)=RankingArray(:,1);

Initialrow=1+(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'WalkingTime(min)'};
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,3:size(ParametersSum(:,2,:),3)+2)=num2cell(ParametersSum(IndexNewSort,2,:));
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+2*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'StaticTime(min)'};
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,3:size(ParametersSum(:,2,:),3)+2)=num2cell(ParametersSum(IndexNewSort,3,:));
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+3*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'RunningTimeHighVelocity(min)'};
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,3:size(ParametersSum(:,2,:),3)+2)=num2cell(ParametersSum(IndexNewSort,54,:));
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+4*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'movementTime(min)'};
raw(Initialrow:size(ParametersSum(:,12,:),1)+Initialrow-1,3:size(ParametersSum(:,12,:),3)+2)=num2cell(ParametersSum(IndexNewSort,12,:));
raw(Initialrow:size(ParametersSum(:,12,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+5*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'sleepingSumTime(min)'};
raw(Initialrow:size(ParametersSum(:,6,:),1)+Initialrow-1,3:size(ParametersSum(:,6,:),3)+2)=num2cell(ParametersSum(IndexNewSort,6,:));
raw(Initialrow:size(ParametersSum(:,6,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+6*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'eatingSumTime(min)'};
raw(Initialrow:size(ParametersSum(:,4,:),1)+Initialrow-1,3:size(ParametersSum(:,4,:),3)+2)=num2cell(ParametersSum(IndexNewSort,4,:));
raw(Initialrow:size(ParametersSum(:,4,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+7*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'drinkingSumTime(min)'};
raw(Initialrow:size( ParametersSum(:,5,:),1)+Initialrow-1,3:size(ParametersSum(:,5,:),3)+2)=num2cell(ParametersSum(IndexNewSort,5,:));
raw(Initialrow:size(ParametersSum(:,5,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+8*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'hidingSumTime(min)'};
raw(Initialrow:size(ParametersSum(:,7,:),1)+Initialrow-1,3:size(ParametersSum(:,7,:),3)+2)=num2cell(ParametersSum(IndexNewSort,7,:));
raw(Initialrow:size(ParametersSum(:,7,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+9*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'ArenaSumTime(min)'};
raw(Initialrow:size(ParametersSum(:,8,:),1)+Initialrow-1,3:size(ParametersSum(:,8,:),3)+2)=num2cell(ParametersSum(IndexNewSort,8,:));
raw(Initialrow:size(ParametersSum(:,8,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+10*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'CenterTimeAlone(min)'};
raw(Initialrow:size(ParametersSum(:,11,:),1)+Initialrow-1,3:size(ParametersSum(:,11,:),3)+2)=num2cell(ParametersSum(IndexNewSort,11,:));
raw(Initialrow:size(ParametersSum(:,11,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+11*(size(ParametersSum(:,1,:),1)+2);

raw(Initialrow,1)={'InsideZoneTime(min)'};
raw(Initialrow:size(ParametersSum(:,9,:),1)+Initialrow-1,3:size(ParametersSum(:,9,:),3)+2)=num2cell(ParametersSum(IndexNewSort,9,:));
raw(Initialrow:size(ParametersSum(:,9,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+12*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'OutsideZoneTime(min)'};
raw(Initialrow:size(ParametersSum(:,10,:),1)+Initialrow-1,3:size(ParametersSum(:,10,:),3)+2)=num2cell(ParametersSum(IndexNewSort,10,:));
raw(Initialrow:size(ParametersSum(:,10,:),1)+Initialrow-1,2)=RankingArray(:,1);


% Social behaviour
Initialrow=1+13*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'chasing all (N events)'};
raw(Initialrow:size(ParametersSum(:,18,:),1)+Initialrow-1,3:size(ParametersSum(:,18,:),3)+2)=num2cell(ChasingEventsPerDay(IndexNewSort,:));%In the case of manual tracking
%raw(Initialrow:size(ParametersSum(:,18,:),1)+Initialrow-1,3:size(ParametersSum(:,18,:),3)+2)=num2cell(ParametersSum(IndexNewSort,18,:));
raw(Initialrow:size(ParametersSum(:,18,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+14*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'being chased all(N events)'};
raw(Initialrow:size(ParametersSum(:,19,:),1)+Initialrow-1,3:size(ParametersSum(:,19,:),3)+2)=num2cell(BeingChasingEventsPerDay(IndexNewSort,:));%In the case of manual tracking
%raw(Initialrow:size(ParametersSum(:,19,:),1)+Initialrow-1,3:size(ParametersSum(:,19,:),3)+2)=num2cell(ParametersSum(IndexNewSort,19,:));
raw(Initialrow:size(ParametersSum(:,19,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+15*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Chasing plus being chasing all(N events)'};
raw(Initialrow:size(ParametersSum(:,20,:),1)+Initialrow-1,3:size(ParametersSum(:,20,:),3)+2)=num2cell(ChasingPlusChased(IndexNewSort,:));%In the case of manual tracking
%raw(Initialrow:size(ParametersSum(:,20,:),1)+Initialrow-1,3:size(ParametersSum(:,20,:),3)+2)=num2cell(ParametersSum(IndexNewSort,20,:));
raw(Initialrow:size(ParametersSum(:,20,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+16*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Time together(min)'};%less than 10cm
raw(Initialrow:size(ParametersSum(:,21,:),1)+Initialrow-1,3:size(ParametersSum(:,21,:),3)+2)=num2cell(ParametersSum(IndexNewSort,21,:));
raw(Initialrow:size(ParametersSum(:,21,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+17*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Distance pairs(cm)'};%less than 10cm
raw(Initialrow:size(ParametersSum(:,16,:),1)+Initialrow-1,3:size(ParametersSum(:,16,:),3)+2)=num2cell(ParametersSum(IndexNewSort,16,:));
raw(Initialrow:size(ParametersSum(:,16,:),1)+Initialrow-1,2)=RankingArray(:,1);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%
Initialrow=1+18*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Chasing duration (sec)'};
 raw(Initialrow:size(ParametersSum(:,22,:),1)+Initialrow-1,3:size(ParametersSum(:,22,:),3)+2)=num2cell(ChasingDurationPerDay(IndexNewSort,:));%In the case of manual tracking
%raw(Initialrow:size(ParametersSum(:,22,:),1)+Initialrow-1,3:size(ParametersSum(:,22,:),3)+2)=num2cell(ParametersSum(IndexNewSort,22,:));
raw(Initialrow:size(ParametersSum(:,22,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+19*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Glicko per day'};
raw(Initialrow:size(GlickoPerLastDay1,1)+Initialrow-1,3:size(GlickoPerLastDay1,2)+1)=(GlickoPerLastDay1(:,2:end));
raw(Initialrow:size(GlickoPerLastDay1,1)+Initialrow-1,2)=RankingArray(:,1);
% 
% Initialrow=1+20*(size(ParametersSum(:,1,:),1)+2);
% raw(Initialrow,1)={'Chasing plus being chasing duration(sec)'};
% raw(Initialrow:size(ParametersSum(:,24,:),1)+Initialrow-1,3:size(ParametersSum(:,24,:),3)+2)=num2cell(ParametersSum(IndexNewSort,24,:));
% raw(Initialrow:size(ParametersSum(:,24,:),1)+Initialrow-1,2)=RankingArray(:,1);
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Initialrow=1+21*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Approaching (N events)'};
raw(Initialrow:size(ParametersSum(:,37,:),1)+Initialrow-1,3:size(ParametersSum(:,37,:),3)+2)=num2cell(ParametersSum(IndexNewSort,37,:));
raw(Initialrow:size(ParametersSum(:,37,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+22*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Be avoiding (N events)'};
raw(Initialrow:size(ParametersSum(:,38,:),1)+Initialrow-1,3:size(ParametersSum(:,38,:),3)+2)=num2cell(ParametersSum(IndexNewSort,38,:));
raw(Initialrow:size(ParametersSum(:,38,:),1)+Initialrow-1,2)=RankingArray(:,1);


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%  Events %%%%%%%%%%%%%%%%%%%%%%%%
Initialrow=1+23*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'RunningTime(N events)'};
raw(Initialrow:size(ParametersSum(:,25,:),1)+Initialrow-1,3:size(ParametersSum(:,25,:),3)+2)=num2cell(ParametersSum(IndexNewSort,25,:));
raw(Initialrow:size(ParametersSum(:,25,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+24*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'WalkingTime(N events)'};
raw(Initialrow:size(ParametersSum(:,26,:),1)+Initialrow-1,3:size(ParametersSum(:,26,:),3)+2)=num2cell(ParametersSum(IndexNewSort,26,:));
raw(Initialrow:size(ParametersSum(:,26,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+25*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'StaticTime(N events)'};
raw(Initialrow:size(ParametersSum(:,27,:),1)+Initialrow-1,3:size(ParametersSum(:,27,:),3)+2)=num2cell(ParametersSum(IndexNewSort,27,:));
raw(Initialrow:size(ParametersSum(:,27,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+26*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'RunningTimeHighVelocity(N events)'};
raw(Initialrow:size(ParametersSum(:,55,:),1)+Initialrow-1,3:size(ParametersSum(:,55,:),3)+2)=num2cell(ParametersSum(IndexNewSort,55,:));
raw(Initialrow:size(ParametersSum(:,55,:),1)+Initialrow-1,2)=RankingArray(:,1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Elorating%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Initialrow=1+27*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Elorating according to last event per day'};
raw(Initialrow:size(EloratingPerLastDay,1)+Initialrow-1,3:size(EloratingPerLastDay,2)+2)=num2cell(EloratingPerLastDay);
raw(Initialrow:size(EloratingPerLastDay,1)+Initialrow-1,2)=RankingArray(:,1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%According to active
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%time%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Initialrow=1+28*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'RunningTimeActive(% of Active time)'};
raw(Initialrow:size(ParametersSum(:,1,:),1)+Initialrow-1,3:size(ParametersSum(:,1,:),3)+2)=num2cell(ParametersSumActiveTime(IndexNewSort,1,:));
raw(Initialrow:size(ParametersSum(:,1,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+29*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'WalkingTimeActive(% of Active time)'};
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,3:size(ParametersSum(:,2,:),3)+2)=num2cell(ParametersSumActiveTime(IndexNewSort,2,:));
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+30*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'StaticTimeActive(% of Active time)'};
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,3:size(ParametersSum(:,2,:),3)+2)=num2cell(ParametersSumActiveTime(IndexNewSort,3,:));
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+31*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'RunningTimeHighVelocity(% of Active time)'};
raw(Initialrow:size(ParametersSum(:,54,:),1)+Initialrow-1,3:size(ParametersSum(:,1,:),3)+2)=num2cell(ParametersSumActiveTime(IndexNewSort,54,:));
raw(Initialrow:size(ParametersSum(:,54,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+32*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'movementTimeActive(% of Active time)'};
raw(Initialrow:size(ParametersSum(:,12,:),1)+Initialrow-1,3:size(ParametersSum(:,12,:),3)+2)=num2cell(ParametersSumActiveTime(IndexNewSort,12,:));
raw(Initialrow:size(ParametersSum(:,12,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+33*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'eatingSumTimeActive(% of Active time)'};
raw(Initialrow:size(ParametersSum(:,4,:),1)+Initialrow-1,3:size(ParametersSum(:,4,:),3)+2)=num2cell(ParametersSumActiveTime(IndexNewSort,4,:));
raw(Initialrow:size(ParametersSum(:,4,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+34*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'drinkingSumTimeActive(% of Active time)'};
raw(Initialrow:size( ParametersSum(:,5,:),1)+Initialrow-1,3:size(ParametersSum(:,5,:),3)+2)=num2cell(ParametersSumActiveTime(IndexNewSort,5,:));
raw(Initialrow:size(ParametersSum(:,5,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+35*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'CenterTimeAloneActive(% of Active time)'};
raw(Initialrow:size(ParametersSum(:,11,:),1)+Initialrow-1,3:size(ParametersSum(:,11,:),3)+2)=num2cell(ParametersSumActiveTime(IndexNewSort,11,:));
raw(Initialrow:size(ParametersSum(:,11,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+36*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'InsideZoneTime(% of active time)'};
raw(Initialrow:size(ParametersSum(:,9,:),1)+Initialrow-1,3:size(ParametersSum(:,9,:),3)+2)=num2cell(ParametersSumActiveTime(IndexNewSort,9,:));
raw(Initialrow:size(ParametersSum(:,9,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+37*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'OutsideZoneTime(% of active time)'};
raw(Initialrow:size(ParametersSum(:,10,:),1)+Initialrow-1,3:size(ParametersSum(:,10,:),3)+2)=num2cell(ParametersSumActiveTime(IndexNewSort,10,:));
raw(Initialrow:size(ParametersSum(:,10,:),1)+Initialrow-1,2)=RankingArray(:,1);

%%%%%%%%%% Others %%%%%%%%%%%%%%%%%%%%%%%%%

Initialrow=1+38*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Frequency visits outside sleeping box (1/hour)'};
raw(Initialrow:size(FrequencyVisitsOutside,1)+Initialrow-1,3:size(FrequencyVisitsOutside,2)+2)=num2cell(FrequencyVisitsOutside(IndexNewSort,:));
raw(Initialrow:size(FrequencyVisitsOutside,1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+39*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Foraging correlation'};
raw(Initialrow:size(ForagingCorrelation,1)+Initialrow-1,3:size(ForagingCorrelation,2)+2)=num2cell(ForagingCorrelation(IndexNewSort,:));
raw(Initialrow:size(ForagingCorrelation,1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+40*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'ROI exploration (bits/hour)'}; %Larger values less information.
raw(Initialrow:size(ParametersSum(:,10,:),1)+Initialrow-1,3:size(ParametersSum(:,10,:),3)+2)=num2cell(EntropyDay(IndexNewSort,:));
raw(Initialrow:size(ParametersSum(:,10,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+41*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Median/mean speed (cm/sec)'}; 
raw(Initialrow:size(ParametersSum(:,17,:),1)+Initialrow-1,3:size(ParametersSum(:,17,:),3)+2)=num2cell(ParametersSum(IndexNewSort,17,:));
raw(Initialrow:size(ParametersSum(:,17,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+42*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Median/mean Aceleration (cm/sec^2)'}; 
raw(Initialrow:size(ParametersSum(:,56,:),1)+Initialrow-1,3:size(ParametersSum(:,56,:),3)+2)=num2cell(ParametersSum(IndexNewSort,56,:));
raw(Initialrow:size(ParametersSum(:,56,:),1)+Initialrow-1,2)=RankingArray(:,1);


Initialrow=1+43*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Distance traveled (m)'}; 
%raw(Initialrow:size(DistanceTravelDay,1)+Initialrow-1,3:size(DistanceTravelDay,2)+2)=num2cell(DistanceTravelDay(IndexNewSort,:)); %this distance is divided by number of events
raw(Initialrow:size(ParametersSum(:,42,:),1)+Initialrow-1,3:size(ParametersSum(:,42,:),3)+2)=num2cell(ParametersSum(IndexNewSort,42,:));%this is the total distance travelled by the mice inside the arenaduring a day in meter
raw(Initialrow:size(DistanceTravelDay,1)+Initialrow-1,2)=RankingArray(:,1);


Initialrow=1+44*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Angular velocity (rad/sec)'}; 
raw(Initialrow:size(AngularVelocityDay,1)+Initialrow-1,3:size(AngularVelocityDay,2)+2)=num2cell(AngularVelocityDay(IndexNewSort,:));
raw(Initialrow:size(AngularVelocityDay,1)+Initialrow-1,2)=RankingArray(:,1);

% %%%%%%%%%%%%%%%%%%%%%%%%% Normalization according total time %%%%%%%%%%%%%%%%%%%%%%%

Initialrow=1+45*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'RunningTime (% of Total time)'};
raw(Initialrow:size(ParametersSum(:,1,:),1)+Initialrow-1,3:size(ParametersSum(:,1,:),3)+2)=num2cell(ParametersSumTotalDetected(IndexNewSort,1,:));
raw(Initialrow:size(ParametersSum(:,1,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+46*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'WalkingTime (% of Total time)'};
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,3:size(ParametersSum(:,2,:),3)+2)=num2cell(ParametersSumTotalDetected(IndexNewSort,2,:));
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+47*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'StaticTime (% of Total time)'};
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,3:size(ParametersSum(:,2,:),3)+2)=num2cell(ParametersSumTotalDetected(IndexNewSort,3,:));
raw(Initialrow:size(ParametersSum(:,2,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+48*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'movementTime (% of Total time)'};
raw(Initialrow:size(ParametersSum(:,12,:),1)+Initialrow-1,3:size(ParametersSum(:,12,:),3)+2)=num2cell(ParametersSumTotalDetected(IndexNewSort,12,:));
raw(Initialrow:size(ParametersSum(:,12,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+49*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'eatingSumTime (% of Total time)'};
raw(Initialrow:size(ParametersSum(:,4,:),1)+Initialrow-1,3:size(ParametersSum(:,4,:),3)+2)=num2cell(ParametersSumTotalDetected(IndexNewSort,4,:));
raw(Initialrow:size(ParametersSum(:,4,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+50*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'drinkingSumTime(% of Total time)'};
raw(Initialrow:size( ParametersSum(:,5,:),1)+Initialrow-1,3:size(ParametersSum(:,5,:),3)+2)=num2cell(ParametersSumTotalDetected(IndexNewSort,5,:));
raw(Initialrow:size(ParametersSum(:,5,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+51*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'CenterTimeAlone (% of Total time)'};
raw(Initialrow:size(ParametersSum(:,11,:),1)+Initialrow-1,3:size(ParametersSum(:,11,:),3)+2)=num2cell(ParametersSumTotalDetected(IndexNewSort,11,:));
raw(Initialrow:size(ParametersSum(:,11,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+52*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'InsideZone(% of Total time)'};
raw(Initialrow:size(ParametersSum(:,9,:),1)+Initialrow-1,3:size(ParametersSum(:,9,:),3)+2)=num2cell(ParametersSumTotalDetected(IndexNewSort,9,:));
raw(Initialrow:size(ParametersSum(:,9,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+53*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'OutsideZone(% of Total time)'};
raw(Initialrow:size(ParametersSum(:,10,:),1)+Initialrow-1,3:size(ParametersSum(:,10,:),3)+2)=num2cell(ParametersSumTotalDetected(IndexNewSort,10,:));
raw(Initialrow:size(ParametersSum(:,10,:),1)+Initialrow-1,2)=RankingArray(:,1);


Initialrow=1+54*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'sleepingSumTime(% of Total time)'};
raw(Initialrow:size(ParametersSum(:,6,:),1)+Initialrow-1,3:size(ParametersSum(:,6,:),3)+2)=num2cell(ParametersSumTotalDetected(IndexNewSort,6,:));
raw(Initialrow:size(ParametersSum(:,6,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+55*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'hidingSumTime(% of Total time)'};
raw(Initialrow:size(ParametersSum(:,7,:),1)+Initialrow-1,3:size(ParametersSum(:,7,:),3)+2)=num2cell(ParametersSumTotalDetected(IndexNewSort,7,:));
raw(Initialrow:size(ParametersSum(:,7,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+56*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'ArenaSumTime(% of Total time)'};
raw(Initialrow:size(ParametersSum(:,8,:),1)+Initialrow-1,3:size(ParametersSum(:,8,:),3)+2)=num2cell(ParametersSumTotalDetected(IndexNewSort,8,:));
raw(Initialrow:size(ParametersSum(:,8,:),1)+Initialrow-1,2)=RankingArray(:,1);

% Add parameters of hiding + sleeping
Initialrow=1+57*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Hiding plus sleeping Time (min)'};
raw(Initialrow:size(ParametersSum(:,49,:),1)+Initialrow-1,3:size(ParametersSum(:,49,:),3)+2)=num2cell(ParametersSum(IndexNewSort,49,:));
raw(Initialrow:size(ParametersSum(:,8,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+58*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Hiding plus sleeping (% of Total time)'};
raw(Initialrow:size(ParametersSum(:,49,:),1)+Initialrow-1,3:size(ParametersSum(:,49,:),3)+2)=num2cell(ParametersSumTotalDetected(IndexNewSort,49,:));
raw(Initialrow:size(ParametersSum(:,8,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+59*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Hiding plus sleeping (N events)'};
raw(Initialrow:size(ParametersSum(:,50,:),1)+Initialrow-1,3:size(ParametersSum(:,50,:),3)+2)=num2cell(ParametersSumTotalDetected(IndexNewSort,50,:));
raw(Initialrow:size(ParametersSum(:,8,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+60*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Frequency visits the hiding boxes (1/hour)'};
raw(Initialrow:size(FrequencyVisitsHidingBox,1)+Initialrow-1,3:size(FrequencyVisitsHidingBox,2)+2)=num2cell(FrequencyVisitsHidingBox(IndexNewSort,:));
raw(Initialrow:size(FrequencyVisitsHidingBox,1)+Initialrow-1,2)=RankingArray(:,1);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Social parameters which were
% forget%%%%%%%%%%%%%%%%%%%%%%
Initialrow=1+61*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Together(N events)'};%less than 10cm
raw(Initialrow:size(ParametersSum(:,48,:),1)+Initialrow-1,3:size(ParametersSum(:,48,:),3)+2)=num2cell(ParametersSum(IndexNewSort,48,:));
raw(Initialrow:size(ParametersSum(:,48,:),1)+Initialrow-1,2)=RankingArray(:,1);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%Number of events with head to head %%%%%%
Initialrow=1+62*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Head to head(N events)'};%less than 2cm
raw(Initialrow:size(ParametersSum(:,52,:),1)+Initialrow-1,3:size(ParametersSum(:,52,:),3)+2)=num2cell(ParametersSum(IndexNewSort,52,:));
raw(Initialrow:size(ParametersSum(:,52,:),1)+Initialrow-1,2)=RankingArray(:,1);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%Number of events with head to tail %%%%%%
Initialrow=1+63*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Head to tail(N events)'};%less than 2cm
raw(Initialrow:size(ParametersSum(:,53,:),1)+Initialrow-1,3:size(ParametersSum(:,53,:),3)+2)=num2cell(ParametersSum(IndexNewSort,53,:));
raw(Initialrow:size(ParametersSum(:,53,:),1)+Initialrow-1,2)=RankingArray(:,1);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%Number of events with head to head -Normalized to the total time %%%%%%
Initialrow=1+64*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Head to head(1/min)'};%less than 2cm
raw(Initialrow:size(ParametersSum(:,52,:),1)+Initialrow-1,3:size(ParametersSum(:,52,:),3)+2)=num2cell(ParametersSumTotalDetected(IndexNewSort,52,:));
raw(Initialrow:size(ParametersSum(:,52,:),1)+Initialrow-1,2)=RankingArray(:,1);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%Number of events with head to tail - normalized to the total time %%%%%%
Initialrow=1+65*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Head to tail(1/min)'};%less than 2cm
raw(Initialrow:size(ParametersSum(:,53,:),1)+Initialrow-1,3:size(ParametersSum(:,53,:),3)+2)=num2cell(ParametersSumTotalDetected(IndexNewSort,53,:));
raw(Initialrow:size(ParametersSum(:,53,:),1)+Initialrow-1,2)=RankingArray(:,1);




% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Score of chasing%%%%%%%%%%%%%%%%%
Initialrow=1+66*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'David score'};
raw(Initialrow:size(NormDSAll,1)+Initialrow-1,3)=num2cell(NormDSAll(IndexNewSort,:));
raw(Initialrow:size(NormDSAll,1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+67*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Average elorating'};
raw(Initialrow:size(AverageElorating,1)+Initialrow-1,3)=num2cell(AverageElorating(IndexNewSort,:));
raw(Initialrow:size(AverageElorating,1)+Initialrow-1,2)=RankingArray(:,1);

% % Save the parameters as method score choice for sorting.
% Initialrow=1+68*(size(ParametersSum(:,1,:),1)+2);
% raw(Initialrow,1)={strcat('NOTE: The first mouse is the dominant sorted according to',ItemUsedToScore)};

%% Create array of days

Date=strcat(num2str(TimeArray(:,4)),'-',num2str(TimeArray(:,3)),'-',num2str(TimeArray(:,2)));

 raw(1,3:size(ParametersSum(:,1,:),3)+2)=(unique(cellstr(Date),'stable'))';%create the days
 
 
 %% Add at the end social matrix

 Initialrow=1+68*(size(ParametersSum(:,1,:),1)+2);
 raw(Initialrow,1)={'Social Matrix'};
 raw(Initialrow:Initialrow+size(SocialMatrix,1)-1,2:size(SocialMatrix,2)+1)=SocialMatrix;
  
Initialrow=1+69*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Glicko Error per Day'};
raw(Initialrow:Initialrow+size( GlickoErrorPerDay2,1)-1,3:size( GlickoErrorPerDay2,2)+2)= GlickoErrorPerDay2;
raw(Initialrow:size(ParametersSum(:,53,:),1)+Initialrow-1,2)=RankingArray(:,1);

%% Add new parameters
% duration
Initialrow=1+70*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Approaching duration (sec)'};
raw(Initialrow:size(ParametersSum(:,57,:),1)+Initialrow-1,3:size(ParametersSum(:,57,:),3)+2)=num2cell(ParametersSum(IndexNewSort,57,:));
raw(Initialrow:size(ParametersSum(:,57,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+71*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Be avoiding duration (sec)'};
raw(Initialrow:size(ParametersSum(:,58,:),1)+Initialrow-1,3:size(ParametersSum(:,58,:),3)+2)=num2cell(ParametersSum(IndexNewSort,58,:));
raw(Initialrow:size(ParametersSum(:,58,:),1)+Initialrow-1,2)=RankingArray(:,1);

%%%%%%%%%%%%
% number of events
Initialrow=1+72*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Be approaching (N events)'};
raw(Initialrow:size(ParametersSum(:,61,:),1)+Initialrow-1,3:size(ParametersSum(:,61,:),3)+2)=num2cell(ParametersSum(IndexNewSort,61,:));
raw(Initialrow:size(ParametersSum(:,61,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+73*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Avoiding (N events)'};
raw(Initialrow:size(ParametersSum(:,59,:),1)+Initialrow-1,3:size(ParametersSum(:,59,:),3)+2)=num2cell(ParametersSum(IndexNewSort,59,:));
raw(Initialrow:size(ParametersSum(:,59,:),1)+Initialrow-1,2)=RankingArray(:,1);
% duration

Initialrow=1+74*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Be approaching duration (sec)'};
raw(Initialrow:size(ParametersSum(:,62,:),1)+Initialrow-1,3:size(ParametersSum(:,62,:),3)+2)=num2cell(ParametersSum(IndexNewSort,62,:));
raw(Initialrow:size(ParametersSum(:,62,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+75*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Avoiding duration (sec)'};
raw(Initialrow:size(ParametersSum(:,60,:),1)+Initialrow-1,3:size(ParametersSum(:,60,:),3)+2)=num2cell(ParametersSum(IndexNewSort,60,:));
raw(Initialrow:size(ParametersSum(:,60,:),1)+Initialrow-1,2)=RankingArray(:,1);


Initialrow=1+76*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Being chasing duration(sec)'};
% raw(Initialrow:size(ParametersSum(:,23,:),1)+Initialrow-1,3:size(ParametersSum(:,23,:),3)+2)=num2cell(ParametersSum(IndexNewSort,23,:));
raw(Initialrow:size(ParametersSum(:,23,:),1)+Initialrow-1,3:size(ParametersSum(:,23,:),3)+2)=num2cell(BeingChasingDurationPerDay(IndexNewSort,:));

raw(Initialrow:size(ParametersSum(:,23,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+77*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Chasing plus being chasing duration(sec)'};
raw(Initialrow:size(ParametersSum(:,24,:),1)+Initialrow-1,3:size(ParametersSum(:,24,:),3)+2)=num2cell(ChasingBeingChasedEventsPerDay(IndexNewSort,:))
%raw(Initialrow:size(ParametersSum(:,24,:),1)+Initialrow-1,3:size(ParametersSum(:,24,:),3)+2)=num2cell(ParametersSum(IndexNewSort,24,:));
raw(Initialrow:size(ParametersSum(:,24,:),1)+Initialrow-1,2)=RankingArray(:,1);


Initialrow=1+78*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Chasing plus being chasing duration(sec)-FromRawData'};
%raw(Initialrow:size(ParametersSum(:,24,:),1)+Initialrow-1,3:size(ParametersSum(:,24,:),3)+2)=num2cell(ChasingBeingChasedEventsPerDay(IndexNewSort,:))
raw(Initialrow:size(ParametersSum(:,24,:),1)+Initialrow-1,3:size(ParametersSum(:,24,:),3)+2)=num2cell(ParametersSum(IndexNewSort,24,:));
raw(Initialrow:size(ParametersSum(:,24,:),1)+Initialrow-1,2)=RankingArray(:,1);


Initialrow=1+79*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Being chasing duration(sec)-FromRawData'};
 raw(Initialrow:size(ParametersSum(:,23,:),1)+Initialrow-1,3:size(ParametersSum(:,23,:),3)+2)=num2cell(ParametersSum(IndexNewSort,23,:));
%raw(Initialrow:size(ParametersSum(:,23,:),1)+Initialrow-1,3:size(ParametersSum(:,23,:),3)+2)=num2cell(BeingChasingDurationPerDay(IndexNewSort,:));
raw(Initialrow:size(ParametersSum(:,23,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+80*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Chasing duration (sec)-FromRawData'};
% raw(Initialrow:size(ParametersSum(:,22,:),1)+Initialrow-1,3:size(ParametersSum(:,22,:),3)+2)=num2cell(ChasingDurationPerDay(IndexNewSort,:));%In the case of manual tracking
raw(Initialrow:size(ParametersSum(:,22,:),1)+Initialrow-1,3:size(ParametersSum(:,22,:),3)+2)=num2cell(ParametersSum(IndexNewSort,22,:));
raw(Initialrow:size(ParametersSum(:,22,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+81*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'chasing all (N events)-FromRawData'};
%raw(Initialrow:size(ParametersSum(:,18,:),1)+Initialrow-1,3:size(ParametersSum(:,18,:),3)+2)=num2cell(ChasingEventsPerDay(IndexNewSort,:));%In the case of manual tracking
raw(Initialrow:size(ParametersSum(:,18,:),1)+Initialrow-1,3:size(ParametersSum(:,18,:),3)+2)=num2cell(ParametersSum(IndexNewSort,18,:));
raw(Initialrow:size(ParametersSum(:,18,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+82*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'being chased all(N events)-FromRawData'};
%raw(Initialrow:size(ParametersSum(:,19,:),1)+Initialrow-1,3:size(ParametersSum(:,19,:),3)+2)=num2cell(BeingChasingEventsPerDay(IndexNewSort,:));%In the case of manual tracking
raw(Initialrow:size(ParametersSum(:,19,:),1)+Initialrow-1,3:size(ParametersSum(:,19,:),3)+2)=num2cell(ParametersSum(IndexNewSort,19,:));
raw(Initialrow:size(ParametersSum(:,19,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+83*(size(ParametersSum(:,1,:),1)+2);
raw(Initialrow,1)={'Chasing plus being chasing all(N events-FromRawData)'};
%raw(Initialrow:size(ParametersSum(:,20,:),1)+Initialrow-1,3:size(ParametersSum(:,20,:),3)+2)=num2cell(ChasingPlusChased(IndexNewSort,:));%In the case of manual tracking
raw(Initialrow:size(ParametersSum(:,20,:),1)+Initialrow-1,3:size(ParametersSum(:,20,:),3)+2)=num2cell(ParametersSum(IndexNewSort,20,:));
raw(Initialrow:size(ParametersSum(:,20,:),1)+Initialrow-1,2)=RankingArray(:,1);
end