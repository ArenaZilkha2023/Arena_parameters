classdef Approaching
    %All related with avoidance
    %% NOTE MOUSE 1 IS RUNNING AWAY FROM MOUSE 2 , MOUSE 1 IS AVOIDING
    
    
    properties
      numOfMice; %number of mice 
      Distance_thresh; % According GV 400 in mm
      distTr;%According GV it is 100mm or 10cm
      CorrelFactor;%according to GV this factor is around 0.3
      velTr2;%according GV it is 25 cm/sec
     
    end
    %% 
    
    methods
        %% ----------------Calculation of approaching WITHOUT REPEATS--------------------
        
        function ApproachingCal=ApproachingCal(obj,TrajectoryX,TrajectoryY,Velocity,isInArena,VectorX,VectorY)
         
         hbar=waitbar(0,'Calculating approaching')
%     
         Distance_thresh=obj. Distance_thresh;
         distTr=obj. distTr;
         CorrelFactor=obj.CorrelFactor;
         velTr2=obj.velTr2;
         
         approaching_to_all=cell(1,obj.numOfMice);
         being_approached_all=approaching_to_all;
         j=1;
         %% ---Looping for every mouse ----------------
         for mouse1=1:obj.numOfMice

                 Trajectory1=[]; %define variable
                 Vector1=[];
                 others=setdiff(1:obj.numOfMice,mouse1);
                 Trajectory1=[TrajectoryX(:,mouse1) TrajectoryY(:,mouse1)];
                  Trajectory1(~isInArena(:,mouse1))=0; %in the case is not in the arena
                 
                 if isempty(find(isInArena(:,mouse1)==1))%in the case all the arena is zero and not mouse in the arena
                     Trajectory1=0;
                 end
              if sum(sum( Trajectory1))==0
              continue; %continue with another mouse
              else
                   Vector1=[VectorX(:,mouse1) VectorY(:,mouse1)];  
                     for mouse2=others
                         %% Reset and clear variables
                           being_approached=[];
                           avoiding1of2=[];
                           Trajectory2=[];
                           %% 

                           Trajectory2=[TrajectoryX(:,mouse2) TrajectoryY(:,mouse2)];
                           Trajectory2(~isInArena(:,mouse2))=0; %in the case is not in the arena
                           if isempty(find(isInArena(:,mouse2)==1))%in the case all the arena is zero and not mouse in the arena
                                Trajectory2=0;    
                           end
            
                               if sum(sum( Trajectory2))==0
                                  continue; %continue with another mouse
                               else
                               approaching1to2=detectApproach(Trajectory1,Trajectory2,Velocity(:,mouse1),Velocity(:,mouse2),Distance_thresh,Vector1,distTr,CorrelFactor,velTr2);  
                                  if ~isempty(approaching1to2)
                                     being_approached=[approaching1to2(:,1) approaching1to2(:,2) mouse1*ones(size(approaching1to2,1),1)]; 
                                     approaching1to2=[approaching1to2(:,1) approaching1to2(:,2) mouse2*ones(size(approaching1to2,1),1)];%the first intervals correspond to without repeats 
                                     approaching_to_all{mouse1}=[approaching_to_all{mouse1};approaching1to2];
                                     being_approached_all{mouse2}=[being_approached_all{mouse2};being_approached];
                                  end    
                               end

                     end
                     
                     
              end
              
               waitbar(j/length(length(obj.numOfMice)));
              j=j+1;
              

         end

         %% 
            
            
         close(hbar);
         ApproachingCal=[approaching_to_all,being_approached_all];
        end
        
        
       
        
        
        %% 
        
        
        
        
        
        
    end
    
end

%% ---------------------------------------Auxiliary functions-----------------------------------------
function approach=detectApproach(Trajectory1,Trajectory2,Velocity1,Velocity2,Distance_thresh,Vector1,distTr,CorrelFactor,velTr2)

%find the events with distance between mice  close less than a threshold.IN
%GV the threhold was 40cm.

Distance=dist_calc(Trajectory1,Trajectory2);

% IndexProximity=Distance<Distance_thresh;

IndexProximity=Distance(1:length(Velocity1))<Distance_thresh & Velocity1<1e6 & Velocity2<1e6;
[Index_proximityBeg Index_proximityEnd]=getEventsIndexesGV(IndexProximity,length(IndexProximity));

%% Addition to Vector1 to get same length as the other vectors
Vector1(length(Velocity1),:)=[0 0];

%% 


j=1;
approach=[];
%Fine tunning aproaching events
 if ~isempty(Index_proximityBeg)%if there are events
    for i=1:length(Index_proximityBeg) %loop over each event
     Seg=Index_proximityBeg(i):Index_proximityEnd(i);
     velocity1=Velocity1(Seg);
     velocity2=Velocity2(Seg);
     trajectory1=Trajectory1(Seg,:);
     trajectory2=Trajectory2(Seg,:);
     vector1=Vector1(Seg,:);
     distance=Distance(Seg);
     
      if isapproaching(velocity1,velocity2,distance,trajectory1,trajectory2,vector1,distTr,CorrelFactor,velTr2)
            approach(j,:)=[Seg(1) Seg(end)]; %get the intervals of avoidance
            j=j+1;
      end
     
    end

 end
end

%% 
function flag=isapproaching(velocity1,velocity2,distance,trajectory1,trajectory2,vector1,distTr,CorrelFactor,velTr2)
%Remember that this function receives only the variables related with
%events in which trajectories are nearby.

flag=false;


trajectory=trajectory1-trajectory2;
N=sqrt(sum(trajectory.^2,2));
trajectory=trajectory./[N N]; %type of normalization

[m i]=min(distance);
n=length(distance);

T=trajectory2(i,:);
D2=sum(sqrt((trajectory2-repmat(T,n,1)).^2),2);

if m<distTr %the minimum distance less than a threshold then could be approaching-distTR is GV 100mm
    if i>2 %far from the terminal
      c=corrcoef(trajectory(1:i,:),vector1(1:i,:));
        c=c(2);   
      if abs(c)>CorrelFactor% mouse1 is directing towards mouse2 Correlation factor is according GV o.3-this is like angle
            if sum(velocity2(i+1:n)<velTr2)>(n-i)/2 %mouse1 is approaching- in general velTr2 is 25 cm/sec mouse 2 is quiet
                flag=true;
            end
      end    
        
    end
     
end    



end
