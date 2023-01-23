function Parameters=calcApproaching(AproachingStructure)
for mouse=1:size(AproachingStructure,2)
  if  ~isempty(AproachingStructure{1,mouse})
   EventsApproaching(mouse,:)=length(AproachingStructure{1,mouse}(:,3));
  else
    EventsApproaching(mouse,:)=0;  % in the case of non chasing events 
  end
 
end
Parameters=EventsApproaching;

end