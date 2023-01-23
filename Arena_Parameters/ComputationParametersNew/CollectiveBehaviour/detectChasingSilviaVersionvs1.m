function [chasing chasedby  IndexChasing allevents ]=detectChasingSilviaVersion(Trajectory1,Trajectory2,Velocity1,Velocity2,...
                                 Vector1,Vector2,timeLine,Dist_tresh1,Velocity_Tresh,PathTresh,Dist_tresh2,IForDistance,numMice,angle_threshold)
 %% 
j1=1;j2=1;j3=1;j=0;
chasing=[];
chasedby=[];
together=[];
IndexChasing=[];
allevents=[];
Par=zeros(1,numMice); %for 5 mice
                       
                             %% 
 
%-----------Difference between the 2 trajectories------------------------
DistFun=@(t1,t2) sqrt(sum((t1-t2).^2,2));
Distance=DistFun(Trajectory1,Trajectory2);
%----------------------------------find near trajectories-------------------

Index_proximity=Distance<Dist_tresh1 & IForDistance;
[Index_proximityBeg Index_proximityEnd]=getEventsIndexesGV(Index_proximity,length(Index_proximity));%find events

%--------------------------------------------------------------------------------------------
 %%%%%%%%%%  Loop over each event %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:length(Index_proximityBeg) %loop for each interval
    Ind_Seg=Index_proximityBeg(i):Index_proximityEnd(i); % range of proximity
    IndHighVelocity=Velocity1(Ind_Seg)>Velocity_Tresh&Velocity2(Ind_Seg)>Velocity_Tresh; %Find inside the events,events with high velocity
   % Check Velocity1 and velocity 2 in the same direction
    angleV1ToV2=FindAngleDirection(Vector1(Ind_Seg,1),Vector1(Ind_Seg,2),Vector2(Ind_Seg,1),Vector2(Ind_Seg,2)); %in degrees
    IangleV1ToV2=angleV1ToV2<angle_threshold;
    % Check that the mice aren't in parallel 
     angleV1ToT2=FindAngleDirection(Vector1(Ind_Seg,1),Vector1(Ind_Seg,2),(Trajectory2(Ind_Seg,1)-Trajectory1(Ind_Seg,1)),(Trajectory2(Ind_Seg,2)-Trajectory1(Ind_Seg,2)));
     IangleV1ToT2=angleV1ToT2<angle_threshold;
    % Join all the conditions
    IindAll=IndHighVelocity & IangleV1ToV2 & IangleV1ToT2;
    
    % Find the subintervals
    [Index_HVBeg Index_HVEnd]=getEventsIndexesGV(IindAll,length(IindAll));%index by considering the velocity and trajectory and angles
    interval=Ind_Seg(Index_HVEnd)-Ind_Seg(Index_HVBeg); %Original interval with velocity and trajectory assumptions
%---444-------------------------------
    if ~isempty(interval)
        [temp ind_max]=max(interval);
        Seg=Index_HVBeg(ind_max(1)):Index_HVEnd(ind_max(1));%Segment of probable chasing
        vel1=Velocity1(Ind_Seg(Seg),:);
        vel2=Velocity2(Ind_Seg(Seg),:); %consider the larger interval of probable chasing
        j=j+1;
        % possible events for chasing
         allevents(j,:)=[Ind_Seg(Index_HVBeg(ind_max(1))) Ind_Seg(Index_HVEnd(ind_max(1))) 0];
 %---555---------------------------------------------------------------------------------
         if (Ind_Seg(Seg(1))-1)>0
             %calculate delta time
             timeline=timeLine(Ind_Seg(Seg(1))-1:Ind_Seg(Seg(length(Seg))),1);
             timeline=RemoveDoubleString(timeline); % Remove double string
             timeVec=etime(datevec(timeline(2:end)),datevec(timeline(1:end-1)));
             % Distance of the selected trajectory for each mouse
              dist1=sum(vel1.*timeVec);
              dist2=sum(vel2.*timeVec);
             % Add additional conditions
                trajectory1=Trajectory1(Ind_Seg(Seg),:); %all the trajectory in the selected segment
                trajectory2=Trajectory2(Ind_Seg(Seg),:);
                T1=trajectory1(1,:); % first point
                T2=trajectory1(1,:); % first point
                d1=DistFun(trajectory1,repmat(T1,size(trajectory1,1),1)); %find distance respect first point
                d2=DistFun(trajectory2,repmat(T2,size(trajectory2,1),1));
                
                
                    %----------------------777--------------
                    if(dist1>PathTresh&&dist2>PathTresh) % check that the interval isn't so short
                        
                    %----------------888-------------  
                     
                             
                        %------------------999--------------------------
                        
                             IndexChasing=[IndexChasing  Ind_Seg(Seg)];
                             chasing(j1,:)=[Ind_Seg(Index_HVBeg(ind_max(1))) Ind_Seg(Index_HVEnd(ind_max(1)))];
                              j1=j1+1;
                              allevents(j,3)=1;
                              
                              
%                                chasedby(j2,:)=[Ind_Seg(Index_HVBeg(ind_max(1))) Ind_Seg(Index_HVEnd(ind_max(1)))];
%                                 j2=j2+1; 

                    end  
                        
                        %---------------999-------------------
                           
                      
                    
                    %--------------888-----------
                    
                    end
                    %----------------------777---------------
                    
                    
                    
                end
                %------------------------666-------------
                
                
                
         end
 %---555--------------------------------------------------        
         
         
         
end        
         
 
%---444------------------------------------------    


                             
                             
                             
                             
                             
                             
                             

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
function [result]=FindAngleDirection(dx,dy,dx1,dy1)

%% % vector of movement second mouse 
vmov2=[dx1,dy1];
%vector movement
vmov=[dx,dy];
%% %calculate angle between vectors
Modvmov2=sqrt(sum((vmov2).^2,2));
Modvmov=sqrt(sum((vmov).^2,2));
% if Modvmov2~=0 & Modvmov~=0
coseno=dot(vmov,vmov2,2)./(Modvmov2.*Modvmov); %dot between columns
result=acos(coseno)*180/pi;
% else
%     result=1000;
% end
end
