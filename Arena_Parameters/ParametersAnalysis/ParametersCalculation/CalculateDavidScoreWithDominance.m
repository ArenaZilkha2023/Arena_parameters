function [DSAll NormDSAll]=CalculateDavidScoreWithDominance(InteractionMatrix)

%--------------------Calculate David Score of all the exp----------
%-------------------Based on the paper Animal behaviour 2006,71,585-592
%---This calculation  considered the number of interactions.
%% ----------Variables-------------
IntMatrixTotal=[];
DSAll=[];
NDS=[];
Ninteraction=zeros(size(IntMatrixTotal));
% InteractionMatrix=[0 1 1 1 1;0 0 1 1 1;0 0 0 1 1; 0 0 0 0 1]
%% 
 IntMatrixTotal=sum(InteractionMatrix,3);
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


%% -----------Auxiliary parameters to calculate dominance matrix
Partial1=zeros(size(IntMatrixTotal,1),size(IntMatrixTotal,2));
Partial1(find(Ninteraction>0))=P(find(Ninteraction>0))-0.5;

Partial2=zeros(size(IntMatrixTotal,1),size(IntMatrixTotal,2));
AuxOnes=ones(size(IntMatrixTotal,1),size(IntMatrixTotal,2));
Partial2(find(Ninteraction>0))=AuxOnes(find(Ninteraction>0))./(Ninteraction(find(Ninteraction>0))+1);



%% 

D=zeros(size(IntMatrixTotal,1),size(IntMatrixTotal,2));
D=P-Partial1.*Partial2;


%%-----------------Find the sum of D for each mouse-------------------- 
W=sum(D,2);
W2=D*W;
losses=1-D;
 %% --------Eliminate the diagonal
for i=1:size(losses,1)
losses(i,i)=0;
end
%% 

l=sum(losses,2);
l2=losses*l;

DSAll=W+W2-l-l2;
%% Normalization
 N=size(IntMatrixTotal,1);
  NormDSAll=(DSAll+N*(N-1)/2)/N;








end