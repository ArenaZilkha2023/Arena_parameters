classdef Sleeping
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        AntennaNumber;
        AntennaCage;
        AntennaSideBox;
        CoordinateX;
        CoordinateY;
        SleepingCoord;
    end
    
    methods
        %% Find where is sleeping and assign 1
        function IsSleeping=IsSleeping(obj)
          IsSleeping=zeros(length(obj.AntennaNumber),1);  
          IndexS=[];
          AntennaN=[obj.AntennaCage,obj.AntennaSideBox];%consider antenna on the side and on the entrance to the cage
          
           %only if it is sleeping
            for j=1:length(AntennaN)
            
             Index=find(strcmp({num2str(AntennaN(j))},obj.AntennaNumber)==1);
             IndexS=[IndexS ; Index];
             
            end
            if ~isempty(IndexS) %only if is sleeping
            IsSleeping(IndexS)=1;
            end
            
          end
          %% --------Corrections------------------
          function IsSleepingCorrections=IsSleepingCorrections(obj,IsSleeping)
              %% Corrections because side antenna also is measured when it is inside
              AntennaInput=[14,34,36,15];
               IsSleepingCorrections=IsSleeping;
%               %LogicalIndex= strcmp({num2str(AntennaInput)},obj.AntennaNumber) & (cell2mat(obj.CoordinateX)==1e6);
              for j=1:length(AntennaInput)
               
              LogicalIndex1= strcmp({num2str(AntennaInput(j))},obj.AntennaNumber) & (cell2mat(obj.CoordinateX)>=10000);
              LogicalIndex2= strcmp({num2str(AntennaInput(j))},obj.AntennaNumber) & (cell2mat(obj.CoordinateX)<=0);
%               %LogicalIndex3= strcmp({num2str(AntennaInput)},obj.AntennaNumber) & (cell2mat(obj.CoordinateY)<=0);
                       
                if ~isempty(find(LogicalIndex1==1))
                  %check that the mouse is not detected because is in the sleeping or is outside without video detection cages-go through each interval  
                  [EventsBeg EventsEnd]=getEventsIndexesGV(LogicalIndex1,length(LogicalIndex1));
                  for i=1:length(EventsBeg)
%                       obj.AntennaNumber{EventsBeg(i)-1}
%                       obj.AntennaCage
                      if isempty(find(obj.AntennaCage==str2num(obj.AntennaNumber{EventsBeg(i)-1}))) & isempty(find(obj.AntennaCage==str2num(obj.AntennaNumber{EventsEnd(i)+1}))) %check that the side are antenna inside the arena
                       IsSleepingCorrections(EventsBeg(i):EventsEnd(i))=0; 
                      else
                       IsSleepingCorrections(EventsBeg(i):EventsEnd(i))=1;  
                     end
                  end
                end
                
                 if ~isempty(find(LogicalIndex2==1))
                  IsSleepingCorrections(find(LogicalIndex2==1))=1; 
                  
                end
                
              end
                  
             end    
             %% ------------find interval frames----------------------------
             function     IsSleepingInterval=IsSleepingInterval(obj,IsSleepingCorrections)
                 
               [EventsBeg EventsEnd]=getEventsIndexesGV(IsSleepingCorrections,length(IsSleepingCorrections));  
                 
              
               IsSleepingInterval=[EventsBeg EventsEnd];
              
              
             end
             %% -----------find the number of cage per interval------------
             %since in a same interval there could be different antenna for
             %the same cage we are doing a mean and find the exact cage
             
             function IsSleepingCage=IsSleepingCage(obj,IsSleepingInterval)
                
                 IsSleepingCage=zeros(length(obj.AntennaNumber),1);
                 for i=1:length(IsSleepingInterval(:,1))
                 clear Data
                 clear result
                 clear MeanCages
                 clear value
                 
                Data=obj.AntennaNumber(IsSleepingInterval(i,1):IsSleepingInterval(i,2));
                    
                %convert the Data into number
                
                   result=cellfun(@NumberConversion,Data,'UniformOutput',false);
                   MeanCages= mean(cell2mat(result));
                  B=cell2mat(result);
                   value =knnsearch(cell2mat(result),repmat(MeanCages,length(result),1));
                   CageValue=B(value(1));
                   
                  
                   %look for the Cage number
                   if ~isempty(find( obj.AntennaCage==CageValue, 1))
                       IsSleepingCage([IsSleepingInterval(i,1):IsSleepingInterval(i,2)],1)=find( obj.AntennaCage==CageValue);
                   elseif ~isempty(find( obj.AntennaSideBox==CageValue, 1))
                       IsSleepingCage([IsSleepingInterval(i,1):IsSleepingInterval(i,2)],1)=find( obj.AntennaSideBox==CageValue);
                   elseif CageValue==15
                       IsSleepingCage([IsSleepingInterval(i,1):IsSleepingInterval(i,2)],1)=8;
                    elseif CageValue==36
                       IsSleepingCage(IsSleepingInterval(i,1):IsSleepingInterval(i,2),1)=7;  
                    elseif CageValue==14
                       IsSleepingCage(IsSleepingInterval(i,1):IsSleepingInterval(i,2),1)=3;  
                     elseif CageValue==34
                       IsSleepingCage(IsSleepingInterval(i,1):IsSleepingInterval(i,2),1)=4; 
                        
                   end
        
                   
                     
                 end
                 
                 
             end
             %% ------change the coordinates of the sleeping to the position of the entrance to the cage---------
             
             function IsSleepingCoord=IsSleepingCoord(obj,IsSleepingInterval,IsSleepingCage)
                 clear X
                 clear Y
                 X=obj.CoordinateX;
                 Y=obj.CoordinateY;
                 X=cell2mat(X);
                 Y=cell2mat(Y);
                for i=1:length(IsSleepingInterval(:,1))
                   clear ReferenceCage 
                   ReferenceCage=IsSleepingCage(IsSleepingInterval(i,1)); 
                   X(IsSleepingInterval(i,1):IsSleepingInterval(i,2))=obj.SleepingCoord(ReferenceCage,1); %for the x  
                   Y(IsSleepingInterval(i,1):IsSleepingInterval(i,2))=obj.SleepingCoord(ReferenceCage,2); %for the y   
                    
                end
                 IsSleepingCoord=[X,Y];
                 
                 
                 
             end
             
             
             
             
             
             
end

end

%% AUXILIARY FUNCTIONS
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
%% 
function result=NumberConversion(x)
result=str2num(x);

end
