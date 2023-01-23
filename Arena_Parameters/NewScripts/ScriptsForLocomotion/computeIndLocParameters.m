function computeIndLocParameters(~,~)
%This function computes the locomation parameters for a given mouse
%   Detailed explanation goes here
%% First load parameters
global h
global Params
clc
%% clear variables 
clear TrajXNew;
 clear TrajYNew;
clear TrajXNew1;
 clear TrajYNew1;
clear DataMouse;
clear DataMouseWithoutD;
clear num1;
clear num_modified;
clear DataAllMouse;
clear DataAllMouseWithFrame;
 
%% 

cr_fname=get(h.editLoc1,'string');
Iaux=strfind(cr_fname,'\');
Ifinal=strfind(cr_fname,'.csv');
filesNames=cr_fname(Iaux(length(Iaux))+1:Ifinal-1);
directory=get(h.editLoc2,'string');

% filesNames='18.5.2016 - 17.00.00.032(Camera-2)[17.30.00.042-18.00.00.042].csv';
Params.NoDetection=1e6;
Params.FPS=30;
Params.Frames=10; %number of frames to select the peaks
Params.ArtifactVelocity=100; % this is an artifact velocity of cm/sec. Sometimes the marker cannot follow the mouse and the velocity is very big.
Params.ThesholdEating=20; %velocity to consider that the mouse is eating
Params.ArtifactVelocityMarker=200;
Params.ThresholdSlope=90; %THE SLOPE IS THE ANGLE
Params.FramesVel=12;
Params.ThresholdRepeatedFrames=15;%discard interpolation if the quantity of frames in which the antennas of the mice overlapped is bigger than a given threshold 
radiusD=40;%radius for drinking
%Read the mouse from the popup
index_selected = get(h.popmenuLoc1,'Value');
list = get(h.popmenuLoc1,'String');
MouseSelected = list(index_selected,1);
Params.Velocity=100;
OutputFile=strcat(directory,'\',MouseSelected,'_',filesNames,'.xlsx');
%parameters
max_width=1140; %in mm
CoordSleepingCellsPx=[222	31;...,
495	29;...,
594	151;...,
594	418;...,
480	532;...,
234	540;...,
126	418;...,
127	141];%Left

HidingCoordinatesCentralPx=[218 471;495 469;493 114; 230 121];% central point of the hiding boxes

HidingCoordinates1Px=[211 438; 254 466;208 534 ;168 508];   %hiding coordinates for each box 
HidingCoordinates2Px=[459 469; 506 437;548 500;499 535];
HidingCoordinates3Px=[502 50; 551 84;499 146;461 114];
HidingCoordinates4Px=[172 78; 222 52;250 124;203 149];

Corners=[118 30;...
604 27;...
602 561;...
117 555];

FoodCoordinatesPx=[319.3338192 242.7390671;...
317.654519 211.6720117;...
394.0626822 215.8702624;...
394.0626822 246.0976676];

WaterCoordinatesPx=[352.9198251 305.712828];
%WaterCoordinatesPx=[353 308];

%conversion from pixel to mm
CoordSleepingCells=rescaleCoordinatesGV(CoordSleepingCellsPx,Corners,max_width);
CoordHidingCells=rescaleCoordinatesGV(HidingCoordinatesCentralPx,Corners,max_width);
HidingCoordinates1=rescaleCoordinatesGV(HidingCoordinates1Px,Corners,max_width);
HidingCoordinates2=rescaleCoordinatesGV(HidingCoordinates2Px,Corners,max_width);
HidingCoordinates3=rescaleCoordinatesGV(HidingCoordinates3Px,Corners,max_width);
HidingCoordinates4=rescaleCoordinatesGV(HidingCoordinates4Px,Corners,max_width);

WaterCoordinates=rescaleCoordinatesGV(WaterCoordinatesPx,Corners,max_width);
FoodCoordinates=rescaleCoordinatesGV(FoodCoordinatesPx,Corners,max_width);

%% Remove duplicates
[DataMouse DataMouseWithoutD DataAllMouse DataAllMouseWithFrame]=TakeRepeatsOriginalData(cr_fname,MouseSelected);
num1=DataMouse;
num_modified=num1;
%% Nothing is done  if there are not mouse data

if length(find(isnan(DataMouse(:,2))==1))==length(DataMouse(:,2))
msgbox('No mouse detected')
else
%% Work without repetitions to find sleeping/hiding intervals and velocities.
%% Read the intervals for is arena and is sleeping as calculated without duplicates

 [ArenaBegOriginal ArenaEndOriginal SleepingIntervalBeg SleepingIntervalEnd Velocity NumbFrames AngleOneMouse AngleSign VelocityMarker Slope theta]=detectSleeping_hiding_arena(DataMouseWithoutD);
 %% 
 %Group events
 InArena=zeros(length(num1(:,2)),1);
 for i=1:length(ArenaBegOriginal)
    InArena(ArenaBegOriginal(i,1):ArenaEndOriginal(i,1),1)=1;
 end 
 j=1;
 IsSleepingFinal=zeros(length(num1(:,2)),1);
 SleepingInterval=[SleepingIntervalBeg SleepingIntervalEnd];
 IsHiding=zeros(length(num1(:,2)),1);

 %% Add the velocity data in the relevant frames

RawVelocity(NumbFrames(1:length(Velocity)))=Velocity;

% Add the angle velocity data to the relevant frames

RawAngleOneMouse(NumbFrames(1:length(AngleOneMouse)))=AngleOneMouse;

% Add the angle sign data to the relevant frames

RawAngleSignOneMouse(NumbFrames(1:length(AngleSign)))=AngleSign;

 %Add the velocity marker data in the relevant frames

RawVelocityMarker(NumbFrames(1:length(VelocityMarker)))=VelocityMarker;

 %Add the slope data in the relevant frames

RawSlope(NumbFrames(1:length(Slope)))=Slope;

 %Add the angle data in the relevant frames

RawTheta(NumbFrames(1:length(theta)))=theta;

 %% 
SleepingCage=[]; 
HidingCage=[];
for i=1:length(SleepingIntervalBeg(:,1))
IsSleepingHiding(SleepingIntervalBeg(i,1)-1:SleepingIntervalEnd(i,1),1)=1;
%% FIND LOCATION IF IS SLEEPING OR HIDING
%% Sometimes there is a change of antenna in some interval 
 cordsBeforeEnterInside=[num1(SleepingInterval(i,1)+3,2),num1(SleepingInterval(i,1)+3,3)];
 cordsAfterExitInside=[num1(SleepingInterval(i,2)-3,2),num1(SleepingInterval(i,2)-3,3)];  
 
% d=((cordsAfterExit(:,1)-cordsBeforeEnter(:,1))^2+(cordsAfterExit(:,2)-cordsBeforeEnter(:,2))^2)^0.5;
%  AuxI1=find(RawVelocity(SleepingIntervalBeg:SleepingIntervalEnd,1)> Params.Velocity);
%  
%   if  cordsBeforeEnterInside > 2e4 & cordsAfterExitInside >2e4 & d > 20 %bigger than 2cm
%    
%       
%     
% end
 cordsBeforeEnterOutside=[num1(SleepingInterval(i,1)-3,2),num1(SleepingInterval(i,1)-3,3)];
 if (SleepingInterval(i,2)+3)<length(num1)
 cordsAfterExitOutside=[num1(SleepingInterval(i,2)+3,2),num1(SleepingInterval(i,2)+3,3)];
 else
    cordsAfterExitOutside= [num1(SleepingInterval(i,2),2),num1(SleepingInterval(i,2),3)];
 end
%%        
% Take coordinates before and after enter into
  
     if cordsBeforeEnterInside >=2e4
        cords=cordsBeforeEnterInside-2e4;%measure inside the cage
     else
         cords=cordsBeforeEnterInside;
     end
         
    if isnan(cords)==1
            if isnan(cordsBeforeEnterOutside)==0 & isnan(cordsAfterExitOutside)==1
                cords=cordsBeforeEnterOutside;
            elseif isnan(cordsBeforeEnterOutside)==0 & isnan(cordsAfterExitOutside)==0
            cords=(cordsBeforeEnterOutside+cordsAfterExitOutside)/2;
            elseif  isnan(cordsBeforeEnterOutside)==1 & isnan(cordsAfterExitOutside)==0
                cords=cordsAfterExitOutside;
            end
        end

  %%

 
    %calculate dist either from sleeping and hiding togehter.
    
    DistSleepS=dist_calc(CoordSleepingCells,repmat(cords,length(CoordSleepingCells),1));
    DistSleepH=dist_calc(CoordHidingCells,repmat(cords,length(CoordHidingCells),1));
    DistSleep=[DistSleepS; DistSleepH]
    
    %find the minimum distance
     ResultDist(i)=min(DistSleep);
     
    %distinguish if is hiding or sleeping box-find the index
     if find(DistSleep==min(DistSleep),1,'first')<=8 %r
       SleepingCage(i)=find(DistSleep==min(DistSleep));
       IsSleepingFinal(SleepingIntervalBeg(i,1):SleepingIntervalEnd(i,1),1)=1;
        %New coordinates replace coordinates for sleeping where is sleeping
    num_modified(SleepingInterval(i,1):SleepingInterval(i,2),2)=CoordSleepingCells( SleepingCage(i),1);
    num_modified(SleepingInterval(i,1):SleepingInterval(i,2),3)=CoordSleepingCells( SleepingCage(i),2);
     else
     if ~isempty( find(DistSleep==min(DistSleep),1,'first'))
     HidingInterval(j,:)=[SleepingInterval(i,1) SleepingInterval(i,2)];  
     HidingCage(j)=find(DistSleep==min(DistSleep),1,'first')-8;
     
     IsHiding(SleepingIntervalBeg(i,1)-1:SleepingIntervalEnd(i,1),1)=1;
       %New coordinates replace coordinates for sleeping where is sleeping
    num_modified(SleepingInterval(i,1):SleepingInterval(i,2),2)=CoordHidingCells(HidingCage(j),1);
    num_modified(SleepingInterval(i,1):SleepingInterval(i,2),3)=CoordHidingCells(HidingCage(j),2);
     end
     j=j+1;
     
    end
    


   
    %coord
    corden(i,:)=[num1(SleepingInterval(i,1),2),num1(SleepingInterval(i,1),3)]-2e4;
end
%END

 %% %First correction: Correct the events if it is sleeping and also in the arena isarena==0 -since 20000 dissapear inside the arena was found this.


 InArena(find(InArena==1 & IsSleepingFinal==1))=0;
 
 %Second correction if it is hiding and in the arena it is zero in the
 %arena
 
%InArena(find(InArena==1 & IsHiding==1))=0;
%if it is hiding and in the arena I will considered that hiding is
%zero-Since sometimes it looks like is hiding but it is in the arena
InH=find(InArena==1 & IsHiding==1);
IsHiding(find(InArena==1 & IsHiding==1))=0;
%return the coordinates to the arena
num_modified(InH,2)=num1(InH,2);
num_modified(InH,3)=num1(InH,3);
%% Is feeding and Isdrinking
%DEFINE isEATING/ISDRINKING VECTOR
 IsEatingDrinking=zeros(length(num1(:,2)),1);
%find the coordinates in the arena

XInArena=num1(find(InArena(:,1)==1),2);
YInArena=num1(find(InArena(:,1)==1),3);
IndexArena=find(InArena(:,1)==1);
%check if it is in the food
xmin=min(FoodCoordinates(:,1));
xmax=max(FoodCoordinates(:,1));

ymin=min(FoodCoordinates(:,2));
ymax=max(FoodCoordinates(:,2));

xf=[xmin,xmin,xmax,xmax,xmin];
yf=[ymax+30,ymin-30,ymin-30,ymax+30,ymax+30];

[inF,onF] = inpolygon(XInArena,YInArena,xf,yf);


IsEatingDrinking(IndexArena(find(inF==1)))=1;
IsEatingDrinking(IndexArena(find(onF==1)))=1;

%add that the drinking- create a circle around the drinking point- ADD
%VELOCITY

Center=WaterCoordinates;

Idrinking=find(((XInArena - Center(1)).^2 + (YInArena - Center(2)).^2 )<= radiusD^2);
save('testd1.mat','Idrinking')
IsEatingDrinking(IndexArena((Idrinking)))=1;
%% 
%% Processing of the velocity
%create vector of time
VelocityInt=Velocity; %velocity for interpolation
Time=DataMouse(:,1);
TimeWithoutRepeats=Time(NumbFrames(1:length(VelocityInt))); %without repeats

%find within the arena velocity points >=100cm/sec which are artifacts
I=InArena(NumbFrames(1:length(VelocityInt)),1)==1 & VelocityInt(:,1)>=Params.ArtifactVelocity;
VelocityInt(find(I==1))=NaN; % remove the high velocity values
IndexV=find(I==1);
%figure
%plot(TimeWithoutRepeats,VelocityInt)
Velocityq=interp1(TimeWithoutRepeats,VelocityInt,TimeWithoutRepeats(IndexV),'pchip');
VelocityInt(IndexV)=Velocityq;
%interpolate velocity for the subset of times with IndexV

InterpVelocity(NumbFrames(1:length(VelocityInt)))=VelocityInt;

%
%% Create Iseating isdrinking under velocity threshold
%First work without frames
IsEatingDrinkingV=IsEatingDrinking(NumbFrames(1:length(VelocityInt)));
IsEatingDrinkingV(IsEatingDrinkingV(:,1)==1 & VelocityInt(:,1)<=Params.ThesholdEating,1)=1;
IsEatingDrinkingV(IsEatingDrinkingV(:,1)==1 & VelocityInt(:,1)>Params.ThesholdEating,1)=0;

%find the intervals where is eating/drinking
 [EventsBeg EventsEnd]=getEventsIndexesGV(IsEatingDrinkingV,length(IsEatingDrinkingV));

%creat new eatingdrinking vector
 IsEatingDrinkingVel=zeros(length(num1(:,2)),1);
 
 for i=1:length(EventsBeg)
 %return to frames
 IsEatingDrinkingVel(NumbFrames(EventsBeg(i)):NumbFrames(EventsEnd(i)),1)=1;
 end
%%
%ARRANGE ARTIFACT WHEN THE TRAJECTORY IS OUT FROM THE NORMAL TRAJECTORY OF
%THE MOUSE
%Find the points where the marker jump- Velocity Marker is the velocity of
%the last jump- Also correct points where the marker dissapear inside the
%arena
%%  create vector of x and y without repetitions
numForInterpolation=num_modified(NumbFrames(:,1),2:3); %without repeats

%% 
%for resseting
 InArena(find(InArena==1 & IsSleepingFinal==1))=0;

InArenaWithoutFrames=InArena(NumbFrames(:,1),1);
IsHidingWithoutFrames=IsHiding(NumbFrames(:,1),1);
IsSleepingWithoutFrames=IsSleepingFinal(NumbFrames(:,1),1);
%look for events
[Evb Eve]=getEventsIndexesGV(InArenaWithoutFrames,length(InArenaWithoutFrames));
%go through each arena interval and find the maximum velocity
 AllRepeatedCoord=[];
for i=1:length(Evb)
    %% For each event find if the data is repeated in the rest of mouse-RESOLVE PROBLEM THAT DIFFERENT MOUSE IN THE EXACT SAME LOCATION
   clear IndexRepeatedCoord
   clear RealIndexRepeatedCoord
 
  
    IndexRepeatedCoord=(FindRepeatData(numForInterpolation(Evb(i):Eve(i),1),numForInterpolation(Evb(i):Eve(i),2),DataAllMouse(Evb(i):Eve(i),:)))';
    RealIndexRepeatedCoord=find(IndexRepeatedCoord==1)+Evb(i)-1;
    %do vector of repeated Coord
    if ~isempty( RealIndexRepeatedCoord)
    if i==1
       AllRepeatedCoord=RealIndexRepeatedCoord;
       
    else
      if isempty( AllRepeatedCoord)
            AllRepeatedCoord=RealIndexRepeatedCoord;
       else
        AllRepeatedCoord=[AllRepeatedCoord;RealIndexRepeatedCoord];  
        
       end
    end
    end
%     if ~isempty(Index)
%         i
%     RealIndex=find(Index==1)+Evb(i)-1;
%     A=NumbFrames(RealIndex)
   % save('test.mat','AllRepeatedCoord')
%    end 
    %% 
    
   I=VelocityMarker(Evb(i):Eve(i),1)>=Params.ArtifactVelocityMarker; %find the points where the velocity is higher

   
   Ivel=Evb(i)+find(I)-1 %find the indexes inside the interval
   if ~isempty(Ivel)
       j=1;
       p=1;
      while j<length(Ivel)
         if Ivel(j+1)-Ivel(j)< Params.FramesVel; 
             
          Interval=[Ivel(j):Ivel(j+1)-1];
          
         
             numForInterpolation(Ivel(j):Ivel(j+1)-1,1)=NaN; %it is x
             numForInterpolation(Ivel(j):Ivel(j+1)-1,2)=NaN; %it is y
             
%                 numForInterpolation(Interval,1)=interp1(TimeWithoutRepeats, numForInterpolation(:,1),TimeWithoutRepeats(Interval),'pchip'); 
%              numForInterpolation(Interval,2)=interp1(TimeWithoutRepeats, numForInterpolation(:,2),TimeWithoutRepeats(Interval),'pchip'); 
             j=j+2;
         else
             Interval=Ivel(j);
             numForInterpolation(Ivel(j),1)=NaN; %it is x
             numForInterpolation(Ivel(j),2)=NaN; %it is y
        
%                numForInterpolation(Interval,1)=interp1(TimeWithoutRepeats, numForInterpolation(:,1),TimeWithoutRepeats(Interval),'pchip'); 
%                numForInterpolation(Interval,2)=interp1(TimeWithoutRepeats, numForInterpolation(:,2),TimeWithoutRepeats(Interval),'pchip'); 
                j=j+1;
      end
   end
   
   end  
   
   %% ALSO NaN DATA THAT IT IS REPEATED IN ANOTHER MOUSE
   if ~isempty(RealIndexRepeatedCoord)
             numForInterpolation(RealIndexRepeatedCoord,1)=NaN; %it is x
             numForInterpolation(RealIndexRepeatedCoord,2)=NaN; %it is y
   end
   %% find the interval to do interpolation
   if i==1
   Inan=(find(isnan( numForInterpolation(Evb(i):Eve(i),1)))+Evb(i)-1)';
   else
      Inan= [Inan (find(isnan( numForInterpolation(Evb(i):Eve(i),1)))+Evb(i)-1)'];
   end
   
end

%% Do interpolation to all nan inside the arena
 
if ~isempty(Inan)
   %do interpolation
       numForInterpolation(Inan,1)=interp1(TimeWithoutRepeats, numForInterpolation(:,1),TimeWithoutRepeats(Inan),'pchip'); 
       numForInterpolation(Inan,2)=interp1(TimeWithoutRepeats, numForInterpolation(:,2),TimeWithoutRepeats(Inan),'pchip'); 
end
%% GET THROUGH ALL aRENA EVENTS AND CHECK THAT BETWEEN ARENA EVENTS , NOT SLEEPING AND HIDING THEN COMPLETE WITH  INTERPOLATION IF THE NUMBER OF FRAMES LESS THAN 15
clear I %in the case it is used before

for i=1:length(Evb)-1
    
   %I= InArenaWithoutFrames(Eve(i)+1:Evb(i+1)-1)~=1 & IsHidingWithoutFrames(Eve(i)+1:Evb(i+1)-1)~=1 & IsSleepingWithoutFrames(Eve(i)+1:Evb(i+1)-1)~=1;
   
   I= InArenaWithoutFrames(Eve(i)+1:Evb(i+1)-1)==1 | IsHidingWithoutFrames(Eve(i)+1:Evb(i+1)-1)==1 | IsSleepingWithoutFrames(Eve(i)+1:Evb(i+1)-1)==1;
   
  if isempty(find(I==1)) %all must be zero to be used
      
      
   numForInterpolation(Eve(i)+1:Evb(i+1)-1,1)=NaN; %it is x
   numForInterpolation(Eve(i)+1:Evb(i+1)-1,2)=NaN; %it is y
   
   %for interpolation
    numForInterpolation(Eve(i)+1:Evb(i+1)-1,1)=interp1(TimeWithoutRepeats, numForInterpolation(:,1),TimeWithoutRepeats(Eve(i)+1:Evb(i+1)-1),'pchip'); 
    numForInterpolation(Eve(i)+1:Evb(i+1)-1,2)=interp1(TimeWithoutRepeats, numForInterpolation(:,2),TimeWithoutRepeats(Eve(i)+1:Evb(i+1)-1),'pchip'); 
    %CORRECTION THAT IT IS IN THE ARENA- CORRECT THAT WITH FRAMES
    InArena(NumbFrames(Eve(i),1)+1:NumbFrames(Evb(i+1),1)-1)=1;
    
  end
end
   
%% 


 
%% 
%return to the repeats
RawXinterp(NumbFrames(1:length(numForInterpolation(:,1))))=numForInterpolation(:,1);
RawYinterp(NumbFrames(1:length(numForInterpolation(:,2))))=numForInterpolation(:,2);
%% 


%% Interpolate between repeats.


%% 
%repeats the values
%find the index to begin- Remember the first one is nan

[newX,newY]=FillWithRepeats(NumbFrames,numForInterpolation(:,1),numForInterpolation(:,2));



%% 

%%%% %First correction: Correct the events if it is sleeping and also in the arena isarena==0 -since 20000 dissapear inside the arena was found this.


 InArena(find(InArena==1 & IsSleepingFinal==1))=0; 
 IsHiding(find(InArena==1 & IsHiding==1))=0; 
 %% Calculate velocity from interpolation coordinates
 VelocityFromInterpCoord=VelocityCalculation(numForInterpolation(:,1),numForInterpolation(:,2),NumbFrames); %the input information is without frames
 
  %% Add the velocity data in the relevant frames

RawVelocityFromInterpCoord(NumbFrames(1:length(VelocityFromInterpCoord)))=VelocityFromInterpCoord;
%% 
%% Find intervals of hiding- sleeping -in arena
[InArenaIntervalb InArenaIntervale]=getEventsIndexesGV(InArena,length(InArena));
[IsSleepingIntervalb IsSleepingIntervale]=getEventsIndexesGV(IsSleepingFinal,length(IsSleepingFinal));
[IsHidingIntervalb IsHidingIntervale]=getEventsIndexesGV(IsHiding,length(IsHiding));
[IsEatingDrinkingVelIntervalb IsEatingDrinkingVelIntervale]=getEventsIndexesGV(IsEatingDrinkingVel,length(IsEatingDrinkingVel));

 %% Interpolation between repeated frames of trajectory
%for each in arena interval
  TrajXNew=newX;
  TrajYNew=newY;
  clear I;
 
for i=1:length(InArenaIntervalb)
  range=[InArenaIntervalb(i):InArenaIntervale(i)];

  I=find(RawXinterp(range)==0);%where is null
  if i~=length(InArenaIntervalb) %if it is on the edge 
  if length(range)>length(InArenaIntervalb(i)+I-1) %There are cases that all the coordinates are zero- Actually are the same through alll the range and cannot do interpolation. %use the newX new Y coordinates in those intervals
  try 
 TrajXNew(InArenaIntervalb(i)+I-1)=NaN;
  InArenaIntervalb(i)+I-1
  TrajYNew(InArenaIntervalb(i)+I-1)=NaN;  
   %for interpolation
  
   TrajXNew(InArenaIntervalb(i)+I-1)=interp1(Time(range,1), TrajXNew(range),Time(InArenaIntervalb(i)+I-1),'pchip'); 
   TrajYNew(InArenaIntervalb(i)+I-1)=interp1(Time(range,1), TrajYNew(range),Time(InArenaIntervalb(i)+I-1),'pchip'); 
   catch
        msgbox('Interpolation not considered');
   end
  end
  elseif length(newX(:,1))-InArenaIntervale(length(InArenaIntervalb))>5 % in the edge do aproximation if the number of frame at the end is bigger than 5 do aproximation
     
  if length(range)>length(InArenaIntervalb(i)+I-1)  %There are cases that all the coordinates are zero- Actually are the same through alll the range and cannot do interpolation. %use the newX new Y coordinates in those intervals
  try %if there are errors continue
  TrajXNew(InArenaIntervalb(i)+I-1)=NaN;
  InArenaIntervalb(i)+I-1
  TrajYNew(InArenaIntervalb(i)+I-1)=NaN;  
  
 
   %for interpolation
   TrajXNew(InArenaIntervalb(i)+I-1)=interp1(Time(range,1), TrajXNew(range),Time(InArenaIntervalb(i)+I-1),'pchip'); 
   TrajYNew(InArenaIntervalb(i)+I-1)=interp1(Time(range,1), TrajYNew(range),Time(InArenaIntervalb(i)+I-1),'pchip'); 
  catch
      msgbox('Interpolation not considered');
      TrajXNew(InArenaIntervalb(i)+I-1)=newX((InArenaIntervalb(i)+I-1));
      TrajYNew(InArenaIntervalb(i)+I-1)=newY((InArenaIntervalb(i)+I-1));
  end
  end  
      
  end

end
  
  %% Remove coordinates repeated among the mouse-THE IDEA IS TO REMOVE COORDINATES IN THE PLACES WHERE THE INTERPOLATION DIDNT WORK
   clear range
   TrajXNew1=TrajXNew;
   TrajYNew1=TrajYNew;
   NoCoordinatesConsidered=zeros(length(InArena),1);
   for j=1:length(AllRepeatedCoord)-1
 
  TrajXNew1(NumbFrames(AllRepeatedCoord(j)):NumbFrames(AllRepeatedCoord(j)+1)-1)=NaN;
  TrajYNew1(NumbFrames(AllRepeatedCoord(j)):NumbFrames(AllRepeatedCoord(j)+1)-1)=NaN;
 NoCoordinatesConsidered(NumbFrames(AllRepeatedCoord(j)):NumbFrames(AllRepeatedCoord(j)+1)-1,1)=1; %no information
   
   end
 %% Return values in which the antennas overlaped only several frames-only the cases that are between arena events!!!!!!!!!!!!!!!
 [EventsBeg5 EventsEnd5]=getEventsIndexesGV(NoCoordinatesConsidered,length(NoCoordinatesConsidered))
 for i=1:length(EventsBeg5) %go over each event with isarena =5 and return the coordinate if the number of frames is less than 15
     if (EventsEnd5(i)-EventsBeg5(i))<Params.ThresholdRepeatedFrames%return coordinates
     TrajXNew1(EventsBeg5(i):EventsEnd5(i))=TrajXNew(EventsBeg5(i):EventsEnd5(i));
     TrajYNew1(EventsBeg5(i):EventsEnd5(i))=TrajYNew(EventsBeg5(i):EventsEnd5(i));
    
     end
    %RETURN THE COORDINATES TO SLEEPING DRINKING
    Id=find(IsEatingDrinkingVel(EventsBeg5(i):EventsEnd5(i))==1);
 if ~isempty(Id)
      TrajXNew1(EventsBeg5(i)+Id-1)=TrajXNew(EventsBeg5(i)+Id-1);
     TrajYNew1(EventsBeg5(i)+Id-1)=TrajYNew(EventsBeg5(i)+Id-1);
 end
 %% 
 end
 %% %% 
%Calculate velocity with new interpolated coordinates
 Velocity = VelocityCalculationArenaAllFrames( TrajXNew1,TrajYNew1,InArenaIntervalb,InArenaIntervale);
 
 %% Calculation of is drinking eating again since the marking is wrong after the repeats and new interpolation
 
 %DEFINE isEATING/ISDRINKING VECTOR
 IsEatingDrinkingFinal=zeros(length(TrajXNew1(:,1)),1);
%find the coordinates in the arena
%% Clear variables
clear XInArena
clear YInArena
clear IndexArena
clear Idrinking
%% 

XInArena=TrajXNew1(find(InArena(1:length(TrajXNew1))==1));
YInArena=TrajYNew1(find(InArena(1:length(TrajXNew1))));
IndexArena=find(InArena(:,1)==1);
%check if it is in the food
xmin=min(FoodCoordinates(:,1));
xmax=max(FoodCoordinates(:,1));

ymin=min(FoodCoordinates(:,2));
ymax=max(FoodCoordinates(:,2));

xf=[xmin,xmin,xmax,xmax,xmin];
yf=[ymax+30,ymin-30,ymin-30,ymax+30,ymax+30];

[inF,onF] = inpolygon(XInArena,YInArena,xf,yf);


IsEatingDrinkingFinal(IndexArena(find(inF==1)))=1;
IsEatingDrinkingFinal(IndexArena(find(onF==1)))=1;

%add that the drinking- create a circle around the drinking point- ADD
%VELOCITY

Center=WaterCoordinates;

Idrinking=find(((XInArena - Center(1)).^2 + (YInArena - Center(2)).^2 )<= radiusD^2);
IsEatingDrinkingFinal(IndexArena((Idrinking)))=1;

%%%%%%%%%%%%%%%%%
%% Create Iseating isdrinking under velocity threshold
%First work without frames

IsEatingDrinkingFinal(IsEatingDrinkingFinal(:,1)==1 & Velocity(:,1)<=Params.ThesholdEating,1)=1;
IsEatingDrinkingFinal(IsEatingDrinkingFinal(:,1)==1 & Velocity(:,1)>Params.ThesholdEating,1)=0;

%find the intervals where is eating/drinking
 [EventsBegEDF EventsEndEDF]=getEventsIndexesGV(IsEatingDrinkingFinal,length(IsEatingDrinkingFinal));



 %% 

% I=InArena(NumbFrames(1:length(VelocityMarker)),1)==1 & VelocityMarker(:,1)>=Params.ArtifactVelocityMarker;  %without repeats
% Ioriginal=NumbFrames(I);
% In=find(I==1);
% %find the slope of the frames with velocity marker>200
% Islope=InArena(NumbFrames(1:length(VelocityMarker)),1)==1 & VelocityMarker(:,1)>=Params.ArtifactVelocityMarker & abs(Slope(:,1))>Params.ThresholdSlope; %upper threshold
% %Islope=InArena(NumbFrames(1:length(VelocityMarker)),1)==1 & VelocityMarker(:,1)>=Params.ArtifactVelocityMarker;
% IslopeIndex=find(Islope==1);
% IslopeOriginal=NumbFrames(Islope);
% 
% 
% %go over each value and found the interval to interpolate the x modified
% %and y modified.
% i=1;
% j=1;
% while i<length(In)
%  
%     DifferenceSlope=abs(Slope(In(i),1)-Slope(In(i+1),1));
%     if  DifferenceSlope>Params.ThresholdSlope & In(i)-In(i+1)<15 %15 frames
%      %to interpolate use without repeats and find 
%      numForInterpolation(In(i):In(i+1),1)=NaN; %it is x
%      numForInterpolation(In(i):In(i+1),2)=NaN; %it is y
%      IndexInterpol=[In(i):In(i+1)];
%      numForInterpolation(IndexInterpol,1)=interp1(TimeWithoutRepeats, numForInterpolation(:,1),TimeWithoutRepeats(IndexInterpol),'pchip'); 
%      numForInterpolation(IndexInterpol,2)=interp1(TimeWithoutRepeats, numForInterpolation(:,2),TimeWithoutRepeats(IndexInterpol),'pchip'); 
%      
%      i=i+2;
%         
%     else
%     i=i+1;
%     end
% %    A= IslopeIndex(i);
% %    IslopeAux=find(VelocityMarker(IslopeIndex(i):IslopeIndex(i+1)-1)>=Params.ArtifactVelocityMarker,1,'first');  %find the next point until the next if velocity is higher
% %    if ~isempty(IslopeAux)
% %        Iinitial=IslopeIndex(i);
% %        Ifinal=IslopeIndex(i)+IslopeAux-1;
% %  %to interpolate use without repeats and find 
% %      numForInterpolation(Iinitial:Ifinal,1)=NaN; %it is x
% %      numForInterpolation(Iinitial:Ifinal,2)=NaN; %it is y
% %      IndexInterpol(i)=[Iinitial:Ifinal];
% %        
% %    end    
% end
% %Interpolate x and y alone.
% 
% 
% %% 




 %% Save data
  raw(1,1)={'time'};
  raw(1,2)={'Xoriginal'};
  raw(1,3)={'Yoriginal'};
timeLine_time=datestr(DataMouse(:,1),'HH:MM:SS.FFF'); %include milliseconds

raw(2:length(cellstr(timeLine_time))+1,1)=(cellstr(timeLine_time));
raw(2:length(DataMouse(:,2))+1,2)=num2cell(DataMouse(:,2));
raw(2:length(DataMouse(:,3))+1,3)=num2cell(DataMouse(:,3));

%save modified coordinates
raw(1,4)={'XwithSleeping'}; %added the coordinates of the entrance to the sleeping box
raw(2:length(InArena)+1,4)=num2cell(num_modified(:,2));
raw(1,5)={'YwithSleeping'}; %added the coordinates of the entrance to the sleeping box
raw(2:length(InArena)+1,5)=num2cell(num_modified(:,3));
raw(1,6)={'XmodifiedOld'}; %to withSleeping coordinates do interpolation in problematic places-modified name appears in the validation program
raw(2:length(newX)+1,6)=num2cell(newX); 
raw(1,7)={'YmodifiedOld'}; %to withSleeping coordinates do interpolation in problematic places
raw(2:length(newY)+1,7)=num2cell(newY);
raw(1,8)={'Xmodified'};
raw(2:length(TrajXNew1)+1,8)=num2cell(TrajXNew1);
raw(1,9)={'Ymodified'};
raw(2:length(TrajYNew1)+1,9)=num2cell(TrajYNew1);


%save passive location
raw(1,10)={'InArena'};
raw(2:length(InArena)+1,10)=num2cell(InArena);
raw(1,11)={'IsSleeping'};
raw(2:length(IsSleepingFinal)+1,11)=num2cell(IsSleepingFinal);
raw(1,12)={'IsHiding'};
raw(2:length(IsHiding)+1,12)=num2cell(IsHiding);
raw(1,13)={'IsDrinking/IsEating'};
raw(2:length(IsEatingDrinkingFinal)+1,13)=num2cell(IsEatingDrinkingFinal);
raw(1,14)={'Repeated coordinates'};
raw(2:length(NoCoordinatesConsidered)+1,14)=num2cell(NoCoordinatesConsidered);

%save velocities
raw(1,15)={'Raw velocity'};
raw(2:length( RawVelocity)+1,15)=num2cell( RawVelocity);
raw(1,16)={'Interpolation velocity'};
raw(2:length(InterpVelocity)+1,16)=num2cell(InterpVelocity);
raw(1,17)={'Velocity from interpolation coordinates'};
raw(2:length(RawVelocityFromInterpCoord)+1,17)=num2cell(RawVelocityFromInterpCoord);
raw(1,18)={'Velocity Marker'};
raw(2:length(RawVelocityMarker)+1,18)=num2cell(RawVelocityMarker); %in this case the delta distance was divided by one frame
raw(1,19)={'Raw slope'};
raw(2:length(RawSlope)+1,19)=num2cell(RawSlope);  %this is the angle of the slope
raw(1,20)={'Velocity'};
raw(2:length(Velocity)+1,20)=num2cell(Velocity);
raw(1,21)={'Angle vector'};
raw(2:length(RawTheta)+1,21)=num2cell(RawTheta);


%save intervals and cage numbers of either hiding or sleeping

raw(1,22:23)={'In Arena begin' 'In Arena end'};
raw(2:length(InArenaIntervalb)+1,22)=num2cell(InArenaIntervalb);
raw(2:length(InArenaIntervale)+1,23)=num2cell(InArenaIntervale);
raw(1,24:25)={'Is Sleeping begin' 'Is Sleeping end'};
raw(2:length(IsSleepingIntervalb)+1,24)=num2cell(IsSleepingIntervalb);
raw(2:length(IsSleepingIntervale)+1,25)=num2cell(IsSleepingIntervale);
raw(1,26:27)={'Is Hiding begin' 'Is Hiding end'};
raw(2:length(IsHidingIntervalb)+1,26)=num2cell(IsHidingIntervalb);
raw(2:length(IsHidingIntervale)+1,27)=num2cell(IsHidingIntervale);
raw(1,28:29)={'Is Eating/drinking begin' 'Is Eating/drinking end'};
% raw(2:length(IsEatingDrinkingVelIntervalb)+1,28)=num2cell(IsEatingDrinkingVelIntervalb);
% raw(2:length(IsEatingDrinkingVelIntervale)+1,29)=num2cell(IsEatingDrinkingVelIntervale);
raw(2:length(EventsBegEDF)+1,28)=num2cell(EventsEndEDF);
raw(2:length(IsEatingDrinkingVelIntervale)+1,29)=num2cell(IsEatingDrinkingVelIntervale);
raw(1,30)={'Sleeping cage'};

raw(2:length(SleepingCage)+1,30)=num2cell(SleepingCage);
raw(1,31)={'Hiding cage'};
raw(2:length( HidingCage)+1,31)=num2cell( HidingCage);

  %The program to look the video begins from zero then create a raw with
  %actual frames
raw(1,32)={'Actual Frames'};
ActualFrame=[0:length(DataMouse(:,1))];
raw(2:length(ActualFrame)+1,32)=num2cell(ActualFrame);









% RawnumForInterpolation(NumbFrames(1:length(numForInterpolation(:,1))),1:2)=numForInterpolation(:,1:2);
% raw(1,34)={'XInt without duplicat'};
% raw(2:length(RawnumForInterpolation(:,1))+1,34)=num2cell(RawnumForInterpolation(:,1));
% 
% raw(1,35)={'YInt without duplicat'};
% raw(2:length(RawnumForInterpolation(:,2))+1,35)=num2cell(RawnumForInterpolation(:,2));

    %raw(1,16)={'angle from one frame to the other'};
  %raw(2:length(RawAngleOneMouse)+1,16)=num2cell(RawAngleOneMouse);
  %raw(1,10:11)={'Sleeping Hiding begin' 'Sleeping Hiding end'};
%raw(2:length(SleepingInterval)+1,10:11)=num2cell(SleepingInterval);
   % raw(1,17)={'Sign angle'};
  %raw(2:length(RawAngleSignOneMouse)+1,17)=num2cell(RawAngleSignOneMouse);
  
%   raw(1,14)={'Cords'};
%   raw(2:length( CoordT(:,1))+1,14:15)=num2cell( CoordT);
 %   raw(1,20)={'min dist'};
  %raw(2:length(ResultDist)+1,20)=num2cell(ResultDist);
  
 
  
  

  
%        raw(1,24)={'int'};
%     
%   raw(2:length(IslopeOriginal)+1,24)=num2cell(IslopeOriginal);
  
    
   
  
 
  
OutputFile=char(OutputFile);  
OutputFile(strfind(OutputFile,'['))='(';
OutputFile(strfind(OutputFile,']'))=')';
xlswrite(OutputFile,raw)
%xlswrite('D:\Test_Tables\TestSilviawithFrames(a451)vs1.xlsx',raw)
%% Additional calculation
 %% Plot velocities histograms
 figure
 clear I
 I=Velocity>0; %logical variable
 nbins=200;
 h1=histogram(Velocity(I),nbins);
xlabel(strcat('Velocity cm/sec of Mouse  ',MouseSelected));
ylabel('Counts')
title(OutputFile)
set(gcf,'units','normalized','outerposition',[0 0 1 1])
saveas(gcf,strcat(OutputFile,'Allrange','.png'))

 figure
 clear I
 I=Velocity>0 & Velocity<150; %logical variable
 nbins=150;
 h1=histogram(Velocity(I),nbins);
xlabel(strcat('Velocity cm/sec of Mouse  ',MouseSelected));
ylabel('Counts')
title(OutputFile)
set(gcf,'units','normalized','outerposition',[0 0 1 1])
saveas(gcf,strcat(OutputFile,'MostRelevantRange','.png'))


 figure
 clear I
 I=Velocity>0 & Velocity<50; %logical variable
 nbins=50;
 h1=histogram(Velocity(I),nbins);
xlabel(strcat('Velocity cm/sec of Mouse  ',MouseSelected));
ylabel('Counts')
title(OutputFile)
set(gcf,'units','normalized','outerposition',[0 0 1 1])
saveas(gcf,strcat(OutputFile,'CrowdyRange','.png'))
end
end

%% Calculation of velocity


 
%% Auxiliary functions

function XY=rescaleCoordinatesGV(XY,Corners,max_width)
XY=(XY-repmat(Corners(1,:),size(XY,1),1))...,
    ./repmat(Corners(3,:)-Corners(1,:),size(XY,1),1)*max_width; % max_wd - mm

end 
 
%% 
function dist = dist_calc(T1,T2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

dist=sqrt(sum((T1-T2).^2,2));

end 
%% 
function IsHiding=InsideHidingBox(cords,HidingCoordinates)
 [in,on]=inpolygon(cords(:,1),cords(:,2),HidingCoordinates(:,1),HidingCoordinates(:,2));
 IsHiding=in&on;
end
%% 
function Index=FindRepeatData(x,y,All)
%tell if the data is repeated in another mouse-If itis repeated is one
for i=1:length(x) %scan each row
  
   L=length(All(i,:));
   
  I=find(All(i,1:2:L-1)==x(i,1)); 
  
if length(I)>1 & All(i,2*(I-1)+2)==y(i,1) %if it is repeated
   Index(i)=1; 
else
    Index(i)=0;
end

end
end




