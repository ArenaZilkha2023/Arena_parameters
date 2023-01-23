function  [HeadToHead HeadToTail]=PositionBodyCalc(Locomotion,DistanceToBeTogether,XYCorners,max_width)
DistanceToBeTogether=DistanceToBeTogether;%it is 2cm
%% -------------Define the variables--------------
Headx=Locomotion.AssigRFID.Arena.HeadCoordX;
Heady=Locomotion.AssigRFID.Arena.HeadCoordY;%in pixel
Tailx=Locomotion.AssigRFID.Arena.TailCoordX;
Taily=Locomotion.AssigRFID.Arena.TailCoordY;%in pixel

%% Convert head and tail into mm from pixel
HeadxMM=PixelsToMM(Headx,XYCorners(1,1),XYCorners(2,1),max_width); %x
HeadyMM=PixelsToMM(Heady,XYCorners(1,2),XYCorners(4,2),max_width); %y

TailxMM=PixelsToMM(Tailx,XYCorners(1,1),XYCorners(2,1),max_width); %x
TailyMM=PixelsToMM(Taily,XYCorners(1,2),XYCorners(4,2),max_width); %y
%% 

XMM=Locomotion.AssigRFID.XcoordMM;
YMM=Locomotion.AssigRFID.YcoordMM;
TrajectoryX=Locomotion.AssigRFID.XcoordMM;
TrajectoryY=Locomotion.AssigRFID.YcoordMM;
isInArena=Locomotion.AssigRFID.Arena.InArena;

  HeadToHead=cell(1,size(TrajectoryX,2));
  HeadToTail=cell(1,size(TrajectoryX,2));

%% ------------FIND EVENTS-------------------------
  hbar=waitbar(0,'Calculating Body position')
% ------------------------Loop over every mice ---------------
 for mouse1=1:size(Locomotion.AssigRFID.miceList,1)
     others = setdiff(1:size(Locomotion.AssigRFID.miceList,1),mouse1);
     Trajectory1=[TrajectoryX(:,mouse1) TrajectoryY(:,mouse1)];
     Trajectory1(~isInArena(:,mouse1)|(TrajectoryX(:,mouse1)==1e6))=0; % if it is outside the arena and the trayectory is non-defined
     if sum(sum(Trajectory1))==0 %in the case is not in the arena
           continue;
     else     
           for mouse2=others % loop over the other mice
            % Find both in the arena without hiding box
             Trajectory2=[TrajectoryX(:,mouse2) TrajectoryY(:,mouse2)];
             Trajectory2(~isInArena(:,mouse2)|(TrajectoryX(:,mouse2)==1e6))=0; % if it is outside the arena and the trayectory is non-defined
             if sum(sum(Trajectory2))==0 %in the case is not in the arena
                continue;
             else     
                % 1)- Consider possible cases for consideration
                 I1=(Headx(:,mouse1)~=1e6 & Heady(:,mouse1)~=1e6 & Tailx(:,mouse1)~=1e6 & Taily(:,mouse1)~=1e6 &...
                     Headx(:,mouse2)~=1e6 & Heady(:,mouse2)~=1e6 & Tailx(:,mouse2)~=1e6 & Taily(:,mouse2)~=1e6);
                
                % 2)- Calculate distance between head and tails 
                 
                 HeadHeadDistance=Distancia(Headx(:,mouse1),Heady(:,mouse1),Headx(:,mouse2), Heady(:,mouse2));
                 TailTailDistance=Distancia(Tailx(:,mouse1),Taily(:,mouse1),Tailx(:,mouse2), Taily(:,mouse2));
                 HeadTailDistance12=Distancia(Headx(:,mouse1),Heady(:,mouse1),Tailx(:,mouse2), Taily(:,mouse2));
                  HeadTailDistance21=Distancia(Headx(:,mouse2),Heady(:,mouse2),Tailx(:,mouse1), Taily(:,mouse1));
                  % 2a)- Determine events head head
                  
                      [Index_Beg Index_End]=IsHeadHead(I1,HeadHeadDistance,TailTailDistance,DistanceToBeTogether);
                        if ~isempty(Index_Beg)
                            HH12=[];
                            HH12=[Index_Beg Index_End mouse2*ones(length(Index_Beg),1)];
                            HeadToHead{mouse1}=[HeadToHead{mouse1};HH12]; 
                        end 
                        % 2a)- Determine events head tail events
                  
                      [Index_Begt Index_Endt]=IsHeadTail(I1,HeadTailDistance12,HeadTailDistance21,DistanceToBeTogether);
                        if ~isempty(Index_Begt)
                            HT12=[];
                            HT12=[Index_Begt Index_Endt mouse2*ones(length(Index_Begt),1)];
                            HeadToTail{mouse1}=[HeadToTail{mouse1};HT12]; 
                       end 
                        
                        
                        
                        
                  end        
             end
           end
      waitbar(mouse1/size(TrajectoryX,2));
       
     end  
         close(hbar);
 end
 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----------------------------------------Auxiliary functions--------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Convert pixel to mm 

function X=PixelsToMM(XPixel,Corn0,Corn1,max_width)
X=(XPixel-Corn0)*(max_width/(Corn1-Corn0)); 

end 
%% Calculate distance
function dist=Distancia(x1,y1,x2,y2)

dist=((x2-x1).^2+(y2-y1).^2).^0.5;
end

%%