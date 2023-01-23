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

HidingCoordinates1Px=[211 438; 254 466;208 534 ;168 508];   %hiding coordinates for each box 
HidingCoordinates2Px=[459 469; 506 437;548 500;499 535];
HidingCoordinates3Px=[502 50; 551 84;499 146;461 114];
HidingCoordinates4Px=[172 78; 222 52;250 124;203 149];

Corners=[118 30;...
604 27;...
602 561;...
117 555];
%conversion from pixel to mm
CoordSleepingCells=rescaleCoordinatesGV(CoordSleepingCellsPx,Corners,max_width);
CoordHidingCells=rescaleCoordinatesGV(HidingCoordinatesCentralPx,Corners,max_width);
HidingCoordinates1=rescaleCoordinatesGV(HidingCoordinates1Px,Corners,max_width);
HidingCoordinates2=rescaleCoordinatesGV(HidingCoordinates2Px,Corners,max_width);
HidingCoordinates3=rescaleCoordinatesGV(HidingCoordinates3Px,Corners,max_width);
HidingCoordinates4=rescaleCoordinatesGV(HidingCoordinates4Px,Corners,max_width);

num_modified=num1;
%% Read the intervals for is arena and is sleeping as calculated without duplicates

 [ArenaBegOriginal ArenaEndOriginal SleepingIntervalBeg SleepingIntervalEnd Velocity NumbFrames]=detectSleepingNewvs3;

 
 InArena=zeros(length(num1(:,2)),1);
 for i=1:length(ArenaBegOriginal)
InArena(ArenaBegOriginal(i,1):ArenaEndOriginal(i,1),1)=1;
%Correct the events
 end 
 j=1;
 IsSleepingFinal=zeros(length(num1(:,2)),1);
 SleepingInterval=[SleepingIntervalBeg SleepingIntervalEnd];
 IsHiding=zeros(length(num1(:,2)),1);
for i=1:length(SleepingIntervalBeg(:,1))
IsSleepingHiding(SleepingIntervalBeg(i,1)-1:SleepingIntervalEnd(i,1),1)=1;
%% FIND LOCATION IF IS SLEEPING OR HIDING

%%  %% Evaluate the cage is sleeping or hiding-
%    if isnan(num1(SleepingInterval(i,1)-1,2))==0 %begin interval test where the mouse enter
%       Iaux=find( num1(SleepingInterval(i,1)-1:end,2)>=20000,5,'first');
%       Arrayaux=num1(Iaux+SleepingInterval(i,1)-1,2) -20000;
%       length(Iaux)
%       cords=sum(Arrayaux)/ length(Iaux); %take five points and do the average
%       
%    else % Take coordinates before and after enter into
    cordsBeforeEnter=[num1(SleepingInterval(i,1)-3,2),num1(SleepingInterval(i,1)-3,3)];
    cordsAfterExit=[num1(SleepingInterval(i,2)+3,2),num1(SleepingInterval(i,2)+3,3)];
    %do average
    cords=(cordsBeforeEnter+cordsAfterExit)/2;
%    end
    %%
    %First check if the mouse is insede the hiding box
   cordsf=[num1(SleepingIntervalBeg(i,1)-1,1) num1(SleepingIntervalBeg(i,1)-1,2)]
    IsHiding1=InsideHidingBox(cordsf,HidingCoordinates1);
    IsHiding2=InsideHidingBox(cordsf,HidingCoordinates2);
    IsHiding3=InsideHidingBox(cordsf,HidingCoordinates3);
    IsHiding4=InsideHidingBox(cordsf,HidingCoordinates4);
    %% 
    HidingCage=[];
    if IsHiding1==1 %is inside box 1
         HidingInterval(j,:)=[SleepingInterval(i,1) SleepingInterval(i,2)];  
     HidingCage(j)=1;
     IsHiding(SleepingIntervalBeg(i,1)-1:SleepingIntervalEnd(i,1),1)=1;
       %New coordinates replace coordinates for sleeping where is sleeping
    num_modified(SleepingInterval(i,1):SleepingInterval(i,2),2)=CoordHidingCells(HidingCage(j),1);
    num_modified(SleepingInterval(i,1):SleepingInterval(i,2),3)=CoordHidingCells(HidingCage(j),2);
     j=j+1;
    elseif IsHiding2==1
              HidingInterval(j,:)=[SleepingInterval(i,1) SleepingInterval(i,2)];  
     HidingCage(j)=2;
     IsHiding(SleepingIntervalBeg(i,1)-1:SleepingIntervalEnd(i,1),1)=1;
       %New coordinates replace coordinates for sleeping where is sleeping
    num_modified(SleepingInterval(i,1):SleepingInterval(i,2),2)=CoordHidingCells(HidingCage(j),1);
    num_modified(SleepingInterval(i,1):SleepingInterval(i,2),3)=CoordHidingCells(HidingCage(j),2);
     j=j+1;
        elseif IsHiding3==1
                  HidingInterval(j,:)=[SleepingInterval(i,1) SleepingInterval(i,2)];  
     HidingCage(j)=3;
     IsHiding(SleepingIntervalBeg(i,1)-1:SleepingIntervalEnd(i,1),1)=1;
       %New coordinates replace coordinates for sleeping where is sleeping
    num_modified(SleepingInterval(i,1):SleepingInterval(i,2),2)=CoordHidingCells(HidingCage(j),1);
    num_modified(SleepingInterval(i,1):SleepingInterval(i,2),3)=CoordHidingCells(HidingCage(j),2);
     j=j+1;
            elseif IsHiding4==1
                  HidingInterval(j,:)=[SleepingInterval(i,1) SleepingInterval(i,2)];  
            HidingCage(j)=4;
     IsHiding(SleepingIntervalBeg(i,1)-1:SleepingIntervalEnd(i,1),1)=1;
       %New coordinates replace coordinates for sleeping where is sleeping
    num_modified(SleepingInterval(i,1):SleepingInterval(i,2),2)=CoordHidingCells(HidingCage(j),1);
    num_modified(SleepingInterval(i,1):SleepingInterval(i,2),3)=CoordHidingCells(HidingCage(j),2);
     j=j+1;    
    else
    
    %calculate dist either from sleeping 
    DistSleepS=dist_calc(CoordSleepingCells,repmat(cords,length(CoordSleepingCells),1));
    %DistSleepH=dist_calc(CoordHidingCells,repmat(cords,length(CoordHidingCells),1));
    %DistSleep=[DistSleepS; DistSleepH];
    %find the minimum distance
    DistSleep=DistSleepS;
    ResultDist(i)=min(DistSleep);
    %distinguish if is hiding or sleeping box-find the index
%     if find(DistSleep==min(DistSleep))<=8 %r
       SleepingCage(i)=find(DistSleep==min(DistSleep));
       IsSleepingFinal(SleepingIntervalBeg(i,1)-1:SleepingIntervalEnd(i,1),1)=1;
        %New coordinates replace coordinates for sleeping where is sleeping
    num_modified(SleepingInterval(i,1):SleepingInterval(i,2),2)=CoordSleepingCells( SleepingCage(i),1);
    num_modified(SleepingInterval(i,1):SleepingInterval(i,2),3)=CoordSleepingCells( SleepingCage(i),2);
 
     
    end
    


   
    %coord
    %corden(i,:)=[num(SleepingInterval(i,1),2),num(SleepingInterval(i,1),3)]-2e4;
end
%END

 %% %First correction: Correct the events if it is sleeping and also in the arena isarena==0 -since 20000 dissapear inside the arena was found this.


 InArena(find(InArena==1 & IsSleepingFinal==1))=0;
 
 %Second correction if it is hiding and in the arena it is zero in the
 %arena
 
InArena(find(InArena==1 & IsHiding==1))=0;
%% Add the velocity data in the relevant frames

RawVelocity(NumbFrames(1:length(Velocity)))=Velocity;

 %% Save data
  raw(1,4)={'Xmodified'};
raw(2:length(InArena)+1,4)=num2cell(num_modified(:,2));
  raw(1,5)={'Ymodified'};
raw(2:length(InArena)+1,5)=num2cell(num_modified(:,3));
 raw(1,6)={'InArena'};
raw(2:length(InArena)+1,6)=num2cell(InArena);
 raw(1,7)={'IsSleeping'};
 raw(2:length(IsSleepingFinal)+1,7)=num2cell(IsSleepingFinal);
  raw(1,8)={'IsHiding'};
 raw(2:length(IsHiding)+1,8)=num2cell(IsHiding);
  raw(1,9:10)={'Sleeping Hiding begin' 'Sleeping Hiding end'};
 raw(2:length(SleepingInterval)+1,9:10)=num2cell(SleepingInterval);
   raw(1,11)={'Sleeping cage'};
 raw(2:length(SleepingCage)+1,11)=num2cell(SleepingCage);
   raw(1,12)={'Hiding cage'};
 raw(2:length( HidingCage)+1,12)=num2cell( HidingCage);
 raw(1,13)={'Raw velocity'};
  raw(2:length( RawVelocity)+1,13)=num2cell( RawVelocity);
 
xlswrite('D:\Test_Tables\TestSilviawithFramesvs4.xlsx',raw)
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
%% 
function IsHiding=InsideHidingBox(cords,HidingCoordinates)
 [in,on]=inpolygon(cords(:,1),cords(:,2),HidingCoordinates(:,1),HidingCoordinates(:,2));
 IsHiding=in&on;
end
