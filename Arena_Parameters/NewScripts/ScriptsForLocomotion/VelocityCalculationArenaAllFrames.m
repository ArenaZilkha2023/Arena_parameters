function Velocity = VelocityCalculationArenaAllFrames( x,y,Evb,Eve)
%This function calculate velocity
%% VELOCITY CALCULATION-THIS IS A RAW CALCULATION WITH ORIGINAL NUM DATA-The velocity is in cm/sec
%% variable
global Params
Velocity=[];
TimePerFrame=round((1/Params.FPS)*1000); %time per frame 33ms
for i=1:length(Evb)
%%Clear variables-
clear VelocityAux
clear DeltaX
clear DeltaY

%% 
if i==length(Evb) %arrangement for certain files
    Eve(i)=Eve(i)-1;
end

 DeltaX=diff(x(Evb(i):Eve(i)));
 DeltaY=diff(y(Evb(i):Eve(i)));

VelocityAux=(sqrt(DeltaX.^2+DeltaY.^2)./(TimePerFrame))*100
[a,b]=size(VelocityAux)
length([Evb(i)+1:Evb(i)+a]);
Velocity(Evb(i)+1:Evb(i)+a)=VelocityAux;

end
end

