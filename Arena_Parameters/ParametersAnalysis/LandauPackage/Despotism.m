function  Despotism1=Despotism(SocialMatrixN)

% despotism is the proportion of all wins by the dominant male over the
% total number of aggressive interactions over the observation period. It
% is a value between 0-1, with 1 indicating that the alpha male performed
% 100% of all aggression with the group.Under standard ranking
%%
Wins=sum(SocialMatrixN(1,:));
N=sum(SocialMatrixN,'all');

Despotism1=Wins/N;







end 