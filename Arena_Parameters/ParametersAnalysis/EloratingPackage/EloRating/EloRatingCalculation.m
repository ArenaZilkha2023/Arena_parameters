function eloe  = EloRatingCalculation( SubsetData,MouseID,k,initial_rating,IndexChasing,IndexBeingChasing,IndexEvents )
%% Variable definition
clear eloe;
clear eloee;
%% 

%UNTITLED Summary of this function goes here
%   Elo rating calculation
%% ELORATING CALCULATION-Take from old program

for event=1:size(SubsetData,1)
for mouse=1:length(MouseID) %define from which elorating begins
if event>1
    eloe(mouse,event)=eloe(mouse,event-1);
else
    eloe(mouse,event)=initial_rating; %at the beggining the elo rating is 1000
    
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
%% Definition of p, which is the expectation of winning for the higher rated individual which is a function of the absolute difference in the rating of the two interaction
% patterns before the interaction-see wikipedia definition
if abs(eloe(doing,event)-eloe(being,event))>800
    p=1;
else
    p=1-1/(1+10^(abs(eloe(doing,event)-eloe(being,event))/400));
end
%% Check eloe according who is the winner and the looser/There are winner or looser in chasing

if eloe(doing,event)>=eloe(being,event) %the higher rated mouse wins
eloe(doing,event)=eloe(doing,event)+(1-p)*k; %eloe of the winner
eloe(being,event)=eloe(being,event)-(1-p)*k; %eloe rating of the loser
else %lower rated individual wins against expectation
eloe(doing,event)=eloe(doing,event)+p*k; %eloe of the winner
eloe(being,event)=eloe(being,event)-p*k; %eloe rating of the loser
end


end
%% adding a'zeroth event' with 1000s for each mouse
eloee=zeros(length(MouseID),size(SubsetData,1)+1)+initial_rating;
 for event=1:size(SubsetData,1)
     eloee(:,event+1)=eloe(:,event);
 end
 eloe=eloee;

 
     
     
 end





