function [chasing_all,being_chasing_all]=ChasingCalvs2(Params,Locomotion)
  hbar=waitbar(0,'Calculating second version of Chasing')
  %%Variable and parameters Definition
  numOfMice=size(Locomotion.AssigRFID.miceList,1);
  chasing_all=cell(1,numOfMice);
  being_chasing_all=cell(1,numOfMice); 
  
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
  %for mouse1=1:size(TrajectoryX,2) % Loop over every mouse
     for mouse1=1:size(Locomotion.AssigRFID.miceList,1)
         
      % others = setdiff(1:size(TrajectoryX,2),mouse1);
      others = setdiff(1:size(Locomotion.AssigRFID.miceList,1),mouse1);
      
       Trajectory1=[TrajectoryX(:,mouse1) TrajectoryY(:,mouse1)];
       Trajectory1(~isInArena(:,mouse1)|(TrajectoryX(:,mouse1)==1e6),:)=0; % if it is outside the arena and the trayectory is non-defined
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
          clear ChasingVector;
          clear BegChasingCorrected2;
          clear EndChasingCorrected2;
          
          %% 
          
             Trajectory2=[TrajectoryX(:,mouse2) TrajectoryY(:,mouse2)];
             Trajectory2(~isInArena(:,mouse2)|(TrajectoryX(:,mouse2)==1e6),:)=0; % if it is outside the arena and the trayectory is non-defined
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
                      %% Looking for chasing when the distance is less than a given angle and the velocity and angle conditions are satisfied.

                        ChasingVector=((cell2mat(angle1) < Params.AngleMaximum1) & (cell2mat(angle2) < Params.AngleMaximum2) & ...
                                       (IForDistance(1:size(DeltaY,1),1)==1) & (Velocity(1:size(DeltaY,1),mouse1)> Params.editpar3) & (Velocity(1:size(DeltaY,1),mouse2)>Params.editpar3) &...
                                       (Distance(1:size(DeltaY,1))<Params.editpar2));%this is a logical vector   
                        
%                       %% Caculate intervals
                         [BegChasingCorrected2 EndChasingCorrected2]=getEventsIndexesGV(ChasingVector,length(ChasingVector));
%                      
%                      %% -------------------------Select events-remove less than 3 events--------------
                       v1=Velocity(1:size(DeltaY,1),mouse1);
                       v2=Velocity(1:size(DeltaY,1),mouse2);
                       [ChasingVector ChasingVectorWithSmallEvents]=RealEvents1(BegChasingCorrected2, EndChasingCorrected2,...
                                                                    ChasingVector,DeltaX(:,mouse1),DeltaY(:,mouse1),...
                                                                    DeltaX(:,mouse2),DeltaY(:,mouse2),Params.editpar1,v1,v2);
%                      %% Calculate events for large events
                         [BegChasingCorrected1 EndChasingCorrected1]=getEventsIndexesGV(ChasingVector,length(ChasingVector)); 
%                      
%                      %% Calculate events for small events
%                         [BegChasingCorrected1S EndChasingCorrected1S]=getEventsIndexesGV(ChasingVectorWithSmallEvents,length(ChasingVectorWithSmallEvents)); 
%                      %% -------------------------------------------Unify events which are very near--------------------------------   
%                           %------Large events
                             ChasingVector=FillGap(BegChasingCorrected1, EndChasingCorrected1,ChasingVector,Trajectory1,Trajectory2,Params.editpar5,Params.editpar4);
%                             [BegChasingCorrected3 EndChasingCorrected3]=getEventsIndexesGV(ChasingVector,length(ChasingVector)); 
%              
%                          %----Small events-----------------
%                             ChasingVectorWithSmallEvents=FillGapSmall(BegChasingCorrected1S, EndChasingCorrected1S,ChasingVectorWithSmallEvents,Trajectory1,Trajectory2,Params.editpar7,Params.editpar6);
%                             [BegChasingCorrected3S EndChasingCorrected3S]=getEventsIndexesGV(ChasingVectorWithSmallEvents,length(ChasingVectorWithSmallEvents));   
%                     %----------------------Once we know the chasing events find the beggining and end of each event
%                            ChasingVector=FindEnds(BegChasingCorrected3, EndChasingCorrected3,ChasingVector,Trajectory1,Trajectory2,Params.editpar5);
%                            ChasingVectorWithSmallEvents=FindEnds(BegChasingCorrected3S, EndChasingCorrected3S,...
%                                                                 ChasingVectorWithSmallEvents,Trajectory1,Trajectory2,Params.editpar5);  
%                      
%                      %%---------------- Eliminate very small events
%            
%                           [BegChasingCorrected4S EndChasingCorrected4S]=getEventsIndexesGV(ChasingVectorWithSmallEvents,length(ChasingVectorWithSmallEvents)); %THIS ALL THE CHASING
%                            ChasingVectorWithSmallEvents=RealEvents(BegChasingCorrected4S, EndChasingCorrected4S,...
%                                                                       ChasingVectorWithSmallEvents,DeltaX(:,mouse1),DeltaY(:,mouse1),DeltaX(:,mouse2),DeltaY(:,mouse2),...
%                                                                       Params.editpar1,Velocity(1:size(DeltaY,1),mouse1),Velocity(1:size(DeltaY,1),mouse2),Params.editpar3);
%                    %% -------------------- Join the two chasing events with small and large events
% %             
%                        ChasingVector=or(ChasingVector,ChasingVectorWithSmallEvents);  
                       [BegChasingCorrected EndChasingCorrected]=getEventsIndexesGV(ChasingVector,length(ChasingVector)); %THIS ALL THE CHASING
%                       [BegChasingCorrectedS EndChasingCorrectedS]=getEventsIndexesGV(ChasingVectorWithSmallEvents,length(ChasingVectorWithSmallEvents));%For Small events
%              
%                      %make  a logical vector with small events
%                    %  SmallEvents=FoundSmallEvents(BegChasingCorrectedS,EndChasingCorrectedS,BegChasingCorrected, EndChasingCorrected);
             
                   if ~isempty(BegChasingCorrected)
                    %chasing12=[BegChasingCorrected EndChasingCorrected mouse2*ones(length(BegChasingCorrected),1) SmallEvents];%Return real frames
                    %beingchasing21=[BegChasingCorrected EndChasingCorrected mouse1*ones(length(BegChasingCorrected),1) SmallEvents]; 
                    chasing12=[BegChasingCorrected EndChasingCorrected mouse2*ones(length(BegChasingCorrected),1)];%Return real frames
                    beingchasing21=[BegChasingCorrected EndChasingCorrected mouse1*ones(length(BegChasingCorrected),1)]; 
                  
                    chasing_all{mouse1}=[chasing_all{mouse1};chasing12];
                    being_chasing_all{mouse2}=[ being_chasing_all{mouse2};beingchasing21];
                   end 
  %----------------------------------------------------------------------           
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

%% %% -------------First function for data filtering------------------
function [ChasingVector ChasingVectorWithSmallEvents] =RealEvents1(BegChasing, EndChasing,ChasingVector,Dx1,Dy1,Dx2,Dy2,MinimumPath,v1,v2)

ChasingVectorWithSmallEvents=[];

ChasingVectorWithSmallEvents=zeros(length(ChasingVector),1);


if ~isempty(BegChasing)
    
   for i=1:length(BegChasing)
       
       
     if  (EndChasing(i)-BegChasing(i))<3 
       
        ChasingVector(BegChasing(i):EndChasing(i))=0; %ELIMINATE CHASING EVENTS IF THERE AS LESS THAN 3 EVENTS
        
      
     else
       
    DeltaX1=Dx1(BegChasing(i):EndChasing(i));
    DeltaY1=Dy1(BegChasing(i):EndChasing(i));
    
    DeltaX2=Dx2(BegChasing(i):EndChasing(i));
    DeltaY2=Dy2(BegChasing(i):EndChasing(i));
    
    DistFun1=sum(sqrt((DeltaX1).^2+(DeltaY1).^2));%all the distance done during this chasing   
    DistFun2=sum(sqrt((DeltaX2).^2+(DeltaY2).^2));   
     
    if DistFun1< MinimumPath | DistFun2< MinimumPath
        
      ChasingVector(BegChasing(i):EndChasing(i))=0; %ELIMINATE CHASING EVENTS IF THE TRAYECTORY ARE VERY SMALL  
      ChasingVectorWithSmallEvents(BegChasing(i):EndChasing(i))=1; %CONSIDER ONLY SMALL EVENTS  
        
    end
    % If velocity inside the event is very high don't consider it
    if any(v1(BegChasing(i):EndChasing(i))>150) | any(v2(BegChasing(i):EndChasing(i))>150)
        ChasingVector(BegChasing(i):EndChasing(i))=0; %ELIMINATE CHASING EVENTS
    end
    
    
   end
   end
end
end
   
   %% 
  %% -----------This function fill gaps between chasing events
function ChasingVector=FillGap(BegChasing, EndChasing,ChasingVector,Trajectory1,Trajectory2,GapPathEnd,GapFrames)

if ~isempty(BegChasing)& length(BegChasing)>1
  for i=1:length(BegChasing)-1
    if (BegChasing(i+1)-EndChasing(i))<GapFrames %if the difference in frames between gaps in the chasing is less than a given value
     %check if the trajectories are near
     
   %-----------Difference between the 2 trajectories------------------------
          %   DistFun=@(t1,t2) sqrt(sum((t1-t2).^2,2));
%              Trajectory1(EndChasing(i)+1:BegChasing(i+1)-1,:)
%              Trajectory2(EndChasing(i)+1:BegChasing(i+1)-1,:)
          %   Distance=DistFun(Trajectory1(EndChasing(i)+1:BegChasing(i+1)-1,:),Trajectory2(EndChasing(i)+1:BegChasing(i+1)-1,:));
%----------------------------------find near trajectories-------------------
           
          %  Index_proximity=(Distance > GapPathEnd); %if this condition is empty the trajectory are near then the chasing is filled with one
           
           
            %  if isempty(find(Index_proximity)==1)
                ChasingVector(EndChasing(i)+1:BegChasing(i+1)-1)=1; 
    
           %   end


%--------------------------------------------------------------------------------------------  
     




   end
end
end
end  
%%
%% -----------This function fill gaps between SMALL chasing events
function ChasingVector=FillGapSmall(BegChasing, EndChasing,ChasingVector,Trajectory1,Trajectory2,GapPathEndS,GapFramesS)

if ~isempty(BegChasing)& length(BegChasing)>1
 for i=1:length(BegChasing)-1
    if (BegChasing(i+1)-EndChasing(i))<GapFramesS %if the difference in frames between gaps in the chasing is less than a given value REDUCE TEN TIMES THE GAP
     %check if the trajectories are near
     
   %-----------Difference between the 2 trajectories------------------------
             DistFun=@(t1,t2) sqrt(sum((t1-t2).^2,2));
%              Trajectory1(EndChasing(i)+1:BegChasing(i+1)-1,:)
%              Trajectory2(EndChasing(i)+1:BegChasing(i+1)-1,:)
             Distance=DistFun(Trajectory1(EndChasing(i)+1:BegChasing(i+1)-1,:),Trajectory2(EndChasing(i)+1:BegChasing(i+1)-1,:));
%----------------------------------find near trajectories-------------------
           
            Index_proximity=(Distance > GapPathEndS); %if this condition is empty the trajectory are near then the chasing is filled with one
           
           
              if isempty(find(Index_proximity)==1)
                ChasingVector(EndChasing(i)+1:BegChasing(i+1)-1)=1; 
    
              end


%--------------------------------------------------------------------------------------------  
     




   end
end
end
end
%% -------------------------Function to find the exact beggining and end of the chasing----------------------

function ChasingVector=FindEnds(BegChasing, EndChasing,ChasingVector,Trajectory1,Trajectory2,GapPath)

   %-----------Distance between the 2 trajectories------------------------
             DistFun=@(t1,t2) sqrt(sum((t1-t2).^2,2));
%           
            DistanceT=DistFun(Trajectory1(1:end,:),Trajectory2(1:end,:));
  A=length(ChasingVector);           
if ~isempty(BegChasing)
    
   for i=1:length(BegChasing)

%----------------Correct the beggining of the chasing---------------
     if (BegChasing(i)>1)
        IndBeginChasing=find(DistanceT(1:BegChasing(i)-1)>GapPath,1,'last');%the idea is to found the moment the trajectory are near
        
         if ~isempty( IndBeginChasing)
            ChasingVector(IndBeginChasing:BegChasing(i)-1)=1; %correct chasing vector
         end
         
     end

%---------------------------------------

%----------------Correct the end  of the chasing---------------
     if (EndChasing(i)<length(ChasingVector))
        IndEndChasing=find(DistanceT(EndChasing(i)+1:end)>GapPath,1,'first');%the idea is to found the moment the trajectory are separated at the end of the chasing
      
         if ~isempty(IndEndChasing)
             if (EndChasing(i)+1+IndEndChasing-1)<=A %to avoid go out of the chasing size
            ChasingVector(EndChasing(i)+1:EndChasing(i)+1+IndEndChasing-1)=1; %correct chasing vector
             end
          end
         
     end
   end
end

% B=length(ChasingVector)

end

 
%---------------------------------------
%% %% ----------------Second function for filtering
function ChasingVector=RealEvents(BegChasing, EndChasing,ChasingVector,Dx1,Dy1,Dx2,Dy2,MinimumPath,V1,V2,VelocityThresh)
clear DeltaX1;
clear DeltaX2;
clear DeltaY1;
clear DeltaY2;

% length(ChasingVector)

if ~isempty(BegChasing)
    
   for i=1:length(BegChasing)
       
       
     if  (EndChasing(i)-BegChasing(i))<10 %for small events less than 10 no consider
       
        ChasingVector(BegChasing(i):EndChasing(i))=0; %ELIMINATE CHASING EVENTS IF THERE AS LESS THAN 3 EVENTS
     
      
     else

       
    DeltaX1=Dx1(BegChasing(i):EndChasing(i));
    DeltaY1=Dy1(BegChasing(i):EndChasing(i));
    
    DeltaX2=Dx2(BegChasing(i):EndChasing(i));
    DeltaY2=Dy2(BegChasing(i):EndChasing(i));
    
   MedV1= median(V1(BegChasing(i):EndChasing(i)));
   MedV2= median(V2(BegChasing(i):EndChasing(i))); 
    
    DistFun1=sum(sqrt((DeltaX1).^2+(DeltaY1).^2));%all the distance done during this chasing   
    DistFun2=sum(sqrt((DeltaX2).^2+(DeltaY2).^2));   
     
    if DistFun1< MinimumPath | DistFun2< MinimumPath
        
      ChasingVector(BegChasing(i):EndChasing(i))=0; %ELIMINATE CHASING EVENTS IF THE TRAYECTORY ARE VERY SMALL  
    elseif   MedV1 < VelocityThresh | MedV2< VelocityThresh                   %check velocity median bigger than the thrheshold during this period if not it was not moving   
         ChasingVector(BegChasing(i):EndChasing(i))=0; %ELIMINATE CHASING EVENTS IF THE mouse is not moving enough for cases it is in the eating place all the time.
    end

   end
   
   
    
end

end

end
