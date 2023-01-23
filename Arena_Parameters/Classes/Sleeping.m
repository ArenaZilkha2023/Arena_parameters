classdef Sleeping
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        SleepingBox;
        CoordinateX;
        CoordinateY;
        SleepingCoord;
        TimeSleeping;
        IsSleepingBox;
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
              AntennaParallel=[7,35,43,8];
              AntennaInputStraight=[2,5,47,45]; 
              AntennaInputStraightSide=[49,50,53,54]; 
              
              IsSleepingCorrections=IsSleeping;
%             
              for j=1:length(AntennaInput)
               
              LogicalIndex1= strcmp({num2str(AntennaInput(j))},obj.AntennaNumber); %locate this side antenna
             
              if ~isempty(find(LogicalIndex1==1))
                  %check that the mouse is not detected because is in the sleeping or is outside without video detection cages-go through each interval  
                  [EventsBeg EventsEnd]=getEventsIndexesGV(LogicalIndex1,length(LogicalIndex1));
                  
                  
                for i=1:length(EventsBeg)
                 if   EventsBeg(i)>1 & EventsEnd(i)<length(IsSleeping)
                    if  AntennaParallel(j)==str2num(obj.AntennaNumber{EventsBeg(i)-1}) & AntennaParallel(j)==str2num(obj.AntennaNumber{EventsEnd(i)+1}) 
                     
                      IsSleepingCorrections(EventsBeg(i):EventsEnd(i))=1; %WHEN THE ANTENNA IS BETWEEN TWO SIDE ANTENNA
                      
                     elseif AntennaParallel(j)==str2num(obj.AntennaNumber{EventsBeg(i)-1}) %only the cage before get out is  a side antenna  
                   
                      I=find(obj. TimeLapseFrameAntenna(EventsBeg(i):EventsEnd(i))<80,1,'last'); %the idea to check when the mouse go out from the cage
                    %this happen if the rfid measure when time frame rfid
                    %less than 80ms
                    
                    IsSleepingCorrections(EventsBeg(i):EventsBeg(i)+I-1)=1;%WHEN THE MICE GO OUT THROUGH THE SIDE BOX
                
                 
                     elseif AntennaParallel(j)==str2num(obj.AntennaNumber{EventsEnd(i)+1})
                      I1=find(obj.TimeLapseFrameAntenna(EventsBeg(i):EventsEnd(i))<80,1,'last');
                      
                      IsSleepingCorrections(EventsBeg(i)+I1+1:EventsEnd(i))=1;%WHEN THE MICE Enter THROUGH THE SIDE BOX
                     end
                 elseif EventsBeg(i)>1 %looking the end of the list
                     if AntennaParallel(j)==str2num(obj.AntennaNumber{EventsBeg(i)-1}) %only the cage before get out is  a side antenna  
                   
                      I2=find(obj. TimeLapseFrameAntenna(EventsBeg(i):EventsEnd(i))<80,1,'last'); %the idea to check when the mouse go out from the cage
                    %this happen if the rfid measure when time frame rfid
                    %less than 80ms
                     if ~isempty(I2)
                         IsSleepingCorrections(EventsBeg(i):EventsBeg(i)+I2-1)=1;%WHEN THE MICE GO OUT THROUGH THE SIDE BOX 
                         
                     else
                          IsSleepingCorrections(EventsBeg(i):EventsEnd(i))=1;%WHEN THE MICE GO OUT THROUGH THE SIDE BOX
                     end
                         
                     end
                 elseif  EventsEnd(i)<length(IsSleeping) %in the upper side of the list
                     if AntennaParallel(j)==str2num(obj.AntennaNumber{EventsEnd(i)+1})
                         I3=find(obj.TimeLapseFrameAntenna(EventsBeg(i):EventsEnd(i))<80,1,'last');
                      if ~isempty(I3)
                      IsSleepingCorrections(EventsBeg(i)+I3+1:EventsEnd(i))=1;%WHEN THE MICE Enter THROUGH THE SIDE BOX
                      else
                        IsSleepingCorrections(EventsBeg(i):EventsEnd(i))=1; 
                          
                      end
                     end
                 
                 end     
                    
                end  
              end
              end
%              end
               
             
           
              %% %% Corrections for the entrance and outside from the straight antenna 2,5,47,45-Detect when enter and when go outside
               for j=1:length(AntennaInputStraight)
               LogicalIndex2= strcmp({num2str(AntennaInputStraight(j))},obj.AntennaNumber); %locate this cage antenna  
               
                  if ~isempty(find(LogicalIndex2==1))
                  %check that the mouse is not detected because is in the sleeping or is outside without video detection cages-go through each interval  
                  [EventsBeg1 EventsEnd1]=getEventsIndexesGV(LogicalIndex2,length(LogicalIndex2));   
                    for i=1:length(EventsBeg1)
                      if (EventsBeg1(i)-1)>1%it is not extreme
                        if str2num(obj.AntennaNumber{EventsBeg1(i)-1})~=AntennaInputStraightSide(j) %check that before was not in the side cage
                         I2=find(obj.TimeLapseFrameAntenna(EventsBeg1(i):EventsEnd1(i))<80,1,'first'); %indicates when enter into the box
                         IsSleepingCorrections(EventsBeg1(i):EventsBeg1(i)+I2-1)=0;%WHEN THE MICE Enter THROUGH THE SIDE BOX
                        end
                      end 
                      if (EventsEnd1(i)+1)<length(obj.AntennaNumber) %it is not extreme
                        if str2num(obj.AntennaNumber{EventsEnd1(i)+1})~=AntennaInputStraightSide(j)
                         I3=find(obj.TimeLapseFrameAntenna(EventsBeg1(i):EventsEnd1(i))<80,1,'last'); %indicates when go out of the box
                         IsSleepingCorrections(EventsBeg1(i)+I3-1:EventsEnd1(i))=0;%WHEN THE MICE Enter THROUGH THE SIDE BOX
                        end
                      end 
                    end    
                   
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
              % Create vector to save the cage number
              IsSleepingCage=zeros(size(obj.CoordinateX,1),1);
              x=obj.CoordinateX;
              y=obj.CoordinateY;
              Sbox=obj.SleepingBox;
              % Loop over each sleeping interval
                for countInterval=1:size(IsSleepingInterval,1) 
                %do  another loop and compare each xy with the coordinates
                   for count=IsSleepingInterval(countInterval,1):IsSleepingInterval(countInterval,2)
                %get the x and y coordinates in such interval and compare
                %with sleeping box
                count
                      Ilogical=(Sbox(:,1)==x(count))&(Sbox(:,2)==y(count));
                %get the number of cage save in a zero vector with the length of all
                %the list
                if ~isempty(find(Ilogical==1)) %Corregir
                     IsSleepingCage(count,1)=find(Ilogical==1); %save the number of cage
                end
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
