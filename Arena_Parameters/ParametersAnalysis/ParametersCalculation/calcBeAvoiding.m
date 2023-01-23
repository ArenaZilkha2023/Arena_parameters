function Parameters=calcBeAvoiding(AvoidingStructure)
for mouse=1:size(AvoidingStructure,2)
  if  ~isempty(AvoidingStructure{1,mouse})
   EventsAvoiding(mouse,:)=length(AvoidingStructure{1,mouse}(:,3));
  else
    EventsAvoiding(mouse,:)=0;  % in the case of non chasing events 
  end
 
end
Parameters=EventsAvoiding;

end