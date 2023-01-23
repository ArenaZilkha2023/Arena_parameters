function  Parameters=calcBeAvoidingDuration(AvoidingStructure,ExperimentTime)

%Remove quotes
     ExperimentTime=strrep(ExperimentTime,'''','');
  for mouse=1:size(AvoidingStructure,2)
      % Variables reset
        InitialFrame=[];
        FinalFrame=[];
        InitialFrame1=[];
        FinalFrame1=[];
      
    % For chasing
     if  ~isempty(AvoidingStructure{1,mouse})   
       InitialFrame=cell2mat(AvoidingStructure{1,mouse}(:,1));
       FinalFrame=cell2mat(AvoidingStructure{1,mouse}(:,2));
       DurationAvoiding(mouse,1)=sum(etime(datevec(ExperimentTime(FinalFrame,1),'HH:MM:SS.FFF'),datevec(ExperimentTime(InitialFrame,1),'HH:MM:SS.FFF')))
    else
        DurationAvoiding(mouse,1)=0;
    end

    
  end
     Parameters=[DurationAvoiding]; % in seconds
end