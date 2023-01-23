function [MajorAxis,Head,Tail]=FindHeadTail(Locomotion,countMouse)
%% Definition of variables
MajorAxis=1000000*ones(size(Locomotion.AssigRFID.Arena.InArena,1),1);%everywhere is 1000000 except of the defined points
Head=1000000*ones(size(Locomotion.AssigRFID.Arena.InArena,1),2);
Tail=1000000*ones(size(Locomotion.AssigRFID.Arena.InArena,1),2);
%% 

InArena=Locomotion.AssigRFID.Arena.InArena(:,countMouse);
IsEating=Locomotion.AssigRFID.EatingDrinking.IsEatingAccordingPlaceVelocity(:,countMouse); 
IsCluster=Locomotion.AssigRFID.Clusters(:,countMouse);  

% Find the frames in which the mouse is in the Arena, isn't eating and isn't  in a
% cluster
ISelected=InArena & (IsEating==0) & (IsCluster==1);

% Find the index of those frames
IndexSelected=find(ISelected==1);
if ~isempty(IndexSelected)
 for   count=1:length(IndexSelected)        %USE par loop
   
    indexForAxis=find(Locomotion.SegmentationDetails.Orientation(:,1)==(IndexSelected(count)+1)...
          & Locomotion.SegmentationDetails.Orientation(:,2)==Locomotion.AssigRFID.MouseOrientation(IndexSelected(count),countMouse) & ...
          Locomotion.Coordinates(:,2)==Locomotion.AssigRFID.XcoordPixel(IndexSelected(count),countMouse)...
      & Locomotion.Coordinates(:,3)==Locomotion.AssigRFID.YcoordPixel(IndexSelected(count),countMouse)); % in the original the frame is plus one  
    
  MajorAxis(IndexSelected(count),1)=Locomotion.SegmentationDetails.MajorAxisLength(indexForAxis,2); 
    
  %% Find the extremes of the mouse
  x=Locomotion.AssigRFID.XcoordPixel(IndexSelected(count),countMouse);
  y=Locomotion.AssigRFID.YcoordPixel(IndexSelected(count),countMouse);
  theta=Locomotion.AssigRFID.MouseOrientation(IndexSelected(count),countMouse);
  
  ExtremeAX=x+MajorAxis(IndexSelected(count),1)*0.5*cos(theta*pi/180);
  ExtremeAY=y+MajorAxis(IndexSelected(count),1)*0.5*sin(theta*pi/180);
  VectorA=[MajorAxis(IndexSelected(count),1)*0.5*cos(theta*pi/180) MajorAxis(IndexSelected(count),1)*0.5*sin(theta*pi/180)];
  
  ExtremeBX=x-MajorAxis(IndexSelected(count),1)*0.5*cos(theta*pi/180);
  ExtremeBY=y-MajorAxis(IndexSelected(count),1)*0.5*sin(theta*pi/180);
  VectorB=[-MajorAxis(IndexSelected(count),1)*0.5*cos(theta*pi/180) -MajorAxis(IndexSelected(count),1)*0.5*sin(theta*pi/180)];
  
  %% Decide if it is the tail or the head
  vx=Locomotion.AssigRFID.VelocityMouseX(IndexSelected(count),countMouse);  
  vy=Locomotion.AssigRFID.VelocityMouseY(IndexSelected(count),countMouse);  
  v=[vx,vy];
  ExtremeA=[ExtremeAX,ExtremeAY];
  ExtremeB=[ExtremeBX,ExtremeBY];
  
  if (dot(v,VectorA)/norm(v)*norm(VectorA))>0 & (dot(v,VectorB)/norm(v)*norm(VectorB))<= 0
      Head(IndexSelected(count),:)=[ExtremeAX,ExtremeAY]; %in pixels
        Tail(IndexSelected(count),:)=[ExtremeBX,ExtremeBY]; %in pixels
  elseif (dot(v,VectorB)/norm(v)*norm(VectorB))>0 & (dot(v,VectorA)/norm(v)*norm(VectorA))<= 0
      Head(IndexSelected(count),:)=[ExtremeBX,ExtremeBY]; %in pixels
      Tail(IndexSelected(count),:)=[ExtremeAX,ExtremeAY]; %in pixels
  end
  
  
  end
end
end

