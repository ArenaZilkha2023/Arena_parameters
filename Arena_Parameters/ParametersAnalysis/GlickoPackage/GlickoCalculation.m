function [Rglicko, RDglicko]=GlickoCalculation(SubsetData,MouseID,Cconstant,InitialRating,InitialRatingDesviation,...
                          IndexChasing,IndexBeingChasing,IndexEvents)
                      
%% Variable definition
clear Rglicko;
clear RDglicko;

%% Glicko calculation- Calculate rating,R and also rating desviation RD

 for event=1:size(SubsetData,1)  %Loop over each event
       for mouse=1:length(MouseID) %define for each mouse which glicko begins
                 if event>1
                     Rglicko(mouse,event)=Rglicko(mouse,event-1);
                     RDglicko(mouse,event)=min(sqrt((RDglicko(mouse,event-1))^2+Cconstant^2),350);
                     
                 else
                     Rglicko(mouse,event)=InitialRating; 
                     RDglicko(mouse,event)=InitialRatingDesviation;
                 end
       end                   
                      
  %% Define which number of mouse is doing and being chasing

if strcmp(strrep( SubsetData(event,IndexEvents),'''',''),'Y')==1
   doing=find(strcmp(strrep(SubsetData(event,IndexChasing),'''',''),MouseID)==1);
   being=find(strcmp(strrep(SubsetData(event,IndexBeingChasing),'''',''),MouseID)==1);
   
else%in the case the event was detected as reverse
   doing=find(strcmp(strrep(SubsetData(event,IndexBeingChasing),'''',''),MouseID)==1);
   being=find(strcmp(strrep(SubsetData(event,IndexChasing),'''',''),MouseID)==1);
   
end                    

%% Actualization of rating and RD for the competitors
 [Rglicko(doing,event), RDglicko(doing,event)]=GlickoFormulas(Rglicko(doing,event),RDglicko(doing,event),Rglicko(being,event),RDglicko(being,event),1);   % the player is the doing and the opponent the being                 
 [Rglicko(being,event), RDglicko(being,event)]=GlickoFormulas(Rglicko(being,event),RDglicko(being,event),Rglicko(doing,event),RDglicko(doing,event),0);   % the player is the being and the opponent the doing                  
                                                             
  end
end