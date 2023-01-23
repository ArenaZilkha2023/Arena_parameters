function [newX,newY]=FillWithRepeats(NumbFrames,x,y)
for i=1:length(x)-1

      if isnan(x(i))==0 
      newX(NumbFrames(i):NumbFrames(i+1)-1,1)=x(i);
       newY(NumbFrames(i):NumbFrames(i+1)-1,1)=y(i);
      end
    
end


end

