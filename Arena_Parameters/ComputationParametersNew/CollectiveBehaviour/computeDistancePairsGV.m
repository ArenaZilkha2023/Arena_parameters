%% To calculate distance between pair of mice-If one is in the arena/hiding or sleeping box  and vicevers  or both sleeping is NAN no information
%% Remember that in Arena is without sleeping and hiding box
%THE DISTANCES WERE CALCULATED IN MM
function DistancePairs=computeDistancePairsGV(Locomotion)
%%%%%%%%%% Get the variables %%%%%%%%%%%%%%%%
TrajectoryX=Locomotion.AssigRFID.XcoordMM;
TrajectoryY=Locomotion.AssigRFID.YcoordMM;
isInArena=Locomotion.AssigRFID.Arena.InArena;
SleepingBoxInd=Locomotion.AssigRFID.Sleeping.SleepingCage;
HidingBoxInd=Locomotion.AssigRFID.Hiding.HidingBox;
%% %%%%%%%%%%%%%%Definition%%%%%%%%%%%%%%%%%%%%%%%
% numOfMice=size(TrajectoryX,2);
numOfMice=size(Locomotion.AssigRFID.miceList,1);
dist=@(x1,x2) sqrt(sum((x1-x2).^2,2));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Loop over every mouse %%%%%%%%%%%%%%%%%%
for i=1:numOfMice
    for j=1:numOfMice
        
        clear a;
        clear b;
        clear c;
        clear d;
        clear Inondefined;
       
        DistancePairs(:,i,j)=dist([TrajectoryX(:,i) TrajectoryY(:,i)],[TrajectoryX(:,j) TrajectoryY(:,j)]);
        Ai=~isInArena(:,i);
        Aj=~isInArena(:,j);
        a=Ai&Aj;%both are not in arena/could be in the hiding box or in the sleeping box
        b=(Ai&~Aj)|(Aj&~Ai);%Ai isn't in arena and Aj is 
        Inondefined=(TrajectoryX(:,i)==1e6)|(TrajectoryX(:,j)==1e6);
        c=(SleepingBoxInd(:,i)-SleepingBoxInd(:,j)==0)& SleepingBoxInd(:,i)~=0 & SleepingBoxInd(:,j)~=0; %find are either in the same sleeping box or hiding box
        d=(HidingBoxInd(:,i)-HidingBoxInd(:,j)==0)& HidingBoxInd(:,i)~=0 & HidingBoxInd(:,j)~=0;
       
%         DistancePairs(b,i,j)=1139*sqrt(2);% one is at the arena and the other is outside
        DistancePairs(Ai|Aj,i,j)=NaN; %one is not in the arena,or both
        DistancePairs(c&a,i,j)=0; %if it is outside the arena and the same sleeping box 
        DistancePairs(d&a,i,j)=0; %if it is outside the arena and the same hiding box
    if j==i
         DistancePairs(:,i,j)=NaN; %it is the same mice
    end
        DistancePairs(Inondefined,i,j)=NaN; %for non-defined coordinates
    end
end
end
