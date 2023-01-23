function Parameters=calc2MiceNear(Data,ExperimentTime)
ExperimentTime=strrep(ExperimentTime,'''','');
for mouse=1:size(Data,2)
  if  ~isempty(Data{1,mouse})
  Events(mouse,:)=length(Data{1,mouse}(:,3));
  
     %InitialFrame=Data{1,mouse}(:,1);
     %FinalFrame=Data{1,mouse}(:,2);
    % Time(mouse,1)=sum(etime(datevec(ExperimentTime(FinalFrame,1),'HH:MM:SS.FFF'),datevec(ExperimentTime(InitialFrame,1),'HH:MM:SS.FFF')));
  
  else
    Events(mouse,:)=0;  % in the case of non  events 
   % Time(mouse,1)=0;
  end
   
end
Parameters=Events;

end