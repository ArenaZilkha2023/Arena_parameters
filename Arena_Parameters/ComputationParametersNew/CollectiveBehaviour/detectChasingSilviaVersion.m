function [chasing chasedby  IndexChasing]=detectChasingSilviaVersion(Trajectory1,Trajectory2,Velocity1,Velocity2,...
                                 Vector1,Vector2,timeLine,Velocity_Tresh,IForDistance,numMice,angle_threshold,TrajectoryThresh)
 %% 
j1=1;j2=1;j3=1;j=0;
chasing=[];
chasedby=[];
together=[];
IndexChasing=[];
% allevents=[];
% Par=zeros(1,numMice); %for 5 mice

%% ------- Calculate the angle between the velocities (see when they are moving in the same direction aproximately)
AngleVelocities=FindVelocityDirection(Vector1(:,1),Vector1(:,2),Vector2(:,1),Vector2(:,2));
 IangleVelocity=(abs(AngleVelocities) < angle_threshold );
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% - Calculate the movement angle- angle between reference mouse velocity and the join between the 2 mice
dx1=[0; diff(Trajectory1(:,1))];
dy1=[0; diff(Trajectory1(:,2))];
AngleMovement=FindAngle(Trajectory1(:,1),Trajectory1(:,2),Trajectory2(:,1),Trajectory2(:,2),dx1,dy1);
IangleMovement=(abs(AngleMovement) < angle_threshold );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ---Select chasing events with a given velocity threshold-------------
Ivelocity=(Velocity1>Velocity_Tresh)& (Velocity2>Velocity_Tresh);

%% ----------------Find the  points in time with 2 mice inside arena , without non-defined coordinates, with velocity in the same direction,
% and the reference mouse points to the second mouse- also consider
% velocity for each mice larger than the static velocity
Iselection=IForDistance & IangleVelocity & IangleMovement & Ivelocity;
 
%% ----------------------Look for the intervals---------------------------
[EventsBeg EventsEnd]=getEventsIndexesGV(Iselection,length(Iselection));

%% -------------------Find intervals with trajectories for each mice larger than a certain threshold-
%----------10---------------
if ~isempty(EventsBeg)

% Loop over the events
%--------11---------------
 for cevents=1:length(EventsBeg)
%------------22-------------    
     if (EventsBeg(cevents)-1)>0
             %calculate delta time
             timeline=timeLine(EventsBeg(cevents)-1:EventsEnd(cevents));
             timeline=RemoveDoubleString(timeline); % Remove double string
             timeVec=etime(datevec(timeline(2:end)),datevec(timeline(1:end-1)));
             vel1=Velocity1(EventsBeg(cevents):EventsEnd(cevents),:);
             vel2=Velocity2(EventsBeg(cevents):EventsEnd(cevents),:);
             % Distance of the selected trajectory for each mouse
              dist1=sum(vel1.*timeVec);
              dist2=sum(vel2.*timeVec);
              
  %--------------33-------------------            
  %--Consider only trajectories larger than a given threshold----------            
            if  (dist1 > TrajectoryThresh) & (dist2 > TrajectoryThresh) 
                IndexChasing=[IndexChasing [EventsBeg(cevents):EventsEnd(cevents)]];
                chasing(j1,:)=[EventsBeg(cevents) EventsEnd(cevents)];
                j1=j1+1;
                chasedby(j2,:)=[EventsBeg(cevents) EventsEnd(cevents)];
                j2=j2+1;
            end
  %--------------33------------------            
     end
%-----------22-------------    
end
%--------11------------------

end
%--------10------------
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%% Auxiliary functions%%%%%%%%%%%%%

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
%% Remove double string from the time

function TimeExp=RemoveDoubleString(TimeExp)

    for count=1:size(TimeExp,1)
       TimeExp(count,1)=strrep(TimeExp(count,1),'''','');
    end

end
%% 
function [result]=FindVelocityDirection(vx1,vy1,vx2,vy2)

%% % vector of movement second mouse -mouse one is the reference
vmov1=[vx1,vy1];
%vector movement
vmov2=[vx2,vy2];
%% %calculate angle between vectors
Modvmov2=sqrt(sum((vmov2).^2,2));
Modvmov1=sqrt(sum((vmov1).^2,2));
% if Modvmov2~=0 & Modvmov~=0
coseno=dot(vmov1,vmov2,2)./(Modvmov2.*Modvmov1); %dot between columns
result=acos(coseno)*180/pi;
% else
%     result=1000;
% end
end
% 
function [result]=FindAngle(x,y,x1,y1,dx,dy)

%% % vector of location between mouse 
vloc=[x1-x,y1-y];
%vector movement
vmov=[dx,dy];
%% %calculate angle between vectors
Modvloc=sqrt(sum((vloc).^2,2));
Modvmov=sqrt(sum((vmov).^2,2));
coseno=dot(vloc,vmov,2)./(Modvloc.*Modvmov);
result=acos(coseno)*180/pi;
end