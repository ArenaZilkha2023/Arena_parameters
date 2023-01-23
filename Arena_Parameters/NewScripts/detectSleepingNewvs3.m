function [ArenaBegOriginal ArenaEndOriginal SleepingIntervalBeg SleepingIntervalEnd Velocity NumbFrames]=detectSleepingNewvs3(data)
%%This data don't include duplicates
%Detection of peaks
%
%% Parameters

global Params
global num
global Frames;
%global Velocity;
global FirstDerivative
Frames=Params.Frames;
NFS=Params.FPS;%number of frame per second
TimePerFrame=(1/Params.FPS)*1000; %33ms
% fileWithoutDuplicates='D:\Test_Tables\Mousea451WitoutDuplicates.xlsx';
% %[num,txt,raw]=xlsread('D:\Test_Tables\tableTestSilvia.xlsx');
% [num,txt,raw]=xlsread(fileWithoutDuplicates);
num=data;

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

Corners=[72.47667638 26.94897959;...
548.558309 23.59037901;...
546.0393586 545.8527697;...
79.19387755 544.1734694];
%conversion from pixel to mm
CoordSleepingCells=rescaleCoordinatesGV(CoordSleepingCellsPx,Corners,max_width);
%save('SleepingCoord.mat','CoordSleepingCells')

%% Find the first non-NaN element
InitialDetection=find(isnan(num(:,2))==0,1,'first'); %index of the first detectionA
numOriginal=num;
%% Fill the NaN with 30000
index=find(isnan(num(:,2))==1);
num(index,2:3)=30000;
num(1:InitialDetection-1,2:3)=NaN;
%% 



%% BEGIN ARENA
%% 


% %% Find the points in the arena
xv=[0 0 1140 1140 0];
yv=[0 1140 1140 0 0];
% %figure
% %plot(xv,yv)
[in,on]=inpolygon(num(:,2),num(:,3),xv,yv);
IsArena=in & ~on; %find points without the frame of the square
IsArenaIndex=find(IsArena==1);
IsArenaValues=[num(IsArenaIndex,2),num(IsArenaIndex,3)];
% 
%on the border
IsArenaBorderIndex=find(on==1);

%check if the border is part of the arena if mouse go into ten frame is on
%the arena
cellfun(@TestFrames,num2cell(IsArenaBorderIndex),'UniformOutput',false);
Aux(:,1)=ans;
IndexBorderArena=Aux(find(cell2mat(Aux)>0),1); %find index adequate not adequate are zero
%join the index before
IsArenaIndexTotal=[IsArenaIndex;cell2mat(IndexBorderArena)];
%add to IsArena
IsArena(cell2mat(IndexBorderArena))=1;
%% Create vector
IsInArena=zeros(length(IsArena),1);
IsInArena(IsArenaIndexTotal)=1;

%% Save data
raw(1,1)={'Frames'};
raw(1,2)={'Xoriginal'};
raw(1,3)={'Yoriginal'};
raw(2:length(data(:,1)),1)=num2cell(data(:,1));
raw(2:length(data(:,2)),1)=num2cell(data(:,2));
raw(2:length(data(:,3)),1)=num2cell(data(:,3));
raw(2:length(IsArena)+1,4)=num2cell(IsInArena);
raw(1,4)={'Is Arena'};
%% Find the intervals for the isarena
[ArenaBeg ArenaEnd]=getEventsIndexesGV(IsInArena,length(IsInArena));
%% Convert to original frame with duplicates/ which is in the first column
ArenaBegOriginal=num(ArenaBeg,1);
ArenaEndOriginal=num(ArenaEnd,1);



%% FINISH ARENA


%% Hiding /Sleeping
%% 
 % Try to found is sleeping/hiding 

% %% do the difference for both x and y
 FirstDerivative=diff(num(:,2:3)); %to find peaks
 IndexTotal=find((FirstDerivative(:,1)>=1e4 & FirstDerivative(:,2)>=1e4)|(FirstDerivative(:,1)<=-1e4 & FirstDerivative(:,2)<=-1e4));%find where only detects antenna or is nan

 %% Calculate velocity with original num
 numvs1=numOriginal;
 %find numbers larger than 15000 antenna and substract them
 IndAntenna=find(numvs1(:,2)>1.5e4 & numvs1(:,3)>1.5e4);
 numvs1(IndAntenna,2:3)= numvs1(IndAntenna,2:3)-2e4;
 
 DeltaX=diff(numvs1(:,2));
 DeltaY=diff(numvs1(:,3));
 DeltaFrames=diff(numvs1(:,1)); %each frame is 30ms
Velocity=(sqrt(DeltaX.^2+DeltaY.^2)./(TimePerFrame*DeltaFrames))*100;
NumbFrames=num(:,1);
%% 
% %% Try to found is sleeping/hiding
% 
% % %% do the difference for both x and y
 
 
% result=FirstDerivative(IndexTotal);
IndexTotal1=IndexTotal;
IndexForIn=find(FirstDerivative(:,1)>=1e4 & FirstDerivative(:,2)>=1e4); %find the indexes for input  
IndexForOut=find(FirstDerivative(:,1)<=-1e4 & FirstDerivative(:,2)<=-1e4);%find the indexes for output
%% 

%select which indexes are significant for input/output from the cage
IndInput=cellfun(@TestInput,num2cell(IndexForIn));
IndOutput=cellfun(@TestOutput,num2cell(IndexForOut));
%% 
%Retain only indexes >0 the others are not significant
IndInput=IndInput(find(IndInput(:,1)>0),1);
IndOutput=IndOutput(find(IndOutput(:,1)>0),1);
%all toghether and sort
Ind=sort([IndInput;IndOutput]);

%% Get intervals the mouse is inside the cages For test
%The idea is that the intervals are between a positive (+1) and a negative
%(-1) interval. There are cases where the output dissapeared

IndAux=sort([IndInput-1;IndOutput]);
test=sign(FirstDerivative(IndAux,:));%if the sign is -1 go out the cage and +1 inside the cage
%find if the first is input or output.
% 
%% 
FirstPeak=FirstDerivative(IndexTotal(1),1);
if FirstPeak<0 % go out
%The pairs is where the difference is -2
 AuxI=find(diff(sign(FirstDerivative(IndAux,1)))==-2);   %choice either x or y
    SleepingInterval=[Ind(AuxI) Ind(AuxI+1)];
    %% Take into account the output peaks which were not considered. In general it is detected the input but not the output.
    %Find the difference is equal to 2
%      AuxNoDetected=find(diff(sign(FirstDerivative(IndAux,1)))==0);
%      sign(FirstDerivative(Ind( AuxNoDetected)))
%      
%      if ~isempty(AuxNoDetected)
%     for t=1:length(AuxNoDetected)
%         if sign(FirstDerivative(Ind(AuxNoDetected(t)),1))==1
%        Ienter(t)=Ind(AuxNoDetected(t)) %find when the mouse is outside the cage until the next entrance
%        Ioutside(t)=Ind(AuxNoDetected(t)+1)-Frames
%        IndexAdditional(t)=find(num(Ienter(t):Ioutside(t))>=1e4,1,'last')
%         end
%     end
%     %add additional intervals
%      SleepingInterval=[ SleepingInterval;[Ienter IndexAdditional]];
%      end
    %% 
    
 %fill with zeros
 IsSleeping=zeros(length(num),1);
% % Loop all the indexes
 num_modified=num;
for i=1:length(SleepingInterval(:,1))
   S=sum(SleepingInterval(i,2)+SleepingInterval(i,2)+1+SleepingInterval(i,2)+2+SleepingInterval(i,2)+3+SleepingInterval(i,2)+4)/5;
     if Velocity(SleepingInterval(i,2)-1)>150 | Velocity(SleepingInterval(i,2)-2)>150 | Velocity(SleepingInterval(i,2)-3)>150 | Velocity(SleepingInterval(i,2)-4)>150 | Velocity(SleepingInterval(i,2)-5)>150  | Velocity(SleepingInterval(i,2)-6)>150 |Velocity(SleepingInterval(i,2)+1)>150 | Velocity(SleepingInterval(i,2)+2)>150 | Velocity(SleepingInterval(i,2)+3)>150
         %& Velocity(S)<5 %it was 200 %The idea if the mouse is inside and the velocity increases and then is reduced the mouse is in the cage, in the moment the velocity increases the mouse outside
        %look for the index where go out from the cage with velocity >5
        %cm/sec
      I2=find(Velocity(SleepingInterval(i,2)+1:length(Velocity))>5,5,'first') %detect 5 consecutives with velocity> 5cm
%        SleepingInterval(i,2)=SleepingInterval(i,2)+1+I(1)-1;  
      I1=find(Velocity(SleepingInterval(i,2)+1:length(Velocity))>130,1,'first');%shift because bag in the program that the mouse is inside but it is detected outsid Add that velocity is small 
      if I2(1)<I1
        SleepingInterval(i,2)=SleepingInterval(i,2)+1+I2(1)-1;   
          
      elseif I1<I2(1)
      I=find(Velocity(SleepingInterval(i,2)+1+I1:length(Velocity))>5,5,'first') %detect 5 consecutives with velocity> 5cm
      SleepingInterval(i,2)=SleepingInterval(i,2)+1+I1-1+I(1)-1; 
      end
       %if isempty(I) %if is empty
        %    SleepingInterval(i,2)=SleepingInterval(i,2)
       %end
     end
    
    
    IsSleeping(SleepingInterval(i,1):SleepingInterval(i,2))=1; %issleeping is one where is either sleeping or hiding
    %in this interval arena is zero
    
    % Evaluate the cage is sleeping- Take coordinates before enter into the cage and after  go out and determine the cage
    cordsBeforeEnter=[num(SleepingInterval(i,1)-1,2),num(SleepingInterval(i,1)-1,3)];
    cordsAfterExit=[num(SleepingInterval(i,2)+1,2),num(SleepingInterval(i,2)+1,3)];
    %do average
    cords=(cordsBeforeEnter+cordsAfterExit)/2;
%    calculate dist
    DistSleep=dist_calc(CoordSleepingCells,repmat(cords,length(CoordSleepingCells),1));
   % find the minimum distance
    ResultDist(i)=min(DistSleep);
    SleepingCage(i)=find(DistSleep==min(DistSleep));
    
    %New coordinates replace coordinates for sleeping where is sleeping
    num_modified(SleepingInterval(i,1):SleepingInterval(i,2),2)=CoordSleepingCells( SleepingCage(i),1);
    num_modified(SleepingInterval(i,1):SleepingInterval(i,2),3)=CoordSleepingCells( SleepingCage(i),2);
  
    corden(i,:)=[num(SleepingInterval(i,1),2),num(SleepingInterval(i,1),3)]-2e4;
    
end 
    
    
%else
end


  Xmodified=num_modified(:,2);
  Ymodified=num_modified(:,3);
%% SAVING DATA
raw(2:length(IsSleeping)+1,5)=num2cell(IsSleeping);
raw(1,5)={'Is sleeping'};
SleepingIntervalBeg=num(SleepingInterval(:,1),1);
SleepingIntervalEnd=num(SleepingInterval(:,2),1);
ActualSleepingInt=[SleepingIntervalBeg SleepingIntervalEnd];

raw(2:length(SleepingInterval)+1,6:7)=num2cell(ActualSleepingInt);
raw(1,6)={'Frame before enter to cage'};
raw(1,7)={'Frame after exit of the cage'};

raw(2:length(ResultDist)+1,8)=num2cell(ResultDist);
raw(1,8)={'Dist to the nearest cage'};
raw(2:length(SleepingCage)+1,9)=num2cell(SleepingCage);
raw(1,9)={'Sleeping cage'};

%Additional information
raw(2:length(Ind)+1,12)=num2cell(Ind);
raw(2:length(test)+1,13:14)=num2cell(test);

%new coordinates
raw(1,15)={'Xmodified'};
raw(2:length(Xmodified)+1,15)=num2cell(Xmodified);
raw(1,16)={'Ymodified'};
raw(2:length(Ymodified)+1,16)=num2cell(Ymodified);

raw(2:length(corden(:,2))+1,17:18)=num2cell(corden);
% Output
% 
% 
raw(1,19)={'velocity'};
raw(2:length(Velocity)+1,19)=num2cell(Velocity);
raw(2:length(DeltaFrames)+1,20)=num2cell(DeltaFrames);
raw(2:length(IndInput)+1,21)=num2cell(IndInput);
Arena=[ArenaBeg ArenaEnd];
ArenaOriginal=[ArenaBegOriginal ArenaEndOriginal];
raw(2:length(Arena)+1,22:23)=num2cell(Arena);
raw(2:length(ArenaOriginal)+1,24:25)=num2cell(ArenaOriginal);
xlswrite('D:\Test_Tables\TestSilviawithoutframes6.xlsx',raw)
% % raw(2:length(IndexTotal1)+1,7)=num2cell(IndexTotal1);
% % raw(2:length(IndexForIn)+1,8)=num2cell(IndexForIn);
% % raw(2:length(IndexForOut)+1,9)=num2cell(IndexForOut);
% % raw(2:length(IndInput)+1,10)=num2cell(IndInput);
% % raw(2:length(IndOutput)+1,11)=num2cell(IndOutput);
% % raw(2:length(Ind)+1,12)=num2cell(Ind);
% % raw(2:length(test)+1,13:14)=num2cell(test);
% % raw(2:length(SleepingInterval)+1,15:16)=num2cell(SleepingInterval);
% % raw(2:length(IsSleeping)+1,17)=num2cell(IsSleeping);
% % raw(2:length(ResultDist)+1,18)=num2cell(ResultDist);
% % raw(2:length(SleepingCage)+1,19)=num2cell(SleepingCage);
% %xlswrite('D:\Test_Tables\tableTestSilvia.xlsx',raw)
% % 
% FINISH SAVING
end
%% Auxiliary functions
function result=TestFrames(Index)
global num
global Frames

if num(Index,2)==0 %in the x direction
  if num(Index:Index+Frames,2)>=0 & num(Index:Index+Frames,2)<1140 & num(Index:Index+Frames,3)>=0 & num(Index:Index+Frames,3)<1140 %is inside the arena
      result=Index ; %ten frames
  else
      result=0;
  end
else
    result=0;
end
  
  
  if num(Index,3)==0 %in the y direction
  if num(Index:Index+Frames,3)>=0 & num(Index:Index+Frames,3)<1140 num(Index:Index+Frames,2)>=0 & num(Index:Index+Frames,2)<1140 %is inside the arena
      result=Index ; %ten frames
  else
      result=0;
  end
  else
      result=0;
end
end

%% function to test if the mouse is inside the cage
function Input=TestInput(Index) %before input must be the coordinate less than 2000 to be either in arena or tubes
global num
global Frames
global Velocity
Index=Index; 
num(Index-Frames:Index,2);
% find bounds for intervals in which the 20000 dissapear
Ilow=find(num(Index+1:end,2)<1.5e4,1,'first');
Ihigh=find(num(Index+1+Ilow:end,2)>1.5e4,1,'first');

if num(Index-Frames:Index,2)<2000 & num(Index+1:Index+1+Frames,2)>1.5e4  %before input must be the coordinate less than 2000 to be either in arena or tubes/ after must be larger than 1.5e4-Try xdirection
  Input=Index+1;
  
elseif  num(Index-Frames:Index,2)<2000 & Ihigh<Frames % in the case the 20000 dissapear then the second condition is not satisfied
    Input=Index+1;
else
    Input=0;%decline the peak

end

end

%% %% function to test if the mouse go outiside the cage
function Input=TestOutput(Index) %before output must be the coordinate bigger than 1.5e4 and after this to be either in arena or tubes less than
global num
global Frames
global Velocity
global FirstDerivative
Index=Index; 
% find bounds for intervals in which the 20000 dissapear
Ilow=find(num(Index-1-Frames:Index-1,2)<1.5e4,1,'first');%look back
Ihigh=find(num(Index-1-Frames:Index-1,2)<1.5e4,1,'last');
delta=Ihigh-Ilow;
% 
if num(Index-1-Frames:Index-1,2)>1.5e4  & num(Index+1:Index+1+Frames,2)<2000
   
         

  Input=Index;
elseif num(Index+1:Index+1+Frames,2)<2000 & delta<Frames %in the case there is jump
    
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

