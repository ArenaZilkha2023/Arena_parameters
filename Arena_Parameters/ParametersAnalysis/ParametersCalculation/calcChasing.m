function Parameters=calcHeadToHead(ChasingStructure)
for mouse=1:size(ChasingStructure.chasing,2)
  if  ~isempty(ChasingStructure.chasing{1,mouse})
   EventsChasing(mouse,:)=length(ChasingStructure.chasing{1,mouse}(:,3));
  else
    EventsChasing(mouse,:)=0;  % in the case of non chasing events 
  end
   if  ~isempty(ChasingStructure.chased{1,mouse}) 
     EventsChased(mouse,:)=length(ChasingStructure.chased{1,mouse}(:,3));
   else
      EventsChased(mouse,:)=0;% in the case of non chased events   
   end
   EventsChasingChased(mouse,:)=EventsChasing(mouse,:)+EventsChased(mouse,:);
 
end
Parameters=[EventsChasing, EventsChased,EventsChasingChased];

end