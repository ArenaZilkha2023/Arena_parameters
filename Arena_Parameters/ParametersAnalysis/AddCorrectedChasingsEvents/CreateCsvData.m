
function CreateCsvData(Filename,Folder_Data)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %% ---------------------------------First Part Arrange the chasing events into a table----------------------------

AllChasing =GetEvents(Folder_Data);
%% --------------------SAVE SOCIAL EVENTS INTO EXCEL FILE-----------------
  %for chasing
        
      if ~isempty(AllChasing)
          SaveSocialData(AllChasing,Filename)
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


%% Find the time near to the RFID data for each frame
function result=FoundNearTime(x,RFIDDataTime)

xTime=datevec(x,'HH:MM:SS.FFF');
TimeDif=abs(etime(RFIDDataTime,repmat(xTime,size(RFIDDataTime,1),1)));

%find the nearest time of rfid to frame video
result=find(TimeDif==min(TimeDif));
result=result(1);


end



%% 



%% -----------------------Function for saving Chasing, approachin/avoiding into an excel file------------------

function SaveSocialData(Social_Data,Filename)

 %chasing
  %Separate the duplicates from the data and save in another sheet
  %[Social_Data,DoubleData]=RemoveDuplicates(Social_Data);
  
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
  
;
  
  %%   
 % Chasing.AllChasing=raw;
%   
   sheet='Chasing';
   xlswrite(char(Filename),raw,sheet);
 %  save([SaveDirectory,'\',exp_name,'_','ChasingResults.mat'],raw)



end



%% %% -----------------------Function for saving avoiding into an excel file------------------













