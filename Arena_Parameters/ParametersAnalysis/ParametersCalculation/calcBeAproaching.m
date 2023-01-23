function [EventsAproaching, DurationAproaching]=calcBeAproaching(AproachingStructure,ExperimentTime)
%Remove quotes
     ExperimentTime=strrep(ExperimentTime,'''','');
AproachingTable =[];
count=1;
for mouse=1:size(AproachingStructure,2)
  if  ~isempty(AproachingStructure{1,mouse})
     if count==1
       AproachingTable = AproachingStructure{1,mouse}; 
     end    
     AproachingTable=[AproachingTable;AproachingStructure{1,mouse}];
     count=count+1;
  end  
end
%%%%%%%%%%%Calculate the number of aproaching per mice%%%%%%%%
AproachingTable= cell2mat(AproachingTable)
for mouse=1:size(AproachingStructure,2)
  if  ~isempty(AproachingTable)
   EventsAproaching(mouse,:)=length(find(AproachingTable(:,3)== mouse));
  else
    EventsAproaching(mouse,:)=0;  % in the case of non avoiding events 
  end
 
end
%%%%%%%%%%%%%%%Calculate duration of avoiding per mice ##############
for mouse=1:size(AproachingStructure,2)
  if  ~isempty(AproachingTable)
    Index= find(AproachingTable(:,3)== mouse);
   if length(Index)~=0 
    Aux= AproachingTable(Index,:);  
    DurationAproaching(mouse,1)=sum(etime(datevec(ExperimentTime(Aux(:,2),1),'HH:MM:SS.FFF'),datevec(ExperimentTime(Aux(:,1),1),'HH:MM:SS.FFF')));
   else
       DurationAproaching(mouse,1)=0;
   end   
  else
    DurationAproaching(mouse,1)=0;  % in the case of be approaching events 
  end
  
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end