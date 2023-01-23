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

%% ----------------------------------Read Parameters of RFID files----------------
%  AllListRFID=cell(50000,4);%definition to accelerate the formation of the list

RFIDobj=FilesTreat;%use class FilesTreat
RFIDobj.directory=Params.DataRFID;
RFIDobj.extension='.txt';
N=RFIDobj.NumFiles(RFIDobj.ListFiles);
DateFiles=RFIDobj.DateFiles(RFIDobj.ListFiles,N);


%% --------------------Read Parameters of csv files----------------
CSVobj=FilesTreat;%use class FilesTreat
CSVobj.directory=Params.DataDir;
CSVobj.extension='.csv';

%% ----------------------------Select  your list if female or male----------------
switch Params.ChoiceList
case 'Males'
miceList=Params.malesList;
miceList=strrep(miceList,'''',''); %for removing double quotes
miceListRibs=Params.malesListRibs;
miceListRibs=strrep(miceListRibs,'''','');

case 'Females'
miceList=Params.femalesList;
miceList=strrep(miceList,'''',''); %for removing double quotes
miceListRibs=Params.femalesListRibs;
miceListRibs=strrep(miceListRibs,'''','');
end

%% --------------------Define object IsSleeping---------------------
IsSleepingobj=Sleeping; %use class Sleeping
IsSleepingobj.AntennaCage=Params.AntennaCage; %number of antenna that detetect outside the arena
IsSleepingobj.AntennaSideBox=Params.SideBoxAntenna;%number of antenna in the side box
IsSleepingobj.SleepingCoord=Params.Coordinates.CoordSleepingCells; %coordinates of the sleeping cells if it is right or left
%% --------------------------Define object IsHiding-----------------
IsHidingobj=Hiding; %use class Hiding
IsHidingobj.AntennaHidingBox=Params.AntennaHidingBox;
IsHidingobj.HidingCoord=Params.HidingCoordinatesCentral;

%% -----------------------------Define object IsArena ---------------------------
InArenaobj=Arena;
InArenaobj. AntennaCoord=Params. AntennaCoord;%antenna position
%% ---------------------------Define object Time---------------------------------
Timeobj=TimeLine;

%%
%%-------SELECT BETWEEN DOING ALL THE EXPERIMENT OR THE SELECTION OF SOME
%%FILES---

switch Params.ForSomeFile
case 0 %All the experiment
nCSV=CSVobj.NumFiles(CSVobj.ListFiles);  %number of files of all the experiment   

for i=1:nCSV %loop over the original files
clear ArrayX; %for x coord.
clear ArrayY; %for y coord.
clear ArrayXY;
ArrayX=[];
ArrayY=[];
ArrayXY=[];
 clear Distance;
  clear  VectorX;
  clear  VectorY;
Distance=[];
VectorX=[];
VectorY=[];      
    
clear MouseArray;    
CSVFile=CSVobj.ReadFilesAllCSV(CSVobj.ListFiles,i);%read each file
CSVmiceIDs=CSVobj.miceIDs(CSVobj.ListFiles,i);%read the mice identities of each file


 hn=msgbox(strcat('Doing File:',num2str(i)))

%% %%-------- According to date select RFDI----------------
ListFiles=CSVobj.ListFiles;
ListFiles(i).name
 IndexFilesDates=findRFIDSubset(ListFiles(i).name,DateFiles);

 SelectedDataRFID=RFIDobj.ReadFilesAllDate(RFIDobj.ListFiles,IndexFilesDates);

%% Create a wait bar for control
hbar = waitbar(0,'Please wait...'); 

% Rearrange the data according to the mice in a multidimensional array

for j=1:length(miceList) %for each mouse
      %% Clear the variables
    clear AuxID
    clear Auxtime
    clear Auxantenna
    clear Iaux
    clear AuxIDn
    clear Auxtimen
    clear Auxantennan
    %% 

%ONLY CONSIDER THE LAST NUMBERS SINCE SOMETIMES THE INITIAL ZERO DISSAPEAR

Ind=cellfun(@(x)Find4last(x,miceList{j}(end-6:end)),CSVmiceIDs,'UniformOutput', false);

MouseArray(2:length([CSVFile{1}])+1,1,j)=CSVFile{1}; %for date
MouseArray(2:length([CSVFile{2}])+1,2,j)=strcat('''',[CSVFile{2}],''''); %for time

if ~isempty(find(cell2mat(Ind)==1))
    %% 
MouseArray(2:length([CSVFile{2}])+1,3,j)=num2cell(CSVFile{3+(find(cell2mat(Ind)==1)-1)*3}); %for x
MouseArray(2:length([CSVFile{2}])+1,4,j)=num2cell(CSVFile{4+(find(cell2mat(Ind)==1)-1)*3}); %for y

%% --------Found in the RFID selected data the mouse with 2 identities head or reabs--
AuxID=vertcat(SelectedDataRFID{:,1});%identity
Auxtime=vertcat(SelectedDataRFID{:,3}); %time
Auxantenna=vertcat(SelectedDataRFID{:,4}); %antenna
Iaux=[find(strcmp(miceList(j),AuxID)==1); find(strcmp(miceListRibs(j),AuxID)==1)]; %find the identity of the respective mouse either with the ribs or head ID

%for the specific mouse
 AuxIDn=AuxID(Iaux);
 Auxtimen=Auxtime(Iaux);
 Auxantennan=Auxantenna(Iaux);
 
  %search the similar time points for each frame in the csv file
  d=knnsearch(datenum(Auxtimen,'HH:MM:SS.FFF'),datenum(CSVFile{2},'HH:MM:SS.FFF'));


   %save rfid data in a mouse array  
    MouseArray(2:length([CSVFile{2}])+1,5,j)=strcat('''',Auxtimen(d),''''); %RFID time
    MouseArray(2:length([CSVFile{2}])+1,6,j)=Auxantennan(d); %antenna rfid

     %% ---------------------------- Treat with the time-------------------------
    Timeobj.FrameTime=[CSVFile{2}];
    Timeobj.RFIDTime=Auxtimen(d);
    
    DeltaTimeFrameRFID=abs(Timeobj.DeltaTime)*1000 ;%for getting in ms
    MouseArray(2:length([CSVFile{2}])+1,22,j)=num2cell(DeltaTimeFrameRFID);
    
    %----------------define time object for sleeping----------------------
    IsSleepingobj.TimeLapseFrameAntenna=DeltaTimeFrameRFID;
    
    %------do frame time difference----------------
    FrameTimeDif=abs(Timeobj.FrameTimeDif)*1000; %for getting in ms
     MouseArray(2:length([CSVFile{2}])+1,23,j)=num2cell(FrameTimeDif);

    %% In the case is the first csv experiment don't consider the first 10000 data since this is the phase the mice are putting in the arena
      if i==1
        I=[];
        if cell2mat(MouseArray(1,3,j))==1e6 %only if the first is million
        I=find(cell2mat(MouseArray(:,3,j))~=1e6,1,'first');
        MouseArray(1:I-1,6,j)={''};   
        end
        
    end

    %% 
  MouseArray(2:length([CSVFile{2}])+1,7,j)=AuxIDn(d); %mouse id

  %%  %% ----------Find is sleeping-------------------------
      IsSleepingobj.CoordinateX=MouseArray(:,3,j);
      IsSleepingobj.CoordinateY=MouseArray(:,4,j);
      IsSleepingobj.AntennaNumber=Auxantennan(d);
      MouseArray(2:length([CSVFile{2}])+1,8,j)=num2cell(IsSleepingobj.IsSleepingCorrections(IsSleepingobj.IsSleeping));
      
     SleepingInterval=IsSleepingobj.IsSleepingInterval(IsSleepingobj.IsSleepingCorrections(IsSleepingobj.IsSleeping)); %sleeping interval
     SleepingBeg= SleepingInterval(:,1);
     SleepingEnd=SleepingInterval(:,2);
     MouseArray(2:length(SleepingBeg)+1,17,j)=num2cell(SleepingBeg);
     MouseArray(2:length(SleepingEnd)+1,18,j)=num2cell(SleepingEnd);
     
     
     %find the number of the sleeping cage
     MouseArray(2:length([CSVFile{2}])+1,9,j)=num2cell(IsSleepingobj.IsSleepingCage(SleepingInterval));
     
     %arrange coordinates for sleeping
     MouseArray(2:length([CSVFile{2}])+1,13:14,j)=num2cell(IsSleepingobj.IsSleepingCoord(SleepingInterval,IsSleepingobj.IsSleepingCage(SleepingInterval)));
     %% 
       %%-------------------------------- Find is hiding---------------------------------------- 
      IsHidingobj.CoordinateX=MouseArray(:,13,j);%use the coordinates after the correction of sleeping
      IsHidingobj.CoordinateY=MouseArray(:,14,j);
      IsHidingobj.AntennaNumber=Auxantennan(d);
      MouseArray(2:length([CSVFile{2}])+1,10,j)=num2cell(IsHidingobj.IsHiding);     
       
       %find hiding interval
       
     HidingInterval=IsHidingobj.IsHidingInterval(IsHidingobj.IsHiding); %sleeping interval
     HidingBeg= HidingInterval(:,1);
     HidingEnd=HidingInterval(:,2);
     MouseArray(2:length(HidingBeg)+1,19,j)=num2cell(HidingBeg);
     MouseArray(2:length(HidingEnd)+1,20,j)=num2cell(HidingEnd);
       
     %find the number of the hiding box
     MouseArray(2:length([CSVFile{2}])+1,11,j)=num2cell(IsHidingobj.IsHidingCage(HidingInterval));  
       
      %arrange coordinates for hiding
     MouseArray(2:length([CSVFile{2}])+1,15:16,j)=num2cell(IsHidingobj.IsHidingCoord(HidingInterval,IsHidingobj.IsHidingCage(HidingInterval))); 
     %% %% 
     %-----------------------------Find is in the arena-------------------------------------
    %find the interval for in arena
     InArenaobj.IsSleeping=MouseArray(:,8,j);
     InArenaobj.IsHiding=MouseArray(:,10,j);
     InArenaobj.AntennaNumber=Auxantennan(d);
     
     MouseArray(2:length([CSVFile{2}])+1,12,j)=num2cell(InArenaobj.InArena);  
    
     %% Addition number of frame
     MouseArray(2:length([CSVFile{2}])+1,21,j)=num2cell([0:length([CSVFile{2}])-1]');
    
     %% 
    if i==1
        I=[];
        if cell2mat(MouseArray(2,3,j))==1e6 %only if the first is million
        I=find(cell2mat(MouseArray(2:length([CSVFile{2}])+1,3,j))~=1e6,1,'first');
        MouseArray(2:I-1,12,j)=num2cell(0);   
        end
        
    end
else %if the mouse doesn't exit
%   MouseArray(:,3,j)={''};
 MouseArray(:,:,j)=num2cell([0]);
end 
% 
% 
%%

   ArrayX=[ArrayX,cell2mat(MouseArray(2:length([CSVFile{2}])+1,15,j))];
   ArrayY=[ArrayY,cell2mat(MouseArray(2:length([CSVFile{2}])+1,16,j))];
   ArrayXY=[ArrayXY,cell2mat(MouseArray(2:length([CSVFile{2}])+1,15:16,j))]; 
%% 

 %Control of wait bar
 waitbar(j/length(miceList));

end
%NOTE:DECIDE IF TO SAVE THE MOUSE ARRAY MATRIX

% Results.miceList=miceList;
% Results.MouseArray=MouseArray;
%  %save(mat according the date)
 close(hbar)
 
%% -------------------Treat spetial cases-----------------------

%---------------Find repeated Frames for further use-------------------
  RepeatedFrames=CSVobj.RemoveDuplicFrame(ArrayXY);
 
 %----------------Identified in the arena duplicates and no video ---

hbar=waitbar(0,'Second part wait')

for j=1:length(miceList)
    clear InArenaNonDefined;
    clear InArenaDuplicates;
   Ind=cellfun(@(x)Find4last(x,miceList{j}(end-6:end)),CSVmiceIDs,'UniformOutput', false);
    
    if ~isempty(find(cell2mat(Ind)==1))
        
    InArenaNonDefined=InArenaobj.InArenaNonDefined(ArrayX,ArrayY,j,cell2mat(MouseArray(2:length([CSVFile{2}])+1,12,j)));
    InArenaDuplicates=InArenaobj.InArenaDuplic(ArrayX,ArrayY,j,length(miceList),cell2mat(MouseArray(2:length([CSVFile{2}])+1,12,j)));
    MouseArray(2:length([CSVFile{2}])+1,24,j)=num2cell(InArenaDuplicates);
    MouseArray(2:length([CSVFile{2}])+1,25,j)=num2cell(InArenaNonDefined);
    
      %% ---------------- Calculate velocity -----------------
    InArenaVelocity=InArenaobj.InArenaVelocity(RepeatedFrames,ArrayX(:,j),ArrayY(:,j), (cell2mat(MouseArray(2:length([CSVFile{2}])+1,23,j))));
    MouseArray(2:length([CSVFile{2}])+1,26,j)=num2cell(InArenaVelocity); 
     %% -------------------Calculate distance to antenna-------------------------------
     InArenaAntennaDistance=InArenaobj.InArenaAntennaDistance(ArrayX(:,j),ArrayY(:,j),InArenaDuplicates,MouseArray(2:length([CSVFile{2}])+1,6,j));
     MouseArray(2:length([CSVFile{2}])+1,27,j)=num2cell( InArenaAntennaDistance); 
     
       %% ------------------------Correct the coordinates-----------------------------------
    
    InArenaCorrectedCoord=InArenaobj.InArenaCorrectedCoord(ArrayX(:,j),ArrayY(:,j),RepeatedFrames, InArenaAntennaDistance,InArenaDuplicates,InArenaNonDefined,cell2mat(MouseArray(2:length([CSVFile{2}])+1,22,j)),MouseArray(2:length([CSVFile{2}])+1,6,j));
    MouseArray(2:length([CSVFile{2}])+1,28,j)=num2cell(InArenaCorrectedCoord(:,1));
    MouseArray(2:length([CSVFile{2}])+1,29,j)=num2cell(InArenaCorrectedCoord(:,2));
    
    %% ---------------------------------Interpolate the coordinates-------------------------------
        TimeFrame=cell2mat(MouseArray(2:length([CSVFile{2}])+1,23,j));
       InArenaInterpolation=InArenaobj.InArenaInterpolation(RepeatedFrames,TimeFrame,InArenaCorrectedCoord(:,1),InArenaCorrectedCoord(:,2));
    
        MouseArray(2:length([CSVFile{2}])+1,30,j)=num2cell(InArenaInterpolation(:,1));
        MouseArray(2:length([CSVFile{2}])+1,31,j)=num2cell(InArenaInterpolation(:,2));
        %% -----------------------------------Return repeated coordinates-------------------------------------------
        InArenaAddRepeats=InArenaobj.InArenaAddRepeats(RepeatedFrames,InArenaInterpolation(:,1),InArenaInterpolation(:,2));
         MouseArray(2:length([CSVFile{2}])+1,32,j)=num2cell(InArenaAddRepeats(:,1));
        MouseArray(2:length([CSVFile{2}])+1,33,j)=num2cell(InArenaAddRepeats(:,2));
        
    %% -------------------------------------------------In Arena velocity with approximate real time -----------------------------
    RealTime=78; %Real time is 78ms
     InArenaVelocityR=InArenaobj.InArenaVelocityR(RepeatedFrames,InArenaAddRepeats(:,1),InArenaAddRepeats(:,2),RealTime);
     MouseArray(2:length([CSVFile{2}])+1,34,j)=num2cell(InArenaVelocityR); 
    
    %% -------------------------for further use create 2 auxiliary arrays----------------------
    InArenaAuxiliary=InArenaobj.InArenaAuxiliary(RepeatedFrames,InArenaAddRepeats(:,1),InArenaAddRepeats(:,2));
    Distance(:,j)=InArenaAuxiliary(:,1);
    VectorX(:,j)=InArenaAuxiliary(:,2);
    VectorY(:,j)=InArenaAuxiliary(:,3);
    
    %% 
    
    else %if the mouse doesn't exit
 MouseArray(:,:,j)=num2cell([0]);
 
end 
% 
 
     waitbar(j/length(miceList));
      
end
 close(hbar)
%% ---------------------Save the locomotion parameters as a structure bring  all the mice together----------------------
Locomotion.miceList=miceList;
Large=length(MouseArray(:,12,1));
Locomotion.isInArena=reshape(cell2mat(MouseArray(2:Large,12,:)),Large-1,length(miceList));
Locomotion.TrajectoryX=reshape(cell2mat(MouseArray(2:Large,32,:)),Large-1,length(miceList)); %coord after corrections with repeats
Locomotion.TrajectoryY=reshape(cell2mat(MouseArray(2:Large,33,:)),Large-1,length(miceList));  %coord after corrections with repeats
Locomotion.Velocity=reshape(cell2mat(MouseArray(2:Large,34,:)),Large-1,length(miceList)); %velocity of the real frames
Locomotion.RepeatedFrames=RepeatedFrames;
Locomotion.ExperimentalTime=MouseArray(2:Large,2,1); %take only one mouse since it is the same time for everything.
Locomotion.VectorX=VectorX; %without repeats
Locomotion.VectorY=VectorY; %without repeats
Locomotion.Distance=Distance;%without repeats

%% -------------------------------Calculating chasing-----------------------------

%---------Create chasing object-------------------

Chasingobj=Chasing;
Chasingobj.numOfMice=length(Locomotion.miceList);
Chasingobj.Dist_tresh1=300;
Chasingobj.Velocity_Tresh=0.5;
Chasingobj.PathTresh=600;
Chasingobj.Dist_tresh2=200;


%-------------------------

TrajectoryX=Locomotion.TrajectoryX(Locomotion.RepeatedFrames,:);
TrajectoryY=Locomotion.TrajectoryY(Locomotion.RepeatedFrames,:);
ChasingCal=Chasingobj.ChasingCal(TrajectoryX,TrajectoryY,Locomotion.Velocity(Locomotion.RepeatedFrames,:),Locomotion.isInArena(Locomotion.RepeatedFrames,:),Locomotion.VectorX,Locomotion.VectorY,Locomotion.Distance,Locomotion.ExperimentalTime(Locomotion.RepeatedFrames,:));

Locomotion.ChasingAll=ChasingCal(:,1:Chasingobj.numOfMice);
Locomotion.ChasedAll=ChasingCal(:,Chasingobj.numOfMice+1:2*Chasingobj.numOfMice);
Locomotion.MoveTogether=ChasingCal(:,2*Chasingobj.numOfMice+1:3*Chasingobj.numOfMice);
Locomotion.TimeWithoutRepeats=Locomotion.ExperimentalTime(Locomotion.RepeatedFrames,:);



hhh=msgbox('Chasing analysis finish')
close(hhh)
%% %------------Save as a mat file---------------------------
Namef=char(ListFiles(i).name);
filename1=strcat(Namef(1:end-4),'.mat');
FinalDir=mkdir(strcat(Params.SaveDirectory,'\','Results',Params.exp_name))
filename1=strcat(Params.SaveDirectory,'\',filename1);

save(filename1,'Locomotion');


 

 close(hn)
 
end
msgbox('Finish all')

%%
%END MULTIPLE FILES
%%BEGIN FOR SELECTED FILES 
%% 
%% 

case 1 %take single files from the list for further analysis
    
index_selected = get(h.listAllRFID,'Value');  %Select the csv files to work
list = cellstr(get(h.listAllRFID,'String'));
item_selected = list(index_selected,1); % Convert from cell array to string
nCSV=length(item_selected);

for i=1:nCSV %loop over the original files

clear MouseArray ;  
CSVFile=CSVobj.ReadFilesAllCSV(CSVobj.ListFiles,index_selected(i));%Use Files Treat to read this file
CSVmiceIDs=CSVobj.miceIDs(CSVobj.ListFiles,index_selected(i));

%%-------- According to date select RFDI----------------
 IndexFilesDates=findRFIDSubset(item_selected(i),DateFiles);

SelectedDataRFID=RFIDobj.ReadFilesAllDate(RFIDobj.ListFiles,IndexFilesDates);

%% Create a wait bar for control
hbar = waitbar(0,'Please wait...');

% Rearrange the data according to the mice in a multidimensional array

for j=1:length(miceList) %for each mouse
    %% Clear the variables
    clear AuxID
    clear Auxtime
    clear Auxantenna
    clear Iaux
    clear AuxIDn
    clear Auxtimen
    clear Auxantennan
    
    %% 

%ONLY CONSIDER THE LAST NUMBERS SINCE SOMETIMES THE INITIAL ZERO DISSAPEAR

Ind=cellfun(@(x)Find4last(x,miceList{j}(end-6:end)),CSVmiceIDs,'UniformOutput', false);

MouseArray(2:length([CSVFile{1}])+1,1,j)=CSVFile{1}; %for date
MouseArray(2:length([CSVFile{2}])+1,2,j)=strcat('''',[CSVFile{2}],''''); %for time

if ~isempty(find(cell2mat(Ind)==1))
MouseArray(2:length([CSVFile{2}])+1,3,j)=num2cell(CSVFile{3+(find(cell2mat(Ind)==1)-1)*3}); %for x
MouseArray(2:length([CSVFile{2}])+1,4,j)=num2cell(CSVFile{4+(find(cell2mat(Ind)==1)-1)*3}); %for y

%% --------Found in the RFID selected data the mouse with 2 identities--
AuxID=vertcat(SelectedDataRFID{:,1});%identity
Auxtime=vertcat(SelectedDataRFID{:,3}); %time
Auxantenna=vertcat(SelectedDataRFID{:,4}); %antenna
Iaux=[find(strcmp(miceList(j),AuxID)==1); find(strcmp(miceListRibs(j),AuxID)==1)]; %find the identity of the respective mouse either with the ribs or head ID

%for the specific mouse
 AuxIDn=AuxID(Iaux);
 Auxtimen=Auxtime(Iaux);
 Auxantennan=Auxantenna(Iaux);
 
 %search the similar time points for each frame in the csv file
  d=knnsearch(datenum(Auxtimen,'HH:MM:SS.FFF'),datenum(CSVFile{2},'HH:MM:SS.FFF'));
  
  %save rfid data in a mouse array  
    MouseArray(2:length([CSVFile{2}])+1,5,j)=strcat('''',Auxtimen(d),''''); %RFID time
    MouseArray(2:length([CSVFile{2}])+1,6,j)=Auxantennan(d); %antenna rfid
    
    %% ---------------------------- Treat with the time-------------------------
    Timeobj.FrameTime=[CSVFile{2}];
    Timeobj.RFIDTime=Auxtimen(d);
    
    DeltaTimeFrameRFID=abs(Timeobj.DeltaTime)*1000 ;%for getting in ms
    MouseArray(2:length([CSVFile{2}])+1,22,j)=num2cell(DeltaTimeFrameRFID);
    
    %----------------define time object for sleeping----------------------
    IsSleepingobj.TimeLapseFrameAntenna=DeltaTimeFrameRFID;
    
    %------do frame time difference----------------
    FrameTimeDif=abs(Timeobj.FrameTimeDif)*1000; %for getting in ms
     MouseArray(2:length([CSVFile{2}])+1,23,j)=num2cell(FrameTimeDif);
    
    
    %% In the case is the first csv experiment don't consider the first 10000 data since this is the phase the mice are putting in the arena
    if index_selected==1
        I=[];
        if cell2mat(MouseArray(1,3,j))==1e6 %only if the first is million
        I=find(cell2mat(MouseArray(:,3,j))~=1e6,1,'first');
        MouseArray(1:I-1,6,j)={''};   
        end
        
    end
    
    %% 
    
    
    MouseArray(2:length([CSVFile{2}])+1,7,j)=AuxIDn(d); %mouse id
    
    %% ----------Find is sleeping-------------------------
      IsSleepingobj.CoordinateX=MouseArray(:,3,j);
      IsSleepingobj.CoordinateY=MouseArray(:,4,j);
      IsSleepingobj.AntennaNumber=Auxantennan(d);
      MouseArray(2:length([CSVFile{2}])+1,8,j)=num2cell(IsSleepingobj.IsSleepingCorrections(IsSleepingobj.IsSleeping));
      
     SleepingInterval=IsSleepingobj.IsSleepingInterval(IsSleepingobj.IsSleepingCorrections(IsSleepingobj.IsSleeping)); %sleeping interval
     SleepingBeg= SleepingInterval(:,1);
     SleepingEnd=SleepingInterval(:,2);
     MouseArray(2:length(SleepingBeg)+1,17,j)=num2cell(SleepingBeg);
     MouseArray(2:length(SleepingEnd)+1,18,j)=num2cell(SleepingEnd);
     
     
     %find the number of the sleeping cage
     MouseArray(2:length([CSVFile{2}])+1,9,j)=num2cell(IsSleepingobj.IsSleepingCage(SleepingInterval));
     
     %arrange coordinates for sleeping
     MouseArray(2:length([CSVFile{2}])+1,13:14,j)=num2cell(IsSleepingobj.IsSleepingCoord(SleepingInterval,IsSleepingobj.IsSleepingCage(SleepingInterval)));

     %% 
       %%-------------------------------- Find is hiding---------------------------------------- 
      IsHidingobj.CoordinateX=MouseArray(:,13,j);%use the coordinates after the correction of sleeping
      IsHidingobj.CoordinateY=MouseArray(:,14,j);
      IsHidingobj.AntennaNumber=Auxantennan(d);
      MouseArray(2:length([CSVFile{2}])+1,10,j)=num2cell(IsHidingobj.IsHiding);     
       
       %find hiding interval
       
     HidingInterval=IsHidingobj.IsHidingInterval(IsHidingobj.IsHiding); %sleeping interval
     HidingBeg= HidingInterval(:,1);
     HidingEnd=HidingInterval(:,2);
     MouseArray(2:length(HidingBeg)+1,19,j)=num2cell(HidingBeg);
     MouseArray(2:length(HidingEnd)+1,20,j)=num2cell(HidingEnd);
       
     %find the number of the hiding box
     MouseArray(2:length([CSVFile{2}])+1,11,j)=num2cell(IsHidingobj.IsHidingCage(HidingInterval));  
       
      %arrange coordinates for hiding
     MouseArray(2:length([CSVFile{2}])+1,15:16,j)=num2cell(IsHidingobj.IsHidingCoord(HidingInterval,IsHidingobj.IsHidingCage(HidingInterval))); 
     %% 
     %-----------------------------Find is in the arena-------------------------------------
    %find the interval for in arena
     InArenaobj.IsSleeping=MouseArray(:,8,j);
     InArenaobj.IsHiding=MouseArray(:,10,j);
     InArenaobj.AntennaNumber=Auxantennan(d);
     
     MouseArray(2:length([CSVFile{2}])+1,12,j)=num2cell(InArenaobj.InArena);  
     
     
     %% Addition number of frame
     MouseArray(2:length([CSVFile{2}])+1,21,j)=num2cell([0:length([CSVFile{2}])-1]');
    
     %%     %% In the case is the first csv experiment don't consider the first 10000 data since this is the phase the mice are putting in the arena
    if index_selected==1
        I=[];
        if cell2mat(MouseArray(2,3,j))==1e6 %only if the first is million
        I=find(cell2mat(MouseArray(2:length([CSVFile{2}])+1,3,j))~=1e6,1,'first');
        MouseArray(2:I-1,12,j)=num2cell(0);   
        end
        
    end
    
else %if the mouse doesn't exit
  %MouseArray(:,3,j)={''};
  MouseArray(:,:,j)={'0'};
end    

%% ------------------ Save to excel file---------------------------------
% Titles

MouseArray(1,1,j)={'Experiment Date'};
MouseArray(1,2,j)={'Experiment Time'};
MouseArray(1,3,j)={'Original x coord.'};
MouseArray(1,4,j)={'Original y coord.'};
MouseArray(1,5,j)={'RFID Time'};
MouseArray(1,6,j)={'Number RFID antenna'};
MouseArray(1,7,j)={'RFID mouse identity'};
MouseArray(1,8,j)={'Is Sleeping'};
MouseArray(1,9,j)={'Sleeping Box'};
MouseArray(1,10,j)={'Is Hiding'};
MouseArray(1,11,j)={'Hiding Box'};
MouseArray(1,12,j)={'In Arena'};
MouseArray(1,13,j)={'Coord x with Sleeping'};
MouseArray(1,14,j)={'Coord y with Sleeping'};
MouseArray(1,15,j)={'Coord x with Hiding/Sleeping'};
MouseArray(1,16,j)={'Coord y with Hiding/Sleeping'};
MouseArray(1,17,j)={'Beg.Int.Sleeping'};
MouseArray(1,18,j)={'End Int.Sleeping'};
MouseArray(1,19,j)={'Beg.Int.Hiding'};
MouseArray(1,20,j)={'End.Int.Hiding'};
MouseArray(1,21,j)={'Number of video frame'};
MouseArray(1,22,j)={'Elapsed time between Frame and RFID (msec)'};
MouseArray(1,23,j)={'Elapsed time between frames (msec)'};
MouseArray(1,24,j)={'Duplicates in coord. at arena'};
MouseArray(1,25,j)={'Non defined coord. at arena'};
MouseArray(1,26,j)={'Velocity without repeats in (cm/sec)'};
MouseArray(1,27,j)={'Distance from antenna for duplicates (mm)'};
MouseArray(1,28,j)={'X corrected coord.'};
MouseArray(1,29,j)={'Y corrected coord.'};
MouseArray(1,30,j)={'X interpolated coord.'};
MouseArray(1,31,j)={'Y interpolated coord.'};
MouseArray(1,32,j)={'X interpolated coord. with repeats'};
MouseArray(1,33,j)={'Y interpolated coord. with repeats'};
MouseArray(1,34,j)={'In Arena velocity with real time between frames'};

% 
%%

   ArrayX=[ArrayX,cell2mat(MouseArray(2:length([CSVFile{2}])+1,15,j))];
   ArrayY=[ArrayY,cell2mat(MouseArray(2:length([CSVFile{2}])+1,16,j))];
   ArrayXY=[ArrayXY,cell2mat(MouseArray(2:length([CSVFile{2}])+1,15:16,j))];

%% 

%  sheet=char(miceList(j));
%  Namef=char(item_selected(i));
%  filename=strcat(Namef(1:end-4),'LocomotionResults','.xlsx');
%  filename=strrep(filename,'[','(');
%   filename=strrep(filename,']',')');
%   filename=strcat(Params.SaveDirectory,'\',filename);
%  xlswrite(filename,MouseArray(:,:,j),sheet);

 %Control of wait bar
 waitbar(j/length(miceList));
end
close(hbar)
%% -------------------Treat spetial cases-----------------------

%---------------Find repeated Frames for further use-------------------

% RepeatedFrames=CSVobj.RemoveDuplicFrame([CSVFile{3:end}]);
  RepeatedFrames=CSVobj.RemoveDuplicFrame(ArrayXY);
  
%----------------Identified in the arena duplicates and no video ---

hbar=waitbar(0,'Second part wait')
for j=1:length(miceList)
    clear InArenaNonDefined;
    clear InArenaDuplicates;
 
     Ind=cellfun(@(x)Find4last(x,miceList{j}(end-6:end)),CSVmiceIDs,'UniformOutput', false);
    
    if ~isempty(find(cell2mat(Ind)==1))
    
      if ~isempty(find(cell2mat( MouseArray(2:length([CSVFile{2}])+1,12,j))==1)) 
        InArenaNonDefined=InArenaobj.InArenaNonDefined(ArrayX,ArrayY,j,cell2mat(MouseArray(2:length([CSVFile{2}])+1,12,j)));
        InArenaDuplicates=InArenaobj.InArenaDuplic(ArrayX,ArrayY,j,length(miceList),cell2mat(MouseArray(2:length([CSVFile{2}])+1,12,j)));
        %InArenaDuplicates=InArenaobj.InArenaDuplic(ArrayX,ArrayY,j,length( CSVmiceIDs),cell2mat(MouseArray(2:length([CSVFile{2}])+1,12,j)));
        MouseArray(2:length([CSVFile{2}])+1,24,j)=num2cell(InArenaDuplicates);
        MouseArray(2:length([CSVFile{2}])+1,25,j)=num2cell(InArenaNonDefined);
      else
          
        MouseArray(2:length([CSVFile{2}])+1,24,j)=num2cell(0);%for cases it is inside the cage all along the file
        MouseArray(2:length([CSVFile{2}])+1,25,j)=num2cell(0); 
          
      end
    
    
    %% ---------------- Calculate velocity -----------------
       if ~isempty(find(cell2mat( MouseArray(2:length([CSVFile{2}])+1,12,j))==1)) 
          InArenaVelocity=InArenaobj.InArenaVelocity(RepeatedFrames,ArrayX(:,j),ArrayY(:,j), (cell2mat(MouseArray(2:length([CSVFile{2}])+1,23,j))));
          MouseArray(2:length([CSVFile{2}])+1,26,j)=num2cell(InArenaVelocity); 
       else
          MouseArray(2:length([CSVFile{2}])+1,26,j)=num2cell(0); %for cases it is inside the cage all along the file
       end    
 
    %% -------------------Calculate distance to antenna-------------------------------
%     InArena.AntennaNumber= MouseArray(2:length([CSVFile{2}])+1,6,j);
       if ~isempty(find(cell2mat( MouseArray(2:length([CSVFile{2}])+1,12,j))==1)) 
         InArenaAntennaDistance=InArenaobj.InArenaAntennaDistance(ArrayX(:,j),ArrayY(:,j),InArenaDuplicates,MouseArray(2:length([CSVFile{2}])+1,6,j));
         MouseArray(2:length([CSVFile{2}])+1,27,j)=num2cell( InArenaAntennaDistance); 
       else
           
          MouseArray(2:length([CSVFile{2}])+1,27,j)=num2cell(0); %for cases it is inside the cage all along the file   
           
       end
    %% ------------------------Correct the coordinates-----------------------------------
      if ~isempty(find(cell2mat( MouseArray(2:length([CSVFile{2}])+1,12,j))==1)) 
           InArenaCorrectedCoord=InArenaobj.InArenaCorrectedCoord(ArrayX(:,j),ArrayY(:,j),RepeatedFrames, InArenaAntennaDistance,InArenaDuplicates,InArenaNonDefined,cell2mat(MouseArray(2:length([CSVFile{2}])+1,22,j)),MouseArray(2:length([CSVFile{2}])+1,6,j));
           MouseArray(2:length([CSVFile{2}])+1,28,j)=num2cell(InArenaCorrectedCoord(:,1));
           MouseArray(2:length([CSVFile{2}])+1,29,j)=num2cell(InArenaCorrectedCoord(:,2));
      else
           MouseArray(2:length([CSVFile{2}])+1,28,j)=MouseArray(2:length([CSVFile{2}])+1,15,j);
           MouseArray(2:length([CSVFile{2}])+1,29,j)=MouseArray(2:length([CSVFile{2}])+1,16,j);%for cases it is inside the cage all along the file
      end
    %% ---------------------------------Interpolate the coordinates-------------------------------
        TimeFrame=cell2mat(MouseArray(2:length([CSVFile{2}])+1,23,j));
        if ~isempty(find(cell2mat( MouseArray(2:length([CSVFile{2}])+1,12,j))==1)) 
          InArenaInterpolation=InArenaobj.InArenaInterpolation(RepeatedFrames,TimeFrame,InArenaCorrectedCoord(:,1),InArenaCorrectedCoord(:,2));
          MouseArray(2:length([CSVFile{2}])+1,30,j)=num2cell(InArenaInterpolation(:,1));
          MouseArray(2:length([CSVFile{2}])+1,31,j)=num2cell(InArenaInterpolation(:,2));
        else 
           MouseArray(2:length([CSVFile{2}])+1,30,j)=MouseArray(2:length([CSVFile{2}])+1,15,j);
           MouseArray(2:length([CSVFile{2}])+1,31,j)=MouseArray(2:length([CSVFile{2}])+1,16,j); %for cases it is inside the cage all along the file
        end
        %% -----------------------------------Return repeated coordinates-------------------------------------------
        if ~isempty(find(cell2mat( MouseArray(2:length([CSVFile{2}])+1,12,j))==1))
            InArenaAddRepeats=InArenaobj.InArenaAddRepeats(RepeatedFrames,InArenaInterpolation(:,1),InArenaInterpolation(:,2));
            MouseArray(2:length([CSVFile{2}])+1,32,j)=num2cell(InArenaAddRepeats(:,1));
            MouseArray(2:length([CSVFile{2}])+1,33,j)=num2cell(InArenaAddRepeats(:,2));
        else
             MouseArray(2:length([CSVFile{2}])+1,32,j)=MouseArray(2:length([CSVFile{2}])+1,15,j);
             MouseArray(2:length([CSVFile{2}])+1,33,j)=MouseArray(2:length([CSVFile{2}])+1,16,j); %for cases it is inside the cage all along the file
        end    
        
    %% -------------------------------------------------In Arena velocity with approximate real time -----------------------------
        RealTime=78; %Real time is 78ms
       if ~isempty(find(cell2mat( MouseArray(2:length([CSVFile{2}])+1,12,j))==1)) 
        InArenaVelocityR=InArenaobj.InArenaVelocityR(RepeatedFrames,InArenaAddRepeats(:,1),InArenaAddRepeats(:,2),RealTime);
        MouseArray(2:length([CSVFile{2}])+1,34,j)=num2cell(InArenaVelocityR);
       else
          MouseArray(2:length([CSVFile{2}])+1,34,j)=num2cell(0);  %for cases it is inside the cage all along the file
       end   
    
    %% -------------------------for further use create 2 auxiliary arrays----------------------
        if ~isempty(find(cell2mat( MouseArray(2:length([CSVFile{2}])+1,12,j))==1)) 
         InArenaAuxiliary=InArenaobj.InArenaAuxiliary(RepeatedFrames,InArenaAddRepeats(:,1),InArenaAddRepeats(:,2));
         Distance(:,j)=InArenaAuxiliary(:,1);
         VectorX(:,j)=InArenaAuxiliary(:,2);
         VectorY(:,j)=InArenaAuxiliary(:,3);
        else
           Distance(:,j)=0; %in the case it is inside all the time
           VectorX(:,j)=0;
           VectorY(:,j)=0;
            
        end
        
    %% 
    
 sheet=char(miceList(j));
 Namef=char(item_selected(i));
 filename=strcat(Namef(1:end-4),'LocomotionResults','.xlsx');
 filename=strrep(filename,'[','(');
  filename=strrep(filename,']',')');
  filename=strcat(Params.SaveDirectory,'\',filename);
 xlswrite(filename,MouseArray(:,:,j),sheet);
     else %if the mouse doesn't exit
  MouseArray(:,:,j)=num2cell([0]);
 
end 
 waitbar(j/length(miceList));
end
%% ---------------------Save the locomotion parameters as a structure bring  all the mice together----------------------
Locomotion.miceList=miceList;
Large=length(MouseArray(:,12,1));
Locomotion.isInArena=reshape(cell2mat(MouseArray(2:Large,12,:)),Large-1,length(miceList));
Locomotion.TrajectoryX=reshape(cell2mat(MouseArray(2:Large,32,:)),Large-1,length(miceList)); %coord after corrections with repeats
Locomotion.TrajectoryY=reshape(cell2mat(MouseArray(2:Large,33,:)),Large-1,length(miceList));  %coord after corrections with repeats
Locomotion.Velocity=reshape(cell2mat(MouseArray(2:Large,34,:)),Large-1,length(miceList)); %velocity of the real frames
Locomotion.RepeatedFrames=RepeatedFrames;
Locomotion.ExperimentalTime=MouseArray(2:Large,2,1); %take only one mouse since it is the same time for everything.
Locomotion.VectorX=VectorX; %without repeats
Locomotion.VectorY=VectorY; %without repeats
Locomotion.Distance=Distance;%without repeats


%------------Save as a mat file---------------------------
filename1=strcat(Namef(1:end-4),'.mat');
filename1=strcat(Params.SaveDirectory,'\',filename1);

save(filename1,'Locomotion')

%% -------------------------------Calculating chasing-----------------------------

%---------Create chasing object-------------------

Chasingobj=Chasing;
Chasingobj.numOfMice=length(Locomotion.miceList);
Chasingobj.Dist_tresh1=300;
Chasingobj.Velocity_Tresh=0.5;
Chasingobj.PathTresh=600;
Chasingobj.Dist_tresh2=200;


%-------------------------

TrajectoryX=Locomotion.TrajectoryX(Locomotion.RepeatedFrames,:);
TrajectoryY=Locomotion.TrajectoryY(Locomotion.RepeatedFrames,:);
ChasingCal=Chasingobj.ChasingCal(TrajectoryX,TrajectoryY,Locomotion.Velocity(Locomotion.RepeatedFrames,:),Locomotion.isInArena(Locomotion.RepeatedFrames,:),Locomotion.VectorX,Locomotion.VectorY,Locomotion.Distance,Locomotion.ExperimentalTime(Locomotion.RepeatedFrames,:))

Locomotion.ChasingAll=ChasingCal(:,1:Chasingobj.numOfMice);
Locomotion.ChasedAll=ChasingCal(:,Chasingobj.numOfMice+1:2*Chasingobj.numOfMice);
Locomotion.MoveTogether=ChasingCal(:,2*Chasingobj.numOfMice+1:3*Chasingobj.numOfMice);
Locomotion.TimeWithoutRepeats=Locomotion.ExperimentalTime(Locomotion.RepeatedFrames,:);



msgbox('Chasing analysis finish')


%% %------------Save as a mat file---------------------------
filename1=strcat(Namef(1:end-4),'.mat');
filename1=strcat(Params.SaveDirectory,'\',filename1);

save(filename1,'Locomotion');


%% 

 
msgbox('Finish')

%% 
end



%Results.miceList=miceList;
%Results.MouseArray=MouseArray;
 %save(mat according the date)



end
close(hbar)

end


%% 


%% %% Auxiliary functions

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
