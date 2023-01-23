function LandauCoef=LandauCoef(RankingMatrix)
%Calculation of landau coefficient

N=size(RankingMatrix,1);

LandauCoef=(12/(N^3-N))*sum((sum(RankingMatrix,2,'omitnan')-(N-1)/2).^2);


end

