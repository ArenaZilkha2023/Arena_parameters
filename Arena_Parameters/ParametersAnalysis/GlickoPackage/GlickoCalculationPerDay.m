function   [Rglicko, RDglicko]=GlickoCalculationPerDay(SocialMatrixN,MouseID,InitialRating,InitialRatingDesviation)

% Given the initial standard desviation calculate g
Rglicko=InitialRating;
RDglicko=InitialRatingDesviation;
q=0.0057565

% go through each mouse and each competent

for mouse=1:size(MouseID,1)
  % initialization
  dSquareAux=0;
  rAux=0;
   %% look for the other possible mice
   restMouse=setdiff([1:size(MouseID,1)],mouse,'stable');
   for count=1:length(restMouse) % go over the other mice
   %% check that actually is a competitor
     if or(SocialMatrixN(mouse,restMouse(count))~=0,SocialMatrixN(restMouse(count),mouse)~=0) %the idea is to accept mice which interact with the given mouse
          % Calculation
          g=(1+3*q^2*(InitialRatingDesviation(restMouse(count))*InitialRatingDesviation(restMouse(count)))/pi^2).^-0.5; 
          Aux1=-g*(InitialRating(mouse)-InitialRating(restMouse(count)))/400;
          E1=(1+10^Aux1)^-1
          E2=1-E1;
          Aux2=(g^2)*E1*E2;
         dSquareAux=dSquareAux+(q^2*Aux2);
         
         %% Decide about the outcome
         if SocialMatrixN(mouse,restMouse(count))> SocialMatrixN(restMouse(count),mouse) %gain
             score=1;
         elseif SocialMatrixN(mouse,restMouse(count))== SocialMatrixN(restMouse(count),mouse) %draw
             score=0.5;
         else %loss
             score=0
         end
         
         rAux=rAux+g*(score-E1);
         
         
         
     end
   end 
   if dSquareAux~=0 % only change rating for the mouse who has interacted   
        dSquare=(dSquareAux^-1); 
        Rglicko(mouse,1)=InitialRating(mouse)+(q/(InitialRatingDesviation(mouse)^-2 +dSquare^-1))*rAux;
        RDglicko(mouse,1)=((InitialRatingDesviation(mouse)^-2 +dSquare^-1)^-1)^0.5;
         
   end


end





end