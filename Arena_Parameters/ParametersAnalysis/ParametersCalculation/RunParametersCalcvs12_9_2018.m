function RunParametersCalc(~,~)
%--------------------To calculate all the parameters by using all
%GUI--------

%% 

%NOTE: FOR THIS CALCULATION NO REPEATS ARE CONSIDERED
%% 
global h
%% Load parameters
% Params=ParametersComputeAll();
% staticVelocity=Params.TreshWalk;
staticVelocity=0.5; %INSERT INTO MATLAB PARAMETERS
%% Variables
 SaveFolder=strcat(get(h.editSave,'string'),'\')
%-------------------Select the experiments-------------------
index_selected = get(h.listRunParams,'Value');
list = get(h.listRunParams,'String');
item_selected = list(index_selected,1); % Convert from cell array

Exp_arrA=item_selected'; %Input Data



%% -----------------------Select the experiments -----------------------
hbar = waitbar(0,'Please wait...');
for t=1:length(item_selected) %LOOP FOR EACH EXPERIMENT
%% ----------Select according to checkbox-------
if get(h.checkbox2,'Value')==1  %In the case of running only the parameters 
    
Folder_Data=strcat(get(h.editRunParams,'string'),'\',item_selected(t),'\','Data','\',strcat(item_selected(t),'ResultsMatlab','\'));
Folder_Data=char(Folder_Data);
ListFiles=dir([Folder_Data,'*.mat']);
%% 
item_selected(t)
ListDates={}; %like clear for each experiment
clear B;
clear subStr_arrA;
clear raw;

for i=1:length(ListFiles(not([ListFiles.isdir])))
I=strfind(ListFiles(i).name,'-');
Aux=char(ListFiles(i).name);
ListDates(i)=cellstr(Aux(1:I(1)-1));
end
%sort the date list

%[B,I]=sort(unique(ListDates));
%% 

VectorDate=datevec(unique(ListDates),'DD.MM.YYYY');

VectorDateSort=sortrows(VectorDate,[1,5,3]);

Year=VectorDateSort(:,1);
Month=VectorDateSort(:,5);
Day=VectorDateSort(:,3);

% [Year,Iyear]=sort(VectorDate(:,1));
% 
% [Month,Imonth]=sort(VectorDate(Iyear,5)); %sort the month
% Day=VectorDate(Iyear,3); %sort according the day according to the year.
% Day=Day(Imonth);  %sort according to the month

%% 
for jj=1:length(Day)
    D=num2str(Day(jj));
    M=num2str(Month(jj));
    Y=num2str(Year(jj));
    
    
B{jj}=strcat(D,'.',M,'.',Y);

end

subStr_arrA{1,:}=B;





 %A=subStr_arrA{1,:}
%% -------------------LOOP FOR EACH DAY-------------------------
% ListFiles(1).name

%% 
 RunningTimePercent=[]; %each row is for each mouse and the columns represented the days
    WalkingTimePercent=[];
    StaticTimePercent=[];
    EatingTimePercent=[];
    
    
    DrinkingTimePercent=[];
    SleepingTimePercent=[];
    HidingTimePercent=[];
     ArenaTimePercent=[];
     OutsideZoneTimePercent=[];
     InsideZoneTimePercent=[];
    ChasingEventsPerDay=[];
    BeingChasingEventsPerDay=[];
    MovementTimePercent=[];
    AverageDistancePairsPerDay=[];
    AverageVelocityPerDay=[];
    AloneTimePercent=[];
    TogetherTimePercent=[];
     ChasingDurationPerDay=[];
    ChasingLengthPerDay=[];
    RankingArray=[];
     RunningTimePercentActive=[];
     WalkingTimePercentActive=[];
      StaticTimePercentActive=[];
     EatingTimePercentActive=[];
     DrinkingTimePercentActive=[];
     AloneTimePercentActive=[];
      InsideZoneTimePercentActive=[];
     OutsideZoneTimePercentActive=[]; 
     ActiveTimePerDay=[];
%% 
 %for i=1

  for i=1:length(subStr_arrA{1,:}) %go over the list %loop over each date
    %------Variables definition---------------
    %load one matlab file for mice list
    load(strcat(Folder_Data,ListFiles(1).name));
    i
    RunningTime(:,1)=zeros(length(Locomotion.AssigRFID.miceList),1);
    WalkingTime(:,1)=zeros(length(Locomotion.AssigRFID.miceList),1);
    StaticTime(:,1)=zeros(length(Locomotion.AssigRFID.miceList),1);
    EatingTime(:,1)=zeros(length(Locomotion.AssigRFID.miceList),1);
    SleepingTime(:,1)=zeros(length(Locomotion.AssigRFID.miceList),1);
    HidingTime(:,1)=zeros(length(Locomotion.AssigRFID.miceList),1);
    DrinkingTime(:,1)=zeros(length(Locomotion.AssigRFID.miceList),1);
    ChasingEvents(:,1)=zeros(length(Locomotion.AssigRFID.miceList),1);
    BeingChasingEvents(:,1)=zeros(length(Locomotion.AssigRFID.miceList),1);
    MovementTime(:,1)=zeros(length(Locomotion.AssigRFID.miceList),1);
    ActiveTime(:,1)=zeros(length(Locomotion.AssigRFID.miceList),1);
    
    clear DistPairs;
    DistPairs=[];
    SumVelocity=[];
    DataSize(:,1)=zeros(length(Locomotion.AssigRFID.miceList),1);
    ArenaTime(:,1)=zeros(length(Locomotion.AssigRFID.miceList),1);
    InsideZoneTime(:,1)=zeros(length(Locomotion.AssigRFID.miceList),1);
    OutsideZoneTime(:,1)=zeros(length(Locomotion.AssigRFID.miceList),1);
    AloneTime(:,1)=zeros(length(Locomotion.AssigRFID.miceList),1);
    TogetherTime=zeros(length(Locomotion.AssigRFID.miceList),length(Locomotion.AssigRFID.miceList));
    ChasingDuration=[];
    ChasingLength=[];
    TotalTime=0;
    
    %% ----------------------------LOOP FOR EACH MAT FILE------------------
    SelectedFilesNumber=[]; %clearence
   
    SelectedFilesNumber=find(strcmp(subStr_arrA{1,:}(i),ListDates)==1);
    elapsetime=0;
   
    for j=1:length(SelectedFilesNumber)%loop over the files of each date
%  j 
   load(strcat(Folder_Data,ListFiles(SelectedFilesNumber(j)).name));    
      ListFiles(SelectedFilesNumber(j)).name  
%              Locomotion.miceList; 
%              Locomotion.isStop;
%              Locomotion.isWalking;
%              Locomotion.isRunning;
%              Locomotion.IsEating;
%              Locomotion.IsDrinking;
%              Locomotion.ChasingAll;

             %% 
             
             %%------- Calculate the real time lapse the experiment for
             %%each file
             
             k1=strfind(ListFiles(SelectedFilesNumber(j)).name  ,'[');
             k2=strfind(ListFiles(SelectedFilesNumber(j)).name  ,'-');
             fileE=ListFiles(SelectedFilesNumber(j)).name;
             t1=fileE(k1(1)+1:k2(3)-1);
             t2=fileE(k2(3)+1:length(fileE)-5);
             
            elapsetime= elapsetime+(etime(datevec(t2,'HH_MM_SS.FFF'),datevec(t1,'HH_MM_SS.FFF')))/(60); %in minutes
             
       
             %% ---Find percentage of running time per day--------------
            
         %RunningTime(:,1)=   RunningTime(:,1) +(sum(Locomotion.AssigRFID.Arena.IsRunning,1))' ; %each row is for each mouse/that is sum over the rows
          RunningTime(:,1)=RunningTime(:,1)+GetTimeDurationParameter(Locomotion.AssigRFID.Arena.IsRunning,Locomotion.ExperimentTime);  %The time is in minutes
          
         
            %% ---Find percentage of walking time per day--------------
         %WalkingTime(:,1)=   WalkingTime(:,1) +(sum(Locomotion.isWalking,1))' ; %each row is for each mouse
          WalkingTime(:,1)=   WalkingTime(:,1) +GetTimeDurationParameter(Locomotion.AssigRFID.Arena.IsWalking,Locomotion.ExperimentTime); %each row is for each mouse
         
            %% ---Find percentage of static time per day with velocity less than 0.5 cm/sec by default--------------
         
            StaticTime(:,1)=   StaticTime(:,1) +GetTimeDurationParameter(Locomotion.AssigRFID.Arena.IsStopping,Locomotion.ExperimentTime); %each row is for each mouse
         
                %% ---Find percentage of eating time per day --------------
         EatingTime(:,1)= EatingTime(:,1) +GetTimeDurationParameter(Locomotion.AssigRFID.EatingDrinking.IsEatingAccordingPlaceVelocity,Locomotion.ExperimentTime); %each row is for each mouse
         
       
                %% ---Find percentage of drinking time per day --------------
         DrinkingTime(:,1)= DrinkingTime(:,1) +GetTimeDurationParameter(Locomotion.AssigRFID.EatingDrinking.IsDrinking,Locomotion.ExperimentTime); %each row is for each mouse
         %% -----------------Find percentage of sleeping time per day-----------
         SleepingTime(:,1)= SleepingTime(:,1) +GetTimeDurationParameter(Locomotion.AssigRFID.Sleeping.IsSleeping,Locomotion.ExperimentTime); %each row is for each mouse
         %% ----------------Find percentage of hiding time per day
         HidingTime(:,1)= HidingTime(:,1) +GetTimeDurationParameter(Locomotion.AssigRFID.Hiding.IsHiding,Locomotion.ExperimentTime); %each row is for each mouse
         %% -----------------Find percentage of time  the mice were in the arena--------------
        
          ArenaTime(:,1)= ArenaTime(:,1) +GetTimeDurationParameter(Locomotion.AssigRFID.Arena.InArena,Locomotion.ExperimentTime); %each row is for each mouse
          %%  %% -----------------Find percentage of time  the mice is inside the zone--------------
       %sum(Locomotion.IsInsideZone,1)
          InsideZoneTime(:,1)= InsideZoneTime(:,1)+GetTimeDurationParameter(Locomotion.AssigRFID.Arena.InsideZone,Locomotion.ExperimentTime);  %each row is for each mouse
          %%  %% -----------------Find percentage of time  the mice is outside the zone--------------
        %sum(Locomotion.IsOutsideZone,1)
          OutsideZoneTime(:,1)= OutsideZoneTime(:,1)+GetTimeDurationParameter(Locomotion.AssigRFID.Arena.OutsideZone,Locomotion.ExperimentTime); %each row is for each mouse
             
        %% -------Calculate percent of time the mouse is alone in the arena from total experimental time
        %time in minutes
        AloneTime(:,1)=AloneTime(:,1)+(calcAloneTime(Locomotion.AssigRFID.Arena.InArena,Locomotion.ExperimentTime));
        
        
        %% ---Find movement time  as percent of time the mice walking and running inside the arena -Movement
         MovementTime(:,1)= MovementTime(:,1)+ RunningTime(:,1)+WalkingTime(:,1); %each row is for each mouse In minutes
        
        %% -----Calculate if it is together in the arena-------------
%         size(TogetherTime)
%         size(Locomotion.TimesTogether{:})
        TogetherTime=TogetherTime+Locomotion.AssigRFID.Behaviour.Together.TimesTogetherSec{1, 1};%Here we created a matrix nXn and look for the distance from each mouse it is in seconds
         
         TotalTime=TotalTime+ArenaTime(:,1)+SleepingTime(:,1)+HidingTime(:,1);   %total time was detectede 
         
         %-------------Find active time inside the arena---------------------
         ActiveTime(:,1)= ActiveTime(:,1)+ArenaTime(:,1);  %each row is for each mouse
        
%          %% -----------------Find number of chasing per day-----------------
%           ChasingEventsPerFile=CalculateNumberChasing(Locomotion.ChasingAll);   
%               
%           ChasingEvents(:,1)= ChasingEvents(:,1)+(ChasingEventsPerFile)';
          
%           %% ---Find chasing duration and length duration
%           [ChasingDurationPerFile ChasingLengthPerFile]=CalculateChasingDurationLength(Locomotion.ChasingAll,Locomotion.TrajectoryX,Locomotion.TrajectoryY,length(Locomotion.miceList));
%           ChasingDuration=[ChasingDuration,ChasingDurationPerFile]; %accumlation of chasing duration in real frames
%           ChasingLength=[ChasingLength,ChasingLengthPerFile./10]; %WORK IN CM
          %% 
%           
%          %---------------------Find the number of being chasing per day----------------- 
%          BeingChasingEventsPerFile=CalculateNumberChasing(Locomotion.BeingChasingAll); 
%          
%          BeingChasingEvents(:,1)= BeingChasingEvents(:,1)+(BeingChasingEventsPerFile)';
         

         %% -------Insert average per day distance pair between mice
         DistPairs=[DistPairs,(calcDistancePairs(length(Locomotion.AssigRFID.miceList),Locomotion.AssigRFID.Behaviour.DistancePairs))];
         
         %% -----------Calculate the average velocity per day----------------------------
         
         SumVelocity=[SumVelocity, calcVelocity(Locomotion.Velocity,staticVelocity)];
        
       
      
       
               
    end
    i
  
    %% 
    
    %-------Information per day-----------------------  
    RunningTimePercent(:,i)=(RunningTime./TotalTime)*100; %each row is for each mouse and the columns represented the days
    WalkingTimePercent(:,i)=(WalkingTime./TotalTime)*100;
    StaticTimePercent(:,i)=(StaticTime./TotalTime)*100;
    EatingTimePercent(:,i)=(EatingTime./TotalTime)*100;
    DrinkingTimePercent(:,i)=(DrinkingTime./TotalTime)*100;
    SleepingTimePercent(:,i)=(SleepingTime./TotalTime)*100;
    HidingTimePercent(:,i)=(HidingTime./TotalTime)*100;
    ArenaTimePercent(:,i)=(ArenaTime./TotalTime)*100;
    AloneTimePercent(:,i)=(AloneTime./TotalTime)*100;
    InsideZoneTimePercent(:,i)=(InsideZoneTime./TotalTime)*100;
    OutsideZoneTimePercent(:,i)=(OutsideZoneTime./TotalTime)*100;
    
    %%----------Normalize relative to the active time(in Arena without
    %%hiding and sleeping)for each day.Note that each mouse  is divided by
    %%a different time-Normalize parameters related to activity
    RunningTimePercentActive(:,i)=(RunningTime./ ActiveTime)*100; %each row is for each mouse and the columns represented the days
    WalkingTimePercentActive(:,i)=(WalkingTime./ ActiveTime)*100;
    StaticTimePercentActive(:,i)=(StaticTime./ ActiveTime)*100;
    EatingTimePercentActive(:,i)=(EatingTime./ ActiveTime)*100;
    DrinkingTimePercentActive(:,i)=(DrinkingTime./ ActiveTime)*100;
    ActiveTimePerDay(:,i)=ActiveTime;
    
    
    AloneTimePercentActive(:,i)=(AloneTime./ ActiveTime)*100;
    InsideZoneTimePercentActive(:,i)=(InsideZoneTime./ ActiveTime)*100;
    OutsideZoneTimePercentActive(:,i)=(OutsideZoneTime./ ActiveTime)*100;
    
%     ActiveTime
%     InsideZoneTime
%    OutsideZoneTime
    
    %% 
    
    
    TogetherTime(find(TogetherTime==0))=NaN;
    TogetherTimePercent(:,i)=(mean(TogetherTime,2,'omitnan')./TotalTime)*100;% We are doing the mean for each mouse from the events to the other mouse.
                          
%     ChasingEventsPerDay(:,i)=ChasingEvents;
%     BeingChasingEventsPerDay(:,i)=BeingChasingEvents;
%     ChasingDurationPerDay(:,i)=mean(ChasingDuration,2,'omitnan')*80; %NOTE MULTIPLIED BY 80 MS BUT ITS NOT SURE
%     ChasingLengthPerDay(:,i)=mean(ChasingLength,2,'omitnan');
    
    MovementTimePercent(:,i)=(MovementTime./TotalTime)*100;
     MovementTimePercentActive(:,i)=(MovementTime./ActiveTime)*100;
     
    AverageDistancePairsPerDay(:,i)=mean(DistPairs,2,'omitnan');
    
    AverageVelocityPerDay(:,i)=mean(SumVelocity,2,'omitnan');
    
    TotalExpTime(i)=TotalTime;
    ElapseTimePerDay(i)=elapsetime;
  end
  %% --------------------Find number of chasing per day BY USING THE CORRECTED LIST------------------------------
    %% -----------------Load  excel file--------------------------------
    ChasingFile=strcat(get(h.editRunParams,'string'),'\',item_selected(t),'\','Data','\','Results','\',strcat(item_selected(t),'_ChasingResults.xlsx')); %OPen chasing excel file
    sheet='Chasing';
    [num txt ChasingList]=xlsread(char(ChasingFile),sheet);
    
     sheet='Elo-rating All Events';
    [num txt EloratingList]=xlsread(char(ChasingFile),sheet);
    
      sheet='Elo-rating per day order';
    [num txt EloratingPerLastDay]=xlsread(char(ChasingFile),sheet);
    
    
%     sheet='Elo-rating per day order';
%     [num txt EloratingPerlastDay]=xlsread(char(ChasingFile),sheet);
%     EloratingPerlastDay=EloratingPerlastDay(3:end,2:length(miceList)+1);
%     EloratingPerlastDay=(EloratingPerlastDay)';
       
    %% -------------Find events per day of chasing and being chasing----------------
    NormDS=[];
    EloratingAveragePerDay=[];
    ChasingEventsPerDay=[];
    BeingChasingEventsPerDay=[];
    ChasingDurationPerDay=[];
    InteractionMatrix=[];
    
    
    
       [NormDS EloratingAveragePerDay ChasingEventsPerDay BeingChasingEventsPerDay ChasingDurationPerDay  InteractionMatrix]=CalculateNumberChasingCorrected( Locomotion.miceList,ChasingList,EloratingList,length(subStr_arrA{1,:}));
      
       ChasingTimePercentActive=(ChasingDurationPerDay./ActiveTimePerDay)*100;
       [DSAll NormDSAll]=CalculateDavidScore(InteractionMatrix); %Calculate David Score without considerading interactions
       [DSAllD NormDSAllD]=CalculateDavidScoreWithDominance(InteractionMatrix);%Calculate David Score by considerading interactions
       
        NormDSAllDPerDay=CalculateDavidScoreWithDominancePerDay(InteractionMatrix);%Calculate David Score by considerading interactions per day
         
%% -----------Sort the data according to the ranking from elorating calculation-------------
% Steps-Load ranking-remove'' from the string values- Find index of the ordered list-Create a new matrix in the given
% order
% ChasingFile=strcat(get(h.editRunParams,'string'),'\',item_selected(t),'\','Data','\','ChasingResults','\',strcat(item_selected(t),'_ChasingResults.xlsx')); %OPen chasing excel file
 sheet='Ranking';
 [num txt RankingArray]=xlsread(char(ChasingFile),sheet);
 %% 
 
IndexNew=FindIndex(strrep(RankingArray(:,1),'''',''),(Locomotion.miceList)');

  RunningTimePercent= RunningTimePercent(IndexNew,:);
    WalkingTimePercent=WalkingTimePercent(IndexNew,:);
    StaticTimePercent=StaticTimePercent(IndexNew,:);
    EatingTimePercent=EatingTimePercent(IndexNew,:);
    DrinkingTimePercent=DrinkingTimePercent(IndexNew,:);
    SleepingTimePercent=SleepingTimePercent(IndexNew,:);
    HidingTimePercent=HidingTimePercent(IndexNew,:);
    ArenaTimePercent= ArenaTimePercent(IndexNew,:);
    AloneTimePercent=AloneTimePercent(IndexNew,:);
    TogetherTimePercent=TogetherTimePercent(IndexNew,:);
    ChasingEventsPerDay=ChasingEventsPerDay(IndexNew,:);
    BeingChasingEventsPerDay=BeingChasingEventsPerDay(IndexNew,:);
    ChasingTimePercentActive=ChasingTimePercentActive(IndexNew,:);
    EloratingAveragePerDay=EloratingAveragePerDay(IndexNew,:);
    EloratingPerLastDay=(EloratingPerLastDay(3:end,2:length(Locomotion.miceList)+1))'; %Copy the elorating of the last day
    
    %Spetial for interaction matrix
    InteractionMatrix=InteractionMatrix(IndexNew,:,:);%reorder the rows
     InteractionMatrix=InteractionMatrix(:,IndexNew,:); %reorder the columns
    
    
%     ChasingDurationPerDay= ChasingDurationPerDay(IndexNew,:);
%     ChasingLengthPerDay= ChasingLengthPerDay(IndexNew,:);
    MovementTimePercent=MovementTimePercent(IndexNew,:);
    AverageDistancePairsPerDay=AverageDistancePairsPerDay(IndexNew,:);
    AverageVelocityPerDay=AverageVelocityPerDay(IndexNew,:);
    InsideZoneTimePercent= InsideZoneTimePercent(IndexNew,:);
    OutsideZoneTimePercent= OutsideZoneTimePercent(IndexNew,:); 
    RunningTimePercentActive=RunningTimePercentActive(IndexNew,:);
    WalkingTimePercentActive=WalkingTimePercentActive(IndexNew,:);
    StaticTimePercentActive=StaticTimePercentActive(IndexNew,:); 
    EatingTimePercentActive=EatingTimePercentActive(IndexNew,:);
    DrinkingTimePercentActive=DrinkingTimePercentActive(IndexNew,:);
    AloneTimePercentActive= AloneTimePercentActive(IndexNew,:);
    InsideZoneTimePercentActive=InsideZoneTimePercentActive(IndexNew,:); 
    OutsideZoneTimePercentActive=OutsideZoneTimePercentActive(IndexNew,:); 
    MovementTimePercentActive=MovementTimePercentActive(IndexNew,:); 
    
    NormDSAll=NormDSAll(IndexNew);
    NormDSAllD=NormDSAllD(IndexNew);
   
    NormDSAllDPerDay=NormDSAllDPerDay(IndexNew,:);
    
    TotalExpTime(i)=TotalTime;
    ElapseTimePerDay(i)=elapsetime;


%% --------------------Arrange the data-Create an array --------------------------

raw{1,1}={'Days'};
raw(1,2)={'head chip'};
raw(2,1)={'RunningTime(% of time)'};
raw(2:size(RunningTimePercent,1)+1,3:size(RunningTimePercent,2)+2)=num2cell(RunningTimePercent);
%raw(2:size(RunningTimePercent,1)+1,2)=strcat('''',(Locomotion.miceList)','''');
raw(2:size(RunningTimePercent,1)+1,2)=RankingArray(:,1);

Initialrow=1+size(RunningTimePercent,1)+2;
raw(Initialrow,1)={'WalkingTime(% of time)'};
raw(Initialrow:size(WalkingTimePercent,1)+Initialrow-1,3:size(WalkingTimePercent,2)+2)=num2cell(WalkingTimePercent);
% raw(Initialrow:size(WalkingTimePercent,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');
raw(Initialrow:size(WalkingTimePercent,1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+2*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'StaticTime(% of time)'};
raw(Initialrow:size(StaticTimePercent,1)+Initialrow-1,3:size(StaticTimePercent,2)+2)=num2cell(StaticTimePercent);
raw(Initialrow:size(StaticTimePercent,1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+3*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'movementTime(% of time)'};
raw(Initialrow:size(MovementTimePercent,1)+Initialrow-1,3:size(MovementTimePercent,2)+2)=num2cell(MovementTimePercent);
% raw(Initialrow:size(MovementTimePercent,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');
raw(Initialrow:size(MovementTimePercent,1)+Initialrow-1,2)=RankingArray(:,1);



Initialrow=1+4*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'sleepingSumTime(% of time)'};
raw(Initialrow:size( SleepingTimePercent,1)+Initialrow-1,3:size( SleepingTimePercent,2)+2)=num2cell( SleepingTimePercent);
%raw(Initialrow:size( SleepingTimePercent,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');
raw(Initialrow:size( SleepingTimePercent,1)+Initialrow-1,2)=RankingArray(:,1);


Initialrow=1+5*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'eatingSumTime(% of time)'};
raw(Initialrow:size(EatingTimePercent,1)+Initialrow-1,3:size(EatingTimePercent,2)+2)=num2cell(EatingTimePercent);
% raw(Initialrow:size(EatingTimePercent,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');
raw(Initialrow:size(EatingTimePercent,1)+Initialrow-1,2)=RankingArray(:,1);


Initialrow=1+6*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'drinkingSumTime(% of time)'};
raw(Initialrow:size( DrinkingTimePercent,1)+Initialrow-1,3:size( DrinkingTimePercent,2)+2)=num2cell( DrinkingTimePercent);
% raw(Initialrow:size( DrinkingTimePercent,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');
raw(Initialrow:size( DrinkingTimePercent,1)+Initialrow-1,2)=RankingArray(:,1);



Initialrow=1+7*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'hidingSumTime(% of time)'};
raw(Initialrow:size( HidingTimePercent,1)+Initialrow-1,3:size( HidingTimePercent,2)+2)=num2cell( HidingTimePercent);
%raw(Initialrow:size( HidingTimePercent,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');
raw(Initialrow:size( HidingTimePercent,1)+Initialrow-1,2)=RankingArray(:,1);


Initialrow=1+8*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'ArenaSumTime(% of time)'};
raw(Initialrow:size(ArenaTimePercent,1)+Initialrow-1,3:size(ArenaTimePercent,2)+2)=num2cell(ArenaTimePercent);
%raw(Initialrow:size(ArenaTimePercent,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');
raw(Initialrow:size(ArenaTimePercent,1)+Initialrow-1,2)=RankingArray(:,1);



Initialrow=1+9*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'CenterTimeAlone(% of time)'};
raw(Initialrow:size(AloneTimePercent,1)+Initialrow-1,3:size(AloneTimePercent,2)+2)=num2cell(AloneTimePercent);
%raw(Initialrow:size(AloneTimePercent,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');
raw(Initialrow:size(AloneTimePercent,1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+10*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'InsideZoneTime(% of time)'};
raw(Initialrow:size(InsideZoneTimePercent,1)+Initialrow-1,3:size(InsideZoneTimePercent,2)+2)=num2cell(InsideZoneTimePercent);
%raw(Initialrow:size(AloneTimePercent,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');
raw(Initialrow:size(InsideZoneTimePercent,1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+11*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'OutsideZoneTime(% of time)'};
raw(Initialrow:size(OutsideZoneTimePercent,1)+Initialrow-1,3:size(OutsideZoneTimePercent,2)+2)=num2cell(OutsideZoneTimePercent);
%raw(Initialrow:size(AloneTimePercent,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');
raw(Initialrow:size(OutsideZoneTimePercent,1)+Initialrow-1,2)=RankingArray(:,1);



Initialrow=1+12*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'chasing all (N events)'};
raw(Initialrow:size(ChasingEventsPerDay,1)+Initialrow-1,3:size(ChasingEventsPerDay,2)+2)=num2cell(ChasingEventsPerDay);
% raw(Initialrow:size(ChasingEventsPerDay,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');
raw(Initialrow:size(ChasingEventsPerDay,1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+13*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'being chased all(N events)'};
raw(Initialrow:size(BeingChasingEventsPerDay,1)+Initialrow-1,3:size(BeingChasingEventsPerDay,2)+2)=num2cell(BeingChasingEventsPerDay);
% raw(Initialrow:size(BeingChasingEventsPerDay,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');
raw(Initialrow:size(BeingChasingEventsPerDay,1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+14*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'Chasing plus being chasing all(N events)'};
raw(Initialrow:size(BeingChasingEventsPerDay,1)+Initialrow-1,3:size(BeingChasingEventsPerDay,2)+2)=num2cell(BeingChasingEventsPerDay+ChasingEventsPerDay);
% raw(Initialrow:size(BeingChasingEventsPerDay,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');
raw(Initialrow:size(BeingChasingEventsPerDay,1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+15*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'%ChasingTime  (% of Active time)'};
raw(Initialrow:size( ChasingTimePercentActive,1)+Initialrow-1,3:size( ChasingTimePercentActive,2)+2)=num2cell( ChasingTimePercentActive);
% raw(Initialrow:size(ChasingDurationPerDay,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');
raw(Initialrow:size( ChasingTimePercentActive,1)+Initialrow-1,2)=RankingArray(:,1);
% 
Initialrow=1+16*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'Mean Elorating per day'};
raw(Initialrow:size(EloratingAveragePerDay,1)+Initialrow-1,3:size(EloratingAveragePerDay,2)+2)=num2cell(EloratingAveragePerDay);
% raw(Initialrow:size(ChasingLengthPerDay,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');
raw(Initialrow:size(EloratingAveragePerDay,1)+Initialrow-1,2)=RankingArray(:,1);


Initialrow=1+17*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'Elorating according to last event per day'};
raw(Initialrow:size(EloratingPerLastDay,1)+Initialrow-1,3:size(EloratingPerLastDay,2)+2)=EloratingPerLastDay;
% raw(Initialrow:size(ChasingLengthPerDay,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');
raw(Initialrow:size(EloratingPerLastDay,1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+18*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'Normalized David Score all the experiment'};
raw(Initialrow:size(NormDSAll,1)+Initialrow-1,3)=num2cell(NormDSAll);
% raw(Initialrow:size(ChasingLengthPerDay,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');
raw(Initialrow:size(NormDSAll,1)+Initialrow-1,2)=RankingArray(:,1);



Initialrow=1+19*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'Normalized David Score from Dominance matrix all the experiment'};
raw(Initialrow:size(NormDSAllD,1)+Initialrow-1,3)=num2cell(NormDSAllD);
% raw(Initialrow:size(ChasingLengthPerDay,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');
raw(Initialrow:size(NormDSAllD,1)+Initialrow-1,2)=RankingArray(:,1);


Initialrow=1+20*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'DistPairs all(average (cm))'};
raw(Initialrow:size(AverageDistancePairsPerDay,1)+Initialrow-1,3:size(AverageDistancePairsPerDay,2)+2)=num2cell(AverageDistancePairsPerDay);
% raw(Initialrow:size(AverageDistancePairsPerDay,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');
raw(Initialrow:size(AverageDistancePairsPerDay,1)+Initialrow-1,2)=RankingArray(:,1);


Initialrow=1+21*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'David score with interactions per day'};
raw(Initialrow:size(NormDSAllDPerDay,1)+Initialrow-1,3:size(NormDSAllDPerDay,2)+2)=num2cell(NormDSAllDPerDay);
% raw(Initialrow:size(ChasingLengthPerDay,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');
raw(Initialrow:size(NormDSAllDPerDay,1)+Initialrow-1,2)=RankingArray(:,1);


Initialrow=1+22*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'Average velocity (average (cm/sec))'};
raw(Initialrow:size(AverageVelocityPerDay,1)+Initialrow-1,3:size(AverageVelocityPerDay,2)+2)=num2cell(AverageVelocityPerDay);
%raw(Initialrow:size(AverageVelocityPerDay,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');
raw(Initialrow:size(AverageVelocityPerDay,1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+23*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'togetherAll(% of time)'};
raw(Initialrow:size(TogetherTimePercent,1)+Initialrow-1,3:size(TogetherTimePercent,2)+2)=num2cell(TogetherTimePercent);
%raw(Initialrow:size(TogetherTimePercent,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');
raw(Initialrow:size(TogetherTimePercent,1)+Initialrow-1,2)=RankingArray(:,1);


Initialrow=1+24*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'RunningTimeActive(% of Active time)'};
raw(Initialrow:size(RunningTimePercentActive,1)+Initialrow-1,3:size(RunningTimePercentActive,2)+2)=num2cell(RunningTimePercentActive);
%raw(2:size(RunningTimePercent,1)+1,2)=strcat('''',(Locomotion.miceList)','''');
raw(Initialrow:size(RunningTimePercentActive,1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+25*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'WalkingTimeActive(% of Active time)'};
raw(Initialrow:size(WalkingTimePercentActive,1)+Initialrow-1,3:size(WalkingTimePercentActive,2)+2)=num2cell(WalkingTimePercentActive);
% raw(Initialrow:size(WalkingTimePercent,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');
raw(Initialrow:size(WalkingTimePercentActive,1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+26*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'StaticTimeActive(% of Active time)'};
raw(Initialrow:size(StaticTimePercentActive,1)+Initialrow-1,3:size(StaticTimePercentActive,2)+2)=num2cell(StaticTimePercentActive);
raw(Initialrow:size(StaticTimePercentActive,1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+27*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'movementTimeActive(% of Active time)'};
raw(Initialrow:size(MovementTimePercentActive,1)+Initialrow-1,3:size(MovementTimePercentActive,2)+2)=num2cell(MovementTimePercentActive);
% raw(Initialrow:size(MovementTimePercent,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');
raw(Initialrow:size(MovementTimePercentActive,1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+28*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'eatingSumTimeActive(% of Active time)'};
raw(Initialrow:size(EatingTimePercent,1)+Initialrow-1,3:size(EatingTimePercent,2)+2)=num2cell(EatingTimePercent);
% raw(Initialrow:size(EatingTimePercent,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');
raw(Initialrow:size(EatingTimePercent,1)+Initialrow-1,2)=RankingArray(:,1);


Initialrow=1+29*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'drinkingSumTimeActive(% of Active time)'};
raw(Initialrow:size( DrinkingTimePercentActive,1)+Initialrow-1,3:size( DrinkingTimePercentActive,2)+2)=num2cell( DrinkingTimePercentActive);
% raw(Initialrow:size( DrinkingTimePercent,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');
raw(Initialrow:size( DrinkingTimePercentActive,1)+Initialrow-1,2)=RankingArray(:,1);


Initialrow=1+30*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'CenterTimeAloneActive(% of Active time)'};
raw(Initialrow:size(AloneTimePercentActive,1)+Initialrow-1,3:size(AloneTimePercentActive,2)+2)=num2cell(AloneTimePercentActive);
%raw(Initialrow:size(AloneTimePercent,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');
raw(Initialrow:size(AloneTimePercentActive,1)+Initialrow-1,2)=RankingArray(:,1);


Initialrow=1+31*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'InsideZoneTime(% of active time)'};
raw(Initialrow:size(InsideZoneTimePercentActive,1)+Initialrow-1,3:size(InsideZoneTimePercentActive,2)+2)=num2cell(InsideZoneTimePercentActive);
%raw(Initialrow:size(AloneTimePercent,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');
raw(Initialrow:size(InsideZoneTimePercentActive,1)+Initialrow-1,2)=RankingArray(:,1);

Initialrow=1+32*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'OutsideZoneTime(% of active time)'};
raw(Initialrow:size(OutsideZoneTimePercentActive,1)+Initialrow-1,3:size(OutsideZoneTimePercentActive,2)+2)=num2cell(OutsideZoneTimePercentActive);
%raw(Initialrow:size(AloneTimePercent,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');
raw(Initialrow:size(OutsideZoneTimePercentActive,1)+Initialrow-1,2)=RankingArray(:,1);
%% 

%Spetial for interaction matrix
Initialrow=1+33*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'Interaction Matrix for each day (Chasing/being Chasing)'};
for i=1:size(InteractionMatrix,3)%loop on number of days
    
raw(Initialrow:size(InteractionMatrix,1)+Initialrow-1,3+(i-1)*(size(InteractionMatrix,2)+1):size(InteractionMatrix,2)+2+(i-1)*(size(InteractionMatrix,2)+1))=num2cell(InteractionMatrix(:,:,i));
raw(Initialrow-1,3+(i-1)*(size(InteractionMatrix,2)+1):size(InteractionMatrix,2)+2+(i-1)*(size(InteractionMatrix,2)+1))=(RankingArray(:,1))';
end
raw(Initialrow:size(InteractionMatrix,1)+Initialrow-1,2)=RankingArray(:,1); 
%% 

Initialrow=1+34*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'Total frames per day(~ to total experimental time)'};
raw(Initialrow:size(TotalExpTime,1)+Initialrow-1,3:size(TotalExpTime,2)+2)=num2cell(TotalExpTime);
% raw(Initialrow:size(TotalTime,1)+Initialrow-1,2)=strcat('''',(Locomotion.miceList)','''');


Initialrow=1+35*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'Duration of the experiment per day (h)'};
raw(Initialrow:size(ElapseTimePerDay,1)+Initialrow-1,3:size(ElapseTimePerDay,2)+2)=num2cell(ElapseTimePerDay);


 raw(1,3:size(RunningTimePercent,2)+2)=subStr_arrA{1,:};%create the days
 %% -----------------------------Add ranking from elorating to get order--------------
% ChasingFile=strcat(get(h.editRunParams,'string'),'\',item_selected(t),'\','Data','\','ChasingResults','\',strcat(item_selected(t),'_ChasingResults.xlsx')); %OPen chasing excel file
%  sheet='Ranking';
%  [num txt RankingArray]=xlsread(char(ChasingFile),sheet);
 
 Initialrow=1+36*(size(RunningTimePercent,1)+2);
raw(Initialrow,1)={'Ranking according to elo-rating'};
raw(Initialrow:size(RankingArray,1)+Initialrow-1,3:size(RankingArray,2)+2)=RankingArray;

 
 %% --------------------------------Plot the parameters ---------------------
 

 %% Plot data
%  figure
%  subplot(2,2,1)
% hfig=bar((RunningTimePercent(:,1:6))')
% l=strcat('''',(Locomotion.miceList)','''');
% legend(hfig,l,'Location','northwestoutside')
% ylim([0 100]);
%  title('RunningTime(% of time)')
%  
%   subplot(2,2,2)
% hfig1=bar((WalkingTimePercent(:,1:6))')
% l=strcat('''',(Locomotion.miceList)','''');
% legend(hfig1,l,'Location','northwestoutside')
% ylim([0 100]);
%  title('WalkingTime(% of time)')
%  
%    subplot(2,2,3)
% hfig3=bar((StaticTimePercent(:,1:6))')
% l=strcat('''',(Locomotion.miceList)','''');
% legend(hfig3,l,'Location','northwestoutside')
% ylim([0 100]);
%  title('StaticTime(% of time)')
%  
% subplot(2,2,4)
% hfig4=bar((MovementTimePercent(:,1:6))')
% l=strcat('''',(Locomotion.miceList)','''');
% legend(hfig4,l,'Location','northwestoutside')
% ylim([0 100]);
%  title('movementTime(% of time)')
%  
%  figure
%  
%   subplot(3,2,1)
% hfig5=bar((SleepingTimePercent(:,1:6))')
% l=strcat('''',(Locomotion.miceList)','''');
% legend(hfig5,l,'Location','northwestoutside')
% ylim([0 100]);
%  title('sleepingSumTime(% of time)')
%  
%   subplot(3,2,2)
% hfig6=bar((EatingTimePercent(:,1:6))')
% l=strcat('''',(Locomotion.miceList)','''');
% legend(hfig6,l,'Location','northwestoutside')
% ylim([0 100]);
%  title('eatingSumTime(% of time)')
%  
%    subplot(3,2,3)
% hfig7=bar((DrinkingTimePercent(:,1:6))')
% l=strcat('''',(Locomotion.miceList)','''');
% legend(hfig7,l,'Location','northwestoutside')
% ylim([0 100]);
%  title('drinkingSumTime(% of time))')
%  
% subplot(3,2,4)
% hfig8=bar((HidingTimePercent(:,1:6))')
% l=strcat('''',(Locomotion.miceList)','''');
% legend(hfig8,l,'Location','northwestoutside')
% ylim([0 100]);
%  title('hidingSumTime(% of time)')
%  
%   
% subplot(3,2,5)
% hfig9=bar((ArenaTimePercent(:,1:6))')
% l=strcat('''',(Locomotion.miceList)','''');
% legend(hfig9,l,'Location','northwestoutside')
% ylim([0 100]);
%  title('centerSumTime(% of time)')
%  
%   
% subplot(3,2,6)
% hfig10=bar((AloneTimePercent(:,1:6))')
% l=strcat('''',(Locomotion.miceList)','''');
% legend(hfig10,l,'Location','northwestoutside')
% ylim([0 100]);
%  title('CenterTimeAlone(% of time)')
%  
%  
%   figure
%  
%   subplot(3,2,1)
% hfig5=bar((TogetherTimePercent(:,1:6))')
% l=strcat('''',(Locomotion.miceList)','''');
% legend(hfig5,l,'Location','northwestoutside')
% ylim([0 100]);
%  title('togetherAll(% of time)')
%  
%   subplot(3,2,2)
% hfig6=bar((ChasingEventsPerDay(:,1:6))')
% l=strcat('''',(Locomotion.miceList)','''');
% legend(hfig6,l,'Location','northwestoutside')
% 
%  title('chasing all (N events)')
%  
%    subplot(3,2,3)
% hfig7=bar((BeingChasingEventsPerDay(:,1:6))')
% l=strcat('''',(Locomotion.miceList)','''');
% legend(hfig7,l,'Location','northwestoutside')
% 
%  title('being chased all(N events)')
%  
% subplot(3,2,4)
% hfig8=bar(( AverageDistancePairsPerDay(:,1:6))')
% l=strcat('''',(Locomotion.miceList)','''');
% legend(hfig8,l,'Location','northwestoutside')
% 
%  title('DistPairs all(average (cm))')
%  
%   
% subplot(3,2,5)
% hfig9=bar((AverageVelocityPerDay(:,1:6))')
% l=strcat('''',(Locomotion.miceList)','''');
% legend(hfig9,l,'Location','northwestoutside')
% 
%  title('Average velocity (average (cm/sec))')
%  
  
% subplot(3,2,6)
% hfig10=bar((AloneTimePercent(:,1:6))')
% l=strcat('''',(Locomotion.miceList)','''');
% legend(hfig10,l,'Location','northwestoutside')
% ylim([0 100]);
%  title('CenterTimeAlone(% of time)')
 
 

%% ---Save the data----------

sheet=char(item_selected(t));
xlswrite(strcat(SaveFolder,'AllTheParameters.xlsx'),raw,sheet)
end






waitbar(t/length(item_selected))
end
close(hbar)

%% -------------For plotting---------------

if get(h.checkbox1,'Value')==1 %for plotting all the experiments 
    msgbox('Wait for plottings')
%  FilenameChasingData=strcat(get(h.editRunParams,'string'),'\',item_selected(t),'\','Data','\','ChasingResults','\',strcat(item_selected(t),'_ChasingResults.xlsx'));
 FilenameChasingData=strcat(get(h.editRunParams,'string'),'\');
 PlotParameters(strcat(SaveFolder,'AllTheParameters.xlsx'),Exp_arrA,FilenameChasingData);   
end





msgbox('The running finished')
end





%% --Auxiliary functions---------------

function ChasingEventsPerFile=CalculateNumberChasing(ChasingAll) 
   for i=1:size(ChasingAll,2)
      ChasingEventsPerFile(i)=size(ChasingAll{1,i},1);

    end
end

%% 
function [ChasingDurationPerFile ChasingLengthPerFile]=CalculateChasingDurationLength(ChasingAll,TrajectoryX,TrajectoryY,numOfMice)
%  ChasingDurationPerFile=NaN(numOfMice,length(TrajectoryX));
%  ChasingLengthPerFile=NaN(numOfMice,length(TrajectoryX));
%  ChasingAll
%  size(ChasingAll,2)
for i=1:size(ChasingAll,2)
    if ~isempty(ChasingAll{1,i})
      ChasingDurationPerFile(i,1:length(ChasingAll{1,i}(:,2)))=(ChasingAll{1,i}(:,2)-ChasingAll{1,i}(:,1))';%number of frames
      t1=(TrajectoryX(ChasingAll{1,i}(:,5))-TrajectoryX(ChasingAll{1,i}(:,4)))';
      t2=(TrajectoryY(ChasingAll{1,i}(:,5))-TrajectoryY(ChasingAll{1,i}(:,4)))';
      
      ChasingLengthPerFile(i,1:length(ChasingAll{1,i}(:,2)))=sqrt(t1.^2+t2.^2);
    end
      
    end
end




%%  
function DistPairs=calcDistancePairs(num,DistancePairs)

% DistancePairs=AllMice.DistancePairs;
% num=length(AllMice.IDs);
%TotTime=(length(DistancePairs)+1)/30/3600;

for i=1:num
    DistPairsA=[];
    for j=1:num
       
        dp=[];
        T=[];
        dp=DistancePairs(:,i,j);
        %tt=sum(~isnan(dp))/30/3600;
%         tt=length(dp)/30/3600;
%         DistPairs(i,j)=mean(dp(~isnan(dp)))/tt;
        

%% ---------Correction for very big distance in the border between sleeping and arena
%      if ~isempty(find(DistancePairs(:,i,j)>2000))
%       DistancePairs(find(DistancePairs(:,i,j)>2000),i,j)=NaN;   
%         find(DistancePairs(:,i,j)>2000) 
%      end
%Consider when the distance is big because of WRONG COORDINATE
        T= dp(~isnan(dp));
         if ~isempty(find(T>2000))
           T(find(T>2000))=NaN;  
             
         end
        DistPairsA(i,j)=mean(T,'omitnan');
        
    end
    %for each mouse distance from all other mouse
    DistPairs(i)=mean(DistPairsA(i,:),'omitnan')/10;
%divided by 10 for cm conversion    
   

    
    
end
% DistPairs
end
%% 

%% ---Calculation of velocity-------------
function SumVelocityExp =calcVelocity(Velocity,staticVelocity)

for i=1:size(Velocity,2) %loop through all mice
    %sum all without consider static
    
%    SumVelocityExp(i,1)= sum(Velocity(Velocity(:,i)>staticVelocity,i));
%    VelocitySize(i,1)=size(SumVelocityExp(i,1),1); 
    if ~isempty(find(Velocity(:,i)>staticVelocity))  %consider no valid velocity more than 200cm/sec which is the reported limit this is not correct.
       SumVelocityExp(i,1)=median(Velocity(Velocity(:,i)>staticVelocity,i)); %since the velocity distribution is very width it is better to take the median of the distribution
       
       %Velocity median more than 200cm/sec which is the reported limit
       %this is not correct.NOTE!!!!!!
       
      if  SumVelocityExp(i,1)>200
         SumVelocityExp(i,1)=NaN; %no information 
          
      end
       
    else
        SumVelocityExp(i,1)=NaN;
       
    end
    
    
    
end
% SumVelocityExp
end
%% 
function TimeAlone=calcAloneTime(isInArena,ExperimentTime)
%find the ones

[Irow,Icolumn,ind]=find(isInArena==1);
%sort the Irow
[Irow IndSort]=sort(Irow);


%find rows without repeats 

RowsWithOneMouse = Irow(sum(bsxfun(@eq, Irow(:), Irow(:)'))==1);

%Extract the arena data which has a row with only one 1 , this means that
%there is only one mouse in the arena.


%Remove quotes
     ExperimentTime=strrep(ExperimentTime,'''','');

if ~isempty(RowsWithOneMouse)
    
  
    AuxTime=ExperimentTime;
    Arena=zeros(size(isInArena,1),size(isInArena,2));
    Arena(RowsWithOneMouse,:)=isInArena(RowsWithOneMouse,:);
  
    TimeAlone=[];
    for mouse=1:size(Arena,2)
         EventsBeg=[];
         EventsEnd=[]
       [EventsBeg EventsEnd]=getEventsIndexesGV(Arena(:,mouse),size(Arena,1));  
         
        TimeAlone(mouse,1)=sum(etime(datevec(AuxTime(EventsEnd,1),'HH:MM:SS.FFF'),datevec(AuxTime(EventsBeg,1),'HH:MM:SS.FFF')))/60  %convert into minutes , not consider unique events
         

     end 

  
 

else
  TimeAlone=zeros(1,size(isInArena,2));  
end



end
%% 
function  IndexNew=FindIndex(A,B)

for i=1:length(A)
    
   IndexNew(i)=find(strcmp(A(i,1),B)==1); 
    
    
end



end

