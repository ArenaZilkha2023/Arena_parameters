
function DataToUse=ArrangeInputFiles(FilenameN)

%All is valid if the experiment is during 2days.
%reset variables
clear SubsetData;
clear MouseID;
clear Days;
clear DaysWR;
clear Int

%parameters
Params = EloRatingParams();
NumberDaysExp=Params.DaysExp;

%Arrange input files
[num raw]=xlsread(FilenameN);
if isempty(raw)
   [num raw]=xlsread(FilenameN,'Chasing'); %in the case the first sheet is empty
end

%% %find the index of the columns chasing and being chasing and events
IndexChasing=find(strcmp(raw(1,:),'chasing')==1);
if isempty(IndexChasing)
 IndexChasing=4;   
end
IndexBeingChasing=find(strcmp(raw(1,:),'being chasing')==1);
if isempty(IndexBeingChasing)
 IndexBeingChasing=5;   
end
IndexEvents=find(strcmp(raw(1,:),'events')==1);
if isempty(IndexEvents)
 IndexEvents=6;   
end
%ckeck if there is a title on the top
FirstCell=raw(1,1);

if (strfind(char(FirstCell),'_20'))>1 %if it is the date non title
    begin=1;
else
    begin=2;
end


%% Find the identity of the mouse from column 4 and 5

MouseID=unique(vertcat(strrep(raw(begin:end,IndexChasing),'''',''),strrep(raw(begin:end,IndexBeingChasing),'''','')));
%% Select only events with R and Y.

LogicIndex=cellfun(@FilterData,strrep(raw(begin:end,IndexEvents),'''',''),'UniformOutput', false);
if begin==2
SubsetData=raw(find(cell2mat(LogicIndex)==1)+1,:);
else
    SubsetData=raw(find(cell2mat(LogicIndex)==1),:);
end

%% Determine the days and range for each day depending on the number of days selected
for i=1:length(SubsetData(:,1))
      Ax=char(strrep(SubsetData(i,1),'''','')); %remove every comma
    k=strfind(Ax,'.');
    
    Days(i)=str2num(Ax(1:k(1)-1));
  
end

  Days=Days'; %this are all the days -we want to remove
  
 %remove repeats days and locations
 DaysWR=unique(Days,'stable') %only intrested days in the same order
 %% From these days select the user choice days

 DaysWR=DaysWR(1:NumberDaysExp);

%find the index of days intrested
 for i=1:length(DaysWR)
    Int(i)=find(Days==DaysWR(i),1,'last'); %index there is a change in day
     
 end






%% Create structure with all the data
DataToUse.SubsetData=SubsetData;
DataToUse.IndexBeingChasing=IndexBeingChasing;
DataToUse.IndexChasing=IndexChasing;
DataToUse.IndexEvents=IndexEvents;
DataToUse.MouseID=MouseID;
DataToUse.begin=begin;
DataToUse.Days=Days;
DataToUse.DaysWR=DaysWR;
DataToUse.Int=Int;
%% 

end

%% Auxiliary data

  function result=FilterData(x)
 
        if strcmp(x,'Y')==1 | strcmp(x,'R')==1
         result=1;
        elseif strcmp(x,'N')==1
            result=0;
        end
end

