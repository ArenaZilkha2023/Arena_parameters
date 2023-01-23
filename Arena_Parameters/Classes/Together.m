classdef Together
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
     numOfMice;   
     DistanceToBeTogether   
        
        
    end
    
    methods
        %% -----------Insert together ----------------
        function TogetherCalc=TogetherCalc(obj,TrajectoryX,TrajectoryY,isInArena)
            
          hbar=waitbar(0,'Calculating Together')
        %%Variable Definition
       
         together=zeros(obj.numOfMice,obj.numOfMice);
         together_all=cell(1,obj.numOfMice);

         
         %% -----Detect one they are together----------------------
         
         for mouse1=1:obj.numOfMice
           others = setdiff(1:obj.numOfMice,mouse1);
          Trajectory1=[TrajectoryX(:,mouse1) TrajectoryY(:,mouse1)];
          Trajectory1(isnan(Trajectory1(:,1))|~isInArena(:,mouse1))=0;%if it is outside the aren    
             
           if sum(sum(Trajectory1))==0 %in the case is not in the arena
           continue;
           else   
           InArenaInd1=(isInArena(:,mouse1) & Trajectory1(:,1)<2000 & Trajectory1(:,2)<2000);  
           
           for mouse2=others
               
               Trajectory2=[TrajectoryX(:,mouse2) TrajectoryY(:,mouse2)];
               Trajectory2(isnan(Trajectory2(:,1))|~isInArena(:,mouse2))=0;%if it is outside the aren  
               if sum(sum(Trajectory2))==0
               continue;
               else
                 InArenaInd2=(isInArena(:,mouse2) & Trajectory2(:,2)<2000 & Trajectory2(:,2)<2000);  
                  [timeTogether totTime Index_proximityBeg Index_proximityEnd]=detectTogether(Trajectory1,Trajectory2,InArenaInd1,InArenaInd2,obj.DistanceToBeTogether);  
                   
                  if ~isempty(timeTogether)
                      together(mouse1,mouse2)=timeTogether; %this is a matrix nxn (n number of mice) each value represents the number of times they were together
                     
                      %This array gives the events  of together without
                      %repeats a the beggining and with repeats at the end
                      together12=[Index_proximityBeg Index_proximityEnd mouse2*ones(length(Index_proximityBeg),1)];%at the end were included real frames
                      
                      together_all{mouse1}=[together_all{mouse1};together12];
                  
                  end
                   
               end
               end
           end
           
           waitbar(mouse1/obj.numOfMice);
           
         end
         %% 
         close(hbar);
           TogetherCalc=[together_all,together];
       
         end    
            
            
        end
        
end
%% 

%%---Insert Auxiliary functions-------------------
        
  function  [timeTogether totTime Index_proximityBeg Index_proximityEnd]=detectTogether(Trajectory1,Trajectory2,InArenaInd1,InArenaInd2,Distance_tresh)

% Distance_tresh=10;

Distance=sqrt(sum((Trajectory1-Trajectory2).^2,2)); %distance between mice
Index_proximity=Distance<Distance_tresh&InArenaInd1&InArenaInd2;
[Index_proximityBeg Index_proximityEnd]=getEventsIndexesGV(Index_proximity,length(Index_proximity));
%[Index_TotTimeBeg Index_TotTimeEnd]=getEventsIndexesGV(InArenaInd1,length(timeLine));

% timeTogetherV=[timeLine(Index_proximityBeg) timeLine(Index_proximityEnd)];
timeTogether=sum(Index_proximity);
%totTime=[timeLine(Index_TotTimeBeg) timeLine(Index_TotTimeEnd)];
%totTime=sum(etime(datevec(totTime(:,2)),datevec(totTime(:,1))));
totTime=sum(InArenaInd1);
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
        
        


