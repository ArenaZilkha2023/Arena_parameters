function [AngleVelocity,NumberEvents]=calcAngularVelocity(ExpTime,Orientation,InArena)

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Information
% Calculate the angular velocity delta(theta)/delta(time) in rad/sec

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Loop over each mice
for mice=1:size(InArena,2)
    Ang=[];
    EventsBeg=[];
    EventsEnd=[];
   % Find when it is in the arean 
    [EventsBeg EventsEnd]=getEventsIndexesGV(InArena(:,mice),size(InArena(:,mice),1));
    if ~isempty(EventsBeg)
      
       %Calculate all the angle's velocity for each given event
        Ang=AngleVelocityForEvent(EventsBeg,EventsEnd,Orientation(:,mice),ExpTime(:,1)); % all the angular velocity for each event in rad/sec
        %Check if there are inf angle and change with NaN
         Index=find(isinf(Ang)==1);
         if ~isempty(Index)
            Ang(Index)=NaN; 
         end
         
          AngleVelocity(mice,:)=sum(Ang,1,'omitnan');
          NumberEvents(mice,:)=size(Ang,1);
    else %No events
        AngleVelocity(mice,:)=NaN;
         NumberEvents(mice,:)=NaN;
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
function AngVel=AngleVelocityForEvent(EventsBeg,EventsEnd,Orientation,ExpTime)
AngVel=[];
for Event=1:size(EventsBeg,1)
    Time=[];
    % Find the delta theta and the delta time
    DeltaTheta=diff(Orientation(EventsBeg(Event):EventsEnd(Event)));
   %%%%%%%%%%%%%%% Delta Time calculation%%%%%%%%%%%%%%%%%%%%%
   Time=datevec(ExpTime(EventsBeg(Event):EventsEnd(Event)));
   DeltaTime=etime(Time(2:size(Time,1),:),Time(1:size(Time,1)-1,:));
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
 
    % Eliminate the angles related with non-defined positions (1000000).
    % These angles are 0 or larger than 1e5.
    if ~isempty(find( DeltaTheta~=0 &  abs(DeltaTheta)<1e5))
        AngVel=[AngVel;abs(DeltaTheta(find( DeltaTheta~=0 &  abs(DeltaTheta)<1e5))*(pi/180))./DeltaTime(find( DeltaTheta~=0 &  abs(DeltaTheta)<1e5))];
    else % only one-2 points in the event
       AngVel=[AngVel;NaN];  
    end
    %%%%%%%%%%%%%%%%%%%%%%%%
    
   
    
    
end

end
