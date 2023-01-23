function DCIndexAllEvents=DCIndex(SocialMatrixN)

%% Calculation of directional consistency index - Leiva David et al. Behaviour Research Methods 2008, 40,626-634
% The DC is obtained by dividing the number of total interactions in the
% most frequent direction minus the number of interactions in the less
% frequent direction by the total of interactions performed by all the
% individuals in the group. H-L/(H+L)
%The index ranges from 0 to 1.
% if DC takes a value close to 0 social reciprocity is near its maximum. If
% DC is 1 the dyadic interactions are unidirectionsal and reciprocity is
% near the minumum value.

%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%Calculation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%initialization
Differences=0;
for mouse1=1:size(SocialMatrixN,1) %go over the mice
   for  mouse2=(mouse1+1):size(SocialMatrixN,2)
    Differences=Differences+abs(SocialMatrixN(mouse1,mouse2)-SocialMatrixN(mouse2,mouse1));
   end 
end
N=sum(sum(SocialMatrixN,2)); %Number of total interactions

DCIndexAllEvents=Differences/N;



end