function LandauCoef=LandauCoefModified(RankingMatrix,PairNoInteractionT)
%Calculation of landau  modified coefficient/ do randomization on non
%interaction points


N=size(RankingMatrix,1);

LandauCoef=(12/(N^3-N))*sum((sum(RankingMatrix,2,'omitnan')-(N-1)/2).^2);


end

