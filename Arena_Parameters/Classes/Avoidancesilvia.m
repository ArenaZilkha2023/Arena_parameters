classdef Avoidance
    %All related with avoidance
    %% NOTE MOUSE 1 IS RUNNING AWAY FROM MOUSE 2 , MOUSE 1 IS AVOIDING
    
    
    properties
      numOfMice %number of mice 
      Distance_thresh; % According GV 400 in mm
      Dist_thresh_Fine_Tuning; %according GV it is 100 in mm
      velThr; %according GV 35cm/sec
      R; %according GV 30cm
    end
    %% 
    
    methods
        %% ----------------Calculation of avoidance WITHOUT REPEATS--------------------
        
        function AvoidanceCal=AvoidanceCal(obj,TrajectoryX,TrajectoryY,Velocity,isInArena,RepeatedFrames)
         
         hbar=waitbar(0,'Calculating avoidance')
    
         Distance_thresh=obj.Distance_thresh;
         Dist_thresh_Fine_Tuning=obj.Dist_thresh_Fine_Tuning;
         velThr=obj.velThr;
         R=obj.R;
         
         avoiding_to_all=cell(1,obj.numOfMice);
         j=1;
         %% ---Looping for every mouse ----------------
       
         for mouse1=1:obj.numOfMice
                 
                 Trajectory1=[]; %define variable
                 others=setdiff(1:obj.numOfMice,mouse1);
                 Trajectory1=[TrajectoryX(:,mouse1) TrajectoryY(:,mouse1)];
                 Trajectory1(~isInArena(:,mouse1))=0; %in the case is not in the arena
                 
                 if isempty(find(isInArena(:,mouse1)==1))%in the case all the arena is zero and not mouse in the arena
                     Trajectory1=0;
                 end
                 
              if sum(sum( Trajectory1))==0
              continue; %continue with another mouse
              else
                    
                     for mouse2=others
                         %% Reset and clear variables
                           
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
                               avoiding1of2=detectAvoidance(Trajectory1,Trajectory2,Velocity(:,mouse1),Velocity(:,mouse2),Distance_thresh,Dist_thresh_Fine_Tuning,velThr,R);  
                                  if ~isempty(avoiding1of2)
                                     avoiding1of2=[avoiding1of2(:,1) avoiding1of2(:,2) mouse2*ones(size(avoiding1of2,1),1) RepeatedFrames(avoiding1of2(:,1)) RepeatedFrames(avoiding1of2(:,2))];%the first intervals correspond to without repeats 
                                      avoiding_to_all{mouse1}=[avoiding_to_all{mouse1};avoiding1of2];
                                  end    
                               end

                    end

              end
         waitbar(j/length(length(obj.numOfMice)));
         j=j+1;
         end
     
         %% 
            
            
         close(hbar);
         AvoidanceCal=avoiding_to_all;
        end
        
        
       
        
        
        %% 
        
        
        
        
        
        
    end
    
end

%% ---------------------------------------Auxiliary functions-----------------------------------------
function avoidance=detectAvoidance(Trajectory1,Trajectory2,Velocity1,Velocity2,Distance_thresh,Dist_thresh_Fine_Tuning,velThr,R)

%find the events with distance between mice  close less than a threshold.IN
%GV the threhold was 40cm.

Distance=dist_calc(Trajectory1,Trajectory2);
IndexProximity=Distance<Distance_thresh;
[Index_proximityBeg Index_proximityEnd]=getEventsIndexesGV(IndexProximity,length(Distance));

j=1;
avoidance=[];
%Fine tunning aproaching events
 if ~isempty(Index_proximityBeg)%if there are events
    for i=1:length(Index_proximityBeg) %loop over each event
     Seg=Index_proximityBeg(i):Index_proximityEnd(i);
     velocity1=Velocity1(Seg);
     velocity2=Velocity2(Seg);
     trajectory1=Trajectory1(Seg,:);
     trajectory2=Trajectory2(Seg,:);
     distance=Distance(Seg);
     
      if isavoiding(velocity1,velocity2,distance,trajectory1,trajectory2,Dist_thresh_Fine_Tuning,velThr,R)
            avoidance(j,:)=[Seg(1) Seg(end)]; %get the intervals of avoidance
            j=j+1;
      end
     
    end

 end
end

%% 
function flag=isavoiding(velocity1,velocity2,distance,trajectory1,trajectory2,Dist_thresh_Fine_Tuning,velTr1,R)
%Remember that this function receives only the variables related with
%events in which trajectories are nearby and the velocity1 of the avoiding
%mouse is static , this means the mouse is static(less than 0.5 cm/sec) until 2 is approaching

flag=false;
I=(distance<Dist_thresh_Fine_Tuning) & (velocity1<0.5);
i=find(I==1,1,'last'); %find the index before it is open

n=length(distance);
%% 
%The Correlation was introduced by GV
% c=corrcoef(trajectory1(i:end,:),trajectory2(i:end,:)); %if the c(2) is positive means that they move at the end in the same direction
%Since the correlation didn't detect the cases the mice go in opposite
% %direction - we treated the angle instead the correlation.
% flag_angle=Flag_angle(trajectory1(i:end,:),trajectory2(i:end,:));



%% 

% if c(2)>0
% if flag_angle==1
    if ~isempty(i)
        if i<n-2&&i>1 %Avoid situation that i is the beggining or end of the interval
          if sum(velocity1(i+1:n)>velTr1)>=(n-i)/2 %mouse1 running away from mouse 2 -this gives the difference with approaching
%             T=trajectory1(i,:);
%             D1=sum(sqrt((trajectory2-repmat(T,n,1)).^2),2);
%             
%                if sum(D1(i+1:n)>R)==0 %the mouse 2 is not far from mouse1 but the are not touching
%                     flag=true;
%                 end
           %Assure that the avoiding is not developed into chasing            
                angle=Calc_angle(trajectory1(i:end,:),trajectory2(i:end,:));    
                    if angle>40 %the event doesn't progress into chasing
                       flag=true; 
                        
                    end

              
          end    
            
        end
        
    end    
    
%  end




end
%% Calculation direction between trajectories
function flag_angle=Flag_angle(trajectory1,trajectory2)
if ~isempty(trajectory1)&& ~isempty(trajectory2)
a(:,:)=trajectory1(1,:,:);
b(:,:)=trajectory1(2:end,:,:);
distance1=b-repmat(a,size(b,1),1);

c(:,:)=trajectory2(1,:,:);
d(:,:)=trajectory2(2:end,:,:);
distance2=d-repmat(c,size(d,1),1);

    Iflag=dot(distance1,distance2,2)<0; %means that the 2 mices are moving in opposite direction

    if Iflag==1
    
  flag_angle=0; %opposite direction are not considered
    else
    flag_angle=1;
    
    end
else
    
    flag_angle=0; 
end


end

%% Calculation of the angle at the end of the event to be sure that the avoiding is not converting into chasing

function angle=Calc_angle(trajectory1,trajectory2)
   if ~isempty(trajectory1)&& ~isempty(trajectory2)
         d1=trajectory1(end,:)-trajectory1(1,:);
         d2=trajectory2(end,:)-trajectory2(1,:);
         angle1=dot(d1,d2)/(norm(d1)*norm(d2));
         angle=acosd(angle1);

   end

end



