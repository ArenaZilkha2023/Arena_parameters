function [RankingMatrix PairNoInteractionT]=RankingMatrixSocial(SocialMatrix)
%look for each pair see who gain
%%variables
PairNoInteractionT=[];
%% 

t=0;
RankingMatrix=NaN*zeros(size(SocialMatrix));
for i=1:size(SocialMatrix,1)
    for j=1:size(SocialMatrix,1)
        if i~=j
     if SocialMatrix(i,j)> SocialMatrix(j,i)
     RankingMatrix(i,j)=1;
     RankingMatrix(j,i)=0;
     elseif SocialMatrix(i,j)== SocialMatrix(j,i)
     RankingMatrix(i,j)=0.5;
     RankingMatrix(j,i)=0.5;
     elseif SocialMatrix(i,j)< SocialMatrix(j,i) 
     RankingMatrix(i,j)=0;
     RankingMatrix(j,i)=1;
   
     
     end
       if SocialMatrix(i,j)==0 & SocialMatrix(j,i)==0  %in the case of non interactions
         RankingMatrix(i,j)=0;
         RankingMatrix(j,i)=0;
         t=t+1;
         if t==1
         %save the pair for future randomization
         PairNoInteraction=[i,j]
         else
              PairNoInteraction=[i,j]
               PairNoInteractionT=[PairNoInteractionT; PairNoInteraction]
         end
         
       end
        end
    end

end

end