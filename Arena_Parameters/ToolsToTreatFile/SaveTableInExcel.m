function SaveTableInExcel(~,~)
%variables
global h


table=get(h.table,'data');
Folder_root=get(h.edit1,'string'); %load directory
Experiment=get(h.edit2,'string'); %load experiment
%create parameters if it doesn't exit
if isdir([Folder_root,'\','Parameters','\'])==1
Folder_Data=[Folder_root,'\','Parameters','\']; %dir of the data
else
    mkdir([Folder_root,'\','Parameters','\']);
    Folder_Data=[Folder_root,'\','Parameters','\']; 
end

%% load Arenas coordinates
S=load(strcat(Folder_Data,Experiment,'ArenaCoord.mat'));
HidingCoordinatesCentral=S.HidingCoordinatesCentral;
Corn=S.Corn;
FoodCoordinates=S.FoodCoordinates;
WaterCoordinates=S.WaterCoordinates;
CoordSleepingCells=S.CoordSleepingCells;
BridgesCoordinatesNarrow=S.BridgesCoordinatesNarrow;
BridgesCoordinatesLarger=S.BridgesCoordinatesLarger;
MarkCoordinates=S.MarkCoordPixel;

%% 

%create table
raw(1,2:7)={'Chip1','Chip2','Chip3','Sex','Genotype','Idah'};
raw(2:8,1)={'Mouse1','Mouse2','Mouse3','Mouse4','Mouse5','Mouse6','Mouse7'}; %CONSIDER 7 MOUSES
raw(2:end,2:end)=table;

%% Create a table with the coordinates
raw1(1,1)={'Hiding Central Coordinates x'};
raw1(1,2)={'Hiding Central Coordinates y'};
raw1(1,3)={'Corners x'};
raw1(1,4)={'Corners y'};
raw1(1,5)={'Food coordinates x'};
raw1(1,6)={'Food coordinates y'};
raw1(1,7)={'Water coordinates x'};
raw1(1,8)={'Water coordinates y'};
raw1(1,9)={'Sleeping cells x'};
raw1(1,10)={'Sleeping cells y'};
raw1(1,11)={'Narrow bridge x'};
raw1(1,12)={'Narrow bridge y'};
raw1(1,13)={'Large bridge x'};
raw1(1,14)={'Large bridge y'};
raw1(1,15)={'Zone Coord. x'};
raw1(1,16)={'Zone Coord. y'};


raw1(2:length(HidingCoordinatesCentral(:,1))+1,1:2)=num2cell(HidingCoordinatesCentral);
raw1(2:length(Corn(:,1))+1,3:4)=num2cell(Corn);
raw1(2:length(FoodCoordinates(:,1))+1,5:6)=num2cell(FoodCoordinates);
raw1(2:length(WaterCoordinates(:,1))+1,7:8)=num2cell(WaterCoordinates);
raw1(2:length(CoordSleepingCells(:,1))+1,9:10)=num2cell(CoordSleepingCells);
raw1(2:length(BridgesCoordinatesNarrow(:,1))+1,11:12)=num2cell(BridgesCoordinatesNarrow);
raw1(2:length(BridgesCoordinatesLarger(:,1))+1,13:14)=num2cell(BridgesCoordinatesLarger);

raw1(2:length(MarkCoordinates(:,1))+1,15:16)=num2cell(MarkCoordinates);


%% save in a sheet with experiment name and date in the udisk

%formatOut = 'mm-dd-yy';
%date=datestr(now,formatOut)
%sheet=strcat(ExpName,date)
sheet=strcat(Experiment,'_',h.date)
xlswrite([Folder_Data,'MiceID.xlsx'],raw,sheet);

sheet=strcat(Experiment,'_Arena Coord.','_',h.date)
xlswrite([Folder_Data,'MiceID.xlsx'],raw1,sheet);
end

