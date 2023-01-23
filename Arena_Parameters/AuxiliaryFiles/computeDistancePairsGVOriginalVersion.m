function DistancePairs=computeDistancePairsGV(TrajectoryX,TrajectoryY,isInArena,SleepingBoxInd)

numOfMice=size(TrajectoryX,2);
dist=@(x1,x2) sqrt(sum((x1-x2).^2,2));

for i=1:numOfMice
    for j=1:numOfMice
        DistancePairs(:,i,j)=dist([TrajectoryX(:,i) TrajectoryY(:,i)],[TrajectoryX(:,j) TrajectoryY(:,j)]);
        Ai=~isInArena(:,i);
        Aj=~isInArena(:,j);
        a=Ai&Aj;%both are not in arena
        b=(Ai&~Aj)|(Aj&~Ai);%Ai in arena and Aj is not 
        c=SleepingBoxInd(:,i)-SleepingBoxInd(:,j)==0;
       
        DistancePairs(b,i,j)=1139*sqrt(2);% one is at the arena and the other is outside
        DistancePairs(Ai|Aj,i,j)=NaN;
        DistancePairs(c&a,i,j)=0; %if it is outside the arena and the same sleeping box 
    end
end
end