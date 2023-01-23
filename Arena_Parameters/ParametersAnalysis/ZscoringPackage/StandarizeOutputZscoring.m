function ExpTableStandarize=StandarizeOutputZscoring(A)
%Standarize all the data from different parameters to be able to compare
%% ------------A is an array in which the columns are variables/parameters and the columns are observations---------

AMean=mean(A);
%AStd = std(A);
AStd = std(A)./sqrt(size(A,1));
%%
 n=size(A,1);
 ExpTableStandarize = (A - repmat(AMean,[n 1])) ./ repmat(AStd,[n 1]);


end

