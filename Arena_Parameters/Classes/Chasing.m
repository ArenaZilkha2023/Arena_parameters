classdef Chasing
%All related with the chasing

    properties
        
         numOfMice; %number of mice
        %% ---------------------------------Settings used during these years----------------------
         Dist_tresh1;%40 in cm according GV
         Velocity_Tresh;%1
         PathTresh;%80
         Dist_tresh2;
         
          AngleMaximum1; %This is the maximum angle, which is allowed, between the line joining the mice 1-2 and the vector of movement of mouse 1.
          AngleMaximum2; %This is the maximum angle, which is allowed, between the vector of movement of mouse 1 and mouse 2.
          MinimumPath; %This is the minimum path recording to be considered as chasing.
%           GapPath=200; %This is the gap between the chasing that it is allow in units of mm
          GapPath;
          GapPathEnd;
          GapFrames;
          
           GapPathEndS;
          GapFramesS;
          
         ThreshVelocity; %threshold for the velocity 
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
    %% -----------------------Calculation of chasing according to second method------------------------------
    
    function ChasingCalvs2=ChasingCalvs2( obj,TrajectoryX,TrajectoryY,DeltaX,DeltaY,isInArena,Velocity)
        
    hbar=waitbar(0,'Calculating second version of Chasing')
        %%Variable Definition
    chasing_all=cell(1,obj.numOfMice);
    being_chasing_all=cell(1,obj.numOfMice); 
     
     %%

  for mouse1=1:obj.numOfMice
 %for mouse1=1
    %% variables
     Trajectory1=[];
        
    
    
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
 % for mouse2=5
         %variables
        clear ChasingVector;
        clear angle1;
        clear angle2;
        clear BegChasing;
        clear EndChasing;
        clear BegChasingCorrected1;
        clear EndChasingCorrected1;
        clear BegChasingCorrected2;
        clear EndChasingCorrected2;
          clear BegChasingCorrected3;
        clear EndChasingCorrected3;
         clear BegChasingCorrected;
        clear EndChasingCorrected;
        
         clear BegChasingCorrected1S;
        clear EndChasingCorrected1S;
        clear BegChasingCorrected2S;
        clear EndChasingCorrected2S;
          clear BegChasingCorrected3S;
        clear EndChasingCorrected3S;
         clear BegChasingCorrectedS;
        clear EndChasingCorrectedS;
        clear  Distance;
        clear SmallEvents;   
          clear BegChasingCorrected4S;
        clear EndChasingCorrected4S;
        
        ChasingVector=[];
         angle1=[];
         angle2=[];
         Trajectory2=[];
         chasing12=[];
         beingchasing21=[];  
           %% 
           
           
          Trajectory2=[TrajectoryX(:,mouse2) TrajectoryY(:,mouse2)];
          Trajectory2(~isInArena(:,mouse2))=0; %in the case is not in the arena
           if isempty(find(isInArena(:,mouse2)==1))%in the case all the arena is zero and not mouse in the arena
            Trajectory2=0;    
           end
            
           if sum(sum( Trajectory2))==0
              continue; %continue with another mouse
           else
               %% 
%                size(Trajectory1(:,1))
%                size(DeltaX,1)
%                 size(Trajectory1(1:size(DeltaX,1),2))
%                  size(Trajectory2(1:size(DeltaX,1),1))
%                 size(Trajectory2(1:size(DeltaX,1),2))
%                 size(DeltaX(:,mouse1))
%                 size(DeltaY(:,mouse1))
             %%Calculate angle between line joining 1 to 2 and mouse 1 movement direction
             
             angle1=cellfun(@FindAngle,num2cell(Trajectory1(1:size(DeltaX,1),1)),num2cell(Trajectory1(1:size(DeltaY,1),2)),num2cell(Trajectory2(1:size(DeltaX,1),1)),num2cell(Trajectory2(1:size(DeltaY,1),2)),num2cell(DeltaX(:,mouse1)),num2cell(DeltaY(:,mouse1)),'UniformOutput',false);
             
             %%Calculate angle between movement of mouse 1 and movement of
             %%mouse 2
           
             
             angle2=cellfun(@FindAngleDirection,num2cell(DeltaX(:,mouse1)),num2cell(DeltaY(:,mouse1)),num2cell(DeltaX(:,mouse2)),num2cell(DeltaY(:,mouse2)),'UniformOutput',false);
             dx1=DeltaX(:,mouse1);
%              Array=[Trajectory1(1:length(dx1),1),Trajectory1(1:length(dx1),2),Trajectory2(1:length(dx1),1),Trajectory2(1:length(dx1),2),dx1,dy1,dx2,dy2,angle1,angle2];
 
            %-----------------------------Difference between the 2 trajectories------------------------------
             DistFun=@(t1,t2) sqrt(sum((t1-t2).^2,2));
             
              Distance=DistFun(Trajectory1,Trajectory2);
             
             
             %---------------------------------------------------
             
             %% Looking for chasing when the distance is less than a given angle and the velocity and angle conditions are satisfied.

           ChasingVector=((cell2mat(angle1) < obj.AngleMaximum1) & (cell2mat(angle2) < obj.AngleMaximum2) & (isInArena(1:size(DeltaY,1),mouse1))==1 & (isInArena(1:size(DeltaY,1),mouse2))==1 & (Velocity(1:size(DeltaY,1),mouse1)> obj.ThreshVelocity) & (Velocity(1:size(DeltaY,1),mouse2)>obj.ThreshVelocity) &( Distance(1:size(DeltaY,1))<obj.GapPath));%this is a logical vector
            
              %ChasingVector=((cell2mat(angle1) < obj.AngleMaximum1) & (cell2mat(angle2) < obj.AngleMaximum2) & (isInArena(1:size(DeltaY,1),mouse1))==1 & (isInArena(1:size(DeltaY,1),mouse2))==1 & (Velocity(1:size(DeltaY,1),mouse1)> obj.ThreshVelocity) & (Velocity(1:size(DeltaY,1),mouse2)>obj.ThreshVelocity));%this is a logical vector
            [BegChasingCorrected2 EndChasingCorrected2]=getEventsIndexesGV(ChasingVector,length(ChasingVector));
            
            %% -------------------------Select events-remove less than 3 events--------------
               [ChasingVector ChasingVectorWithSmallEvents]=RealEvents1(BegChasingCorrected2, EndChasingCorrected2,ChasingVector,DeltaX(:,mouse1),DeltaY(:,mouse1),DeltaX(:,mouse2),DeltaY(:,mouse2),obj.MinimumPath);
              
               
               %% ----------------Treat different small events from larger events-----------------------
%                [BegChasingCorrected3S EndChasingCorrected3S]=getEventsIndexesGV(ChasingVectorWithSmallEvents,length(ChasingVectorWithSmallEvents)); 
%                
%                 [BegChasingCorrected3 EndChasingCorrected3]=getEventsIndexesGV(ChasingVector,length(ChasingVector)); 
            %% 
             
             %--------------------Consider the case in which is chasing and the coordinates are duplicated then must decide if the event is correct or not
             %----------for large events--------
%               ChasingVector=CorrectDuplicates(ChasingVector,Duplicates(:,mouse1),Duplicates(:,mouse2),Trajectory1,Trajectory2);
             
              [BegChasingCorrected1 EndChasingCorrected1]=getEventsIndexesGV(ChasingVector,length(ChasingVector)); 
             %----------------------for small events---------
%                 ChasingVectorWithSmallEvents=CorrectDuplicates(ChasingVectorWithSmallEvents,Duplicates(:,mouse1),Duplicates(:,mouse2),Trajectory1,Trajectory2);
             
              [BegChasingCorrected1S EndChasingCorrected1S]=getEventsIndexesGV(ChasingVectorWithSmallEvents,length(ChasingVectorWithSmallEvents)); 
             
             
             %-----------------------------------------------------
%              
%                 Array=[Trajectory1(1:length(dx1),1),Trajectory1(1:length(dx1),2),Trajectory2(1:length(dx1),1),Trajectory2(1:length(dx1),2),DeltaX(:,mouse1),DeltaY(:,mouse1),DeltaX(:,mouse2),DeltaY(:,mouse2),cell2mat(angle1),cell2mat(angle2),isInArena(1:size(DeltaY,1),mouse1),isInArena(1:size(DeltaY,1),mouse2),ChasingVector];
%                xlswrite('test.xlsx',Array)
%              %Again find  new chasing events
             
%%                         
             %----------Unify events which are very near----------------
             %------Large events
             ChasingVector=FillGap(BegChasingCorrected1, EndChasingCorrected1,ChasingVector,Trajectory1,Trajectory2,obj.GapPathEnd,obj.GapFrames);
             [BegChasingCorrected3 EndChasingCorrected3]=getEventsIndexesGV(ChasingVector,length(ChasingVector)); 
             
             %----Small events-----------------
              ChasingVectorWithSmallEvents=FillGapSmall(BegChasingCorrected1S, EndChasingCorrected1S,ChasingVectorWithSmallEvents,Trajectory1,Trajectory2,obj.GapPathEndS,obj.GapFramesS);
             [BegChasingCorrected3S EndChasingCorrected3S]=getEventsIndexesGV(ChasingVectorWithSmallEvents,length(ChasingVectorWithSmallEvents)); 
             
             
             
             %% 
             
              
%               Array=[Trajectory1(1:length(dx1),1),Trajectory1(1:length(dx1),2),Trajectory2(1:length(dx1),1),Trajectory2(1:length(dx1),2),DeltaX(:,mouse1),DeltaY(:,mouse1),DeltaX(:,mouse2),DeltaY(:,mouse2),cell2mat(angle1),cell2mat(angle2),isInArena(1:size(DeltaY,1),mouse1),isInArena(1:size(DeltaY,1),mouse2),ChasingVector];
%                xlswrite('test.xlsx',Array)
             %---------------------------------------------------------
%              
%               ChasingVector=RealEvents(BegChasingCorrected2, EndChasingCorrected2,ChasingVector,DeltaX(:,mouse1),DeltaY(:,mouse1),DeltaX(:,mouse2),DeltaY(:,mouse2),obj.MinimumPath);
%              [BegChasingCorrected3 EndChasingCorrected3]=getEventsIndexesGV(ChasingVector,length(ChasingVector)); 
             
             
             
             
             %----------------------Once we know the chasing events find the beggining and end of each event
            ChasingVector=FindEnds(BegChasingCorrected3, EndChasingCorrected3,ChasingVector,Trajectory1,Trajectory2,obj.GapPathEnd);
          
            ChasingVectorWithSmallEvents=FindEnds(BegChasingCorrected3S, EndChasingCorrected3S,ChasingVectorWithSmallEvents,Trajectory1,Trajectory2,obj.GapPathEnd);
            
            %% Eliminate very small events
           
             [BegChasingCorrected4S EndChasingCorrected4S]=getEventsIndexesGV(ChasingVectorWithSmallEvents,length(ChasingVectorWithSmallEvents)); %THIS ALL THE CHASING
          
             
             ChasingVectorWithSmallEvents=RealEvents(BegChasingCorrected4S, EndChasingCorrected4S,ChasingVectorWithSmallEvents,DeltaX(:,mouse1),DeltaY(:,mouse1),DeltaX(:,mouse2),DeltaY(:,mouse2),obj.MinimumPath,Velocity(1:size(DeltaY,1),mouse1),Velocity(1:size(DeltaY,1),mouse2),obj.ThreshVelocity);
           
            
            %% Join the two chasing events with small and large events
%             length(ChasingVector)
%             length(ChasingVectorWithSmallEvents)
            ChasingVector=or(ChasingVector,ChasingVectorWithSmallEvents);
            
            %% 
            
            
             [BegChasingCorrected EndChasingCorrected]=getEventsIndexesGV(ChasingVector,length(ChasingVector)); %THIS ALL THE CHASING
             [BegChasingCorrectedS EndChasingCorrectedS]=getEventsIndexesGV(ChasingVectorWithSmallEvents,length(ChasingVectorWithSmallEvents));%For Small events
             
             %make  a logical vector with small events
             SmallEvents=FoundSmallEvents(BegChasingCorrectedS,EndChasingCorrectedS,BegChasingCorrected, EndChasingCorrected);
             
             

             % Array=[Trajectory1(1:length(dx1),1),Trajectory1(1:length(dx1),2),Trajectory2(1:length(dx1),1),Trajectory2(1:length(dx1),2),DeltaX(:,mouse1),DeltaY(:,mouse1),DeltaX(:,mouse2),DeltaY(:,mouse2),cell2mat(angle1),cell2mat(angle2),isInArena(1:size(DeltaY,1),mouse1),isInArena(1:size(DeltaY,1),mouse2),ChasingVector,RepeatedFrames(1:size(DeltaY,1)),Distance(1:size(DeltaY,1))];
             %xlswrite('test.xlsx',Array)
          
             %-----------------------------------------------------------------
             if ~isempty(BegChasingCorrected)
              chasing12=[BegChasingCorrected EndChasingCorrected mouse2*ones(length(BegChasingCorrected),1) SmallEvents];%Return real frames
              beingchasing21=[BegChasingCorrected EndChasingCorrected mouse1*ones(length(BegChasingCorrected),1) SmallEvents];  
             
             end
             
            chasing_all{mouse1}=[chasing_all{mouse1};chasing12];
            being_chasing_all{mouse2}=[ being_chasing_all{mouse2};beingchasing21];
           end
       end
        
      end
    waitbar(j/length(length(obj.numOfMice)));
end
close(hbar);
ChasingCalvs2=[chasing_all,being_chasing_all];
end
%Finish Silvia's script
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
            %%
            timeVec=etime(datevec(timeline(2:end)),datevec(timeline(1:end-1)));
            dist1=sum(vel1.*timeVec);
            dist2=sum(vel2.*timeVec);
%%Add by Silvia for without repeats
%           timeVec=78; %use real time
%             dist1=sum(vel1.*timeVec);
%            dist2=sum(vel2.*timeVec); %ADD FOR THE CASE OF NON REPEATED
%%
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

%% -----------This function fill gaps between chasing events
function ChasingVector=FillGap(BegChasing, EndChasing,ChasingVector,Trajectory1,Trajectory2,GapPathEnd,GapFrames)

if ~isempty(BegChasing)& length(BegChasing)>1
 for i=1:length(BegChasing)-1
    if (BegChasing(i+1)-EndChasing(i))<GapFrames %if the difference in frames between gaps in the chasing is less than a given value
     %check if the trajectories are near
     
   %-----------Difference between the 2 trajectories------------------------
             DistFun=@(t1,t2) sqrt(sum((t1-t2).^2,2));
%              Trajectory1(EndChasing(i)+1:BegChasing(i+1)-1,:)
%              Trajectory2(EndChasing(i)+1:BegChasing(i+1)-1,:)
             Distance=DistFun(Trajectory1(EndChasing(i)+1:BegChasing(i+1)-1,:),Trajectory2(EndChasing(i)+1:BegChasing(i+1)-1,:));
%----------------------------------find near trajectories-------------------
           
            Index_proximity=(Distance > GapPathEnd); %if this condition is empty the trajectory are near then the chasing is filled with one
           
           
              if isempty(find(Index_proximity)==1)
                ChasingVector(EndChasing(i)+1:BegChasing(i+1)-1)=1; 
    
              end


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







%% ----------------Second function for filtering
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


%% -------------First function for data filtering------------------
function [ChasingVector ChasingVectorWithSmallEvents] =RealEvents1(BegChasing, EndChasing,ChasingVector,Dx1,Dy1,Dx2,Dy2,MinimumPath)

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

%% ---------- Determine if the events with duplicates are corrected--------------
function ChasingVector=CorrectDuplicates(ChasingVector,Duplicates1,Duplicates2,Trajectory1,Trajectory2)
ChasingVector=ChasingVector;

DistFun=@(t1,t2) sqrt(sum((t1-t2).^2,2));

if ~isempty(ChasingVector)

%--find events which are chasing and also duplicated coord
Ind=(ChasingVector(1:length(ChasingVector))==1 & Duplicates1(1:length(ChasingVector))==1 & Duplicates2(1:length(ChasingVector))==1);

[EventsBegCD EventsEndCD]=getEventsIndexesGV(Ind,length(Ind));
if ~isempty(EventsBegCD)
  for i=1:length(EventsBegCD)
    if EventsBegCD(i)>1 & EventsEndCD(i)<length(ChasingVector) %assure that it is a middle event not in the extrem
      Iinitial=find(Duplicates1(1:EventsBegCD(i)-1)==0,1,'last');%find when the duplicates are finish or begin around the chasing event
      Ifinal=find(Duplicates1(EventsEndCD(i)+1:end)==0,1,'first');
      
%       EventsEndCD(i)+1+Ifinal-1
%       EventsBegCD(i)
%         EventsEndCD(i)
      
      
      if ~isempty(Ifinal) & ~isempty(Iinitial)
      %--------determine if the event is real compare if the delta vector from mouse 1 to 2 before and after has the same sense or are opposite------------
      
     %-------------measure the distance------------------
     
    D1=DistFun(Trajectory1(Iinitial,:),Trajectory1(EventsBegCD(i),:));
     D2=DistFun(Trajectory2(Iinitial,:),Trajectory2(EventsBegCD(i),:));
     
         D1f=DistFun(Trajectory1(EventsEndCD(i)+1+Ifinal-1,:),Trajectory1(EventsEndCD(i),:));
     D2f=DistFun(Trajectory2(EventsEndCD(i)+1+Ifinal-1,:),Trajectory2(EventsEndCD(i),:));
%      
%      A=(Trajectory1(EventsEndCD(i)+1+Ifinal-1,:)-Trajectory1(EventsEndCD(i),:))
%      B=(Trajectory2(EventsEndCD(i)+1+Ifinal-1,:)-Trajectory2(EventsEndCD(i),:))
      beta=dot((Trajectory1(EventsEndCD(i)+1+Ifinal-1,:)-Trajectory1(EventsEndCD(i),:)),(Trajectory2(EventsEndCD(i)+1+Ifinal-1,:)-Trajectory2(EventsEndCD(i),:)));
   % beta=dot((Trajectory1(EventsEndCD(i)+1+Ifinal-1,:)-Trajectory1(EventsEndCD(i),:)),(Trajectory2(EventsEndCD(i)+1+Ifinal-1,:)-Trajectory2(EventsEndCD(i),:)))/(norm(Trajectory1(EventsEndCD(i)+1+Ifinal-1,:)-Trajectory1(EventsEndCD(i),:))*norm(Trajectory2(EventsEndCD(i)+1+Ifinal-1,:)-Trajectory2(EventsEndCD(i),:)))
    
     if ~ (D1>D2 & D1f<D2f & beta>0)
      %if ~ (D1>D2 & D1f<D2f) %IF MOUSE 1 IS CHASING 1 must be before2-also add the final angle is positive to be considered as chasing,beta ADD BETA TO ELIMINATE EFFECTS OF THAT ARE RUNNING AT THE END IN OPPOSITE DIRECTIONS
      
        ChasingVector(EventsBegCD(i):EventsEndCD(i))=0;
      
      end
      
%       Alpha=dot((Trajectory2(Iinitial,:)-Trajectory1(Iinitial,:)),(Trajectory2(EventsEndCD(i)+1+Ifinal-1,:)-Trajectory1(EventsEndCD(i)+1+Ifinal-1,:)))
      
%       if Alpha<0 %the event is not correct
%           
%          
%         ChasingVector(EventsBegCD(i):EventsEndCD(i))=0;  
%           
%       end
      end
    end
  end

end

end
end
%% 
function SmallEvents=FoundSmallEvents(BegChasingCorrectedS,EndChasingCorrectedS,BegChasingCorrected, EndChasingCorrected)

    SmallEvents=zeros(length(BegChasingCorrected),1);
if ~isempty(BegChasingCorrectedS) 
   for i=1:length(BegChasingCorrectedS) 
   Index=find(BegChasingCorrected==BegChasingCorrectedS(i));
   
   SmallEvents(Index)=1;
    
   end 
    
    
end
end






