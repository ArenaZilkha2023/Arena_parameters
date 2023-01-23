


function  NewCoord=DetectSideBoxRFID(NewCoord,AntennaInf)
%Detect side box
%% variables
global Params
Box=[];
EventsBegfinal=[];
EventsEndfinal=[];
%convert NewCoord
NewCoord=cell2mat(NewCoord);
%%
if ~isempty(find(strcmp(AntennaInf,'56')==1))
BoxIndex=zeros(length(AntennaInf),1);
 BoxIndex(strcmp(AntennaInf,'56'))=1;
  %% %Get final events
[EventsBegfinal EventsEndfinal]=getEventsIndexesGV(BoxIndex,length(BoxIndex));
NewCoord(EventsBegfinal:EventsEndfinal,1)=Params.CoordSleepingCells(8,1); 
NewCoord(EventsBegfinal:EventsEndfinal,2)=Params.CoordSleepingCells(8,2);
end
if ~isempty(find(strcmp(AntennaInf,'55')==1))
 BoxIndex=zeros(length(AntennaInf),1);
 BoxIndex(strcmp(AntennaInf,'55'))=1;
[EventsBegfinal EventsEndfinal]=getEventsIndexesGV(BoxIndex,length(BoxIndex));
NewCoord(EventsBegfinal:EventsEndfinal,1)=Params.CoordSleepingCells(7,1); 
NewCoord(EventsBegfinal:EventsEndfinal,2)=Params.CoordSleepingCells(7,2);
end
if ~isempty(find(strcmp(AntennaInf,'54')==1))
     BoxIndex=zeros(length(AntennaInf),1);
     BoxIndex(strcmp(AntennaInf,'54'))=1;
[EventsBegfinal EventsEndfinal]=getEventsIndexesGV(BoxIndex,length(BoxIndex));
NewCoord(EventsBegfinal:EventsEndfinal,1)=Params.CoordSleepingCells(6,1); 
NewCoord(EventsBegfinal:EventsEndfinal,2)=Params.CoordSleepingCells(6,2);
end
if ~isempty(find(strcmp(AntennaInf,'53')==1))
     BoxIndex=zeros(length(AntennaInf),1);
     BoxIndex(strcmp(AntennaInf,'53'))=1;
[EventsBegfinal EventsEndfinal]=getEventsIndexesGV(BoxIndex,length(BoxIndex));
NewCoord(EventsBegfinal:EventsEndfinal,1)=Params.CoordSleepingCells(5,1); 
NewCoord(EventsBegfinal:EventsEndfinal,2)=Params.CoordSleepingCells(5,2);
end
if ~isempty(find(strcmp(AntennaInf,'52')==1))
     BoxIndex=zeros(length(AntennaInf),1);
     BoxIndex(strcmp(AntennaInf,'52'))=1;
[EventsBegfinal EventsEndfinal]=getEventsIndexesGV(BoxIndex,length(BoxIndex));
NewCoord(EventsBegfinal:EventsEndfinal,1)=Params.CoordSleepingCells(4,1); 
NewCoord(EventsBegfinal:EventsEndfinal,2)=Params.CoordSleepingCells(4,2);
end
if ~isempty(find(strcmp(AntennaInf,'51')==1))
     BoxIndex=zeros(length(AntennaInf),1);
     BoxIndex(strcmp(AntennaInf,'51'))=1;
[EventsBegfinal EventsEndfinal]=getEventsIndexesGV(BoxIndex,length(BoxIndex));
NewCoord(EventsBegfinal:EventsEndfinal,1)=Params.CoordSleepingCells(3,1); 
NewCoord(EventsBegfinal:EventsEndfinal,2)=Params.CoordSleepingCells(3,2);
end
if ~isempty(find(strcmp(AntennaInf,'50')==1))
     BoxIndex=zeros(length(AntennaInf),1);
     BoxIndex(strcmp(AntennaInf,'50'))=1;
[EventsBegfinal EventsEndfinal]=getEventsIndexesGV(BoxIndex,length(BoxIndex));
NewCoord(EventsBegfinal:EventsEndfinal,1)=Params.CoordSleepingCells(2,1); 
NewCoord(EventsBegfinal:EventsEndfinal,2)=Params.CoordSleepingCells(2,2);
end
if ~isempty(find(strcmp(AntennaInf,'49')==1))
     BoxIndex=zeros(length(AntennaInf),1);
     BoxIndex(strcmp(AntennaInf,'49'))=1;
[EventsBegfinal EventsEndfinal]=getEventsIndexesGV(BoxIndex,length(BoxIndex));
NewCoord(EventsBegfinal:EventsEndfinal,1)=Params.CoordSleepingCells(1,1); 
NewCoord(EventsBegfinal:EventsEndfinal,2)=Params.CoordSleepingCells(1,2);
end
% if isempty(find(strcmp(AntennaInf,'49')==1))& isempty(find(strcmp(AntennaInf,'50')==1))& isempty(find(strcmp(AntennaInf,'51')==1))& isempty(find(strcmp(AntennaInf,'52')==1))& isempty(find(strcmp(AntennaInf,'53')==1))& isempty(find(strcmp(AntennaInf,'54')==1))& isempty(find(strcmp(AntennaInf,'55')==1))& isempty(find(strcmp(AntennaInf,'56')==1))
%      BoxIndex=zeros(length(AntennaInf),1); %all is zero nothing change 
% end
NewCoord=num2cell(NewCoord);
end

