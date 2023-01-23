function  Parameters=calcChasingDuration(ChasingStructure,ExperimentTime)

%Remove quotes
     ExperimentTime=strrep(ExperimentTime,'''','');
  for mouse=1:size(ChasingStructure.chasing,2)
      % Variables reset
        InitialFrame=[];
        FinalFrame=[];
        InitialFrame1=[];
        FinalFrame1=[];
      
    % For chasing
     if  ~isempty(ChasingStructure.chasing{1,mouse})   
       InitialFrame=ChasingStructure.chasing{1,mouse}(:,1);
       FinalFrame=ChasingStructure.chasing{1,mouse}(:,2);
       DurationChasing(mouse,1)=sum(etime(datevec(ExperimentTime(FinalFrame,1),'HH:MM:SS.FFF'),datevec(ExperimentTime(InitialFrame,1),'HH:MM:SS.FFF')))
    else
        DurationChasing(mouse,1)=0;
    end
    %% For chased
     if  ~isempty(ChasingStructure.chased{1,mouse})   
       InitialFrame1=ChasingStructure.chased{1,mouse}(:,1);
       FinalFrame1=ChasingStructure.chased{1,mouse}(:,2);
       DurationChased(mouse,1)=sum(etime(datevec(ExperimentTime(FinalFrame1,1),'HH:MM:SS.FFF'),datevec(ExperimentTime(InitialFrame1,1),'HH:MM:SS.FFF')))
    else
        DurationChased(mouse,1)=0;
     end
        DurationChasedPlusChasing(mouse,1)=DurationChasing(mouse,1)+DurationChased(mouse,1);
    
  end
     Parameters=[DurationChasing,DurationChased,DurationChasedPlusChasing];
end