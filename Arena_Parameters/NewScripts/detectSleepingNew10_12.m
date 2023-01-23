function detectSleepingNew
%Detection of peaks
%  [ TrajectoryX TrajectoryY SleepingInd] = detectSleepingNew(TrajectoryX,TrajectoryY,Params)
global num
global Frames;
Frames=10;

[num,txt,raw]=xlsread('D:\Test_Tables\OriginalData(a451).xlsx');
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


%% Find the first non-NaN element
InitialDetection=find(isnan(num(:,2))==0,1,'first'); %index of the first detectionA
numOriginal=num;
%% Fill the NaN with 30000
index=find(isnan(num(:,2))==1);
num(index,2:3)=30000;
num(1:InitialDetection-1,2:3)=NaN;

%% Find the points in the arena
xv=[0 0 1140 1140 0];
yv=[0 1140 1140 0 0];
%figure
%plot(xv,yv)
[in,on]=inpolygon(num(:,2),num(:,3),xv,yv);
IsArena=in & ~on; %find points without the frame of the square
IsArenaIndex=find(IsArena==1);
IsArenaValues=[num(IsArenaIndex,2),num(IsArenaIndex,3)];

%on the border
IsArenaBorderIndex=find(on==1);
%IsArenaValuesborder=[num(find(on==1),2),num(find(on==1),3)];
%check if the border is part of the arena if mouse go out ten frame is on
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

raw(2:length(IsArena)+1,4)=num2cell(IsInArena);
raw(1,4)={'Is Arena'};



%% Try to found is sleeping/hiding

% %% do the difference for both x and y
 FirstDerivative=diff(num(:,2:3)); %to find peaks
 IndexTotal=find((FirstDerivative(:,1)>=1e4 & FirstDerivative(:,2)>=1e4)|(FirstDerivative(:,1)<=-1e4 & FirstDerivative(:,2)<=-1e4));
 
% result=FirstDerivative(IndexTotal);
IndexTotal1=IndexTotal;
IndexForIn=find(FirstDerivative(:,1)>=1e4 & FirstDerivative(:,2)>=1e4); %find the indexes for input  
IndexForOut=find(FirstDerivative(:,1)<=-1e4 & FirstDerivative(:,2)<=-1e4);%find the indexes for output
%% 

%select which indexes are significant for input/output from the cage
IndInput=cellfun(@TestInput,num2cell(IndexForIn));
IndOutput=cellfun(@TestOutput,num2cell(IndexForOut));
%% 
%Retain only indexes
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
FirstPeak=FirstDerivative(IndexTotal(1),1);
if FirstPeak<0 % go out
%The pairs is where the difference is -2
 AuxI=find(diff(sign(FirstDerivative(IndAux,1)))==-2);   %choice either x or y
    SleepingInterval=[Ind(AuxI) Ind(AuxI+1)];
    
 %fill with zeros
 IsSleeping=zeros(length(num),1);
% % Loop all the indexes
 num_modified=num;
for i=1:length(SleepingInterval(:,1))
    IsSleeping(SleepingInterval(i,1):SleepingInterval(i,2))=1; %issleeping is one where is either sleeping or hiding
    %% Evaluate the cage is sleeping- Take coordinates before enter into the cage and after  go out and determine the cage
    cordsBeforeEnter=[num(SleepingInterval(i,1)-1,2),num(SleepingInterval(i,1)-1,3)];
    cordsAfterExit=[num(SleepingInterval(i,2)+1,2),num(SleepingInterval(i,2)+1,3)];
    %do average
    cords=(cordsBeforeEnter+cordsAfterExit)/2;
    %calculate dist
    DistSleep=dist_calc(CoordSleepingCells,repmat(cords,length(CoordSleepingCells),1));
    %find the minimum distance
    ResultDist(i)=min(DistSleep);
    SleepingCage(i)=find(DistSleep==min(DistSleep));
    
    %New coordinates replace coordinates for sleeping where is sleeping
    num_modified(SleepingInterval(i,1):SleepingInterval(i,2),2)=CoordSleepingCells( SleepingCage(i),1);
    num_modified(SleepingInterval(i,1):SleepingInterval(i,2),3)=CoordSleepingCells( SleepingCage(i),2);
    %coord
    corden(i,:)=[num(SleepingInterval(i,1),2),num(SleepingInterval(i,1),3)]-2e4;
    
end 
    
    
else
end

  Xmodified=num_modified(:,2);
  Ymodified=num_modified(:,3);
%% 
raw(2:length(IsSleeping)+1,5)=num2cell(IsSleeping);
raw(1,5)={'Is sleeping'};

raw(2:length(SleepingInterval)+1,6:7)=num2cell(SleepingInterval);
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


% raw(2:length(IndexTotal1)+1,7)=num2cell(IndexTotal1);
% raw(2:length(IndexForIn)+1,8)=num2cell(IndexForIn);
% raw(2:length(IndexForOut)+1,9)=num2cell(IndexForOut);
% raw(2:length(IndInput)+1,10)=num2cell(IndInput);
% raw(2:length(IndOutput)+1,11)=num2cell(IndOutput);
% raw(2:length(Ind)+1,12)=num2cell(Ind);
% raw(2:length(test)+1,13:14)=num2cell(test);
% raw(2:length(SleepingInterval)+1,15:16)=num2cell(SleepingInterval);
% raw(2:length(IsSleeping)+1,17)=num2cell(IsSleeping);
% raw(2:length(ResultDist)+1,18)=num2cell(ResultDist);
% raw(2:length(SleepingCage)+1,19)=num2cell(SleepingCage);
xlswrite('D:\Test_Tables\tableTestSilvia.xlsx',raw)
% 

end
%% Auxiliary functions
function result=TestFrames(Index)
global num
global Frames
%Index=str2num(Index1)
if num(Index,2)==0 %in the x direction
  if num(Index:Index+Frames,2)>=0 & num(Index:Index+Frames,2)<1140 %is inside the arena
      result=Index ; %ten frames
  else
      result=0;
  end
else
    result=0;
end
  
  
  if num(Index,3)==0 %in the y direction
  if num(Index:Index+Frames,3)>=0 & num(Index:Index+Frames,3)<1140 %is inside the arena
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
Index=Index; 
num(Index-Frames:Index,2);
% 
if num(Index-Frames:Index,2)<2000 & num(Index+1:Index+1+Frames,2)>1.5e4 %before input must be the coordinate less than 2000 to be either in arena or tubes/ after must be larger than 1.5e4-Try xdirection
  Input=Index+1
  
  
else
    Input=0;

end

end

%% %% function to test if the mouse go outiside the cage
function Input=TestOutput(Index) %before output must be the coordinate bigger than 1.5e4 and after this to be either in arena or tubes less than
global num
global Frames
Index=Index; 

% 
if num(Index-1-Frames:Index-1,2)>1.5e4  & num(Index+1:Index+1+Frames,2)<2000
  Input=Index
  
  
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

