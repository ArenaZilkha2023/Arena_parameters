function   Entropy=ManagerEntropy(Eating,Drinking,Hiding,LargeBridge,NarowBridge,NumberOfEvents)

 % entropy                       
 % This function calculates the Entropy for each mouse-
 %The probabily the events /number of events 
 
 P(:,1)=Eating/NumberOfEvents; %probability
 P(:,2)=Drinking/NumberOfEvents;
 P(:,3)=Hiding/NumberOfEvents;
 P(:,4)=LargeBridge/NumberOfEvents;
 P(:,5)=NarowBridge/NumberOfEvents;
 
 % Entropy calculation
 NumberRegions=3;
 
for i=1:NumberRegions 
       S(:,i)=-P(:,i).*log2(P(:,i));
end
                         
                         
  Entropy=sum(S,2,'omitnan');        % the units are  in bits               
                    
end
