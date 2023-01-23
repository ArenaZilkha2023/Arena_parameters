function [MajorAxis,Head,Tail]=FindHeadTail(Locomotion,countMouse,XYCorners,max_width)
%% Definition of variables
MajorAxis=1000000*ones(size(Locomotion.AssigRFID.Arena.InArena,1),1);%everywhere is 1000000 except of the defined points
Head=1000000*ones(size(Locomotion.AssigRFID.Arena.InArena,1),2);
Tail=1000000*ones(size(Locomotion.AssigRFID.Arena.InArena,1),2);
IndexSelectedAux=[];
MajorAxisAux=[];
HeadAux=[];
TailAux=[];
Corn0=XYCorners(1,1);
Corn1=XYCorners(2,1);
Corn2=XYCorners(1,2);
Corn3=XYCorners(4,2);
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

    parfor  count=1:length(IndexSelected)        %USE par loop
   
    indexForAxis=find(Locomotion.SegmentationDetails.Orientation(:,1)==(IndexSelected(count)+1)...
          & Locomotion.SegmentationDetails.Orientation(:,2)==Locomotion.AssigRFID.MouseOrientation(IndexSelected(count),countMouse) & ...
          Locomotion.Coordinates(:,2)==Locomotion.AssigRFID.XcoordPixel(IndexSelected(count),countMouse)...
      & Locomotion.Coordinates(:,3)==Locomotion.AssigRFID.YcoordPixel(IndexSelected(count),countMouse)); % in the original the frame is plus one  
     if ~isempty(indexForAxis)
       IndexSelectedAux(count,1)=IndexSelected(count);  
       indexForAxis;
       count;
         MajorAxisAux(count,1)=Locomotion.SegmentationDetails.MajorAxisLength(indexForAxis,2); 
    
  %% Find the extremes of the mouse
  x=Locomotion.AssigRFID.XcoordPixel(IndexSelected(count),countMouse);
  y=Locomotion.AssigRFID.YcoordPixel(IndexSelected(count),countMouse);
  theta=Locomotion.AssigRFID.MouseOrientation(IndexSelected(count),countMouse);
  
  ExtremeAX=x+MajorAxisAux(count,1)*0.5*cos(theta*pi/180);
  ExtremeAY=y+MajorAxisAux(count,1)*0.5*sin(theta*pi/180);
  VectorA=[MajorAxisAux(count,1)*0.5*cos(theta*pi/180) MajorAxisAux(count,1)*0.5*sin(theta*pi/180)];
  
  ExtremeBX=x-MajorAxisAux(count,1)*0.5*cos(theta*pi/180);
  ExtremeBY=y-MajorAxisAux(count,1)*0.5*sin(theta*pi/180);
  VectorB=[-MajorAxisAux(count,1)*0.5*cos(theta*pi/180) -MajorAxisAux(count,1)*0.5*sin(theta*pi/180)];
  
  %% Decide if it is the tail or the head
  vx=Locomotion.AssigRFID.VelocityMouseX(IndexSelected(count),countMouse);  
  vy=Locomotion.AssigRFID.VelocityMouseY(IndexSelected(count),countMouse);  
  v=[vx,vy];
  %% Correction of head and tail in the case the body is curved
%   %convert vector A from pixel to MM
 VectorAMMx=PixelsToMM(VectorA(1),Corn0,Corn1,max_width); %x
 VectorAMMy=PixelsToMM(VectorA(2),Corn2,Corn3,max_width); %y
 VectorAMM=[VectorAMMx,VectorAMMy]; 
% % 
  VectorBMMx=PixelsToMM(VectorB(1),Corn0,Corn1,max_width); %x
  VectorBMMy=PixelsToMM(VectorB(2),Corn2,Corn3,max_width); %y
  VectorBMM=[VectorBMMx,VectorBMMy];
% 
%   alpha=acosd(dot(VectorAMM,v)/(norm(v)*norm(VectorAMM)));
% %   if alpha >90 & alpha < 180
% %       alpha=(180-alpha);
% %       
% %   end
%   thetap=theta+alpha;
%     
%   ExtremeAX=x+MajorAxisAux(count,1)*0.5*cos(thetap*pi/180);
%   ExtremeAY=y+MajorAxisAux(count,1)*0.5*sin(thetap*pi/180);
%   ExtremeBX=x-MajorAxisAux(count,1)*0.5*cos(thetap*pi/180);
%   ExtremeBY=y-MajorAxisAux(count,1)*0.5*sin(theta*pi/180);
%   %% 
%   
%   
%   ExtremeA=[ExtremeAX,ExtremeAY];
%   ExtremeB=[ExtremeBX,ExtremeBY];
  
  if (dot(v,VectorA)/(norm(v)*norm(VectorA)))>0 & (dot(v,VectorB)/(norm(v)*norm(VectorB)))< 0
      HeadAux(count,:)=[ExtremeAX,ExtremeAY]; %in pixels
        TailAux(count,:)=[ExtremeBX,ExtremeBY]; %in pixels
  elseif (dot(v,VectorB)/(norm(v)*norm(VectorB))) >0 & (dot(v,VectorA)/(norm(v)*norm(VectorA)))< 0
      HeadAux(count,:)=[ExtremeBX,ExtremeBY]; %in pixels
      TailAux(count,:)=[ExtremeAX,ExtremeAY]; %in pixels
  else
      HeadAux(count,:)=[1000000 1000000];
      TailAux(count,:)=[1000000 1000000];
  end
     else
          MajorAxisAux(count,1)=1000;
          HeadAux(count,:)=[1000000 1000000];
          TailAux(count,:)=[1000000 1000000];
          IndexSelectedAux(count,1)=IndexSelected(count,1);
     end
    end

MajorAxis(IndexSelectedAux,1)=MajorAxisAux;
Head(IndexSelectedAux,:)=HeadAux;
Tail(IndexSelectedAux,:)=TailAux;
 %end
    end 
 
end


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----------------------------------------Auxiliary functions--------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Convert pixel to mm 

function X=PixelsToMM(XPixel,Corn0,Corn1,max_width)
X=(XPixel-Corn0)*(max_width/(Corn1-Corn0)); 

end 