function TrajectoryNew=trajRescaleGV(Trajectory,maxM,minM,Params)
maxT=Params.ArenaLength; %cm
minT=0;
%Consider that the original data is negative
%Scaling to 0 114
TrajectoryNew=(Trajectory-minM)/(maxM-minM);
TrajectoryNew=TrajectoryNew*(maxT-minT)+minT;
end