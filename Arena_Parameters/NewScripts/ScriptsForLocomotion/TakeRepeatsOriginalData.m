function [DataMouse DataMouseWithoutD,DataAllMouse,DataAllMouseWithFrame]=TakeRepeatsOriginalData(cr_fname,MouseSelected) %Data include the original list without velocities and repeats, with first column represents the number of frame in the original data.
%% Initial parameters
global Params
%%
Iaux=strfind(cr_fname,'\');
filesNames=cr_fname(Iaux(length(Iaux))+1:end);

%----------------------------------------------------------------------------------------------------------
%     load data csv file
%----------------------------------------------------------------------------------------------------------


% cr_fname='D:\MiceApplication\NewScripts\18.5.2016 - 17.00.00.032(Camera-2)[17.30.00.042-18.00.00.042].csv';
% filesNames='18.5.2016 - 17.00.00.032(Camera-2)[17.30.00.042-18.00.00.042].csv';
% Params.NoDetection=1e6;
% Params.FPS=30;
%% 

%Open csv  files to get data

fid=fopen(cr_fname,'r'); %fopen([Params.fileDetails.Dir '/' filesNames],'r');
header=fgets(fid);%GET FIRST HEADER
numOfMice=length(strfind(header,'000')); %THIS COULD BE A PROBLEM IF THE 000 DISSAPEAR!!!!
FORMAT1=[];
FORMAT2=[];

for i=1:numOfMice*3+2 %For each mouse x, y and velocity.The first 2 columns are the date and the time.
    FORMAT1 = [FORMAT1 ' %s'];
    if i>2
        FORMAT2 = [FORMAT2 ' %f'];
    else
        FORMAT2= [FORMAT2 ' %s'];
    end
end
header = textscan(header,FORMAT1,'delimiter', ',','EmptyValue', NaN);%GETS XY VELO

%% 

for i=1:numOfMice %COULD BRING DATA NUM OF MICE FROM PARAMS!!!!!!!!!
    miceIDs(i)=header{3*i+1};
end
header=fgets(fid);

num = textscan(fid,FORMAT2,'delimiter', ',','EmptyValue', NaN); %data values
fclose(fid); 
%end
%%
%Get all the data in mm
positionMat=getTracksGVver2(num); % xy coordinates + velocity (in mm)

%%
%%Create the time lapse by using the initial time the fps and the second
%%date num value
%REMEMBER THAT THE TIMELINE IS UNIFORM!!!!!!!!!!!!!!

second=datenum('00/00/0000;00:00:01.000','dd/mm/yyyy;HH:MM:SS.FFF')-datenum('00/00/0000;00:00:00.000','dd/mm/yyyy;HH:MM:SS.FFF');
%calculate how much is 1 sec
frametime=(((second/Params.FPS))); %time of one frame
%frametime=(round((1/Params.FPS)*1000))/1000; %time of one frame
i1=strfind(filesNames,'[');i2=strfind(filesNames,'-');
FirstFrameTimeString=filesNames(i1+1:i2(end)-1);%indicates when begin the measurement
i1=strfind(FirstFrameTimeString,'.');
FirstFrameTimeString(i1(1:2))=':';
FirstFrameTimeString=strcat(num{1}(1),';',FirstFrameTimeString);
FirstFrameTimeNum=datenum(FirstFrameTimeString,'dd/mm/yyyy;HH:MM:SS.FFF'); %convert all in date num
timeLine=FirstFrameTimeNum*ones(length(positionMat),1);
frametime=[0;frametime*ones(length(positionMat)-1,1)];
frametime=cumsum(frametime);
timeLine=timeLine+frametime;
%% Take only the coordinates-reject velocities
for i=1:3:numOfMice*3-1
    if i==1
CoordData=positionMat(:,[i i+1]);
    else
        CoordData=[CoordData positionMat(:,[i i+1])];
    end
end

%% Find which mouse is your selection
NumberOfMouse=find(strcmp(miceIDs,char(MouseSelected))==1);
%% 
%Remove duplicates
[CoorDataWithouD,frames,ic]=unique(CoordData,'rows','stable');
CoorDataWithouD(CoorDataWithouD>=Params.NoDetection)=NaN;
Data=[frames CoorDataWithouD];
%% Data includes all the mice- select the data you need.
DataMouseWithoutD=[frames CoorDataWithouD(:,2*(NumberOfMouse-1)+1:2*(NumberOfMouse-1)+2)];
CoordData(CoordData>=Params.NoDetection)=NaN;
DataAllMouseWithFrame=CoordData;
DataMouse=[timeLine CoordData(:,2*(NumberOfMouse-1)+1:2*(NumberOfMouse-1)+2)];
%xlswrite('D:\Test_Tables\TableWithoutDuplicatesMouse2.xlsx',DataMouseWithoutD)
DataAllMouse=Data(:,2:end);




end

