function [TogetherTime,NumberOfContacts]=calcTogether(TogetherData,ExperimentTime)
ExperimentTime=strrep(ExperimentTime,'''','');

% if ~isempty(cell2mat(TogetherData.TimesTogetherSec))   %is a double matrix only one cell
%    for mouse=1:size(TogetherData.TimesTogetherSec{1,1},2) 
%       TogetherTime(mouse,1)=(sum(TogetherData.TimesTogetherSec{1,1}(:,mouse)))/60; %in minutes
%    end  
% else
%    
%      TogetherTime(1:size(TogetherData.TogetherAll,2),1)=0; %no time
%    
% end
%% -------------------Consider the  total number of contacts---------------
for mouse=1:size(TogetherData.TogetherAll,2)
  if ~isempty(TogetherData.TogetherAll{1,mouse})
    DeltaEvents=[];
    %DeltaEvents=TogetherData.TogetherAll{1,mouse}(:,2)-TogetherData.TogetherAll{1,mouse}(:,1)+1;
    % NumberOfContacts(mouse,1)=sum(DeltaEvents,1,'omitnan'); 
     NumberOfContacts(mouse,1)=size(TogetherData.TogetherAll{1,mouse},1); %number of contacts events
     InitialFrame=TogetherData.TogetherAll{1,mouse}(:,1);
     FinalFrame=TogetherData.TogetherAll{1,mouse}(:,2);
     TogetherTime(mouse,1)=sum(etime(datevec(ExperimentTime(FinalFrame,1),'HH:MM:SS.FFF'),datevec(ExperimentTime(InitialFrame,1),'HH:MM:SS.FFF')))/60; %convert into minutes
  else
   % NumberOfContacts(mouse,1)=NaN;
    NumberOfContacts(mouse,1)=0;%changed on november 2021
    TogetherTime(mouse,1)=0;
  end
end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%














