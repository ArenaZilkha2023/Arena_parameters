function Approaching1To2=IsApproaching(mouse2,BeginApproaching,EndApproaching,v1,v2,Distance,angle1,angle2,Approaching_Angle,Aproaching_velocity,Stay_Velocity)
% Loop over each event- check the point are separated
BeginA=[];
FinishA=[];
Approaching1To2=[];
Approaching1To2Aux=[];
UniqueValues=[];
count1=1;
 for count=1:length(BeginApproaching)
     
     if or(BeginApproaching>1,(EndApproaching-BeginApproaching)>5) %larger than 5 frames
         %find the point are separated
         
         Index1=find(Distance(1:BeginApproaching(count))>=200,1,'last');% Find when the mice are seperated in the back direction
         
         angleDirection=median(cell2mat(angle1(Index1:BeginApproaching(count))));
         velocity1=median(v1(Index1:BeginApproaching(count)));
         velocity2=median(v2(Index1:BeginApproaching(count)));
         
         if  (angleDirection<Approaching_Angle)&(velocity1>Aproaching_velocity)&(velocity2<Stay_Velocity)
             
              flag=true;
                BeginA=Index1;
                FinishA=EndApproaching(count);
                Approaching1To2(count1,:)=[BeginA,FinishA,mouse2];
                count1=count1+1;
             
             
         end
         
         
         
%         if (cell2mat(angle1(Index1))< Approaching_Angle)&(cell2mat(angle2(Index1))< 90)  %mouse1 points to mouse2
%             if (v1(Index1)>Aproaching_velocity)&(v2(Index1)<Stay_Velocity)
%                 flag=true;
%                 BeginA=Index1;
%                 FinishA=EndApproaching(count);
%                 Approaching1To2Aux(count1,:)=[BeginA,FinishA,mouse2];
%                 count1=count1+1;
%             
%             end
%      
%      
%      
%         end
     
        
        
     end




 end
%  
%  %% Join events with the same beggining
%  if ~isempty(Approaching1To2Aux)
%  countn=1;
%  [UniqueValues,~]=unique(Approaching1To2Aux(:,1),'stable')
%  for countUnique=1:length(UniqueValues)
%    Index=find(Approaching1To2Aux(:,1)==UniqueValues(countUnique));  
%    Approaching1To2(countn,:)=[UniqueValues(countUnique),max(Approaching1To2Aux(Index,2)),mouse2];
%     
%   countn=countn+1;   
%  end
% 
%  end
end