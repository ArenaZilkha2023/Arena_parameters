function [approaching]=Approaching(Params,Locomotion)
% Method according Silvia
  hbar=waitbar(0,'Calculating second version of Chasing')
  %%Variable and parameters Definition
  numOfMice=size(Locomotion.AssigRFID.miceList,1);
  approaching_to_all=cell(1,numOfMice);
  being_approached_all=approaching_to_all; 
  approaching=zeros(numOfMice);
  
      TrajectoryX=Locomotion.AssigRFID.XcoordMM;
      TrajectoryY=Locomotion.AssigRFID.YcoordMM;
      isInArena=Locomotion.AssigRFID.Arena.InArena;
      Velocity=Locomotion.AssigRFID.VelocityMouse; % this is the mod (speed) velocity
      Vectorx=Locomotion.AssigRFID.VelocityMouseX; % this is the x component of velocity
      Vectory=Locomotion.AssigRFID.VelocityMouseY; % this is the y component of velocity
      DeltaX=diff(TrajectoryX);

      DeltaY=diff(TrajectoryY);
  %% 
   %% %%%%%%%%%%%%%%% Begin Calculation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  for mouse1=1:size(TrajectoryX,2) % Loop over every mouse
      
       others = setdiff(1:size(TrajectoryX,2),mouse1);
       Trajectory1=[TrajectoryX(:,mouse1) TrajectoryY(:,mouse1)];
       Trajectory1(~isInArena(:,mouse1)|(TrajectoryX(:,mouse1)==1e6))=0; % if it is outside the arena and the trayectory is non-defined
      if sum(sum(Trajectory1))==0 %in the case is not in the arena
           continue;
        else     
        Velocity1=Velocity(:,mouse1); 
         Vector1=[Vectorx(:,mouse1) Vectory(:,mouse1)];
       for mouse2=others % loop over the other mice
          % Find both in the arena without hiding box
          %% 
          % Reset variables
          clear angle1;
          clear angle2;
          clear ApproachingVector;
         
          
          %% 
          
             Trajectory2=[TrajectoryX(:,mouse2) TrajectoryY(:,mouse2)];
             Trajectory2(~isInArena(:,mouse2)|(TrajectoryX(:,mouse2)==1e6))=0; % if it is outside the arena and the trayectory is non-defined
                 if sum(sum(Trajectory2))==0 %in the case is not in the arena
                          continue;
                 else   
                       Velocity2=Velocity(:,mouse2); 
                       Vector2=[Vectorx(:,mouse2) Vectory(:,mouse2)];
                       timeLine=Locomotion.ExperimentTime;
                       IbothArena=isInArena(:,mouse1)& isInArena(:,mouse2) ;
                       Inondefined=(TrajectoryX(:,mouse1)==1e6)|(TrajectoryX(:,mouse2)==1e6); 
                       IForDistance=IbothArena & ~Inondefined; % assure both mouse in the arena and define
                       %% 
                       %% Calculate angle between line joining 1 to 2 and mouse 1 movement direction
             
                      angle1=cellfun(@FindAngle,num2cell(Trajectory1(1:size(DeltaX,1),1)),num2cell(Trajectory1(1:size(DeltaY,1),2)),...
                                    num2cell(Trajectory2(1:size(DeltaX,1),1)),num2cell(Trajectory2(1:size(DeltaY,1),2)),...
                                    num2cell(DeltaX(:,mouse1)),num2cell(DeltaY(:,mouse1)),'UniformOutput',false);   
                        
                         %% Calculate angle between movement of mouse 1 and movement of mouse 2
             
                      angle2=cellfun(@FindAngleDirection,num2cell(DeltaX(:,mouse1)),num2cell(DeltaY(:,mouse1)),...
                                    num2cell(DeltaX(:,mouse2)),num2cell(DeltaY(:,mouse2)),'UniformOutput',false);
                         
                          %% Distance between the 2 trajectories
                            DistFun=@(t1,t2) sqrt(sum((t1-t2).^2,2));
                            Distance=DistFun(Trajectory1,Trajectory2);
                      %% Looking for events in which the distance is less than a given value to be in contact.
                     
                      
                      % more than 20 cm check that mouse 1 points toward
                      % mouse 2 and the velocity is larger than 5 and the
                      % velocity of mouse 2 is smaller.

                       ApproachingVector=(Distance<Params.MaximumDistanceToApproach)& IForDistance;%this is a logical vector   
                        
% %                        % Get the events
                                   [BeginApproaching EndApproaching]=getEventsIndexesGV(ApproachingVector,length(ApproachingVector));
                                   v1=Velocity(1:size(DeltaY,1),mouse1);
                                   v2=Velocity(1:size(DeltaY,1),mouse2);
                                   
                            % If approaching 
                                if ~isempty(BeginApproaching)
                                   Approaching1To2=IsApproaching(mouse2,BeginApproaching,EndApproaching,v1,v2,Distance,angle1,angle2,Params.ApproachingAngle,Params.Aproaching_velocity,Params.VelocityApproachedMouse);
                                   approaching{mouse1}=[approaching{mouse1};Approaching1To2];
                                end
         
             end
                       
                      
                 end        
                     
      
      
      end
        waitbar(j/length(length(numOfMice)));  
  
  end
       close(hbar);
  end 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------------Auxiliary function----------------------------

%% 
function [result]=FindAngle(x,y,x1,y1,dx,dy)

%% % vector of location between mouse 
vloc=[x1-x,y1-y];
%vector movement
vmov=[dx,dy];
%% %calculate angle between vectors
Modvloc=norm(vloc);
Modvmov=norm(vmov);

if vloc==0 %the same coordinates as the angle is zero
    result=0;
elseif vmov==0
    result=1000;
else    
coseno=dot(vloc,vmov)/(Modvloc*Modvmov);
result=acos(coseno)*180/pi;
end
end
%% 

%% 
function [result]=FindAngleDirection(dx,dy,dx1,dy1)

%% % vector of movement second mouse 
vmov2=[dx1,dy1];
%vector movement
vmov=[dx,dy];
%% %calculate angle between vectors
Modvmov2=norm(vmov2);
Modvmov=norm(vmov);
if Modvmov2~=0 & Modvmov~=0
coseno=dot(vmov,vmov2)/(Modvmov2*Modvmov);
result=acos(coseno)*180/pi;
else
    result=1000;
end
end
%% 
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