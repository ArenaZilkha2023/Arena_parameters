 
function [EloeDayTotal,NumberEventsPerDay,Intervalbegin,Intervalfinish]= EloRatingperDay(SubsetData,Aux1,MouseID,NumberDaysExp)
 
%This function calculates the elorating per day by taking the last event of
%the day

 %% Variables
 clear Days;
 clear NumberEventsPerDay;
 clear Intervalbegin;
 clear Intervalfinish;
 %% 

 
% for i=1:length(SubsetData(:,1));
%       Ax=char(SubsetData(i,1));
%     k=strfind(Ax,'_');
%     if strcmp(Ax(1),'''')==0  %Consider when the original data has ' at the begining
%     Days(i)=str2num(Ax(1:k(1)-1));
%     else
%        Days(i)=str2num(Ax(2:k(1)-1));
%     end
% end
%% 
for i=1:length(SubsetData(:,1));
      Ax=char(strrep(SubsetData(i,1),'''','')); %remove every comma
    k=strfind(Ax,'.');
    
    Days(i)=str2num(Ax(1:k(1)-1));
    
    formatIn = 'dd.mm.yyyy';
    DateString=Ax(1:k(3)-1);
    DateNum(i)=datenum(DateString,formatIn); %this is done if there was a change in month
    
  
end

%% 
[~,Ids]=sort(unique(DateNum,'stable'));

%% 

  Days=Days';
 %remove repeats days and locations
 DaysWR=unique(Days,'stable'); %only intrested days
 
 DaysWR=DaysWR(Ids);
 %% From these days select the user choice days
 
 DaysWR=DaysWR(1:NumberDaysExp);
 % 
   
    Aux1=Aux1(2:end,:);
 for i=1:length(DaysWR) %loop over each day
     Auxiliar=[];
  
    Auxiliar=Aux1(find(Days==DaysWR(i),1,'first'):find(Days==DaysWR(i),1,'last'),:); %range for each day 
    NumberEventsPerDay(i)=find(Days==DaysWR(i),1,'last')-find(Days==DaysWR(i),1,'first')+1;
    %also take interval information
    Intervalbegin(i)=find(Days==DaysWR(i),1,'first');
    Intervalfinish(i)=find(Days==DaysWR(i),1,'last');
    
    for j=1:length(MouseID)

         Auxiliar(size(Auxiliar,1),j);
         EloeDay(i,j)=Auxiliar(size(Auxiliar,1),j);%check for each mouse last  data
         
 end
 end
 
 %% save elo per day
 EloeDayTotal={};
 EloeDayTotal(1,1)={'Days'};
 
 for i=1:length(MouseID)
EloeDayTotal(1,i+1)=strcat('''',MouseID(i),'''');
 end

 
  EloeDayTotal(2,2:length(MouseID)+1)=num2cell(repmat(1000,1,length(MouseID))); %add 10000
  EloeDayTotal(2:length(DaysWR)+2,1)=num2cell([0 1:length(DaysWR)]');
  EloeDayTotal(3:length(DaysWR)+2,2:length(MouseID)+1)=num2cell(EloeDay);
 
 end
 %% 