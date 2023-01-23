
function ManagerComputeAll( ~,~ )
%% ------------------------------Variables---------------------------

global h
clc
clear MouseArray;
clear ArrayX; %for x coord.
clear ArrayY; %for y coord.
clear ArrayXY;
ArrayX=[];
ArrayY=[];
ArrayXY=[];
%% -----------------------Parameters----------------
Params=ParametersComputeAll;


%% --------------------Read Parameters of csv files----------------
CSVobj=FilesTreat;%use class FilesTreat
CSVobj.directory=Params.DataDir;
CSVobj.extension='.csv';




%% --------------------Define object IsSleeping---------------------
IsSleepingobj=Sleeping; %use class Sleeping

IsSleepingobj.SleepingBox=Params.SleepingBox; %coordinates of sleeping box


%% --------------------------Define object IsHiding-----------------
IsHidingobj=Hiding; %use class Hiding
% IsHidingobj.AntennaHidingBox=Params.AntennaHidingBox;
IsHidingobj.HidingCoord=Params.Coordinates.HidingCoordinates; %every 4rows is a different hiding box

%% -----------------------------Define object IsArena ---------------------------
InArenaobj=Arena;
InArenaobj. AntennaCoord=Params. AntennaCoord;%antenna position
InArenaobj.TreshWalk=Params.TreshWalk;%walking threshold in cm/sec
InArenaobj.TreshRun=Params.TreshRun;%running threshold in cm/sec
InArenaobj.TreshVelocity=Params.TreshVelocity; % velocity threshold cm/sec
%% ---------------------------Define object Time---------------------------------
Timeobj=TimeLine;
%% ------------------------Define object IsEatingDrinking-----------------------------
IsEatingDrinkingobj=IsEatingDrinking;
IsEatingDrinkingobj.VelocityThreshFood=Params.VelocityThreshFood; %velocity when is either eating or drinking
IsEatingDrinkingobj.FoodCoordinates=Params.Coordinates.FoodCoordinates;%coordinates of eating
IsEatingDrinkingobj.WaterCoordinates=Params.Coordinates.WaterCoordinates;%coordinates of drinking
IsEatingDrinkingobj.radiusD=Params.radiusD; %radius around drinking
%% 
%%-----------Define object IsInZone----------------
IsInZoneobj=IsInZone;
IsInZoneobj.ZoneCoord=Params.ZoneCoord;


%%
%%-------SELECT BETWEEN DOING ALL THE EXPERIMENT OR THE SELECTION OF SOME
%%FILES---

switch Params.ForSomeFile
case 0 %All the experiment
nCSV=CSVobj.NumFiles(CSVobj.ListFiles);  %number of files of all the experiment   

for i=1:nCSV %loop over the original files
%for i=1:3

    
    i
%% Variables 
    
clear MouseArray;
%% Read excel and matlab files for each nCSV
        
CSVFile=CSVobj.ReadFilesAllCSV(CSVobj.ListFiles,i);%read each file
CSVmiceIDs=CSVobj.miceIDs(CSVobj.ListFiles,i);%read the mice identities of each file-Now the  order of the mice identity is the same for each file
CSVFileName=CSVobj.FileName(CSVobj.ListFiles,i)

% Read the mat file


MatFileName=strcat(CSVFileName(1:strfind(CSVFileName,']')),'.mat');
try %if the file isn't in one directory is in the other
load(fullfile(Params.resultsDir,MatFileName)); %the structure is lococomotion
catch
    
  
    
end
%% R the mice list  identity
miceList=Locomotion.AssigRFID.miceList;

 hn=msgbox(strcat('Doing File:',num2str(i)))


%% Create a wait bar for control
hbar = waitbar(0,'Please wait...'); 

% Rearrange the data according to the mice in a multidimensional array

for countMouse=1:length(miceList) %for each mouse
    j=countMouse
      %% Clear the variables
   
    %% 

    MouseArray(2:length([CSVFile{1}])+1,1,countMouse)=CSVFile{1}; %for date
    MouseArray(2:length([CSVFile{2}])+1,2,countMouse)=strcat([CSVFile{2}]); %for time


    %% 
    MouseArray(2:length([CSVFile{2}])+1,3,countMouse)=num2cell(CSVFile{3+(countMouse-1)*3}); %for x coordinates

    MouseArray(2:length([CSVFile{2}])+1,4,countMouse)=num2cell(CSVFile{4+(countMouse-1)*3}); %for y  coordinates
    


  %%  %% ----------Find is sleeping-------------------------
     IsSleeping=[];
     SleepingInterval=[];
     
     IsSleeping=Locomotion.AssigRFID.IsSleeping(:,countMouse);
     IsSleeping=IsSleeping(1:size(CSVFile{4+(countMouse-1)*3},1),:); 
     MouseArray(2:length([CSVFile{2}])+1,5,countMouse)=num2cell(IsSleeping);
     SleepingInterval=IsSleepingobj.IsSleepingInterval((IsSleeping));%Sleeping interval
     
     Locomotion.AssigRFID.Sleeping.IsSleeping(:,countMouse)=IsSleeping;
     Locomotion.AssigRFID.Sleeping.SleepingIntervalBegin(1:size(SleepingInterval(:,1),1),countMouse)=SleepingInterval(:,1);
     Locomotion.AssigRFID.Sleeping.SleepingIntervalEnd(1:size(SleepingInterval(:,2),1),countMouse)=SleepingInterval(:,2);
     MouseArray(2:length(SleepingInterval(:,1))+1,20,countMouse)=num2cell(SleepingInterval(:,1));
     MouseArray(2:length(SleepingInterval(:,2))+1,21,countMouse)=num2cell(SleepingInterval(:,2));
     % find the number of the sleeping cage
     IsSleepingobj.CoordinateX=cell2mat( MouseArray(2:length([CSVFile{2}])+1,3,countMouse));
     IsSleepingobj.CoordinateY=cell2mat( MouseArray(2:length([CSVFile{2}])+1,4,countMouse));
     Locomotion.AssigRFID.Sleeping.SleepingCage(:,countMouse)=IsSleepingobj.IsSleepingCage(SleepingInterval);%sleeping cage
     MouseArray(2:length([CSVFile{2}])+1,6,countMouse)=num2cell( Locomotion.AssigRFID.Sleeping.SleepingCage(:,countMouse));
     
     
     %% 
%        %%-------------------------------- Find is hiding---------------------------------------- 
      HidingInterval=[];
      
      IsHidingobj.CoordinateX=cell2mat(MouseArray(2:length([CSVFile{2}])+1,3,countMouse));% coordinates for each mouse
      IsHidingobj.CoordinateY=cell2mat(MouseArray(2:length([CSVFile{2}])+1,4,countMouse));
      Locomotion.AssigRFID.Hiding.IsHiding(:,countMouse)=IsHidingobj.IsHiding;%is hiding
      MouseArray(2:length([CSVFile{2}])+1,7,countMouse)=num2cell(Locomotion.AssigRFID.Hiding.IsHiding(:,countMouse));   % save hiding data  
      HidingInterval=IsHidingobj.IsHidingInterval(IsHidingobj.IsHiding); %sleeping interval
      Locomotion.AssigRFID.Hiding.HidingIntervalBegin(1:size(HidingInterval(:,1),1),countMouse)= HidingInterval(:,1);
      Locomotion.AssigRFID.Hiding.HidingIntervalEnd(1:size(HidingInterval(:,2),1),countMouse)=HidingInterval(:,2);
      MouseArray(2:length(HidingInterval(:,1))+1,22,countMouse)=num2cell(HidingInterval(:,1));
      MouseArray(2:length(HidingInterval(:,1))+1,23,countMouse)=num2cell(HidingInterval(:,1));
       
     %find the number of the hiding box
      Locomotion.AssigRFID.Hiding.HidingBox(:,countMouse)=IsHidingobj.IsHidingCage(HidingInterval);
     
      MouseArray(2:length([CSVFile{2}])+1,8,countMouse)=num2cell(Locomotion.AssigRFID.Hiding.HidingBox(:,countMouse));  
       
     
     %% %% 
     %-----------------------------Find is in the arena-------------------------------------
    %find the interval for in arena
    InArenaobj.IsSleeping=[];
    InArenaobj.IsHiding=[];
     InArenaobj.IsSleeping=Locomotion.AssigRFID.Sleeping.IsSleeping(:,countMouse);
     InArenaobj.IsHiding= Locomotion.AssigRFID.Hiding.IsHiding(:,countMouse);
     Locomotion.AssigRFID.Arena.InArena(:,countMouse)=InArenaobj.InArena;
     MouseArray(2:length([CSVFile{2}])+1,9,countMouse)=num2cell(Locomotion.AssigRFID.Arena.InArena(:,countMouse));  
     
  
     %% ---------------------------- Calculate velocity -----------------------
    
       % Save the speed velocity
       Locomotion.AssigRFID.Arena.VelocityMouse(:,countMouse)=Locomotion.AssigRFID.VelocityMouse(:,countMouse);
        MouseArray(2:length([CSVFile{2}])+1,10,countMouse)=num2cell(Locomotion.AssigRFID.VelocityMouse(:,countMouse));
       % Consider only the velocity in the arena
        Locomotion.AssigRFID.Arena.ArenaVelocityOnly(:,countMouse)=Locomotion.AssigRFID.Arena.VelocityMouse(:,countMouse);
        Locomotion.AssigRFID.Arena.ArenaVelocityOnly(~Locomotion.AssigRFID.Arena.InArena(:,countMouse),countMouse)=NaN; %everything in the sleeping cage and hiding box  is NAN
        Locomotion.AssigRFID.Arena.ArenaVelocityOnly(:,countMouse)=Locomotion.AssigRFID.Arena.ArenaVelocityOnly(1:size(Locomotion.AssigRFID.Arena.VelocityMouse(:,countMouse)),countMouse); %to avoid addition of Nan more
       
   %% ----------------------------Determine when it is stop,running, walking according to the velocity----------------------------  
            InArenaActivity=[];
            InArenaActivity=InArenaobj.InArenaActivity(Locomotion.AssigRFID.Arena.ArenaVelocityOnly(:,countMouse));
            Locomotion.AssigRFID.Arena.IsRunning(:,countMouse)=InArenaActivity(:,3);
            Locomotion.AssigRFID.Arena.IsWalking(:,countMouse)=InArenaActivity(:,2);
            Locomotion.AssigRFID.Arena.IsStopping(:,countMouse)=InArenaActivity(:,1);
          
            MouseArray(2:length([CSVFile{2}])+1,11,countMouse)=num2cell(InArenaActivity(:,1)); %stop
            MouseArray(2:length([CSVFile{2}])+1,12,countMouse)=num2cell(InArenaActivity(:,2));%walking
            MouseArray(2:length([CSVFile{2}])+1,13,countMouse)=num2cell(InArenaActivity(:,3));%running
       
       %% ---------------------- Find is drinking and is eating ------------------------------
     IsEating=[];
     IsDrinking=[];
     
     IsEating=IsEatingDrinkingobj.IsEating(Locomotion.AssigRFID.Arena.InArena(:,countMouse),...
                                      cell2mat(MouseArray(2:length([CSVFile{2}])+1,3,countMouse)),cell2mat(MouseArray(2:length([CSVFile{2}])+1,4,countMouse)),...
                                       Locomotion.AssigRFID.Arena.ArenaVelocityOnly(:,countMouse));
                                   
     IsDrinking=IsEatingDrinkingobj.IsDrinking(Locomotion.AssigRFID.Arena.InArena(:,countMouse),...
                                      cell2mat(MouseArray(2:length([CSVFile{2}])+1,3,countMouse)),cell2mat(MouseArray(2:length([CSVFile{2}])+1,4,countMouse)),...
                                       Locomotion.AssigRFID.Arena.ArenaVelocityOnly(:,countMouse));
    
    Locomotion.AssigRFID.EatingDrinking.IsEatingAccordingPlace(:,countMouse)=IsEating(:,1);
    Locomotion.AssigRFID.EatingDrinking.IsEatingAccordingPlaceVelocity(:,countMouse)=IsEating(:,2);
    Locomotion.AssigRFID.EatingDrinking.IsDrinking(:,countMouse)=IsDrinking;
    MouseArray(2:length([CSVFile{2}])+1,11,countMouse)=num2cell(IsEating(:,2));%eating
    MouseArray(2:length([CSVFile{2}])+1,12,countMouse)=num2cell(IsDrinking);%drinking  
    
    
        %% -----------------------------Determine if it is inside or outside a given zone----------------------------
    IsZone=[];
    IsZone=IsInZoneobj.IsZone(Locomotion.AssigRFID.Arena.InArena(:,countMouse),...
                         cell2mat(MouseArray(2:length([CSVFile{2}])+1,3,j)),cell2mat(MouseArray(2:length([CSVFile{2}])+1,4,j)));
                     
    Locomotion.AssigRFID.Arena.InsideZone(:,countMouse)=IsZone(:,1);
    Locomotion.AssigRFID.Arena.OutsideZone(:,countMouse)=IsZone(:,2);
    MouseArray(2:length([CSVFile{2}])+1,13,countMouse)=num2cell(IsZone(:,1));%inner zone
    MouseArray(2:length([CSVFile{2}])+1,14,countMouse)=num2cell(IsZone(:,2));%outside zone
       
    
%  %Control of wait bar
 waitbar(countMouse/length(miceList));

end

 close(hbar)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Finish Looping  over each mice %%%%%%
%% --------------------Compute distance pairs---------------------------
 DistancePairs=computeDistancePairsGV(Locomotion);
 Locomotion.AssigRFID.Behaviour.DistancePairs=DistancePairs; %NO TO TRUST IN ZERO VALUES

%% -----------------------Compute together--------------------------------------
%% ---------------------------Define object together--------------------------------
DistanceToBeTogether=Params.DistanceToBeTogheter; %distance to be considered together in general is 10cm
TogetherParams=TogetherCalc(Locomotion,DistanceToBeTogether);

Locomotion.AssigRFID.Behaviour.Together.TimesTogetherSec=TogetherParams(:,length(Locomotion.AssigRFID.miceList)+1);
Locomotion.AssigRFID.Behaviour.Together.TogetherAll=TogetherParams(:,1:length(Locomotion.AssigRFID.miceList));



%% -------------------------------Calculating chasing-----------------------------

Dist_tresh1=300;
Velocity_Tresh=0.5;
PathTresh=600;
Dist_tresh2=300;%instead 200
angle_threshold=30; %FIVE DEGREES
TrajectoryThresh=200;

%[chasing_all,chased_all]=ChasingCal(Locomotion,Dist_tresh1,Velocity_Tresh,PathTresh,Dist_tresh2);
% [chasing_all,chased_all]=ChasingCalSilviaVersion(Locomotion,Velocity_Tresh,angle_threshold,TrajectoryThresh);
%% Second option
AngleMaximum1=Params.AngleMaximum1; %This is the maximum angle, which is allowed, between the line joining the mice 1-2 and the vector of movement of mouse 1.
AngleMaximum2=Params.AngleMaximum2; %This is the maximum angle, which is allowed, between the vector of movement of mouse 1 and mouse 2.
MinimumPath=Params.editpar1; %This is the minimum path recording to be considered as chasing.
GapPath=Params.editpar2; %This is the maximum distance allow to finish the chasing mm
ThreshVelocity=Params.editpar3; %20-10 cm/sec
GapFrames=Params.editpar4; %maximum number of frames to be allowed to be a gap
GapPathEnd=Params.editpar5; %the end of the frame
% 
GapFramesS=Params.editpar6; %maximum number of frames to be allowed to be a gap in small frames
GapPathEndS=Params.editpar7; % condition of the end of the frame in small frames
% 
% % Chasingobj.AngleMaximum1=20/30; %This is the maximum angle, which is allowed, between the line joining the mice 1-2 and the vector of movement of mouse 1.
% % Chasingobj.AngleMaximum2=20/30; %This is the maximum angle, which is allowed, between the vector of movement of mouse 1 and mouse 2.
% % Chasingobj.MinimumPath=200; %This is the minimum path recording to be considered as chasing.
% % Chasingobj.GapPath=400; %This is the maximum distance allow to finish the chasing mm
% % Chasingobj.ThreshVelocity=10/5; %20-10 cm/sec
% % Chasingobj.GapFrames=100; %maximum number of frames to be allowed to be a gap
% % Chasingobj.GapPathEnd=200; %the end of the frame

[chasing_all,chased_all]=ChasingCalvs2(Params,Locomotion)



Locomotion.AssigRFID.Behaviour.Chasing.chasing=chasing_all;
Locomotion.AssigRFID.Behaviour.Chasing.chased=chased_all;


%---------Create chasing object-------------------
%All the units are in mm
%Chasingobj=Chasing;




% Chasingobj.numOfMice=length(Locomotion.miceList);
% Chasingobj.Dist_tresh1=300;
% Chasingobj.Velocity_Tresh=0.5;
% Chasingobj.PathTresh=600;
% Chasingobj.Dist_tresh2=200;
% 

% 
% 
% 
% 
% 
% 
% %-------------------------
% % 
% % TrajectoryX=Locomotion.TrajectoryX;
% % TrajectoryY=Locomotion.TrajectoryY;
% % Velocity=Locomotion.Velocity;
% %% CALCULATION OF CHASING BY INSERTING CORRECTED COORDINATES INTO GV MODULE
% 
% % ChasingCal=Chasingobj.ChasingCal(TrajectoryX,TrajectoryY,Locomotion.Velocity(Locomotion.RepeatedFrames,:),Locomotion.isInArena(Locomotion.RepeatedFrames,:),Locomotion.VectorX,Locomotion.VectorY,Locomotion.Distance,Locomotion.ExperimentalTime(Locomotion.RepeatedFrames,:));
% 
% %% CALCULATION OF CHASING BY INSERTING CORRECTED COORDINATES INTO SILVIA MODULE
%  %ChasingCalvs2=Chasingobj.ChasingCalvs2(TrajectoryX,TrajectoryY,Locomotion.VectorX1,Locomotion.VectorY1,Locomotion.isInArena,Velocity );
% 
% %% 
% 
% % Locomotion.ChasingAll=ChasingCal(:,1:Chasingobj.numOfMice);
% % Locomotion.ChasedAll=ChasingCal(:,Chasingobj.numOfMice+1:2*Chasingobj.numOfMice);
% 
% % Locomotion.MoveTogether=ChasingCal(:,2*Chasingobj.numOfMice+1:3*Chasingobj.numOfMice);
% 
% 
% Locomotion.ChasingAll=ChasingCalvs2(:,1:Chasingobj.numOfMice);
% Locomotion.BeingChasingAll=ChasingCalvs2(:,Chasingobj.numOfMice+1:Chasingobj.numOfMice+Chasingobj.numOfMice);
% % Locomotion.TimeWithoutRepeats=Locomotion.ExperimentalTime(Locomotion.RepeatedFrames,:);



hhh=msgbox('Chasing analysis finish')
close(hhh)
% %%                                                  CALCULATION OF AVOIDANCE(mouse2 near mouse1 but mouse1 running away from mouse2)
% 
% % Create Avoidance object
% Avoidanceobj=Avoidance;
% Avoidanceobj.numOfMice=length(Locomotion.miceList);
% Avoidanceobj.Distance_thresh= Params.Distance_thresh_For_Avoidance;
% Avoidanceobj.Dist_thresh_Fine_Tuning=Params.Dist_thresh_Fine_Tuning_For_Avoidance; %dist for fine tuning according GV is 100mm
% Avoidanceobj.velThr=Params.Velocity_For_Avoidance;% according gv 35cm/sec
% Avoidanceobj.R=Params.Radius_Within_Avoidance;% according gv 30 cm
% 
% %% 
% AvoidanceCal=Avoidanceobj.AvoidanceCal(TrajectoryX,TrajectoryY,Velocity,Locomotion.isInArena)
% %% 
% Locomotion.avoiding=AvoidanceCal;
% 
% hhhh=msgbox('Avoidance calculation was finished')
% close(hhhh)
% 
% %% %%                                                  CALCULATION OF APPROACHING (mouse 1 approaches mouse 2 and the event finished)
% 
% % Create Approaching object
%  Approachingobj=Approaching;
%  Approachingobj.numOfMice=length(Locomotion.miceList);
%  Approachingobj.Distance_thresh= Params.Distance_thresh_For_Approaching; %According to GV this is 40cm
%  Approachingobj.distTr=Params.Distance_Thresh_For_Approaching_Fine_Tuning;%According to GV this is 10cm
%  Approachingobj.CorrelFactor=Params.CorrFactor_between_mice_For_Approaching; %According to GV this is 0.3
%  Approachingobj.velTr2=Params.Velocity_Thresh_To_beSamePlace_For_Approaching; %According to GV this is 25cm/sec
% 
% 
% %% 
% ApproachingCal=Approachingobj.ApproachingCal(TrajectoryX,TrajectoryY,Velocity,Locomotion.isInArena,Locomotion.VectorX,Locomotion.VectorY)
% % %% 
% Locomotion.ApproachingAll=ApproachingCal(:,1:Approachingobj.numOfMice);
% Locomotion.BeingApproachingAll=ApproachingCal(:,Approachingobj.numOfMice+1:Approachingobj.numOfMice+Approachingobj.numOfMice);
% 
% hhhh=msgbox('Approaching calculation was finished')
% close(hhhh)


%% %------------Save as a mat file as GV---------------------------
% %% Move matlab files with segmentation +rfid to new directory
% mkdir(Params.resultsDir,'SegmentationPlusRFID');
% try %if it wasn't move the file before
% movefile(fullfile(Params.resultsDir,MatFileName),fullfile(Params.resultsDir,'SegmentationPlusRFID',MatFileName));
% catch
%     
% end


%% Save mat files with names as GV

% 
% DateMat=MatFileName(1:strfind(MatFileName,'-')-1);
% DateMat=strrep(DateMat,'.','_');
% 
%  Indexes1a=strfind(MatFileName,'['); %the initial time
%  Indexes1b=strfind(MatFileName,']'); %the final time
%  
%  NewMatFileName=strcat(DateMat,'_',MatFileName(Indexes1a+1:Indexes1b-1),'.mat');
%  
%    filename1=strcat(fullfile(Params.resultsDir,MatFileName));%where are the matlab results
   save(fullfile(Params.resultsDir,MatFileName),'Locomotion');

%    delete(fullfile(Params.resultsDir,MatFileName));
 

%% 

 
 close(hn)

 %% 
 
end

%% %% ---------------------------------Arrange the chasing events into an excel file AGREGAR LO QUE FALTA----------------------------
%[AllChasing,AllAvoiding,AllApproaching]=GetEvents;

[AllChasing]=GetEvents;
%% --------------------SAVE SOCIAL EVENTS INTO EXCEL FILE-----------------
behaviour=0;


      %for chasing
        if ~isempty(AllChasing)
          SaveSocialData(AllChasing,behaviour,Params.SaveDirectory,Params.exp_name,Params)
        end

         
          
          
  msgbox('Finish all')
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%END MULTIPLE FILES
%%BEGIN FOR SELECTED FILES 
%% 
%% 
% 
% case 1 %take single files from the list for further analysis
%     
% index_selected = get(h.listAllRFID,'Value');  %Select the csv files to work
% list = cellstr(get(h.listAllRFID,'String'));
% item_selected = list(index_selected,1); % Convert from cell array to string
% nCSV=length(item_selected);
% % 
% for i=1:nCSV %loop over the original files
% clear ArrayX; %for x coord.
% clear ArrayY; %for y coord.
% clear ArrayXY;
% clear ArrayRFID;
% 
% ArrayX=[];
% ArrayY=[];
% ArrayXY=[];
% ArrayRFID=[];
% 
%  clear Distance;
%   clear  VectorX;
%   clear  VectorY;
%     clear  VectorX1;
%   clear  VectorY1;
% Distance=[];
% VectorX=[];
% VectorY=[];   
% VectorX1=[];
% VectorY1=[]; 
% clear MouseArray ; 
% %% 
% 
% CSVFile=CSVobj.ReadFilesAllCSV(CSVobj.ListFiles,index_selected(i));%Use Files Treat to read this file
% CSVmiceIDs=CSVobj.miceIDs(CSVobj.ListFiles,index_selected(i));
% CSVFileName=CSVobj.FileName(CSVobj.ListFiles,index_selected(i))
% 
% % Read the mat file
% 
% 
% MatFileName=strcat(CSVFileName(1:strfind(CSVFileName,']')),'.mat');
% try %if the file isn't in one directory is in the other
% load(fullfile(Params.resultsDir,MatFileName)); %the structure is lococomotion
% catch
%     
%     load(fullfile(Params.resultsDir,'SegmentationPlusRFID',MatFileName));
%     
% end
% %% 
% 
% hn=msgbox(strcat('Doing File:',num2str(i)))
% 
% 
% %% Create a wait bar for control
% hbar = waitbar(0,'Please wait...'); 
% 
% % Rearrange the data according to the mice in a multidimensional array
% 
% for j=1:length(miceList) %for each mouse
%       %% Clear the variables
%     clear AuxID
%     clear Auxtime
%     clear Auxantenna
%     clear Iaux
%     clear AuxIDn
%     clear Auxtimen
%     clear Auxantennan
%     clear IsSleeping
%     %% 
% 
%     MouseArray(2:length([CSVFile{1}])+1,1,j)=CSVFile{1}; %for date
%     MouseArray(2:length([CSVFile{2}])+1,2,j)=strcat([CSVFile{2}]); %for time
% 
% 
%     %% 
%     MouseArray(2:length([CSVFile{2}])+1,3,j)=num2cell(CSVFile{3+(j-1)*3}); %for x coordinates
% 
%     MouseArray(2:length([CSVFile{2}])+1,4,j)=num2cell(CSVFile{4+(j-1)*3}); %for y  coordinates
%     
%     MouseArray(2:length([CSVFile{2}])+1,5,j)=num2cell(Locomotion.AntennaInformation(:,j)); %antenna rfid
% 
% 
% 
% 
%   %%  %% ----------Find is sleeping-------------------------
%      IsSleepingobj.AntennaNumber=Locomotion.AntennaInformation(:,j);  
%      
%      IsSleeping=[Locomotion.IsSleeping(:,j)];
%      IsSleeping=IsSleeping(1:size(Locomotion.AntennaInformation(:,j),1),:);%since restrict the matrix in segmentation program to 20000
%      
%      MouseArray(2:length([CSVFile{2}])+1,6,j)=IsSleeping;
%       
%      SleepingInterval=IsSleepingobj.IsSleepingInterval(cell2mat(IsSleeping)); %sleeping interval
%      SleepingBeg= SleepingInterval(:,1);
%      SleepingEnd=SleepingInterval(:,2);
%      MouseArray(2:length(SleepingBeg)+1,20,j)=num2cell(SleepingBeg);
%      MouseArray(2:length(SleepingEnd)+1,21,j)=num2cell(SleepingEnd);
%      
%      
%      %find the number of the sleeping cage
%      MouseArray(2:length([CSVFile{2}])+1,7,j)=num2cell(IsSleepingobj.IsSleepingCage(SleepingInterval));
%      
%      
%      %% 
%        %%-------------------------------- Find is hiding---------------------------------------- 
%       IsHidingobj.CoordinateX=cell2mat(MouseArray(2:length([CSVFile{2}])+1,3,j));
%       IsHidingobj.CoordinateY=cell2mat(MouseArray(2:length([CSVFile{2}])+1,4,j));
%       IsHidingobj.AntennaNumber=Locomotion.AntennaInformation(:,j); 
%       
%       
%       MouseArray(2:length([CSVFile{2}])+1,8,j)=num2cell(IsHidingobj.IsHiding);     
%        
%        %find hiding interval
%        
%      HidingInterval=IsHidingobj.IsHidingInterval(IsHidingobj.IsHiding); %sleeping interval
%      HidingBeg= HidingInterval(:,1);
%      HidingEnd=HidingInterval(:,2);
%      MouseArray(2:length(HidingBeg)+1,22,j)=num2cell(HidingBeg);
%      MouseArray(2:length(HidingEnd)+1,23,j)=num2cell(HidingEnd);
%        
%      %find the number of the hiding box
%      MouseArray(2:length([CSVFile{2}])+1,9,j)=num2cell(IsHidingobj.IsHidingCage(HidingInterval));  
%        
%      
%      %% %% 
%      %-----------------------------Find is in the arena-------------------------------------
%     %find the interval for in arena
%      InArenaobj.IsSleeping=MouseArray(:,6,j);
%      InArenaobj.IsHiding=MouseArray(:,8,j);
%      InArenaobj.AntennaNumber=Locomotion.AntennaInformation(:,j);
%      
%      MouseArray(2:length([CSVFile{2}])+1,10,j)=num2cell(InArenaobj.InArena);  
%      
%      
%      
%     
%      %% ---------------------------- Calculate velocity -----------------------
%      clear InArenaVelocity;
%        % Save all the velocity
%        MouseArray(3:length([CSVFile{2}])+1,15,j)=Locomotion.TotalVelocity(:,j);
%        % Consider only the velocity in the arena
%        
%         InArenaVelocity=[Locomotion.TotalVelocity{:,j}];
%         InArenaVelociy=InArenaVelocity';
%         InArenaVelocity(~InArenaobj.InArena)=NaN; %everything outside the arena is NaN
%         InArenaVelocity=InArenaVelocity(1:size(Locomotion.TotalVelocity(:,j),1)); %to avoid addition of Nan more
%        
%    %% ----------------------------Determine when it is stop,running, walking according to the velocity----------------------------  
%            clear InArenaActivity;
%             InArenaActivity=InArenaobj.InArenaActivity(InArenaVelocity);
%     
%           
%             MouseArray(3:length([CSVFile{2}])+1,16,j)=num2cell(InArenaActivity(:,1)); %stop
%             MouseArray(3:length([CSVFile{2}])+1,17,j)=num2cell(InArenaActivity(:,2));%walking
%             MouseArray(3:length([CSVFile{2}])+1,18,j)=num2cell(InArenaActivity(:,3));%running
%        
%        %% ---------------------- Find is drinking and is eating ------------------------------
%      clear IsEating;
%      clear IsDrinking;
%      
%      IsEating=IsEatingDrinkingobj. IsEating(cell2mat(MouseArray(2:length([CSVFile{2}])+1,10,j)),cell2mat(MouseArray(2:length([CSVFile{2}])+1,3,j)),cell2mat(MouseArray(2:length([CSVFile{2}])+1,4,j)), InArenaVelocity);
%      IsDrinking=IsEatingDrinkingobj. IsDrinking(cell2mat(MouseArray(2:length([CSVFile{2}])+1,10,j)),cell2mat(MouseArray(2:length([CSVFile{2}])+1,3,j)),cell2mat(MouseArray(2:length([CSVFile{2}])+1,4,j)), InArenaVelocity); 
%     
%     MouseArray(2:length([CSVFile{2}])+1,11,j)=num2cell(IsEating);%eating
%     MouseArray(2:length([CSVFile{2}])+1,12,j)=num2cell(IsDrinking);%drinking  
%     
%     
%         %% -----------------------------Determine if it is inside or outside a given zone----------------------------
%   
%     IsZone=IsInZoneobj.IsZone(cell2mat(MouseArray(2:length([CSVFile{2}])+1,10,j)),cell2mat(MouseArray(2:length([CSVFile{2}])+1,3,j)),cell2mat(MouseArray(2:length([CSVFile{2}])+1,4,j)));
%   
%     MouseArray(2:length([CSVFile{2}])+1,13,j)=num2cell(IsZone(:,1));%inner zone
%     MouseArray(2:length([CSVFile{2}])+1,14,j)=num2cell(IsZone(:,2));%outside zone
%        
%    
%      %% Addition number of frame
%      MouseArray(2:length([CSVFile{2}])+1,19,j)=num2cell([0:length([CSVFile{2}])-1]');
%     
%      %% 
%     if i==1 %for the first csv file
%         I=[];
%         if cell2mat(MouseArray(2,3,j))==1e6 %only if the first is million
%         I=find(cell2mat(MouseArray(2:length([CSVFile{2}])+1,3,j))~=1e6,1,'first');
%         MouseArray(2:I-1,5:10,j)=num2cell(0);   
%         end
%         
%     end
% 
% % 
% % 
% %% 
% %%Coordinates after sleeping and hiding
% 
%    ArrayX=[ArrayX,cell2mat(MouseArray(2:length([CSVFile{2}])+1,3,j))];
%    ArrayY=[ArrayY,cell2mat(MouseArray(2:length([CSVFile{2}])+1,4,j))];
%    ArrayXY=[ArrayXY,cell2mat(MouseArray(2:length([CSVFile{2}])+1,3:4,j))]; 
% %% 
% 
% %% 
% 
% %% -------------------------for further use create 2 auxiliary arrays---------------------- 
%     
%     
%    if any(cell2mat( MouseArray(2:length([CSVFile{2}])+1,10,j))==1)
%        InArenaAuxiliary=InArenaobj.InArenaAuxiliary(cell2mat(MouseArray(2:length([CSVFile{2}])+1,3,j)),cell2mat(MouseArray(2:length([CSVFile{2}])+1,4,j)));
%        Distance(1:length([CSVFile{2}])-1,j)=InArenaAuxiliary(:,1);
%        VectorX(1:length([CSVFile{2}])-1,j)=InArenaAuxiliary(:,2); %normalized vector
%        VectorY(1:length([CSVFile{2}])-1,j)=InArenaAuxiliary(:,3); %normalized vector
%        
%        VectorX1(1:length([CSVFile{2}])-1,j)=InArenaAuxiliary(:,4); %not normalized vector
%        VectorY1(1:length([CSVFile{2}])-1,j)=InArenaAuxiliary(:,5); %not normalized vector
%     else
%            Distance(1:length([CSVFile{2}])-1,j)=0; %in the case it is inside all the time
%            VectorX(1:length([CSVFile{2}])-1,j)=0;
%            VectorY(1:length([CSVFile{2}])-1,j)=0;
%           VectorX1(1:length([CSVFile{2}])-1,j)=0;
%            VectorY1(1:length([CSVFile{2}])-1,j)=0; 
%     end
% 
%     %% 
% 
% % %% ------------------ Save to excel file---------------------------------
% % % Titles
% % 
% MouseArray(1,1,j)={'Experiment Date'};
% MouseArray(1,2,j)={'Experiment Time'};
% MouseArray(1,3,j)={'Original x coord.'};
% MouseArray(1,4,j)={'Original y coord.'};
% MouseArray(1,5,j)={'Number RFID antenna'};
% 
% MouseArray(1,6,j)={'Is Sleeping'};
% MouseArray(1,7,j)={'Sleeping Box'};
%  MouseArray(1,8,j)={'Is Hiding'};
%  MouseArray(1,9,j)={'Hiding Box'};
% MouseArray(1,10,j)={'In Arena'};
% 
% MouseArray(1,20,j)={'Beg.Int.Sleeping'};
% MouseArray(1,21,j)={'End Int.Sleeping'};
%  MouseArray(1,22,j)={'Beg.Int.Hiding'};
%  MouseArray(1,23,j)={'End.Int.Hiding'};
%  MouseArray(1,19,j)={'Number of video frame'};
% 
% MouseArray(1,15,j)={'In Arena velocity'};
% MouseArray(1,16,j)={'Is stop'};
% MouseArray(1,17,j)={'Is walking'};
% MouseArray(1,18,j)={'Is running'};
% MouseArray(1,11,j)={'Is eating'};
% MouseArray(1,12,j)={'Is drinking'};
%  MouseArray(1,13,j)={'Is in zone inside'};
%  MouseArray(1,14,j)={'Is in zone outside'};
% 
% % 
% 
%  sheet=char(miceList(j));
%  Namef=char(item_selected(i));
%  filename=strcat(Namef(1:end-4),'LocomotionResults','.xlsx');
%  filename=strrep(filename,'[','(');
%   filename=strrep(filename,']',')');
%   filename=strcat(Params.SaveDirectory,'\',filename);
%  xlswrite(filename,MouseArray(:,:,j),sheet);
% 
% 
% 
% 
%     %% 
% 
%  %Control of wait bar
%  waitbar(j/length(miceList));
% 
% end %finish loop of mouse
% %NOTE:DECIDE IF TO SAVE THE MOUSE ARRAY MATRIX
% 
% % Results.miceList=miceList;
% % Results.MouseArray=MouseArray;
% %  %save(mat according the date)
%  close(hbar)
%  
% 
% 
% %% ---------------------Save the locomotion parameters as a structure bring  all the mice together----------------------
% Locomotion.miceList=miceList;
% Large=length(MouseArray(:,10,1));
% Locomotion.isInArena=reshape(cell2mat(MouseArray(2:Large,10,:)),Large-1,length(miceList));
% Locomotion.TrajectoryX=reshape(cell2mat(MouseArray(2:Large,3,:)),Large-1,length(miceList)); %coord x
% Locomotion.TrajectoryY=reshape(cell2mat(MouseArray(2:Large,4,:)),Large-1,length(miceList));  %coord y
% 
% Locomotion.Velocity=reshape(cell2mat(MouseArray(3:Large,15,:)),Large-2,length(miceList)); %include non defined points
% 
% %Locomotion.ExperimentalTime=MouseArray(2:Large,2,1); %take only one mouse since it is the same time for everything.
% Locomotion.VectorX=VectorX; %without repeats
% Locomotion.VectorY=VectorY; %without repeats
% Locomotion.Distance=Distance;%without repeats
% Locomotion.VectorX1=VectorX1; %without repeats no normalized
% Locomotion.VectorY1=VectorY1; %no normalized
% Locomotion.isStop=reshape(cell2mat(MouseArray(3:Large,16,:)),Large-2,length(miceList));
% Locomotion.isWalking=reshape(cell2mat(MouseArray(3:Large,17,:)),Large-2,length(miceList));
% Locomotion.isRunning=reshape(cell2mat(MouseArray(3:Large,18,:)),Large-2,length(miceList));
% 
% Locomotion.IsEating=reshape(cell2mat(MouseArray(2:Large,11,:)),Large-1,length(miceList));
% Locomotion.IsDrinking=reshape(cell2mat(MouseArray(2:Large,12,:)),Large-1,length(miceList));
% %Locomotion.IsSleeping=reshape(cell2mat(MouseArray(2:Large,6,:)),Large-1,length(miceList));%already
% %is saved before
% Locomotion.IsHiding=reshape(cell2mat(MouseArray(2:Large,8,:)),Large-1,length(miceList));
% 
% Locomotion.SleepingBox=reshape(cell2mat(MouseArray(2:Large,7,:)),Large-1,length(miceList));
% Locomotion.HidingBox=reshape(cell2mat(MouseArray(2:Large,9,:)),Large-1,length(miceList));
% Locomotion.IsInsideZone=reshape(cell2mat(MouseArray(2:Large,13,:)),Large-1,length(miceList));
% Locomotion.IsOutsideZone=reshape(cell2mat(MouseArray(2:Large,14,:)),Large-1,length(miceList));
% 
% 
% %% --------------------Compute distance pairs---------------------------
%  DistancePairs=computeDistancePairsGV(Locomotion.TrajectoryX,Locomotion.TrajectoryY,Locomotion.isInArena,Locomotion.SleepingBox,Locomotion.HidingBox);
% Locomotion.DistancePairs=DistancePairs; %NO TO TRUST IN ZERO VALUES
% 
% %%
% 
% 
% %% -------------------------------Calculating chasing-----------------------------
% 
% %---------Create chasing object-------------------
% %All the units are in mm
% Chasingobj=Chasing;
% 
% 
% Chasingobj.numOfMice=length(Locomotion.miceList);
% Chasingobj.Dist_tresh1=300;
% Chasingobj.Velocity_Tresh=0.5;
% Chasingobj.PathTresh=600;
% Chasingobj.Dist_tresh2=200;
% % 
% Chasingobj.AngleMaximum1=Params.AngleMaximum1; %This is the maximum angle, which is allowed, between the line joining the mice 1-2 and the vector of movement of mouse 1.
% Chasingobj.AngleMaximum2=Params.AngleMaximum2; %This is the maximum angle, which is allowed, between the vector of movement of mouse 1 and mouse 2.
% Chasingobj.MinimumPath=Params.editpar1; %This is the minimum path recording to be considered as chasing.
% Chasingobj.GapPath=Params.editpar2; %This is the maximum distance allow to finish the chasing mm
% Chasingobj.ThreshVelocity=Params.editpar3; %20-10 cm/sec
% Chasingobj.GapFrames=Params.editpar4; %maximum number of frames to be allowed to be a gap
% Chasingobj.GapPathEnd=Params.editpar5; %the end of the frame
% 
% Chasingobj.GapFramesS=Params.editpar6; %maximum number of frames to be allowed to be a gap in small frames
% Chasingobj.GapPathEndS=Params.editpar7; % condition of the end of the frame in small frames
% 
% % Chasingobj.AngleMaximum1=20; %This is the maximum angle, which is allowed, between the line joining the mice 1-2 and the vector of movement of mouse 1.
% % Chasingobj.AngleMaximum2=20; %This is the maximum angle, which is allowed, between the vector of movement of mouse 1 and mouse 2.
% % Chasingobj.MinimumPath=200; %This is the minimum path recording to be considered as chasing.
% % Chasingobj.GapPath=400; %This is the maximum distance allow to finish the chasing mm
% % Chasingobj.ThreshVelocity=10; %20-10 cm/sec
% % Chasingobj.GapFrames=100; %maximum number of frames to be allowed to be a gap
% % Chasingobj.GapPathEnd=200; %the end of the frame
% 
% 
% 
% 
% 
% 
% %-------------------------
% 
% TrajectoryX=Locomotion.TrajectoryX;
% TrajectoryY=Locomotion.TrajectoryY;
% Velocity=Locomotion.Velocity;
% %% CALCULATION OF CHASING BY INSERTING CORRECTED COORDINATES INTO GV MODULE
% 
% % ChasingCal=Chasingobj.ChasingCal(TrajectoryX,TrajectoryY,Locomotion.Velocity(Locomotion.RepeatedFrames,:),Locomotion.isInArena(Locomotion.RepeatedFrames,:),Locomotion.VectorX,Locomotion.VectorY,Locomotion.Distance,Locomotion.ExperimentalTime(Locomotion.RepeatedFrames,:));
% 
% %% CALCULATION OF CHASING BY INSERTING CORRECTED COORDINATES INTO SILVIA MODULE
%  ChasingCalvs2=Chasingobj.ChasingCalvs2(TrajectoryX,TrajectoryY,Locomotion.VectorX1,Locomotion.VectorY1,Locomotion.isInArena,Velocity );
% 
% %% 
% 
% % Locomotion.ChasingAll=ChasingCal(:,1:Chasingobj.numOfMice);
% % Locomotion.ChasedAll=ChasingCal(:,Chasingobj.numOfMice+1:2*Chasingobj.numOfMice);
% 
% % Locomotion.MoveTogether=ChasingCal(:,2*Chasingobj.numOfMice+1:3*Chasingobj.numOfMice);
% 
% 
% Locomotion.ChasingAll=ChasingCalvs2(:,1:Chasingobj.numOfMice);
% Locomotion.BeingChasingAll=ChasingCalvs2(:,Chasingobj.numOfMice+1:Chasingobj.numOfMice+Chasingobj.numOfMice);
% % Locomotion.TimeWithoutRepeats=Locomotion.ExperimentalTime(Locomotion.RepeatedFrames,:);
% 
% 
% 
% hhh=msgbox('Chasing analysis finish')
% close(hhh)
% %%                                                  CALCULATION OF AVOIDANCE(mouse2 near mouse1 but mouse1 running away from mouse2)
% 
% % Create Avoidance object
% Avoidanceobj=Avoidance;
% Avoidanceobj.numOfMice=length(Locomotion.miceList);
% Avoidanceobj.Distance_thresh= Params.Distance_thresh_For_Avoidance;
% Avoidanceobj.Dist_thresh_Fine_Tuning=Params.Dist_thresh_Fine_Tuning_For_Avoidance; %dist for fine tuning according GV is 100mm
% Avoidanceobj.velThr=Params.Velocity_For_Avoidance;% according gv 35cm/sec
% Avoidanceobj.R=Params.Radius_Within_Avoidance;% according gv 30 cm
% 
% %% 
% AvoidanceCal=Avoidanceobj.AvoidanceCal(TrajectoryX,TrajectoryY,Velocity,Locomotion.isInArena)
% %% 
% Locomotion.avoiding=AvoidanceCal;
% 
% hhhh=msgbox('Avoidance calculation was finished')
% close(hhhh)
% 
% %% %%                                                  CALCULATION OF APPROACHING (mouse 1 approaches mouse 2 and the event finished)
% 
% % Create Approaching object
%  Approachingobj=Approaching;
%  Approachingobj.numOfMice=length(Locomotion.miceList);
%  Approachingobj.Distance_thresh= Params.Distance_thresh_For_Approaching; %According to GV this is 40cm
%  Approachingobj.distTr=Params.Distance_Thresh_For_Approaching_Fine_Tuning;%According to GV this is 10cm
%  Approachingobj.CorrelFactor=Params.CorrFactor_between_mice_For_Approaching; %According to GV this is 0.3
%  Approachingobj.velTr2=Params.Velocity_Thresh_To_beSamePlace_For_Approaching; %According to GV this is 25cm/sec
% 
% 
% %% 
% ApproachingCal=Approachingobj.ApproachingCal(TrajectoryX,TrajectoryY,Velocity,Locomotion.isInArena,Locomotion.VectorX,Locomotion.VectorY)
% % %% 
% Locomotion.ApproachingAll=ApproachingCal(:,1:Approachingobj.numOfMice);
% Locomotion.BeingApproachingAll=ApproachingCal(:,Approachingobj.numOfMice+1:Approachingobj.numOfMice+Approachingobj.numOfMice);
% 
% hhhh=msgbox('Approaching calculation was finished')
% close(hhhh)
% 
% 
% %% %------------Save as a mat file as GV---------------------------
% %% Move matlab files with segmentation +rfid to new directory
% mkdir(Params.resultsDir,'SegmentationPlusRFID');
% try %if it wasn't move the file before
% movefile(fullfile(Params.resultsDir,MatFileName),fullfile(Params.resultsDir,'SegmentationPlusRFID',MatFileName));
% catch
%     
% end
% 
% 
% %% Save mat files with names as GV
% 
% 
% DateMat=MatFileName(1:strfind(MatFileName,'-')-1);
% DateMat=strrep(DateMat,'.','_');
% 
%  Indexes1a=strfind(MatFileName,'['); %the initial time
%  Indexes1b=strfind(MatFileName,']'); %the final time
%  
%  NewMatFileName=strcat(DateMat,'_',MatFileName(Indexes1a+1:Indexes1b-1),'.mat');
%  
%    filename1=strcat(Params.resultsDir,'\',NewMatFileName);%where are the matlab results
%    save(filename1,'Locomotion');
% 
% %    delete(fullfile(Params.resultsDir,MatFileName));
%  
% 
% %% 
% 
%  
%  close(hn)
% 
%  %% 
% 
% 
% 
% 
% %% 
%   
% % 
% 
% 
% end

msgbox('Finished the running')
% 
 end
end
% 
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %% %% Auxiliary functions
% 
function XY=rescaleCoordinatesGV(XY,Corners,max_width)
XY=(XY-repmat(Corners(1,:),size(XY,1),1))...,
    ./repmat(Corners(3,:)-Corners(1,:),size(XY,1),1)*max_width; % max_wd - mm

end 
%% find  the last numbers
function result=Find4last(x,a)
x=char(x);
T=strfind(x(end-6:end),a);
if isempty(T)
result=0;
else
result=1;
end
end
%% find RFID subset with the same date as the selected csv file
function IndexFilesDates=findRFIDSubset(FileSelected,DateFiles)
FileSelected=char(FileSelected);
Lim=strfind(FileSelected,'-');
x=datenum(FileSelected(1:Lim-1),'dd.mm.yyyy');
IndexFilesDates=find(DateFiles==x);

end 

%% Find the time near to the RFID data for each frame
function result=FoundNearTime(x,RFIDDataTime)

xTime=datevec(x,'HH:MM:SS.FFF');
TimeDif=abs(etime(RFIDDataTime,repmat(xTime,size(RFIDDataTime,1),1)));

%find the nearest time of rfid to frame video
result=find(TimeDif==min(TimeDif));
result=result(1);


end
%% Arrange the coordinates in an horizontal way

function [X,Y]=ArrangeHoriz(AuxArray,L)
X=[];
Y=[];
for j=1:L
     X=[X, AuxArray(:,1,j)];
     Y=[Y, AuxArray(:,2,j)];
end


end


%% 



%% -----------------------Function for saving Chasing, approachin/avoiding into an excel file------------------

function SaveSocialData(Social_Data,behaviour,SaveDirectory,exp_name,Params)

 %chasing
  %Separate the duplicates from the data and save in another sheet
  [Social_Data,DoubleData]=RemoveDuplicates(Social_Data);
  
  %% %%   %% save into an excel file in a sheet called list of all chasing events
  raw={};
  raw(1,1)={'Experiment date'};
  raw(1,2)={'Time begin event'};
  raw(1,3)={'Time end event'};
  raw(1,4)={'Chasing mouse'};
  raw(1,5)={'Chased mouse'};
  raw(1,6)={'Corrected events'};
  raw(1,7)={'Frame begin chasing'};
  raw(1,8)={'Frame finish chasing'};
  raw(1,9)={'Number of Event'};
  
 % raw(2:size(Social_Data,1)+1,1:9)=Social_Data;
  
  %% Sort the data according to the days
  
  for i=1:length(Social_Data(:,1))
      Ax=char(strrep(Social_Data(i,1),'''','')); %remove every comma
    k=strfind(Ax,'-');
    
    formatIn = 'dd.mm.yyyy';
    DateString=Ax(1:k(1)-2);
    DateNum(i)=datenum(DateString,formatIn); %this is done if there was a change in month
    
  
end
 [~,idDateSort]=sort(DateNum); 
 Social_Data=Social_Data(idDateSort,:);
 
  raw(2:size(Social_Data,1)+1,1:8)=Social_Data; 
  %% 
  
  raw(2:size(Social_Data,1)+1,9)=num2cell([1:size(Social_Data,1)]');
  
  sheet=['Chasing'];
  xlswrite([SaveDirectory,'\',exp_name,'_','ChasingResults.xlsx'],raw,sheet)
  
    %% Save in another sheet data which appear as duplicate and it is not sure
  
  raw1={};
  raw1(1,1)={'Experiment date'};
  raw1(1,2)={'Time begin event'};
  raw1(1,3)={'Time end event'};
  raw1(1,4)={'Chasing mouse'};
  raw1(1,5)={'Chased mouse'};
  raw1(1,6)={'Corrected events'};
  raw1(1,7)={'Frame begin chasing'};
  raw1(1,8)={'Frame finish chasing'};
 
  raw1(1,9)={'Number of Event'};
   
  raw1(2:size(DoubleData,1)+1,1:8)=DoubleData;
  
  raw1(2:size(DoubleData,1)+1,9)=num2cell([1:size(DoubleData,1)]');
  
  sheet1=['ChasingNoDefinedData'];
  xlswrite([SaveDirectory,'\',exp_name,'_','ChasingResults.xlsx'],raw1,sheet1)
  
%     %% Save in another sheet all the parameters
%   raw2={};
 raw2(1,1)={'Angle of 1-2 with movement 1 (degree)'};
 raw2(2,1)={'Angle of movement 1 with movement 2 (degree)'};
 raw2(3,1)={'Minimum path done by the mouse to be considered chasing (mm)'};
 raw2(4,1)={'Maximum distance between mice allow in a chasing event (mm)'};
  raw2(5,1)={'Minimum velocity to be considered in a chasing event (cm/sec)'};
  raw2(6,1)={'Maximum number of frames  between events allow to join between them'};
   raw2(7,1)={'Maximum mice distance between events allow to join events(mm)'};
%   raw2(8,1)={'Maximum number of frames  between SMALL events allow to join between them'};
%   raw2(9,1)={'Maximum mice distance between SMALL events allow to join events (mm)'};
%   
  raw2(1,2)=num2cell(Params.AngleMaximum1);
  raw2(2,2)=num2cell(Params.AngleMaximum2);
  raw2(3,2)=num2cell(Params.editpar1);
  raw2(4,2)=num2cell(Params.editpar2);
  raw2(5,2)=num2cell(Params.editpar3);
  raw2(6,2)=num2cell(Params.editpar4);
  raw2(7,2)=num2cell(Params.editpar5);
%   raw2(8,2)=num2cell(SocialObj.GapFramesS);
%   raw2(9,2)=num2cell(SocialObj.GapPathEndS);
%   
%   
 sheet2=['ChasingParameters'];
  xlswrite([SaveDirectory,'\',exp_name,'_','ChasingResults.xlsx'],raw2,sheet2)
  

end





%% -----------For removing duplicates from excel file------------------
function [Social_Data,DoubleData]=RemoveDuplicates(Social_Data)
   Iaux=[];   

   BegFrameEndFrame=cell2mat(Social_Data(:,7:8));
   A=[1:length(BegFrameEndFrame(:,1))]'; 
   [C,ia,ic]=unique(BegFrameEndFrame,'rows','stable');%eliminate the duplicates
   IndWithDuplicates=setdiff(A,ia,'rows');
   Duplicates=BegFrameEndFrame(IndWithDuplicates,:);
   Lia=ismember(BegFrameEndFrame,Duplicates,'rows');%find this duplicates in original data
   AuxData=Social_Data(find(Lia(:,1)==1),:);%this is data of duplicates
  % Iaux=find(Lia(:,1)==1);
  
  
   
   %% Select which are actually double data or there are an inconsistent between chasing and non chasing
[EventsBeg EventsEnd]=getEventsIndexesGV(Lia,size(Lia,1))
   for ic=1:length(EventsBeg)
      M1=unique(Social_Data(EventsBeg(ic):EventsEnd(ic),4));
      M2=unique(Social_Data(EventsBeg(ic):EventsEnd(ic),5));
      Mtotal=unique([Social_Data(EventsBeg(ic):EventsEnd(ic),4);Social_Data(EventsBeg(ic):EventsEnd(ic),5)]) ;
      
      if length(Mtotal)<=2 %remove cases in which the mice are the same in the same frames.
          
          Iaux=[Iaux;[EventsBeg(ic):EventsEnd(ic)]'];
      end
       
   end
   
   DoubleData=Social_Data(Iaux,:); 
   
   %% 
   if ~isempty(EventsBeg)& ~isempty(Iaux)
      Iaux1=setdiff(A,Iaux,'rows');
      Social_Data=Social_Data(Iaux1,:);
   end


end


%% 


