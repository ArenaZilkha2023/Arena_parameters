classdef Chasing
%All related with the chasing

    properties
        
         numOfMice; %number of mice
        %% ---------------------------------Settings used during these years----------------------
         Dist_tresh1;%40 in mm
         Velocity_Tresh;%1
         PathTresh;%80
         Dist_tresh2;
         
          AngleMaximum1; %This is the maximum angle, which is allowed, between the line joining the mice 1-2 and the vector of movement of mouse 1.
          AngleMaximum2; %This is the maximum angle, which is allowed, between the vector of movement of mouse 1 and mouse 2.
          MinimumPath; %This is the minimum path recording to be considered as chasing.
%           GapPath=200; %This is the gap between the chasing that it is allow in units of mm
          GapPath;
          
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
    
    function ChasingCalvs2=ChasingCalvs2( obj,TrajectoryX,TrajectoryY,DeltaX,DeltaY,isInArena )
        
    hbar=waitbar(0,'Calculating second version Chasing')
        %%Variable Definition
    chasing_all=cell(1,obj.numOfMice);
     
     
     %%

 for mouse1=1:obj.numOfMice
    %% variables
     
    
    
          others=setdiff(1:obj.numOfMice,mouse1);
          Trajectory1=[TrajectoryX(:,mouse1) TrajectoryY(:,mouse1)];
          Trajectory1(~isInArena(:,mouse1))=0; %in the case is not in the arena
    
        if sum(sum( Trajectory1))==0
        continue; %continue with another mouse
        else
       for mouse2=others
         %variables
         clear ChasingVector;
         clear angle1;
         clear angle2;
         clear chasing12; 
           
           %% 
           
           
          Trajectory2=[TrajectoryX(:,mouse2) TrajectoryY(:,mouse2)];
          Trajectory2(~isInArena(:,mouse2))=0; %in the case is not in the arena
          
           if sum(sum( Trajectory2))==0
              continue; %continue with another mouse
           else
               %% 
               
             %%Calculate angle between line joining 1 to 2 and mouse 1 movement direction
             
             angle1=cellfun(@FindAngle,num2cell(Trajectory1(1:size(DeltaX,1),1)),num2cell(Trajectory1(1:size(DeltaY,1),2)),num2cell(Trajectory2(1:size(DeltaX,1),1)),num2cell(Trajectory2(1:size(DeltaY,1),2)),num2cell(DeltaX(:,mouse1)),num2cell(DeltaY(:,mouse1)),'UniformOutput',false);
             
             %%Calculate angle between movement of mouse 1 and movement of
             %%mouse 2
           
             
             angle2=cellfun(@FindAngleDirection,num2cell(DeltaX(:,mouse1)),num2cell(DeltaY(:,mouse1)),num2cell(DeltaX(:,mouse2)),num2cell(DeltaY(:,mouse2)),'UniformOutput',false);
         dx1=DeltaX(:,mouse1);
%              Array=[Trajectory1(1:length(dx1),1),Trajectory1(1:length(dx1),2),Trajectory2(1:length(dx1),1),Trajectory2(1:length(dx1),2),dx1,dy1,dx2,dy2,angle1,angle2];
 
         
             
             %% Looking for chasing 
            ChasingVector=((cell2mat(angle1) < obj.AngleMaximum1) & (cell2mat(angle2) < obj.AngleMaximum2) & (isInArena(1:size(DeltaY,1),mouse1))==1 & (isInArena(1:size(DeltaY,1),mouse2))==1);%this is a logical vector
               
             %complete small gaps- look for small gaps-find the gaps
%              IGapChasing=(((cell2mat(angle1) > obj.AngleMaximum1 & cell2mat(angle1) < 1000) | (cell2mat(angle2) > obj.AngleMaximum2 & cell2mat(angle2)<1000)) & isInArena(1:size(DeltaY,1),mouse1)==1);
%              
%              [BegGapChasing EndGapChasing]=getEventsIndexesGV(IGapChasing,length(IGapChasing));
%              
%              ChasingVector=FillGap(BegGapChasing, EndGapChasing,ChasingVector,DeltaX(:,mouse1),DeltaY(:,mouse1),obj.GapPath);
             
        
             %look for Chasing events 
             
              [BegChasing EndChasing]=getEventsIndexesGV(ChasingVector,length(ChasingVector))
             %Consider only chasing events when the distance recorded by
             %both mice is larger than a threshold and there is more one
             %event
             
             ChasingVector=RealEvents(BegChasing, EndChasing,ChasingVector,DeltaX(:,mouse1),DeltaY(:,mouse1),DeltaX(:,mouse2),DeltaY(:,mouse2),obj.MinimumPath);
             
%                 Array=[Trajectory1(1:length(dx1),1),Trajectory1(1:length(dx1),2),Trajectory2(1:length(dx1),1),Trajectory2(1:length(dx1),2),DeltaX(:,mouse1),DeltaY(:,mouse1),DeltaX(:,mouse2),DeltaY(:,mouse2),cell2mat(angle1),cell2mat(angle2),isInArena(1:size(DeltaY,1),mouse1),isInArena(1:size(DeltaY,1),mouse2),ChasingVector];
%                xlswrite('test.xlsx',Array)
             %Again find  new chasing events
             
             [BegChasingCorrected EndChasingCorrected]=getEventsIndexesGV(ChasingVector,length(ChasingVector)); 
             if ~isempty(BegChasingCorrected)
             chasing12=[BegChasingCorrected EndChasingCorrected mouse2*ones(length(BegChasingCorrected),1)];
             
             end
            chasing_all{mouse1}=[chasing_all{mouse1};chasing12];
           end
       end
        
      end
    waitbar(j/length(length(obj.numOfMice)));
end
close(hbar);
ChasingCalvs2=[chasing_all];
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
function ChasingVector=FillGap(BegGapChasing, EndGapChasing,ChasingVector,Dx,Dy,GapPath)
if ~isempty(BegGapChasing)
for i=1:length(BegGapChasing)
    
    DeltaX=Dx(BegGapChasing:EndGapChasing);
    DeltaY=Dy(BegGapChasing:EndGapChasing);
    
    DistFun=sum(sqrt((DeltaX).^2+(DeltaY).^2));%all the distance done during this chasing
    
    if DistFun<GapPath
        
        ChasingVector(BegGapChasing:EndGapChasing)=1;
    
    end
end



end
end

%%

%% 
function ChasingVector=RealEvents(BegChasing, EndChasing,ChasingVector,Dx1,Dy1,Dx2,Dy2,MinimumPath)




if ~isempty(BegChasing)
    
   for i=1:length(BegChasing)
       BegChasing
       
     if  EndChasing-BegChasing<3 
         EndChasing
        ChasingVector(BegChasing:EndChasing)=0; %ELIMINATE CHASING EVENTS IF THERE AS LESS THAN 3 EVENTS
        s=1
        
     else
       
    DeltaX1=Dx1(BegChasing:EndChasing);
    DeltaY1=Dy1(BegChasing:EndChasing);
    
    DeltaX2=Dx2(BegChasing:EndChasing);
    DeltaY2=Dy2(BegChasing:EndChasing);
    
    DistFun1=sum(sqrt((DeltaX1).^2+(DeltaY1).^2));%all the distance done during this chasing   
    DistFun2=sum(sqrt((DeltaX2).^2+(DeltaY2).^2));   
     
    if DistFun1< MinimumPath | DistFun2< MinimumPath
        
      ChasingVector(BegChasing:EndChasing)=0; %ELIMINATE CHASING EVENTS IF THE TRAYECTORY ARE VERY SMALL  
        
        
    end
       
   end
   
   
    
end

end

end


