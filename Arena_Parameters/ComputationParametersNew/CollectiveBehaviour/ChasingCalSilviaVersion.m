function [chasing_all,chased_all]=ChasingCalSilviaVersion(Locomotion,Velocity_Tresh,angle_threshold,TrajectoryThresh)
% Method according Silvia
  hbar=waitbar(0,'Calculating Chasing')
  %% Parameters and variables
      TrajectoryX=Locomotion.AssigRFID.XcoordMM;
      TrajectoryY=Locomotion.AssigRFID.YcoordMM;
      isInArena=Locomotion.AssigRFID.Arena.InArena;
      Velocity=Locomotion.AssigRFID.VelocityMouse; % this is the mod (speed) velocity
      Vectorx=Locomotion.AssigRFID.VelocityMouseX; % this is the x component of velocity
      Vectory=Locomotion.AssigRFID.VelocityMouseY; % this is the y component of velocity
      
    %
       AllEvents=[];
       Par=[];
       chasing_all=cell(1,size(TrajectoryX,2));
       chased_all=chasing_all;
       move_together_all=chasing_all;
       chasing=zeros(size(TrajectoryX,2),size(TrajectoryX,2));
       IndexChasingAll=zeros(size(TrajectoryX,1),size(TrajectoryX,2));
       %% %%%%%%%%%%%%%%% Begin Calculation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  for mouse1=1:size(TrajectoryX,2) % Loop over every mouse
     others = setdiff(1:size(TrajectoryX,2),mouse1);
     Trajectory1=[TrajectoryX(:,mouse1) TrajectoryY(:,mouse1)];
     Trajectory1(~isInArena(:,mouse1)|(TrajectoryX(:,mouse1)==1e6))=0; % if it is outside the arena and the trayectory is non-defined
     if sum(sum(Trajectory1))==0 %in the case is not in the arena
           continue;
     else     
         Velocity1=Velocity(:,mouse1); 
         Vector1=[Vectorx(:,mouse1) Vectory(:,mouse1)];
         
          for mouse2=others % loop over the other mice
            % Find both in the arena without hiding box
             Trajectory2=[TrajectoryX(:,mouse2) TrajectoryY(:,mouse2)];
             Trajectory2(~isInArena(:,mouse2)|(TrajectoryX(:,mouse2)==1e6))=0; % if it is outside the arena and the trayectory is non-defined
                 if sum(sum(Trajectory2))==0 %in the case is not in the arena
                          continue;
                 else     
                     Velocity2=Velocity(:,mouse2); 
                     Vector2=[Vectorx(:,mouse2) Vectory(:,mouse2)];
                     timeLine=Locomotion.ExperimentTime;
                     IbothArena=isInArena(:,mouse1)& isInArena(:,mouse2) ;
                     Inondefined=(TrajectoryX(:,mouse1)==1e6)|(TrajectoryX(:,mouse2)==1e6); 
                     IForDistance=IbothArena & ~Inondefined; % assure both mouse in the arena and define
                     numMice=size(TrajectoryX,2);
                     
                     [chasing12 chasing21 IndexChasing]=detectChasingSilviaVersion(Trajectory1,Trajectory2,Velocity1,Velocity2,...
                                 Vector1,Vector2,timeLine,Velocity_Tresh,IForDistance,numMice,angle_threshold,TrajectoryThresh);
                 
                         if ~isempty(chasing12)
                            IndexChasingAll(IndexChasing,mouse1)=mouse2;
                            chasing12=[chasing12 mouse2*ones(size(chasing12,1),1)];
                            chasing(mouse1,mouse2)=size(chasing12,1);
%                            AllEvents=[AllEvents;allevents];
                    
                         end 
                          
                           if ~isempty(chasing21)
                               chasing21=[chasing21 mouse1*ones(size(chasing21,1),1)];
                           end
                           
                          chasing_all{mouse1}=[chasing_all{mouse1};chasing12];
                          chased_all{mouse2}=[chased_all{mouse2};chasing21]; 
                             
                 end
           end 
      
      
     end
 
 waitbar(mouse1/size(TrajectoryX,2));
  end
    close(hbar);
    ChasingCal=[chasing_all,chased_all];
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%% Auxiliary functions %%%%%%%%%%%%%%%%%%%%%

  %% -----------------------------------Calculate auxiliary parameters for chasing----------------------------------------
   function InArenaAuxiliary=InArenaAuxiliary(obj,XMouse,YMouse)
       
       
       Distance=(sqrt(sum([diff(XMouse) diff(YMouse)].^2,2)));
       %Calculation vector for chasing
       vectorx=diff( XMouse);
       vectory=diff( YMouse);
       vectorx1=vectorx;
       vectory1=vectory;
       Inozero=vectorx~=0 & vectory~=0;
       vector=[vectorx(Inozero) vectory(Inozero)]; 
       norm_vec=sqrt(sum(vector.^2,2));
       vectorx(Inozero)=vector(:,1)./norm_vec;
       vectory(Inozero)=vector(:,2)./norm_vec;
       
       InArenaAuxiliary=[Distance vectorx vectory vectorx1 vectory1];
   end
