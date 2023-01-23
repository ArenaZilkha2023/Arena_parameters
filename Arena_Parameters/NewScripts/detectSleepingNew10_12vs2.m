function detectSleepingNew
%Detection of peaks
%  [ TrajectoryX TrajectoryY SleepingInd] = detectSleepingNew(TrajectoryX,TrajectoryY,Params)
%%The data x is on column 2 and y in column 3
global num
global Frames;
Frames=10;

[num1,txt,raw]=xlsread('D:\Test_Tables\OriginalData(a451).xlsx');
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

HidingCoordinatesCentralPx=[212 482;501 485;503 92; 211 99];% central point of the hiding boxes

Corners=[72.47667638 26.94897959;...
548.558309 23.59037901;...
546.0393586 545.8527697;...
79.19387755 544.1734694];
%conversion from pixel to mm
CoordSleepingCells=rescaleCoordinatesGV(CoordSleepingCellsPx,Corners,max_width);
CoordHidingCells=rescaleCoordinatesGV(HidingCoordinatesCentralPx,Corners,max_width);

%% Read the intervals for is arena and is sleeping as calculated without duplicates

 [ArenaBegOriginal ArenaEndOriginal SleepingIntervalBeg SleepingIntervalEnd]=detectSleepingNewvs3;
 
 InArena=zeros(length(num1(:,2)),1);
 for i=1:length(ArenaBegOriginal)
InArena(ArenaBegOriginal(i,1):ArenaEndOriginal(i,1),1)=1;
%Correct the events
 end 
 j=1;
 IsSleepingFinal=zeros(length(num1(:,2)),1);
for i=1:length(SleepingIntervalBeg(:,1))
IsSleepingFinal(SleepingIntervalBeg(i,1)-1:SleepingIntervalEnd(i,1),1)=1;

%%  %% Evaluate the cage is sleeping or hiding- Take coordinates before enter into the cage and after  go out and determine the cage
if isnan(num1(SleepingInterval(i,1),2)) %if it is nan %here I take the input and output
    cordsBeforeEnter=[num1(SleepingInterval(i,1)-2,2),num1(SleepingInterval(i,1)-2,3)];
    cordsAfterExit=[num1(SleepingInterval(i,2)+1,2),num1(SleepingInterval(i,2)+1,3)];
    %do average
    cords=(cordsBeforeEnter+cordsAfterExit)/2;
    %calculate dist
    DistSleepS=dist_calc(CoordSleepingCells,repmat(cords,length(CoordSleepingCells),1));
    DistSleepH=dist_calc(CoordHidingCells,repmat(cords,length(CoordHidingCells),1));
    DistSleep=[DistSleepS DistSleepH];
    %find the minimum distance
    ResultDist(i)=min(DistSleep);
    SleepingCage(i)=find(DistSleep==min(DistSleep));
else
    cordsBeforeEnter=[num1(SleepingInterval(i,1)-1,2),num1(SleepingInterval(i,1)-1,3)];
    cordsAfterExit=[num1(SleepingInterval(i,2)+1,2),num1(SleepingInterval(i,2)+1,3)];
    %do average
    cords=(cordsBeforeEnter+cordsAfterExit)/2;
    %calculate dist
    DistSleepS=dist_calc(CoordSleepingCells,repmat(cords,length(CoordSleepingCells),1));
    DistSleepH=dist_calc(CoordHidingCells,repmat(cords,length(CoordHidingCells),1));
    DistSleep=[DistSleepS; DistSleepH];
    %find the minimum distance
    ResultDist(i)=min(DistSleep);
    %distinguish if is hiding or sleeping box-find the index
    if find(DistSleep==min(DistSleep))<8 %r
       SleepingCage(i)=find(DistSleep==min(DistSleep));
    else
      HidingInterval(j)=[SleepingInterval(i,1) SleepingInterval(i,2)];  
     HidingCage(j)=find(DistSleep==min(DistSleep))-8;
     j=j+1;
    end
    
end

    %New coordinates replace coordinates for sleeping where is sleeping
    num_modified(SleepingInterval(i,1):SleepingInterval(i,2),2)=CoordSleepingCells( SleepingCage(i),1);
    num_modified(SleepingInterval(i,1):SleepingInterval(i,2),3)=CoordSleepingCells( SleepingCage(i),2);
    %coord
    corden(i,:)=[num(SleepingInterval(i,1),2),num(SleepingInterval(i,1),3)]-2e4;

 end
 %% %Correct the events if it is sleeping and also in the arena isarena==0 -since 20000 dissapear inside the arena was found this.


 InArena(find(InArena==1 & IsSleepingFinal==1))=0;

 %% Save data
 raw(1,6)={'InArena'};
raw(2:length(InArena)+1,6)=num2cell(InArena);
 raw(1,7)={'IsSleeping'};
 raw(2:length(IsSleepingFinal)+1,7)=num2cell(IsSleepingFinal);
 
xlswrite('D:\Test_Tables\TestSilviawithFramesvs6.xlsx',raw)
end
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
 

