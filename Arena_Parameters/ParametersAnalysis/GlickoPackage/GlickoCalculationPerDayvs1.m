function   [Rglicko, RDglicko]=GlickoCalculationPerDay(RankingMatrix,MouseID,Cconstant,InitialRating,InitialRatingDesviation)

% Given the initial standard desviation calculate g
Rglicko=[];
RDglicko=[];
q=0.0057565

g=(1+3*q^2*(InitialRatingDesviation.*InitialRatingDesviation)/pi^2).^-0.5; %for each mice

for mouse=1:size(MouseID,1)
  
    Aux1=[];
    Aux2=[];
    E1=[];
    E2=[];
    
    restMouse=setdiff([1:size(MouseID,1)],mouse,'stable');
    Aux1=-g(restMouse).*(InitialRating(mouse)-InitialRating(restMouse))/400;
    E1=(1+10.^Aux1).^-1
    E2=1-E1;
    Aux2=(g(restMouse).^2).*E1.*E2;
    dSquare=(q^2*sum(Aux2))^-1;
    
    % final results
    RDglicko(mouse,1)=((InitialRatingDesviation(mouse)^-2 +dSquare^-1)^-1)^0.5;
    
    % calculate new rating by considering the other mice
    value=0;
    for count=1:size(restMouse,2)
        
    value=value+g(restMouse(count))*(RankingMatrix(mouse,restMouse(count))-E1(count))   
    end
    Rglicko(mouse,1)=InitialRating(mouse)+(q/(InitialRatingDesviation(mouse)^-2 +dSquare^-1))*value;
    
    
end








end