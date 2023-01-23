function Velocity = VelocityCalculation( x,y ,NumbFrames)
%This function calculate velocity
%% VELOCITY CALCULATION-THIS IS A RAW CALCULATION WITH ORIGINAL NUM DATA-The velocity is in cm/sec
%% variable
global Params
TimePerFrame=round((1/Params.FPS)*1000); %33ms

%% 

%find numbers larger than 15000 antenna and substract them
 IndAntenna=find(x>1.5e4 & y>1.5e4);
 x(IndAntenna,1)= x(IndAntenna,1)-2e4;
 y(IndAntenna,1)= y(IndAntenna,1)-2e4;
  
 DeltaX=diff(x);
 DeltaY=diff(y);

DeltaFrames=diff(NumbFrames); %each frame is 30ms
Velocity=(sqrt(DeltaX.^2+DeltaY.^2)./(TimePerFrame*DeltaFrames))*100;
Velocity(2:length(Velocity)+1)=Velocity;

end

