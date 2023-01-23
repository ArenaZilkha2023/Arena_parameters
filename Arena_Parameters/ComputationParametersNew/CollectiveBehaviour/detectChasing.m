function [chasing chasedby  IndexChasing allevents ]=detectChasing(Trajectory1,Trajectory2,Velocity1,Velocity2,...
                                 Vector1,Vector2,timeLine,Dist_tresh1,Velocity_Tresh,PathTresh,Dist_tresh2,IForDistance,numMice)
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
[Index_proximityBeg Index_proximityEnd]=getEventsIndexesGV(Index_proximity,length(timeLine));%find events

%--------------------------------------------------------------------------------------------
 %%%%%%%%%%  Loop over each event %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:length(Index_proximityBeg) %loop for each interval
    Ind_Seg=Index_proximityBeg(i):Index_proximityEnd(i); % range of proximity
    IndHighVelocity=Velocity1(Ind_Seg)>Velocity_Tresh&Velocity2(Ind_Seg)>Velocity_Tresh; %Find inside the events,events with high velocity
    [Index_HVBeg Index_HVEnd]=getEventsIndexesGV(IndHighVelocity,length(Ind_Seg));%index by considering the velocity and trajectory
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
                T2=trajectory2(1,:); % first point
                d1=DistFun(trajectory1,repmat(T1,size(trajectory1,1),1)); %find distance respect first point
                d2=DistFun(trajectory2,repmat(T2,size(trajectory2,1),1));
                
                [F C D]=iscorrelated(trajectory1,trajectory2);
                %---------------666----------------
                if sum(d1>=Dist_tresh2)>0&&sum(d2>=Dist_tresh2)>0 %out of 20 cm radius
                    %----------------------777--------------
                    if((dist1>PathTresh&&dist2>PathTresh)||...,
                        (DistFun(trajectory1(1,:),trajectory1(end,:))>=Dist_tresh2&&DistFun(trajectory2(1,:),trajectory2(end,:))>=Dist_tresh2))
                    %----------------888-------------  
                      if (F) % correlation
                             vec1=Vector1(Ind_Seg(Seg),:);
                             vec1=vec1./[sqrt(sum(vec1.^2,2)) sqrt(sum(vec1.^2,2))];
                             vec2=trajectory2-trajectory1;
                             vec2=vec2./[sqrt(sum(vec2.^2,2)) sqrt(sum(vec2.^2,2))];
                             %ii=~isnan(vec1)&~isnan(vec2);
                             flag=dot(vec1,vec2,2);
                             flag=sum(flag(~isnan(flag)));
                             coseno=dot(vec1,vec2,2);
                            angle=acos(coseno)*180/pi;
                        %------------------999--------------------------
                        if flag>0  % This means that mouse 1 chase mouse 2 and the angle less than 15 degrees to avoid paralell cases
                             IndexChasing=[IndexChasing  Ind_Seg(Seg)];
                             chasing(j1,:)=[Ind_Seg(Index_HVBeg(ind_max(1))) Ind_Seg(Index_HVEnd(ind_max(1)))];
                              j1=j1+1;
                              allevents(j,3)=1;
                              
                              elseif flag<0
                               chasedby(j2,:)=[Ind_Seg(Index_HVBeg(ind_max(1))) Ind_Seg(Index_HVEnd(ind_max(1)))];
                                j2=j2+1; 

                         end
                        
                        %---------------999-------------------
                           
                       end
                    
                    %--------------888-----------
                    
                    end
                    %----------------------777---------------
                    
                    
                    
                end
                %------------------------666-------------
                
                
                
         end
 %---555--------------------------------------------------        
         
         
         
         
         
    end
%---444------------------------------------------    
end

                             
                             
                             
                             
                             
                             
                             
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
function [flag C D]=iscorrelated(trajectory1,trajectory2)

CorTresh=.7;%.75
flag=false;
C=0;

D=dot(trajectory1(end,:)-trajectory1(1,:),trajectory2(end,:)-trajectory2(1,:)); % actually is the dot
% between the beggining and the end of the vector- the sign will change if
% the direction is different

if size(trajectory1,1)>4
    ccx=corrcoef(trajectory1(:,1),trajectory2(:,1));
    ccy=corrcoef(trajectory1(:,2),trajectory2(:,2));
    cc=(ccx+ccy)/2;
    %first is correlation second is for cutting out the cases of coming
    %forward each other
    C=cc(2);
    if cc(2)>CorTresh&&dot(trajectory1(end,:)-trajectory1(1,:),trajectory2(end,:)-trajectory2(1,:))>0
        flag=true;
    end
end
end
