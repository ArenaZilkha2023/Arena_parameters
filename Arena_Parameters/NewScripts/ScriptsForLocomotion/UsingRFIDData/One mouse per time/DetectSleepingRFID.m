function [SleepingBoxIndexTotal NewCoord EventsBegfinal EventsEndfinal Cages]=DetectSleepingRFID(NewCoord,RFIDInf)
%  Detect sleeping with RFID
%variables
global Params
%clear variables
EventsBeg=[];
EventsEnd=[];
EventsBeg1=[];
EventsEnd1=[];
EventsBegfinal=[];
EventsEndfinal =[];
Cages=[];
I=[];

%%   %% Assign cages
    CageNumber(1:8)=[2,5,7,35,47,45,43,8];%order according to the cages order
    SideBox(1:8)=[49,50,51,52,53,54,55,56];%this is detected if the mouse is jumping
    
 
    %% 
    SleepingBoxIndexTotal=[];
    SleepingBoxIndexTotal=zeros(length(RFIDInf),1);
     NewCoord=cell2mat(NewCoord);
     
%% found sleeping box/tube
for j=1:8 %go around the cages
    %% clear variables
    EventsBeg=[];
    EventsEnd=[];
    EventsBeg1=[];
    EventsEnd1=[];
    SleepingBoxIndex=[];
    SleepingBoxIndex=zeros(length(RFIDInf),1);
       if (CageNumber(j)==8)
    ActualCage=8;
elseif (CageNumber(j)==43)
    ActualCage=7;
elseif (CageNumber(j)==2)
    ActualCage=1;
elseif (CageNumber(j)==5)
    ActualCage=2;
 elseif (CageNumber(j)==7)
    ActualCage=3;
 elseif (CageNumber(j)==35)
    ActualCage=4;
 elseif (CageNumber(j)==47)
    ActualCage=5;
 elseif (CageNumber(j)==45) 
    ActualCage=6;
end
    %% 


  if ~isempty(find(strcmp({num2str(CageNumber(j))},RFIDInf)==1))%only if it is sleeping    
    
         SleepingBoxIndex(strcmp({num2str(CageNumber(j))},RFIDInf))=1;

    %find the limits of each interval

         [EventsBeg EventsEnd]=getEventsIndexesGV(SleepingBoxIndex,length(SleepingBoxIndex));
         %% %join events with small gap because of antenna jumping
         I=find(EventsEnd(1:length(EventsEnd)-1)-EventsBeg(2:length(EventsEnd))< Params.frames);
         if ~isempty(I)
         SleepingBoxIndex(EventsEnd(I):EventsBeg(I+1))=1;
         end
       
%% 
   %arrange the upper border
   %Find again intervals different for each cage
   
       [EventsBeg1 EventsEnd1]=getEventsIndexesGV(SleepingBoxIndex,length(SleepingBoxIndex));
   %for side cages 8 and 43

  for i=1:length(EventsEnd1)%loop on each event
  
  %begin cage 8       
 if (CageNumber(j)==8)| (CageNumber(j)==43)  
  if EventsEnd1(i)< length((RFIDInf)) %assure that it is not the end
   if isnan(NewCoord(EventsEnd1(i),1))| NewCoord(EventsEnd1(i),1)<=0 | NewCoord(EventsEnd1(i),1)> 20000 %under these conditions continue to look for the limit in the sleeping range
      I1=find(NewCoord(EventsEnd1(i):end,1)>0 & NewCoord(EventsEnd1(i):end,1)<20000,1,'first')
      if ~isempty(I1)
         SleepingBoxIndex( EventsEnd1(i):EventsEnd1(i)+(I1-1)-1)=1
      else
          SleepingBoxIndex(EventsEnd1(i):end)=1;
      end
   end
   end
 elseif  (CageNumber(j)==2)| (CageNumber(j)==5) 
  if EventsEnd1(i)< length((RFIDInf)) %assure that it is not the end
   if isnan(NewCoord(EventsEnd1(i),2))| NewCoord(EventsEnd1(i),2)<=0 | NewCoord(EventsEnd1(i),2)> 20000 %under these conditions continue to look for the limit in the sleeping range the y direction
      I1=find(NewCoord(EventsEnd1(i):end,2)>0 & NewCoord(EventsEnd1(i):end,2)<20000,1,'first');
      if ~isempty(I1)
         SleepingBoxIndex( EventsEnd1(i):EventsEnd1(i)+(I1-1)-1)=1;
      else
          SleepingBoxIndex(EventsEnd1(i):end)=1;
      end
   end
  end
  %% 
   elseif  (CageNumber(j)==7)| (CageNumber(j)==35) 
    if EventsEnd1(i)< length((RFIDInf)) %assure that it is not the end
      if isnan(NewCoord(EventsEnd1(i),1))| NewCoord(EventsEnd1(i),1)>=1110 | NewCoord(EventsEnd1(i),1)> 20000 %under these conditions continue to look for the limit in the sleeping range the y direction
      I1=find(NewCoord(EventsEnd1(i):end,1)<1110 & NewCoord(EventsEnd1(i):end,1)<20000,1,'first'); %1110 COULD BE 1139
       if ~isempty(I1)
         SleepingBoxIndex( EventsEnd1(i):EventsEnd1(i)+(I1-1)-1)=1;
       else
          SleepingBoxIndex(EventsEnd1(i):end)=1;
       end
      end
  end
  %% 
     elseif  (CageNumber(j)==45)| (CageNumber(j)==47) 
    if EventsEnd1(i)< length((RFIDInf)) %assure that it is not the end
      if isnan(NewCoord(EventsEnd1(i),2))| NewCoord(EventsEnd1(i),2)>=1110 | NewCoord(EventsEnd1(i),2)> 20000 %under these conditions continue to look for the limit in the sleeping range the y direction
      I1=find(NewCoord(EventsEnd1(i):end,2)<1110 & NewCoord(EventsEnd1(i):end,2)<20000,1,'first'); %1110 COULD BE 1139
       if ~isempty(I1)
         SleepingBoxIndex( EventsEnd1(i):EventsEnd1(i)+(I1-1)-1)=1;
       else
          SleepingBoxIndex(EventsEnd1(i):end)=1;
       end
      end
  end
 end
  end  
 

  %% %Get final events
  [Inti Intf]=getEventsIndexesGV(SleepingBoxIndex,length(SleepingBoxIndex))
  if j==1
[EventsBegfinal EventsEndfinal]=getEventsIndexesGV(SleepingBoxIndex,length(SleepingBoxIndex));
  Cages=repmat(ActualCage,length(Inti),1);
  SleepingBoxIndexTotal=SleepingBoxIndex;
  else
      if ~isempty(EventsBegfinal)
        EventsBegfinal= [EventsBegfinal;Inti ]; 
        EventsEndfinal= [EventsEndfinal;Intf ];  
    
    Cages=[Cages;repmat(ActualCage,length(Inti),1)];
    SleepingBoxIndexTotal=SleepingBoxIndexTotal+ SleepingBoxIndex;
      else
      [EventsBegfinal EventsEndfinal]=getEventsIndexesGV(SleepingBoxIndex,length(SleepingBoxIndex));  
      Cages=repmat(ActualCage,length(Inti),1);
      SleepingBoxIndexTotal=SleepingBoxIndex;
      end
  end

%Replace the coordinates of cages to cages coordinates

if ~isempty(Inti)
NewCoord(Inti:Intf,1)=Params.CoordSleepingCells(ActualCage,1); 
NewCoord(Inti:Intf,2)=Params.CoordSleepingCells(ActualCage,2);
end

  
  
 end
  end
 %
  
  
  
  
  

  
  
  
  
  
  
end
%% 



