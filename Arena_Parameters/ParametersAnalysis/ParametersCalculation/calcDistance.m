function [TotalDistanceTravel,NumberOfEventsInTheMean]=calcDistance(XcoordMM,YcoordMM,InArena)

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Information
% Calculate the distance travelled for each mouse, when it is on the arena.
% Then the mean of the distance  for each file is calculated
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Loop over each mice
for mice=1:size(InArena,2)
    
   % Find when it is in the arean 
    [EventsBeg EventsEnd]=getEventsIndexesGV(InArena(:,mice),size(InArena(:,mice),1));
    if ~isempty(EventsBeg)
        dist=[]; % to reset
       %Calculate the distance for the given event
        dist=DistanceForEvent(EventsBeg,EventsEnd,XcoordMM(:,mice),YcoordMM(:,mice)); % distance cover for each event in mm
        % Convert mm to m
        dist=dist/1000;
        % Calculate mean
        TotalDistanceTravel(mice,:)=sum(dist,2,'omitnan');
        NumberOfEventsInTheMean(mice,:)=sum(~isnan(dist));
    else %No events
        TotalDistanceTravel(mice,:)=NaN;
        NumberOfEventsInTheMean(mice,:)=NaN;
    end
    
end

end
%%%%%%%%%%%%%%%%

%% ------------------------Auxiliary functions------------------------------------
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
%% 
function dist=DistanceForEvent(EventsBeg,EventsEnd,X,Y)
for Event=1:size(EventsBeg,1)
    distAux=[];
    Xdif=diff(X(EventsBeg(Event):EventsEnd(Event)));
    Ydif=diff(Y(EventsBeg(Event):EventsEnd(Event)));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%
    distAux=sqrt(Xdif.^2+Ydif.^2);
    % Eliminate the distance related with non-defined positions (1000000).
    % These distances are 0 or larger than 1e5.
    if ~isempty(find(distAux~=0 & distAux<1e5))
     distAux=distAux(find(distAux~=0 & distAux<1e5));
     dist(:,Event)=sum(distAux,'omitnan');% the units are in mm
    else % only one-2 points in the event
       dist(:,Event)=NaN;  
    end
    %%%%%%%%%%%%%%%%%%%%%%%%
    
   
    
    
end

end
