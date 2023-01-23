function [ArenaBegOriginal ArenaEndOriginal SleepingIntervalBeg SleepingIntervalEnd Velocity NumbFrames AngleOneMouse AngleSign VelocityMarker Slope theta]=detectSleeping_hiding_arena(data)
%%This data don't include duplicates
%This script detects the arena points and the sleeping/hiding positions
%detected only by rfid antenna
%
%% Parameters

global Params
global num
global FirstDerivative

clear VelocityJumpPosition
clear SleepingInterval


Frames=Params.Frames;
NFS=Params.FPS;%number of frame per second
TimePerFrame=round((1/Params.FPS)*1000); %33ms

num=data;

%% Prepare the data

%% Find the first non-NaN element
InitialDetection=find(isnan(num(:,2))==0,1,'first'); %index of the first detectionA
numvs1=num;
num_modified=num;
%% Fill the NaN with 30000
index=find(isnan(num(:,2))==1);
num(index,2:3)=30000;
num(1:InitialDetection-1,2:3)=NaN;



%% BEGIN ARENA-Find the points in the arena
%% 
%Find the points inside a square
xv=[0 0 1140 1140 0];
yv=[0 1140 1140 0 0];

[in,on]=inpolygon(num(:,2),num(:,3),xv,yv);
IsArena=in & ~on; %find points without the frame of the square
IsArenaIndex=find(IsArena==1);
IsArenaValues=[num(IsArenaIndex,2),num(IsArenaIndex,3)];
% 
%on the border
IsArenaBorderIndex=find(on==1);

%check if the border is part of the arena if mouse go into ten frame is on
%the arena
result=cellfun(@TestFrames,num2cell(IsArenaBorderIndex),'UniformOutput',false)
Aux(:,1)=result;
IndexBorderArena=Aux(find(cell2mat(Aux)>0),1); %find index adequate not adequate are zero
%join the index before
IsArenaIndexTotal=[IsArenaIndex;cell2mat(IndexBorderArena)];
%add to IsArena
IsArena(cell2mat(IndexBorderArena))=1;
%% Create vector
IsInArena=zeros(length(IsArena),1);
IsInArena(IsArenaIndexTotal)=1;

%% Find the intervals for the isarena
[ArenaBeg ArenaEnd]=getEventsIndexesGV(IsInArena,length(IsInArena));
%% Convert to original frame with duplicates/ which is in the first column
ArenaBegOriginal=num(ArenaBeg,1);
ArenaEndOriginal=num(ArenaEnd,1);

%% FINISH ARENA


%% Hiding /Sleeping
%% VELOCITY CALCULATION-THIS IS A RAW CALCULATION WITH ORIGINAL NUM DATA-The velocity is in cm/sec

%find numbers larger than 15000 antenna and substract them
 IndAntenna=find(numvs1(:,2)>1.5e4 & numvs1(:,3)>1.5e4);
 numvs1(IndAntenna,2:3)= numvs1(IndAntenna,2:3)-2e4;
 
 DeltaX=diff(numvs1(:,2));
 DeltaY=diff(numvs1(:,3));
 %% find slope angle
Slope=cellfun(@FindAngle,num2cell(DeltaX),num2cell(DeltaY),'UniformOutput', false);
Slope=cell2mat(Slope);%IS THE ANGLE OF THE SLOPE
 %% find angle
 [theta,rho]=cart2pol(numvs1(:,2),numvs1(:,3));
 %% 

 DeltaFrames=diff(numvs1(:,1)); %each frame is 30ms
Velocity=(sqrt(DeltaX.^2+DeltaY.^2)./(TimePerFrame*DeltaFrames))*100;
Velocity(2:length(Velocity)+1)=Velocity;
Slope(2:length(Slope)+1)=Slope;
NumbFrames=num(:,1);

%CALCULATION OF THE ANGLE
for i=1:length(numvs1(:,2))-1
    u=[numvs1(i,2) numvs1(i,3)];
v=[numvs1(i+1,2) numvs1(i+1,3)];

    if isnan(u)==0 & isnan(v)==0
%ThetaInDegrees(i+1) = atan2d(norm(cross(u,v)),dot(u,v));
CosTheta = dot(u,v)/(norm(u)*norm(v));
AngleOneMouse(i+1) = acosd(CosTheta);%it was i+1

%calculate sign of change
auxvector=[1 0];
CosThetau = dot(u,auxvector)/(norm(auxvector)*norm(u));
CosThetav = dot(v,auxvector)/(norm(auxvector)*norm(v));
AngleSign(i+1)=sign(acosd(CosThetau)-acosd(CosThetav)); %gives the sign of the change

    end
end
%CALCULATION OF VELOCITY PER FRAME TO DISTINGUISH JUMP OF THE MARKER
VelocityMarker=(sqrt(DeltaX.^2+DeltaY.^2)./(TimePerFrame))*100;
VelocityMarker(2:length(VelocityMarker)+1)=VelocityMarker;
%% 
% %% Try to found is sleeping/hiding
% %% do the difference for both x and y

 FirstDerivative=diff(num(:,2:3)); %to find peaks
 IndexTotal=find((FirstDerivative(:,1)>=1e4 & FirstDerivative(:,2)>=1e4)|(FirstDerivative(:,1)<=-1e4 & FirstDerivative(:,2)<=-1e4));%find where only detects antenna or is nan

IndexTotal1=IndexTotal;
IndexForIn=find(FirstDerivative(:,1)>=1e4 & FirstDerivative(:,2)>=1e4); %find the indexes for input  
IndexForOut=find(FirstDerivative(:,1)<=-1e4 & FirstDerivative(:,2)<=-1e4); %find the indexes for output
%% 

%select which indexes are significant for input/output from the cage
IndInput=cellfun(@TestInput,num2cell(IndexForIn));
IndOutput=cellfun(@TestOutput,num2cell(IndexForOut));
%% 
%Retain only indexes >0 the others are not significant-since the no
%significant were marked with zero.

IndInput=IndInput(find(IndInput(:,1)>0),1);
IndOutput=IndOutput(find(IndOutput(:,1)>0),1);
%all toghether and sort
Ind=sort([IndInput;IndOutput]);

%% Get intervals the mouse is inside the cages For test
%The idea is that the intervals are between a positive (+1) and a negative
%(-1) interval. There are cases where the output /input dissapeared
FirstPeak=FirstDerivative(IndexTotal(1),1);

if FirstPeak<0
IndAux=sort([IndInput-1;IndOutput]);
elseif FirstPeak>0
IndAux=sort([IndInput-1;IndOutput]);
end

test=sign(FirstDerivative(IndAux,:));%if the sign is -1 go out the cage and +1 inside the cage
%find if the first is input or output. 
% go out %The pairs is where the difference is -2

 AuxI=find(diff(sign(FirstDerivative(IndAux,1)))==-2);   %choice either x or y
    SleepingInterval=[Ind(AuxI) Ind(AuxI+1)];

    %%
    %Create vector for sleeping-LOOP EACH INTERVAL  AND CORRECT PUNTUAL
    %PROBLEMS AS JUMP OF MEASUREMENT WHEN IT IS IN THE CAGE. 
    %Problem a- suddenly the antenna jumps at the exit from the cage-Then
    %the velocity increases very high-if the velocity is higher than 200
    %cm/sec it is assumed as a jump.
    
    
    %fill with zeros
 IsSleeping=zeros(length(num),1);
% % Loop all the indexes
 num_modified=num;
for i=1:length(SleepingInterval(:,1))
 
  if SleepingInterval(i,2)+3<length(Velocity)
     if Velocity(SleepingInterval(i,2)-1)>Params.Velocity | Velocity(SleepingInterval(i,2)-2)>Params.Velocity | Velocity(SleepingInterval(i,2)-3)>Params.Velocity | Velocity(SleepingInterval(i,2)-4)>Params.Velocity | Velocity(SleepingInterval(i,2)-5)>Params.Velocity  | Velocity(SleepingInterval(i,2))>Params.Velocity |Velocity(SleepingInterval(i,2)+1)>Params.Velocity | Velocity(SleepingInterval(i,2)+2)>Params.Velocity | Velocity(SleepingInterval(i,2)+3)>Params.Velocity
       %find the ~ the same position as the i
      if i+1<=length(SleepingInterval(:,1))%NOT CONSIDERED WHEN IT IS THE END OF THE DATA
       JumpPosition=[numvs1(SleepingInterval(i,2)-1,2),numvs1(SleepingInterval(i,2)- 1,3)]; %if this is 30000 check something different or numvs1
       %find when the velocity jump again
      
      VelocityJumpPosition= SleepingInterval(i,2)+1+find(Velocity(SleepingInterval(i,2)+1:SleepingInterval(i+1,1)+1,1)> Params.Velocity,1,'first')
      else
          JumpPosition=NaN;
          
      end
       
       %% Find the Jump position  when return or the mouse go out. Look until the next interval
      if isnan(JumpPosition)==0
      TestInterval=[numvs1(SleepingInterval(i,2)+1:SleepingInterval(i+1,1),2),numvs1(SleepingInterval(i,2)+1:SleepingInterval(i+1,1),3)]; %distancia minima
      dist=((TestInterval(:,1)-JumpPosition(:,1)).^2+ (TestInterval(:,2)-JumpPosition(:,2)).^2).^0.5; %sometimes this distance is not real since the mark return after the mouse is outside
      %find the minimum distance
      if ~isempty( VelocityJumpPosition)
          AuxSleeping=SleepingInterval(i,2)+1+ find(dist==min(dist),1,'first');  
          if AuxSleeping-VelocityJumpPosition>0 & AuxSleeping-VelocityJumpPosition<2*Params.Frames
         SleepingInterval(i,2)= SleepingInterval(i,2)+1+ find(dist==min(dist),1,'first'); 
          elseif AuxSleeping-VelocityJumpPosition<0
            SleepingInterval(i,2)= SleepingInterval(i,2)+1+ find(dist==min(dist),1,'first');  
          else
           SleepingInterval(i,2)= VelocityJumpPosition;   
          end
      else
        SleepingInterval(i,2)=SleepingInterval(i,2);   
      end
      else
      SleepingInterval(i,2)=SleepingInterval(i,2); %not considered the NaN
      end
     end
  end
    IsSleeping(SleepingInterval(i,1):SleepingInterval(i,2))=1; %issleeping is one where is either sleeping or hiding
    %in this interval arena is zero
    
  
    
end 
    
    




 
%% SAVING DATA
%% Save data
raw(1,1)={'Frames'};
raw(1,2)={'Xoriginal'};
raw(1,3)={'Yoriginal'};
raw(2:length(data(:,1))+1,1)=num2cell(data(:,1));
raw(2:length(data(:,2))+1,2)=num2cell(data(:,2));
raw(2:length(data(:,3))+1,3)=num2cell(data(:,3));
raw(2:length(IsArena)+1,4)=num2cell(IsInArena);
raw(1,4)={'Is Arena'};
raw(2:length(IsSleeping)+1,5)=num2cell(IsSleeping);
raw(1,5)={'Is sleeping'};
length(SleepingInterval)
SleepingIntervalBeg=num(SleepingInterval(:,1),1);
SleepingIntervalEnd=num(SleepingInterval(:,2),1);
ActualSleepingInt=[SleepingIntervalBeg SleepingIntervalEnd];

%  raw(2:length(SleepingInterval)+1,6:7)=num2cell(ActualSleepingInt);
raw(1,6)={'Frame before enter to cage'};
raw(1,7)={'Frame after exit of the cage'};

raw(2:length(IndexTotal)+1,10)=num2cell(IndexTotal);

%Additional information
raw(2:length(Ind)+1,12)=num2cell(Ind);
raw(2:length(test)+1,13:14)=num2cell(test);

raw(1,19)={'velocity'};
raw(2:length(Velocity)+1,19)=num2cell(Velocity);

raw(1,20)={'angle'};
raw(2:length(AngleOneMouse)+1,20)=num2cell(AngleOneMouse);


raw(2:length(IndInput)+1,21)=num2cell(IndInput);
Arena=[ArenaBeg ArenaEnd];
ArenaOriginal=[ArenaBegOriginal ArenaEndOriginal];
raw(2:length(Arena)+1,22:23)=num2cell(Arena);
raw(2:length(ArenaOriginal)+1,24:25)=num2cell(ArenaOriginal);
% xlswrite('D:\Test_Tables\TestSilviawithoutframes8.xlsx',raw)

% FINISH SAVING
end
%% Auxiliary functions
function result=TestFrames(Index)
global num
global Params
Frames=Params.Frames;

xv=[0 0 1140 1140 0];
yv=[0 1140 1140 0 0];

[in,on]=inpolygon(num(Index:Index+Frames,2),num(Index:Index+Frames,3),xv,yv);%several frames inside the arena

for i=1:length(in)
if in(i)==1 | on(i)==1 %is inside or in the border
result=Index ; %ten frames
else
    result=0;
end
end

end
%% function to test if the mouse is inside the cage
function Input=TestInput(Index) %before input must be the coordinate less than 20000 to be either in arena or tubes
global num
global Params
global Velocity

Frames=Params.Frames;
Index=Index; 
%% 
% find bounds for intervals in which the 20000 dissapear-Sometimes the
% 20000 is substracted-Check in the surrounding


if Index+1+Frames<length(num)% in the case is on the border
    
Ilow=find(num(Index+1:Index+1+Frames,2)<1.5e4,1,'first');
else
    Ilow=[];
end

if Index+1+Ilow+Frames < length(num) 
if ~isempty(Ilow)
Ihigh=find(num(Index+1+Ilow:Index+1+Ilow+Frames,2)>1.5e4,1,'first');%must be stringest
else
    
end
else
    Ihigh=[];
end
%% 
if(Index-Frames)<0 
    if num(Index+1:Index+1+Frames,2)>1.5e4 %it is the lower border
    Input=Index+1;
    else
        Input=0;
    end
elseif (Index+1+Frames>length(num))
    if num(Index-Frames:Index,2)<2000
    Input=Index+1;
    else
         Input=0;
    end
elseif num(Index-Frames:Index,2)<2000 & num(Index+1:Index+1+Frames,2)>1.5e4 %before input must be the coordinate less than 2000 to be either in arena or tubes/ after must be larger than 1.5e4-Try xdirection
  Input=Index+1;
elseif  num(Index-Frames:Index,2)<2000 & ~isempty(Ihigh) % in the case the 20000 dissapear then the second condition is not satisfied
    Input=Index+1;
else
    Input=0;%decline the peak

end
end

%% %% function to test if the mouse go outiside the cage
function Input=TestOutput(Index) %before output must be the coordinate bigger than 1.5e4 and after this to be either in arena or tubes less than
global num
global Params
global Velocity
%% 
Frames=Params.Frames;
% find bounds for intervals in which the 20000 dissapear

if Index-1-Frames>0
Ilow=find(num(Index-1-Frames:Index-1,2)<1.5e4,1,'first');%look back
else
    Ilow=[];
end
if (Index-1-Frames-Ilow)>0
if ~isempty(Ilow)
Ihigh=find(num(Index-1-Frames-Ilow:Index-1-Ilow,2)>1.5e4,1,'first');
else
    Ihigh=[];
end
else
    Ihigh=[];
end
% 
%% 
if Index-1-Frames<0 
    if num(Index+1:Index+1+Frames,2)<2000 %at the end of the lower range
    Input=Index;
    else
        Input=0;
    end
elseif Index+1+Frames >length(num)
    if num(Index-1-Frames:Index-1,2)>1.5e4 %at the upper range
     Input=Index;
    else
        Input=0;
    end
elseif num(Index-1-Frames:Index-1,2)>1.5e4  & num(Index+1:Index+1+Frames,2)<2000 
   Input=Index;

elseif num(Index+1:Index+1+Frames,2)<2000 & ~isempty(Ihigh) %in the case there is jump
    
   Input=Index;
else
    Input=0;

end

end


%%
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
function result=FindAngle(X,Y);
result=atan2(Y,X)*180/pi;
end

