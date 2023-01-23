function [Approaching1To2  BeAvoiding1To2] =IsApproaching(mouse2,BeginApproaching,EndApproaching,v1,v2,Distance,angle1,angle2,Approaching_Angle,Aproaching_velocity,Stay_Velocity,FoodCoordinates,XMM,YMM,mouse1)
% Loop over each event- check the point are separated
BeginA=[];
FinishA=[];
Approaching1To2=[];
 BeAvoiding1To2=[];
Approaching1To2Aux=[];
UniqueValues=[];
count1=1;
count2=1;
 for count=1:length(BeginApproaching)
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % Before everything we tested that the event aren't in the eating food
     % otherwise the event isn't consider
       xf=[FoodCoordinates(:,1);FoodCoordinates(1,1)]; % Create polygon around the eat place
       yf=[FoodCoordinates(:,2);FoodCoordinates(1,2)]; % Create polygon around the eat place
        [inF1,onF1] = inpolygon(XMM(BeginApproaching:EndApproaching,mouse1),YMM(BeginApproaching:EndApproaching,mouse1),xf,yf);
        [inF2,onF2] = inpolygon(XMM(BeginApproaching:EndApproaching,mouse2),YMM(BeginApproaching:EndApproaching,mouse2),xf,yf);
        
        if or(~isempty(find(inF1==1)),~isempty(find(inF2==1))) %if the mice coordinates are inside the food stand
            break;%terminates the execution of the for loop and continue with other event
        end
        
        
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     if or(BeginApproaching>1,(EndApproaching-BeginApproaching)>5) %larger than 5 frames
         %find the point are separated
         
         Index1=find(Distance(1:BeginApproaching(count))>=200,1,'last')% Find when the mice are seperated in the back direction
      
           count
       if  BeginApproaching(count)<= size(angle1,1)   %In the case of the end
         angleDirection=median(cell2mat(angle1(Index1:BeginApproaching(count))),'omitnan');
         velocity1=median(v1(Index1:BeginApproaching(count)),'omitnan');
         velocity2=median(v2(Index1:BeginApproaching(count)),'omitnan');
       else
            angleDirection=median(cell2mat(angle1(Index1:size(angle1,1))),'omitnan');
            velocity1=median(v1(Index1:size(angle1,1)),'omitnan');
            velocity2=median(v2(Index1:size(angle1,1)),'omitnan');
       end
         
          Index2partial=find(Distance(EndApproaching(count):end)>=200,1,'first'); % Find when the mice are separated in the forward direction
          Index2=Index2partial+EndApproaching(count)-1
          if Index2>size(angle1,1)
              Index2=size(angle1,1)
          end
          
          angleDirectionf=median(cell2mat(angle1(EndApproaching(count):Index2)),'omitnan');
          velocity1f=median(v1(EndApproaching(count):Index2),'omitnan');
          velocity2f=median(v2(EndApproaching(count):Index2),'omitnan');
         
         
         if  (angleDirection<=Approaching_Angle)&(velocity1>Aproaching_velocity)&(velocity2<=Stay_Velocity)
             
              flag=true;
                BeginA=Index1;
                FinishA=EndApproaching(count);
                
                %% ---------------------Decide if the event is approaching or be avoiding-----------------------
                
                         if (angleDirectionf>50)& (velocity2f>Aproaching_velocity) % If there is a drastic separation, as velocity2 increases
                             BeAvoiding1To2(count2,:)=[BeginA,Index2,mouse2];
                             count2=count2+1;
                         else
                            Approaching1To2(count1,:)=[BeginA,FinishA,mouse2];
                            count1=count1+1;
                        end
             
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
 %% Join events with the same beggining
 
if ~isempty(BeAvoiding1To2)
 [~,iAvoiding,~]=unique(BeAvoiding1To2(:,1),'stable'); %IN THE FUTURE TOOK THE LARGEST INTERVAL
 BeAvoiding1To2=BeAvoiding1To2(iAvoiding,:);
end
if ~isempty(Approaching1To2)
 [~,iApproaching,~]=unique(Approaching1To2(:,1),'stable');
  Approaching1To2=Approaching1To2(iApproaching,:);
end
 

 
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