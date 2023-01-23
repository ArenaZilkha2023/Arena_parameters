function [EventsAvoiding, DurationAvoiding]=calcAvoiding(AvoidingStructure,ExperimentTime)
%Remove quotes
     ExperimentTime=strrep(ExperimentTime,'''','');
AvoidingTable =[];
count=1;
for mouse=1:size(AvoidingStructure,2)
  if  ~isempty(AvoidingStructure{1,mouse})
     if count==1
       AvoidingTable = AvoidingStructure{1,mouse}; 
     end    
     AvoidingTable=[AvoidingTable;AvoidingStructure{1,mouse}];
     count=count+1;
  end  
end
%%%%%%%%%%%Calculate the number of avoiding per mice%%%%%%%%
AvoidingTable= cell2mat(AvoidingTable)
for mouse=1:size(AvoidingStructure,2)
  if  ~isempty(AvoidingTable)
   EventsAvoiding(mouse,:)=length(find(AvoidingTable(:,3)== mouse));
  else
    EventsAvoiding(mouse,:)=0;  % in the case of non avoiding events 
  end
 
end
%%%%%%%%%%%%%%%Calculate duration of avoiding per mice ##############
for mouse=1:size(AvoidingStructure,2)
  if  ~isempty(AvoidingTable)
    Index= find(AvoidingTable(:,3)== mouse);
   if length(Index)~=0 
    Aux= AvoidingTable(Index,:);  
    DurationAvoiding(mouse,1)=sum(etime(datevec(ExperimentTime(Aux(:,2),1),'HH:MM:SS.FFF'),datevec(ExperimentTime(Aux(:,1),1),'HH:MM:SS.FFF')));
   else
       DurationAvoiding(mouse,1)=0;
   end   
  else
    DurationAvoiding(mouse,1)=0;  % in the case of non avoiding events 
  end
  
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end

