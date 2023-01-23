classdef IsEatingDrinking
  %All related with drinking eating 
    
    properties
        VelocityThreshFood;
        FoodCoordinates;
        WaterCoordinates;
        radiusD;
        
    end
    
    methods
        %% ------------------Determine if it is eating------------------
        function IsEating=IsEating(obj,InArena,X,Y,Velocity)
         %clear variables 
         clear XInArena;
         clear YInArena;
         clear IndexArena;
         clear inF;
         clear onF;
         clear IsEating;
         
         %Define IsEating vector
         IsEating=zeros(length(InArena(:,1)),1);
         
         %find the coordinates in the arena
         XInArena=X(find(InArena(:,1)==1),1);
         YInArena=Y(find(InArena(:,1)==1),1);
        
         IndexArena=find(InArena(:,1)==1);
         
         %check if it is in the food compartment
         
%          xmin=min(obj.FoodCoordinates(:,1));
%          ymin=min(obj.FoodCoordinates(:,2));
%          
%              
%          xmax=max(obj.FoodCoordinates(:,1));
%          ymax=max(obj.FoodCoordinates(:,2));
         
          %xf=[xmin,xmin,xmax,xmax,xmin];
%           yf=[ymax+30,ymin-30,ymin-30,ymax+30,ymax+30];  %give some boderline
          xf=[obj.FoodCoordinates(:,1);obj.FoodCoordinates(1,1)];
          yf=[obj.FoodCoordinates(:,2);obj.FoodCoordinates(1,2)];
                     

          [inF,onF] = inpolygon(XInArena,YInArena,xf,yf);
          
         if ~isempty(find(inF==1))
         IsEating(IndexArena(find(or(inF==1,onF==1))))=1; 
         end
         %Add condition of velocity threshold
         IsEatingWithoutVelocity=IsEating;
         Velocity=Velocity;
         IsEating(IsEating(1:end,1)==1 & Velocity(:,1)<=obj.VelocityThreshFood,1)=1;
         IsEating(IsEating(1:end,1)==1 & Velocity(:,1)>obj.VelocityThreshFood,1)=0;
         IsEatingWithVelocity=IsEating;
         
         IsEating=[IsEatingWithoutVelocity,IsEatingWithVelocity];
        end
        
        %%     %% ------------------Determine if it is drinking------------------
        function IsDrinking=IsDrinking(obj,InArena,X,Y,Velocity)
         %clear variables 
         clear XInArena;
         clear YInArena;
         clear IndexArena;
         clear IndexDrinking;
         clear IsDrinking;
         
         %Define IsEating vector
         IsDrinking=zeros(length(InArena(:,1)),1);
         
         %find the coordinates in the arena
         XInArena=X(find(InArena(:,1)==1),1);
         YInArena=Y(find(InArena(:,1)==1),1);
        
         IndexArena=find(InArena(:,1)==1);
         
         %check if it is in the food compartment
         
         Center=obj.WaterCoordinates;

         IndexDrinking=find(((XInArena - Center(1)).^2 + (YInArena - Center(2)).^2 )<= obj.radiusD^2);
         
         if ~isempty(IndexDrinking)
         IsDrinking(IndexArena((IndexDrinking)))=1;
         end
         %Add condition of velocity threshold the same threshold as food
         Velocity=Velocity';
         
         IsDrinking(IsDrinking(2:end,1)==1 & Velocity(:,1)<=obj.VelocityThreshFood,1)=1;
         IsDrinking(IsDrinking(2:end,1)==1 & Velocity(:,1)>obj.VelocityThreshFood,1)=0;
         
        end
        
        
        
    end
    
end

