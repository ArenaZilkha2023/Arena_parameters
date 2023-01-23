
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

% ---------------------Read choice score method---------------------------
index_ScoreDay = get( h.Popup2PCA,'Value');
listScoreDay = get( h.Popup2PCA,'String');
item_ScoreDay = listScoreDay(index_ScoreDay,1); % Convert from cell array
% ---------------------------Read from which day to do average of score parameters-
index_ScoreMethod = get( h.Popup3PCA,'Value');
listScore = get( h.Popup3PCA,'String');
item_ScoreMethod = listScore(index_ScoreMethod,1); % Convert from cell array

% ---------------------Read number of days to analyzed------------
LastDay=str2num(get(h.editDays,'string'));
%% -----------------------Select the experiments -----------------------
hbar = waitbar(0,'Please wait...');
for t=1:length(item_selected) %LOOP FOR EACH EXPERIMENT
    
   g= msgbox(strcat('Now is running',item_selected(t)));
%% ----------Select according to checkbox-------
   if get(h.checkbox2,'Value')==1  %In the case of running only the parameters 
    
      Folder_Data=strcat(get(h.editRunParams,'string'),'\',item_selected(t),'\',item_selected(t),'\','Data','\',strcat(item_selected(t),'ResultsMatlab','\'));
  %%  Folder_Data=strcat(get(h.editRunParams,'string'),'\',item_selected(t),'\',item_selected(t),'\','Data','\',strcat(item_selected(t),'ResultsMatlabCorr0.7_200','\')); %spetial case 2021
      Folder_Data=char(Folder_Data);
      ListFiles=dir([Folder_Data,'*.mat']);
      item_selected(t)
      % Reset paramaters matrix
      Parameters=[]; % This is a three dimensional matrix the rows are mice and the columns are parameters
      TimeArray=[]; % Matrix with array information
       ParametersSum=[];% Sum all parameters per day
       ParametersSumTotalDetected=[];
       ParametersSumActiveTime=[];
        ParametersSumActiveTimeHour=[];
        DimensionArray=[]; %Number of total events for each file
       
      for countFile=1:1:length(ListFiles(not([ListFiles.isdir]))) %GO OVER EACH FILE
 
             load(strcat(Folder_Data,ListFiles(countFile).name));    
             ListFiles(countFile).name  

 %%  ------- Calculate the real time lapse the experiment for each file in minutes-Create Array with time information
             
             k1=strfind(ListFiles(countFile).name  ,'[');
             k2=strfind(ListFiles(countFile).name  ,'-');
             fileE=ListFiles(countFile).name;
             countFile
             t1=fileE(k1(1)+1:k2(3)-1);
             t2=fileE(k2(3)+1:length(fileE)-5);
             TimeArray(countFile,1)=(etime(datevec(t2,'HH_MM_SS.FFF'),datevec(t1,'HH_MM_SS.FFF')))/(60); % First data elapse time in minutes
             
             % day, month and year 
             Idates=strfind(ListFiles(countFile).name  ,'.');
             TimeArray(countFile,4)= str2num(fileE(1:Idates(1)-1));  % 4th column for the day
             TimeArray(countFile,3)= str2num(fileE(Idates(1)+1:Idates(2)-1));  % 3th column for the month
             TimeArray(countFile,2)= str2num(fileE(Idates(2)+1:k2(1)-1));  % 2th column for the year
             auxIndC= strfind(t1,'_');
             TimeArray(countFile,5)= str2num(t1(1:auxIndC(1)-1));% 5 th column for the first hour
             TimeArray(countFile,6)= str2num(t1(auxIndC(1)+1:auxIndC(2)-1));% 6 th column for the first minute
       
             %% ---Find running  duration in minutes--------------

             [Parameters(:,1,countFile) Parameters(:,25,countFile)]=GetTimeDurationParameter(Locomotion.AssigRFID.Arena.IsRunning,Locomotion.ExperimentTime);  % first column running

            %% ---Find Walking per file--------------
             [Parameters(:,2,countFile) Parameters(:,26,countFile)]=GetTimeDurationParameter(Locomotion.AssigRFID.Arena.IsWalking,Locomotion.ExperimentTime); % second walking time
             %%  ---------------Find running at higher velocity--------------------
           [Parameters(:,54,countFile) Parameters(:,55,countFile)]=GetTimeDurationParameter(Locomotion.AssigRFID.Arena.IsRunningHighVelocity,Locomotion.ExperimentTime);  % First column is duration and second column is number of events

            %% ---Find percentage of static time per file with velocity less than 0.5 cm/sec by default--------------
             [Parameters(:,3,countFile) Parameters(:,27,countFile)]=GetTimeDurationParameter(Locomotion.AssigRFID.Arena.IsStopping,Locomotion.ExperimentTime); % 3rd static time     
                %% ---Find percentage of eating time per file --------------
             [Parameters(:,4,countFile) Parameters(:,28,countFile)]=GetTimeDurationParameter(Locomotion.AssigRFID.EatingDrinking.IsEatingAccordingPlaceVelocity,Locomotion.ExperimentTime); % 4rd for eating
                %% ---Find percentage of drinking time per file --------------
             [Parameters(:,5,countFile) Parameters(:,29,countFile)]=GetTimeDurationParameter(Locomotion.AssigRFID.EatingDrinking.IsDrinking,Locomotion.ExperimentTime); % 5th for drinking
         %% -----------------Find percentage of sleeping time per file-----------
             [Parameters(:,6,countFile) Parameters(:,30,countFile) LastParameterIndex]=GetTimeDurationParameter(Locomotion.AssigRFID.Sleeping.IsSleeping,Locomotion.ExperimentTime); % 6th for sleeping
             % -------------- Find number of visits outside the sleeping
             % box in order to get frequency.That is the events the mouse
             % exits one of the sleeping box. It is important to do
             % frequency if not there is not meaning since not all cases
             % can be considered
              Parameters(:,35,countFile)=Parameters(:,30,countFile)- LastParameterIndex; %Remove one event in the case last event was not finish
             
         %% ----------------Find hiding time per file
             [Parameters(:,7,countFile) Parameters(:,31,countFile) LastParameterIndexh]=GetTimeDurationParameter(Locomotion.AssigRFID.Hiding.IsHiding,Locomotion.ExperimentTime); % 7th for hiding
             
             Parameters(:,51,countFile)=Parameters(:,31,countFile)- LastParameterIndexh; %Remove one event in the case last event was not finish- for frequency visitis inside the hiding box
         %% -----------------Find   the mice were in the arena--------------
             [Parameters(:,8,countFile) Parameters(:,32,countFile)]=GetTimeDurationParameter(Locomotion.AssigRFID.Arena.InArena,Locomotion.ExperimentTime); % 8th for arena
             Parameters(:,36,countFile)=GetCorrelation(Locomotion.AssigRFID.Arena.InArena); %Foraging correlation
          %%  %% -----------------Find   the mice is inside the zone--------------
             [Parameters(:,9,countFile) Parameters(:,33,countFile)]=GetTimeDurationParameter(Locomotion.AssigRFID.Arena.InsideZone,Locomotion.ExperimentTime);  % 9th for inside zone
          %%  %% -----------------Find the mice is outside the zone--------------
             [Parameters(:,10,countFile) Parameters(:,34,countFile)]=GetTimeDurationParameter(Locomotion.AssigRFID.Arena.OutsideZone,Locomotion.ExperimentTime); % 10th for outside zone 
        %% -------Calculate  time the mouse is alone in the arena per file
        %time in minutes
            Parameters(:,11,countFile)=(calcAloneTime(Locomotion.AssigRFID.Arena.InArena,Locomotion.ExperimentTime)); % 11th time the mouse is alone inside the arena
 
        %% ---Find movement time  as percent of time the mice walking and running inside the arena -Movement
            Parameters(:,12,countFile)= sum([Parameters(:,1,countFile),Parameters(:,2,countFile)],2,'omitnan'); % 12th movement time : walking plus running time
       %% ------ Detected time--------------------------------------
            Parameters(:,13,countFile)=sum([Parameters(:,8,countFile),Parameters(:,6,countFile),Parameters(:,7,countFile)],2,'omitnan');   % 13 th total time was detected arena+sleeping +hiding
         % -------------Find active time inside the arena---------------------
            Parameters(:,14,countFile)=Parameters(:,8,countFile);  % 14 th active time in the arena
        
%          %% -------Insert average per file distance pair between mice
            Parameters(:,16,countFile)=calcDistancePairs(length(Locomotion.AssigRFID.miceList),Locomotion.AssigRFID.Behaviour.DistancePairs); %16 th average distance of each mouse to the others 
%          %% -----------Calculate the average velocity per file----------------------------
            Parameters(:,17,countFile)=calcVelocity(Locomotion.AssigRFID.VelocityMouse,staticVelocity,Locomotion.AssigRFID.Arena.InArena);
            %% ----- Calculate aceleration per file --------------------------------
             Parameters(:,56,countFile)=calcAceleration(Locomotion.AssigRFID.Arena.AcelerationMouse,Locomotion.AssigRFID.Arena.InArena);
           %% ----------------------Chasing Parameters-----------------------
            Parameters(:,18:20,countFile)=calcChasing(Locomotion.AssigRFID.Behaviour.Chasing); %chasing all, chased all and chasing+chased all events
            %% -----------------------------Together Parameters---------------------------------
          [Parameters(:,21,countFile) Parameters(:,48,countFile)]=calcTogether(Locomotion.AssigRFID.Behaviour.Together,Locomotion.ExperimentTime); % time together and number of total contacts
            %% ----------------------------Duration of chasing----------------
            Parameters(:,22:24,countFile)=calcChasingDuration(Locomotion.AssigRFID.Behaviour.Chasing,Locomotion.ExperimentTime);
            %% ------------------------------------------------Approaching parameters per file----------------------------------
           Parameters(:,37,countFile)=calcApproaching(Locomotion.AssigRFID.Behaviour.Approaching);
           Parameters(:,57,countFile)=calcAproachingDuration(Locomotion.AssigRFID.Behaviour.Approaching,Locomotion.ExperimentTime)
           [Parameters(:,61,countFile),Parameters(:,62,countFile)]=calcBeAproaching(Locomotion.AssigRFID.Behaviour.Approaching,Locomotion.ExperimentTime);%first is be approaching events, second is the duration
           %% -------------------------------------------------Avoiding parameters per file
             Parameters(:,38,countFile)=calcBeAvoiding(Locomotion.AssigRFID.Behaviour.BeAvoiding);
             Parameters(:,58,countFile)=calcBeAvoidingDuration(Locomotion.AssigRFID.Behaviour.BeAvoiding,Locomotion.ExperimentTime)
             [Parameters(:,59,countFile),Parameters(:,60,countFile)]=calcAvoiding(Locomotion.AssigRFID.Behaviour.BeAvoiding,Locomotion.ExperimentTime);%first is avoiding events, second is the duration
             %% --------------------------For further calculation of entropy- Calculate number of events for each mouse, and total number
             % of events
             DimensionArray(countFile)=size(Locomotion.AssigRFID.EatingDrinking.IsEatingAccordingPlace,1); % Number of total events
             Parameters(:,39,countFile)=(sum(Locomotion.AssigRFID.EatingDrinking.IsEatingAccordingPlace,1))';% Number of events for each action eating
             Parameters(:,40,countFile)=(sum(Locomotion.AssigRFID.EatingDrinking.IsDrinking,1))'; %drinking
             Parameters(:,41,countFile)=(sum(Locomotion.AssigRFID.Hiding.IsHiding,1))';%hiding
             Parameters(:,46,countFile)=(sum(Locomotion.AssigRFID.Arena.IsLargerBridge,1))';%Large bridge
             Parameters(:,47,countFile)=(sum(Locomotion.AssigRFID.Arena.IsNarrowBridge,1))';%Narrow bridge
             %% --------------------------------- Calculation of the mean distance travelled by the mouse in the arena Eliminate non defined points---------------------
             % Output parameters are Sum of the measure travelled distance
             % and the number of events involved
              [Parameters(:,42,countFile),Parameters(:,43,countFile)]=calcDistance(Locomotion.AssigRFID.XcoordMM,Locomotion.AssigRFID.YcoordMM,Locomotion.AssigRFID.Arena.InArena);  
              %% -------Calculate the angular velocity in absolute value------------------------
                [Parameters(:,44,countFile),Parameters(:,45,countFile)]=calcAngularVelocity(Locomotion.ExperimentTime,Locomotion.AssigRFID.MouseOrientation,Locomotion.AssigRFID.Arena.InArena);
                
                %% --Calculation of number of events in which head to head  and head tail for mouse lying in the arena without hiding and eating stands / without consider mice in cluster-----------------------------------
                 Parameters(:,52,countFile)=calc2MiceNear(Locomotion.AssigRFID.Behaviour.HeadToHead(:,1:size(Locomotion.AssigRFID.Arena.InArena,2)),Locomotion.ExperimentTime);
                 Parameters(:,53,countFile)=calc2MiceNear(Locomotion.AssigRFID.Behaviour.HeadToTail(:,1:size(Locomotion.AssigRFID.Arena.InArena,2)),Locomotion.ExperimentTime);
             %% --------------------------Parameter of duration/Number of events of hiding plus sleeping--------------------------------
             % Duration
             Parameters(:,49,countFile)=Parameters(:,6,countFile)+Parameters(:,7,countFile);
             % Number of events
              Parameters(:,50,countFile)=Parameters(:,30,countFile)+Parameters(:,31,countFile);
             
      end % finish loop over all files of one specific experiment
      %% ----------------Order the data in cronological order get new index, get times for each day and days-----------------------------
              [NewIndex,Days]=GetOrderFiles(TimeArray);
               Parameters=Parameters(:,:,NewIndex); % sorted according to the dates
               TimeArray=TimeArray(NewIndex,:);
              % Days=unique(TimeArray(:,4),'stable');% I used the corected order
      %% ------------------ Sum for each day------------------
            EntropyDay=[];
            DistanceTravelDay=[];
            AngularVelocityDay=[];
             FrequencyVisitsOutside=[];
             FrequencyVisitsHidingBox=[];
             ForagingCorrelation=[];
            
           for countDay=1:LastDay %consider last day selected by the user
               ParametersSum(:,:,countDay)=sum(Parameters(:,:,find(TimeArray(:,4)==Days(countDay))),3,'omitnan');%sum all the parameters of a given day 
%                % Normalization Parameters according total time detected
                 ParametersSumTotalDetected(:,:,countDay)=ParametersSum(:,:,countDay);
                 ParametersSumActiveTime(:,:,countDay)=ParametersSum(:,:,countDay);
                 ParametersSumTotalDetected(:,1:12,countDay)=(ParametersSum(:,1:12,countDay)./repmat(ParametersSum(:,13,countDay),1,12))*100; 
                 ParametersSumTotalDetected(:,49,countDay)=(ParametersSum(:,49,countDay)./repmat(ParametersSum(:,13,countDay),1,1))*100; 
                 ParametersSumTotalDetected(:,52,countDay)=(ParametersSum(:,52,countDay)./repmat(ParametersSum(:,13,countDay),1,1)); 
                 ParametersSumTotalDetected(:,53,countDay)=(ParametersSum(:,53,countDay)./repmat(ParametersSum(:,13,countDay),1,1)); 
                 
%                % Normalization parameters according active time without
%                % hiding and sleeping for each day
                 ParametersSumActiveTime(:,1:5,countDay)=(ParametersSum(:,1:5,countDay)./repmat(ParametersSum(:,14,countDay),1,5))*100;
                 ParametersSumActiveTime(:,9:12,countDay)=(ParametersSum(:,9:12,countDay)./repmat(ParametersSum(:,14,countDay),1,4))*100; % for outside, inside and alone
             %    ParametersSumActiveTime(:,54,countDay)=(ParametersSum(:,54,countDay)./repmat(ParametersSum(:,14,countDay),1,1))*100; % run at high velocity
                 
                % Average Distance pairs per day , and average velocity
                % per day
                ParametersSum(:,16,countDay)= mean(Parameters(:,16,find(TimeArray(:,4)==Days(countDay))),3,'omitnan'); %for distance in cm
                ParametersSum(:,17,countDay)= mean(Parameters(:,17,find(TimeArray(:,4)==Days(countDay))),3,'omitnan'); % for Median mean speed in cm/sec2
                ParametersSum(:,56,countDay)= mean(Parameters(:,56,find(TimeArray(:,4)==Days(countDay))),3,'omitnan'); % for Median mean speed in cm/sec2
               
               ElapseTimePerDay(countDay)=sum(TimeArray(find(TimeArray(:,4)==Days(countDay)),1));% total time in which was measured (not necessarily detected) during each day
                ActiveTimePerDay(:,countDay)=sum(Parameters(:,14,find(TimeArray(:,4)==Days(countDay))),3,'omitnan');
                
                % Parameters related with frequency-The rate at which the
                % mouse exits the nest.
                % or mouse visists Hiding boxes
                %Normalizations: Total time(1/hour)
                FrequencyVisitsOutside(:,countDay)=sum(Parameters(:,35,find(TimeArray(:,4)==Days(countDay))),3,'omitnan')./(ElapseTimePerDay(countDay)/60); % number of events go out of sleeping box normalized to detection time (1/h)
                FrequencyVisitsHidingBox(:,countDay)=sum(Parameters(:,51,find(TimeArray(:,4)==Days(countDay))),3,'omitnan')./(ElapseTimePerDay(countDay)/60); % number of events go out/in of hiding boxes normalized to detection time (1/h)
                ForagingCorrelation(:,countDay)=mean(Parameters(:,36,find(TimeArray(:,4)==Days(countDay))),3,'omitnan'); %Foraging correlation
                
            %% ------------------------------------------------Calculate ROI exploration---------------------------------
             % Quantifies the amount of exploration the mouse is doing.
             % Measured as the entropy of probability of being in each of
             % the regions of interest (ROI). Mice that spend the same
             % amount of time in all regions will get the highest score,
             % while mice that spend all their time in a single ROI will be
             % scored zero. ROI are hidden box , bridges , drinking and
             % eating. 
               NumberOfTotalEvents=sum(DimensionArray(find(TimeArray(:,4)==Days(countDay))));
               EntropyDay(:,countDay)=(ManagerEntropy( ParametersSum(:,39,countDay), ParametersSum(:,40,countDay), ParametersSum(:,41,countDay),ParametersSum(:,46,countDay),ParametersSum(:,47,countDay),NumberOfTotalEvents))./(ActiveTimePerDay(:,countDay)/60);  % units bits/hour- normalized to hour inside the aren
               %% ---Calculate the distance travelled in each day in m units-REMEMBER ONLY CONSIDER DEFINED POINTS------
               DistanceTravelDay(:,countDay)=ParametersSum(:,42,countDay)./ParametersSum(:,43,countDay);
               %% -----------Calculate the average angular velocity (rad/sec) for each mouse-ONLY CONSIDER DEFINED POINTS-------
               AngularVelocityDay(:,countDay)=ParametersSum(:,44,countDay)./ParametersSum(:,45,countDay);
               %% ---------------------------------- Number of contacts the mouse has normalized to the time in the arena------------------
               
               
                
           end
           
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% For 2 stages %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            ForagingCorrelationStage(:,1)=mean(Parameters(:,36,find(TimeArray(:,4)==Days(1))),3,'omitnan'); %Foraging correlation
            AuxRTotal=[];
            for countDay=2:LastDay
                   AuxR=[];
                   AuxR=Parameters(:,36,find(TimeArray(:,4)==Days(countDay)));
                   AuxR=reshape(AuxR,size(AuxR,1),size(AuxR,3));
                   AuxRTotal=[AuxRTotal,AuxR];
            end       
            ForagingCorrelationStage(:,2)=mean(AuxRTotal,2,'omitnan'); %Foraging correlation
%%  Region of interest exploration
P1Total=[];
P2Total=[];
P3Total=[];
P4Total=[];
P5Total=[];
N1Total=[];
T1Total=[];
 NumberOfTotalEventsStage1=sum(DimensionArray(find(TimeArray(:,4)==Days(1))));
 ActiveTimePerDay1(:,1)=sum(Parameters(:,14,find(TimeArray(:,4)==Days(1))),3,'omitnan');
 EntropyDayStage(:,1)=(ManagerEntropy( ParametersSum(:,39,1), ParametersSum(:,40,1), ParametersSum(:,41,1),ParametersSum(:,46,1),ParametersSum(:,47,1),NumberOfTotalEventsStage1))./(ActiveTimePerDay1(:,1)/60);  % units bits/hour- normalized to hour inside the arena
 for countDay=2:LastDay
       P1=[];
       P1=ParametersSum(:,39,countDay);
       P1Total=[P1Total,P1];
       
       P2=[];
       P2=ParametersSum(:,40,countDay);
       P2Total=[P2Total,P2];

       P3=[];
       P3=ParametersSum(:,41,countDay);
       P3Total=[P3Total,P3];

       P4=[];
       P4=ParametersSum(:,46,countDay);
       P4Total=[P4Total,P4];

       P5=[];
       P5=ParametersSum(:,47,countDay);
       P5Total=[P5Total,P5];

     
      N1=[];%total number of events
      N1=sum(DimensionArray(find(TimeArray(:,4)==Days(countDay))));
      N1Total=[N1Total,N1];

       
      T1=[];%total active time
      T1=ActiveTimePerDay(:,countDay);
      T1Total=[T1Total,T1];
     
end
    EntropyDayStage(:,2)=(ManagerEntropy( sum(P1Total,2,'omitnan'), sum(P2Total,2,'omitnan'),sum(P3Total,2,'omitnan'),sum(P4Total,2,'omitnan'), sum(P5Total,2,'omitnan'),sum(N1Total,2,'omitnan')))./(sum(T1Total,2,'omitnan')/60);  % units bits/hour- normalized to hour inside the aren     
    %% Mean distance travel by each mice in m units in the arena
    D1Total=[];
    DEvents1Total=[];
    DistanceTravelDayStage(:,1)=ParametersSum(:,42,1)./ParametersSum(:,43,1);
    for countDay=2:LastDay
       D1=[]; %distance travel per event
       D1=ParametersSum(:,42,countDay);
       D1Total=[D1Total,D1];  
       
       DEvents1=[]; %distance travel events
       DEvents1=ParametersSum(:,43,countDay);
       DEvents1Total=[DEvents1Total,DEvents1]; 
    end
    
    DistanceTravelDayStage(:,2)=sum(D1Total,2,'omitnan')./sum(DEvents1Total,2,'omitnan');
    
    %% Angular velocity in the arena it is a mean for each stage
      Ang1Total=[];
     AngEvents1Total=[];
    AngularVelocityStage(:,1)=ParametersSum(:,44,1)./ParametersSum(:,45,1);
    for countDay=2:LastDay
       AD1=[]; %distance travel per event
       AD1=ParametersSum(:,44,countDay);
       Ang1Total=[Ang1Total,AD1];  
       
       ADEvents1=[]; %distance travel events
       ADEvents1=ParametersSum(:,45,countDay);
       AngEvents1Total=[AngEvents1Total,ADEvents1]; 
    end
    
    AngularVelocityStage(:,2)=sum(Ang1Total,2,'omitnan')./sum(AngEvents1Total,2,'omitnan');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%           
           %% ----------------------------- Sum for each hour- I assumed that the second day the detection is for 10 min. ------------------------------------------
           countFile=1;
           ParametersHour=[];
           TimeHour=[];
           ParametersHour=[];
           FrequencyVisitsOutsideHour=[];
           FrequencyVisitsHidingBoxHour=[];
           ForagingCorrelationHour=[];
           DistanceTravelHour=[];
           AngularVelocityHour=[];
           HourPoint=1;
           while countFile<=size(TimeArray,1) % Loop over the files
               ElapseTime=TimeArray(countFile,1);
               countFile
             if  ElapseTime >15 % larger than 15 min , at the beggining the files are of 60min
               range=countFile;  
                ParametersHour(:,:,HourPoint)=sum(Parameters(:,:,range),3,'omitnan');
                % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                  % Normalization parameters according active time without
%                % hiding and sleeping for each hour
                 ParametersSumActiveTimeHour(:,1:5,HourPoint)=(ParametersHour(:,1:5,HourPoint)./repmat(ParametersHour(:,14,HourPoint),1,5))*100;
                 ParametersSumActiveTimeHour(:,9:12,HourPoint)=(ParametersHour(:,9:12,HourPoint)./repmat(ParametersHour(:,14,HourPoint),1,4))*100; % for outside, inside and alone
                
                % %%%%%%%%%%%%%%%%%%%%%%
                FrequencyVisitsOutsideHour(:,HourPoint)=sum(Parameters(:,35,range),3,'omitnan')./(ElapseTime/60); % number of events go out of sleeping box normalized to detection time (1/h)
                FrequencyVisitsHidingBoxHour(:,HourPoint)=sum(Parameters(:,51,range),3,'omitnan')./(ElapseTime/60);% number of events go out of hiding box normalized to detection time (1/h)
                ForagingCorrelationHour(:,HourPoint)=mean(Parameters(:,36,range),3,'omitnan'); %Foraging correlation
                % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                 %% ---Calculate the distance travelled in each day in m units-REMEMBER ONLY CONSIDER DEFINED POINTS------
               DistanceTravelHour(:,HourPoint)=Parameters(:,42,range)./Parameters(:,43,range);
               %% -----------Calculate the average angular velocity (rad/sec) for each mouse-ONLY CONSIDER DEFINED POINTS-------
               AngularVelocityHour(:,HourPoint)=Parameters(:,44,range)./Parameters(:,45,range);
   
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                   TimeHour=[TimeHour,ElapseTime];
               countFile=countFile+1;%go to next file
               HourPoint=HourPoint+1;
             else
                 %distinguish between the end of files and the rest
                 if countFile+5<=size(TimeArray,1)
                   range=[countFile:countFile+5];  % sum to 1 hour of detection
                   ParametersHour(:,:,HourPoint)=sum(Parameters(:,:,range),3,'omitnan');
                    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                  % Normalization parameters according active time without
%                % hiding and sleeping for each hour
                 
              ParametersSumActiveTimeHour(:,1:5,HourPoint)=(ParametersHour(:,1:5,HourPoint)./repmat(ParametersHour(:,14,HourPoint),1,5))*100;
                 ParametersSumActiveTimeHour(:,9:12,HourPoint)=(ParametersHour(:,9:12,HourPoint)./repmat(ParametersHour(:,14,HourPoint),1,4))*100; % for outside, inside and alone
                
                % %%%%%%%%%%%%%%%%%%%%%%
                    FrequencyVisitsOutsideHour(:,HourPoint)=sum(Parameters(:,35,range),3,'omitnan')./(ElapseTime/60); % number of events go out of sleeping box normalized to detection time (1/h)
                     FrequencyVisitsHidingBoxHour(:,HourPoint)=sum(Parameters(:,51,range),3,'omitnan')./(ElapseTime/60);% number of events go out of hiding box normalized to detection time (1/h)
                    ForagingCorrelationHour(:,HourPoint)=mean(Parameters(:,36,range),3,'omitnan'); %Foraging correlation
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
               %% ---Calculate the distance travelled in each day in m units-REMEMBER ONLY CONSIDER DEFINED POINTS------
               DistanceTravelHour(:,HourPoint)=sum(Parameters(:,42,range),3,'omitnan')./sum(Parameters(:,43,range),3,'omitnan');
               %% -----------Calculate the average angular velocity (rad/sec) for each mouse-ONLY CONSIDER DEFINED POINTS-------
               AngularVelocityHour(:,HourPoint)=sum(Parameters(:,44,range),3,'omitnan')./sum(Parameters(:,45,range),3,'omitnan');
   
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    
                   TimeHour=[TimeHour,sum(TimeArray(countFile:countFile+5,1))];%vector of hours 
                   countFile=countFile+6;%go to next files
                   HourPoint=HourPoint+1;
                else  % for the last files    
                   range=[countFile:size(TimeArray,1)];  % sum to 1 hour of detection
                   ParametersHour(:,:,HourPoint)=sum(Parameters(:,:,range),3,'omitnan');
                    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                  % Normalization parameters according active time without
%                % hiding and sleeping for each hour
                 ParametersSumActiveTimeHour(:,1:5,HourPoint)=(ParametersHour(:,1:5,HourPoint)./repmat(ParametersHour(:,14,HourPoint),1,5))*100;
                 ParametersSumActiveTimeHour(:,9:12,HourPoint)=(ParametersHour(:,9:12,HourPoint)./repmat(ParametersHour(:,14,HourPoint),1,4))*100; % for outside, inside and alone
                
                % %%%%%%%%%%%%%%%%%%%%%%
                    FrequencyVisitsOutsideHour(:,HourPoint)=sum(Parameters(:,35,range),3,'omitnan')./(ElapseTime/60); % number of events go out of sleeping box normalized to detection time (1/h)
                    FrequencyVisitsHidingBoxHour(:,HourPoint)=sum(Parameters(:,51,range),3,'omitnan')./(ElapseTime/60);% number of events go out of hiding box normalized to detection time (1/h)
                    ForagingCorrelationHour(:,HourPoint)=mean(Parameters(:,36,range),3,'omitnan'); %Foraging correlation
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                  %% ---Calculate the distance travelled in each day in m units-REMEMBER ONLY CONSIDER DEFINED POINTS------
               DistanceTravelHour(:,HourPoint)=sum(Parameters(:,42,range),3,'omitnan')./sum(Parameters(:,43,range),3,'omitnan');
               %% -----------Calculate the average angular velocity (rad/sec) for each mouse-ONLY CONSIDER DEFINED POINTS-------
               AngularVelocityHour(:,HourPoint)=sum(Parameters(:,44,range),3,'omitnan')./sum(Parameters(:,45,range),3,'omitnan');   
                    
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    
                    
                    
                   TimeHour=[TimeHour,sum(TimeArray(countFile:size(TimeArray,1),1))];%vector of hours 
                   break
                   %countFile=countFile+6;%go to next files
                   %HourPoint=HourPoint+1;
                 end   
                   
             end
               
               
           end
           
           
           
           
           
           
           %% 
           
           % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Chasing analysis per day by
           % using excel file 
           % %%%%%%%%%%%%%%%%Load excel data %%%%%%%%%%%%%%%%%%%%

           
          ChasingFile=strcat(get(h.editRunParams,'string'),'\',item_selected(t),'\',item_selected(t),'\','Results','\','Chasing.xlsx'); %OPen chasing excel file
    %%  ChasingFile=strcat(get(h.editRunParams,'string'),'\',item_selected(t),'\',item_selected(t),'\','ResultsCorr0.7_200','\','Chasing.xlsx'); %OPen chasing excel file spetial case 2021
              sheet='Chasing';
              [num txt ChasingList]=xlsread(char(ChasingFile),sheet);
              sheet='Elo-rating All Events';
              [num txt EloratingList]=xlsread(char(ChasingFile),sheet);
              sheet='Elo-rating per day order';
              [num txt EloratingPerLastDay]=xlsread(char(ChasingFile),sheet);
              sheet='Glicko-rating Per Day';
              [num txt GlickoPerLastDay]=xlsread(char(ChasingFile),sheet);
               sheet='Glicko-rating Error Per Day';
              [num txt GlickoErrorPerDay]=xlsread(char(ChasingFile),sheet);
            %% -------------Find events per day of chasing and being chasing----------------
            NormDS=[];
            EloratingAveragePerDay=[];
            ChasingEventsPerDay=[];
            BeingChasingEventsPerDay=[];
            ChasingDurationPerDay=[];
            InteractionMatrix=[];
            [NormDS EloratingAveragePerDay ChasingEventsPerDay BeingChasingEventsPerDay ChasingDurationPerDay  InteractionMatrix ChasingPlusChased BeingChasingDurationPerDay ChasingBeingChasedEventsPerDay]=CalculateNumberChasingCorrected(Locomotion.AssigRFID.miceList,ChasingList,EloratingList,length(Days),Days);
%             ChasingTimePercentActive=(ChasingDurationPerDay./ActiveTimePerDay)*100;
            [DSAll NormDSAll]=CalculateDavidScore(InteractionMatrix,item_ScoreDay,LastDay); %Calculate David Score without considerading interactions Calculate from second day
            [DSAllD NormDSAllD]=CalculateDavidScoreWithDominance(InteractionMatrix);%Calculate David Score by considerading interactions
             NormDSAllDPerDay=CalculateDavidScoreWithDominancePerDay(InteractionMatrix);%Calculate David Score by considerading interactions per day
             EloratingPerLastDay=(EloratingPerLastDay(3:end,2:length(Locomotion.AssigRFID.miceList)+1))'; %Copy the elorating of the last day- This is the elorating per day
    %column are mice and columns are day
    %% %% -----------Sort the data according to the ranking from elorating calculation/acording to average-------------
             sheet='Ranking';
             [num txt RankingArray]=xlsread(char(ChasingFile),sheet); %THIS IS THE RANKING ACCORDING TO AVERAGE ELORATION
             IndexNewSort=FindIndex(strrep(RankingArray(:,1),'''',''),(Locomotion.AssigRFID.miceList)');
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          %%%%%%%%%%%%%% Create the sorting with the data from here %%%%%%%%%%%%%%%%%%%%%%%%
          % Read choice -fIRST ORDER ACCORDING TO THE MICElIST BY USING
          % RANKING AND THEN REORDER AGAIN.
           IndexNewSort1=FindIndex((Locomotion.AssigRFID.miceList)',strrep(RankingArray(:,1),'''',''));%Reorder again the elorating
          EloratingPerLastDayRealOrder=EloratingPerLastDay(IndexNewSort1,:);
           EloratingPerLastDayRealOrder=cell2mat( EloratingPerLastDayRealOrder);
           
           %get the glycko with the real order
           RankGlicko=(GlickoPerLastDay(1,2:end))';
           IndexRealForGlicko=FindIndex((Locomotion.AssigRFID.miceList)',strrep(RankGlicko,'''',''));%Reorder glicko according to original mice order
           GlickoPerLastDay=GlickoPerLastDay(:,2:end);
           GlickoPerLastDayRealOrder=GlickoPerLastDay(:,IndexRealForGlicko);
           
           
            AverageElorating= mean( EloratingPerLastDayRealOrder(:,str2num(char(item_ScoreDay)):LastDay),2);
                 switch(index_ScoreMethod)
                     case 2 % Average elorating from the second day
                        
                       [~,IndexNewSort]= sort(AverageElorating,'descend');
                     case 3  % David score ranking
                          [~,IndexNewSort]= sort(NormDSAll,'descend');%REVIEW THIS
                     case 4  % Last day elorating
                         [EloratingLast,IndexNewSort]= sort( EloratingPerLastDayRealOrder(:,LastDay),'descend');
                       case 5  % Last day glicko
                         [~,IndexNewSort]= sort( cell2mat(GlickoPerLastDayRealOrder(LastDay+2,:)),'descend');    
                 end
           
           %% Rearrangement of the data 
%                  raw=GetArrangementData(ParametersSum,IndexNewSort,...
%                      ChasingEventsPerDay, BeingChasingEventsPerDay,...
%                      EloratingAveragePerDay,EloratingPerLastDay,InteractionMatrix,...
%                      NormDSAll,NormDSAllD,NormDSAllDPerDay,TimeArray,RankingArray,ParametersSumTotalDetected,ParametersSumActiveTime);

% ----------------Arrange Ranking and elorating---------------------
RankingArray=(Locomotion.AssigRFID.miceList);
RankingArray=RankingArray(IndexNewSort,1);
EloratingPerLastDay=EloratingPerLastDayRealOrder(IndexNewSort,:);
GlickoPerLastDay1=(GlickoPerLastDayRealOrder(2:end,:))';
GlickoPerLastDay1=GlickoPerLastDay1(IndexNewSort,:);
GlickoErrorPerDay1=GlickoErrorPerDay';
IndexGlicko=FindIndex(RankingArray,strrep(GlickoErrorPerDay1(2:end,1),'''',''));
GlickoErrorPerDay2=GlickoErrorPerDay1(2:end,2:end);
GlickoErrorPerDay2=GlickoErrorPerDay2(IndexGlicko,:);
% ----------Add Social parameters at the end per day-------------------------
 sheet='Socialmatrix_LandauCoefficient';
             [num txt SocialMatrix]=xlsread(char(ChasingFile),sheet);
              MouseNames=SocialMatrix(1,2:size(Locomotion.AssigRFID.miceList,1)+1);
              MouseOriginal=(Locomotion.AssigRFID.miceList)';
              IndexSortSocial=FindIndex(MouseOriginal(1,IndexNewSort),strrep(MouseNames,'''',''));%Reorder social according to the new index sort
              SocialMatrix=SocialMatrix(1:size(Locomotion.AssigRFID.miceList,1)+1,1:size(Locomotion.AssigRFID.miceList,1)+1);
              AuxSc=SocialMatrix(:,2:end);
              SocialMatrix(:,2:end)=AuxSc(:,IndexSortSocial);
              AuxSr=SocialMatrix(2:end,:);
              SocialMatrix(2:end,:)=AuxSr(IndexSortSocial,:);
              
raw=GetArrangementDatavs2(ParametersSum,IndexNewSort,...
                      ChasingEventsPerDay, BeingChasingEventsPerDay,...
                      EloratingAveragePerDay,EloratingPerLastDay,InteractionMatrix,...
                    NormDSAll,AverageElorating,item_ScoreMethod,TimeArray,RankingArray,ParametersSumTotalDetected,ParametersSumActiveTime,...
                    FrequencyVisitsOutside,ForagingCorrelation,EntropyDay,DistanceTravelDay,AngularVelocityDay,FrequencyVisitsHidingBox,ChasingPlusChased,ChasingDurationPerDay,...
                   GlickoPerLastDay1,SocialMatrix,GlickoErrorPerDay2,BeingChasingDurationPerDay,ChasingBeingChasedEventsPerDay); %David score differnet from the chasing tables
                
  sheet=strcat(char(item_selected(t)),'PerDay'); %save per day
  xlswrite(strcat(SaveFolder,'AllTheParametersPerDay.xlsx'),raw,sheet)
  

             % Rearrangement the data per hour
               rawHour=GetArrangementDataPerHour(ParametersHour,TimeHour,RankingArray,IndexNewSort,ForagingCorrelationHour,FrequencyVisitsOutsideHour,ParametersSumActiveTimeHour,...
                        DistanceTravelHour,AngularVelocityHour,FrequencyVisitsHidingBoxHour)
              %% add parameters per stage
           rawPerStage=ParametersPerStage(ParametersSum,IndexNewSort,RankingArray,ChasingEventsPerDay,BeingChasingEventsPerDay,ChasingPlusChased,ChasingDurationPerDay,GlickoPerLastDay1,...
               EloratingPerLastDay,ForagingCorrelationStage,EntropyDayStage,DistanceTravelDayStage,AngularVelocityStage);
           
           %% ---Save the data----------

   sheet=strcat(char(item_selected(t)),'PerHour'); %save per hour
  xlswrite(strcat(SaveFolder,'AllTheParametersPerHour.xlsx'),rawHour,sheet)
   % -----------Save data per stage 1(first day) and stage2 others
   % days--------
   sheet=strcat(char(item_selected(t)),'PerStage'); %save per hour
  xlswrite(strcat(SaveFolder,'AllTheParametersPerStage.xlsx'),rawPerStage,sheet)
  
  %------------------Save also matrix as matlab for further use----------
  Allparameters.ParamsPerHour= ParametersHour;
  Allparameters.HourDetection= TimeHour;
  Allparameters.IndexDominance=IndexNewSort;
  Allparameters.MiceList=Locomotion.AssigRFID.miceList;
  Allparameters.ParametersUsed={'RunningTime';'WalkingTime';'StaticTime';'eatingSumTime';'drinkingSumTime';'sleepingSumTime';...
                               'hidingSumTime';'ArenaSumTime';'InsideZoneTime';'OutsideZoneTime';'CenterTimeAlone';'movementTime'};
  save(strcat(SaveFolder,char(item_selected(t)),'AllTheParameters.mat'),'Allparameters')

   end


close(g)
waitbar(t/length(item_selected))
end
close(hbar)

%% -------------For plotting -Etogram for each mouse and each group---------------
% 
for t=1:length(item_selected) %LOOP FOR EACH EXPERIMENT
    if get(h.checkbox3,'Value')==1%for plotting all the experiments 
     uu=msgbox('Wait for plottings')
    
% %  FilenameChasingData=strcat(get(h.editRunParams,'string'),'\',item_selected(t),'\','Data','\','ChasingResults','\',strcat(item_selected(t),'_ChasingResults.xlsx'));
%  FilenameChasingData=strcat(get(h.editRunParams,'string'),'\');
%  PlotParameters(strcat(SaveFolder,'AllTheParameters.xlsx'),Exp_arrA,FilenameChasingData);   
    PlotEthogram(SaveFolder,char(item_selected(t)))
    close(uu)
    end
end   

%% 
if (get(h.checkbox1,'Value')==1) %for plotting ethograms of groups
   for t=1:length(item_selected) %LOOP FOR EACH EXPERIMENT 
        uu=msgbox('Wait for plottings')
        load(strcat(SaveFolder,char(item_selected(t)),'AllTheParameters.mat'),'Allparameters')
        IndexOrder=Allparameters.IndexDominance;
           Folder_Data=strcat(get(h.editRunParams,'string'),'\',item_selected(t),'\',item_selected(t),'\','Data','\',strcat(item_selected(t),'ResultsMatlab','\'));
         PlotEthogramGroups(SaveFolder,char(item_selected(t)),Folder_Data,IndexOrder)
    
        close(uu)
   end
end
%% 

  msgbox('The running finished')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% --Auxiliary functions---------------

function ChasingEventsPerFile=CalculateNumberChasing(ChasingAll) 
   for i=1:size(ChasingAll,2)
      ChasingEventsPerFile(i)=size(ChasingAll{1,i},1);

    end
end

%% 
function [ChasingLengthPerFile]=CalculateChasingDurationLength(ChasingAll,TrajectoryX,TrajectoryY,numOfMice)
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
% function SumVelocityExp =calcVelocity(Velocity,staticVelocity)
% 
% for i=1:size(Velocity,2) %loop through all mice
%     %sum all without consider static
%     
% %    SumVelocityExp(i,1)= sum(Velocity(Velocity(:,i)>staticVelocity,i));
% %    VelocitySize(i,1)=size(SumVelocityExp(i,1),1); 
%     if ~isempty(find(Velocity(:,i)>staticVelocity))  %consider no valid velocity more than 200cm/sec which is the reported limit this is not correct.
%        SumVelocityExp(i,1)=median(Velocity(Velocity(:,i)>staticVelocity,i)); %since the velocity distribution is very width it is better to take the median of the distribution
%        
%        %Velocity median more than 200cm/sec which is the reported limit
%        %this is not correct.NOTE!!!!!!
%        
%       if  SumVelocityExp(i,1)>1000 %was 200
%          SumVelocityExp(i,1)=NaN; %no information 
%           
%       end
%        
%     else
%         SumVelocityExp(i,1)=NaN;
%        
%     end
%     
%     
%     
% end
% % SumVelocityExp
% end
function SumVelocityExp =calcVelocity(Velocity,staticVelocity,inarena)

 for i=1:size(inarena,2) %loop through all mice
    %sum all without consider static
    Ilogical=(Velocity(:,i)<400 & Velocity(:,i)>staticVelocity & inarena(:,i)); %LIMITS THE VELOCITY TO 400-be in
                                                                           % arena and larger than static
    
  
    if ~isempty(find(Ilogical==1))  %consider no valid velocity more than 200cm/sec which is the reported limit this is not correct.
       SumVelocityExp(i,1)=median(Velocity(Ilogical,i)); %since the velocity distribution is very width it is better to take the median of the distribution
    else
       SumVelocityExp(i,1)=NaN;
   end
% SumVelocityExp
 end
end
%% 
function SumAcelerationExp =calcAceleration(Aceleration,inarena)

 for i=1:size(Aceleration,2) %loop through all mice
    %sum all without consider static
    Ilogical=(Aceleration(:,i)<1e6 & Aceleration(:,i)> 0 & inarena(:,i)); %LIMITS THE VELOCITY TO 400-be in
                                                                           % arena and larger than static
    
  
    if ~isempty(find(Ilogical==1))  %consider no valid velocity more than 200cm/sec which is the reported limit this is not correct.
       SumAcelerationExp(i,1)=median(Aceleration(Ilogical,i)); 
    else
        SumAcelerationExp(i,1)=NaN;
        
   end
% SumVelocityExp
 end
end

%% 
function TimeAlone=calcAloneTime(isInArena,ExperimentTime)
%find the ones
%Separate into files to limit memory size
 if size(isInArena,1)<60000
  [Irow,Icolumn,ind]=find(isInArena==1);
  %sort the Irow
   [Irow IndSort]=sort(Irow);


    %find rows without repeats 

    RowsWithOneMouse = Irow(sum(bsxfun(@eq, Irow(:), Irow(:)'))==1);

%Extract the arena data which has a row with only one 1 , this means that
%there is only one mouse in the arena.
 else 
      [Irow,Icolumn,ind]=find(isInArena(1:29999,:)==1);
  %sort the Irow
   [Irow IndSort]=sort(Irow);
    %find rows without repeats 
    RowsWithOneMouse1 = Irow(sum(bsxfun(@eq, Irow(:), Irow(:)'))==1);
    
    Irow=[];
    IndSort=[];
    ind=[];
    Icolumn=[];
    
     [Irow,Icolumn,ind]=find(isInArena(30000:size(isInArena,1),:)==1);
  %sort the Irow
   [Irow IndSort]=sort(Irow);
    %find rows without repeats 
    RowsWithOneMouse2 = Irow(sum(bsxfun(@eq, Irow(:), Irow(:)'))==1);
    RowsWithOneMouse=[RowsWithOneMouse1;RowsWithOneMouse2];
 end    
     
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
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
    
   IndexNew(i)=find(strcmp(A(i),B)==1); 
    
    
end



end

