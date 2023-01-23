function computeIndLocParametersRFID( ~,~ )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
global h
global Params
global SubsetRFIDDataTime
clc
Params.frames=10;
%Read the mouse head and ribs from the popmenu
index_selected=get(h.popmenuLoc2,'Value');%head
list=get(h.popmenuLoc2,'String');
MouseSelectedHead=list(index_selected,1);

index_selected=get(h.popmenuLocSec2,'Value'); %ribs
list=get(h.popmenuLocSec2,'String');
MouseSelectedRibs=list(index_selected,1);

%Parameters for csv file
cr_fname=get(h.editLoc2,'string');
%% %parameters
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
Params.CoordSleepingCells=rescaleCoordinatesGV(CoordSleepingCellsPx,Corners,max_width);
CoordHidingCells=rescaleCoordinatesGV(HidingCoordinatesCentralPx,Corners,max_width);
HidingCoordinates1=rescaleCoordinatesGV(HidingCoordinates1Px,Corners,max_width);
HidingCoordinates2=rescaleCoordinatesGV(HidingCoordinates2Px,Corners,max_width);
HidingCoordinates3=rescaleCoordinatesGV(HidingCoordinates3Px,Corners,max_width);
HidingCoordinates4=rescaleCoordinatesGV(HidingCoordinates4Px,Corners,max_width);

WaterCoordinates=rescaleCoordinatesGV(WaterCoordinatesPx,Corners,max_width);
FoodCoordinates=rescaleCoordinatesGV(FoodCoordinatesPx,Corners,max_width);

%% 

%Parameters
Params.FPS=30;
Params.NoDetection=1e6;
%% Read text files
RFIDData=LoadRFID(get( h.edittxtLoc2,'string'),MouseSelectedHead,MouseSelectedRibs);

%% Read csv data and remove duplicates
[ActualDate ActualDateWithoutD, DataMouse ,DataMouseWithoutD,DataAllMouse,DataAllMouseWithFrame]=TakeRepeatsOriginalDataRFID(cr_fname,MouseSelectedHead);

%% Found the RFID time near to each frame

%% convert time into time vector
%First find the limits of the data
RFIDDataTime=datevec( RFIDData(:,3),'HH:MM:SS.FFF');


SubsetRFIDDataTime=[];
SubsetRFIDDataTime=RFIDDataTime;
IndexLower=FoundNearTime(ActualDate(1,2));
IndexHigher=FoundNearTime(ActualDate(size(ActualDate,1),2));
%% 


SubsetRFIDDataTime=[];
SubsetRFIDDataTime=RFIDDataTime(IndexLower:IndexHigher,:);
result=cellfun(@FoundNearTime,ActualDate(:,2),'UniformOutput', false);%consider all the frames
%% Save the data
raw={};
%Test=[ActualDate(:,2),RFIDData(cell2mat(result)+IndexLower-1,3),RFIDData(cell2mat(result)+IndexLower-1,4)];
raw(:,1)=ActualDate(:,2);%Real time
raw(:,2)=num2cell(DataMouse(:,2));%x time
raw(:,3)=num2cell(DataMouse(:,3));%ytime
raw(:,4)=RFIDData(cell2mat(result)+IndexLower-1,3);%Rfid time
raw(:,5)=RFIDData(cell2mat(result)+IndexLower-1,4);%antenna rfid
raw(:,6)=RFIDData(cell2mat(result)+IndexLower-1,1);%mouse id
% 
%% Create new coordinates x,y
NewCoord=[];
NewCoord=[raw(:,2) raw(:,3)];

%% 
% Test=[ActualDateWithoutD(:,2),RFIDData(cell2mat(result),3),RFIDData(cell2mat(result),4)];
%xlswrite('testtAll.xlsx',RFIDData)
%  xlswrite('testf.xlsx',raw)
%% Found side box- when there is activity
SideBoxIndex=[];
SideBoxIndex=zeros(length(raw(:,5)),1);
SideBoxIndex(strcmp(raw(:,5),'56') | strcmp(raw(:,5),'55')| strcmp(raw(:,5),'54') | strcmp(raw(:,5),'53')|strcmp(raw(:,5),'49') | strcmp(raw(:,5),'50')| strcmp(raw(:,5),'51') | strcmp(raw(:,5),'52'))=1; %logic index
raw(:,7)=num2cell(SideBoxIndex);
%Assign new position as box entrance-as sleeping box
NewCoord=DetectSideBoxRFID(NewCoord,raw(:,5));




%% Sleeping detection
[SleepingBoxIndexTotal NewCoord EventsBegfinal EventsEndfinal Cages]=DetectSleepingRFID(NewCoord,raw(:,5));

%sort events
I=[];
EventsBegfinal=sort(EventsBegfinal);
[EventsEndfinal I]=sort(EventsEndfinal);
Cages=Cages(I);
IndexSleeping=[];
IndexSleeping=zeros(length(raw(:,5)),1);
IndexSleeping(SleepingBoxIndexTotal | SideBoxIndex)=1;

raw(:,8)=num2cell(SleepingBoxIndexTotal);
raw(:,9)=num2cell(IndexSleeping);
raw(:,10)=num2cell(NewCoord(:,1));
raw(:,11)=num2cell(NewCoord(:,2));
raw(1:length(EventsBegfinal),12)=num2cell(EventsBegfinal);
raw(1:length(EventsEndfinal),13)=num2cell(EventsEndfinal);
raw(1:length(Cages),14)=num2cell(Cages);

 xlswrite('testYefim_e43c_d15e_53L_16.12.xlsx',raw)



end
%% %% Auxiliary functions

function XY=rescaleCoordinatesGV(XY,Corners,max_width)
XY=(XY-repmat(Corners(1,:),size(XY,1),1))...,
    ./repmat(Corners(3,:)-Corners(1,:),size(XY,1),1)*max_width; % max_wd - mm

end 


