function   [DSAll NormDSAll]=CalculateDavidScore(InteractionMatrix,item_ScoreDay,LastDay)
%--------------------Calculate David Score of all the exp----------
%-------------------Based on the paper Animal behaviour 2006,71,585-592
%---This calculation didn't consider the number of interactions.
%% ----------Variables-------------
IntMatrixTotal=[];
DSAll=[];
NDS=[];
Ninteraction=zeros(size(IntMatrixTotal));
% InteractionMatrix=[0 1 1 1 1;0 0 1 1 1;0 0 0 1 1; 0 0 0 0 1]
%% 
 IntMatrixTotal=sum(InteractionMatrix(:,:,str2num(char(item_ScoreDay)):LastDay),3);
% IntMatrixTotal=[0 1 1 1 1;0 0 1 1 1;0 0 0 1 1; 0 0 0 0 1;0 0 0 0 0]

% %% --------Eliminate the diagonal
% for i=1:size(InteractionMatrix,1)
% IntMatrixTotal(i,i)=NaN;
% end
%% --------------Create matrix with number of interactions----------------
for t=1:size(InteractionMatrix,1) %go throug the diagonal
 
 Ninteraction(:,:,t)= diag( diag(IntMatrixTotal,t) +  diag(IntMatrixTotal,-t),t)+  diag( diag(IntMatrixTotal,t) +  diag(IntMatrixTotal,-t),-t); 


end
Ninteraction=sum(Ninteraction,3);

% %% --------Eliminate the diagonal
% for i=1:size(Ninteraction,1)
% Ninteraction(i,i)=NaN;
% end

%% ------------Create the P matrix----------
P=zeros(size(IntMatrixTotal,1),size(IntMatrixTotal,2));
P(find(Ninteraction>0))=IntMatrixTotal(find(Ninteraction>0))./Ninteraction(find(Ninteraction>0));

%%-----------------Find the sum of P for each mouse-------------------- 
W=sum(P,2);
W2=P*W;
losses=1-P;
 %% --------Eliminate the diagonal
for i=1:size(losses,1)
losses(i,i)=0;
end
%% 

l=sum(losses,2);
l2=losses*l;

DSAll=W+W2-l-l2
%% Normalization
 N=size(IntMatrixTotal,1);
  NormDSAll=(DSAll+N*(N-1)/2)/N;

end

