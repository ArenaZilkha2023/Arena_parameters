function [RatingPlayer,RDPlayer]=GlickoFormulas(RglickoPlayer,RDglickoPlayer,RglickoOpponent,RDglickoOpponent,OutcomePlayer)

q=log(10)/400; %log is ln 
gPlayer=1/sqrt(1+(3*(q^2)*(RDglickoPlayer^2)/(pi^2)));
gOpponent=1/sqrt(1+(3*(q^2)*(RDglickoOpponent^2)/(pi^2)));

EPlayer=1/(1+10^(-gOpponent*(RglickoPlayer-RglickoOpponent)/400));

dPlayerSquare=(q^2*((gOpponent)^2*EPlayer*(1-EPlayer)))^-1;

RatingPlayer=RglickoPlayer+(q/((1/RDglickoPlayer^2)+(1/dPlayerSquare)))*gOpponent*(OutcomePlayer-EPlayer);
RDPlayer=sqrt(((1/RDglickoPlayer^2)+(1/dPlayerSquare))^-1)

end 