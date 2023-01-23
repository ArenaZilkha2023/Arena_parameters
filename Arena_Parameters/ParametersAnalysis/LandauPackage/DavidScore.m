function  [Steepness,NormDS,NormDSWithoutSorting]=DavidScore(MatrixS)

%% Create Win proportion matrix-Remember winners on the rows

Pw=zeros(size(MatrixS,1),size(MatrixS,2));%matrix proportions wins
Pl=zeros(size(MatrixS,1),size(MatrixS,2));%matrix proportions lost
for row=1:size(MatrixS,1)
   for col=[1:size(MatrixS,2)]
       if col~=row
         n=MatrixS(row,col)+MatrixS(col,row);
         if n~=0
            Pw(row,col)=MatrixS(row,col)/n;
            Pl(row,col)=1-Pw(row,col);
         else
             Pw(row,col)=0;
             Pl(row,col)=0;
         end
       end
   end
end
%% Calculate the sum the winner/losses proportions for each winner
w=sum(Pw,2); %sum over the columns
l=sum(Pl,2);

Auxw=Pw.*repmat(w',size(MatrixS,1),1);
Auxl=Pl.*repmat(l',size(MatrixS,1),1);

w2=sum(Auxw,2);
l2=sum(Auxl,2);
%% DS David Score for each mice

DS=w+w2-l-l2;

%% Normalized david score
N=size(MatrixS,2);
NormDS=(DS+N*(N-1)/2)/N;
NormDSWithoutSorting=NormDS;

%% Sort davies score from higher to lower value

DS=sort(DS,'descend');
NormDS=sort(NormDS,'descend');

%% Get steepness measurement
x=[1:size(MatrixS,2)];
p=polyfit(x',NormDS,1); %linear fit
Steepness=abs(p(1)); %slope of the fitting.

%% Add to excel







end