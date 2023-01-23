function raw=GetArrangementDataPerHour(ParametersHour,TimeHour,RankingArray,IndexNewSort,...
                                        ForagingCorrelationHour,FrequencyVisitsOutsideHour,ParametersSumActiveTimeHour,...
                                        DistanceTravelHour,AngularVelocityHour,FrequencyVisitsHidingBoxHour)

%% --------------------Arrange the data-Create an array by ordering according to elorating ranking per day--------------------------


raw{1,1}={'Detection per hour (hour)'};
raw(1,2)={'head chip / hour'};
raw(2,1)={'RunningTime(min)'};
raw(2:size(ParametersHour(:,1,:),1)+1,3:size(ParametersHour(:,1,:),3)+2)=num2cell(ParametersHour(IndexNewSort,1,:));
raw(2:size(ParametersHour(:,1,:),1)+1,2)=RankingArray(:,1);

Initialrow=1+size(ParametersHour(:,1,:),1)+2;
raw(Initialrow,1)={'WalkingTime(min)'};
raw(Initialrow:size(ParametersHour(:,2,:),1)+Initialrow-1,3:size(ParametersHour(:,2,:),3)+2)=num2cell(ParametersHour(IndexNewSort,2,:));
raw(Initialrow:size(ParametersHour(:,2,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+2*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'StaticTime(min)'};
raw(Initialrow:size(ParametersHour(:,2,:),1)+Initialrow-1,3:size(ParametersHour(:,2,:),3)+2)=num2cell(ParametersHour(IndexNewSort,3,:));
raw(Initialrow:size(ParametersHour(:,2,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+3*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'movementTime(min)'};
raw(Initialrow:size(ParametersHour(:,12,:),1)+Initialrow-1,3:size(ParametersHour(:,12,:),3)+2)=num2cell(ParametersHour(IndexNewSort,12,:));
raw(Initialrow:size(ParametersHour(:,12,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+4*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'sleepingSumTime(min)'};
raw(Initialrow:size(ParametersHour(:,6,:),1)+Initialrow-1,3:size(ParametersHour(:,6,:),3)+2)=num2cell(ParametersHour(IndexNewSort,6,:));
raw(Initialrow:size(ParametersHour(:,6,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+5*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'eatingSumTime(min)'};
raw(Initialrow:size(ParametersHour(:,4,:),1)+Initialrow-1,3:size(ParametersHour(:,4,:),3)+2)=num2cell(ParametersHour(IndexNewSort,4,:));
raw(Initialrow:size(ParametersHour(:,4,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+6*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'drinkingSumTime(min)'};
raw(Initialrow:size( ParametersHour(:,5,:),1)+Initialrow-1,3:size(ParametersHour(:,5,:),3)+2)=num2cell(ParametersHour(IndexNewSort,5,:));
raw(Initialrow:size(ParametersHour(:,5,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+7*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'hidingSumTime(min)'};
raw(Initialrow:size(ParametersHour(:,7,:),1)+Initialrow-1,3:size(ParametersHour(:,7,:),3)+2)=num2cell(ParametersHour(IndexNewSort,7,:));
raw(Initialrow:size(ParametersHour(:,7,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+8*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'ArenaSumTime(min)'};
raw(Initialrow:size(ParametersHour(:,8,:),1)+Initialrow-1,3:size(ParametersHour(:,8,:),3)+2)=num2cell(ParametersHour(IndexNewSort,8,:));
raw(Initialrow:size(ParametersHour(:,8,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+9*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'CenterTimeAlone(min)'};
raw(Initialrow:size(ParametersHour(:,11,:),1)+Initialrow-1,3:size(ParametersHour(:,11,:),3)+2)=num2cell(ParametersHour(IndexNewSort,11,:));
raw(Initialrow:size(ParametersHour(:,11,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+10*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'InsideZoneTime(min)'};
raw(Initialrow:size(ParametersHour(:,9,:),1)+Initialrow-1,3:size(ParametersHour(:,9,:),3)+2)=num2cell(ParametersHour(IndexNewSort,9,:));
raw(Initialrow:size(ParametersHour(:,9,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+11*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'OutsideZoneTime(min)'};
raw(Initialrow:size(ParametersHour(:,10,:),1)+Initialrow-1,3:size(ParametersHour(:,10,:),3)+2)=num2cell(ParametersHour(IndexNewSort,10,:));
raw(Initialrow:size(ParametersHour(:,10,:),1)+Initialrow-1,2)=RankingArray(:,1);

% Social behaviour
Initialrow=1+12*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'chasing all (N events)'};
raw(Initialrow:size(ParametersHour(:,18,:),1)+Initialrow-1,3:size(ParametersHour(:,18,:),3)+2)=num2cell(ParametersHour(IndexNewSort,18,:));
raw(Initialrow:size(ParametersHour(:,18,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+13*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'being chased all(N events)'};
raw(Initialrow:size(ParametersHour(:,19,:),1)+Initialrow-1,3:size(ParametersHour(:,19,:),3)+2)=num2cell(ParametersHour(IndexNewSort,19,:));
raw(Initialrow:size(ParametersHour(:,19,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+14*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'Chasing plus being chasing all(N events)'};
raw(Initialrow:size(ParametersHour(:,20,:),1)+Initialrow-1,3:size(ParametersHour(:,20,:),3)+2)=num2cell(ParametersHour(IndexNewSort,20,:));
raw(Initialrow:size(ParametersHour(:,20,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+15*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'Time together(min)'};%less than 10cm
raw(Initialrow:size(ParametersHour(:,21,:),1)+Initialrow-1,3:size(ParametersHour(:,21,:),3)+2)=num2cell(ParametersHour(IndexNewSort,21,:));
raw(Initialrow:size(ParametersHour(:,21,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+16*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'Distance pairs(cm)'};%less than 10cm
raw(Initialrow:size(ParametersHour(:,16,:),1)+Initialrow-1,3:size(ParametersHour(:,16,:),3)+2)=num2cell(ParametersHour(IndexNewSort,16,:));
raw(Initialrow:size(ParametersHour(:,16,:),1)+Initialrow-1,2)=RankingArray(:,1);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%
Initialrow=1+17*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'Chasing duration (sec)'};
raw(Initialrow:size(ParametersHour(:,22,:),1)+Initialrow-1,3:size(ParametersHour(:,22,:),3)+2)=num2cell(ParametersHour(IndexNewSort,22,:));
raw(Initialrow:size(ParametersHour(:,22,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+18*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'Being chasing duration(sec)'};
raw(Initialrow:size(ParametersHour(:,23,:),1)+Initialrow-1,3:size(ParametersHour(:,23,:),3)+2)=num2cell(ParametersHour(IndexNewSort,23,:));
raw(Initialrow:size(ParametersHour(:,23,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+19*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'Chasing plus being chasing duration(sec)'};
raw(Initialrow:size(ParametersHour(:,24,:),1)+Initialrow-1,3:size(ParametersHour(:,24,:),3)+2)=num2cell(ParametersHour(IndexNewSort,24,:));
raw(Initialrow:size(ParametersHour(:,24,:),1)+Initialrow-1,2)=RankingArray(:,1);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Initialrow=1+20*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'Approaching (N events)'};
raw(Initialrow:size(ParametersHour(:,37,:),1)+Initialrow-1,3:size(ParametersHour(:,37,:),3)+2)=num2cell(ParametersHour(IndexNewSort,37,:));
raw(Initialrow:size(ParametersHour(:,37,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+21*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'Be avoiding (N events)'};
raw(Initialrow:size(ParametersHour(:,38,:),1)+Initialrow-1,3:size(ParametersHour(:,38,:),3)+2)=num2cell(ParametersHour(IndexNewSort,38,:));
raw(Initialrow:size(ParametersHour(:,38,:),1)+Initialrow-1,2)=RankingArray(:,1);


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%  Events %%%%%%%%%%%%%%%%%%%%%%%%
Initialrow=1+22*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'RunningTime(N events)'};
raw(Initialrow:size(ParametersHour(:,25,:),1)+Initialrow-1,3:size(ParametersHour(:,25,:),3)+2)=num2cell(ParametersHour(IndexNewSort,25,:));
raw(Initialrow:size(ParametersHour(:,25,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+23*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'WalkingTime(N events)'};
raw(Initialrow:size(ParametersHour(:,26,:),1)+Initialrow-1,3:size(ParametersHour(:,26,:),3)+2)=num2cell(ParametersHour(IndexNewSort,26,:));
raw(Initialrow:size(ParametersHour(:,26,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+24*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'StaticTime(N events)'};
raw(Initialrow:size(ParametersHour(:,27,:),1)+Initialrow-1,3:size(ParametersHour(:,27,:),3)+2)=num2cell(ParametersHour(IndexNewSort,27,:));
raw(Initialrow:size(ParametersHour(:,27,:),1)+Initialrow-1,2)=RankingArray(:,1);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Initialrow=1+25*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'RunningTimeActive(% of Active time)'};
raw(Initialrow:size(ParametersHour(:,1,:),1)+Initialrow-1,3:size(ParametersHour(:,1,:),3)+2)=num2cell(ParametersSumActiveTimeHour(IndexNewSort,1,:));
raw(Initialrow:size(ParametersHour(:,1,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+26*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'WalkingTimeActive(% of Active time)'};
raw(Initialrow:size(ParametersHour(:,2,:),1)+Initialrow-1,3:size(ParametersHour(:,2,:),3)+2)=num2cell(ParametersSumActiveTimeHour(IndexNewSort,2,:));
raw(Initialrow:size(ParametersHour(:,2,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+27*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'StaticTimeActive(% of Active time)'};
raw(Initialrow:size(ParametersHour(:,3,:),1)+Initialrow-1,3:size(ParametersHour(:,3,:),3)+2)=num2cell(ParametersSumActiveTimeHour(IndexNewSort,3,:));
raw(Initialrow:size(ParametersHour(:,3,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+28*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'movementTimeActive(% of Active time)'};
raw(Initialrow:size(ParametersHour(:,12,:),1)+Initialrow-1,3:size(ParametersHour(:,12,:),3)+2)=num2cell(ParametersSumActiveTimeHour(IndexNewSort,12,:));
raw(Initialrow:size(ParametersHour(:,12,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+29*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'eatingSumTimeActive(% of Active time)'};
raw(Initialrow:size(ParametersHour(:,4,:),1)+Initialrow-1,3:size(ParametersHour(:,4,:),3)+2)=num2cell(ParametersSumActiveTimeHour(IndexNewSort,4,:));
raw(Initialrow:size(ParametersHour(:,4,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+30*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'drinkingSumTimeActive(% of Active time)'};
raw(Initialrow:size( ParametersHour(:,5,:),1)+Initialrow-1,3:size(ParametersHour(:,5,:),3)+2)=num2cell(ParametersSumActiveTimeHour(IndexNewSort,5,:));
raw(Initialrow:size(ParametersHour(:,5,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+31*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'CenterTimeAloneActive(% of Active time)'};
raw(Initialrow:size(ParametersHour(:,11,:),1)+Initialrow-1,3:size(ParametersHour(:,11,:),3)+2)=num2cell(ParametersSumActiveTimeHour(IndexNewSort,11,:));
raw(Initialrow:size(ParametersHour(:,11,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+32*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'InsideZoneTime(% of active time)'};
raw(Initialrow:size(ParametersHour(:,9,:),1)+Initialrow-1,3:size(ParametersHour(:,9,:),3)+2)=num2cell(ParametersSumActiveTimeHour(IndexNewSort,9,:));
raw(Initialrow:size(ParametersHour(:,9,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+33*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'OutsideZoneTime(% of active time)'};
raw(Initialrow:size(ParametersHour(:,10,:),1)+Initialrow-1,3:size(ParametersHour(:,10,:),3)+2)=num2cell(ParametersSumActiveTimeHour(IndexNewSort,10,:));
raw(Initialrow:size(ParametersHour(:,10,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+34*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'Frequency visits outside sleeping box (1/hour)'};
raw(Initialrow:size(FrequencyVisitsOutsideHour,1)+Initialrow-1,3:size(FrequencyVisitsOutsideHour,2)+2)=num2cell(FrequencyVisitsOutsideHour(IndexNewSort,:));
raw(Initialrow:size(FrequencyVisitsOutsideHour,1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+35*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'Foraging correlation'};
raw(Initialrow:size( ForagingCorrelationHour,1)+Initialrow-1,3:size( ForagingCorrelationHour,2)+2)=num2cell(ForagingCorrelationHour(IndexNewSort,:));
raw(Initialrow:size( ForagingCorrelationHour,1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+36*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'Distance traveled (m)'};
%raw(Initialrow:size( DistanceTravelHour,1)+Initialrow-1,3:size( DistanceTravelHour,2)+2)=num2cell(DistanceTravelHour(IndexNewSort,:));%this a mean distance per frame
raw(Initialrow:size(ParametersHour(:,42,:),1)+Initialrow-1,3:size(ParametersHour(:,42,:),3)+2)=num2cell(ParametersHour(IndexNewSort,42,:));%this is the total distance travelled during an hour
raw(Initialrow:size( DistanceTravelHour,1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+37*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'Angular velocity (rad/sec)'};
raw(Initialrow:size( AngularVelocityHour,1)+Initialrow-1,3:size( AngularVelocityHour,2)+2)=num2cell(AngularVelocityHour(IndexNewSort,:));
raw(Initialrow:size( AngularVelocityHour,1)+Initialrow-1,2)=RankingArray(:,1);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Parameter related with sleeping plus
% hiding
Initialrow=1+38*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'Hiding plus sleeping Time (min)'};
raw(Initialrow:size(ParametersHour(:,49,:),1)+Initialrow-1,3:size(ParametersHour(:,49,:),3)+2)=num2cell(ParametersHour(IndexNewSort,49,:));
raw(Initialrow:size(ParametersHour(:,49,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+39*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'Hiding plus sleeping (N events)'};
raw(Initialrow:size(ParametersHour(:,50,:),1)+Initialrow-1,3:size(ParametersHour(:,50,:),3)+2)=num2cell(ParametersHour(IndexNewSort,50,:));
raw(Initialrow:size(ParametersHour(:,50,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+40*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'Frequency visits the hiding boxes (1/hour)'};
raw(Initialrow:size( FrequencyVisitsHidingBoxHour,1)+Initialrow-1,3:size( FrequencyVisitsHidingBoxHour,2)+2)=num2cell( FrequencyVisitsHidingBoxHour(IndexNewSort,:));
raw(Initialrow:size( FrequencyVisitsHidingBoxHour,1)+Initialrow-1,2)=RankingArray(:,1);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%Number of events with head to tail %%%%%%
Initialrow=1+41*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'Head to head(N events)'};%less than 2cm
raw(Initialrow:size(ParametersHour(:,53,:),1)+Initialrow-1,3:size(ParametersHour(:,52,:),3)+2)=num2cell(ParametersHour(IndexNewSort,52,:));
raw(Initialrow:size(ParametersHour(:,53,:),1)+Initialrow-1,2)=RankingArray(:,1);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%Number of events with head to head -Normalized to the total time %%%%%%
Initialrow=1+42*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'Head to tail(N events)'};%less than 2cm
raw(Initialrow:size(ParametersHour(:,52,:),1)+Initialrow-1,3:size(ParametersHour(:,53,:),3)+2)=num2cell(ParametersHour(IndexNewSort,53,:));
raw(Initialrow:size(ParametersHour(:,52,:),1)+Initialrow-1,2)=RankingArray(:,1);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Aproaching and avoiding
% duration
Initialrow=1+43*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'Approaching duration (sec)'};
raw(Initialrow:size(ParametersHour(:,57,:),1)+Initialrow-1,3:size(ParametersHour(:,57,:),3)+2)=num2cell(ParametersHour(IndexNewSort,57,:));
raw(Initialrow:size(ParametersHour(:,57,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+44*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'Be avoiding duration (sec)'};
raw(Initialrow:size(ParametersHour(:,58,:),1)+Initialrow-1,3:size(ParametersHour(:,58,:),3)+2)=num2cell(ParametersHour(IndexNewSort,58,:));
raw(Initialrow:size(ParametersHour(:,58,:),1)+Initialrow-1,2)=RankingArray(:,1);

%%%%%%%%%%%%
% number of events
Initialrow=1+45*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'Be approaching (N events)'};
raw(Initialrow:size(ParametersHour(:,61,:),1)+Initialrow-1,3:size(ParametersHour(:,61,:),3)+2)=num2cell(ParametersHour(IndexNewSort,61,:));
raw(Initialrow:size(ParametersHour(:,61,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+46*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'Avoiding (N events)'};
raw(Initialrow:size(ParametersHour(:,59,:),1)+Initialrow-1,3:size(ParametersHour(:,59,:),3)+2)=num2cell(ParametersHour(IndexNewSort,59,:));
raw(Initialrow:size(ParametersHour(:,59,:),1)+Initialrow-1,2)=RankingArray(:,1);
% duration

Initialrow=1+47*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'Be approaching duration (sec)'};
raw(Initialrow:size(ParametersHour(:,62,:),1)+Initialrow-1,3:size(ParametersHour(:,62,:),3)+2)=num2cell(ParametersHour(IndexNewSort,62,:));
raw(Initialrow:size(ParametersHour(:,62,:),1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+48*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'Avoiding duration (sec)'};
raw(Initialrow:size(ParametersHour(:,60,:),1)+Initialrow-1,3:size(ParametersHour(:,60,:),3)+2)=num2cell(ParametersHour(IndexNewSort,60,:));
raw(Initialrow:size(ParametersHour(:,60,:),1)+Initialrow-1,2)=RankingArray(:,1);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
Initialrow=1+49*(size(ParametersHour(:,1,:),1)+2);
raw(Initialrow,1)={'Together(N events)'};%less than 10cm
raw(Initialrow:size(ParametersHour(:,48,:),1)+Initialrow-1,3:size(ParametersHour(:,48,:),3)+2)=num2cell(ParametersHour(IndexNewSort,48,:));
raw(Initialrow:size(ParametersHour(:,48,:),1)+Initialrow-1,2)=RankingArray(:,1);



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add time of detection
DetectionTime=cumsum(TimeHour)/60;% conversion to hours
raw(1,3:size(ParametersHour(:,1,:),3)+2)=num2cell(DetectionTime);
raw{1,1}={'Detection per hour (hour)'};
end