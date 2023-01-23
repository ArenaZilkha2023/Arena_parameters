function [TrajectoryX TrajectoryY SleepingInd]=detectSleeping(TrajectoryX,TrajectoryY,M,CoordSleepingCells,Params)
%review
maxT=Params.ArenaLength; %cm
minT=0;

minMx=M(2);maxMx=M(1);
minMy=M(4);maxMy=M(3);

SleepingInd=TrajectoryX> Params.ThresholdDistance&TrajectoryY> Params.ThresholdDistance; % Params.ThresholdDistance default is 1.5e4
TrajectoryX(SleepingInd)=TrajectoryX(SleepingInd)-2e4;%Why!!!
TrajectoryY(SleepingInd)=TrajectoryY(SleepingInd)-2e4;
%% 

if isnan(TrajectoryX(1)) %only in the case the first value is nan non detected
    k=find(~isnan(TrajectoryX)==1,1,'first');
    if ~isempty(k)
        cords=[TrajectoryX(k) TrajectoryY(k)];
        cords(1)=(cords(1)-minMx)/(maxMx-minMx);
        cords(2)=(cords(2)-minMy)/(maxMy-minMy);
        cords=cords*(maxT-minT)+minT;
        DistSleep=dist_calc(CoordSleepingCells,repmat(cords,length(CoordSleepingCells),1));
        i=find(DistSleep<= Params.ThresholdDistance); %Params.ThresholdDistance default is 10
        if ~isempty(i)
            TrajectoryX(1:k)=CoordSleepingCells(i(1),1);
            TrajectoryY(1:k)=CoordSleepingCells(i(1),2);
            SleepingInd(1:k)=true;
        end
    end
end
%% 

n=length(TrajectoryX);

[EventsBeg EventsEnd]=getEventsIndexesGV(isnan(TrajectoryX),n);
I=find((EventsEnd-EventsBeg)>60*30);

for i=1:length(I)
    if EventsBeg(I(i))-1==0&&EventsEnd(I(i))+1<n
        C(1)=TrajectoryX(EventsEnd(I(i))+1);
        C(2)=TrajectoryY(EventsEnd(I(i))+1);
    elseif EventsBeg(I(i))-1==0&&EventsEnd(I(i))+1>n
        C(1)=CoordSleepingCells(1,1);
        C(2)=CoordSleepingCells(1,2);
    else
        C(1)=TrajectoryX(EventsBeg(I(i))-1);
        C(2)=TrajectoryY(EventsBeg(I(i))-1);
    end
    
    TrajectoryX(EventsBeg(I(i)):EventsEnd(I(i)))=C(1);
    TrajectoryY(EventsBeg(I(i)):EventsEnd(I(i)))=C(2);
    SleepingInd(EventsBeg(I(i)):EventsEnd(I(i)))=true;
end
end