%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The idea is 2 find when 2 mice inside the arena are together
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function TogetherCalc=TogetherCalc(Locomotion,DistanceToBeTogether)
        
          hbar=waitbar(0,'Calculating Together')
        %% Variable Definition
           TrajectoryX=Locomotion.AssigRFID.XcoordMM;
           TrajectoryY=Locomotion.AssigRFID.YcoordMM;
           isInArena=Locomotion.AssigRFID.Arena.InArena;
           together=zeros(size(TrajectoryX,2),size(TrajectoryX,2)); % size as the number of mice
           together_all=cell(1,size(TrajectoryX,2));
 %% ------------------------Loop over every mice ---------------
 for mouse1=1:size(Locomotion.AssigRFID.miceList,1)
     others = setdiff(1:size(Locomotion.AssigRFID.miceList,1),mouse1);
     Trajectory1=[TrajectoryX(:,mouse1) TrajectoryY(:,mouse1)];
     Trajectory1(~isInArena(:,mouse1)|(TrajectoryX(:,mouse1)==1e6))=0; % if it is outside the arena and the trayectory is non-defined
     if sum(sum(Trajectory1))==0 %in the case is not in the arena
           continue;
     else     
     
           for mouse2=others % loop over the other mice
            % Find both in the arena without hiding box
             Trajectory2=[TrajectoryX(:,mouse2) TrajectoryY(:,mouse2)];
             Trajectory2(~isInArena(:,mouse2)|(TrajectoryX(:,mouse2)==1e6))=0; % if it is outside the arena and the trayectory is non-defined
             if sum(sum(Trajectory2))==0 %in the case is not in the arena
                continue;
            else     
        %
                IbothArena=isInArena(:,mouse1)& isInArena(:,mouse2) ;
                Inondefined=(TrajectoryX(:,mouse1)==1e6)|(TrajectoryX(:,mouse2)==1e6); 
                IForDistance=IbothArena & ~Inondefined;
       
        
                [timeTogether Index_proximityBeg Index_proximityEnd]=detectTogether(Trajectory1,Trajectory2,IForDistance,DistanceToBeTogether,Locomotion.ExperimentTime); 
                   if ~isempty(timeTogether)
                      together(mouse1,mouse2)=timeTogether; %this is a matrix nxn (n number of mice) each value represents the number of times they were together

                      together12=[Index_proximityBeg Index_proximityEnd mouse2*ones(length(Index_proximityBeg),1)];%at the end were included real frames
                      
                      together_all{mouse1}=[together_all{mouse1};together12];
                  
                  end        
             end
           end
     
     end  
      waitbar(mouse1/size(TrajectoryX,2));
       TogetherCalc=[together_all,together];
 end
     close(hbar);
end

%% 
%% ---Insert Auxiliary functions-------------------
        
  function  [timeTogether Index_proximityBeg  Index_proximityEnd]=detectTogether(Trajectory1,Trajectory2,IForDistance,DistanceToBeTogether,ExperimentTime)
ElapseTime=[];
timeTogether=[];

Distance=sqrt(sum((Trajectory1-Trajectory2).^2,2)); %distance between mice
Index_proximity=Distance<DistanceToBeTogether & IForDistance;
% get the events of together
[Index_proximityBeg Index_proximityEnd]=getEventsIndexesGV(Index_proximity,length(Index_proximity));
% get the time together
for count=1:size(Index_proximityBeg,1)
ElapseTime(count)=MeasureTimeDifference(ExperimentTime(Index_proximityEnd(count),1), ExperimentTime(Index_proximityBeg(count),1));
end
if ~isempty(ElapseTime)
timeTogether=sum(ElapseTime);
end
end      
        
%% ---------To find ones------------------
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

 %% Time difference between frames

function ElapseTime=MeasureTimeDifference(TimeAfter, TimeBefore)

TimeAfter=RemoveDoubleString(TimeAfter);
TimeBefore=RemoveDoubleString(TimeBefore);

%translate TimeExp to vector

TimeVectorAfter=datevec(TimeAfter,'HH:MM:SS.FFF');
TimeVectorBefore=datevec(TimeBefore,'HH:MM:SS.FFF');

ElapseTime=abs(etime(TimeVectorAfter,TimeVectorBefore));% this is given in second

end
%% Remove double string from the time

function TimeExp=RemoveDoubleString(TimeExp)

    for count=1:size(TimeExp,1)
       TimeExp(count,1)=strrep(TimeExp(count,1),'''','');
    end

end