

function CreateCsvData(Filename)

root_folder=cd;
%% Add path
addpath(genpath([root_folder,'/Classes/']));
%% Read params
Filename=char(Filename);
IndexAux1=strfind(Filename,'/');
load(strcat(Filename(1:IndexAux1(length(IndexAux1))),'Parameters/AdditionalParameters.mat')); %load parameters
%Create folder of results
mkdir(strcat(Filename(1:IndexAux1(length(IndexAux1))),'Results'));
Params.resultsDir=strcat(Filename(1:IndexAux1(length(IndexAux1))),'Results');
Params.Directory=Filename;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %% ---------------------------------First Part Arrange the chasing events/approaching and avoiding events into a table----------------------------

[ParamToSave AllChasing AllApproaching  AllBeAvoiding AllClose AllCloseClose]=GetEvents(Params);
%% --------------------SAVE SOCIAL EVENTS INTO EXCEL FILE-----------------



      %for chasing
        
      if ~isempty(AllChasing)
          SaveSocialData(AllChasing,Params,ParamToSave)
        end
        %for approaching
          if ~isempty(AllApproaching)
             SaveSocialDataApproaching(AllApproaching,Params)
          end
        %for be avoiding
        if ~isempty( AllBeAvoiding)
          SaveSocialDataAvoiding(AllBeAvoiding,Params)
        end
           %for be avoiding
        if ~isempty(AllClose)
            %% Remove repeated rows since each event is duplicated
            
            
            %%
            [~,index]=unique(cell2mat(AllClose(:,7:8)),'rows','stable')
            AllCloseR=AllClose(index,:);
          SaveSocialClose(AllCloseR,Params)
        end
        
            if ~isempty(AllCloseClose)
            %% Remove repeated rows since each event is duplicated
            
            
            %%
            [~,index]=unique(cell2mat(AllCloseClose(:,7:8)),'rows','stable')
            AllCloseR=AllCloseClose(index,:);
          SaveSocialCloseClose(AllCloseR,Params)
        end
        
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
   % Get elorating- and other parameters related with chasing
  % ManagerAllFiles(Chasing,Params.SaveDirectory,Params.exp_name)
          
  
end
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %% %% Auxiliary functions
% 
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



%% -----------------------Function for saving Chasing, approachin/avoiding into an excel file------------------

function SaveSocialData(Social_Data,Params,ParamToSave)

 %chasing
  %Separate the duplicates from the data and save in another sheet
  [Social_Data,DoubleData]=RemoveDuplicates(Social_Data);
  
  %% %%   %% save into a csv file in a sheet called list of all chasing events
  raw={};
  raw(1,1)={'Experiment date'};
  raw(1,2)={'Time begin event'};
  raw(1,3)={'Time end event'};
  raw(1,4)={'Chasing mouse'};
  raw(1,5)={'Chased mouse'};
  raw(1,6)={'Corrected events'};
  raw(1,7)={'Frame begin chasing'};
  raw(1,8)={'Frame finish chasing'};
  raw(1,9)={'Number of Event'};
  
 % raw(2:size(Social_Data,1)+1,1:9)=Social_Data;
  
  %% Sort the data according to the days
  
  for i=1:length(Social_Data(:,1))
      Ax=char(strrep(Social_Data(i,1),'''','')) %remove every comma
    k=strfind(Ax,'-')
    
    formatIn = 'dd.mm.yyyy';
    DateString=Ax(1:k(1)-2);
    DateNum(i)=datenum(DateString,formatIn); %this is done if there was a change in month
    
  
end
 [~,idDateSort]=sort(DateNum); 
 Social_Data=Social_Data(idDateSort,:);
 
  raw(2:size(Social_Data,1)+1,1:8)=Social_Data; 
  %% 
  
  raw(2:size(Social_Data,1)+1,9)=num2cell([1:size(Social_Data,1)]');
  
  %% For Csv
%   ExperimentDate=raw(2:end,1);
%   TimeBeginEvent=raw(2:end,2);
%   TimeEndEvent=raw(2:end,3);
%   ChasingMouse=raw(2:end,4);
%   ChasedMouse=raw(2:end,5);
%   CorrectedEvents=raw(2:end,6);
%   FrameBeginChasing=raw(2:end,7);
%   FrameFinishChasing=raw(2:end,8);
%   NumberOfEvent= raw(2:end,9);
  
  %%   
  Chasing.AllChasing=raw;
%   
  % sheet=['Chasing'];
  % xlswrite([SaveDirectory,'/',exp_name,'_','ChasingResults.xlsx'],raw,sheet)
%   save([SaveDirectory,'\',exp_name,'_','ChasingResults.mat'],raw)

% T=table(ExperimentDate,TimeBeginEvent,TimeEndEvent,ChasingMouse,ChasedMouse,CorrectedEvents,FrameBeginChasing,FrameFinishChasing,NumberOfEvent);
% writetable(T,strcat(Params.resultsDir,'/','Chasing.csv'))
cellwrite(strcat(Params.resultsDir,'/','Chasing.csv'),raw)


    %% Save in another sheet data which appear as duplicate and it is not sure
  
  raw1={};
  raw1(1,1)={'Experiment date'};
  raw1(1,2)={'Time begin event'};
  raw1(1,3)={'Time end event'};
  raw1(1,4)={'Chasing mouse'};
  raw1(1,5)={'Chased mouse'};
  raw1(1,6)={'Corrected events'};
  raw1(1,7)={'Frame begin chasing'};
  raw1(1,8)={'Frame finish chasing'};
 
  raw1(1,9)={'Number of Event'};
   
  raw1(2:size(DoubleData,1)+1,1:8)=DoubleData;
  
  raw1(2:size(DoubleData,1)+1,9)=num2cell([1:size(DoubleData,1)]');
  
%   sheet1=['ChasingNoDefinedData'];
%   xlswrite([SaveDirectory,'\',exp_name,'_','ChasingResults.xlsx'],raw1,sheet1)

  %% For Csv
%   ExperimentDate=raw1(2:end,1);
%   TimeBeginEvent=raw1(2:end,2);
%   TimeEndEvent=raw1(2:end,3);
%   ChasingMouse=raw1(2:end,4);
%   ChasedMouse=raw1(2:end,5);
%   CorrectedEvents=raw1(2:end,6);
%   FrameBeginChasing=raw1(2:end,7);
%   FrameFinishChasing=raw1(2:end,8);
%   NumberOfEvent= raw1(2:end,9);
% 
% T1=table(ExperimentDate,TimeBeginEvent,TimeEndEvent,ChasingMouse,ChasedMouse,CorrectedEvents,FrameBeginChasing,FrameFinishChasing,NumberOfEvent);
% writetable(T1,strcat(Params.resultsDir,'/','NonDefinedChasing.csv'))
cellwrite(strcat(Params.resultsDir,'/','NonDefinedChasing.csv'),raw1)
%% 


  Chasing.DoubleChasing=raw1;
  
%     %% Save in another sheet all the parameters
%   raw2={};
%  raw2(1,1)={'Angle of 1-2 with movement 1 (degree)'};
%  raw2(2,1)={'Angle of movement 1 with movement 2 (degree)'};
%  raw2(3,1)={'Minimum path done by the mouse to be considered chasing (mm)'};
%  raw2(4,1)={'Maximum distance between mice allow in a chasing event (mm)'};
%   raw2(5,1)={'Minimum velocity to be considered in a chasing event (cm/sec)'};
%   raw2(6,1)={'Maximum number of frames  between events allow to join between them'};
%    raw2(7,1)={'Maximum mice distance between events allow to join events(mm)'};
%   raw2(8,1)={'Maximum number of frames  between SMALL events allow to join between them'};
%   raw2(9,1)={'Maximum mice distance between SMALL events allow to join events (mm)'};

 raw2(1,1)={'Dist_tresh1'};
 raw2(2,1)={'Velocity_Tresh'};
 raw2(3,1)={'PathTresh'};
 raw2(4,1)={'Dist_tresh2'};
  raw2(5,1)={'AngleReference'};
  raw2(6,1)={'CorTresh'};
 
   raw2(1,2)=num2cell(ParamToSave{1,2});
   raw2(2,2)=num2cell(ParamToSave{2,2});
   raw2(3,2)=num2cell(ParamToSave{3,2});
   raw2(4,2)=num2cell(ParamToSave{4,2});
   raw2(5,2)=num2cell(ParamToSave{5,2});
   raw2(6,2)=num2cell(ParamToSave{6,2});

%   
%   raw2(1,2)=num2cell(Params.AngleMaximum1);
%   raw2(2,2)=num2cell(Params.AngleMaximum2);
%   raw2(3,2)=num2cell(Params.editpar1);
%   raw2(4,2)=num2cell(Params.editpar2);
%   raw2(5,2)=num2cell(Params.editpar3);
%   raw2(6,2)=num2cell(Params.editpar4);
%   raw2(7,2)=num2cell(Params.editpar5);
%   raw2(8,2)=num2cell(SocialObj.GapFramesS);
%   raw2(9,2)=num2cell(SocialObj.GapPathEndS);
 Parameters=raw2(:,2);
%  rowNames={'Angle of 1-2 with movement 1 (degree)';'Angle of movement 1 with movement 2 (degree)';'Minimum path done by the mouse to be considered chasing (mm)';...
%      'Maximum distance between mice allow in a chasing event (mm)';'Minimum velocity to be considered in a chasing event (cm/sec)';'Maximum number of frames  between events allow to join between them';...
%      'Maximum mice distance between events allow to join events(mm)'};
  rowNames={'Dist_tresh1';'Velocity_Tresh';'PathTresh';'Dist_tresh2';'AngleReference';'CorTresh'};
 
%   
%  sheet2=['ChasingParameters'];
%   xlswrite([SaveDirectory,'\',exp_name,'_','ChasingResults.xlsx'],raw2,sheet2)
    Chasing.ChasingParameters=raw2;
%     save([SaveDirectory,'/',exp_name,'_','ChasingResults.mat'],'Chasing')
T2=table(rowNames,Parameters);
writetable(T2,strcat(Params.resultsDir,'/','ParametersChasing.csv'))


end

%% %% -----------------------Function for saving  approaching into an excel file------------------

function SaveSocialDataAvoiding(Social_Data,Params)

 %chasing
  %Separate the duplicates from the data and save in another sheet
  %[Social_Data,DoubleData]=RemoveDuplicates(Social_Data);
  
  %% %%   %% save into an excel file in a sheet called list of all chasing events
  raw={};
  raw(1,1)={'Experiment date'};
  raw(1,2)={'Time begin event'};
  raw(1,3)={'Time end event'};
  raw(1,4)={'Be avoiding mouse'};
  raw(1,5)={'Avoiding mouse'};
  raw(1,6)={'Corrected events'};
  raw(1,7)={'Frame begin be avoiding'};
  raw(1,8)={'Frame finish avoiding'};
  raw(1,9)={'Number of Event'};
  
 % raw(2:size(Social_Data,1)+1,1:9)=Social_Data;
  
  %% Sort the data according to the days
  
  for i=1:length(Social_Data(:,1))
      Ax=char(strrep(Social_Data(i,1),'''','')); %remove every comma
    k=strfind(Ax,'-');
    
    formatIn = 'dd.mm.yyyy';
    DateString=Ax(1:k(1)-2);
    DateNum(i)=datenum(DateString,formatIn); %this is done if there was a change in month
    
  
  end
% order data according to data
 [~,idDateSort]=sort(DateNum); 
 Social_Data=Social_Data(idDateSort,:);
 
  raw(2:size(Social_Data,1)+1,1:8)=Social_Data; 
  %% 
  
  raw(2:size(Social_Data,1)+1,9)=num2cell([1:size(Social_Data,1)]');
  
    %% For Csv
%   ExperimentDate=raw(2:end,1);
%   TimeBeginEvent=raw(2:end,2);
%   TimeEndEvent=raw(2:end,3);
%   BeAvoidingMouse=raw(2:end,4);
%   AvoidingMouse=raw(2:end,5);
%   CorrectedEvents=raw(2:end,6);
%   FrameBeginBeAvoiding=raw(2:end,7);
%   FrameFinishAvoiding=raw(2:end,8);
%   NumberOfEvent= raw(2:end,9);
% 
% T4=table(ExperimentDate,TimeBeginEvent,TimeEndEvent,BeAvoidingMouse,AvoidingMouse,CorrectedEvents,FrameBeginBeAvoiding, FrameFinishAvoiding,NumberOfEvent);
% writetable(T4,strcat(Params.resultsDir,'/','Avoiding.csv'))
  
  cellwrite(strcat(Params.resultsDir,'/','Avoiding.csv'),raw)
  
  %% 
  
  
  Avoiding.Avoiding=raw;
%   sheet=['Avoiding'];
%   xlswrite([SaveDirectory,'\',exp_name,'_','AvoidingResults.xlsx'],raw,sheet)
%   

%     %% Save in another sheet all the parameters
%   raw2={};
 raw2(1,1)={'Maximum distance between mice to be considered approaching (mm)'};
 raw2(2,1)={'Approaching angle (degree)'};
 raw2(3,1)={'Velocity of the approached mouse (cm/sec)'};
 raw2(4,1)={'Velocity of the mouse approaching (cm/sec)'};
 
  raw2(1,2)=num2cell(Params.MaximumDistanceToApproach);
  raw2(2,2)=num2cell(Params.ApproachingAngle);
  raw2(3,2)=num2cell(Params.VelocityApproachedMouse);
  raw2(4,2)=num2cell(Params.Aproaching_velocity);
  Avoiding.AvoidingParameters=raw2;
%  sheet2=['AvoidingParameters'];
%   xlswrite([SaveDirectory,'\',exp_name,'_','AvoidingResults.xlsx'],raw2,sheet2)
%   save([SaveDirectory,'/',exp_name,'_','AvoidingResults.mat'],'Avoiding')
%% 
 rowNames={'Maximum distance between mice to be considered approaching (mm)';'Approaching angle (degree)';'Velocity of the approached mouse (cm/sec)';...
    'Velocity of the mouse approaching (cm/sec)'};
Parameters=raw2(:,2);
T5=table(rowNames,Parameters);
writetable(T5,strcat(Params.resultsDir,'/','ParametersAvoiding.csv'))


end

%% %% -----------------------Function for saving avoiding into an excel file------------------

function SaveSocialDataApproaching(Social_Data,Params)

 %chasing
  %Separate the duplicates from the data and save in another sheet
  %[Social_Data,DoubleData]=RemoveDuplicates(Social_Data);
  
  %% %%   %% save into an excel file in a sheet called list of all chasing events
  raw={};
  raw(1,1)={'Experiment date'};
  raw(1,2)={'Time begin event'};
  raw(1,3)={'Time end event'};
  raw(1,4)={'Approaching mouse'};
  raw(1,5)={'Approached mouse'};
  raw(1,6)={'Corrected events'};
  raw(1,7)={'Frame begin approaching'};
  raw(1,8)={'Frame finish approaching'};
  raw(1,9)={'Number of Event'};
  
 % raw(2:size(Social_Data,1)+1,1:9)=Social_Data;
  
  %% Sort the data according to the days
  
  for i=1:length(Social_Data(:,1))
      Ax=char(strrep(Social_Data(i,1),'''','')); %remove every comma
    k=strfind(Ax,'-');
    
    formatIn = 'dd.mm.yyyy';
    DateString=Ax(1:k(1)-2);
    DateNum(i)=datenum(DateString,formatIn); %this is done if there was a change in month
    
  
  end
% order data according to data
 [~,idDateSort]=sort(DateNum); 
 Social_Data=Social_Data(idDateSort,:);
 
  raw(2:size(Social_Data,1)+1,1:8)=Social_Data; 
  %% 
  
  raw(2:size(Social_Data,1)+1,9)=num2cell([1:size(Social_Data,1)]');
  
   %% For Csv
%   ExperimentDate=raw(2:end,1);
%   TimeBeginEvent=raw(2:end,2);
%   TimeEndEvent=raw(2:end,3);
%   ApproachingMouse=raw(2:end,4);
%   ApproachedMouse=raw(2:end,5);
%   CorrectedEvents=raw(2:end,6);
%   FrameBeginApproaching=raw(2:end,7);
%   FrameFinishApproaching=raw(2:end,8);
%   NumberOfEvent= raw(2:end,9);
% 
% T6=table(ExperimentDate,TimeBeginEvent,TimeEndEvent,ApproachingMouse,ApproachedMouse,CorrectedEvents,FrameBeginApproaching,FrameFinishApproaching,NumberOfEvent);
% writetable(T6,strcat(Params.resultsDir,'/','Approaching.csv'))
 cellwrite(strcat(Params.resultsDir,'/','Approaching.csv'),raw) 
  
%   sheet=['Approaching'];
%   xlswrite([SaveDirectory,'\',exp_name,'_','ApproachingResults.xlsx'],raw,sheet)
  Approaching.Approaching=raw;

%     %% Save in another sheet all the parameters
%   raw2={};
 raw2(1,1)={'Maximum distance between mice to be considered approaching (mm)'};
 raw2(2,1)={'Approaching angle (degree)'};
 raw2(3,1)={'Velocity of the approached mouse (cm/sec)'};
 raw2(4,1)={'Velocity of the mouse approaching (cm/sec)'};
 
  raw2(1,2)=num2cell(Params.MaximumDistanceToApproach);
  raw2(2,2)=num2cell(Params.ApproachingAngle);
  raw2(4,2)=num2cell(Params.Aproaching_velocity);
  raw2(3,2)=num2cell(Params.VelocityApproachedMouse);
  Approaching.ApproachingParameters=raw2;
  
%  sheet2=['ApproachingParameters'];
%   xlswrite([SaveDirectory,'\',exp_name,'_','ApproachingResults.xlsx'],raw2,sheet2)
%  save([SaveDirectory,'/',exp_name,'_','ApproachingResults.mat'],'Approaching')
  
%% 
 rowNames={'Maximum distance between mice to be considered approaching (mm)';'Approaching angle (degree)';'Velocity of the approached mouse (cm/sec)';...
    'Velocity of the mouse approaching (cm/sec)'};
Parameters=raw2(:,2);
T7=table(rowNames,Parameters);
writetable(T7,strcat(Params.resultsDir,'/','ParametersApproaching.csv'))

end



%% -----------For removing duplicates from excel file------------------
function [Social_Data,DoubleData]=RemoveDuplicates(Social_Data)
   Iaux=[];   

   BegFrameEndFrame=cell2mat(Social_Data(:,7:8));
   A=[1:length(BegFrameEndFrame(:,1))]'; 
   [C,ia,ic]=unique(BegFrameEndFrame,'rows','stable');%eliminate the duplicates
   IndWithDuplicates=setdiff(A,ia,'rows');
   Duplicates=BegFrameEndFrame(IndWithDuplicates,:);
   Lia=ismember(BegFrameEndFrame,Duplicates,'rows');%find this duplicates in original data
   AuxData=Social_Data(find(Lia(:,1)==1),:);%this is data of duplicates
  % Iaux=find(Lia(:,1)==1);
  
  
   
   %% Select which are actually double data or there are an inconsistent between chasing and non chasing
[EventsBeg EventsEnd]=getEventsIndexesGV(Lia,size(Lia,1))
   for ic=1:length(EventsBeg)
      M1=unique(Social_Data(EventsBeg(ic):EventsEnd(ic),4));
      M2=unique(Social_Data(EventsBeg(ic):EventsEnd(ic),5));
      Mtotal=unique([Social_Data(EventsBeg(ic):EventsEnd(ic),4);Social_Data(EventsBeg(ic):EventsEnd(ic),5)]) ;
      
      if length(Mtotal)<=2 %remove cases in which the mice are the same in the same frames.
          
          Iaux=[Iaux;[EventsBeg(ic):EventsEnd(ic)]'];
      end
       
   end
   
   DoubleData=Social_Data(Iaux,:); 
   
   %% 
   if ~isempty(EventsBeg)& ~isempty(Iaux)
      Iaux1=setdiff(A,Iaux,'rows');
      Social_Data=Social_Data(Iaux1,:);
   end


end

%% Get events

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %% -----------------------Function for saving close into an excel file------------------

function SaveSocialClose(Social_Data,Params)


  
  %% %%   %% save into an excel file in a sheet called list of all closest events
  raw={};
  raw(1,1)={'Experiment date'};
  raw(1,2)={'Time begin event'};
  raw(1,3)={'Time end event'};
  raw(1,4)={'mouse1'};
  raw(1,5)={'mouse2'};
  raw(1,6)={'Corrected events'};
  raw(1,7)={'Frame begin close event'};
  raw(1,8)={'Frame finish close event'};


  raw(1,9)={'Number of Event'};
  
 % raw(2:size(Social_Data,1)+1,1:9)=Social_Data;
  
  %% Sort the data according to the days
  
  for i=1:length(Social_Data(:,1))
      Ax=char(strrep(Social_Data(i,1),'''','')); %remove every comma
    k=strfind(Ax,'-');
    
    formatIn = 'dd.mm.yyyy';
    DateString=Ax(1:k(1)-2);
    DateNum(i)=datenum(DateString,formatIn); %this is done if there was a change in month
    
  
  end
% order data according to data
 [~,idDateSort]=sort(DateNum); 
 Social_Data=Social_Data(idDateSort,:);
 
  raw(2:size(Social_Data,1)+1,1:8)=Social_Data; 
  %% 
  
  raw(2:size(Social_Data,1)+1,9)=num2cell([1:size(Social_Data,1)]');
  
   %% For Csv

 cellwrite(strcat(Params.resultsDir,'/','CloseEvents.csv'),raw) 
  



end

%%
%% %% -----------------------Function for saving close into an excel file------------------

function SaveSocialCloseClose(Social_Data,Params)


  
  %% %%   %% save into an excel file in a sheet called list of all closest events
  raw={};
  raw(1,1)={'Experiment date'};
  raw(1,2)={'Time begin event'};
  raw(1,3)={'Time end event'};
  raw(1,4)={'mouse1'};
  raw(1,5)={'mouse2'};
  raw(1,6)={'Corrected events'};
  raw(1,7)={'Frame begin close event'};
  raw(1,8)={'Frame finish close event'};
  raw(1,9)={'Median Velocity mouse1'};
  raw(1,10)={'Median Velocity mouse2'};
  raw(1,11)={'Angular velocity mouse1'};
  raw(1,12)={'Angular velocity mouse2'};
  raw(1,13)={'Distance travel mouse1'};
  raw(1,14)={'Distance travel mouse2'};
  raw(1,15)={'Interquantil velocity mouse1'};
  raw(1,16)={'Interquantil velocity mouse2'};
  raw(1,17)={'Mean Velocity mouse1'};
  raw(1,18)={'Mean Velocity mouse2'};
  raw(1,19)={'Duration of the event (sec)'};
  raw(1,20)={'Mean distance between mice (cm)'};
  
  raw(1,21)={'Number of Event'};
  
 % raw(2:size(Social_Data,1)+1,1:9)=Social_Data;
  
  %% Sort the data according to the days
  
  for i=1:length(Social_Data(:,1))
      Ax=char(strrep(Social_Data(i,1),'''','')); %remove every comma
    k=strfind(Ax,'-');
    
    formatIn = 'dd.mm.yyyy';
    DateString=Ax(1:k(1)-2);
    DateNum(i)=datenum(DateString,formatIn); %this is done if there was a change in month
    
  
  end
% order data according to data
 [~,idDateSort]=sort(DateNum); 
 Social_Data=Social_Data(idDateSort,:);
 
  raw(2:size(Social_Data,1)+1,1:20)=Social_Data; 
  %% 
  
  raw(2:size(Social_Data,1)+1,21)=num2cell([1:size(Social_Data,1)]');
  
   %% For Csv

 cellwrite(strcat(Params.resultsDir,'/','CloseCloseEvents.csv'),raw) 
  



end













