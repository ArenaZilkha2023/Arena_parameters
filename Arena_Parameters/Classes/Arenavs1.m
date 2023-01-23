classdef Arena
%All related with the arena
    
    properties
        AntennaNumber;
        IsHiding;
        IsSleeping;
        
    end
    
    methods
        %% -----------Determine according to sleeping and hiding when it is at the arena--
        function InArena=InArena(obj)
        InArena=zeros(length(obj.AntennaNumber),1);  
        LogicalIndex=~(cell2mat(obj.IsHiding) + cell2mat(obj.IsSleeping));
        InArena(LogicalIndex)=1;
        end 
        
        %% ----------------Determine arena events interval----------------
        function InArenaInterval=InArenaInterval(obj,InArena)
            
            [EventsBeg EventsEnd]=getEventsIndexesGV(InArena,length(InArena));  
            InArenaInterval=[EventsBeg EventsEnd];   
            
        end
        
        
        
        %% -----------------Find the duplicates in the coordinates-----------------
        function InArenaDuplic=InArenaDuplic(obj,AuxArrayM,AuxArrayHx,AuxArrayHy,NumberMouse,LengthMouse,InArenaInterval)
            InArenaDuplic=zeros(length(AuxArrayM(:,1)),1);
            
            ML=[1:LengthMouse];
            ML=ML(ML~=NumberMouse); %only the list for compare
          
            
            for i=1:length(InArenaInterval(:,1)) %loop for each arena event
                
                Beg=InArenaInterval(i,1);
                En=InArenaInterval(i,2);
                X=AuxArrayM(Beg:En,1);
                
                
                Y=AuxArrayM(Beg:En,2);
                ArrX=AuxArrayHx(Beg:En,:);
                ArrY=AuxArrayHy(Beg:En,:);
                
                
                for j=1:length(X)
                 
                    if ~isempty(find(ArrX(j,ML)==X(j,1)))& ~isempty(find(ArrY(j,ML)==Y(j,1))) & X(j,1)<1e6
                    InArenaDuplic(j+Beg-1,1)=1;
                    
                    end
                    j=j+1;
                end
               
                
              
                
            end
%           InArenaDuplic  
        end
        
        
    end
    
end

%% %% AUXILIARY FUNCTIONS
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

