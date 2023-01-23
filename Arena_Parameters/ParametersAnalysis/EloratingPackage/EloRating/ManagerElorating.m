function DataToUse =ManagerElorating(DataToUse,FilenameN) 
%UNTITLED Summary of this function goes here
%  Manager of the Elo rating and montecarlo by adding external list-REQUEST
%  DATA -fIRST COLUMN DATE-SECOND COL. TIME BEGIN-THIRD COL. FINISH EVENT-
%  FOUR IDENTITY MOUSE- FIVE IDENTITY MOUSE- ACCEPTED/NOT
%  ACCEPTED/REVERSED-the first row is with title
%ASUMPTION THE DATA IS SORTED WITH THE TIME
%% Variable reset
global h
global version
clear eventlist
clear Aux
clear LogicIndex
clear SubsetData;
clear Aux;
clear Aux1;
clear EloMatrix;
clear EloMatrixOrder;
clear EloeDayTotalOrder;
clear EloeDayTotal;
%% Load parameters
Params = EloRatingParams();
k=Params.k;
initial_rating=Params.initial_rating;
NumberDaysExp=Params.DaysExp;

SubsetData=DataToUse.SubsetData;
MouseID=DataToUse.MouseID;
IndexChasing=DataToUse.IndexChasing;
IndexBeingChasing=DataToUse.IndexBeingChasing;
IndexEvents=DataToUse.IndexEvents;
begin=DataToUse.begin;
%% Load external data in excel format 
hwait = waitbar(0,'Please wait Elo-rating calculation...');


%% CALCULATION OF THE ELO RATING
 close(hwait)
hwait = waitbar(0.5,'Please wait...');
eloe  = EloRatingCalculation( SubsetData,MouseID,k,initial_rating,IndexChasing,IndexBeingChasing,IndexEvents);

 %% Table which includes the real interaction 

Aux1=eloe';
Aux=Aux1(2:end,:);
Aux(diff(eloe',1,1)==0)=NaN;
Aux=[Aux1(1,:);Aux];

%create elorating matrix
EloMatrix(1,1)={'Experiment date'};
EloMatrix(1,2)={'Time begin'};
EloMatrix(1,3)={'Time end'};

for i=1:length(MouseID)
EloMatrix(1,i+3)=strcat('''',MouseID(i),'''');
end

%add zero time
EloMatrix(2:size(SubsetData,1)+2,1)=[0; SubsetData(:,1)];
EloMatrix(2:size(SubsetData,1)+2,2)=[0; SubsetData(:,2)];
EloMatrix(2:size(SubsetData,1)+2,3)=[0; SubsetData(:,3)];

EloMatrix(2:size(SubsetData,1)+2,4:length(MouseID)+3)=num2cell(Aux1); %including repeats of elorating

%% Save number of events
widthM=size((EloMatrix),2)+1;
EloMatrix(1,widthM)={'Events'};
EloMatrix(2:end,widthM)=num2cell([0:size((EloMatrix),1)-2]);

%% Save only the days choose by the user
IndexToRemove=DaysRemove(EloMatrix(:,1),NumberDaysExp);
if IndexToRemove>0
  EloMatrix(IndexToRemove+2,:)={''};
    
end

%% 

  %% Group elorating per day and choose the last event per day
  [EloeDayTotal,NumberEventsPerDay,Intervalbegin,Intervalfinish]= EloRatingperDay(SubsetData,Aux1,MouseID,NumberDaysExp);
  %save the numbers and raw of Elodaytotal to the structure without order
   
   DataToUse.numElo=cell2mat(EloeDayTotal(2:size(EloeDayTotal,1),2:size(EloeDayTotal,2)));
   
  
  EloeDayTotalOrder=EloeDayTotal;
  EloMatrixOrder=EloMatrix;
  

  
  %% Insert new column with the days
  EloMatrixOrder(1,widthM+1)={'Day'};
  for i=1:NumberDaysExp   
  EloMatrixOrder(Intervalbegin(i)+2:Intervalfinish(i)+2,widthM+1)=num2cell(i);
  end
 %% -----------------Ranking according to the mean along the days of each mouse-------
%   %save the ranking by considering  the last event or last day
%   [Ranking I]=sort(cell2mat(EloeDayTotal(size(EloeDayTotal,1),2:end)),'descend' );
% EloeDayTotal(:,2:end)
    [Ranking I]=sort(mean(cell2mat(EloeDayTotal(2:end,2:end)),1),'descend');
  
  Tree(:,1)=strcat('''',MouseID(I),'''');
  Tree(:,2)=num2cell(Ranking');
  %save to the structure
  DataToUse.numR=Ranking';
  DataToUse.rawR=Tree(:,1);
  
  
  
  %% Order Data according to the ranking
  for i=2:length(MouseID)+1
      EloeDayTotalOrder(:,i)=EloeDayTotal(:,I(i-1)+1);
      EloMatrixOrder(:,i+2)=EloMatrix(:,I(i-1)+3);
  end
 
  %% Number of events per day
   widthM=size(EloeDayTotalOrder,2)+3;
   EloeDayTotalOrder(1,widthM)={'Number of events per day'};
   EloeDayTotalOrder(3:NumberDaysExp+2,widthM)=num2cell(NumberEventsPerDay');
   DataToUse.EloeDayTotalOrder=EloeDayTotalOrder;
   DataToUse.EloMatrixOrder=EloMatrixOrder;
   %% 
  
   %% Saving data
   
   
%    %% Add to the filename the matlab version used
%    FilenameN=strcat(version,FilenameN);
   
   %save elorating
if (get(h.Checkbox1,'Value') == 1)
 sheet1=['Elo-rating All Events'];
 try
  xlswrite(FilenameN,EloMatrix,sheet1)
 catch
    msgbox('CLOSE YOUR EXCEL FILE') 
 end
end
  if (get(h.Checkbox1,'Value') == 1)
     
   sheet1=['Elo-rating All Events'];
   try
  xlswrite(FilenameN,EloMatrixOrder,sheet1)
   catch
       msgbox('CLOSE YOUR EXCEL FILE')
   end
  sheet1=['Ranking'];
  try
  xlswrite(FilenameN,Tree,sheet1)
  catch
     msgbox('CLOSE YOUR EXCEL FILE') 
  end
  end
  
 if  (get(h.Checkbox2,'Value') == 1)
     try
%   sheet1=['Elo-rating per day'];
%   xlswrite(FilenameN,EloeDayTotal,sheet1) 
   sheet1=['Elo-rating per day order'];
  xlswrite(FilenameN,EloeDayTotalOrder,sheet1) 
 sheet1=['Ranking'];
  xlswrite(FilenameN,Tree,sheet1)
     catch
         msgbox('CLOSE YOUR EXCEL FILE')
     end
end
   close(hwait)
  hwait = waitbar(1,'End of the calculation...');
 close(hwait);
 h1=msgbox('The elorating calculation finished')

% 
%  
 close(h1)
 
 
 

 
 
 %% 
 
 %% if checkbox is ok run shuffling methods
 if  (get(h.Checkbox3,'Value') == 1) & (get(h.Checkbox2,'Value') == 1) %only if for one day was calculated
  SaveArray=RunShuffling(DataToUse,FilenameN);
  %Save the data
      DataToUse.PvalueElo=SaveArray;
      sheet=['P-value of the randomization'];
      xlswrite(FilenameN,SaveArray,sheet)
  
  %FINISH
  %% Arrange SaveArray
  for i=1:NumberDaysExp+1 %read each matrix -Remember the first is last event
  SaveArrayAux(:,:,i)=SaveArray(i+(i-1)*(length(MouseID)+1):i+(i-1)*(length(MouseID)+1)+length(MouseID)+1,1:length(MouseID)+1);
  end
 end
 %% 
 
  %% Plotting of Eloe day
if IndexToRemove>0 
   EloMatrixOrder=EloMatrixOrder(1:IndexToRemove(1)+1,:); 
end

 PlotEloRateDay(EloeDayTotalOrder,EloMatrixOrder,MouseID,NumberDaysExp,FilenameN);
 
 
 end



%% Auxiliary functions


%% 
    function I=DaysRemove(A,NumberDaysExp)
    Days=[];
    DaysWR=[];
   A=A(3:end);
    for i=1:length(A)
         
      Ax=char(strrep(A(i),'''','')); %remove every comma
    k=strfind(Ax,'.');
    
    Days(i)=str2num(Ax(1:k(1)-1));
  
    end
     Days=Days';
 %remove repeats days and locations
     DaysWR=unique(Days,'stable')
     
     %find not consider days
     if NumberDaysExp==length(DaysWR)
         I=0;
     else
     DaysNC=DaysWR(NumberDaysExp+1:length(DaysWR));
     for i=1:length(DaysNC)
         if i==1
        I=find(Days==DaysNC(i));
         else
             I1=find(Days==DaysNC(i));
             I=[I;I1];
         end
     end    
     end    
         
 end
   