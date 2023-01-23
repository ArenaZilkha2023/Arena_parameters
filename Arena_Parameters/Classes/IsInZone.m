classdef IsInZone
    %This class is to calculate the presence of the mouse in different
    %zones
    
    
    properties
        ZoneCoord;
        LargeBridge;
        NarrowBridge;
    end
    %% 
     methods
         
         %% ------------------Calculate if is inside a given zone-----------------
         function IsZone=IsZone(obj,InArena,X,Y)
         %% Reset variables
         clear XInArena;
         clear YInArena;
         clear IndexArena;
         clear inF;
         clear onF;
         clear IsInsideZone;
          clear IsOutsideZone;
          
         %% Define IsInsideZone vector
         IsInsideZone=zeros(length(InArena(:,1)),1);
         IsOutsideZone=zeros(length(InArena(:,1)),1);
         
          %find the coordinates in the arena
           XInArena=X(find(InArena(:,1)==1),1);
           YInArena=Y(find(InArena(:,1)==1),1);

           IndexArena=find(InArena(:,1)==1);
         
           Idefined=XInArena~=1e6;
           
           
           
          %check if it is inside the given zone
          xz=[obj.ZoneCoord(1,1) obj.ZoneCoord(2,1) obj.ZoneCoord(3,1) obj.ZoneCoord(4,1) obj.ZoneCoord(1,1)];
          yz=[obj.ZoneCoord(1,2) obj.ZoneCoord(2,2) obj.ZoneCoord(3,2) obj.ZoneCoord(4,2) obj.ZoneCoord(1,2)];
          
          [inF,onF] = inpolygon(XInArena,YInArena,xz,yz);
          inFoutside=~inF & Idefined ; % not consider no defined coordinates
          
           if ~isempty(find(inF==1))
           IsInsideZone(IndexArena(find(inF==1)))=1;
           IsOutsideZone(IndexArena(find(inFoutside==1)))=1;
           end
          
            IsZone=[IsInsideZone,IsOutsideZone];
          
          
          
          
         end
         %% -----------------------Calculate if  in the zone near the bridges-----------------------------
         function IsBridge=IsBridge(obj,InArena,X,Y)
          %% Define IsInsideZone vector
             IsNarrowBridge=zeros(length(InArena(:,1)),1);
             IsLargerBridge=zeros(length(InArena(:,1)),1);
          % find the coordinates in the arena
              XInArena=X(find(InArena(:,1)==1),1);
              YInArena=Y(find(InArena(:,1)==1),1);
              IndexArena=find(InArena(:,1)==1);
              
          %% ----------- Check if the mouse is in the sector of  the bridges-----------------
               xLarge=[obj.LargeBridge(1,1) obj.LargeBridge(2,1) obj.LargeBridge(3,1) obj.LargeBridge(4,1) obj.LargeBridge(1,1)];
               yLarge=[obj.LargeBridge(1,2) obj.LargeBridge(2,2) obj.LargeBridge(3,2) obj.LargeBridge(4,2) obj.LargeBridge(1,2)];
               xNarrow=[obj.NarrowBridge(1,1) obj.NarrowBridge(2,1) obj.NarrowBridge(3,1) obj.NarrowBridge(4,1) obj.NarrowBridge(1,1)];
               yNarrow=[obj.NarrowBridge(1,2) obj.NarrowBridge(2,2) obj.NarrowBridge(3,2) obj.NarrowBridge(4,2) obj.NarrowBridge(1,2)];
               
               [inFLarge,~] = inpolygon(XInArena,YInArena,xLarge,yLarge);
               [inFNarrow,~] = inpolygon(XInArena,YInArena,xNarrow,yNarrow);
               
               % Do assignment
               if ~isempty(find(inFLarge==1))
                   IsLargerBridge(IndexArena(find(inFLarge==1)))=1;
               end
                if ~isempty(find(inFNarrow)==1)
                   IsNarrowBridge(IndexArena(find(inFNarrow==1)))=1;
               end
              IsBridge=[IsLargerBridge,IsNarrowBridge];
         
         
         end
         
         
    
    
end
end
