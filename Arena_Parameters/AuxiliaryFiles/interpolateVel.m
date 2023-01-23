function VelocityNew=interpolateVel(timeLine,Velocity,isInArena,vel)

indexMeasured=Velocity>0;
VelocityNew=Velocity;

if(sum(indexMeasured)>=2)
    VelocityNew=interp1(timeLine(indexMeasured),Velocity(indexMeasured),timeLine,'cubic');
end
VelocityNew(~isInArena)=0;
VelocityNew(vel<0.5)=0;
end