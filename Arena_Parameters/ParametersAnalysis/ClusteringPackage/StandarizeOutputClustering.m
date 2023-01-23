function ExpTableStandarize=StandarizeOutputClustering(A)
%Standarize all the data from different parameters to be able to compare
%% ------------A is an array in which the columns are variables/parameters and the rows are the observations---------

AMean=mean(A)
%AStd = std(A)./sqrt(size(A,1));
AStd = std(A);

%%
 n=size(A,1);
 ExpTableStandarize = (A - repmat(AMean,[n 1])) ./ repmat(AStd,[n 1])


end

