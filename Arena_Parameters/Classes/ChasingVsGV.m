classdef Chasing
%All related with the chasing

    properties
        
       numOfMice; %number of mice
        %% ---------------------------------Settings used during these years----------------------
         Dist_tresh1;%40 in mm
         Velocity_Tresh;%1
         PathTresh;%80
         Dist_tresh2;
        
        
        
%         if(use_RFID_only==0)
%     Dist_tresh1=30;%40
%     Velocity_Tresh=.5;%1
%     PathTresh=60;%80
%     Dist_tresh2=20;
% elseif(RFID_SET==1) % RFID_1
%     Dist_tresh1=60; %30; 
%     Velocity_Tresh=.1; %.5;
%     PathTresh=50; %60;
%     Dist_tresh2=0; %20;
% elseif(RFID_SET==2) % RFID_1
%     Dist_tresh1=50; %30; 
%     Velocity_Tresh=.25; %.5;
%     PathTresh=50; %60;
%     Dist_tresh2=10;
% end
     end
    
    %----------------------------------------------------------------------
    %% 
    

methods
    %% -----------------------------Calculate chasing without repeats ----------------------------
    
    function ChasingCal=ChasingCal(obj,TrajectoryX,TrajectoryY,Velocity,isInArena,VectorX,VectorY,Distance,timeLine)
  hbar=waitbar(0,'Calculating Chasing')
  
 Dist_tresh1=obj.Dist_tresh1;
 Velocity_Tresh=obj.Velocity_Tresh;
 PathTresh=obj.PathTresh;
 Dist_tresh2=obj.Dist_tresh2;
 miceList=obj.numOfMice;
 %% Variable definition
 AllEvents=[];
 Par=[];
 chasing_all=cell(1,obj.numOfMice);
 chased_all=chasing_all;
 move_together_all=chasing_all;
 chasing=zeros(obj.numOfMice);
 IndexChasingAll=zeros(length(timeLine),obj.numOfMice);
 
  
  %% 
  for mouse1 = 1:obj.numOfMice
    others = setdiff(1:obj.numOfMice,mouse1);
    Trajectory1=[TrajectoryX(:,mouse1) TrajectoryY(:,mouse1)];
    Trajectory1(isnan(Trajectory1(:,1))|~isInArena(:,mouse1))=0;%if it is outside the arena
    
    if sum(sum(Trajectory1))==0 %in the case is not in the arena
       continue;
    else
        Velocity1=Velocity(:,mouse1); 
        Vector1=[VectorX(:,mouse1) VectorY(:,mouse1)];
        dist1=Distance(:,mouse1);
        
        for mouse2 = others %go over the other mouse
            Trajectory2=[TrajectoryX(:,mouse2) TrajectoryY(:,mouse2)];
            Trajectory2(isnan(Trajectory2(:,1))|~isInArena(:,mouse2))=0;
            if sum(sum(Trajectory2))==0 %if it is not in the arean
                continue;
            else
                Vector2=[VectorX(:,mouse2) VectorY(:,mouse2)];
                Velocity2=Velocity(:,mouse2);
                dist2=Distance(:,mouse2);
                [chasing12 chasing21 together12 IndexChasing allevents par ]=detectChasing(Trajectory1,Trajectory2,Velocity1,Velocity2,Vector1,Vector2,timeLine,Dist_tresh1,Velocity_Tresh,PathTresh,Dist_tresh2, miceList);
               
       %CONTINUE FROM HERE         
                if ~isempty(chasing12)
                    IndexChasingAll(IndexChasing,mouse1)=mouse2;
                    chasing12=[chasing12 mouse2*ones(size(chasing12,1),1)];
                    chasing(mouse1,mouse2)=size(chasing12,1);
                    AllEvents=[AllEvents;allevents];
                    Par=[Par;par];
                end
                
                if ~isempty(chasing21)
                    chasing21=[chasing21 mouse2*ones(size(chasing21,1),1)];
                end
                
                if~isempty(together12)
                    together12=[together12 mouse2*ones(size(together12,1),1)];
                end
                
                move_together_all{mouse1}=[move_together_all{mouse1};together12];
                chasing_all{mouse1}=[chasing_all{mouse1};chasing12];
                chased_all{mouse1}=[chased_all{mouse1};chasing21];
            end
        end
    end
    waitbar(j/length(miceList));
  end
close(hbar);
    ChasingCal=[chasing_all,chased_all,move_together_all];
    
    end
    %% 
    
end


end



%% -----------------Auxiliary functions-------------------


%% -----------Detect chasing----------------------------------------------------------
function [chasing chasedby together IndexChasing allevents Par ]=detectChasing(Trajectory1,Trajectory2,Velocity1,Velocity2,Vector1,Vector2,timeLine,Dist_tresh1,Velocity_Tresh,PathTresh,Dist_tresh2,miceList)


%-----------Difference between the 2 trajectories------------------------
DistFun=@(t1,t2) sqrt(sum((t1-t2).^2,2));
Distance=DistFun(Trajectory1,Trajectory2);
%----------------------------------find near trajectories-------------------

Index_proximity=Distance<Dist_tresh1;
[Index_proximityBeg Index_proximityEnd]=getEventsIndexesGV(Index_proximity,length(timeLine));%find events

%--------------------------------------------------------------------------------------------

j1=1;j2=1;j3=1;j=0;

chasing=[];
chasedby=[];
together=[];
IndexChasing=[];
allevents=[];
Par=zeros(1,5); %for 5 mice



for i=1:length(Index_proximityBeg) %loop for each interval
    Ind_Seg=Index_proximityBeg(i):Index_proximityEnd(i); %wehere the proximity is near
    IndHighVelocity=Velocity1(Ind_Seg)>Velocity_Tresh&Velocity2(Ind_Seg)>Velocity_Tresh;
    [Index_HVBeg Index_HVEnd]=getEventsIndexesGV(IndHighVelocity,length(Ind_Seg));%index by considering the velocity and trajectory
    interval=Ind_Seg(Index_HVEnd)-Ind_Seg(Index_HVBeg); %Original interval with velocity and trajectory assumptions
    if ~isempty(interval)
        [temp ind_max]=max(interval);
        Seg=Index_HVBeg(ind_max(1)):Index_HVEnd(ind_max(1));
        vel1=Velocity1(Ind_Seg(Seg),:);
        vel2=Velocity2(Ind_Seg(Seg),:); %consider the larger interval
        j=j+1;
        allevents(j,:)=[Ind_Seg(Index_HVBeg(ind_max(1))) Ind_Seg(Index_HVEnd(ind_max(1))) 0];
        if (Ind_Seg(Seg(1))-1)>0
            timeline=cat(1,timeLine(Ind_Seg(Seg(1))-1),timeLine(Ind_Seg(Seg),:));
            timeVec=etime(datevec(timeline(2:end)),datevec(timeline(1:end-1)));
            dist1=sum(vel1.*timeVec);
            dist2=sum(vel2.*timeVec);
            trajectory1=Trajectory1(Ind_Seg(Seg),:);
            trajectory2=Trajectory2(Ind_Seg(Seg),:);
            T1=trajectory1(1,:);
            T2=trajectory1(1,:);%NO HAY UN ERROR
            d1=DistFun(trajectory1,repmat(T1,size(trajectory1,1),1));
            d2=DistFun(trajectory2,repmat(T2,size(trajectory2,1),1));
            Par(j,1)=sum(d1>=Dist_tresh2)>0&sum(d2>=Dist_tresh2)>0;
            Par(j,2)=(dist1>PathTresh&&dist2>PathTresh)||(DistFun(trajectory1(1,:),trajectory1(end,:))>=Dist_tresh2)&&(DistFun(trajectory2(1,:),trajectory2(end,:))>=Dist_tresh2);
            [F C D]=iscorrelated(trajectory1,trajectory2);
            Par(j,3)=C;
            Par(j,4)=D;
            if sum(d1>=Dist_tresh2)>0&&sum(d2>=Dist_tresh2)>0 %out of 20 cm radius
                if((dist1>PathTresh&&dist2>PathTresh)||...,
                        (DistFun(trajectory1(1,:),trajectory1(end,:))>=Dist_tresh2&&DistFun(trajectory2(1,:),trajectory2(end,:))>=Dist_tresh2))
                    if (F)
                        vec1=Vector1(Ind_Seg(Seg),:);
                        vec2=trajectory2-trajectory1;
                        vec2=vec2./[sqrt(sum(vec2.^2,2)) sqrt(sum(vec2.^2,2))];
                        %ii=~isnan(vec1)&~isnan(vec2);
                        flag=dot(vec1,vec2,2);
                        flag=sum(flag(~isnan(flag)));
                        Par(j,5)=flag;
                        
                        if flag>0
                            IndexChasing=[IndexChasing  Ind_Seg(Seg)];
                            chasing(j1,:)=[Ind_Seg(Index_HVBeg(ind_max(1))) Ind_Seg(Index_HVEnd(ind_max(1)))];
%                             a=Ind_Seg(Index_HVBeg(ind_max(1)))
%                             timeLine(a,1)
                        
                            j1=j1+1;
                            allevents(j,3)=1;
                        elseif flag<0
                            chasedby(j2,:)=[Ind_Seg(Index_HVBeg(ind_max(1))) Ind_Seg(Index_HVEnd(ind_max(1)))];
                          
                            j2=j2+1;
                        else
                            together(j3,:)=[Ind_Seg(Index_HVBeg(ind_max(1))) Ind_Seg(Index_HVEnd(ind_max(1)))];
                          
                            j3=j3+1;
                        end
                    end
                end
            end
        end
    end
end
end

%% 
function [flag C D]=iscorrelated(trajectory1,trajectory2)

CorTresh=.7;%.75
flag=false;
C=0;

D=dot(trajectory1(end,:)-trajectory1(1,:),trajectory2(end,:)-trajectory2(1,:));

if length(trajectory1)>4
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

