function  Parameters=calcAproachingDuration(ApproachingStructure,ExperimentTime)

%Remove quotes
     ExperimentTime=strrep(ExperimentTime,'''','');
  for mouse=1:size(ApproachingStructure,2)
      % Variables reset
        InitialFrame=[];
        FinalFrame=[];
        InitialFrame1=[];
        FinalFrame1=[];
      
    % For chasing
     if  ~isempty(ApproachingStructure{1,mouse})   
       InitialFrame=cell2mat(ApproachingStructure{1,mouse}(:,1));
       FinalFrame=cell2mat(ApproachingStructure{1,mouse}(:,2));
       DurationAproaching(mouse,1)=sum(etime(datevec(ExperimentTime(FinalFrame,1),'HH:MM:SS.FFF'),datevec(ExperimentTime(InitialFrame,1),'HH:MM:SS.FFF')))
    else
        DurationAproaching(mouse,1)=0;
    end

    
  end
     Parameters=[DurationAproaching]; % in seconds
end