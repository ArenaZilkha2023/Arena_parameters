function [Duration NumberEvents  LastEventIndex]=GetTimeDurationParameter(IsRunning,ExperimentTime)

%Get duration of running activity , remove single frame events.
Duration=[];
NumberEvents=[];
LastEventIndex=zeros(size(IsRunning,2),1);% The idea is to create a vector with zeros and which marks events that didn't finish
%Remove quotes
     ExperimentTime=strrep(ExperimentTime,'''','');

%     parfor mouse=1:size(IsRunning,2)
  parfor mouse=1:size(IsRunning,2)
         
        [EventsBeg EventsEnd]=getEventsIndexesGV(IsRunning(:,mouse),size(IsRunning,1));
    if ~isempty(EventsBeg)
        % to consider only one frame add one to the last event -only check
        % this events is not outside the range.
        if (EventsEnd(size(EventsEnd,1),1)+1) > size(ExperimentTime,1) 
           EventsEndFinal=EventsEnd+1; %Consider outside the event
           EventsEndFinal(size(EventsEnd,1),1)=EventsEnd(size(EventsEnd,1),1);
           LastEventIndex=1;
        else 
           EventsEndFinal=EventsEnd+1; 
        end

        Duration(mouse,1)=sum(etime(datevec(ExperimentTime(EventsEndFinal,1),'HH:MM:SS.FFF'),datevec(ExperimentTime(EventsBeg,1),'HH:MM:SS.FFF')))/60  %convert into minutes , not consider unique events
        NumberEvents(mouse,1)=size(EventsBeg,1); 
     else
%           
        % Duration(mouse,1)=NaN; %Used this until 10/11/2021
         %NumberEvents(mouse,1)=NaN; %Used this until 10/11/2021
         Duration(mouse,1)=0;  %this means that there aren't data
         NumberEvents(mouse,1)=0;
     end


end
end%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Auxiliary
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% functions%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [EventsBeg EventsEnd]=getEventsIndexesGV(IndLogical,n)

EventsBeg=find(diff(IndLogical)==1)+1;
EventsEnd=find(diff(IndLogical)==-1);

if isempty(EventsBeg)||isempty(EventsEnd)
    if(isempty(EventsBeg)&&~isempty(EventsEnd))
        EventsBeg=[1;EventsBeg];
    elseif(isempty(EventsEnd)&&~isempty(EventsBeg))
        EventsEnd=[EventsEnd;n];
    else
        if sum(IndLogical)==n
            EventsBeg=1;
            EventsEnd=n;
        end
    end
else
    if(EventsBeg(1)>EventsEnd(1))
        EventsBeg=[1;EventsBeg];
    end
    
    if(EventsBeg(end)>EventsEnd(end))
        EventsEnd=[EventsEnd;n];
    end
end

end